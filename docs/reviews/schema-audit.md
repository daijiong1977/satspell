# Schema Audit Report

**Date:** 2026-04-11
**Source of truth:** `docs/data-schema.md`
**Audited against:** 6 design documents (learning model, UI spec, flashcard, game views, points system, visual system)

---

## A. WORD STATE (`word_state` table)

| Field | Schema | Docs | Status |
|-------|--------|------|--------|
| `box_level` (0-5) | INTEGER DEFAULT 0 | Learning model: 1-5 boxes + 0 for not introduced | MATCH | 
| `due_at` (DateTime) | TEXT (ISO8601 DateTime) | Learning model Codex review: must be DateTime not Date | MATCH |
| `memory_status` (easy/normal/fragile/stubborn) | TEXT DEFAULT 'normal' | Learning model Section 9 | MATCH |
| `intro_stage` (0-3) | INTEGER DEFAULT 0 | Learning model Codex review: same-day progression | MATCH |
| `lapse_count` | INTEGER DEFAULT 0 | Learning model Section 9 | MATCH |
| `consecutive_wrong` | INTEGER DEFAULT 0 | Learning model Section 9 | MATCH |
| `total_correct` | INTEGER DEFAULT 0 | Learning model Section 9 | MATCH |
| `total_seen` | INTEGER DEFAULT 0 | Learning model Section 9 | MATCH |
| `day_touches` | INTEGER DEFAULT 0 | Learning model Section 9 | MATCH |
| `last_reviewed_at` | TEXT (ISO8601) | Learning model: `last_reviewed: DateTime` | MATCH (name differs slightly: `last_reviewed_at` vs `last_reviewed`) |
| `recent_accuracy` | -- | Learning model Section 9: `recent_accuracy: Float (rolling accuracy over recent scored recalls)` | MISSING FROM SCHEMA |
| `created_at` | TEXT | Schema only | Extra but harmless (housekeeping) |
| `updated_at` | TEXT | Schema only | Extra but harmless (housekeeping) |

### Findings

- **MISSING FROM SCHEMA: `recent_accuracy`** -- The learning model data model (Section 9) explicitly lists `recent_accuracy: Float (rolling accuracy over recent scored recalls)` as a persistent field on `word_state`. The `classifyMemoryStatus()` function reads `word.recent_accuracy` to determine `fragile` (< 0.6) and `easy` (>= 0.85) status. The schema's `word_state` table does not include this column. This is either a bug or an intentional decision to compute it on-the-fly from `review_log`, but the learning model treats it as stored state.

---

## B. SESSION / DAY STATE

### `day_state` table

| Field | Schema | Docs | Status |
|-------|--------|------|--------|
| `study_day` | INTEGER | Learning model: study-day progression | MATCH |
| `zone_index` | INTEGER | Implied by zone system | MATCH |
| `morning_complete` | INTEGER (boolean) | UI spec State C/D/E | MATCH |
| `evening_complete` | INTEGER (boolean) | UI spec State E | MATCH |
| `morning_complete_at` | TEXT (DateTime) | UI spec: evening unlock = morning_complete_at + 4hr | MATCH |
| `evening_complete_at` | TEXT (DateTime) | UI spec: completion tracking | MATCH |
| `new_words_morning` / `new_words_evening` | INTEGER | Implied by session structure | MATCH |
| `morning_accuracy` / `evening_accuracy` | REAL | UI spec: accuracy display on completion | MATCH |
| `morning_xp` / `evening_xp` | INTEGER | Points system: per-session XP | MATCH |
| `is_recovery_day` | INTEGER (boolean) | UI spec State F1/F2/F3 | MATCH |
| `is_review_only_day` | INTEGER (boolean) | UI spec State G (back-pressure) | MATCH |

### Practice Tab State Resolver (10 states)

