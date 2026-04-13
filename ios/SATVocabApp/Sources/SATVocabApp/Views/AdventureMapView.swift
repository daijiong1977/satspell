import SwiftUI

struct AdventureMapView: View {
    var switchToPractice: () -> Void = {}

    @State private var zoneIndex: Int = AdventureSchedule.zoneIndex(forDayIndex: AdventureSchedule.dayIndexForToday())
    @State private var route: AdventureMapRoute? = nil
    @State private var familiarCount: Int = 0
    @State private var totalWordsInZone: Int = 0

    // 6 positions: 5 day nodes + 1 test node, winding path
    private let nodePositions: [CGPoint] = [
        CGPoint(x: 0.50, y: 0.06),
        CGPoint(x: 0.78, y: 0.22),
        CGPoint(x: 0.35, y: 0.38),
        CGPoint(x: 0.72, y: 0.54),
        CGPoint(x: 0.28, y: 0.70),
        CGPoint(x: 0.55, y: 0.88),  // zone test node
    ]

    var body: some View {
        let zoneIsUnlocked = AdventureProgressStore.shared.isZoneUnlocked(zoneIndex: zoneIndex)
        let dayStart = zoneIndex * AdventureSchedule.daysPerZone
        let dayEnd = min(dayStart + AdventureSchedule.daysPerZone, AdventureSchedule.totalDays)
        let days = Array(dayStart..<dayEnd)

        let nextDayToStart = AdventureProgressStore.shared.firstIncompleteDayIndex()
        let highlightedDay: Int? = AdventureSchedule.zoneIndex(forDayIndex: nextDayToStart) == zoneIndex ? nextDayToStart : nil

        VStack(spacing: 12) {
            // Zone header with navigation
            VStack(spacing: 4) {
                Text("WordScholar")
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundStyle(.secondary)

                HStack(spacing: 8) {
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            zoneIndex = max(0, zoneIndex - 1)
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                            .frame(width: 36, height: 36)
                    }
                    .buttonStyle(.plain)
                    .disabled(zoneIndex == 0)
                    .opacity(zoneIndex == 0 ? 0.3 : 1)

                    VStack(spacing: 2) {
                        Text(AdventureSchedule.zoneTitle(zoneIndex: zoneIndex))
                            .font(.system(.title3, design: .rounded).weight(.bold))
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                        Text(AdventureSchedule.zoneDescription(zoneIndex: zoneIndex))
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundStyle(.secondary)
                    }

                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            zoneIndex = min(AdventureSchedule.totalZones - 1, zoneIndex + 1)
                        }
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 16, weight: .semibold))
                            .frame(width: 36, height: 36)
                    }
                    .buttonStyle(.plain)
                    .disabled(zoneIndex >= AdventureSchedule.totalZones - 1)
                    .opacity(zoneIndex >= AdventureSchedule.totalZones - 1 ? 0.3 : 1)
                }
            }
            .padding(.top, 6)

            // Zone progress bar
            ZoneProgressBar(familiarCount: familiarCount, totalCount: max(1, totalWordsInZone))
                .padding(.horizontal, 4)

            // Map area
            ZStack {
                // Themed background
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(zoneBackgroundGradient)

                // Decorative elements
                GeometryReader { geo in
                    ZStack {
                        // Zone-specific decorations
                        zoneDecorations(size: geo.size)

                        // Previous zone portal (top)
                        if zoneIndex > 0 {
                            VStack(spacing: 2) {
                                Image(systemName: "arrowtriangle.up.fill")
                                    .font(.system(size: 10))
                                Text(AdventureSchedule.zoneEmoji(zoneIndex: zoneIndex - 1))
                                    .font(.system(size: 14))
                            }
                            .foregroundStyle(.white.opacity(0.6))
                            .position(x: geo.size.width * 0.50, y: 12)
                        }

                        // Winding path
                        ZoneMapPathShape(nodeCount: days.count + 1, positions: nodePositions)
                            .stroke(
                                pathColor.opacity(0.5),
                                style: StrokeStyle(lineWidth: 14, lineCap: .round, lineJoin: .round, dash: [8, 8])
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
                                        if dayCompleted {
                                            route = .day(dayIndex)
                                        } else if highlightedDay == dayIndex {
                                            switchToPractice()
                                        }
                                    }
                                )
                                .position(x: geo.size.width * pos.x, y: geo.size.height * pos.y)
                            }
                        }

                        // Zone test node (last position)
                        let testPos = nodePositions[min(nodePositions.count - 1, days.count)]
                        let zoneCompleted = AdventureProgressStore.shared.isZoneCompleted(zoneIndex: zoneIndex)
                        let allDaysDone = days.allSatisfy { AdventureProgressStore.shared.isDayCompleted(dayIndex: $0) }

                        MapDayNode(
                            title: "Zone Test",
                            state: allDaysDone ? .zoneTest(passed: zoneCompleted) : .locked,
                            onTap: {
                                guard allDaysDone else { return }
                                route = .zoneTest(zoneIndex)
                            }
                        )
                        .position(x: geo.size.width * testPos.x, y: geo.size.height * testPos.y)

                        // Next zone portal (bottom)
                        if zoneIndex < AdventureSchedule.totalZones - 1 {
                            VStack(spacing: 2) {
                                Text(AdventureSchedule.zoneEmoji(zoneIndex: zoneIndex + 1))
                                    .font(.system(size: 14))
                                Image(systemName: "arrowtriangle.down.fill")
                                    .font(.system(size: 10))
                            }
                            .foregroundStyle(.white.opacity(0.6))
                            .position(x: geo.size.width * 0.55, y: geo.size.height - 6)
                        }
                    }
                }
                .padding(10)
            }
            .frame(height: 480)

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
        .navigationDestination(item: $route) { route in
            switch route {
            case .day(let dayIdx):
                DayCompleteSummary(
                    studyDay: dayIdx,
                    userId: LocalIdentity.userId()
                )
                .navigationTitle("Day \(AdventureSchedule.globalDayNumber(forDayIndex: dayIdx))")
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

    // MARK: - Zone Decorations

    @ViewBuilder
    private func zoneDecorations(size: CGSize) -> some View {
        switch zoneIndex % 4 {
        case 0: // Enchanted Forest — trees and leaves
            ForEach(0..<8, id: \.self) { i in
                Text(["🌿", "🍃", "🌲", "🌳", "🍀", "🦋", "🌸", "🍄"][i])
                    .font(.system(size: CGFloat.random(in: 16...28)))
                    .opacity(0.3)
                    .position(
                        x: size.width * CGFloat([0.12, 0.88, 0.08, 0.92, 0.15, 0.85, 0.10, 0.90][i]),
                        y: size.height * CGFloat([0.08, 0.15, 0.35, 0.42, 0.58, 0.65, 0.82, 0.90][i])
                    )
            }
        case 1: // Cloud Kingdom — clouds and sky
            ForEach(0..<8, id: \.self) { i in
                Text(["☁️", "🌤️", "✨", "🌈", "☁️", "⛅", "🌥️", "✨"][i])
                    .font(.system(size: CGFloat.random(in: 16...32)))
                    .opacity(0.3)
                    .position(
                        x: size.width * CGFloat([0.10, 0.90, 0.15, 0.50, 0.85, 0.08, 0.92, 0.45][i]),
                        y: size.height * CGFloat([0.12, 0.08, 0.30, 0.20, 0.45, 0.60, 0.72, 0.88][i])
                    )
            }
        case 2: // Crystal Caverns — gems and crystals
            ForEach(0..<8, id: \.self) { i in
                Text(["💎", "🔮", "💠", "✨", "🪨", "💎", "⚡", "✨"][i])
                    .font(.system(size: CGFloat.random(in: 14...26)))
                    .opacity(0.3)
                    .position(
                        x: size.width * CGFloat([0.08, 0.92, 0.12, 0.88, 0.06, 0.94, 0.15, 0.85][i]),
                        y: size.height * CGFloat([0.10, 0.18, 0.38, 0.32, 0.55, 0.62, 0.80, 0.88][i])
                    )
            }
        default: // Starlight Summit — stars and space
            ForEach(0..<8, id: \.self) { i in
                Text(["⭐", "🌟", "💫", "🌙", "✨", "🌠", "⭐", "💫"][i])
                    .font(.system(size: CGFloat.random(in: 14...28)))
                    .opacity(0.35)
                    .position(
                        x: size.width * CGFloat([0.10, 0.90, 0.05, 0.95, 0.12, 0.88, 0.08, 0.92][i]),
                        y: size.height * CGFloat([0.05, 0.12, 0.28, 0.35, 0.52, 0.60, 0.78, 0.85][i])
                    )
            }
        }
    }

    // MARK: - Helpers

    private func loadZoneWordProgress() async {
        do {
            let dm = DataManager.shared
            try await dm.initializeIfNeeded()
            let userId = LocalIdentity.userId()
            let wsStore = WordStateStore(db: dm.db)
            let dist = try await wsStore.getBoxDistribution(userId: userId)
            familiarCount = dist.filter { $0.key >= 1 }.values.reduce(0, +)
            totalWordsInZone = max(dist.values.reduce(0, +), AdventureSchedule.daysPerZone * (AppConfig.morningNewWords + AppConfig.eveningNewWords))
        } catch {
            familiarCount = 0
            totalWordsInZone = 1
        }
    }

    private func mapNodeState(dayIndex: Int, dayCompleted: Bool, zoneIsUnlocked: Bool, highlightedDay: Int?) -> MapDayNode.NodeState {
        if dayCompleted {
            return .completed(morningDone: true, eveningDone: true)
        }
        if highlightedDay == dayIndex {
            return .current
        }
        return zoneIsUnlocked ? .available : .locked
    }

    private var zoneBackgroundGradient: LinearGradient {
        let colors: [Color] = {
            switch zoneIndex % 4 {
            case 0: return [Color(hex: "#2D5016").opacity(0.25), Color(hex: "#1A3A0A").opacity(0.15)] // forest green
            case 1: return [Color(hex: "#4A90D9").opacity(0.20), Color(hex: "#87CEEB").opacity(0.12)] // sky blue
            case 2: return [Color(hex: "#6B3FA0").opacity(0.22), Color(hex: "#4A2C7A").opacity(0.12)] // crystal purple
            default: return [Color(hex: "#1A1A3E").opacity(0.30), Color(hex: "#0D0D2B").opacity(0.18)] // deep space
            }
        }()
        return LinearGradient(colors: colors, startPoint: .top, endPoint: .bottom)
    }

    private var pathColor: Color {
        switch zoneIndex % 4 {
        case 0: return .white
        case 1: return .white
        case 2: return Color(hex: "#E0B0FF")
        default: return Color(hex: "#FFD700")
        }
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

// MARK: - Path Shape (connects node positions with curves)

private struct ZoneMapPathShape: Shape {
    let nodeCount: Int
    let positions: [CGPoint]

    func path(in rect: CGRect) -> Path {
        var p = Path()
        let count = min(nodeCount, positions.count)
        guard count >= 2 else { return p }

        let first = positions[0]
        p.move(to: CGPoint(x: rect.width * first.x, y: rect.height * first.y))

        for i in 1..<count {
            let prev = positions[i - 1]
            let curr = positions[i]
            let prevPt = CGPoint(x: rect.width * prev.x, y: rect.height * prev.y)
            let currPt = CGPoint(x: rect.width * curr.x, y: rect.height * curr.y)

            let controlX = (prevPt.x + currPt.x) / 2 + (i % 2 == 0 ? 30 : -30)
            let controlY = (prevPt.y + currPt.y) / 2

            p.addQuadCurve(
                to: currPt,
                control: CGPoint(x: controlX, y: controlY)
            )
        }

        return p
    }
}
