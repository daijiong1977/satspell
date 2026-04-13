# WordScholar (satspell) — Project Retrospective

## Project Overview

**App Name:** WordScholar (formerly SAT Vocab)  
**Platform:** iOS 17.0+, iPhone-only, portrait  
**Purpose:** Gamified SAT vocabulary learning for high school students (15-18)  
**Timeline:** April 12-13, 2026 (2-day intensive build)  
**Status:** First draft complete, deployed to physical iPhone 16 Max  

## What Was Built

### By the Numbers
- **49 commits** from data deduplication to milestone
- **73 source files**, 9,430 lines of Swift
- **11 test files**, 1,930 lines, 88 tests (0 failures)
- **9 design documents** + 3 implementation plans + 1 testing plan
- **372 vocabulary words** with images, SAT questions, collocations, contexts
- **30+ bugs fixed** during testing
- **1 cross-check review** by GPT via Copilot CLI

### Architecture
```
Data Layer (SQLite)
├── SchemaV2 (17 tables, 13 indexes)
├── ContentImporter (JSON → SQLite on first launch)
├── DataManager (singleton, actor-isolated)
├── WordStateStore (Leitner 5-box progression)
├── SessionStateStore (pause/resume/auto-save)
├── StatsStore (daily stats, streaks, milestones)
├── ReviewLogger (scored event logging)
├── ZoneStore (adventure zone unlocks)
└── NotificationScheduler (morning/evening reminders)

Session Engine
├── SessionFlowViewModel (multi-step orchestrator)
├── SessionFlowView (step navigation, loading, error, complete)
├── FlashcardStepView (exposure, Show Again/Got It)
├── ImageGameStepView (scored, 2x2 grid, cloze)
├── QuickRecallStepView (scored, definition matching)
└── SATQuestionStepView (scored, passage + 4 options, retry-on-wrong)

App Shell
├── RootTabView (4 tabs: Map, Practice, Stats, Profile)
├── PracticeTabView (5-state machine: A-E)
├── PracticeStateResolver (morning→evening→complete)
├── AdventureMapView (zone nav, day nodes, zone test gating)
├── StatsView (hero tiles, box distribution, streaks)
├── ProfileView (avatar, name, parent email, notifications, reset)
└── ReportCardGenerator (share image renderer)

Backend
├── Supabase edge function: send-email-v2 (Gmail SMTP)
└── ParentReportSender (HTML email from iOS app)
```

### Features Implemented
1. **Flashcard system** — Image-hero front, detail back, 3D flip animation, Show Again re-queue
2. **Image game** — 2x2 grid, cloze sentence, scaledToFill image at 55% height
3. **Quick recall** — Definition matching, purple theme, scored
4. **SAT questions** — Passage + 4 options, retry-until-correct, auto-fit no-scroll
5. **Spaced repetition** — Leitner 5-box system, Day 1 acceleration, memory status classification
6. **Adventure map** — Zone navigation, day nodes, zone test gating, session dots
7. **Practice state machine** — 5 states with pause/resume/restart
8. **Session persistence** — Auto-save on every item advance, survives app kill
9. **Profile** — Editable name, emoji avatar, parent email, notification toggles, reset progress
10. **Parent reports** — HTML email via Supabase edge function + Gmail SMTP
11. **Pronunciation** — AVSpeechSynthesizer on sound button
12. **Step transitions** — 3-second auto-advance with manual override
13. **Session complete** — XP summary, share progress, spring animation
14. **Dynamic Island** — Live Activity widget (disabled for device due to signing)
15. **Cross-check pipeline** — `scripts/copilot-review.sh` for GPT reviews

---

## Project Phases

### Phase 1: Design (hours 0-3)
- Brainstormed UI direction (chose Duolingo-style gamified)
- Created 9 design documents covering all aspects
- Cross-checked designs with GPT-5.4 via Copilot CLI
- Found and resolved 15+ design gaps before writing code

### Phase 2: Implementation Planning (hours 3-4)
- Created 3 implementation plans (data layer, session engine, app shell)
- Created testing plan with 45 tests across 8 files
- Plans cross-checked by GPT-5.4

