# 🤖 Copilot CLI Session

> [!NOTE]
> - **Session ID:** `f7a296a4-ca41-488b-8f27-e023b8278c0e`  
> - **Started:** 4/12/2026, 5:21:27 PM  
> - **Duration:** 9m 57s  
> - **Exported:** 4/12/2026, 5:31:24 PM  

---

<sub>⏱️ 2s</sub>

### 👤 User

You are doing a DEEP CODE REVIEW of the SAT Vocab iOS app implementation. NOT documents — the actual Swift source code.

Read EVERY Swift file in the implementation:

DATA LAYER:
- ios/SATVocabApp/Sources/SATVocabApp/Data/SchemaV2.swift
- ios/SATVocabApp/Sources/SATVocabApp/Data/ContentImporter.swift
- ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift
- ios/SATVocabApp/Sources/SATVocabApp/Data/WordStateStore.swift
- ios/SATVocabApp/Sources/SATVocabApp/Data/SessionStateStore.swift
- ios/SATVocabApp/Sources/SATVocabApp/Data/StatsStore.swift
- ios/SATVocabApp/Sources/SATVocabApp/Data/ZoneStore.swift
- ios/SATVocabApp/Sources/SATVocabApp/Data/ReviewLogger.swift
- ios/SATVocabApp/Sources/SATVocabApp/Data/SQLite.swift

MODELS:
- ios/SATVocabApp/Sources/SATVocabApp/Models/Enums.swift
- ios/SATVocabApp/Sources/SATVocabApp/Models/Models.swift

VIEW MODELS:
- ios/SATVocabApp/Sources/SATVocabApp/ViewModels/SessionFlowViewModel.swift

KEY VIEWS:
- ios/SATVocabApp/Sources/SATVocabApp/Views/Session/SessionFlowView.swift
- ios/SATVocabApp/Sources/SATVocabApp/Views/Flashcard/FlashcardFrontView.swift
- ios/SATVocabApp/Sources/SATVocabApp/Views/Flashcard/FlashcardBackView.swift
- ios/SATVocabApp/Sources/SATVocabApp/Views/Flashcard/FlashcardCardView.swift
- ios/SATVocabApp/Sources/SATVocabApp/Views/Flashcard/FlashcardStepView.swift
- ios/SATVocabApp/Sources/SATVocabApp/Views/Game/ImageGameView.swift
- ios/SATVocabApp/Sources/SATVocabApp/Views/Game/QuickRecallView.swift
- ios/SATVocabApp/Sources/SATVocabApp/Views/Game/SATQuestionView.swift
- ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/PracticeTabView.swift
- ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/PracticeStateResolver.swift
- ios/SATVocabApp/Sources/SATVocabApp/Views/RootTabView.swift

TESTS:
- ios/SATVocabApp/Tests/SATVocabAppTests/Data/WordStateStoreTests.swift
- ios/SATVocabApp/Tests/SATVocabAppTests/Data/StatsStoreTests.swift
- ios/SATVocabApp/Tests/SATVocabAppTests/Data/SchemaTests.swift
- ios/SATVocabApp/Tests/SATVocabAppTests/Data/ReviewLoggerTests.swift

Review for:
1. CRASH RISKS — any force unwraps, array out of bounds, nil dereferences that could crash
2. DATA CORRUPTION — any SQL that could corrupt word_state, lose progress, or double-count XP
3. ACTOR ISOLATION — any sendability issues, data races, or deadlocks between actors
4. FIRST LAUNCH — trace the path: app opens → DataManager.initializeIfNeeded() → ContentImporter → loadWords(). Will it work?
5. EMPTY STATES — what happens when word lists are empty, no reviews exist, no session started?
6. SQL INJECTION — any string interpolation with user-supplied values in SQL
7. MEMORY LEAKS — any retain cycles in closures, especially in SwiftUI views
8. MISSING FUNCTIONALITY — compare against docs/data-schema.md Section 5 (data lifecycle). Is anything not implemented that should be?

If you find issues, also try to write and run a test to verify the bug:
cd ios/SATVocabApp && xcodebuild test -scheme SATVocabApp -destination 'platform=iOS Simulator,name=iPhone 17 Pro Max' -only-testing:SATVocabAppTests 2\>&1 | grep -E 'Test Case|passed|failed|Executed'

Write your complete findings to docs/reviews/code-review-implementation.md — include severity (CRITICAL/HIGH/MEDIUM/LOW) for each issue, the exact file:line, and a suggested fix.

---

<sub>⏱️ 19s</sub>

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

<sub>⏱️ 42s</sub>

### 💬 Copilot

Using the systematic-debugging and parallel-agents skills so I can split this into focused code audits: data/model correctness, session/view flow, and test coverage/verification. I’m also pulling the existing todo state and the full target file set now.

---

<sub>⏱️ 42s</sub>

### ✅ `skill`

**systematic-debugging**

<details>
<summary>Arguments</summary>

```json
{
  "skill": "systematic-debugging"
}
```

</details>

```
Skill "systematic-debugging" loaded successfully. Follow the instructions in the skill context.
```


---

<sub>⏱️ 42s</sub>

### ✅ `skill`

**dispatching-parallel-agents**

<details>
<summary>Arguments</summary>

```json
{
  "skill": "dispatching-parallel-agents"
}
```

</details>

```
Skill "dispatching-parallel-agents" loaded successfully. Follow the instructions in the skill context.
```


---

<sub>⏱️ 42s</sub>

### ✅ `sql`

**Start deep review todos**

<details>
<summary>Arguments</summary>

```json
{
  "description": "Start deep review todos",
  "query": "SELECT t.id, t.title, t.status FROM todos t WHERE t.status = 'pending' AND NOT EXISTS (SELECT 1 FROM todo_deps td JOIN todos dep ON td.depends_on = dep.id WHERE td.todo_id = t.id AND dep.status != 'done') ORDER BY t.created_at;\nINSERT INTO todos (id, title, description, status) VALUES\n  ('deep-review-data-layer', 'Review data layer code', 'Audit schema, importer, SQLite wrapper, data manager, and stores for crash risks, corruption, actor isolation, first-launch flow, SQL safety, and missing lifecycle functionality.', 'in_progress'),\n  ('deep-review-ui-flow', 'Review session and practice flow', 'Audit session view model and key SwiftUI views for crash risks, empty states, retain cycles, error handling, and first-launch behavior.', 'pending'),\n  ('deep-review-tests', 'Review and run tests', 'Audit existing unit tests, add focused regression tests for confirmed bugs when feasible, and run SATVocabAppTests with xcodebuild.', 'pending'),\n  ('write-deep-review', 'Write implementation review doc', 'Write docs/reviews/code-review-implementation.md with severity, exact file:line references, and suggested fixes.', 'pending')\nON CONFLICT(id) DO UPDATE SET description=excluded.description;\nSELECT id, title, status FROM todos WHERE id IN ('deep-review-data-layer','deep-review-ui-flow','deep-review-tests','write-deep-review') ORDER BY created_at;"
}
```

</details>

<details>
<summary>17 lines</summary>

```
Executed 3 statement(s):

1. SELECT
   2 row(s) returned:
   
   | id | title | status |
   | --- | --- | --- |
   | audit-test-coverage | Audit test coverage | pending |
   | append-testing-review | Append testing review | pending |

2. INSERT
   4 row(s) inserted. Last inserted row ID: 25.

3. SELECT
   4 row(s) returned:
   
   | id | title | status |
   | --- | --- | --- |
   | deep-review-data-layer | Review data layer code | in_progress |
   | deep-review-tests | Review and run tests | pending |
   | deep-review-ui-flow | Review session and practice flow | pending |
   | write-deep-review | Write implementation review doc | pending |
```

</details>


---

<sub>⏱️ 42s</sub>

### ✅ `view`

**view the file at /Users/jiong/.copilot/session-state/f7a296a4-ca41-488b-8f27-e023b8278c0e/plan.md.**

/Users/jiong/.copilot/session-state/f7a296a4-ca41-488b-8f27-e023b8278c0e/plan.md (lines 1-220)

<details>
<summary>6 lines</summary>

```
1. # Activities UI Mockup Plan
2. 
3. 1. Synthesize the visual system from the points, game, and flashcard specs into a single premium direction: deep navy background, realistic iPhone shells, activity-specific accent glows, Duolingo-style 3D controls, and clearer student-facing rewards.
4. 2. Build a self-contained HTML review artifact at `docs/reviews/activities-ui-polished.html` showing four phone mockups plus a reward/points surface with XP, combo, streak, and the 5-stage Word Strength meter.
5. 3. Append a short follow-up review to `docs/points-system.md` with concrete recommendations tightened by the mockup pass, then verify the HTML/document updates render cleanly at a markup level.
6.
```

</details>


---

<sub>⏱️ 42s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SQLite.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SQLite.swift

<details>
<summary>137 lines</summary>

```
1. import Foundation
2. import SQLite3
3. 
4. private let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
5. 
6. enum SQLiteError: Error, CustomStringConvertible {
7.     case openFailed(message: String)
8.     case prepareFailed(message: String)
9.     case stepFailed(message: String)
10.     case bindFailed(message: String)
11. 
12.     var description: String {
13.         switch self {
14.         case .openFailed(let m): return "SQLite open failed: \(m)"
15.         case .prepareFailed(let m): return "SQLite prepare failed: \(m)"
16.         case .stepFailed(let m): return "SQLite step failed: \(m)"
17.         case .bindFailed(let m): return "SQLite bind failed: \(m)"
18.         }
19.     }
20. }
21. 
22. final class SQLiteDB {
23.     private var db: OpaquePointer?
24. 
25.     func open(path: String) throws {
26.         if sqlite3_open(path, &db) != SQLITE_OK {
27.             throw SQLiteError.openFailed(message: String(cString: sqlite3_errmsg(db)))
28.         }
29.         _ = sqlite3_exec(db, "PRAGMA foreign_keys = ON;", nil, nil, nil)
30.     }
31. 
32.     func close() {
33.         if let db {
34.             sqlite3_close(db)
35.         }
36.         db = nil
37.     }
38. 
39.     func prepare(_ sql: String) throws -> OpaquePointer? {
40.         var stmt: OpaquePointer?
41.         if sqlite3_prepare_v2(db, sql, -1, &stmt, nil) != SQLITE_OK {
42.             throw SQLiteError.prepareFailed(message: String(cString: sqlite3_errmsg(db)))
43.         }
44.         return stmt
45.     }
46. 
47.     func exec(_ sql: String) throws {
48.         var errMsg: UnsafeMutablePointer<Int8>?
49.         if sqlite3_exec(db, sql, nil, nil, &errMsg) != SQLITE_OK {
50.             let msg = errMsg.map { String(cString: $0) } ?? "unknown"
51.             sqlite3_free(errMsg)
52.             throw SQLiteError.stepFailed(message: msg)
53.         }
54.     }
55. 
56.     func lastInsertRowId() -> Int64 {
57.         sqlite3_last_insert_rowid(db)
58.     }
59. 
60.     func errorMessage() -> String {
61.         String(cString: sqlite3_errmsg(db))
62.     }
63. }
64. 
65. extension OpaquePointer {
66.     func finalize() {
67.         sqlite3_finalize(self)
68.     }
69. }
70. 
71. extension SQLiteDB {
72.     static func bind(_ stmt: OpaquePointer?, _ index: Int32, _ value: String?) throws {
73.         let rc: Int32
74.         if let v = value {
75.             rc = sqlite3_bind_text(stmt, index, v, -1, SQLITE_TRANSIENT)
76.         } else {
77.             rc = sqlite3_bind_null(stmt, index)
78.         }
79.         if rc != SQLITE_OK {
80.             throw SQLiteError.bindFailed(message: "bind text/null failed")
81.         }
82.     }
83. 
84.     static func bind(_ stmt: OpaquePointer?, _ index: Int32, _ value: Int?) throws {
85.         let rc: Int32
86.         if let v = value {
87.             rc = sqlite3_bind_int(stmt, index, Int32(v))
88.         } else {
89.             rc = sqlite3_bind_null(stmt, index)
90.         }
91.         if rc != SQLITE_OK {
92.             throw SQLiteError.bindFailed(message: "bind int/null failed")
93.         }
94.     }
95. 
96.     static func bind(_ stmt: OpaquePointer?, _ index: Int32, _ value: Int64?) throws {
97.         let rc: Int32
98.         if let v = value {
99.             rc = sqlite3_bind_int64(stmt, index, v)
100.         } else {
101.             rc = sqlite3_bind_null(stmt, index)
102.         }
103.         if rc != SQLITE_OK {
104.             throw SQLiteError.bindFailed(message: "bind int64/null failed")
105.         }
106.     }
107. 
108.     static func columnText(_ stmt: OpaquePointer?, _ idx: Int32) -> String? {
109.         guard let c = sqlite3_column_text(stmt, idx) else { return nil }
110.         return String(cString: c)
111.     }
112. 
113.     static func columnInt(_ stmt: OpaquePointer?, _ idx: Int32) -> Int {
114.         Int(sqlite3_column_int(stmt, idx))
115.     }
116. 
117.     static func columnInt64(_ stmt: OpaquePointer?, _ idx: Int32) -> Int64 {
118.         sqlite3_column_int64(stmt, idx)
119.     }
120. 
121.     static func columnDouble(_ stmt: OpaquePointer?, _ idx: Int32) -> Double {
122.         sqlite3_column_double(stmt, idx)
123.     }
124. 
125.     static func bind(_ stmt: OpaquePointer?, _ index: Int32, _ value: Double?) throws {
126.         let rc: Int32
127.         if let v = value {
128.             rc = sqlite3_bind_double(stmt, index, v)
129.         } else {
130.             rc = sqlite3_bind_null(stmt, index)
131.         }
132.         if rc != SQLITE_OK {
133.             throw SQLiteError.bindFailed(message: "bind double/null failed")
134.         }
135.     }
136. }
137.
```

</details>


---

<sub>⏱️ 42s</sub>

### ✅ `rg`

**/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp**

<details>
<summary>Arguments</summary>

```json
{
  "pattern": "(struct|class|actor|enum)\\s+|force|!\\)|\\[[^\\]]+\\]|fatalError|precondition|try!|as!|Task \\{|@Published|sqlite3_step|prepare\\(|db\\.exec\\(|defer \\{|JSONDecoder|JSONEncoder",
  "path": "/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp",
  "glob": "**/*.swift",
  "output_mode": "content",
  "-n": true,
  "head_limit": 400
}
```

</details>

<details>
<summary>7 lines</summary>

```
Output too large to read at once (75.7 KB). Saved to: /var/folders/lw/yv880yw12w36hj114qn16_g00000gn/T/copilot-tool-output-1776028929894-3uop9b.txt
Consider using tools like grep (for searching), head/tail (for viewing start/end), view with view_range (for specific sections), or jq (for JSON) to examine portions of the output.

Preview (first 500 chars):
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Components/XPChipView.swift:3:struct XPChipView: View {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SchemaV2.swift:5:enum SchemaV2 {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SchemaV2.swift:9:    static let createStatements: [String] = [
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SchemaV2.swift:262:    static let createIndexes: [S
```

</details>


---

<sub>⏱️ 1m 54s</sub>

### 💬 Copilot

I’m splitting the audit into three independent tracks now: data/model correctness, SwiftUI/session flow, and test coverage. In parallel, I’m reading the remaining view/test files locally and kicking off the unit test run so I can cross-check the code review against actual behavior.

---

<sub>⏱️ 1m 54s</sub>

### ✅ `task`

**Audit data layer**

<details>
<summary>Arguments</summary>

```json
{
  "description": "Audit data layer",
  "prompt": "You are performing a deep code review of the SAT Vocab iOS app implementation. Investigate ONLY the data/model layer and compare behavior against docs/data-schema.md Section 5 lifecycle expectations.\n\nRead these files completely:\n- /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SchemaV2.swift\n- /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/ContentImporter.swift\n- /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift\n- /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/WordStateStore.swift\n- /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SessionStateStore.swift\n- /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/StatsStore.swift\n- /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/ZoneStore.swift\n- /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/ReviewLogger.swift\n- /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SQLite.swift\n- /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Models/Enums.swift\n- /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Models/Models.swift\n- /Users/jiong/myprojects/satspell/docs/data-schema.md\n\nFocus on:\n1. CRASH RISKS\n2. DATA CORRUPTION / progress loss / XP double counting\n3. ACTOR ISOLATION / data races / sendability\n4. FIRST LAUNCH path: initializeIfNeeded -> import -> first session load\n5. EMPTY STATES relevant to data APIs\n6. SQL INJECTION\n7. MISSING FUNCTIONALITY vs docs/data-schema.md Section 5 lifecycle\n\nReturn only concrete findings. For each finding include: severity (CRITICAL/HIGH/MEDIUM/LOW), exact file:line, concise explanation, and suggested fix. Also mention any candidate regression tests that would best prove the bug. Do not modify files.",
  "agent_type": "explore",
  "name": "data-layer-audit",
  "mode": "background",
  "model": "claude-haiku-4.5"
}
```

</details>

```
Agent started in background with agent_id: data-layer-audit. You can use read_agent tool with this agent_id to check status and retrieve results. Instruct the user to use /tasks to manage the background agent.
```


---

<sub>⏱️ 1m 54s</sub>

### ✅ `task`

**Audit UI flow**

<details>
<summary>Arguments</summary>

```json
{
  "description": "Audit UI flow",
  "prompt": "You are performing a deep code review of the SAT Vocab iOS app implementation. Investigate ONLY the view model and SwiftUI flow layer.\n\nRead these files completely:\n- /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/SessionFlowViewModel.swift\n- /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Session/SessionFlowView.swift\n- /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Flashcard/FlashcardFrontView.swift\n- /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Flashcard/FlashcardBackView.swift\n- /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Flashcard/FlashcardCardView.swift\n- /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Flashcard/FlashcardStepView.swift\n- /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/ImageGameView.swift\n- /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/QuickRecallView.swift\n- /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/SATQuestionView.swift\n- /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/PracticeTabView.swift\n- /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/PracticeStateResolver.swift\n- /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/RootTabView.swift\n\nFocus on:\n1. CRASH RISKS (force unwraps, index errors, invalid assumptions)\n2. EMPTY STATES and zero-word flows\n3. ERROR HANDLING and user-visible failure modes\n4. MEMORY LEAKS / retain cycles in closures / Tasks\n5. FIRST-LAUNCH behavior through the session flow\n6. Any significant UX or state bugs caused by missing data or async timing\n\nReturn only concrete findings. For each finding include: severity (CRITICAL/HIGH/MEDIUM/LOW), exact file:line, concise explanation, and suggested fix. Do not modify files.",
  "agent_type": "explore",
  "name": "ui-flow-audit",
  "mode": "background",
  "model": "claude-haiku-4.5"
}
```

</details>

```
Agent started in background with agent_id: ui-flow-audit. You can use read_agent tool with this agent_id to check status and retrieve results. Instruct the user to use /tasks to manage the background agent.
```


---

<sub>⏱️ 1m 54s</sub>

### ✅ `task`

**Audit tests**

<details>
<summary>Arguments</summary>

```json
{
  "description": "Audit tests",
  "prompt": "You are performing a deep code review of the SAT Vocab iOS app tests. Investigate ONLY the listed unit tests.\n\nRead these files completely:\n- /Users/jiong/myprojects/satspell/ios/SATVocabApp/Tests/SATVocabAppTests/Data/WordStateStoreTests.swift\n- /Users/jiong/myprojects/satspell/ios/SATVocabApp/Tests/SATVocabAppTests/Data/StatsStoreTests.swift\n- /Users/jiong/myprojects/satspell/ios/SATVocabApp/Tests/SATVocabAppTests/Data/SchemaTests.swift\n- /Users/jiong/myprojects/satspell/ios/SATVocabApp/Tests/SATVocabAppTests/Data/ReviewLoggerTests.swift\n\nDetermine:\n1. Which critical bugs in the current implementation are already covered\n2. Which serious issues are not covered at all\n3. The best candidate regression tests to add if specific bugs are confirmed\n\nReturn concise findings with exact file:line references where relevant. Do not modify files or run commands.",
  "agent_type": "explore",
  "name": "test-audit",
  "mode": "background",
  "model": "claude-haiku-4.5"
}
```

</details>

```
Agent started in background with agent_id: test-audit. You can use read_agent tool with this agent_id to check status and retrieve results. Instruct the user to use /tasks to manage the background agent.
```


---

<sub>⏱️ 1m 54s</sub>

### ✅ `sql`

**Advance deep review todos**

<details>
<summary>Arguments</summary>

```json
{
  "description": "Advance deep review todos",
  "query": "UPDATE todos SET status = 'in_progress' WHERE id IN ('deep-review-ui-flow','deep-review-tests');\nSELECT id, title, status FROM todos WHERE id IN ('deep-review-data-layer','deep-review-ui-flow','deep-review-tests','write-deep-review') ORDER BY created_at;"
}
```

</details>

<details>
<summary>11 lines</summary>

```
Executed 2 statement(s):

1. UPDATE
   2 row(s) updated.

2. SELECT
   4 row(s) returned:
   
   | id | title | status |
   | --- | --- | --- |
   | deep-review-data-layer | Review data layer code | in_progress |
   | deep-review-tests | Review and run tests | in_progress |
   | deep-review-ui-flow | Review session and practice flow | in_progress |
   | write-deep-review | Write implementation review doc | pending |
```

</details>


---

<sub>⏱️ 1m 59s</sub>

### ✅ `bash`

**Run SATVocabApp unit tests**

$ cd /Users/jiong/myprojects/satspell/ios/SATVocabApp && xcodebuild test -scheme SATVocabApp -destination 'platform=iOS Simulator,name=iPhone 17 Pro Max' -only-testing:SATVocabAppTests 2>&1 | grep -E 'Test Case|passed|failed|Executed'

<details>
<summary>81 lines</summary>

```
Ignoring --strip-bitcode because --sign was not passed
Ignoring --strip-bitcode because --sign was not passed
Test Case '-[SATVocabAppTests.ReviewLoggerTests testLogReviewWritesEntry]' started.
Test Case '-[SATVocabAppTests.ReviewLoggerTests testLogReviewWritesEntry]' passed (0.132 seconds).
Test Case '-[SATVocabAppTests.ReviewLoggerTests testSupersedeMarksEntriesAsSuperseded]' started.
Test Case '-[SATVocabAppTests.ReviewLoggerTests testSupersedeMarksEntriesAsSuperseded]' passed (0.003 seconds).
Test Suite 'ReviewLoggerTests' passed at 2026-04-12 17:23:25.726.
	 Executed 2 tests, with 0 failures (0 unexpected) in 0.135 (0.136) seconds
Test Case '-[SATVocabAppTests.SchemaTests testForeignKeysEnabled]' started.
Test Case '-[SATVocabAppTests.SchemaTests testForeignKeysEnabled]' passed (0.001 seconds).
Test Case '-[SATVocabAppTests.SchemaTests testSchemaCreatesAllTables]' started.
Test Case '-[SATVocabAppTests.SchemaTests testSchemaCreatesAllTables]' passed (0.001 seconds).
Test Case '-[SATVocabAppTests.SchemaTests testSchemaIsIdempotent]' started.
Test Case '-[SATVocabAppTests.SchemaTests testSchemaIsIdempotent]' passed (0.001 seconds).
Test Suite 'SchemaTests' passed at 2026-04-12 17:23:25.729.
	 Executed 3 tests, with 0 failures (0 unexpected) in 0.003 (0.003) seconds
Test Case '-[SATVocabAppTests.StatsStoreTests testFirstDayStreakIsOne]' started.
Test Case '-[SATVocabAppTests.StatsStoreTests testFirstDayStreakIsOne]' passed (0.007 seconds).
Test Case '-[SATVocabAppTests.StatsStoreTests testGetOrCreateDailyStats]' started.
Test Case '-[SATVocabAppTests.StatsStoreTests testGetOrCreateDailyStats]' passed (0.002 seconds).
Test Case '-[SATVocabAppTests.StatsStoreTests testRecordCorrectAddsXP]' started.
Test Case '-[SATVocabAppTests.StatsStoreTests testRecordCorrectAddsXP]' passed (0.001 seconds).
Test Case '-[SATVocabAppTests.StatsStoreTests testRecordWrongNoXP]' started.
Test Case '-[SATVocabAppTests.StatsStoreTests testRecordWrongNoXP]' passed (0.001 seconds).
Test Case '-[SATVocabAppTests.StatsStoreTests testSessionBonus]' started.
Test Case '-[SATVocabAppTests.StatsStoreTests testSessionBonus]' passed (0.002 seconds).
Test Case '-[SATVocabAppTests.StatsStoreTests testStreakMilestoneAt3Days]' started.
Test Case '-[SATVocabAppTests.StatsStoreTests testStreakMilestoneAt3Days]' passed (0.001 seconds).
Test Case '-[SATVocabAppTests.StatsStoreTests testStreakMilestoneClaimedOnlyOnce]' started.
Test Case '-[SATVocabAppTests.StatsStoreTests testStreakMilestoneClaimedOnlyOnce]' passed (0.020 seconds).
Test Case '-[SATVocabAppTests.StatsStoreTests testStreakResetsAfterMissedDay]' started.
Test Case '-[SATVocabAppTests.StatsStoreTests testStreakResetsAfterMissedDay]' passed (0.016 seconds).
Test Suite 'StatsStoreTests' passed at 2026-04-12 17:23:25.780.
	 Executed 8 tests, with 0 failures (0 unexpected) in 0.049 (0.051) seconds
Test Case '-[SATVocabAppTests.WordStateStoreTests testBoxDistributionCounts]' started.
Test Case '-[SATVocabAppTests.WordStateStoreTests testBoxDistributionCounts]' passed (0.004 seconds).
Test Case '-[SATVocabAppTests.WordStateStoreTests testCorrectAnswerAtBox5StaysAt5]' started.
Test Case '-[SATVocabAppTests.WordStateStoreTests testCorrectAnswerAtBox5StaysAt5]' passed (0.003 seconds).
Test Case '-[SATVocabAppTests.WordStateStoreTests testCorrectAnswerPromotesBox]' started.
Test Case '-[SATVocabAppTests.WordStateStoreTests testCorrectAnswerPromotesBox]' passed (0.001 seconds).
Test Case '-[SATVocabAppTests.WordStateStoreTests testCorrectAnswerResetsConsecutiveWrong]' started.
Test Case '-[SATVocabAppTests.WordStateStoreTests testCorrectAnswerResetsConsecutiveWrong]' passed (0.001 seconds).
Test Case '-[SATVocabAppTests.WordStateStoreTests testDay1PromotionFailsWithOnlyOneCorrect]' started.
Test Case '-[SATVocabAppTests.WordStateStoreTests testDay1PromotionFailsWithOnlyOneCorrect]' passed (0.001 seconds).
Test Case '-[SATVocabAppTests.WordStateStoreTests testDay1PromotionFailsWithWrongFinalRecall]' started.
Test Case '-[SATVocabAppTests.WordStateStoreTests testDay1PromotionFailsWithWrongFinalRecall]' passed (0.002 seconds).
Test Case '-[SATVocabAppTests.WordStateStoreTests testDay1PromotionWithTwoOfThreeCorrectAndCorrectFinal]' started.
Test Case '-[SATVocabAppTests.WordStateStoreTests testDay1PromotionWithTwoOfThreeCorrectAndCorrectFinal]' passed (0.002 seconds).
Test Case '-[SATVocabAppTests.WordStateStoreTests testEasyAtBox3WithHighAccuracyNoLapses]' started.
Test Case '-[SATVocabAppTests.WordStateStoreTests testEasyAtBox3WithHighAccuracyNoLapses]' passed (0.003 seconds).
Test Case '-[SATVocabAppTests.WordStateStoreTests testFragileAfter1Lapse]' started.
Test Case '-[SATVocabAppTests.WordStateStoreTests testFragileAfter1Lapse]' passed (0.002 seconds).
Test Case '-[SATVocabAppTests.WordStateStoreTests testIntroduceWordIsIdempotent]' started.
Test Case '-[SATVocabAppTests.WordStateStoreTests testIntroduceWordIsIdempotent]' passed (0.002 seconds).
Test Case '-[SATVocabAppTests.WordStateStoreTests testIntroduceWordSetsIntroStage1]' started.
Test Case '-[SATVocabAppTests.WordStateStoreTests testIntroduceWordSetsIntroStage1]' passed (0.006 seconds).
Test Case '-[SATVocabAppTests.WordStateStoreTests testOverdueCount]' started.
Test Case '-[SATVocabAppTests.WordStateStoreTests testOverdueCount]' passed (0.001 seconds).
Test Case '-[SATVocabAppTests.WordStateStoreTests testReviewQueueExcludesNotYetDue]' started.
Test Case '-[SATVocabAppTests.WordStateStoreTests testReviewQueueExcludesNotYetDue]' passed (0.001 seconds).
Test Case '-[SATVocabAppTests.WordStateStoreTests testReviewQueuePrioritizesBox1First]' started.
Test Case '-[SATVocabAppTests.WordStateStoreTests testReviewQueuePrioritizesBox1First]' passed (0.001 seconds).
Test Case '-[SATVocabAppTests.WordStateStoreTests testReviewQueuePrioritizesStubbornOverNormal]' started.
Test Case '-[SATVocabAppTests.WordStateStoreTests testReviewQueuePrioritizesStubbornOverNormal]' passed (0.001 seconds).
Test Case '-[SATVocabAppTests.WordStateStoreTests testStubbornAfter2ConsecutiveWrong]' started.
Test Case '-[SATVocabAppTests.WordStateStoreTests testStubbornAfter2ConsecutiveWrong]' passed (0.001 seconds).
Test Case '-[SATVocabAppTests.WordStateStoreTests testStubbornAfter3Lapses]' started.
Test Case '-[SATVocabAppTests.WordStateStoreTests testStubbornAfter3Lapses]' passed (0.001 seconds).
Test Case '-[SATVocabAppTests.WordStateStoreTests testWrongAnswerAtBox1StaysAtBox1]' started.
Test Case '-[SATVocabAppTests.WordStateStoreTests testWrongAnswerAtBox1StaysAtBox1]' passed (0.001 seconds).
Test Case '-[SATVocabAppTests.WordStateStoreTests testWrongAnswerIncrementsConsecutiveWrong]' started.
Test Case '-[SATVocabAppTests.WordStateStoreTests testWrongAnswerIncrementsConsecutiveWrong]' passed (0.001 seconds).
Test Case '-[SATVocabAppTests.WordStateStoreTests testWrongAnswerResetsToBox1]' started.
Test Case '-[SATVocabAppTests.WordStateStoreTests testWrongAnswerResetsToBox1]' passed (0.001 seconds).
Test Suite 'WordStateStoreTests' passed at 2026-04-12 17:23:25.823.
	 Executed 20 tests, with 0 failures (0 unexpected) in 0.039 (0.042) seconds
Test Suite 'SATVocabAppTests.xctest' passed at 2026-04-12 17:23:25.823.
	 Executed 33 tests, with 0 failures (0 unexpected) in 0.226 (0.233) seconds
Test Suite 'All tests' passed at 2026-04-12 17:23:25.823.
	 Executed 33 tests, with 0 failures (0 unexpected) in 0.226 (0.233) seconds
<exited with exit code 0>
```

</details>


---

<sub>⏱️ 1m 54s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Flashcard/FlashcardFrontView.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Flashcard/FlashcardFrontView.swift

<details>
<summary>114 lines</summary>

```
1. import SwiftUI
2. 
3. struct FlashcardFrontView: View {
4.     let card: VocabCard
5.     let cardIndex: Int
6.     let totalCards: Int
7. 
8.     var body: some View {
9.         GeometryReader { geo in
10.             ZStack {
11.                 // Full-bleed image
12.                 if let ui = ImageResolver.uiImage(for: card.imageFilename) {
13.                     Image(uiImage: ui)
14.                         .resizable()
15.                         .scaledToFill()
16.                         .frame(width: geo.size.width, height: geo.size.height)
17.                         .clipped()
18.                 } else {
19.                     // Fallback gradient
20.                     LinearGradient(
21.                         colors: [Color(hex: "#4A90D9"), Color(hex: "#2C5F8A")],
22.                         startPoint: .topLeading,
23.                         endPoint: .bottomTrailing
24.                     )
25.                     Text(card.lemma.uppercased())
26.                         .font(.system(size: 32, weight: .black))
27.                         .foregroundColor(.white.opacity(0.3))
28.                 }
29. 
30.                 // Top gradient
31.                 VStack {
32.                     LinearGradient(
33.                         gradient: Gradient(colors: [
34.                             Color.black.opacity(0.4),
35.                             Color.black.opacity(0.0)
36.                         ]),
37.                         startPoint: .top,
38.                         endPoint: .bottom
39.                     )
40.                     .frame(height: 50)
41.                     Spacer()
42.                 }
43. 
44.                 // Bottom gradient for sentence
45.                 VStack {
46.                     Spacer()
47.                     LinearGradient(
48.                         gradient: Gradient(stops: [
49.                             .init(color: .clear, location: 0),
50.                             .init(color: Color.black.opacity(0.12), location: 0.25),
51.                             .init(color: Color.black.opacity(0.45), location: 0.55),
52.                             .init(color: Color.black.opacity(0.78), location: 0.85),
53.                             .init(color: Color.black.opacity(0.88), location: 1.0),
54.                         ]),
55.                         startPoint: .top,
56.                         endPoint: .bottom
57.                     )
58.                     .frame(height: geo.size.height * 0.5)
59.                 }
60. 
61.                 // Sentence overlay
62.                 VStack {
63.                     Spacer()
64.                     if let example = card.example, !example.isEmpty {
65.                         Text(highlightedSentence(example, word: card.lemma))
66.                             .font(.system(size: 19, weight: .medium))
67.                             .foregroundColor(.white.opacity(0.9))
68.                             .lineSpacing(5)
69.                             .padding(.horizontal, 14)
70.                             .padding(.bottom, 6)
71.                             .shadow(color: .black.opacity(0.8), radius: 4, x: 0, y: 1)
72.                     }
73.                     Text("tap to flip \u{00B7} swipe next \u{2192}")
74.                         .font(.system(size: 8, weight: .medium))
75.                         .foregroundColor(.white.opacity(0.45))
76.                         .padding(.horizontal, 10)
77.                         .padding(.vertical, 4)
78.                         .background(Color.black.opacity(0.2))
79.                         .clipShape(Capsule())
80.                         .padding(.bottom, 12)
81.                 }
82. 
83.                 // Top header overlay
84.                 VStack {
85.                     HStack {
86.                         Spacer()
87.                         Text("\(cardIndex + 1) / \(totalCards)")
88.                             .font(.system(size: 9, weight: .bold, design: .rounded))
89.                             .foregroundColor(.white)
90.                             .padding(.horizontal, 10)
91.                             .padding(.vertical, 4)
92.                             .background(Color.black.opacity(0.35))
93.                             .clipShape(Capsule())
94.                         Spacer()
95.                     }
96.                     .padding(.top, 8)
97.                     Spacer()
98.                 }
99.             }
100.         }
101.     }
102. 
103.     private func highlightedSentence(_ text: String, word: String) -> AttributedString {
104.         var attr = AttributedString(text)
105.         if let range = attr.range(of: word, options: .caseInsensitive) {
106.             attr[range].font = .system(size: 24, weight: .black)
107.             attr[range].foregroundColor = Color(hex: "#FFC800")
108.             attr[range].underlineStyle = .single
109.             attr[range].underlineColor = .init(Color(hex: "#FFC800").opacity(0.4))
110.         }
111.         return attr
112.     }
113. }
114.
```

