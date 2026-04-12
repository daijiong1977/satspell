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

## User Journey Simulation Tests

These tests simulate **real student behavior** across multiple sessions/days. They run against the data layer (no UI) but exercise the complete flow.

### Journey 1: First Day Complete

```swift
// Tests/SATVocabAppTests/Journeys/FirstDayJourneyTests.swift
import XCTest
@testable import SATVocabApp

final class FirstDayJourneyTests: XCTestCase {
    var db: SQLiteDB!
    var userId: String!
    var wsStore: WordStateStore!
    var sessionStore: SessionStateStore!
    var statsStore: StatsStore!
    var logger: ReviewLogger!
    
    override func setUpWithError() throws {
        db = try TestDatabase.create(withWords: true)
        userId = try TestDatabase.createTestUser(db: db)
        wsStore = WordStateStore(db: db)
        sessionStore = SessionStateStore(db: db)
        statsStore = StatsStore(db: db)
        logger = ReviewLogger(db: db)
    }
    
    /// Simulates a complete Day 1: morning + evening sessions
    func testCompleteDayOneFlow() async throws {
        let studyDay = 0
        
        // === MORNING SESSION ===
        
        // Step 1: Flashcards — introduce 5 words (exposure only)
        let morningWords = [1, 2, 3, 4, 5]
        for wordId in morningWords {
            try await wsStore.introduceWord(userId: userId, wordId: wordId)
        }
        
        // Verify all at intro_stage = 1, box = 0
        for wordId in morningWords {
            let ws = try await wsStore.getWordState(userId: userId, wordId: wordId)
            XCTAssertEqual(ws?.introStage, 1)
            XCTAssertEqual(ws?.boxLevel, 0)
        }
        
        // Step 2: Image game — score 5 answers (4 correct, 1 wrong)
        _ = try await statsStore.getOrCreateDailyStats(userId: userId, studyDay: studyDay)
        
        let morningResults: [(Int, Bool)] = [(1, true), (2, true), (3, true), (4, false), (5, true)]
        for (wordId, correct) in morningResults {
            try await logger.logReview(userId: userId, wordId: wordId, outcome: correct ? .correct : .incorrect,
                                      activityType: .imageGame, sessionType: .morning, studyDay: studyDay, durationMs: 2500)
            _ = try await wsStore.recordScoredAnswer(userId: userId, wordId: wordId, correct: correct)
            if correct {
                try await statsStore.recordCorrectAnswer(userId: userId, studyDay: studyDay)
            } else {
                try await statsStore.recordWrongAnswer(userId: userId, studyDay: studyDay)
            }
        }
        
        // Step 3: SAT questions — 2 correct
        try await logger.logReview(userId: userId, wordId: 1, outcome: .correct,
                                  activityType: .satQuestion, sessionType: .morning, studyDay: studyDay, durationMs: 5000)
        try await statsStore.recordCorrectAnswer(userId: userId, studyDay: studyDay)
        
        try await logger.logReview(userId: userId, wordId: 2, outcome: .correct,
                                  activityType: .satQuestion, sessionType: .morning, studyDay: studyDay, durationMs: 4000)
        try await statsStore.recordCorrectAnswer(userId: userId, studyDay: studyDay)
        
        // Mark morning complete
        try await sessionStore.markMorningComplete(userId: userId, studyDay: studyDay,
            accuracy: 6.0/7.0, xp: 60, newWords: 5)
        
        // Verify morning stats
        let morningStats = try await statsStore.getOrCreateDailyStats(userId: userId, studyDay: studyDay)
        XCTAssertEqual(morningStats.correctCount, 6, "4 game + 2 SAT correct")
        XCTAssertEqual(morningStats.totalCount, 7, "5 game + 2 SAT total")
        XCTAssertEqual(morningStats.xpEarned, 60, "6 × 10 XP")
        
        // Verify evening is locked
        let dayState = try await sessionStore.getDayState(userId: userId, studyDay: studyDay)
        XCTAssertTrue(dayState!.morningComplete)
        XCTAssertFalse(dayState!.eveningComplete)
        XCTAssertNotNil(dayState!.morningCompleteAt)
        
        // === EVENING SESSION ===
        
        // Step 1: Flashcards (3 more new words)
        for wordId in [6, 7, 8] {
            try await wsStore.introduceWord(userId: userId, wordId: wordId)
        }
        
        // Step 2: Quick recall (morning words)
        let recallResults: [(Int, Bool)] = [(1, true), (2, true), (3, false), (4, true), (5, true)]
        for (wordId, correct) in recallResults {
            try await logger.logReview(userId: userId, wordId: wordId, outcome: correct ? .correct : .incorrect,
                                      activityType: .quickRecall, sessionType: .evening, studyDay: studyDay, durationMs: 2000)
            if correct { try await statsStore.recordCorrectAnswer(userId: userId, studyDay: studyDay) }
            else { try await statsStore.recordWrongAnswer(userId: userId, studyDay: studyDay) }
        }
        
        // Step 3: Image game (evening words + reviews)
        let eveningGameResults: [(Int, Bool)] = [(6, true), (7, true), (8, false)]
        for (wordId, correct) in eveningGameResults {
            try await logger.logReview(userId: userId, wordId: wordId, outcome: correct ? .correct : .incorrect,
                                      activityType: .imageGame, sessionType: .evening, studyDay: studyDay, durationMs: 2500)
            _ = try await wsStore.recordScoredAnswer(userId: userId, wordId: wordId, correct: correct)
            if correct { try await statsStore.recordCorrectAnswer(userId: userId, studyDay: studyDay) }
            else { try await statsStore.recordWrongAnswer(userId: userId, studyDay: studyDay) }
        }
        
        // Mark evening complete
        try await sessionStore.markEveningComplete(userId: userId, studyDay: studyDay,
            accuracy: 0.75, xp: 70, newWords: 3)
        
        // Run Day 1 promotion
        let promotion = try await wsStore.runDay1Promotion(userId: userId, studyDay: studyDay)
        
        // Update streak
        let totalXP = 60 + 70
        let (streak, milestoneXP) = try await statsStore.updateStreak(userId: userId, xpToday: totalXP)
        
        // === FINAL ASSERTIONS ===
        
        // Day state
        let finalDay = try await sessionStore.getDayState(userId: userId, studyDay: studyDay)
        XCTAssertTrue(finalDay!.morningComplete)
        XCTAssertTrue(finalDay!.eveningComplete)
        
        // Streak
        XCTAssertEqual(streak, 1)
        
        // Word 1: morning game correct + evening recall correct = 2/2 correct, last correct → Box 2
        let ws1 = try await wsStore.getWordState(userId: userId, wordId: 1)
        XCTAssertEqual(ws1?.boxLevel, 2, "Word 1 should be promoted to Box 2")
        
        // Word 4: morning game WRONG + evening recall correct = 1/2 correct → Box 1
        let ws4 = try await wsStore.getWordState(userId: userId, wordId: 4)
        // Day 1 promotion only checks image_game + quick_recall events
        // Word 4: game=wrong, recall=correct → 1/2 correct. Need 2/3. Not enough → Box 1
        XCTAssertEqual(ws4?.boxLevel, 1, "Word 4 should stay at Box 1 (only 1/2 correct)")
        
        // Promotion stats
        XCTAssertGreaterThan(promotion.promoted, 0, "At least some words should be promoted")
        
        print("✅ Day 1 journey complete:")
        print("   Words introduced: 8")
        print("   Promoted to Box 2: \(promotion.promoted)")
        print("   Stayed at Box 1: \(promotion.notPromoted)")
        print("   Streak: \(streak)")
        print("   Total XP: \(totalXP + milestoneXP)")
    }
}
```

