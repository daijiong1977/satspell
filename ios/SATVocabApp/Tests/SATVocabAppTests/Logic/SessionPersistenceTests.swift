import XCTest
import SQLite3
@testable import SATVocabApp

// MARK: - Session State Persistence Tests
//
// These integration tests verify that session state survives SQLite round-trips.
// Target bugs:
//   - Session not saving position (step/item index lost)
//   - saveProgress marks is_paused=1 but resume clears it without restoring position
//   - showAgainIds JSON encoding/decoding corruption
//   - Completed session still returned as "active"

final class SessionPersistenceTests: XCTestCase {

    private var db: SQLiteDB!
    private var userId: String!

    override func setUpWithError() throws {
        db = try TestDatabase.create(withWords: true)
        userId = try TestDatabase.createTestUser(db: db)
    }

    override func tearDownWithError() throws {
        db = nil
        userId = nil
    }

    // MARK: - Helper: Direct SQL session operations (bypasses the actor)

    private func insertSession(
        sessionType: String = "morning",
        studyDay: Int = 0,
        stepIndex: Int = 0,
        itemIndex: Int = 0,
        isPaused: Int = 0,
        showAgainIds: String = "[]",
        requeuedIds: String = "[]",
        completedAt: String? = nil
    ) throws {
        let sql = """
        INSERT INTO session_state(user_id, session_type, study_day, step_index, item_index,
            is_paused, show_again_ids, requeued_ids, started_at, paused_at, completed_at)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, datetime('now'), NULL, ?);
        """
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }
        try SQLiteDB.bind(stmt, 1, userId!)
        try SQLiteDB.bind(stmt, 2, sessionType)
        try SQLiteDB.bind(stmt, 3, studyDay)
        try SQLiteDB.bind(stmt, 4, stepIndex)
        try SQLiteDB.bind(stmt, 5, itemIndex)
        try SQLiteDB.bind(stmt, 6, isPaused)
        try SQLiteDB.bind(stmt, 7, showAgainIds)
        try SQLiteDB.bind(stmt, 8, requeuedIds)
        try SQLiteDB.bind(stmt, 9, completedAt)
        XCTAssertEqual(sqlite3_step(stmt), SQLITE_DONE)
    }

    private func fetchSession(sessionType: String = "morning", studyDay: Int = 0) throws -> (stepIndex: Int, itemIndex: Int, isPaused: Int, showAgainIds: String, completedAt: String?)? {
        let sql = """
        SELECT step_index, item_index, is_paused, show_again_ids, completed_at
        FROM session_state
        WHERE user_id = ? AND study_day = ? AND session_type = ?;
        """
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }
        try SQLiteDB.bind(stmt, 1, userId!)
        try SQLiteDB.bind(stmt, 2, studyDay)
        try SQLiteDB.bind(stmt, 3, sessionType)
        if sqlite3_step(stmt) == SQLITE_ROW {
            return (
                stepIndex: SQLiteDB.columnInt(stmt, 0),
                itemIndex: SQLiteDB.columnInt(stmt, 1),
                isPaused: SQLiteDB.columnInt(stmt, 2),
                showAgainIds: SQLiteDB.columnText(stmt, 3) ?? "[]",
                completedAt: SQLiteDB.columnText(stmt, 4)
            )
        }
        return nil
    }

    private func fetchActiveSession() throws -> (sessionType: String, stepIndex: Int, itemIndex: Int)? {
        let sql = """
        SELECT session_type, step_index, item_index
        FROM session_state
        WHERE user_id = ? AND is_paused = 1 AND completed_at IS NULL
        LIMIT 1;
        """
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }
        try SQLiteDB.bind(stmt, 1, userId!)
        if sqlite3_step(stmt) == SQLITE_ROW {
            return (
                sessionType: SQLiteDB.columnText(stmt, 0) ?? "",
                stepIndex: SQLiteDB.columnInt(stmt, 1),
                itemIndex: SQLiteDB.columnInt(stmt, 2)
            )
        }
        return nil
    }

    // MARK: - Tests

    /// BUG: saveProgress must persist step and item indices so a hard kill
    /// restores the user to the correct word, not the beginning.
    func testSaveProgress_persistsStepAndItemIndex() throws {
        try insertSession(sessionType: "morning", studyDay: 0, stepIndex: 0, itemIndex: 0, isPaused: 0)

        // Simulate saveProgress SQL
        let sql = """
        UPDATE session_state
        SET step_index = ?, item_index = ?, show_again_ids = ?, is_paused = 1
        WHERE user_id = ? AND study_day = ? AND session_type = ?;
        """
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }
        try SQLiteDB.bind(stmt, 1, 2)    // step 2
        try SQLiteDB.bind(stmt, 2, 7)    // item 7
        try SQLiteDB.bind(stmt, 3, "[3,5]")
        try SQLiteDB.bind(stmt, 4, userId!)
        try SQLiteDB.bind(stmt, 5, 0)
        try SQLiteDB.bind(stmt, 6, "morning")
        XCTAssertEqual(sqlite3_step(stmt), SQLITE_DONE)

        // Verify
        let result = try XCTUnwrap(fetchSession())
        XCTAssertEqual(result.stepIndex, 2, "Step index must be persisted")
        XCTAssertEqual(result.itemIndex, 7, "Item index must be persisted")
        XCTAssertEqual(result.showAgainIds, "[3,5]", "showAgainIds JSON must round-trip")
        XCTAssertEqual(result.isPaused, 1, "saveProgress should mark as paused")
    }

    /// BUG: After completing a session, getActiveSession must NOT return it.
    func testCompletedSession_notReturnedAsActive() throws {
        try insertSession(sessionType: "morning", studyDay: 0, isPaused: 1)

        // Mark complete
        let sql = """
        UPDATE session_state
        SET completed_at = datetime('now'), is_paused = 0
        WHERE user_id = ? AND study_day = ? AND session_type = ?;
        """
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }
        try SQLiteDB.bind(stmt, 1, userId!)
        try SQLiteDB.bind(stmt, 2, 0)
        try SQLiteDB.bind(stmt, 3, "morning")
        XCTAssertEqual(sqlite3_step(stmt), SQLITE_DONE)

        // Active session query should return nil
        let active = try fetchActiveSession()
        XCTAssertNil(active, "Completed session must not be returned as active")
    }

    /// BUG: Pause then resume must restore exact position.
    func testPauseThenResume_restoresPosition() throws {
        try insertSession(sessionType: "evening", studyDay: 1, stepIndex: 0, itemIndex: 0, isPaused: 0)

        // Pause at step 3, item 5
        let pauseSQL = """
        UPDATE session_state
        SET is_paused = 1, paused_at = datetime('now'), step_index = ?, item_index = ?,
            show_again_ids = ?, requeued_ids = ?
        WHERE user_id = ? AND study_day = ? AND session_type = ?;
        """
        let s1 = try db.prepare(pauseSQL)
        defer { s1?.finalize() }
        try SQLiteDB.bind(s1, 1, 3)
        try SQLiteDB.bind(s1, 2, 5)
        try SQLiteDB.bind(s1, 3, "[1,2,3]")
        try SQLiteDB.bind(s1, 4, "[4]")
        try SQLiteDB.bind(s1, 5, userId!)
        try SQLiteDB.bind(s1, 6, 1)
        try SQLiteDB.bind(s1, 7, "evening")
        XCTAssertEqual(sqlite3_step(s1), SQLITE_DONE)

        // Verify active session returned
        let active = try XCTUnwrap(fetchActiveSession())
        XCTAssertEqual(active.sessionType, "evening")
        XCTAssertEqual(active.stepIndex, 3, "Paused step index must be preserved")
        XCTAssertEqual(active.itemIndex, 5, "Paused item index must be preserved")

        // Resume
        let resumeSQL = """
        UPDATE session_state
        SET is_paused = 0
        WHERE user_id = ? AND study_day = ? AND session_type = ?;
        """
        let s2 = try db.prepare(resumeSQL)
        defer { s2?.finalize() }
        try SQLiteDB.bind(s2, 1, userId!)
        try SQLiteDB.bind(s2, 2, 1)
        try SQLiteDB.bind(s2, 3, "evening")
        XCTAssertEqual(sqlite3_step(s2), SQLITE_DONE)

        // After resume, step/item must still be there
        let result = try XCTUnwrap(fetchSession(sessionType: "evening", studyDay: 1))
        XCTAssertEqual(result.stepIndex, 3, "Step index must survive resume")
        XCTAssertEqual(result.itemIndex, 5, "Item index must survive resume")
        XCTAssertEqual(result.showAgainIds, "[1,2,3]", "showAgainIds must survive resume")
    }

    /// Test that discarding a session removes it entirely.
    func testDiscardSession_removesRecord() throws {
        try insertSession(sessionType: "morning", studyDay: 0, isPaused: 1)

        let sql = """
        DELETE FROM session_state
        WHERE user_id = ? AND study_day = ? AND session_type = ?;
        """
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }
        try SQLiteDB.bind(stmt, 1, userId!)
        try SQLiteDB.bind(stmt, 2, 0)
        try SQLiteDB.bind(stmt, 3, "morning")
        XCTAssertEqual(sqlite3_step(stmt), SQLITE_DONE)

        let result = try fetchSession()
        XCTAssertNil(result, "Discarded session should be fully removed")
    }

    /// Test that showAgainIds JSON handles edge cases.
    func testShowAgainIds_emptyArray() throws {
        try insertSession(sessionType: "morning", studyDay: 0, showAgainIds: "[]")
        let result = try XCTUnwrap(fetchSession())
        XCTAssertEqual(result.showAgainIds, "[]")
    }

    func testShowAgainIds_largeArray() throws {
        let ids = (1...50).map { String($0) }.joined(separator: ",")
        let json = "[\(ids)]"
        try insertSession(sessionType: "morning", studyDay: 0, showAgainIds: json)
        let result = try XCTUnwrap(fetchSession())
        XCTAssertEqual(result.showAgainIds, json, "Large arrays must survive round-trip")
    }

    // MARK: - Day State Persistence

    func testMarkMorningComplete_setsTimestamp() throws {
        // Insert day_state row (already done by createTestUser for day 0)
        let sql = """
        UPDATE day_state
        SET morning_complete = 1, morning_complete_at = datetime('now'),
            morning_accuracy = 0.85, morning_xp = 120, new_words_morning = 11
        WHERE user_id = ? AND study_day = 0;
        """
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }
        try SQLiteDB.bind(stmt, 1, userId!)
        XCTAssertEqual(sqlite3_step(stmt), SQLITE_DONE)

        // Verify
        let fetchSQL = """
        SELECT morning_complete, morning_complete_at, morning_accuracy, morning_xp
        FROM day_state WHERE user_id = ? AND study_day = 0;
        """
        let s2 = try db.prepare(fetchSQL)
        defer { s2?.finalize() }
        try SQLiteDB.bind(s2, 1, userId!)
        XCTAssertEqual(sqlite3_step(s2), SQLITE_ROW)
        XCTAssertEqual(SQLiteDB.columnInt(s2, 0), 1, "morning_complete should be 1")
        XCTAssertNotNil(SQLiteDB.columnText(s2, 1), "morning_complete_at timestamp must not be nil")
    }

    func testBothSessionsComplete_dayStateReflects() throws {
        let sql = """
        UPDATE day_state
        SET morning_complete = 1, morning_complete_at = datetime('now', '-4 hours'),
            evening_complete = 1, evening_complete_at = datetime('now')
        WHERE user_id = ? AND study_day = 0;
        """
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }
        try SQLiteDB.bind(stmt, 1, userId!)
        XCTAssertEqual(sqlite3_step(stmt), SQLITE_DONE)

        let fetchSQL = """
        SELECT morning_complete, evening_complete FROM day_state
        WHERE user_id = ? AND study_day = 0;
        """
        let s2 = try db.prepare(fetchSQL)
        defer { s2?.finalize() }
        try SQLiteDB.bind(s2, 1, userId!)
        XCTAssertEqual(sqlite3_step(s2), SQLITE_ROW)
        XCTAssertEqual(SQLiteDB.columnInt(s2, 0), 1)
        XCTAssertEqual(SQLiteDB.columnInt(s2, 1), 1)
    }

    // MARK: - Session Uniqueness Constraint

    /// The UNIQUE(user_id, study_day, session_type) constraint means
    /// createSession uses INSERT OR REPLACE, which should overwrite old rows.
    func testCreateSession_replacesExistingForSameDay() throws {
        try insertSession(sessionType: "morning", studyDay: 0, stepIndex: 5, itemIndex: 8, isPaused: 1)

        // INSERT OR REPLACE with same key
        let sql = """
        INSERT OR REPLACE INTO session_state(user_id, session_type, study_day, step_index, item_index,
            is_paused, show_again_ids, requeued_ids, started_at, paused_at, completed_at)
        VALUES (?, 'morning', 0, 0, 0, 0, '[]', '[]', datetime('now'), NULL, NULL);
        """
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }
        try SQLiteDB.bind(stmt, 1, userId!)
        XCTAssertEqual(sqlite3_step(stmt), SQLITE_DONE)

        let result = try XCTUnwrap(fetchSession())
        XCTAssertEqual(result.stepIndex, 0, "New session should reset step to 0")
        XCTAssertEqual(result.itemIndex, 0, "New session should reset item to 0")
        XCTAssertEqual(result.isPaused, 0, "New session should not be paused")
    }
}
