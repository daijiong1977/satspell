import SwiftUI

struct ZoneReviewSessionView: View {
    let zoneIndex: Int
    let onCompleted: () -> Void

    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm: ZoneReviewSessionViewModel

    init(zoneIndex: Int, onCompleted: @escaping () -> Void) {
        self.zoneIndex = zoneIndex
        self.onCompleted = onCompleted
        _vm = StateObject(wrappedValue: ZoneReviewSessionViewModel(zoneIndex: zoneIndex))
    }

    var body: some View {
        VStack(spacing: 0) {
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
                    Text("Zone review complete")
                        .font(.system(.largeTitle, design: .rounded).weight(.bold))
                    Text("Nice work")
                        .foregroundStyle(.secondary)
                    Button("Done") {
                        onCompleted()
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                }
            } else if let card = vm.currentCard {
                FlashcardView(
                    card: card,
                    onForgot: { vm.recordAnswer(outcome: .incorrect) },
                    onGotIt: { vm.recordAnswer(outcome: .correct) }
                )
                .id(card.id)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                VStack(spacing: 12) {
                    Text("No difficult words")
                        .font(.system(.title2, design: .rounded).weight(.bold))
                    Text("You have no incorrect words in this zone.")
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(.secondary)
                    Button("Done") {
                        onCompleted()
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        .navigationTitle("Zone \(zoneIndex + 1)")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .padding(.horizontal, 16)
    }
}
