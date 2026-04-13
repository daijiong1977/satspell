import SwiftUI

struct AdventureMapView: View {
    var switchToPractice: () -> Void = {}

    @State private var zoneIndex: Int = AdventureSchedule.zoneIndex(forDayIndex: AdventureSchedule.dayIndexForToday())
    @State private var route: AdventureMapRoute? = nil
    @State private var familiarCount: Int = 0
    @State private var totalWordsInZone: Int = 0

    // Node positions as percentage of FULL SCREEN (not a sub-region)
    // These were detected from painted circles in the background images
    private let nodePositions: [CGPoint] = [
        CGPoint(x: 0.4261, y: 0.3783),   // I — down half
        CGPoint(x: 0.6641, y: 0.4342),   // II — down half
        CGPoint(x: 0.3658, y: 0.5049),   // III — good
        CGPoint(x: 0.6392, y: 0.6149),   // IV — down half
        CGPoint(x: 0.3103, y: 0.7188),   // V — down half
        CGPoint(x: 0.4914, y: 0.8668),   // TEST — down half
    ]

    private let zoneBackgroundImages = [
        "zone-enchanted-forest",
        "zone-cloud-kingdom",
        "zone-crystal-caverns",
        "zone-starlight-summit",
    ]

    private let zoneSubtitles = [
        "Enchanted Forest",
        "Cloud Kingdom",
        "Crystal Caverns",
        "Starlight Summit",
    ]

    private let romanLabels = ["I", "II", "III", "IV", "V"]

