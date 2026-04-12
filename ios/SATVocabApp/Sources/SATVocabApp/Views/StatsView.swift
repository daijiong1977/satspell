import SwiftUI

struct StatsView: View {
    @State private var streak: StreakInfo = StreakInfo(
        currentStreak: 0, bestStreak: 0, lastStudyDate: nil,
        totalXP: 0, totalStudyDays: 0,
        streak3Claimed: false, streak7Claimed: false,
        streak14Claimed: false, streak30Claimed: false
    )
    @State private var boxDistribution: [Int: Int] = [:]
    @State private var stubbornWords: [(lemma: String, pos: String?, lapseCount: Int, boxLevel: Int)] = []
    @State private var wordsLearnedCount: Int = 0

    private let userId = LocalIdentity.userId()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Hero tiles
                HStack(spacing: 12) {
                    StatsHeroTile(title: "Streak", value: "\(streak.currentStreak)", icon: "flame.fill", color: .orange)
                    StatsHeroTile(title: "XP", value: "\(streak.totalXP)", icon: "star.fill", color: .yellow)
                    StatsHeroTile(title: "Words", value: "\(wordsLearnedCount)", icon: "textformat.abc", color: Color(hex: "#58CC02"))
                }

                // Box distribution
                VStack(alignment: .leading, spacing: 12) {
                    Text("Word Strength")
                        .font(.system(.headline, design: .rounded).weight(.bold))

                    BoxDistributionBar(distribution: boxDistribution)
                }
                .padding(16)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
                )

                // Words Fighting Back
                if !stubbornWords.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Words Fighting Back")
                            .font(.system(.headline, design: .rounded).weight(.bold))

                        Text("These words need extra attention")
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundStyle(.secondary)

                        ForEach(Array(stubbornWords.enumerated()), id: \.offset) { _, word in
                            HStack(spacing: 10) {
                                Text(word.lemma)
                                    .font(.system(.body, design: .rounded).weight(.semibold))

                                if let pos = word.pos {
                                    Text(pos)
                                        .font(.system(.caption, design: .rounded))
                                        .foregroundStyle(.secondary)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(Color.gray.opacity(0.1))
                                        .clipShape(Capsule())
                                }

                                Spacer()

                                Text("Box \(word.boxLevel)")
                                    .font(.system(.caption, design: .rounded).weight(.semibold))
                                    .foregroundStyle(.orange)

                                Text("\(word.lapseCount)x")
                                    .font(.system(.caption, design: .rounded).weight(.bold))
                                    .foregroundStyle(.red)
                            }
                            .padding(.vertical, 4)

                            if word.lemma != stubbornWords.last?.lemma {
                                Divider().opacity(0.3)
                            }
                        }
                    }
                    .padding(16)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
                    )
                }

                // Best streak
                HStack {
                    Text("Best Streak")
                        .font(.system(.subheadline, design: .rounded).weight(.semibold))
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text("\(streak.bestStreak) days")
                        .font(.system(.subheadline, design: .rounded).weight(.bold))
                }
                .padding(16)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
                )
            }
            .padding(16)
        }
        .navigationTitle("Stats")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await loadStats()
        }
    }

    private func loadStats() async {
        do {
            let dm = DataManager.shared
            try await dm.initializeIfNeeded()

            let statsStore = StatsStore.shared
            streak = try await statsStore.getStreak(userId: userId)

            let wsStore = WordStateStore(db: dm.db)
            boxDistribution = try await wsStore.getBoxDistribution(userId: userId)
            stubbornWords = try await wsStore.getStubbornWords(userId: userId, limit: 10)
            wordsLearnedCount = try await wsStore.countWordsLearned(userId: userId)
        } catch {
            // ignore
        }
    }
}

// MARK: - Hero Tile

private struct StatsHeroTile: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(color)

            Text(value)
                .font(.system(.title2, design: .rounded).weight(.bold))

            Text(title)
                .font(.system(.caption, design: .rounded).weight(.semibold))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
        )
    }
}

// MARK: - Box Distribution Bar

private struct BoxDistributionBar: View {
    let distribution: [Int: Int]

    private var total: Int {
        distribution.values.reduce(0, +)
    }

    var body: some View {
        if total > 0 {
            VStack(spacing: 8) {
                // Stacked bar
                GeometryReader { geo in
                    HStack(spacing: 1) {
                        ForEach(0...5, id: \.self) { box in
                            let count = distribution[box] ?? 0
                            let width = geo.size.width * CGFloat(count) / CGFloat(max(1, total))
                            if count > 0 {
                                RoundedRectangle(cornerRadius: 3, style: .continuous)
                                    .fill(Color(hex: WordStrength(rawValue: box)?.colorHex ?? "#E8ECF0"))
                                    .frame(width: max(4, width))
                            }
                        }
                    }
                }
                .frame(height: 20)
                .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))

                // Legend
                HStack(spacing: 8) {
                    ForEach(1...5, id: \.self) { box in
                        let strength = WordStrength(rawValue: box)
                        let count = distribution[box] ?? 0
                        HStack(spacing: 4) {
                            Circle()
                                .fill(Color(hex: strength?.colorHex ?? "#E8ECF0"))
                                .frame(width: 8, height: 8)
                            Text("\(count)")
                                .font(.system(.caption2, design: .rounded).weight(.semibold))
                        }
                    }
                }
            }
        } else {
            Text("No words studied yet")
                .font(.system(.subheadline, design: .rounded))
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
        }
    }
}