| State | Data Required | Schema Support | Status |
|-------|--------------|---------------|--------|
| A: Morning available | `!morning_complete` | `day_state.morning_complete` | MATCH |
| B: Paused session | Active session exists | `session_state.is_paused` | MATCH |
| C: Morning done, evening locked | `morning_complete && !evening_unlocked` | `day_state.morning_complete_at` + 4hr check | MATCH |
| D: Morning done, evening available | Timer expired or after 5 PM | `morning_complete_at` + clock | MATCH |
| E: Both complete | Both flags true | `day_state.morning_complete + evening_complete` | MATCH |
| F1: Recovery evening | Missed evening only | Need to detect incomplete previous day | MATCH (via `day_state` of previous study_day: `morning_complete=1, evening_complete=0`) |
| F2: Catch-up day | Missed 1-2 days | Need to compute days since last complete day | MATCH (derivable from `day_state` + `streak_store.last_study_date`) |
| F3: Re-entry day | Missed 3+ days | Same as F2 with larger gap | MATCH |
| G: Back-pressure | Overdue count > 18/30 | Query `word_state WHERE due_at < now()` | MATCH (derivable) |
| H: Late night | Morning started after 8 PM | `session_state.started_at` time check | MATCH |

### Recovery type detection

| Concept | How Detected | Status |
|---------|-------------|--------|
| Recovery Evening (F1) | Previous day: `morning_complete=1, evening_complete=0` | MATCH |
| Catch-Up Day (F2) | Calendar gap of 1-2 days since `last_study_date` | MATCH (derivable from `streak_store.last_study_date` + `daily_stats.calendar_date`) |
| Re-entry Day (F3) | Calendar gap of 3+ days | MATCH (same mechanism) |
| Days missed count | `today - last_study_date` | MATCH |

### Missing/Ambiguous

| Concept | Source Doc | Status |
|---------|-----------|--------|
| `RecoveryState` (recovery_type, is_recovery_needed) | UI spec Section 12 data dependencies | NOT A TABLE -- UI spec lists this as a data dependency but it is derivable from `day_state` + `streak_store`. No separate table needed, but implementation must compute it. |
| `BoxTransitionLog` (promotions, demotions today) | UI spec Section 12 | MISSING FROM SCHEMA -- Session Complete screen shows "18 promoted / 3 need more practice." Schema has `daily_stats.words_promoted` and `daily_stats.words_demoted` as aggregate counts, but no per-word transition log exists. If the Session Complete screen needs to show WHICH words were promoted/demoted (e.g., with names), the aggregate counts alone are insufficient. However, this can be derived from `review_log` + `word_state` changes during the session. |

---

## C. POINTS SYSTEM

### `daily_stats` table

| Field | Schema | Docs | Status |
|-------|--------|------|--------|
| `xp_earned` | INTEGER DEFAULT 0 | Points: total XP today | MATCH |
| `session_bonus` | INTEGER DEFAULT 0 | Points 7.3: +30 XP session completion bonus | MATCH |
| `correct_count` / `total_count` | INTEGER | Points: accuracy calculation | MATCH |
| `new_count` / `review_count` | INTEGER | Points: daily summary | MATCH |
| `study_minutes` | REAL | UI spec: parent report "TIME" field | MATCH |
| `words_promoted` / `words_demoted` | INTEGER | UI spec: session complete "box moves" | MATCH |

### `streak_store` table

| Field | Schema | Docs | Status |
|-------|--------|------|--------|
| `current_streak` | INTEGER | Points 7.4, UI spec header badge | MATCH |
| `best_streak` | INTEGER | Schema only (reasonable to keep) | EXTRA IN SCHEMA (not referenced by any doc) |
| `last_study_date` | TEXT | Points: streak calculation | MATCH |
| `streak_3_claimed` | INTEGER (boolean) | Points 7.4: +20 XP one-time | MATCH |
| `streak_7_claimed` | INTEGER (boolean) | Points 7.4: +50 XP one-time | MATCH |
| `streak_14_claimed` | INTEGER (boolean) | Points 7.4: +100 XP one-time | MATCH |
| `streak_30_claimed` | INTEGER (boolean) | Points 7.4: +200 XP one-time | MATCH |
| `total_xp` | INTEGER | Points: lifetime XP, Visual system header | MATCH |
| `total_study_days` | INTEGER | Schema only | EXTRA IN SCHEMA (not referenced by any doc, but reasonable) |

### XP per answer (+10)

- Stored via `review_log` outcomes. Each correct answer = +10 XP (derivable). Schema `session.xp_earned` and `daily_stats.xp_earned` store aggregates.
- MATCH

