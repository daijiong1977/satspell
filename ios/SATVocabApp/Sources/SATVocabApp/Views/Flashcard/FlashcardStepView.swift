import SwiftUI

struct FlashcardStepView: View {
    let words: [VocabCard]
    let stepNumber: Int
    let totalSteps: Int
    var startItemIndex: Int = 0
    let onComplete: ([Int]) -> Void
    var onItemAdvance: ((Int) -> Void)? = nil
    let onPause: (Int, Int, [Int], [Int]) -> Void

    @State private var currentIndex: Int = 0
    @State private var showAgainIds: Set<Int> = []
    @State private var completedIds: Set<Int> = []
    @State private var requeuedCards: [VocabCard] = []
    @State private var showPause: Bool = false
    @State private var dragOffset: CGFloat = 0
    @State private var didInit = false

    private var allCards: [VocabCard] {
        words + requeuedCards
    }

    private var totalCards: Int {
        allCards.count
    }

    private var currentCard: VocabCard? {
        guard allCards.indices.contains(currentIndex) else { return nil }
        return allCards[currentIndex]
    }

    private var isReadOnly: Bool {
        guard let card = currentCard else { return false }
        return completedIds.contains(card.id)
    }

    var body: some View {
        VStack(spacing: 0) {
            SessionHeaderView(
                stepNumber: stepNumber,
                totalSteps: totalSteps,
                stepLabel: "Explore New Words",
                currentWord: currentCard?.lemma ?? "",
                currentItem: min(currentIndex + 1, totalCards),
                totalItems: totalCards,
                progressColor: Color(hex: "#58CC02"),
                isScored: false,
                onClose: { showPause = true }
            )

            if let card = currentCard {
                FlashcardCardView(
                    card: card,
                    cardIndex: currentIndex,
                    totalCards: totalCards,
                    boxLevel: 0,
                    memoryStatus: .normal,
                    isReadOnly: isReadOnly,
                    onShowAgain: {
                        handleShowAgain(card)
                    },
                    onGotIt: {
                        advanceCard(card)
                    }
                )
                .id(currentIndex)
                .offset(x: dragOffset)
                .gesture(
                    DragGesture(minimumDistance: 50)
                        .onChanged { value in
                            dragOffset = value.translation.width
                        }
                        .onEnded { value in
                            let threshold: CGFloat = 80
                            withAnimation(.spring(response: 0.3)) {
                                if value.translation.width < -threshold {
                                    if let card = currentCard {
                                        advanceCard(card)
                                    }
                                } else if value.translation.width > threshold {
                                    goBack()
                                }
                                dragOffset = 0
                            }
                        }
                )
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
            } else {
                VStack(spacing: 16) {
                    Spacer()
                    Text("All caught up!")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: "#4B4B4B"))
                    Text("No words to review right now.")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(hex: "#AFAFAF"))
                    Spacer()
                }
            }
        }
        .onAppear {
            if !didInit {
                didInit = true
                currentIndex = min(startItemIndex, max(allCards.count - 1, 0))
            }
            if words.isEmpty {
                onComplete([])
            }
        }
        .sheet(isPresented: $showPause) {
            PauseSheet(
                onKeepGoing: { showPause = false },
                onPauseExit: {
                    onPause(stepNumber - 1, currentIndex, Array(showAgainIds), requeuedCards.map { $0.id })
                }
            )
        }
    }

    private func handleShowAgain(_ card: VocabCard) {
        if !showAgainIds.contains(card.id) {
            showAgainIds.insert(card.id)
            requeuedCards.append(card)
        }
        completedIds.insert(card.id)
        advanceToNext()
    }

    private func advanceCard(_ card: VocabCard) {
        completedIds.insert(card.id)
        advanceToNext()
    }

    private func advanceToNext() {
        if currentIndex + 1 >= totalCards {
            onComplete(Array(showAgainIds))
        } else {
            withAnimation(.easeInOut(duration: 0.25)) {
                currentIndex += 1
            }
            onItemAdvance?(currentIndex)
        }
    }

    private func goBack() {
        if currentIndex > 0 {
            withAnimation(.easeInOut(duration: 0.25)) {
                currentIndex -= 1
            }
        }
    }
}
