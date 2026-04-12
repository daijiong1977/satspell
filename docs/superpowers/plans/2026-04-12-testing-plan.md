# Testing Plan — SAT Vocab V1

> **For agentic workers:** Run tests after each implementation task. Tests MUST pass before committing. Failed tests block progress until fixed.

**Goal:** Automated test suite that catches data layer bugs, scoring errors, and state management issues before they become UI bugs. The last build had extensive manual debugging — this plan prevents that.

**Principle:** Test the things that are hardest to debug manually. Data layer logic (box progression, Day 1 promotion, review queue priority) is invisible in the UI — if it's wrong, you won't notice until a student's progress is corrupted. Test that first and most thoroughly.

**Framework:** XCTest (built into Xcode, no external dependencies)

---

## Test Architecture

```
ios/SATVocabApp/
├── Sources/SATVocabApp/         ← Production code
└── Tests/SATVocabAppTests/      ← Test code
    ├── Data/
    │   ├── SchemaTests.swift           ← Schema creation + migration
    │   ├── ContentImporterTests.swift  ← JSON import validation
    │   ├── WordStateStoreTests.swift   ← Box progression, review queue, promotion
    │   ├── SessionStateStoreTests.swift ← Day state, pause/resume, session lifecycle
    │   ├── StatsStoreTests.swift       ← XP, streaks, milestones
    │   ├── ZoneStoreTests.swift        ← Zone unlock, test tracking
    │   └── ReviewLoggerTests.swift     ← Logging, supersede
    ├── ViewModels/
    │   ├── SessionFlowViewModelTests.swift  ← Step transitions, scoring, Show Again
    │   ├── PracticeStateResolverTests.swift ← All 5 practice tab states
    │   └── EveningUnlockTests.swift    ← Timing matrix validation
    └── Helpers/
        └── TestDatabase.swift          ← In-memory SQLite for fast tests
```

---

## Shared Test Helper: In-Memory SQLite

Every test uses an **in-memory database** — no file I/O, instant setup/teardown, no test pollution.

```swift
// Tests/SATVocabAppTests/Helpers/TestDatabase.swift
import Foundation
@testable import SATVocabApp

/// Creates a fresh in-memory SQLite database with full schema for each test.
/// Usage: let db = try TestDatabase.create()
enum TestDatabase {
    
    /// Create in-memory DB with schema + optional test words
    static func create(withWords: Bool = false) throws -> SQLiteDB {
        let db = SQLiteDB()
        try db.open(path: ":memory:")
        try SchemaV2.createAll(db: db)
        
        if withWords {
            try insertTestWords(db: db)
        }
        return db
    }
    
    /// Insert a minimal set of test words (10 words for fast tests)
    static func insertTestWords(db: SQLiteDB, count: Int = 10) throws {
        try db.exec("INSERT INTO lists (name, description, version) VALUES ('test_list', 'Test', 1);")
        
        for i in 1...count {
            try db.exec("""
            INSERT INTO words (lemma, pos, definition, example, image_filename)
            VALUES ('word\(i)', 'adj.', 'definition \(i)', 'example sentence \(i)', 'word\(i).jpg');
            """)
            try db.exec("INSERT INTO word_list (word_id, list_id, rank) VALUES (\(i), 1, \(i));")
            
            // Add 2 SAT contexts per word
            try db.exec("INSERT INTO sat_contexts (word_id, context) VALUES (\(i), 'context A for word\(i)');")
            try db.exec("INSERT INTO sat_contexts (word_id, context) VALUES (\(i), 'context B for word\(i)');")
            
            // Add 1 collocation per word
            try db.exec("INSERT INTO collocations (word_id, phrase) VALUES (\(i), 'word\(i) phrase');")
        }
    }
    
    /// Create a test user and return userId
    static func createTestUser(db: SQLiteDB, name: String = "test_user") throws -> String {
        let userId = "test-\(UUID().uuidString.prefix(8))"
        try db.exec("INSERT INTO users (id, display_name) VALUES ('\(userId)', '\(name)');")
        try db.exec("INSERT INTO streak_store (user_id) VALUES ('\(userId)');")
        try db.exec("INSERT INTO zone_state (user_id, zone_index, unlocked) VALUES ('\(userId)', 0, 1);")
        try db.exec("INSERT INTO day_state (user_id, study_day, zone_index) VALUES ('\(userId)', 0, 0);")
        return userId
    }
}
```

---

## Plan 1 Tests: Data Layer

### Test 1.1: Schema Creation

