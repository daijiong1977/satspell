import SwiftUI

struct EveningCompleteCard: View {
    var reviewable: Bool = false
    var onReview: (() -> Void)? = nil

    var body: some View {
        Button {
            onReview?()
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(Color.indigo.opacity(0.15))
                        .frame(width: 52, height: 52)
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.indigo)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Evening Session")
                        .font(.system(.headline, design: .rounded).weight(.bold))
                        .foregroundStyle(.primary)
                    Text("Complete!")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(.indigo)
                }

                Spacer()

                if reviewable {
                    Text("Review")
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundStyle(.indigo)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.indigo.opacity(0.1))
                        .clipShape(Capsule())
                }

                Text("\u{1F319}")
                    .font(.system(size: 22))
            }
            .padding(16)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .strokeBorder(Color.indigo.opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .disabled(!reviewable)
        .accessibilityIdentifier("eveningCompleteCard")
    }
}
