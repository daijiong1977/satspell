import SwiftUI

struct StatsView: View {
    @StateObject private var vm = DashboardViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Words Finished")
                    .font(.system(.title2, design: .rounded).weight(.bold))

                HStack(spacing: 12) {
                    StatTile(title: "Streak", value: "\(vm.stats.streakDays)")
                    StatTile(title: "XP", value: "\(vm.stats.xp)")
                }

                SectionCard(title: "Performance Curve") {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color.black.opacity(0.06))
                        .frame(height: 160)
                        .overlay(
                            Text("Performance Curve")
                                .font(.system(.headline, design: .rounded).weight(.semibold))
                                .foregroundStyle(.secondary)
                        )
                }

                SectionCard(title: "Games") {
                    ActionRow(title: "Word Match", subtitle: nil, systemImage: "rectangle.grid.2x2")
                }

                SectionCard(title: "Time") {
                    ActionRow(title: "Avg. Completion Time", subtitle: "15 mins", systemImage: "clock")
                }

                SectionCard(title: "Word Lists") {
                    ActionRow(title: "Download Word List", subtitle: nil, systemImage: "arrow.down.circle")
                    Divider().opacity(0.25)
                    ActionRow(title: "Switch Word List", subtitle: nil, systemImage: "arrow.triangle.2.circlepath")
                }
            }
            .padding(16)
        }
        .navigationTitle("Stats")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { vm.load() }
    }
}

private struct StatTile: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(.subheadline, design: .rounded).weight(.semibold))
                .foregroundStyle(.secondary)

            Text(value)
                .font(.system(.title, design: .rounded).weight(.bold))
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
        )
    }
}

private struct SectionCard<Content: View>: View {
    let title: String
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(.headline, design: .rounded).weight(.bold))

            content
        }
        .padding(16)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
        )
    }
}

private struct ActionRow: View {
    let title: String
    let subtitle: String?
    let systemImage: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.system(size: 18, weight: .semibold))
                .frame(width: 28)
                .foregroundStyle(.primary)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(.subheadline, design: .rounded).weight(.semibold))
                if let subtitle {
                    Text(subtitle)
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(.secondary)
                }
            }

            Spacer(minLength: 0)

            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.secondary)
        }
        .contentShape(Rectangle())
    }
}
