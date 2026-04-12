# Plan 2: Session Engine + Activity Views

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the core learning loop: session flow orchestrator that chains 4 activity views (flashcard, image game, quick recall, SAT question), with scoring, pause/resume, and session completion.

**Architecture:** A `SessionFlowViewModel` orchestrates the multi-step session. Each activity view is a standalone SwiftUI view that communicates results back via closures. The orchestrator manages step transitions, word loading, and Show Again priority passing between steps.

**Tech Stack:** SwiftUI, Combine (@Published), existing Data layer from Plan 1

**Depends on:** Plan 1 (Data Layer) must be complete.

**Reference docs:**
- `docs/flashcard-design.md` — flashcard layout, gestures, Word Strength meter
- `docs/game-views-design.md` — image game, quick recall, SAT question specs
- `docs/ui-design-spec.md` Section 4 — session header, step transitions
- `docs/ui-visual-system.md` — colors, typography, animations
- `docs/points-system.md` — XP per answer, combos, session bonus

---

### File Structure

```
ios/SATVocabApp/Sources/SATVocabApp/
├── ViewModels/
│   ├── SessionFlowViewModel.swift    (CREATE — orchestrates multi-step session)
│   ├── FlashcardStepViewModel.swift  (CREATE — replaces FlashcardSessionViewModel)
│   ├── ImageGameViewModel.swift      (CREATE — replaces GameSessionViewModel for image game)
│   ├── QuickRecallViewModel.swift    (CREATE — new)
│   ├── SATQuestionViewModel.swift    (CREATE — new)
│   └── SessionCompleteViewModel.swift (CREATE — session summary data)
├── Views/
│   ├── Session/
│   │   ├── SessionFlowView.swift     (CREATE — container that switches between steps)
│   │   ├── SessionHeaderView.swift   (CREATE — glass header with progress)
│   │   ├── StepTransitionView.swift  (CREATE — "Step 1 Complete!" screen)
│   │   ├── SessionCompleteView.swift (CREATE — session summary + share)
│   │   └── PauseSheet.swift          (CREATE — pause confirmation bottom sheet)
│   ├── Flashcard/
│   │   ├── FlashcardFrontView.swift  (CREATE — image-hero with sentence overlay)
│   │   ├── FlashcardBackView.swift   (CREATE — definition, collocations, Word Strength meter)
│   │   └── FlashcardCardView.swift   (CREATE — flip container, replaces FlashcardView.swift)
│   ├── Game/
│   │   ├── ImageGameView.swift       (CREATE — replaces ClozeRoundView)
│   │   ├── QuickRecallView.swift     (CREATE — new activity)
│   │   ├── SATQuestionView.swift     (CREATE — split-scroll, replaces SatMCQRoundView)
│   │   └── AnswerFeedbackView.swift  (CREATE — correct/wrong feedback overlay)
│   └── Components/
│       ├── WordStrengthMeter.swift   (CREATE — 5-segment bar)
│       ├── XPChipView.swift          (CREATE — +10 XP animation)
│       ├── ComboCalloutView.swift    (CREATE — "On a roll." toast)
│       └── Button3D.swift            (CREATE — Duolingo-style 3D button)
```

---

### Task 1: Session Flow Orchestrator

**Files:**
- Create: `ios/SATVocabApp/Sources/SATVocabApp/ViewModels/SessionFlowViewModel.swift`
- Create: `ios/SATVocabApp/Sources/SATVocabApp/Views/Session/SessionFlowView.swift`

- [ ] **Step 1: Create SessionFlowViewModel**

This is the brain of the session. It manages:
- Which step is active (flashcard → game → SAT for morning; flashcard → recall → game → SAT for evening)
- Word lists for each step
- Show Again IDs passed from Step 1 → Step 2
- Scoring totals for session complete
- Pause/resume state

