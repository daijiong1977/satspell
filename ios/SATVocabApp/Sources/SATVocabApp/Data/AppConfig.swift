import Foundation

enum AppConfig {
    static let defaultListName = "sat_core_1"

    // Testing helpers
    // When enabled, all dashboard tasks are unlocked/clickable (including Task 5/6).
    static let unlockAllTasksForTesting = true

    // When enabled, all adventure zones/days/tasks are treated as unlocked.
    // This is intended for UI testing/polish; gating rules can be added later.
    static let unlockAllAdventureForTesting = true

    // Dashboard tasks (v1)
    static let task1CardCount = 20
    static let task2CardCount = 10

    // Task 3: 20 image-to-word rounds
    // Task 4: 20 SAT MCQ rounds
    static let task3SetsCount = 20
    static let task4McqCount = 20
    static let task4McqFetchPerWord = 2

    // Verified-only SAT MCQ questions in v1
    static let satQuestionsVerifiedOnly = true

    // Bundle resource names
    static let bundledDatabaseName = "data"
    static let bundledDatabaseExtension = "db"
    static let bundledImagesFolderName = "Images" // add as folder reference in Xcode

    static let xpPerCorrect = 10
}
