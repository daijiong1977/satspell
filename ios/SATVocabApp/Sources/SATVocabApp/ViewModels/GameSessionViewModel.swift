import Foundation

enum GameSessionMode: String, Hashable {
    case task3Images
    case task4Sat
}

enum GameRound: Hashable {
    case cloze(target: VocabCard, context: String, choices: [VocabCard], correctWordId: Int)
    case satMCQ(target: VocabCard, question: SatQuestion)
}

@MainActor
final class GameSessionViewModel: ObservableObject {
    @Published var isLoading: Bool = true
    @Published var errorMessage: String? = nil

    @Published var rounds: [GameRound] = []
    @Published var currentIndex: Int = 0

    @Published private(set) var needsReviewCount: Int = 0

    let mode: GameSessionMode
    let dayIndexOverride: Int?

    let userId = LocalIdentity.userId()
    private(set) var list: ListInfo? = nil

    private var sessionId: Int? = nil
    private var itemsCorrect: Int = 0
    private var roundShownAt: Date = Date()
    private var needsReviewWordIds = Set<Int>()

    init(mode: GameSessionMode, dayIndexOverride: Int? = nil) {
        self.mode = mode
        self.dayIndexOverride = dayIndexOverride
    }

    func start() {
        isLoading = true
        errorMessage = nil
        rounds = []
        currentIndex = 0
        itemsCorrect = 0
        needsReviewWordIds = []
        needsReviewCount = 0

        Task {
            do {
                let list = try await DataManager.shared.getDefaultList()
                self.list = list
                try await DataManager.shared.ensureProgressSnapshot(userId: userId, listId: list.id)

                // Build target words: selected day's 20 words (same ordering as Task 1)
                let dayIdx = AdventureSchedule.clampDayIndex(dayIndexOverride ?? AdventureSchedule.dayIndexForToday())
                let startIndex = dayIdx * AppConfig.task1CardCount
                let queue = try await DataManager.shared.fetchSessionQueue(listId: list.id, limit: AppConfig.task1CardCount, startIndex: startIndex)
                let uniqueTargets: [VocabCard] = {
                    var out: [VocabCard] = []
                    var seen = Set<Int>()
                    for c in queue {
                        if seen.insert(c.id).inserted { out.append(c) }
                    }
                    return out
                }()

                let targetCount = min(AppConfig.task3SetsCount, max(1, uniqueTargets.count))
                // Task 3 / Task 4 should not follow the list order.
                let targets = Array(uniqueTargets.prefix(targetCount)).shuffled()

                var wordById: [Int: VocabCard] = [:]
                for t in targets { wordById[t.id] = t }

                let allRounds: [GameRound]
                switch mode {
                case .task3Images:
                    var clozeRounds: [GameRound] = []
                    for target in targets {
                        let targetWordId = target.id
                        let example = (target.example ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
                        let satContext = (try await DataManager.shared.randomSatContext(wordId: targetWordId) ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
                        let def = (target.definition ?? "").trimmingCharacters(in: .whitespacesAndNewlines)

                        let context = !example.isEmpty ? example : (!satContext.isEmpty ? satContext : (!def.isEmpty ? def : target.lemma))

                        let distractors = try await DataManager.shared.fetchDistractors(
                            listId: list.id,
                            pos: target.pos,
                            excludeWordId: targetWordId,
                            limit: 3
                        )
                        var choices = [target] + distractors
                        choices.shuffle()
                        clozeRounds.append(.cloze(target: target, context: context, choices: choices, correctWordId: targetWordId))
                    }
                    allRounds = clozeRounds

                case .task4Sat:
                    var pool: [GameRound] = []
                    for target in targets {
                        let qs = try await DataManager.shared.fetchSatQuestionsForWord(
                            wordId: target.id,
                            limit: AppConfig.task4McqFetchPerWord,
                            verifiedOnly: AppConfig.satQuestionsVerifiedOnly
                        )
                        for q in qs {
                            pool.append(.satMCQ(target: target, question: q))
                        }
                    }

                    // Prefer variety and cap to 20.
                    var seenQ = Set<String>()
                    let unique = pool.filter { round in
                        if case .satMCQ(_, let q) = round {
                            return seenQ.insert(q.id).inserted
                        }
                        return false
                    }
                    allRounds = Array(unique.shuffled().prefix(AppConfig.task4McqCount))
                }

                if allRounds.isEmpty {
                    self.errorMessage = (mode == .task4Sat) ? "No SAT questions available for today's words." : "No rounds available."
                    self.isLoading = false
                    return
                }

                let sId = try await DataManager.shared.startSession(userId: userId, listId: list.id, itemsTotal: allRounds.count)
                self.sessionId = sId

                self.rounds = allRounds
                self.roundShownAt = Date()
                self.isLoading = false
            } catch {
                self.errorMessage = String(describing: error)
                self.isLoading = false
            }
        }
    }

    var isFinished: Bool {
        !rounds.isEmpty && currentIndex >= rounds.count
    }

    func submitAnswer(wordId: Int, isCorrect: Bool, logReview: Bool = true, markNeedsReview: Bool = false) {
        guard let list else { return }
        let durationMs = Int(Date().timeIntervalSince(roundShownAt) * 1000)
        let deviceId = LocalIdentity.deviceId()

        if !isCorrect || markNeedsReview {
            if needsReviewWordIds.insert(wordId).inserted {
                needsReviewCount = needsReviewWordIds.count
            }
        }

        if logReview {
            Task {
                do {
                    try await DataManager.shared.logReview(
                        userId: userId,
                        wordId: wordId,
                        listId: list.id,
                        outcome: isCorrect ? .correct : .incorrect,
                        durationMs: durationMs,
                        reviewedAt: Date(),
                        deviceId: deviceId
                    )
                } catch {
                    // non-fatal
                }
            }
        }

        if isCorrect { itemsCorrect += 1 }
    }

    func advance() {
        currentIndex += 1
        roundShownAt = Date()
    }

    func finishIfNeeded() {
        guard isFinished else { return }
        guard let list else { return }
        guard let sessionId else { return }

        Task {
            do {
                try await DataManager.shared.finishSession(sessionId: sessionId, itemsCorrect: itemsCorrect)
                try await DataManager.shared.updateProgressAfterSession(
                    userId: userId,
                    listId: list.id,
                    itemsTotal: rounds.count,
                    itemsCorrect: itemsCorrect
                )
            } catch {
                // non-fatal
            }
        }
    }

    // (no longer needed) fetchWordByIdFallback
}