```swift
// ios/SATVocabApp/Sources/SATVocabApp/ViewModels/SessionFlowViewModel.swift
import Foundation

@MainActor
final class SessionFlowViewModel: ObservableObject {
    // Session config
    let sessionType: SessionType
    let studyDay: Int
    let userId: String

    // State
    @Published var currentStepIndex: Int = 0
    @Published var isComplete: Bool = false
    @Published var isPaused: Bool = false
    @Published var showStepTransition: Bool = false

    // Scoring
    @Published var totalCorrect: Int = 0
    @Published var totalAttempts: Int = 0
    @Published var xpEarned: Int = 0
    @Published var wordsPromoted: Int = 0
    @Published var wordsDemoted: Int = 0
    @Published var comboCount: Int = 0

    // Show Again from flashcard step → image game step
    var showAgainWordIds: [Int] = []

    // Words for each step (loaded at session start)
    var newWords: [VocabCard] = []
    var reviewWords: [VocabCard] = []
    var morningWords: [VocabCard] = []  // for evening quick recall

    // Step definitions
    struct StepDef {
        let type: StepType
        let label: String
        let itemCount: Int
    }

    enum StepType {
        case flashcard
        case imageGame
        case quickRecall
        case satQuestion
    }

    var steps: [StepDef] = []

    var currentStep: StepDef? {
        steps.indices.contains(currentStepIndex) ? steps[currentStepIndex] : nil
    }

    var totalSteps: Int { steps.count }

    var progressLabel: String {
        guard let step = currentStep else { return "" }
        return step.label
    }

    init(sessionType: SessionType, studyDay: Int) {
        self.sessionType = sessionType
        self.studyDay = studyDay
        self.userId = LocalIdentity.userId()

        // Define steps based on session type
        switch sessionType {
        case .morning:
            steps = [
                StepDef(type: .flashcard, label: "Explore New Words", itemCount: AppConfig.morningNewWords),
                StepDef(type: .imageGame, label: "Image Practice", itemCount: AppConfig.morningGameRounds),
                StepDef(type: .satQuestion, label: "SAT Questions", itemCount: AppConfig.morningSATQuestions),
            ]
        case .evening:
            steps = [
                StepDef(type: .flashcard, label: "Explore New Words", itemCount: AppConfig.eveningNewWords),
                StepDef(type: .quickRecall, label: "Quick Recall", itemCount: AppConfig.morningNewWords),
                StepDef(type: .imageGame, label: "Image Practice", itemCount: AppConfig.eveningGameRounds),
                StepDef(type: .satQuestion, label: "SAT Questions", itemCount: AppConfig.eveningSATQuestions),
            ]
        default:
            // Recovery/review/bonus sessions — simplified
            steps = [
                StepDef(type: .imageGame, label: "Practice", itemCount: 12),
                StepDef(type: .satQuestion, label: "SAT Questions", itemCount: 3),
            ]
        }
    }

    func loadWords() async throws {
        // Load from DataManager based on session type and study day
        let dm = DataManager.shared
        try await dm.initializeIfNeeded()

        // Create required rows BEFORE any updates
        let sessionStore = SessionStateStore(db: dm.db)
        let statsStore = StatsStore(db: dm.db)
        let zoneIdx = studyDay / 4  // approximate zone
        _ = try await sessionStore.getOrCreateDayState(userId: userId, studyDay: studyDay, zoneIndex: zoneIdx)
        _ = try await sessionStore.createSession(userId: userId, sessionType: sessionType, studyDay: studyDay)
        _ = try await statsStore.getOrCreateDailyStats(userId: userId, studyDay: studyDay)

        let list = try await dm.getDefaultList()
        let startIndex = studyDay * (AppConfig.morningNewWords + AppConfig.eveningNewWords)

        switch sessionType {
        case .morning:
            newWords = try await dm.fetchSessionQueue(listId: list.id, limit: AppConfig.morningNewWords, startIndex: startIndex)
        case .evening:
            let morningStart = studyDay * (AppConfig.morningNewWords + AppConfig.eveningNewWords)
            morningWords = try await dm.fetchSessionQueue(listId: list.id, limit: AppConfig.morningNewWords, startIndex: morningStart)
            let eveningStart = morningStart + AppConfig.morningNewWords
            newWords = try await dm.fetchSessionQueue(listId: list.id, limit: AppConfig.eveningNewWords, startIndex: eveningStart)
        default:
            break
        }

        // Load review words from word_state
        let wsStore = WordStateStore(db: dm.db)
        let reviews = try await wsStore.getReviewQueue(userId: userId, limit: 6)
        // Convert WordState to VocabCard — would need a lookup
        // (simplified — full implementation maps wordId → VocabCard)
    }

    func advanceToNextStep() {
        showStepTransition = true
    }

    func continueAfterTransition() {
        showStepTransition = false
        currentStepIndex += 1
        if currentStepIndex >= steps.count {
            completeSession()
        }
    }

    func recordAnswer(correct: Bool, wordId: Int, activityType: ActivityType, durationMs: Int) async {
        totalAttempts += 1
        if correct {
            totalCorrect += 1
            xpEarned += AppConfig.correctAnswerXP
            comboCount += 1
        } else {
            comboCount = 0
        }

        // Record in data layer
        do {
            let dm = DataManager.shared
            let reviewLogger = ReviewLogger(db: dm.db)
            let wsStore = WordStateStore(db: dm.db)
            let statsStore = StatsStore(db: dm.db)

            // 1. Write review_log entry
            let outcome: ReviewOutcome = correct ? .correct : .incorrect
            try await reviewLogger.logReview(
                userId: userId, wordId: wordId, outcome: outcome,
                activityType: activityType, sessionType: sessionType,
                studyDay: studyDay, durationMs: durationMs)

            // 2. Update word_state (box progression)
            let boxChange = try await wsStore.recordScoredAnswer(userId: userId, wordId: wordId, correct: correct)

            switch boxChange {
            case .promoted(_, _): wordsPromoted += 1
            case .demoted(_, _): wordsDemoted += 1
            case .none: break
            }

            if correct {
                try await statsStore.recordCorrectAnswer(userId: userId, studyDay: studyDay)
            } else {
                try await statsStore.recordWrongAnswer(userId: userId, studyDay: studyDay)
            }
        } catch {
            // Non-fatal for v1
        }
    }

    func receiveShowAgainIds(_ ids: [Int]) {
        showAgainWordIds = ids
    }

    private func completeSession() {
        isComplete = true

        Task {
            do {
                let dm = DataManager.shared
                let sessionStore = SessionStateStore(db: dm.db)
                let statsStore = StatsStore(db: dm.db)

                // Mark session complete
                try await sessionStore.completeSession(userId: userId, studyDay: studyDay, sessionType: sessionType)

                // Session bonus
                try await statsStore.addSessionBonus(userId: userId, studyDay: studyDay)
                xpEarned += AppConfig.sessionBonusXP

                // Mark day state
                if sessionType == .morning {
                    try await sessionStore.markMorningComplete(userId: userId, studyDay: studyDay,
                        accuracy: totalAttempts > 0 ? Double(totalCorrect) / Double(totalAttempts) : 0,
                        xp: xpEarned, newWords: newWords.count)
                } else if sessionType == .evening {
                    try await sessionStore.markEveningComplete(userId: userId, studyDay: studyDay,
                        accuracy: totalAttempts > 0 ? Double(totalCorrect) / Double(totalAttempts) : 0,
                        xp: xpEarned, newWords: newWords.count)

                    // Run Day 1 promotion
                    let wsStore = WordStateStore(db: dm.db)
                    let promotion = try await wsStore.runDay1Promotion(userId: userId, studyDay: studyDay)
                    wordsPromoted += promotion.promoted
                }

                // Update streak
                let (_, milestoneXP) = try await statsStore.updateStreak(userId: userId, xpToday: xpEarned)
                xpEarned += milestoneXP
            } catch {
                // Non-fatal
            }
        }
    }

    // MARK: - Pause/Resume

    func pause(stepIndex: Int, itemIndex: Int, showAgainIds: [Int], requeuedIds: [Int]) async {
        isPaused = true
        do {
            let dm = DataManager.shared
            let store = SessionStateStore(db: dm.db)
            try await store.pauseSession(userId: userId, studyDay: studyDay, sessionType: sessionType,
                                        stepIndex: stepIndex, itemIndex: itemIndex,
                                        showAgainIds: showAgainIds, requeuedIds: requeuedIds)
        } catch {}
    }
}
```

