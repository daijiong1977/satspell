import Foundation
import SQLite3

extension DateFormatter {
    static let yyyyMMdd: DateFormatter = {
        let f = DateFormatter()
        f.calendar = Calendar.current
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()
}

actor StatsStore {
    static let shared = StatsStore()

    private let _db: SQLiteDB?
    private var db: SQLiteDB { _db ?? DataManager.shared.db }

    private init() { _db = nil }

    /// Testable initializer accepting an explicit database
    init(db: SQLiteDB) { _db = db }

    // MARK: - Daily Stats

    func getOrCreateDailyStats(userId: String, studyDay: Int) throws -> DailyStats {
        let calendarDate = DateFormatter.yyyyMMdd.string(from: Date())

        let insertSQL = """
        INSERT OR IGNORE INTO daily_stats(user_id, study_day, calendar_date)
        VALUES (?, ?, ?);
        """
        let s1 = try db.prepare(insertSQL)
        defer { s1?.finalize() }
        try SQLiteDB.bind(s1, 1, userId)
        try SQLiteDB.bind(s1, 2, studyDay)
        try SQLiteDB.bind(s1, 3, calendarDate)
        if sqlite3_step(s1) != SQLITE_DONE {
            throw SQLiteError.stepFailed(message: db.errorMessage())
        }

        let selectSQL = """
        SELECT id, user_id, study_day, calendar_date, new_count, review_count,
               correct_count, total_count, xp_earned, session_bonus,
               study_minutes, words_promoted, words_demoted
        FROM daily_stats
        WHERE user_id = ? AND study_day = ?
        LIMIT 1;
        """
        let s2 = try db.prepare(selectSQL)
        defer { s2?.finalize() }
        try SQLiteDB.bind(s2, 1, userId)
        try SQLiteDB.bind(s2, 2, studyDay)
        if sqlite3_step(s2) == SQLITE_ROW {
            return parseDailyStats(s2)
        }
        throw SQLiteError.stepFailed(message: "Failed to fetch daily_stats after insert")
    }

    func recordCorrectAnswer(userId: String, studyDay: Int, xpPerCorrect: Int = AppConfig.correctAnswerXP) throws {
        let sql = """
        UPDATE daily_stats
        SET correct_count = correct_count + 1,
            total_count = total_count + 1,
            xp_earned = xp_earned + ?
        WHERE user_id = ? AND study_day = ?;
        """
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }
        try SQLiteDB.bind(stmt, 1, xpPerCorrect)
        try SQLiteDB.bind(stmt, 2, userId)
        try SQLiteDB.bind(stmt, 3, studyDay)
        if sqlite3_step(stmt) != SQLITE_DONE {
            throw SQLiteError.stepFailed(message: db.errorMessage())
        }
    }

