import SwiftUI

struct EveningCompleteCard: View {
    var reviewable: Bool = false
    var onReview: (() -> Void)? = nil
    var onReviewStep: ((Int) -> Void)? = nil

    var body: some View {
        VStack(spacing: 0) {
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

                Text("\u{1F319}")
                    .font(.system(size: 22))
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, reviewable ? 10 : 16)

            if reviewable {
                HStack(spacing: 8) {
                    reviewButton(icon: "rectangle.stack", label: "Flashcards", step: 0, color: .indigo)
                    reviewButton(icon: "brain.head.profile", label: "Recall", step: 1, color: .indigo)
                    reviewButton(icon: "photo", label: "Image", step: 2, color: .indigo)
                    reviewButton(icon: "doc.text", label: "Questions", step: 3, color: .indigo)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 14)
            }
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(Color.indigo.opacity(0.2), lineWidth: 1)
        )
        .accessibilityIdentifier("eveningCompleteCard")
    }

    @ViewBuilder
    private func reviewButton(icon: String, label: String, step: Int, color: Color) -> some View {
        Button {
            onReviewStep?(step)
        } label: {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                Text(label)
                    .font(.system(size: 10, weight: .semibold, design: .rounded))
            }
            .foregroundStyle(color)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(color.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}