- [ ] **Step 2: Create SessionFlowView**

```swift
// ios/SATVocabApp/Sources/SATVocabApp/Views/Session/SessionFlowView.swift
import SwiftUI

struct SessionFlowView: View {
    @StateObject var vm: SessionFlowViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            if vm.isComplete {
                SessionCompleteView(
                    xpEarned: vm.xpEarned,
                    totalCorrect: vm.totalCorrect,
                    totalAttempts: vm.totalAttempts,
                    wordsPromoted: vm.wordsPromoted,
                    wordsDemoted: vm.wordsDemoted,
                    onDone: { dismiss() }
                )
            } else if vm.showStepTransition {
                StepTransitionView(
                    stepNumber: vm.currentStepIndex + 1,
                    totalSteps: vm.totalSteps,
                    nextStepLabel: vm.steps[safe: vm.currentStepIndex + 1]?.label ?? "Done",
                    onContinue: { vm.continueAfterTransition() }
                )
            } else if let step = vm.currentStep {
                switch step.type {
                case .flashcard:
                    FlashcardStepView(
                        words: vm.newWords,
                        stepNumber: vm.currentStepIndex + 1,
                        totalSteps: vm.totalSteps,
                        onComplete: { showAgainIds in
                            vm.receiveShowAgainIds(showAgainIds)
                            vm.advanceToNextStep()
                        },
                        onPause: { stepIdx, itemIdx, saIds, rqIds in
                            Task { await vm.pause(stepIndex: stepIdx, itemIndex: itemIdx, showAgainIds: saIds, requeuedIds: rqIds) }
                            dismiss()
                        }
                    )
                case .imageGame:
                    ImageGameStepView(
                        words: vm.newWords,
                        showAgainPriority: vm.showAgainWordIds,
                        stepNumber: vm.currentStepIndex + 1,
                        totalSteps: vm.totalSteps,
                        onAnswer: { correct, wordId in
                            Task { await vm.recordAnswer(correct: correct, wordId: wordId, activityType: .imageGame, durationMs: 0) }
                        },
                        onComplete: { vm.advanceToNextStep() },
                        onPause: { _, _, _, _ in dismiss() }
                    )
                case .quickRecall:
                    QuickRecallStepView(
                        words: vm.morningWords,
                        stepNumber: vm.currentStepIndex + 1,
                        totalSteps: vm.totalSteps,
                        onAnswer: { correct, wordId in
                            Task { await vm.recordAnswer(correct: correct, wordId: wordId, activityType: .imageGame, durationMs: 0) }
                        },
                        onComplete: { vm.advanceToNextStep() },
                        onPause: { _, _, _, _ in dismiss() }
                    )
                case .satQuestion:
                    SATQuestionStepView(
                        words: vm.newWords,
                        stepNumber: vm.currentStepIndex + 1,
                        totalSteps: vm.totalSteps,
                        onAnswer: { correct, wordId in
                            Task { await vm.recordAnswer(correct: correct, wordId: wordId, activityType: .imageGame, durationMs: 0) }
                        },
                        onComplete: { vm.advanceToNextStep() },
                        onPause: { _, _, _, _ in dismiss() }
                    )
                }
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .task { try? await vm.loadWords() }
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
```