</details>


---

<sub>⏱️ 1m 54s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Flashcard/FlashcardBackView.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Flashcard/FlashcardBackView.swift

<details>
<summary>212 lines</summary>

```
1. import SwiftUI
2. 
3. struct FlashcardBackView: View {
4.     let card: VocabCard
5.     let cardIndex: Int
6.     let totalCards: Int
7.     let boxLevel: Int
8.     let memoryStatus: MemoryStatus
9.     let isReadOnly: Bool
10.     let onShowAgain: () -> Void
11.     let onGotIt: () -> Void
12. 
13.     var body: some View {
14.         VStack(spacing: 0) {
15.             // Header
16.             HStack {
17.                 Spacer()
18.                 Text("\(cardIndex + 1) / \(totalCards)")
19.                     .font(.system(size: 9, weight: .bold, design: .rounded))
20.                     .foregroundColor(Color(hex: "#AFAFAF"))
21.                 Spacer()
22.             }
23.             .padding(.vertical, 8)
24. 
25.             ScrollView {
26.                 VStack(alignment: .leading, spacing: 16) {
27.                     // Thumbnail + Word + POS + Strength
28.                     HStack(alignment: .top, spacing: 12) {
29.                         if let ui = ImageResolver.uiImage(for: card.imageFilename) {
30.                             Image(uiImage: ui)
31.                                 .resizable()
32.                                 .scaledToFill()
33.                                 .frame(width: 60, height: 60)
34.                                 .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
35.                         } else {
36.                             RoundedRectangle(cornerRadius: 12, style: .continuous)
37.                                 .fill(Color(hex: "#E8ECF0"))
38.                                 .frame(width: 60, height: 60)
39.                                 .overlay(
40.                                     Text(String(card.lemma.prefix(1)).uppercased())
41.                                         .font(.system(size: 24, weight: .bold))
42.                                         .foregroundColor(Color(hex: "#AFAFAF"))
43.                                 )
44.                         }
45. 
46.                         VStack(alignment: .leading, spacing: 4) {
47.                             Text(card.lemma.uppercased())
48.                                 .font(.system(size: 22, weight: .black, design: .rounded))
49.                                 .foregroundColor(Color(hex: "#FFC800"))
50.                                 .tracking(0.5)
51. 
52.                             if let pos = card.pos, !pos.isEmpty {
53.                                 Text(pos)
54.                                     .font(.system(size: 12, weight: .medium))
55.                                     .foregroundColor(Color(hex: "#AFAFAF"))
56.                             }
57. 
58.                             if boxLevel > 0 {
59.                                 WordStrengthMeter(boxLevel: boxLevel, memoryStatus: memoryStatus)
60.                                     .frame(width: 140)
61.                             }
62.                         }
63.                     }
64.                     .padding(.horizontal, 16)
65. 
66.                     // Definition
67.                     sectionView(label: "DEFINITION") {
68.                         Text(card.definition ?? "")
69.                             .font(.system(size: 20, weight: .semibold))
70.                             .foregroundColor(Color(hex: "#1A1A2E"))
71.                             .lineSpacing(4)
72.                             .fixedSize(horizontal: false, vertical: true)
73.                     }
74. 
75.                     // Example
76.                     if let example = card.example, !example.isEmpty {
77.                         sectionView(label: "EXAMPLE") {
78.                             HStack(spacing: 0) {
79.                                 Rectangle()
80.                                     .fill(Color(hex: "#FFC800"))
81.                                     .frame(width: 4)
82.                                 Text(highlightedExample(example, word: card.lemma))
83.                                     .font(.system(size: 18, weight: .regular))
84.                                     .foregroundColor(Color(hex: "#4B4B4B"))
85.                                     .lineSpacing(4)
86.                                     .padding(12)
87.                             }
88.                             .background(Color(hex: "#FFFDE7"))
89.                             .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
90.                         }
91.                     }
92. 
93.                     // Collocations
94.                     if let collocations = card.collocations, !collocations.isEmpty {
95.                         sectionView(label: "COLLOCATIONS") {
96.                             FlowLayout(spacing: 8) {
97.                                 ForEach(collocations, id: \.self) { phrase in
98.                                     Text(phrase)
99.                                         .font(.system(size: 16, weight: .medium))
100.                                         .foregroundColor(Color(hex: "#4B4B4B"))
101.                                         .padding(.horizontal, 12)
102.                                         .padding(.vertical, 8)
103.                                         .background(Color(hex: "#FFF8E1"))
104.                                         .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
105.                                 }
106.                             }
107.                         }
108.                     }
109. 
110.                     // SAT Context
111.                     if let satContext = card.satContext, !satContext.isEmpty {
112.                         sectionView(label: "SAT CONTEXT") {
113.                             Text(satContext)
114.                                 .font(.system(size: 16, weight: .regular))
115.                                 .foregroundColor(Color(hex: "#666666"))
116.                                 .lineSpacing(3)
117.                                 .fixedSize(horizontal: false, vertical: true)
118.                         }
119.                     }
120.                 }
121.                 .padding(.bottom, 16)
122.             }
123.             .frame(minHeight: UIScreen.main.bounds.height * 0.7 - 80)
124. 
125.             Spacer(minLength: 0)
126. 
127.             // Bottom buttons
128.             VStack(spacing: 6) {
129.                 Text("tap to flip back \u{00B7} swipe \u{2192}")
130.                     .font(.system(size: 7, weight: .medium))
131.                     .foregroundColor(Color(hex: "#AFAFAF"))
132. 
133.                 HStack(spacing: 10) {
134.                     if !isReadOnly {
135.                         Button3D("SHOW AGAIN",
136.                                 color: .white,
137.                                 pressedColor: Color(hex: "#E5E5E5"),
138.                                 textColor: Color(hex: "#AFAFAF"),
139.                                 action: onShowAgain)
140.                     }
141.                     Button3D("GOT IT \u{2192}", action: onGotIt)
142.                 }
143.                 .padding(.horizontal, 16)
144.             }
145.             .padding(.bottom, 12)
146.         }
147.         .background(Color.white)
148.     }
149. 
150.     @ViewBuilder
151.     private func sectionView(label: String, @ViewBuilder content: () -> some View) -> some View {
152.         VStack(alignment: .leading, spacing: 6) {
153.             Text(label)
154.                 .font(.system(size: 10, weight: .semibold, design: .rounded))
155.                 .foregroundColor(Color(hex: "#AFAFAF"))
156.                 .tracking(0.5)
157.             content()
158.         }
159.         .padding(.horizontal, 16)
160.     }
161. 
162.     private func highlightedExample(_ text: String, word: String) -> AttributedString {
163.         var attr = AttributedString(text)
164.         if let range = attr.range(of: word, options: .caseInsensitive) {
165.             attr[range].font = .system(size: 20, weight: .bold)
166.             attr[range].foregroundColor = Color(hex: "#FFC800")
167.         }
168.         return attr
169.     }
170. }
171. 
172. // Simple flow layout for collocations
173. struct FlowLayout: Layout {
174.     var spacing: CGFloat = 6
175. 
176.     func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
177.         let result = arrange(proposal: proposal, subviews: subviews)
178.         return result.size
179.     }
180. 
181.     func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
182.         let result = arrange(proposal: proposal, subviews: subviews)
183.         for (index, origin) in result.origins.enumerated() {
184.             subviews[index].place(at: CGPoint(x: bounds.minX + origin.x, y: bounds.minY + origin.y), proposal: .unspecified)
185.         }
186.     }
187. 
188.     private func arrange(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, origins: [CGPoint]) {
189.         let maxWidth = proposal.width ?? .infinity
190.         var origins: [CGPoint] = []
191.         var x: CGFloat = 0
192.         var y: CGFloat = 0
193.         var rowHeight: CGFloat = 0
194.         var maxX: CGFloat = 0
195. 
196.         for subview in subviews {
197.             let size = subview.sizeThatFits(.unspecified)
198.             if x + size.width > maxWidth && x > 0 {
199.                 x = 0
200.                 y += rowHeight + spacing
201.                 rowHeight = 0
202.             }
203.             origins.append(CGPoint(x: x, y: y))
204.             rowHeight = max(rowHeight, size.height)
205.             x += size.width + spacing
206.             maxX = max(maxX, x)
207.         }
208. 
209.         return (CGSize(width: maxX, height: y + rowHeight), origins)
210.     }
211. }
212.
```

</details>


---

<sub>⏱️ 1m 54s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Flashcard/FlashcardCardView.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Flashcard/FlashcardCardView.swift

<details>
<summary>54 lines</summary>

```
1. import SwiftUI
2. 
3. struct FlashcardCardView: View {
4.     let card: VocabCard
5.     let cardIndex: Int
6.     let totalCards: Int
7.     let boxLevel: Int
8.     let memoryStatus: MemoryStatus
9.     let isReadOnly: Bool
10.     let onShowAgain: () -> Void
11.     let onGotIt: () -> Void
12. 
13.     @State private var isFlipped = false
14. 
15.     var body: some View {
16.         ZStack {
17.             if !isFlipped {
18.                 FlashcardFrontView(
19.                     card: card,
20.                     cardIndex: cardIndex,
21.                     totalCards: totalCards
22.                 )
23.             } else {
24.                 FlashcardBackView(
25.                     card: card,
26.                     cardIndex: cardIndex,
27.                     totalCards: totalCards,
28.                     boxLevel: boxLevel,
29.                     memoryStatus: memoryStatus,
30.                     isReadOnly: isReadOnly,
31.                     onShowAgain: onShowAgain,
32.                     onGotIt: onGotIt
33.                 )
34.                 .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
35.             }
36.         }
37.         .rotation3DEffect(
38.             .degrees(isFlipped ? 180 : 0),
39.             axis: (x: 0, y: 1, z: 0),
40.             perspective: 0.75
41.         )
42.         .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isFlipped)
43.         .contentShape(Rectangle())
44.         .onTapGesture {
45.             isFlipped.toggle()
46.         }
47.         .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
48.     }
49. 
50.     func resetFlip() {
51.         isFlipped = false
52.     }
53. }
54.
```

</details>


---

<sub>⏱️ 1m 54s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Flashcard/FlashcardStepView.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Flashcard/FlashcardStepView.swift

<details>
<summary>147 lines</summary>

```
1. import SwiftUI
2. 
3. struct FlashcardStepView: View {
4.     let words: [VocabCard]
5.     let stepNumber: Int
6.     let totalSteps: Int
7.     let onComplete: ([Int]) -> Void
8.     let onPause: (Int, Int, [Int], [Int]) -> Void
9. 
10.     @State private var currentIndex: Int = 0
11.     @State private var showAgainIds: Set<Int> = []
12.     @State private var completedIds: Set<Int> = []
13.     @State private var requeuedCards: [VocabCard] = []
14.     @State private var showPause: Bool = false
15.     @State private var dragOffset: CGFloat = 0
16. 
17.     private var allCards: [VocabCard] {
18.         words + requeuedCards
19.     }
20. 
21.     private var totalCards: Int {
22.         allCards.count
23.     }
24. 
25.     private var currentCard: VocabCard? {
26.         guard allCards.indices.contains(currentIndex) else { return nil }
27.         return allCards[currentIndex]
28.     }
29. 
30.     private var isReadOnly: Bool {
31.         guard let card = currentCard else { return false }
32.         return completedIds.contains(card.id)
33.     }
34. 
35.     var body: some View {
36.         VStack(spacing: 0) {
37.             SessionHeaderView(
38.                 stepNumber: stepNumber,
39.                 totalSteps: totalSteps,
40.                 stepLabel: "Explore New Words",
41.                 currentItem: min(currentIndex + 1, totalCards),
42.                 totalItems: totalCards,
43.                 progressColor: Color(hex: "#58CC02"),
44.                 isScored: false,
45.                 onClose: { showPause = true }
46.             )
47. 
48.             if let card = currentCard {
49.                 FlashcardCardView(
50.                     card: card,
51.                     cardIndex: currentIndex,
52.                     totalCards: totalCards,
53.                     boxLevel: 0,
54.                     memoryStatus: .normal,
55.                     isReadOnly: isReadOnly,
56.                     onShowAgain: {
57.                         handleShowAgain(card)
58.                     },
59.                     onGotIt: {
60.                         advanceCard(card)
61.                     }
62.                 )
63.                 .id(currentIndex) // Force recreation on index change
64.                 .offset(x: dragOffset)
65.                 .gesture(
66.                     DragGesture(minimumDistance: 50)
67.                         .onChanged { value in
68.                             dragOffset = value.translation.width
69.                         }
70.                         .onEnded { value in
71.                             let threshold: CGFloat = 80
72.                             withAnimation(.spring(response: 0.3)) {
73.                                 if value.translation.width < -threshold {
74.                                     // Swipe left = next
75.                                     if let card = currentCard {
76.                                         advanceCard(card)
77.                                     }
78.                                 } else if value.translation.width > threshold {
79.                                     // Swipe right = previous
80.                                     goBack()
81.                                 }
82.                                 dragOffset = 0
83.                             }
84.                         }
85.                 )
86.                 .padding(.horizontal, 8)
87.                 .padding(.vertical, 4)
88.             } else {
89.                 // Empty state
90.                 VStack(spacing: 16) {
91.                     Spacer()
92.                     Text("All caught up!")
93.                         .font(.system(size: 20, weight: .bold, design: .rounded))
94.                         .foregroundColor(Color(hex: "#4B4B4B"))
95.                     Text("No words to review right now.")
96.                         .font(.system(size: 14, weight: .medium))
97.                         .foregroundColor(Color(hex: "#AFAFAF"))
98.                     Spacer()
99.                 }
100.             }
101.         }
102.         .sheet(isPresented: $showPause) {
103.             PauseSheet(
104.                 onKeepGoing: { showPause = false },
105.                 onPauseExit: {
106.                     showPause = false
107.                     onPause(stepNumber - 1, currentIndex, Array(showAgainIds), requeuedCards.map { $0.id })
108.                 }
109.             )
110.         }
111.     }
112. 
113.     private func handleShowAgain(_ card: VocabCard) {
114.         // Only requeue once per card
115.         if !showAgainIds.contains(card.id) {
116.             showAgainIds.insert(card.id)
117.             requeuedCards.append(card)
118.         }
119.         completedIds.insert(card.id)
120.         advanceToNext()
121.     }
122. 
123.     private func advanceCard(_ card: VocabCard) {
124.         completedIds.insert(card.id)
125.         advanceToNext()
126.     }
127. 
128.     private func advanceToNext() {
129.         if currentIndex + 1 >= totalCards {
130.             // All cards done
131.             onComplete(Array(showAgainIds))
132.         } else {
133.             withAnimation(.easeInOut(duration: 0.25)) {
134.                 currentIndex += 1
135.             }
136.         }
137.     }
138. 
139.     private func goBack() {
140.         if currentIndex > 0 {
141.             withAnimation(.easeInOut(duration: 0.25)) {
142.                 currentIndex -= 1
143.             }
144.         }
145.     }
146. }
147.
```

</details>


---

<sub>⏱️ 1m 54s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/ImageGameView.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/ImageGameView.swift

<details>
<summary>142 lines</summary>

```
1. import SwiftUI
2. 
3. struct ImageGameView: View {
4.     let card: VocabCard
5.     let choices: [VocabCard]  // 4 choices including the correct one
6.     let roundIndex: Int
7.     let totalRounds: Int
8.     let onAnswer: (Bool) -> Void
9. 
10.     @State private var selectedId: Int? = nil
11.     @State private var isCorrect: Bool? = nil
12.     @State private var showFeedback = false
13. 
14.     private var clozeSentence: String {
15.         guard let example = card.example else { return "________" }
16.         // Replace the word with a blank
17.         let pattern = "\\b\(NSRegularExpression.escapedPattern(for: card.lemma))\\b"
18.         if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
19.             let range = NSRange(example.startIndex..., in: example)
20.             return regex.stringByReplacingMatches(in: example, range: range, withTemplate: "________")
21.         }
22.         return example
23.     }
24. 
25.     var body: some View {
26.         VStack(spacing: 0) {
27.             // Image area
28.             GeometryReader { geo in
29.                 ZStack(alignment: .bottom) {
30.                     if let ui = ImageResolver.uiImage(for: card.imageFilename) {
31.                         Image(uiImage: ui)
32.                             .resizable()
33.                             .scaledToFill()
34.                             .frame(width: geo.size.width, height: geo.size.height)
35.                             .clipped()
36.                     } else {
37.                         LinearGradient(
38.                             colors: [Color(hex: "#4A90D9"), Color(hex: "#2C5F8A")],
39.                             startPoint: .topLeading,
40.                             endPoint: .bottomTrailing
41.                         )
42.                     }
43. 
44.                     // Bottom gradient with caption
45.                     LinearGradient(
46.                         gradient: Gradient(colors: [.clear, Color.black.opacity(0.5)]),
47.                         startPoint: .top,
48.                         endPoint: .bottom
49.                     )
50.                     .frame(height: geo.size.height * 0.4)
51. 
52.                     Text("CHOOSE THE BEST WORD")
53.                         .font(.system(size: 7, weight: .bold, design: .rounded))
54.                         .foregroundColor(.white)
55.                         .tracking(0.5)
56.                         .padding(.bottom, 8)
57.                 }
58.             }
59.             .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
60.             .padding(.horizontal, 12)
61.             .frame(maxHeight: .infinity, alignment: .top)
62.             .layoutPriority(1)
63. 
64.             // Cloze sentence
65.             Text(clozeSentence)
66.                 .font(.system(size: 12, weight: .medium))
67.                 .foregroundColor(Color(hex: "#4B4B4B"))
68.                 .multilineTextAlignment(.center)
69.                 .padding(.horizontal, 16)
70.                 .padding(.vertical, 8)
71.                 .background(Color(hex: "#F7F7F7"))
72.                 .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
73.                 .padding(.horizontal, 12)
74.                 .padding(.top, 8)
75. 
76.             // 2x2 answer grid
77.             VStack(spacing: 6) {
78.                 ForEach(0..<2, id: \.self) { row in
79.                     HStack(spacing: 6) {
80.                         ForEach(0..<2, id: \.self) { col in
81.                             let index = row * 2 + col
82.                             if index < choices.count {
83.                                 answerButton(for: choices[index])
84.                             }
85.                         }
86.                     }
87.                 }
88.             }
89.             .padding(.horizontal, 12)
90.             .padding(.vertical, 10)
91.             .padding(.bottom, 8)
92.         }
93.         .allowsHitTesting(!showFeedback)
94.     }
95. 
96.     @ViewBuilder
97.     private func answerButton(for choice: VocabCard) -> some View {
98.         let isSelected = selectedId == choice.id
99.         let isCorrectAnswer = choice.id == card.id
100.         let bgColor: Color = {
101.             guard showFeedback else { return .white }
102.             if isSelected && isCorrect == true { return Color(hex: "#58CC02").opacity(0.2) }
103.             if isSelected && isCorrect == false { return Color(hex: "#FF4B4B").opacity(0.2) }
104.             if isCorrectAnswer && isCorrect == false { return Color(hex: "#58CC02").opacity(0.2) }
105.             return .white
106.         }()
107.         let borderColor: Color = {
108.             guard showFeedback else { return Color(hex: "#E5E5E5") }
109.             if isSelected && isCorrect == true { return Color(hex: "#58CC02") }
110.             if isSelected && isCorrect == false { return Color(hex: "#FF4B4B") }
111.             if isCorrectAnswer && isCorrect == false { return Color(hex: "#58CC02") }
112.             return Color(hex: "#E5E5E5")
113.         }()
114. 
115.         Button {
116.             guard !showFeedback else { return }
117.             selectedId = choice.id
118.             let correct = choice.id == card.id
119.             isCorrect = correct
120.             showFeedback = true
121. 
122.             let delay: Double = correct ? 1.5 : 2.5
123.             DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
124.                 onAnswer(correct)
125.             }
126.         } label: {
127.             Text(choice.lemma)
128.                 .font(.system(size: 13, weight: .bold, design: .rounded))
129.                 .foregroundColor(Color(hex: "#4B4B4B"))
130.                 .frame(maxWidth: .infinity)
131.                 .padding(.vertical, 12)
132.                 .background(bgColor)
133.                 .overlay(
134.                     RoundedRectangle(cornerRadius: 10, style: .continuous)
135.                         .stroke(borderColor, lineWidth: 1.5)
136.                 )
137.                 .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
138.         }
139.         .buttonStyle(.plain)
140.     }
141. }
142.
```

</details>


---

<sub>⏱️ 1m 54s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/QuickRecallView.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/QuickRecallView.swift

<details>
<summary>99 lines</summary>

```
1. import SwiftUI
2. 
3. struct QuickRecallView: View {
4.     let card: VocabCard
5.     let definitionChoices: [DefinitionChoice]
6.     let onAnswer: (Bool) -> Void
7. 
8.     @State private var selectedIndex: Int? = nil
9.     @State private var isCorrect: Bool? = nil
10.     @State private var showFeedback = false
11. 
12.     struct DefinitionChoice: Identifiable {
13.         let id: Int  // word id
14.         let definition: String
15.         let isCorrect: Bool
16.     }
17. 
18.     var body: some View {
19.         VStack(spacing: 16) {
20.             Spacer()
21. 
22.             // Word display
23.             VStack(spacing: 6) {
24.                 Text("WHAT DOES THIS MEAN?")
25.                     .font(.system(size: 9, weight: .semibold, design: .rounded))
26.                     .foregroundColor(Color(hex: "#AFAFAF"))
27.                     .tracking(0.5)
28. 
29.                 Text(card.lemma.uppercased())
30.                     .font(.system(size: 24, weight: .heavy, design: .rounded))
31.                     .foregroundColor(Color(hex: "#4B4B4B"))
32. 
33.                 Text("from this morning")
34.                     .font(.system(size: 10, weight: .medium))
35.                     .foregroundColor(Color(hex: "#CE82FF"))
36.             }
37. 
38.             Spacer()
39. 
40.             // 4 vertical definition choices
41.             VStack(spacing: 8) {
42.                 ForEach(Array(definitionChoices.enumerated()), id: \.element.id) { index, choice in
43.                     definitionButton(choice: choice, index: index)
44.                 }
45.             }
46.             .padding(.horizontal, 16)
47.             .padding(.bottom, 20)
48.         }
49.         .allowsHitTesting(!showFeedback)
50.     }
51. 
52.     @ViewBuilder
53.     private func definitionButton(choice: DefinitionChoice, index: Int) -> some View {
54.         let isSelected = selectedIndex == index
55.         let bgColor: Color = {
56.             guard showFeedback else { return .white }
57.             if isSelected && isCorrect == true { return Color(hex: "#58CC02").opacity(0.15) }
58.             if isSelected && isCorrect == false { return Color(hex: "#FF4B4B").opacity(0.15) }
59.             if choice.isCorrect && isCorrect == false { return Color(hex: "#58CC02").opacity(0.15) }
60.             return .white
61.         }()
62.         let borderColor: Color = {
63.             guard showFeedback else { return Color(hex: "#E5E5E5") }
64.             if isSelected && isCorrect == true { return Color(hex: "#58CC02") }
65.             if isSelected && isCorrect == false { return Color(hex: "#FF4B4B") }
66.             if choice.isCorrect && isCorrect == false { return Color(hex: "#58CC02") }
67.             return Color(hex: "#E5E5E5")
68.         }()
69. 
70.         Button {
71.             guard !showFeedback else { return }
72.             selectedIndex = index
73.             let correct = choice.isCorrect
74.             isCorrect = correct
75.             showFeedback = true
76. 
77.             let delay: Double = correct ? 1.0 : 2.0
78.             DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
79.                 onAnswer(correct)
80.             }
81.         } label: {
82.             Text(choice.definition)
83.                 .font(.system(size: 12, weight: .medium))
84.                 .foregroundColor(Color(hex: "#4B4B4B"))
85.                 .multilineTextAlignment(.leading)
86.                 .frame(maxWidth: .infinity, alignment: .leading)
87.                 .padding(.horizontal, 12)
88.                 .padding(.vertical, 10)
89.                 .background(bgColor)
90.                 .overlay(
91.                     RoundedRectangle(cornerRadius: 10, style: .continuous)
92.                         .stroke(borderColor, lineWidth: 1.5)
93.                 )
94.                 .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
95.         }
96.         .buttonStyle(.plain)
97.     }
98. }
99.
```

</details>


---

<sub>⏱️ 1m 54s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/SATQuestionView.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/SATQuestionView.swift

<details>
<summary>270 lines</summary>

```
1. import SwiftUI
2. 
3. struct SATQuestionView: View {
4.     let question: SatQuestion
5.     let onAnswer: (Bool) -> Void
6. 
7.     @State private var selectedOption: String? = nil
8.     @State private var showFeedback = false
9.     @State private var isCorrect: Bool? = nil
10. 
11.     private let options = ["A", "B", "C", "D"]
12. 
13.     private func optionText(for letter: String) -> String {
14.         switch letter {
15.         case "A": return question.optionA ?? ""
16.         case "B": return question.optionB ?? ""
17.         case "C": return question.optionC ?? ""
18.         case "D": return question.optionD ?? ""
19.         default: return ""
20.         }
21.     }
22. 
23.     private var correctLetter: String {
24.         // The answer field contains the letter (A/B/C/D) or the full text
25.         let answer = (question.deepseekAnswer ?? question.answer ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
26.         // Check if it's a single letter
27.         if answer.count == 1 && "ABCD".contains(answer.uppercased()) {
28.             return answer.uppercased()
29.         }
30.         // Check if it starts with a letter and paren like "A)" or "A."
31.         if answer.count >= 2 {
32.             let first = String(answer.prefix(1)).uppercased()
33.             if "ABCD".contains(first) {
34.                 return first
35.             }
36.         }
37.         // Fallback: match text against options
38.         for letter in options {
39.             if optionText(for: letter).lowercased().trimmingCharacters(in: .whitespacesAndNewlines) == answer.lowercased() {
40.                 return letter
41.             }
42.         }
43.         return question.answer?.prefix(1).uppercased() ?? "A"
44.     }
45. 
46.     var body: some View {
47.         VStack(spacing: 0) {
48.             // Passage area (scrollable)
49.             ScrollView {
50.                 VStack(alignment: .leading, spacing: 8) {
51.                     HStack {
52.                         Text("PASSAGE")
53.                             .font(.system(size: 7, weight: .bold, design: .rounded))
54.                             .foregroundColor(Color(hex: "#AFAFAF"))
55.                             .tracking(0.5)
56.                         Spacer()
57.                         Text("scroll \u{2195}")
58.                             .font(.system(size: 7, weight: .medium))
59.                             .foregroundColor(Color(hex: "#AFAFAF"))
60.                     }
61. 
62.                     if let passage = question.passage, !passage.isEmpty {
63.                         Text(passage)
64.                             .font(.system(size: 11, weight: .regular, design: .serif))
65.                             .foregroundColor(Color(hex: "#4B4B4B"))
66.                             .lineSpacing(3)
67.                     }
68.                 }
69.                 .padding(12)
70.             }
71.             .frame(maxHeight: 260)
72.             .background(Color(hex: "#FFF8E1"))
73.             .overlay(
74.                 RoundedRectangle(cornerRadius: 12, style: .continuous)
75.                     .stroke(Color(hex: "#FFE082"), lineWidth: 2)
76.             )
77.             .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
78.             .padding(.horizontal, 12)
79. 
80.             // Divider
81.             HStack {
82.                 Rectangle().fill(Color(hex: "#E5E5E5")).frame(height: 1)
83.                 Text("QUESTION")
84.                     .font(.system(size: 7, weight: .bold, design: .rounded))
85.                     .foregroundColor(Color(hex: "#AFAFAF"))
86.                     .tracking(0.5)
87.                 Rectangle().fill(Color(hex: "#E5E5E5")).frame(height: 1)
88.             }
89.             .padding(.horizontal, 12)
90.             .padding(.vertical, 8)
91. 
92.             // Question text
93.             if let questionText = question.question {
94.                 Text(questionText)
95.                     .font(.system(size: 11, weight: .semibold))
96.                     .foregroundColor(Color(hex: "#4B4B4B"))
97.                     .padding(.horizontal, 16)
98.                     .padding(.bottom, 8)
99.             }
100. 
101.             // Answer options
102.             VStack(spacing: 5) {
103.                 ForEach(options, id: \.self) { letter in
104.                     answerRow(letter: letter)
105.                 }
106.             }
107.             .padding(.horizontal, 12)
108. 
109.             Spacer(minLength: 8)
110. 
111.             // CHECK button
112.             Button {
113.                 guard let selected = selectedOption, !showFeedback else { return }
114.                 let correct = selected == correctLetter
115.                 isCorrect = correct
116.                 showFeedback = true
117.             } label: {
118.                 Text("CHECK")
119.                     .font(.system(size: 15, weight: .heavy, design: .rounded))
120.                     .foregroundColor(.white)
121.                     .frame(maxWidth: .infinity)
122.                     .padding(.vertical, 14)
123.                     .background(selectedOption != nil && !showFeedback ? Color(hex: "#58CC02") : Color(hex: "#E5E5E5"))
124.                     .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
125.             }
126.             .disabled(selectedOption == nil || showFeedback)
127.             .padding(.horizontal, 16)
128.             .padding(.bottom, 12)
129.         }
130.         .sheet(isPresented: $showFeedback) {
131.             SATFeedbackSheet(
132.                 isCorrect: isCorrect ?? false,
133.                 targetWord: question.targetWord ?? "",
134.                 correctAnswer: optionText(for: correctLetter),
135.                 explanation: question.deepseekReason ?? question.deepseekBackground ?? "",
136.                 onNext: {
137.                     showFeedback = false
138.                     onAnswer(isCorrect ?? false)
139.                 }
140.             )
141.             .presentationDetents([.fraction(0.5)])
142.         }
143.     }
144. 
145.     @ViewBuilder
146.     private func answerRow(letter: String) -> some View {
147.         let isSelected = selectedOption == letter
148.         let isCorrectOption = showFeedback && letter == correctLetter
149.         let isWrongSelected = showFeedback && isSelected && letter != correctLetter
150. 
151.         Button {
152.             guard !showFeedback else { return }
153.             selectedOption = letter
154.         } label: {
155.             HStack(spacing: 10) {
156.                 // Letter circle
157.                 ZStack {
158.                     Circle()
159.                         .stroke(isSelected ? Color(hex: "#1CB0F6") : Color(hex: "#E5E5E5"), lineWidth: 2)
160.                         .fill(isSelected ? Color(hex: "#1CB0F6") : .clear)
161.                         .frame(width: 18, height: 18)
162. 
163.                     Text(letter)
164.                         .font(.system(size: 10, weight: .bold))
165.                         .foregroundColor(isSelected ? .white : Color(hex: "#AFAFAF"))
166.                 }
167. 
168.                 Text(optionText(for: letter))
169.                     .font(.system(size: 10, weight: .medium))
170.                     .foregroundColor(Color(hex: "#4B4B4B"))
171.                     .multilineTextAlignment(.leading)
172. 
173.                 Spacer()
174.             }
175.             .padding(.horizontal, 10)
176.             .padding(.vertical, 8)
177.             .background(
178.                 isCorrectOption ? Color(hex: "#58CC02").opacity(0.1) :
179.                 isWrongSelected ? Color(hex: "#FF4B4B").opacity(0.1) :
180.                 Color.white
181.             )
182.             .overlay(
183.                 RoundedRectangle(cornerRadius: 8, style: .continuous)
184.                     .stroke(
185.                         isCorrectOption ? Color(hex: "#58CC02") :
186.                         isWrongSelected ? Color(hex: "#FF4B4B") :
187.                         isSelected ? Color(hex: "#1CB0F6") :
188.                         Color(hex: "#E5E5E5"),
189.                         lineWidth: 1.5
190.                     )
191.             )
192.             .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
193.         }
194.         .buttonStyle(.plain)
195.     }
196. }
197. 
198. // MARK: - SAT Feedback Sheet
199. 
200. struct SATFeedbackSheet: View {
201.     let isCorrect: Bool
202.     let targetWord: String
203.     let correctAnswer: String
204.     let explanation: String
205.     let onNext: () -> Void
206. 
207.     var body: some View {
208.         VStack(alignment: .leading, spacing: 12) {
209.             // Verdict
210.             HStack {
211.                 if isCorrect {
212.                     Image(systemName: "checkmark.circle.fill")
213.                         .foregroundColor(Color(hex: "#58CC02"))
214.                     Text("Correct!")
215.                         .font(.system(size: 18, weight: .bold, design: .rounded))
216.                         .foregroundColor(Color(hex: "#58CC02"))
217.                 } else {
218.                     Image(systemName: "xmark.circle.fill")
219.                         .foregroundColor(Color(hex: "#FF4B4B"))
220.                     Text("Not quite.")
221.                         .font(.system(size: 18, weight: .bold, design: .rounded))
222.                         .foregroundColor(Color(hex: "#FF4B4B"))
223.                 }
224.                 Spacer()
225.             }
226. 
227.             if !targetWord.isEmpty {
228.                 VStack(alignment: .leading, spacing: 2) {
229.                     Text("WORD")
230.                         .font(.system(size: 7, weight: .bold))
231.                         .foregroundColor(Color(hex: "#AFAFAF"))
232.                     Text(targetWord)
233.                         .font(.system(size: 14, weight: .semibold))
234.                         .foregroundColor(Color(hex: "#4B4B4B"))
235.                 }
236.             }
237. 
238.             if !correctAnswer.isEmpty {
239.                 VStack(alignment: .leading, spacing: 2) {
240.                     Text("MEANING")
241.                         .font(.system(size: 7, weight: .bold))
242.                         .foregroundColor(Color(hex: "#AFAFAF"))
243.                     Text(correctAnswer)
244.                         .font(.system(size: 12, weight: .medium))
245.                         .foregroundColor(Color(hex: "#4B4B4B"))
246.                 }
247.             }
248. 
249.             if !explanation.isEmpty {
250.                 VStack(alignment: .leading, spacing: 2) {
251.                     Text("WHY")
252.                         .font(.system(size: 7, weight: .bold))
253.                         .foregroundColor(Color(hex: "#AFAFAF"))
254.                     Text(explanation)
255.                         .font(.system(size: 11, weight: .regular))
256.                         .foregroundColor(Color(hex: "#666666"))
257.                         .lineSpacing(2)
258.                 }
259.             }
260. 
261.             Spacer()
262. 
263.             Button3D("NEXT \u{2192}", action: onNext)
264.                 .padding(.horizontal, 4)
265.         }
266.         .padding(20)
267.         .background(isCorrect ? Color(hex: "#58CC02").opacity(0.05) : Color(hex: "#FF4B4B").opacity(0.05))
268.     }
269. }
270.
```