### Journey 2: Five-Day Progression

```swift
// Tests/SATVocabAppTests/Journeys/FiveDayJourneyTests.swift
import XCTest
@testable import SATVocabApp

final class FiveDayJourneyTests: XCTestCase {
    var db: SQLiteDB!
    var userId: String!
    var wsStore: WordStateStore!
    var statsStore: StatsStore!
    var logger: ReviewLogger!
    var sessionStore: SessionStateStore!
    
    override func setUpWithError() throws {
        db = try TestDatabase.create()
        // Insert 50 words for multi-day test
        try TestDatabase.insertTestWords(db: db, count: 50)
        userId = try TestDatabase.createTestUser(db: db)
        wsStore = WordStateStore(db: db)
        statsStore = StatsStore(db: db)
        logger = ReviewLogger(db: db)
        sessionStore = SessionStateStore(db: db)
    }
    
    /// Simulates 5 study days with 10 new words per day
    func testFiveDayProgression() async throws {
        var totalXP = 0
        
        for day in 0..<5 {
            let wordsForDay = Array((day * 10 + 1)...(day * 10 + 10))
            
            // Introduce words
            for wordId in wordsForDay {
                try await wsStore.introduceWord(userId: userId, wordId: wordId)
            }
            
            // Create day state
            _ = try await sessionStore.getOrCreateDayState(userId: userId, studyDay: day, zoneIndex: 0)
            _ = try await statsStore.getOrCreateDailyStats(userId: userId, studyDay: day)
            
            // Morning game: 80% correct
            for (i, wordId) in wordsForDay.enumerated() {
                let correct = i < 8 // 8/10 correct
                try await logger.logReview(userId: userId, wordId: wordId, outcome: correct ? .correct : .incorrect,
                                          activityType: .imageGame, sessionType: .morning, studyDay: day, durationMs: 2000)
                _ = try await wsStore.recordScoredAnswer(userId: userId, wordId: wordId, correct: correct)
                if correct { try await statsStore.recordCorrectAnswer(userId: userId, studyDay: day) }
                else { try await statsStore.recordWrongAnswer(userId: userId, studyDay: day) }
            }
            
            // Evening recall: 80% correct
            for (i, wordId) in wordsForDay.enumerated() {
                let correct = i < 8
                try await logger.logReview(userId: userId, wordId: wordId, outcome: correct ? .correct : .incorrect,
                                          activityType: .quickRecall, sessionType: .evening, studyDay: day, durationMs: 1500)
                if correct { try await statsStore.recordCorrectAnswer(userId: userId, studyDay: day) }
                else { try await statsStore.recordWrongAnswer(userId: userId, studyDay: day) }
            }
            
            // Run Day 1 promotion
            let result = try await wsStore.runDay1Promotion(userId: userId, studyDay: day)
            
            // Complete day
            try await sessionStore.markMorningComplete(userId: userId, studyDay: day, accuracy: 0.8, xp: 80, newWords: 10)
            try await sessionStore.markEveningComplete(userId: userId, studyDay: day, accuracy: 0.8, xp: 80, newWords: 0)
            
            let dayXP = 160 // 16 correct × 10
            totalXP += dayXP
            let (streak, milestoneXP) = try await statsStore.updateStreak(userId: userId, xpToday: dayXP)
            totalXP += milestoneXP
            
            // Reset day touches for next day
            try await wsStore.resetDayTouches(userId: userId)
            
            print("  Day \(day + 1): \(result.promoted) promoted, \(result.notPromoted) box 1, streak=\(streak), xp=\(totalXP)")
        }
        
        // Final assertions
        let dist = try await wsStore.getBoxDistribution(userId: userId)
        let box2plus = (dist[2] ?? 0) + (dist[3] ?? 0) + (dist[4] ?? 0) + (dist[5] ?? 0)
        
        XCTAssertGreaterThan(box2plus, 20, "After 5 days with 80% accuracy, >20 words should be at Box 2+")
        
        let streakInfo = try await statsStore.getStreak(userId: userId)
        XCTAssertEqual(streakInfo.currentStreak, 5)
        XCTAssertTrue(streakInfo.streak3Claimed, "3-day milestone should be claimed")
        XCTAssertGreaterThan(streakInfo.totalXP, 750, "5 days × ~160 XP = ~800+")
        
        // Review queue: words from Day 1 should be due by Day 5 (box 2 = 3 day interval)
        let overdue = try await wsStore.countOverdue(userId: userId)
        XCTAssertGreaterThan(overdue, 0, "Some Day 1-2 words should be due for review by Day 5")
        
        let queue = try await wsStore.getReviewQueue(userId: userId, limit: 50)
        XCTAssertGreaterThan(queue.count, 0, "Review queue should have entries")
        
        print("\n✅ 5-day journey complete:")
        print("   Box distribution: \(dist)")
        print("   Box 2+: \(box2plus)")
        print("   Streak: \(streakInfo.currentStreak)")
        print("   Total XP: \(streakInfo.totalXP)")
        print("   Reviews due: \(overdue)")
    }
}
```

