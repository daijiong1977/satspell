# Plan 3: App Shell + Navigation

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the app navigation shell: 4-tab layout, Practice tab (daily hub with 5 P0 states), Adventure map with session indicators, and parent report sharing.

**Architecture:** Replace the current 5-tab RootTabView with a 4-tab layout. The Practice tab is the new primary screen with a state resolver that determines which of 5 states to show. The Adventure map is redesigned with session indicators (☀️🌙 dots). Tab bar hidden during sessions.

**Tech Stack:** SwiftUI, existing Data layer (Plan 1) + Session engine (Plan 2)

**Depends on:** Plan 1 (Data Layer) must be complete. Plan 2 (Session Engine) should be complete for full integration, but the shell can be built with stub data.

**Reference docs:**
- `docs/ui-design-spec.md` Sections 1-3 — tab bar, map, Practice tab states
- `docs/ui-visual-system.md` — dark chrome, white cards, accent glows
- `docs/ui-design-spec.md` Section 14.6-14.7 — map tap behavior, timing matrix

---

### File Structure

```
ios/SATVocabApp/Sources/SATVocabApp/
├── Views/
│   ├── RootTabView.swift             (MODIFY — 5 tabs → 4 tabs)
│   ├── Practice/
│   │   ├── PracticeTabView.swift     (CREATE — daily hub, state resolver)
│   │   ├── MorningSessionCard.swift  (CREATE — session card component)
│   │   ├── EveningSessionCard.swift  (CREATE — with lock timer)
│   │   ├── ResumeCard.swift          (CREATE — gold border resume)
│   │   ├── DayCompleteSummary.swift  (CREATE — State E summary)
│   │   ├── PracticeHeader.swift      (CREATE — Day + streak + XP header)
│   │   ├── MorningCompleteCard.swift (CREATE — green checkmark card)
│   │   ├── EveningCompleteCard.swift (CREATE — green checkmark card)
│   │   ├── ReviewsDueRow.swift       (CREATE — "12 reviews due today" row)
│   │   └── PracticeStateResolver.swift (CREATE — determines which state to show)
│   ├── Map/
│   │   ├── AdventureMapView.swift    (MODIFY — redesign with session dots)
│   │   ├── MapDayNode.swift          (CREATE — replaces AdventureDayNode)
│   │   └── ZoneProgressBar.swift     (CREATE — word progress per zone)
│   ├── Stats/
│   │   └── StatsView.swift           (MODIFY — minimal P0 version)
│   ├── Profile/
│   │   └── ProfileView.swift         (MODIFY — share report + settings)
│   └── Report/
│       └── ReportCardGenerator.swift (CREATE — renders report image for sharing)
├── ViewModels/
│   └── PracticeTabViewModel.swift    (CREATE — Practice tab state management)
```

---

### Task 1: 4-Tab Root Layout

**Files:**
- Modify: `ios/SATVocabApp/Sources/SATVocabApp/Views/RootTabView.swift`

- [ ] **Step 1: Update RootTabView to 4 tabs**

```swift
// Replace entire RootTabView.swift
import SwiftUI

struct RootTabView: View {
    enum Tab: Hashable {
        case map
        case practice
        case stats
        case profile
    }

    @State private var selected: Tab = .practice  // Practice is the default tab

    var body: some View {
        TabView(selection: $selected) {
            NavigationStack {
                AdventureMapView()
            }
            .tabItem {
                Label("Map", systemImage: "map")
            }
            .tag(Tab.map)

            NavigationStack {
                PracticeTabView()
            }
            .tabItem {
                Label("Practice", systemImage: "pencil.and.list.clipboard")
            }
            .tag(Tab.practice)

            NavigationStack {
                StatsView()
            }
            .tabItem {
                Label("Stats", systemImage: "chart.bar")
            }
            .tag(Tab.stats)

            NavigationStack {
                ProfileView()
            }
            .tabItem {
                Label("Profile", systemImage: "person")
            }
            .tag(Tab.profile)
        }
        .tint(Color(hex: "#58CC02"))  // Green active tab
    }
}
```

- [ ] **Step 2: Remove old tabs** — Delete `GamesHubView.swift`, `DayTasksView.swift`, `DashboardView.swift` references
- [ ] **Step 3: Verify build + commit**

```bash
git commit -m "feat: 4-tab layout (Map, Practice, Stats, Profile)"
```

---

### Task 2: Practice Tab State Resolver + View

**Files:**
- Create: `PracticeStateResolver.swift`, `PracticeTabViewModel.swift`, `PracticeTabView.swift`