</details>


---

<sub>⏱️ 1m 54s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/PracticeTabView.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/PracticeTabView.swift

<details>
<summary>69 lines</summary>

```
1. import SwiftUI
2. 
3. struct PracticeTabView: View {
4.     @StateObject private var vm = PracticeTabViewModel()
5.     @State private var navigateToSession: SessionType? = nil
6. 
7.     var body: some View {
8.         ScrollView {
9.             VStack(spacing: 14) {
10.                 PracticeHeader(
11.                     studyDay: vm.studyDay,
12.                     zoneIndex: vm.zoneIndex,
13.                     streak: vm.streak.currentStreak,
14.                     totalXP: vm.streak.totalXP
15.                 )
16. 
17.                 if vm.isLoading {
18.                     ProgressView()
19.                         .padding(.top, 40)
20.                 } else {
21.                     stateContent
22.                 }
23.             }
24.             .padding(.horizontal, 16)
25.         }
26.         .navigationBarTitleDisplayMode(.inline)
27.         .onAppear { Task { await vm.load() } }
28.         .navigationDestination(item: $navigateToSession) { type in
29.             SessionFlowView(vm: SessionFlowViewModel(sessionType: type, studyDay: vm.studyDay))
30.         }
31.     }
32. 
33.     @ViewBuilder
34.     private var stateContent: some View {
35.         switch vm.state {
36.         case .morningAvailable:
37.             MorningSessionCard {
38.                 navigateToSession = .morning
39.             }
40.             EveningSessionCard(locked: true, unlockAt: nil)
41.             ReviewsDueRow(count: vm.reviewsDueCount)
42. 
43.         case .paused(let session):
44.             ResumeCard(session: session) {
45.                 navigateToSession = session.sessionType
46.             }
47.             EveningSessionCard(locked: true, unlockAt: nil)
48. 
49.         case .morningDoneEveningLocked(let unlockAt):
50.             MorningCompleteCard()
51.             EveningSessionCard(locked: true, unlockAt: unlockAt)
52.             ReviewsDueRow(count: vm.reviewsDueCount)
53. 
54.         case .eveningAvailable:
55.             MorningCompleteCard()
56.             EveningSessionCard(locked: false, unlockAt: nil) {
57.                 navigateToSession = .evening
58.             }
59.             ReviewsDueRow(count: vm.reviewsDueCount)
60. 
61.         case .bothComplete:
62.             MorningCompleteCard()
63.             EveningCompleteCard()
64.             DayCompleteSummary(studyDay: vm.studyDay, userId: vm.userId)
65.             ReviewsDueRow(count: vm.reviewsDueCount)
66.         }
67.     }
68. }
69.
```

</details>


---

<sub>⏱️ 1m 54s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/PracticeStateResolver.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/PracticeStateResolver.swift

<details>
<summary>59 lines</summary>

```
1. import Foundation
2. 
3. enum PracticeState {
4.     case morningAvailable                           // A
5.     case paused(SessionState)                       // B
6.     case morningDoneEveningLocked(unlockAt: Date)   // C
7.     case eveningAvailable                           // D
8.     case bothComplete                               // E
9. }
10. 
11. struct PracticeStateResolver {
12.     static func resolve(
13.         dayState: DayState?,
14.         activeSession: SessionState?,
15.         now: Date = Date()
16.     ) -> PracticeState {
17.         // Priority 1: Paused session
18.         if let session = activeSession, session.isPaused {
19.             return .paused(session)
20.         }
21. 
22.         guard let day = dayState else {
23.             return .morningAvailable
24.         }
25. 
26.         // Both done
27.         if day.morningComplete && day.eveningComplete {
28.             return .bothComplete
29.         }
30. 
31.         // Morning done, check evening
32.         if day.morningComplete {
33.             let unlockAt = calculateEveningUnlock(morningCompleteAt: day.morningCompleteAt)
34.             if now >= unlockAt {
35.                 return .eveningAvailable
36.             } else {
37.                 return .morningDoneEveningLocked(unlockAt: unlockAt)
38.             }
39.         }
40. 
41.         // Morning not done
42.         return .morningAvailable
43.     }
44. 
45.     static func calculateEveningUnlock(morningCompleteAt: Date?) -> Date {
46.         guard let morningDone = morningCompleteAt else {
47.             // Fallback to 5 PM today
48.             return Calendar.current.date(bySettingHour: AppConfig.eveningUnlockFallbackHour,
49.                                          minute: 0, second: 0, of: Date()) ?? Date()
50.         }
51. 
52.         let hoursLater = morningDone.addingTimeInterval(TimeInterval(AppConfig.eveningUnlockHours * 3600))
53.         let fallback = Calendar.current.date(bySettingHour: AppConfig.eveningUnlockFallbackHour,
54.                                              minute: 0, second: 0, of: Date()) ?? Date()
55. 
56.         return min(hoursLater, fallback)
57.     }
58. }
59.
```

</details>


---

<sub>⏱️ 1m 54s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/RootTabView.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/RootTabView.swift

<details>
<summary>56 lines</summary>

```
1. import SwiftUI
2. 
3. struct RootTabView: View {
4.     enum Tab: Hashable {
5.         case map
6.         case practice
7.         case stats
8.         case profile
9.     }
10. 
11.     @State private var selected: Tab = .practice
12. 
13.     var body: some View {
14.         TabView(selection: $selected) {
15.             NavigationStack {
16.                 AdventureMapView()
17.             }
18.             .tabItem {
19.                 Label("Map", systemImage: "map")
20.             }
21.             .tag(Tab.map)
22. 
23.             NavigationStack {
24.                 PracticeTabView()
25.             }
26.             .tabItem {
27.                 Label("Practice", systemImage: "pencil.and.list.clipboard")
28.             }
29.             .tag(Tab.practice)
30. 
31.             NavigationStack {
32.                 StatsView()
33.             }
34.             .tabItem {
35.                 Label("Stats", systemImage: "chart.bar")
36.             }
37.             .tag(Tab.stats)
38. 
39.             NavigationStack {
40.                 ProfileView()
41.             }
42.             .tabItem {
43.                 Label("Profile", systemImage: "person")
44.             }
45.             .tag(Tab.profile)
46.         }
47.         .tint(Color(hex: "#58CC02"))
48.     }
49. }
50. 
51. // Color(hex:) extension is in Views/Components/Button3D.swift
52. 
53. #Preview {
54.     RootTabView()
55. }
56.
```

</details>


---

<sub>⏱️ 1m 54s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Tests/SATVocabAppTests/Data/WordStateStoreTests.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Tests/SATVocabAppTests/Data/WordStateStoreTests.swift

<details>
<summary>295 lines</summary>

```
1. import XCTest
2. import SQLite3
3. @testable import SATVocabApp
4. 
5. final class WordStateStoreTests: XCTestCase {
6.     var db: SQLiteDB!
7.     var store: WordStateStore!
8.     var userId: String!
9. 
10.     override func setUpWithError() throws {
11.         db = try TestDatabase.create(withWords: true)
12.         userId = try TestDatabase.createTestUser(db: db)
13.         store = WordStateStore(db: db)
14.     }
15. 
16.     // MARK: - Introduction
17. 
18.     func testIntroduceWordSetsIntroStage1() async throws {
19.         try await store.introduceWord(userId: userId, wordId: 1)
20. 
21.         let ws = try await store.getWordState(userId: userId, wordId: 1)
22.         XCTAssertNotNil(ws)
23.         XCTAssertEqual(ws?.introStage, 1)
24.         XCTAssertEqual(ws?.boxLevel, 0)
25.         XCTAssertEqual(ws?.totalSeen, 1)
26.     }
27. 
28.     func testIntroduceWordIsIdempotent() async throws {
29.         try await store.introduceWord(userId: userId, wordId: 1)
30.         try await store.introduceWord(userId: userId, wordId: 1)
31. 
32.         let ws = try await store.getWordState(userId: userId, wordId: 1)
33.         XCTAssertEqual(ws?.totalSeen, 2)  // incremented
34.         XCTAssertEqual(ws?.introStage, 1) // stays at 1
35.     }
36. 
37.     // MARK: - Box Progression (Correct)
38. 
39.     func testCorrectAnswerPromotesBox() async throws {
40.         // Setup: word at box 1
41.         try await store.introduceWord(userId: userId, wordId: 1)
42.         try db.exec("UPDATE word_state SET box_level = 1, due_at = datetime('now','-1 day') WHERE word_id = 1")
43. 
44.         let change = try await store.recordScoredAnswer(userId: userId, wordId: 1, correct: true)
45. 
46.         let ws = try await store.getWordState(userId: userId, wordId: 1)
47.         XCTAssertEqual(ws?.boxLevel, 2)
48.         if case .promoted(let from, let to) = change {
49.             XCTAssertEqual(from, 1)
50.             XCTAssertEqual(to, 2)
51.         } else {
52.             XCTFail("Expected promoted, got \(change)")
53.         }
54.     }
55. 
56.     func testCorrectAnswerAtBox5StaysAt5() async throws {
57.         try await store.introduceWord(userId: userId, wordId: 1)
58.         try db.exec("UPDATE word_state SET box_level = 5 WHERE word_id = 1")
59. 
60.         let change = try await store.recordScoredAnswer(userId: userId, wordId: 1, correct: true)
61. 
62.         let ws = try await store.getWordState(userId: userId, wordId: 1)
63.         XCTAssertEqual(ws?.boxLevel, 5)
64.         if case .none = change {} else { XCTFail("Should be .none at max box") }
65.     }
66. 
67.     // MARK: - Box Progression (Wrong)
68. 
69.     func testWrongAnswerResetsToBox1() async throws {
70.         try await store.introduceWord(userId: userId, wordId: 1)
71.         try db.exec("UPDATE word_state SET box_level = 3, due_at = datetime('now','-1 day') WHERE word_id = 1")
72. 
73.         let change = try await store.recordScoredAnswer(userId: userId, wordId: 1, correct: false)
74. 
75.         let ws = try await store.getWordState(userId: userId, wordId: 1)
76.         XCTAssertEqual(ws?.boxLevel, 1, "Wrong answer should reset to box 1")
77.         XCTAssertEqual(ws?.lapseCount, 1, "Should increment lapse count")
78.         if case .demoted(let from, let to) = change {
79.             XCTAssertEqual(from, 3)
80.             XCTAssertEqual(to, 1)
81.         } else {
82.             XCTFail("Expected demoted")
83.         }
84.     }
85. 
86.     func testWrongAnswerAtBox1StaysAtBox1() async throws {
87.         try await store.introduceWord(userId: userId, wordId: 1)
88.         try db.exec("UPDATE word_state SET box_level = 1, due_at = datetime('now','-1 day') WHERE word_id = 1")
89. 
90.         let change = try await store.recordScoredAnswer(userId: userId, wordId: 1, correct: false)
91. 
92.         let ws = try await store.getWordState(userId: userId, wordId: 1)
93.         XCTAssertEqual(ws?.boxLevel, 1)
94.         XCTAssertEqual(ws?.lapseCount, 0, "No lapse from box 1 (already at bottom)")
95.     }
96. 
97.     func testWrongAnswerIncrementsConsecutiveWrong() async throws {
98.         try await store.introduceWord(userId: userId, wordId: 1)
99.         try db.exec("UPDATE word_state SET box_level = 2, due_at = datetime('now','-1 day') WHERE word_id = 1")
100. 
101.         _ = try await store.recordScoredAnswer(userId: userId, wordId: 1, correct: false)
102.         _ = try await store.recordScoredAnswer(userId: userId, wordId: 1, correct: false)
103. 
104.         let ws = try await store.getWordState(userId: userId, wordId: 1)
105.         XCTAssertEqual(ws?.consecutiveWrong, 2)
106.     }
107. 
108.     func testCorrectAnswerResetsConsecutiveWrong() async throws {
109.         try await store.introduceWord(userId: userId, wordId: 1)
110.         try db.exec("UPDATE word_state SET box_level = 1, consecutive_wrong = 3, due_at = datetime('now','-1 day') WHERE word_id = 1")
111. 
112.         _ = try await store.recordScoredAnswer(userId: userId, wordId: 1, correct: true)
113. 
114.         let ws = try await store.getWordState(userId: userId, wordId: 1)
115.         XCTAssertEqual(ws?.consecutiveWrong, 0)
116.     }
117. 
118.     // MARK: - Memory Status Classification
119. 
120.     func testStubbornAfter3Lapses() async throws {
121.         try await store.introduceWord(userId: userId, wordId: 1)
122.         try db.exec("UPDATE word_state SET box_level = 1, lapse_count = 3, due_at = datetime('now','-1 day') WHERE word_id = 1")
123. 
124.         _ = try await store.recordScoredAnswer(userId: userId, wordId: 1, correct: true)
125. 
126.         let ws = try await store.getWordState(userId: userId, wordId: 1)
127.         XCTAssertEqual(ws?.memoryStatus, .stubborn)
128.     }
129. 
130.     func testStubbornAfter2ConsecutiveWrong() async throws {
131.         try await store.introduceWord(userId: userId, wordId: 1)
132.         try db.exec("UPDATE word_state SET box_level = 2, due_at = datetime('now','-1 day') WHERE word_id = 1")
133. 
134.         _ = try await store.recordScoredAnswer(userId: userId, wordId: 1, correct: false)
135.         _ = try await store.recordScoredAnswer(userId: userId, wordId: 1, correct: false)
136. 
137.         let ws = try await store.getWordState(userId: userId, wordId: 1)
138.         XCTAssertEqual(ws?.memoryStatus, .stubborn)
139.     }
140. 
141.     func testFragileAfter1Lapse() async throws {
142.         try await store.introduceWord(userId: userId, wordId: 1)
143.         try db.exec("UPDATE word_state SET box_level = 2, lapse_count = 1, due_at = datetime('now','-1 day') WHERE word_id = 1")
144. 
145.         _ = try await store.recordScoredAnswer(userId: userId, wordId: 1, correct: true)
146. 
147.         let ws = try await store.getWordState(userId: userId, wordId: 1)
148.         XCTAssertEqual(ws?.memoryStatus, .fragile)
149.     }
150. 
151.     func testEasyAtBox3WithHighAccuracyNoLapses() async throws {
152.         try await store.introduceWord(userId: userId, wordId: 1)
153.         try db.exec("UPDATE word_state SET box_level = 3, lapse_count = 0, recent_accuracy = 0.9, due_at = datetime('now','-1 day') WHERE word_id = 1")
154. 
155.         // Need review_log entries for computeRecentAccuracy
156.         let logger = ReviewLogger(db: db)
157.         for _ in 0..<5 {
158.             try await logger.logReview(userId: userId, wordId: 1, outcome: .correct,
159.                                       activityType: .imageGame, sessionType: .morning,
160.                                       studyDay: 0, durationMs: 2000)
161.         }
162. 
163.         _ = try await store.recordScoredAnswer(userId: userId, wordId: 1, correct: true)
164. 
165.         let ws = try await store.getWordState(userId: userId, wordId: 1)
166.         XCTAssertEqual(ws?.memoryStatus, .easy)
167.     }
168. 
169.     // MARK: - Review Queue
170. 
171.     func testReviewQueuePrioritizesBox1First() async throws {
172.         // Create words at different box levels, all due
173.         for i in 1...3 {
174.             try await store.introduceWord(userId: userId, wordId: i)
175.         }
176.         try db.exec("UPDATE word_state SET box_level = 3, due_at = datetime('now','-1 day') WHERE word_id = 1")
177.         try db.exec("UPDATE word_state SET box_level = 1, due_at = datetime('now','-1 day') WHERE word_id = 2")
178.         try db.exec("UPDATE word_state SET box_level = 2, due_at = datetime('now','-1 day') WHERE word_id = 3")
179. 
180.         let queue = try await store.getReviewQueue(userId: userId, limit: 10)
181. 
182.         XCTAssertEqual(queue.count, 3)
183.         XCTAssertEqual(queue[0].wordId, 2, "Box 1 word should be first")
184.         XCTAssertEqual(queue[1].wordId, 3, "Box 2 word should be second")
185.         XCTAssertEqual(queue[2].wordId, 1, "Box 3 word should be last")
186.     }
187. 
188.     func testReviewQueueExcludesNotYetDue() async throws {
189.         try await store.introduceWord(userId: userId, wordId: 1)
190.         try db.exec("UPDATE word_state SET box_level = 2, due_at = datetime('now','+1 day') WHERE word_id = 1")
191. 
192.         let queue = try await store.getReviewQueue(userId: userId, limit: 10)
193.         XCTAssertEqual(queue.count, 0, "Word due tomorrow should not appear")
194.     }
195. 
196.     func testReviewQueuePrioritizesStubbornOverNormal() async throws {
197.         for i in 1...2 {
198.             try await store.introduceWord(userId: userId, wordId: i)
199.         }
200.         try db.exec("UPDATE word_state SET box_level = 1, due_at = datetime('now','-1 day'), memory_status = 'normal' WHERE word_id = 1")
201.         try db.exec("UPDATE word_state SET box_level = 1, due_at = datetime('now','-1 day'), memory_status = 'stubborn' WHERE word_id = 2")
202. 
203.         let queue = try await store.getReviewQueue(userId: userId, limit: 10)
204.         XCTAssertEqual(queue[0].wordId, 2, "Stubborn word should come first within same box")
205.     }
206. 
207.     // MARK: - Day 1 Promotion
208. 
209.     func testDay1PromotionWithTwoOfThreeCorrectAndCorrectFinal() async throws {
210.         try await store.introduceWord(userId: userId, wordId: 1)
211. 
212.         let logger = ReviewLogger(db: db)
213.         // 3 scored events: correct, wrong, correct (2/3, last correct)
214.         try await logger.logReview(userId: userId, wordId: 1, outcome: .correct,
215.                                   activityType: .imageGame, sessionType: .morning, studyDay: 0, durationMs: 2000)
216.         try await logger.logReview(userId: userId, wordId: 1, outcome: .incorrect,
217.                                   activityType: .quickRecall, sessionType: .evening, studyDay: 0, durationMs: 2000)
218.         try await logger.logReview(userId: userId, wordId: 1, outcome: .correct,
219.                                   activityType: .imageGame, sessionType: .evening, studyDay: 0, durationMs: 2000)
220. 
221.         let result = try await store.runDay1Promotion(userId: userId, studyDay: 0)
222. 
223.         XCTAssertEqual(result.promoted, 1)
224.         XCTAssertEqual(result.notPromoted, 0)
225. 
226.         let ws = try await store.getWordState(userId: userId, wordId: 1)
227.         XCTAssertEqual(ws?.boxLevel, 2, "Should promote to box 2")
228.         XCTAssertEqual(ws?.introStage, 3, "Should be marked as decided")
229.     }
230. 
231.     func testDay1PromotionFailsWithWrongFinalRecall() async throws {
232.         try await store.introduceWord(userId: userId, wordId: 1)
233. 
234.         let logger = ReviewLogger(db: db)
235.         // 3 scored events: correct, correct, WRONG (2/3 correct but last is wrong)
236.         try await logger.logReview(userId: userId, wordId: 1, outcome: .correct,
237.                                   activityType: .imageGame, sessionType: .morning, studyDay: 0, durationMs: 2000)
238.         try await logger.logReview(userId: userId, wordId: 1, outcome: .correct,
239.                                   activityType: .quickRecall, sessionType: .evening, studyDay: 0, durationMs: 2000)
240.         try await logger.logReview(userId: userId, wordId: 1, outcome: .incorrect,
241.                                   activityType: .imageGame, sessionType: .evening, studyDay: 0, durationMs: 2000)
242. 
243.         let result = try await store.runDay1Promotion(userId: userId, studyDay: 0)
244. 
245.         XCTAssertEqual(result.promoted, 0)
246.         XCTAssertEqual(result.notPromoted, 1)
247. 
248.         let ws = try await store.getWordState(userId: userId, wordId: 1)
249.         XCTAssertEqual(ws?.boxLevel, 1, "Should stay at box 1")
250.     }
251. 
252.     func testDay1PromotionFailsWithOnlyOneCorrect() async throws {
253.         try await store.introduceWord(userId: userId, wordId: 1)
254. 
255.         let logger = ReviewLogger(db: db)
256.         try await logger.logReview(userId: userId, wordId: 1, outcome: .incorrect,
257.                                   activityType: .imageGame, sessionType: .morning, studyDay: 0, durationMs: 2000)
258.         try await logger.logReview(userId: userId, wordId: 1, outcome: .incorrect,
259.                                   activityType: .quickRecall, sessionType: .evening, studyDay: 0, durationMs: 2000)
260.         try await logger.logReview(userId: userId, wordId: 1, outcome: .correct,
261.                                   activityType: .imageGame, sessionType: .evening, studyDay: 0, durationMs: 2000)
262. 
263.         let result = try await store.runDay1Promotion(userId: userId, studyDay: 0)
264. 
265.         XCTAssertEqual(result.promoted, 0, "1/3 correct should not promote")
266.     }
267. 
268.     // MARK: - Box Distribution
269. 
270.     func testBoxDistributionCounts() async throws {
271.         for i in 1...5 {
272.             try await store.introduceWord(userId: userId, wordId: i)
273.         }
274.         try db.exec("UPDATE word_state SET box_level = 1 WHERE word_id IN (1,2)")
275.         try db.exec("UPDATE word_state SET box_level = 3 WHERE word_id IN (3,4,5)")
276. 
277.         let dist = try await store.getBoxDistribution(userId: userId)
278.         XCTAssertEqual(dist[1], 2)
279.         XCTAssertEqual(dist[3], 3)
280.     }
281. 
282.     // MARK: - Overdue Count
283. 
284.     func testOverdueCount() async throws {
285.         for i in 1...5 {
286.             try await store.introduceWord(userId: userId, wordId: i)
287.         }
288.         try db.exec("UPDATE word_state SET box_level = 1, due_at = datetime('now','-1 day') WHERE word_id IN (1,2,3)")
289.         try db.exec("UPDATE word_state SET box_level = 2, due_at = datetime('now','+1 day') WHERE word_id IN (4,5)")
290. 
291.         let count = try await store.countOverdue(userId: userId)
292.         XCTAssertEqual(count, 3)
293.     }
294. }
295.
```

</details>


---

<sub>⏱️ 1m 54s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Tests/SATVocabAppTests/Data/StatsStoreTests.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Tests/SATVocabAppTests/Data/StatsStoreTests.swift

<details>
<summary>91 lines</summary>

```
1. import XCTest
2. import SQLite3
3. @testable import SATVocabApp
4. 
5. final class StatsStoreTests: XCTestCase {
6.     var db: SQLiteDB!
7.     var store: StatsStore!
8.     var userId: String!
9. 
10.     override func setUpWithError() throws {
11.         db = try TestDatabase.create(withWords: true)
12.         userId = try TestDatabase.createTestUser(db: db)
13.         store = StatsStore(db: db)
14.     }
15. 
16.     func testGetOrCreateDailyStats() async throws {
17.         let stats = try await store.getOrCreateDailyStats(userId: userId, studyDay: 0)
18.         XCTAssertEqual(stats.studyDay, 0)
19.         XCTAssertEqual(stats.xpEarned, 0)
20.         XCTAssertEqual(stats.correctCount, 0)
21.     }
22. 
23.     func testRecordCorrectAddsXP() async throws {
24.         _ = try await store.getOrCreateDailyStats(userId: userId, studyDay: 0)
25.         try await store.recordCorrectAnswer(userId: userId, studyDay: 0)
26.         try await store.recordCorrectAnswer(userId: userId, studyDay: 0)
27. 
28.         let stats = try await store.getOrCreateDailyStats(userId: userId, studyDay: 0)
29.         XCTAssertEqual(stats.correctCount, 2)
30.         XCTAssertEqual(stats.totalCount, 2)
31.         XCTAssertEqual(stats.xpEarned, 20)  // 2 x 10 XP
32.     }
33. 
34.     func testRecordWrongNoXP() async throws {
35.         _ = try await store.getOrCreateDailyStats(userId: userId, studyDay: 0)
36.         try await store.recordWrongAnswer(userId: userId, studyDay: 0)
37. 
38.         let stats = try await store.getOrCreateDailyStats(userId: userId, studyDay: 0)
39.         XCTAssertEqual(stats.correctCount, 0)
40.         XCTAssertEqual(stats.totalCount, 1)
41.         XCTAssertEqual(stats.xpEarned, 0, "Wrong answers earn 0 XP")
42.     }
43. 
44.     func testSessionBonus() async throws {
45.         _ = try await store.getOrCreateDailyStats(userId: userId, studyDay: 0)
46.         try await store.addSessionBonus(userId: userId, studyDay: 0, bonus: 30)
47. 
48.         let stats = try await store.getOrCreateDailyStats(userId: userId, studyDay: 0)
49.         XCTAssertEqual(stats.sessionBonus, 30)
50.     }
51. 
52.     // MARK: - Streak
53. 
54.     func testFirstDayStreakIsOne() async throws {
55.         let (streak, _) = try await store.updateStreak(userId: userId, xpToday: 100)
56.         XCTAssertEqual(streak, 1)
57.     }
58. 
59.     func testStreakMilestoneAt3Days() async throws {
60.         // Simulate 3 consecutive days
61.         try db.exec("UPDATE streak_store SET current_streak = 2, last_study_date = '\(yesterday())' WHERE user_id = '\(userId!)'")
62. 
63.         let (streak, milestoneXP) = try await store.updateStreak(userId: userId, xpToday: 100)
64.         XCTAssertEqual(streak, 3)
65.         XCTAssertEqual(milestoneXP, 20, "3-day streak milestone = +20 XP")
66.     }
67. 
68.     func testStreakMilestoneClaimedOnlyOnce() async throws {
69.         try db.exec("UPDATE streak_store SET current_streak = 2, last_study_date = '\(yesterday())', streak_3_claimed = 1 WHERE user_id = '\(userId!)'")
70. 
71.         let (streak, milestoneXP) = try await store.updateStreak(userId: userId, xpToday: 100)
72.         XCTAssertEqual(streak, 3)
73.         XCTAssertEqual(milestoneXP, 0, "Already claimed -- no bonus")
74.     }
75. 
76.     func testStreakResetsAfterMissedDay() async throws {
77.         try db.exec("UPDATE streak_store SET current_streak = 5, last_study_date = '\(twoDaysAgo())' WHERE user_id = '\(userId!)'")
78. 
79.         let (streak, _) = try await store.updateStreak(userId: userId, xpToday: 100)
80.         XCTAssertEqual(streak, 1, "Streak should reset after missed day")
81.     }
82. 
83.     private func yesterday() -> String {
84.         DateFormatter.yyyyMMdd.string(from: Calendar.current.date(byAdding: .day, value: -1, to: Date())!)
85.     }
86. 
87.     private func twoDaysAgo() -> String {
88.         DateFormatter.yyyyMMdd.string(from: Calendar.current.date(byAdding: .day, value: -2, to: Date())!)
89.     }
90. }
91.
```

</details>


---

<sub>⏱️ 1m 54s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Tests/SATVocabAppTests/Data/SchemaTests.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Tests/SATVocabAppTests/Data/SchemaTests.swift

<details>
<summary>39 lines</summary>

```
1. import XCTest
2. import SQLite3
3. @testable import SATVocabApp
4. 
5. final class SchemaTests: XCTestCase {
6. 
7.     func testSchemaCreatesAllTables() throws {
8.         let db = try TestDatabase.create()
9. 
10.         let expectedTables = [
11.             "lists", "words", "word_list", "sat_contexts", "collocations",
12.             "sat_question_bank", "word_questions", "deepseek_sat_feedback",
13.             "users", "word_state", "day_state", "session_state",
14.             "review_log", "session", "daily_stats", "streak_store", "zone_state"
15.         ]
16. 
17.         for table in expectedTables {
18.             let stmt = try db.prepare("SELECT name FROM sqlite_master WHERE type='table' AND name=?")
19.             defer { stmt?.finalize() }
20.             try SQLiteDB.bind(stmt, 1, table)
21.             XCTAssertEqual(sqlite3_step(stmt), SQLITE_ROW, "Table '\(table)' should exist")
22.         }
23.     }
24. 
25.     func testSchemaIsIdempotent() throws {
26.         let db = try TestDatabase.create()
27.         // Running createAll twice should not fail
28.         XCTAssertNoThrow(try SchemaV2.createAll(db: db))
29.     }
30. 
31.     func testForeignKeysEnabled() throws {
32.         let db = try TestDatabase.create()
33.         let stmt = try db.prepare("PRAGMA foreign_keys;")
34.         defer { stmt?.finalize() }
35.         guard sqlite3_step(stmt) == SQLITE_ROW else { XCTFail(); return }
36.         XCTAssertEqual(SQLiteDB.columnInt(stmt, 0), 1, "Foreign keys should be enabled")
37.     }
38. }
39.
```

</details>


---

<sub>⏱️ 1m 54s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Tests/SATVocabAppTests/Data/ReviewLoggerTests.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Tests/SATVocabAppTests/Data/ReviewLoggerTests.swift

<details>
<summary>50 lines</summary>

```
1. import XCTest
2. import SQLite3
3. @testable import SATVocabApp
4. 
5. final class ReviewLoggerTests: XCTestCase {
6.     var db: SQLiteDB!
7.     var logger: ReviewLogger!
8.     var userId: String!
9. 
10.     override func setUpWithError() throws {
11.         db = try TestDatabase.create(withWords: true)
12.         userId = try TestDatabase.createTestUser(db: db)
13.         logger = ReviewLogger(db: db)
14.     }
15. 
16.     func testLogReviewWritesEntry() async throws {
17.         try await logger.logReview(userId: userId, wordId: 1, outcome: .correct,
18.                                   activityType: .imageGame, sessionType: .morning,
19.                                   studyDay: 0, durationMs: 1500)
20. 
21.         let stmt = try db.prepare("SELECT outcome, activity_type, session_type, study_day, duration_ms, superseded FROM review_log WHERE word_id = 1")
22.         defer { stmt?.finalize() }
23.         guard sqlite3_step(stmt) == SQLITE_ROW else { XCTFail(); return }
24. 
25.         XCTAssertEqual(SQLiteDB.columnText(stmt, 0), "correct")
26.         XCTAssertEqual(SQLiteDB.columnText(stmt, 1), "image_game")
27.         XCTAssertEqual(SQLiteDB.columnText(stmt, 2), "morning")
28.         XCTAssertEqual(SQLiteDB.columnInt(stmt, 3), 0)
29.         XCTAssertEqual(SQLiteDB.columnInt(stmt, 4), 1500)
30.         XCTAssertEqual(SQLiteDB.columnInt(stmt, 5), 0, "Should not be superseded")
31.     }
32. 
33.     func testSupersedeMarksEntriesAsSuperseded() async throws {
34.         // Log 3 entries
35.         for _ in 0..<3 {
36.             try await logger.logReview(userId: userId, wordId: 1, outcome: .correct,
37.                                       activityType: .imageGame, sessionType: .morning,
38.                                       studyDay: 0, durationMs: 1500)
39.         }
40. 
41.         // Supersede
42.         try await logger.supersedeSession(userId: userId, studyDay: 0, sessionType: .morning)
43. 
44.         let stmt = try db.prepare("SELECT COUNT(*) FROM review_log WHERE superseded = 1")
45.         defer { stmt?.finalize() }
46.         guard sqlite3_step(stmt) == SQLITE_ROW else { XCTFail(); return }
47.         XCTAssertEqual(SQLiteDB.columnInt(stmt, 0), 3, "All 3 should be superseded")
48.     }
49. }
50.
```

</details>


---

<sub>⏱️ 1m 54s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/docs/data-schema.md.**

/Users/jiong/myprojects/satspell/docs/data-schema.md (lines 536-705)

<details>
<summary>170 lines</summary>

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
````

</details>


---

<sub>⏱️ 3m 38s</sub>

### 💬 Copilot

I’ve got several real issues already: progression state is drifting from the schema spec, pause/resume only works in one step type, and the view model can report success while DB writes fail. I’m checking a few supporting files now—mainly to pin exact line references and verify whether some of these are latent or already exercised by the app path.

---

<sub>⏱️ 3m 38s</sub>

### ✅ `rg`

**/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp**

<details>
<summary>Arguments</summary>

```json
{
  "pattern": "init\\(db:|progress_snapshot|startSession\\(|finishSession\\(|logReview\\(|fetchReviewQueue\\(|PracticeTabViewModel|initializeIfNeeded\\(|Task \\{|DispatchQueue\\.main\\.asyncAfter|catch \\{\\}|Non-fatal|try\\?|!\\)|fatalError|precondition|force|session_type|study_day|xp_earned",
  "path": "/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp",
  "glob": "**/*.swift",
  "output_mode": "content",
  "-n": true,
  "head_limit": 500
}
```

</details>

<details>
<summary>116 lines</summary>

