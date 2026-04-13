import SwiftUI

struct MorningCompleteCard: View {
    var reviewable: Bool = false
    var onReview: (() -> Void)? = nil
    var onReviewStep: ((Int) -> Void)? = nil  // 0=flashcard, 1=image game, 2=questions

    var body: some View {
        VStack(spacing: 0) {
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

                Text("\u{2600}\u{FE0F}")
                    .font(.system(size: 22))
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, reviewable ? 10 : 16)

            if reviewable {
                // 3 review step buttons
                HStack(spacing: 8) {
                    reviewButton(icon: "rectangle.stack", label: "Flashcards", step: 0)
                    reviewButton(icon: "photo", label: "Image Game", step: 1)
                    reviewButton(icon: "doc.text", label: "Questions", step: 2)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 14)
            }
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(Color(hex: "#58CC02").opacity(0.2), lineWidth: 1)
        )
        .accessibilityIdentifier("morningCompleteCard")
    }

    @ViewBuilder
    private func reviewButton(icon: String, label: String, step: Int) -> some View {
        Button {
            onReviewStep?(step)
        } label: {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                Text(label)
                    .font(.system(size: 11, weight: .semibold, design: .rounded))
            }
            .foregroundStyle(Color(hex: "#58CC02"))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(Color(hex: "#58CC02").opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}