### Phase 3: Data Layer (hours 4-6)
- Built SQLite schema (17 tables), content importer, all actor stores
- 39 unit tests passing
- **Critical bug found:** SQLite multi-threaded crash (NSLock + FULLMUTEX fix)

### Phase 4: Session Engine (hours 6-10)
- Built multi-step session flow with all 4 activity types
- Flashcard → Image Game → Quick Recall → SAT Questions
- Pause/resume, Show Again, scoring pipeline

### Phase 5: App Shell (hours 10-14)
- 4-tab layout, practice state machine, adventure map
- Stats view, profile view, share functionality
- Merge conflicts from parallel worktrees resolved

### Phase 6: Testing & Bug Fixing (hours 14-20)
- Simulator testing found 20+ bugs
- Physical device testing found additional threading crash
- Multiple rounds of font size increases per user feedback
- Added auto-save, retry-on-wrong, pronunciation, notifications

### Phase 7: Cross-Check & Polish (hours 20-24)
- GPT cross-check found 18 issues (12 fixed)
- Added 49 more tests (88 total)
- Evening unlock bug found by new tests
- Parent email report via Supabase + Gmail
- App renamed to WordScholar

---

## Bugs Found & Fixed (Categorized)

### Threading / Data (5 bugs)
| Bug | Root Cause | Fix |
|-----|-----------|-----|
| SQLite multi-threaded crash | NSLock not recursive, multiple actors | NSRecursiveLock + FULLMUTEX + WAL |
| Box 0 promoted mid-session | recordScoredAnswer() promoted all boxes | Box 0 only via runDay1Promotion() |
| Day 1 promotion counted all days | Missing WHERE study_day = ? | Added study_day filter |
| Session data not persisting | try? swallowing errors silently | Proper error handling |
| Resume destroyed paused state | INSERT OR REPLACE wiped saved position | Check for existing paused session first |

### Session Flow (8 bugs)
| Bug | Root Cause | Fix |
|-----|-----------|-----|
| App kill loses position | Only saved on explicit Pause | Auto-save on every item advance |
| Evening loads wrong words | morningWords array empty | Explicit load in loadWords() |
| Pause & Exit doesn't exit | Dismiss not called properly | @Environment(\.dismiss) + delay |
| Blank sheet on cold launch | Dangling navigateToSession state | Clear on onAppear |
| No restart option | Only Resume available | Added Start Over + confirmation |
| Morning disappears during evening | State machine hid completed session | Always show with Review button |
| Evening unlocks immediately | Fallback hour in the past after 5PM | Use tomorrow when today passed |
| SAT wrong not reported | onAnswer(false) never called | Added onWrongAttempt callback |

### UI / Layout (12 bugs)
| Bug | Root Cause | Fix |
|-----|-----------|-----|
| Fonts too small (×4 rounds) | Default sizes too small for teens | Systematic increase to 20pt+ |
| Image clipped at top | scaledToFill in fixed frame | GeometryReader with 55% height |
| SAT questions truncated | ScrollView + fixed maxHeight | 60% area + minimumScaleFactor |
| Double header | Both step view and card had counters | Removed duplicate |
| Markdown ** in examples | Raw markdown in data | Strip with replaceOccurrences |
| Map "Day details coming soon" | Placeholder text | Navigate to Practice tab |
| Word count always 0 | Used stats.newCount (always 0) | countWordsLearned() query |
| Completion animation missing | No animation on appear | scale + opacity spring |
| "Day 0" displayed | 0-based index shown directly | Display studyDay + 1 |
| Sound button non-functional | Empty action closure | AVSpeechSynthesizer |
| Map nodes all tappable | No state check on tap | Only current + completed |
| Empty queue stranded UI | "All caught up!" dead end | onAppear guard → onComplete |