```swift
// Tests/SATVocabAppTests/Data/SchemaTests.swift
import XCTest
@testable import SATVocabApp

final class SchemaTests: XCTestCase {
    
    func testSchemaCreatesAllTables() throws {
        let db = try TestDatabase.create()
        
        let expectedTables = [
            "lists", "words", "word_list", "sat_contexts", "collocations",
            "sat_question_bank", "word_questions", "deepseek_sat_feedback",
            "users", "word_state", "day_state", "session_state",
            "review_log", "session", "daily_stats", "streak_store", "zone_state"
        ]
        
        for table in expectedTables {
            let stmt = try db.prepare("SELECT name FROM sqlite_master WHERE type='table' AND name=?")
            defer { stmt?.finalize() }
            try SQLiteDB.bind(stmt, 1, table)
            XCTAssertEqual(sqlite3_step(stmt), SQLITE_ROW, "Table '\(table)' should exist")
        }
    }
    
    func testSchemaIsIdempotent() throws {
        let db = try TestDatabase.create()
        // Running createAll twice should not fail
        XCTAssertNoThrow(try SchemaV2.createAll(db: db))
    }
    
    func testForeignKeysEnabled() throws {
        let db = try TestDatabase.create()
        let stmt = try db.prepare("PRAGMA foreign_keys;")
        defer { stmt?.finalize() }
        guard sqlite3_step(stmt) == SQLITE_ROW else { XCTFail(); return }
        XCTAssertEqual(SQLiteDB.columnInt(stmt, 0), 1, "Foreign keys should be enabled")
    }
}
```

### Test 1.2: Content Import

```swift
// Tests/SATVocabAppTests/Data/ContentImporterTests.swift
import XCTest
@testable import SATVocabApp

final class ContentImporterTests: XCTestCase {
    
    func testImportCreatesCorrectWordCount() throws {
        let db = try TestDatabase.create(withWords: true)
        
        let stmt = try db.prepare("SELECT COUNT(*) FROM words")
        defer { stmt?.finalize() }
        guard sqlite3_step(stmt) == SQLITE_ROW else { XCTFail(); return }
        XCTAssertEqual(SQLiteDB.columnInt(stmt, 0), 10, "Should have 10 test words")
    }
    
    func testImportCreatesWordListMappings() throws {
        let db = try TestDatabase.create(withWords: true)
        
        let stmt = try db.prepare("SELECT COUNT(*) FROM word_list WHERE list_id = 1")
        defer { stmt?.finalize() }
        guard sqlite3_step(stmt) == SQLITE_ROW else { XCTFail(); return }
        XCTAssertEqual(SQLiteDB.columnInt(stmt, 0), 10)
    }
    
    func testImportCreatesSATContexts() throws {
        let db = try TestDatabase.create(withWords: true)
        
        let stmt = try db.prepare("SELECT COUNT(*) FROM sat_contexts")
        defer { stmt?.finalize() }
        guard sqlite3_step(stmt) == SQLITE_ROW else { XCTFail(); return }
        XCTAssertEqual(SQLiteDB.columnInt(stmt, 0), 20, "Should have 2 contexts per word × 10 words")
    }
    
    func testImportImageFilenameMapping() throws {
        let db = try TestDatabase.create(withWords: true)
        
        let stmt = try db.prepare("SELECT image_filename FROM words WHERE lemma = 'word1'")
        defer { stmt?.finalize() }
        guard sqlite3_step(stmt) == SQLITE_ROW else { XCTFail(); return }
        XCTAssertEqual(SQLiteDB.columnText(stmt, 0), "word1.jpg")
    }
}
```

### Test 1.3: WordStateStore — Box Progression (CRITICAL)

