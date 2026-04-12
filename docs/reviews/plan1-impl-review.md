# 🤖 Copilot CLI Session

> [!NOTE]
> - **Session ID:** `f7a296a4-ca41-488b-8f27-e023b8278c0e`  
> - **Started:** 4/12/2026, 3:32:01 PM  
> - **Duration:** 2m 28s  
> - **Exported:** 4/12/2026, 3:34:29 PM  

---

<sub>⏱️ 2s</sub>

### 👤 User

Review the Plan 1 data layer implementation for an iOS SAT vocab app.

The following Swift files were just implemented. Read them all and check against docs/data-schema.md:

1. ios/SATVocabApp/Sources/SATVocabApp/Models/Enums.swift
2. ios/SATVocabApp/Sources/SATVocabApp/Models/Models.swift
3. ios/SATVocabApp/Sources/SATVocabApp/Data/SchemaV2.swift
4. ios/SATVocabApp/Sources/SATVocabApp/Data/ContentImporter.swift
5. ios/SATVocabApp/Sources/SATVocabApp/Data/WordStateStore.swift
6. ios/SATVocabApp/Sources/SATVocabApp/Data/SessionStateStore.swift
7. ios/SATVocabApp/Sources/SATVocabApp/Data/StatsStore.swift
8. ios/SATVocabApp/Sources/SATVocabApp/Data/ZoneStore.swift
9. ios/SATVocabApp/Sources/SATVocabApp/Data/ReviewLogger.swift
10. ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift

Check for:
1. Does the schema in SchemaV2 match data-schema.md exactly?
2. Are all WordStateStore methods correct (box progression, promotion rule)?
3. Any SQL injection vulnerabilities?
4. Any actor isolation issues?
5. Any missing error handling that would cause silent failures?

Write a brief review (under 300 words) to docs/reviews/plan1-implementation-review.md

---

<sub>⏱️ 21s</sub>

### ✅ `skill`

**using-superpowers**

<details>
<summary>Arguments</summary>

```json
{
  "skill": "using-superpowers"
}
```

</details>

```
Skill "using-superpowers" loaded successfully. Follow the instructions in the skill context.
```


---

<sub>⏱️ 50s</sub>

### 💬 Copilot

Using the brainstorming skill to frame the audit, then I’ll read the implemented Swift files plus the schema spec in parallel and write the review file directly.

---

<sub>⏱️ 50s</sub>

### ✅ `skill`

**brainstorming**

<details>
<summary>Arguments</summary>

```json
{
  "skill": "brainstorming"
}
```

</details>

```
Skill "brainstorming" loaded successfully. Follow the instructions in the skill context.
```


---

<sub>⏱️ 50s</sub>

### ✅ `sql`

**Prepare implementation review todos**

<details>
<summary>Arguments</summary>

```json
{
  "description": "Prepare implementation review todos",
  "query": "INSERT INTO todos (id, title, description, status) VALUES\n  ('read-plan1-implementation', 'Read Plan 1 implementation', 'Read the 10 implemented Swift files plus docs/data-schema.md to verify schema fidelity, WordStateStore logic, SQL safety, actor isolation, and error handling.', 'in_progress'),\n  ('audit-plan1-implementation', 'Audit data layer implementation', 'Cross-check the implementation against docs/data-schema.md, identify mismatches and bugs, and assess SQL injection, actor isolation, and silent-failure risks.', 'pending'),\n  ('write-plan1-review', 'Write plan1 implementation review', 'Create docs/reviews/plan1-implementation-review.md with a brief under-300-word review summarizing the most important findings.', 'pending');\nSELECT id, title, status FROM todos WHERE id IN ('read-plan1-implementation','audit-plan1-implementation','write-plan1-review') ORDER BY created_at;"
}
```

</details>

<details>
<summary>10 lines</summary>

```
Executed 2 statement(s):

1. INSERT
   3 row(s) inserted. Last inserted row ID: 20.

2. SELECT
   3 row(s) returned:
   
   | id | title | status |
   | --- | --- | --- |
   | audit-plan1-implementation | Audit data layer implementation | pending |
   | read-plan1-implementation | Read Plan 1 implementation | in_progress |
   | write-plan1-review | Write plan1 implementation review | pending |
```

</details>


---

<sub>⏱️ 50s</sub>

### ✅ `rg`

**/Users/jiong/myprojects/satspell/docs/data-schema.md**

<details>
<summary>Arguments</summary>

```json
{
  "pattern": "^(##|###) ",
  "path": "/Users/jiong/myprojects/satspell/docs/data-schema.md",
  "output_mode": "content",
  "-n": true,
  "head_limit": 160
}
```

</details>

<details>
<summary>47 lines</summary>

```
/Users/jiong/myprojects/satspell/docs/data-schema.md:7:## 1. Architecture Overview
/Users/jiong/myprojects/satspell/docs/data-schema.md:27:### Principles
/Users/jiong/myprojects/satspell/docs/data-schema.md:37:## 2. SQLite Schema — Existing Tables (Keep)
/Users/jiong/myprojects/satspell/docs/data-schema.md:41:### 2.1 Word Content (read-only, bundled)
/Users/jiong/myprojects/satspell/docs/data-schema.md:124:### 2.2 Existing User Tables (Modify)
/Users/jiong/myprojects/satspell/docs/data-schema.md:137:### 2.3 Existing Log Tables (Modify)
/Users/jiong/myprojects/satspell/docs/data-schema.md:184:## 3. SQLite Schema — New Tables
/Users/jiong/myprojects/satspell/docs/data-schema.md:188:### 3.1 Word State (Leitner Box Progression)
/Users/jiong/myprojects/satspell/docs/data-schema.md:217:### 3.2 Day State (Study Day Tracking)
/Users/jiong/myprojects/satspell/docs/data-schema.md:245:### 3.3 Session State (Pause/Resume)
/Users/jiong/myprojects/satspell/docs/data-schema.md:266:### 3.4 Daily Stats
/Users/jiong/myprojects/satspell/docs/data-schema.md:290:### 3.5 Streak Store
/Users/jiong/myprojects/satspell/docs/data-schema.md:310:### 3.6 Zone State
/Users/jiong/myprojects/satspell/docs/data-schema.md:329:### 3.7 Canonical Enums
/Users/jiong/myprojects/satspell/docs/data-schema.md:357:### 3.8 Field Name Conventions
/Users/jiong/myprojects/satspell/docs/data-schema.md:370:## 4. Supabase Schema — Authentication & Sync
/Users/jiong/myprojects/satspell/docs/data-schema.md:372:### 4.1 Authentication (Supabase Auth — built-in)
/Users/jiong/myprojects/satspell/docs/data-schema.md:387:### 4.2 User Profile (Supabase)
/Users/jiong/myprojects/satspell/docs/data-schema.md:409:### 4.3 Progress Sync (Supabase)
/Users/jiong/myprojects/satspell/docs/data-schema.md:432:### 4.4 Not Used from Existing Supabase
/Users/jiong/myprojects/satspell/docs/data-schema.md:444:## 5. Data Population & Lifecycle
/Users/jiong/myprojects/satspell/docs/data-schema.md:446:### 5.0 Data Population — Two-Phase Architecture
/Users/jiong/myprojects/satspell/docs/data-schema.md:536:### 5.1 First Launch
/Users/jiong/myprojects/satspell/docs/data-schema.md:547:### 5.2 Opening Practice Tab (every app launch)
/Users/jiong/myprojects/satspell/docs/data-schema.md:558:### 5.3 Starting a Session
/Users/jiong/myprojects/satspell/docs/data-schema.md:578:### 5.4 During Flashcard Step (Step 1 — Exposure Only)
/Users/jiong/myprojects/satspell/docs/data-schema.md:589:### 5.5 During Scored Step (Image Game / Quick Recall / SAT)
/Users/jiong/myprojects/satspell/docs/data-schema.md:608:### 5.6 classifyMemoryStatus() — When to Recalculate
/Users/jiong/myprojects/satspell/docs/data-schema.md:623:### 5.7 computeRecentAccuracy() — How to Calculate
/Users/jiong/myprojects/satspell/docs/data-schema.md:639:### 5.8 Day 1 Promotion — End of Evening Session
/Users/jiong/myprojects/satspell/docs/data-schema.md:652:### 5.9 Session Complete
/Users/jiong/myprojects/satspell/docs/data-schema.md:666:### 5.10 Pause / Resume
/Users/jiong/myprojects/satspell/docs/data-schema.md:685:### 5.11 Restart (from Resume card)
/Users/jiong/myprojects/satspell/docs/data-schema.md:694:### 5.12 Box Progression — When Words Move
/Users/jiong/myprojects/satspell/docs/data-schema.md:707:### 5.13 New Device Sync
/Users/jiong/myprojects/satspell/docs/data-schema.md:717:### 5.14 Optional Sign-Up
/Users/jiong/myprojects/satspell/docs/data-schema.md:729:## 6. Key Queries
/Users/jiong/myprojects/satspell/docs/data-schema.md:731:### Get Review Queue (Priority Order)
/Users/jiong/myprojects/satspell/docs/data-schema.md:753:### Day 1 Promotion Check
/Users/jiong/myprojects/satspell/docs/data-schema.md:778:### Daily Stats Summary
/Users/jiong/myprojects/satspell/docs/data-schema.md:798:### Word Strength Distribution (Stats Tab)
/Users/jiong/myprojects/satspell/docs/data-schema.md:810:### Words Fighting Back (memory_status = stubborn)
/Users/jiong/myprojects/satspell/docs/data-schema.md:824:## 7. Migration Plan
/Users/jiong/myprojects/satspell/docs/data-schema.md:826:### From Current SQLite to New Schema
/Users/jiong/myprojects/satspell/docs/data-schema.md:867:### Supabase Changes
/Users/jiong/myprojects/satspell/docs/data-schema.md:898:## 8. Summary
/Users/jiong/myprojects/satspell/docs/data-schema.md:911:## Schema Review
```

</details>


---

<sub>⏱️ 50s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/docs/data-schema.md.**

/Users/jiong/myprojects/satspell/docs/data-schema.md (lines 37-360)

<details>
<summary>324 lines</summary>

