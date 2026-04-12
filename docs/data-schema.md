# Data Schema Design

This document defines the complete data layer for SAT Vocab V1: local SQLite for offline learning + Supabase for authentication and cloud sync.

---

## 1. Architecture Overview

```
┌─────────────────────────────────────────────────┐
│                 iPhone App                       │
│                                                  │
│  ┌──────────────────┐  ┌──────────────────────┐ │
│  │  SQLite (local)   │  │  Supabase Client     │ │
│  │                    │  │                      │ │
│  │  Word content      │  │  Auth (sign up/in)   │ │
│  │  SAT questions     │  │  Profile sync        │ │
│  │  Learning state    │  │  Progress backup     │ │
│  │  Review logs       │  │                      │ │
│  │  Session state     │  │  (online when avail) │ │
│  │                    │  │                      │ │
│  │  (always works)    │  │                      │ │
│  └──────────────────┘  └──────────────────────┘ │
└─────────────────────────────────────────────────┘
```

### Principles

1. **Offline-first:** Student can download app and study immediately. No internet required.
2. **No sign-up required to start:** Anonymous local ID created on first launch. Full functionality.
3. **Optional sign-up:** Creates Supabase auth account. Enables cloud backup and multi-device.
4. **Sync when online:** Local changes pushed to Supabase in background. Pull on new device sign-in.
5. **SQLite is source of truth** during active use. Supabase is backup.

---

## 2. SQLite Schema — Existing Tables (Keep)

These tables are already in the bundled `data.db` and should be kept as-is.

### 2.1 Word Content (read-only, bundled)

```sql
-- Core vocabulary (372 words, bundled)
CREATE TABLE words (
    id          INTEGER PRIMARY KEY,
    lemma       TEXT NOT NULL,
    pos         TEXT,                    -- part of speech (adj., noun, etc.)
    definition  TEXT,
    example     TEXT,                    -- example sentence
    image_filename TEXT                  -- e.g., "ephemeral.jpg"
);

-- Word lists
CREATE TABLE lists (
    id          INTEGER PRIMARY KEY,
    name        TEXT NOT NULL,           -- e.g., "sat_core_1"
    description TEXT,
    version     INTEGER DEFAULT 1
);

-- Word-to-list mapping with ordering
CREATE TABLE word_list (
    id          INTEGER PRIMARY KEY,
    word_id     INTEGER NOT NULL REFERENCES words(id),
    list_id     INTEGER NOT NULL REFERENCES lists(id),
    rank        INTEGER                  -- display/sequence order
);

-- SAT context sentences per word
CREATE TABLE sat_contexts (
    id          INTEGER PRIMARY KEY,
    word_id     INTEGER NOT NULL REFERENCES words(id),
    context     TEXT NOT NULL
);

-- Word collocations
CREATE TABLE collocations (
    id          INTEGER PRIMARY KEY,
    word_id     INTEGER NOT NULL REFERENCES words(id),
    phrase      TEXT NOT NULL
);

-- SAT question bank (~8000 questions)
CREATE TABLE sat_question_bank (
    id              TEXT PRIMARY KEY,
    word_id         INTEGER,
    target_word     TEXT,
    section         TEXT,
    module          INTEGER,
    q_type          TEXT,
    passage         TEXT,
    question        TEXT,
    option_a        TEXT,
    option_b        TEXT,
    option_c        TEXT,
    option_d        TEXT,
    answer          TEXT,               -- correct answer letter
    source_pdf      TEXT,
    page            INTEGER,
    feedback_generated INTEGER DEFAULT 0,
    answer_verified    INTEGER DEFAULT 0
);

-- Word-to-question mapping
CREATE TABLE word_questions (
    id          INTEGER PRIMARY KEY,
    word_id     INTEGER NOT NULL REFERENCES words(id),
    question_id TEXT NOT NULL REFERENCES sat_question_bank(id)
);

-- AI-generated feedback for SAT questions
CREATE TABLE deepseek_sat_feedback (
    id              INTEGER PRIMARY KEY,
    question_id     TEXT REFERENCES sat_question_bank(id),
    ai_source       TEXT,
    answer          TEXT,               -- AI's answer
    background      TEXT,               -- background explanation
    reason_for_answer TEXT,             -- reasoning
    created_at      TEXT
);
```

### 2.2 Existing User Tables (Modify)

```sql
-- Local user identity (keep, add supabase_uid)
CREATE TABLE users (
    id          TEXT PRIMARY KEY,        -- local UUID
    email       TEXT,
    supabase_uid TEXT,                   -- NEW: linked Supabase auth.users.id (nullable)
    display_name TEXT,                   -- NEW: student name
    created_at  TEXT DEFAULT (datetime('now'))
);
```

### 2.3 Existing Log Tables (Modify)

