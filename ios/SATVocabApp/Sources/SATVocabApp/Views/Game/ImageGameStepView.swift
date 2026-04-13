import SwiftUI

struct ImageGameStepView: View {
    let words: [VocabCard]
    let showAgainPriority: [Int]
    let stepNumber: Int
    let totalSteps: Int
    var startItemIndex: Int = 0
    let onAnswer: (Bool, Int) -> Void
    let onComplete: () -> Void
    var onItemAdvance: ((Int) -> Void)? = nil
    let onPause: (Int, Int, [Int], [Int]) -> Void

    @State private var currentRound: Int = 0
    @State private var roundCards: [(card: VocabCard, choices: [VocabCard])] = []
    @State private var isLoading = true
    @State private var showPause = false
    @State private var didInit = false

    private var totalRounds: Int {
        roundCards.count
    }

    var body: some View {
        VStack(spacing: 0) {
            SessionHeaderView(
                stepNumber: stepNumber,
                totalSteps: totalSteps,
                stepLabel: "Image Practice",
                currentWord: (currentRound < roundCards.count) ? roundCards[currentRound].card.lemma : "",
                currentItem: min(currentRound + 1, max(totalRounds, 1)),
                totalItems: max(totalRounds, 1),
                progressColor: Color(hex: "#58CC02"),
                isScored: true,
                onClose: { showPause = true }
            )

            if isLoading {
                Spacer()
                ProgressView("Loading...")
                Spacer()
            } else if currentRound < totalRounds {
                let round = roundCards[currentRound]
                ImageGameView(
                    card: round.card,
                    choices: round.choices,
                    roundIndex: currentRound,
                    totalRounds: totalRounds,
                    onAnswer: { correct in
                        onAnswer(correct, round.card.id)
                        if currentRound + 1 >= totalRounds {
                            onComplete()
                        } else {
                            currentRound += 1
                            onItemAdvance?(currentRound)
                        }
                    }
                )
                .id(currentRound)
            }
        }
        .onAppear {
            if words.isEmpty {
                onComplete()
            }
        }
        .task {
            await loadRounds()
            if !didInit {
                didInit = true
                currentRound = min(startItemIndex, max(roundCards.count - 1, 0))
            }
        }
        .sheet(isPresented: $showPause) {
            PauseSheet(
                onKeepGoing: { showPause = false },
                onPauseExit: {
                    onPause(stepNumber - 1, currentRound, [], [])
                }
            )
        }
    }

    private func loadRounds() async {
        var ordered: [VocabCard] = []
        let priorityIds = Set(showAgainPriority)
        let priorityCards = words.filter { priorityIds.contains($0.id) }
        let otherCards = words.filter { !priorityIds.contains($0.id) }
        ordered = priorityCards + otherCards

        var rounds: [(card: VocabCard, choices: [VocabCard])] = []
        for card in ordered {
            do {
                let dm = DataManager.shared
                let list = try await dm.getDefaultList()
                let distractors = try await dm.fetchDistractors(listId: list.id, pos: card.pos, excludeWordId: card.id, limit: 3)
                var choices = distractors + [card]
                choices.shuffle()
                rounds.append((card: card, choices: choices))
            } catch {
                var choices = Array(words.filter { $0.id != card.id }.prefix(3))
                choices.append(card)
                choices.shuffle()
                rounds.append((card: card, choices: choices))
            }
        }

        roundCards = rounds
        isLoading = false
    }
}