```swift
// Tests/SATVocabAppTests/Data/WordStateStoreTests.swift
import XCTest
@testable import SATVocabApp

final class WordStateStoreTests: XCTestCase {
    var db: SQLiteDB!
    var store: WordStateStore!
    var userId: String!
    
    override func setUpWithError() throws {
        db = try TestDatabase.create(withWords: true)
        userId = try TestDatabase.createTestUser(db: db)
        store = WordStateStore(db: db)
    }
    
    // MARK: - Introduction
    
    func testIntroduceWordSetsIntroStage1() async throws {
        try await store.introduceWord(userId: userId, wordId: 1)
        
        let ws = try await store.getWordState(userId: userId, wordId: 1)
        XCTAssertNotNil(ws)
        XCTAssertEqual(ws?.introStage, 1)
        XCTAssertEqual(ws?.boxLevel, 0)
        XCTAssertEqual(ws?.totalSeen, 1)
    }
    
    func testIntroduceWordIsIdempotent() async throws {
        try await store.introduceWord(userId: userId, wordId: 1)
        try await store.introduceWord(userId: userId, wordId: 1)
        
        let ws = try await store.getWordState(userId: userId, wordId: 1)
        XCTAssertEqual(ws?.totalSeen, 2)  // incremented
        XCTAssertEqual(ws?.introStage, 1) // stays at 1
    }
    
    // MARK: - Box Progression (Correct)
    
    func testCorrectAnswerPromotesBox() async throws {
        // Setup: word at box 1
        try await store.introduceWord(userId: userId, wordId: 1)
        try db.exec("UPDATE word_state SET box_level = 1, due_at = datetime('now','-1 day') WHERE word_id = 1")
        
        let change = try await store.recordScoredAnswer(userId: userId, wordId: 1, correct: true)
        
        let ws = try await store.getWordState(userId: userId, wordId: 1)
        XCTAssertEqual(ws?.boxLevel, 2)
        if case .promoted(let from, let to) = change {
            XCTAssertEqual(from, 1)
            XCTAssertEqual(to, 2)
        } else {
            XCTFail("Expected promoted, got \(change)")
        }
    }
    
    func testCorrectAnswerAtBox5StaysAt5() async throws {
        try await store.introduceWord(userId: userId, wordId: 1)
        try db.exec("UPDATE word_state SET box_level = 5 WHERE word_id = 1")
        
        let change = try await store.recordScoredAnswer(userId: userId, wordId: 1, correct: true)
        
        let ws = try await store.getWordState(userId: userId, wordId: 1)
        XCTAssertEqual(ws?.boxLevel, 5)
        if case .none = change {} else { XCTFail("Should be .none at max box") }
    }
    
    // MARK: - Box Progression (Wrong)
    
    func testWrongAnswerResetsToBox1() async throws {
        try await store.introduceWord(userId: userId, wordId: 1)
        try db.exec("UPDATE word_state SET box_level = 3, due_at = datetime('now','-1 day') WHERE word_id = 1")
        
        let change = try await store.recordScoredAnswer(userId: userId, wordId: 1, correct: false)
        
        let ws = try await store.getWordState(userId: userId, wordId: 1)
        XCTAssertEqual(ws?.boxLevel, 1, "Wrong answer should reset to box 1")
        XCTAssertEqual(ws?.lapseCount, 1, "Should increment lapse count")
        if case .demoted(let from, let to) = change {
            XCTAssertEqual(from, 3)
            XCTAssertEqual(to, 1)
        } else {
            XCTFail("Expected demoted")
        }
    }
    
    func testWrongAnswerAtBox1StaysAtBox1() async throws {
        try await store.introduceWord(userId: userId, wordId: 1)
        try db.exec("UPDATE word_state SET box_level = 1, due_at = datetime('now','-1 day') WHERE word_id = 1")
        
        let change = try await store.recordScoredAnswer(userId: userId, wordId: 1, correct: false)
        
        let ws = try await store.getWordState(userId: userId, wordId: 1)
        XCTAssertEqual(ws?.boxLevel, 1)
        XCTAssertEqual(ws?.lapseCount, 0, "No lapse from box 1 (already at bottom)")
    }
    
    func testWrongAnswerIncrementsConsecutiveWrong() async throws {
        try await store.introduceWord(userId: userId, wordId: 1)
        try db.exec("UPDATE word_state SET box_level = 2, due_at = datetime('now','-1 day') WHERE word_id = 1")
        
        _ = try await store.recordScoredAnswer(userId: userId, wordId: 1, correct: false)
        _ = try await store.recordScoredAnswer(userId: userId, wordId: 1, correct: false)
        
        let ws = try await store.getWordState(userId: userId, wordId: 1)
        XCTAssertEqual(ws?.consecutiveWrong, 2)
    }
    
    func testCorrectAnswerResetsConsecutiveWrong() async throws {
        try await store.introduceWord(userId: userId, wordId: 1)
        try db.exec("UPDATE word_state SET box_level = 1, consecutive_wrong = 3, due_at = datetime('now','-1 day') WHERE word_id = 1")
        
        _ = try await store.recordScoredAnswer(userId: userId, wordId: 1, correct: true)
        
        let ws = try await store.getWordState(userId: userId, wordId: 1)
        XCTAssertEqual(ws?.consecutiveWrong, 0)
    }
    
    // MARK: - Memory Status Classification
    
    func testStubbornAfter3Lapses() async throws {
        try await store.introduceWord(userId: userId, wordId: 1)
        try db.exec("UPDATE word_state SET box_level = 1, lapse_count = 3, due_at = datetime('now','-1 day') WHERE word_id = 1")
        
        _ = try await store.recordScoredAnswer(userId: userId, wordId: 1, correct: true)
        
        let ws = try await store.getWordState(userId: userId, wordId: 1)
        XCTAssertEqual(ws?.memoryStatus, .stubborn)
    }
    
    func testStubbornAfter2ConsecutiveWrong() async throws {
        try await store.introduceWord(userId: userId, wordId: 1)
        try db.exec("UPDATE word_state SET box_level = 2, due_at = datetime('now','-1 day') WHERE word_id = 1")
        
        _ = try await store.recordScoredAnswer(userId: userId, wordId: 1, correct: false)
        _ = try await store.recordScoredAnswer(userId: userId, wordId: 1, correct: false)
        
        let ws = try await store.getWordState(userId: userId, wordId: 1)
        XCTAssertEqual(ws?.memoryStatus, .stubborn)
    }
    
    func testFragileAfter1Lapse() async throws {
        try await store.introduceWord(userId: userId, wordId: 1)
        try db.exec("UPDATE word_state SET box_level = 2, lapse_count = 1, due_at = datetime('now','-1 day') WHERE word_id = 1")
        
        _ = try await store.recordScoredAnswer(userId: userId, wordId: 1, correct: true)
        
        let ws = try await store.getWordState(userId: userId, wordId: 1)
        XCTAssertEqual(ws?.memoryStatus, .fragile)
    }
    
    func testEasyAtBox3WithHighAccuracyNoLapses() async throws {
        try await store.introduceWord(userId: userId, wordId: 1)
        try db.exec("UPDATE word_state SET box_level = 3, lapse_count = 0, recent_accuracy = 0.9, due_at = datetime('now','-1 day') WHERE word_id = 1")
        
        // Need review_log entries for computeRecentAccuracy
        let logger = ReviewLogger(db: db)
        for _ in 0..<5 {
            try await logger.logReview(userId: userId, wordId: 1, outcome: .correct,
                                      activityType: .imageGame, sessionType: .morning,
                                      studyDay: 0, durationMs: 2000)
        }
        
        _ = try await store.recordScoredAnswer(userId: userId, wordId: 1, correct: true)
        
        let ws = try await store.getWordState(userId: userId, wordId: 1)
        XCTAssertEqual(ws?.memoryStatus, .easy)
    }
    
    // MARK: - Review Queue
    
    func testReviewQueuePrioritizesBox1First() async throws {
        // Create words at different box levels, all due
        for i in 1...3 {
            try await store.introduceWord(userId: userId, wordId: i)
        }
        try db.exec("UPDATE word_state SET box_level = 3, due_at = datetime('now','-1 day') WHERE word_id = 1")
        try db.exec("UPDATE word_state SET box_level = 1, due_at = datetime('now','-1 day') WHERE word_id = 2")
        try db.exec("UPDATE word_state SET box_level = 2, due_at = datetime('now','-1 day') WHERE word_id = 3")
        
        let queue = try await store.getReviewQueue(userId: userId, limit: 10)
        
        XCTAssertEqual(queue.count, 3)
        XCTAssertEqual(queue[0].wordId, 2, "Box 1 word should be first")
        XCTAssertEqual(queue[1].wordId, 3, "Box 2 word should be second")
        XCTAssertEqual(queue[2].wordId, 1, "Box 3 word should be last")
    }
    
    func testReviewQueueExcludesNotYetDue() async throws {
        try await store.introduceWord(userId: userId, wordId: 1)
        try db.exec("UPDATE word_state SET box_level = 2, due_at = datetime('now','+1 day') WHERE word_id = 1")
        
        let queue = try await store.getReviewQueue(userId: userId, limit: 10)
        XCTAssertEqual(queue.count, 0, "Word due tomorrow should not appear")
    }
    
    func testReviewQueuePrioritizesStubbornOverNormal() async throws {
        for i in 1...2 {
            try await store.introduceWord(userId: userId, wordId: i)
        }
        try db.exec("UPDATE word_state SET box_level = 1, due_at = datetime('now','-1 day'), memory_status = 'normal' WHERE word_id = 1")
        try db.exec("UPDATE word_state SET box_level = 1, due_at = datetime('now','-1 day'), memory_status = 'stubborn' WHERE word_id = 2")
        
        let queue = try await store.getReviewQueue(userId: userId, limit: 10)
        XCTAssertEqual(queue[0].wordId, 2, "Stubborn word should come first within same box")
    }
    
    // MARK: - Day 1 Promotion
    
    func testDay1PromotionWithTwoOfThreeCorrectAndCorrectFinal() async throws {
        try await store.introduceWord(userId: userId, wordId: 1)
        
        let logger = ReviewLogger(db: db)
        // 3 scored events: correct, wrong, correct (2/3, last correct)
        try await logger.logReview(userId: userId, wordId: 1, outcome: .correct,
                                  activityType: .imageGame, sessionType: .morning, studyDay: 0, durationMs: 2000)
        try await logger.logReview(userId: userId, wordId: 1, outcome: .incorrect,
                                  activityType: .quickRecall, sessionType: .evening, studyDay: 0, durationMs: 2000)
        try await logger.logReview(userId: userId, wordId: 1, outcome: .correct,
                                  activityType: .imageGame, sessionType: .evening, studyDay: 0, durationMs: 2000)
        
        let result = try await store.runDay1Promotion(userId: userId, studyDay: 0)
        
        XCTAssertEqual(result.promoted, 1)
        XCTAssertEqual(result.notPromoted, 0)
        
        let ws = try await store.getWordState(userId: userId, wordId: 1)
        XCTAssertEqual(ws?.boxLevel, 2, "Should promote to box 2")
        XCTAssertEqual(ws?.introStage, 3, "Should be marked as decided")
    }
    
    func testDay1PromotionFailsWithWrongFinalRecall() async throws {
        try await store.introduceWord(userId: userId, wordId: 1)
        
        let logger = ReviewLogger(db: db)
        // 3 scored events: correct, correct, WRONG (2/3 correct but last is wrong)
        try await logger.logReview(userId: userId, wordId: 1, outcome: .correct,
                                  activityType: .imageGame, sessionType: .morning, studyDay: 0, durationMs: 2000)
        try await logger.logReview(userId: userId, wordId: 1, outcome: .correct,
                                  activityType: .quickRecall, sessionType: .evening, studyDay: 0, durationMs: 2000)
        try await logger.logReview(userId: userId, wordId: 1, outcome: .incorrect,
                                  activityType: .imageGame, sessionType: .evening, studyDay: 0, durationMs: 2000)
        
        let result = try await store.runDay1Promotion(userId: userId, studyDay: 0)
        
        XCTAssertEqual(result.promoted, 0)
        XCTAssertEqual(result.notPromoted, 1)
        
        let ws = try await store.getWordState(userId: userId, wordId: 1)
        XCTAssertEqual(ws?.boxLevel, 1, "Should stay at box 1")
    }
    
    func testDay1PromotionFailsWithOnlyOneCorrect() async throws {
        try await store.introduceWord(userId: userId, wordId: 1)
        
        let logger = ReviewLogger(db: db)
        try await logger.logReview(userId: userId, wordId: 1, outcome: .incorrect,
                                  activityType: .imageGame, sessionType: .morning, studyDay: 0, durationMs: 2000)
        try await logger.logReview(userId: userId, wordId: 1, outcome: .incorrect,
                                  activityType: .quickRecall, sessionType: .evening, studyDay: 0, durationMs: 2000)
        try await logger.logReview(userId: userId, wordId: 1, outcome: .correct,
                                  activityType: .imageGame, sessionType: .evening, studyDay: 0, durationMs: 2000)
        
        let result = try await store.runDay1Promotion(userId: userId, studyDay: 0)
        
        XCTAssertEqual(result.promoted, 0, "1/3 correct should not promote")
    }
    
    // MARK: - Box Distribution
    
    func testBoxDistributionCounts() async throws {
        for i in 1...5 {
            try await store.introduceWord(userId: userId, wordId: i)
        }
        try db.exec("UPDATE word_state SET box_level = 1 WHERE word_id IN (1,2)")
        try db.exec("UPDATE word_state SET box_level = 3 WHERE word_id IN (3,4,5)")
        
        let dist = try await store.getBoxDistribution(userId: userId)
        XCTAssertEqual(dist[1], 2)
        XCTAssertEqual(dist[3], 3)
    }
    
    // MARK: - Overdue Count
    
    func testOverdueCount() async throws {
        for i in 1...5 {
            try await store.introduceWord(userId: userId, wordId: i)
        }
        try db.exec("UPDATE word_state SET box_level = 1, due_at = datetime('now','-1 day') WHERE word_id IN (1,2,3)")
        try db.exec("UPDATE word_state SET box_level = 2, due_at = datetime('now','+1 day') WHERE word_id IN (4,5)")
        
        let count = try await store.countOverdue(userId: userId)
        XCTAssertEqual(count, 3)
    }
}
```

