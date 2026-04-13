import SwiftUI
import AVFoundation

struct SessionHeaderView: View {
    let stepNumber: Int
    let totalSteps: Int
    let stepLabel: String
    var currentWord: String = ""
    let currentItem: Int
    let totalItems: Int
    let progressColor: Color
    let isScored: Bool
    let onClose: () -> Void

    private let synthesizer = AVSpeechSynthesizer()

    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 12) {
                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(hex: "#AFAFAF"))
                        .frame(width: 36, height: 36)
                }

                // Compact info
                HStack(spacing: 6) {
                    Text("\(stepNumber)/\(totalSteps)")
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundColor(isScored ? progressColor : Color(hex: "#AFAFAF"))

                    if !currentWord.isEmpty {
                        Text("\u{00B7}")
                            .foregroundColor(Color(hex: "#AFAFAF"))
                        Text(currentWord.uppercased())
                            .font(.system(size: 15, weight: .black, design: .rounded))
                            .foregroundColor(Color(hex: "#FFC800"))
                            .lineLimit(1)
                    }

                    Text("\(currentItem)/\(totalItems)")
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundColor(Color(hex: "#AFAFAF"))
                }
                .frame(maxWidth: .infinity)

                // Sound button — pronounces the current word
                Button {
                    speakWord()
                } label: {
                    Image(systemName: "speaker.wave.2.fill")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(currentWord.isEmpty ? Color(hex: "#AFAFAF") : Color(hex: "#1CB0F6"))
                        .frame(width: 36, height: 36)
                }
                .disabled(currentWord.isEmpty)
            }
            .padding(.horizontal, 8)

            // Progress bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3, style: .continuous)
                        .fill(Color(hex: "#E5E5E5"))

                    RoundedRectangle(cornerRadius: 3, style: .continuous)
                        .fill(progressColor)
                        .frame(width: geo.size.width * CGFloat(currentItem) / CGFloat(max(totalItems, 1)))
                }
            }
            .frame(height: 5)
            .padding(.horizontal, 12)
        }
        .padding(.top, 4)
        .padding(.bottom, 2)
        .contentShape(Rectangle())  // Entire header area is tappable
        .background(Color.white.opacity(0.001))  // Ensure hit testing works
    }

    private func speakWord() {
        guard !currentWord.isEmpty else { return }
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        let utterance = AVSpeechUtterance(string: currentWord)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate * 0.85
        synthesizer.speak(utterance)
    }
}