### Device-Specific (3 bugs)
| Bug | Root Cause | Fix |
|-----|-----------|-----|
| NSLock deadlock on iPhone | NSLock not recursive | NSRecursiveLock |
| Widget deployment error | Free signing can't deploy extensions | Disabled widget target |
| SAT questions not loading | verifiedOnly=true, 0 verified | Changed to false |

---

## Lessons Learned

### 1. Physical Device Testing is Non-Negotiable
**What happened:** The app ran perfectly on the simulator but crashed immediately on a physical iPhone due to `sqlite3MutexMisuseAssert`. The simulator's threading model is more forgiving.

**Lesson:** Always test on a physical device before calling anything "done." Threading bugs, performance issues, and signing problems only surface on real hardware.

**Future action:** Add "device test" as a mandatory step in every implementation plan. Include a device-specific test checklist.

### 2. Font Sizes Need Real-World Validation
**What happened:** Four rounds of font size increases were needed. What looks readable on a 27" monitor running the simulator is tiny on a 6.7" phone held at arm's length.

**Lesson:** Start with larger fonts (20pt minimum for content) and test by holding the actual phone. Teens have good vision but low patience — if text feels small, they'll disengage.

**Future action:** Establish a minimum font size standard early in design. Test fonts on the actual device screen, not the simulator.

### 3. Unit Tests Miss the Bugs Users Find
**What happened:** 39 unit tests all passed, but 10-20 minutes of manual testing found 15+ bugs. The bugs were in state transitions (morning disappearing), persistence (kill app loses position), layout (images clipped), and flow logic (SAT answers not counted).

**Lesson:** Unit tests verify algorithms. Integration tests verify flows. Neither verifies that a human would have a good experience. You need all three.

**Future action:** Write state machine integration tests that simulate full session lifecycles. Add XCUITest smoke tests. Manual testing remains essential but should come after automated smoke tests.

### 4. Auto-Save is Better Than Explicit Pause
**What happened:** The app only saved session state when the user tapped "Pause & Exit." If they swiped away or the app was killed, they lost progress.

**Lesson:** Users don't follow happy paths. They get interrupted by notifications, phone calls, running out of battery. Save state continuously.

**Future action:** Save-on-every-action as default pattern. Use `scenePhase` to handle background transitions. Never rely on the user to explicitly save.

### 5. Cross-Check Reviews Find Real Issues
**What happened:** The GPT cross-check review found 18 issues, including critical ones like "Day 0" display and SAT wrong answers not being recorded. These were invisible during manual testing because the tester (user) was focused on the happy path.

**Lesson:** A different perspective (different AI model, different reviewer) catches different bugs. Spec-vs-implementation comparison is especially valuable.

**Future action:** Run cross-check at every milestone, not just at the end. The `scripts/copilot-review.sh` pipeline makes this a 5-minute step.

### 6. Design Documents Pay Off During Bug Fixing
**What happened:** When the cross-check review said "Map CTA missing per spec line 196," we could immediately find the gap because the spec was thorough and line-numbered.

**Lesson:** Detailed design documents aren't just for planning — they're the test oracle for implementation reviews.

**Future action:** Keep design docs updated as features change. They're living documents, not write-once artifacts.

### 7. Parallel Subagents Accelerate Development
**What happened:** Using subagent-driven development, we could dispatch implementation, testing, and review tasks in parallel. The P1/P2 bug fix agent worked for 12 minutes while we continued with other tasks.

**Lesson:** Decompose work into independent tasks and run them in parallel. The key is clear task boundaries and no shared file conflicts.

**Future action:** Continue using subagent-driven development. Structure tasks to minimize file overlap. Always verify combined build after parallel work merges.

### 8. Start Simple, Then Layer Complexity
**What happened:** The initial design had 10 practice states, recovery sessions, rush detection, and zone mastery. We shipped with 5 states (A-E) and deferred the rest. The app is fully functional.

**Lesson:** P0 features make a working app. P1/P2 features make it polished. Ship P0 first, then iterate.

**Future action:** Continue the P0/P1/P2 prioritization. Resist the urge to build everything before testing anything.