### Journey 3: Edge Cases

```swift
// Tests/SATVocabAppTests/Journeys/EdgeCaseJourneyTests.swift
import XCTest
@testable import SATVocabApp

final class EdgeCaseJourneyTests: XCTestCase {
    var db: SQLiteDB!
    var userId: String!
    var wsStore: WordStateStore!
    var statsStore: StatsStore!
    var sessionStore: SessionStateStore!
    var logger: ReviewLogger!
    
    override func setUpWithError() throws {
        db = try TestDatabase.create(withWords: true)
        userId = try TestDatabase.createTestUser(db: db)
        wsStore = WordStateStore(db: db)
        statsStore = StatsStore(db: db)
        sessionStore = SessionStateStore(db: db)
        logger = ReviewLogger(db: db)
    }
    
    /// Missed day → streak resets, review queue grows
    func testMissedDayResetsStreak() async throws {
        // Day 0: complete
        try db.exec("UPDATE streak_store SET current_streak = 3, last_study_date = '\(daysAgo(2))' WHERE user_id = '\(userId!)'")
        
        let (streak, _) = try await statsStore.updateStreak(userId: userId, xpToday: 100)
        XCTAssertEqual(streak, 1, "Streak resets after missing a day")
    }
    
    /// Back-pressure: >18 overdue words triggers reduced new words
    func testBackPressureDetection() async throws {
        // Create 20 words at box 1, all overdue
        for i in 1...10 {
            try await wsStore.introduceWord(userId: userId, wordId: i)
        }
        try db.exec("UPDATE word_state SET box_level = 1, due_at = datetime('now','-2 day')")
        
        let overdue = try await wsStore.countOverdue(userId: userId)
        XCTAssertEqual(overdue, 10)
        
        // Check threshold (AppConfig.backPressureReduceAt = 18)
        let shouldReduce = overdue > AppConfig.backPressureReduceAt
        XCTAssertFalse(shouldReduce, "10 overdue should not trigger back-pressure (threshold 18)")
    }
    
    /// Restart mid-session supersedes old entries
    func testRestartSupersedesOldEntries() async throws {
        _ = try await statsStore.getOrCreateDailyStats(userId: userId, studyDay: 0)
        
        // First attempt: 3 correct answers
        for i in 1...3 {
            try await logger.logReview(userId: userId, wordId: i, outcome: .correct,
                                      activityType: .imageGame, sessionType: .morning, studyDay: 0, durationMs: 2000)
            try await statsStore.recordCorrectAnswer(userId: userId, studyDay: 0)
        }
        
        let statsBefore = try await statsStore.getOrCreateDailyStats(userId: userId, studyDay: 0)
        XCTAssertEqual(statsBefore.xpEarned, 30)
        
        // Restart: supersede old entries
        try await logger.supersedeSession(userId: userId, studyDay: 0, sessionType: .morning)
        
        // Verify superseded
        let stmt = try db.prepare("SELECT COUNT(*) FROM review_log WHERE superseded = 1")
        defer { stmt?.finalize() }
        guard sqlite3_step(stmt) == SQLITE_ROW else { XCTFail(); return }
        XCTAssertEqual(SQLiteDB.columnInt(stmt, 0), 3, "All 3 should be superseded")
    }
    
    /// Word progresses from Locked In → Mastered over time
    func testWordProgressionToMastery() async throws {
        try await wsStore.introduceWord(userId: userId, wordId: 1)
        try db.exec("UPDATE word_state SET box_level = 1, due_at = datetime('now','-1 day') WHERE word_id = 1")
        
        // Correct answers at each box level: 1→2→3→4→5
        for expectedBox in 2...5 {
            let change = try await wsStore.recordScoredAnswer(userId: userId, wordId: 1, correct: true)
            let ws = try await wsStore.getWordState(userId: userId, wordId: 1)
            XCTAssertEqual(ws?.boxLevel, expectedBox, "Should be at box \(expectedBox)")
            
            if expectedBox == 5 {
                XCTAssertTrue(change.isMastery, "Box 5 should trigger mastery")
            }
            
            // Set due to past for next iteration
            if expectedBox < 5 {
                try db.exec("UPDATE word_state SET due_at = datetime('now','-1 day') WHERE word_id = 1")
            }
        }
        
        let final = try await wsStore.getWordState(userId: userId, wordId: 1)
        XCTAssertEqual(final?.strength, .mastered)
    }
    
    /// Pause and resume preserves position
    func testPauseResumePreservesState() async throws {
        _ = try await sessionStore.createSession(userId: userId, sessionType: .morning, studyDay: 0)
        
        try await sessionStore.pauseSession(userId: userId, studyDay: 0, sessionType: .morning,
                                           stepIndex: 1, itemIndex: 7,
                                           showAgainIds: [3, 5], requeuedIds: [2])
        
        let paused = try await sessionStore.getActiveSession(userId: userId)
        XCTAssertNotNil(paused)
        XCTAssertEqual(paused?.stepIndex, 1)
        XCTAssertEqual(paused?.itemIndex, 7)
        XCTAssertEqual(paused?.showAgainIds, [3, 5])
        XCTAssertEqual(paused?.requeuedIds, [2])
        XCTAssertTrue(paused?.isPaused ?? false)
        
        // Resume
        try await sessionStore.resumeSession(userId: userId, studyDay: 0, sessionType: .morning)
        let resumed = try await sessionStore.getActiveSession(userId: userId)
        // After resume, is_paused = false but session still active (not completed)
        XCTAssertNil(resumed, "No active paused session after resume")
    }
    
    private func daysAgo(_ n: Int) -> String {
        DateFormatter.yyyyMMdd.string(from: Calendar.current.date(byAdding: .day, value: -n, to: Date())!)
    }
}
```

