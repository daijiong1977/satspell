import SwiftUI

struct QuickRecallView: View {
    let card: VocabCard
    let definitionChoices: [DefinitionChoice]
    let onAnswer: (Bool) -> Void

    @State private var selectedIndex: Int? = nil
    @State private var isCorrect: Bool? = nil
    @State private var showFeedback = false

    struct DefinitionChoice: Identifiable {
        let id: Int  // word id
        let definition: String
        let isCorrect: Bool
    }

    var body: some View {
        VStack(spacing: 16) {
            Spacer()

            // Word display
            VStack(spacing: 6) {
                Text("WHAT DOES THIS MEAN?")
                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                    .foregroundColor(Color(hex: "#AFAFAF"))
                    .tracking(0.5)

                Text(card.lemma.uppercased())
                    .font(.system(size: 28, weight: .heavy, design: .rounded))
                    .foregroundColor(Color(hex: "#4B4B4B"))

                Text("from this morning")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(Color(hex: "#CE82FF"))
            }

            Spacer()

            // 4 vertical definition choices
            VStack(spacing: 8) {
                ForEach(Array(definitionChoices.enumerated()), id: \.element.id) { index, choice in
                    definitionButton(choice: choice, index: index)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
        .allowsHitTesting(!showFeedback)
    }

    @ViewBuilder
    private func definitionButton(choice: DefinitionChoice, index: Int) -> some View {
        let isSelected = selectedIndex == index
        let bgColor: Color = {
            guard showFeedback else { return .white }
            if isSelected && isCorrect == true { return Color(hex: "#58CC02").opacity(0.15) }
            if isSelected && isCorrect == false { return Color(hex: "#FF4B4B").opacity(0.15) }
            if choice.isCorrect && isCorrect == false { return Color(hex: "#58CC02").opacity(0.15) }
            return .white
        }()
        let borderColor: Color = {
            guard showFeedback else { return Color(hex: "#E5E5E5") }
            if isSelected && isCorrect == true { return Color(hex: "#58CC02") }
            if isSelected && isCorrect == false { return Color(hex: "#FF4B4B") }
            if choice.isCorrect && isCorrect == false { return Color(hex: "#58CC02") }
            return Color(hex: "#E5E5E5")
        }()

        Button {
            guard !showFeedback else { return }
            selectedIndex = index
            let correct = choice.isCorrect
            isCorrect = correct
            showFeedback = true

            let delay: Double = correct ? 1.0 : 2.0
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                onAnswer(correct)
            }
        } label: {
            Text(choice.definition)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(Color(hex: "#4B4B4B"))
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(bgColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(borderColor, lineWidth: 1.5)
                )
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}
