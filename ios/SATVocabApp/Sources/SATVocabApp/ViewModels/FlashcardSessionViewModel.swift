import Foundation

enum FlashcardSessionMode: String, Hashable {
    case task1
    case task2
}

@MainActor
final class FlashcardSessionViewModel: ObservableObject {
    @Published var cards: [VocabCard] = []
    @Published var currentIndex: Int = 0
    @Published var isLoading: Bool = true
    @Published var errorMessage: String? = nil

    let userId = LocalIdentity.userId()
    private(set) var list: ListInfo? = nil

    private var sessionId: Int? = nil
    private var itemsCorrect: Int = 0
    private var cardShownAt: Date = Date()

    private var repeatUntilMastered: Bool = false
    private var remainingToMaster = Set<Int>()
    private var uniqueTotal: Int = 0

    var masteredCount: Int {
        max(0, uniqueTotal - remainingToMaster.count)
    }

    var masteredTotal: Int {
        uniqueTotal
    }

    func start(mode: FlashcardSessionMode, dayIndexOverride: Int? = nil) {
        isLoading = true
        errorMessage = nil
        currentIndex = 0
        itemsCorrect = 0
        repeatUntilMastered = (mode == .task1)
        remainingToMaster = []
        uniqueTotal = 0

        Task {
            do {
                let list = try await DataManager.shared.getDefaultList()
                self.list = list
                try await DataManager.shared.ensureProgressSnapshot(userId: userId, listId: list.id)

                let count = (mode == .task1) ? AppConfig.task1CardCount : AppConfig.task2CardCount
                var cards: [VocabCard]

                if mode == .task2 {
                    // Task 2: review words (latest outcome is incorrect).
                    cards = try await DataManager.shared.fetchReviewQueue(userId: userId, listId: list.id, limit: count)
                } else {
                    // Task 1: deterministic daily sequencing.
                    let dayIdx = AdventureSchedule.clampDayIndex(dayIndexOverride ?? AdventureSchedule.dayIndexForToday())
                    let startIndex = dayIdx * AppConfig.task1CardCount
                    cards = try await DataManager.shared.fetchSessionQueue(listId: list.id, limit: count, startIndex: startIndex)
                }

                // Preload one random sat_context per card (used on front caption + back context).
                for idx in cards.indices {
                    let context = try await DataManager.shared.randomSatContext(wordId: cards[idx].id)
                    cards[idx].satContext = context

                    let collocations = try await DataManager.shared.fetchCollocations(wordId: cards[idx].id)
                    cards[idx].collocations = collocations.isEmpty ? nil : collocations
                }

                let sId = try await DataManager.shared.startSession(userId: userId, listId: list.id, itemsTotal: cards.count)
                self.sessionId = sId

                self.cards = cards
                if mode == .task1 {
                    self.remainingToMaster = Set(cards.map { $0.id })
                    self.uniqueTotal = self.remainingToMaster.count
                }
                self.cardShownAt = Date()
                self.isLoading = false
            } catch {
                self.errorMessage = String(describing: error)
                self.isLoading = false
            }
        }
    }

    func recordAnswer(outcome: ReviewOutcome) {
        guard let list else { return }
        guard currentIndex < cards.count else { return }
        let card = cards[currentIndex]

        let durationMs = Int(Date().timeIntervalSince(cardShownAt) * 1000)
        let deviceId = LocalIdentity.deviceId()

        Task {
            do {
                try await DataManager.shared.logReview(
                    userId: userId,
                    wordId: card.id,
                    listId: list.id,
                    outcome: outcome,
                    durationMs: durationMs,
                    reviewedAt: Date(),
                    deviceId: deviceId
                )
            } catch {
                // non-fatal for v1
            }
        }

        if outcome == .correct { itemsCorrect += 1 }

        if repeatUntilMastered {
            if outcome == .correct {
                remainingToMaster.remove(card.id)
            } else {
                // Re-queue this word so it repeats later.
                cards.append(card)
            }
            advanceSkippingMastered()
        } else {
            advance()
        }
    }

    func advance() {
        currentIndex += 1
        cardShownAt = Date()
    }

    private func advanceSkippingMastered() {
        currentIndex += 1
        while currentIndex < cards.count {
            let id = cards[currentIndex].id
            if remainingToMaster.contains(id) { break }
            currentIndex += 1
        }

        if remainingToMaster.isEmpty {
            currentIndex = cards.count
        }

        cardShownAt = Date()
    }

    var isFinished: Bool {
        !cards.isEmpty && currentIndex >= cards.count
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
                    itemsTotal: cards.count,
                    itemsCorrect: itemsCorrect
                )
            } catch {
                // non-fatal
            }
        }
    }

    // rotationKeyForToday removed: sequencing is now startIndex-based.
}