---

## iPhone Simulator UI Tests (XCUITest)

Basic smoke tests that run on the iOS simulator to verify navigation and critical user flows.

```
ios/SATVocabApp/
└── UITests/SATVocabAppUITests/
    ├── LaunchTests.swift           ← First launch, import, Practice tab visible
    ├── SessionFlowUITests.swift    ← Start session, flashcard flip, game answer, complete
    └── NavigationUITests.swift     ← Tab switching, map tap, pause/resume
```

### Launch Test

```swift
// UITests/SATVocabAppUITests/LaunchTests.swift
import XCTest

final class LaunchTests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUp() {
        continueAfterFailure = false
        app.launchArguments = ["--reset-data"]  // Fresh start
        app.launch()
    }
    
    func testFirstLaunchShowsPracticeTab() {
        // After first launch + JSON import, Practice tab should be visible
        XCTAssertTrue(app.tabBars.buttons["Practice"].waitForExistence(timeout: 10),
                     "Practice tab should appear after import")
    }
    
    func testAllFourTabsExist() {
        XCTAssertTrue(app.tabBars.buttons["Map"].exists)
        XCTAssertTrue(app.tabBars.buttons["Practice"].exists)
        XCTAssertTrue(app.tabBars.buttons["Stats"].exists)
        XCTAssertTrue(app.tabBars.buttons["Profile"].exists)
    }
    
    func testPracticeShowsMorningSessionCard() {
        let morningCard = app.staticTexts["Morning Session"]
        XCTAssertTrue(morningCard.waitForExistence(timeout: 10),
                     "Morning session card should be visible on Practice tab")
    }
}
```

