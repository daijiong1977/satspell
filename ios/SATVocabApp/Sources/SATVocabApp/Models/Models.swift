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
