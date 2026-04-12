import SwiftUI

struct AdventureMapView: View {
    @State private var zoneIndex: Int = AdventureSchedule.zoneIndex(forDayIndex: AdventureSchedule.dayIndexForToday())
    @State private var route: AdventureMapRoute? = nil
    @State private var familiarCount: Int = 0
    @State private var totalWordsInZone: Int = 0

    private let nodePositions: [CGPoint] = [
        CGPoint(x: 0.50, y: 0.10),
        CGPoint(x: 0.75, y: 0.28),
        CGPoint(x: 0.45, y: 0.46),
        CGPoint(x: 0.20, y: 0.64),
        CGPoint(x: 0.55, y: 0.84)  // zone test node
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
            // Zone header with navigation
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

            // Zone progress bar
            ZoneProgressBar(familiarCount: familiarCount, totalCount: max(1, totalWordsInZone))
                .padding(.horizontal, 4)

            // Map area
            ZStack {
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(zoneBackgroundGradient)

                GeometryReader { geo in
                    ZStack {
                        // Path
                        AdventureMapPathShape()
                            .stroke(
                                Color.white.opacity(0.55),
                                style: StrokeStyle(lineWidth: 18, lineCap: .round, lineJoin: .round, dash: [10, 10])
                            )
                            .padding(.horizontal, 10)
                            .padding(.vertical, 8)

                        // Day nodes
                        ForEach(Array(days.enumerated()), id: \.element) { idx, dayIndex in
                            if idx < nodePositions.count - 1 {
                                let pos = nodePositions[idx]
                                let dayTasks = AdventureProgressStore.shared.loadDayTasks(dayIndex: dayIndex)
                                let dayCompleted = dayTasks.allSatisfy { $0 }

                                MapDayNode(
                                    title: "Day \(AdventureSchedule.globalDayNumber(forDayIndex: dayIndex))",
                                    state: mapNodeState(
                                        dayIndex: dayIndex,
                                        dayCompleted: dayCompleted,
                                        zoneIsUnlocked: zoneIsUnlocked,
                                        highlightedDay: highlightedDay
                                    ),
                                    onTap: {
                                        guard zoneIsUnlocked else { return }
                                        route = .day(dayIndex)
                                    }
                                )
                                .position(x: geo.size.width * pos.x, y: geo.size.height * pos.y)
                            }
                        }

                        // Zone test node (last position)
                        let testPos = nodePositions[min(nodePositions.count - 1, days.count)]
                        let zoneCompleted = AdventureProgressStore.shared.isZoneCompleted(zoneIndex: zoneIndex)

                        MapDayNode(
                            title: "Zone Test",
                            state: .zoneTest(passed: zoneCompleted),
                            onTap: {
                                guard zoneIsUnlocked else { return }
                                route = .zoneTest(zoneIndex)
                            }
                        )
                        .position(x: geo.size.width * testPos.x, y: geo.size.height * testPos.y)
                    }
                }
                .padding(14)
            }
            .frame(height: 440)

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
        .navigationDestination(item: $route) { route in
            switch route {
            case .day:
                // Navigate to Practice tab
                PracticeTabView()
            case .zoneTest(let zi):
                ZoneReviewSessionView(zoneIndex: zi) {
                    AdventureProgressStore.shared.setZoneUnlocked(zoneIndex: zi + 1, unlocked: true)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await loadZoneWordProgress()
        }
        .onChange(of: zoneIndex) { _, _ in
            Task { await loadZoneWordProgress() }
        }
    }

    private func loadZoneWordProgress() async {
        do {
            let dm = DataManager.shared
            try await dm.initializeIfNeeded()
            let userId = LocalIdentity.userId()
            let wsStore = WordStateStore(db: dm.db)
            let dist = try await wsStore.getBoxDistribution(userId: userId)
            // Count words with box >= 1 as "familiar"
            familiarCount = dist.filter { $0.key >= 1 }.values.reduce(0, +)
            totalWordsInZone = max(dist.values.reduce(0, +), AdventureSchedule.daysPerZone * (AppConfig.morningNewWords + AppConfig.eveningNewWords))
        } catch {
            familiarCount = 0
            totalWordsInZone = 1
        }
    }

    private func mapNodeState(dayIndex: Int, dayCompleted: Bool, zoneIsUnlocked: Bool, highlightedDay: Int?) -> MapDayNode.NodeState {
        if dayCompleted {
            // Check if morning/evening are done (simplified: if day completed, both are done)
            return .completed(morningDone: true, eveningDone: true)
        }
        if highlightedDay == dayIndex {
            return .current
        }
        return zoneIsUnlocked ? .available : .locked
    }

    private var zoneBackgroundGradient: LinearGradient {
        let colors: [Color] = {
            switch zoneIndex % 5 {
            case 0: return [Color.green.opacity(0.18), Color.green.opacity(0.08)]
            case 1: return [Color.blue.opacity(0.18), Color.blue.opacity(0.08)]
            case 2: return [Color.teal.opacity(0.18), Color.teal.opacity(0.08)]
            case 3: return [Color.purple.opacity(0.18), Color.purple.opacity(0.08)]
            default: return [Color.orange.opacity(0.18), Color.orange.opacity(0.08)]
            }
        }()
        return LinearGradient(colors: colors, startPoint: .top, endPoint: .bottom)
    }
}

// MARK: - Route

private enum AdventureMapRoute: Hashable, Identifiable {
    case day(Int)
    case zoneTest(Int)

    var id: String {
        switch self {
        case .day(let idx): return "day-\(idx)"
        case .zoneTest(let zone): return "test-\(zone)"
        }
    }
}

// MARK: - Path Shape

private struct AdventureMapPathShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()

        let start = CGPoint(x: rect.midX, y: rect.minY + rect.height * 0.10)
        p.move(to: start)

        p.addQuadCurve(
            to: CGPoint(x: rect.width * 0.80, y: rect.height * 0.28),
            control: CGPoint(x: rect.width * 0.62, y: rect.height * 0.14)
        )
        p.addQuadCurve(
            to: CGPoint(x: rect.width * 0.48, y: rect.height * 0.46),
            control: CGPoint(x: rect.width * 0.84, y: rect.height * 0.36)
        )
        p.addQuadCurve(
            to: CGPoint(x: rect.width * 0.26, y: rect.height * 0.64),
            control: CGPoint(x: rect.width * 0.28, y: rect.height * 0.54)
        )
        p.addQuadCurve(
            to: CGPoint(x: rect.width * 0.54, y: rect.height * 0.84),
            control: CGPoint(x: rect.width * 0.14, y: rect.height * 0.78)
        )

        return p
    }
}
