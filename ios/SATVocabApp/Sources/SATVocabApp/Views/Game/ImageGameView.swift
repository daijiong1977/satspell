import SwiftUI

struct ImageGameView: View {
    let card: VocabCard
    let choices: [VocabCard]  // 4 choices including the correct one
    let roundIndex: Int
    let totalRounds: Int
    let onAnswer: (Bool) -> Void

    @State private var selectedId: Int? = nil
    @State private var isCorrect: Bool? = nil
    @State private var showFeedback = false

    private var clozeSentence: String {
        guard let example = card.example else { return "________" }
        let clean = example.replacingOccurrences(of: "**", with: "")
        let pattern = "\\b\(NSRegularExpression.escapedPattern(for: card.lemma))\\b"
        if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
            let range = NSRange(clean.startIndex..., in: clean)
            return regex.stringByReplacingMatches(in: clean, range: range, withTemplate: "________")
        }
        return clean
    }

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                // Image area — ~60% of available height
                ZStack(alignment: .bottom) {
                    if let ui = ImageResolver.uiImage(for: card.imageFilename) {
                        Image(uiImage: ui)
                            .resizable()
                            .scaledToFill()
                            .frame(width: geo.size.width - 24, height: geo.size.height * 0.55)
                            .clipped()
                    } else {
                        LinearGradient(
                            colors: [Color(hex: "#4A90D9"), Color(hex: "#2C5F8A")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    }

                    // Bottom gradient with caption
                    LinearGradient(
                        gradient: Gradient(colors: [.clear, Color.black.opacity(0.5)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 80)

                    Text("CHOOSE THE BEST WORD")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .tracking(0.5)
                        .padding(.bottom, 8)
                }
                .frame(height: geo.size.height * 0.55)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .padding(.horizontal, 12)

                // Cloze sentence — no line limit, auto-shrinks for long text
                Text(clozeSentence)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(Color(hex: "#4B4B4B"))
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.6)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: "#F7F7F7"))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .padding(.horizontal, 12)
                    .padding(.top, 8)

                Spacer(minLength: 4)

                // 2x2 answer grid
                VStack(spacing: 8) {
                    ForEach(0..<2, id: \.self) { row in
                        HStack(spacing: 8) {
                            ForEach(0..<2, id: \.self) { col in
                                let index = row * 2 + col
                                if index < choices.count {
                                    answerButton(for: choices[index])
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 12)
                .padding(.bottom, 12)
            }
        }
        .allowsHitTesting(!showFeedback)
    }

    @ViewBuilder
    private func answerButton(for choice: VocabCard) -> some View {
        let isSelected = selectedId == choice.id
        let isCorrectAnswer = choice.id == card.id
        let bgColor: Color = {
            guard showFeedback else { return .white }
            if isSelected && isCorrect == true { return Color(hex: "#58CC02").opacity(0.2) }
            if isSelected && isCorrect == false { return Color(hex: "#FF4B4B").opacity(0.2) }
            if isCorrectAnswer && isCorrect == false { return Color(hex: "#58CC02").opacity(0.2) }
            return .white
        }()
        let borderColor: Color = {
            guard showFeedback else { return Color(hex: "#E5E5E5") }
            if isSelected && isCorrect == true { return Color(hex: "#58CC02") }
            if isSelected && isCorrect == false { return Color(hex: "#FF4B4B") }
            if isCorrectAnswer && isCorrect == false { return Color(hex: "#58CC02") }
            return Color(hex: "#E5E5E5")
        }()

        Button {
            guard !showFeedback else { return }
            selectedId = choice.id
            let correct = choice.id == card.id
            isCorrect = correct
            showFeedback = true

            let delay: Double = correct ? 1.5 : 2.5
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                onAnswer(correct)
            }
        } label: {
            Text(choice.lemma)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(Color(hex: "#4B4B4B"))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(bgColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(borderColor, lineWidth: 2)
                )
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}
