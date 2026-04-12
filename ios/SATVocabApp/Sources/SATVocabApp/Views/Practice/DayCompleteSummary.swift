import SwiftUI

struct DayCompleteSummary: View {
    let studyDay: Int
    let userId: String

    @State private var dailyStats: DailyStats?
    @State private var wordsLearned: Int = 0

    var body: some View {
        VStack(spacing: 14) {
            Text("Day \(studyDay) Complete!")
                .font(.system(.title2, design: .rounded).weight(.bold))
                .foregroundStyle(Color(hex: "#58CC02"))

            if let stats = dailyStats {
                HStack(spacing: 16) {
                    summaryTile(title: "Words", value: "\(wordsLearned)", icon: "textformat.abc")
                    summaryTile(title: "XP", value: "\(stats.xpEarned + stats.sessionBonus)", icon: "star.fill")
                    summaryTile(title: "Accuracy", value: stats.totalCount > 0 ? "\(Int(Double(stats.correctCount) / Double(stats.totalCount) * 100))%" : "--", icon: "target")
                }
            } else {
                HStack(spacing: 16) {
                    summaryTile(title: "Words", value: "--", icon: "textformat.abc")
                    summaryTile(title: "XP", value: "--", icon: "star.fill")
                    summaryTile(title: "Accuracy", value: "--", icon: "target")
                }
            }

            Text("Great work today! Come back tomorrow.")
                .font(.system(.subheadline, design: .rounded))
                .foregroundStyle(.secondary)
        }
        .padding(20)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(Color(hex: "#58CC02").opacity(0.2), lineWidth: 1)
        )
        .task {
            do {
                let statsStore = StatsStore.shared
                dailyStats = try await statsStore.getOrCreateDailyStats(userId: userId, studyDay: studyDay)

                let dm = DataManager.shared
                try await dm.initializeIfNeeded()
                let wsStore = WordStateStore(db: dm.db)
                wordsLearned = try await wsStore.countWordsLearned(userId: userId)
            } catch {
                // ignore
            }
        }
    }

    private func summaryTile(title: String, value: String, icon: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.secondary)
            Text(value)
                .font(.system(.title3, design: .rounded).weight(.bold))
            Text(title)
                .font(.system(.caption, design: .rounded))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}