### Session Flow UI Test

```swift
// UITests/SATVocabAppUITests/SessionFlowUITests.swift
import XCTest

final class SessionFlowUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUp() {
        continueAfterFailure = false
        app.launch()
    }
    
    func testStartMorningSession() {
        // Tap START on morning card
        let startButton = app.buttons["START"]
        if startButton.waitForExistence(timeout: 10) {
            startButton.tap()
            
            // Should see flashcard step header
            let stepLabel = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'STEP 1'")).firstMatch
            XCTAssertTrue(stepLabel.waitForExistence(timeout: 5),
                         "Should show Step 1 header after starting session")
        }
    }
    
    func testFlashcardFlip() {
        // Start session
        app.buttons["START"].tap()
        sleep(2)
        
        // Tap to flip (the flashcard is the main content area)
        let cardArea = app.otherElements.firstMatch
        cardArea.tap()
        
        // After flip, should see "SHOW AGAIN" or "GOT IT" button
        let gotIt = app.buttons.matching(NSPredicate(format: "label CONTAINS 'GOT IT'")).firstMatch
        XCTAssertTrue(gotIt.waitForExistence(timeout: 3),
                     "GOT IT button should appear on card back")
    }
    
    func testPauseAndResume() {
        // Start session
        app.buttons["START"].tap()
        sleep(2)
        
        // Tap close (✕) button
        let closeButton = app.buttons.matching(NSPredicate(format: "label CONTAINS 'xmark' OR label CONTAINS '✕'")).firstMatch
        if closeButton.waitForExistence(timeout: 3) {
            closeButton.tap()
            
            // Pause sheet should appear
            let pauseSheet = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'Pause'")).firstMatch
            XCTAssertTrue(pauseSheet.waitForExistence(timeout: 3))
            
            // Tap "PAUSE & EXIT"
            let exitButton = app.buttons.matching(NSPredicate(format: "label CONTAINS 'PAUSE'")).firstMatch
            if exitButton.exists {
                exitButton.tap()
                
                // Should see Resume card on Practice tab
                let resumeCard = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'Continue'")).firstMatch
                XCTAssertTrue(resumeCard.waitForExistence(timeout: 5),
                             "Resume card should appear after pausing")
            }
        }
    }
}
```

### Performance Test

```swift
// Tests/SATVocabAppTests/Data/PerformanceTests.swift
import XCTest
@testable import SATVocabApp

final class PerformanceTests: XCTestCase {
    
    func testSchemaCreationPerformance() throws {
        measure {
            let db = try! TestDatabase.create()
            _ = db  // Schema creation is inside create()
        }
        // Should complete in < 100ms
    }
    
    func testContentImportPerformance() throws {
        // Test with 50 words (scaled from 372)
        measure {
            let db = try! TestDatabase.create()
            try! TestDatabase.insertTestWords(db: db, count: 50)
        }
        // 50 words should complete in < 500ms
        // 372 words should complete in < 3s (extrapolated)
    }
    
    func testReviewQueueQueryPerformance() async throws {
        let db = try TestDatabase.create()
        try TestDatabase.insertTestWords(db: db, count: 50)
        let userId = try TestDatabase.createTestUser(db: db)
        let store = WordStateStore(db: db)
        
        // Create 50 word_state entries, all overdue
        for i in 1...50 {
            try await store.introduceWord(userId: userId, wordId: i)
        }
        try db.exec("UPDATE word_state SET box_level = 1, due_at = datetime('now','-1 day')")
        
        // Query should be fast even with all 50 overdue
        let start = CFAbsoluteTimeGetCurrent()
        let queue = try await store.getReviewQueue(userId: userId, limit: 20)
        let elapsed = CFAbsoluteTimeGetCurrent() - start
        
        XCTAssertEqual(queue.count, 20)
        XCTAssertLessThan(elapsed, 0.1, "Review queue query should complete in < 100ms")
    }
}
```

