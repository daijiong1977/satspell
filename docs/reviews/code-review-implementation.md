# Code Review — SAT Vocab iOS Implementation

## Verified repro

- Baseline before adding repro tests: `SATVocabAppTests` passed (`33 tests, 0 failures`).
- Added two regression tests that now fail for the right reasons:
  - `WordStateStoreTests.swift:207-217` proves Day 1 scored answers incorrectly move new words out of box 0.
  - `WordStateStoreTests.swift:281-299` proves Day 1 promotion incorrectly counts previous `study_day` rows.

## Findings

1. **CRITICAL — Day 1 scoring corrupts box progression**
   - **File:** `ios/SATVocabApp/Sources/SATVocabApp/Data/WordStateStore.swift:176-208`
   - **Why:** `recordScoredAnswer()` promotes `box_level` from `0 -> 1` on the first correct scored answer and always assigns a due date. That contradicts `docs/data-schema.md` Section 5.12, where Day 1 words stay in box 0 until end-of-evening promotion.
   - **Fix:** Special-case box-0 intro words so scored Day 1 answers update accuracy/touches only; do not change `box_level`/`due_at` until `runDay1Promotion()`.

2. **CRITICAL — Day 1 promotion counts historical reviews**
   - **File:** `ios/SATVocabApp/Sources/SATVocabApp/Data/WordStateStore.swift:275-303`
   - **Why:** Both the count query and “last recall” query ignore the `studyDay` argument, so prior days can satisfy today’s promotion threshold.
   - **Fix:** Add `AND study_day = ?` to both queries and bind `studyDay`.

3. **CRITICAL — Resume flow destroys paused session state**
   - **Files:** `ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/PracticeTabView.swift:43-46`, `ios/SATVocabApp/Sources/SATVocabApp/ViewModels/SessionFlowViewModel.swift:92-99`, `ios/SATVocabApp/Sources/SATVocabApp/Data/SessionStateStore.swift:151-154`
   - **Why:** Tapping Resume only passes `sessionType`; `loadWords()` then calls `createSession()`, and `createSession()` uses `INSERT OR REPLACE`, wiping the saved `step_index`, `item_index`, `show_again_ids`, and `requeued_ids`.
   - **Fix:** Load the existing paused `session_state` instead of replacing it, and pass persisted resume state into the view model.

4. **HIGH — Pause/resume is only implemented for flashcards**
   - **File:** `ios/SATVocabApp/Sources/SATVocabApp/Views/Session/SessionFlowView.swift:57-60,72,83,94`
   - **Why:** Flashcards call `vm.pause(...)`, but Image Game / Quick Recall / SAT just dismiss the view. Progress from scored steps is lost even though the UI presents them as pausable.
   - **Fix:** Wire all step views through the same pause persistence path and save current round state before dismissing.

5. **HIGH — First-launch can get stuck in a permanently unseeded DB**
   - **Files:** `ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift:20-29,50-56`, `ios/SATVocabApp/Sources/SATVocabApp/ViewModels/PracticeTabViewModel.swift:22-45`
   - **Why:** `initializeIfNeeded()` treats “database file exists” as “content import succeeded.” If schema creation creates the file and import later fails, future launches skip import, `getDefaultList()` can keep failing, and `PracticeTabViewModel` silently falls back to `.morningAvailable`.
   - **Fix:** Validate seeded content (for example `lists`/`words` existence) before marking initialization complete, and surface initialization failure instead of masking it. Also seed the required Day 0 `day_state` row from `docs/data-schema.md` Section 5.1.

6. **HIGH — Session load writes partial state before confirming content exists**
   - **File:** `ios/SATVocabApp/Sources/SATVocabApp/ViewModels/SessionFlowViewModel.swift:92-100`
   - **Why:** `loadWords()` creates `day_state`, `session_state`, and `daily_stats` before `getDefaultList()` or any queue fetch succeeds. A content/load failure leaves orphaned in-progress rows.
   - **Fix:** Fetch/validate content first, then create session/day/stats rows in one transactional step.

7. **HIGH — Errors are swallowed after UI state is already mutated**
   - **Files:** `ios/SATVocabApp/Sources/SATVocabApp/ViewModels/SessionFlowViewModel.swift:135-175,182-219,225-232`
   - **Why:** XP, correct counts, completion state, and pause state are updated in memory before persistence finishes, and failures are silently ignored. The user can see progress that never actually saved.
   - **Fix:** Persist first or roll back UI state on failure, and surface a recoverable error to the view.

