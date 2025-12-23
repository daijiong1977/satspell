import Foundation

@MainActor
final class ZoneReviewSessionViewModel: ObservableObject {
    @Published var isLoading: Bool = true
    @Published var errorMessage: String? = nil

    @Published private(set) var queue: [VocabCard] = []

    let zoneIndex: Int
    let userId = LocalIdentity.userId()

    private(set) var list: ListInfo? = nil
    private var shownAt: Date = Date()

    init(zoneIndex: Int) {
        self.zoneIndex = zoneIndex
    }

    var currentCard: VocabCard? {
        queue.first
    }

    var isFinished: Bool {
        !isLoading && errorMessage == nil && queue.isEmpty
    }

    func start() {
        isLoading = true
        errorMessage = nil
        queue = []

        Task {
            do {
                let list = try await DataManager.shared.getDefaultList()
                self.list = list
                try await DataManager.shared.ensureProgressSnapshot(userId: userId, listId: list.id)

                let wordsPerDay = AppConfig.task1CardCount
                let zoneStartIndex = zoneIndex * AdventureSchedule.daysPerZone * wordsPerDay
                let zoneWords = try await DataManager.shared.fetchSessionQueue(
                    listId: list.id,
                    limit: AdventureSchedule.daysPerZone * wordsPerDay,
                    startIndex: zoneStartIndex
                )
                let zoneWordIds = zoneWords.map { $0.id }
                if zoneWordIds.isEmpty {
                    isLoading = false
                    return
                }

                let cards = try await DataManager.shared.fetchReviewQueue(userId: userId, listId: list.id, limit: 200, restrictToWordIds: zoneWordIds)
                var enriched = cards
                for idx in enriched.indices {
                    enriched[idx].satContext = try await DataManager.shared.randomSatContext(wordId: enriched[idx].id)
                    let collocations = try await DataManager.shared.fetchCollocations(wordId: enriched[idx].id)
                    enriched[idx].collocations = collocations.isEmpty ? nil : collocations
                }

                self.queue = enriched
                self.shownAt = Date()
                self.isLoading = false
            } catch {
                self.errorMessage = String(describing: error)
                self.isLoading = false
            }
        }
    }

    func recordAnswer(outcome: ReviewOutcome) {
        guard let list else { return }
        guard let card = queue.first else { return }

        let durationMs = Int(Date().timeIntervalSince(shownAt) * 1000)
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
                // non-fatal
            }
        }

        // This zone review is a cleanup pass; do not repeat cards in-session.
        queue.removeFirst()
        shownAt = Date()
    }
}