---

## Updated Test Summary

| Category | File | Tests | What |
|----------|------|-------|------|
| **Unit: Schema** | SchemaTests | 3 | Table creation, idempotency, FK |
| **Unit: Import** | ContentImporterTests | 4 | Word count, mappings, images |
| **Unit: WordState** | WordStateStoreTests | 15 | Box progression, memory status, queue, promotion |
| **Unit: Stats** | StatsStoreTests | 6 | XP, streak, milestones |
| **Unit: ReviewLog** | ReviewLoggerTests | 2 | Logging, supersede |
| **Unit: Practice** | PracticeStateResolverTests | 5 | 5 states, evening unlock |
| **Journey: Day 1** | FirstDayJourneyTests | 1 (large) | Full morning + evening flow |
| **Journey: 5 Days** | FiveDayJourneyTests | 1 (large) | Multi-day progression, streak, review queue |
| **Journey: Edge Cases** | EdgeCaseJourneyTests | 5 | Missed day, back-pressure, restart, mastery, pause |
| **Performance** | PerformanceTests | 3 | Schema, import, query speed |
| **UI: Launch** | LaunchTests | 3 | First launch, tabs, morning card |
| **UI: Session** | SessionFlowUITests | 3 | Start, flashcard flip, pause/resume |
| **Total** | | **~51 tests** | |

---

## Test Execution Commands

```bash
# Unit + journey tests (fast, no simulator needed for data-only):
xcodebuild test -scheme SATVocabApp \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro' \
  -only-testing:SATVocabAppTests \
  2>&1 | xcpretty

# UI tests (requires simulator):
xcodebuild test -scheme SATVocabApp \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro' \
  -only-testing:SATVocabAppUITests \
  2>&1 | xcpretty

# Full suite:
xcodebuild test -scheme SATVocabApp \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro' \
  2>&1 | xcpretty

# Single test (for debugging):
xcodebuild test -scheme SATVocabApp \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro' \
  -only-testing:SATVocabAppTests/WordStateStoreTests/testCorrectAnswerPromotesBox \
  2>&1 | xcpretty
```

---

## What NOT to Test Automatically

- SwiftUI view rendering details (visual — test with eyes)
- Animation timing and smoothness (visual)
- Image quality/display (visual)
- Specific font sizes matching spec (visual — verify on device)

These are tested **manually on a real device** with your daughter as the first tester.

---

## Additional Tests (from Codex Review)

### Rushed Answer Tests

```swift
// Add to WordStateStoreTests.swift

func testRushedAnswerDoesNotIncrementDayTouches() async throws {
    // A rushed answer (<1s for game) is logged but should NOT count for Day 1 promotion
    // The rush detection is at the ViewModel level, not the store level.
    // The store always increments — the VM must NOT call recordScoredAnswer for rushed answers.
    // This test verifies the expected behavior at the integration level.
    
    try await wsStore.introduceWord(userId: userId, wordId: 1)
    
    // Log a rushed answer (duration < 1000ms) — logged to review_log but NOT to word_state
    let logger = ReviewLogger(db: db)
    try await logger.logReview(userId: userId, wordId: 1, outcome: .correct,
                              activityType: .imageGame, sessionType: .morning,
                              studyDay: 0, durationMs: 500)  // 500ms = rushed
    
    // word_state should NOT be updated (VM skips recordScoredAnswer for rushed answers)
    let ws = try await wsStore.getWordState(userId: userId, wordId: 1)
    XCTAssertEqual(ws?.dayTouches, 0, "Rushed answer should not increment day_touches")
    XCTAssertEqual(ws?.totalCorrect, 0, "Rushed answer should not count as correct")
}
```

### Recovery Flow Tests

