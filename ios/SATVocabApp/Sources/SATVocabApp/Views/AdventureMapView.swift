import SwiftUI

struct AdventureMapView: View {
    @Binding var selectedDayIndex: Int

    @State private var zoneIndex: Int = AdventureSchedule.zoneIndex(forDayIndex: AdventureSchedule.dayIndexForToday())
    @State private var route: MapRoute? = nil

    var body: some View {
        let zoneIsUnlocked = AdventureProgressStore.shared.isZoneUnlocked(zoneIndex: zoneIndex)
        let zoneTitle = AdventureSchedule.zoneTitle(zoneIndex: zoneIndex)
        let dayStart = zoneIndex * AdventureSchedule.daysPerZone
        let dayEnd = min(dayStart + AdventureSchedule.daysPerZone, AdventureSchedule.totalDays)
        let days = Array(dayStart..<dayEnd)

        VStack(spacing: 16) {
            VStack(spacing: 6) {
                Text("Adventure Map")
                    .font(.system(.headline, design: .rounded).weight(.semibold))
                    .foregroundStyle(.secondary)

                HStack(spacing: 8) {
                    Button {
                        zoneIndex = max(0, zoneIndex - 1)
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                            .frame(width: 36, height: 36)
                    }
                    .buttonStyle(.plain)
                    .disabled(zoneIndex == 0)

                    Text(zoneTitle)
                        .font(.system(.largeTitle, design: .rounded).weight(.bold))
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)

                    Button {
                        zoneIndex = min(AdventureSchedule.totalZones - 1, zoneIndex + 1)
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 16, weight: .semibold))
                            .frame(width: 36, height: 36)
                    }
                    .buttonStyle(.plain)
                    .disabled(zoneIndex >= AdventureSchedule.totalZones - 1)
                }
            }
            .padding(.top, 10)

            ZStack {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.green.opacity(0.10))

                VStack(spacing: 12) {
                    ForEach(days, id: \.self) { dayIndex in
                        MapItemRow(
                            icon: "circle",
                            title: "Day \(AdventureSchedule.dayNumberInZone(forDayIndex: dayIndex))",
                            isCompleted: AdventureProgressStore.shared.isDayCompleted(dayIndex: dayIndex),
                            isUnlocked: zoneIsUnlocked,
                            isSelected: dayIndex == selectedDayIndex,
                            onTap: {
                                guard zoneIsUnlocked else { return }
                                selectedDayIndex = dayIndex
                                route = .day(dayIndex)
                            }
                        )
                    }

                    MapItemRow(
                        icon: "flag.checkered",
                        title: "Review & Test",
                        isCompleted: AdventureProgressStore.shared.isZoneCompleted(zoneIndex: zoneIndex),
                        isUnlocked: zoneIsUnlocked,
                        isSelected: false,
                        onTap: {
                            guard zoneIsUnlocked else { return }
                            route = .review(zoneIndex)
                        }
                    )
                }
                .padding(16)
            }
            .frame(maxWidth: .infinity)

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
        .navigationDestination(item: $route) { route in
            switch route {
            case .day(let dayIndex):
                DayTasksView(dayIndex: dayIndex)
            case .review(let zoneIndex):
                ZoneReviewSessionView(zoneIndex: zoneIndex) { }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

private enum MapRoute: Hashable, Identifiable {
    case day(Int)
    case review(Int)

    var id: String {
        switch self {
        case .day(let idx): return "day-\(idx)"
        case .review(let zone): return "review-\(zone)"
        }
    }
}

private struct MapItemRow: View {
    let icon: String
    let title: String
    let isCompleted: Bool
    let isUnlocked: Bool
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(isCompleted ? Color.green.opacity(0.85) : Color.gray.opacity(0.25))
                        .frame(width: 44, height: 32)

                    if isCompleted {
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(.white)
                    } else {
                        Image(systemName: isUnlocked ? icon : "lock.fill")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(.white.opacity(0.9))
                    }
                }

                Text(title)
                    .font(.system(.headline, design: .rounded).weight(.semibold))
                Spacer()

                if isSelected {
                    Text("Selected")
                        .font(.system(.caption, design: .rounded).weight(.semibold))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.black.opacity(0.08))
                        .clipShape(Capsule())
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color.white.opacity(0.85))
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .strokeBorder(isSelected ? Color.green.opacity(0.5) : Color.black.opacity(0.06), lineWidth: 1)
            )
            .opacity(isUnlocked ? 1.0 : 0.55)
        }
        .buttonStyle(.plain)
        .disabled(!isUnlocked)
    }
}