### Combo streaks (3/5/10 correct in a row)

- Points system 7.2: "Combos are visual only -- no bonus XP"
- Visual system 3.2: Combo callouts are UI toasts only
- No schema storage needed or provided
- MATCH (correctly omitted -- UI-only state)

### Daily XP target progress (250 XP)

- Visual system 3.4: "5 dots, each = 50 XP, target 250 XP"
- Derivable from `daily_stats.xp_earned + daily_stats.session_bonus`
- MATCH (no separate field needed)

### Word mastery celebrations (which words hit Box 5 today)

- Points 7.5: "When a word reaches Mastered (Box 5): gold ring animation"
- Not stored as a separate event. Detectable at runtime when `word_state.box_level` transitions from 4 to 5 during a scored event.
- No schema storage needed. Implementation must detect the transition in real-time.
- MATCH (correctly not stored -- runtime detection)

---

## D. FLASHCARD

### `session_state` table

| Field | Schema | Docs | Status |
|-------|--------|------|--------|
| `show_again_ids` | TEXT (JSON array) | Flashcard Section 15: word IDs passed from Step 1 to Step 2 | MATCH |
| `step_index` | INTEGER | Flashcard: pause/resume state | MATCH |
| `item_index` | INTEGER | Flashcard: pause/resume state | MATCH |
| `is_paused` | INTEGER (boolean) | UI spec: pause/resume | MATCH |
| `started_at` / `paused_at` / `completed_at` | TEXT | Session lifecycle tracking | MATCH |

### Card state model

- Flashcard Section 12: `CardState { pending, current, completed, requeued }`
- This is a **runtime/in-memory state**, not persisted to DB. The flashcard spec says "persist `currentCardIndex` and the list of `requeued` card IDs" on pause.
- `session_state.item_index` covers `currentCardIndex`.
- Requeued card IDs: NOT EXPLICITLY STORED. The `show_again_ids` field stores Step 1 -> Step 2 pass-through, but there is no field for the list of currently requeued cards within a step.
- **MISSING FROM SCHEMA: requeued card IDs for pause/resume** -- If a student pauses mid-flashcard-step with some cards requeued, those IDs need to be persisted. `show_again_ids` serves a different purpose (Step 1 -> Step 2 transfer). A separate field like `requeued_ids` (JSON array) is needed, OR `show_again_ids` could be repurposed to also hold requeued state during pause. This needs a design decision.

### Restart semantics

| Field | Schema | Docs | Status |
|-------|--------|------|--------|
| `superseded` | INTEGER DEFAULT 0 on `review_log` | UI spec Section 5.5: restart marks old events superseded | MATCH |

---

## E. REPORTS

### Parent Report Card

| Data Needed | Source | Status |
|-------------|--------|--------|
| Sessions completed (checkmarks) | `day_state.morning_complete + evening_complete` | MATCH |
| Streak | `streak_store.current_streak` | MATCH |
| Time | `daily_stats.study_minutes` | MATCH |
| Accuracy | `daily_stats.correct_count / total_count` | MATCH |
| Mastery bar (familiar+ words / 372) | `word_state WHERE box_level >= 3` count | MATCH |
| Stubborn words list | `word_state WHERE memory_status = 'stubborn'` | MATCH |
| Milestone ("100 words!") | Derivable from `word_state` count at box >= 1 | MATCH |

### Stats Tab

| Data Needed | Source | Status |
|-------------|--------|--------|
| Box distribution (stacked bar) | `word_state GROUP BY box_level` | MATCH (query in schema Section 6) |
| Weekly calendar (M-S with session dots) | `daily_stats.calendar_date` + `day_state.morning_complete/evening_complete` | MATCH |
| Words Fighting Back | `word_state WHERE memory_status = 'stubborn'` | MATCH (query in schema Section 6) |
| Zone progress (% familiar+) | `word_state` + `word_list` (zone membership) | MATCH |
| Hero tiles: streak, XP, words | `streak_store` + `daily_stats` + `word_state` count | MATCH |

### Session Complete Screen