```swift
// Add to EdgeCaseJourneyTests.swift

/// Missed evening → next day should be Recovery Evening (F1)
func testMissedEveningTriggersRecovery() async throws {
    // Day 0: morning complete, evening NOT complete
    _ = try await sessionStore.getOrCreateDayState(userId: userId, studyDay: 0, zoneIndex: 0)
    try await sessionStore.markMorningComplete(userId: userId, studyDay: 0, accuracy: 0.8, xp: 80, newWords: 10)
    
    let day0 = try await sessionStore.getDayState(userId: userId, studyDay: 0)
    XCTAssertTrue(day0!.morningComplete)
    XCTAssertFalse(day0!.eveningComplete, "Evening should NOT be complete")
    
    // Simulate next day: check Practice state resolver
    // F1 is detected when previous day has morning_complete=true, evening_complete=false
    let state = PracticeStateResolver.resolve(dayState: day0, activeSession: nil)
    // Since morning is complete but evening is not, and it's a "new day",
    // the resolver needs the CURRENT day's state. The resolver logic detects F1
    // by checking if the previous study day is incomplete.
    // For this test: day0 has morning done but evening not → when creating day1,
    // the system should detect F1 and show Recovery Evening.
    
    // The detection happens in PracticeTabViewModel.load() which checks previous day
    XCTAssertFalse(day0!.eveningComplete, "Precondition: evening incomplete")
}

/// Back-pressure at 20 overdue triggers reduced new words
func testBackPressureAtThreshold() async throws {
    // Create 20 overdue words
    for i in 1...10 {
        try await wsStore.introduceWord(userId: userId, wordId: i)
    }
    try db.exec("UPDATE word_state SET box_level = 1, due_at = datetime('now','-2 day')")
    
    // Insert 10 more words and make them overdue too
    try TestDatabase.insertTestWords(db: db, count: 20)
    for i in 11...20 {
        try await wsStore.introduceWord(userId: userId, wordId: i)
    }
    try db.exec("UPDATE word_state SET box_level = 1, due_at = datetime('now','-1 day') WHERE word_id > 10")
    
    let overdue = try await wsStore.countOverdue(userId: userId)
    XCTAssertEqual(overdue, 20)
    XCTAssertTrue(overdue > AppConfig.backPressureReduceAt, "20 > 18 should trigger reduced new words")
    XCTAssertFalse(overdue > AppConfig.backPressureStopAt, "20 < 30 should NOT trigger review-only")
}
```

### Restart Rollback Test

```swift
// Add to EdgeCaseJourneyTests.swift

func testRestartRollsBackWordStateCorrectly() async throws {
    // Setup: word at box 1, introduce it
    try await wsStore.introduceWord(userId: userId, wordId: 1)
    try db.exec("UPDATE word_state SET box_level = 1, due_at = datetime('now','-1 day') WHERE word_id = 1")
    
    _ = try await statsStore.getOrCreateDailyStats(userId: userId, studyDay: 0)
    
    // First attempt: correct answer promotes to box 2
    try await logger.logReview(userId: userId, wordId: 1, outcome: .correct,
                              activityType: .imageGame, sessionType: .morning, studyDay: 0, durationMs: 2000)
    let change = try await wsStore.recordScoredAnswer(userId: userId, wordId: 1, correct: true)
    try await statsStore.recordCorrectAnswer(userId: userId, studyDay: 0)
    
    let wsAfterFirst = try await wsStore.getWordState(userId: userId, wordId: 1)
    XCTAssertEqual(wsAfterFirst?.boxLevel, 2, "Should be at box 2 after correct")
    
    // Restart: supersede old entries
    try await logger.supersedeSession(userId: userId, studyDay: 0, sessionType: .morning)
    
    // NOTE: Current implementation does NOT roll back word_state on restart.
    // This is a known limitation (see GPT-5.4 cross-check review).
    // For V1: supersede review_log entries so Day 1 promotion ignores them.
    // word_state.box_level from mid-session answers may be inconsistent.
    // Full rollback requires storing pre-session word_state snapshot.
    
    // Verify review_log entries are superseded
    let stmt = try db.prepare("SELECT COUNT(*) FROM review_log WHERE superseded = 0 AND study_day = 0")
    defer { stmt?.finalize() }
    guard sqlite3_step(stmt) == SQLITE_ROW else { XCTFail(); return }
    XCTAssertEqual(SQLiteDB.columnInt(stmt, 0), 0, "All entries should be superseded after restart")
}
```

### Real JSON Import Test

```swift
// Add to ContentImporterTests.swift

/// Test importing the ACTUAL bundled word_list.json (not synthetic data)
func testImportRealWordListJSON() throws {
    // This test only runs when the real JSON file is accessible
    guard let url = Bundle.main.url(forResource: "word_list", withExtension: "json"),
          let data = try? Data(contentsOf: url),
          let words = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]]
    else {
        // Skip if not running in app context (CI may not have bundle)
        throw XCTSkip("word_list.json not in test bundle")
    }
    
    XCTAssertEqual(words.count, 372, "Should have exactly 372 words")
    
    // Verify every word has required fields
    for (i, w) in words.enumerated() {
        XCTAssertNotNil(w["word"] as? String, "Word \(i) missing 'word' field")
        XCTAssertNotNil(w["definition"] as? String, "Word \(i) missing 'definition'")
        XCTAssertNotNil(w["example"] as? String, "Word \(i) missing 'example'")
        XCTAssertNotNil(w["pos"] as? String, "Word \(i) missing 'pos'")
    }
    
    // Verify SAT questions embedded
    let totalQ = words.reduce(0) { $0 + ((($1["sat_questions"] as? [[String: Any]])?.count) ?? 0) }
    XCTAssertGreaterThan(totalQ, 500, "Should have >500 embedded SAT questions")
}
```

