import SwiftUI

struct SatMCQRoundView: View {
    let target: VocabCard
    let question: SatQuestion
    /// - Parameters:
    ///   - isCorrect: Whether the chosen answer is correct.
    ///   - keepInReview: Whether this word should be flagged for review even if eventually answered correctly.
    let onSubmit: (_ isCorrect: Bool, _ keepInReview: Bool) -> Void
    let onNext: () -> Void

    @State private var selected: String? = nil
    @State private var didMiss = false
    @State private var showFeedbackSheet = false
    @State private var sheetVerdict: Bool? = nil

    private var keywordTerm: String {
        let kw = target.lemma.trimmingCharacters(in: .whitespacesAndNewlines)
        if !kw.isEmpty { return kw }
        return (question.targetWord ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                if let passage = question.passage, !passage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    Text(passage)
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(.primary)
                        .padding(14)
                        .background(Color.gray.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }

                Text(question.question ?? "")
                    .font(.system(.title3, design: .rounded).weight(.semibold))

                VStack(spacing: 10) {
                    optionRow(letter: "A", text: question.optionA)
                    optionRow(letter: "B", text: question.optionB)
                    optionRow(letter: "C", text: question.optionC)
                    optionRow(letter: "D", text: question.optionD)
                }
            }
            .padding(.top, 8)
        }
        .onChange(of: question.id) { _, _ in
            selected = nil
            didMiss = false
            showFeedbackSheet = false
            sheetVerdict = nil
        }
        .sheet(isPresented: $showFeedbackSheet) {
            feedbackSheet
        }
    }

    @ViewBuilder
    private func optionRow(letter: String, text: String?) -> some View {
        let display = (text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)

        Button {
            guard !display.isEmpty else { return }
            guard showFeedbackSheet == false else { return }
            selected = letter
            let correct = isCorrectSelection(letter: letter, optionText: display)
            if !correct { didMiss = true }

            // Log incorrect attempts, and keep the word in review if it was ever missed.
            if correct {
                onSubmit(true, didMiss)
            } else {
                onSubmit(false, true)
            }

            sheetVerdict = correct
            showFeedbackSheet = true
        } label: {
            HStack(alignment: .top, spacing: 12) {
                Text(letter)
                    .font(.system(.headline, design: .rounded).weight(.bold))
                    .frame(width: 28, height: 28)
                    .background(Color.gray.opacity(0.12))
                    .clipShape(Circle())

                Text(display)
                    .font(.system(.headline, design: .rounded))
                    .foregroundStyle(.primary)

                Spacer(minLength: 0)
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 14)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .strokeBorder(Color.gray.opacity(0.12), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .disabled(display.isEmpty)
        .opacity(display.isEmpty ? 0.35 : 1.0)
    }

    private var feedbackSheet: some View {
        let verdict = (sheetVerdict == true)
        let snippet = sentenceSnippet(passage: question.passage, questionText: question.question, term: keywordTerm)

        return NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text(verdict ? "Right" : "Wrong")
                        .font(.system(.title3, design: .rounded).weight(.bold))
                        .foregroundStyle(verdict ? Color.green : Color.red)

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Key word")
                            .font(.system(.caption, design: .rounded).weight(.bold))
                            .foregroundStyle(.secondary)
                        Text(keywordTerm)
                            .font(.system(.headline, design: .rounded).weight(.semibold))
                            .foregroundStyle(Color.brown)
                    }

                    highlightedText(snippet, term: keywordTerm)
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(.primary)

                    if let def = target.definition, !def.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Meaning")
                                .font(.system(.caption, design: .rounded).weight(.bold))
                                .foregroundStyle(.secondary)
                            Text(def)
                                .font(.system(.headline, design: .rounded))
                                .foregroundStyle(.primary)
                        }
                    }

                    if let bg = question.deepseekBackground?.trimmingCharacters(in: .whitespacesAndNewlines), !bg.isEmpty {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Background")
                                .font(.system(.caption, design: .rounded).weight(.bold))
                                .foregroundStyle(.secondary)
                            Text(bg)
                                .font(.system(.body, design: .rounded))
                                .foregroundStyle(.primary)
                        }
                    }

                    if let reason = question.deepseekReason?.trimmingCharacters(in: .whitespacesAndNewlines), !reason.isEmpty {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Explanation")
                                .font(.system(.caption, design: .rounded).weight(.bold))
                                .foregroundStyle(.secondary)
                            Text(reason)
                                .font(.system(.body, design: .rounded))
                                .foregroundStyle(.primary)
                        }
                    }

                    if let ans = question.deepseekAnswer?.trimmingCharacters(in: .whitespacesAndNewlines), !ans.isEmpty {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Answer")
                                .font(.system(.caption, design: .rounded).weight(.bold))
                                .foregroundStyle(.secondary)
                            Text(ans)
                                .font(.system(.body, design: .rounded).weight(.semibold))
                                .foregroundStyle(.primary)
                        }
                    }

                    if question.deepseekBackground == nil && question.deepseekReason == nil && question.deepseekAnswer == nil {
                        Text("(No DeepSeek feedback yet)")
                            .font(.system(.body, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(16)
            }
            .navigationTitle("Feedback")
            .navigationBarTitleDisplayMode(.inline)
            .safeAreaInset(edge: .bottom) {
                HStack {
                    if verdict {
                        Button("Next") {
                            showFeedbackSheet = false
                            selected = nil
                            sheetVerdict = nil
                            onNext()
                        }
                        .buttonStyle(.borderedProminent)
                    } else {
                        Button("Try again") {
                            showFeedbackSheet = false
                            selected = nil
                            sheetVerdict = nil
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(.white)
            }
        }
    }

    private func highlightedText(_ text: String, term: String) -> Text {
        guard !text.isEmpty else { return Text("") }
        guard !term.isEmpty else { return Text(text) }

        let nsText = text as NSString
        let pattern = "\\b" + NSRegularExpression.escapedPattern(for: term) + "\\b"
        let regex = (try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]))
        let matches = regex?.matches(in: text, range: NSRange(location: 0, length: nsText.length)) ?? []

        guard !matches.isEmpty else { return Text(text) }

        var out = Text("")
        var cursor = 0
        for m in matches {
            if m.range.location > cursor {
                out = out + Text(nsText.substring(with: NSRange(location: cursor, length: m.range.location - cursor)))
            }
            let matched = nsText.substring(with: m.range)
            out = out + Text(matched)
                .fontWeight(.bold)
                .foregroundStyle(Color.brown)
            cursor = m.range.location + m.range.length
        }
        if cursor < nsText.length {
            out = out + Text(nsText.substring(from: cursor))
        }
        return out
    }

    private func sentenceSnippet(passage: String?, questionText: String?, term: String) -> String {
        let cleanedPassage = (passage ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedQuestion = (questionText ?? "").trimmingCharacters(in: .whitespacesAndNewlines)

        let source = !cleanedPassage.isEmpty ? cleanedPassage : cleanedQuestion
        guard !source.isEmpty else { return term }
        guard !term.isEmpty else { return source }

        // Try to pick a single sentence containing the term.
        let parts = source
            .replacingOccurrences(of: "\n", with: " ")
            .split(separator: ".")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        if let hit = parts.first(where: { $0.range(of: term, options: [.caseInsensitive, .diacriticInsensitive]) != nil }) {
            return hit + "."
        }

        return source
    }

    private func normalizeAnswerText(_ s: String?) -> String {
        let raw = (s ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        if raw.isEmpty { return "" }

        // Drop common leading markers like "A.", "A)", "A:".
        if raw.count >= 2 {
            let prefix2 = raw.prefix(2)
            if prefix2.count == 2 {
                let first = prefix2.prefix(1).uppercased()
                let second = prefix2.suffix(1)
                if ["A", "B", "C", "D"].contains(first), [".", ")", ":"].contains(String(second)) {
                    let dropped = raw.dropFirst(2)
                    return normalizeAnswerText(String(dropped))
                }
            }
        }

        // Lowercase + collapse whitespace.
        let lowered = raw.lowercased()
        let parts = lowered.split(whereSeparator: { $0.isWhitespace })
        return parts.joined(separator: " ")
    }

    private func correctLetterFromQuestion() -> String? {
        let ansRaw = (question.answer ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let ansNorm = normalizeAnswerText(ansRaw)

        // Case 1: stored as letter.
        if ["a", "b", "c", "d"].contains(ansNorm) {
            return ansNorm.uppercased()
        }

        // Case 2: stored as full correct option text.
        let options: [(String, String)] = [
            ("A", normalizeAnswerText(question.optionA)),
            ("B", normalizeAnswerText(question.optionB)),
            ("C", normalizeAnswerText(question.optionC)),
            ("D", normalizeAnswerText(question.optionD))
        ]
        for (letter, optNorm) in options {
            if !optNorm.isEmpty, optNorm == ansNorm {
                return letter
            }
        }
        return nil
    }

    private func isCorrectSelection(letter: String, optionText: String) -> Bool {
        if let correctLetter = correctLetterFromQuestion() {
            return correctLetter == letter
        }
        // Fallback: compare normalized option text against normalized stored answer text.
        let ansNorm = normalizeAnswerText(question.answer)
        let optNorm = normalizeAnswerText(optionText)
        return !ansNorm.isEmpty && ansNorm == optNorm
    }
}