- [ ] **Step 1: Create PracticeStateResolver**

Implements the priority resolver from `ui-design-spec.md` Section 3.4.

```swift
// ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/PracticeStateResolver.swift
import Foundation

enum PracticeState {
    case morningAvailable           // A
    case paused(SessionState)       // B
    case morningDoneEveningLocked(unlockAt: Date) // C
    case eveningAvailable           // D
    case bothComplete               // E
}

struct PracticeStateResolver {
    static func resolve(
        dayState: DayState?,
        activeSession: SessionState?,
        now: Date = Date()
    ) -> PracticeState {
        // Priority 1: Paused session
        if let session = activeSession, session.isPaused {
            return .paused(session)
        }

        guard let day = dayState else {
            return .morningAvailable
        }

        // Both done
        if day.morningComplete && day.eveningComplete {
            // DailyStats loaded separately in PracticeTabViewModel
            return .bothComplete
        }

        // Morning done, check evening
        if day.morningComplete {
            let unlockAt = calculateEveningUnlock(morningCompleteAt: day.morningCompleteAt)
            if now >= unlockAt {
                return .eveningAvailable
            } else {
                return .morningDoneEveningLocked(unlockAt: unlockAt)
            }
        }

        // Morning not done
        return .morningAvailable
    }

    private static func calculateEveningUnlock(morningCompleteAt: Date?) -> Date {
        guard let morningDone = morningCompleteAt else {
            // Fallback to 5 PM today
            return Calendar.current.date(bySettingHour: AppConfig.eveningUnlockFallbackHour,
                                        minute: 0, second: 0, of: Date()) ?? Date()
        }

        let fourHoursLater = morningDone.addingTimeInterval(TimeInterval(AppConfig.eveningUnlockHours * 3600))
        let fivePM = Calendar.current.date(bySettingHour: AppConfig.eveningUnlockFallbackHour,
                                           minute: 0, second: 0, of: Date()) ?? Date()

        return min(fourHoursLater, fivePM)  // whichever comes first
    }
}
```

- [ ] **Step 2: Create PracticeTabViewModel**

```swift
// ios/SATVocabApp/Sources/SATVocabApp/ViewModels/PracticeTabViewModel.swift
import Foundation
import Combine

@MainActor
final class PracticeTabViewModel: ObservableObject {
    @Published var state: PracticeState = .morningAvailable
    @Published var studyDay: Int = 0
    @Published var zoneIndex: Int = 0
    @Published var streak: StreakInfo = StreakInfo(currentStreak: 0, bestStreak: 0, lastStudyDate: nil, totalXP: 0, totalStudyDays: 0, streak3Claimed: false, streak7Claimed: false, streak14Claimed: false, streak30Claimed: false)
    @Published var reviewsDueCount: Int = 0
    @Published var isLoading: Bool = true

    let userId = LocalIdentity.userId()

    func load() async {
        isLoading = true
        do {
            let dm = DataManager.shared
            try await dm.initializeIfNeeded()

            let sessionStore = SessionStateStore(db: dm.db)
            let statsStore = StatsStore(db: dm.db)
            let wsStore = WordStateStore(db: dm.db)

            let dayState = try await sessionStore.getCurrentDayState(userId: userId)
            let activeSession = try await sessionStore.getActiveSession(userId: userId)
            streak = try await statsStore.getStreak(userId: userId)
            reviewsDueCount = try await wsStore.countOverdue(userId: userId)

            studyDay = dayState?.studyDay ?? 0
            zoneIndex = dayState?.zoneIndex ?? 0

            state = PracticeStateResolver.resolve(
                dayState: dayState,
                activeSession: activeSession
            )
        } catch {
            // Handle error
        }
        isLoading = false
    }
}
```

- [ ] **Step 3: Create PracticeTabView**