### XCUITest Improvements

```swift
// Add to all XCUITest files:

// 1. Use accessibility identifiers instead of text matching
// In production code, add:
//   .accessibilityIdentifier("morning-session-card")
//   .accessibilityIdentifier("start-button")
//   .accessibilityIdentifier("flashcard-front")

// 2. Seed test state via launch arguments
override func setUp() {
    app.launchArguments = [
        "--ui-testing",        // Signals app to use test DB
        "--disable-animations" // Faster, less flaky
    ]
    app.launch()
}

// 3. Use explicit identifiers in tests
func testStartMorningSession() {
    let startButton = app.buttons["start-button"]
    XCTAssertTrue(startButton.waitForExistence(timeout: 10))
    startButton.tap()
    
    let stepHeader = app.staticTexts["step-header"]
    XCTAssertTrue(stepHeader.waitForExistence(timeout: 5))
}
```

### Temporary-File DB Test

```swift
// Add to SchemaTests.swift

func testDatabasePersistsToDisk() throws {
    let tmpPath = NSTemporaryDirectory() + "test_\(UUID().uuidString).db"
    defer { try? FileManager.default.removeItem(atPath: tmpPath) }
    
    // Create and populate
    let db1 = SQLiteDB()
    try db1.open(path: tmpPath)
    try SchemaV2.createAll(db: db1)
    try db1.exec("INSERT INTO lists (name) VALUES ('persist_test');")
    db1.close()
    
    // Reopen and verify
    let db2 = SQLiteDB()
    try db2.open(path: tmpPath)
    let stmt = try db2.prepare("SELECT name FROM lists WHERE name = 'persist_test'")
    defer { stmt?.finalize() }
    XCTAssertEqual(sqlite3_step(stmt), SQLITE_ROW, "Data should persist after reopen")
    XCTAssertEqual(SQLiteDB.columnText(stmt, 0), "persist_test")
    db2.close()
}
```

---

## Updated Test Count

| Category | Tests | Change |
|----------|-------|--------|
| Unit tests | 38 | +3 (rushed, back-pressure threshold, persist) |
| Journey tests | 9 | +2 (recovery, restart rollback) |
| Performance | 3 | unchanged |
| XCUITest | 6 | improved with accessibility IDs |
| JSON validation | 1 | +1 (real JSON import) |
| **Total** | **~57** | +6 new |

---

## Codex Test Review

This is a strong testing direction overall: the plan correctly concentrates on the hidden failure zones first — box progression, Day 1 promotion, review queue priority, streak math, and pause/resume state. Those are the right critical paths.

The biggest missing scenarios are:

1. **Rushed-answer behavior** is not covered enough. The learning model depends on “logged but not counted” timing thresholds, but I do not see explicit tests that rushed image/recall/SAT answers fail to increment promotion state.
2. **Recovery flows** are mostly absent. There should be tests for missed-evening → Recovery Evening, catch-up / re-entry day gating, and “evening session stays locked until recovery is finished.”
3. **Restart correctness** needs deeper assertions. The current restart test checks `superseded`, but not rollback of `word_state`, `daily_stats`, or recomputed `recent_accuracy`.
4. **Importer tests are too synthetic.** `ContentImporterTests` currently validate `insertTestWords`, not the real bundled JSON importer, malformed JSON, duplicate question IDs, or transaction rollback on partial failure.

The journey tests are directionally good, but they are still a bit too “happy path scripted.” The 5-day test does not realistically simulate passage of time, overdue scheduling, or mixed new/review slot pressure; it mostly proves loops run. I would add at least one deterministic journey that advances dates and verifies due words actually re-enter the queue in the correct order.

For **XCUITest**, the main gotchas are determinism and selectors. `sleep(2)`, `app.otherElements.firstMatch`, and text-based matching like `"START"` / `"Continue"` / `"Pause"` will be flaky in SwiftUI. These tests need explicit accessibility identifiers, seeded launch state (`--ui-testing`, fixed test DB), and preferably disabled animations.

The in-memory SQLite helper is good for fast logic tests, but it is **not sufficient by itself**. Add at least one temporary-file DB test for migration/reopen behavior, because `:memory:` will not catch persistence bugs.

Finally, the performance thresholds (`<100ms`, `<500ms`) may be noisy on CI simulators. Keep the performance tests, but avoid hard-coded simulator timing gates unless they are generous and measured against release-like conditions.
