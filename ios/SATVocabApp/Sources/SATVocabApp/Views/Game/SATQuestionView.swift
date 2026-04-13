import SwiftUI

struct SATQuestionView: View {
    let question: SatQuestion
    let onAnswer: (Bool) -> Void
    var onWrongAttempt: (() -> Void)? = nil

    @State private var selectedOption: String? = nil
    @State private var showFeedback = false
    @State private var isCorrect: Bool? = nil
    @State private var wrongAttempts: Int = 0
    @State private var autoAdvanceTask: Task<Void, Never>? = nil

    private let options = ["A", "B", "C", "D"]

    /// Replace the target word with "________" so it doesn't give away the answer
    private func blankOutWord(_ text: String) -> String {
        guard let word = question.targetWord, !word.isEmpty else { return text }
        // Match the word + common suffixes (s, es, ed, ing, ly, ness, ment, tion, etc.)
        let escaped = NSRegularExpression.escapedPattern(for: word)
        let pattern = "\\b\(escaped)(s|es|ed|ing|ly|ness|ment|tion|ity|ous|ive|al|er|est|ance|ence|ances|ences)?\\b"
        if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
            let range = NSRange(text.startIndex..., in: text)
            return regex.stringByReplacingMatches(in: text, range: range, withTemplate: "________")
        }
        return text
    }

    private func optionText(for letter: String) -> String {
        let raw: String
        switch letter {
        case "A": raw = question.optionA ?? ""
        case "B": raw = question.optionB ?? ""
        case "C": raw = question.optionC ?? ""
        case "D": raw = question.optionD ?? ""
        default: raw = ""
        }
        return raw
    }

    private var correctLetter: String {
        let answer = (question.deepseekAnswer ?? question.answer ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        if answer.count == 1 && "ABCD".contains(answer.uppercased()) {
            return answer.uppercased()
        }
        if answer.count >= 2 {
            let first = String(answer.prefix(1)).uppercased()
            if "ABCD".contains(first) {
                return first
            }
        }
        for letter in options {
            if optionText(for: letter).lowercased().trimmingCharacters(in: .whitespacesAndNewlines) == answer.lowercased() {
                return letter
            }
        }
        return question.answer?.prefix(1).uppercased() ?? "A"
    }

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                // Passage area
                VStack(alignment: .leading, spacing: 6) {
                    Text("PASSAGE")
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: "#AFAFAF"))
                        .tracking(0.5)

                    if let passage = question.passage, !passage.isEmpty {
                        ScrollView {
                            Text(blankOutWord(passage))
                                .font(.system(size: 20, weight: .regular, design: .serif))
                                .foregroundColor(Color(hex: "#4B4B4B"))
                                .lineSpacing(2)
                        }
                    }
                }
                .padding(12)
                .frame(maxWidth: .infinity, maxHeight: geo.size.height * 0.5, alignment: .topLeading)
                .background(Color(hex: "#FFF8E1"))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Color(hex: "#FFE082"), lineWidth: 2)
                )
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .padding(.horizontal, 12)

                // Question text
                if let questionText = question.question {
                    Text(blankOutWord(questionText))
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color(hex: "#4B4B4B"))
                        .fixedSize(horizontal: false, vertical: true)
                        .minimumScaleFactor(0.7)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 6)
                }

                // Answer options
                VStack(spacing: 4) {
                    ForEach(options, id: \.self) { letter in
                        answerRow(letter: letter)
                    }
                }
                .padding(.horizontal, 12)

                Spacer(minLength: 4)

                // CHECK button
                Button {
                    guard let selected = selectedOption, !showFeedback else { return }
                    let correct = selected == correctLetter
                    isCorrect = correct
                    showFeedback = true
                    if !correct {
                        wrongAttempts += 1
                        onWrongAttempt?()
                    }
                } label: {
                    Text("CHECK")
                        .font(.system(size: 22, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(selectedOption != nil && !showFeedback ? Color(hex: "#58CC02") : Color(hex: "#E5E5E5"))
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                .disabled(selectedOption == nil || showFeedback)
                .padding(.horizontal, 16)
                .padding(.bottom, 10)
            }
        }
        .sheet(isPresented: $showFeedback) {
            Group {
                if isCorrect == true {
                    // CORRECT — show explanation, auto-advance after 4s
                    SATFeedbackSheet(
                        mode: .correct,
                        correctAnswerText: "\(correctLetter). \(optionText(for: correctLetter))",
                        explanation: question.explanation ?? question.deepseekReason ?? question.deepseekBackground ?? "",
                        buttonLabel: "NEXT →",
                        onNext: {
                            autoAdvanceTask?.cancel()
                            showFeedback = false
                            onAnswer(true)
                        }
                    )
                    .onAppear {
                        autoAdvanceTask = Task {
                            try? await Task.sleep(nanoseconds: 4_000_000_000)
                            if !Task.isCancelled {
                                await MainActor.run {
                                    showFeedback = false
                                    onAnswer(true)
                                }
                            }
                        }
                    }
                    .onDisappear {
                        autoAdvanceTask?.cancel()
                    }
                } else if wrongAttempts < 2 {
                    // FIRST WRONG — encourage retry
                    SATFeedbackSheet(
                        mode: .firstWrong,
                        correctAnswerText: "",
                        explanation: "Read the passage carefully and try again!",
                        buttonLabel: "TRY AGAIN",
                        onNext: {
                            showFeedback = false
                            selectedOption = nil
                            isCorrect = nil
                        }
                    )
                } else {
                    // SECOND WRONG — show correct answer + full explanation
                    SATFeedbackSheet(
                        mode: .secondWrong,
                        correctAnswerText: "\(correctLetter). \(optionText(for: correctLetter))",
                        explanation: question.explanation ?? question.deepseekReason ?? question.deepseekBackground ?? "The correct answer is \(correctLetter).",
                        buttonLabel: "GOT IT →",
                        onNext: {
                            showFeedback = false
                            onAnswer(false)
                        }
                    )
                }
            }
            .presentationDetents([.fraction(0.5)])
        }
    }

    @ViewBuilder
    private func answerRow(letter: String) -> some View {
        let isSelected = selectedOption == letter
        let isCorrectOption = showFeedback && (isCorrect == true) && letter == correctLetter
        let isWrongSelected = showFeedback && isSelected && letter != correctLetter

        Button {
            guard !showFeedback else { return }
            selectedOption = letter
        } label: {
            HStack(spacing: 8) {
                ZStack {
                    Circle()
                        .stroke(isSelected ? Color(hex: "#1CB0F6") : Color(hex: "#E5E5E5"), lineWidth: 2)
                        .fill(isSelected ? Color(hex: "#1CB0F6") : .clear)
                        .frame(width: 22, height: 22)

                    Text(letter)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(isSelected ? .white : Color(hex: "#AFAFAF"))
                }

                Text(optionText(for: letter))
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(Color(hex: "#4B4B4B"))
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer()
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
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

// MARK: - Feedback Sheet

struct SATFeedbackSheet: View {
    enum Mode {
        case correct
        case firstWrong
        case secondWrong
    }

    let mode: Mode
    let correctAnswerText: String  // e.g. "B. ameliorate"
    let explanation: String
    var buttonLabel: String = "NEXT →"
    let onNext: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Header
            HStack {
                switch mode {
                case .correct:
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(Color(hex: "#58CC02"))
                    Text("Correct!")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: "#58CC02"))
                case .firstWrong:
                    Image(systemName: "arrow.counterclockwise.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(Color(hex: "#FF9600"))
                    Text("Try again!")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: "#FF9600"))
                case .secondWrong:
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(Color(hex: "#FF4B4B"))
                    Text("Not quite")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: "#FF4B4B"))
                }
                Spacer()
            }

            // Correct answer (shown for correct + 2nd wrong)
            if !correctAnswerText.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("CORRECT ANSWER")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Color(hex: "#AFAFAF"))
                        .tracking(0.5)
                    Text(correctAnswerText)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(Color(hex: "#58CC02"))
                }
            }

            // Explanation
            if !explanation.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    if mode != .firstWrong {
                        Text("EXPLANATION")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(Color(hex: "#AFAFAF"))
                            .tracking(0.5)
                    }
                    Text(explanation)
                        .font(.system(size: 20, weight: .regular))
                        .foregroundColor(Color(hex: "#555555"))
                        .lineSpacing(3)
                }
            }

            Spacer()

            Button3D(buttonLabel, action: onNext)
                .padding(.horizontal, 4)
        }
        .padding(20)
        .background(backgroundColor)
    }

    private var backgroundColor: Color {
        switch mode {
        case .correct: return Color(hex: "#58CC02").opacity(0.05)
        case .firstWrong: return Color(hex: "#FF9600").opacity(0.05)
        case .secondWrong: return Color(hex: "#FF4B4B").opacity(0.05)
        }
    }
}