```
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/SatMCQRoundView.swift:217:        let regex = (try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]))
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SchemaV2.swift:140:            study_day           INTEGER NOT NULL,
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SchemaV2.swift:155:            UNIQUE(user_id, study_day)
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SchemaV2.swift:163:            session_type   TEXT NOT NULL,
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SchemaV2.swift:164:            study_day      INTEGER NOT NULL,
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SchemaV2.swift:173:            UNIQUE(user_id, study_day, session_type)
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SchemaV2.swift:188:            session_type  TEXT,
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SchemaV2.swift:189:            study_day     INTEGER,
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SchemaV2.swift:203:            session_type  TEXT,
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SchemaV2.swift:204:            study_day     INTEGER,
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SchemaV2.swift:205:            xp_earned     INTEGER DEFAULT 0
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SchemaV2.swift:213:            study_day      INTEGER NOT NULL,
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SchemaV2.swift:219:            xp_earned      INTEGER DEFAULT 0,
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SchemaV2.swift:224:            UNIQUE(user_id, study_day)
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SchemaV2.swift:240:            total_study_days  INTEGER DEFAULT 0,
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SchemaV2.swift:269:        "CREATE INDEX IF NOT EXISTS idx_day_state_user ON day_state(user_id, study_day DESC)",
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SchemaV2.swift:273:        "CREATE INDEX IF NOT EXISTS idx_review_log_day ON review_log(user_id, study_day)",
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/GameSessionViewModel.swift:48:        Task {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/GameSessionViewModel.swift:128:                let sId = try await DataManager.shared.startSession(userId: userId, listId: list.id, itemsTotal: allRounds.count)
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/GameSessionViewModel.swift:157:            Task {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/GameSessionViewModel.swift:159:                    try await DataManager.shared.logReview(
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/GameSessionViewModel.swift:187:        Task {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/GameSessionViewModel.swift:189:                try await DataManager.shared.finishSession(sessionId: sessionId, itemsCorrect: itemsCorrect)
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Session/SessionFlowView.swift:58:                            Task { await vm.pause(stepIndex: stepIdx, itemIndex: itemIdx, showAgainIds: saIds, requeuedIds: rqIds) }
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Session/SessionFlowView.swift:69:                            Task { await vm.recordAnswer(correct: correct, wordId: wordId, activityType: .imageGame, durationMs: 0) }
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Session/SessionFlowView.swift:80:                            Task { await vm.recordAnswer(correct: correct, wordId: wordId, activityType: .quickRecall, durationMs: 0) }
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Session/SessionFlowView.swift:91:                            Task { await vm.recordAnswer(correct: correct, wordId: wordId, activityType: .satQuestion, durationMs: 0) }
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/AdventureMapView.swift:146:            Task { await loadZoneWordProgress() }
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/AdventureMapView.swift:153:            try await dm.initializeIfNeeded()
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/SessionFlowViewModel.swift:90:        try await dm.initializeIfNeeded()
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/SessionFlowViewModel.swift:154:            try await reviewLogger.logReview(
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/SessionFlowViewModel.swift:174:            // Non-fatal for v1
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/SessionFlowViewModel.swift:185:        Task {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/SessionFlowViewModel.swift:218:                // Non-fatal
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/SessionFlowViewModel.swift:232:        } catch {}
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/PracticeTabViewModel.swift:5:final class PracticeTabViewModel: ObservableObject {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/PracticeTabViewModel.swift:24:            try await dm.initializeIfNeeded()
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/FlashcardView.swift:210:        let regex = (try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]))
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Utils/TextHighlight.swift:10:        let regex = (try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]))
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/AppBootstrap.swift:9:        Task {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/AppBootstrap.swift:11:                try await DataManager.shared.initializeIfNeeded()
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/TaskProgressStore.swift:28:        precondition((0..<6).contains(taskIndex))
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/FlashcardSessionViewModel.swift:43:        Task {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/FlashcardSessionViewModel.swift:54:                    cards = try await DataManager.shared.fetchReviewQueue(userId: userId, listId: list.id, limit: count)
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/FlashcardSessionViewModel.swift:71:                let sId = try await DataManager.shared.startSession(userId: userId, listId: list.id, itemsTotal: cards.count)
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/FlashcardSessionViewModel.swift:96:        Task {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/FlashcardSessionViewModel.swift:98:                try await DataManager.shared.logReview(
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/FlashcardSessionViewModel.swift:156:        Task {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/FlashcardSessionViewModel.swift:158:                try await DataManager.shared.finishSession(sessionId: sessionId, itemsCorrect: itemsCorrect)
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/ClozeRoundView.swift:78:                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/ClozeRoundView.swift:89:                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/ClozeRoundView.swift:171:        let regex = (try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]))
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/ClozeRoundView.swift:205:        guard let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]) else {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Utils/TextFill.swift:14:        if let r1 = try? NSRegularExpression(pattern: "_{2,}\\s*blank", options: [.caseInsensitive]) {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Utils/TextFill.swift:19:        if let r2 = try? NSRegularExpression(pattern: "_{2,}", options: []) {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/ContentImporter.swift:50:        if let arr = try? decoder.singleValueContainer().decode([String].self) {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/ContentImporter.swift:52:        } else if let dict = try? decoder.singleValueContainer().decode([String: String].self) {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/ContentImporter.swift:186:            try? db.exec("ROLLBACK")
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/StatsStore.swift:23:    init(db: SQLiteDB) { _db = db }
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/StatsStore.swift:31:        INSERT OR IGNORE INTO daily_stats(user_id, study_day, calendar_date)
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/StatsStore.swift:44:        SELECT id, user_id, study_day, calendar_date, new_count, review_count,
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/StatsStore.swift:45:               correct_count, total_count, xp_earned, session_bonus,
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/StatsStore.swift:48:        WHERE user_id = ? AND study_day = ?
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/StatsStore.swift:66:            xp_earned = xp_earned + ?
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/StatsStore.swift:67:        WHERE user_id = ? AND study_day = ?;
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/StatsStore.swift:83:        WHERE user_id = ? AND study_day = ?;
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/StatsStore.swift:98:        WHERE user_id = ? AND study_day = ?;
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/StatsStore.swift:114:        WHERE user_id = ? AND study_day = ?;
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/StatsStore.swift:129:        WHERE user_id = ? AND study_day = ?;
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/StatsStore.swift:145:               total_xp, total_study_days,
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/StatsStore.swift:224:            total_study_days = ?,
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/ReviewLogger.swift:7:    init(db: SQLiteDB) {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/ReviewLogger.swift:11:    func logReview(
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/ReviewLogger.swift:21:        INSERT INTO review_log(user_id, word_id, outcome, duration_ms, reviewed_at, device_id, activity_type, session_type, study_day, superseded)
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/ReviewLogger.swift:47:        WHERE user_id = ? AND study_day = ? AND session_type = ? AND superseded = 0;
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/PracticeTabView.swift:4:    @StateObject private var vm = PracticeTabViewModel()
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/PracticeTabView.swift:27:        .onAppear { Task { await vm.load() } }
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/WordStateStore.swift:25:    init(db: SQLiteDB) {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/ZoneReviewSessionViewModel.swift:33:        Task {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/ZoneReviewSessionViewModel.swift:52:                let cards = try await DataManager.shared.fetchReviewQueue(userId: userId, listId: list.id, limit: 200, restrictToWordIds: zoneWordIds)
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/ZoneReviewSessionViewModel.swift:77:        Task {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/ZoneReviewSessionViewModel.swift:79:                try await DataManager.shared.logReview(
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SessionStateStore.swift:18:        SELECT id, user_id, study_day, zone_index, morning_complete, evening_complete,
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SessionStateStore.swift:24:        ORDER BY study_day DESC
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SessionStateStore.swift:39:        SELECT id, user_id, study_day, zone_index, morning_complete, evening_complete,
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SessionStateStore.swift:44:        WHERE user_id = ? AND study_day = ?
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SessionStateStore.swift:60:        INSERT OR IGNORE INTO day_state(user_id, study_day, zone_index)
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SessionStateStore.swift:87:        WHERE user_id = ? AND study_day = ?;
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SessionStateStore.swift:112:        WHERE user_id = ? AND study_day = ?;
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SessionStateStore.swift:133:        SELECT id, user_id, session_type, study_day, step_index, item_index,
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SessionStateStore.swift:151:        INSERT OR REPLACE INTO session_state(user_id, session_type, study_day, step_index, item_index,
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SessionStateStore.swift:195:        WHERE user_id = ? AND study_day = ? AND session_type = ?;
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SessionStateStore.swift:220:        WHERE user_id = ? AND study_day = ? AND session_type = ?;
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SessionStateStore.swift:237:        WHERE user_id = ? AND study_day = ? AND session_type = ?;
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SessionStateStore.swift:277:        let showAgain = (try? decodeIntArray(showAgainJSON)) ?? []
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SessionStateStore.swift:278:        let requeued = (try? decodeIntArray(requeuedJSON)) ?? []
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/StatsView.swift:124:            try await dm.initializeIfNeeded()
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Components/Button3D.swift:41:                DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/AdventureProgressStore.swift:28:        precondition((0..<4).contains(taskIndex))
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/ImageGameView.swift:18:        if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/ImageGameView.swift:123:            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift:16:    func initializeIfNeeded() throws {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift:109:    func fetchReviewQueue(userId: String, listId: Int, limit: Int) throws -> [VocabCard] {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift:110:        try fetchReviewQueue(userId: userId, listId: listId, limit: limit, restrictToWordIds: nil)
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift:113:    func fetchReviewQueue(userId: String, listId: Int, limit: Int, restrictToWordIds: [Int]?) throws -> [VocabCard] {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift:290:    func logReview(userId: String, wordId: Int, listId: Int?, outcome: ReviewOutcome, durationMs: Int, reviewedAt: Date, deviceId: String) throws {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift:316:    func startSession(userId: String, listId: Int?, itemsTotal: Int, startedAt: Date = Date()) throws -> Int {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift:338:    func finishSession(sessionId: Int, itemsCorrect: Int, endedAt: Date = Date()) throws {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift:363:        INSERT OR IGNORE INTO progress_snapshot(user_id, list_id, mastered_count, total_seen, streak_days, last_reviewed_at, version)
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift:378:        FROM progress_snapshot
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift:428:        UPDATE progress_snapshot
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift:656:        let re = (try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]))
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/ImageResolver.swift:10:           let data = try? Data(contentsOf: url),
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/ImageResolver.swift:17:           let data = try? Data(contentsOf: url),
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/ImageResolver.swift:24:           let data = try? Data(contentsOf: url),
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/QuickRecallView.swift:78:            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
```

</details>


---

<sub>⏱️ 3m 38s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift (lines 521--1)

<details>
<summary>141 lines</summary>

```
521. 
522.         if out.count < limit {
523.             let remaining = limit - out.count
524.             let stmt = try db.prepare(sqlNoPos)
525.             defer { stmt?.finalize() }
526.             try SQLiteDB.bind(stmt, 1, listId)
527.             try SQLiteDB.bind(stmt, 2, excludeWordId)
528.             try SQLiteDB.bind(stmt, 3, remaining)
529.             while sqlite3_step(stmt) == SQLITE_ROW {
530.                 out.append(VocabCard(
531.                     id: SQLiteDB.columnInt(stmt, 0),
532.                     lemma: SQLiteDB.columnText(stmt, 1) ?? "",
533.                     pos: SQLiteDB.columnText(stmt, 2),
534.                     definition: SQLiteDB.columnText(stmt, 3),
535.                     example: SQLiteDB.columnText(stmt, 4),
536.                     imageFilename: SQLiteDB.columnText(stmt, 5)
537.                 ))
538.             }
539.         }
540. 
541.         // Ensure uniqueness by id.
542.         var seen = Set<Int>()
543.         return out.filter { seen.insert($0.id).inserted }.prefix(limit).map { $0 }
544.     }
545. 
546.     func fetchSatQuestionsForWord(wordId: Int, limit: Int, verifiedOnly: Bool) throws -> [SatQuestion] {
547.         let lemma = (try fetchWordById(wordId: wordId)?.lemma ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
548. 
549.          let sql = """
550.          WITH fb AS (
551.              SELECT question_id,
552.                  answer AS deepseek_answer,
553.                  background AS deepseek_background,
554.                  reason_for_answer AS deepseek_reason,
555.                  ROW_NUMBER() OVER (PARTITION BY question_id ORDER BY created_at DESC, id DESC) AS rn
556.              FROM deepseek_sat_feedback
557.              WHERE ai_source = 'deepseek'
558.          )
559.          SELECT q.id, q.word_id, q.target_word, q.section, q.module, q.q_type,
560.              q.passage, q.question, q.option_a, q.option_b, q.option_c, q.option_d,
561.              q.answer, q.source_pdf, q.page,
562.              q.feedback_generated, q.answer_verified,
563.              fb.deepseek_answer, fb.deepseek_background, fb.deepseek_reason
564.          FROM sat_question_bank q
565.          JOIN word_questions wq ON wq.question_id = q.id
566.          LEFT JOIN fb ON fb.question_id = q.id AND fb.rn = 1
567.          WHERE wq.word_id = ?
568.            AND (? = 0 OR q.answer_verified = 1)
569.            AND q.answer IS NOT NULL AND TRIM(q.answer) <> ''
570.            AND q.option_a IS NOT NULL AND TRIM(q.option_a) <> ''
571.            AND q.option_b IS NOT NULL AND TRIM(q.option_b) <> ''
572.            AND q.option_c IS NOT NULL AND TRIM(q.option_c) <> ''
573.            AND q.option_d IS NOT NULL AND TRIM(q.option_d) <> ''
574.          ORDER BY RANDOM()
575.          LIMIT ?;
576.          """
577.         let stmt = try db.prepare(sql)
578.         defer { stmt?.finalize() }
579. 
580.         try SQLiteDB.bind(stmt, 1, wordId)
581.         try SQLiteDB.bind(stmt, 2, verifiedOnly ? 1 : 0)
582.         try SQLiteDB.bind(stmt, 3, limit)
583. 
584.         var out: [SatQuestion] = []
585.         while sqlite3_step(stmt) == SQLITE_ROW {
586.             out.append(SatQuestion(
587.                 id: SQLiteDB.columnText(stmt, 0) ?? "",
588.                 wordId: sqlite3_column_type(stmt, 1) == SQLITE_NULL ? nil : SQLiteDB.columnInt(stmt, 1),
589.                 targetWord: SQLiteDB.columnText(stmt, 2),
590.                 section: SQLiteDB.columnText(stmt, 3),
591.                 module: sqlite3_column_type(stmt, 4) == SQLITE_NULL ? nil : SQLiteDB.columnInt(stmt, 4),
592.                 qType: SQLiteDB.columnText(stmt, 5),
593.                 passage: SQLiteDB.columnText(stmt, 6),
594.                 question: SQLiteDB.columnText(stmt, 7),
595.                 optionA: SQLiteDB.columnText(stmt, 8),
596.                 optionB: SQLiteDB.columnText(stmt, 9),
597.                 optionC: SQLiteDB.columnText(stmt, 10),
598.                 optionD: SQLiteDB.columnText(stmt, 11),
599.                 answer: SQLiteDB.columnText(stmt, 12),
600.                 sourcePdf: SQLiteDB.columnText(stmt, 13),
601.                 page: sqlite3_column_type(stmt, 14) == SQLITE_NULL ? nil : SQLiteDB.columnInt(stmt, 14),
602.                 feedbackGenerated: SQLiteDB.columnInt(stmt, 15),
603.                 answerVerified: SQLiteDB.columnInt(stmt, 16),
604.                 deepseekAnswer: SQLiteDB.columnText(stmt, 17),
605.                 deepseekBackground: SQLiteDB.columnText(stmt, 18),
606.                 deepseekReason: SQLiteDB.columnText(stmt, 19)
607.             ))
608.         }
609. 
610.         // Prefer questions where the *correct* answer is the target lemma.
611.         // This keeps Task 4 aligned: keyword == the word you're trying to pick.
612.         if !lemma.isEmpty {
613.             let preferred = out.filter { q in
614.                 Self.answerMatchesTargetWord(answer: q.answer, targetWord: lemma)
615.             }
616.             if !preferred.isEmpty {
617.                 return Array(preferred.prefix(limit))
618.             }
619.         }
620. 
621.         return out
622.     }
623. 
624.     private static func normalizedComparable(_ s: String) -> String {
625.         var t = s.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
626.         // Collapse whitespace
627.         t = t.split(whereSeparator: { $0.isWhitespace }).joined(separator: " ")
628. 
629.         // Trim leading/trailing punctuation/quotes (so "Indeed," matches "indeed")
630.         let trimSet = CharacterSet.punctuationCharacters
631.             .union(.whitespacesAndNewlines)
632.             .union(CharacterSet(charactersIn: "\"\u{201C}\u{201D}\u{2018}\u{2019}"))
633. 
634.         while let first = t.unicodeScalars.first, trimSet.contains(first) {
635.             t = String(t.unicodeScalars.dropFirst())
636.         }
637.         while let last = t.unicodeScalars.last, trimSet.contains(last) {
638.             t = String(t.unicodeScalars.dropLast())
639.         }
640.         return t
641.     }
642. 
643.     private static func answerMatchesTargetWord(answer: String?, targetWord: String) -> Bool {
644.         let a = normalizedComparable(answer ?? "")
645.         let w = normalizedComparable(targetWord)
646.         guard !a.isEmpty, !w.isEmpty else { return false }
647. 
648.         if a == w { return true }
649. 
650.         // If the answer is longer text (rare), allow whole-word containment.
651.         if w.contains(" ") {
652.             return a.contains(w)
653.         }
654. 
655.         let pattern = "\\b" + NSRegularExpression.escapedPattern(for: w) + "\\b"
656.         let re = (try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]))
657.         let range = NSRange(location: 0, length: (a as NSString).length)
658.         return re?.firstMatch(in: a, range: range) != nil
659.     }
660. }
661.
```

</details>


---

<sub>⏱️ 3m 38s</sub>

### ✅ `glob`

**/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp**

"**/PracticeTabViewModel.swift" in /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp

```
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/PracticeTabViewModel.swift
```


---

<sub>⏱️ 3m 38s</sub>

### ✅ `rg`

**/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp**

<details>
<summary>Arguments</summary>

```json
{
  "pattern": "DispatchQueue\\.main\\.asyncAfter|onPause: \\{ _, _, _, _ in dismiss\\(\\) \\}|catch \\{\\s*// Non-fatal|catch \\{\\}|showFeedback|selectedOption|isComplete = true|createSession\\(|getOrCreateDayState\\(|getOrCreateDailyStats\\(|getReviewQueue\\(|runDay1Promotion\\(|recordScoredAnswer\\(",
  "path": "/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp",
  "glob": "**/*.{swift}",
  "output_mode": "content",
  "-n": true,
  "head_limit": 400
}
```

</details>

<details>
<summary>55 lines</summary>

```
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Session/SessionFlowView.swift:72:                        onPause: { _, _, _, _ in dismiss() }
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Session/SessionFlowView.swift:83:                        onPause: { _, _, _, _ in dismiss() }
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Session/SessionFlowView.swift:94:                        onPause: { _, _, _, _ in dismiss() }
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/SatMCQRoundView.swift:14:    @State private var showFeedbackSheet = false
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/SatMCQRoundView.swift:50:            showFeedbackSheet = false
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/SatMCQRoundView.swift:53:        .sheet(isPresented: $showFeedbackSheet) {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/SatMCQRoundView.swift:64:            guard showFeedbackSheet == false else { return }
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/SatMCQRoundView.swift:77:            showFeedbackSheet = true
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/SatMCQRoundView.swift:188:                            showFeedbackSheet = false
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/SatMCQRoundView.swift:196:                            showFeedbackSheet = false
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/DayCompleteSummary.swift:43:                dailyStats = try await statsStore.getOrCreateDailyStats(userId: userId, studyDay: studyDay)
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/SATQuestionView.swift:7:    @State private var selectedOption: String? = nil
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/SATQuestionView.swift:8:    @State private var showFeedback = false
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/SATQuestionView.swift:113:                guard let selected = selectedOption, !showFeedback else { return }
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/SATQuestionView.swift:116:                showFeedback = true
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/SATQuestionView.swift:123:                    .background(selectedOption != nil && !showFeedback ? Color(hex: "#58CC02") : Color(hex: "#E5E5E5"))
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/SATQuestionView.swift:126:            .disabled(selectedOption == nil || showFeedback)
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/SATQuestionView.swift:130:        .sheet(isPresented: $showFeedback) {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/SATQuestionView.swift:137:                    showFeedback = false
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/SATQuestionView.swift:147:        let isSelected = selectedOption == letter
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/SATQuestionView.swift:148:        let isCorrectOption = showFeedback && letter == correctLetter
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/SATQuestionView.swift:149:        let isWrongSelected = showFeedback && isSelected && letter != correctLetter
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/SATQuestionView.swift:152:            guard !showFeedback else { return }
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/SATQuestionView.swift:153:            selectedOption = letter
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/QuickRecallView.swift:10:    @State private var showFeedback = false
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/QuickRecallView.swift:49:        .allowsHitTesting(!showFeedback)
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/QuickRecallView.swift:56:            guard showFeedback else { return .white }
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/QuickRecallView.swift:63:            guard showFeedback else { return Color(hex: "#E5E5E5") }
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/QuickRecallView.swift:71:            guard !showFeedback else { return }
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/QuickRecallView.swift:75:            showFeedback = true
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/QuickRecallView.swift:78:            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/ImageGameView.swift:12:    @State private var showFeedback = false
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/ImageGameView.swift:93:        .allowsHitTesting(!showFeedback)
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/ImageGameView.swift:101:            guard showFeedback else { return .white }
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/ImageGameView.swift:108:            guard showFeedback else { return Color(hex: "#E5E5E5") }
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/ImageGameView.swift:116:            guard !showFeedback else { return }
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/ImageGameView.swift:120:            showFeedback = true
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/ImageGameView.swift:123:            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/ClozeRoundView.swift:78:                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/ClozeRoundView.swift:89:                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Components/Button3D.swift:41:                DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/WordStateStore.swift:50:    func getReviewQueue(userId: String, limit: Int) throws -> [WordState] {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/WordStateStore.swift:165:    func recordScoredAnswer(userId: String, wordId: Int, correct: Bool) throws -> BoxChange {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/WordStateStore.swift:253:    func runDay1Promotion(userId: String, studyDay: Int) throws -> (promoted: Int, notPromoted: Int) {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/StatsStore.swift:27:    func getOrCreateDailyStats(userId: String, studyDay: Int) throws -> DailyStats {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/SessionFlowViewModel.swift:96:        _ = try await sessionStore.getOrCreateDayState(userId: userId, studyDay: studyDay, zoneIndex: zoneIdx)
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/SessionFlowViewModel.swift:97:        _ = try await sessionStore.createSession(userId: userId, sessionType: sessionType, studyDay: studyDay)
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/SessionFlowViewModel.swift:98:        _ = try await statsStore.getOrCreateDailyStats(userId: userId, studyDay: studyDay)
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/SessionFlowViewModel.swift:117:        let reviews = try await wsStore.getReviewQueue(userId: userId, limit: 6)
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/SessionFlowViewModel.swift:160:            let boxChange = try await wsStore.recordScoredAnswer(userId: userId, wordId: wordId, correct: correct)
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/SessionFlowViewModel.swift:183:        isComplete = true
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/SessionFlowViewModel.swift:210:                    let promotion = try await wsStore.runDay1Promotion(userId: userId, studyDay: studyDay)
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/SessionFlowViewModel.swift:232:        } catch {}
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SessionStateStore.swift:57:    func getOrCreateDayState(userId: String, studyDay: Int, zoneIndex: Int) throws -> DayState {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SessionStateStore.swift:148:    func createSession(userId: String, sessionType: SessionType, studyDay: Int) throws -> SessionState {
```

</details>


---

<sub>⏱️ 3m 38s</sub>

### ✅ `rg`

**/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp**

<details>
<summary>Arguments</summary>

```json
{
  "pattern": "TODO|FIXME|progress_snapshot|vocab_progress_sync|review_only|recovery_evening|catch_up|re_entry|zone_test|bonus",
  "path": "/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp",
  "glob": "**/*.swift",
  "output_mode": "content",
  "-n": true,
  "head_limit": 300
}
```

</details>

<details>
<summary>21 lines</summary>

```
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SchemaV2.swift:153:            is_review_only_day  INTEGER DEFAULT 0,
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SchemaV2.swift:220:            session_bonus  INTEGER DEFAULT 0,
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift:363:        INSERT OR IGNORE INTO progress_snapshot(user_id, list_id, mastered_count, total_seen, streak_days, last_reviewed_at, version)
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift:378:        FROM progress_snapshot
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift:428:        UPDATE progress_snapshot
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/StatsStore.swift:45:               correct_count, total_count, xp_earned, session_bonus,
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/StatsStore.swift:94:    func addSessionBonus(userId: String, studyDay: Int, bonus: Int = AppConfig.sessionBonusXP) throws {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/StatsStore.swift:97:        SET session_bonus = session_bonus + ?
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/StatsStore.swift:102:        try SQLiteDB.bind(stmt, 1, bonus)
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/StatsStore.swift:204:        // Calculate milestone bonuses
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/SessionFlowViewModel.swift:80:            // Recovery/review/bonus sessions — simplified
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/SessionFlowViewModel.swift:193:                // Session bonus
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SessionStateStore.swift:21:               is_recovery_day, is_review_only_day
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SessionStateStore.swift:42:               is_recovery_day, is_review_only_day
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/AppConfig.swift:50:    static let bonusPracticeXP = 5
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Models/Enums.swift:7:    case recoveryEvening = "recovery_evening"
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Models/Enums.swift:8:    case catchUp = "catch_up"
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Models/Enums.swift:9:    case reEntry = "re_entry"
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Models/Enums.swift:10:    case reviewOnly = "review_only"
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Models/Enums.swift:11:    case zoneTest = "zone_test"
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Models/Enums.swift:12:    case bonus
```

</details>


---

<sub>⏱️ 3m 38s</sub>

### ℹ️ Notification

Background agent "Audit UI flow" (explore) completed

<details>
<summary>Detail</summary>

You are performing a deep code review of the SAT Vocab iOS app implementation. Investigate ONLY the view model and SwiftUI flow layer.

Read these files completely:
- /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/SessionFlowViewModel.swift
- /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Session/SessionFlowView.swift
- /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Flashcard/FlashcardFrontView.swift
- /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Flashcard/FlashcardBackView.swift
- /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Flashcard/FlashcardCardView.swift
- /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Flashcard/FlashcardStepView.swift
- /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/ImageGameView.swift
- /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/QuickRecallView.swift
- /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/SATQuestionView.swift
- /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/PracticeTabView.swift
- /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/PracticeStateResolver.swift
- /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/RootTabView.swift

Focus on:
1. CRASH RISKS (force unwraps, index errors, invalid assumptions)
2. EMPTY STATES and zero-word flows
3. ERROR HANDLING and user-visible failure modes
4. MEMORY LEAKS / retain cycles in closures / Tasks
5. FIRST-LAUNCH behavior through the session flow
6. Any significant UX or state bugs caused by missing data or async timing

Return only concrete findings. For each finding include: severity (CRITICAL/HIGH/MEDIUM/LOW), exact file:line, concise explanation, and suggested fix. Do not modify files.

</details>

---

<sub>⏱️ 3m 38s</sub>

### ℹ️ Notification

Background agent "Audit tests" (explore) completed

<details>
<summary>Detail</summary>

You are performing a deep code review of the SAT Vocab iOS app tests. Investigate ONLY the listed unit tests.

Read these files completely:
- /Users/jiong/myprojects/satspell/ios/SATVocabApp/Tests/SATVocabAppTests/Data/WordStateStoreTests.swift
- /Users/jiong/myprojects/satspell/ios/SATVocabApp/Tests/SATVocabAppTests/Data/StatsStoreTests.swift
- /Users/jiong/myprojects/satspell/ios/SATVocabApp/Tests/SATVocabAppTests/Data/SchemaTests.swift
- /Users/jiong/myprojects/satspell/ios/SATVocabApp/Tests/SATVocabAppTests/Data/ReviewLoggerTests.swift

Determine:
1. Which critical bugs in the current implementation are already covered
2. Which serious issues are not covered at all
3. The best candidate regression tests to add if specific bugs are confirmed

Return concise findings with exact file:line references where relevant. Do not modify files or run commands.

</details>

---

<sub>⏱️ 4m 41s</sub>

### 💬 Copilot

The first pass is consistent: the existing tests all pass, but they mostly lock in the current behavior rather than the spec, which is why some serious lifecycle bugs aren’t being caught. I’m pulling the agent summaries plus the small app-start files now so I can finish the finding list before I add any targeted repro tests.

---

<sub>⏱️ 4m 41s</sub>

### ✅ `read_agent`

**Explore agent (Audit UI flow)**

<details>
<summary>Arguments</summary>

```json
{
  "agent_id": "ui-flow-audit",
  "wait": true,
  "timeout": 10
}
```

</details>

<details>
<summary>119 lines</summary>

```
Agent completed. agent_id: ui-flow-audit, agent_type: explore, status: completed, description: Audit UI flow, elapsed: 167s, total_turns: 0, model: claude-haiku-4.5, duration: 51s

Perfect. Now let me verify the issues with a comprehensive review:

## DEEP CODE REVIEW - SAT VOCAB iOS VIEW MODEL & SWIFTUI FLOW

Based on my analysis of the view model and SwiftUI flow layers, here are the critical findings:

---

### **CRITICAL ISSUES**

1. **CRITICAL - Force Unwrap on Step Transitions | SessionFlowView.swift:43**
   - **File:Line:** `/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Session/SessionFlowView.swift:43`
   - **Issue:** `vm.steps[safe: vm.currentStepIndex + 1]?.label ?? "Done"` uses safe indexing but transitions when `currentStepIndex` may be at last step, showing "Done" incorrectly. However, real crash: On empty steps array, `vm.currentStep` at line 46 will become nil and entire session crashes silently into empty state.
   - **Severity:** CRITICAL
   - **Suggested Fix:** Guard against empty steps array in SessionFlowViewModel init. Add: `if steps.isEmpty { fatalError("Session must have at least one step") }` or return early with error handling. Validate in SessionFlowView that `vm.totalSteps > 0` before proceeding.

---

2. **CRITICAL - Zero-Word Session Flow Crash | SessionFlowViewModel.swift:88-113**
   - **File:Line:** `/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/SessionFlowViewModel.swift:100-105`
   - **Issue:** If `dm.getDefaultList()` returns a list but `fetchSessionQueue()` returns empty array (e.g., not enough words in database), `newWords` remains empty. All game steps then receive empty `words: []`. ImageGameStepView/QuickRecallStepView/SATQuestionStepView will load with empty arrays → show loading screen forever because their async tasks complete but find 0 rounds, never calling `onComplete()`. Session becomes stuck.
   - **Severity:** CRITICAL
   - **Suggested Fix:** In `loadWords()`, after fetching, validate: `guard !newWords.isEmpty else { throw LoadError.insufficientWords }`. Propagate to SessionFlowView loadError state.

---

3. **CRITICAL - Memory Leak via DispatchQueue.main.asyncAfter | ImageGameView.swift:123 & QuickRecallView.swift:78**
   - **File:Line:** `/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/ImageGameView.swift:123` and `/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/QuickRecallView.swift:78`
   - **Issue:** `DispatchQueue.main.asyncAfter(deadline: .now() + delay) { onAnswer(correct) }` captures `self` (closure by default captures view, which keeps parent alive). If user dismisses view (pause/exit) before delay fires, the closure still executes, calling `onAnswer()` on deallocated view's parent. Also: closure holds reference to closure parameters, creating retain cycle in some contexts.
   - **Severity:** CRITICAL
   - **Suggested Fix:** Use `Task.sleep(nanoseconds:)` instead: `Task { try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000)); onAnswer(correct) }`. Or store task ID to cancel: `@State var feedbackTask: Task<Void, Never>?` then `feedbackTask?.cancel()` on dismiss.

---

4. **CRITICAL - Array Index Out of Bounds in Empty State | SATQuestionStepView.swift:37-51**
   - **File:Line:** `/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/SATQuestionStepView.swift:37-51`
   - **Issue:** Line 38: `let round = questions[currentRound]` - if `questions` array is empty after loading (no SAT questions found in DB for any word), the condition `else if currentRound < totalRounds` is false (0 < 0), so it skips to else block at line 51. Good. BUT: the step is called with `words: vm.newWords` which could be empty, then `loadQuestions()` fetches questions for empty word list and returns empty. Then step transitions stuck because there are 0 questions but step expects >= 1.
   - **Severity:** CRITICAL
   - **Suggested Fix:** In loadQuestions(), after loop: `guard !loaded.isEmpty else { onComplete() }` so empty state auto-continues instead of showing "No SAT questions" indefinitely.

---

### **HIGH SEVERITY ISSUES**

5. **HIGH - Unhandled Task Completion in completeSession | SessionFlowViewModel.swift:185-220**
   - **File:Line:** `/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/SessionFlowViewModel.swift:185-220`
   - **Issue:** `Task { ... }` at line 185 is fire-and-forget with no cancellation token. If view dismisses before Task completes, operations continue in background. If user immediately restarts same session, dual tasks race to update `sessionStore.completeSession()`, causing potential data corruption or hung UI.
   - **Severity:** HIGH
   - **Suggested Fix:** Store task: `@State var completionTask: Task<Void, Never>?`. In `completeSession()` use `completionTask = Task { ... }`. Add `.onDisappear { completionTask?.cancel() }` to SessionFlowView.

---

6. **HIGH - First-Launch Empty State: ReviewWords Not Loaded | SessionFlowViewModel.swift:115-120**
   - **File:Line:** `/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/SessionFlowViewModel.swift:115-120`
   - **Issue:** `reviewWords` is declared but never used. Line 120: `_ = reviews` suppresses "unused" warning. On first launch, there are no review_log entries, so `getReviewQueue()` returns empty. But reviewWords is never populated into step data, so if a step ever tries to use `reviewWords`, it's always empty. Also: evening quick recall uses `morningWords` which is only populated if sessionType == .evening, but never validated as non-empty before being passed to QuickRecallStepView.
   - **Severity:** HIGH
   - **Suggested Fix:** Either (a) remove unused reviewWords and code, or (b) properly load and pass it. For evening session, validate: `guard !morningWords.isEmpty else { return error "No morning words" }` before starting QuickRecall step.

---

7. **HIGH - Cascade Failure: Steps with Wrong Word Arrays | SessionFlowView.swift:49-96**
   - **File:Line:** `/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Session/SessionFlowView.swift:62-95`
   - **Issue:** All game steps (imageGame, quickRecall, satQuestion) receive `words: vm.newWords` regardless of step type. But QuickRecall step should receive `vm.morningWords`. This means:
     - Morning session: QuickRecall doesn't exist, OK.
     - Evening session: QuickRecall should show morning words but receives evening new words → user sees wrong content.
   - **Severity:** HIGH
   - **Suggested Fix:** Change line 76: `words: vm.morningWords,` instead of `vm.newWords,`.

---

### **MEDIUM SEVERITY ISSUES**

8. **MEDIUM - Silent Error Swallowing in recordAnswer | SessionFlowViewModel.swift:135-176**
   - **File:Line:** `/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/SessionFlowViewModel.swift:173-175`
   - **Issue:** `catch { }` silently swallows all errors from review logging, word state updates, and stats updates. User sees correct/incorrect feedback but backend state is never updated. Over session, scoring and progress data become corrupted.
   - **Severity:** MEDIUM
   - **Suggested Fix:** Log errors: `catch { print("ERROR: recordAnswer failed: \(error)") }`. Consider soft-failing with retry or user notification.

---

9. **MEDIUM - Pause State Not Properly Saved | SessionFlowViewModel.swift:225-232**
   - **File:Line:** `/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/SessionFlowViewModel.swift:232`
   - **Issue:** `catch {}` swallows pause errors. If `store.pauseSession()` fails (DB error), user can exit thinking session is paused, but backend never marked it paused. On next launch, session resumes from step 0 instead of resumed step.
   - **Severity:** MEDIUM
   - **Suggested Fix:** Propagate error back to view. Change to `func pause(...) async throws`, and let SessionFlowView handle error with alert.

---

10. **MEDIUM - Day1Promotion Run Only on Evening, Missing Morning Path | SessionFlowViewModel.swift:207-212**
    - **File:Line:** `/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/SessionFlowViewModel.swift:207-212`
    - **Issue:** `runDay1Promotion()` only called after evening session. Morning session never triggers promotion. If user only completes morning and doesn't return for evening (e.g., abandons app), Day 1 promotion never runs.
    - **Severity:** MEDIUM
    - **Suggested Fix:** Run promotion after morning session too (or check day count and run when appropriate): Add after morning complete block.

---

### **LOW SEVERITY ISSUES**

11. **LOW - ImageResolver.uiImage May Return Nil Without Error State | FlashcardFrontView.swift:12-28**
    - **File:Line:** `/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Flashcard/FlashcardFrontView.swift:12-28`
    - **Issue:** If ImageResolver fails to load image, fallback gradient is shown. User may think image is broken. No feedback about why.
    - **Severity:** LOW
    - **Suggested Fix:** Add subtle error indicator or log cache miss.

---

12. **LOW - FlashcardStepView currentCard Optional Unwrap Risk | FlashcardStepView.swift:48-100**
    - **File:Line:** `/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Flashcard/FlashcardStepView.swift:48-100`
    - **Issue:** `if let card = currentCard` is safe, but if `words` array is empty on init, first card is nil and empty state shows immediately. No "loading" phase. User sees "All caught up!" even on first session.
    - **Severity:** LOW
    - **Suggested Fix:** Add `@State isLoading = true` phase before displaying cards, matching pattern from other step views.

---

13. **LOW - SATQuestionView.correctLetter Fallback to "A" | SATQuestionView.swift:43**
    - **File:Line:** `/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/SATQuestionView.swift:43`
    - **Issue:** If answer parsing fails, defaults to "A". User may be marked wrong when they selected the correct answer.
    - **Severity:** LOW
    - **Suggested Fix:** Log warning and provide better fallback or error state.

---

14. **LOW - Box Level & Memory Status Hardcoded in FlashcardStepView | FlashcardStepView.swift:53-54**
    - **File:Line:** `/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Flashcard/FlashcardStepView.swift:53-54`
    - **Issue:** `boxLevel: 0, memoryStatus: .normal` hardcoded for all new words. Should fetch actual box levels from DB to show accurate strength meter.
    - **Severity:** LOW
    - **Suggested Fix:** Load box levels from word_state table and pass actual values.

---

15. **LOW - PracticeStateResolver Fallback Date Calculation Issue | PracticeStateResolver.swift:48-56**
    - **File:Line:** `/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/PracticeStateResolver.swift:48-56`
    - **Issue:** If `morningCompleteAt` is nil, calculates fallback to 5 PM today. But min() compares hoursLater (can be tomorrow) vs fallback (today). If hoursLater is tomorrow 2 PM and fallback is today 5 PM, min returns today 5 PM (locked), which is wrong if it's already past 5 PM today.
    - **Severity:** LOW
    - **Suggested Fix:** Ensure fallback is at least today's unlock time: `return max(hoursLater, fallback)` instead of `min()`.

---

## SUMMARY TABLE

| # | Severity | File | Line(s) | Issue |
|---|----------|------|---------|-------|
| 1 | **CRITICAL** | SessionFlowView.swift | 46 | Empty steps array crashes session |
| 2 | **CRITICAL** | SessionFlowViewModel.swift | 100-105 | Zero-word session stuck forever |
| 3 | **CRITICAL** | ImageGameView.swift, QuickRecallView.swift | 123, 78 | Memory leak via DispatchQueue closure |
| 4 | **CRITICAL** | SATQuestionStepView.swift | 37-51 | No SAT questions auto-completes stuck |
| 5 | **HIGH** | SessionFlowViewModel.swift | 185-220 | Fire-and-forget completion Task |
| 6 | **HIGH** | SessionFlowViewModel.swift | 115-120 | morningWords never validated empty |
| 7 | **HIGH** | SessionFlowView.swift | 62-95 | QuickRecall receives wrong word array |
| 8 | **MEDIUM** | SessionFlowViewModel.swift | 173-175 | Error swallowing in recordAnswer |
| 9 | **MEDIUM** | SessionFlowViewModel.swift | 232 | Pause state not saved on error |
| 10 | **MEDIUM** | SessionFlowViewModel.swift | 207-212 | Day1Promotion missing morning path |
| 11 | **LOW** | FlashcardFrontView.swift | 12-28 | Image load failure no feedback |
| 12 | **LOW** | FlashcardStepView.swift | 48-100 | No loading state for empty words |
| 13 | **LOW** | SATQuestionView.swift | 43 | Answer fallback to "A" wrong |
| 14 | **LOW** | FlashcardStepView.swift | 53-54 | Box level hardcoded to 0 |
| 15 | **LOW** | PracticeStateResolver.swift | 48-56 | Evening unlock time calc inverted |
```

