import Foundation

struct VocabCard: Identifiable, Hashable {
    let id: Int
    let lemma: String
    let pos: String?
    let definition: String?
    let example: String?
    let imageFilename: String?

    var satContext: String? = nil
    var collocations: [String]? = nil
}

struct ListInfo: Identifiable, Hashable {
    let id: Int
    let name: String
    let description: String?
    let version: Int
}

enum ReviewOutcome: String {
    case correct
    case incorrect
    case skip
}

struct SatQuestion: Identifiable, Hashable {
    let id: String
    let wordId: Int?
    let targetWord: String?
    let section: String?
    let module: Int?
    let qType: String?
    let passage: String?
    let question: String?
    let optionA: String?
    let optionB: String?
    let optionC: String?
    let optionD: String?
    let answer: String?
    let sourcePdf: String?
    let page: Int?
    let feedbackGenerated: Int
    let answerVerified: Int

    // Explanation (from word_list.json)
    let explanation: String?

    // DeepSeek feedback (optional, may be missing for some questions)
    let deepseekAnswer: String?
    let deepseekBackground: String?
    let deepseekReason: String?
}

struct ProgressSnapshot: Hashable {
    let userId: String
    let listId: Int
    let masteredCount: Int
    let totalSeen: Int
    let streakDays: Int
    let lastReviewedAt: Date?
    let version: Int
}

// MARK: - Learning State Models

struct WordState: Identifiable, Hashable {
    let id: Int
    let userId: String
    let wordId: Int
    var boxLevel: Int
    var dueAt: Date?
    var introStage: Int
    var memoryStatus: MemoryStatus
    var lapseCount: Int
    var consecutiveWrong: Int
    var totalCorrect: Int
    var totalSeen: Int
    var dayTouches: Int
    var recentAccuracy: Double
    var lastReviewedAt: Date?

    var strength: WordStrength {
        WordStrength(rawValue: boxLevel) ?? .notIntroduced
    }
}

struct DayState: Identifiable, Hashable {
    let id: Int
    let userId: String
    let studyDay: Int
    let zoneIndex: Int
    var morningComplete: Bool
    var eveningComplete: Bool
    var morningCompleteAt: Date?
    var eveningCompleteAt: Date?
    var newWordsMorning: Int
    var newWordsEvening: Int
    var morningAccuracy: Double
    var eveningAccuracy: Double
    var morningXP: Int
    var eveningXP: Int
    var isRecoveryDay: Bool
    var isReviewOnlyDay: Bool
}

struct SessionState: Identifiable, Hashable {
    let id: Int
    let userId: String
    let sessionType: SessionType
    let studyDay: Int
    var stepIndex: Int
    var itemIndex: Int
    var isPaused: Bool
    var showAgainIds: [Int]
    var requeuedIds: [Int]
    var startedAt: Date?
    var pausedAt: Date?
    var completedAt: Date?
}

struct DailyStats: Identifiable, Hashable {
    let id: Int
    let userId: String
    let studyDay: Int
    let calendarDate: String
    var newCount: Int
    var reviewCount: Int
    var correctCount: Int
    var totalCount: Int
    var xpEarned: Int
    var sessionBonus: Int
    var studyMinutes: Double
    var wordsPromoted: Int
    var wordsDemoted: Int
}

struct StreakInfo: Hashable {
    var currentStreak: Int
    var bestStreak: Int
    var lastStudyDate: String?
    var totalXP: Int
    var totalStudyDays: Int
    var streak3Claimed: Bool
    var streak7Claimed: Bool
    var streak14Claimed: Bool
    var streak30Claimed: Bool
}

struct ZoneState: Identifiable, Hashable {
    let id: Int
    let userId: String
    let zoneIndex: Int
    var unlocked: Bool
    var testPassed: Bool
    var testAttempts: Int
    var testBestScore: Double
}
