import SwiftUI

struct SessionFlowView: View {
    @StateObject var vm: SessionFlowViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var isLoading = true
    @State private var loadError: String?

    var body: some View {
        ZStack {
            if isLoading {
                VStack(spacing: 12) {
                    ProgressView()
                    Text("Loading words...")
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundColor(.gray)
                }
            } else if let error = loadError {
                VStack(spacing: 12) {
                    Text("Failed to load")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                    Text(error)
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    Button("Go Back") { dismiss() }
                        .buttonStyle(.borderedProminent)
                }
            } else if vm.isComplete {
                SessionCompleteView(
                    xpEarned: vm.xpEarned,
                    totalCorrect: vm.totalCorrect,
                    totalAttempts: vm.totalAttempts,
                    wordsPromoted: vm.wordsPromoted,
                    wordsDemoted: vm.wordsDemoted,
                    onDone: { dismiss() }
                )
            } else if vm.showStepTransition {
                StepTransitionView(
                    stepNumber: vm.currentStepIndex + 1,
                    totalSteps: vm.totalSteps,
                    nextStepLabel: vm.steps[safe: vm.currentStepIndex + 1]?.label ?? "Done",
                    onContinue: { vm.continueAfterTransition() }
                )
            } else if let step = vm.currentStep {
                switch step.type {
                case .flashcard:
                    FlashcardStepView(
                        words: vm.newWords,
                        stepNumber: vm.currentStepIndex + 1,
                        totalSteps: vm.totalSteps,
                        startItemIndex: vm.resumeItemIndex,
                        onComplete: { showAgainIds in
                            vm.receiveShowAgainIds(showAgainIds)
                            vm.advanceToNextStep()
                        },
                        onItemAdvance: { itemIdx in
                            vm.didAdvanceItem(to: itemIdx)
                        },
                        onPause: { stepIdx, itemIdx, saIds, rqIds in
                            Task { await vm.pause(stepIndex: stepIdx, itemIndex: itemIdx, showAgainIds: saIds, requeuedIds: rqIds) }
                            dismiss()
                        }
                    )
                case .imageGame:
                    ImageGameStepView(
                        words: vm.newWords,
                        showAgainPriority: vm.showAgainWordIds,
                        stepNumber: vm.currentStepIndex + 1,
                        totalSteps: vm.totalSteps,
                        startItemIndex: vm.resumeItemIndex,
                        onAnswer: { correct, wordId in
                            Task { await vm.recordAnswer(correct: correct, wordId: wordId, activityType: .imageGame, durationMs: 0) }
                        },
                        onComplete: { vm.advanceToNextStep() },
                        onItemAdvance: { itemIdx in
                            vm.didAdvanceItem(to: itemIdx)
                        },
                        onPause: { stepIdx, itemIdx, saIds, rqIds in
                            Task { await vm.pause(stepIndex: stepIdx, itemIndex: itemIdx, showAgainIds: saIds, requeuedIds: rqIds) }
                            dismiss()
                        }
                    )
                case .quickRecall:
                    QuickRecallStepView(
                        words: vm.morningWords,
                        stepNumber: vm.currentStepIndex + 1,
                        totalSteps: vm.totalSteps,
                        startItemIndex: vm.resumeItemIndex,
                        onAnswer: { correct, wordId in
                            Task { await vm.recordAnswer(correct: correct, wordId: wordId, activityType: .quickRecall, durationMs: 0) }
                        },
                        onComplete: { vm.advanceToNextStep() },
                        onItemAdvance: { itemIdx in
                            vm.didAdvanceItem(to: itemIdx)
                        },
                        onPause: { stepIdx, itemIdx, saIds, rqIds in
                            Task { await vm.pause(stepIndex: stepIdx, itemIndex: itemIdx, showAgainIds: saIds, requeuedIds: rqIds) }
                            dismiss()
                        }
                    )
                case .satQuestion:
                    SATQuestionStepView(
                        words: vm.newWords,
                        stepNumber: vm.currentStepIndex + 1,
                        totalSteps: vm.totalSteps,
                        startItemIndex: vm.resumeItemIndex,
                        onAnswer: { correct, wordId in
                            Task { await vm.recordAnswer(correct: correct, wordId: wordId, activityType: .satQuestion, durationMs: 0) }
                        },
                        onComplete: { vm.advanceToNextStep() },
                        onItemAdvance: { itemIdx in
                            vm.didAdvanceItem(to: itemIdx)
                        },
                        onPause: { stepIdx, itemIdx, saIds, rqIds in
                            Task { await vm.pause(stepIndex: stepIdx, itemIndex: itemIdx, showAgainIds: saIds, requeuedIds: rqIds) }
                            dismiss()
                        }
                    )
                }
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden(true)
        .task {
            do {
                try await vm.loadWords()
                isLoading = false
            } catch {
                loadError = String(describing: error)
                isLoading = false
            }
        }
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
