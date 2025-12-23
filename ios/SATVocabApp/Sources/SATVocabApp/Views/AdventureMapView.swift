import SwiftUI

struct AdventureMapView: View {
    @Binding var selectedDayIndex: Int

    @State private var zoneIndex: Int = AdventureSchedule.zoneIndex(forDayIndex: AdventureSchedule.dayIndexForToday())
    @State private var route: MapRoute? = nil

    private let nodePositions: [CGPoint] = [
        CGPoint(x: 0.50, y: 0.12),
        CGPoint(x: 0.75, y: 0.27),
        CGPoint(x: 0.45, y: 0.44),
        CGPoint(x: 0.20, y: 0.60)
    ]

    var body: some View {
        let zoneIsUnlocked = AdventureProgressStore.shared.isZoneUnlocked(zoneIndex: zoneIndex)
        let zoneTitle = AdventureSchedule.zoneTitle(zoneIndex: zoneIndex)
        let dayStart = zoneIndex * AdventureSchedule.daysPerZone
        let dayEnd = min(dayStart + AdventureSchedule.daysPerZone, AdventureSchedule.totalDays)
        let days = Array(dayStart..<dayEnd)

        let nextDayToStart = AdventureProgressStore.shared.firstIncompleteDayIndex()
        let highlightedDay: Int? = AdventureSchedule.zoneIndex(forDayIndex: nextDayToStart) == zoneIndex ? nextDayToStart : nil

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
                        .font(.system(.title2, design: .rounded).weight(.bold))
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
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(Color.green.opacity(0.16))

                GeometryReader { geo in
                    ZStack {
                        AdventurePathShape()
                            .stroke(
                                Color.white.opacity(0.55),
                                style: StrokeStyle(lineWidth: 18, lineCap: .round, lineJoin: .round, dash: [10, 10])
                            )
                            .padding(.horizontal, 10)
                            .padding(.vertical, 8)
                            .shadow(color: .black.opacity(0.10), radius: 6, x: 0, y: 2)

                        ForEach(Array(days.enumerated()), id: \.element) { idx, dayIndex in
                            if idx < nodePositions.count {
                                let pos = nodePositions[idx]

                                AdventureDayNode(
                                    title: "Day \(AdventureSchedule.globalDayNumber(forDayIndex: dayIndex))",
                                    state: nodeState(
                                        dayIndex: dayIndex,
                                        zoneIsUnlocked: zoneIsUnlocked,
                                        highlightedDay: highlightedDay
                                    ),
                                    onTap: {
                                        guard zoneIsUnlocked else { return }
                                        selectedDayIndex = dayIndex
                                        route = .day(dayIndex)
                                    }
                                )
                                .position(x: geo.size.width * pos.x, y: geo.size.height * pos.y)
                            }
                        }
                    }
                }
                .padding(14)
            }
            .frame(height: 460)

            Button {
                guard zoneIsUnlocked else { return }
                route = .review(zoneIndex)
            } label: {
                HStack(spacing: 10) {
                    Text("Zone \(zoneIndex + 1) Review & Test")
                        .font(.system(.headline, design: .rounded).weight(.bold))
                    Image(systemName: "flag.checkered")
                        .font(.system(size: 16, weight: .bold))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.indigo.opacity(0.88))
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .opacity(zoneIsUnlocked ? 1.0 : 0.55)
            }
            .buttonStyle(.plain)
            .disabled(!zoneIsUnlocked)

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

    private func nodeState(dayIndex: Int, zoneIsUnlocked: Bool, highlightedDay: Int?) -> AdventureDayNode.State {
        if AdventureProgressStore.shared.isDayCompleted(dayIndex: dayIndex) {
            return .completed
        }
        if highlightedDay == dayIndex {
            return .current
        }
        return zoneIsUnlocked ? .available : .locked
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

private struct AdventurePathShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()

        let start = CGPoint(x: rect.midX, y: rect.minY + rect.height * 0.10)
        p.move(to: start)

        p.addQuadCurve(
            to: CGPoint(x: rect.width * 0.80, y: rect.height * 0.28),
            control: CGPoint(x: rect.width * 0.62, y: rect.height * 0.14)
        )
        p.addQuadCurve(
            to: CGPoint(x: rect.width * 0.48, y: rect.height * 0.44),
            control: CGPoint(x: rect.width * 0.84, y: rect.height * 0.36)
        )
        p.addQuadCurve(
            to: CGPoint(x: rect.width * 0.26, y: rect.height * 0.62),
            control: CGPoint(x: rect.width * 0.28, y: rect.height * 0.52)
        )
        p.addQuadCurve(
            to: CGPoint(x: rect.width * 0.54, y: rect.height * 0.90),
            control: CGPoint(x: rect.width * 0.14, y: rect.height * 0.78)
        )

        return p
    }
}

private struct AdventureDayNode: View {
    enum State {
        case completed
        case current
        case available
        case locked
    }

    let title: String
    let state: State
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(fillColor)
                        .frame(width: 68, height: 48)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .strokeBorder(Color.black.opacity(0.10), lineWidth: 1)
                        )

                    if state == .completed {
                        Image(systemName: "checkmark")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(.white)
                    } else if state == .locked {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.white.opacity(0.95))
                    } else {
                        Image(systemName: "circle.fill")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(.white.opacity(0.95))
                    }
                }

                Text(title)
                    .font(.system(.footnote, design: .rounded).weight(.bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.black.opacity(0.22))
                    .clipShape(Capsule())
            }
        }
        .buttonStyle(.plain)
        .disabled(state == .locked)
    }

    private var fillColor: Color {
        switch state {
        case .completed:
            return Color.green.opacity(0.90)
        case .current:
            return Color.accentColor.opacity(0.92)
        case .available:
            return Color.green.opacity(0.75)
        case .locked:
            return Color.gray.opacity(0.55)
        }
    }
}