| Data Needed | Source | Status |
|-------------|--------|--------|
| XP earned this session | `session.xp_earned` | MATCH |
| Streak | `streak_store.current_streak` | MATCH |
| Words count | `daily_stats.new_count + review_count` | MATCH |
| Promoted/demoted word counts | `daily_stats.words_promoted / words_demoted` | MATCH |
| Which specific words promoted/demoted | No per-word transition log | PARTIALLY MISSING -- counts exist but not names. See note in Section B above. |

---

## F. SYNC (Supabase)

### New device restoration

| Requirement | Schema Support | Status |
|-------------|---------------|--------|
| Full word_state restoration | `vocab_progress_sync.sync_data` JSONB includes word_state | MATCH |
| Day state restoration | `sync_data` includes day_state | MATCH |
| Streak restoration | `sync_data` includes streak | MATCH |
| Zone state restoration | `sync_data` should include zone_state | MATCH (implied by "full snapshot" language) |

### Progress backup

| Requirement | Schema Support | Status |
|-------------|---------------|--------|
| After session completion sync | `vocab_progress_sync` with `synced_at` timestamp | MATCH |
| Device identification | `vocab_progress_sync.device_id` | MATCH |
| Conflict resolution | Latest `synced_at` wins | MATCH |
| User profile sync | `user_profiles` with `current_study_day`, `total_xp`, `current_streak` | MATCH |

### Sync data completeness

- The schema says `sync_data JSONB` is a "full snapshot of word_state + day_state + streak."
- **AMBIGUITY:** Does sync_data also include `daily_stats`, `session_state`, `zone_state`, and `review_log`? The schema says "word_state + day_state + streak" but a complete restore would also need `zone_state` (zone unlock progress) and possibly `daily_stats` (for Stats tab history).
- **INCONSISTENCY: sync_data scope not fully defined** -- `zone_state` is critical for restoration but not explicitly listed in the sync_data contents.

---

## G. REVIEW LOG

| Field | Schema | Learning Model | Status |
|-------|--------|---------------|--------|
| `outcome` | TEXT ('correct'/'incorrect') | Learning model: Enum (correct, incorrect) | MATCH |
| `duration_ms` | INTEGER | Learning model: `response_ms: Integer` | MATCH (name differs: `duration_ms` vs `response_ms`) |
| `activity_type` | TEXT | Learning model: Enum (flashcard, image_game, sat_question, quick_recall) | MATCH |
| `session_type` | TEXT | Learning model: Enum (morning, evening) | INCONSISTENCY -- Schema has broader enum: 'morning', 'evening', 'recovery_evening', 'catch_up', 're_entry', 'zone_test', 'bonus'. Learning model only mentions 'morning', 'evening'. Schema is more complete. |
| `study_day` | INTEGER | Learning model: `day_index: Integer` | MATCH (name differs: `study_day` vs `day_index`) |
| `reviewed_at` | TEXT (ISO8601) | Learning model: `reviewed_at: DateTime` | MATCH |
| `superseded` | INTEGER DEFAULT 0 | UI spec Section 5.5: restart semantics | MATCH |
| `list_id` | INTEGER | Schema only | EXTRA IN SCHEMA (legacy field, not referenced by design docs) |
| `device_id` | TEXT | Schema only | EXTRA IN SCHEMA (not referenced by design docs, but useful for sync) |

---

## H. SESSION TABLE

| Field | Schema | Docs | Status |
|-------|--------|------|--------|
| `session_type` | TEXT | UI spec: morning/evening/recovery/etc. | MATCH |
| `study_day` | INTEGER | Learning model | MATCH |
| `xp_earned` | INTEGER | Points system: session XP total | MATCH |
| `started_at` / `ended_at` | TEXT | Session lifecycle | MATCH |
| `items_total` / `items_correct` | INTEGER | Session stats | MATCH |
| `list_id` | INTEGER | Schema only | EXTRA IN SCHEMA (legacy, not referenced by design docs) |

---

## I. ZONE STATE

| Field | Schema | Docs | Status |
|-------|--------|------|--------|
| `zone_index` (0-4) | INTEGER | Learning model: 5 zones | MATCH |
| `unlocked` | INTEGER (boolean) | UI spec: zone locking | MATCH |
| `test_passed` | INTEGER (boolean) | UI spec Section 9: zone test | MATCH |
| `test_attempts` | INTEGER | UI spec Section 9.2: retry tracking, 3+ fail triggers remediation | MATCH |
| `test_best_score` | REAL | Schema only (reasonable for display) | EXTRA IN SCHEMA (not explicitly referenced but harmless) |
| `unlocked_at` | TEXT | Schema only | EXTRA IN SCHEMA (not referenced but harmless) |

