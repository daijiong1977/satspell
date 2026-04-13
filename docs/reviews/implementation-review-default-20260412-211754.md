# Implementation Review vs `docs/ui-design-spec.md`

**Verdict:** The Swift code covers the basic P0 shell, but it does **not** fully match the spec's screen inventory, several required button actions are missing or wired differently, pause/resume/recovery handling is only partial, and the data model still reflects an older/ad hoc flow in a few key places.

Two important scope notes from the spec:
- `docs/ui-design-spec.md:1025-1060` lists the **full** inventory, including P1/P2 views.
- `docs/ui-design-spec.md:1233-1247` narrows P0 to the simpler A-E Practice states and explicitly defers recovery, back-pressure, late-night, bonus practice, rush toasts, and some other pieces.

## 1. Screen inventory

### What is present
- The app has the required 4-tab shell: `RootTabView.swift:14-47` creates Map, Practice, Stats, and Profile tabs.
- The main P0 session surfaces exist in some form: `PracticeTabView.swift:41-98`, `ResumeCard.swift:3-81`, `SessionFlowView.swift:30-125`, `FlashcardStepView.swift:38-120`, `ImageGameStepView.swift:24-82`, `QuickRecallStepView.swift:23-79`, `SATQuestionStepView.swift:23-83`, `SessionCompleteView.swift:17-90`, `PauseSheet.swift:8-63`.
- The tab bar is hidden during active sessions via `SessionFlowView.swift:124-125`.

### Where the inventory diverges
- **AdventureMapView is missing major spec surfaces.** The spec requires header badges, context-aware CTA, richer node states, and zone/test gating (`docs/ui-design-spec.md:136-206`). The implementation only renders the zone header, progress bar, and node map (`AdventureMapView.swift:27-126`). There is **no map CTA button at all**.
- **Map node states are incomplete.** The spec includes completed, morning-done split, current, available, locked, and zone-test states (`docs/ui-design-spec.md:162-178`). The code only models `.completed`, `.current`, `.available`, `.locked`, and `.zoneTest` (`MapDayNode.swift:4-10`), and `AdventureMapView.swift:165-174` never produces a morning-done split state.
- **Practice only implements A-E.** `PracticeStateResolver.swift:3-43` defines and resolves only `morningAvailable`, `paused`, `morningDoneEveningLocked`, `eveningAvailable`, and `bothComplete`. Full-spec states F1/F2/F3/G/H (`docs/ui-design-spec.md:321-447`) and the inventory items that support them (`docs/ui-design-spec.md:1037-1040`) are absent.
- **Stats is only a partial redesign.** `StatsView.swift:16-133` renders hero tiles, a box bar, stubborn words, and best streak, but the spec also calls for a weekly calendar, zone progress list, and a zone-mastery drill-down (`docs/ui-design-spec.md:802-870`). There is no `WeeklyCalendarView`, `ZoneMasteryListView`, or tappable zone row.
- **Profile is also partial.** `ProfileView.swift:28-211` provides avatar/name editing, sharing, and two toggles, but the V1 layout also requires a danger-zone reset action (`docs/ui-design-spec.md:875-907`), which is missing.
- **Zone test is not implemented as specified.** The inventory expects a zone test session plus remediation flow (`docs/ui-design-spec.md:1056-1057`, `954-995`). The shipped view is `ZoneReviewSessionView.swift:16-70`, which is a flashcard-only review of previously incorrect words backed by `ZoneReviewSessionViewModel.swift:28-96`; it is not the 3-step quick-recall/image/SAT test from the spec.
- **Parent report card exists only as a simplified renderer.** `ReportCardGenerator.swift:3-49` renders a generic streak/XP card, but the spec calls for a report with sessions, accuracy, mastery bar, stubborn words, and milestone content (`docs/ui-design-spec.md:917-950`).

## 2. Button actions

