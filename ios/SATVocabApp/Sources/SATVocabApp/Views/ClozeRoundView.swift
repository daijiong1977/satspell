import SwiftUI

struct ClozeRoundView: View {
    let target: VocabCard
    let context: String
    let choices: [VocabCard]
    let correctWordId: Int
    /// - Parameters:
    ///   - isCorrect: Whether the chosen answer is correct.
    ///   - keepInReview: Whether this word should be flagged for review even if eventually answered correctly.
    let onSubmit: (_ isCorrect: Bool, _ keepInReview: Bool) -> Void
    let onNext: () -> Void

    @State private var locked = false
    @State private var isCorrect: Bool? = nil
    @State private var didMiss = false
    @State private var showTryAgain = false

    var body: some View {
        GeometryReader { geo in
            // Keep everything on one screen: shrink image slightly so the 2x2 choices aren't cut off.
            let imageHeight = min(max(200, geo.size.height * 0.55), 420)
            let bottomSafePadding = max(10, geo.safeAreaInsets.bottom)

            VStack(spacing: 12) {
                ZStack(alignment: .bottomLeading) {
                    if let ui = ImageResolver.uiImage(for: target.imageFilename) {
                        Image(uiImage: ui)
                            .resizable(resizingMode: .stretch) // allow distortion, but never crop
                            .frame(maxWidth: .infinity)
                            .frame(height: imageHeight)
                    } else {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color.gray.opacity(0.15))
                            .frame(height: imageHeight)
                            .overlay(
                                Image(systemName: "photo")
                                    .font(.system(size: 24, weight: .semibold))
                                    .foregroundStyle(.gray.opacity(0.6))
                            )
                    }

                    Text("Choose the best word")
                        .font(.system(.caption, design: .rounded).weight(.bold))
                        .foregroundStyle(.white)
                        .padding(10)
                        .background(Color.black.opacity(0.35))
                        .clipShape(Capsule())
                        .padding(12)
                }
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

                if isCorrect == true {
                    feedbackViewCorrect()
                } else if showTryAgain {
                    tryAgainView
                } else {
                    Text(clozeSentence)
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(14)
                        .background(Color.gray.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                    LazyVGrid(
                        columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)],
                        spacing: 10
                    ) {
                        ForEach(choices, id: \.id) { choice in
                            Button {
                                guard !locked else { return }
                                let correct = (choice.id == correctWordId)
                                if correct {
                                    locked = true
                                    isCorrect = true
                                    onSubmit(true, didMiss)

                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                        // Avoid stale auto-advance if the view already moved on.
                                        guard isCorrect == true else { return }
                                        onNext()
                                    }
                                } else {
                                    didMiss = true
                                    onSubmit(false, true)

                                    locked = true
                                    showTryAgain = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                        // Return to the original question until the user gets it right.
                                        guard showTryAgain, isCorrect != true else { return }
                                        showTryAgain = false
                                        locked = false
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(choice.lemma)
                                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                                        .lineLimit(1)
                                    Spacer(minLength: 0)
                                }
                                .frame(maxWidth: .infinity)
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
                        }
                    }
                }
            }
            .padding(.top, 8)
            .padding(.bottom, bottomSafePadding)
            .frame(width: geo.size.width, height: geo.size.height, alignment: .top)
        }
        .onChange(of: target.id) { _, _ in
            locked = false
            isCorrect = nil
            didMiss = false
            showTryAgain = false
        }
    }

    @ViewBuilder
    private func feedbackViewCorrect() -> some View {
        let sentence = TextFill.fillBlankPlaceholders(context, with: target.lemma)
        VStack(alignment: .leading, spacing: 10) {
            Text("Right")
                .font(.system(.headline, design: .rounded).weight(.bold))
                .foregroundStyle(Color.green)

            highlightedText(sentence, term: target.lemma, highlightColor: .green)
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.primary)

            if let def = target.definition, !def.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                Text(def)
                    .font(.system(.body, design: .rounded).weight(.semibold))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(14)
        .background(Color.gray.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    private var tryAgainView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Try again")
                .font(.system(.title3, design: .rounded).weight(.bold))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(Color.gray.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    private func highlightedText(_ text: String, term: String, highlightColor: Color) -> Text {
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
                .foregroundStyle(highlightColor)
            cursor = m.range.location + m.range.length
        }
        if cursor < nsText.length {
            out = out + Text(nsText.substring(from: cursor))
        }
        return out
    }

    private var clozeSentence: String {
        let lemma = target.lemma
        if lemma.isEmpty { return context }

        // Some SAT contexts already contain "______ blank" placeholders.
        // Fill those first so we can reliably turn the target word into "____".
        let filledContext = TextFill.fillBlankPlaceholders(context, with: lemma)

        // Whole-word case-insensitive replacement.
        let escaped = NSRegularExpression.escapedPattern(for: lemma)
        let pattern = "\\b\(escaped)\\b"
        guard let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]) else {
            return filledContext
        }

        let range = NSRange(filledContext.startIndex..<filledContext.endIndex, in: filledContext)
        let replaced = regex.stringByReplacingMatches(in: filledContext, options: [], range: range, withTemplate: "____")
        return replaced == filledContext ? filledContext : replaced
    }
}