8. **HIGH — Review queue and lifecycle logic do not match the schema spec**
   - **Files:** `ios/SATVocabApp/Sources/SATVocabApp/ViewModels/SessionFlowViewModel.swift:103-121`, `ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift:113-179`, `ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/PracticeStateResolver.swift:3-58`
   - **Why:** The session VM loads sequential list words, discards the `word_state` review queue, and never implements recovery/re-entry/review-only flows. `fetchReviewQueue()` itself uses “latest incorrect review_log row” instead of `word_state.due_at` + box/memory priority from `docs/data-schema.md` Sections 5.3 and 6.
   - **Fix:** Drive review selection from `word_state`, and implement the missing recovery/back-pressure/session-type branches end to end.

9. **HIGH — Legacy DataManager APIs still write incompatible rows and a nonexistent table**
   - **Files:** `ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift:290-448`, call sites in `ios/SATVocabApp/Sources/SATVocabApp/ViewModels/GameSessionViewModel.swift:128-190`, `ios/SATVocabApp/Sources/SATVocabApp/ViewModels/FlashcardSessionViewModel.swift:71-159`, `ios/SATVocabApp/Sources/SATVocabApp/ViewModels/ZoneReviewSessionViewModel.swift:52-79`
   - **Why:** `logReview()` omits `activity_type`, `session_type`, `study_day`, and `superseded`; `startSession()/finishSession()` omit `session_type`, `study_day`, and `xp_earned`; `progress_snapshot` APIs target a table not created by `SchemaV2`.
   - **Fix:** Remove or migrate the legacy APIs and move all call sites onto the V2 stores / schema.

10. **HIGH — Empty queues strand the session UI**
    - **Files:** `ios/SATVocabApp/Sources/SATVocabApp/ViewModels/SessionFlowViewModel.swift:111-113`, `ios/SATVocabApp/Sources/SATVocabApp/Views/Flashcard/FlashcardStepView.swift:88-100`, `ios/SATVocabApp/Sources/SATVocabApp/Views/Game/ImageGameStepView.swift:34-55`, `ios/SATVocabApp/Sources/SATVocabApp/Views/Game/QuickRecallStepView.swift:33-53`
    - **Why:** Recovery/default sessions load no words at all, FlashcardStepView shows a dead-end “All caught up!” state, and ImageGame/QuickRecall step wrappers render a blank body when `roundCards`/`roundData` is empty.
    - **Fix:** Detect empty queues in the VM, either skip the step automatically or show an explicit recoverable empty state with a Continue action.

11. **HIGH — SAT grading can use AI output instead of the canonical answer**
    - **File:** `ios/SATVocabApp/Sources/SATVocabApp/Views/Game/SATQuestionView.swift:23-43`
    - **Why:** `correctLetter` prefers `deepseekAnswer` over `question.answer` and falls back to `"A"` if parsing fails. That can misgrade a student even when the canonical answer exists.
    - **Fix:** Grade only against `question.answer` (or a validated normalized form of it). Treat missing/unparseable answers as an error state, not `"A"`.

12. **MEDIUM — Actor isolation is undermined by a shared nonisolated SQLite handle**
    - **Files:** `ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift:4-8`, `ios/SATVocabApp/Sources/SATVocabApp/Data/StatsStore.swift:14-23`, `ios/SATVocabApp/Sources/SATVocabApp/Data/SessionStateStore.swift:4-9`, `ios/SATVocabApp/Sources/SATVocabApp/Data/ZoneStore.swift:4-9`
    - **Why:** Multiple actors share the same mutable `SQLiteDB` instance through `DataManager.shared.db`. That defeats actor serialization and makes correctness depend on SQLite runtime behavior instead of Swift concurrency guarantees.
    - **Fix:** Centralize DB access in one actor / serial executor or make the DB wrapper actor-isolated.

13. **MEDIUM — Corrupted resume payloads are silently erased**
    - **File:** `ios/SATVocabApp/Sources/SATVocabApp/Data/SessionStateStore.swift:275-278`
    - **Why:** Bad JSON in `show_again_ids` / `requeued_ids` is converted to `[]` via `try?`, losing resume state without any signal.
    - **Fix:** Throw a decoding error or mark the session as invalid so corruption is visible.

## Additional notes

- **SQL injection:** I did **not** find a production SQL injection issue in the reviewed implementation. Runtime SQL is consistently parameterized; the only interpolation-heavy SQL I saw was in test helpers.
- **Retain cycles / leaks:** I did **not** find an obvious strong-reference cycle in the listed SwiftUI code. The main async risk is not leaking; it is stale delayed callbacks in `ImageGameView.swift:122-125` and `QuickRecallView.swift:77-80`, which should be cancellable if the view disappears.