- [ ] **Step 3: Verify build + commit**

```bash
git add ios/SATVocabApp/Sources/SATVocabApp/ViewModels/SessionFlowViewModel.swift \
        ios/SATVocabApp/Sources/SATVocabApp/Views/Session/SessionFlowView.swift
git commit -m "feat: SessionFlowViewModel + SessionFlowView (multi-step orchestrator)"
```

---

### Task 2: Shared UI Components

**Files:**
- Create: `Button3D.swift`, `WordStrengthMeter.swift`, `XPChipView.swift`, `ComboCalloutView.swift`, `SessionHeaderView.swift`

- [ ] **Step 1: Create Button3D (Duolingo-style 3D button)**

```swift
// ios/SATVocabApp/Sources/SATVocabApp/Views/Components/Button3D.swift
import SwiftUI

struct Button3D: View {
    let title: String
    let color: Color
    let pressedColor: Color
    let textColor: Color
    let action: () -> Void

    @State private var isPressed = false

    init(_ title: String, color: Color = Color(hex: "#58CC02"),
         pressedColor: Color = Color(hex: "#58A700"),
         textColor: Color = .white, action: @escaping () -> Void) {
        self.title = title
        self.color = color
        self.pressedColor = pressedColor
        self.textColor = textColor
        self.action = action
    }

    var body: some View {
        Text(title)
            .font(.system(size: 15, weight: .heavy, design: .rounded))
            .tracking(0.3)
            .foregroundColor(textColor)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(pressedColor)
                    .frame(height: isPressed ? 2 : 4)
                    .frame(maxHeight: .infinity, alignment: .bottom)
            )
            .offset(y: isPressed ? 2 : 0)
            .animation(.easeOut(duration: 0.12), value: isPressed)
            .onTapGesture {
                isPressed = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                    isPressed = false
                    action()
                }
            }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
```

