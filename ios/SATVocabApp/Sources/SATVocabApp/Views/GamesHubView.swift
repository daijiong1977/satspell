import SwiftUI

struct GamesHubView: View {
    let dayIndex: Int

    var body: some View {
        VStack(spacing: 14) {
            Text("Games")
                .font(.system(.largeTitle, design: .rounded).weight(.bold))
                .frame(maxWidth: .infinity, alignment: .leading)

            Text("Pick a game for Day \(AdventureSchedule.globalDayNumber(forDayIndex: dayIndex)).")
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            NavigationLink {
                GameSessionView(mode: .task3Images, dayIndexOverride: dayIndex) { _ in }
                    .toolbar(.hidden, for: .tabBar)
            } label: {
                HubRow(title: "Image → Word", subtitle: "Practice")
            }

            NavigationLink {
                GameSessionView(mode: .task4Sat, dayIndexOverride: dayIndex) { _ in }
                    .toolbar(.hidden, for: .tabBar)
            } label: {
                HubRow(title: "SAT Questions", subtitle: "Real questions")
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct HubRow: View {
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.blue.opacity(0.18))
                .frame(width: 44, height: 44)
                .overlay(
                    Image(systemName: "play.fill")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.blue)
                )

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(.headline, design: .rounded).weight(.bold))
                Text(subtitle)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(14)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
        )
        .buttonStyle(.plain)
    }
}
