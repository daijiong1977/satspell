import XCTest
import SQLite3
@testable import SATVocabApp

/// Integration test that replicates the exact flow of SessionFlowViewModel.recordAnswer
/// to catch issues that unit tests on individual stores might miss.
final class RecordAnswerIntegrationTests: XCTestCase {
    var db: SQLiteDB!
    var userId: String!

    override func setUpWithError() throws {
        db = try TestDatabase.create(withWords: true)
        userId = try TestDatabase.createTestUser(db: db)
    }

    /// Replicates SessionFlowViewModel.recordAnswer exactly
    func testRecordAnswerFlow() async throws {
        // Create daily_stats row (normally done in loadWords)
        let statsStore = StatsStore(db: db)
        _ = try await statsStore.getOrCreateDailyStats(userId: userId, studyDay: 0)

        // Simulate what recordAnswer does
        let reviewLogger = ReviewLogger(db: db)
        let wsStore = WordStateStore(db: db)

        // 1. Write review_log entry
        let outcome: ReviewOutcome = .correct
        try await reviewLogger.logReview(
            userId: userId, wordId: 1, outcome: outcome,
            activityType: .imageGame, sessionType: .morning,
            studyDay: 0, durationMs: 0)

        // 2. Update word_state (box progression)
        let boxChange = try await wsStore.recordScoredAnswer(userId: userId, wordId: 1, correct: true)

        // 3. Update daily_stats
        try await statsStore.recordCorrectAnswer(userId: userId, studyDay: 0)

        // Verify review_log
        let rlStmt = try db.prepare("SELECT COUNT(*) FROM review_log WHERE word_id = 1")
        defer { rlStmt?.finalize() }
        guard sqlite3_step(rlStmt) == SQLITE_ROW else { XCTFail("No review_log rows"); return }
        XCTAssertEqual(SQLiteDB.columnInt(rlStmt, 0), 1, "Should have 1 review_log entry")

        // Verify word_state
        let wsStmt = try db.prepare("SELECT box_level, intro_stage FROM word_state WHERE word_id = 1")
        defer { wsStmt?.finalize() }
        guard sqlite3_step(wsStmt) == SQLITE_ROW else { XCTFail("No word_state rows"); return }
        let boxLevel = SQLiteDB.columnInt(wsStmt, 0)
        let introStage = SQLiteDB.columnInt(wsStmt, 1)
        // First answer introduces the word (box 0, intro_stage 1), returns .none
        XCTAssertEqual(boxLevel, 0)
        XCTAssertEqual(introStage, 1)
        XCTAssert(boxChange == .none, "First scored answer just introduces; returns .none")

        // Verify daily_stats
        let dsStmt = try db.prepare("SELECT correct_count, total_count FROM daily_stats WHERE study_day = 0")
        defer { dsStmt?.finalize() }
        guard sqlite3_step(dsStmt) == SQLITE_ROW else { XCTFail("No daily_stats rows"); return }
        XCTAssertEqual(SQLiteDB.columnInt(dsStmt, 0), 1)
        XCTAssertEqual(SQLiteDB.columnInt(dsStmt, 1), 1)
    }

    /// Test multiple sequential answers (like rapid gameplay)
    func testMultipleSequentialAnswers() async throws {
        let statsStore = StatsStore(db: db)
        _ = try await statsStore.getOrCreateDailyStats(userId: userId, studyDay: 0)

        // Answer 5 words sequentially (exactly like the real app does)
        for wordId in 1...5 {
            let reviewLogger = ReviewLogger(db: db)
            let wsStore = WordStateStore(db: db)

            try await reviewLogger.logReview(
                userId: userId, wordId: wordId, outcome: .correct,
                activityType: .imageGame, sessionType: .morning,
                studyDay: 0, durationMs: 0)

            _ = try await wsStore.recordScoredAnswer(userId: userId, wordId: wordId, correct: true)

            try await statsStore.recordCorrectAnswer(userId: userId, studyDay: 0)
        }

        // Verify counts
        let rlStmt = try db.prepare("SELECT COUNT(*) FROM review_log")
        defer { rlStmt?.finalize() }
        guard sqlite3_step(rlStmt) == SQLITE_ROW else { XCTFail(); return }
        XCTAssertEqual(SQLiteDB.columnInt(rlStmt, 0), 5, "Should have 5 review_log entries")

        let wsStmt = try db.prepare("SELECT COUNT(*) FROM word_state")
        defer { wsStmt?.finalize() }
        guard sqlite3_step(wsStmt) == SQLITE_ROW else { XCTFail(); return }
        XCTAssertEqual(SQLiteDB.columnInt(wsStmt, 0), 5, "Should have 5 word_state entries")
    }

    /// Test concurrent answers (simulates MainActor re-entrancy creating parallel Tasks)
    func testConcurrentAnswerTasks() async throws {
        let statsStore = StatsStore(db: db)
        _ = try await statsStore.getOrCreateDailyStats(userId: userId, studyDay: 0)

        // Fire multiple answer tasks concurrently (simulates rapid tapping with await suspension)
        try await withThrowingTaskGroup(of: Void.self) { group in
            for wordId in 1...5 {
                group.addTask {
                    let reviewLogger = ReviewLogger(db: self.db)
                    let wsStore = WordStateStore(db: self.db)

                    try await reviewLogger.logReview(
                        userId: self.userId, wordId: wordId, outcome: .correct,
                        activityType: .imageGame, sessionType: .morning,
                        studyDay: 0, durationMs: 0)

                    _ = try await wsStore.recordScoredAnswer(userId: self.userId, wordId: wordId, correct: true)
                }
            }
            try await group.waitForAll()
        }

        // Verify all writes succeeded
        let rlStmt = try db.prepare("SELECT COUNT(*) FROM review_log")
        defer { rlStmt?.finalize() }
        guard sqlite3_step(rlStmt) == SQLITE_ROW else { XCTFail(); return }
        XCTAssertEqual(SQLiteDB.columnInt(rlStmt, 0), 5, "All 5 concurrent review_log writes should succeed")

        let wsStmt = try db.prepare("SELECT COUNT(*) FROM word_state")
        defer { wsStmt?.finalize() }
        guard sqlite3_step(wsStmt) == SQLITE_ROW else { XCTFail(); return }
        XCTAssertEqual(SQLiteDB.columnInt(wsStmt, 0), 5, "All 5 concurrent word_state writes should succeed")
    }
}

// BoxChange needs Equatable for testing
extension BoxChange: Equatable {
    public static func == (lhs: BoxChange, rhs: BoxChange) -> Bool {
        switch (lhs, rhs) {
        case (.none, .none): return true
        case (.promoted(let lf, let lt), .promoted(let rf, let rt)): return lf == rf && lt == rt
        case (.demoted(let lf, let lt), .demoted(let rf, let rt)): return lf == rf && lt == rt
        default: return false
        }
    }
}
