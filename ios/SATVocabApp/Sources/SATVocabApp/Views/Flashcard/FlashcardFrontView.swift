import SwiftUI

struct FlashcardFrontView: View {
    let card: VocabCard
    let cardIndex: Int
    let totalCards: Int

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Full-bleed image
                if let ui = ImageResolver.uiImage(for: card.imageFilename) {
                    Image(uiImage: ui)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width, height: geo.size.height)
                        .clipped()
                } else {
                    // Fallback gradient
                    LinearGradient(
                        colors: [Color(hex: "#4A90D9"), Color(hex: "#2C5F8A")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    Text(card.lemma.uppercased())
                        .font(.system(size: 32, weight: .black))
                        .foregroundColor(.white.opacity(0.3))
                }

                // Top gradient
                VStack {
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.black.opacity(0.4),
                            Color.black.opacity(0.0)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 50)
                    Spacer()
                }

                // Bottom gradient for sentence
                VStack {
                    Spacer()
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: .clear, location: 0),
                            .init(color: Color.black.opacity(0.12), location: 0.25),
                            .init(color: Color.black.opacity(0.45), location: 0.55),
                            .init(color: Color.black.opacity(0.78), location: 0.85),
                            .init(color: Color.black.opacity(0.88), location: 1.0),
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: geo.size.height * 0.5)
                }

                // Sentence overlay
                VStack {
                    Spacer()
                    if let example = card.example, !example.isEmpty {
                        Text(highlightedSentence(example, word: card.lemma))
                            .font(.system(size: 19, weight: .medium))
                            .foregroundColor(.white.opacity(0.9))
                            .lineSpacing(5)
                            .padding(.horizontal, 14)
                            .padding(.bottom, 6)
                            .shadow(color: .black.opacity(0.8), radius: 4, x: 0, y: 1)
                    }
                    Text("tap to flip \u{00B7} swipe next \u{2192}")
                        .font(.system(size: 8, weight: .medium))
                        .foregroundColor(.white.opacity(0.45))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.black.opacity(0.2))
                        .clipShape(Capsule())
                        .padding(.bottom, 12)
                }

                // Top header overlay
                VStack {
                    HStack {
                        Spacer()
                        Text("\(cardIndex + 1) / \(totalCards)")
                            .font(.system(size: 9, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color.black.opacity(0.35))
                            .clipShape(Capsule())
                        Spacer()
                    }
                    .padding(.top, 8)
                    Spacer()
                }
            }
        }
    }

    private func highlightedSentence(_ text: String, word: String) -> AttributedString {
        var attr = AttributedString(text)
        if let range = attr.range(of: word, options: .caseInsensitive) {
            attr[range].font = .system(size: 24, weight: .black)
            attr[range].foregroundColor = Color(hex: "#FFC800")
            attr[range].underlineStyle = .single
            attr[range].underlineColor = .init(Color(hex: "#FFC800").opacity(0.4))
        }
        return attr
    }
}
