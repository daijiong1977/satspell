import SwiftUI

struct SessionCompleteView: View {
    let xpEarned: Int
    let totalCorrect: Int
    let totalAttempts: Int
    let wordsPromoted: Int
    let wordsDemoted: Int
    let onDone: () -> Void

    private var accuracy: Int {
        totalAttempts > 0 ? Int(Double(totalCorrect) / Double(totalAttempts) * 100) : 0
    }

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            // Celebration
            Text("Session Complete!")
                .font(.system(size: 24, weight: .black, design: .rounded))
                .foregroundColor(Color(hex: "#4B4B4B"))

            Text("Great work today")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color(hex: "#AFAFAF"))

            // XP earned
            VStack(spacing: 4) {
                Text("+\(xpEarned)")
                    .font(.system(size: 48, weight: .black, design: .rounded))
                    .foregroundColor(Color(hex: "#FFC800"))
                Text("XP EARNED")
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "#AFAFAF"))
                    .tracking(0.5)
            }
            .padding(.vertical, 8)

            // Stats grid
            HStack(spacing: 20) {
                statItem(value: "\(accuracy)%", label: "Accuracy", color: "#58CC02")
                statItem(value: "\(totalCorrect)/\(totalAttempts)", label: "Correct", color: "#1CB0F6")
            }

            HStack(spacing: 20) {
                if wordsPromoted > 0 {
                    statItem(value: "+\(wordsPromoted)", label: "Promoted", color: "#58CC02")
                }
                if wordsDemoted > 0 {
                    statItem(value: "-\(wordsDemoted)", label: "Demoted", color: "#FF7043")
                }
            }

            Spacer()

            // Share button placeholder
            Button {
                // Share functionality placeholder
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 13, weight: .semibold))
                    Text("Share Progress")
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                }
                .foregroundColor(Color(hex: "#1CB0F6"))
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color(hex: "#1CB0F6").opacity(0.1))
                .clipShape(Capsule())
            }

            // Done button
            Button3D("Done", action: onDone)
                .padding(.horizontal, 40)
                .padding(.bottom, 30)
        }
        .background(Color.white)
    }

    @ViewBuilder
    private func statItem(value: String, label: String, color: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 22, weight: .heavy, design: .rounded))
                .foregroundColor(Color(hex: color))
            Text(label.uppercased())
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .foregroundColor(Color(hex: "#AFAFAF"))
                .tracking(0.5)
        }
        .frame(minWidth: 80)
        .padding(.vertical, 12)
        .background(Color(hex: color).opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}