### Test 1.4: StatsStore

```swift
// Tests/SATVocabAppTests/Data/StatsStoreTests.swift
import XCTest
@testable import SATVocabApp

final class StatsStoreTests: XCTestCase {
    var db: SQLiteDB!
    var store: StatsStore!
    var userId: String!
    
    override func setUpWithError() throws {
        db = try TestDatabase.create(withWords: true)
        userId = try TestDatabase.createTestUser(db: db)
        store = StatsStore(db: db)
    }
    
    func testGetOrCreateDailyStats() async throws {
        let stats = try await store.getOrCreateDailyStats(userId: userId, studyDay: 0)
        XCTAssertEqual(stats.studyDay, 0)
        XCTAssertEqual(stats.xpEarned, 0)
        XCTAssertEqual(stats.correctCount, 0)
    }
    
    func testRecordCorrectAddsXP() async throws {
        _ = try await store.getOrCreateDailyStats(userId: userId, studyDay: 0)
        try await store.recordCorrectAnswer(userId: userId, studyDay: 0)
        try await store.recordCorrectAnswer(userId: userId, studyDay: 0)
        
        let stats = try await store.getOrCreateDailyStats(userId: userId, studyDay: 0)
        XCTAssertEqual(stats.correctCount, 2)
        XCTAssertEqual(stats.totalCount, 2)
        XCTAssertEqual(stats.xpEarned, 20)  // 2 × 10 XP
    }
    
    func testRecordWrongNoXP() async throws {
        _ = try await store.getOrCreateDailyStats(userId: userId, studyDay: 0)
        try await store.recordWrongAnswer(userId: userId, studyDay: 0)
        
        let stats = try await store.getOrCreateDailyStats(userId: userId, studyDay: 0)
        XCTAssertEqual(stats.correctCount, 0)
        XCTAssertEqual(stats.totalCount, 1)
        XCTAssertEqual(stats.xpEarned, 0, "Wrong answers earn 0 XP")
    }
    
    func testSessionBonus() async throws {
        _ = try await store.getOrCreateDailyStats(userId: userId, studyDay: 0)
        try await store.addSessionBonus(userId: userId, studyDay: 0, bonus: 30)
        
        let stats = try await store.getOrCreateDailyStats(userId: userId, studyDay: 0)
        XCTAssertEqual(stats.sessionBonus, 30)
    }
    
    // MARK: - Streak
    
    func testFirstDayStreakIsOne() async throws {
        let (streak, _) = try await store.updateStreak(userId: userId, xpToday: 100)
        XCTAssertEqual(streak, 1)
    }
    
    func testStreakMilestoneAt3Days() async throws {
        // Simulate 3 consecutive days
        try db.exec("UPDATE streak_store SET current_streak = 2, last_study_date = '\(yesterday())' WHERE user_id = '\(userId!)'")
        
        let (streak, milestoneXP) = try await store.updateStreak(userId: userId, xpToday: 100)
        XCTAssertEqual(streak, 3)
        XCTAssertEqual(milestoneXP, 20, "3-day streak milestone = +20 XP")
    }
    
    func testStreakMilestoneClaimedOnlyOnce() async throws {
        try db.exec("UPDATE streak_store SET current_streak = 2, last_study_date = '\(yesterday())', streak_3_claimed = 1 WHERE user_id = '\(userId!)'")
        
        let (streak, milestoneXP) = try await store.updateStreak(userId: userId, xpToday: 100)
        XCTAssertEqual(streak, 3)
        XCTAssertEqual(milestoneXP, 0, "Already claimed — no bonus")
    }
    
    func testStreakResetsAfterMissedDay() async throws {
        try db.exec("UPDATE streak_store SET current_streak = 5, last_study_date = '\(twoDaysAgo())' WHERE user_id = '\(userId!)'")
        
        let (streak, _) = try await store.updateStreak(userId: userId, xpToday: 100)
        XCTAssertEqual(streak, 1, "Streak should reset after missed day")
    }
    
    private func yesterday() -> String {
        DateFormatter.yyyyMMdd.string(from: Calendar.current.date(byAdding: .day, value: -1, to: Date())!)
    }
    
    private func twoDaysAgo() -> String {
        DateFormatter.yyyyMMdd.string(from: Calendar.current.date(byAdding: .day, value: -2, to: Date())!)
    }
}
```

