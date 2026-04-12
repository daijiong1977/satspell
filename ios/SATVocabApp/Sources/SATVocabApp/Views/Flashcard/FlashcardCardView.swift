import SwiftUI

struct FlashcardCardView: View {
    let card: VocabCard
    let cardIndex: Int
    let totalCards: Int
    let boxLevel: Int
    let memoryStatus: MemoryStatus
    let isReadOnly: Bool
    let onShowAgain: () -> Void
    let onGotIt: () -> Void

    @State private var isFlipped = false

    var body: some View {
        ZStack {
            if !isFlipped {
                FlashcardFrontView(
                    card: card,
                    cardIndex: cardIndex,
                    totalCards: totalCards
                )
            } else {
                FlashcardBackView(
                    card: card,
                    cardIndex: cardIndex,
                    totalCards: totalCards,
                    boxLevel: boxLevel,
                    memoryStatus: memoryStatus,
                    isReadOnly: isReadOnly,
                    onShowAgain: onShowAgain,
                    onGotIt: onGotIt
                )
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
            }
        }
        .rotation3DEffect(
            .degrees(isFlipped ? 180 : 0),
            axis: (x: 0, y: 1, z: 0),
            perspective: 0.75
        )
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isFlipped)
        .contentShape(Rectangle())
        .onTapGesture {
            isFlipped.toggle()
        }
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    func resetFlip() {
        isFlipped = false
    }
}
