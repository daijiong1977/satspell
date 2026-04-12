import Foundation
import SQLite3

actor ReviewLogger {
    private let db: SQLiteDB

    init(db: SQLiteDB) {
        self.db = db
    }

    func logReview(
        userId: String,
        wordId: Int,
        outcome: ReviewOutcome,
        activityType: ActivityType,
        sessionType: SessionType,
        studyDay: Int,
        durationMs: Int
    ) throws {
        let sql = """
        INSERT INTO review_log(user_id, word_id, outcome, duration_ms, reviewed_at, device_id, activity_type, session_type, study_day, superseded)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 0);
        """
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }

        let reviewedAt = ISO8601DateFormatter().string(from: Date())

        try SQLiteDB.bind(stmt, 1, userId)
        try SQLiteDB.bind(stmt, 2, wordId)
        try SQLiteDB.bind(stmt, 3, outcome.rawValue)
        try SQLiteDB.bind(stmt, 4, durationMs)
        try SQLiteDB.bind(stmt, 5, reviewedAt)
        try SQLiteDB.bind(stmt, 6, LocalIdentity.deviceId())
        try SQLiteDB.bind(stmt, 7, activityType.rawValue)
        try SQLiteDB.bind(stmt, 8, sessionType.rawValue)
        try SQLiteDB.bind(stmt, 9, studyDay)

        if sqlite3_step(stmt) != SQLITE_DONE {
            throw SQLiteError.stepFailed(message: db.errorMessage())
        }
    }

    func supersedeSession(userId: String, studyDay: Int, sessionType: SessionType) throws {
        let sql = """
        UPDATE review_log SET superseded = 1
        WHERE user_id = ? AND study_day = ? AND session_type = ? AND superseded = 0;
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
}
