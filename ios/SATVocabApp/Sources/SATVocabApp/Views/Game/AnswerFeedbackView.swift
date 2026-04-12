import SwiftUI

struct AnswerFeedbackView: View {
    let isCorrect: Bool
    let word: String
    let xpEarned: Int

    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0

    var body: some View {
        VStack(spacing: 8) {
            if isCorrect {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(Color(hex: "#58CC02"))

                Text("Nailed it.")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "#58CC02"))

                if xpEarned > 0 {
                    XPChipView(xp: xpEarned)
                }
            } else {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(Color(hex: "#FF4B4B"))

                Text("Not yet \u{2014} you'll get it.")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "#FF4B4B"))

                Text("The answer was \(word)")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color(hex: "#AFAFAF"))
            }
        }
        .padding(24)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .scaleEffect(scale)
        .opacity(opacity)
        .onAppear {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                scale = 1.0
                opacity = 1.0
            }
        }
    }
}