</details>


---

<sub>⏱️ 4m 41s</sub>

### ✅ `read_agent`

**Explore agent (Audit tests)**

<details>
<summary>Arguments</summary>

```json
{
  "agent_id": "test-audit",
  "wait": true,
  "timeout": 10
}
```

</details>

<details>
<summary>175 lines</summary>

````
Agent completed. agent_id: test-audit, agent_type: explore, status: completed, description: Audit tests, elapsed: 167s, total_turns: 0, model: claude-haiku-4.5, duration: 97s

Perfect. Now I have enough information to provide comprehensive findings. Let me compile them.

---

## DEEP CODE REVIEW: SAT Vocab iOS App Unit Tests

### 1. CRITICAL BUGS ALREADY COVERED

**WordStateStoreTests.swift:**
- ✅ **Box progression logic** (lines 39-65): Tests promotion to box 5 and demotion back to box 1
- ✅ **Lapse count tracking** (lines 69-95): Wrong answers properly increment lapses (except from box 1)
- ✅ **Consecutive wrong counter** (lines 97-116): Tracks consecutive failures and resets on correct
- ✅ **Day1Promotion threshold logic** (lines 209-266): Validates 2/3 correct + final correct requirement
- ✅ **Review queue prioritization** (lines 171-205): Box level sorting and stubborn word prioritization
- ✅ **Memory status classification** (lines 120-167): Tests all four statuses (stubborn, fragile, easy, normal)

**StatsStoreTests.swift:**
- ✅ **XP calculation** (lines 23-42): Correct answers earn XP, wrong answers don't
- ✅ **Streak reset on missed day** (lines 76-81): Properly resets after 2+ days without activity
- ✅ **Streak milestone at day 3** (lines 59-74): Awards bonus XP once, prevents duplicate claims

**SchemaTests.swift:**
- ✅ **Schema initialization** (lines 7-23): All 17 tables created
- ✅ **Foreign key enforcement** (lines 31-37): PRAGMA enabled

**ReviewLoggerTests.swift:**
- ✅ **Review entry logging** (lines 16-31): Correctly records all fields including superseded flag
- ✅ **Session supersession** (lines 33-48): Marks matching entries correctly

---

### 2. SERIOUS ISSUES NOT COVERED AT ALL

#### **A. computeRecentAccuracy() - Private Function Never Tested**
- **Location:** WordStateStore.swift:368-399
- **Risk:** Accuracy calculation used in memoryStatus classification and Day1Promotion, but the function itself is never isolated and tested
- **Gap:** No test for:
  - Behavior when outcomes are empty
  - Prepending logic with `includingCurrent` parameter
  - Limiting to last 5 entries edge case
  - NULL/nil handling in review_log queries

#### **B. Recent Accuracy Edge Cases in Memory Classification**
- **Location:** WordStateStoreTests.swift:151-167 (testEasyAtBox3WithHighAccuracyNoLapses)
- **Risk:** Memory status logic at line 405 (StatsStore.swift) uses `recentAccuracy < 0.6` but tests don't validate:
  - Boundary: 0.6 exactly → should be fragile? (not tested)
  - Boundary: 0.85 exactly → should be easy? (not tested)
  - What happens when recentAccuracy=0.0 (all wrong)?
  - What if recentAccuracy > 1.0 (should be impossible, but untested)?

#### **C. Streak Milestones 7/14/30 Day Completeness**
- **Location:** StatsStoreTests.swift:142-248, but only tests day 3
- **Missing tests:**
  - 7-day milestone bonus (+50 XP) - **NEVER TESTED**
  - 14-day milestone bonus (+100 XP) - **NEVER TESTED**
  - 30-day milestone bonus (+200 XP) - **NEVER TESTED**
  - Cascading milestones (e.g., reaching day 7 should also claim day 3 if not already claimed)

#### **D. Stats Tracking Functions Not Tested**
- **Location:** StatsStore.swift:110-138
- **Missing tests:**
  - `recordWordPromoted()` - increments words_promoted counter
  - `recordWordDemoted()` - increments words_demoted counter
  - `newCount` and `reviewCount` fields in daily_stats never appear in tests

#### **E. Session State Mismatch / Supersession Incomplete Coverage**
- **Location:** ReviewLoggerTests.swift:33-48
- **Gap:** `testSupersedeMarksEntriesAsSuperseded` only tests single session supersession
- **Missing:**
  - Superseding with different wordIds (should NOT affect other words)
  - Superseding with different studyDays (should NOT affect other days)
  - Partial supersession when some entries already superseded
  - No test that entries NOT matching all 3 criteria (userId, studyDay, sessionType) remain untouched

#### **F. Day1Promotion Edge Cases**
- **Location:** WordStateStoreTests.swift:209-266
- **Missing critical tests:**
  - Word with `intro_stage = 3` (already decided) - should be skipped
  - Word with `intro_stage = 4` or higher - untested
  - Exactly 3 entries (boundary) vs. 4+ entries (does it use only first 3?)
  - Exactly 2/3 correct (boundary) vs. 3/3 correct
  - Zero review_log entries for a word (edge case)
  - Entries only from non-scored activities (should not count for day1)

#### **G. Async/Actor Isolation - No Concurrency Tests**
- **Location:** All test files
- **Risk:** `WordStateStore`, `StatsStore`, `ReviewLogger` are actors, but NO tests for:
  - Two concurrent `recordScoredAnswer()` calls on same word
  - Race condition: `getWordState()` then `recordScoredAnswer()` by different tasks
  - Actor re-entrancy guarantees
  - Database transaction consistency under concurrent writes

#### **H. NULL/Invalid Data Handling**
- **Missing tests for:**
  - `getWordState()` called on non-existent wordId (should return nil gracefully)
  - `recordScoredAnswer()` on a wordId that doesn't exist in words table (FK constraint)
  - `computeRecentAccuracy()` when no review_log rows exist
  - Null values in `dueAt`, `lastReviewedAt` fields

#### **I. Date/Time Logic Not Tested**
- **Location:** WordStateStore.swift:199-208
- **Missing tests:**
  - `due_at = nil` for box 0 (unintroduced) and box 5 (mastered) - **NO ASSERTIONS**
  - Day boundaries in `yesterday()`/`twoDaysAgo()` (StatsStoreTests.swift:83-88) don't account for timezone issues
  - ISO8601DateFormatter edge cases (leap seconds, daylight saving transitions)

#### **J. Box Distribution Query - Empty Case**
- **Location:** WordStateStoreTests.swift:270-280
- **Gap:** Only tests with words present; no test for:
  - Empty distribution (no words introduced)
  - Box 0 distribution (introduced but not scored)

---

### 3. BEST CANDIDATE REGRESSION TESTS TO ADD

If any of the following bugs are confirmed:

#### **Test Suite A: computeRecentAccuracy Isolation**
```swift
func testComputeRecentAccuracyWith5CorrectAnswers() 
func testComputeRecentAccuracyMixed3of5Correct()
func testComputeRecentAccuracyEmptyReviewLog()
func testComputeRecentAccuracyWithIncludingCurrentParameter()
func testComputeRecentAccuracyLimitsToLast5Entries()
```
**File location:** WordStateStoreTests.swift (new section after line 167)

#### **Test Suite B: Memory Status Boundary Conditions**
```swift
func testFragileAt0p6Accuracy() // Exactly 60% (fragile boundary)
func testEasyAt0p85Accuracy()   // Exactly 85% (easy boundary)
func testNormalAt0p65Accuracy() // Between fragile & easy
func testStubbornOverridesHighAccuracy() // Stubborn takes precedence
```
**File location:** WordStateStoreTests.swift (lines 120-167 expansion)

#### **Test Suite C: Streak Milestones 7/14/30**
```swift
func testStreakMilestoneAt7Days()
func testStreakMilestoneAt14Days()
func testStreakMilestoneAt30Days()
func testStreakCascadingMilestones() // Reach day 14, claim all bonuses
```
**File location:** StatsStoreTests.swift (after line 74)

#### **Test Suite D: Stats Promotion/Demotion Tracking**
```swift
func testRecordWordPromotedIncrementsCounter()
func testRecordWordDemotedIncrementsCounter()
func testNewCountVsReviewCount()
```
**File location:** StatsStoreTests.swift (new section after line 50)

#### **Test Suite E: Supersession Isolation**
```swift
func testSupersedeOnlyAffectsMatchingSession()
func testSupersedeDoesNotAffectOtherWords()
func testSupersedeDoesNotAffectOtherDays()
func testSupersedeDoesNotAffectOtherSessionTypes()
```
**File location:** ReviewLoggerTests.swift (after line 48)

#### **Test Suite F: Day1Promotion Edge Cases**
```swift
func testDay1PromotionWithExactly2of3Correct()
func testDay1PromotionWithAllThreeCorrect()
func testDay1PromotionSkipsAlreadyDecidedWords()
func testDay1PromotionWith4EntriesRequires3of4()
func testDay1PromotionIgnoresNonScoredActivities()
func testDay1PromotionWithNoReviewLogEntries()
```
**File location:** WordStateStoreTests.swift (lines 209-266 expansion)

#### **Test Suite G: Concurrency Regression Tests**
```swift
func testConcurrentRecordScoredAnswerOnSameWord()
func testConcurrentGetAndUpdate()
func testActorReentrancy()
```
**File location:** WordStateStoreTests.swift (new section before line 294)

#### **Test Suite H: Null/Missing Data**
```swift
func testGetWordStateNonExistentWord()
func testRecordScoredAnswerOnUntrackedWord()
func testComputeRecentAccuracyWithNoLogs()
func testDueAtNilForBox0()
func testDueAtNilForBox5()
```
**File location:** WordStateStoreTests.swift (new section after line 293)

---

### SUMMARY TABLE

| Category | Covered | Gap | Severity |
|----------|---------|-----|----------|
| Box progression | 4/6 tests | Edge cases at box boundaries | Medium |
| Memory status | 4 statuses | Accuracy boundary values (0.6, 0.85) | **HIGH** |
| Day1Promotion | 3 paths | Extra entries (4+), already-decided words | **HIGH** |
| Streak bonuses | Day 3 only | Days 7, 14, 30 | **CRITICAL** |
| Stats tracking | XP, bonus | word_promoted, word_demoted, counts | **HIGH** |
| Review logging | Basic + supersede | Isolation guarantees | **MEDIUM** |
| Concurrency | None | Actor race conditions | **CRITICAL** |
| Date/time | None | Timezone, NULL dates | **MEDIUM** |
| Error handling | None | Invalid data, FK violations | **MEDIUM** |
````

</details>


---

<sub>⏱️ 4m 41s</sub>

### ✅ `read_agent`

**Explore agent (Audit data layer)**

<details>
<summary>Arguments</summary>

```json
{
  "agent_id": "data-layer-audit",
  "wait": true,
  "timeout": 10
}
```

</details>

<details>
<summary>225 lines</summary>

````
Agent completed. agent_id: data-layer-audit, agent_type: explore, status: completed, description: Audit data layer, elapsed: 167s, total_turns: 0, model: claude-haiku-4.5, duration: 114s

Good! The SQL injection risk is properly mitigated via parameterized placeholders. Now let me compile my complete findings:

## SUMMARY OF FINDINGS

Based on deep code review of the SAT Vocab iOS app's data layer against docs/data-schema.md Section 5 lifecycle expectations:

---

### 🔴 **CRITICAL FINDINGS**

**1. Missing Day 0 Initialization on First Launch**
- **Severity:** CRITICAL
- **File:** `/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift:16-57`
- **Issue:** The `initializeIfNeeded()` function does NOT create the initial `day_state` row for study_day=0, as required by docs/data-schema.md Section 5.1 Step 6. The schema is created, content is imported, users/streak/zone are initialized, but **day_state is completely missing**. This breaks the "Opening Practice Tab" lifecycle (Section 5.2) which expects to query `day_state` to find the current study day.
- **Impact:** First launch will crash when trying to determine the current study day. Any code reading `day_state` will get zero results on first launch.
- **Fix:** Add this after line 49 in DataManager:
  ```swift
  // Create initial Day 0 state (doc Section 5.1 Step 6)
  let dayStateSQL = "INSERT OR IGNORE INTO day_state(user_id, study_day, zone_index) VALUES (?, 0, 0)"
  let s3 = try db.prepare(dayStateSQL)
  defer { s3?.finalize() }
  try SQLiteDB.bind(s3, 1, userId)
  if sqlite3_step(s3) != SQLITE_DONE {
      throw SQLiteError.stepFailed(message: db.errorMessage())
  }
  ```
- **Regression Test:** Create a new app instance, call `initializeIfNeeded()`, query `SELECT COUNT(*) FROM day_state WHERE study_day=0`, verify result is 1. Also test that "Opening Practice Tab" logic can successfully find the current study day.

---

**2. Streak Store NOT Initialized on First Launch**
- **Severity:** CRITICAL  
- **File:** `/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift:34-40`
- **Issue:** While streak_store IS initialized via `INSERT OR IGNORE INTO streak_store(user_id) VALUES (?)` on line 34, the schema defines UNIQUE(user_id) but does NOT provide default values for all required fields like `current_streak`, `best_streak`, etc. SQLite will use NULL for non-specified columns. Later, `StatsStore.updateStreak()` (line 219-229) calls UPDATE without a preceding INSERT OR IGNORE, so if getStreak() previously returned a default StreakInfo (line 168-173), the UPDATE will silently fail with 0 rows updated, leaving the streak unmodified. However, the more immediate issue is that `getStreak()` at line 154 checks `SQLITE_ROW` — if the row exists but all fields are NULL, the code will silently treat them as 0/false, masking the real issue.
- **Impact:** Streak data may be corrupted or lost due to incomplete initialization. XP and milestone tracking will start from wrong values.
- **Fix:** Change line 34 to explicitly set all defaults:
  ```swift
  let streakSQL = """
  INSERT OR IGNORE INTO streak_store(user_id, current_streak, best_streak, total_xp, total_study_days)
  VALUES (?, 0, 0, 0, 0)
  """
  ```
- **Regression Test:** On first launch, call `StatsStore.shared.getStreak(userId:)`, verify all fields are properly initialized (not NULL). Call `updateStreak()` and verify UPDATE affects exactly 1 row.

---

**3. XP Double-Counting Risk on Session Interruption**
- **Severity:** HIGH
- **File:** `/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/StatsStore.swift:61-77` (recordCorrectAnswer) + ReviewLogger.swift:44-59 (supersedeSession)
- **Issue:** The `recordCorrectAnswer()` function updates `daily_stats.correct_count` and `xp_earned` WITHOUT checking the `superseded` flag in `review_log`. According to docs/data-schema.md Section 5.5, when a session is interrupted and resumed, the old `review_log` entries should be marked with `superseded=1`. However, if XP is recorded before superseding, and then the session is retaken, the app will:
  1. Mark old review_log entries as superseded
  2. BUT already added XP to daily_stats
  3. On session restart, add XP again to daily_stats
  
  The `recordCorrectAnswer()` should filter: `WHERE user_id=? AND study_day=? AND outcome='correct' AND superseded=0` to only count non-superseded reviews.
- **Impact:** Users can exploit session interruption to farm XP. Accurate progress tracking is broken.
- **Fix:** Query `review_log` with superseded=0 filter to only count non-superseded correct answers. Or, only call `recordCorrectAnswer()` AFTER confirming the review_log entry is NOT superseded.
  ```swift
  // In StatsStore, only record correct answers that aren't superseded
  func recordCorrectAnswer(userId: String, studyDay: Int, xpPerCorrect: Int = AppConfig.correctAnswerXP) throws {
      // Verify this answer isn't superseded before recording
      let checkSQL = "SELECT COUNT(*) FROM review_log WHERE user_id=? AND study_day=? AND outcome='correct' AND superseded=0"
      // ... only UPDATE daily_stats if count > 0
  }
  ```
- **Regression Test:** 
  1. Start a session, submit a correct answer, verify `daily_stats.correct_count` increments
  2. Call `ReviewLogger.supersedeSession()` on that session
  3. Start a new session for same day and submit same word correct again
  4. Verify `daily_stats.correct_count` incremented exactly once (not twice), and `daily_stats.xp_earned` reflects only one answer

---

**4. INSERT OR REPLACE with lastInsertRowId() Race in session_state**
- **Severity:** HIGH
- **File:** `/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SessionStateStore.swift:148-181`
- **Issue:** The `createSession()` function uses `INSERT OR REPLACE INTO session_state(...)` with a UNIQUE constraint on `(user_id, study_day, session_type)`. When an INSERT replaces an existing row, SQLite's `lastInsertRowId()` returns the OLD row's ID, not a new one. This means:
  1. User starts morning session (row ID=5 created)
  2. App crashes
  3. User resumes app, calls `createSession()` again with same userId/studyDay/sessionType
  4. REPLACE occurs, but `lastInsertRowId()` still returns 5
  5. Function returns a SessionState with `id=5` (which may be stale)
  6. Later, resuming the paused session may read old state from a different row
- **Impact:** Session state corruption on resume/restart flows. Users may lose progress or see inconsistent state.
- **Fix:** After INSERT OR REPLACE, query back the actual row ID via:
  ```swift
  func createSession(userId: String, sessionType: SessionType, studyDay: Int) throws -> SessionState {
      // ... INSERT OR REPLACE ...
      // Query to get the actual row
      let selectSQL = """
      SELECT id FROM session_state
      WHERE user_id = ? AND session_type = ? AND study_day = ?
      LIMIT 1;
      """
      let selectStmt = try db.prepare(selectSQL)
      defer { selectStmt?.finalize() }
      try SQLiteDB.bind(selectStmt, 1, userId)
      try SQLiteDB.bind(selectStmt, 2, sessionType.rawValue)
      try SQLiteDB.bind(selectStmt, 3, studyDay)
      guard sqlite3_step(selectStmt) == SQLITE_ROW else {
          throw SQLiteError.stepFailed(message: "Failed to fetch session_state after insert")
      }
      let rowId = SQLiteDB.columnInt(selectStmt, 0)
      // ... return SessionState(id: rowId, ...)
  }
  ```
- **Regression Test:**
  1. Create a session (id=X)
  2. Pause it
  3. Create another session for same day/type (should REPLACE)
  4. Verify the returned SessionState has the correct ID from the replaced row
  5. Resume paused session and verify state is correctly loaded

---

**5. Actor Isolation Violation: Multiple Actors Access Non-Actor SQLiteDB**
- **Severity:** HIGH
- **File:** 
  - `/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift:7` (nonisolated let db)
  - `/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SessionStateStore.swift:7` (accesses DataManager.shared.db)
  - `/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/StatsStore.swift:18` (accesses DataManager.shared.db)
  - `/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/ZoneStore.swift:7` (accesses DataManager.shared.db)
  - `/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/WordStateStore.swift:22` (accepts db as parameter)
- **Issue:** `DataManager` is an actor but exposes its `db` property as `nonisolated`, allowing other actors (`StatsStore`, `ZoneStore`, `SessionStateStore`) and non-actors to access the same SQLiteDB instance without synchronization. SQLiteDB is a `final class` (not an actor), so concurrent access from multiple threads will cause data races. The Swift compiler will NOT catch this at compile time due to the `nonisolated` escape hatch. This violates Swift concurrency safety guarantees.
- **Impact:** Subtle data corruption, crashes, or undefined behavior under concurrent access. Particularly dangerous because it may only manifest under high concurrency (e.g., multiple sessions updating simultaneously).
- **Fix:** Make SQLiteDB an actor, OR ensure all database access goes through a single actor with synchronization, OR use a serial DispatchQueue to protect all db access:
  ```swift
  actor SQLiteDB {
      // ... move all sqlite3_* calls into this actor
  }
  // OR
  final class SQLiteDB {
      private let serialQueue = DispatchQueue(label: "com.satspell.db", attributes: [])
      // Wrap all methods with serialQueue.sync { }
  }
  ```
- **Regression Test:** Run concurrent stress test with multiple async tasks calling different StatsStore, ZoneStore, and SessionStateStore methods simultaneously while monitoring for crashes or data inconsistencies.

---

### 🟡 **HIGH SEVERITY FINDINGS**

**6. Streak Milestone XP Calculations Not Protected from Multi-Session Calls**
- **Severity:** HIGH
- **File:** `/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/StatsStore.swift:176-248`
- **Issue:** `updateStreak()` reads current streak data, calculates milestones (lines 211-214), then updates. There is NO transaction isolation. If two sessions call `updateStreak()` concurrently for the same user:
  1. Session A reads streak (e.g., currentStreak=2)
  2. Session B reads streak (e.g., currentStreak=2)
  3. Both calculate "should I award 3-streak bonus?" → YES
  4. Both write back (currentStreak=3, milestone XP added)
  5. User gets 2x milestone XP
- **Impact:** Milestone XP bonuses can be double-counted in concurrent scenarios.
- **Fix:** Wrap the entire function in a transaction:
  ```swift
  func updateStreak(userId: String, xpToday: Int) throws -> (newStreak: Int, milestoneXP: Int) {
      let current = try getStreak(userId: userId)
      // ... calculations ...
      try db.exec("BEGIN IMMEDIATE")  // IMMEDIATE prevents concurrent updates
      defer { try? db.exec("ROLLBACK") }
      // ... UPDATE streak_store ...
      try db.exec("COMMIT")
      return (newStreak: newStreak, milestoneXP: milestoneXP)
  }
  ```
- **Regression Test:** Call `updateStreak()` concurrently from multiple tasks for the same user on the same day when streak >= 3, verify milestone XP is awarded exactly once.

---

**7. Missing Supersede Logic Check in `computeRecentAccuracy()`**
- **Severity:** MEDIUM
- **File:** `/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/WordStateStore.swift:368-399`
- **Issue:** The `computeRecentAccuracy()` function queries `review_log` but does NOT filter by `superseded=0`. According to docs/data-schema.md Section 5.7, the function should only consider non-superseded reviews. If a session is interrupted and superseded, the old reviews should not affect accuracy calculations for the new session.
- **Impact:** Memory status classification (`classifyMemoryStatus()`) will use incorrect recent_accuracy values, potentially marking words as "stubborn" or "fragile" when they shouldn't be.
- **Fix:** Add `AND superseded=0` to the WHERE clause in `computeRecentAccuracy()`:
  ```swift
  private func computeRecentAccuracy(userId: String, wordId: Int, includingCurrent correct: Bool? = nil) throws -> Double {
      let sql = """
      SELECT outcome FROM review_log
      WHERE user_id = ? AND word_id = ?
        AND outcome IN ('correct', 'incorrect')
        AND superseded = 0
      ORDER BY reviewed_at DESC
      LIMIT 5;
      """
      // ...
  }
  ```
- **Regression Test:** 
  1. Submit a word as correct 5 times (recent_accuracy=1.0)
  2. Mark those reviews as superseded
  3. Submit same word as incorrect
  4. Verify `computeRecentAccuracy()` returns 0.0 (not 0.2)

---

### 🟠 **MEDIUM SEVERITY FINDINGS**

**8. Day 1 Promotion Uses Non-Superseded Filter But `recordScoredAnswer()` May Not**
- **Severity:** MEDIUM
- **File:** `/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/WordStateStore.swift:253-354` vs `/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/StatsStore.swift:61-77`
- **Issue:** `runDay1Promotion()` correctly filters by `superseded=0` in the countSQL (line 282), but `recordScoredAnswer()` does not validate that the review_log entry it's responding to is non-superseded. If the code calls `recordScoredAnswer()` in response to a review_log entry that later gets superseded, the word_state changes will be inconsistent with the "true" learning state.
- **Impact:** Word box levels may advance even though the answer was superseded. Users may see progress that doesn't reflect actual learning.
- **Fix:** Either:
  1. Pass a `reviewLogId` to `recordScoredAnswer()` and verify it's not superseded before processing
  2. Or, ensure `recordScoredAnswer()` is only called from flows that guarantee non-superseded status
- **Regression Test:** Call `recordScoredAnswer()` for a word, then mark that review_log entry as superseded, verify the word_state changes are later undone or flagged as invalid.

---

**9. lastInsertRowId() in ContentImporter Also Vulnerable to Race**
- **Severity:** MEDIUM
- **File:** `/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/ContentImporter.swift:103, 115`
- **Issue:** While content import happens inside a transaction on first launch (so concurrency is not an issue), the use of `lastInsertRowId()` assumes sequential inserts. If the import process is ever refactored to use batch inserts or parallel processing, this could break. Additionally, the code does not validate that the returned ID is actually the word/list that was just inserted.
- **Impact:** Unlikely in current single-threaded first-launch scenario, but represents a code smell and technical debt.
- **Fix:** Query back the inserted row to verify:
  ```swift
  let listId = Int(db.lastInsertRowId())
  // Optionally validate:
  let checkSQL = "SELECT id FROM lists WHERE id=? AND name=? LIMIT 1"
  // ...
  ```
- **Regression Test:** After bundled content import, verify that all inserted words/contexts/collocations are correctly linked via their IDs.

---

### 🔵 **LOW SEVERITY FINDINGS**

**10. `getOrCreateDailyStats()` and `getOrCreateDayState()` Don't Validate Success**
- **Severity:** LOW
- **File:** 
  - `/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/StatsStore.swift:27-59`
  - `/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SessionStateStore.swift:57-76`
- **Issue:** Both functions do `INSERT OR IGNORE` followed by `SELECT`. If the INSERT succeeds but the subsequent SELECT somehow fails (e.g., due to a concurrent DELETE, unlikely but possible), the function throws "Failed to fetch ... after insert" but the row WAS actually inserted. This is a rare edge case but represents incomplete error handling.
- **Impact:** Confusing error messages in rare concurrent scenarios. Not a correctness issue in normal operation.
- **Fix:** More robust would be to use `INSERT OR IGNORE ... RETURNING id` (if SQLite version supports it) or retry the SELECT.
- **Regression Test:** Inject a concurrent DELETE between INSERT OR IGNORE and SELECT, verify error handling is graceful.

---

### 🟢 **SAFE PATTERNS FOUND**

✅ ContentImporter properly uses transactions for atomicity  
✅ SessionStateStore properly uses pauseSession/resumeSession for state management  
✅ WordStateStore uses parameterized queries (no SQL injection risk)  
✅ ReviewLogger properly marks reviews as superseded  
✅ Zone unlock logic properly uses INSERT OR IGNORE + ON CONFLICT  

---

## CANDIDATE REGRESSION TESTS

1. **First Launch Integration Test:** Fresh app → initializeIfNeeded() → verify all 7 lifecycle tables are initialized with correct Day 0 state
2. **Session Interruption Test:** Start session → pause → resume → verify session_state ID is consistent and no state is lost
3. **XP Accuracy Test:** Record answers, supersede session, retake → verify XP counted exactly once
4. **Concurrent Actor Access Stress Test:** Hammer StatsStore/ZoneStore/SessionStateStore from multiple async tasks → watch for crashes/data corruption
5. **Streak Milestone Edge Case:** Update streak at boundaries (3, 7, 14, 30) concurrently → verify bonuses awarded once
6. **Recent Accuracy Calculation:** Add/supersede reviews and verify accuracy recalculation excludes superseded entries
````

</details>


---

<sub>⏱️ 4m 41s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/PracticeTabViewModel.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/PracticeTabViewModel.swift

<details>
<summary>49 lines</summary>

```
1. import Foundation
2. import Combine
3. 
4. @MainActor
5. final class PracticeTabViewModel: ObservableObject {
6.     @Published var state: PracticeState = .morningAvailable
7.     @Published var studyDay: Int = 0
8.     @Published var zoneIndex: Int = 0
9.     @Published var streak: StreakInfo = StreakInfo(
10.         currentStreak: 0, bestStreak: 0, lastStudyDate: nil,
11.         totalXP: 0, totalStudyDays: 0,
12.         streak3Claimed: false, streak7Claimed: false,
13.         streak14Claimed: false, streak30Claimed: false
14.     )
15.     @Published var reviewsDueCount: Int = 0
16.     @Published var isLoading: Bool = true
17. 
18.     let userId = LocalIdentity.userId()
19. 
20.     func load() async {
21.         isLoading = true
22.         do {
23.             let dm = DataManager.shared
24.             try await dm.initializeIfNeeded()
25. 
26.             let sessionStore = SessionStateStore.shared
27.             let statsStore = StatsStore.shared
28.             let wsStore = WordStateStore(db: dm.db)
29. 
30.             let dayState = try await sessionStore.getCurrentDayState(userId: userId)
31.             let activeSession = try await sessionStore.getActiveSession(userId: userId)
32.             streak = try await statsStore.getStreak(userId: userId)
33.             reviewsDueCount = try await wsStore.countOverdue(userId: userId)
34. 
35.             studyDay = dayState?.studyDay ?? 0
36.             zoneIndex = dayState?.zoneIndex ?? 0
37. 
38.             state = PracticeStateResolver.resolve(
39.                 dayState: dayState,
40.                 activeSession: activeSession
41.             )
42.         } catch {
43.             // Default to morning available on error
44.             state = .morningAvailable
45.         }
46.         isLoading = false
47.     }
48. }
49.
```

</details>


---

<sub>⏱️ 4m 41s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/AppBootstrap.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/AppBootstrap.swift

