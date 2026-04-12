import SwiftUI

struct SATQuestionStepView: View {
    let words: [VocabCard]
    let stepNumber: Int
    let totalSteps: Int
    let onAnswer: (Bool, Int) -> Void
    let onComplete: () -> Void
    let onPause: (Int, Int, [Int], [Int]) -> Void

    @State private var currentRound: Int = 0
    @State private var questions: [(wordId: Int, question: SatQuestion)] = []
    @State private var isLoading = true
    @State private var showPause = false

    private var totalRounds: Int {
        questions.count
    }

    var body: some View {
        VStack(spacing: 0) {
            SessionHeaderView(
                stepNumber: stepNumber,
                totalSteps: totalSteps,
                stepLabel: "SAT Questions",
                currentWord: "",
                currentItem: min(currentRound + 1, max(totalRounds, 1)),
                totalItems: max(totalRounds, 1),
                progressColor: Color(hex: "#FF9600"),
                isScored: true,
                onClose: { showPause = true }
            )

            if isLoading {
                Spacer()
                ProgressView("Loading SAT questions...")
                Spacer()
            } else if currentRound < totalRounds {
                let round = questions[currentRound]
                SATQuestionView(
                    question: round.question,
                    onAnswer: { correct in
                        onAnswer(correct, round.wordId)
                        if currentRound + 1 >= totalRounds {
                            onComplete()
                        } else {
                            currentRound += 1
                        }
                    }
                )
                .id(currentRound)
            } else {
                // No questions available
                VStack(spacing: 16) {
                    Spacer()
                    Text("No SAT questions available")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: "#AFAFAF"))
                    Button3D("Continue", action: onComplete)
                        .padding(.horizontal, 40)
                    Spacer()
                }
            }
        }
        .task { await loadQuestions() }
        .sheet(isPresented: $showPause) {
            PauseSheet(
                onKeepGoing: { showPause = false },
                onPauseExit: {
                    showPause = false
                    onPause(stepNumber - 1, currentRound, [], [])
                }
            )
        }
    }

    private func loadQuestions() async {
        var loaded: [(wordId: Int, question: SatQuestion)] = []
        let dm = DataManager.shared

        // Try to get one SAT question per word
        for card in words.shuffled() {
            do {
                let qs = try await dm.fetchSatQuestionsForWord(
                    wordId: card.id,
                    limit: 1,
                    verifiedOnly: AppConfig.satQuestionsVerifiedOnly
                )
                if let q = qs.first {
                    loaded.append((wordId: card.id, question: q))
                }
            } catch {
                // Skip this word
            }

            // Stop once we have enough
            if loaded.count >= (stepNumber <= 3 ? AppConfig.morningSATQuestions : AppConfig.eveningSATQuestions) {
                break
            }
        }

        questions = loaded
        isLoading = false
    }
}
