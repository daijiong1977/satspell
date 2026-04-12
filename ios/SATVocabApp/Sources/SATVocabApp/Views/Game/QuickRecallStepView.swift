import SwiftUI

struct QuickRecallStepView: View {
    let words: [VocabCard]
    let stepNumber: Int
    let totalSteps: Int
    let onAnswer: (Bool, Int) -> Void
    let onComplete: () -> Void
    let onPause: (Int, Int, [Int], [Int]) -> Void

    @State private var currentRound: Int = 0
    @State private var roundData: [(card: VocabCard, choices: [QuickRecallView.DefinitionChoice])] = []
    @State private var isLoading = true
    @State private var showPause = false

    private var totalRounds: Int {
        roundData.count
    }

    var body: some View {
        VStack(spacing: 0) {
            SessionHeaderView(
                stepNumber: stepNumber,
                totalSteps: totalSteps,
                stepLabel: "Quick Recall",
                currentWord: (currentRound < roundData.count) ? roundData[currentRound].card.lemma : "",
                currentItem: min(currentRound + 1, max(totalRounds, 1)),
                totalItems: max(totalRounds, 1),
                progressColor: Color(hex: "#CE82FF"),
                isScored: true,
                onClose: { showPause = true }
            )

            if isLoading {
                Spacer()
                ProgressView("Loading...")
                Spacer()
            } else if currentRound < totalRounds {
                let round = roundData[currentRound]
                QuickRecallView(
                    card: round.card,
                    definitionChoices: round.choices,
                    onAnswer: { correct in
                        onAnswer(correct, round.card.id)
                        if currentRound + 1 >= totalRounds {
                            onComplete()
                        } else {
                            currentRound += 1
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
        .task { await loadRounds() }
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
        var rounds: [(card: VocabCard, choices: [QuickRecallView.DefinitionChoice])] = []

        for card in words {
            do {
                let dm = DataManager.shared
                let list = try await dm.getDefaultList()
                let distractors = try await dm.fetchDistractors(listId: list.id, pos: card.pos, excludeWordId: card.id, limit: 3)

                var choices: [QuickRecallView.DefinitionChoice] = distractors.map { d in
                    QuickRecallView.DefinitionChoice(id: d.id, definition: d.definition ?? "Unknown", isCorrect: false)
                }
                choices.append(QuickRecallView.DefinitionChoice(id: card.id, definition: card.definition ?? "Unknown", isCorrect: true))
                choices.shuffle()
                rounds.append((card: card, choices: choices))
            } catch {
                // Fallback
                var choices: [QuickRecallView.DefinitionChoice] = words.filter { $0.id != card.id }.prefix(3).map { d in
                    QuickRecallView.DefinitionChoice(id: d.id, definition: d.definition ?? "Unknown", isCorrect: false)
                }
                choices.append(QuickRecallView.DefinitionChoice(id: card.id, definition: card.definition ?? "Unknown", isCorrect: true))
                choices.shuffle()
                rounds.append((card: card, choices: choices))
            }
        }

        roundData = rounds
        isLoading = false
    }
}