<details>
<summary>19 lines</summary>

```
1. import Foundation
2. 
3. @MainActor
4. final class AppBootstrap: ObservableObject {
5.     @Published var isReady: Bool = false
6.     @Published var errorMessage: String? = nil
7. 
8.     func start() {
9.         Task {
10.             do {
11.                 try await DataManager.shared.initializeIfNeeded()
12.                 isReady = true
13.             } catch {
14.                 errorMessage = String(describing: error)
15.             }
16.         }
17.     }
18. }
19.
```

</details>


---

<sub>⏱️ 4m 41s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/StatsStore.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/StatsStore.swift (lines 1-80)

<details>
<summary>80 lines</summary>

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
17.     private let _db: SQLiteDB?
18.     private var db: SQLiteDB { _db ?? DataManager.shared.db }
19. 
20.     private init() { _db = nil }
21. 
22.     /// Testable initializer accepting an explicit database
23.     init(db: SQLiteDB) { _db = db }
24. 
25.     // MARK: - Daily Stats
26. 
27.     func getOrCreateDailyStats(userId: String, studyDay: Int) throws -> DailyStats {
28.         let calendarDate = DateFormatter.yyyyMMdd.string(from: Date())
29. 
30.         let insertSQL = """
31.         INSERT OR IGNORE INTO daily_stats(user_id, study_day, calendar_date)
32.         VALUES (?, ?, ?);
33.         """
34.         let s1 = try db.prepare(insertSQL)
35.         defer { s1?.finalize() }
36.         try SQLiteDB.bind(s1, 1, userId)
37.         try SQLiteDB.bind(s1, 2, studyDay)
38.         try SQLiteDB.bind(s1, 3, calendarDate)
39.         if sqlite3_step(s1) != SQLITE_DONE {
40.             throw SQLiteError.stepFailed(message: db.errorMessage())
41.         }
42. 
43.         let selectSQL = """
44.         SELECT id, user_id, study_day, calendar_date, new_count, review_count,
45.                correct_count, total_count, xp_earned, session_bonus,
46.                study_minutes, words_promoted, words_demoted
47.         FROM daily_stats
48.         WHERE user_id = ? AND study_day = ?
49.         LIMIT 1;
50.         """
51.         let s2 = try db.prepare(selectSQL)
52.         defer { s2?.finalize() }
53.         try SQLiteDB.bind(s2, 1, userId)
54.         try SQLiteDB.bind(s2, 2, studyDay)
55.         if sqlite3_step(s2) == SQLITE_ROW {
56.             return parseDailyStats(s2)
57.         }
58.         throw SQLiteError.stepFailed(message: "Failed to fetch daily_stats after insert")
59.     }
60. 
61.     func recordCorrectAnswer(userId: String, studyDay: Int, xpPerCorrect: Int = AppConfig.correctAnswerXP) throws {
62.         let sql = """
63.         UPDATE daily_stats
64.         SET correct_count = correct_count + 1,
65.             total_count = total_count + 1,
66.             xp_earned = xp_earned + ?
67.         WHERE user_id = ? AND study_day = ?;
68.         """
69.         let stmt = try db.prepare(sql)
70.         defer { stmt?.finalize() }
71.         try SQLiteDB.bind(stmt, 1, xpPerCorrect)
72.         try SQLiteDB.bind(stmt, 2, userId)
73.         try SQLiteDB.bind(stmt, 3, studyDay)
74.         if sqlite3_step(stmt) != SQLITE_DONE {
75.             throw SQLiteError.stepFailed(message: db.errorMessage())
76.         }
77.     }
78. 
79.     func recordWrongAnswer(userId: String, studyDay: Int) throws {
80.         let sql = """
```

</details>


---

<sub>⏱️ 4m 41s</sub>

### ℹ️ Notification

Background agent "Audit data layer" (explore) completed

<details>
<summary>Detail</summary>

You are performing a deep code review of the SAT Vocab iOS app implementation. Investigate ONLY the data/model layer and compare behavior against docs/data-schema.md Section 5 lifecycle expectations.

Read these files completely:
- /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SchemaV2.swift
- /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/ContentImporter.swift
- /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift
- /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/WordStateStore.swift
- /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SessionStateStore.swift
- /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/StatsStore.swift
- /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/ZoneStore.swift
- /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/ReviewLogger.swift
- /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SQLite.swift
- /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Models/Enums.swift
- /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Models/Models.swift
- /Users/jiong/myprojects/satspell/docs/data-schema.md

Focus on:
1. CRASH RISKS
2. DATA CORRUPTION / progress loss / XP double counting
3. ACTOR ISOLATION / data races / sendability
4. FIRST LAUNCH path: initializeIfNeeded -> import -> first session load
5. EMPTY STATES relevant to data APIs
6. SQL INJECTION
7. MISSING FUNCTIONALITY vs docs/data-schema.md Section 5 lifecycle

Return only concrete findings. For each finding include: severity (CRITICAL/HIGH/MEDIUM/LOW), exact file:line, concise explanation, and suggested fix. Also mention any candidate regression tests that would best prove the bug. Do not modify files.

</details>

---

<sub>⏱️ 5m 32s</sub>

### 💬 Copilot

I found one more important thread: the listed `ImageGameView`/`QuickRecallView` components are only the leaf cards—the actual stuck/empty-state behavior lives in the step wrappers that `SessionFlowView` pushes. I’m reading those wrappers now so I don’t overstate or miss the real failure mode.

---

<sub>⏱️ 5m 32s</sub>

### ✅ `rg`

**/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views**

<details>
<summary>Arguments</summary>

```json
{
  "pattern": "struct\\s+(ImageGameStepView|QuickRecallStepView|SATQuestionStepView)",
  "path": "/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views",
  "glob": "**/*.swift",
  "output_mode": "content",
  "-n": true,
  "head_limit": 50
}
```

</details>

```
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/SATQuestionStepView.swift:3:struct SATQuestionStepView: View {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/ImageGameStepView.swift:3:struct ImageGameStepView: View {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/QuickRecallStepView.swift:3:struct QuickRecallStepView: View {
```


---

<sub>⏱️ 5m 32s</sub>

### ✅ `glob`

**/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views**

"**/*StepView.swift" in /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views

```
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/QuickRecallStepView.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/ImageGameStepView.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/SATQuestionStepView.swift
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Flashcard/FlashcardStepView.swift
```


---

<sub>⏱️ 5m 32s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/ImageGameStepView.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/ImageGameStepView.swift

<details>
<summary>100 lines</summary>

```
1. import SwiftUI
2. 
3. struct ImageGameStepView: View {
4.     let words: [VocabCard]
5.     let showAgainPriority: [Int]
6.     let stepNumber: Int
7.     let totalSteps: Int
8.     let onAnswer: (Bool, Int) -> Void
9.     let onComplete: () -> Void
10.     let onPause: (Int, Int, [Int], [Int]) -> Void
11. 
12.     @State private var currentRound: Int = 0
13.     @State private var roundCards: [(card: VocabCard, choices: [VocabCard])] = []
14.     @State private var isLoading = true
15.     @State private var showPause = false
16. 
17.     private var totalRounds: Int {
18.         roundCards.count
19.     }
20. 
21.     var body: some View {
22.         VStack(spacing: 0) {
23.             SessionHeaderView(
24.                 stepNumber: stepNumber,
25.                 totalSteps: totalSteps,
26.                 stepLabel: "Image Practice",
27.                 currentItem: min(currentRound + 1, max(totalRounds, 1)),
28.                 totalItems: max(totalRounds, 1),
29.                 progressColor: Color(hex: "#58CC02"),
30.                 isScored: true,
31.                 onClose: { showPause = true }
32.             )
33. 
34.             if isLoading {
35.                 Spacer()
36.                 ProgressView("Loading...")
37.                 Spacer()
38.             } else if currentRound < totalRounds {
39.                 let round = roundCards[currentRound]
40.                 ImageGameView(
41.                     card: round.card,
42.                     choices: round.choices,
43.                     roundIndex: currentRound,
44.                     totalRounds: totalRounds,
45.                     onAnswer: { correct in
46.                         onAnswer(correct, round.card.id)
47.                         if currentRound + 1 >= totalRounds {
48.                             onComplete()
49.                         } else {
50.                             currentRound += 1
51.                         }
52.                     }
53.                 )
54.                 .id(currentRound)
55.             }
56.         }
57.         .task { await loadRounds() }
58.         .sheet(isPresented: $showPause) {
59.             PauseSheet(
60.                 onKeepGoing: { showPause = false },
61.                 onPauseExit: {
62.                     showPause = false
63.                     onPause(stepNumber - 1, currentRound, [], [])
64.                 }
65.             )
66.         }
67.     }
68. 
69.     private func loadRounds() async {
70.         // Order: showAgain priority first, then remaining words
71.         var ordered: [VocabCard] = []
72.         let priorityIds = Set(showAgainPriority)
73.         let priorityCards = words.filter { priorityIds.contains($0.id) }
74.         let otherCards = words.filter { !priorityIds.contains($0.id) }
75.         ordered = priorityCards + otherCards
76. 
77.         // Generate rounds with distractors
78.         var rounds: [(card: VocabCard, choices: [VocabCard])] = []
79.         for card in ordered {
80.             do {
81.                 let dm = DataManager.shared
82.                 let list = try await dm.getDefaultList()
83.                 let distractors = try await dm.fetchDistractors(listId: list.id, pos: card.pos, excludeWordId: card.id, limit: 3)
84.                 var choices = distractors + [card]
85.                 choices.shuffle()
86.                 rounds.append((card: card, choices: choices))
87.             } catch {
88.                 // Fallback: use other words as distractors
89.                 var choices = Array(words.filter { $0.id != card.id }.prefix(3))
90.                 choices.append(card)
91.                 choices.shuffle()
92.                 rounds.append((card: card, choices: choices))
93.             }
94.         }
95. 
96.         roundCards = rounds
97.         isLoading = false
98.     }
99. }
100.
```

</details>


---

<sub>⏱️ 5m 32s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/QuickRecallStepView.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/QuickRecallStepView.swift

<details>
<summary>96 lines</summary>

```
1. import SwiftUI
2. 
3. struct QuickRecallStepView: View {
4.     let words: [VocabCard]
5.     let stepNumber: Int
6.     let totalSteps: Int
7.     let onAnswer: (Bool, Int) -> Void
8.     let onComplete: () -> Void
9.     let onPause: (Int, Int, [Int], [Int]) -> Void
10. 
11.     @State private var currentRound: Int = 0
12.     @State private var roundData: [(card: VocabCard, choices: [QuickRecallView.DefinitionChoice])] = []
13.     @State private var isLoading = true
14.     @State private var showPause = false
15. 
16.     private var totalRounds: Int {
17.         roundData.count
18.     }
19. 
20.     var body: some View {
21.         VStack(spacing: 0) {
22.             SessionHeaderView(
23.                 stepNumber: stepNumber,
24.                 totalSteps: totalSteps,
25.                 stepLabel: "Quick Recall",
26.                 currentItem: min(currentRound + 1, max(totalRounds, 1)),
27.                 totalItems: max(totalRounds, 1),
28.                 progressColor: Color(hex: "#CE82FF"),
29.                 isScored: true,
30.                 onClose: { showPause = true }
31.             )
32. 
33.             if isLoading {
34.                 Spacer()
35.                 ProgressView("Loading...")
36.                 Spacer()
37.             } else if currentRound < totalRounds {
38.                 let round = roundData[currentRound]
39.                 QuickRecallView(
40.                     card: round.card,
41.                     definitionChoices: round.choices,
42.                     onAnswer: { correct in
43.                         onAnswer(correct, round.card.id)
44.                         if currentRound + 1 >= totalRounds {
45.                             onComplete()
46.                         } else {
47.                             currentRound += 1
48.                         }
49.                     }
50.                 )
51.                 .id(currentRound)
52.             }
53.         }
54.         .task { await loadRounds() }
55.         .sheet(isPresented: $showPause) {
56.             PauseSheet(
57.                 onKeepGoing: { showPause = false },
58.                 onPauseExit: {
59.                     showPause = false
60.                     onPause(stepNumber - 1, currentRound, [], [])
61.                 }
62.             )
63.         }
64.     }
65. 
66.     private func loadRounds() async {
67.         var rounds: [(card: VocabCard, choices: [QuickRecallView.DefinitionChoice])] = []
68. 
69.         for card in words {
70.             do {
71.                 let dm = DataManager.shared
72.                 let list = try await dm.getDefaultList()
73.                 let distractors = try await dm.fetchDistractors(listId: list.id, pos: card.pos, excludeWordId: card.id, limit: 3)
74. 
75.                 var choices: [QuickRecallView.DefinitionChoice] = distractors.map { d in
76.                     QuickRecallView.DefinitionChoice(id: d.id, definition: d.definition ?? "Unknown", isCorrect: false)
77.                 }
78.                 choices.append(QuickRecallView.DefinitionChoice(id: card.id, definition: card.definition ?? "Unknown", isCorrect: true))
79.                 choices.shuffle()
80.                 rounds.append((card: card, choices: choices))
81.             } catch {
82.                 // Fallback
83.                 var choices: [QuickRecallView.DefinitionChoice] = words.filter { $0.id != card.id }.prefix(3).map { d in
84.                     QuickRecallView.DefinitionChoice(id: d.id, definition: d.definition ?? "Unknown", isCorrect: false)
85.                 }
86.                 choices.append(QuickRecallView.DefinitionChoice(id: card.id, definition: card.definition ?? "Unknown", isCorrect: true))
87.                 choices.shuffle()
88.                 rounds.append((card: card, choices: choices))
89.             }
90.         }
91. 
92.         roundData = rounds
93.         isLoading = false
94.     }
95. }
96.
```

</details>


---

<sub>⏱️ 5m 32s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/SATQuestionStepView.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Game/SATQuestionStepView.swift

<details>
<summary>105 lines</summary>

```
1. import SwiftUI
2. 
3. struct SATQuestionStepView: View {
4.     let words: [VocabCard]
5.     let stepNumber: Int
6.     let totalSteps: Int
7.     let onAnswer: (Bool, Int) -> Void
8.     let onComplete: () -> Void
9.     let onPause: (Int, Int, [Int], [Int]) -> Void
10. 
11.     @State private var currentRound: Int = 0
12.     @State private var questions: [(wordId: Int, question: SatQuestion)] = []
13.     @State private var isLoading = true
14.     @State private var showPause = false
15. 
16.     private var totalRounds: Int {
17.         questions.count
18.     }
19. 
20.     var body: some View {
21.         VStack(spacing: 0) {
22.             SessionHeaderView(
23.                 stepNumber: stepNumber,
24.                 totalSteps: totalSteps,
25.                 stepLabel: "SAT Questions",
26.                 currentItem: min(currentRound + 1, max(totalRounds, 1)),
27.                 totalItems: max(totalRounds, 1),
28.                 progressColor: Color(hex: "#FF9600"),
29.                 isScored: true,
30.                 onClose: { showPause = true }
31.             )
32. 
33.             if isLoading {
34.                 Spacer()
35.                 ProgressView("Loading SAT questions...")
36.                 Spacer()
37.             } else if currentRound < totalRounds {
38.                 let round = questions[currentRound]
39.                 SATQuestionView(
40.                     question: round.question,
41.                     onAnswer: { correct in
42.                         onAnswer(correct, round.wordId)
43.                         if currentRound + 1 >= totalRounds {
44.                             onComplete()
45.                         } else {
46.                             currentRound += 1
47.                         }
48.                     }
49.                 )
50.                 .id(currentRound)
51.             } else {
52.                 // No questions available
53.                 VStack(spacing: 16) {
54.                     Spacer()
55.                     Text("No SAT questions available")
56.                         .font(.system(size: 16, weight: .bold, design: .rounded))
57.                         .foregroundColor(Color(hex: "#AFAFAF"))
58.                     Button3D("Continue", action: onComplete)
59.                         .padding(.horizontal, 40)
60.                     Spacer()
61.                 }
62.             }
63.         }
64.         .task { await loadQuestions() }
65.         .sheet(isPresented: $showPause) {
66.             PauseSheet(
67.                 onKeepGoing: { showPause = false },
68.                 onPauseExit: {
69.                     showPause = false
70.                     onPause(stepNumber - 1, currentRound, [], [])
71.                 }
72.             )
73.         }
74.     }
75. 
76.     private func loadQuestions() async {
77.         var loaded: [(wordId: Int, question: SatQuestion)] = []
78.         let dm = DataManager.shared
79. 
80.         // Try to get one SAT question per word
81.         for card in words.shuffled() {
82.             do {
83.                 let qs = try await dm.fetchSatQuestionsForWord(
84.                     wordId: card.id,
85.                     limit: 1,
86.                     verifiedOnly: AppConfig.satQuestionsVerifiedOnly
87.                 )
88.                 if let q = qs.first {
89.                     loaded.append((wordId: card.id, question: q))
90.                 }
91.             } catch {
92.                 // Skip this word
93.             }
94. 
95.             // Stop once we have enough
96.             if loaded.count >= (stepNumber <= 3 ? AppConfig.morningSATQuestions : AppConfig.eveningSATQuestions) {
97.                 break
98.             }
99.         }
100. 
101.         questions = loaded
102.         isLoading = false
103.     }
104. }
105.
```

</details>


---

<sub>⏱️ 5m 40s</sub>

### ✅ `skill`

**test-driven-development**

<details>
<summary>Arguments</summary>

```json
{
  "skill": "test-driven-development"
}
```

</details>

```
Skill "test-driven-development" loaded successfully. Follow the instructions in the skill context.
```


---

<sub>⏱️ 5m 48s</sub>

### 💬 Copilot

I’ve finished the root-cause pass, and the cleanest bugs to prove are both in `WordStateStore`: Day 1 answers incorrectly move box-0 words, and Day 1 promotion counts prior study days. I’m writing those as regression tests first and running them in isolation so we can verify they fail for the right reason before I finalize the review.

---

<sub>⏱️ 5m 48s</sub>

### ✅ `rg`

**/Users/jiong/myprojects/satspell/ios/SATVocabApp/Tests/SATVocabAppTests**

<details>
<summary>Arguments</summary>

```json
{
  "pattern": "struct TestDatabase|enum TestDatabase|final class TestDatabase|create\\(withWords|createTestUser",
  "path": "/Users/jiong/myprojects/satspell/ios/SATVocabApp/Tests/SATVocabAppTests",
  "glob": "**/*.swift",
  "output_mode": "content",
  "-n": true,
  "head_limit": 200
}
```

</details>

<details>
<summary>9 lines</summary>

```
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Tests/SATVocabAppTests/Helpers/TestDatabase.swift:6:enum TestDatabase {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Tests/SATVocabAppTests/Helpers/TestDatabase.swift:9:    static func create(withWords: Bool = false) throws -> SQLiteDB {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Tests/SATVocabAppTests/Helpers/TestDatabase.swift:41:    static func createTestUser(db: SQLiteDB, name: String = "test_user") throws -> String {
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Tests/SATVocabAppTests/Data/StatsStoreTests.swift:11:        db = try TestDatabase.create(withWords: true)
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Tests/SATVocabAppTests/Data/StatsStoreTests.swift:12:        userId = try TestDatabase.createTestUser(db: db)
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Tests/SATVocabAppTests/Data/ReviewLoggerTests.swift:11:        db = try TestDatabase.create(withWords: true)
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Tests/SATVocabAppTests/Data/ReviewLoggerTests.swift:12:        userId = try TestDatabase.createTestUser(db: db)
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Tests/SATVocabAppTests/Data/WordStateStoreTests.swift:11:        db = try TestDatabase.create(withWords: true)
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Tests/SATVocabAppTests/Data/WordStateStoreTests.swift:12:        userId = try TestDatabase.createTestUser(db: db)
```

</details>


---

<sub>⏱️ 5m 48s</sub>

### ✅ `sql`

**Track regression tests work**

<details>
<summary>Arguments</summary>

```json
{
  "description": "Track regression tests work",
  "query": "UPDATE todos SET status = 'in_progress' WHERE id = 'deep-review-tests';\nSELECT id, title, status FROM todos WHERE id IN ('deep-review-tests','write-deep-review');"
}
```

</details>

<details>
<summary>9 lines</summary>

```
Executed 2 statement(s):

1. UPDATE
   1 row(s) updated.

2. SELECT
   2 row(s) returned:
   
   | id | title | status |
   | --- | --- | --- |
   | deep-review-tests | Review and run tests | in_progress |
   | write-deep-review | Write implementation review doc | pending |
```

</details>


---

<sub>⏱️ 5m 52s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Tests/SATVocabAppTests/Helpers/TestDatabase.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Tests/SATVocabAppTests/Helpers/TestDatabase.swift

<details>
<summary>50 lines</summary>

```
1. import Foundation
2. @testable import SATVocabApp
3. 
4. /// Creates a fresh in-memory SQLite database with full schema for each test.
5. /// Usage: let db = try TestDatabase.create()
6. enum TestDatabase {
7. 
8.     /// Create in-memory DB with schema + optional test words
9.     static func create(withWords: Bool = false) throws -> SQLiteDB {
10.         let db = SQLiteDB()
11.         try db.open(path: ":memory:")
12.         try SchemaV2.createAll(db: db)
13. 
14.         if withWords {
15.             try insertTestWords(db: db)
16.         }
17.         return db
18.     }
19. 
20.     /// Insert a minimal set of test words (10 words for fast tests)
21.     static func insertTestWords(db: SQLiteDB, count: Int = 10) throws {
22.         try db.exec("INSERT INTO lists (name, description, version) VALUES ('test_list', 'Test', 1);")
23. 
24.         for i in 1...count {
25.             try db.exec("""
26.             INSERT INTO words (lemma, pos, definition, example, image_filename)
27.             VALUES ('word\(i)', 'adj.', 'definition \(i)', 'example sentence \(i)', 'word\(i).jpg');
28.             """)
29.             try db.exec("INSERT INTO word_list (word_id, list_id, rank) VALUES (\(i), 1, \(i));")
30. 
31.             // Add 2 SAT contexts per word
32.             try db.exec("INSERT INTO sat_contexts (word_id, context) VALUES (\(i), 'context A for word\(i)');")
33.             try db.exec("INSERT INTO sat_contexts (word_id, context) VALUES (\(i), 'context B for word\(i)');")
34. 
35.             // Add 1 collocation per word
36.             try db.exec("INSERT INTO collocations (word_id, phrase) VALUES (\(i), 'word\(i) phrase');")
37.         }
38.     }
39. 
40.     /// Create a test user and return userId
41.     static func createTestUser(db: SQLiteDB, name: String = "test_user") throws -> String {
42.         let userId = "test-\(UUID().uuidString.prefix(8))"
43.         try db.exec("INSERT INTO users (id, display_name) VALUES ('\(userId)', '\(name)');")
44.         try db.exec("INSERT INTO streak_store (user_id) VALUES ('\(userId)');")
45.         try db.exec("INSERT INTO zone_state (user_id, zone_index, unlocked) VALUES ('\(userId)', 0, 1);")
46.         try db.exec("INSERT INTO day_state (user_id, study_day, zone_index) VALUES ('\(userId)', 0, 0);")
47.         return userId
48.     }
49. }
50.
```

</details>


---

<sub>⏱️ 5m 52s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Tests/SATVocabAppTests/Data/WordStateStoreTests.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Tests/SATVocabAppTests/Data/WordStateStoreTests.swift (lines 200-320)

<details>
<summary>96 lines</summary>

```
200.         try db.exec("UPDATE word_state SET box_level = 1, due_at = datetime('now','-1 day'), memory_status = 'normal' WHERE word_id = 1")
201.         try db.exec("UPDATE word_state SET box_level = 1, due_at = datetime('now','-1 day'), memory_status = 'stubborn' WHERE word_id = 2")
202. 
203.         let queue = try await store.getReviewQueue(userId: userId, limit: 10)
204.         XCTAssertEqual(queue[0].wordId, 2, "Stubborn word should come first within same box")
205.     }
206. 
207.     // MARK: - Day 1 Promotion
208. 
209.     func testDay1PromotionWithTwoOfThreeCorrectAndCorrectFinal() async throws {
210.         try await store.introduceWord(userId: userId, wordId: 1)
211. 
212.         let logger = ReviewLogger(db: db)
213.         // 3 scored events: correct, wrong, correct (2/3, last correct)
214.         try await logger.logReview(userId: userId, wordId: 1, outcome: .correct,
215.                                   activityType: .imageGame, sessionType: .morning, studyDay: 0, durationMs: 2000)
216.         try await logger.logReview(userId: userId, wordId: 1, outcome: .incorrect,
217.                                   activityType: .quickRecall, sessionType: .evening, studyDay: 0, durationMs: 2000)
218.         try await logger.logReview(userId: userId, wordId: 1, outcome: .correct,
219.                                   activityType: .imageGame, sessionType: .evening, studyDay: 0, durationMs: 2000)
220. 
221.         let result = try await store.runDay1Promotion(userId: userId, studyDay: 0)
222. 
223.         XCTAssertEqual(result.promoted, 1)
224.         XCTAssertEqual(result.notPromoted, 0)
225. 
226.         let ws = try await store.getWordState(userId: userId, wordId: 1)
227.         XCTAssertEqual(ws?.boxLevel, 2, "Should promote to box 2")
228.         XCTAssertEqual(ws?.introStage, 3, "Should be marked as decided")
229.     }
230. 
231.     func testDay1PromotionFailsWithWrongFinalRecall() async throws {
232.         try await store.introduceWord(userId: userId, wordId: 1)
233. 
234.         let logger = ReviewLogger(db: db)
235.         // 3 scored events: correct, correct, WRONG (2/3 correct but last is wrong)
236.         try await logger.logReview(userId: userId, wordId: 1, outcome: .correct,
237.                                   activityType: .imageGame, sessionType: .morning, studyDay: 0, durationMs: 2000)
238.         try await logger.logReview(userId: userId, wordId: 1, outcome: .correct,
239.                                   activityType: .quickRecall, sessionType: .evening, studyDay: 0, durationMs: 2000)
240.         try await logger.logReview(userId: userId, wordId: 1, outcome: .incorrect,
241.                                   activityType: .imageGame, sessionType: .evening, studyDay: 0, durationMs: 2000)
242. 
243.         let result = try await store.runDay1Promotion(userId: userId, studyDay: 0)
244. 
245.         XCTAssertEqual(result.promoted, 0)
246.         XCTAssertEqual(result.notPromoted, 1)
247. 
248.         let ws = try await store.getWordState(userId: userId, wordId: 1)
249.         XCTAssertEqual(ws?.boxLevel, 1, "Should stay at box 1")
250.     }
251. 
252.     func testDay1PromotionFailsWithOnlyOneCorrect() async throws {
253.         try await store.introduceWord(userId: userId, wordId: 1)
254. 
255.         let logger = ReviewLogger(db: db)
256.         try await logger.logReview(userId: userId, wordId: 1, outcome: .incorrect,
257.                                   activityType: .imageGame, sessionType: .morning, studyDay: 0, durationMs: 2000)
258.         try await logger.logReview(userId: userId, wordId: 1, outcome: .incorrect,
259.                                   activityType: .quickRecall, sessionType: .evening, studyDay: 0, durationMs: 2000)
260.         try await logger.logReview(userId: userId, wordId: 1, outcome: .correct,
261.                                   activityType: .imageGame, sessionType: .evening, studyDay: 0, durationMs: 2000)
262. 
263.         let result = try await store.runDay1Promotion(userId: userId, studyDay: 0)
264. 
265.         XCTAssertEqual(result.promoted, 0, "1/3 correct should not promote")
266.     }
267. 
268.     // MARK: - Box Distribution
269. 
270.     func testBoxDistributionCounts() async throws {
271.         for i in 1...5 {
272.             try await store.introduceWord(userId: userId, wordId: i)
273.         }
274.         try db.exec("UPDATE word_state SET box_level = 1 WHERE word_id IN (1,2)")
275.         try db.exec("UPDATE word_state SET box_level = 3 WHERE word_id IN (3,4,5)")
276. 
277.         let dist = try await store.getBoxDistribution(userId: userId)
278.         XCTAssertEqual(dist[1], 2)
279.         XCTAssertEqual(dist[3], 3)
280.     }
281. 
282.     // MARK: - Overdue Count
283. 
284.     func testOverdueCount() async throws {
285.         for i in 1...5 {
286.             try await store.introduceWord(userId: userId, wordId: i)
287.         }
288.         try db.exec("UPDATE word_state SET box_level = 1, due_at = datetime('now','-1 day') WHERE word_id IN (1,2,3)")
289.         try db.exec("UPDATE word_state SET box_level = 2, due_at = datetime('now','+1 day') WHERE word_id IN (4,5)")
290. 
291.         let count = try await store.countOverdue(userId: userId)
292.         XCTAssertEqual(count, 3)
293.     }
294. }
295.
```

</details>


---

<sub>⏱️ 6m 17s</sub>

### ✅ `apply_patch`

<details>
<summary>Arguments</summary>

```json
"*** Begin Patch\n*** Update File: /Users/jiong/myprojects/satspell/ios/SATVocabApp/Tests/SATVocabAppTests/Data/WordStateStoreTests.swift\n@@\n     func testReviewQueuePrioritizesStubbornOverNormal() async throws {\n         for i in 1...2 {\n             try await store.introduceWord(userId: userId, wordId: i)\n         }\n         try db.exec(\"UPDATE word_state SET box_level = 1, due_at = datetime('now','-1 day'), memory_status = 'normal' WHERE word_id = 1\")\n@@\n         let queue = try await store.getReviewQueue(userId: userId, limit: 10)\n         XCTAssertEqual(queue[0].wordId, 2, \"Stubborn word should come first within same box\")\n     }\n+\n+    func testCorrectAnswerOnDay1WordDoesNotPromoteBoxBeforeEndOfEvening() async throws {\n+        try await store.introduceWord(userId: userId, wordId: 1)\n+\n+        let change = try await store.recordScoredAnswer(userId: userId, wordId: 1, correct: true)\n+\n+        let ws = try await store.getWordState(userId: userId, wordId: 1)\n+        XCTAssertEqual(ws?.boxLevel, 0, \"Day 1 scored answers should not move a new word out of box 0 before promotion is decided\")\n+        XCTAssertNil(ws?.dueAt, \"Day 1 scored answers should not set a review date before promotion is decided\")\n+        if case .none = change {} else {\n+            XCTFail(\"Expected no box change for a Day 1 scored answer, got \\(change)\")\n+        }\n+    }\n \n     // MARK: - Day 1 Promotion\n \n     func testDay1PromotionWithTwoOfThreeCorrectAndCorrectFinal() async throws {\n         try await store.introduceWord(userId: userId, wordId: 1)\n@@\n     func testDay1PromotionFailsWithOnlyOneCorrect() async throws {\n         try await store.introduceWord(userId: userId, wordId: 1)\n \n         let logger = ReviewLogger(db: db)\n         try await logger.logReview(userId: userId, wordId: 1, outcome: .incorrect,\n@@\n \n         let result = try await store.runDay1Promotion(userId: userId, studyDay: 0)\n \n         XCTAssertEqual(result.promoted, 0, \"1/3 correct should not promote\")\n     }\n+\n+    func testDay1PromotionIgnoresPreviousStudyDays() async throws {\n+        try await store.introduceWord(userId: userId, wordId: 1)\n+\n+        try db.exec(\"\"\"\n+        INSERT INTO review_log(user_id, word_id, outcome, duration_ms, reviewed_at, activity_type, session_type, study_day, superseded)\n+        VALUES\n+            ('\\(userId!)', 1, 'correct', 1500, '2026-01-01T08:00:00Z', 'image_game', 'morning', 0, 0),\n+            ('\\(userId!)', 1, 'incorrect', 1500, '2026-01-01T09:00:00Z', 'quick_recall', 'evening', 0, 0),\n+            ('\\(userId!)', 1, 'correct', 1500, '2026-01-01T10:00:00Z', 'image_game', 'evening', 0, 0),\n+            ('\\(userId!)', 1, 'correct', 1500, '2026-01-02T08:00:00Z', 'quick_recall', 'evening', 1, 0);\n+        \"\"\")\n+\n+        let result = try await store.runDay1Promotion(userId: userId, studyDay: 1)\n+\n+        XCTAssertEqual(result.promoted, 0, \"Only the current study day should count toward Day 1 promotion\")\n+        XCTAssertEqual(result.notPromoted, 1)\n+\n+        let ws = try await store.getWordState(userId: userId, wordId: 1)\n+        XCTAssertEqual(ws?.boxLevel, 1, \"Historical days should not promote today's word\")\n+    }\n \n     // MARK: - Box Distribution\n*** End Patch\n"
```

</details>

```
Modified 1 file(s): /Users/jiong/myprojects/satspell/ios/SATVocabApp/Tests/SATVocabAppTests/Data/WordStateStoreTests.swift
```


---

<sub>⏱️ 6m 23s</sub>

### 💬 Copilot

I’ve added the two minimal regression tests. Now I’m running just the `WordStateStoreTests` target to verify they fail for the specific spec mismatches, not because of setup noise.

---

<sub>⏱️ 6m 41s</sub>

### ✅ `bash`

**Run WordStateStore regression tests**

$ cd /Users/jiong/myprojects/satspell/ios/SATVocabApp && xcodebuild test -scheme SATVocabApp -destination 'platform=iOS Simulator,name=iPhone 17 Pro Max' -only-testing:SATVocabAppTests/WordStateStoreTests 2>&1 | grep -E 'testCorrectAnswerOnDay1WordDoesNotPromoteBoxBeforeEndOfEvening|testDay1PromotionIgnoresPreviousStudyDays|Test Case|passed|failed|Executed'

<details>
<summary>56 lines</summary>

```
Ignoring --strip-bitcode because --sign was not passed
Test Case '-[SATVocabAppTests.WordStateStoreTests testBoxDistributionCounts]' started.
Test Case '-[SATVocabAppTests.WordStateStoreTests testBoxDistributionCounts]' passed (0.004 seconds).
Test Case '-[SATVocabAppTests.WordStateStoreTests testCorrectAnswerAtBox5StaysAt5]' started.
Test Case '-[SATVocabAppTests.WordStateStoreTests testCorrectAnswerAtBox5StaysAt5]' passed (0.007 seconds).
Test Case '-[SATVocabAppTests.WordStateStoreTests testCorrectAnswerOnDay1WordDoesNotPromoteBoxBeforeEndOfEvening]' started.
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Tests/SATVocabAppTests/Data/WordStateStoreTests.swift:213: error: -[SATVocabAppTests.WordStateStoreTests testCorrectAnswerOnDay1WordDoesNotPromoteBoxBeforeEndOfEvening] : XCTAssertEqual failed: ("Optional(1)") is not equal to ("Optional(0)") - Day 1 scored answers should not move a new word out of box 0 before promotion is decided
Test Case '-[SATVocabAppTests.WordStateStoreTests testCorrectAnswerOnDay1WordDoesNotPromoteBoxBeforeEndOfEvening]' failed (0.058 seconds).
Test Case '-[SATVocabAppTests.WordStateStoreTests testCorrectAnswerPromotesBox]' started.
Test Case '-[SATVocabAppTests.WordStateStoreTests testCorrectAnswerPromotesBox]' passed (0.002 seconds).
Test Case '-[SATVocabAppTests.WordStateStoreTests testCorrectAnswerResetsConsecutiveWrong]' started.
Test Case '-[SATVocabAppTests.WordStateStoreTests testCorrectAnswerResetsConsecutiveWrong]' passed (0.033 seconds).
Test Case '-[SATVocabAppTests.WordStateStoreTests testDay1PromotionFailsWithOnlyOneCorrect]' started.
Test Case '-[SATVocabAppTests.WordStateStoreTests testDay1PromotionFailsWithOnlyOneCorrect]' passed (0.008 seconds).
Test Case '-[SATVocabAppTests.WordStateStoreTests testDay1PromotionFailsWithWrongFinalRecall]' started.
Test Case '-[SATVocabAppTests.WordStateStoreTests testDay1PromotionFailsWithWrongFinalRecall]' passed (0.002 seconds).
Test Case '-[SATVocabAppTests.WordStateStoreTests testDay1PromotionIgnoresPreviousStudyDays]' started.
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Tests/SATVocabAppTests/Data/WordStateStoreTests.swift:295: error: -[SATVocabAppTests.WordStateStoreTests testDay1PromotionIgnoresPreviousStudyDays] : XCTAssertEqual failed: ("1") is not equal to ("0") - Only the current study day should count toward Day 1 promotion
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Tests/SATVocabAppTests/Data/WordStateStoreTests.swift:296: error: -[SATVocabAppTests.WordStateStoreTests testDay1PromotionIgnoresPreviousStudyDays] : XCTAssertEqual failed: ("0") is not equal to ("1")
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Tests/SATVocabAppTests/Data/WordStateStoreTests.swift:299: error: -[SATVocabAppTests.WordStateStoreTests testDay1PromotionIgnoresPreviousStudyDays] : XCTAssertEqual failed: ("Optional(2)") is not equal to ("Optional(1)") - Historical days should not promote today's word
Test Case '-[SATVocabAppTests.WordStateStoreTests testDay1PromotionIgnoresPreviousStudyDays]' failed (0.005 seconds).
Test Case '-[SATVocabAppTests.WordStateStoreTests testDay1PromotionWithTwoOfThreeCorrectAndCorrectFinal]' started.
Test Case '-[SATVocabAppTests.WordStateStoreTests testDay1PromotionWithTwoOfThreeCorrectAndCorrectFinal]' passed (0.002 seconds).
Test Case '-[SATVocabAppTests.WordStateStoreTests testEasyAtBox3WithHighAccuracyNoLapses]' started.
Test Case '-[SATVocabAppTests.WordStateStoreTests testEasyAtBox3WithHighAccuracyNoLapses]' passed (0.002 seconds).
Test Case '-[SATVocabAppTests.WordStateStoreTests testFragileAfter1Lapse]' started.
Test Case '-[SATVocabAppTests.WordStateStoreTests testFragileAfter1Lapse]' passed (0.001 seconds).
Test Case '-[SATVocabAppTests.WordStateStoreTests testIntroduceWordIsIdempotent]' started.
Test Case '-[SATVocabAppTests.WordStateStoreTests testIntroduceWordIsIdempotent]' passed (0.001 seconds).
Test Case '-[SATVocabAppTests.WordStateStoreTests testIntroduceWordSetsIntroStage1]' started.
Test Case '-[SATVocabAppTests.WordStateStoreTests testIntroduceWordSetsIntroStage1]' passed (0.008 seconds).
Test Case '-[SATVocabAppTests.WordStateStoreTests testOverdueCount]' started.
Test Case '-[SATVocabAppTests.WordStateStoreTests testOverdueCount]' passed (0.001 seconds).
Test Case '-[SATVocabAppTests.WordStateStoreTests testReviewQueueExcludesNotYetDue]' started.
Test Case '-[SATVocabAppTests.WordStateStoreTests testReviewQueueExcludesNotYetDue]' passed (0.001 seconds).
Test Case '-[SATVocabAppTests.WordStateStoreTests testReviewQueuePrioritizesBox1First]' started.
Test Case '-[SATVocabAppTests.WordStateStoreTests testReviewQueuePrioritizesBox1First]' passed (0.001 seconds).
Test Case '-[SATVocabAppTests.WordStateStoreTests testReviewQueuePrioritizesStubbornOverNormal]' started.
Test Case '-[SATVocabAppTests.WordStateStoreTests testReviewQueuePrioritizesStubbornOverNormal]' passed (0.001 seconds).
Test Case '-[SATVocabAppTests.WordStateStoreTests testStubbornAfter2ConsecutiveWrong]' started.
Test Case '-[SATVocabAppTests.WordStateStoreTests testStubbornAfter2ConsecutiveWrong]' passed (0.001 seconds).
Test Case '-[SATVocabAppTests.WordStateStoreTests testStubbornAfter3Lapses]' started.
Test Case '-[SATVocabAppTests.WordStateStoreTests testStubbornAfter3Lapses]' passed (0.001 seconds).
Test Case '-[SATVocabAppTests.WordStateStoreTests testWrongAnswerAtBox1StaysAtBox1]' started.
Test Case '-[SATVocabAppTests.WordStateStoreTests testWrongAnswerAtBox1StaysAtBox1]' passed (0.002 seconds).
Test Case '-[SATVocabAppTests.WordStateStoreTests testWrongAnswerIncrementsConsecutiveWrong]' started.
Test Case '-[SATVocabAppTests.WordStateStoreTests testWrongAnswerIncrementsConsecutiveWrong]' passed (0.001 seconds).
Test Case '-[SATVocabAppTests.WordStateStoreTests testWrongAnswerResetsToBox1]' started.
Test Case '-[SATVocabAppTests.WordStateStoreTests testWrongAnswerResetsToBox1]' passed (0.001 seconds).
Test Suite 'WordStateStoreTests' failed at 2026-04-12 17:27:57.672.
	 Executed 22 tests, with 4 failures (0 unexpected) in 0.145 (0.149) seconds
Test Suite 'SATVocabAppTests.xctest' failed at 2026-04-12 17:27:57.672.
	 Executed 22 tests, with 4 failures (0 unexpected) in 0.145 (0.149) seconds
Test Suite 'Selected tests' failed at 2026-04-12 17:27:57.672.
	 Executed 22 tests, with 4 failures (0 unexpected) in 0.145 (0.149) seconds
<exited with exit code 0>
```

</details>


---

<sub>⏱️ 7m 38s</sub>

### 💬 Copilot

I’ve verified the two progression bugs with failing tests. I’m doing one last pass on the legacy call sites that still use `DataManager`’s old session/log APIs, because that determines whether those are harmless leftovers or active corruption risks in the shipped app.

---

<sub>⏱️ 7m 39s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/GameSessionViewModel.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/GameSessionViewModel.swift (lines 110-205)

<details>
<summary>95 lines</summary>

```
110. 
111.                     // Prefer variety and cap to 20.
112.                     var seenQ = Set<String>()
113.                     let unique = pool.filter { round in
114.                         if case .satMCQ(_, let q) = round {
115.                             return seenQ.insert(q.id).inserted
116.                         }
117.                         return false
118.                     }
119.                     allRounds = Array(unique.shuffled().prefix(AppConfig.task4McqCount))
120.                 }
121. 
122.                 if allRounds.isEmpty {
123.                     self.errorMessage = (mode == .task4Sat) ? "No SAT questions available for today's words." : "No rounds available."
124.                     self.isLoading = false
125.                     return
126.                 }
127. 
128.                 let sId = try await DataManager.shared.startSession(userId: userId, listId: list.id, itemsTotal: allRounds.count)
129.                 self.sessionId = sId
130. 
131.                 self.rounds = allRounds
132.                 self.roundShownAt = Date()
133.                 self.isLoading = false
134.             } catch {
135.                 self.errorMessage = String(describing: error)
136.                 self.isLoading = false
137.             }
138.         }
139.     }
140. 
141.     var isFinished: Bool {
142.         !rounds.isEmpty && currentIndex >= rounds.count
143.     }
144. 
145.     func submitAnswer(wordId: Int, isCorrect: Bool, logReview: Bool = true, markNeedsReview: Bool = false) {
146.         guard let list else { return }
147.         let durationMs = Int(Date().timeIntervalSince(roundShownAt) * 1000)
148.         let deviceId = LocalIdentity.deviceId()
149. 
150.         if !isCorrect || markNeedsReview {
151.             if needsReviewWordIds.insert(wordId).inserted {
152.                 needsReviewCount = needsReviewWordIds.count
153.             }
154.         }
155. 
156.         if logReview {
157.             Task {
158.                 do {
159.                     try await DataManager.shared.logReview(
160.                         userId: userId,
161.                         wordId: wordId,
162.                         listId: list.id,
163.                         outcome: isCorrect ? .correct : .incorrect,
164.                         durationMs: durationMs,
165.                         reviewedAt: Date(),
166.                         deviceId: deviceId
167.                     )
168.                 } catch {
169.                     // non-fatal
170.                 }
171.             }
172.         }
173. 
174.         if isCorrect { itemsCorrect += 1 }
175.     }
176. 
177.     func advance() {
178.         currentIndex += 1
179.         roundShownAt = Date()
180.     }
181. 
182.     func finishIfNeeded() {
183.         guard isFinished else { return }
184.         guard let list else { return }
185.         guard let sessionId else { return }
186. 
187.         Task {
188.             do {
189.                 try await DataManager.shared.finishSession(sessionId: sessionId, itemsCorrect: itemsCorrect)
190.                 try await DataManager.shared.updateProgressAfterSession(
191.                     userId: userId,
192.                     listId: list.id,
193.                     itemsTotal: rounds.count,
194.                     itemsCorrect: itemsCorrect
195.                 )
196.             } catch {
197.                 // non-fatal
198.             }
199.         }
200.     }
201. 
202.     // (no longer needed) fetchWordByIdFallback
203. }
204.
```

</details>


---

<sub>⏱️ 7m 39s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/FlashcardSessionViewModel.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/FlashcardSessionViewModel.swift (lines 60-170)

<details>
<summary>111 lines</summary>

```
60.                 }
61. 
62.                 // Preload one random sat_context per card (used on front caption + back context).
63.                 for idx in cards.indices {
64.                     let context = try await DataManager.shared.randomSatContext(wordId: cards[idx].id)
65.                     cards[idx].satContext = context
66. 
67.                     let collocations = try await DataManager.shared.fetchCollocations(wordId: cards[idx].id)
68.                     cards[idx].collocations = collocations.isEmpty ? nil : collocations
69.                 }
70. 
71.                 let sId = try await DataManager.shared.startSession(userId: userId, listId: list.id, itemsTotal: cards.count)
72.                 self.sessionId = sId
73. 
74.                 self.cards = cards
75.                 if mode == .task1 {
76.                     self.remainingToMaster = Set(cards.map { $0.id })
77.                     self.uniqueTotal = self.remainingToMaster.count
78.                 }
79.                 self.cardShownAt = Date()
80.                 self.isLoading = false
81.             } catch {
82.                 self.errorMessage = String(describing: error)
83.                 self.isLoading = false
84.             }
85.         }
86.     }
87. 
88.     func recordAnswer(outcome: ReviewOutcome) {
89.         guard let list else { return }
90.         guard currentIndex < cards.count else { return }
91.         let card = cards[currentIndex]
92. 
93.         let durationMs = Int(Date().timeIntervalSince(cardShownAt) * 1000)
94.         let deviceId = LocalIdentity.deviceId()
95. 
96.         Task {
97.             do {
98.                 try await DataManager.shared.logReview(
99.                     userId: userId,
100.                     wordId: card.id,
101.                     listId: list.id,
102.                     outcome: outcome,
103.                     durationMs: durationMs,
104.                     reviewedAt: Date(),
105.                     deviceId: deviceId
106.                 )
107.             } catch {
108.                 // non-fatal for v1
109.             }
110.         }
111. 
112.         if outcome == .correct { itemsCorrect += 1 }
113. 
114.         if repeatUntilMastered {
115.             if outcome == .correct {
116.                 remainingToMaster.remove(card.id)
117.             } else {
118.                 // Re-queue this word so it repeats later.
119.                 cards.append(card)
120.             }
121.             advanceSkippingMastered()
122.         } else {
123.             advance()
124.         }
125.     }
126. 
127.     func advance() {
128.         currentIndex += 1
129.         cardShownAt = Date()
130.     }
131. 
132.     private func advanceSkippingMastered() {
133.         currentIndex += 1
134.         while currentIndex < cards.count {
135.             let id = cards[currentIndex].id
136.             if remainingToMaster.contains(id) { break }
137.             currentIndex += 1
138.         }
139. 
140.         if remainingToMaster.isEmpty {
141.             currentIndex = cards.count
142.         }
143. 
144.         cardShownAt = Date()
145.     }
146. 
147.     var isFinished: Bool {
148.         !cards.isEmpty && currentIndex >= cards.count
149.     }
150. 
151.     func finishIfNeeded() {
152.         guard isFinished else { return }
153.         guard let list else { return }
154.         guard let sessionId else { return }
155. 
156.         Task {
157.             do {
158.                 try await DataManager.shared.finishSession(sessionId: sessionId, itemsCorrect: itemsCorrect)
159.                 try await DataManager.shared.updateProgressAfterSession(
160.                     userId: userId,
161.                     listId: list.id,
162.                     itemsTotal: cards.count,
163.                     itemsCorrect: itemsCorrect
164.                 )
165.             } catch {
166.                 // non-fatal
167.             }
168.         }
169.     }
170.
```

</details>


---

<sub>⏱️ 7m 39s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/ZoneReviewSessionViewModel.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/ZoneReviewSessionViewModel.swift (lines 40-100)

<details>
<summary>59 lines</summary>

```
40.                 let zoneStartIndex = zoneIndex * AdventureSchedule.daysPerZone * wordsPerDay
41.                 let zoneWords = try await DataManager.shared.fetchSessionQueue(
42.                     listId: list.id,
43.                     limit: AdventureSchedule.daysPerZone * wordsPerDay,
44.                     startIndex: zoneStartIndex
45.                 )
46.                 let zoneWordIds = zoneWords.map { $0.id }
47.                 if zoneWordIds.isEmpty {
48.                     isLoading = false
49.                     return
50.                 }
51. 
52.                 let cards = try await DataManager.shared.fetchReviewQueue(userId: userId, listId: list.id, limit: 200, restrictToWordIds: zoneWordIds)
53.                 var enriched = cards
54.                 for idx in enriched.indices {
55.                     enriched[idx].satContext = try await DataManager.shared.randomSatContext(wordId: enriched[idx].id)
56.                     let collocations = try await DataManager.shared.fetchCollocations(wordId: enriched[idx].id)
57.                     enriched[idx].collocations = collocations.isEmpty ? nil : collocations
58.                 }
59. 
60.                 self.queue = enriched
61.                 self.shownAt = Date()
62.                 self.isLoading = false
63.             } catch {
64.                 self.errorMessage = String(describing: error)
65.                 self.isLoading = false
66.             }
67.         }
68.     }
69. 
70.     func recordAnswer(outcome: ReviewOutcome) {
71.         guard let list else { return }
72.         guard let card = queue.first else { return }
73. 
74.         let durationMs = Int(Date().timeIntervalSince(shownAt) * 1000)
75.         let deviceId = LocalIdentity.deviceId()
76. 
77.         Task {
78.             do {
79.                 try await DataManager.shared.logReview(
80.                     userId: userId,
81.                     wordId: card.id,
82.                     listId: list.id,
83.                     outcome: outcome,
84.                     durationMs: durationMs,
85.                     reviewedAt: Date(),
86.                     deviceId: deviceId
87.                 )
88.             } catch {
89.                 // non-fatal
90.             }
91.         }
92. 
93.         // This zone review is a cleanup pass; do not repeat cards in-session.
94.         queue.removeFirst()
95.         shownAt = Date()
96.     }
97. }
98.
```

</details>


---

<sub>⏱️ 7m 39s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift (lines 288-450)

<details>
<summary>163 lines</summary>

```
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
```

</details>


---

<sub>⏱️ 7m 46s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Tests/SATVocabAppTests/Data/WordStateStoreTests.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Tests/SATVocabAppTests/Data/WordStateStoreTests.swift (lines 200-310)

<details>
<summary>111 lines</summary>

```
200.         try db.exec("UPDATE word_state SET box_level = 1, due_at = datetime('now','-1 day'), memory_status = 'normal' WHERE word_id = 1")
201.         try db.exec("UPDATE word_state SET box_level = 1, due_at = datetime('now','-1 day'), memory_status = 'stubborn' WHERE word_id = 2")
202. 
203.         let queue = try await store.getReviewQueue(userId: userId, limit: 10)
204.         XCTAssertEqual(queue[0].wordId, 2, "Stubborn word should come first within same box")
205.     }
206. 
207.     func testCorrectAnswerOnDay1WordDoesNotPromoteBoxBeforeEndOfEvening() async throws {
208.         try await store.introduceWord(userId: userId, wordId: 1)
209. 
210.         let change = try await store.recordScoredAnswer(userId: userId, wordId: 1, correct: true)
211. 
212.         let ws = try await store.getWordState(userId: userId, wordId: 1)
213.         XCTAssertEqual(ws?.boxLevel, 0, "Day 1 scored answers should not move a new word out of box 0 before promotion is decided")
214.         XCTAssertNil(ws?.dueAt, "Day 1 scored answers should not set a review date before promotion is decided")
215.         if case .none = change {} else {
216.             XCTFail("Expected no box change for a Day 1 scored answer, got \(change)")
217.         }
218.     }
219. 
220.     // MARK: - Day 1 Promotion
221. 
222.     func testDay1PromotionWithTwoOfThreeCorrectAndCorrectFinal() async throws {
223.         try await store.introduceWord(userId: userId, wordId: 1)
224. 
225.         let logger = ReviewLogger(db: db)
226.         // 3 scored events: correct, wrong, correct (2/3, last correct)
227.         try await logger.logReview(userId: userId, wordId: 1, outcome: .correct,
228.                                   activityType: .imageGame, sessionType: .morning, studyDay: 0, durationMs: 2000)
229.         try await logger.logReview(userId: userId, wordId: 1, outcome: .incorrect,
230.                                   activityType: .quickRecall, sessionType: .evening, studyDay: 0, durationMs: 2000)
231.         try await logger.logReview(userId: userId, wordId: 1, outcome: .correct,
232.                                   activityType: .imageGame, sessionType: .evening, studyDay: 0, durationMs: 2000)
233. 
234.         let result = try await store.runDay1Promotion(userId: userId, studyDay: 0)
235. 
236.         XCTAssertEqual(result.promoted, 1)
237.         XCTAssertEqual(result.notPromoted, 0)
238. 
239.         let ws = try await store.getWordState(userId: userId, wordId: 1)
240.         XCTAssertEqual(ws?.boxLevel, 2, "Should promote to box 2")
241.         XCTAssertEqual(ws?.introStage, 3, "Should be marked as decided")
242.     }
243. 
244.     func testDay1PromotionFailsWithWrongFinalRecall() async throws {
245.         try await store.introduceWord(userId: userId, wordId: 1)
246. 
247.         let logger = ReviewLogger(db: db)
248.         // 3 scored events: correct, correct, WRONG (2/3 correct but last is wrong)
249.         try await logger.logReview(userId: userId, wordId: 1, outcome: .correct,
250.                                   activityType: .imageGame, sessionType: .morning, studyDay: 0, durationMs: 2000)
251.         try await logger.logReview(userId: userId, wordId: 1, outcome: .correct,
252.                                   activityType: .quickRecall, sessionType: .evening, studyDay: 0, durationMs: 2000)
253.         try await logger.logReview(userId: userId, wordId: 1, outcome: .incorrect,
254.                                   activityType: .imageGame, sessionType: .evening, studyDay: 0, durationMs: 2000)
255. 
256.         let result = try await store.runDay1Promotion(userId: userId, studyDay: 0)
257. 
258.         XCTAssertEqual(result.promoted, 0)
259.         XCTAssertEqual(result.notPromoted, 1)
260. 
261.         let ws = try await store.getWordState(userId: userId, wordId: 1)
262.         XCTAssertEqual(ws?.boxLevel, 1, "Should stay at box 1")
263.     }
264. 
265.     func testDay1PromotionFailsWithOnlyOneCorrect() async throws {
266.         try await store.introduceWord(userId: userId, wordId: 1)
267. 
268.         let logger = ReviewLogger(db: db)
269.         try await logger.logReview(userId: userId, wordId: 1, outcome: .incorrect,
270.                                   activityType: .imageGame, sessionType: .morning, studyDay: 0, durationMs: 2000)
271.         try await logger.logReview(userId: userId, wordId: 1, outcome: .incorrect,
272.                                   activityType: .quickRecall, sessionType: .evening, studyDay: 0, durationMs: 2000)
273.         try await logger.logReview(userId: userId, wordId: 1, outcome: .correct,
274.                                   activityType: .imageGame, sessionType: .evening, studyDay: 0, durationMs: 2000)
275. 
276.         let result = try await store.runDay1Promotion(userId: userId, studyDay: 0)
277. 
278.         XCTAssertEqual(result.promoted, 0, "1/3 correct should not promote")
279.     }
280. 
281.     func testDay1PromotionIgnoresPreviousStudyDays() async throws {
282.         try await store.introduceWord(userId: userId, wordId: 1)
283. 
284.         try db.exec("""
285.         INSERT INTO review_log(user_id, word_id, outcome, duration_ms, reviewed_at, activity_type, session_type, study_day, superseded)
286.         VALUES
287.             ('\(userId!)', 1, 'correct', 1500, '2026-01-01T08:00:00Z', 'image_game', 'morning', 0, 0),
288.             ('\(userId!)', 1, 'incorrect', 1500, '2026-01-01T09:00:00Z', 'quick_recall', 'evening', 0, 0),
289.             ('\(userId!)', 1, 'correct', 1500, '2026-01-01T10:00:00Z', 'image_game', 'evening', 0, 0),
290.             ('\(userId!)', 1, 'correct', 1500, '2026-01-02T08:00:00Z', 'quick_recall', 'evening', 1, 0);
291.         """)
292. 
293.         let result = try await store.runDay1Promotion(userId: userId, studyDay: 1)
294. 
295.         XCTAssertEqual(result.promoted, 0, "Only the current study day should count toward Day 1 promotion")
296.         XCTAssertEqual(result.notPromoted, 1)
297. 
298.         let ws = try await store.getWordState(userId: userId, wordId: 1)
299.         XCTAssertEqual(ws?.boxLevel, 1, "Historical days should not promote today's word")
300.     }
301. 
302.     // MARK: - Box Distribution
303. 
304.     func testBoxDistributionCounts() async throws {
305.         for i in 1...5 {
306.             try await store.introduceWord(userId: userId, wordId: i)
307.         }
308.         try db.exec("UPDATE word_state SET box_level = 1 WHERE word_id IN (1,2)")
309.         try db.exec("UPDATE word_state SET box_level = 3 WHERE word_id IN (3,4,5)")
310.
```

</details>


---

<sub>⏱️ 7m 46s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SessionStateStore.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Data/SessionStateStore.swift (lines 148-250)

<details>
<summary>103 lines</summary>

```
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
```

</details>


---

<sub>⏱️ 7m 46s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Session/SessionFlowView.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/Views/Session/SessionFlowView.swift (lines 46-100)

<details>
<summary>55 lines</summary>

```
46.             } else if let step = vm.currentStep {
47.                 switch step.type {
48.                 case .flashcard:
49.                     FlashcardStepView(
50.                         words: vm.newWords,
51.                         stepNumber: vm.currentStepIndex + 1,
52.                         totalSteps: vm.totalSteps,
53.                         onComplete: { showAgainIds in
54.                             vm.receiveShowAgainIds(showAgainIds)
55.                             vm.advanceToNextStep()
56.                         },
57.                         onPause: { stepIdx, itemIdx, saIds, rqIds in
58.                             Task { await vm.pause(stepIndex: stepIdx, itemIndex: itemIdx, showAgainIds: saIds, requeuedIds: rqIds) }
59.                             dismiss()
60.                         }
61.                     )
62.                 case .imageGame:
63.                     ImageGameStepView(
64.                         words: vm.newWords,
65.                         showAgainPriority: vm.showAgainWordIds,
66.                         stepNumber: vm.currentStepIndex + 1,
67.                         totalSteps: vm.totalSteps,
68.                         onAnswer: { correct, wordId in
69.                             Task { await vm.recordAnswer(correct: correct, wordId: wordId, activityType: .imageGame, durationMs: 0) }
70.                         },
71.                         onComplete: { vm.advanceToNextStep() },
72.                         onPause: { _, _, _, _ in dismiss() }
73.                     )
74.                 case .quickRecall:
75.                     QuickRecallStepView(
76.                         words: vm.morningWords,
77.                         stepNumber: vm.currentStepIndex + 1,
78.                         totalSteps: vm.totalSteps,
79.                         onAnswer: { correct, wordId in
80.                             Task { await vm.recordAnswer(correct: correct, wordId: wordId, activityType: .quickRecall, durationMs: 0) }
81.                         },
82.                         onComplete: { vm.advanceToNextStep() },
83.                         onPause: { _, _, _, _ in dismiss() }
84.                     )
85.                 case .satQuestion:
86.                     SATQuestionStepView(
87.                         words: vm.newWords,
88.                         stepNumber: vm.currentStepIndex + 1,
89.                         totalSteps: vm.totalSteps,
90.                         onAnswer: { correct, wordId in
91.                             Task { await vm.recordAnswer(correct: correct, wordId: wordId, activityType: .satQuestion, durationMs: 0) }
92.                         },
93.                         onComplete: { vm.advanceToNextStep() },
94.                         onPause: { _, _, _, _ in dismiss() }
95.                     )
96.                 }
97.             }
98.         }
99.         .toolbar(.hidden, for: .tabBar)
100.         .task {
```

</details>


---

<sub>⏱️ 7m 46s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/SessionFlowViewModel.swift.**

/Users/jiong/myprojects/satspell/ios/SATVocabApp/Sources/SATVocabApp/ViewModels/SessionFlowViewModel.swift (lines 88-234)

<details>
<summary>147 lines</summary>

```
88.     func loadWords() async throws {
89.         let dm = DataManager.shared
90.         try await dm.initializeIfNeeded()
91. 
92.         // Create required rows BEFORE any updates
93.         let sessionStore = SessionStateStore.shared
94.         let statsStore = StatsStore.shared
95.         let zoneIdx = studyDay / 4  // approximate zone
96.         _ = try await sessionStore.getOrCreateDayState(userId: userId, studyDay: studyDay, zoneIndex: zoneIdx)
97.         _ = try await sessionStore.createSession(userId: userId, sessionType: sessionType, studyDay: studyDay)
98.         _ = try await statsStore.getOrCreateDailyStats(userId: userId, studyDay: studyDay)
99. 
100.         let list = try await dm.getDefaultList()
101.         let startIndex = studyDay * (AppConfig.morningNewWords + AppConfig.eveningNewWords)
102. 
103.         switch sessionType {
104.         case .morning:
105.             newWords = try await dm.fetchSessionQueue(listId: list.id, limit: AppConfig.morningNewWords, startIndex: startIndex)
106.         case .evening:
107.             let morningStart = studyDay * (AppConfig.morningNewWords + AppConfig.eveningNewWords)
108.             morningWords = try await dm.fetchSessionQueue(listId: list.id, limit: AppConfig.morningNewWords, startIndex: morningStart)
109.             let eveningStart = morningStart + AppConfig.morningNewWords
110.             newWords = try await dm.fetchSessionQueue(listId: list.id, limit: AppConfig.eveningNewWords, startIndex: eveningStart)
111.         default:
112.             break
113.         }
114. 
115.         // Load review words from word_state
116.         let wsStore = WordStateStore(db: dm.db)
117.         let reviews = try await wsStore.getReviewQueue(userId: userId, limit: 6)
118.         // Convert WordState to VocabCard — would need a lookup
119.         // (simplified — full implementation maps wordId -> VocabCard)
120.         _ = reviews // suppress unused warning
121.     }
122. 
123.     func advanceToNextStep() {
124.         showStepTransition = true
125.     }
126. 
127.     func continueAfterTransition() {
128.         showStepTransition = false
129.         currentStepIndex += 1
130.         if currentStepIndex >= steps.count {
131.             completeSession()
132.         }
133.     }
134. 
135.     func recordAnswer(correct: Bool, wordId: Int, activityType: ActivityType, durationMs: Int) async {
136.         totalAttempts += 1
137.         if correct {
138.             totalCorrect += 1
139.             xpEarned += AppConfig.correctAnswerXP
140.             comboCount += 1
141.         } else {
142.             comboCount = 0
143.         }
144. 
145.         // Record in data layer
146.         do {
147.             let dm = DataManager.shared
148.             let reviewLogger = ReviewLogger(db: dm.db)
149.             let wsStore = WordStateStore(db: dm.db)
150.             let statsStore = StatsStore.shared
151. 
152.             // 1. Write review_log entry
153.             let outcome: ReviewOutcome = correct ? .correct : .incorrect
154.             try await reviewLogger.logReview(
155.                 userId: userId, wordId: wordId, outcome: outcome,
156.                 activityType: activityType, sessionType: sessionType,
157.                 studyDay: studyDay, durationMs: durationMs)
158. 
159.             // 2. Update word_state (box progression)
160.             let boxChange = try await wsStore.recordScoredAnswer(userId: userId, wordId: wordId, correct: correct)
161. 
162.             switch boxChange {
163.             case .promoted(_, _): wordsPromoted += 1
164.             case .demoted(_, _): wordsDemoted += 1
165.             case .none: break
166.             }
167. 
168.             if correct {
169.                 try await statsStore.recordCorrectAnswer(userId: userId, studyDay: studyDay)
170.             } else {
171.                 try await statsStore.recordWrongAnswer(userId: userId, studyDay: studyDay)
172.             }
173.         } catch {
174.             // Non-fatal for v1
175.         }
176.     }
177. 
178.     func receiveShowAgainIds(_ ids: [Int]) {
179.         showAgainWordIds = ids
180.     }
181. 
182.     private func completeSession() {
183.         isComplete = true
184. 
185.         Task {
186.             do {
187.                 let sessionStore = SessionStateStore.shared
188.                 let statsStore = StatsStore.shared
189. 
190.                 // Mark session complete
191.                 try await sessionStore.completeSession(userId: userId, studyDay: studyDay, sessionType: sessionType)
192. 
193.                 // Session bonus
194.                 try await statsStore.addSessionBonus(userId: userId, studyDay: studyDay)
195.                 xpEarned += AppConfig.sessionBonusXP
196. 
197.                 // Mark day state
198.                 if sessionType == .morning {
199.                     try await sessionStore.markMorningComplete(userId: userId, studyDay: studyDay,
200.                         accuracy: totalAttempts > 0 ? Double(totalCorrect) / Double(totalAttempts) : 0,
201.                         xp: xpEarned, newWords: newWords.count)
202.                 } else if sessionType == .evening {
203.                     try await sessionStore.markEveningComplete(userId: userId, studyDay: studyDay,
204.                         accuracy: totalAttempts > 0 ? Double(totalCorrect) / Double(totalAttempts) : 0,
205.                         xp: xpEarned, newWords: newWords.count)
206. 
207.                     // Run Day 1 promotion
208.                     let dm = DataManager.shared
209.                     let wsStore = WordStateStore(db: dm.db)
210.                     let promotion = try await wsStore.runDay1Promotion(userId: userId, studyDay: studyDay)
211.                     wordsPromoted += promotion.promoted
212.                 }
213. 
214.                 // Update streak
215.                 let (_, milestoneXP) = try await statsStore.updateStreak(userId: userId, xpToday: xpEarned)
216.                 xpEarned += milestoneXP
217.             } catch {
218.                 // Non-fatal
219.             }
220.         }
221.     }
222. 
223.     // MARK: - Pause/Resume
224. 
225.     func pause(stepIndex: Int, itemIndex: Int, showAgainIds: [Int], requeuedIds: [Int]) async {
226.         isPaused = true
227.         do {
228.             let store = SessionStateStore.shared
229.             try await store.pauseSession(userId: userId, studyDay: studyDay, sessionType: sessionType,
230.                                         stepIndex: stepIndex, itemIndex: itemIndex,
231.                                         showAgainIds: showAgainIds, requeuedIds: requeuedIds)
232.         } catch {}
233.     }
234. }
```

</details>


---

<sub>⏱️ 9m 1s</sub>

### 💬 Copilot

I’ve got the final issue set. I’m writing the full review doc now with exact line references and the verified repro notes from the two failing regression tests.

---

<sub>⏱️ 9m 1s</sub>

### ✅ `apply_patch`

<details>
<summary>Arguments</summary>

```json
"*** Begin Patch\n*** Add File: /Users/jiong/myprojects/satspell/docs/reviews/code-review-implementation.md\n+# Code Review — SAT Vocab iOS Implementation\n+\n+## Verified repro\n+\n+- Baseline before adding repro tests: `SATVocabAppTests` passed (`33 tests, 0 failures`).\n+- Added two regression tests that now fail for the right reasons:\n+  - `WordStateStoreTests.swift:207-217` proves Day 1 scored answers incorrectly move new words out of box 0.\n+  - `WordStateStoreTests.swift:281-299` proves Day 1 promotion incorrectly counts previous `study_day` rows.\n+\n+## Findings\n+\n+1. **CRITICAL — Day 1 scoring corrupts box progression**\n+   - **File:** `ios/SATVocabApp/Sources/SATVocabApp/Data/WordStateStore.swift:176-208`\n+   - **Why:** `recordScoredAnswer()` promotes `box_level` from `0 -> 1` on the first correct scored answer and always assigns a due date. That contradicts `docs/data-schema.md` Section 5.12, where Day 1 words stay in box 0 until end-of-evening promotion.\n+   - **Fix:** Special-case box-0 intro words so scored Day 1 answers update accuracy/touches only; do not change `box_level`/`due_at` until `runDay1Promotion()`.\n+\n+2. **CRITICAL — Day 1 promotion counts historical reviews**\n+   - **File:** `ios/SATVocabApp/Sources/SATVocabApp/Data/WordStateStore.swift:275-303`\n+   - **Why:** Both the count query and “last recall” query ignore the `studyDay` argument, so prior days can satisfy today’s promotion threshold.\n+   - **Fix:** Add `AND study_day = ?` to both queries and bind `studyDay`.\n+\n+3. **CRITICAL — Resume flow destroys paused session state**\n+   - **Files:** `ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/PracticeTabView.swift:43-46`, `ios/SATVocabApp/Sources/SATVocabApp/ViewModels/SessionFlowViewModel.swift:92-99`, `ios/SATVocabApp/Sources/SATVocabApp/Data/SessionStateStore.swift:151-154`\n+   - **Why:** Tapping Resume only passes `sessionType`; `loadWords()` then calls `createSession()`, and `createSession()` uses `INSERT OR REPLACE`, wiping the saved `step_index`, `item_index`, `show_again_ids`, and `requeued_ids`.\n+   - **Fix:** Load the existing paused `session_state` instead of replacing it, and pass persisted resume state into the view model.\n+\n+4. **HIGH — Pause/resume is only implemented for flashcards**\n+   - **File:** `ios/SATVocabApp/Sources/SATVocabApp/Views/Session/SessionFlowView.swift:57-60,72,83,94`\n+   - **Why:** Flashcards call `vm.pause(...)`, but Image Game / Quick Recall / SAT just dismiss the view. Progress from scored steps is lost even though the UI presents them as pausable.\n+   - **Fix:** Wire all step views through the same pause persistence path and save current round state before dismissing.\n+\n+5. **HIGH — First-launch can get stuck in a permanently unseeded DB**\n+   - **Files:** `ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift:20-29,50-56`, `ios/SATVocabApp/Sources/SATVocabApp/ViewModels/PracticeTabViewModel.swift:22-45`\n+   - **Why:** `initializeIfNeeded()` treats “database file exists” as “content import succeeded.” If schema creation creates the file and import later fails, future launches skip import, `getDefaultList()` can keep failing, and `PracticeTabViewModel` silently falls back to `.morningAvailable`.\n+   - **Fix:** Validate seeded content (for example `lists`/`words` existence) before marking initialization complete, and surface initialization failure instead of masking it. Also seed the required Day 0 `day_state` row from `docs/data-schema.md` Section 5.1.\n+\n+6. **HIGH — Session load writes partial state before confirming content exists**\n+   - **File:** `ios/SATVocabApp/Sources/SATVocabApp/ViewModels/SessionFlowViewModel.swift:92-100`\n+   - **Why:** `loadWords()` creates `day_state`, `session_state`, and `daily_stats` before `getDefaultList()` or any queue fetch succeeds. A content/load failure leaves orphaned in-progress rows.\n+   - **Fix:** Fetch/validate content first, then create session/day/stats rows in one transactional step.\n+\n+7. **HIGH — Errors are swallowed after UI state is already mutated**\n+   - **Files:** `ios/SATVocabApp/Sources/SATVocabApp/ViewModels/SessionFlowViewModel.swift:135-175,182-219,225-232`\n+   - **Why:** XP, correct counts, completion state, and pause state are updated in memory before persistence finishes, and failures are silently ignored. The user can see progress that never actually saved.\n+   - **Fix:** Persist first or roll back UI state on failure, and surface a recoverable error to the view.\n+\n+8. **HIGH — Review queue and lifecycle logic do not match the schema spec**\n+   - **Files:** `ios/SATVocabApp/Sources/SATVocabApp/ViewModels/SessionFlowViewModel.swift:103-121`, `ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift:113-179`, `ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/PracticeStateResolver.swift:3-58`\n+   - **Why:** The session VM loads sequential list words, discards the `word_state` review queue, and never implements recovery/re-entry/review-only flows. `fetchReviewQueue()` itself uses “latest incorrect review_log row” instead of `word_state.due_at` + box/memory priority from `docs/data-schema.md` Sections 5.3 and 6.\n+   - **Fix:** Drive review selection from `word_state`, and implement the missing recovery/back-pressure/session-type branches end to end.\n+\n+9. **HIGH — Legacy DataManager APIs still write incompatible rows and a nonexistent table**\n+   - **Files:** `ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift:290-448`, call sites in `ios/SATVocabApp/Sources/SATVocabApp/ViewModels/GameSessionViewModel.swift:128-190`, `ios/SATVocabApp/Sources/SATVocabApp/ViewModels/FlashcardSessionViewModel.swift:71-159`, `ios/SATVocabApp/Sources/SATVocabApp/ViewModels/ZoneReviewSessionViewModel.swift:52-79`\n+   - **Why:** `logReview()` omits `activity_type`, `session_type`, `study_day`, and `superseded`; `startSession()/finishSession()` omit `session_type`, `study_day`, and `xp_earned`; `progress_snapshot` APIs target a table not created by `SchemaV2`.\n+   - **Fix:** Remove or migrate the legacy APIs and move all call sites onto the V2 stores / schema.\n+\n+10. **HIGH — Empty queues strand the session UI**\n+    - **Files:** `ios/SATVocabApp/Sources/SATVocabApp/ViewModels/SessionFlowViewModel.swift:111-113`, `ios/SATVocabApp/Sources/SATVocabApp/Views/Flashcard/FlashcardStepView.swift:88-100`, `ios/SATVocabApp/Sources/SATVocabApp/Views/Game/ImageGameStepView.swift:34-55`, `ios/SATVocabApp/Sources/SATVocabApp/Views/Game/QuickRecallStepView.swift:33-53`\n+    - **Why:** Recovery/default sessions load no words at all, FlashcardStepView shows a dead-end “All caught up!” state, and ImageGame/QuickRecall step wrappers render a blank body when `roundCards`/`roundData` is empty.\n+    - **Fix:** Detect empty queues in the VM, either skip the step automatically or show an explicit recoverable empty state with a Continue action.\n+\n+11. **HIGH — SAT grading can use AI output instead of the canonical answer**\n+    - **File:** `ios/SATVocabApp/Sources/SATVocabApp/Views/Game/SATQuestionView.swift:23-43`\n+    - **Why:** `correctLetter` prefers `deepseekAnswer` over `question.answer` and falls back to `\"A\"` if parsing fails. That can misgrade a student even when the canonical answer exists.\n+    - **Fix:** Grade only against `question.answer` (or a validated normalized form of it). Treat missing/unparseable answers as an error state, not `\"A\"`.\n+\n+12. **MEDIUM — Actor isolation is undermined by a shared nonisolated SQLite handle**\n+    - **Files:** `ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift:4-8`, `ios/SATVocabApp/Sources/SATVocabApp/Data/StatsStore.swift:14-23`, `ios/SATVocabApp/Sources/SATVocabApp/Data/SessionStateStore.swift:4-9`, `ios/SATVocabApp/Sources/SATVocabApp/Data/ZoneStore.swift:4-9`\n+    - **Why:** Multiple actors share the same mutable `SQLiteDB` instance through `DataManager.shared.db`. That defeats actor serialization and makes correctness depend on SQLite runtime behavior instead of Swift concurrency guarantees.\n+    - **Fix:** Centralize DB access in one actor / serial executor or make the DB wrapper actor-isolated.\n+\n+13. **MEDIUM — Corrupted resume payloads are silently erased**\n+    - **File:** `ios/SATVocabApp/Sources/SATVocabApp/Data/SessionStateStore.swift:275-278`\n+    - **Why:** Bad JSON in `show_again_ids` / `requeued_ids` is converted to `[]` via `try?`, losing resume state without any signal.\n+    - **Fix:** Throw a decoding error or mark the session as invalid so corruption is visible.\n+\n+## Additional notes\n+\n+- **SQL injection:** I did **not** find a production SQL injection issue in the reviewed implementation. Runtime SQL is consistently parameterized; the only interpolation-heavy SQL I saw was in test helpers.\n+- **Retain cycles / leaks:** I did **not** find an obvious strong-reference cycle in the listed SwiftUI code. The main async risk is not leaking; it is stale delayed callbacks in `ImageGameView.swift:122-125` and `QuickRecallView.swift:77-80`, which should be cancellable if the view disappears.\n*** End Patch\n"
```

</details>

```
Added 1 file(s): /Users/jiong/myprojects/satspell/docs/reviews/code-review-implementation.md
```


---

<sub>⏱️ 9m 10s</sub>

### 💬 Copilot

I’ve written the review doc. I’m doing the final verification pass now: reading the finished file back and running the exact unit-test command you requested so the repro evidence in the review matches the repo’s current state.

---

<sub>⏱️ 9m 10s</sub>

### ✅ `skill`

**verification-before-completion**

<details>
<summary>Arguments</summary>

```json
{
  "skill": "verification-before-completion"
}
```

</details>

```
Skill "verification-before-completion" loaded successfully. Follow the instructions in the skill context.
```


---

<sub>⏱️ 9m 27s</sub>

### ✅ `bash`

**Run requested SATVocabAppTests command**

$ cd /Users/jiong/myprojects/satspell/ios/SATVocabApp && xcodebuild test -scheme SATVocabApp -destination 'platform=iOS Simulator,name=iPhone 17 Pro Max' -only-testing:SATVocabAppTests 2>&1 | grep -E 'Test Case|passed|failed|Executed'

<details>
<summary>89 lines</summary>

```
Ignoring --strip-bitcode because --sign was not passed
Ignoring --strip-bitcode because --sign was not passed
Test Case '-[SATVocabAppTests.ReviewLoggerTests testLogReviewWritesEntry]' started.
Test Case '-[SATVocabAppTests.ReviewLoggerTests testLogReviewWritesEntry]' passed (0.009 seconds).
Test Case '-[SATVocabAppTests.ReviewLoggerTests testSupersedeMarksEntriesAsSuperseded]' started.
Test Case '-[SATVocabAppTests.ReviewLoggerTests testSupersedeMarksEntriesAsSuperseded]' passed (0.017 seconds).
Test Suite 'ReviewLoggerTests' passed at 2026-04-12 17:30:44.022.
	 Executed 2 tests, with 0 failures (0 unexpected) in 0.026 (0.026) seconds
Test Case '-[SATVocabAppTests.SchemaTests testForeignKeysEnabled]' started.
Test Case '-[SATVocabAppTests.SchemaTests testForeignKeysEnabled]' passed (0.001 seconds).
Test Case '-[SATVocabAppTests.SchemaTests testSchemaCreatesAllTables]' started.
Test Case '-[SATVocabAppTests.SchemaTests testSchemaCreatesAllTables]' passed (0.001 seconds).
Test Case '-[SATVocabAppTests.SchemaTests testSchemaIsIdempotent]' started.
Test Case '-[SATVocabAppTests.SchemaTests testSchemaIsIdempotent]' passed (0.001 seconds).
Test Suite 'SchemaTests' passed at 2026-04-12 17:30:44.025.
	 Executed 3 tests, with 0 failures (0 unexpected) in 0.002 (0.003) seconds
Test Case '-[SATVocabAppTests.StatsStoreTests testFirstDayStreakIsOne]' started.
Test Case '-[SATVocabAppTests.StatsStoreTests testFirstDayStreakIsOne]' passed (0.003 seconds).
Test Case '-[SATVocabAppTests.StatsStoreTests testGetOrCreateDailyStats]' started.
Test Case '-[SATVocabAppTests.StatsStoreTests testGetOrCreateDailyStats]' passed (0.001 seconds).
Test Case '-[SATVocabAppTests.StatsStoreTests testRecordCorrectAddsXP]' started.
Test Case '-[SATVocabAppTests.StatsStoreTests testRecordCorrectAddsXP]' passed (0.002 seconds).
Test Case '-[SATVocabAppTests.StatsStoreTests testRecordWrongNoXP]' started.
Test Case '-[SATVocabAppTests.StatsStoreTests testRecordWrongNoXP]' passed (0.002 seconds).
Test Case '-[SATVocabAppTests.StatsStoreTests testSessionBonus]' started.
Test Case '-[SATVocabAppTests.StatsStoreTests testSessionBonus]' passed (0.002 seconds).
Test Case '-[SATVocabAppTests.StatsStoreTests testStreakMilestoneAt3Days]' started.
Test Case '-[SATVocabAppTests.StatsStoreTests testStreakMilestoneAt3Days]' passed (0.021 seconds).
Test Case '-[SATVocabAppTests.StatsStoreTests testStreakMilestoneClaimedOnlyOnce]' started.
Test Case '-[SATVocabAppTests.StatsStoreTests testStreakMilestoneClaimedOnlyOnce]' passed (0.003 seconds).
Test Case '-[SATVocabAppTests.StatsStoreTests testStreakResetsAfterMissedDay]' started.
Test Case '-[SATVocabAppTests.StatsStoreTests testStreakResetsAfterMissedDay]' passed (0.009 seconds).
Test Suite 'StatsStoreTests' passed at 2026-04-12 17:30:44.071.
	 Executed 8 tests, with 0 failures (0 unexpected) in 0.044 (0.046) seconds
Test Case '-[SATVocabAppTests.WordStateStoreTests testBoxDistributionCounts]' started.
Test Case '-[SATVocabAppTests.WordStateStoreTests testBoxDistributionCounts]' passed (0.003 seconds).
Test Case '-[SATVocabAppTests.WordStateStoreTests testCorrectAnswerAtBox5StaysAt5]' started.
Test Case '-[SATVocabAppTests.WordStateStoreTests testCorrectAnswerAtBox5StaysAt5]' passed (0.004 seconds).
Test Case '-[SATVocabAppTests.WordStateStoreTests testCorrectAnswerOnDay1WordDoesNotPromoteBoxBeforeEndOfEvening]' started.
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Tests/SATVocabAppTests/Data/WordStateStoreTests.swift:213: error: -[SATVocabAppTests.WordStateStoreTests testCorrectAnswerOnDay1WordDoesNotPromoteBoxBeforeEndOfEvening] : XCTAssertEqual failed: ("Optional(1)") is not equal to ("Optional(0)") - Day 1 scored answers should not move a new word out of box 0 before promotion is decided
Test Case '-[SATVocabAppTests.WordStateStoreTests testCorrectAnswerOnDay1WordDoesNotPromoteBoxBeforeEndOfEvening]' failed (0.049 seconds).
Test Case '-[SATVocabAppTests.WordStateStoreTests testCorrectAnswerPromotesBox]' started.
Test Case '-[SATVocabAppTests.WordStateStoreTests testCorrectAnswerPromotesBox]' passed (0.002 seconds).
Test Case '-[SATVocabAppTests.WordStateStoreTests testCorrectAnswerResetsConsecutiveWrong]' started.
Test Case '-[SATVocabAppTests.WordStateStoreTests testCorrectAnswerResetsConsecutiveWrong]' passed (0.002 seconds).
Test Case '-[SATVocabAppTests.WordStateStoreTests testDay1PromotionFailsWithOnlyOneCorrect]' started.
Test Case '-[SATVocabAppTests.WordStateStoreTests testDay1PromotionFailsWithOnlyOneCorrect]' passed (0.002 seconds).
Test Case '-[SATVocabAppTests.WordStateStoreTests testDay1PromotionFailsWithWrongFinalRecall]' started.
Test Case '-[SATVocabAppTests.WordStateStoreTests testDay1PromotionFailsWithWrongFinalRecall]' passed (0.002 seconds).
Test Case '-[SATVocabAppTests.WordStateStoreTests testDay1PromotionIgnoresPreviousStudyDays]' started.
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Tests/SATVocabAppTests/Data/WordStateStoreTests.swift:295: error: -[SATVocabAppTests.WordStateStoreTests testDay1PromotionIgnoresPreviousStudyDays] : XCTAssertEqual failed: ("1") is not equal to ("0") - Only the current study day should count toward Day 1 promotion
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Tests/SATVocabAppTests/Data/WordStateStoreTests.swift:296: error: -[SATVocabAppTests.WordStateStoreTests testDay1PromotionIgnoresPreviousStudyDays] : XCTAssertEqual failed: ("0") is not equal to ("1")
/Users/jiong/myprojects/satspell/ios/SATVocabApp/Tests/SATVocabAppTests/Data/WordStateStoreTests.swift:299: error: -[SATVocabAppTests.WordStateStoreTests testDay1PromotionIgnoresPreviousStudyDays] : XCTAssertEqual failed: ("Optional(2)") is not equal to ("Optional(1)") - Historical days should not promote today's word
Test Case '-[SATVocabAppTests.WordStateStoreTests testDay1PromotionIgnoresPreviousStudyDays]' failed (0.005 seconds).
Test Case '-[SATVocabAppTests.WordStateStoreTests testDay1PromotionWithTwoOfThreeCorrectAndCorrectFinal]' started.
Test Case '-[SATVocabAppTests.WordStateStoreTests testDay1PromotionWithTwoOfThreeCorrectAndCorrectFinal]' passed (0.002 seconds).
Test Case '-[SATVocabAppTests.WordStateStoreTests testEasyAtBox3WithHighAccuracyNoLapses]' started.
Test Case '-[SATVocabAppTests.WordStateStoreTests testEasyAtBox3WithHighAccuracyNoLapses]' passed (0.002 seconds).
Test Case '-[SATVocabAppTests.WordStateStoreTests testFragileAfter1Lapse]' started.
Test Case '-[SATVocabAppTests.WordStateStoreTests testFragileAfter1Lapse]' passed (0.001 seconds).
Test Case '-[SATVocabAppTests.WordStateStoreTests testIntroduceWordIsIdempotent]' started.
Test Case '-[SATVocabAppTests.WordStateStoreTests testIntroduceWordIsIdempotent]' passed (0.001 seconds).
Test Case '-[SATVocabAppTests.WordStateStoreTests testIntroduceWordSetsIntroStage1]' started.
Test Case '-[SATVocabAppTests.WordStateStoreTests testIntroduceWordSetsIntroStage1]' passed (0.005 seconds).
Test Case '-[SATVocabAppTests.WordStateStoreTests testOverdueCount]' started.
Test Case '-[SATVocabAppTests.WordStateStoreTests testOverdueCount]' passed (0.001 seconds).
Test Case '-[SATVocabAppTests.WordStateStoreTests testReviewQueueExcludesNotYetDue]' started.
Test Case '-[SATVocabAppTests.WordStateStoreTests testReviewQueueExcludesNotYetDue]' passed (0.001 seconds).
Test Case '-[SATVocabAppTests.WordStateStoreTests testReviewQueuePrioritizesBox1First]' started.
Test Case '-[SATVocabAppTests.WordStateStoreTests testReviewQueuePrioritizesBox1First]' passed (0.001 seconds).
Test Case '-[SATVocabAppTests.WordStateStoreTests testReviewQueuePrioritizesStubbornOverNormal]' started.
Test Case '-[SATVocabAppTests.WordStateStoreTests testReviewQueuePrioritizesStubbornOverNormal]' passed (0.001 seconds).
Test Case '-[SATVocabAppTests.WordStateStoreTests testStubbornAfter2ConsecutiveWrong]' started.
Test Case '-[SATVocabAppTests.WordStateStoreTests testStubbornAfter2ConsecutiveWrong]' passed (0.001 seconds).
Test Case '-[SATVocabAppTests.WordStateStoreTests testStubbornAfter3Lapses]' started.
Test Case '-[SATVocabAppTests.WordStateStoreTests testStubbornAfter3Lapses]' passed (0.002 seconds).
Test Case '-[SATVocabAppTests.WordStateStoreTests testWrongAnswerAtBox1StaysAtBox1]' started.
Test Case '-[SATVocabAppTests.WordStateStoreTests testWrongAnswerAtBox1StaysAtBox1]' passed (0.001 seconds).
Test Case '-[SATVocabAppTests.WordStateStoreTests testWrongAnswerIncrementsConsecutiveWrong]' started.
Test Case '-[SATVocabAppTests.WordStateStoreTests testWrongAnswerIncrementsConsecutiveWrong]' passed (0.002 seconds).
Test Case '-[SATVocabAppTests.WordStateStoreTests testWrongAnswerResetsToBox1]' started.
Test Case '-[SATVocabAppTests.WordStateStoreTests testWrongAnswerResetsToBox1]' passed (0.001 seconds).
Test Suite 'WordStateStoreTests' failed at 2026-04-12 17:30:44.166.
	 Executed 22 tests, with 4 failures (0 unexpected) in 0.092 (0.095) seconds
Test Suite 'SATVocabAppTests.xctest' failed at 2026-04-12 17:30:44.167.
	 Executed 35 tests, with 4 failures (0 unexpected) in 0.164 (0.171) seconds
Test Suite 'All tests' failed at 2026-04-12 17:30:44.167.
	 Executed 35 tests, with 4 failures (0 unexpected) in 0.164 (0.172) seconds
<exited with exit code 0>
```

</details>


---

<sub>⏱️ 9m 10s</sub>

### ✅ `view`

**view the file at /Users/jiong/myprojects/satspell/docs/reviews/code-review-implementation.md.**

/Users/jiong/myprojects/satspell/docs/reviews/code-review-implementation.md

<details>
<summary>81 lines</summary>

```
1. # Code Review — SAT Vocab iOS Implementation
2. 
3. ## Verified repro
4. 
5. - Baseline before adding repro tests: `SATVocabAppTests` passed (`33 tests, 0 failures`).
6. - Added two regression tests that now fail for the right reasons:
7.   - `WordStateStoreTests.swift:207-217` proves Day 1 scored answers incorrectly move new words out of box 0.
8.   - `WordStateStoreTests.swift:281-299` proves Day 1 promotion incorrectly counts previous `study_day` rows.
9. 
10. ## Findings
11. 
12. 1. **CRITICAL — Day 1 scoring corrupts box progression**
13.    - **File:** `ios/SATVocabApp/Sources/SATVocabApp/Data/WordStateStore.swift:176-208`
14.    - **Why:** `recordScoredAnswer()` promotes `box_level` from `0 -> 1` on the first correct scored answer and always assigns a due date. That contradicts `docs/data-schema.md` Section 5.12, where Day 1 words stay in box 0 until end-of-evening promotion.
15.    - **Fix:** Special-case box-0 intro words so scored Day 1 answers update accuracy/touches only; do not change `box_level`/`due_at` until `runDay1Promotion()`.
16. 
17. 2. **CRITICAL — Day 1 promotion counts historical reviews**
18.    - **File:** `ios/SATVocabApp/Sources/SATVocabApp/Data/WordStateStore.swift:275-303`
19.    - **Why:** Both the count query and “last recall” query ignore the `studyDay` argument, so prior days can satisfy today’s promotion threshold.
20.    - **Fix:** Add `AND study_day = ?` to both queries and bind `studyDay`.
21. 
22. 3. **CRITICAL — Resume flow destroys paused session state**
23.    - **Files:** `ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/PracticeTabView.swift:43-46`, `ios/SATVocabApp/Sources/SATVocabApp/ViewModels/SessionFlowViewModel.swift:92-99`, `ios/SATVocabApp/Sources/SATVocabApp/Data/SessionStateStore.swift:151-154`
24.    - **Why:** Tapping Resume only passes `sessionType`; `loadWords()` then calls `createSession()`, and `createSession()` uses `INSERT OR REPLACE`, wiping the saved `step_index`, `item_index`, `show_again_ids`, and `requeued_ids`.
25.    - **Fix:** Load the existing paused `session_state` instead of replacing it, and pass persisted resume state into the view model.
26. 
27. 4. **HIGH — Pause/resume is only implemented for flashcards**
28.    - **File:** `ios/SATVocabApp/Sources/SATVocabApp/Views/Session/SessionFlowView.swift:57-60,72,83,94`
29.    - **Why:** Flashcards call `vm.pause(...)`, but Image Game / Quick Recall / SAT just dismiss the view. Progress from scored steps is lost even though the UI presents them as pausable.
30.    - **Fix:** Wire all step views through the same pause persistence path and save current round state before dismissing.
31. 
32. 5. **HIGH — First-launch can get stuck in a permanently unseeded DB**
33.    - **Files:** `ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift:20-29,50-56`, `ios/SATVocabApp/Sources/SATVocabApp/ViewModels/PracticeTabViewModel.swift:22-45`
34.    - **Why:** `initializeIfNeeded()` treats “database file exists” as “content import succeeded.” If schema creation creates the file and import later fails, future launches skip import, `getDefaultList()` can keep failing, and `PracticeTabViewModel` silently falls back to `.morningAvailable`.
35.    - **Fix:** Validate seeded content (for example `lists`/`words` existence) before marking initialization complete, and surface initialization failure instead of masking it. Also seed the required Day 0 `day_state` row from `docs/data-schema.md` Section 5.1.
36. 
37. 6. **HIGH — Session load writes partial state before confirming content exists**
38.    - **File:** `ios/SATVocabApp/Sources/SATVocabApp/ViewModels/SessionFlowViewModel.swift:92-100`
39.    - **Why:** `loadWords()` creates `day_state`, `session_state`, and `daily_stats` before `getDefaultList()` or any queue fetch succeeds. A content/load failure leaves orphaned in-progress rows.
40.    - **Fix:** Fetch/validate content first, then create session/day/stats rows in one transactional step.
41. 
42. 7. **HIGH — Errors are swallowed after UI state is already mutated**
43.    - **Files:** `ios/SATVocabApp/Sources/SATVocabApp/ViewModels/SessionFlowViewModel.swift:135-175,182-219,225-232`
44.    - **Why:** XP, correct counts, completion state, and pause state are updated in memory before persistence finishes, and failures are silently ignored. The user can see progress that never actually saved.
45.    - **Fix:** Persist first or roll back UI state on failure, and surface a recoverable error to the view.
46. 
47. 8. **HIGH — Review queue and lifecycle logic do not match the schema spec**
48.    - **Files:** `ios/SATVocabApp/Sources/SATVocabApp/ViewModels/SessionFlowViewModel.swift:103-121`, `ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift:113-179`, `ios/SATVocabApp/Sources/SATVocabApp/Views/Practice/PracticeStateResolver.swift:3-58`
49.    - **Why:** The session VM loads sequential list words, discards the `word_state` review queue, and never implements recovery/re-entry/review-only flows. `fetchReviewQueue()` itself uses “latest incorrect review_log row” instead of `word_state.due_at` + box/memory priority from `docs/data-schema.md` Sections 5.3 and 6.
50.    - **Fix:** Drive review selection from `word_state`, and implement the missing recovery/back-pressure/session-type branches end to end.
51. 
52. 9. **HIGH — Legacy DataManager APIs still write incompatible rows and a nonexistent table**
53.    - **Files:** `ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift:290-448`, call sites in `ios/SATVocabApp/Sources/SATVocabApp/ViewModels/GameSessionViewModel.swift:128-190`, `ios/SATVocabApp/Sources/SATVocabApp/ViewModels/FlashcardSessionViewModel.swift:71-159`, `ios/SATVocabApp/Sources/SATVocabApp/ViewModels/ZoneReviewSessionViewModel.swift:52-79`
54.    - **Why:** `logReview()` omits `activity_type`, `session_type`, `study_day`, and `superseded`; `startSession()/finishSession()` omit `session_type`, `study_day`, and `xp_earned`; `progress_snapshot` APIs target a table not created by `SchemaV2`.
55.    - **Fix:** Remove or migrate the legacy APIs and move all call sites onto the V2 stores / schema.
56. 
57. 10. **HIGH — Empty queues strand the session UI**
58.     - **Files:** `ios/SATVocabApp/Sources/SATVocabApp/ViewModels/SessionFlowViewModel.swift:111-113`, `ios/SATVocabApp/Sources/SATVocabApp/Views/Flashcard/FlashcardStepView.swift:88-100`, `ios/SATVocabApp/Sources/SATVocabApp/Views/Game/ImageGameStepView.swift:34-55`, `ios/SATVocabApp/Sources/SATVocabApp/Views/Game/QuickRecallStepView.swift:33-53`
59.     - **Why:** Recovery/default sessions load no words at all, FlashcardStepView shows a dead-end “All caught up!” state, and ImageGame/QuickRecall step wrappers render a blank body when `roundCards`/`roundData` is empty.
60.     - **Fix:** Detect empty queues in the VM, either skip the step automatically or show an explicit recoverable empty state with a Continue action.
61. 
62. 11. **HIGH — SAT grading can use AI output instead of the canonical answer**
63.     - **File:** `ios/SATVocabApp/Sources/SATVocabApp/Views/Game/SATQuestionView.swift:23-43`
64.     - **Why:** `correctLetter` prefers `deepseekAnswer` over `question.answer` and falls back to `"A"` if parsing fails. That can misgrade a student even when the canonical answer exists.
65.     - **Fix:** Grade only against `question.answer` (or a validated normalized form of it). Treat missing/unparseable answers as an error state, not `"A"`.
66. 
67. 12. **MEDIUM — Actor isolation is undermined by a shared nonisolated SQLite handle**
68.     - **Files:** `ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift:4-8`, `ios/SATVocabApp/Sources/SATVocabApp/Data/StatsStore.swift:14-23`, `ios/SATVocabApp/Sources/SATVocabApp/Data/SessionStateStore.swift:4-9`, `ios/SATVocabApp/Sources/SATVocabApp/Data/ZoneStore.swift:4-9`
69.     - **Why:** Multiple actors share the same mutable `SQLiteDB` instance through `DataManager.shared.db`. That defeats actor serialization and makes correctness depend on SQLite runtime behavior instead of Swift concurrency guarantees.
70.     - **Fix:** Centralize DB access in one actor / serial executor or make the DB wrapper actor-isolated.
71. 
72. 13. **MEDIUM — Corrupted resume payloads are silently erased**
73.     - **File:** `ios/SATVocabApp/Sources/SATVocabApp/Data/SessionStateStore.swift:275-278`
74.     - **Why:** Bad JSON in `show_again_ids` / `requeued_ids` is converted to `[]` via `try?`, losing resume state without any signal.
75.     - **Fix:** Throw a decoding error or mark the session as invalid so corruption is visible.
76. 
77. ## Additional notes
78. 
79. - **SQL injection:** I did **not** find a production SQL injection issue in the reviewed implementation. Runtime SQL is consistently parameterized; the only interpolation-heavy SQL I saw was in test helpers.
80. - **Retain cycles / leaks:** I did **not** find an obvious strong-reference cycle in the listed SwiftUI code. The main async risk is not leaking; it is stale delayed callbacks in `ImageGameView.swift:122-125` and `QuickRecallView.swift:77-80`, which should be cancellable if the view disappears.
81.
```

</details>


---

<sub>⏱️ 9m 10s</sub>

### ✅ `sql`

**Complete deep review todos**

<details>
<summary>Arguments</summary>

```json
{
  "description": "Complete deep review todos",
  "query": "UPDATE todos SET status = 'done' WHERE id IN ('deep-review-data-layer','deep-review-ui-flow','deep-review-tests');\nUPDATE todos SET status = 'in_progress' WHERE id = 'write-deep-review';\nSELECT id, title, status FROM todos WHERE id IN ('deep-review-data-layer','deep-review-ui-flow','deep-review-tests','write-deep-review') ORDER BY created_at;"
}
```

</details>

<details>
<summary>13 lines</summary>

```
Executed 3 statement(s):

1. UPDATE
   3 row(s) updated.

2. UPDATE
   1 row(s) updated.

3. SELECT
   4 row(s) returned:
   
   | id | title | status |
   | --- | --- | --- |
   | deep-review-data-layer | Review data layer code | done |
   | deep-review-tests | Review and run tests | done |
   | deep-review-ui-flow | Review session and practice flow | done |
   | write-deep-review | Write implementation review doc | in_progress |
```

</details>


---

<sub>⏱️ 9m 42s</sub>

### ✅ `sql`

**Finish review todo**

<details>
<summary>Arguments</summary>

```json
{
  "description": "Finish review todo",
  "query": "UPDATE todos SET status = 'done' WHERE id = 'write-deep-review';\nSELECT id, title, status FROM todos WHERE id IN ('deep-review-data-layer','deep-review-ui-flow','deep-review-tests','write-deep-review') ORDER BY created_at;"
}
```

</details>

<details>
<summary>11 lines</summary>

```
Executed 2 statement(s):

1. UPDATE
   1 row(s) updated.

2. SELECT
   4 row(s) returned:
   
   | id | title | status |
   | --- | --- | --- |
   | deep-review-data-layer | Review data layer code | done |
   | deep-review-tests | Review and run tests | done |
   | deep-review-ui-flow | Review session and practice flow | done |
   | write-deep-review | Write implementation review doc | done |
```

</details>


---

<sub>⏱️ 9m 42s</sub>

### ✅ `store_memory`

<details>
<summary>Arguments</summary>

```json
{
  "subject": "testing command",
  "fact": "Run iOS unit tests with xcodebuild test -scheme SATVocabApp -destination 'platform=iOS Simulator,name=iPhone 17 Pro Max' -only-testing:SATVocabAppTests.",
  "citations": "User input: cd ios/SATVocabApp && xcodebuild test -scheme SATVocabApp -destination 'platform=iOS Simulator,name=iPhone 17 Pro Max' -only-testing:SATVocabAppTests 2>&1 | grep -E 'Test Case|passed|failed|Executed'; successful run in this session at 2026-04-12 17:23 and rerun at 2026-04-12 17:30.",
  "reason": "This is a verified project-specific test command that will be useful in future implementation, debugging, and code review tasks. Remembering the exact simulator target and scheme avoids rediscovering the working invocation and helps future verification stay consistent with the repository's current setup."
}
```

</details>

```
Memory stored successfully.
```


---

<sub>⏱️ 9m 57s</sub>

### 💬 Copilot

Wrote the full review to `docs/reviews/code-review-implementation.md` and added two repro tests in `ios/SATVocabApp/Tests/SATVocabAppTests/Data/WordStateStoreTests.swift`.

The highest-severity issues in the review are:
1. **Day 1 progression is wrong** — `recordScoredAnswer()` moves box-0 words immediately, and `runDay1Promotion()` counts prior `study_day` rows.
2. **Resume is broken** — starting a resumed session replaces the saved `session_state`, and scored-step pause exits don’t persist anything.
3. **First launch is brittle** — `initializeIfNeeded()` trusts file existence instead of successful seeding, so a partial import can strand the app.
4. **V2 lifecycle is only partially implemented** — review queues, recovery states, and several legacy `DataManager` APIs still don’t match `docs/data-schema.md`.

The requested `xcodebuild test -scheme SATVocabApp -destination 'platform=iOS Simulator,name=iPhone 17 Pro Max' -only-testing:SATVocabAppTests` run now reports **35 tests executed, 4 failures**. Those failures come from the two new regression tests and reproduce the Day 1 progression bugs called out in the review.

---

<sub>Generated by [GitHub Copilot CLI](https://github.com/features/copilot/cli)</sub>
