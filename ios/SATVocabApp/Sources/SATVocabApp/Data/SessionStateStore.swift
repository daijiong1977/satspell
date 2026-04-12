import Foundation
import SQLite3

actor SessionStateStore {
    static let shared = SessionStateStore()

    private var db: SQLiteDB { DataManager.shared.db }

    private let iso = ISO8601DateFormatter()

    private init() {}

    // MARK: - Day State

    func getCurrentDayState(userId: String) throws -> DayState? {
        let db = self.db
        let sql = """
        SELECT id, user_id, study_day, zone_index, morning_complete, evening_complete,
               morning_complete_at, evening_complete_at, new_words_morning, new_words_evening,
               morning_accuracy, evening_accuracy, morning_xp, evening_xp,
               is_recovery_day, is_review_only_day
        FROM day_state
        WHERE user_id = ?
        ORDER BY study_day DESC
        LIMIT 1;
        """
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }
        try SQLiteDB.bind(stmt, 1, userId)
        if sqlite3_step(stmt) == SQLITE_ROW {
            return parseDayState(stmt)
        }
        return nil
    }

    func getDayState(userId: String, studyDay: Int) throws -> DayState? {
        let db = self.db
        let sql = """
        SELECT id, user_id, study_day, zone_index, morning_complete, evening_complete,
               morning_complete_at, evening_complete_at, new_words_morning, new_words_evening,
               morning_accuracy, evening_accuracy, morning_xp, evening_xp,
               is_recovery_day, is_review_only_day
        FROM day_state
        WHERE user_id = ? AND study_day = ?
        LIMIT 1;
        """
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }
        try SQLiteDB.bind(stmt, 1, userId)
        try SQLiteDB.bind(stmt, 2, studyDay)
        if sqlite3_step(stmt) == SQLITE_ROW {
            return parseDayState(stmt)
        }
        return nil
    }

    func getOrCreateDayState(userId: String, studyDay: Int, zoneIndex: Int) throws -> DayState {
        let db = self.db
        let insertSQL = """
        INSERT OR IGNORE INTO day_state(user_id, study_day, zone_index)
        VALUES (?, ?, ?);
        """
        let s1 = try db.prepare(insertSQL)
        defer { s1?.finalize() }
        try SQLiteDB.bind(s1, 1, userId)
        try SQLiteDB.bind(s1, 2, studyDay)
        try SQLiteDB.bind(s1, 3, zoneIndex)
        if sqlite3_step(s1) != SQLITE_DONE {
            throw SQLiteError.stepFailed(message: db.errorMessage())
        }

        guard let state = try getDayState(userId: userId, studyDay: studyDay) else {
            throw SQLiteError.stepFailed(message: "Failed to fetch day_state after insert")
        }
        return state
    }

    func markMorningComplete(userId: String, studyDay: Int, accuracy: Double, xp: Int, newWords: Int) throws {
        let db = self.db
        let sql = """
        UPDATE day_state
        SET morning_complete = 1,
            morning_complete_at = ?,
            morning_accuracy = ?,
            morning_xp = ?,
            new_words_morning = ?
        WHERE user_id = ? AND study_day = ?;
        """
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }
        let now = iso.string(from: Date())
        try SQLiteDB.bind(stmt, 1, now)
        try SQLiteDB.bind(stmt, 2, accuracy)
        try SQLiteDB.bind(stmt, 3, xp)
        try SQLiteDB.bind(stmt, 4, newWords)
        try SQLiteDB.bind(stmt, 5, userId)
        try SQLiteDB.bind(stmt, 6, studyDay)
        if sqlite3_step(stmt) != SQLITE_DONE {
            throw SQLiteError.stepFailed(message: db.errorMessage())
        }
    }

    func markEveningComplete(userId: String, studyDay: Int, accuracy: Double, xp: Int, newWords: Int) throws {
        let db = self.db
        let sql = """
        UPDATE day_state
        SET evening_complete = 1,
            evening_complete_at = ?,
            evening_accuracy = ?,
            evening_xp = ?,
            new_words_evening = ?
        WHERE user_id = ? AND study_day = ?;
        """
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }
        let now = iso.string(from: Date())
        try SQLiteDB.bind(stmt, 1, now)
        try SQLiteDB.bind(stmt, 2, accuracy)
        try SQLiteDB.bind(stmt, 3, xp)
        try SQLiteDB.bind(stmt, 4, newWords)
        try SQLiteDB.bind(stmt, 5, userId)
        try SQLiteDB.bind(stmt, 6, studyDay)
        if sqlite3_step(stmt) != SQLITE_DONE {
            throw SQLiteError.stepFailed(message: db.errorMessage())
        }
    }

    // MARK: - Session State

    func getActiveSession(userId: String) throws -> SessionState? {
        let db = self.db
        let sql = """
        SELECT id, user_id, session_type, study_day, step_index, item_index,
               is_paused, show_again_ids, requeued_ids, started_at, paused_at, completed_at
        FROM session_state
        WHERE user_id = ? AND is_paused = 1 AND completed_at IS NULL
        LIMIT 1;
        """
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }
        try SQLiteDB.bind(stmt, 1, userId)
        if sqlite3_step(stmt) == SQLITE_ROW {
            return parseSessionState(stmt)
        }
        return nil
    }

    func createSession(userId: String, sessionType: SessionType, studyDay: Int) throws -> SessionState {
        let db = self.db
        let sql = """
        INSERT OR REPLACE INTO session_state(user_id, session_type, study_day, step_index, item_index,
            is_paused, show_again_ids, requeued_ids, started_at, paused_at, completed_at)
        VALUES (?, ?, ?, 0, 0, 0, '[]', '[]', ?, NULL, NULL);
        """
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }
        let now = iso.string(from: Date())
        try SQLiteDB.bind(stmt, 1, userId)
        try SQLiteDB.bind(stmt, 2, sessionType.rawValue)
        try SQLiteDB.bind(stmt, 3, studyDay)
        try SQLiteDB.bind(stmt, 4, now)
        if sqlite3_step(stmt) != SQLITE_DONE {
            throw SQLiteError.stepFailed(message: db.errorMessage())
        }

        let rowId = Int(db.lastInsertRowId())
        return SessionState(
            id: rowId,
            userId: userId,
            sessionType: sessionType,
            studyDay: studyDay,
            stepIndex: 0,
            itemIndex: 0,
            isPaused: false,
            showAgainIds: [],
            requeuedIds: [],
            startedAt: Date(),
            pausedAt: nil,
            completedAt: nil
        )
    }

    func pauseSession(userId: String, studyDay: Int, sessionType: SessionType,
                       stepIndex: Int, itemIndex: Int,
                       showAgainIds: [Int], requeuedIds: [Int]) throws {
        let db = self.db
        let sql = """
        UPDATE session_state
        SET is_paused = 1,
            paused_at = ?,
            step_index = ?,
            item_index = ?,
            show_again_ids = ?,
            requeued_ids = ?
        WHERE user_id = ? AND study_day = ? AND session_type = ?;
        """
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }
        let now = iso.string(from: Date())
        let showJSON = try encodeIntArray(showAgainIds)
        let reqJSON = try encodeIntArray(requeuedIds)
        try SQLiteDB.bind(stmt, 1, now)
        try SQLiteDB.bind(stmt, 2, stepIndex)
        try SQLiteDB.bind(stmt, 3, itemIndex)
        try SQLiteDB.bind(stmt, 4, showJSON)
        try SQLiteDB.bind(stmt, 5, reqJSON)
        try SQLiteDB.bind(stmt, 6, userId)
        try SQLiteDB.bind(stmt, 7, studyDay)
        try SQLiteDB.bind(stmt, 8, sessionType.rawValue)
        if sqlite3_step(stmt) != SQLITE_DONE {
            throw SQLiteError.stepFailed(message: db.errorMessage())
        }
    }

    func resumeSession(userId: String, studyDay: Int, sessionType: SessionType) throws {
        let db = self.db
        let sql = """
        UPDATE session_state
        SET is_paused = 0
        WHERE user_id = ? AND study_day = ? AND session_type = ?;
        """
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }
        try SQLiteDB.bind(stmt, 1, userId)
        try SQLiteDB.bind(stmt, 2, studyDay)
        try SQLiteDB.bind(stmt, 3, sessionType.rawValue)
        if sqlite3_step(stmt) != SQLITE_DONE {
            throw SQLiteError.stepFailed(message: db.errorMessage())
        }
    }

    func completeSession(userId: String, studyDay: Int, sessionType: SessionType) throws {
        let db = self.db
        let sql = """
        UPDATE session_state
        SET completed_at = ?, is_paused = 0
        WHERE user_id = ? AND study_day = ? AND session_type = ?;
        """
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }
        let now = iso.string(from: Date())
        try SQLiteDB.bind(stmt, 1, now)
        try SQLiteDB.bind(stmt, 2, userId)
        try SQLiteDB.bind(stmt, 3, studyDay)
        try SQLiteDB.bind(stmt, 4, sessionType.rawValue)
        if sqlite3_step(stmt) != SQLITE_DONE {
            throw SQLiteError.stepFailed(message: db.errorMessage())
        }
    }

    // MARK: - Private Helpers

    private func parseDayState(_ stmt: OpaquePointer?) -> DayState {
        DayState(
            id: SQLiteDB.columnInt(stmt, 0),
            userId: SQLiteDB.columnText(stmt, 1) ?? "",
            studyDay: SQLiteDB.columnInt(stmt, 2),
            zoneIndex: SQLiteDB.columnInt(stmt, 3),
            morningComplete: SQLiteDB.columnInt(stmt, 4) != 0,
            eveningComplete: SQLiteDB.columnInt(stmt, 5) != 0,
            morningCompleteAt: SQLiteDB.columnText(stmt, 6).flatMap { iso.date(from: $0) },
            eveningCompleteAt: SQLiteDB.columnText(stmt, 7).flatMap { iso.date(from: $0) },
            newWordsMorning: SQLiteDB.columnInt(stmt, 8),
            newWordsEvening: SQLiteDB.columnInt(stmt, 9),
            morningAccuracy: SQLiteDB.columnDouble(stmt, 10),
            eveningAccuracy: SQLiteDB.columnDouble(stmt, 11),
            morningXP: SQLiteDB.columnInt(stmt, 12),
            eveningXP: SQLiteDB.columnInt(stmt, 13),
            isRecoveryDay: SQLiteDB.columnInt(stmt, 14) != 0,
            isReviewOnlyDay: SQLiteDB.columnInt(stmt, 15) != 0
        )
    }

    private func parseSessionState(_ stmt: OpaquePointer?) -> SessionState {
        let showAgainJSON = SQLiteDB.columnText(stmt, 7) ?? "[]"
        let requeuedJSON = SQLiteDB.columnText(stmt, 8) ?? "[]"
        let showAgain = (try? decodeIntArray(showAgainJSON)) ?? []
        let requeued = (try? decodeIntArray(requeuedJSON)) ?? []

        return SessionState(
            id: SQLiteDB.columnInt(stmt, 0),
            userId: SQLiteDB.columnText(stmt, 1) ?? "",
            sessionType: SessionType(rawValue: SQLiteDB.columnText(stmt, 2) ?? "morning") ?? .morning,
            studyDay: SQLiteDB.columnInt(stmt, 3),
            stepIndex: SQLiteDB.columnInt(stmt, 4),
            itemIndex: SQLiteDB.columnInt(stmt, 5),
            isPaused: SQLiteDB.columnInt(stmt, 6) != 0,
            showAgainIds: showAgain,
            requeuedIds: requeued,
            startedAt: SQLiteDB.columnText(stmt, 9).flatMap { iso.date(from: $0) },
            pausedAt: SQLiteDB.columnText(stmt, 10).flatMap { iso.date(from: $0) },
            completedAt: SQLiteDB.columnText(stmt, 11).flatMap { iso.date(from: $0) }
        )
    }

    private func encodeIntArray(_ arr: [Int]) throws -> String {
        let data = try JSONEncoder().encode(arr)
        return String(data: data, encoding: .utf8) ?? "[]"
    }

    private func decodeIntArray(_ json: String) throws -> [Int] {
        guard let data = json.data(using: .utf8) else { return [] }
        return try JSONDecoder().decode([Int].self, from: data)
    }
}