- [ ] **Step 2: Create WordStrengthMeter**

```swift
// ios/SATVocabApp/Sources/SATVocabApp/Views/Components/WordStrengthMeter.swift
import SwiftUI

struct WordStrengthMeter: View {
    let boxLevel: Int  // 0-5
    let memoryStatus: MemoryStatus

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 2) {
                ForEach(1...5, id: \.self) { level in
                    RoundedRectangle(cornerRadius: 3, style: .continuous)
                        .fill(level <= boxLevel
                              ? Color(hex: WordStrength(rawValue: level)?.color ?? "#E8ECF0")
                              : Color(hex: "#E8ECF0"))
                        .frame(height: 6)
                }
            }

            if boxLevel > 0 {
                HStack(spacing: 4) {
                    if memoryStatus == .fragile {
                        Circle().fill(Color(hex: "#FFC800")).frame(width: 6, height: 6)
                    } else if memoryStatus == .stubborn {
                        Circle().fill(Color(hex: "#FF7043")).frame(width: 6, height: 6)
                    }

                    Text(WordStrength(rawValue: boxLevel)?.label ?? "")
                        .font(.system(size: 9, weight: .semibold, design: .rounded))
                        .foregroundColor(Color(hex: WordStrength(rawValue: boxLevel)?.color ?? "#AFAFAF"))
                }
            }
        }
    }
}
```

- [ ] **Step 3: Create SessionHeaderView**

```swift
// ios/SATVocabApp/Sources/SATVocabApp/Views/Session/SessionHeaderView.swift
import SwiftUI

struct SessionHeaderView: View {
    let stepNumber: Int
    let totalSteps: Int
    let stepLabel: String
    let currentItem: Int
    let totalItems: Int
    let progressColor: Color
    let isScored: Bool
    let onClose: () -> Void

    var body: some View {
        VStack(spacing: 6) {
            HStack {
                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(hex: "#AFAFAF"))
                }

                Spacer()

                VStack(spacing: 2) {
                    Text("STEP \(stepNumber) OF \(totalSteps) · \(isScored ? "📊 SCORED" : "👁️ EXPOSURE")")
                        .font(.system(size: 9, weight: .semibold, design: .rounded))
                        .foregroundColor(isScored ? progressColor : Color(hex: "#AFAFAF"))
                        .tracking(0.5)

                    Text("\(stepLabel) · \(currentItem)/\(totalItems)")
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: "#4B4B4B"))
                }

                Spacer()

                // Sound button for flashcard/recall
                Button(action: {}) {
                    Image(systemName: "speaker.wave.2.fill")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color(hex: "#AFAFAF"))
                }
            }
            .padding(.horizontal, 16)

            // Progress bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3, style: .continuous)
                        .fill(Color(hex: "#E5E5E5"))

                    RoundedRectangle(cornerRadius: 3, style: .continuous)
                        .fill(progressColor)
                        .frame(width: geo.size.width * CGFloat(currentItem) / CGFloat(max(totalItems, 1)))
                }
            }
            .frame(height: 6)
            .padding(.horizontal, 16)
        }
        .padding(.top, 8)
        .padding(.bottom, 4)
    }
}
```

- [ ] **Step 4: Verify build + commit**

```bash
git add ios/SATVocabApp/Sources/SATVocabApp/Views/Components/
git add ios/SATVocabApp/Sources/SATVocabApp/Views/Session/SessionHeaderView.swift
git commit -m "feat: shared UI components (Button3D, WordStrengthMeter, SessionHeader)"
```

---

### Task 3: Flashcard View (Image Hero)

**Files:**
- Create: `FlashcardFrontView.swift`, `FlashcardBackView.swift`, `FlashcardCardView.swift`

Refer to `docs/flashcard-design.md` for complete spec. Key points:
- Front: image fills 100%, sentence with gold-highlighted word overlaid at bottom
- Back: thumbnail + word + Word Strength meter + definition + example + collocations + SAT context
- Tap to flip, swipe left/right to navigate
- Show Again / Got It buttons on back only
- Show Again re-queues card at end of step

The implementation follows the existing `FlashcardView.swift` pattern but with the new image-hero layout. Full SwiftUI code is ~200 lines per file — the engineer should reference `flashcard-design.md` Sections 2-4 for exact layout specs and `ui-visual-system.md` Section 2.2 for colors/typography.

