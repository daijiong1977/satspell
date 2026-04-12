import SwiftUI

enum ReportCardGenerator {
    @MainActor
    static func render(streak: StreakInfo, userId: String) -> UIImage {
        let view = ReportCardView(streak: streak, userId: userId)
        let renderer = ImageRenderer(content: view)
        renderer.scale = UIScreen.main.scale
        return renderer.uiImage ?? UIImage()
    }
}

// MARK: - Report Card View (rendered to image)

private struct ReportCardView: View {
    let streak: StreakInfo
    let userId: String

    var body: some View {
        VStack(spacing: 20) {
            Text("SAT Vocab Progress")
                .font(.system(.title, design: .rounded).weight(.bold))
                .foregroundStyle(.white)

            HStack(spacing: 24) {
                reportStat(value: "\(streak.currentStreak)", label: "Day Streak", icon: "flame.fill")
                reportStat(value: "\(streak.totalXP)", label: "Total XP", icon: "star.fill")
                reportStat(value: "\(streak.totalStudyDays)", label: "Study Days", icon: "calendar")
            }

            Text("Best Streak: \(streak.bestStreak) days")
                .font(.system(.subheadline, design: .rounded).weight(.semibold))
                .foregroundStyle(.white.opacity(0.8))

            Text(DateFormatter.yyyyMMdd.string(from: Date()))
                .font(.system(.caption, design: .rounded))
                .foregroundStyle(.white.opacity(0.6))
        }
        .padding(30)
        .frame(width: 360)
        .background(
            LinearGradient(
                colors: [Color(hex: "#58CC02"), Color(hex: "#3B8C00")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    private func reportStat(value: String, label: String, icon: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(.white.opacity(0.9))
            Text(value)
                .font(.system(.title2, design: .rounded).weight(.bold))
                .foregroundStyle(.white)
            Text(label)
                .font(.system(.caption, design: .rounded).weight(.medium))
                .foregroundStyle(.white.opacity(0.75))
        }
    }
}
