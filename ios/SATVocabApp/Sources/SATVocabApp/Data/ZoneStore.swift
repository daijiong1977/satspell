import Foundation
import SQLite3

actor ZoneStore {
    static let shared = ZoneStore()

    private var db: SQLiteDB { DataManager.shared.db }

    private init() {}

    // MARK: - Zone State

    func getZoneState(userId: String, zoneIndex: Int) throws -> ZoneState? {
        let sql = """
        SELECT id, user_id, zone_index, unlocked, test_passed, test_attempts, test_best_score
        FROM zone_state
        WHERE user_id = ? AND zone_index = ?
        LIMIT 1;
        """
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }
        try SQLiteDB.bind(stmt, 1, userId)
        try SQLiteDB.bind(stmt, 2, zoneIndex)
        if sqlite3_step(stmt) == SQLITE_ROW {
            return parseZoneState(stmt)
        }
        return nil
    }

    func isZoneUnlocked(userId: String, zoneIndex: Int) throws -> Bool {
        if zoneIndex == 0 { return true }
        guard let state = try getZoneState(userId: userId, zoneIndex: zoneIndex) else {
            return false
        }
        return state.unlocked
    }

    func unlockZone(userId: String, zoneIndex: Int) throws {
        let sql = """
        INSERT INTO zone_state(user_id, zone_index, unlocked, unlocked_at)
        VALUES (?, ?, 1, datetime('now'))
        ON CONFLICT(user_id, zone_index) DO UPDATE SET unlocked = 1, unlocked_at = datetime('now');
        """
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }
        try SQLiteDB.bind(stmt, 1, userId)
        try SQLiteDB.bind(stmt, 2, zoneIndex)
        if sqlite3_step(stmt) != SQLITE_DONE {
            throw SQLiteError.stepFailed(message: db.errorMessage())
        }
    }

    func recordTestAttempt(userId: String, zoneIndex: Int, score: Double, passed: Bool) throws {
        // Ensure row exists first
        let insertSQL = """
        INSERT OR IGNORE INTO zone_state(user_id, zone_index, unlocked)
        VALUES (?, ?, 0);
        """
        let s1 = try db.prepare(insertSQL)
        defer { s1?.finalize() }
        try SQLiteDB.bind(s1, 1, userId)
        try SQLiteDB.bind(s1, 2, zoneIndex)
        if sqlite3_step(s1) != SQLITE_DONE {
            throw SQLiteError.stepFailed(message: db.errorMessage())
        }

        let updateSQL = """
        UPDATE zone_state
        SET test_attempts = test_attempts + 1,
            test_best_score = MAX(test_best_score, ?),
            test_passed = CASE WHEN ? = 1 THEN 1 ELSE test_passed END
        WHERE user_id = ? AND zone_index = ?;
        """
        let s2 = try db.prepare(updateSQL)
        defer { s2?.finalize() }
        try SQLiteDB.bind(s2, 1, score)
        try SQLiteDB.bind(s2, 2, passed ? 1 : 0)
        try SQLiteDB.bind(s2, 3, userId)
        try SQLiteDB.bind(s2, 4, zoneIndex)
        if sqlite3_step(s2) != SQLITE_DONE {
            throw SQLiteError.stepFailed(message: db.errorMessage())
        }
    }

    // MARK: - Private

    private func parseZoneState(_ stmt: OpaquePointer?) -> ZoneState {
        ZoneState(
            id: SQLiteDB.columnInt(stmt, 0),
            userId: SQLiteDB.columnText(stmt, 1) ?? "",
            zoneIndex: SQLiteDB.columnInt(stmt, 2),
            unlocked: SQLiteDB.columnInt(stmt, 3) != 0,
            testPassed: SQLiteDB.columnInt(stmt, 4) != 0,
            testAttempts: SQLiteDB.columnInt(stmt, 5),
            testBestScore: SQLiteDB.columnDouble(stmt, 6)
        )
    }
}