### 9. SQLite Concurrency Needs Upfront Design
**What happened:** The actor-based data stores each called `db.prepare()` with `NSLock`, but multiple actors on different threads caused lock contention and eventually a deadlock on physical devices.

**Lesson:** Decide the concurrency model early. SQLite serialized mode (FULLMUTEX) + WAL + recursive lock + busy timeout is the proven pattern for multi-actor iOS apps.

**Future action:** Document the SQLite concurrency pattern as a reusable template. Use `NSRecursiveLock` from the start. Always test with concurrent access.

### 10. The Gap Between Spec and Implementation Grows Silently
**What happened:** The cross-check found the Map still using the old `AdventureProgressStore` (UserDefaults) while the rest of the app used the new `DayState` model. Nobody noticed because both "worked."

**Lesson:** Technical debt accumulates when you implement features incrementally. Spec-vs-implementation audits catch these divergences.

**Future action:** Schedule periodic spec alignment reviews. Update or remove outdated code paths when new ones replace them.

---

## What's Still TODO

### High Priority (P1)
- [ ] Stats: weekly calendar, zone progress list, zone mastery drill-down
- [ ] Map: CTA button, morning-done split state for nodes
- [ ] Map: migrate from AdventureProgressStore to DayState
- [ ] Profile: wire notification toggles to actual UNUserNotification scheduling
- [ ] Zone test: 3-step test (quick recall + image + SAT) instead of flashcard-only
- [ ] Recovery states (F1/F2/F3): paused-next-day, review-only, bonus practice
- [ ] Report card: sessions, accuracy, mastery bar, stubborn words

### Medium Priority (P2)
- [ ] Rush detection (timing-based warnings)
- [ ] 30-minute background policy (in-place resume vs Resume card)
- [ ] Pause sheet: progress-aware content
- [ ] Resume card: segmented progress bar, step tags
- [ ] Restart: XP rollback with supersede
- [ ] Step transition: celebration effects
- [ ] Dynamic Island: re-enable with proper Apple Developer signing
- [ ] durationMs tracking for rush detection

### Low Priority (P3)
- [ ] App Store submission preparation
- [ ] Image regeneration for weak images
- [ ] Content delivery V2 (downloadable packs)
- [ ] Supabase sync for multi-device progress
- [ ] Weekly auto-send parent reports
- [ ] Brand expansion beyond SAT (WordScholar platform)

---

## Technical Debt

1. **Map uses AdventureProgressStore (UserDefaults)** while session flow uses DayState (SQLite) — should consolidate
2. **`unlockAllAdventureForTesting`** now false but the flag should be removed in production
3. **Review queue uses old logic** — `fetchReviewQueue` in DataManager has two implementations
4. **Legacy DataManager APIs** — old session/review_log methods coexist with new actor stores
5. **Widget extension** exists but disabled — either commit to it (paid developer account) or remove
6. **`durationMs: 0` everywhere** — timing is never captured, making rush detection impossible

---

## Key Files Reference

| File | Purpose |
|------|---------|
| `project.yml` | XcodeGen config, targets, signing |
| `Resources/Info.plist` | App config, display name "WordScholar" |
| `Data/DataManager.swift` | SQLite init, content import, queries |
| `Data/SQLite.swift` | NSRecursiveLock wrapper, WAL mode |
| `Data/SessionStateStore.swift` | Pause/resume/auto-save/discard |
| `Data/WordStateStore.swift` | Leitner box progression |
| `Data/ParentReportSender.swift` | Supabase edge function email |
| `Data/NotificationScheduler.swift` | Morning/evening UNNotification |
| `ViewModels/SessionFlowViewModel.swift` | Session orchestrator |
| `Views/Practice/PracticeStateResolver.swift` | 5-state machine |
| `Views/Practice/PracticeTabView.swift` | State-driven UI |
| `Views/Session/SessionFlowView.swift` | Step navigation |
| `scripts/copilot-review.sh` | Cross-check review pipeline |

---

*Document created: April 13, 2026*  
*App: WordScholar v1.0 (first draft)*  
*Team: Jiong Dai + Claude Opus 4.6*