### Test 1.5: ReviewLogger + Supersede

```swift
// Tests/SATVocabAppTests/Data/ReviewLoggerTests.swift
import XCTest
@testable import SATVocabApp

final class ReviewLoggerTests: XCTestCase {
    var db: SQLiteDB!
    var logger: ReviewLogger!
    var userId: String!
    
    override func setUpWithError() throws {
        db = try TestDatabase.create(withWords: true)
        userId = try TestDatabase.createTestUser(db: db)
        logger = ReviewLogger(db: db)
    }
    
    func testLogReviewWritesEntry() async throws {
        try await logger.logReview(userId: userId, wordId: 1, outcome: .correct,
                                  activityType: .imageGame, sessionType: .morning,
                                  studyDay: 0, durationMs: 1500)
        
        let stmt = try db.prepare("SELECT outcome, activity_type, session_type, study_day, duration_ms, superseded FROM review_log WHERE word_id = 1")
        defer { stmt?.finalize() }
        guard sqlite3_step(stmt) == SQLITE_ROW else { XCTFail(); return }
        
        XCTAssertEqual(SQLiteDB.columnText(stmt, 0), "correct")
        XCTAssertEqual(SQLiteDB.columnText(stmt, 1), "image_game")
        XCTAssertEqual(SQLiteDB.columnText(stmt, 2), "morning")
        XCTAssertEqual(SQLiteDB.columnInt(stmt, 3), 0)
        XCTAssertEqual(SQLiteDB.columnInt(stmt, 4), 1500)
        XCTAssertEqual(SQLiteDB.columnInt(stmt, 5), 0, "Should not be superseded")
    }
    
    func testSupersedeMarksEntriesAsSuperseded() async throws {
        // Log 3 entries
        for _ in 0..<3 {
            try await logger.logReview(userId: userId, wordId: 1, outcome: .correct,
                                      activityType: .imageGame, sessionType: .morning,
                                      studyDay: 0, durationMs: 1500)
        }
        
        // Supersede
        try await logger.supersedeSession(userId: userId, studyDay: 0, sessionType: .morning)
        
        let stmt = try db.prepare("SELECT COUNT(*) FROM review_log WHERE superseded = 1")
        defer { stmt?.finalize() }
        guard sqlite3_step(stmt) == SQLITE_ROW else { XCTFail(); return }
        XCTAssertEqual(SQLiteDB.columnInt(stmt, 0), 3, "All 3 should be superseded")
    }
}
```

