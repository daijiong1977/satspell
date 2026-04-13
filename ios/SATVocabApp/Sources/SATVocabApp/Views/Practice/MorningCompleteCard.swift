import SwiftUI

struct MorningCompleteCard: View {
    var reviewable: Bool = false
    var onReview: (() -> Void)? = nil

    var body: some View {
        Button {
            onReview?()
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(Color(hex: "#58CC02").opacity(0.15))
                        .frame(width: 52, height: 52)
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(Color(hex: "#58CC02"))
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Morning Session")
                        .font(.system(.headline, design: .rounded).weight(.bold))
                        .foregroundStyle(.primary)
                    Text("Complete!")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(Color(hex: "#58CC02"))
                }

                Spacer()

                if reviewable {
                    Text("Review")
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundStyle(Color(hex: "#58CC02"))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color(hex: "#58CC02").opacity(0.1))
                        .clipShape(Capsule())
                }

                Text("\u{2600}\u{FE0F}")
                    .font(.system(size: 22))
            }
            .padding(16)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .strokeBorder(Color(hex: "#58CC02").opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .disabled(!reviewable)
        .accessibilityIdentifier("morningCompleteCard")
    }
}