````
37. ## 2. SQLite Schema — Existing Tables (Keep)
38. 
39. These tables are already in the bundled `data.db` and should be kept as-is.
40. 
41. ### 2.1 Word Content (read-only, bundled)
42. 
43. ```sql
44. -- Core vocabulary (372 words, bundled)
45. CREATE TABLE words (
46.     id          INTEGER PRIMARY KEY,
47.     lemma       TEXT NOT NULL,
48.     pos         TEXT,                    -- part of speech (adj., noun, etc.)
49.     definition  TEXT,
50.     example     TEXT,                    -- example sentence
51.     image_filename TEXT                  -- e.g., "ephemeral.jpg"
52. );
53. 
54. -- Word lists
55. CREATE TABLE lists (
56.     id          INTEGER PRIMARY KEY,
57.     name        TEXT NOT NULL,           -- e.g., "sat_core_1"
58.     description TEXT,
59.     version     INTEGER DEFAULT 1
60. );
61. 
62. -- Word-to-list mapping with ordering
63. CREATE TABLE word_list (
64.     id          INTEGER PRIMARY KEY,
65.     word_id     INTEGER NOT NULL REFERENCES words(id),
66.     list_id     INTEGER NOT NULL REFERENCES lists(id),
67.     rank        INTEGER                  -- display/sequence order
68. );
69. 
70. -- SAT context sentences per word
71. CREATE TABLE sat_contexts (
72.     id          INTEGER PRIMARY KEY,
73.     word_id     INTEGER NOT NULL REFERENCES words(id),
74.     context     TEXT NOT NULL
75. );
76. 
77. -- Word collocations
78. CREATE TABLE collocations (
79.     id          INTEGER PRIMARY KEY,
80.     word_id     INTEGER NOT NULL REFERENCES words(id),
81.     phrase      TEXT NOT NULL
82. );
83. 
84. -- SAT question bank (~8000 questions)
85. CREATE TABLE sat_question_bank (
86.     id              TEXT PRIMARY KEY,
87.     word_id         INTEGER,
88.     target_word     TEXT,
89.     section         TEXT,
90.     module          INTEGER,
91.     q_type          TEXT,
92.     passage         TEXT,
93.     question        TEXT,
94.     option_a        TEXT,
95.     option_b        TEXT,
96.     option_c        TEXT,
97.     option_d        TEXT,
98.     answer          TEXT,               -- correct answer letter
99.     source_pdf      TEXT,
100.     page            INTEGER,
101.     feedback_generated INTEGER DEFAULT 0,
102.     answer_verified    INTEGER DEFAULT 0
103. );
104. 
105. -- Word-to-question mapping
106. CREATE TABLE word_questions (
107.     id          INTEGER PRIMARY KEY,
108.     word_id     INTEGER NOT NULL REFERENCES words(id),
109.     question_id TEXT NOT NULL REFERENCES sat_question_bank(id)
110. );
111. 
112. -- AI-generated feedback for SAT questions
113. CREATE TABLE deepseek_sat_feedback (
114.     id              INTEGER PRIMARY KEY,
115.     question_id     TEXT REFERENCES sat_question_bank(id),
116.     ai_source       TEXT,
117.     answer          TEXT,               -- AI's answer
118.     background      TEXT,               -- background explanation
119.     reason_for_answer TEXT,             -- reasoning
120.     created_at      TEXT
121. );
122. ```
123. 
124. ### 2.2 Existing User Tables (Modify)
125. 
126. ```sql
127. -- Local user identity (keep, add supabase_uid)
128. CREATE TABLE users (
129.     id          TEXT PRIMARY KEY,        -- local UUID
130.     email       TEXT,
131.     supabase_uid TEXT,                   -- NEW: linked Supabase auth.users.id (nullable)
132.     display_name TEXT,                   -- NEW: student name
133.     created_at  TEXT DEFAULT (datetime('now'))
134. );
135. ```
136. 
137. ### 2.3 Existing Log Tables (Modify)
138. 
139. ```sql
140. -- Review log (keep, add columns)
141. CREATE TABLE review_log (
142.     id          INTEGER PRIMARY KEY AUTOINCREMENT,
143.     user_id     TEXT NOT NULL REFERENCES users(id),
144.     word_id     INTEGER NOT NULL REFERENCES words(id),
145.     list_id     INTEGER,
146.     outcome     TEXT NOT NULL,           -- 'correct' or 'incorrect'
147.     duration_ms INTEGER,                 -- response time
148.     reviewed_at TEXT NOT NULL,           -- ISO8601
149.     device_id   TEXT,
150.     activity_type TEXT,                  -- NEW: 'flashcard', 'image_game', 'quick_recall', 'sat_question'
151.     session_type TEXT,                   -- NEW: 'morning', 'evening', 'recovery', 'bonus', 'zone_test'
152.     study_day   INTEGER,                -- NEW: study day index (0-19)
153.     superseded  INTEGER DEFAULT 0       -- NEW: 1 if this entry was replaced by a restart
154. );
155. 
156. CREATE INDEX idx_review_log_word ON review_log(word_id, user_id, reviewed_at DESC);
157. CREATE INDEX idx_review_log_day ON review_log(user_id, study_day);
158. CREATE INDEX idx_review_log_scored ON review_log(user_id, word_id, activity_type, superseded, reviewed_at DESC);
159. 
160. -- Content table indexes (for word lookup performance)
161. CREATE INDEX idx_word_list_rank ON word_list(list_id, rank);
162. CREATE INDEX idx_sat_contexts_word ON sat_contexts(word_id);
163. CREATE INDEX idx_collocations_word ON collocations(word_id);
164. CREATE INDEX idx_word_questions_word ON word_questions(word_id);
165. CREATE UNIQUE INDEX idx_word_questions_unique ON word_questions(word_id, question_id);
166. 
167. -- Session table (keep, add columns)
168. CREATE TABLE session (
169.     id          INTEGER PRIMARY KEY AUTOINCREMENT,
170.     user_id     TEXT NOT NULL,
171.     list_id     INTEGER,
172.     started_at  TEXT,
173.     ended_at    TEXT,
174.     items_total INTEGER,
175.     items_correct INTEGER DEFAULT 0,
176.     session_type TEXT,                   -- NEW: 'morning', 'evening', 'recovery_evening', 'catch_up', 're_entry', 'zone_test', 'bonus'
177.     study_day   INTEGER,                -- NEW: study day index
178.     xp_earned   INTEGER DEFAULT 0       -- NEW: total XP from this session
179. );
180. ```
181. 
182. ---
183. 
184. ## 3. SQLite Schema — New Tables
185. 
186. These tables implement the learning model from `learning-model-design.md`.
187. 
188. ### 3.1 Word State (Leitner Box Progression)
189. 
190. ```sql
191. -- Per-word learning state for each user
192. CREATE TABLE word_state (
193.     id              INTEGER PRIMARY KEY AUTOINCREMENT,
194.     user_id         TEXT NOT NULL REFERENCES users(id),
195.     word_id         INTEGER NOT NULL REFERENCES words(id),
196.     box_level       INTEGER NOT NULL DEFAULT 0,  -- 0=not introduced, 1-5=Leitner boxes
197.     due_at          TEXT,                         -- ISO8601 DateTime (NULL = not yet due)
198.     intro_stage     INTEGER DEFAULT 0,            -- 0=not introduced, 1=morning seen, 2=evening recall done, 3=promotion decided
199.     memory_status   TEXT DEFAULT 'normal',         -- 'easy', 'normal', 'fragile', 'stubborn'
200.     lapse_count     INTEGER DEFAULT 0,             -- times reset to box 1 from higher
201.     consecutive_wrong INTEGER DEFAULT 0,           -- current wrong streak
202.     total_correct   INTEGER DEFAULT 0,             -- lifetime correct count
203.     total_seen      INTEGER DEFAULT 0,             -- lifetime seen count
204.     day_touches     INTEGER DEFAULT 0,             -- scored touches today (reset daily)
205.     recent_accuracy REAL DEFAULT 0,                -- rolling accuracy over recent scored recalls (used by classifyMemoryStatus)
206.     last_reviewed_at TEXT,                          -- ISO8601
207.     created_at      TEXT DEFAULT (datetime('now')),
208.     updated_at      TEXT DEFAULT (datetime('now')),
209.     UNIQUE(user_id, word_id)
210. );
211. 
212. CREATE INDEX idx_word_state_due ON word_state(user_id, due_at);
213. CREATE INDEX idx_word_state_box ON word_state(user_id, box_level);
214. CREATE INDEX idx_word_state_status ON word_state(user_id, memory_status);
215. ```
216. 
217. ### 3.2 Day State (Study Day Tracking)
218. 
219. ```sql
220. -- Per study-day state
221. CREATE TABLE day_state (
222.     id                  INTEGER PRIMARY KEY AUTOINCREMENT,
223.     user_id             TEXT NOT NULL REFERENCES users(id),
224.     study_day           INTEGER NOT NULL,             -- 0-indexed study day (not calendar day)
225.     zone_index          INTEGER NOT NULL,             -- 0-4
226.     morning_complete    INTEGER DEFAULT 0,             -- boolean
227.     evening_complete    INTEGER DEFAULT 0,             -- boolean
228.     morning_complete_at TEXT,                           -- ISO8601 DateTime
229.     evening_complete_at TEXT,                           -- ISO8601 DateTime
230.     new_words_morning   INTEGER DEFAULT 0,             -- actual new words introduced
231.     new_words_evening   INTEGER DEFAULT 0,
232.     morning_accuracy    REAL DEFAULT 0,                -- 0.0-1.0
233.     evening_accuracy    REAL DEFAULT 0,
234.     morning_xp          INTEGER DEFAULT 0,
235.     evening_xp          INTEGER DEFAULT 0,
236.     is_recovery_day     INTEGER DEFAULT 0,             -- boolean
237.     is_review_only_day  INTEGER DEFAULT 0,             -- boolean (back-pressure)
238.     created_at          TEXT DEFAULT (datetime('now')),
239.     UNIQUE(user_id, study_day)
240. );
241. 
242. CREATE INDEX idx_day_state_user ON day_state(user_id, study_day DESC);
243. ```
244. 
245. ### 3.3 Session State (Pause/Resume)
246. 
247. ```sql
248. -- Active session state for pause/resume
249. CREATE TABLE session_state (
250.     id              INTEGER PRIMARY KEY AUTOINCREMENT,
251.     user_id         TEXT NOT NULL REFERENCES users(id),
252.     session_type    TEXT NOT NULL,          -- 'morning', 'evening', 'recovery_evening', etc.
253.     study_day       INTEGER NOT NULL,
254.     step_index      INTEGER DEFAULT 0,     -- current step (0-based)
255.     item_index      INTEGER DEFAULT 0,     -- current item within step
256.     is_paused       INTEGER DEFAULT 0,     -- boolean
257.     show_again_ids  TEXT,                   -- JSON array of word IDs from Show Again (Step 1 → Step 2)
258.     requeued_ids    TEXT,                   -- JSON array of word IDs currently requeued within a step (for pause/resume)
259.     started_at      TEXT,                   -- ISO8601
260.     paused_at       TEXT,                   -- ISO8601
261.     completed_at    TEXT,                   -- ISO8601 (NULL if not done)
262.     UNIQUE(user_id, study_day, session_type)
263. );
264. ```
265. 
266. ### 3.4 Daily Stats
267. 
268. ```sql
269. -- Aggregated daily statistics
270. CREATE TABLE daily_stats (
271.     id              INTEGER PRIMARY KEY AUTOINCREMENT,
272.     user_id         TEXT NOT NULL REFERENCES users(id),
273.     study_day       INTEGER NOT NULL,
274.     calendar_date   TEXT NOT NULL,          -- YYYY-MM-DD
275.     new_count       INTEGER DEFAULT 0,     -- new words introduced today
276.     review_count    INTEGER DEFAULT 0,     -- review words practiced
277.     correct_count   INTEGER DEFAULT 0,     -- total correct answers
278.     total_count     INTEGER DEFAULT 0,     -- total scored attempts
279.     xp_earned       INTEGER DEFAULT 0,     -- total XP today
280.     session_bonus   INTEGER DEFAULT 0,     -- session completion bonuses
281.     study_minutes   REAL DEFAULT 0,        -- total active study time
282.     words_promoted  INTEGER DEFAULT 0,     -- words that moved up a box
283.     words_demoted   INTEGER DEFAULT 0,     -- words that went back to box 1
284.     UNIQUE(user_id, study_day)
285. );
286. 
287. CREATE INDEX idx_daily_stats_date ON daily_stats(user_id, calendar_date DESC);
288. ```
289. 
290. ### 3.5 Streak Store
291. 
292. ```sql
293. -- Streak tracking
294. CREATE TABLE streak_store (
295.     id                  INTEGER PRIMARY KEY AUTOINCREMENT,
296.     user_id             TEXT NOT NULL REFERENCES users(id),
297.     current_streak      INTEGER DEFAULT 0,
298.     best_streak         INTEGER DEFAULT 0,
299.     last_study_date     TEXT,               -- YYYY-MM-DD
300.     streak_3_claimed    INTEGER DEFAULT 0,  -- milestone booleans
301.     streak_7_claimed    INTEGER DEFAULT 0,
302.     streak_14_claimed   INTEGER DEFAULT 0,
303.     streak_30_claimed   INTEGER DEFAULT 0,
304.     total_xp            INTEGER DEFAULT 0,  -- lifetime XP
305.     total_study_days    INTEGER DEFAULT 0,  -- lifetime study days
306.     UNIQUE(user_id)
307. );
308. ```
309. 
310. ### 3.6 Zone State
311. 
312. ```sql
313. -- Zone unlock and test state
314. CREATE TABLE zone_state (
315.     id              INTEGER PRIMARY KEY AUTOINCREMENT,
316.     user_id         TEXT NOT NULL REFERENCES users(id),
317.     zone_index      INTEGER NOT NULL,       -- 0-4
318.     unlocked        INTEGER DEFAULT 0,      -- boolean
319.     test_passed     INTEGER DEFAULT 0,      -- boolean
320.     test_attempts   INTEGER DEFAULT 0,      -- total attempts
321.     test_best_score REAL DEFAULT 0,         -- best accuracy
322.     unlocked_at     TEXT,                   -- ISO8601
323.     UNIQUE(user_id, zone_index)
324. );
325. ```
326. 
327. ---
328. 
329. ### 3.7 Canonical Enums
330. 
331. **`session_type`** (used in `review_log`, `session`, `session_state`, `day_state`):
332. - `morning` — regular morning session
333. - `evening` — regular evening session
334. - `recovery_evening` — missed evening recovery (F1)
335. - `catch_up` — missed 1-2 days recovery (F2)
336. - `re_entry` — missed 3+ days recovery (F3)
337. - `review_only` — back-pressure day (State G)
338. - `zone_test` — zone unlock test
339. - `bonus` — optional bonus practice
340. 
341. **`activity_type`** (used in `review_log`):
342. - `flashcard` — NOT used in V1 (flashcards don't write to review_log). Reserved for V2 exposure analytics.
343. - `image_game` — scored, +10 XP
344. - `quick_recall` — scored, +10 XP
345. - `sat_question` — scored, +10 XP
346. 
347. **`memory_status`** (used in `word_state`):
348. - `easy` — recent_accuracy >= 0.85, box >= 3, lapse_count == 0
349. - `normal` — default
350. - `fragile` — recent_accuracy < 0.6 or lapse_count >= 1
351. - `stubborn` — lapse_count >= 3 or consecutive_wrong >= 2
352. 
353. **`outcome`** (used in `review_log`):
354. - `correct`
355. - `incorrect`
356. 
357. ### 3.8 Field Name Conventions
358. 
359. Schema field names are **canonical**. Where design docs use different names:
360.
````

</details>


---

<sub>⏱️ 50s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/docs/data-schema.md.**

/Users/jiong/myprojects/satspell/docs/data-schema.md (lines 536-810)

<details>
<summary>275 lines</summary>

````
536. ### 5.1 First Launch
537. 
538. | Step | Action | Tables Written |
539. |------|--------|---------------|
540. | 1 | Create empty `data.db` with all table schemas | All CREATE TABLE statements |
541. | 2 | Import bundled content from JSON | `lists`, `words`, `word_list`, `sat_contexts`, `collocations`, `sat_question_bank`, `word_questions` — see content-delivery.md Section 2 |
542. | 3 | Create local user | `users` INSERT (id=UUID, supabase_uid=NULL) |
543. | 4 | Initialize streak | `streak_store` INSERT (current_streak=0) |
544. | 5 | Unlock Zone 1 | `zone_state` INSERT (zone_index=0, unlocked=1) |
545. | 6 | Create Day 0 state | `day_state` INSERT (study_day=0, zone_index=0) |
546. 
547. ### 5.2 Opening Practice Tab (every app launch)
548. 
549. | Step | Action | Tables Read | Logic |
550. |------|--------|-------------|-------|
551. | 1 | Determine current study day | `day_state` (latest) | Find most recent incomplete study day |
552. | 2 | Check for recovery needed | `day_state` (previous), `streak_store.last_study_date` | Compare calendar date gap to detect F1/F2/F3 |
553. | 3 | Check back-pressure | `word_state WHERE due_at <= now()` | COUNT overdue > 18 or > 30 |
554. | 4 | Check morning/evening state | `day_state.morning_complete`, `morning_complete_at` | Determine Practice tab state (A-H) |
555. | 5 | Check for paused session | `session_state WHERE is_paused=1` | If exists → State B (Resume) |
556. | 6 | Read streak + XP | `streak_store`, `daily_stats` | Header badge display |
557. 
558. ### 5.3 Starting a Session
559. 
560. | Step | Action | Tables Written |
561. |------|--------|---------------|
562. | 1 | Create session record | `session` INSERT (session_type, study_day, started_at) |
563. | 2 | Create session_state | `session_state` INSERT (session_type, study_day, step_index=0) |
564. | 3 | Load words for this session | — |
565. 
566. **Loading words (Tables Read):**
567. 
568. | Session Type | Read From | Logic |
569. |-------------|-----------|-------|
570. | Morning (new words) | `word_list` + `words` | Sequential: offset = study_day × daily_new_count |
571. | Morning (review words for game) | `word_state WHERE due_at <= now()` | Priority: box_level ASC, memory_status priority |
572. | Evening (new words) | `word_list` + `words` | Next batch after morning |
573. | Evening (quick recall) | `word_state WHERE intro_stage=1` | This morning's words |
574. | Evening (review words) | `word_state WHERE due_at <= now()` | Same priority as morning |
575. | Recovery | `word_state` for previous day's words | Words from missed day |
576. | Zone test | `word_state` for current zone | Sample from zone's word range |
577. 
578. ### 5.4 During Flashcard Step (Step 1 — Exposure Only)
579. 
580. | Event | Tables Written | Fields Updated |
581. |-------|---------------|----------------|
582. | Card shown (first time) | `word_state` UPSERT | `intro_stage = 1` (if morning, new word), `total_seen += 1` |
583. | "Show Again" tapped | `session_state` UPDATE | `show_again_ids` append word_id, `requeued_ids` append word_id |
584. | "Got It" tapped | (nothing — exposure only) | — |
585. | "Word unlocked" (first Got It ever) | `word_state` UPDATE | `box_level = 0 → 0` (stays 0, not yet scored) |
586. 
587. **No review_log entry for flashcards.** No XP. No box changes.
588. 
589. ### 5.5 During Scored Step (Image Game / Quick Recall / SAT)
590. 
591. | Event | Tables Written | Fields Updated |
592. |-------|---------------|----------------|
593. | **Correct answer** | `review_log` INSERT | outcome='correct', activity_type, session_type, study_day, duration_ms |
594. | | `word_state` UPDATE | `total_correct += 1`, `total_seen += 1`, `day_touches += 1`, `consecutive_wrong = 0` |
595. | | `word_state` UPDATE | `recent_accuracy` = recalculate from last N reviews |
596. | | `word_state` UPDATE | `memory_status` = classifyMemoryStatus(word) |
597. | | `daily_stats` UPDATE | `correct_count += 1`, `total_count += 1`, `xp_earned += 10` |
598. | | `session` UPDATE | `items_correct += 1`, `xp_earned += 10` |
599. | **Wrong answer** | `review_log` INSERT | outcome='incorrect', same fields |
600. | | `word_state` UPDATE | `total_seen += 1`, `day_touches += 1`, `consecutive_wrong += 1` |
601. | | If `box_level > 1`: | `word_state` UPDATE: `box_level = 1`, `due_at = tomorrow`, `lapse_count += 1` |
602. | | `word_state` UPDATE | `recent_accuracy` recalculate, `memory_status` reclassify |
603. | | `daily_stats` UPDATE | `total_count += 1`, `words_demoted += 1` (if box dropped) |
604. | **Rushed answer** (<1s game/recall, <3s SAT) | `review_log` INSERT | Logged but `day_touches` NOT incremented (doesn't count for promotion) |
605. | **Step advances** | `session_state` UPDATE | `step_index += 1`, `item_index = 0` |
606. | **Item advances** | `session_state` UPDATE | `item_index += 1` |
607. 
608. ### 5.6 classifyMemoryStatus() — When to Recalculate
609. 
610. Called after every scored answer. Updates `word_state.memory_status`.
611. 
612. ```
613. function classifyMemoryStatus(word):
614.     if word.lapse_count >= 3 or word.consecutive_wrong >= 2:
615.         return 'stubborn'
616.     if word.recent_accuracy < 0.6 or word.lapse_count >= 1:
617.         return 'fragile'
618.     if word.box_level >= 3 and word.recent_accuracy >= 0.85 and word.lapse_count == 0:
619.         return 'easy'
620.     return 'normal'
621. ```
622. 
623. ### 5.7 computeRecentAccuracy() — How to Calculate
624. 
625. ```
626. function computeRecentAccuracy(user_id, word_id):
627.     // Last 5 scored (non-superseded) reviews for this word
628.     results = SELECT outcome FROM review_log
629.               WHERE user_id=? AND word_id=?
630.               AND activity_type IN ('image_game', 'quick_recall', 'sat_question')
631.               AND superseded=0
632.               ORDER BY reviewed_at DESC LIMIT 5
633. 
634.     if results.count == 0: return 0.0
635.     correct = results.filter(r => r.outcome == 'correct').count
636.     return correct / results.count
637. ```
638. 
639. ### 5.8 Day 1 Promotion — End of Evening Session
640. 
641. Runs after the evening session's last step completes.
642. 
643. | Step | Action | Tables Read/Written |
644. |------|--------|-------------------|
645. | 1 | Find all words with `intro_stage = 1` (morning seen, evening not yet decided) | READ `word_state` |
646. | 2 | For each word, count scored correct today | READ `review_log WHERE study_day=current AND activity_type IN (image_game, quick_recall) AND superseded=0` |
647. | 3 | Check promotion rule: 2/3 correct + final recall correct | (computed) |
648. | 4 | If promoted: | WRITE `word_state`: `box_level=2, due_at=now()+3days, intro_stage=3` |
649. | 5 | If not promoted: | WRITE `word_state`: `box_level=1, due_at=tomorrow, intro_stage=3` |
650. | 6 | Update daily stats | WRITE `daily_stats`: `words_promoted += promoted_count` |
651. 
652. ### 5.9 Session Complete
653. 
654. | Step | Action | Tables Written |
655. |------|--------|---------------|
656. | 1 | Mark session done | `session` UPDATE: `ended_at=now()` |
657. | 2 | Mark session_state complete | `session_state` UPDATE: `completed_at=now(), is_paused=0` |
658. | 3 | Add session bonus XP | `daily_stats` UPDATE: `session_bonus += 30` |
659. | 4 | Update day_state | `day_state` UPDATE: `morning_complete=1, morning_complete_at=now()` (or evening equivalent) |
660. | 5 | Update streak | `streak_store` UPDATE: recalculate current_streak based on last_study_date |
661. | 6 | Check streak milestones | `streak_store`: if streak=3 and streak_3_claimed=0 → `xp_earned += 20, streak_3_claimed=1` |
662. | 7 | If evening: run Day 1 promotion | See Section 5.8 above |
663. | 8 | Reset day_touches for tomorrow | `word_state` UPDATE: `day_touches=0` WHERE words were seen today (deferred to next morning) |
664. | 9 | Sync to Supabase (if signed in) | `vocab_progress_sync` INSERT |
665. 
666. ### 5.10 Pause / Resume
667. 
668. **Pause:**
669. 
670. | Step | Action | Tables Written |
671. |------|--------|---------------|
672. | 1 | Save current position | `session_state` UPDATE: `step_index, item_index, is_paused=1, paused_at=now()` |
673. | 2 | Save requeued cards | `session_state` UPDATE: `requeued_ids = [list of requeued word_ids]` |
674. | (review_log entries already written per-item — no batch needed) | | |
675. 
676. **Resume:**
677. 
678. | Step | Action | Tables Read |
679. |------|--------|-------------|
680. | 1 | Load session state | `session_state WHERE is_paused=1` |
681. | 2 | Navigate to step + item | Use `step_index`, `item_index` |
682. | 3 | Restore requeued cards | Read `requeued_ids`, `show_again_ids` |
683. | 4 | Continue | `session_state` UPDATE: `is_paused=0` |
684. 
685. ### 5.11 Restart (from Resume card)
686. 
687. | Step | Action | Tables Written |
688. |------|--------|---------------|
689. | 1 | Mark previous answers superseded | `review_log` UPDATE: `superseded=1` WHERE this session + study_day |
690. | 2 | Subtract superseded XP | `daily_stats` UPDATE: `xp_earned -= superseded_correct × 10` |
691. | 3 | Reset session_state | `session_state` UPDATE: `step_index=0, item_index=0, requeued_ids=NULL, show_again_ids=NULL` |
692. | 4 | Reset word day_touches | `word_state` UPDATE: `day_touches=0` for affected words |
693. 
694. ### 5.12 Box Progression — When Words Move
695. 
696. | Event | Box Change | due_at Update | When |
697. |-------|-----------|---------------|------|
698. | New word first introduced | 0 → stays 0 | NULL | Flashcard step (exposure, not scored) |
699. | Day 1 promotion (2/3 + final correct) | 0 → 2 | now + 3 days | End of evening session |
700. | Day 1 no promotion | 0 → 1 | tomorrow | End of evening session |
701. | Correct answer (review) | N → N+1 | now + interval[N+1] | During scored step, per answer |
702. | Wrong answer (any box > 0) | N → 1 | tomorrow | During scored step, per answer |
703. | Wrong answer (already box 1) | stays 1 | tomorrow | During scored step |
704. 
705. **Box intervals:** 1→1day, 2→3days, 3→7days, 4→14days, 5→no review
706. 
707. ### 5.13 New Device Sync
708. 
709. | Step | Action | Tables Read/Written |
710. |------|--------|-------------------|
711. | 1 | Sign in via Supabase Auth | — |
712. | 2 | Pull latest sync | READ Supabase `vocab_progress_sync` (latest by synced_at) |
713. | 3 | Parse sync_data JSON | — |
714. | 4 | Hydrate SQLite tables | WRITE: `word_state`, `day_state`, `streak_store`, `zone_state`, `daily_stats` (bulk insert) |
715. | 5 | Continue studying | — |
716. 
717. ### 5.14 Optional Sign-Up
718. 
719. | Step | Action | Tables Written |
720. |------|--------|---------------|
721. | 1 | Student taps "Sign Up" | — |
722. | 2 | Supabase auth.users created | Supabase `auth.users` |
723. | 3 | Profile created | Supabase `user_profiles` INSERT |
724. | 4 | Link accounts | SQLite `users` UPDATE: `supabase_uid = auth.users.id` |
725. | 5 | First sync | Supabase `vocab_progress_sync` INSERT (full local snapshot) |
726. 
727. ---
728. 
729. ## 6. Key Queries
730. 
731. ### Get Review Queue (Priority Order)
732. 
733. ```sql
734. SELECT ws.word_id, ws.box_level, ws.memory_status, ws.due_at,
735.        w.lemma, w.pos, w.definition, w.example, w.image_filename
736. FROM word_state ws
737. JOIN words w ON w.id = ws.word_id
738. WHERE ws.user_id = ?
739.   AND ws.due_at <= datetime('now')
740.   AND ws.box_level > 0
741. ORDER BY
742.   ws.box_level ASC,                    -- Box 1 first (most urgent)
743.   CASE ws.memory_status
744.     WHEN 'stubborn' THEN 0
745.     WHEN 'fragile' THEN 1
746.     WHEN 'normal' THEN 2
747.     WHEN 'easy' THEN 3
748.   END ASC,
749.   ws.due_at ASC                        -- oldest due first
750. LIMIT ?;
751. ```
752. 
753. ### Day 1 Promotion Check
754. 
755. ```sql
756. -- After evening session: check if word qualifies for Box 2
757. SELECT ws.word_id, ws.day_touches,
758.   (SELECT COUNT(*) FROM review_log rl
759.    WHERE rl.word_id = ws.word_id
760.      AND rl.user_id = ws.user_id
761.      AND rl.study_day = ?
762.      AND rl.activity_type IN ('image_game', 'quick_recall')
763.      AND rl.outcome = 'correct'
764.      AND rl.superseded = 0
765.   ) as scored_correct,
766.   (SELECT COUNT(*) FROM review_log rl
767.    WHERE rl.word_id = ws.word_id
768.      AND rl.user_id = ws.user_id
769.      AND rl.study_day = ?
770.      AND rl.activity_type IN ('image_game', 'quick_recall')
771.      AND rl.superseded = 0
772.   ) as scored_total
773. FROM word_state ws
774. WHERE ws.user_id = ?
775.   AND ws.intro_stage = 2;    -- evening recall done, ready for promotion decision
776. ```
777. 
778. ### Daily Stats Summary
779. 
780. ```sql
781. SELECT
782.   ds.xp_earned + ds.session_bonus as total_xp,
783.   ds.correct_count,
784.   ds.total_count,
785.   CASE WHEN ds.total_count > 0
786.     THEN ROUND(ds.correct_count * 100.0 / ds.total_count)
787.     ELSE 0
788.   END as accuracy_pct,
789.   ds.new_count,
790.   ds.review_count,
791.   ds.words_promoted,
792.   ds.words_demoted,
793.   ds.study_minutes
794. FROM daily_stats ds
795. WHERE ds.user_id = ? AND ds.study_day = ?;
796. ```
797. 
798. ### Word Strength Distribution (Stats Tab)
799. 
800. ```sql
801. SELECT
802.   box_level,
803.   COUNT(*) as word_count
804. FROM word_state
805. WHERE user_id = ? AND box_level > 0
806. GROUP BY box_level
807. ORDER BY box_level;
808. ```
809. 
810. ### Words Fighting Back (memory_status = stubborn)
````

</details>


---

<sub>⏱️ 50s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Models/Enums.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Models/Enums.swift

<details>
<summary>70 lines</summary>

```
1. import Foundation
2. 
3. enum SessionType: String, Codable, Identifiable {
4.     var id: String { rawValue }
5.     case morning
6.     case evening
7.     case recoveryEvening = "recovery_evening"
8.     case catchUp = "catch_up"
9.     case reEntry = "re_entry"
10.     case reviewOnly = "review_only"
11.     case zoneTest = "zone_test"
12.     case bonus
13. }
14. 
15. enum ActivityType: String, Codable {
16.     case imageGame = "image_game"
17.     case quickRecall = "quick_recall"
18.     case satQuestion = "sat_question"
19. }
20. 
21. enum MemoryStatus: String, Codable {
22.     case easy, normal, fragile, stubborn
23. }
24. 
25. enum CardState {
26.     case pending, current, completed, requeued
27. }
28. 
29. enum WordStrength: Int, CaseIterable {
30.     case notIntroduced = 0
31.     case lockedIn = 1
32.     case rising = 2
33.     case strong = 3
34.     case solid = 4
35.     case mastered = 5
36. 
37.     var label: String {
38.         switch self {
39.         case .notIntroduced: return ""
40.         case .lockedIn: return "Locked In"
41.         case .rising: return "Rising"
42.         case .strong: return "Strong"
43.         case .solid: return "Solid"
44.         case .mastered: return "Mastered"
45.         }
46.     }
47. 
48.     var reviewIntervalDays: Int? {
49.         switch self {
50.         case .notIntroduced: return nil
51.         case .lockedIn: return 1
52.         case .rising: return 3
53.         case .strong: return 7
54.         case .solid: return 14
55.         case .mastered: return nil
56.         }
57.     }
58. 
59.     var colorHex: String {
60.         switch self {
61.         case .notIntroduced: return "#E8ECF0"
62.         case .lockedIn: return "#FF7043"
63.         case .rising: return "#FFAB40"
64.         case .strong: return "#FFC800"
65.         case .solid: return "#89E219"
66.         case .mastered: return "#58CC02"
67.         }
68.     }
69. }
70.
```

</details>


---

<sub>⏱️ 50s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Models/Models.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Models/Models.swift

<details>
<summary>157 lines</summary>

```
1. import Foundation
2. 
3. struct VocabCard: Identifiable, Hashable {
4.     let id: Int
5.     let lemma: String
6.     let pos: String?
7.     let definition: String?
8.     let example: String?
9.     let imageFilename: String?
10. 
11.     var satContext: String? = nil
12.     var collocations: [String]? = nil
13. }
14. 
15. struct ListInfo: Identifiable, Hashable {
16.     let id: Int
17.     let name: String
18.     let description: String?
19.     let version: Int
20. }
21. 
22. enum ReviewOutcome: String {
23.     case correct
24.     case incorrect
25.     case skip
26. }
27. 
28. struct SatQuestion: Identifiable, Hashable {
29.     let id: String
30.     let wordId: Int?
31.     let targetWord: String?
32.     let section: String?
33.     let module: Int?
34.     let qType: String?
35.     let passage: String?
36.     let question: String?
37.     let optionA: String?
38.     let optionB: String?
39.     let optionC: String?
40.     let optionD: String?
41.     let answer: String?
42.     let sourcePdf: String?
43.     let page: Int?
44.     let feedbackGenerated: Int
45.     let answerVerified: Int
46. 
47.     // DeepSeek feedback (optional, may be missing for some questions)
48.     let deepseekAnswer: String?
49.     let deepseekBackground: String?
50.     let deepseekReason: String?
51. }
52. 
53. struct ProgressSnapshot: Hashable {
54.     let userId: String
55.     let listId: Int
56.     let masteredCount: Int
57.     let totalSeen: Int
58.     let streakDays: Int
59.     let lastReviewedAt: Date?
60.     let version: Int
61. }
62. 
63. // MARK: - Learning State Models
64. 
65. struct WordState: Identifiable, Hashable {
66.     let id: Int
67.     let userId: String
68.     let wordId: Int
69.     var boxLevel: Int
70.     var dueAt: Date?
71.     var introStage: Int
72.     var memoryStatus: MemoryStatus
73.     var lapseCount: Int
74.     var consecutiveWrong: Int
75.     var totalCorrect: Int
76.     var totalSeen: Int
77.     var dayTouches: Int
78.     var recentAccuracy: Double
79.     var lastReviewedAt: Date?
80. 
81.     var strength: WordStrength {
82.         WordStrength(rawValue: boxLevel) ?? .notIntroduced
83.     }
84. }
85. 
86. struct DayState: Identifiable, Hashable {
87.     let id: Int
88.     let userId: String
89.     let studyDay: Int
90.     let zoneIndex: Int
91.     var morningComplete: Bool
92.     var eveningComplete: Bool
93.     var morningCompleteAt: Date?
94.     var eveningCompleteAt: Date?
95.     var newWordsMorning: Int
96.     var newWordsEvening: Int
97.     var morningAccuracy: Double
98.     var eveningAccuracy: Double
99.     var morningXP: Int
100.     var eveningXP: Int
101.     var isRecoveryDay: Bool
102.     var isReviewOnlyDay: Bool
103. }
104. 
105. struct SessionState: Identifiable, Hashable {
106.     let id: Int
107.     let userId: String
108.     let sessionType: SessionType
109.     let studyDay: Int
110.     var stepIndex: Int
111.     var itemIndex: Int
112.     var isPaused: Bool
113.     var showAgainIds: [Int]
114.     var requeuedIds: [Int]
115.     var startedAt: Date?
116.     var pausedAt: Date?
117.     var completedAt: Date?
118. }
119. 
120. struct DailyStats: Identifiable, Hashable {
121.     let id: Int
122.     let userId: String
123.     let studyDay: Int
124.     let calendarDate: String
125.     var newCount: Int
126.     var reviewCount: Int
127.     var correctCount: Int
128.     var totalCount: Int
129.     var xpEarned: Int
130.     var sessionBonus: Int
131.     var studyMinutes: Double
132.     var wordsPromoted: Int
133.     var wordsDemoted: Int
134. }
135. 
136. struct StreakInfo: Hashable {
137.     var currentStreak: Int
138.     var bestStreak: Int
139.     var lastStudyDate: String?
140.     var totalXP: Int
141.     var totalStudyDays: Int
142.     var streak3Claimed: Bool
143.     var streak7Claimed: Bool
144.     var streak14Claimed: Bool
145.     var streak30Claimed: Bool
146. }
147. 
148. struct ZoneState: Identifiable, Hashable {
149.     let id: Int
150.     let userId: String
151.     let zoneIndex: Int
152.     var unlocked: Bool
153.     var testPassed: Bool
154.     var testAttempts: Int
155.     var testBestScore: Double
156. }
157.
```

</details>


---

<sub>⏱️ 50s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SchemaV2.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SchemaV2.swift

<details>
<summary>300 lines</summary>

```
1. import Foundation
2. 
3. /// Complete SQLite schema DDL for SAT Vocab V2.
4. /// Covers all 17 tables: content (bundled), user/log (modified), and new learning-state tables.
5. enum SchemaV2 {
6. 
7.     // MARK: - CREATE TABLE statements (17 tables)
8. 
9.     static let createStatements: [String] = [
10. 
11.         // ── Content tables (read-only, bundled) ──
12. 
13.         """
14.         CREATE TABLE IF NOT EXISTS lists (
15.             id          INTEGER PRIMARY KEY,
16.             name        TEXT NOT NULL,
17.             description TEXT,
18.             version     INTEGER DEFAULT 1
19.         )
20.         """,
21. 
22.         """
23.         CREATE TABLE IF NOT EXISTS words (
24.             id              INTEGER PRIMARY KEY,
25.             lemma           TEXT NOT NULL,
26.             pos             TEXT,
27.             definition      TEXT,
28.             example         TEXT,
29.             image_filename  TEXT
30.         )
31.         """,
32. 
33.         """
34.         CREATE TABLE IF NOT EXISTS word_list (
35.             id      INTEGER PRIMARY KEY,
36.             word_id INTEGER NOT NULL REFERENCES words(id),
37.             list_id INTEGER NOT NULL REFERENCES lists(id),
38.             rank    INTEGER
39.         )
40.         """,
41. 
42.         """
43.         CREATE TABLE IF NOT EXISTS sat_contexts (
44.             id      INTEGER PRIMARY KEY,
45.             word_id INTEGER NOT NULL REFERENCES words(id),
46.             context TEXT NOT NULL
47.         )
48.         """,
49. 
50.         """
51.         CREATE TABLE IF NOT EXISTS collocations (
52.             id      INTEGER PRIMARY KEY,
53.             word_id INTEGER NOT NULL REFERENCES words(id),
54.             phrase  TEXT NOT NULL
55.         )
56.         """,
57. 
58.         """
59.         CREATE TABLE IF NOT EXISTS sat_question_bank (
60.             id                 TEXT PRIMARY KEY,
61.             word_id            INTEGER,
62.             target_word        TEXT,
63.             section            TEXT,
64.             module             INTEGER,
65.             q_type             TEXT,
66.             passage            TEXT,
67.             question           TEXT,
68.             option_a           TEXT,
69.             option_b           TEXT,
70.             option_c           TEXT,
71.             option_d           TEXT,
72.             answer             TEXT,
73.             source_pdf         TEXT,
74.             page               INTEGER,
75.             feedback_generated INTEGER DEFAULT 0,
76.             answer_verified    INTEGER DEFAULT 0
77.         )
78.         """,
79. 
80.         """
81.         CREATE TABLE IF NOT EXISTS word_questions (
82.             id          INTEGER PRIMARY KEY,
83.             word_id     INTEGER NOT NULL REFERENCES words(id),
84.             question_id TEXT NOT NULL REFERENCES sat_question_bank(id)
85.         )
86.         """,
87. 
88.         """
89.         CREATE TABLE IF NOT EXISTS deepseek_sat_feedback (
90.             id                INTEGER PRIMARY KEY,
91.             question_id       TEXT REFERENCES sat_question_bank(id),
92.             ai_source         TEXT,
93.             answer            TEXT,
94.             background        TEXT,
95.             reason_for_answer TEXT,
96.             created_at        TEXT
97.         )
98.         """,
99. 
100.         // ── User / identity ──
101. 
102.         """
103.         CREATE TABLE IF NOT EXISTS users (
104.             id           TEXT PRIMARY KEY,
105.             email        TEXT,
106.             supabase_uid TEXT,
107.             display_name TEXT,
108.             created_at   TEXT DEFAULT (datetime('now'))
109.         )
110.         """,
111. 
112.         // ── Learning-state tables (new) ──
113. 
114.         """
115.         CREATE TABLE IF NOT EXISTS word_state (
116.             id                INTEGER PRIMARY KEY AUTOINCREMENT,
117.             user_id           TEXT NOT NULL REFERENCES users(id),
118.             word_id           INTEGER NOT NULL REFERENCES words(id),
119.             box_level         INTEGER NOT NULL DEFAULT 0,
120.             due_at            TEXT,
121.             intro_stage       INTEGER DEFAULT 0,
122.             memory_status     TEXT DEFAULT 'normal',
123.             lapse_count       INTEGER DEFAULT 0,
124.             consecutive_wrong INTEGER DEFAULT 0,
125.             total_correct     INTEGER DEFAULT 0,
126.             total_seen        INTEGER DEFAULT 0,
127.             day_touches       INTEGER DEFAULT 0,
128.             recent_accuracy   REAL DEFAULT 0,
129.             last_reviewed_at  TEXT,
130.             created_at        TEXT DEFAULT (datetime('now')),
131.             updated_at        TEXT DEFAULT (datetime('now')),
132.             UNIQUE(user_id, word_id)
133.         )
134.         """,
135. 
136.         """
137.         CREATE TABLE IF NOT EXISTS day_state (
138.             id                  INTEGER PRIMARY KEY AUTOINCREMENT,
139.             user_id             TEXT NOT NULL REFERENCES users(id),
140.             study_day           INTEGER NOT NULL,
141.             zone_index          INTEGER NOT NULL,
142.             morning_complete    INTEGER DEFAULT 0,
143.             evening_complete    INTEGER DEFAULT 0,
144.             morning_complete_at TEXT,
145.             evening_complete_at TEXT,
146.             new_words_morning   INTEGER DEFAULT 0,
147.             new_words_evening   INTEGER DEFAULT 0,
148.             morning_accuracy    REAL DEFAULT 0,
149.             evening_accuracy    REAL DEFAULT 0,
150.             morning_xp          INTEGER DEFAULT 0,
151.             evening_xp          INTEGER DEFAULT 0,
152.             is_recovery_day     INTEGER DEFAULT 0,
153.             is_review_only_day  INTEGER DEFAULT 0,
154.             created_at          TEXT DEFAULT (datetime('now')),
155.             UNIQUE(user_id, study_day)
156.         )
157.         """,
158. 
159.         """
160.         CREATE TABLE IF NOT EXISTS session_state (
161.             id             INTEGER PRIMARY KEY AUTOINCREMENT,
162.             user_id        TEXT NOT NULL REFERENCES users(id),
163.             session_type   TEXT NOT NULL,
164.             study_day      INTEGER NOT NULL,
165.             step_index     INTEGER DEFAULT 0,
166.             item_index     INTEGER DEFAULT 0,
167.             is_paused      INTEGER DEFAULT 0,
168.             show_again_ids TEXT,
169.             requeued_ids   TEXT,
170.             started_at     TEXT,
171.             paused_at      TEXT,
172.             completed_at   TEXT,
173.             UNIQUE(user_id, study_day, session_type)
174.         )
175.         """,
176. 
177.         """
178.         CREATE TABLE IF NOT EXISTS review_log (
179.             id            INTEGER PRIMARY KEY AUTOINCREMENT,
180.             user_id       TEXT NOT NULL REFERENCES users(id),
181.             word_id       INTEGER NOT NULL REFERENCES words(id),
182.             list_id       INTEGER,
183.             outcome       TEXT NOT NULL,
184.             duration_ms   INTEGER,
185.             reviewed_at   TEXT NOT NULL,
186.             device_id     TEXT,
187.             activity_type TEXT,
188.             session_type  TEXT,
189.             study_day     INTEGER,
190.             superseded    INTEGER DEFAULT 0
191.         )
192.         """,
193. 
194.         """
195.         CREATE TABLE IF NOT EXISTS session (
196.             id            INTEGER PRIMARY KEY AUTOINCREMENT,
197.             user_id       TEXT NOT NULL,
198.             list_id       INTEGER,
199.             started_at    TEXT,
200.             ended_at      TEXT,
201.             items_total   INTEGER,
202.             items_correct INTEGER DEFAULT 0,
203.             session_type  TEXT,
204.             study_day     INTEGER,
205.             xp_earned     INTEGER DEFAULT 0
206.         )
207.         """,
208. 
209.         """
210.         CREATE TABLE IF NOT EXISTS daily_stats (
211.             id             INTEGER PRIMARY KEY AUTOINCREMENT,
212.             user_id        TEXT NOT NULL REFERENCES users(id),
213.             study_day      INTEGER NOT NULL,
214.             calendar_date  TEXT NOT NULL,
215.             new_count      INTEGER DEFAULT 0,
216.             review_count   INTEGER DEFAULT 0,
217.             correct_count  INTEGER DEFAULT 0,
218.             total_count    INTEGER DEFAULT 0,
219.             xp_earned      INTEGER DEFAULT 0,
220.             session_bonus  INTEGER DEFAULT 0,
221.             study_minutes  REAL DEFAULT 0,
222.             words_promoted INTEGER DEFAULT 0,
223.             words_demoted  INTEGER DEFAULT 0,
224.             UNIQUE(user_id, study_day)
225.         )
226.         """,
227. 
228.         """
229.         CREATE TABLE IF NOT EXISTS streak_store (
230.             id                INTEGER PRIMARY KEY AUTOINCREMENT,
231.             user_id           TEXT NOT NULL REFERENCES users(id),
232.             current_streak    INTEGER DEFAULT 0,
233.             best_streak       INTEGER DEFAULT 0,
234.             last_study_date   TEXT,
235.             streak_3_claimed  INTEGER DEFAULT 0,
236.             streak_7_claimed  INTEGER DEFAULT 0,
237.             streak_14_claimed INTEGER DEFAULT 0,
238.             streak_30_claimed INTEGER DEFAULT 0,
239.             total_xp          INTEGER DEFAULT 0,
240.             total_study_days  INTEGER DEFAULT 0,
241.             UNIQUE(user_id)
242.         )
243.         """,
244. 
245.         """
246.         CREATE TABLE IF NOT EXISTS zone_state (
247.             id              INTEGER PRIMARY KEY AUTOINCREMENT,
248.             user_id         TEXT NOT NULL REFERENCES users(id),
249.             zone_index      INTEGER NOT NULL,
250.             unlocked        INTEGER DEFAULT 0,
251.             test_passed     INTEGER DEFAULT 0,
252.             test_attempts   INTEGER DEFAULT 0,
253.             test_best_score REAL DEFAULT 0,
254.             unlocked_at     TEXT,
255.             UNIQUE(user_id, zone_index)
256.         )
257.         """,
258.     ]
259. 
260.     // MARK: - CREATE INDEX statements
261. 
262.     static let createIndexes: [String] = [
263.         // word_state
264.         "CREATE INDEX IF NOT EXISTS idx_word_state_due ON word_state(user_id, due_at)",
265.         "CREATE INDEX IF NOT EXISTS idx_word_state_box ON word_state(user_id, box_level)",
266.         "CREATE INDEX IF NOT EXISTS idx_word_state_status ON word_state(user_id, memory_status)",
267. 
268.         // day_state
269.         "CREATE INDEX IF NOT EXISTS idx_day_state_user ON day_state(user_id, study_day DESC)",
270. 
271.         // review_log
272.         "CREATE INDEX IF NOT EXISTS idx_review_log_word ON review_log(word_id, user_id, reviewed_at DESC)",
273.         "CREATE INDEX IF NOT EXISTS idx_review_log_day ON review_log(user_id, study_day)",
274.         "CREATE INDEX IF NOT EXISTS idx_review_log_scored ON review_log(user_id, word_id, activity_type, superseded, reviewed_at DESC)",
275. 
276.         // content tables
277.         "CREATE INDEX IF NOT EXISTS idx_word_list_rank ON word_list(list_id, rank)",
278.         "CREATE INDEX IF NOT EXISTS idx_sat_contexts_word ON sat_contexts(word_id)",
279.         "CREATE INDEX IF NOT EXISTS idx_collocations_word ON collocations(word_id)",
280.         "CREATE INDEX IF NOT EXISTS idx_word_questions_word ON word_questions(word_id)",
281.         "CREATE UNIQUE INDEX IF NOT EXISTS idx_word_questions_unique ON word_questions(word_id, question_id)",
282. 
283.         // daily_stats
284.         "CREATE INDEX IF NOT EXISTS idx_daily_stats_date ON daily_stats(user_id, calendar_date DESC)",
285.     ]
286. 
287.     // MARK: - Apply all
288. 
289.     /// Creates all tables and indexes. Safe to call multiple times (IF NOT EXISTS).
290.     static func createAll(db: SQLiteDB) throws {
291.         try db.exec("PRAGMA foreign_keys = ON")
292.         for sql in createStatements {
293.             try db.exec(sql)
294.         }
295.         for sql in createIndexes {
296.             try db.exec(sql)
297.         }
298.     }
299. }
300.
```

</details>


---

<sub>⏱️ 50s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/ContentImporter.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/ContentImporter.swift

<details>
<summary>235 lines</summary>

```
1. import Foundation
2. import SQLite3
3. 
4. // MARK: - Import errors
5. 
6. enum ImportError: Error, CustomStringConvertible {
7.     case bundleResourceNotFound(name: String)
8.     case jsonDecodingFailed(name: String, underlying: Error)
9.     case insertFailed(table: String, message: String)
10. 
11.     var description: String {
12.         switch self {
13.         case .bundleResourceNotFound(let n): return "Bundle resource not found: \(n)"
14.         case .jsonDecodingFailed(let n, let e): return "JSON decoding failed for \(n): \(e)"
15.         case .insertFailed(let t, let m): return "Insert into \(t) failed: \(m)"
16.         }
17.     }
18. }
19. 
20. // MARK: - JSON shapes
21. 
22. private struct WordEntry: Decodable {
23.     let word: String
24.     let pos: String?
25.     let definition: String?
26.     let example: String?
27.     let sat_context: [String]?
28.     let collocation: [String]?
29.     let sat_questions: [EmbeddedQuestion]?
30. }
31. 
32. private struct EmbeddedQuestion: Decodable {
33.     let id: String
34.     let section: String?
35.     let module: Int?
36.     let type: String?
37.     let passage: String?
38.     let question: String?
39.     let options: QuestionOptions?
40.     let answer: String?
41.     let source_pdf: String?
42.     let page: Int?
43. }
44. 
45. private enum QuestionOptions: Decodable {
46.     case array([String])
47.     case dict([String: String])
48. 
49.     init(from decoder: Decoder) throws {
50.         if let arr = try? decoder.singleValueContainer().decode([String].self) {
51.             self = .array(arr)
52.         } else if let dict = try? decoder.singleValueContainer().decode([String: String].self) {
53.             self = .dict(dict)
54.         } else {
55.             self = .array([])
56.         }
57.     }
58. 
59.     var abcd: (String?, String?, String?, String?) {
60.         switch self {
61.         case .array(let a):
62.             return (a.indices.contains(0) ? a[0] : nil,
63.                     a.indices.contains(1) ? a[1] : nil,
64.                     a.indices.contains(2) ? a[2] : nil,
65.                     a.indices.contains(3) ? a[3] : nil)
66.         case .dict(let d):
67.             return (d["A"] ?? d["a"], d["B"] ?? d["b"], d["C"] ?? d["c"], d["D"] ?? d["d"])
68.         }
69.     }
70. }
71. 
72. private struct StandaloneQuestion: Decodable {
73.     let id: String
74.     let section: String?
75.     let module: Int?
76.     let type: String?
77.     let passage: String?
78.     let question: String?
79.     let options: QuestionOptions?
80.     let answer: String?
81.     let source_pdf: String?
82.     let page: Int?
83. }
84. 
85. // MARK: - ContentImporter
86. 
87. actor ContentImporter {
88. 
89.     /// Import bundled JSON content into the given SQLite database.
90.     /// Must be called AFTER SchemaV2.createAll(db:).
91.     static func importBundledContent(db: SQLiteDB) throws {
92.         // --- Load JSON data ---
93.         let words = try loadJSON([WordEntry].self, resource: "word_list", ext: "json")
94.         let standaloneQuestions = try loadJSON([StandaloneQuestion].self, resource: "sat_reading_questions_deduplicated", ext: "json")
95. 
96.         // --- Begin transaction ---
97.         try db.exec("BEGIN TRANSACTION")
98. 
99.         do {
100.             // 1. Insert list
101.             try insertRow(db: db, sql: "INSERT INTO lists(name, description, version) VALUES (?, ?, 1)",
102.                           bindings: [.text("sat_core_1"), .text("SAT Core Vocabulary List")])
103.             let listId = Int(db.lastInsertRowId())
104. 
105.             // 2. Insert words + word_list + sat_contexts + collocations + embedded questions
106.             // Track all question IDs already inserted to avoid duplicates
107.             var insertedQuestionIds = Set<String>()
108. 
109.             for (rank, entry) in words.enumerated() {
110.                 let imageFilename = entry.word.replacingOccurrences(of: " ", with: "_") + ".jpg"
111. 
112.                 // words
113.                 try insertRow(db: db, sql: "INSERT INTO words(lemma, pos, definition, example, image_filename) VALUES (?, ?, ?, ?, ?)",
114.                               bindings: [.text(entry.word), .textOpt(entry.pos), .textOpt(entry.definition), .textOpt(entry.example), .text(imageFilename)])
115.                 let wordId = Int(db.lastInsertRowId())
116. 
117.                 // word_list
118.                 try insertRow(db: db, sql: "INSERT INTO word_list(word_id, list_id, rank) VALUES (?, ?, ?)",
119.                               bindings: [.int(wordId), .int(listId), .int(rank)])
120. 
121.                 // sat_contexts
122.                 if let contexts = entry.sat_context {
123.                     for ctx in contexts {
124.                         try insertRow(db: db, sql: "INSERT INTO sat_contexts(word_id, context) VALUES (?, ?)",
125.                                       bindings: [.int(wordId), .text(ctx)])
126.                     }
127.                 }
128. 
129.                 // collocations
130.                 if let colls = entry.collocation {
131.                     for phrase in colls {
132.                         try insertRow(db: db, sql: "INSERT INTO collocations(word_id, phrase) VALUES (?, ?)",
133.                                       bindings: [.int(wordId), .text(phrase)])
134.                     }
135.                 }
136. 
137.                 // embedded sat_questions
138.                 if let questions = entry.sat_questions {
139.                     for q in questions {
140.                         if !insertedQuestionIds.contains(q.id) {
141.                             let opts = q.options?.abcd ?? (nil, nil, nil, nil)
142.                             try insertRow(db: db,
143.                                 sql: """
144.                                 INSERT INTO sat_question_bank(id, word_id, target_word, section, module, q_type, passage, question, option_a, option_b, option_c, option_d, answer, source_pdf, page)
145.                                 VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
146.                                 """,
147.                                 bindings: [
148.                                     .text(q.id), .int(wordId), .text(entry.word),
149.                                     .textOpt(q.section), .intOpt(q.module), .textOpt(q.type),
150.                                     .textOpt(q.passage), .textOpt(q.question),
151.                                     .textOpt(opts.0), .textOpt(opts.1), .textOpt(opts.2), .textOpt(opts.3),
152.                                     .textOpt(q.answer), .textOpt(q.source_pdf), .intOpt(q.page)
153.                                 ])
154.                             insertedQuestionIds.insert(q.id)
155.                         }
156. 
157.                         // word_questions link
158.                         try insertRow(db: db,
159.                             sql: "INSERT OR IGNORE INTO word_questions(word_id, question_id) VALUES (?, ?)",
160.                             bindings: [.int(wordId), .text(q.id)])
161.                     }
162.                 }
163.             }
164. 
165.             // 3. Insert standalone questions (sat_reading_questions_deduplicated.json)
166.             for q in standaloneQuestions {
167.                 if insertedQuestionIds.contains(q.id) { continue }
168.                 let opts = q.options?.abcd ?? (nil, nil, nil, nil)
169.                 try insertRow(db: db,
170.                     sql: """
171.                     INSERT INTO sat_question_bank(id, section, module, q_type, passage, question, option_a, option_b, option_c, option_d, answer, source_pdf, page)
172.                     VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
173.                     """,
174.                     bindings: [
175.                         .text(q.id),
176.                         .textOpt(q.section), .intOpt(q.module), .textOpt(q.type),
177.                         .textOpt(q.passage), .textOpt(q.question),
178.                         .textOpt(opts.0), .textOpt(opts.1), .textOpt(opts.2), .textOpt(opts.3),
179.                         .textOpt(q.answer), .textOpt(q.source_pdf), .intOpt(q.page)
180.                     ])
181.                 insertedQuestionIds.insert(q.id)
182.             }
183. 
184.             try db.exec("COMMIT")
185.         } catch {
186.             try? db.exec("ROLLBACK")
187.             throw error
188.         }
189.     }
190. 
191.     // MARK: - Helpers
192. 
193.     private enum BindValue {
194.         case text(String)
195.         case textOpt(String?)
196.         case int(Int)
197.         case intOpt(Int?)
198.     }
199. 
200.     private static func loadJSON<T: Decodable>(_ type: T.Type, resource: String, ext: String) throws -> T {
201.         guard let url = Bundle.main.url(forResource: resource, withExtension: ext) else {
202.             throw ImportError.bundleResourceNotFound(name: "\(resource).\(ext)")
203.         }
204.         let data = try Data(contentsOf: url)
205.         do {
206.             return try JSONDecoder().decode(T.self, from: data)
207.         } catch {
208.             throw ImportError.jsonDecodingFailed(name: "\(resource).\(ext)", underlying: error)
209.         }
210.     }
211. 
212.     private static func insertRow(db: SQLiteDB, sql: String, bindings: [BindValue]) throws {
213.         let stmt = try db.prepare(sql)
214.         defer { stmt?.finalize() }
215. 
216.         for (i, val) in bindings.enumerated() {
217.             let idx = Int32(i + 1)
218.             switch val {
219.             case .text(let s):
220.                 try SQLiteDB.bind(stmt, idx, s)
221.             case .textOpt(let s):
222.                 try SQLiteDB.bind(stmt, idx, s)
223.             case .int(let v):
224.                 try SQLiteDB.bind(stmt, idx, v)
225.             case .intOpt(let v):
226.                 try SQLiteDB.bind(stmt, idx, v)
227.             }
228.         }
229. 
230.         if sqlite3_step(stmt) != SQLITE_DONE {
231.             throw ImportError.insertFailed(table: sql, message: db.errorMessage())
232.         }
233.     }
234. }
235.
```

</details>


---

<sub>⏱️ 50s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/WordStateStore.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/WordStateStore.swift

<details>
<summary>452 lines</summary>

```
1. import Foundation
2. import SQLite3
3. 
4. // MARK: - BoxChange
5. 
6. enum BoxChange {
7.     case none
8.     case promoted(from: Int, to: Int)
9.     case demoted(from: Int, to: Int)
10. 
11.     var isMastery: Bool {
12.         switch self {
13.         case .promoted(_, let to): return to >= 5
14.         default: return false
15.         }
16.     }
17. }
18. 
19. // MARK: - WordStateStore
20. 
21. actor WordStateStore {
22.     private let db: SQLiteDB
23.     private let iso = ISO8601DateFormatter()
24. 
25.     init(db: SQLiteDB) {
26.         self.db = db
27.     }
28. 
29.     // MARK: - Read Methods
30. 
31.     func getWordState(userId: String, wordId: Int) throws -> WordState? {
32.         let sql = """
33.         SELECT id, user_id, word_id, box_level, due_at, intro_stage,
34.                memory_status, lapse_count, consecutive_wrong, total_correct,
35.                total_seen, day_touches, recent_accuracy, last_reviewed_at
36.         FROM word_state
37.         WHERE user_id = ? AND word_id = ?
38.         LIMIT 1;
39.         """
40.         let stmt = try db.prepare(sql)
41.         defer { stmt?.finalize() }
42.         try SQLiteDB.bind(stmt, 1, userId)
43.         try SQLiteDB.bind(stmt, 2, wordId)
44.         if sqlite3_step(stmt) == SQLITE_ROW {
45.             return parseWordState(stmt)
46.         }
47.         return nil
48.     }
49. 
50.     func getReviewQueue(userId: String, limit: Int) throws -> [WordState] {
51.         let nowStr = iso.string(from: Date())
52.         let sql = """
53.         SELECT id, user_id, word_id, box_level, due_at, intro_stage,
54.                memory_status, lapse_count, consecutive_wrong, total_correct,
55.                total_seen, day_touches, recent_accuracy, last_reviewed_at
56.         FROM word_state
57.         WHERE user_id = ? AND due_at <= ? AND box_level > 0
58.         ORDER BY box_level ASC,
59.                  CASE memory_status
60.                      WHEN 'stubborn' THEN 0
61.                      WHEN 'fragile' THEN 1
62.                      WHEN 'normal' THEN 2
63.                      WHEN 'easy' THEN 3
64.                      ELSE 4
65.                  END,
66.                  due_at ASC
67.         LIMIT ?;
68.         """
69.         let stmt = try db.prepare(sql)
70.         defer { stmt?.finalize() }
71.         try SQLiteDB.bind(stmt, 1, userId)
72.         try SQLiteDB.bind(stmt, 2, nowStr)
73.         try SQLiteDB.bind(stmt, 3, limit)
74. 
75.         var out: [WordState] = []
76.         while sqlite3_step(stmt) == SQLITE_ROW {
77.             out.append(parseWordState(stmt))
78.         }
79.         return out
80.     }
81. 
82.     func countOverdue(userId: String) throws -> Int {
83.         let nowStr = iso.string(from: Date())
84.         let sql = """
85.         SELECT COUNT(*) FROM word_state
86.         WHERE user_id = ? AND due_at <= ? AND box_level > 0;
87.         """
88.         let stmt = try db.prepare(sql)
89.         defer { stmt?.finalize() }
90.         try SQLiteDB.bind(stmt, 1, userId)
91.         try SQLiteDB.bind(stmt, 2, nowStr)
92.         if sqlite3_step(stmt) == SQLITE_ROW {
93.             return SQLiteDB.columnInt(stmt, 0)
94.         }
95.         return 0
96.     }
97. 
98.     func getBoxDistribution(userId: String) throws -> [Int: Int] {
99.         let sql = """
100.         SELECT box_level, COUNT(*) FROM word_state
101.         WHERE user_id = ?
102.         GROUP BY box_level;
103.         """
104.         let stmt = try db.prepare(sql)
105.         defer { stmt?.finalize() }
106.         try SQLiteDB.bind(stmt, 1, userId)
107. 
108.         var dist: [Int: Int] = [:]
109.         while sqlite3_step(stmt) == SQLITE_ROW {
110.             let box = SQLiteDB.columnInt(stmt, 0)
111.             let count = SQLiteDB.columnInt(stmt, 1)
112.             dist[box] = count
113.         }
114.         return dist
115.     }
116. 
117.     func getStubbornWords(userId: String, limit: Int) throws -> [(lemma: String, pos: String?, lapseCount: Int, boxLevel: Int)] {
118.         let sql = """
119.         SELECT w.lemma, w.pos, ws.lapse_count, ws.box_level
120.         FROM word_state ws
121.         JOIN words w ON w.id = ws.word_id
122.         WHERE ws.user_id = ? AND ws.memory_status = 'stubborn'
123.         ORDER BY ws.lapse_count DESC, ws.consecutive_wrong DESC
124.         LIMIT ?;
125.         """
126.         let stmt = try db.prepare(sql)
127.         defer { stmt?.finalize() }
128.         try SQLiteDB.bind(stmt, 1, userId)
129.         try SQLiteDB.bind(stmt, 2, limit)
130. 
131.         var out: [(lemma: String, pos: String?, lapseCount: Int, boxLevel: Int)] = []
132.         while sqlite3_step(stmt) == SQLITE_ROW {
133.             let lemma = SQLiteDB.columnText(stmt, 0) ?? ""
134.             let pos = SQLiteDB.columnText(stmt, 1)
135.             let lapse = SQLiteDB.columnInt(stmt, 2)
136.             let box = SQLiteDB.columnInt(stmt, 3)
137.             out.append((lemma: lemma, pos: pos, lapseCount: lapse, boxLevel: box))
138.         }
139.         return out
140.     }
141. 
142.     // MARK: - Write Methods
143. 
144.     func introduceWord(userId: String, wordId: Int) throws {
145.         let nowStr = iso.string(from: Date())
146.         let sql = """
147.         INSERT INTO word_state(user_id, word_id, box_level, intro_stage, total_seen, memory_status, created_at, updated_at)
148.         VALUES (?, ?, 0, 1, 1, 'normal', ?, ?)
149.         ON CONFLICT(user_id, word_id) DO UPDATE SET
150.             intro_stage = MAX(intro_stage, 1),
151.             total_seen = total_seen + 1,
152.             updated_at = excluded.updated_at;
153.         """
154.         let stmt = try db.prepare(sql)
155.         defer { stmt?.finalize() }
156.         try SQLiteDB.bind(stmt, 1, userId)
157.         try SQLiteDB.bind(stmt, 2, wordId)
158.         try SQLiteDB.bind(stmt, 3, nowStr)
159.         try SQLiteDB.bind(stmt, 4, nowStr)
160.         if sqlite3_step(stmt) != SQLITE_DONE {
161.             throw SQLiteError.stepFailed(message: db.errorMessage())
162.         }
163.     }
164. 
165.     func recordScoredAnswer(userId: String, wordId: Int, correct: Bool) throws -> BoxChange {
166.         // Fetch current state
167.         guard var ws = try getWordState(userId: userId, wordId: wordId) else {
168.             // Word not yet introduced; introduce it first
169.             try introduceWord(userId: userId, wordId: wordId)
170.             return .none
171.         }
172. 
173.         let oldBox = ws.boxLevel
174. 
175.         // Update box level
176.         if correct {
177.             ws.boxLevel = min(ws.boxLevel + 1, 5)
178.             ws.consecutiveWrong = 0
179.             ws.totalCorrect += 1
180.         } else {
181.             if ws.boxLevel > 0 {
182.                 ws.boxLevel = 1
183.             }
184.             ws.consecutiveWrong += 1
185.             if oldBox > ws.boxLevel {
186.                 ws.lapseCount += 1
187.             }
188.         }
189. 
190.         ws.totalSeen += 1
191.         ws.dayTouches += 1
192. 
193.         // Recalculate recent accuracy
194.         ws.recentAccuracy = try computeRecentAccuracy(userId: userId, wordId: wordId, includingCurrent: correct)
195. 
196.         // Classify memory status
197.         ws.memoryStatus = classifyMemoryStatus(ws)
198. 
199.         // Calculate due date based on new box level
200.         let now = Date()
201.         let nowStr = iso.string(from: now)
202.         let dueDate: Date?
203.         if let interval = WordStrength(rawValue: ws.boxLevel)?.reviewIntervalDays {
204.             dueDate = Calendar.current.date(byAdding: .day, value: interval, to: now)
205.         } else {
206.             dueDate = nil // box 0 or mastered (5)
207.         }
208.         let dueStr: String? = dueDate.map { iso.string(from: $0) }
209. 
210.         let sql = """
211.         UPDATE word_state SET
212.             box_level = ?,
213.             due_at = ?,
214.             memory_status = ?,
215.             lapse_count = ?,
216.             consecutive_wrong = ?,
217.             total_correct = ?,
218.             total_seen = ?,
219.             day_touches = ?,
220.             recent_accuracy = ?,
221.             last_reviewed_at = ?,
222.             updated_at = ?
223.         WHERE user_id = ? AND word_id = ?;
224.         """
225.         let stmt = try db.prepare(sql)
226.         defer { stmt?.finalize() }
227.         try SQLiteDB.bind(stmt, 1, ws.boxLevel)
228.         try SQLiteDB.bind(stmt, 2, dueStr)
229.         try SQLiteDB.bind(stmt, 3, ws.memoryStatus.rawValue)
230.         try SQLiteDB.bind(stmt, 4, ws.lapseCount)
231.         try SQLiteDB.bind(stmt, 5, ws.consecutiveWrong)
232.         try SQLiteDB.bind(stmt, 6, ws.totalCorrect)
233.         try SQLiteDB.bind(stmt, 7, ws.totalSeen)
234.         try SQLiteDB.bind(stmt, 8, ws.dayTouches)
235.         try SQLiteDB.bind(stmt, 9, ws.recentAccuracy)
236.         try SQLiteDB.bind(stmt, 10, nowStr)
237.         try SQLiteDB.bind(stmt, 11, nowStr)
238.         try SQLiteDB.bind(stmt, 12, userId)
239.         try SQLiteDB.bind(stmt, 13, wordId)
240.         if sqlite3_step(stmt) != SQLITE_DONE {
241.             throw SQLiteError.stepFailed(message: db.errorMessage())
242.         }
243. 
244.         // Determine box change
245.         if ws.boxLevel > oldBox {
246.             return .promoted(from: oldBox, to: ws.boxLevel)
247.         } else if ws.boxLevel < oldBox {
248.             return .demoted(from: oldBox, to: ws.boxLevel)
249.         }
250.         return .none
251.     }
252. 
253.     func runDay1Promotion(userId: String, studyDay: Int) throws -> (promoted: Int, notPromoted: Int) {
254.         // Find words with intro_stage IN (1,2) AND box_level = 0
255.         let findSQL = """
256.         SELECT word_id FROM word_state
257.         WHERE user_id = ? AND intro_stage IN (1, 2) AND box_level = 0;
258.         """
259.         let findStmt = try db.prepare(findSQL)
260.         defer { findStmt?.finalize() }
261.         try SQLiteDB.bind(findStmt, 1, userId)
262. 
263.         var wordIds: [Int] = []
264.         while sqlite3_step(findStmt) == SQLITE_ROW {
265.             wordIds.append(SQLiteDB.columnInt(findStmt, 0))
266.         }
267. 
268.         var promoted = 0
269.         var notPromoted = 0
270.         let now = Date()
271.         let nowStr = iso.string(from: now)
272. 
273.         for wordId in wordIds {
274.             // Count scored correct answers from review_log
275.             let countSQL = """
276.             SELECT
277.                 SUM(CASE WHEN outcome = 'correct' THEN 1 ELSE 0 END) AS correct_count,
278.                 COUNT(*) AS total_count
279.             FROM review_log
280.             WHERE user_id = ? AND word_id = ?
281.               AND activity_type IN ('image_game', 'quick_recall')
282.               AND superseded = 0;
283.             """
284.             let countStmt = try db.prepare(countSQL)
285.             defer { countStmt?.finalize() }
286.             try SQLiteDB.bind(countStmt, 1, userId)
287.             try SQLiteDB.bind(countStmt, 2, wordId)
288. 
289.             var correctCount = 0
290.             var totalCount = 0
291.             if sqlite3_step(countStmt) == SQLITE_ROW {
292.                 correctCount = SQLiteDB.columnInt(countStmt, 0)
293.                 totalCount = SQLiteDB.columnInt(countStmt, 1)
294.             }
295. 
296.             // Check if last recall was correct
297.             let lastSQL = """
298.             SELECT outcome FROM review_log
299.             WHERE user_id = ? AND word_id = ?
300.               AND activity_type IN ('image_game', 'quick_recall')
301.               AND superseded = 0
302.             ORDER BY reviewed_at DESC
303.             LIMIT 1;
304.             """
305.             let lastStmt = try db.prepare(lastSQL)
306.             defer { lastStmt?.finalize() }
307.             try SQLiteDB.bind(lastStmt, 1, userId)
308.             try SQLiteDB.bind(lastStmt, 2, wordId)
309. 
310.             var lastCorrect = false
311.             if sqlite3_step(lastStmt) == SQLITE_ROW {
312.                 let outcome = SQLiteDB.columnText(lastStmt, 0)
313.                 lastCorrect = (outcome == "correct")
314.             }
315. 
316.             // Rule: 2/3 correct AND last recall correct -> box 2, else -> box 1
317.             let meetsThreshold = totalCount >= 3 && correctCount >= 2 && lastCorrect
318.             let newBox: Int
319.             let dueDays: Int
320.             if meetsThreshold {
321.                 newBox = 2
322.                 dueDays = 3
323.                 promoted += 1
324.             } else {
325.                 newBox = 1
326.                 dueDays = 1
327.                 notPromoted += 1
328.             }
329. 
330.             let dueDate = Calendar.current.date(byAdding: .day, value: dueDays, to: now)!
331.             let dueStr = iso.string(from: dueDate)
332. 
333.             let updateSQL = """
334.             UPDATE word_state SET
335.                 box_level = ?,
336.                 due_at = ?,
337.                 intro_stage = 3,
338.                 updated_at = ?
339.             WHERE user_id = ? AND word_id = ?;
340.             """
341.             let updateStmt = try db.prepare(updateSQL)
342.             defer { updateStmt?.finalize() }
343.             try SQLiteDB.bind(updateStmt, 1, newBox)
344.             try SQLiteDB.bind(updateStmt, 2, dueStr)
345.             try SQLiteDB.bind(updateStmt, 3, nowStr)
346.             try SQLiteDB.bind(updateStmt, 4, userId)
347.             try SQLiteDB.bind(updateStmt, 5, wordId)
348.             if sqlite3_step(updateStmt) != SQLITE_DONE {
349.                 throw SQLiteError.stepFailed(message: db.errorMessage())
350.             }
351.         }
352. 
353.         return (promoted: promoted, notPromoted: notPromoted)
354.     }
355. 
356.     func resetDayTouches(userId: String) throws {
357.         let sql = "UPDATE word_state SET day_touches = 0 WHERE user_id = ?;"
358.         let stmt = try db.prepare(sql)
359.         defer { stmt?.finalize() }
360.         try SQLiteDB.bind(stmt, 1, userId)
361.         if sqlite3_step(stmt) != SQLITE_DONE {
362.             throw SQLiteError.stepFailed(message: db.errorMessage())
363.         }
364.     }
365. 
366.     // MARK: - Private Helpers
367. 
368.     private func computeRecentAccuracy(userId: String, wordId: Int, includingCurrent correct: Bool? = nil) throws -> Double {
369.         let sql = """
370.         SELECT outcome FROM review_log
371.         WHERE user_id = ? AND word_id = ?
372.           AND outcome IN ('correct', 'incorrect')
373.           AND superseded = 0
374.         ORDER BY reviewed_at DESC
375.         LIMIT 5;
376.         """
377.         let stmt = try db.prepare(sql)
378.         defer { stmt?.finalize() }
379.         try SQLiteDB.bind(stmt, 1, userId)
380.         try SQLiteDB.bind(stmt, 2, wordId)
381. 
382.         var outcomes: [Bool] = []
383.         while sqlite3_step(stmt) == SQLITE_ROW {
384.             let outcome = SQLiteDB.columnText(stmt, 0) ?? ""
385.             outcomes.append(outcome == "correct")
386.         }
387. 
388.         // If we have a current answer that hasn't been logged yet, prepend it
389.         if let current = correct {
390.             outcomes.insert(current, at: 0)
391.             if outcomes.count > 5 {
392.                 outcomes = Array(outcomes.prefix(5))
393.             }
394.         }
395. 
396.         guard !outcomes.isEmpty else { return 0.0 }
397.         let correctCount = outcomes.filter { $0 }.count
398.         return Double(correctCount) / Double(outcomes.count)
399.     }
400. 
401.     private func classifyMemoryStatus(_ ws: WordState) -> MemoryStatus {
402.         if ws.lapseCount >= 3 || ws.consecutiveWrong >= 2 {
403.             return .stubborn
404.         }
405.         if ws.recentAccuracy < 0.6 || ws.lapseCount >= 1 {
406.             return .fragile
407.         }
408.         if ws.boxLevel >= 3 && ws.recentAccuracy >= 0.85 && ws.lapseCount == 0 {
409.             return .easy
410.         }
411.         return .normal
412.     }
413. 
414.     private func parseWordState(_ stmt: OpaquePointer?) -> WordState {
415.         let id = SQLiteDB.columnInt(stmt, 0)
416.         let userId = SQLiteDB.columnText(stmt, 1) ?? ""
417.         let wordId = SQLiteDB.columnInt(stmt, 2)
418.         let boxLevel = SQLiteDB.columnInt(stmt, 3)
419.         let dueAtStr = SQLiteDB.columnText(stmt, 4)
420.         let introStage = SQLiteDB.columnInt(stmt, 5)
421.         let memStatusStr = SQLiteDB.columnText(stmt, 6) ?? "normal"
422.         let lapseCount = SQLiteDB.columnInt(stmt, 7)
423.         let consecutiveWrong = SQLiteDB.columnInt(stmt, 8)
424.         let totalCorrect = SQLiteDB.columnInt(stmt, 9)
425.         let totalSeen = SQLiteDB.columnInt(stmt, 10)
426.         let dayTouches = SQLiteDB.columnInt(stmt, 11)
427.         let recentAccuracy = SQLiteDB.columnDouble(stmt, 12)
428.         let lastReviewedStr = SQLiteDB.columnText(stmt, 13)
429. 
430.         let dueAt = dueAtStr.flatMap { iso.date(from: $0) }
431.         let lastReviewedAt = lastReviewedStr.flatMap { iso.date(from: $0) }
432.         let memoryStatus = MemoryStatus(rawValue: memStatusStr) ?? .normal
433. 
434.         return WordState(
435.             id: id,
436.             userId: userId,
437.             wordId: wordId,
438.             boxLevel: boxLevel,
439.             dueAt: dueAt,
440.             introStage: introStage,
441.             memoryStatus: memoryStatus,
442.             lapseCount: lapseCount,
443.             consecutiveWrong: consecutiveWrong,
444.             totalCorrect: totalCorrect,
445.             totalSeen: totalSeen,
446.             dayTouches: dayTouches,
447.             recentAccuracy: recentAccuracy,
448.             lastReviewedAt: lastReviewedAt
449.         )
450.     }
451. }
452.
```

</details>


---

<sub>⏱️ 50s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SessionStateStore.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SessionStateStore.swift

<details>
<summary>306 lines</summary>

```
1. import Foundation
2. import SQLite3
3. 
4. actor SessionStateStore {
5.     static let shared = SessionStateStore()
6. 
7.     private var db: SQLiteDB { DataManager.shared.db }
8. 
9.     private let iso = ISO8601DateFormatter()
10. 
11.     private init() {}
12. 
13.     // MARK: - Day State
14. 
15.     func getCurrentDayState(userId: String) throws -> DayState? {
16.         let db = self.db
17.         let sql = """
18.         SELECT id, user_id, study_day, zone_index, morning_complete, evening_complete,
19.                morning_complete_at, evening_complete_at, new_words_morning, new_words_evening,
20.                morning_accuracy, evening_accuracy, morning_xp, evening_xp,
21.                is_recovery_day, is_review_only_day
22.         FROM day_state
23.         WHERE user_id = ?
24.         ORDER BY study_day DESC
25.         LIMIT 1;
26.         """
27.         let stmt = try db.prepare(sql)
28.         defer { stmt?.finalize() }
29.         try SQLiteDB.bind(stmt, 1, userId)
30.         if sqlite3_step(stmt) == SQLITE_ROW {
31.             return parseDayState(stmt)
32.         }
33.         return nil
34.     }
35. 
36.     func getDayState(userId: String, studyDay: Int) throws -> DayState? {
37.         let db = self.db
38.         let sql = """
39.         SELECT id, user_id, study_day, zone_index, morning_complete, evening_complete,
40.                morning_complete_at, evening_complete_at, new_words_morning, new_words_evening,
41.                morning_accuracy, evening_accuracy, morning_xp, evening_xp,
42.                is_recovery_day, is_review_only_day
43.         FROM day_state
44.         WHERE user_id = ? AND study_day = ?
45.         LIMIT 1;
46.         """
47.         let stmt = try db.prepare(sql)
48.         defer { stmt?.finalize() }
49.         try SQLiteDB.bind(stmt, 1, userId)
50.         try SQLiteDB.bind(stmt, 2, studyDay)
51.         if sqlite3_step(stmt) == SQLITE_ROW {
52.             return parseDayState(stmt)
53.         }
54.         return nil
55.     }
56. 
57.     func getOrCreateDayState(userId: String, studyDay: Int, zoneIndex: Int) throws -> DayState {
58.         let db = self.db
59.         let insertSQL = """
60.         INSERT OR IGNORE INTO day_state(user_id, study_day, zone_index)
61.         VALUES (?, ?, ?);
62.         """
63.         let s1 = try db.prepare(insertSQL)
64.         defer { s1?.finalize() }
65.         try SQLiteDB.bind(s1, 1, userId)
66.         try SQLiteDB.bind(s1, 2, studyDay)
67.         try SQLiteDB.bind(s1, 3, zoneIndex)
68.         if sqlite3_step(s1) != SQLITE_DONE {
69.             throw SQLiteError.stepFailed(message: db.errorMessage())
70.         }
71. 
72.         guard let state = try getDayState(userId: userId, studyDay: studyDay) else {
73.             throw SQLiteError.stepFailed(message: "Failed to fetch day_state after insert")
74.         }
75.         return state
76.     }
77. 
78.     func markMorningComplete(userId: String, studyDay: Int, accuracy: Double, xp: Int, newWords: Int) throws {
79.         let db = self.db
80.         let sql = """
81.         UPDATE day_state
82.         SET morning_complete = 1,
83.             morning_complete_at = ?,
84.             morning_accuracy = ?,
85.             morning_xp = ?,
86.             new_words_morning = ?
87.         WHERE user_id = ? AND study_day = ?;
88.         """
89.         let stmt = try db.prepare(sql)
90.         defer { stmt?.finalize() }
91.         let now = iso.string(from: Date())
92.         try SQLiteDB.bind(stmt, 1, now)
93.         try SQLiteDB.bind(stmt, 2, accuracy)
94.         try SQLiteDB.bind(stmt, 3, xp)
95.         try SQLiteDB.bind(stmt, 4, newWords)
96.         try SQLiteDB.bind(stmt, 5, userId)
97.         try SQLiteDB.bind(stmt, 6, studyDay)
98.         if sqlite3_step(stmt) != SQLITE_DONE {
99.             throw SQLiteError.stepFailed(message: db.errorMessage())
100.         }
101.     }
102. 
103.     func markEveningComplete(userId: String, studyDay: Int, accuracy: Double, xp: Int, newWords: Int) throws {
104.         let db = self.db
105.         let sql = """
106.         UPDATE day_state
107.         SET evening_complete = 1,
108.             evening_complete_at = ?,
109.             evening_accuracy = ?,
110.             evening_xp = ?,
111.             new_words_evening = ?
112.         WHERE user_id = ? AND study_day = ?;
113.         """
114.         let stmt = try db.prepare(sql)
115.         defer { stmt?.finalize() }
116.         let now = iso.string(from: Date())
117.         try SQLiteDB.bind(stmt, 1, now)
118.         try SQLiteDB.bind(stmt, 2, accuracy)
119.         try SQLiteDB.bind(stmt, 3, xp)
120.         try SQLiteDB.bind(stmt, 4, newWords)
121.         try SQLiteDB.bind(stmt, 5, userId)
122.         try SQLiteDB.bind(stmt, 6, studyDay)
123.         if sqlite3_step(stmt) != SQLITE_DONE {
124.             throw SQLiteError.stepFailed(message: db.errorMessage())
125.         }
126.     }
127. 
128.     // MARK: - Session State
129. 
130.     func getActiveSession(userId: String) throws -> SessionState? {
131.         let db = self.db
132.         let sql = """
133.         SELECT id, user_id, session_type, study_day, step_index, item_index,
134.                is_paused, show_again_ids, requeued_ids, started_at, paused_at, completed_at
135.         FROM session_state
136.         WHERE user_id = ? AND is_paused = 1 AND completed_at IS NULL
137.         LIMIT 1;
138.         """
139.         let stmt = try db.prepare(sql)
140.         defer { stmt?.finalize() }
141.         try SQLiteDB.bind(stmt, 1, userId)
142.         if sqlite3_step(stmt) == SQLITE_ROW {
143.             return parseSessionState(stmt)
144.         }
145.         return nil
146.     }
147. 
148.     func createSession(userId: String, sessionType: SessionType, studyDay: Int) throws -> SessionState {
149.         let db = self.db
150.         let sql = """
151.         INSERT OR REPLACE INTO session_state(user_id, session_type, study_day, step_index, item_index,
152.             is_paused, show_again_ids, requeued_ids, started_at, paused_at, completed_at)
153.         VALUES (?, ?, ?, 0, 0, 0, '[]', '[]', ?, NULL, NULL);
154.         """
155.         let stmt = try db.prepare(sql)
156.         defer { stmt?.finalize() }
157.         let now = iso.string(from: Date())
158.         try SQLiteDB.bind(stmt, 1, userId)
159.         try SQLiteDB.bind(stmt, 2, sessionType.rawValue)
160.         try SQLiteDB.bind(stmt, 3, studyDay)
161.         try SQLiteDB.bind(stmt, 4, now)
162.         if sqlite3_step(stmt) != SQLITE_DONE {
163.             throw SQLiteError.stepFailed(message: db.errorMessage())
164.         }
165. 
166.         let rowId = Int(db.lastInsertRowId())
167.         return SessionState(
168.             id: rowId,
169.             userId: userId,
170.             sessionType: sessionType,
171.             studyDay: studyDay,
172.             stepIndex: 0,
173.             itemIndex: 0,
174.             isPaused: false,
175.             showAgainIds: [],
176.             requeuedIds: [],
177.             startedAt: Date(),
178.             pausedAt: nil,
179.             completedAt: nil
180.         )
181.     }
182. 
183.     func pauseSession(userId: String, studyDay: Int, sessionType: SessionType,
184.                        stepIndex: Int, itemIndex: Int,
185.                        showAgainIds: [Int], requeuedIds: [Int]) throws {
186.         let db = self.db
187.         let sql = """
188.         UPDATE session_state
189.         SET is_paused = 1,
190.             paused_at = ?,
191.             step_index = ?,
192.             item_index = ?,
193.             show_again_ids = ?,
194.             requeued_ids = ?
195.         WHERE user_id = ? AND study_day = ? AND session_type = ?;
196.         """
197.         let stmt = try db.prepare(sql)
198.         defer { stmt?.finalize() }
199.         let now = iso.string(from: Date())
200.         let showJSON = try encodeIntArray(showAgainIds)
201.         let reqJSON = try encodeIntArray(requeuedIds)
202.         try SQLiteDB.bind(stmt, 1, now)
203.         try SQLiteDB.bind(stmt, 2, stepIndex)
204.         try SQLiteDB.bind(stmt, 3, itemIndex)
205.         try SQLiteDB.bind(stmt, 4, showJSON)
206.         try SQLiteDB.bind(stmt, 5, reqJSON)
207.         try SQLiteDB.bind(stmt, 6, userId)
208.         try SQLiteDB.bind(stmt, 7, studyDay)
209.         try SQLiteDB.bind(stmt, 8, sessionType.rawValue)
210.         if sqlite3_step(stmt) != SQLITE_DONE {
211.             throw SQLiteError.stepFailed(message: db.errorMessage())
212.         }
213.     }
214. 
215.     func resumeSession(userId: String, studyDay: Int, sessionType: SessionType) throws {
216.         let db = self.db
217.         let sql = """
218.         UPDATE session_state
219.         SET is_paused = 0
220.         WHERE user_id = ? AND study_day = ? AND session_type = ?;
221.         """
222.         let stmt = try db.prepare(sql)
223.         defer { stmt?.finalize() }
224.         try SQLiteDB.bind(stmt, 1, userId)
225.         try SQLiteDB.bind(stmt, 2, studyDay)
226.         try SQLiteDB.bind(stmt, 3, sessionType.rawValue)
227.         if sqlite3_step(stmt) != SQLITE_DONE {
228.             throw SQLiteError.stepFailed(message: db.errorMessage())
229.         }
230.     }
231. 
232.     func completeSession(userId: String, studyDay: Int, sessionType: SessionType) throws {
233.         let db = self.db
234.         let sql = """
235.         UPDATE session_state
236.         SET completed_at = ?, is_paused = 0
237.         WHERE user_id = ? AND study_day = ? AND session_type = ?;
238.         """
239.         let stmt = try db.prepare(sql)
240.         defer { stmt?.finalize() }
241.         let now = iso.string(from: Date())
242.         try SQLiteDB.bind(stmt, 1, now)
243.         try SQLiteDB.bind(stmt, 2, userId)
244.         try SQLiteDB.bind(stmt, 3, studyDay)
245.         try SQLiteDB.bind(stmt, 4, sessionType.rawValue)
246.         if sqlite3_step(stmt) != SQLITE_DONE {
247.             throw SQLiteError.stepFailed(message: db.errorMessage())
248.         }
249.     }
250. 
251.     // MARK: - Private Helpers
252. 
253.     private func parseDayState(_ stmt: OpaquePointer?) -> DayState {
254.         DayState(
255.             id: SQLiteDB.columnInt(stmt, 0),
256.             userId: SQLiteDB.columnText(stmt, 1) ?? "",
257.             studyDay: SQLiteDB.columnInt(stmt, 2),
258.             zoneIndex: SQLiteDB.columnInt(stmt, 3),
259.             morningComplete: SQLiteDB.columnInt(stmt, 4) != 0,
260.             eveningComplete: SQLiteDB.columnInt(stmt, 5) != 0,
261.             morningCompleteAt: SQLiteDB.columnText(stmt, 6).flatMap { iso.date(from: $0) },
262.             eveningCompleteAt: SQLiteDB.columnText(stmt, 7).flatMap { iso.date(from: $0) },
263.             newWordsMorning: SQLiteDB.columnInt(stmt, 8),
264.             newWordsEvening: SQLiteDB.columnInt(stmt, 9),
265.             morningAccuracy: SQLiteDB.columnDouble(stmt, 10),
266.             eveningAccuracy: SQLiteDB.columnDouble(stmt, 11),
267.             morningXP: SQLiteDB.columnInt(stmt, 12),
268.             eveningXP: SQLiteDB.columnInt(stmt, 13),
269.             isRecoveryDay: SQLiteDB.columnInt(stmt, 14) != 0,
270.             isReviewOnlyDay: SQLiteDB.columnInt(stmt, 15) != 0
271.         )
272.     }
273. 
274.     private func parseSessionState(_ stmt: OpaquePointer?) -> SessionState {
275.         let showAgainJSON = SQLiteDB.columnText(stmt, 7) ?? "[]"
276.         let requeuedJSON = SQLiteDB.columnText(stmt, 8) ?? "[]"
277.         let showAgain = (try? decodeIntArray(showAgainJSON)) ?? []
278.         let requeued = (try? decodeIntArray(requeuedJSON)) ?? []
279. 
280.         return SessionState(
281.             id: SQLiteDB.columnInt(stmt, 0),
282.             userId: SQLiteDB.columnText(stmt, 1) ?? "",
283.             sessionType: SessionType(rawValue: SQLiteDB.columnText(stmt, 2) ?? "morning") ?? .morning,
284.             studyDay: SQLiteDB.columnInt(stmt, 3),
285.             stepIndex: SQLiteDB.columnInt(stmt, 4),
286.             itemIndex: SQLiteDB.columnInt(stmt, 5),
287.             isPaused: SQLiteDB.columnInt(stmt, 6) != 0,
288.             showAgainIds: showAgain,
289.             requeuedIds: requeued,
290.             startedAt: SQLiteDB.columnText(stmt, 9).flatMap { iso.date(from: $0) },
291.             pausedAt: SQLiteDB.columnText(stmt, 10).flatMap { iso.date(from: $0) },
292.             completedAt: SQLiteDB.columnText(stmt, 11).flatMap { iso.date(from: $0) }
293.         )
294.     }
295. 
296.     private func encodeIntArray(_ arr: [Int]) throws -> String {
297.         let data = try JSONEncoder().encode(arr)
298.         return String(data: data, encoding: .utf8) ?? "[]"
299.     }
300. 
301.     private func decodeIntArray(_ json: String) throws -> [Int] {
302.         guard let data = json.data(using: .utf8) else { return [] }
303.         return try JSONDecoder().decode([Int].self, from: data)
304.     }
305. }
306.
```

</details>


---

<sub>⏱️ 50s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/StatsStore.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/StatsStore.swift

<details>
<summary>266 lines</summary>

```
1. import Foundation
2. import SQLite3
3. 
4. extension DateFormatter {
5.     static let yyyyMMdd: DateFormatter = {
6.         let f = DateFormatter()
7.         f.calendar = Calendar.current
8.         f.locale = Locale(identifier: "en_US_POSIX")
9.         f.dateFormat = "yyyy-MM-dd"
10.         return f
11.     }()
12. }
13. 
14. actor StatsStore {
15.     static let shared = StatsStore()
16. 
17.     private var db: SQLiteDB { DataManager.shared.db }
18. 
19.     private init() {}
20. 
21.     // MARK: - Daily Stats
22. 
23.     func getOrCreateDailyStats(userId: String, studyDay: Int) throws -> DailyStats {
24.         let calendarDate = DateFormatter.yyyyMMdd.string(from: Date())
25. 
26.         let insertSQL = """
27.         INSERT OR IGNORE INTO daily_stats(user_id, study_day, calendar_date)
28.         VALUES (?, ?, ?);
29.         """
30.         let s1 = try db.prepare(insertSQL)
31.         defer { s1?.finalize() }
32.         try SQLiteDB.bind(s1, 1, userId)
33.         try SQLiteDB.bind(s1, 2, studyDay)
34.         try SQLiteDB.bind(s1, 3, calendarDate)
35.         if sqlite3_step(s1) != SQLITE_DONE {
36.             throw SQLiteError.stepFailed(message: db.errorMessage())
37.         }
38. 
39.         let selectSQL = """
40.         SELECT id, user_id, study_day, calendar_date, new_count, review_count,
41.                correct_count, total_count, xp_earned, session_bonus,
42.                study_minutes, words_promoted, words_demoted
43.         FROM daily_stats
44.         WHERE user_id = ? AND study_day = ?
45.         LIMIT 1;
46.         """
47.         let s2 = try db.prepare(selectSQL)
48.         defer { s2?.finalize() }
49.         try SQLiteDB.bind(s2, 1, userId)
50.         try SQLiteDB.bind(s2, 2, studyDay)
51.         if sqlite3_step(s2) == SQLITE_ROW {
52.             return parseDailyStats(s2)
53.         }
54.         throw SQLiteError.stepFailed(message: "Failed to fetch daily_stats after insert")
55.     }
56. 
57.     func recordCorrectAnswer(userId: String, studyDay: Int, xpPerCorrect: Int = AppConfig.correctAnswerXP) throws {
58.         let sql = """
59.         UPDATE daily_stats
60.         SET correct_count = correct_count + 1,
61.             total_count = total_count + 1,
62.             xp_earned = xp_earned + ?
63.         WHERE user_id = ? AND study_day = ?;
64.         """
65.         let stmt = try db.prepare(sql)
66.         defer { stmt?.finalize() }
67.         try SQLiteDB.bind(stmt, 1, xpPerCorrect)
68.         try SQLiteDB.bind(stmt, 2, userId)
69.         try SQLiteDB.bind(stmt, 3, studyDay)
70.         if sqlite3_step(stmt) != SQLITE_DONE {
71.             throw SQLiteError.stepFailed(message: db.errorMessage())
72.         }
73.     }
74. 
75.     func recordWrongAnswer(userId: String, studyDay: Int) throws {
76.         let sql = """
77.         UPDATE daily_stats
78.         SET total_count = total_count + 1
79.         WHERE user_id = ? AND study_day = ?;
80.         """
81.         let stmt = try db.prepare(sql)
82.         defer { stmt?.finalize() }
83.         try SQLiteDB.bind(stmt, 1, userId)
84.         try SQLiteDB.bind(stmt, 2, studyDay)
85.         if sqlite3_step(stmt) != SQLITE_DONE {
86.             throw SQLiteError.stepFailed(message: db.errorMessage())
87.         }
88.     }
89. 
90.     func addSessionBonus(userId: String, studyDay: Int, bonus: Int = AppConfig.sessionBonusXP) throws {
91.         let sql = """
92.         UPDATE daily_stats
93.         SET session_bonus = session_bonus + ?
94.         WHERE user_id = ? AND study_day = ?;
95.         """
96.         let stmt = try db.prepare(sql)
97.         defer { stmt?.finalize() }
98.         try SQLiteDB.bind(stmt, 1, bonus)
99.         try SQLiteDB.bind(stmt, 2, userId)
100.         try SQLiteDB.bind(stmt, 3, studyDay)
101.         if sqlite3_step(stmt) != SQLITE_DONE {
102.             throw SQLiteError.stepFailed(message: db.errorMessage())
103.         }
104.     }
105. 
106.     func recordWordPromoted(userId: String, studyDay: Int) throws {
107.         let sql = """
108.         UPDATE daily_stats
109.         SET words_promoted = words_promoted + 1
110.         WHERE user_id = ? AND study_day = ?;
111.         """
112.         let stmt = try db.prepare(sql)
113.         defer { stmt?.finalize() }
114.         try SQLiteDB.bind(stmt, 1, userId)
115.         try SQLiteDB.bind(stmt, 2, studyDay)
116.         if sqlite3_step(stmt) != SQLITE_DONE {
117.             throw SQLiteError.stepFailed(message: db.errorMessage())
118.         }
119.     }
120. 
121.     func recordWordDemoted(userId: String, studyDay: Int) throws {
122.         let sql = """
123.         UPDATE daily_stats
124.         SET words_demoted = words_demoted + 1
125.         WHERE user_id = ? AND study_day = ?;
126.         """
127.         let stmt = try db.prepare(sql)
128.         defer { stmt?.finalize() }
129.         try SQLiteDB.bind(stmt, 1, userId)
130.         try SQLiteDB.bind(stmt, 2, studyDay)
131.         if sqlite3_step(stmt) != SQLITE_DONE {
132.             throw SQLiteError.stepFailed(message: db.errorMessage())
133.         }
134.     }
135. 
136.     // MARK: - Streak
137. 
138.     func getStreak(userId: String) throws -> StreakInfo {
139.         let sql = """
140.         SELECT current_streak, best_streak, last_study_date,
141.                total_xp, total_study_days,
142.                streak_3_claimed, streak_7_claimed, streak_14_claimed, streak_30_claimed
143.         FROM streak_store
144.         WHERE user_id = ?
145.         LIMIT 1;
146.         """
147.         let stmt = try db.prepare(sql)
148.         defer { stmt?.finalize() }
149.         try SQLiteDB.bind(stmt, 1, userId)
150.         if sqlite3_step(stmt) == SQLITE_ROW {
151.             return StreakInfo(
152.                 currentStreak: SQLiteDB.columnInt(stmt, 0),
153.                 bestStreak: SQLiteDB.columnInt(stmt, 1),
154.                 lastStudyDate: SQLiteDB.columnText(stmt, 2),
155.                 totalXP: SQLiteDB.columnInt(stmt, 3),
156.                 totalStudyDays: SQLiteDB.columnInt(stmt, 4),
157.                 streak3Claimed: SQLiteDB.columnInt(stmt, 5) != 0,
158.                 streak7Claimed: SQLiteDB.columnInt(stmt, 6) != 0,
159.                 streak14Claimed: SQLiteDB.columnInt(stmt, 7) != 0,
160.                 streak30Claimed: SQLiteDB.columnInt(stmt, 8) != 0
161.             )
162.         }
163.         // Return default if no row found
164.         return StreakInfo(
165.             currentStreak: 0, bestStreak: 0, lastStudyDate: nil,
166.             totalXP: 0, totalStudyDays: 0,
167.             streak3Claimed: false, streak7Claimed: false,
168.             streak14Claimed: false, streak30Claimed: false
169.         )
170.     }
171. 
172.     func updateStreak(userId: String, xpToday: Int) throws -> (newStreak: Int, milestoneXP: Int) {
173.         let current = try getStreak(userId: userId)
174.         let today = DateFormatter.yyyyMMdd.string(from: Date())
175.         let calendar = Calendar.current
176. 
177.         var newStreak = current.currentStreak
178.         var newBest = current.bestStreak
179.         var newTotalDays = current.totalStudyDays
180. 
181.         if current.lastStudyDate == today {
182.             // Already studied today, just update XP
183.         } else {
184.             // Check if yesterday
185.             let yesterday = calendar.date(byAdding: .day, value: -1, to: Date())!
186.             let yesterdayStr = DateFormatter.yyyyMMdd.string(from: yesterday)
187. 
188.             if current.lastStudyDate == yesterdayStr {
189.                 newStreak += 1
190.             } else {
191.                 newStreak = 1
192.             }
193.             newTotalDays += 1
194.         }
195. 
196.         if newStreak > newBest {
197.             newBest = newStreak
198.         }
199. 
200.         // Calculate milestone bonuses
201.         var milestoneXP = 0
202.         var s3 = current.streak3Claimed
203.         var s7 = current.streak7Claimed
204.         var s14 = current.streak14Claimed
205.         var s30 = current.streak30Claimed
206. 
207.         if newStreak >= 3 && !s3 { milestoneXP += 20; s3 = true }
208.         if newStreak >= 7 && !s7 { milestoneXP += 50; s7 = true }
209.         if newStreak >= 14 && !s14 { milestoneXP += 100; s14 = true }
210.         if newStreak >= 30 && !s30 { milestoneXP += 200; s30 = true }
211. 
212.         let newTotalXP = current.totalXP + xpToday + milestoneXP
213. 
214.         let sql = """
215.         UPDATE streak_store
216.         SET current_streak = ?,
217.             best_streak = ?,
218.             last_study_date = ?,
219.             total_xp = ?,
220.             total_study_days = ?,
221.             streak_3_claimed = ?,
222.             streak_7_claimed = ?,
223.             streak_14_claimed = ?,
224.             streak_30_claimed = ?
225.         WHERE user_id = ?;
226.         """
227.         let stmt = try db.prepare(sql)
228.         defer { stmt?.finalize() }
229.         try SQLiteDB.bind(stmt, 1, newStreak)
230.         try SQLiteDB.bind(stmt, 2, newBest)
231.         try SQLiteDB.bind(stmt, 3, today)
232.         try SQLiteDB.bind(stmt, 4, newTotalXP)
233.         try SQLiteDB.bind(stmt, 5, newTotalDays)
234.         try SQLiteDB.bind(stmt, 6, s3 ? 1 : 0)
235.         try SQLiteDB.bind(stmt, 7, s7 ? 1 : 0)
236.         try SQLiteDB.bind(stmt, 8, s14 ? 1 : 0)
237.         try SQLiteDB.bind(stmt, 9, s30 ? 1 : 0)
238.         try SQLiteDB.bind(stmt, 10, userId)
239.         if sqlite3_step(stmt) != SQLITE_DONE {
240.             throw SQLiteError.stepFailed(message: db.errorMessage())
241.         }
242. 
243.         return (newStreak: newStreak, milestoneXP: milestoneXP)
244.     }
245. 
246.     // MARK: - Private
247. 
248.     private func parseDailyStats(_ stmt: OpaquePointer?) -> DailyStats {
249.         DailyStats(
250.             id: SQLiteDB.columnInt(stmt, 0),
251.             userId: SQLiteDB.columnText(stmt, 1) ?? "",
252.             studyDay: SQLiteDB.columnInt(stmt, 2),
253.             calendarDate: SQLiteDB.columnText(stmt, 3) ?? "",
254.             newCount: SQLiteDB.columnInt(stmt, 4),
255.             reviewCount: SQLiteDB.columnInt(stmt, 5),
256.             correctCount: SQLiteDB.columnInt(stmt, 6),
257.             totalCount: SQLiteDB.columnInt(stmt, 7),
258.             xpEarned: SQLiteDB.columnInt(stmt, 8),
259.             sessionBonus: SQLiteDB.columnInt(stmt, 9),
260.             studyMinutes: SQLiteDB.columnDouble(stmt, 10),
261.             wordsPromoted: SQLiteDB.columnInt(stmt, 11),
262.             wordsDemoted: SQLiteDB.columnInt(stmt, 12)
263.         )
264.     }
265. }
266.
```

</details>


---

<sub>⏱️ 50s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/ZoneStore.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/ZoneStore.swift

<details>
<summary>99 lines</summary>

```
1. import Foundation
2. import SQLite3
3. 
4. actor ZoneStore {
5.     static let shared = ZoneStore()
6. 
7.     private var db: SQLiteDB { DataManager.shared.db }
8. 
9.     private init() {}
10. 
11.     // MARK: - Zone State
12. 
13.     func getZoneState(userId: String, zoneIndex: Int) throws -> ZoneState? {
14.         let sql = """
15.         SELECT id, user_id, zone_index, unlocked, test_passed, test_attempts, test_best_score
16.         FROM zone_state
17.         WHERE user_id = ? AND zone_index = ?
18.         LIMIT 1;
19.         """
20.         let stmt = try db.prepare(sql)
21.         defer { stmt?.finalize() }
22.         try SQLiteDB.bind(stmt, 1, userId)
23.         try SQLiteDB.bind(stmt, 2, zoneIndex)
24.         if sqlite3_step(stmt) == SQLITE_ROW {
25.             return parseZoneState(stmt)
26.         }
27.         return nil
28.     }
29. 
30.     func isZoneUnlocked(userId: String, zoneIndex: Int) throws -> Bool {
31.         if zoneIndex == 0 { return true }
32.         guard let state = try getZoneState(userId: userId, zoneIndex: zoneIndex) else {
33.             return false
34.         }
35.         return state.unlocked
36.     }
37. 
38.     func unlockZone(userId: String, zoneIndex: Int) throws {
39.         let sql = """
40.         INSERT INTO zone_state(user_id, zone_index, unlocked, unlocked_at)
41.         VALUES (?, ?, 1, datetime('now'))
42.         ON CONFLICT(user_id, zone_index) DO UPDATE SET unlocked = 1, unlocked_at = datetime('now');
43.         """
44.         let stmt = try db.prepare(sql)
45.         defer { stmt?.finalize() }
46.         try SQLiteDB.bind(stmt, 1, userId)
47.         try SQLiteDB.bind(stmt, 2, zoneIndex)
48.         if sqlite3_step(stmt) != SQLITE_DONE {
49.             throw SQLiteError.stepFailed(message: db.errorMessage())
50.         }
51.     }
52. 
53.     func recordTestAttempt(userId: String, zoneIndex: Int, score: Double, passed: Bool) throws {
54.         // Ensure row exists first
55.         let insertSQL = """
56.         INSERT OR IGNORE INTO zone_state(user_id, zone_index, unlocked)
57.         VALUES (?, ?, 0);
58.         """
59.         let s1 = try db.prepare(insertSQL)
60.         defer { s1?.finalize() }
61.         try SQLiteDB.bind(s1, 1, userId)
62.         try SQLiteDB.bind(s1, 2, zoneIndex)
63.         if sqlite3_step(s1) != SQLITE_DONE {
64.             throw SQLiteError.stepFailed(message: db.errorMessage())
65.         }
66. 
67.         let updateSQL = """
68.         UPDATE zone_state
69.         SET test_attempts = test_attempts + 1,
70.             test_best_score = MAX(test_best_score, ?),
71.             test_passed = CASE WHEN ? = 1 THEN 1 ELSE test_passed END
72.         WHERE user_id = ? AND zone_index = ?;
73.         """
74.         let s2 = try db.prepare(updateSQL)
75.         defer { s2?.finalize() }
76.         try SQLiteDB.bind(s2, 1, score)
77.         try SQLiteDB.bind(s2, 2, passed ? 1 : 0)
78.         try SQLiteDB.bind(s2, 3, userId)
79.         try SQLiteDB.bind(s2, 4, zoneIndex)
80.         if sqlite3_step(s2) != SQLITE_DONE {
81.             throw SQLiteError.stepFailed(message: db.errorMessage())
82.         }
83.     }
84. 
85.     // MARK: - Private
86. 
87.     private func parseZoneState(_ stmt: OpaquePointer?) -> ZoneState {
88.         ZoneState(
89.             id: SQLiteDB.columnInt(stmt, 0),
90.             userId: SQLiteDB.columnText(stmt, 1) ?? "",
91.             zoneIndex: SQLiteDB.columnInt(stmt, 2),
92.             unlocked: SQLiteDB.columnInt(stmt, 3) != 0,
93.             testPassed: SQLiteDB.columnInt(stmt, 4) != 0,
94.             testAttempts: SQLiteDB.columnInt(stmt, 5),
95.             testBestScore: SQLiteDB.columnDouble(stmt, 6)
96.         )
97.     }
98. }
99.
```

</details>


---

<sub>⏱️ 50s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/ReviewLogger.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/ReviewLogger.swift

<details>
<summary>61 lines</summary>

```
1. import Foundation
2. import SQLite3
3. 
4. actor ReviewLogger {
5.     private let db: SQLiteDB
6. 
7.     init(db: SQLiteDB) {
8.         self.db = db
9.     }
10. 
11.     func logReview(
12.         userId: String,
13.         wordId: Int,
14.         outcome: ReviewOutcome,
15.         activityType: ActivityType,
16.         sessionType: SessionType,
17.         studyDay: Int,
18.         durationMs: Int
19.     ) throws {
20.         let sql = """
21.         INSERT INTO review_log(user_id, word_id, outcome, duration_ms, reviewed_at, device_id, activity_type, session_type, study_day, superseded)
22.         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 0);
23.         """
24.         let stmt = try db.prepare(sql)
25.         defer { stmt?.finalize() }
26. 
27.         let reviewedAt = ISO8601DateFormatter().string(from: Date())
28. 
29.         try SQLiteDB.bind(stmt, 1, userId)
30.         try SQLiteDB.bind(stmt, 2, wordId)
31.         try SQLiteDB.bind(stmt, 3, outcome.rawValue)
32.         try SQLiteDB.bind(stmt, 4, durationMs)
33.         try SQLiteDB.bind(stmt, 5, reviewedAt)
34.         try SQLiteDB.bind(stmt, 6, LocalIdentity.deviceId())
35.         try SQLiteDB.bind(stmt, 7, activityType.rawValue)
36.         try SQLiteDB.bind(stmt, 8, sessionType.rawValue)
37.         try SQLiteDB.bind(stmt, 9, studyDay)
38. 
39.         if sqlite3_step(stmt) != SQLITE_DONE {
40.             throw SQLiteError.stepFailed(message: db.errorMessage())
41.         }
42.     }
43. 
44.     func supersedeSession(userId: String, studyDay: Int, sessionType: SessionType) throws {
45.         let sql = """
46.         UPDATE review_log SET superseded = 1
47.         WHERE user_id = ? AND study_day = ? AND session_type = ? AND superseded = 0;
48.         """
49.         let stmt = try db.prepare(sql)
50.         defer { stmt?.finalize() }
51. 
52.         try SQLiteDB.bind(stmt, 1, userId)
53.         try SQLiteDB.bind(stmt, 2, studyDay)
54.         try SQLiteDB.bind(stmt, 3, sessionType.rawValue)
55. 
56.         if sqlite3_step(stmt) != SQLITE_DONE {
57.             throw SQLiteError.stepFailed(message: db.errorMessage())
58.         }
59.     }
60. }
61.
```

</details>


---

<sub>⏱️ 50s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift

```
File too large to read at once (24.1 KB). Consider using the grep tool to search within the file, or view with view_range to read specific sections.
```


---

<sub>⏱️ 1m 25s</sub>

### 💬 Copilot

I’ve got the main store implementations. I’m pulling `DataManager.swift` plus a few focused searches now to confirm whether there are actor-isolation leaks, any remaining interpolated SQL, and where the schema or promotion logic diverges from `data-schema.md`.

---

<sub>⏱️ 1m 25s</sub>

### ✅ `rg`

**/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data**

<details>
<summary>Arguments</summary>

```json
{
  "pattern": "db\\.exec\\(|prepare\\(|INSERT|UPDATE|DELETE|SELECT|\\$\\{|\\\\\\(|try\\? sqlite3_step|sqlite3_step\\(|catch \\{|SQLiteError|actor DataManager|let db|var db|initializeIfNeeded|ensureUserExists|getDefaultList|fetchSessionQueue",
  "path": "/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data",
  "output_mode": "content",
  "-n": true,
  "head_limit": 400
}
```

</details>

<details>
<summary>7 lines</summary>

```
Output too large to read at once (41.1 KB). Saved to: /var/folders/lw/yv880yw12w36hj114qn16_g00000gn/T/copilot-tool-output-1776022406893-iywhuf.txt
Consider using tools like grep (for searching), head/tail (for viewing start/end), view with view_range (for specific sections), or jq (for JSON) to examine portions of the output.

Preview (first 500 chars):
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/ZoneStore.swift:7:    private var db: SQLiteDB { DataManager.shared.db }
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/ZoneStore.swift:15:        SELECT id, user_id, zone_index, unlocked, test_passed, test_attempts, test_best_score
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/ZoneStore.swift:20:        let stmt = try db.prepare(sql)
/Users/jiong/myprojects/satspell/i
```

</details>


---

<sub>⏱️ 1m 25s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift

```
File too large to read at once (24.1 KB). Consider using the grep tool to search within the file, or view with view_range to read specific sections.
```


---

<sub>⏱️ 1m 25s</sub>

### ✅ `rg`

**/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/WordStateStore.swift**

<details>
<summary>Arguments</summary>

```json
{
  "pattern": "intro_stage|day_touches|study_day|activity_type IN \\('image_game', 'quick_recall'\\)|box_level > 0|review_log",
  "path": "/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/WordStateStore.swift",
  "output_mode": "content",
  "-n": true,
  "head_limit": 200
}
```

</details>

<details>
<summary>19 lines</summary>

```
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/WordStateStore.swift:33:        SELECT id, user_id, word_id, box_level, due_at, intro_stage,
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/WordStateStore.swift:35:               total_seen, day_touches, recent_accuracy, last_reviewed_at
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/WordStateStore.swift:53:        SELECT id, user_id, word_id, box_level, due_at, intro_stage,
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/WordStateStore.swift:55:               total_seen, day_touches, recent_accuracy, last_reviewed_at
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/WordStateStore.swift:57:        WHERE user_id = ? AND due_at <= ? AND box_level > 0
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/WordStateStore.swift:86:        WHERE user_id = ? AND due_at <= ? AND box_level > 0;
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/WordStateStore.swift:147:        INSERT INTO word_state(user_id, word_id, box_level, intro_stage, total_seen, memory_status, created_at, updated_at)
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/WordStateStore.swift:150:            intro_stage = MAX(intro_stage, 1),
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/WordStateStore.swift:219:            day_touches = ?,
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/WordStateStore.swift:254:        // Find words with intro_stage IN (1,2) AND box_level = 0
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/WordStateStore.swift:257:        WHERE user_id = ? AND intro_stage IN (1, 2) AND box_level = 0;
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/WordStateStore.swift:274:            // Count scored correct answers from review_log
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/WordStateStore.swift:279:            FROM review_log
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/WordStateStore.swift:281:              AND activity_type IN ('image_game', 'quick_recall')
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/WordStateStore.swift:298:            SELECT outcome FROM review_log
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/WordStateStore.swift:300:              AND activity_type IN ('image_game', 'quick_recall')
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/WordStateStore.swift:337:                intro_stage = 3,
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/WordStateStore.swift:357:        let sql = "UPDATE word_state SET day_touches = 0 WHERE user_id = ?;"
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/WordStateStore.swift:370:        SELECT outcome FROM review_log
```

</details>


---

<sub>⏱️ 1m 25s</sub>

### ✅ `sql`

**Advance implementation audit**

<details>
<summary>Arguments</summary>

```json
{
  "description": "Advance implementation audit",
  "query": "UPDATE todos SET status = 'done' WHERE id = 'read-plan1-implementation';\nUPDATE todos SET status = 'in_progress' WHERE id = 'audit-plan1-implementation';\nSELECT id, title, status FROM todos WHERE id IN ('read-plan1-implementation','audit-plan1-implementation','write-plan1-review') ORDER BY created_at;"
}
```

</details>

<details>
<summary>12 lines</summary>

```
Executed 3 statement(s):

1. UPDATE
   1 row(s) updated.

2. UPDATE
   1 row(s) updated.

3. SELECT
   3 row(s) returned:
   
   | id | title | status |
   | --- | --- | --- |
   | audit-plan1-implementation | Audit data layer implementation | in_progress |
   | read-plan1-implementation | Read Plan 1 implementation | done |
   | write-plan1-review | Write plan1 implementation review | pending |
```

</details>


---

<sub>⏱️ 1m 33s</sub>

### 💬 Copilot

The remaining risk is in `DataManager` and the shared-store pattern, so I’m reading just the relevant slices there now before I write the review.

---

<sub>⏱️ 1m 33s</sub>

### ✅ `rg`

**/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift**

<details>
<summary>Arguments</summary>

```json
{
  "pattern": "actor DataManager|let db|initializeIfNeeded|ensureUserExists|getDefaultList|fetchSessionQueue|countWordsInList|shared|nonisolated|async",
  "path": "/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift",
  "output_mode": "content",
  "-n": true,
  "head_limit": 200
}
```

</details>

<details>
<summary>11 lines</summary>

```
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift:4:actor DataManager {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift:5:    static let shared = DataManager()
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift:7:    nonisolated let db = SQLiteDB()
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift:16:    func initializeIfNeeded() throws {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift:31:            try ensureUserExists(userId: userId)
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift:53:            try ensureUserExists(userId: userId)
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift:61:    func ensureUserExists(userId: String) throws {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift:73:    func getDefaultList() throws -> ListInfo {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift:95:    func fetchSessionQueue(listId: Int, limit: Int, startIndex: Int) throws -> [VocabCard] {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift:97:        let total = try countWordsInList(listId: listId)
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift:181:    private func countWordsInList(listId: Int) throws -> Int {
```

</details>


---

<sub>⏱️ 1m 33s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift (lines 1-260)

<details>
<summary>260 lines</summary>

```
1. import Foundation
2. import SQLite3
3. 
4. actor DataManager {
5.     static let shared = DataManager()
6. 
7.     nonisolated let db = SQLiteDB()
8.     private var isInitialized = false
9. 
10.     private init() {}
11. 
12.     deinit {
13.         db.close()
14.     }
15. 
16.     func initializeIfNeeded() throws {
17.         if isInitialized { return }
18. 
19.         let fm = FileManager.default
20.         let writableURL = try DatabasePaths.writableDatabaseURL()
21.         let needsImport = !fm.fileExists(atPath: writableURL.path)
22. 
23.         try db.open(path: writableURL.path)
24. 
25.         if needsImport {
26.             // Fresh install: create schema, import bundled content, seed user defaults
27.             try SchemaV2.createAll(db: db)
28.             try ContentImporter.importBundledContent(db: db)
29. 
30.             let userId = LocalIdentity.userId()
31.             try ensureUserExists(userId: userId)
32. 
33.             // Seed streak_store row
34.             let streakSQL = "INSERT OR IGNORE INTO streak_store(user_id) VALUES (?)"
35.             let s1 = try db.prepare(streakSQL)
36.             defer { s1?.finalize() }
37.             try SQLiteDB.bind(s1, 1, userId)
38.             if sqlite3_step(s1) != SQLITE_DONE {
39.                 throw SQLiteError.stepFailed(message: db.errorMessage())
40.             }
41. 
42.             // Seed zone_state row for zone 0 (unlocked by default)
43.             let zoneSQL = "INSERT OR IGNORE INTO zone_state(user_id, zone_index, unlocked, unlocked_at) VALUES (?, 0, 1, datetime('now'))"
44.             let s2 = try db.prepare(zoneSQL)
45.             defer { s2?.finalize() }
46.             try SQLiteDB.bind(s2, 1, userId)
47.             if sqlite3_step(s2) != SQLITE_DONE {
48.                 throw SQLiteError.stepFailed(message: db.errorMessage())
49.             }
50.         } else {
51.             // Existing DB: just ensure user row exists
52.             let userId = LocalIdentity.userId()
53.             try ensureUserExists(userId: userId)
54.         }
55. 
56.         isInitialized = true
57.     }
58. 
59.     // MARK: - Users
60. 
61.     func ensureUserExists(userId: String) throws {
62.         let sql = "INSERT OR IGNORE INTO users(id, email) VALUES (?, NULL);"
63.         let stmt = try db.prepare(sql)
64.         defer { stmt?.finalize() }
65.         try SQLiteDB.bind(stmt, 1, userId)
66.         if sqlite3_step(stmt) != SQLITE_DONE {
67.             throw SQLiteError.stepFailed(message: db.errorMessage())
68.         }
69.     }
70. 
71.     // MARK: - Lists
72. 
73.     func getDefaultList() throws -> ListInfo {
74.         let sql = """
75.         SELECT id, name, description, version
76.         FROM lists
77.         ORDER BY CASE WHEN name=? THEN 0 ELSE 1 END, id
78.         LIMIT 1;
79.         """
80.         let stmt = try db.prepare(sql)
81.         defer { stmt?.finalize() }
82.         try SQLiteDB.bind(stmt, 1, AppConfig.defaultListName)
83.         if sqlite3_step(stmt) == SQLITE_ROW {
84.             let id = SQLiteDB.columnInt(stmt, 0)
85.             let name = SQLiteDB.columnText(stmt, 1) ?? ""
86.             let description = SQLiteDB.columnText(stmt, 2)
87.             let version = SQLiteDB.columnInt(stmt, 3)
88.             return ListInfo(id: id, name: name, description: description, version: version)
89.         }
90.         throw SQLiteError.stepFailed(message: "No list found")
91.     }
92. 
93.     // MARK: - Queue
94. 
95.     func fetchSessionQueue(listId: Int, limit: Int, startIndex: Int) throws -> [VocabCard] {
96.         // Deterministic sequential ordering (no jumping): offset = startIndex % totalInList
97.         let total = try countWordsInList(listId: listId)
98.         if total == 0 { return [] }
99.         let offset = ((startIndex % total) + total) % total
100. 
101.         // Fetch with wrap-around using two queries.
102.         let first = try fetchOrderedWords(listId: listId, limit: min(limit, total), offset: offset)
103.         if first.count >= limit { return first }
104.         let remaining = limit - first.count
105.         let second = try fetchOrderedWords(listId: listId, limit: remaining, offset: 0)
106.         return first + second
107.     }
108. 
109.     func fetchReviewQueue(userId: String, listId: Int, limit: Int) throws -> [VocabCard] {
110.         try fetchReviewQueue(userId: userId, listId: listId, limit: limit, restrictToWordIds: nil)
111.     }
112. 
113.     func fetchReviewQueue(userId: String, listId: Int, limit: Int, restrictToWordIds: [Int]?) throws -> [VocabCard] {
114.         // Words that currently "need review" are those whose latest logged outcome is incorrect.
115.         // Optionally restrict to a known subset of word IDs (e.g., zone difficulty review).
116. 
117.         if let ids = restrictToWordIds, ids.isEmpty {
118.             return []
119.         }
120. 
121.         let wordFilterSql: String
122.         if let ids = restrictToWordIds {
123.             let placeholders = Array(repeating: "?", count: ids.count).joined(separator: ",")
124.             wordFilterSql = "AND l.word_id IN (\(placeholders))"
125.         } else {
126.             wordFilterSql = ""
127.         }
128. 
129.         let sql = """
130.         WITH latest AS (
131.             SELECT rl.word_id,
132.                    rl.outcome,
133.                    rl.reviewed_at,
134.                    ROW_NUMBER() OVER (PARTITION BY rl.word_id ORDER BY rl.reviewed_at DESC) AS rn
135.             FROM review_log rl
136.             JOIN word_list wl ON wl.word_id = rl.word_id AND wl.list_id = ?
137.             WHERE rl.user_id = ?
138.         )
139.         SELECT w.id, w.lemma, w.pos, w.definition, w.example, w.image_filename
140.         FROM latest l
141.         JOIN words w ON w.id = l.word_id
142.         WHERE l.rn = 1
143.           AND l.outcome = 'incorrect'
144.           \(wordFilterSql)
145.         ORDER BY l.reviewed_at DESC
146.         LIMIT ?;
147.         """
148. 
149.         let stmt = try db.prepare(sql)
150.         defer { stmt?.finalize() }
151. 
152.         var bindIndex: Int32 = 1
153.         try SQLiteDB.bind(stmt, bindIndex, listId)
154.         bindIndex += 1
155.         try SQLiteDB.bind(stmt, bindIndex, userId)
156.         bindIndex += 1
157. 
158.         if let ids = restrictToWordIds {
159.             for id in ids {
160.                 try SQLiteDB.bind(stmt, bindIndex, id)
161.                 bindIndex += 1
162.             }
163.         }
164. 
165.         try SQLiteDB.bind(stmt, bindIndex, limit)
166. 
167.         var out: [VocabCard] = []
168.         while sqlite3_step(stmt) == SQLITE_ROW {
169.             out.append(VocabCard(
170.                 id: SQLiteDB.columnInt(stmt, 0),
171.                 lemma: SQLiteDB.columnText(stmt, 1) ?? "",
172.                 pos: SQLiteDB.columnText(stmt, 2),
173.                 definition: SQLiteDB.columnText(stmt, 3),
174.                 example: SQLiteDB.columnText(stmt, 4),
175.                 imageFilename: SQLiteDB.columnText(stmt, 5)
176.             ))
177.         }
178.         return out
179.     }
180. 
181.     private func countWordsInList(listId: Int) throws -> Int {
182.         let sql = "SELECT COUNT(*) FROM word_list WHERE list_id=?;"
183.         let stmt = try db.prepare(sql)
184.         defer { stmt?.finalize() }
185.         try SQLiteDB.bind(stmt, 1, listId)
186.         if sqlite3_step(stmt) == SQLITE_ROW {
187.             return SQLiteDB.columnInt(stmt, 0)
188.         }
189.         return 0
190.     }
191. 
192.     private func fetchOrderedWords(listId: Int, limit: Int, offset: Int) throws -> [VocabCard] {
193.         let sql = """
194.         SELECT w.id, w.lemma, w.pos, w.definition, w.example, w.image_filename
195.         FROM word_list wl
196.         JOIN words w ON w.id = wl.word_id
197.         WHERE wl.list_id = ?
198.         ORDER BY COALESCE(wl.rank, 999999), w.id
199.         LIMIT ? OFFSET ?;
200.         """
201.         let stmt = try db.prepare(sql)
202.         defer { stmt?.finalize() }
203.         try SQLiteDB.bind(stmt, 1, listId)
204.         try SQLiteDB.bind(stmt, 2, limit)
205.         try SQLiteDB.bind(stmt, 3, offset)
206. 
207.         var out: [VocabCard] = []
208.         while sqlite3_step(stmt) == SQLITE_ROW {
209.             out.append(VocabCard(
210.                 id: SQLiteDB.columnInt(stmt, 0),
211.                 lemma: SQLiteDB.columnText(stmt, 1) ?? "",
212.                 pos: SQLiteDB.columnText(stmt, 2),
213.                 definition: SQLiteDB.columnText(stmt, 3),
214.                 example: SQLiteDB.columnText(stmt, 4),
215.                 imageFilename: SQLiteDB.columnText(stmt, 5)
216.             ))
217.         }
218.         return out
219.     }
220. 
221.     // MARK: - Words
222. 
223.     func fetchWordById(wordId: Int) throws -> VocabCard? {
224.         let sql = """
225.         SELECT id, lemma, pos, definition, example, image_filename
226.         FROM words
227.         WHERE id = ?
228.         LIMIT 1;
229.         """
230.         let stmt = try db.prepare(sql)
231.         defer { stmt?.finalize() }
232. 
233.         try SQLiteDB.bind(stmt, 1, wordId)
234.         if sqlite3_step(stmt) == SQLITE_ROW {
235.             return VocabCard(
236.                 id: SQLiteDB.columnInt(stmt, 0),
237.                 lemma: SQLiteDB.columnText(stmt, 1) ?? "",
238.                 pos: SQLiteDB.columnText(stmt, 2),
239.                 definition: SQLiteDB.columnText(stmt, 3),
240.                 example: SQLiteDB.columnText(stmt, 4),
241.                 imageFilename: SQLiteDB.columnText(stmt, 5)
242.             )
243.         }
244.         return nil
245.     }
246. 
247.     // MARK: - Contexts
248. 
249.     func randomSatContext(wordId: Int) throws -> String? {
250.         let sql = """
251.         SELECT context
252.         FROM sat_contexts
253.         WHERE word_id = ?
254.         ORDER BY RANDOM()
255.         LIMIT 1;
256.         """
257.         let stmt = try db.prepare(sql)
258.         defer { stmt?.finalize() }
259.         try SQLiteDB.bind(stmt, 1, wordId)
260.         if sqlite3_step(stmt) == SQLITE_ROW {
```

</details>


---

<sub>⏱️ 1m 33s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift (lines 261-520)

<details>
<summary>260 lines</summary>

```
261.             return SQLiteDB.columnText(stmt, 0)
262.         }
263.         return nil
264.     }
265. 
266.     func fetchCollocations(wordId: Int, limit: Int = 6) throws -> [String] {
267.         let sql = """
268.         SELECT phrase
269.         FROM collocations
270.         WHERE word_id = ?
271.         ORDER BY id
272.         LIMIT ?;
273.         """
274.         let stmt = try db.prepare(sql)
275.         defer { stmt?.finalize() }
276.         try SQLiteDB.bind(stmt, 1, wordId)
277.         try SQLiteDB.bind(stmt, 2, limit)
278. 
279.         var out: [String] = []
280.         while sqlite3_step(stmt) == SQLITE_ROW {
281.             if let phrase = SQLiteDB.columnText(stmt, 0), !phrase.isEmpty {
282.                 out.append(phrase)
283.             }
284.         }
285.         return out
286.     }
287. 
288.     // MARK: - Review Log
289. 
290.     func logReview(userId: String, wordId: Int, listId: Int?, outcome: ReviewOutcome, durationMs: Int, reviewedAt: Date, deviceId: String) throws {
291.         let sql = """
292.         INSERT INTO review_log(user_id, word_id, list_id, outcome, duration_ms, reviewed_at, device_id)
293.         VALUES (?, ?, ?, ?, ?, ?, ?);
294.         """
295.         let stmt = try db.prepare(sql)
296.         defer { stmt?.finalize() }
297. 
298.         let iso = ISO8601DateFormatter()
299.         let reviewedAtStr = iso.string(from: reviewedAt)
300. 
301.         try SQLiteDB.bind(stmt, 1, userId)
302.         try SQLiteDB.bind(stmt, 2, wordId)
303.         try SQLiteDB.bind(stmt, 3, listId)
304.         try SQLiteDB.bind(stmt, 4, outcome.rawValue)
305.         try SQLiteDB.bind(stmt, 5, durationMs)
306.         try SQLiteDB.bind(stmt, 6, reviewedAtStr)
307.         try SQLiteDB.bind(stmt, 7, deviceId)
308. 
309.         if sqlite3_step(stmt) != SQLITE_DONE {
310.             throw SQLiteError.stepFailed(message: db.errorMessage())
311.         }
312.     }
313. 
314.     // MARK: - Session
315. 
316.     func startSession(userId: String, listId: Int?, itemsTotal: Int, startedAt: Date = Date()) throws -> Int {
317.         let sql = """
318.         INSERT INTO session(user_id, list_id, started_at, items_total, items_correct)
319.         VALUES (?, ?, ?, ?, 0);
320.         """
321.         let stmt = try db.prepare(sql)
322.         defer { stmt?.finalize() }
323. 
324.         let iso = ISO8601DateFormatter()
325.         let startedAtStr = iso.string(from: startedAt)
326. 
327.         try SQLiteDB.bind(stmt, 1, userId)
328.         try SQLiteDB.bind(stmt, 2, listId)
329.         try SQLiteDB.bind(stmt, 3, startedAtStr)
330.         try SQLiteDB.bind(stmt, 4, itemsTotal)
331. 
332.         if sqlite3_step(stmt) != SQLITE_DONE {
333.             throw SQLiteError.stepFailed(message: db.errorMessage())
334.         }
335.         return Int(db.lastInsertRowId())
336.     }
337. 
338.     func finishSession(sessionId: Int, itemsCorrect: Int, endedAt: Date = Date()) throws {
339.         let sql = """
340.         UPDATE session
341.         SET ended_at = ?, items_correct = ?
342.         WHERE id = ?;
343.         """
344.         let stmt = try db.prepare(sql)
345.         defer { stmt?.finalize() }
346. 
347.         let iso = ISO8601DateFormatter()
348.         let endedAtStr = iso.string(from: endedAt)
349. 
350.         try SQLiteDB.bind(stmt, 1, endedAtStr)
351.         try SQLiteDB.bind(stmt, 2, itemsCorrect)
352.         try SQLiteDB.bind(stmt, 3, sessionId)
353. 
354.         if sqlite3_step(stmt) != SQLITE_DONE {
355.             throw SQLiteError.stepFailed(message: db.errorMessage())
356.         }
357.     }
358. 
359.     // MARK: - Progress Snapshot
360. 
361.     func ensureProgressSnapshot(userId: String, listId: Int) throws {
362.         let sql = """
363.         INSERT OR IGNORE INTO progress_snapshot(user_id, list_id, mastered_count, total_seen, streak_days, last_reviewed_at, version)
364.         VALUES (?, ?, 0, 0, 0, NULL, 1);
365.         """
366.         let stmt = try db.prepare(sql)
367.         defer { stmt?.finalize() }
368.         try SQLiteDB.bind(stmt, 1, userId)
369.         try SQLiteDB.bind(stmt, 2, listId)
370.         if sqlite3_step(stmt) != SQLITE_DONE {
371.             throw SQLiteError.stepFailed(message: db.errorMessage())
372.         }
373.     }
374. 
375.     func fetchProgressSnapshot(userId: String, listId: Int) throws -> ProgressSnapshot? {
376.         let sql = """
377.         SELECT user_id, list_id, mastered_count, total_seen, streak_days, last_reviewed_at, version
378.         FROM progress_snapshot
379.         WHERE user_id = ? AND list_id = ?
380.         LIMIT 1;
381.         """
382.         let stmt = try db.prepare(sql)
383.         defer { stmt?.finalize() }
384.         try SQLiteDB.bind(stmt, 1, userId)
385.         try SQLiteDB.bind(stmt, 2, listId)
386.         if sqlite3_step(stmt) == SQLITE_ROW {
387.             let userId = SQLiteDB.columnText(stmt, 0) ?? ""
388.             let listId = SQLiteDB.columnInt(stmt, 1)
389.             let mastered = SQLiteDB.columnInt(stmt, 2)
390.             let totalSeen = SQLiteDB.columnInt(stmt, 3)
391.             let streak = SQLiteDB.columnInt(stmt, 4)
392.             let lastStr = SQLiteDB.columnText(stmt, 5)
393.             let version = SQLiteDB.columnInt(stmt, 6)
394. 
395.             var lastDate: Date? = nil
396.             if let lastStr {
397.                 lastDate = ISO8601DateFormatter().date(from: lastStr)
398.             }
399. 
400.             return ProgressSnapshot(userId: userId, listId: listId, masteredCount: mastered, totalSeen: totalSeen, streakDays: streak, lastReviewedAt: lastDate, version: version)
401.         }
402.         return nil
403.     }
404. 
405.     func updateProgressAfterSession(userId: String, listId: Int, itemsTotal: Int, itemsCorrect: Int, finishedAt: Date = Date()) throws {
406.         try ensureProgressSnapshot(userId: userId, listId: listId)
407. 
408.         let iso = ISO8601DateFormatter()
409.         let finishedStr = iso.string(from: finishedAt)
410. 
411.         let current = try fetchProgressSnapshot(userId: userId, listId: listId)
412.         let calendar = Calendar.current
413. 
414.         var newStreak = current?.streakDays ?? 0
415.         if let last = current?.lastReviewedAt {
416.             if calendar.isDateInToday(last) {
417.                 // keep streak
418.             } else if calendar.isDate(last, inSameDayAs: calendar.date(byAdding: .day, value: -1, to: finishedAt) ?? last) {
419.                 newStreak += 1
420.             } else {
421.                 newStreak = 1
422.             }
423.         } else {
424.             newStreak = 1
425.         }
426. 
427.         let sql = """
428.         UPDATE progress_snapshot
429.         SET mastered_count = mastered_count + ?,
430.             total_seen = total_seen + ?,
431.             streak_days = ?,
432.             last_reviewed_at = ?
433.         WHERE user_id = ? AND list_id = ?;
434.         """
435.         let stmt = try db.prepare(sql)
436.         defer { stmt?.finalize() }
437. 
438.         try SQLiteDB.bind(stmt, 1, itemsCorrect)
439.         try SQLiteDB.bind(stmt, 2, itemsTotal)
440.         try SQLiteDB.bind(stmt, 3, newStreak)
441.         try SQLiteDB.bind(stmt, 4, finishedStr)
442.         try SQLiteDB.bind(stmt, 5, userId)
443.         try SQLiteDB.bind(stmt, 6, listId)
444. 
445.         if sqlite3_step(stmt) != SQLITE_DONE {
446.             throw SQLiteError.stepFailed(message: db.errorMessage())
447.         }
448.     }
449. 
450.     // MARK: - Task 3
451. 
452.     func fetchWeakWords(userId: String, listId: Int, limit: Int) throws -> [Int] {
453.         // Weak words heuristic:
454.         // - at least 3 attempts
455.         // - correct_rate < 0.7
456.         // Ordered by worst first.
457.         let sql = """
458.         SELECT rl.word_id
459.         FROM review_log rl
460.         JOIN word_list wl ON wl.word_id = rl.word_id AND wl.list_id = ?
461.         WHERE rl.user_id = ?
462.         GROUP BY rl.word_id
463.         HAVING COUNT(*) >= 3
464.            AND (SUM(CASE WHEN rl.outcome='correct' THEN 1 ELSE 0 END) * 1.0 / COUNT(*)) < 0.7
465.         ORDER BY (SUM(CASE WHEN rl.outcome='correct' THEN 1 ELSE 0 END) * 1.0 / COUNT(*)) ASC
466.         LIMIT ?;
467.         """
468.         let stmt = try db.prepare(sql)
469.         defer { stmt?.finalize() }
470. 
471.         try SQLiteDB.bind(stmt, 1, listId)
472.         try SQLiteDB.bind(stmt, 2, userId)
473.         try SQLiteDB.bind(stmt, 3, limit)
474. 
475.         var out: [Int] = []
476.         while sqlite3_step(stmt) == SQLITE_ROW {
477.             out.append(SQLiteDB.columnInt(stmt, 0))
478.         }
479.         return out
480.     }
481. 
482.     func fetchDistractors(listId: Int, pos: String?, excludeWordId: Int, limit: Int) throws -> [VocabCard] {
483.         // Prefer same POS if available.
484.         let sqlWithPos = """
485.         SELECT w.id, w.lemma, w.pos, w.definition, w.example, w.image_filename
486.         FROM word_list wl
487.         JOIN words w ON w.id = wl.word_id
488.         WHERE wl.list_id = ? AND w.id != ? AND w.pos = ?
489.         ORDER BY RANDOM()
490.         LIMIT ?;
491.         """
492.         let sqlNoPos = """
493.         SELECT w.id, w.lemma, w.pos, w.definition, w.example, w.image_filename
494.         FROM word_list wl
495.         JOIN words w ON w.id = wl.word_id
496.         WHERE wl.list_id = ? AND w.id != ?
497.         ORDER BY RANDOM()
498.         LIMIT ?;
499.         """
500. 
501.         var out: [VocabCard] = []
502. 
503.         if let pos, !pos.isEmpty {
504.             let stmt = try db.prepare(sqlWithPos)
505.             defer { stmt?.finalize() }
506.             try SQLiteDB.bind(stmt, 1, listId)
507.             try SQLiteDB.bind(stmt, 2, excludeWordId)
508.             try SQLiteDB.bind(stmt, 3, pos)
509.             try SQLiteDB.bind(stmt, 4, limit)
510.             while sqlite3_step(stmt) == SQLITE_ROW {
511.                 out.append(VocabCard(
512.                     id: SQLiteDB.columnInt(stmt, 0),
513.                     lemma: SQLiteDB.columnText(stmt, 1) ?? "",
514.                     pos: SQLiteDB.columnText(stmt, 2),
515.                     definition: SQLiteDB.columnText(stmt, 3),
516.                     example: SQLiteDB.columnText(stmt, 4),
517.                     imageFilename: SQLiteDB.columnText(stmt, 5)
518.                 ))
519.             }
520.         }
```

</details>


---

<sub>⏱️ 1m 33s</sub>

### ✅ `rg`

**/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data**

<details>
<summary>Arguments</summary>

```json
{
  "pattern": "DataManager\\.shared\\.db|static let shared = .*Store\\(|private var db: SQLiteDB \\{ DataManager\\.shared\\.db \\}|actor .*Store",
  "path": "/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data",
  "output_mode": "content",
  "-n": true,
  "head_limit": 300
}
```

</details>

<details>
<summary>12 lines</summary>

```
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/AdventureProgressStore.swift:4:    static let shared = AdventureProgressStore()
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/TaskProgressStore.swift:4:    static let shared = TaskProgressStore()
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/StatsStore.swift:14:actor StatsStore {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/StatsStore.swift:15:    static let shared = StatsStore()
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/StatsStore.swift:17:    private var db: SQLiteDB { DataManager.shared.db }
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SessionStateStore.swift:4:actor SessionStateStore {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SessionStateStore.swift:5:    static let shared = SessionStateStore()
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SessionStateStore.swift:7:    private var db: SQLiteDB { DataManager.shared.db }
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/WordStateStore.swift:21:actor WordStateStore {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/ZoneStore.swift:4:actor ZoneStore {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/ZoneStore.swift:5:    static let shared = ZoneStore()
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/ZoneStore.swift:7:    private var db: SQLiteDB { DataManager.shared.db }
```

</details>


---

<sub>⏱️ 1m 38s</sub>

### ◌ Conversation Compacted

---

<sub>⏱️ 2m 13s</sub>

### 💬 Copilot

I’ve got the review points. I’m writing the brief implementation review file now, focused on the concrete spec mismatches and the couple of bugs that would actually change progression behavior.

---

<sub>⏱️ 2m 13s</sub>

### ✅ `apply_patch`

<details>
<summary>Arguments</summary>

```json
"*** Begin Patch\n*** Add File: /Users/jiong/myprojects/satspell/docs/reviews/plan1-implementation-review.md\n+`SchemaV2.swift` is close to `docs/data-schema.md`, and I did not find direct SQL injection issues: the stores consistently use prepared statements, and the one dynamic `IN (...)` clause only interpolates placeholder tokens, not user data. The bigger issue is that the implementation is only partially migrated to the new schema. `DataManager.swift` still ships legacy `progress_snapshot` APIs and older `logReview` / `startSession` methods that do not match the V2 tables, and `initializeIfNeeded()` does not create the required Day 0 `day_state` row from the schema lifecycle.\n+\n+The most important logic bug is in `WordStateStore.recordScoredAnswer()`: it promotes box-0 words on any correct answer and always increments `day_touches`, which conflicts with the spec’s Day 1 flow where new words stay at box 0 until the end-of-evening promotion decision and rushed answers should not count toward promotion. `runDay1Promotion()` has a second correctness issue: it does not filter its `review_log` counts by `study_day`, so historical attempts can affect today’s promotion result.\n+\n+Actor isolation is also shaky. `DataManager` exposes a single `nonisolated` SQLite connection, while `StatsStore`, `SessionStateStore`, and `ZoneStore` are separate actors that all use that same handle, so actor boundaries do not actually serialize DB access. Finally, several update-only methods can fail silently at the data level: `StatsStore` and `SessionStateStore` often `UPDATE` rows without first ensuring they exist or checking affected-row count, and `parseSessionState()` swallows bad JSON with `try?`, which can erase paused-session state instead of surfacing corruption.\n*** End Patch\n"
```

</details>

```
Added 1 file(s): /Users/jiong/myprojects/satspell/docs/reviews/plan1-implementation-review.md
```


---

<sub>⏱️ 2m 22s</sub>

### 💬 Copilot

The review file is in place. I’m doing one quick pass on the saved text for length and wording, then I’ll close this out.

---

<sub>⏱️ 2m 23s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/docs/reviews/plan1-implementation-review.md.**

/Users/jiong/myprojects/satspell/docs/reviews/plan1-implementation-review.md

<details>
<summary>6 lines</summary>

```
1. `SchemaV2.swift` is close to `docs/data-schema.md`, and I did not find direct SQL injection issues: the stores consistently use prepared statements, and the one dynamic `IN (...)` clause only interpolates placeholder tokens, not user data. The bigger issue is that the implementation is only partially migrated to the new schema. `DataManager.swift` still ships legacy `progress_snapshot` APIs and older `logReview` / `startSession` methods that do not match the V2 tables, and `initializeIfNeeded()` does not create the required Day 0 `day_state` row from the schema lifecycle.
2. 
3. The most important logic bug is in `WordStateStore.recordScoredAnswer()`: it promotes box-0 words on any correct answer and always increments `day_touches`, which conflicts with the spec’s Day 1 flow where new words stay at box 0 until the end-of-evening promotion decision and rushed answers should not count toward promotion. `runDay1Promotion()` has a second correctness issue: it does not filter its `review_log` counts by `study_day`, so historical attempts can affect today’s promotion result.
4. 
5. Actor isolation is also shaky. `DataManager` exposes a single `nonisolated` SQLite connection, while `StatsStore`, `SessionStateStore`, and `ZoneStore` are separate actors that all use that same handle, so actor boundaries do not actually serialize DB access. Finally, several update-only methods can fail silently at the data level: `StatsStore` and `SessionStateStore` often `UPDATE` rows without first ensuring they exist or checking affected-row count, and `parseSessionState()` swallows bad JSON with `try?`, which can erase paused-session state instead of surfacing corruption.
6.
```

</details>


---

<sub>⏱️ 2m 23s</sub>

### ✅ `bash`

**Count words in review file**

$ cd /Users/jiong/myprojects/satspell && wc -w docs/reviews/plan1-implementation-review.md

```
231 docs/reviews/plan1-implementation-review.md
<exited with exit code 0>
```


---

<sub>⏱️ 2m 23s</sub>

### ✅ `sql`

**Complete review todos**

<details>
<summary>Arguments</summary>

```json
{
  "description": "Complete review todos",
  "query": "UPDATE todos SET status = 'done' WHERE id IN ('audit-plan1-implementation','write-plan1-review');\nSELECT id, title, status FROM todos WHERE id IN ('read-plan1-implementation','audit-plan1-implementation','write-plan1-review') ORDER BY created_at;"
}
```

</details>

<details>
<summary>10 lines</summary>

```
Executed 2 statement(s):

1. UPDATE
   2 row(s) updated.

2. SELECT
   3 row(s) returned:
   
   | id | title | status |
   | --- | --- | --- |
   | audit-plan1-implementation | Audit data layer implementation | done |
   | read-plan1-implementation | Read Plan 1 implementation | done |
   | write-plan1-review | Write plan1 implementation review | done |
```

</details>


---

<sub>⏱️ 2m 28s</sub>

### 💬 Copilot

Added the review to `docs/reviews/plan1-implementation-review.md`.

Main findings: the schema layer is mostly aligned and I didn’t find direct SQL injection, but there are important implementation gaps: `DataManager` still contains legacy V1-style APIs not backed by the V2 schema, `initializeIfNeeded()` misses the required Day 0 `day_state` seed, `WordStateStore.recordScoredAnswer()` breaks the Day 1 promotion model by promoting box-0 words too early, `runDay1Promotion()` ignores `study_day`, and the shared `nonisolated` SQLite handle weakens actor isolation while some update paths can fail silently.

---

<sub>Generated by [GitHub Copilot CLI](https://github.com/features/copilot/cli)</sub>
