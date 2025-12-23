import SwiftUI

struct DayTasksView: View {
    let dayIndex: Int

    @State private var route: Route? = nil

    private var zoneIndex: Int { AdventureSchedule.zoneIndex(forDayIndex: dayIndex) }
    private var isZoneUnlocked: Bool { AdventureProgressStore.shared.isZoneUnlocked(zoneIndex: zoneIndex) }

    var body: some View {
        let dayNumber = AdventureSchedule.globalDayNumber(forDayIndex: dayIndex)
        let states = AdventureProgressStore.shared.loadDayTasks(dayIndex: dayIndex)

        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Day \(dayNumber): Adventure Tasks")
                    .font(.system(.largeTitle, design: .rounded).weight(.bold))

                Text(AdventureSchedule.zoneTitle(zoneIndex: zoneIndex))
                    .font(.system(.headline, design: .rounded).weight(.semibold))
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 8)

            VStack(spacing: 12) {
                AdventureTaskCard(
                    icon: "sparkles",
                    title: "Explore New Words",
                    description: "Discover \(AppConfig.task1CardCount) new words in this zone.",
                    isCompleted: states[0],
                    isLocked: !isZoneUnlocked,
                    onTap: { route = .flashcards }
                )
                AdventureTaskCard(
                    icon: "photo",
                    title: "Practice the Words",
                    description: "Complete fun exercises to master them.",
                    isCompleted: states[1],
                    isLocked: !isZoneUnlocked,
                    onTap: { route = .imageGame }
                )
                AdventureTaskCard(
                    icon: "checkmark.circle",
                    title: "Real SAT Questions",
                    description: "Test your knowledge with exam-style questions.",
                    isCompleted: states[2],
                    isLocked: !isZoneUnlocked,
                    onTap: { route = .satGame }
                )
                AdventureTaskCard(
                    icon: "flame",
                    title: "Review Difficulty Words",
                    description: "Focus on challenging words in this zone.",
                    isCompleted: states[3],
                    isLocked: !isZoneUnlocked,
                    onTap: { route = .zoneReview }
                )
            }

            Spacer(minLength: 0)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(item: $route) { route in
            switch route {
            case .flashcards:
                FlashcardSessionView(mode: .task1, dayIndexOverride: dayIndex) { _ in
                    AdventureProgressStore.shared.setDayTaskCompleted(dayIndex: dayIndex, taskIndex: 0, completed: true)
                }
                .toolbar(.hidden, for: .tabBar)
            case .imageGame:
                GameSessionView(mode: .task3Images, dayIndexOverride: dayIndex) { _ in
                    AdventureProgressStore.shared.setDayTaskCompleted(dayIndex: dayIndex, taskIndex: 1, completed: true)
                }
                .toolbar(.hidden, for: .tabBar)
            case .satGame:
                GameSessionView(mode: .task4Sat, dayIndexOverride: dayIndex) { _ in
                    AdventureProgressStore.shared.setDayTaskCompleted(dayIndex: dayIndex, taskIndex: 2, completed: true)
                }
                .toolbar(.hidden, for: .tabBar)
            case .zoneReview:
                ZoneReviewSessionView(zoneIndex: zoneIndex) {
                    AdventureProgressStore.shared.setDayTaskCompleted(dayIndex: dayIndex, taskIndex: 3, completed: true)
                }
                .toolbar(.hidden, for: .tabBar)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 6)
        .overlay {
            if !isZoneUnlocked {
                VStack(spacing: 8) {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 22, weight: .semibold))
                    Text("This zone is locked")
                        .font(.system(.headline, design: .rounded).weight(.semibold))
                    Text("Complete the previous zone review to unlock.")
                        .font(.system(.footnote, design: .rounded))
                        .foregroundStyle(.secondary)
                }
                .padding(18)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .padding()
            }
        }
    }
}

private enum Route: Hashable, Identifiable {
    case flashcards
    case imageGame
    case satGame
    case zoneReview

    var id: String {
        switch self {
        case .flashcards: return "flashcards"
        case .imageGame: return "image"
        case .satGame: return "sat"
        case .zoneReview: return "zoneReview"
        }
    }
}

private struct AdventureTaskCard: View {
    let icon: String
    let title: String
    let description: String
    let isCompleted: Bool
    let isLocked: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .top, spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.black.opacity(0.06))
                        .frame(width: 44, height: 44)
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.primary)
                }

                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 8) {
                        Text(title)
                            .font(.system(.headline, design: .rounded).weight(.bold))
                        Spacer(minLength: 0)
                        if isCompleted {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundStyle(.green)
                        } else if isLocked {
                            Image(systemName: "lock.fill")
                                .foregroundStyle(.secondary)
                        }
                    }

                    Text(description)
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(16)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
            )
            .opacity(isLocked ? 0.6 : 1.0)
        }
        .buttonStyle(.plain)
        .disabled(isLocked)
    }
}
