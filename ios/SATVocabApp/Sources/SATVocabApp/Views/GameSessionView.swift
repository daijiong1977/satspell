import SwiftUI

struct GameSessionView: View {
    let mode: GameSessionMode
    let dayIndexOverride: Int?
    let onCompleted: (Int) -> Void

    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm: GameSessionViewModel

    init(mode: GameSessionMode, dayIndexOverride: Int? = nil, onCompleted: @escaping (Int) -> Void) {
        self.mode = mode
        self.dayIndexOverride = dayIndexOverride
        self.onCompleted = onCompleted
        _vm = StateObject(wrappedValue: GameSessionViewModel(mode: mode, dayIndexOverride: dayIndexOverride))
    }

    var body: some View {
        VStack {
            if vm.isLoading {
                ProgressView()
                    .onAppear { vm.start() }
            } else if let err = vm.errorMessage {
                VStack(spacing: 12) {
                    Text("Failed to load")
                        .font(.title3.weight(.semibold))
                    Text(err)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            } else if vm.isFinished {
                VStack(spacing: 12) {
                    Text("Great job")
                        .font(.system(.largeTitle, design: .rounded).weight(.bold))
                    Text(completionText)
                        .foregroundStyle(.secondary)
                    if mode == .task3Images {
                        Text("\(vm.needsReviewCount) words need review")
                            .font(.system(.headline, design: .rounded).weight(.semibold))
                            .foregroundStyle(.secondary)
                    }
                    Button("Back to Today’s Path") {
                        vm.finishIfNeeded()
                        onCompleted(taskIndex)
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .onAppear { vm.finishIfNeeded() }
            } else {
                roundBody
            }
        }
        .padding(.horizontal, 16)
        .navigationTitle("\(vm.currentIndex + 1)/\(max(vm.rounds.count, 1))")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    NavigationLink {
                        FlashcardSessionView(mode: .task1) { completedTaskIndex in
                            TaskProgressStore.shared.setCompleted(taskIndex: completedTaskIndex, completed: true)
                        }
                    } label: {
                        Text("Task 1")
                    }

                    NavigationLink {
                        FlashcardSessionView(mode: .task2) { completedTaskIndex in
                            TaskProgressStore.shared.setCompleted(taskIndex: completedTaskIndex, completed: true)
                        }
                    } label: {
                        Text("Task 2")
                    }

                    NavigationLink {
                        GameSessionView(mode: .task3Images) { completedTaskIndex in
                            TaskProgressStore.shared.setCompleted(taskIndex: completedTaskIndex, completed: true)
                        }
                    } label: {
                        Text("Task 3")
                    }

                    NavigationLink {
                        GameSessionView(mode: .task4Sat) { completedTaskIndex in
                            TaskProgressStore.shared.setCompleted(taskIndex: completedTaskIndex, completed: true)
                        }
                    } label: {
                        Text("Task 4")
                    }
                } label: {
                    Image(systemName: "square.grid.2x2")
                }
            }
        }
    }

    @ViewBuilder
    private var roundBody: some View {
        let round = vm.rounds[vm.currentIndex]
        switch round {
        case .cloze(let target, let context, let choices, let correctWordId):
            ClozeRoundView(
                target: target,
                context: context,
                choices: choices,
                correctWordId: correctWordId,
                onSubmit: { isCorrect, keepInReview in
                    // If the user missed this word at least once, keep it in Task 2 review by not logging a final 'correct'.
                    let logReview = !(isCorrect && keepInReview)
                    let markNeedsReview = keepInReview || !isCorrect
                    vm.submitAnswer(wordId: target.id, isCorrect: isCorrect, logReview: logReview, markNeedsReview: markNeedsReview)
                },
                onNext: {
                    vm.advance()
                }
            )
        case .satMCQ(let target, let question):
            SatMCQRoundView(
                target: target,
                question: question,
                onSubmit: { isCorrect, keepInReview in
                    // If the user missed this word at least once, keep it in Task 2 review by not logging a final 'correct'.
                    let logReview = !(isCorrect && keepInReview)
                    let markNeedsReview = keepInReview || !isCorrect
                    vm.submitAnswer(wordId: target.id, isCorrect: isCorrect, logReview: logReview, markNeedsReview: markNeedsReview)
                },
                onNext: {
                    vm.advance()
                }
            )
        }
    }

    private var taskIndex: Int {
        switch mode {
        case .task3Images: return 2
        case .task4Sat: return 3
        }
    }

    private var completionText: String {
        switch mode {
        case .task3Images: return "Task 3 complete"
        case .task4Sat: return "Task 4 complete"
        }
    }
}
