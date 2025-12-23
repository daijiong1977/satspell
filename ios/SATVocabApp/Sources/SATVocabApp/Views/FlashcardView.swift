import SwiftUI
import AVFoundation
import Foundation

struct FlashcardView: View {
    let card: VocabCard
    let onForgot: () -> Void
    let onGotIt: () -> Void

    @State private var isFlipped = false

    var body: some View {
        let satContextRaw = (card.satContext ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let exampleRaw = (card.example ?? "").trimmingCharacters(in: .whitespacesAndNewlines)

        let satContext = TextFill.fillBlankPlaceholders(satContextRaw, with: card.lemma)
        let example = TextFill.fillBlankPlaceholders(exampleRaw, with: card.lemma)
        let frontSentence = example.isEmpty ? satContext : example

        ZStack {
            if isFlipped {
                back(context: satContext)
                    .transition(.opacity)
            } else {
                front(sentence: frontSentence)
                    .transition(.opacity)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(maxHeight: .infinity)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.spring(response: 0.55, dampingFraction: 0.85)) {
                isFlipped.toggle()
            }
        }
        .onChange(of: card.id) { _, _ in
            // Always show the front when moving to the next word.
            isFlipped = false
        }
        .rotation3DEffect(
            .degrees(isFlipped ? 180 : 0),
            axis: (x: 0, y: 1, z: 0),
            perspective: 0.75
        )
    }

    private func front(sentence: String) -> some View {
        GeometryReader { geo in
            VStack(alignment: .leading, spacing: 8) {
                VStack(alignment: .leading, spacing: 8) {
                    if sentence.isEmpty {
                        Text(card.lemma)
                            .font(.system(size: 21, design: .rounded).weight(.bold))
                            .foregroundStyle(.primary)
                    } else {
                        highlightedSentence(sentence, term: card.lemma)
                            .font(.system(size: 21, design: .rounded)) // ~body + 4
                            .foregroundStyle(.primary)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    if let def = card.definition, !def.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        Text(def)
                            .font(.system(.body, design: .rounded))
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 6)

                ZStack {
                    if let ui = ImageResolver.uiImage(for: card.imageFilename) {
                        Image(uiImage: ui)
                            .resizable(resizingMode: .stretch) // may change ratio, but never crops content
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        Rectangle()
                            .fill(Color.gray.opacity(0.12))
                            .overlay(
                                Image(systemName: "photo")
                                    .font(.system(size: 36, weight: .semibold))
                                    .foregroundStyle(.gray.opacity(0.6))
                            )
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.gray.opacity(0.06))
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .padding(.horizontal, 16)
                .ignoresSafeArea(.container, edges: .bottom)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .background(.white)
    }

    private func back(context: String) -> some View {
        GeometryReader { geo in
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Definition")
                                .font(.system(.caption, design: .rounded).weight(.bold))
                                .foregroundStyle(.secondary)
                            Text(card.definition ?? "(No definition yet)")
                                .font(.system(.title3, design: .rounded).weight(.bold))
                                .foregroundStyle(.primary)
                        }

                        if let ex = card.example?.trimmingCharacters(in: .whitespacesAndNewlines), !ex.isEmpty {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Example")
                                    .font(.system(.caption, design: .rounded).weight(.bold))
                                    .foregroundStyle(.secondary)
                                highlightedSentence(ex, term: card.lemma)
                                    .font(.system(.headline, design: .rounded))
                                    .foregroundStyle(.primary)
                            }
                        }

                        if let cols = card.collocations, !cols.isEmpty {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Collocations")
                                    .font(.system(.caption, design: .rounded).weight(.bold))
                                    .foregroundStyle(.secondary)

                                VStack(alignment: .leading, spacing: 4) {
                                    ForEach(cols.prefix(3), id: \.self) { phrase in
                                        Text(phrase)
                                            .font(.system(.headline, design: .rounded))
                                            .foregroundStyle(.primary)
                                    }
                                }
                            }
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            Text("SAT Context")
                                .font(.system(.caption, design: .rounded).weight(.bold))
                                .foregroundStyle(.secondary)

                            if context.isEmpty {
                                Text("(No SAT context yet)")
                                    .font(.system(.headline, design: .rounded))
                                    .foregroundStyle(.primary)
                            } else {
                                highlightedSentence(TextFill.fillBlankPlaceholders(context, with: card.lemma), term: card.lemma)
                                    .font(.system(.headline, design: .rounded))
                                    .foregroundStyle(.primary)
                            }
                        }
                        Spacer(minLength: 0)
                }
                .padding(12)
                .frame(maxWidth: .infinity, minHeight: max(0, geo.size.height - 140), alignment: .topLeading)
                .background(Color.gray.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
            .safeAreaInset(edge: .bottom) {
                HStack(spacing: 12) {
                    Button(action: onForgot) {
                        HStack(spacing: 8) {
                            Image(systemName: "xmark")
                            Text("Review")
                        }
                        .font(.system(.headline, design: .rounded).weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.red)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }

                    Button(action: onGotIt) {
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark")
                            Text("Master")
                        }
                        .font(.system(.headline, design: .rounded).weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.green)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 10)
                .padding(.bottom, 12)
                .background(.white)
            }
            .frame(width: geo.size.width, height: geo.size.height, alignment: .top)
        }
        .background(.white)
        // keep text readable after 3D rotation
        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
    }

    private func highlightedSentence(_ text: String, term: String) -> Text {
        guard !text.isEmpty else { return Text("") }
        guard !term.isEmpty else { return Text(text) }

        let nsText = text as NSString
        let pattern = "\\b" + NSRegularExpression.escapedPattern(for: term) + "\\b"
        let regex = (try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]))
        let matches = regex?.matches(in: text, range: NSRange(location: 0, length: nsText.length)) ?? []

        if matches.isEmpty {
            return Text(text)
        }

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
}

struct SoundButton: View {
    let text: String

    private let synthesizer = AVSpeechSynthesizer()

    var body: some View {
        Button {
            let utterance = AVSpeechUtterance(string: text)
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            utterance.rate = AVSpeechUtteranceDefaultSpeechRate
            synthesizer.speak(utterance)
        } label: {
            Image(systemName: "speaker.wave.2.fill")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.blue)
                .padding(8)
                .background(Color.blue.opacity(0.10))
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Pronounce word")
    }
}
