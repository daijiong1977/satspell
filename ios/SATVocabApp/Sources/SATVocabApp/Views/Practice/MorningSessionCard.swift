import SwiftUI

struct MorningSessionCard: View {
    var onStart: () -> Void = {}

    var body: some View {
        Button(action: onStart) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(Color(hex: "#58CC02").opacity(0.15))
                        .frame(width: 52, height: 52)
                    Text("\u{2600}\u{FE0F}")
                        .font(.system(size: 24))
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Morning Session")
                        .font(.system(.headline, design: .rounded).weight(.bold))
                    Text("Learn \(AppConfig.morningNewWords) new words")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Text("Start")
                    .font(.system(.headline, design: .rounded).weight(.semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 10)
                    .background(Color(hex: "#58CC02"))
                    .clipShape(Capsule())
            }
            .padding(16)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .strokeBorder(Color(hex: "#58CC02").opacity(0.3), lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("morningSessionCard")
    }
}