---

## Plan 2 Tests: Session Engine

### Test 2.1: PracticeStateResolver

```swift
// Tests/SATVocabAppTests/ViewModels/PracticeStateResolverTests.swift
import XCTest
@testable import SATVocabApp

final class PracticeStateResolverTests: XCTestCase {
    
    func testStateA_MorningAvailableWhenNoDayState() {
        let state = PracticeStateResolver.resolve(dayState: nil, activeSession: nil)
        if case .morningAvailable = state {} else { XCTFail("Expected morningAvailable") }
    }
    
    func testStateB_PausedSessionTakesPriority() {
        let day = makeDayState(morningComplete: false)
        let session = makeSessionState(isPaused: true)
        
        let state = PracticeStateResolver.resolve(dayState: day, activeSession: session)
        if case .paused = state {} else { XCTFail("Expected paused") }
    }
    
    func testStateC_MorningDoneEveningLocked() {
        let day = makeDayState(morningComplete: true, morningCompleteAt: Date())
        let futureUnlock = Date().addingTimeInterval(3600) // 1 hour from now
        
        let state = PracticeStateResolver.resolve(dayState: day, activeSession: nil, now: Date())
        if case .morningDoneEveningLocked = state {} else { XCTFail("Expected evening locked") }
    }
    
    func testStateD_EveningAvailableAfterUnlock() {
        let fourHoursAgo = Date().addingTimeInterval(-4 * 3600)
        let day = makeDayState(morningComplete: true, morningCompleteAt: fourHoursAgo)
        
        let state = PracticeStateResolver.resolve(dayState: day, activeSession: nil, now: Date())
        if case .eveningAvailable = state {} else { XCTFail("Expected evening available") }
    }
    
    func testStateE_BothComplete() {
        let day = makeDayState(morningComplete: true, eveningComplete: true)
        
        let state = PracticeStateResolver.resolve(dayState: day, activeSession: nil)
        if case .bothComplete = state {} else { XCTFail("Expected bothComplete") }
    }
    
    // MARK: - Evening Unlock Timing
    
    func testEveningUnlocksAt5PMIfMorningDoneBefore1PM() {
        // Morning done at 10 AM → 4 hours = 2 PM, but 5 PM fallback wins (min)
        // Actually min(2PM, 5PM) = 2PM. Let me re-check the rule...
        // Rule: min(morning + 4hr, 5PM) — whichever comes FIRST
        // 10AM + 4hr = 2PM. min(2PM, 5PM) = 2PM. So unlocks at 2PM.
        
        let tenAM = Calendar.current.date(bySettingHour: 10, minute: 0, second: 0, of: Date())!
        let day = makeDayState(morningComplete: true, morningCompleteAt: tenAM)
        
        let twoPM = Calendar.current.date(bySettingHour: 14, minute: 0, second: 0, of: Date())!
        let stateAt1PM = PracticeStateResolver.resolve(dayState: day, activeSession: nil,
            now: Calendar.current.date(bySettingHour: 13, minute: 0, second: 0, of: Date())!)
        if case .morningDoneEveningLocked = stateAt1PM {} else { XCTFail("Should be locked at 1 PM") }
        
        let stateAt3PM = PracticeStateResolver.resolve(dayState: day, activeSession: nil,
            now: Calendar.current.date(bySettingHour: 15, minute: 0, second: 0, of: Date())!)
        if case .eveningAvailable = stateAt3PM {} else { XCTFail("Should be available at 3 PM") }
    }
    
    // MARK: - Helpers
    
    private func makeDayState(morningComplete: Bool = false, eveningComplete: Bool = false,
                             morningCompleteAt: Date? = nil) -> DayState {
        DayState(id: 1, userId: "test", studyDay: 0, zoneIndex: 0,
                morningComplete: morningComplete, eveningComplete: eveningComplete,
                morningCompleteAt: morningCompleteAt, eveningCompleteAt: nil,
                newWordsMorning: 0, newWordsEvening: 0,
                morningAccuracy: 0, eveningAccuracy: 0,
                morningXP: 0, eveningXP: 0,
                isRecoveryDay: false, isReviewOnlyDay: false)
    }
    
    private func makeSessionState(isPaused: Bool) -> SessionState {
        SessionState(id: 1, userId: "test", sessionType: .morning, studyDay: 0,
                    stepIndex: 1, itemIndex: 3, isPaused: isPaused,
                    showAgainIds: [], requeuedIds: [],
                    startedAt: Date(), pausedAt: isPaused ? Date() : nil, completedAt: nil)
    }
}
```

