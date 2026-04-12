import SwiftUI

struct EveningSessionCard: View {
    let locked: Bool
    let unlockAt: Date?
    var onStart: () -> Void = {}

    @State private var timeRemaining: String = ""
    @State private var timer: Timer? = nil

    var body: some View {
        Button(action: { if !locked { onStart() } }) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(Color.indigo.opacity(0.15))
                        .frame(width: 52, height: 52)
                    Text("\u{1F319}")
                        .font(.system(size: 24))
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Evening Session")
                        .font(.system(.headline, design: .rounded).weight(.bold))

                    if locked, unlockAt != nil {
                        Text("Unlocks \(timeRemaining)")
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundStyle(.orange)
                    } else if locked {
                        Text("Complete morning first")
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundStyle(.secondary)
                    } else {
                        Text("Review \(AppConfig.eveningNewWords) new words")
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                }

                Spacer()

                if locked {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.secondary)
                } else {
                    Text("Start")
                        .font(.system(.headline, design: .rounded).weight(.semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 10)
                        .background(Color.indigo)
                        .clipShape(Capsule())
                }
            }
            .padding(16)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .strokeBorder(locked ? Color.gray.opacity(0.15) : Color.indigo.opacity(0.3), lineWidth: 1.5)
            )
            .opacity(locked ? 0.7 : 1.0)
        }
        .buttonStyle(.plain)
        .disabled(locked)
        .onAppear { startTimer() }
        .onDisappear { timer?.invalidate() }
    }

    private func startTimer() {
        updateTimeRemaining()
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            updateTimeRemaining()
        }
    }

    private func updateTimeRemaining() {
        guard let unlockAt else {
            timeRemaining = ""
            return
        }
        let diff = unlockAt.timeIntervalSinceNow
        if diff <= 0 {
            timeRemaining = "now"
            timer?.invalidate()
        } else {
            let hours = Int(diff) / 3600
            let minutes = (Int(diff) % 3600) / 60
            if hours > 0 {
                timeRemaining = "in \(hours)h \(minutes)m"
            } else {
                timeRemaining = "in \(minutes)m"
            }
        }
    }
}
