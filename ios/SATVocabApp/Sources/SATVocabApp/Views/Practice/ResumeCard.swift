import SwiftUI

struct ResumeCard: View {
    let session: SessionState
    var onResume: () -> Void = {}
    var onRestart: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 0) {
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
                    Text("Paused: \(session.sessionType.rawValue.capitalized) Session")
                        .font(.system(.headline, design: .rounded).weight(.bold))
                    Text("Step \(session.stepIndex + 1), Item \(session.itemIndex + 1)")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(.secondary)
                }

                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 12)

            // Two buttons: Resume and Start Over
            HStack(spacing: 10) {
                Button(action: onResume) {
                    HStack(spacing: 6) {
                        Image(systemName: "play.fill")
                            .font(.system(size: 13, weight: .bold))
                        Text("Resume")
                            .font(.system(.headline, design: .rounded).weight(.semibold))
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.orange)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                .buttonStyle(.plain)
                .accessibilityIdentifier("resumeButton")

                if let onRestart {
                    Button(action: onRestart) {
                        HStack(spacing: 6) {
                            Image(systemName: "arrow.counterclockwise")
                                .font(.system(size: 13, weight: .bold))
                            Text("Start Over")
                                .font(.system(.headline, design: .rounded).weight(.semibold))
                        }
                        .foregroundStyle(Color(hex: "#666666"))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color(hex: "#F5F5F5"))
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                    .buttonStyle(.plain)
                    .accessibilityIdentifier("startOverButton")
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(Color.orange.opacity(0.4), lineWidth: 2)
        )
        .accessibilityIdentifier("resumeCard")
    }
}
