import SwiftUI

struct SATQuestionView: View {
    let question: SatQuestion
    let onAnswer: (Bool) -> Void

    @State private var selectedOption: String? = nil
    @State private var showFeedback = false
    @State private var isCorrect: Bool? = nil

    private let options = ["A", "B", "C", "D"]

    private func optionText(for letter: String) -> String {
        switch letter {
        case "A": return question.optionA ?? ""
        case "B": return question.optionB ?? ""
        case "C": return question.optionC ?? ""
        case "D": return question.optionD ?? ""
        default: return ""
        }
    }

    private var correctLetter: String {
        // The answer field contains the letter (A/B/C/D) or the full text
        let answer = (question.deepseekAnswer ?? question.answer ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        // Check if it's a single letter
        if answer.count == 1 && "ABCD".contains(answer.uppercased()) {
            return answer.uppercased()
        }
        // Check if it starts with a letter and paren like "A)" or "A."
        if answer.count >= 2 {
            let first = String(answer.prefix(1)).uppercased()
            if "ABCD".contains(first) {
                return first
            }
        }
        // Fallback: match text against options
        for letter in options {
            if optionText(for: letter).lowercased().trimmingCharacters(in: .whitespacesAndNewlines) == answer.lowercased() {
                return letter
            }
        }
        return question.answer?.prefix(1).uppercased() ?? "A"
    }

    var body: some View {
        VStack(spacing: 0) {
            // Passage area (scrollable)
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("PASSAGE")
                            .font(.system(size: 7, weight: .bold, design: .rounded))
                            .foregroundColor(Color(hex: "#AFAFAF"))
                            .tracking(0.5)
                        Spacer()
                        Text("scroll \u{2195}")
                            .font(.system(size: 7, weight: .medium))
                            .foregroundColor(Color(hex: "#AFAFAF"))
                    }

                    if let passage = question.passage, !passage.isEmpty {
                        Text(passage)
                            .font(.system(size: 11, weight: .regular, design: .serif))
                            .foregroundColor(Color(hex: "#4B4B4B"))
                            .lineSpacing(3)
                    }
                }
                .padding(12)
            }
            .frame(maxHeight: 260)
            .background(Color(hex: "#FFF8E1"))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color(hex: "#FFE082"), lineWidth: 2)
            )
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .padding(.horizontal, 12)

            // Divider
            HStack {
                Rectangle().fill(Color(hex: "#E5E5E5")).frame(height: 1)
                Text("QUESTION")
                    .font(.system(size: 7, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "#AFAFAF"))
                    .tracking(0.5)
                Rectangle().fill(Color(hex: "#E5E5E5")).frame(height: 1)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)

            // Question text
            if let questionText = question.question {
                Text(questionText)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(Color(hex: "#4B4B4B"))
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)
            }

            // Answer options
            VStack(spacing: 5) {
                ForEach(options, id: \.self) { letter in
                    answerRow(letter: letter)
                }
            }
            .padding(.horizontal, 12)

            Spacer(minLength: 8)

            // CHECK button
            Button {
                guard let selected = selectedOption, !showFeedback else { return }
                let correct = selected == correctLetter
                isCorrect = correct
                showFeedback = true
            } label: {
                Text("CHECK")
                    .font(.system(size: 15, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(selectedOption != nil && !showFeedback ? Color(hex: "#58CC02") : Color(hex: "#E5E5E5"))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
            .disabled(selectedOption == nil || showFeedback)
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
        }
        .sheet(isPresented: $showFeedback) {
            SATFeedbackSheet(
                isCorrect: isCorrect ?? false,
                targetWord: question.targetWord ?? "",
                correctAnswer: optionText(for: correctLetter),
                explanation: question.deepseekReason ?? question.deepseekBackground ?? "",
                onNext: {
                    showFeedback = false
                    onAnswer(isCorrect ?? false)
                }
            )
            .presentationDetents([.fraction(0.5)])
        }
    }

    @ViewBuilder
    private func answerRow(letter: String) -> some View {
        let isSelected = selectedOption == letter
        let isCorrectOption = showFeedback && letter == correctLetter
        let isWrongSelected = showFeedback && isSelected && letter != correctLetter

        Button {
            guard !showFeedback else { return }
            selectedOption = letter
        } label: {
            HStack(spacing: 10) {
                // Letter circle
                ZStack {
                    Circle()
                        .stroke(isSelected ? Color(hex: "#1CB0F6") : Color(hex: "#E5E5E5"), lineWidth: 2)
                        .fill(isSelected ? Color(hex: "#1CB0F6") : .clear)
                        .frame(width: 18, height: 18)

                    Text(letter)
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(isSelected ? .white : Color(hex: "#AFAFAF"))
                }

                Text(optionText(for: letter))
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(Color(hex: "#4B4B4B"))
                    .multilineTextAlignment(.leading)

                Spacer()
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(
                isCorrectOption ? Color(hex: "#58CC02").opacity(0.1) :
                isWrongSelected ? Color(hex: "#FF4B4B").opacity(0.1) :
                Color.white
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(
                        isCorrectOption ? Color(hex: "#58CC02") :
                        isWrongSelected ? Color(hex: "#FF4B4B") :
                        isSelected ? Color(hex: "#1CB0F6") :
                        Color(hex: "#E5E5E5"),
                        lineWidth: 1.5
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - SAT Feedback Sheet

struct SATFeedbackSheet: View {
    let isCorrect: Bool
    let targetWord: String
    let correctAnswer: String
    let explanation: String
    let onNext: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Verdict
            HStack {
                if isCorrect {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color(hex: "#58CC02"))
                    Text("Correct!")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: "#58CC02"))
                } else {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color(hex: "#FF4B4B"))
                    Text("Not quite.")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: "#FF4B4B"))
                }
                Spacer()
            }

            if !targetWord.isEmpty {
                VStack(alignment: .leading, spacing: 2) {
                    Text("WORD")
                        .font(.system(size: 7, weight: .bold))
                        .foregroundColor(Color(hex: "#AFAFAF"))
                    Text(targetWord)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color(hex: "#4B4B4B"))
                }
            }

            if !correctAnswer.isEmpty {
                VStack(alignment: .leading, spacing: 2) {
                    Text("MEANING")
                        .font(.system(size: 7, weight: .bold))
                        .foregroundColor(Color(hex: "#AFAFAF"))
                    Text(correctAnswer)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(hex: "#4B4B4B"))
                }
            }

            if !explanation.isEmpty {
                VStack(alignment: .leading, spacing: 2) {
                    Text("WHY")
                        .font(.system(size: 7, weight: .bold))
                        .foregroundColor(Color(hex: "#AFAFAF"))
                    Text(explanation)
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(Color(hex: "#666666"))
                        .lineSpacing(2)
                }
            }

            Spacer()

            Button3D("NEXT \u{2192}", action: onNext)
                .padding(.horizontal, 4)
        }
        .padding(20)
        .background(isCorrect ? Color(hex: "#58CC02").opacity(0.05) : Color(hex: "#FF4B4B").opacity(0.05))
    }
}