---

## Summary

### MISSING FROM SCHEMA (must add before implementation)

| # | Field | Table | Referenced In | Severity |
|---|-------|-------|--------------|----------|
| 1 | `recent_accuracy` (REAL) | `word_state` | Learning model Section 9, used by `classifyMemoryStatus()` | **HIGH** -- Required for memory status classification. Without it, the `fragile` (< 0.6) and `easy` (>= 0.85) thresholds cannot be evaluated without recomputing from review_log each time. |
| 2 | `requeued_ids` (TEXT, JSON array) | `session_state` | Flashcard spec Section 12: "persist requeued card IDs on pause" | **MEDIUM** -- Needed for correct pause/resume of flashcard step with requeued cards. Could potentially overload `show_again_ids` but semantics differ. |

### INCONSISTENCIES (clarify before implementation)

| # | Issue | Details |
|---|-------|---------|
| 1 | `sync_data` scope | Schema says "word_state + day_state + streak" but `zone_state` is needed for device restoration and is not listed. `daily_stats` may also be needed for Stats tab history on new device. |
| 2 | `session_type` enum breadth | `review_log.session_type` in schema includes 'recovery_evening', 'catch_up', 're_entry', 'zone_test', 'bonus'. Learning model only defines 'morning' and 'evening'. Schema is correct/more complete but this should be documented as the canonical enum. |
| 3 | Field name mismatches | `last_reviewed_at` (schema) vs `last_reviewed` (learning model). `duration_ms` (schema) vs `response_ms` (learning model). `study_day` (schema) vs `day_index` (learning model). Schema names should be treated as canonical. |

### EXTRA IN SCHEMA (not referenced by any design doc)

| # | Field | Table | Risk |
|---|-------|-------|------|
| 1 | `best_streak` | `streak_store` | None -- reasonable forward-looking field |
| 2 | `total_study_days` | `streak_store` | None -- useful for analytics |
| 3 | `list_id` | `review_log`, `session` | Low -- legacy field, consider removing or documenting purpose |
| 4 | `device_id` | `review_log` | None -- useful for multi-device debugging |
| 5 | `test_best_score` | `zone_state` | None -- reasonable for future display |
| 6 | `unlocked_at` | `zone_state` | None -- reasonable for analytics |

### DESIGN DECISIONS NEEDED

| # | Question | Context |
|---|----------|---------|
| 1 | Should `recent_accuracy` be stored or computed? | Learning model treats it as stored. Computing from `review_log` on every status check could be expensive. Recommendation: store it and update on each review, matching the learning model. |
| 2 | How to handle requeued card persistence on pause? | Add `requeued_ids TEXT` to `session_state`, or expand the definition of `show_again_ids` to cover both use cases. Recommend a separate field for clarity. |
| 3 | What exactly goes in `sync_data` JSONB? | Enumerate: word_state, day_state, streak_store, zone_state, daily_stats. Document this as a checklist. |
| 4 | Per-word promotion/demotion list for Session Complete screen? | Schema stores aggregate counts in `daily_stats`. If the UI needs to name which words were promoted/demoted, either (a) derive from review_log at session end, or (b) add a `session_word_transitions` table/field. Derivation is likely sufficient. |

---

## Verdict

The schema is in strong shape overall. Out of ~50+ data points checked across 7 design documents, only **2 fields are genuinely missing** (`recent_accuracy` and `requeued_ids`), and **1 sync scope ambiguity** needs clarification. The schema correctly omits UI-only state (combo streaks, daily goal dots) and provides sufficient data for all report, stats, and sync features. The "extra" fields are all reasonable forward-looking additions.

**Recommended fixes before implementation:**
1. Add `recent_accuracy REAL DEFAULT 0` to `word_state`
2. Add `requeued_ids TEXT` to `session_state`
3. Update `vocab_progress_sync` documentation to explicitly list all tables included in `sync_data`
4. Document the canonical `session_type` enum values in the schema
