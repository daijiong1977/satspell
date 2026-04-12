import XCTest
import SQLite3
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

    func testCorrectAnswerOnDay1WordDoesNotPromoteBoxBeforeEndOfEvening() async throws {
        try await store.introduceWord(userId: userId, wordId: 1)

        let change = try await store.recordScoredAnswer(userId: userId, wordId: 1, correct: true)

        let ws = try await store.getWordState(userId: userId, wordId: 1)
        XCTAssertEqual(ws?.boxLevel, 0, "Day 1 scored answers should not move a new word out of box 0 before promotion is decided")
        XCTAssertNil(ws?.dueAt, "Day 1 scored answers should not set a review date before promotion is decided")
        if case .none = change {} else {
            XCTFail("Expected no box change for a Day 1 scored answer, got \(change)")
        }
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

    func testDay1PromotionIgnoresPreviousStudyDays() async throws {
        try await store.introduceWord(userId: userId, wordId: 1)

        try db.exec("""
        INSERT INTO review_log(user_id, word_id, outcome, duration_ms, reviewed_at, activity_type, session_type, study_day, superseded)
        VALUES
            ('\(userId!)', 1, 'correct', 1500, '2026-01-01T08:00:00Z', 'image_game', 'morning', 0, 0),
            ('\(userId!)', 1, 'incorrect', 1500, '2026-01-01T09:00:00Z', 'quick_recall', 'evening', 0, 0),
            ('\(userId!)', 1, 'correct', 1500, '2026-01-01T10:00:00Z', 'image_game', 'evening', 0, 0),
            ('\(userId!)', 1, 'correct', 1500, '2026-01-02T08:00:00Z', 'quick_recall', 'evening', 1, 0);
        """)

        let result = try await store.runDay1Promotion(userId: userId, studyDay: 1)

        XCTAssertEqual(result.promoted, 0, "Only the current study day should count toward Day 1 promotion")
        XCTAssertEqual(result.notPromoted, 1)

        let ws = try await store.getWordState(userId: userId, wordId: 1)
        XCTAssertEqual(ws?.boxLevel, 1, "Historical days should not promote today's word")
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
