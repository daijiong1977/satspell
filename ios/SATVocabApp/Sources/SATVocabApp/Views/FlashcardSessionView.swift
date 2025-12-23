import SwiftUI

struct FlashcardSessionView: View {
    let mode: FlashcardSessionMode
    let onCompleted: (Int) -> Void // task index
    let dayIndexOverride: Int?

    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm = FlashcardSessionViewModel()

    init(mode: FlashcardSessionMode, dayIndexOverride: Int? = nil, onCompleted: @escaping (Int) -> Void) {
        self.mode = mode
        self.dayIndexOverride = dayIndexOverride
        self.onCompleted = onCompleted
    }

    var body: some View {
        VStack(spacing: 0) {
            if vm.isLoading {
                ProgressView()
                    .onAppear { vm.start(mode: mode, dayIndexOverride: dayIndexOverride) }
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
                    Text("Nice work")
                        .font(.system(.largeTitle, design: .rounded).weight(.bold))
                    Text("Session complete")
                        .foregroundStyle(.secondary)
                    Button("Back to Today’s Path") {
                        vm.finishIfNeeded()
                        let idx = (mode == .task1) ? 0 : 1
                        onCompleted(idx)
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .onAppear { vm.finishIfNeeded() }
            } else {
                if vm.cards.isEmpty {
                    VStack(spacing: 12) {
                        Text("No review words")
                            .font(.system(.title2, design: .rounded).weight(.bold))
                        Text("Tap Review in Task 1 to add words here.")
                            .font(.system(.body, design: .rounded))
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        Button("Back to Today’s Path") {
                            let idx = (mode == .task1) ? 0 : 1
                            onCompleted(idx)
                            dismiss()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else {
                    FlashcardView(
                        card: vm.cards[vm.currentIndex],
                        onForgot: { vm.recordAnswer(outcome: .incorrect) },
                        onGotIt: { vm.recordAnswer(outcome: .correct) }
                    )
                    .id(vm.cards[vm.currentIndex].id)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            if !vm.isLoading, vm.errorMessage == nil, !vm.isFinished, vm.cards.indices.contains(vm.currentIndex) {
                ToolbarItem(placement: .principal) {
                    let card = vm.cards[vm.currentIndex]
                    let isTask1 = (mode == .task1)
                    let current = vm.currentIndex + 1
                    let total = max(vm.cards.count, 1)

                    HStack(spacing: 10) {
                        Text(card.lemma)
                            .font(.system(size: 21, design: .rounded).weight(.bold))
                            .foregroundStyle(Color.brown)
                            .lineLimit(1)
                            .minimumScaleFactor(0.85)

                        if isTask1 {
                            Text("Mastered \(vm.masteredCount)/\(max(vm.masteredTotal, 1))")
                                .font(.system(.subheadline, design: .rounded).weight(.semibold))
                                .foregroundStyle(.secondary)
                        } else {
                            Text("(\(current)/\(total))")
                                .font(.system(.subheadline, design: .rounded).weight(.semibold))
                                .foregroundStyle(.secondary)
                        }

                        SoundButton(text: card.lemma)

                        if let pos = card.pos, !pos.isEmpty {
                            Text(pos)
                                .font(.system(.subheadline, design: .rounded).weight(.semibold))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(Color.gray.opacity(0.12))
                                .clipShape(Capsule())
                        }
                    }
                }
            }
        }
    }
}