    var body: some View {
        let zoneIsUnlocked = AdventureProgressStore.shared.isZoneUnlocked(zoneIndex: zoneIndex)
        let dayStart = zoneIndex * AdventureSchedule.daysPerZone
        let dayEnd = min(dayStart + AdventureSchedule.daysPerZone, AdventureSchedule.totalDays)
        let days = Array(dayStart..<dayEnd)
        let nextDayToStart = AdventureProgressStore.shared.firstIncompleteDayIndex()
        let highlightedDay: Int? = AdventureSchedule.zoneIndex(forDayIndex: nextDayToStart) == zoneIndex ? nextDayToStart : nil

        // Everything is absolutely positioned over the full-bleed background
        GeometryReader { geo in
            ZStack {
                // Background image — fills entire screen
                zoneBackground
                    .id(zoneIndex)

                // Title — at 19% from top
                VStack(spacing: 4) {
                    Text("WordScholar")
                        .font(.system(size: 28, weight: .bold, design: .serif))
                        .italic()
                        .foregroundStyle(titleColor)
                        .shadow(color: titleShadow, radius: 3, x: 0, y: 1)
                        .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)

                    Text(zoneSubtitles[zoneIndex % zoneSubtitles.count])
                        .font(.system(size: 15, weight: .regular, design: .serif))
                        .foregroundStyle(subtitleColor)
                        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                }
                .position(x: geo.size.width * 0.5, y: geo.size.height * 0.19)

                // Day nodes — positioned as % of full screen
                ForEach(Array(days.enumerated()), id: \.element) { idx, dayIndex in
                    if idx < nodePositions.count - 1 && idx < romanLabels.count {
                        let pos = nodePositions[idx]
                        let dayTasks = AdventureProgressStore.shared.loadDayTasks(dayIndex: dayIndex)
                        let dayCompleted = dayTasks.allSatisfy { $0 }

                        MapDayNode(
                            label: romanLabels[idx],
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

                // Zone test node
                let testPos = nodePositions[min(nodePositions.count - 1, days.count)]
                let zoneCompleted = AdventureProgressStore.shared.isZoneCompleted(zoneIndex: zoneIndex)
                let allDaysDone = days.allSatisfy { AdventureProgressStore.shared.isDayCompleted(dayIndex: $0) }

                MapDayNode(
                    label: "TEST",
                    state: allDaysDone ? .zoneTest(passed: zoneCompleted) : .locked,
                    onTap: {
                        guard allDaysDone else { return }
                        route = .zoneTest(zoneIndex)
                    }
                )
                .position(x: geo.size.width * testPos.x, y: geo.size.height * testPos.y)

                // Bottom nav — at 87% from top
                HStack {
                    if zoneIndex > 0 {
                        Button {
                            withAnimation(.easeInOut(duration: 0.3)) { zoneIndex -= 1 }
                        } label: {
                            Text("← \(zoneSubtitles[(zoneIndex - 1) % zoneSubtitles.count])")
                                .font(.system(size: 13, weight: .semibold, design: .rounded))
                                .foregroundStyle(.white.opacity(0.85))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 7)
                                .background(Color.black.opacity(0.4))
                                .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
                    }

                    Spacer()

                    if zoneIndex < AdventureSchedule.totalZones - 1 {
                        Button {
                            withAnimation(.easeInOut(duration: 0.3)) { zoneIndex += 1 }
                        } label: {
                            Text("\(zoneSubtitles[(zoneIndex + 1) % zoneSubtitles.count]) →")
                                .font(.system(size: 13, weight: .semibold, design: .rounded))
                                .foregroundStyle(.white.opacity(0.85))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 7)
                                .background(Color.black.opacity(0.4))
                                .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 12)
                .position(x: geo.size.width * 0.5, y: geo.size.height * 0.87)

                // Zone dots — at 90%
                HStack(spacing: 8) {
                    ForEach(0..<AdventureSchedule.totalZones, id: \.self) { i in
                        Circle()
                            .fill(i == zoneIndex ? Color.white : Color.white.opacity(0.35))
                            .frame(width: i == zoneIndex ? 8 : 5, height: i == zoneIndex ? 8 : 5)
                    }
                }
                .position(x: geo.size.width * 0.5, y: geo.size.height * 0.90)

                // Cover Gemini watermark — small dark patch at bottom right
                Color.black.opacity(0.5)
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
                    .blur(radius: 8)
                    .position(x: geo.size.width * 0.95, y: geo.size.height * 0.97)
            }
        }
        .ignoresSafeArea()
        .navigationDestination(item: $route) { route in
            switch route {
            case .day(let dayIdx):
                DayCompleteSummary(studyDay: dayIdx, userId: LocalIdentity.userId())
                    .navigationTitle("Day \(AdventureSchedule.globalDayNumber(forDayIndex: dayIdx))")
            case .zoneTest(let zi):
                ZoneReviewSessionView(zoneIndex: zi) {
                    AdventureProgressStore.shared.setZoneUnlocked(zoneIndex: zi + 1, unlocked: true)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .task { await loadZoneWordProgress() }
        .onChange(of: zoneIndex) { _, _ in Task { await loadZoneWordProgress() } }
    }

    // MARK: - Zone-themed colors

    private var titleColor: Color {
        switch zoneIndex % 4 {
        case 0: return Color(hex: "#1E5A2D")
        case 1: return Color(hex: "#502814")
        case 2: return Color(hex: "#B48CDC")
        default: return Color(hex: "#DCC8A0")
        }
    }

    private var titleShadow: Color {
        switch zoneIndex % 4 {
        case 0: return Color.black.opacity(0.5)
        case 1: return Color(hex: "#FFE0B2").opacity(0.4)
        case 2: return Color.black.opacity(0.6)
        default: return Color.black.opacity(0.6)
        }
    }

    private var subtitleColor: Color {
        switch zoneIndex % 4 {
        case 0: return Color(hex: "#96C88C")
        case 1: return Color(hex: "#FFDCB4")
        case 2: return Color(hex: "#A082C8")
        default: return Color(hex: "#C8B48C")
        }
    }

    // MARK: - Background

    @ViewBuilder
    private var zoneBackground: some View {
        let imgName = zoneBackgroundImages[zoneIndex % zoneBackgroundImages.count]
        if let img = loadBundledImage(named: imgName) {
            Image(uiImage: img)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        } else {
            Rectangle().fill(Color.black).ignoresSafeArea()
        }
    }

    private func loadBundledImage(named name: String) -> UIImage? {
        if let url = Bundle.main.url(forResource: name, withExtension: "png", subdirectory: "MapBackgrounds") {
            return UIImage(contentsOfFile: url.path)
        }
        if let url = Bundle.main.url(forResource: name, withExtension: "png") {
            return UIImage(contentsOfFile: url.path)
        }
        return nil
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