    func recordWrongAnswer(userId: String, studyDay: Int) throws {
        let sql = """
        UPDATE daily_stats
        SET total_count = total_count + 1
        WHERE user_id = ? AND study_day = ?;
        """
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }
        try SQLiteDB.bind(stmt, 1, userId)
        try SQLiteDB.bind(stmt, 2, studyDay)
        if sqlite3_step(stmt) != SQLITE_DONE {
            throw SQLiteError.stepFailed(message: db.errorMessage())
        }
    }

    func addSessionBonus(userId: String, studyDay: Int, bonus: Int = AppConfig.sessionBonusXP) throws {
        let sql = """
        UPDATE daily_stats
        SET session_bonus = session_bonus + ?
        WHERE user_id = ? AND study_day = ?;
        """
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }
        try SQLiteDB.bind(stmt, 1, bonus)
        try SQLiteDB.bind(stmt, 2, userId)
        try SQLiteDB.bind(stmt, 3, studyDay)
        if sqlite3_step(stmt) != SQLITE_DONE {
            throw SQLiteError.stepFailed(message: db.errorMessage())
        }
    }

    func recordWordPromoted(userId: String, studyDay: Int) throws {
        let sql = """
        UPDATE daily_stats
        SET words_promoted = words_promoted + 1
        WHERE user_id = ? AND study_day = ?;
        """
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }
        try SQLiteDB.bind(stmt, 1, userId)
        try SQLiteDB.bind(stmt, 2, studyDay)
        if sqlite3_step(stmt) != SQLITE_DONE {
            throw SQLiteError.stepFailed(message: db.errorMessage())
        }
    }

    func recordWordDemoted(userId: String, studyDay: Int) throws {
        let sql = """
        UPDATE daily_stats
        SET words_demoted = words_demoted + 1
        WHERE user_id = ? AND study_day = ?;
        """
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }
        try SQLiteDB.bind(stmt, 1, userId)
        try SQLiteDB.bind(stmt, 2, studyDay)
        if sqlite3_step(stmt) != SQLITE_DONE {
            throw SQLiteError.stepFailed(message: db.errorMessage())
        }
    }

    // MARK: - Streak

    func getStreak(userId: String) throws -> StreakInfo {
        let sql = """
        SELECT current_streak, best_streak, last_study_date,
               total_xp, total_study_days,
               streak_3_claimed, streak_7_claimed, streak_14_claimed, streak_30_claimed
        FROM streak_store
        WHERE user_id = ?
        LIMIT 1;
        """
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }
        try SQLiteDB.bind(stmt, 1, userId)
        if sqlite3_step(stmt) == SQLITE_ROW {
            return StreakInfo(
                currentStreak: SQLiteDB.columnInt(stmt, 0),
                bestStreak: SQLiteDB.columnInt(stmt, 1),
                lastStudyDate: SQLiteDB.columnText(stmt, 2),
                totalXP: SQLiteDB.columnInt(stmt, 3),
                totalStudyDays: SQLiteDB.columnInt(stmt, 4),
                streak3Claimed: SQLiteDB.columnInt(stmt, 5) != 0,
                streak7Claimed: SQLiteDB.columnInt(stmt, 6) != 0,
                streak14Claimed: SQLiteDB.columnInt(stmt, 7) != 0,
                streak30Claimed: SQLiteDB.columnInt(stmt, 8) != 0
            )
        }
        // Return default if no row found
        return StreakInfo(
            currentStreak: 0, bestStreak: 0, lastStudyDate: nil,
            totalXP: 0, totalStudyDays: 0,
            streak3Claimed: false, streak7Claimed: false,
            streak14Claimed: false, streak30Claimed: false
        )
    }

    func updateStreak(userId: String, xpToday: Int) throws -> (newStreak: Int, milestoneXP: Int) {
        let current = try getStreak(userId: userId)
        let today = DateFormatter.yyyyMMdd.string(from: Date())
        let calendar = Calendar.current

        var newStreak = current.currentStreak
        var newBest = current.bestStreak
        var newTotalDays = current.totalStudyDays

        if current.lastStudyDate == today {
            // Already studied today, just update XP
        } else {
            // Check if yesterday
            let yesterday = calendar.date(byAdding: .day, value: -1, to: Date())!
            let yesterdayStr = DateFormatter.yyyyMMdd.string(from: yesterday)

            if current.lastStudyDate == yesterdayStr {
                newStreak += 1
            } else {
                newStreak = 1
            }
            newTotalDays += 1
        }

        if newStreak > newBest {
            newBest = newStreak
        }

        // Calculate milestone bonuses
        var milestoneXP = 0
        var s3 = current.streak3Claimed
        var s7 = current.streak7Claimed
        var s14 = current.streak14Claimed
        var s30 = current.streak30Claimed

        if newStreak >= 3 && !s3 { milestoneXP += 20; s3 = true }
        if newStreak >= 7 && !s7 { milestoneXP += 50; s7 = true }
        if newStreak >= 14 && !s14 { milestoneXP += 100; s14 = true }
        if newStreak >= 30 && !s30 { milestoneXP += 200; s30 = true }

        let newTotalXP = current.totalXP + xpToday + milestoneXP

        let sql = """
        UPDATE streak_store
        SET current_streak = ?,
            best_streak = ?,
            last_study_date = ?,
            total_xp = ?,
            total_study_days = ?,
            streak_3_claimed = ?,
            streak_7_claimed = ?,
            streak_14_claimed = ?,
            streak_30_claimed = ?
        WHERE user_id = ?;
        """
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }
        try SQLiteDB.bind(stmt, 1, newStreak)
        try SQLiteDB.bind(stmt, 2, newBest)
        try SQLiteDB.bind(stmt, 3, today)
        try SQLiteDB.bind(stmt, 4, newTotalXP)
        try SQLiteDB.bind(stmt, 5, newTotalDays)
        try SQLiteDB.bind(stmt, 6, s3 ? 1 : 0)
        try SQLiteDB.bind(stmt, 7, s7 ? 1 : 0)
        try SQLiteDB.bind(stmt, 8, s14 ? 1 : 0)
        try SQLiteDB.bind(stmt, 9, s30 ? 1 : 0)
        try SQLiteDB.bind(stmt, 10, userId)
        if sqlite3_step(stmt) != SQLITE_DONE {
            throw SQLiteError.stepFailed(message: db.errorMessage())
        }

        return (newStreak: newStreak, milestoneXP: milestoneXP)
    }

    // MARK: - Private

    private func parseDailyStats(_ stmt: OpaquePointer?) -> DailyStats {
        DailyStats(
            id: SQLiteDB.columnInt(stmt, 0),
            userId: SQLiteDB.columnText(stmt, 1) ?? "",
            studyDay: SQLiteDB.columnInt(stmt, 2),
            calendarDate: SQLiteDB.columnText(stmt, 3) ?? "",
            newCount: SQLiteDB.columnInt(stmt, 4),
            reviewCount: SQLiteDB.columnInt(stmt, 5),
            correctCount: SQLiteDB.columnInt(stmt, 6),
            totalCount: SQLiteDB.columnInt(stmt, 7),
            xpEarned: SQLiteDB.columnInt(stmt, 8),
            sessionBonus: SQLiteDB.columnInt(stmt, 9),
            studyMinutes: SQLiteDB.columnDouble(stmt, 10),
            wordsPromoted: SQLiteDB.columnInt(stmt, 11),
            wordsDemoted: SQLiteDB.columnInt(stmt, 12)
        )
    }
}
