import SwiftUI

struct ResumeCard: View {
    let session: SessionState
    var onResume: () -> Void = {}

    var body: some View {
        Button(action: onResume) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(Color.orange.opacity(0.15))
                        .frame(width: 52, height: 52)
                    Image(systemName: "play.fill")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.orange)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Resume \(session.sessionType.rawValue.capitalized)")
                        .font(.system(.headline, design: .rounded).weight(.bold))
                    Text("Step \(session.stepIndex + 1), Item \(session.itemIndex + 1)")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Text("Resume")
                    .font(.system(.headline, design: .rounded).weight(.semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 10)
                    .background(Color.orange)
                    .clipShape(Capsule())
            }
            .padding(16)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .strokeBorder(Color.orange.opacity(0.4), lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
}