- [ ] **Step 1: Create FlashcardCardView with flip animation**
- [ ] **Step 2: Create FlashcardFrontView (image hero + sentence overlay)**
- [ ] **Step 3: Create FlashcardBackView (definition, example, collocations, Word Strength)**
- [ ] **Step 4: Create FlashcardStepView (manages card deck, Show Again, navigation)**
- [ ] **Step 5: Verify build + commit**

```bash
git commit -m "feat: FlashcardView redesign (image-hero, sentence overlay, Word Strength meter)"
```

---

### Task 4: Image-to-Word Game

**Files:**
- Create: `ImageGameView.swift`, `ImageGameStepView.swift`

Refer to `docs/game-views-design.md` Section 2. Key points:
- Image area (45-50%), cloze sentence, 2×2 answer grid
- Show Again priority words fill "new" slots first
- Correct: green flash + "+10 XP" chip + auto-advance 1.5s
- Wrong: red flash + correct highlighted + auto-advance 2.5s
- Scored — writes to review_log and updates word_state

- [ ] **Step 1: Create ImageGameView (single round UI)**
- [ ] **Step 2: Create ImageGameStepView (manages rounds, scoring, Show Again priority)**
- [ ] **Step 3: Verify build + commit**

```bash
git commit -m "feat: ImageGameView (scored, 2x2 grid, Show Again priority)"
```

---

### Task 5: Quick Recall

**Files:**
- Create: `QuickRecallView.swift`, `QuickRecallStepView.swift`

Refer to `docs/game-views-design.md` Section 3. Key points:
- Word displayed large, "from this morning" label
- 4 definition choices (vertical stack)
- Purple progress bar
- Fast-paced (1s correct, 2s wrong auto-advance)
- Scored + Day 1 promotion event

- [ ] **Step 1: Create QuickRecallView + QuickRecallStepView**
- [ ] **Step 2: Verify build + commit**

```bash
git commit -m "feat: QuickRecallView (scored, purple theme, fast-paced)"
```

---

### Task 6: SAT Question (Split Scroll)

**Files:**
- Create: `SATQuestionView.swift`, `SATQuestionStepView.swift`

Refer to `docs/game-views-design.md` Section 4. Key points:
- Split scroll: passage top (scrollable, serif font), question + A/B/C/D bottom (fixed)
- CHECK button, bottom sheet feedback (correct/wrong + explanation)
- Orange progress bar
- Scored

- [ ] **Step 1: Create SATQuestionView + SATQuestionStepView**
- [ ] **Step 2: Verify build + commit**

```bash
git commit -m "feat: SATQuestionView (split-scroll, bottom sheet feedback)"
```

---

### Task 7: Session Complete + Pause Sheet

**Files:**
- Create: `SessionCompleteView.swift`, `PauseSheet.swift`, `StepTransitionView.swift`

- [ ] **Step 1: Create SessionCompleteView** — XP, streak, promoted/demoted, Share Progress button
- [ ] **Step 2: Create PauseSheet** — progress info, focus tip, Keep Going / Pause & Exit
- [ ] **Step 3: Create StepTransitionView** — celebration emoji, step dots, next step card
- [ ] **Step 4: Verify build + commit**

```bash
git commit -m "feat: SessionCompleteView, PauseSheet, StepTransitionView"
```

---

### Plan 2 Summary

**7 tasks, ~20 files created:**

| Task | Component | Key Capability |
|------|-----------|---------------|
| 1 | SessionFlowViewModel + View | Multi-step orchestrator, word loading, scoring |
| 2 | Shared components | Button3D, WordStrengthMeter, SessionHeader, XP chip |
| 3 | Flashcard | Image-hero, sentence overlay, flip, Show Again/Got It |
| 4 | Image Game | 2×2 grid, cloze, Show Again priority, scoring |
| 5 | Quick Recall | Word → definition, purple theme, fast-paced |
| 6 | SAT Question | Split-scroll, serif passage, A/B/C/D, bottom sheet |
| 7 | Session Complete + Pause | Summary, share, pause confirmation, step transition |

**After Plan 2:** Student can play through a complete morning or evening session with all 4 activity types, see scores, and pause/resume. No navigation shell yet — that's Plan 3.