```swift
// ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/PracticeTabView.swift
import SwiftUI

struct PracticeTabView: View {
    @StateObject private var vm = PracticeTabViewModel()
    @State private var navigateToSession: SessionType? = nil

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                // Header: Day + streak + XP
                PracticeHeader(
                    studyDay: vm.studyDay,
                    zoneIndex: vm.zoneIndex,
                    streak: vm.streak.currentStreak,
                    totalXP: vm.streak.totalXP
                )

                // State-dependent content
                switch vm.state {
                case .morningAvailable:
                    MorningSessionCard {
                        navigateToSession = .morning
                    }
                    EveningSessionCard(locked: true, unlockAt: nil)
                    ReviewsDueRow(count: vm.reviewsDueCount)

                case .paused(let session):
                    ResumeCard(session: session) {
                        navigateToSession = session.sessionType
                    }
                    EveningSessionCard(locked: true, unlockAt: nil)

                case .morningDoneEveningLocked(let unlockAt):
                    MorningCompleteCard()
                    EveningSessionCard(locked: true, unlockAt: unlockAt)

                case .eveningAvailable:
                    MorningCompleteCard()
                    EveningSessionCard(locked: false, unlockAt: nil) {
                        navigateToSession = .evening
                    }

                case .bothComplete:
                    MorningCompleteCard()
                    EveningCompleteCard()
                    DayCompleteSummary(studyDay: vm.studyDay, userId: vm.userId)
                }
            }
            .padding(.horizontal, 16)
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { Task { await vm.load() } }
        .navigationDestination(item: $navigateToSession) { type in
            SessionFlowView(vm: SessionFlowViewModel(sessionType: type, studyDay: vm.studyDay))
        }
    }
}
```

- [ ] **Step 4: Create session card components** (MorningSessionCard, EveningSessionCard, ResumeCard, DayCompleteSummary)
- [ ] **Step 5: Verify build + commit**

```bash
git commit -m "feat: PracticeTab with state resolver (5 P0 states)"
```

---

### Task 3: Adventure Map Redesign

**Files:**
- Modify: `AdventureMapView.swift`
- Create: `MapDayNode.swift`, `ZoneProgressBar.swift`

- [ ] **Step 1: Create MapDayNode** — session dots (☀️🌙), half-state, zone test trophy icon
- [ ] **Step 2: Create ZoneProgressBar** — thin bar showing familiar+ word count per zone
- [ ] **Step 3: Redesign AdventureMapView** — zone backgrounds, new node states, context-aware CTA button
- [ ] **Step 4: Verify build + commit**

```bash
git commit -m "feat: Adventure map redesign (session dots, zone progress, trophy nodes)"
```

---

### Task 4: Profile + Report Sharing

**Files:**
- Modify: `ProfileView.swift`
- Create: `ReportCardGenerator.swift`

- [ ] **Step 1: Update ProfileView** — Share Today's Progress button, notification toggles, reset
- [ ] **Step 2: Create ReportCardGenerator** — renders report card view to UIImage via ImageRenderer, passes to UIActivityViewController
- [ ] **Step 3: Verify build + commit**

```bash
git commit -m "feat: ProfileView + parent report card sharing"
```

---

### Task 5: Stats Tab (Minimal P0)

**Files:**
- Modify: `StatsView.swift`

- [ ] **Step 1: Update StatsView** — hero tiles (streak, XP, words), box distribution bar, Words Fighting Back list (display-only)
- [ ] **Step 2: Verify build + commit**

```bash
git commit -m "feat: StatsView P0 (hero tiles, box distribution, Words Fighting Back)"
```

---

### Task 6: Integration + Cleanup

- [ ] **Step 1: Remove old views** — Delete or archive: `DashboardView.swift`, `GamesHubView.swift`, `DayTasksView.swift`, `TimelineView.swift`, `ZoneUnlockReviewView.swift`
- [ ] **Step 2: Remove old view models** — `DashboardViewModel.swift`, old `FlashcardSessionViewModel.swift`, old `GameSessionViewModel.swift`
- [ ] **Step 3: Remove old data stores** — `AdventureProgressStore.swift`, `TaskProgressStore.swift` (replaced by SessionStateStore + ZoneStore)
- [ ] **Step 4: Update project.yml** — ensure all new files are included, old files removed
- [ ] **Step 5: Full build + run test**
- [ ] **Step 6: Commit**

```bash
git commit -m "chore: remove old views/viewmodels, clean up project structure"
```

---

### Plan 3 Summary

**6 tasks, ~15 files created/modified:**

| Task | Component | Key Capability |
|------|-----------|---------------|
| 1 | Root tab layout | 4 tabs, Practice as default |
| 2 | Practice tab | State resolver (5 states), session cards, lock timer, resume |
| 3 | Adventure map | Zone backgrounds, session dots, trophy node, zone progress |
| 4 | Profile + Report | Share Today's Progress, notification settings, report image |
| 5 | Stats tab | Box distribution, streak, Words Fighting Back |
| 6 | Integration | Remove old code, clean project |

**After Plan 3:** The app is fully functional for P0. Student can navigate between tabs, start morning/evening sessions, play through all 4 activities, see progress, share reports, and track streaks.