```sql
-- Review log (keep, add columns)
CREATE TABLE review_log (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id     TEXT NOT NULL REFERENCES users(id),
    word_id     INTEGER NOT NULL REFERENCES words(id),
    list_id     INTEGER,
    outcome     TEXT NOT NULL,           -- 'correct' or 'incorrect'
    duration_ms INTEGER,                 -- response time
    reviewed_at TEXT NOT NULL,           -- ISO8601
    device_id   TEXT,
    activity_type TEXT,                  -- NEW: 'flashcard', 'image_game', 'quick_recall', 'sat_question'
    session_type TEXT,                   -- NEW: 'morning', 'evening', 'recovery', 'bonus', 'zone_test'
    study_day   INTEGER,                -- NEW: study day index (0-19)
    superseded  INTEGER DEFAULT 0       -- NEW: 1 if this entry was replaced by a restart
);

CREATE INDEX idx_review_log_word ON review_log(word_id, user_id, reviewed_at DESC);
CREATE INDEX idx_review_log_day ON review_log(user_id, study_day);
CREATE INDEX idx_review_log_scored ON review_log(user_id, word_id, activity_type, superseded, reviewed_at DESC);

-- Content table indexes (for word lookup performance)
CREATE INDEX idx_word_list_rank ON word_list(list_id, rank);
CREATE INDEX idx_sat_contexts_word ON sat_contexts(word_id);
CREATE INDEX idx_collocations_word ON collocations(word_id);
CREATE INDEX idx_word_questions_word ON word_questions(word_id);
CREATE UNIQUE INDEX idx_word_questions_unique ON word_questions(word_id, question_id);

-- Session table (keep, add columns)
CREATE TABLE session (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id     TEXT NOT NULL,
    list_id     INTEGER,
    started_at  TEXT,
    ended_at    TEXT,
    items_total INTEGER,
    items_correct INTEGER DEFAULT 0,
    session_type TEXT,                   -- NEW: 'morning', 'evening', 'recovery_evening', 'catch_up', 're_entry', 'zone_test', 'bonus'
    study_day   INTEGER,                -- NEW: study day index
    xp_earned   INTEGER DEFAULT 0       -- NEW: total XP from this session
);
```

---

## 3. SQLite Schema — New Tables

These tables implement the learning model from `learning-model-design.md`.

### 3.1 Word State (Leitner Box Progression)

```sql
-- Per-word learning state for each user
CREATE TABLE word_state (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id         TEXT NOT NULL REFERENCES users(id),
    word_id         INTEGER NOT NULL REFERENCES words(id),
    box_level       INTEGER NOT NULL DEFAULT 0,  -- 0=not introduced, 1-5=Leitner boxes
    due_at          TEXT,                         -- ISO8601 DateTime (NULL = not yet due)
    intro_stage     INTEGER DEFAULT 0,            -- 0=not introduced, 1=morning seen, 2=evening recall done, 3=promotion decided
    memory_status   TEXT DEFAULT 'normal',         -- 'easy', 'normal', 'fragile', 'stubborn'
    lapse_count     INTEGER DEFAULT 0,             -- times reset to box 1 from higher
    consecutive_wrong INTEGER DEFAULT 0,           -- current wrong streak
    total_correct   INTEGER DEFAULT 0,             -- lifetime correct count
    total_seen      INTEGER DEFAULT 0,             -- lifetime seen count
    day_touches     INTEGER DEFAULT 0,             -- scored touches today (reset daily)
    recent_accuracy REAL DEFAULT 0,                -- rolling accuracy over recent scored recalls (used by classifyMemoryStatus)
    last_reviewed_at TEXT,                          -- ISO8601
    created_at      TEXT DEFAULT (datetime('now')),
    updated_at      TEXT DEFAULT (datetime('now')),
    UNIQUE(user_id, word_id)
);

CREATE INDEX idx_word_state_due ON word_state(user_id, due_at);
CREATE INDEX idx_word_state_box ON word_state(user_id, box_level);
CREATE INDEX idx_word_state_status ON word_state(user_id, memory_status);
```

### 3.2 Day State (Study Day Tracking)

```sql
-- Per study-day state
CREATE TABLE day_state (
    id                  INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id             TEXT NOT NULL REFERENCES users(id),
    study_day           INTEGER NOT NULL,             -- 0-indexed study day (not calendar day)
    zone_index          INTEGER NOT NULL,             -- 0-4
    morning_complete    INTEGER DEFAULT 0,             -- boolean
    evening_complete    INTEGER DEFAULT 0,             -- boolean
    morning_complete_at TEXT,                           -- ISO8601 DateTime
    evening_complete_at TEXT,                           -- ISO8601 DateTime
    new_words_morning   INTEGER DEFAULT 0,             -- actual new words introduced
    new_words_evening   INTEGER DEFAULT 0,
    morning_accuracy    REAL DEFAULT 0,                -- 0.0-1.0
    evening_accuracy    REAL DEFAULT 0,
    morning_xp          INTEGER DEFAULT 0,
    evening_xp          INTEGER DEFAULT 0,
    is_recovery_day     INTEGER DEFAULT 0,             -- boolean
    is_review_only_day  INTEGER DEFAULT 0,             -- boolean (back-pressure)
    created_at          TEXT DEFAULT (datetime('now')),
    UNIQUE(user_id, study_day)
);

CREATE INDEX idx_day_state_user ON day_state(user_id, study_day DESC);
```

### 3.3 Session State (Pause/Resume)