### Map / navigation actions
- **Day-node tap behavior is wrong.** The spec's current resolution says current-day tap switches to Practice, past days show a read-only summary, future unlocked days are disabled, and locked days do nothing (`docs/ui-design-spec.md:1196-1204`). In code, every non-locked node in an unlocked zone routes to `.day(dayIndex)` (`AdventureMapView.swift:84-103`), and `.day` pushes a new `PracticeTabView()` in the map stack instead of switching the selected tab (`AdventureMapView.swift:129-138`, `RootTabView.swift:11-47`).
- **Future unlocked days are incorrectly tappable.** `AdventureMapView.swift:170-174` marks any incomplete day in an unlocked zone as `.available`, and `MapDayNode.swift:128-133` only disables `.locked`.
- **Zone test is enterable too early.** The spec says the zone test node is distinct and availability-driven (`docs/ui-design-spec.md:172-178`). The code allows tap whenever the zone is unlocked (`AdventureMapView.swift:111-117`), not when the test is actually available.
- **The spec's START/RESUME/RECOVERY map CTA is missing entirely.** Nothing in `AdventureMapView.swift:27-126` corresponds to `docs/ui-design-spec.md:196-206`.

### Practice / session actions
- **Restart-from-beginning is not implemented as specified.** The spec requires a confirmation dialog and `superseded` scoring semantics (`docs/ui-design-spec.md:451-465`, `786-796`). In code, `PracticeTabView.swift:55-64` directly calls `SessionStateStore.discardSession(...)`, and `SessionStateStore.swift:259-273` deletes the session row. `ReviewLogger.swift:45-60` has a `supersedeSession` helper, but it is never used.
- **Both-complete share flow is missing on the Practice tab.** Spec state E includes a share CTA (`docs/ui-design-spec.md:298-318`, `704-707`). The implementation shows `DayCompleteSummary` and `ReviewsDueRow` only (`PracticeTabView.swift:89-97`); `DayCompleteSummary.swift:10-55` has no share button.
- **Session-complete share is a placeholder and always visible.** The spec allows sharing only for evening completion or day-complete states, and explicitly says no share on morning-only completion (`docs/ui-design-spec.md:679-707`). `SessionFlowView.swift:31-38` always builds the same `SessionCompleteView`, and `SessionCompleteView.swift:59-74` renders a share button with no action.
- **SAT wrong-answer flow does not match the spec.** The spec says wrong SAT answers should show explanation and then advance with NEXT (`docs/ui-design-spec.md:608-613`). In `SATQuestionView.swift:111-127`, wrong answers show a sheet and then reset for another try; only correct answers call `onAnswer(true)` at line 119. Incorrect SAT attempts are never reported upward.
- **Stats button actions cannot match because the rows are missing.** The spec expects zone-row navigation (`docs/ui-design-spec.md:860-870`), but `StatsView.swift:16-133` has no zones section to tap.
- **Profile reminder toggles are UI-only.** The spec says toggling reminders should request permission and schedule notifications (`docs/ui-design-spec.md:899-907`). The view only mutates `@State` booleans (`ProfileView.swift:12-13`, `136-158`), and there is no notification API usage anywhere in `ios/SATVocabApp/Sources`.
- **Profile reset action is missing.** The spec requires a destructive reset flow (`docs/ui-design-spec.md:894-907`), but there is no reset button or reset handler in `ProfileView.swift:28-248`.

## 3. Edge cases: pause, resume, recovery

### What works
- The app does persist session position and can resume at the saved step/item. `SessionFlowViewModel.swift:102-122` restores `currentStepIndex` and `resumeItemIndex`, and each step view accepts `startItemIndex` (`FlashcardStepView.swift:7-10`, `ImageGameStepView.swift:8-12`, `QuickRecallStepView.swift:7-11`, `SATQuestionStepView.swift:7-11`).
- Progress is autosaved during a session via `SessionFlowViewModel.swift:264-277` and `SessionStateStore.swift:234-257`.

