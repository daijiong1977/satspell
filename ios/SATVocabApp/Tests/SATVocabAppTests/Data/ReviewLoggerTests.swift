import XCTest
import SQLite3
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

    func testConcurrentWritesFromMultipleActors() async throws {
        // Simulates the real app scenario: multiple actor instances writing to the same DB
        // This is what happens when recordAnswer creates new ReviewLogger/WordStateStore per call
        let logger1 = ReviewLogger(db: db)
        let logger2 = ReviewLogger(db: db)
        let wsStore = WordStateStore(db: db)

        // Introduce word first
        try await wsStore.introduceWord(userId: userId, wordId: 1)

        // Fire concurrent writes from different actor instances (like in the real app)
        async let write1: Void = logger1.logReview(
            userId: userId, wordId: 1, outcome: .correct,
            activityType: .imageGame, sessionType: .morning,
            studyDay: 0, durationMs: 1000)
        async let write2: Void = logger2.logReview(
            userId: userId, wordId: 2, outcome: .incorrect,
            activityType: .imageGame, sessionType: .morning,
            studyDay: 0, durationMs: 1200)
        async let write3: BoxChange = wsStore.recordScoredAnswer(userId: userId, wordId: 1, correct: true)

        // All three should succeed without SQLITE_BUSY
        try await write1
        try await write2
        _ = try await write3

        let stmt = try db.prepare("SELECT COUNT(*) FROM review_log")
        defer { stmt?.finalize() }
        guard sqlite3_step(stmt) == SQLITE_ROW else { XCTFail(); return }
        XCTAssertEqual(SQLiteDB.columnInt(stmt, 0), 2, "Both review_log writes should succeed")
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