```sql
-- Active session state for pause/resume
CREATE TABLE session_state (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id         TEXT NOT NULL REFERENCES users(id),
    session_type    TEXT NOT NULL,          -- 'morning', 'evening', 'recovery_evening', etc.
    study_day       INTEGER NOT NULL,
    step_index      INTEGER DEFAULT 0,     -- current step (0-based)
    item_index      INTEGER DEFAULT 0,     -- current item within step
    is_paused       INTEGER DEFAULT 0,     -- boolean
    show_again_ids  TEXT,                   -- JSON array of word IDs from Show Again (Step 1 → Step 2)
    requeued_ids    TEXT,                   -- JSON array of word IDs currently requeued within a step (for pause/resume)
    started_at      TEXT,                   -- ISO8601
    paused_at       TEXT,                   -- ISO8601
    completed_at    TEXT,                   -- ISO8601 (NULL if not done)
    UNIQUE(user_id, study_day, session_type)
);
```

### 3.4 Daily Stats

```sql
-- Aggregated daily statistics
CREATE TABLE daily_stats (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id         TEXT NOT NULL REFERENCES users(id),
    study_day       INTEGER NOT NULL,
    calendar_date   TEXT NOT NULL,          -- YYYY-MM-DD
    new_count       INTEGER DEFAULT 0,     -- new words introduced today
    review_count    INTEGER DEFAULT 0,     -- review words practiced
    correct_count   INTEGER DEFAULT 0,     -- total correct answers
    total_count     INTEGER DEFAULT 0,     -- total scored attempts
    xp_earned       INTEGER DEFAULT 0,     -- total XP today
    session_bonus   INTEGER DEFAULT 0,     -- session completion bonuses
    study_minutes   REAL DEFAULT 0,        -- total active study time
    words_promoted  INTEGER DEFAULT 0,     -- words that moved up a box
    words_demoted   INTEGER DEFAULT 0,     -- words that went back to box 1
    UNIQUE(user_id, study_day)
);

CREATE INDEX idx_daily_stats_date ON daily_stats(user_id, calendar_date DESC);
```

### 3.5 Streak Store

```sql
-- Streak tracking
CREATE TABLE streak_store (
    id                  INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id             TEXT NOT NULL REFERENCES users(id),
    current_streak      INTEGER DEFAULT 0,
    best_streak         INTEGER DEFAULT 0,
    last_study_date     TEXT,               -- YYYY-MM-DD
    streak_3_claimed    INTEGER DEFAULT 0,  -- milestone booleans
    streak_7_claimed    INTEGER DEFAULT 0,
    streak_14_claimed   INTEGER DEFAULT 0,
    streak_30_claimed   INTEGER DEFAULT 0,
    total_xp            INTEGER DEFAULT 0,  -- lifetime XP
    total_study_days    INTEGER DEFAULT 0,  -- lifetime study days
    UNIQUE(user_id)
);
```

### 3.6 Zone State

```sql
-- Zone unlock and test state
CREATE TABLE zone_state (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id         TEXT NOT NULL REFERENCES users(id),
    zone_index      INTEGER NOT NULL,       -- 0-4
    unlocked        INTEGER DEFAULT 0,      -- boolean
    test_passed     INTEGER DEFAULT 0,      -- boolean
    test_attempts   INTEGER DEFAULT 0,      -- total attempts
    test_best_score REAL DEFAULT 0,         -- best accuracy
    unlocked_at     TEXT,                   -- ISO8601
    UNIQUE(user_id, zone_index)
);
```

---

### 3.7 Canonical Enums

**`session_type`** (used in `review_log`, `session`, `session_state`, `day_state`):
- `morning` — regular morning session
- `evening` — regular evening session
- `recovery_evening` — missed evening recovery (F1)
- `catch_up` — missed 1-2 days recovery (F2)
- `re_entry` — missed 3+ days recovery (F3)
- `review_only` — back-pressure day (State G)
- `zone_test` — zone unlock test
- `bonus` — optional bonus practice