### What is missing or off-spec
- **No 30-minute background/foreground policy.** The spec requires in-place resume for short interruptions and a Resume card after longer ones (`docs/ui-design-spec.md:766-775`). There is no `scenePhase` handling in `SATVocabAppApp.swift:7-28`, `SessionFlowView.swift:9-135`, or anywhere else in `Sources`.
- **Paused-evening-next-day recovery is not handled.** The spec requires converting that case into Recovery Evening (`docs/ui-design-spec.md:777-784`). `PracticeStateResolver.swift:17-43` has no date-gap or prior-day logic, and `ResumeCard.swift:20-25` only shows generic paused-session text.
- **Pause sheet is static, not progress-aware.** The spec varies title, encouragement, and primary action based on step progress (`docs/ui-design-spec.md:724-745`). `PauseSheet.swift:16-57` always shows the same copy and buttons.
- **Resume card is much lighter than specified.** The spec calls for a segmented progress bar, step tags, and a text restart link (`docs/ui-design-spec.md:747-764`). `ResumeCard.swift:20-68` only shows a title, "Step X, Item Y", a Resume button, and a Start Over button.
- **Restart semantics are incomplete.** The spec requires confirmation, `superseded` logs, and XP rollback (`docs/ui-design-spec.md:786-796`). Current behavior just deletes `session_state` (`PracticeTabView.swift:55-64`, `SessionStateStore.swift:259-273`).
- **Step transitions do not auto-advance after 3 seconds.** The spec says they should (`docs/ui-design-spec.md:653-677`), but `StepTransitionView.swift:3-61` only offers a manual Continue button.
- **Rush detection is effectively unimplemented.** The spec requires timing checks and warnings (`docs/ui-design-spec.md:709-719`). `SessionFlowView.swift:73-75`, `91-93`, and `109-111` always pass `durationMs: 0` into `recordAnswer`, so timing-based logic cannot work; there is also no toast/banner UI in the active flow.

## 4. Data model

- **The map is still driven by an older 4-task-per-day model, not the spec's day/session model.** `AdventureProgressStore.swift:17-35` stores `[Bool]` task arrays in `UserDefaults`, and `AdventureMapView.swift:87-100` reads those booleans to decide node state. The spec expects map state to come from `DayState` morning/evening completion plus zone/test data (`docs/ui-design-spec.md:1071-1087`).
- **Map locking is bypassed in shipping config.** `AppConfig.swift:10-12` sets `unlockAllAdventureForTesting = true`, and `AdventureProgressStore.swift:47-55` short-circuits zone locking when that flag is true. That makes the spec's locked-zone states impossible to exercise.
- **Practice-state data is incomplete for full-spec resolution.** `DayState` in `Models.swift:86-103` has only `isRecoveryDay`/`isReviewOnlyDay` booleans, and `PracticeStateResolver.swift:12-43` does not accept overdue counts, prior-day context, or a recovery type. The spec explicitly calls for `RecoveryState` and a priority resolver over multiple overlapping conditions (`docs/ui-design-spec.md:417-447`, `1077-1086`).
- **Session composition does not match the required queues.** `SessionFlowViewModel.swift:66-86` defines 12 image-game rounds for morning and evening, but `loadWords()` only fills `newWords` and `morningWords` (`124-143`); `reviewWords` is never populated beyond a stub (`159-164`). As a result, the actual image-game rounds are just one per `newWords` entry (`ImageGameStepView.swift:84-109`), so morning runs 11 rounds and evening 10, not the spec's 12 mixed new/review rounds.
- **Zone progress is not zone-scoped.** `AdventureMapView.swift:149-158` computes `familiarCount` from the global box distribution and uses that for the current zone's progress bar, so the displayed value is not "familiar+ words in this zone" as required by `docs/ui-design-spec.md:183-184`.
- **The report-card model is too thin for the spec.** `ReportCardGenerator.swift:15-49` only consumes `StreakInfo` and `userId`; it does not pull `DailyStats`, mastery distribution, stubborn words, or milestones required by `docs/ui-design-spec.md:923-945`.
- **A raw 0-based study-day leaks into the UI.** `PracticeHeader.swift:13-17` renders `Day \(studyDay)` directly, while map labels use `AdventureSchedule.globalDayNumber(...)` (`AdventureMapView.swift:91`). If `studyDay` is stored 0-based (as implied by `SessionFlowViewModel.swift:125-135` and `AdventureSchedule.swift:45-46`), the Practice tab and completion summary can display "Day 0" instead of "Day 1".
- **Default profile identity does not match the spec.** `LocalIdentity.swift:10-12` defaults the display name to `"SAT Learner"`, while the spec's first-launch profile default is `"Student"` (`docs/ui-design-spec.md:1094-1100`).

## Bottom line

- **Screen inventory:** partially aligned for the core P0 shell, but still missing several spec screens and major parts of Map/Stats/Profile/Zone Test.
- **Button actions:** several important actions are missing or miswired (map day navigation, map CTA, practice-share, session-share, restart semantics, reminder scheduling, reset progress).
- **Pause/resume/recovery:** basic resume works, but the spec's interruption/recovery behavior is only partially implemented.
- **Data model:** the Practice/session pipeline mostly uses the new stores, but the Map still relies on old task-based `UserDefaults`, and the session queues/reporting data do not yet support the full spec.
