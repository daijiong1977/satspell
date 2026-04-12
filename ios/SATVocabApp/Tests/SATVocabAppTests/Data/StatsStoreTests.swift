import XCTest
import SQLite3
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
        XCTAssertEqual(stats.xpEarned, 20)  // 2 x 10 XP
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
        XCTAssertEqual(milestoneXP, 0, "Already claimed -- no bonus")
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