**`activity_type`** (used in `review_log`):
- `flashcard` — NOT used in V1 (flashcards don't write to review_log). Reserved for V2 exposure analytics.
- `image_game` — scored, +10 XP
- `quick_recall` — scored, +10 XP
- `sat_question` — scored, +10 XP

**`memory_status`** (used in `word_state`):
- `easy` — recent_accuracy >= 0.85, box >= 3, lapse_count == 0
- `normal` — default
- `fragile` — recent_accuracy < 0.6 or lapse_count >= 1
- `stubborn` — lapse_count >= 3 or consecutive_wrong >= 2

**`outcome`** (used in `review_log`):
- `correct`
- `incorrect`

### 3.8 Field Name Conventions

Schema field names are **canonical**. Where design docs use different names:

| Schema (canonical) | Learning Model | Notes |
|-------------------|---------------|-------|
| `study_day` | `day_index` | Use `study_day` in code |
| `due_at` | `next_due` | Use `due_at` in code |
| `last_reviewed_at` | `last_reviewed` | Use `last_reviewed_at` in code |
| `duration_ms` | `response_ms` | Use `duration_ms` in code |

---

## 4. Supabase Schema — Authentication & Sync

### 4.1 Authentication (Supabase Auth — built-in)

Uses Supabase's built-in `auth.users` table. No custom auth tables needed.

**Sign-up methods for V1:**
- Email + password (simple)
- Apple Sign-In (required for iOS App Store)
- Magic link (optional, V2)

**Flow:**
1. First launch → anonymous local user created (SQLite `users.id`)
2. Student taps "Sign Up" in Profile → Supabase auth creates `auth.users` entry
3. Local `users.supabase_uid` updated to link accounts
4. Progress can now sync to cloud

### 4.2 User Profile (Supabase)

Already exists as `public.user_profiles`:

```sql
-- Already in Supabase (keep, add satspell fields)
CREATE TABLE user_profiles (
    id          UUID PRIMARY KEY REFERENCES auth.users(id),
    email       TEXT,
    display_name TEXT,
    preferences JSONB DEFAULT '{"readingStyle": "enjoy"}',
    role        TEXT DEFAULT 'user',
    -- NEW fields for satspell:
    learning_start_date TIMESTAMPTZ,        -- when student started the program
    current_study_day   INTEGER DEFAULT 0,  -- latest study day completed
    total_xp            INTEGER DEFAULT 0,  -- lifetime XP (synced from local)
    current_streak      INTEGER DEFAULT 0,  -- current streak (synced)
    created_at  TIMESTAMPTZ DEFAULT now(),
    updated_at  TIMESTAMPTZ DEFAULT now()
);
```

### 4.3 Progress Sync (Supabase)

```sql
-- Cloud backup of local learning state
-- Synced periodically from SQLite → Supabase
CREATE TABLE vocab_progress_sync (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     UUID NOT NULL REFERENCES auth.users(id),
    sync_data   JSONB NOT NULL,          -- full snapshot: word_state + day_state + streak_store + zone_state + daily_stats
    sync_version INTEGER DEFAULT 1,       -- increments on each sync
    synced_at   TIMESTAMPTZ DEFAULT now(),
    device_id   TEXT                      -- which device synced this
);

CREATE INDEX idx_progress_sync_user ON vocab_progress_sync(user_id, synced_at DESC);
```

**Sync strategy:**
- After each session completion, serialize local state to JSON and push to Supabase
- On new device sign-in, pull latest `vocab_progress_sync` and hydrate SQLite
- Conflict resolution: latest `synced_at` wins (simple, single-user)
- Sync is best-effort — failure doesn't block local operation

### 4.4 Not Used from Existing Supabase

These existing tables are from other projects and should NOT be used by satspell:

- `articles`, `feeds`, `categories`, `responses` — kidsnews project
- `words` (100 rows), `word_lists`, `word_list_items` — incomplete vocab prototype
- `user_progress` (40 rows) — old progress model (correct_count/mistake_count only)
- `word_ai_content` — old AI explanations
- `user_subscriptions`, `user_stats_sync` — kidsnews user system

---

## 5. Data Population & Lifecycle

### 5.0 Data Population — Two-Phase Architecture

The app ships with an **empty database** (schema only, no word data). Word lists are **downloaded** as content packs after install. This supports future expansion (math vocab, reading vocab, etc.) without requiring app updates.

#### Phase 1: App Install (Schema Only)

On first launch, the app creates an empty `data.db` with all table schemas (Sections 2 + 3) but NO word content. The student sees a "Download Word List" screen.

#### Phase 2: Word List Download (Content Pack)

The student selects a word list to download (e.g., "SAT Core Vocabulary — 372 words"). The app downloads a **content pack** and imports it into SQLite.

**Content pack source:** JSON hosted on Supabase Storage or a CDN.

**Pack structure:**
```json
{
  "list_name": "sat_core_1",
  "list_description": "SAT Core Vocabulary",
  "version": 1,
  "words": [
    {
      "word": "ephemeral",
      "pos": "adj.",
      "definition": "lasting for only a short period of time",
      "example": "Ephemeral objects like candy wrappers...",
      "image_filename": "ephemeral.jpg",
      "sat_context": ["context1...", "context2..."],
      "collocation": ["a rather abrupt ending", "..."],
      "sat_questions": [
        {
          "id": "sim-6-q1765243827866",
          "passage": "...",
          "question": "...",
          "options": {"A": "...", "B": "...", "C": "...", "D": "..."},
          "answer": "B"
        }
      ]
    }
  ]
}
```

**Images:** Downloaded separately as a zip or individual files to app bundle. Filenames match `image_filename` field.

**Import order (respects foreign keys):**

| Step | Table | Source | Records |
|------|-------|--------|---------|
| 1 | `lists` | Pack metadata | 1 row per list |
| 2 | `words` | Pack `words[]` | 372 rows for SAT Core |
| 3 | `word_list` | Pack word order | 372 rows, rank = position |
| 4 | `sat_contexts` | `words[].sat_context[]` | ~744 rows |
| 5 | `collocations` | `words[].collocation[]` | ~1,000+ rows |
| 6 | `sat_question_bank` | `words[].sat_questions[]` + standalone questions file | ~1,553 rows |
| 7 | `word_questions` | Word-to-question mappings | ~1,100 rows |

**V1 simplification:** For V1, the "SAT Core 372" pack can be **bundled inside the app** as `word_list.json` + `sat_reading_questions_deduplicated.json` and auto-imported on first launch (no download UI needed). The download architecture is designed for V2 when multiple packs are available.

**V1 first-launch flow:**
```
1. App creates empty data.db with schema
2. App reads bundled word_list.json + sat_reading_questions_deduplicated.json
3. Auto-imports into SQLite (lists, words, word_list, sat_contexts, collocations, sat_question_bank, word_questions)
4. Creates user, streak_store, zone_state
5. Student starts learning
```

**Future (V2):**
```
1. App shows "Word List Store" with available packs
2. Student downloads "SAT Core 372" or "SAT Advanced 200" or "GRE Essentials"
3. Each pack imports into its own list with separate word_state tracking
4. Student can switch between lists or study multiple
```

#### Runtime Tables (Populated During App Use)

| Table | Created At | Populated When |
|-------|-----------|---------------|
| `users` | First launch | Auto-create local user |
| `word_state` | Schema at launch | First morning session: UPSERT per word as introduced |
| `day_state` | Schema at launch | First session start: INSERT for study_day=0 |
| `session_state` | Schema at launch | Each session start: INSERT |
| `daily_stats` | Schema at launch | Session start: UPSERT (INSERT OR IGNORE), then UPDATE per scored answer |
| `streak_store` | First launch | INSERT with all zeros |
| `zone_state` | First launch | INSERT zone_index=0 unlocked |
| `review_log` | Schema at launch | First scored answer: INSERT |
| `session` | Schema at launch | First session start: INSERT |

### 5.1 First Launch

| Step | Action | Tables Written |
|------|--------|---------------|
| 1 | Create empty `data.db` with all table schemas | All CREATE TABLE statements |
| 2 | Import bundled content from JSON | `lists`, `words`, `word_list`, `sat_contexts`, `collocations`, `sat_question_bank`, `word_questions` — see content-delivery.md Section 2 |
| 3 | Create local user | `users` INSERT (id=UUID, supabase_uid=NULL) |
| 4 | Initialize streak | `streak_store` INSERT (current_streak=0) |
| 5 | Unlock Zone 1 | `zone_state` INSERT (zone_index=0, unlocked=1) |
| 6 | Create Day 0 state | `day_state` INSERT (study_day=0, zone_index=0) |

### 5.2 Opening Practice Tab (every app launch)

| Step | Action | Tables Read | Logic |
|------|--------|-------------|-------|
| 1 | Determine current study day | `day_state` (latest) | Find most recent incomplete study day |
| 2 | Check for recovery needed | `day_state` (previous), `streak_store.last_study_date` | Compare calendar date gap to detect F1/F2/F3 |
| 3 | Check back-pressure | `word_state WHERE due_at <= now()` | COUNT overdue > 18 or > 30 |
| 4 | Check morning/evening state | `day_state.morning_complete`, `morning_complete_at` | Determine Practice tab state (A-H) |
| 5 | Check for paused session | `session_state WHERE is_paused=1` | If exists → State B (Resume) |
| 6 | Read streak + XP | `streak_store`, `daily_stats` | Header badge display |

### 5.3 Starting a Session

| Step | Action | Tables Written |
|------|--------|---------------|
| 1 | Create session record | `session` INSERT (session_type, study_day, started_at) |
| 2 | Create session_state | `session_state` INSERT (session_type, study_day, step_index=0) |
| 3 | Load words for this session | — |

**Loading words (Tables Read):**

| Session Type | Read From | Logic |
|-------------|-----------|-------|
| Morning (new words) | `word_list` + `words` | Sequential: offset = study_day × daily_new_count |
| Morning (review words for game) | `word_state WHERE due_at <= now()` | Priority: box_level ASC, memory_status priority |
| Evening (new words) | `word_list` + `words` | Next batch after morning |
| Evening (quick recall) | `word_state WHERE intro_stage=1` | This morning's words |
| Evening (review words) | `word_state WHERE due_at <= now()` | Same priority as morning |
| Recovery | `word_state` for previous day's words | Words from missed day |
| Zone test | `word_state` for current zone | Sample from zone's word range |

### 5.4 During Flashcard Step (Step 1 — Exposure Only)

| Event | Tables Written | Fields Updated |
|-------|---------------|----------------|
| Card shown (first time) | `word_state` UPSERT | `intro_stage = 1` (if morning, new word), `total_seen += 1` |
| "Show Again" tapped | `session_state` UPDATE | `show_again_ids` append word_id, `requeued_ids` append word_id |
| "Got It" tapped | (nothing — exposure only) | — |
| "Word unlocked" (first Got It ever) | `word_state` UPDATE | `box_level = 0 → 0` (stays 0, not yet scored) |

**No review_log entry for flashcards.** No XP. No box changes.

### 5.5 During Scored Step (Image Game / Quick Recall / SAT)

| Event | Tables Written | Fields Updated |
|-------|---------------|----------------|
| **Correct answer** | `review_log` INSERT | outcome='correct', activity_type, session_type, study_day, duration_ms |
| | `word_state` UPDATE | `total_correct += 1`, `total_seen += 1`, `day_touches += 1`, `consecutive_wrong = 0` |
| | `word_state` UPDATE | `recent_accuracy` = recalculate from last N reviews |
| | `word_state` UPDATE | `memory_status` = classifyMemoryStatus(word) |
| | `daily_stats` UPDATE | `correct_count += 1`, `total_count += 1`, `xp_earned += 10` |
| | `session` UPDATE | `items_correct += 1`, `xp_earned += 10` |
| **Wrong answer** | `review_log` INSERT | outcome='incorrect', same fields |
| | `word_state` UPDATE | `total_seen += 1`, `day_touches += 1`, `consecutive_wrong += 1` |
| | If `box_level > 1`: | `word_state` UPDATE: `box_level = 1`, `due_at = tomorrow`, `lapse_count += 1` |
| | `word_state` UPDATE | `recent_accuracy` recalculate, `memory_status` reclassify |
| | `daily_stats` UPDATE | `total_count += 1`, `words_demoted += 1` (if box dropped) |
| **Rushed answer** (<1s game/recall, <3s SAT) | `review_log` INSERT | Logged but `day_touches` NOT incremented (doesn't count for promotion) |
| **Step advances** | `session_state` UPDATE | `step_index += 1`, `item_index = 0` |
| **Item advances** | `session_state` UPDATE | `item_index += 1` |

### 5.6 classifyMemoryStatus() — When to Recalculate

Called after every scored answer. Updates `word_state.memory_status`.

```
function classifyMemoryStatus(word):
    if word.lapse_count >= 3 or word.consecutive_wrong >= 2:
        return 'stubborn'
    if word.recent_accuracy < 0.6 or word.lapse_count >= 1:
        return 'fragile'
    if word.box_level >= 3 and word.recent_accuracy >= 0.85 and word.lapse_count == 0:
        return 'easy'
    return 'normal'
```

### 5.7 computeRecentAccuracy() — How to Calculate

```
function computeRecentAccuracy(user_id, word_id):
    // Last 5 scored (non-superseded) reviews for this word
    results = SELECT outcome FROM review_log
              WHERE user_id=? AND word_id=?
              AND activity_type IN ('image_game', 'quick_recall', 'sat_question')
              AND superseded=0
              ORDER BY reviewed_at DESC LIMIT 5

    if results.count == 0: return 0.0
    correct = results.filter(r => r.outcome == 'correct').count
    return correct / results.count
```

### 5.8 Day 1 Promotion — End of Evening Session

Runs after the evening session's last step completes.

| Step | Action | Tables Read/Written |
|------|--------|-------------------|
| 1 | Find all words with `intro_stage = 1` (morning seen, evening not yet decided) | READ `word_state` |
| 2 | For each word, count scored correct today | READ `review_log WHERE study_day=current AND activity_type IN (image_game, quick_recall) AND superseded=0` |
| 3 | Check promotion rule: 2/3 correct + final recall correct | (computed) |
| 4 | If promoted: | WRITE `word_state`: `box_level=2, due_at=now()+3days, intro_stage=3` |
| 5 | If not promoted: | WRITE `word_state`: `box_level=1, due_at=tomorrow, intro_stage=3` |
| 6 | Update daily stats | WRITE `daily_stats`: `words_promoted += promoted_count` |

### 5.9 Session Complete

| Step | Action | Tables Written |
|------|--------|---------------|
| 1 | Mark session done | `session` UPDATE: `ended_at=now()` |
| 2 | Mark session_state complete | `session_state` UPDATE: `completed_at=now(), is_paused=0` |
| 3 | Add session bonus XP | `daily_stats` UPDATE: `session_bonus += 30` |
| 4 | Update day_state | `day_state` UPDATE: `morning_complete=1, morning_complete_at=now()` (or evening equivalent) |
| 5 | Update streak | `streak_store` UPDATE: recalculate current_streak based on last_study_date |
| 6 | Check streak milestones | `streak_store`: if streak=3 and streak_3_claimed=0 → `xp_earned += 20, streak_3_claimed=1` |
| 7 | If evening: run Day 1 promotion | See Section 5.8 above |
| 8 | Reset day_touches for tomorrow | `word_state` UPDATE: `day_touches=0` WHERE words were seen today (deferred to next morning) |
| 9 | Sync to Supabase (if signed in) | `vocab_progress_sync` INSERT |

### 5.10 Pause / Resume

**Pause:**

| Step | Action | Tables Written |
|------|--------|---------------|
| 1 | Save current position | `session_state` UPDATE: `step_index, item_index, is_paused=1, paused_at=now()` |
| 2 | Save requeued cards | `session_state` UPDATE: `requeued_ids = [list of requeued word_ids]` |
| (review_log entries already written per-item — no batch needed) | | |

**Resume:**

| Step | Action | Tables Read |
|------|--------|-------------|
| 1 | Load session state | `session_state WHERE is_paused=1` |
| 2 | Navigate to step + item | Use `step_index`, `item_index` |
| 3 | Restore requeued cards | Read `requeued_ids`, `show_again_ids` |
| 4 | Continue | `session_state` UPDATE: `is_paused=0` |

### 5.11 Restart (from Resume card)

| Step | Action | Tables Written |
|------|--------|---------------|
| 1 | Mark previous answers superseded | `review_log` UPDATE: `superseded=1` WHERE this session + study_day |
| 2 | Subtract superseded XP | `daily_stats` UPDATE: `xp_earned -= superseded_correct × 10` |
| 3 | Reset session_state | `session_state` UPDATE: `step_index=0, item_index=0, requeued_ids=NULL, show_again_ids=NULL` |
| 4 | Reset word day_touches | `word_state` UPDATE: `day_touches=0` for affected words |

### 5.12 Box Progression — When Words Move

| Event | Box Change | due_at Update | When |
|-------|-----------|---------------|------|
| New word first introduced | 0 → stays 0 | NULL | Flashcard step (exposure, not scored) |
| Day 1 promotion (2/3 + final correct) | 0 → 2 | now + 3 days | End of evening session |
| Day 1 no promotion | 0 → 1 | tomorrow | End of evening session |
| Correct answer (review) | N → N+1 | now + interval[N+1] | During scored step, per answer |
| Wrong answer (any box > 0) | N → 1 | tomorrow | During scored step, per answer |
| Wrong answer (already box 1) | stays 1 | tomorrow | During scored step |

**Box intervals:** 1→1day, 2→3days, 3→7days, 4→14days, 5→no review

### 5.13 New Device Sync

| Step | Action | Tables Read/Written |
|------|--------|-------------------|
| 1 | Sign in via Supabase Auth | — |
| 2 | Pull latest sync | READ Supabase `vocab_progress_sync` (latest by synced_at) |
| 3 | Parse sync_data JSON | — |
| 4 | Hydrate SQLite tables | WRITE: `word_state`, `day_state`, `streak_store`, `zone_state`, `daily_stats` (bulk insert) |
| 5 | Continue studying | — |

### 5.14 Optional Sign-Up

| Step | Action | Tables Written |
|------|--------|---------------|
| 1 | Student taps "Sign Up" | — |
| 2 | Supabase auth.users created | Supabase `auth.users` |
| 3 | Profile created | Supabase `user_profiles` INSERT |
| 4 | Link accounts | SQLite `users` UPDATE: `supabase_uid = auth.users.id` |
| 5 | First sync | Supabase `vocab_progress_sync` INSERT (full local snapshot) |

---

## 6. Key Queries

### Get Review Queue (Priority Order)

```sql
SELECT ws.word_id, ws.box_level, ws.memory_status, ws.due_at,
       w.lemma, w.pos, w.definition, w.example, w.image_filename
FROM word_state ws
JOIN words w ON w.id = ws.word_id
WHERE ws.user_id = ?
  AND ws.due_at <= datetime('now')
  AND ws.box_level > 0
ORDER BY
  ws.box_level ASC,                    -- Box 1 first (most urgent)
  CASE ws.memory_status
    WHEN 'stubborn' THEN 0
    WHEN 'fragile' THEN 1
    WHEN 'normal' THEN 2
    WHEN 'easy' THEN 3
  END ASC,
  ws.due_at ASC                        -- oldest due first
LIMIT ?;
```

### Day 1 Promotion Check

```sql
-- After evening session: check if word qualifies for Box 2
SELECT ws.word_id, ws.day_touches,
  (SELECT COUNT(*) FROM review_log rl
   WHERE rl.word_id = ws.word_id
     AND rl.user_id = ws.user_id
     AND rl.study_day = ?
     AND rl.activity_type IN ('image_game', 'quick_recall')
     AND rl.outcome = 'correct'
     AND rl.superseded = 0
  ) as scored_correct,
  (SELECT COUNT(*) FROM review_log rl
   WHERE rl.word_id = ws.word_id
     AND rl.user_id = ws.user_id
     AND rl.study_day = ?
     AND rl.activity_type IN ('image_game', 'quick_recall')
     AND rl.superseded = 0
  ) as scored_total
FROM word_state ws
WHERE ws.user_id = ?
  AND ws.intro_stage = 2;    -- evening recall done, ready for promotion decision
```

### Daily Stats Summary

```sql
SELECT
  ds.xp_earned + ds.session_bonus as total_xp,
  ds.correct_count,
  ds.total_count,
  CASE WHEN ds.total_count > 0
    THEN ROUND(ds.correct_count * 100.0 / ds.total_count)
    ELSE 0
  END as accuracy_pct,
  ds.new_count,
  ds.review_count,
  ds.words_promoted,
  ds.words_demoted,
  ds.study_minutes
FROM daily_stats ds
WHERE ds.user_id = ? AND ds.study_day = ?;
```

### Word Strength Distribution (Stats Tab)

```sql
SELECT
  box_level,
  COUNT(*) as word_count
FROM word_state
WHERE user_id = ? AND box_level > 0
GROUP BY box_level
ORDER BY box_level;
```

### Words Fighting Back (memory_status = stubborn)

```sql
SELECT w.lemma, w.pos, ws.box_level, ws.lapse_count, ws.consecutive_wrong
FROM word_state ws
JOIN words w ON w.id = ws.word_id
WHERE ws.user_id = ?
  AND ws.memory_status = 'stubborn'
ORDER BY ws.lapse_count DESC
LIMIT 5;
```

---

## 7. Migration Plan

### From Current SQLite to New Schema

The bundled `data.db` already has word content tables. New tables are additive.

```swift
// On first launch with new app version:
func migrateToV2() throws {
    // 1. Create new tables (word_state, day_state, session_state, etc.)
    try db.exec(createWordStateSQL)
    try db.exec(createDayStateSQL)
    try db.exec(createSessionStateSQL)
    try db.exec(createDailyStatsSQL)
    try db.exec(createStreakStoreSQL)
    try db.exec(createZoneStateSQL)

    // 2. Add new columns to review_log
    try db.exec("ALTER TABLE review_log ADD COLUMN activity_type TEXT;")
    try db.exec("ALTER TABLE review_log ADD COLUMN session_type TEXT;")
    try db.exec("ALTER TABLE review_log ADD COLUMN study_day INTEGER;")
    try db.exec("ALTER TABLE review_log ADD COLUMN superseded INTEGER DEFAULT 0;")

    // 3. Add new columns to session
    try db.exec("ALTER TABLE session ADD COLUMN session_type TEXT;")
    try db.exec("ALTER TABLE session ADD COLUMN study_day INTEGER;")
    try db.exec("ALTER TABLE session ADD COLUMN xp_earned INTEGER DEFAULT 0;")

    // 4. Add supabase_uid to users
    try db.exec("ALTER TABLE users ADD COLUMN supabase_uid TEXT;")
    try db.exec("ALTER TABLE users ADD COLUMN display_name TEXT;")

    // 5. Initialize zone_state (zone 0 unlocked)
    try db.exec("INSERT INTO zone_state(user_id, zone_index, unlocked) VALUES (?, 0, 1);")

    // 6. Initialize streak_store
    try db.exec("INSERT INTO streak_store(user_id) VALUES (?);")

    // 7. Migrate existing review_log data to word_state (if any progress exists)
    // ... populate word_state from review_log history
}
```

### Supabase Changes

```sql
-- Add satspell columns to existing user_profiles
ALTER TABLE user_profiles ADD COLUMN learning_start_date TIMESTAMPTZ;
ALTER TABLE user_profiles ADD COLUMN current_study_day INTEGER DEFAULT 0;
ALTER TABLE user_profiles ADD COLUMN total_xp INTEGER DEFAULT 0;
ALTER TABLE user_profiles ADD COLUMN current_streak INTEGER DEFAULT 0;

-- Create new sync table
CREATE TABLE vocab_progress_sync (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     UUID NOT NULL REFERENCES auth.users(id),
    sync_data   JSONB NOT NULL,
    sync_version INTEGER DEFAULT 1,
    synced_at   TIMESTAMPTZ DEFAULT now(),
    device_id   TEXT
);

CREATE INDEX idx_progress_sync_user ON vocab_progress_sync(user_id, synced_at DESC);

-- Enable RLS
ALTER TABLE vocab_progress_sync ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can manage own sync data"
  ON vocab_progress_sync
  FOR ALL
  USING (auth.uid() = user_id);
```

---

## 8. Summary

| Layer | Purpose | Tables | Online Required? |
|-------|---------|--------|-----------------|
| SQLite (bundled content) | 372 words, SAT questions, collocations | 7 tables (read-only) | No |
| SQLite (user state) | Learning progress, sessions, stats | 6 new tables | No |
| SQLite (logs) | Review history, session history | 2 modified tables | No |
| Supabase (auth) | Sign up, sign in, identity | auth.users (built-in) | Yes |
| Supabase (profile) | User info, preferences | user_profiles (existing) | Yes |
| Supabase (sync) | Progress backup, multi-device | vocab_progress_sync (new) | Yes |

---

## Schema Review

1. **Lifecycle is not fully aligned yet.** `data-schema.md` Section 5 leads with a schema-only DB plus download/store flow, while `content-delivery.md` makes V1 bundled auto-import the decision. Then `5.1 First Launch` copies `data.db` and creates user defaults, but it does not explicitly import `lists`, `words`, `word_list`, `sat_contexts`, `collocations`, `sat_question_bank`, and `word_questions`. Pick one authoritative V1 path and mirror it in both docs.

2. **`daily_stats` is created too late for the write path shown.** The runtime table says `daily_stats` is inserted at first session complete, but `5.5 During Scored Step` updates it on every answer. That row needs to exist at session start or be written via UPSERT on first scored event.

3. **Restart logic is incomplete.** `5.11 Restart` marks `review_log` rows as `superseded` and subtracts XP, but it does not roll back `word_state.box_level`, `due_at`, `total_correct`, `total_seen`, `recent_accuracy`, `memory_status`, `lapse_count`, or `last_reviewed_at`. A restarted session can therefore leave word state inconsistent with the surviving log history.

4. **The flashcard logging story is internally inconsistent.** The learning model still mentions flashcard timing validity, and the schema enums say `activity_type='flashcard'`, but `5.4` says flashcards do not create `review_log` entries. Either flashcards are truly exposure-only everywhere, or you need a separate exposure-event log. Right now the docs disagree.

5. **V1→V2 multi-list support needs one clear semantic choice.** `word_state` is per-word (`UNIQUE(user_id, word_id)`), which works only if duplicate lemmas across packs intentionally share progress. But `data-schema.md` says future packs get separate `word_state` tracking, while `content-delivery.md` says progress carries over. The importer also inserts words blindly, so the same lemma in a second pack would get a new `words.id` and break carry-over. Decide shared-per-word vs per-list progress, then enforce it with dedupe/UNIQUE rules or a `list_id` dimension.

6. **Foreign keys and indexes need tightening.** Add FKs for `session.user_id`, `session.list_id`, `review_log.list_id`, and likely `sat_question_bank.word_id`; add `UNIQUE(word_id, question_id)` on `word_questions`; and explicitly require `PRAGMA foreign_keys = ON` for SQLite. Performance-wise, add indexes for `word_list(list_id, rank)`, `sat_contexts(word_id)`, `collocations(word_id)`, `word_questions(word_id)`, a composite `review_log(user_id, word_id, activity_type, superseded, reviewed_at DESC)`, and a composite `word_state(user_id, box_level, memory_status, due_at)` for the review queue.

7. **Supabase sync is acceptable as backup, but not yet safe for multi-device drift.** Full-snapshot sync is fine for offline-first V1, but “latest `synced_at` wins” can let an older offline device overwrite newer progress. Use `sync_version` (or base-version checks) in conflict resolution instead of timestamp alone.
