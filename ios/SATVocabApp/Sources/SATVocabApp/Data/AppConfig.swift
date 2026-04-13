import Foundation

enum AppConfig {
    static let defaultListName = "sat_core_1"

    // Testing helpers
    // When enabled, all dashboard tasks are unlocked/clickable (including Task 5/6).
    static let unlockAllTasksForTesting = true

    // When enabled, all adventure zones/days/tasks are treated as unlocked.
    // This is intended for UI testing/polish; gating rules can be added later.
    static let unlockAllAdventureForTesting = false

    // Dashboard tasks (v1)
    static let task1CardCount = 20
    static let task2CardCount = 10

    // Task 3: 20 image-to-word rounds
    // Task 4: 20 SAT MCQ rounds
    static let task3SetsCount = 20
    static let task4McqCount = 20
    static let task4McqFetchPerWord = 2

    // Verified-only SAT MCQ questions in v1
    static let satQuestionsVerifiedOnly = false  // V1: no verified questions in data, use all

    // Bundle resource names
    static let bundledDatabaseName = "data"
    static let bundledDatabaseExtension = "db"
    static let bundledImagesFolderName = "Images" // add as folder reference in Xcode

    static let xpPerCorrect = 10

    // V2 Learning Model
    static let morningNewWords = 11
    static let eveningNewWords = 10
    static let morningGameRounds = 12
    static let eveningGameRounds = 12
    static let morningSATQuestions = 3
    static let eveningSATQuestions = 2
    static let eveningUnlockHours = 4
    static let eveningUnlockFallbackHour = 17
    static let backPressureReduceAt = 18
    static let backPressureStopAt = 30
    static let zoneTestPassThreshold = 0.8
    static let rushMinGameMs = 1000
    static let rushMinSATMs = 3000
    static let sessionBonusXP = 30
    static let correctAnswerXP = 10
    static let bonusPracticeXP = 5
    static let lateNightHour = 20
}