---

## Test Execution Strategy

### Run After Each Task

```bash
# After any Plan 1 task:
cd ios/SATVocabApp
xcodebuild test -scheme SATVocabApp \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro' \
  -only-testing:SATVocabAppTests/Data \
  2>&1 | grep -E "Test Case|passed|failed|error"

# After any Plan 2 task:
xcodebuild test -scheme SATVocabApp \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro' \
  -only-testing:SATVocabAppTests/ViewModels \
  2>&1 | grep -E "Test Case|passed|failed|error"

# Full test suite:
xcodebuild test -scheme SATVocabApp \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro' \
  2>&1 | grep -E "Test Suite|passed|failed|Executed"
```

### CI Integration (GitHub Actions)

```yaml
# .github/workflows/test.yml
name: Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run tests
        run: |
          cd ios/SATVocabApp
          xcodebuild test -scheme SATVocabApp \
            -destination 'platform=iOS Simulator,name=iPhone 16 Pro' \
            -resultBundlePath TestResults.xcresult \
            | xcpretty
```

---

## Test Coverage Targets

| Layer | Target | Key Tests |
|-------|--------|-----------|
| **WordStateStore** | 95% | Box progression up/down, memory status, review queue, Day 1 promotion |
| **StatsStore** | 90% | XP calculation, streak logic, milestone claiming |
| **SessionStateStore** | 85% | Day state, pause/resume, session lifecycle |
| **ReviewLogger** | 90% | Log entries, supersede on restart |
| **PracticeStateResolver** | 100% | All 5 P0 states, evening unlock timing |
| **ContentImporter** | 80% | Word count, mappings, edge cases |
| **Schema** | 80% | Table creation, idempotency, FK enforcement |

**Total test count: ~45 tests across 8 test files.**

---

## What NOT to Test (V1)

- SwiftUI view rendering (fragile, low value for V1)
- Image loading/display (visual, test manually)
- Animations and transitions (visual, test manually)
- Network/Supabase sync (not in P0)
- XCUITest end-to-end flows (too slow, add in V1.1)

Focus automated tests on **data correctness**. Test the UI manually with your daughter.
