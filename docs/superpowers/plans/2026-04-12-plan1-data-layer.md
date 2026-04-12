# Plan 1: Data Layer + Content Import

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the SQLite data layer that all UI depends on — schema creation, JSON content import, word state management, review queue, box progression, and session state persistence.

**Architecture:** Extend the existing `DataManager` actor with new tables and methods. Content is imported from bundled JSON on first launch. All learning state (box levels, review logs, streaks) lives in local SQLite. Supabase auth deferred to Plan 3.

**Tech Stack:** Swift 5, SQLite3 (system framework), SwiftUI data flow (@Published, @StateObject)

**Reference docs:**
- `docs/data-schema.md` — table definitions, lifecycle, queries
- `docs/learning-model-design.md` — box progression, promotion rules
- `docs/content-delivery.md` — JSON import flow
- `docs/points-system.md` — XP calculation

---

### File Structure

```
ios/SATVocabApp/Sources/SATVocabApp/
├── Data/
│   ├── SQLite.swift              (existing — keep)
│   ├── DatabasePaths.swift       (existing — keep)
│   ├── DataManager.swift         (MODIFY — add new table creation + import)
│   ├── ContentImporter.swift     (CREATE — JSON → SQLite import logic)
│   ├── WordStateStore.swift      (CREATE — word_state CRUD + box progression)
│   ├── SessionStateStore.swift   (CREATE — session_state + day_state + pause/resume)
│   ├── StatsStore.swift          (CREATE — daily_stats, streak_store, XP)
│   ├── ZoneStore.swift           (CREATE — zone_state, unlock logic)
│   ├── ReviewQueue.swift         (CREATE — priority-sorted review queue)
│   ├── SchemaV2.swift            (CREATE — all CREATE TABLE SQL strings)
│   ├── AppConfig.swift           (MODIFY — add new config values)
│   ├── LocalIdentity.swift       (existing — keep)
│   ├── AdventureProgressStore.swift (existing — will be replaced by SessionStateStore in Plan 3)
│   └── TaskProgressStore.swift   (existing — will be removed in Plan 3)
├── Models/
│   ├── Models.swift              (MODIFY — add WordState, DayState, SessionState, etc.)
│   ├── AdventureSchedule.swift   (MODIFY — update zone/day math)
│   └── Enums.swift               (CREATE — SessionType, ActivityType, MemoryStatus, CardState)
```

---

### Task 1: Define New Model Types

**Files:**
- Create: `ios/SATVocabApp/Sources/SATVocabApp/Models/Enums.swift`
- Modify: `ios/SATVocabApp/Sources/SATVocabApp/Models/Models.swift`

- [ ] **Step 1: Create Enums.swift with all canonical enums**

```swift
// ios/SATVocabApp/Sources/SATVocabApp/Models/Enums.swift
import Foundation

enum SessionType: String, Codable, Identifiable {
    var id: String { rawValue }

    case morning
    case evening
    case recoveryEvening = "recovery_evening"
    case catchUp = "catch_up"
    case reEntry = "re_entry"
    case reviewOnly = "review_only"
    case zoneTest = "zone_test"
    case bonus
}

enum ActivityType: String, Codable {
    case imageGame = "image_game"
    case quickRecall = "quick_recall"
    case satQuestion = "sat_question"
    // flashcard NOT included — flashcards don't write to review_log in V1
}

enum MemoryStatus: String, Codable {
    case easy
    case normal
    case fragile
    case stubborn
}

enum CardState {
    case pending
    case current
    case completed
    case requeued
}

// Student-facing box labels (internal code uses box_level Int 0-5)
enum WordStrength: Int, CaseIterable {
    case notIntroduced = 0
    case lockedIn = 1      // Box 1 — review tomorrow
    case rising = 2         // Box 2 — review in 3 days
    case strong = 3         // Box 3 — review in 7 days
    case solid = 4          // Box 4 — review in 14 days
    case mastered = 5       // Box 5 — no review needed

    var label: String {
        switch self {
        case .notIntroduced: return ""
        case .lockedIn: return "Locked In"
        case .rising: return "Rising"
        case .strong: return "Strong"
        case .solid: return "Solid"
        case .mastered: return "Mastered"
        }
    }

    var reviewIntervalDays: Int? {
        switch self {
        case .notIntroduced: return nil
        case .lockedIn: return 1
        case .rising: return 3
        case .strong: return 7
        case .solid: return 14
        case .mastered: return nil  // no review
        }
    }

    var color: String {  // hex colors
        switch self {
        case .notIntroduced: return "#E8ECF0"
        case .lockedIn: return "#FF7043"
        case .rising: return "#FFAB40"
        case .strong: return "#FFC800"
        case .solid: return "#89E219"
        case .mastered: return "#58CC02"
        }
    }
}
```

- [ ] **Step 2: Add new model structs to Models.swift**

Add to end of `ios/SATVocabApp/Sources/SATVocabApp/Models/Models.swift`:

```swift
// MARK: - Learning State Models

struct WordState: Identifiable, Hashable {
    let id: Int
    let userId: String
    let wordId: Int
    var boxLevel: Int           // 0-5
    var dueAt: Date?
    var introStage: Int         // 0=not introduced, 1=morning seen, 2=evening recall, 3=decided
    var memoryStatus: MemoryStatus
    var lapseCount: Int
    var consecutiveWrong: Int
    var totalCorrect: Int
    var totalSeen: Int
    var dayTouches: Int
    var recentAccuracy: Double
    var lastReviewedAt: Date?

    var strength: WordStrength {
        WordStrength(rawValue: boxLevel) ?? .notIntroduced
    }
}

struct DayState: Identifiable, Hashable {
    let id: Int
    let userId: String
    let studyDay: Int
    let zoneIndex: Int
    var morningComplete: Bool
    var eveningComplete: Bool
    var morningCompleteAt: Date?
    var eveningCompleteAt: Date?
    var newWordsMorning: Int
    var newWordsEvening: Int
    var morningAccuracy: Double
    var eveningAccuracy: Double
    var morningXP: Int
    var eveningXP: Int
    var isRecoveryDay: Bool
    var isReviewOnlyDay: Bool
}

struct SessionState: Identifiable, Hashable {
    let id: Int
    let userId: String
    let sessionType: SessionType
    let studyDay: Int
    var stepIndex: Int
    var itemIndex: Int
    var isPaused: Bool
    var showAgainIds: [Int]     // word IDs from Show Again (Step 1 → Step 2)
    var requeuedIds: [Int]      // word IDs requeued within current step
    var startedAt: Date?
    var pausedAt: Date?
    var completedAt: Date?
}

struct DailyStats: Identifiable, Hashable {
    let id: Int
    let userId: String
    let studyDay: Int
    let calendarDate: String    // YYYY-MM-DD
    var newCount: Int
    var reviewCount: Int
    var correctCount: Int
    var totalCount: Int
    var xpEarned: Int
    var sessionBonus: Int
    var studyMinutes: Double
    var wordsPromoted: Int
    var wordsDemoted: Int
}

struct StreakInfo: Hashable {
    var currentStreak: Int
    var bestStreak: Int
    var lastStudyDate: String?  // YYYY-MM-DD
    var totalXP: Int
    var totalStudyDays: Int
    var streak3Claimed: Bool
    var streak7Claimed: Bool
    var streak14Claimed: Bool
    var streak30Claimed: Bool
}

struct ZoneState: Identifiable, Hashable {
    let id: Int
    let userId: String
    let zoneIndex: Int
    var unlocked: Bool
    var testPassed: Bool
    var testAttempts: Int
    var testBestScore: Double
}
```

- [ ] **Step 3: Verify build**

Run: `cd ios/SATVocabApp && xcodegen generate && xcodebuild -scheme SATVocabApp -destination 'platform=iOS Simulator,name=iPhone 16 Pro' build 2>&1 | tail -5`
Expected: BUILD SUCCEEDED

- [ ] **Step 4: Commit**

```bash
git add ios/SATVocabApp/Sources/SATVocabApp/Models/Enums.swift ios/SATVocabApp/Sources/SATVocabApp/Models/Models.swift
git commit -m "feat: add learning model types (WordState, DayState, SessionState, enums)"
```

---

### Task 2: Create Schema V2 (DDL)

**Files:**
- Create: `ios/SATVocabApp/Sources/SATVocabApp/Data/SchemaV2.swift`

- [ ] **Step 1: Create SchemaV2.swift with all CREATE TABLE statements**

```swift
// ios/SATVocabApp/Sources/SATVocabApp/Data/SchemaV2.swift
import Foundation

enum SchemaV2 {
    /// All CREATE TABLE statements for the V2 schema.
    /// Existing tables (words, lists, word_list, etc.) are created by content import.
    /// These are the NEW tables for learning state.
    static let createStatements: [String] = [
        // -- Content tables (populated from JSON import) --
        """
        CREATE TABLE IF NOT EXISTS lists (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL UNIQUE,
            description TEXT,
            version INTEGER DEFAULT 1
        );
        """,
        """
        CREATE TABLE IF NOT EXISTS words (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            lemma TEXT NOT NULL,
            pos TEXT,
            definition TEXT,
            example TEXT,
            image_filename TEXT
        );
        """,
        """
        CREATE TABLE IF NOT EXISTS word_list (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            word_id INTEGER NOT NULL REFERENCES words(id),
            list_id INTEGER NOT NULL REFERENCES lists(id),
            rank INTEGER
        );
        """,
        """
        CREATE TABLE IF NOT EXISTS sat_contexts (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            word_id INTEGER NOT NULL REFERENCES words(id),
            context TEXT NOT NULL
        );
        """,
        """
        CREATE TABLE IF NOT EXISTS collocations (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            word_id INTEGER NOT NULL REFERENCES words(id),
            phrase TEXT NOT NULL
        );
        """,
        """
        CREATE TABLE IF NOT EXISTS sat_question_bank (
            id TEXT PRIMARY KEY,
            word_id INTEGER,
            target_word TEXT,
            section TEXT,
            module INTEGER,
            q_type TEXT,
            passage TEXT,
            question TEXT,
            option_a TEXT,
            option_b TEXT,
            option_c TEXT,
            option_d TEXT,
            answer TEXT,
            source_pdf TEXT,
            page INTEGER,
            feedback_generated INTEGER DEFAULT 0,
            answer_verified INTEGER DEFAULT 0
        );
        """,
        """
        CREATE TABLE IF NOT EXISTS word_questions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            word_id INTEGER NOT NULL REFERENCES words(id),
            question_id TEXT NOT NULL REFERENCES sat_question_bank(id)
        );
        """,
        """
        CREATE TABLE IF NOT EXISTS deepseek_sat_feedback (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            question_id TEXT REFERENCES sat_question_bank(id),
            ai_source TEXT,
            answer TEXT,
            background TEXT,
            reason_for_answer TEXT,
            created_at TEXT
        );
        """,

        // -- User tables --
        """
        CREATE TABLE IF NOT EXISTS users (
            id TEXT PRIMARY KEY,
            email TEXT,
            supabase_uid TEXT,
            display_name TEXT,
            created_at TEXT DEFAULT (datetime('now'))
        );
        """,

        // -- Learning state tables (NEW) --
        """
        CREATE TABLE IF NOT EXISTS word_state (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id TEXT NOT NULL REFERENCES users(id),
            word_id INTEGER NOT NULL REFERENCES words(id),
            box_level INTEGER NOT NULL DEFAULT 0,
            due_at TEXT,
            intro_stage INTEGER DEFAULT 0,
            memory_status TEXT DEFAULT 'normal',
            lapse_count INTEGER DEFAULT 0,
            consecutive_wrong INTEGER DEFAULT 0,
            total_correct INTEGER DEFAULT 0,
            total_seen INTEGER DEFAULT 0,
            day_touches INTEGER DEFAULT 0,
            recent_accuracy REAL DEFAULT 0,
            last_reviewed_at TEXT,
            created_at TEXT DEFAULT (datetime('now')),
            updated_at TEXT DEFAULT (datetime('now')),
            UNIQUE(user_id, word_id)
        );
        """,
        """
        CREATE TABLE IF NOT EXISTS day_state (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id TEXT NOT NULL REFERENCES users(id),
            study_day INTEGER NOT NULL,
            zone_index INTEGER NOT NULL,
            morning_complete INTEGER DEFAULT 0,
            evening_complete INTEGER DEFAULT 0,
            morning_complete_at TEXT,
            evening_complete_at TEXT,
            new_words_morning INTEGER DEFAULT 0,
            new_words_evening INTEGER DEFAULT 0,
            morning_accuracy REAL DEFAULT 0,
            evening_accuracy REAL DEFAULT 0,
            morning_xp INTEGER DEFAULT 0,
            evening_xp INTEGER DEFAULT 0,
            is_recovery_day INTEGER DEFAULT 0,
            is_review_only_day INTEGER DEFAULT 0,
            created_at TEXT DEFAULT (datetime('now')),
            UNIQUE(user_id, study_day)
        );
        """,
        """
        CREATE TABLE IF NOT EXISTS session_state (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id TEXT NOT NULL REFERENCES users(id),
            session_type TEXT NOT NULL,
            study_day INTEGER NOT NULL,
            step_index INTEGER DEFAULT 0,
            item_index INTEGER DEFAULT 0,
            is_paused INTEGER DEFAULT 0,
            show_again_ids TEXT,
            requeued_ids TEXT,
            started_at TEXT,
            paused_at TEXT,
            completed_at TEXT,
            UNIQUE(user_id, study_day, session_type)
        );
        """,
        """
        CREATE TABLE IF NOT EXISTS review_log (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id TEXT NOT NULL REFERENCES users(id),
            word_id INTEGER NOT NULL REFERENCES words(id),
            list_id INTEGER,
            outcome TEXT NOT NULL,
            duration_ms INTEGER,
            reviewed_at TEXT NOT NULL,
            device_id TEXT,
            activity_type TEXT,
            session_type TEXT,
            study_day INTEGER,
            superseded INTEGER DEFAULT 0
        );
        """,
        """
        CREATE TABLE IF NOT EXISTS session (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id TEXT NOT NULL,
            list_id INTEGER,
            started_at TEXT,
            ended_at TEXT,
            items_total INTEGER,
            items_correct INTEGER DEFAULT 0,
            session_type TEXT,
            study_day INTEGER,
            xp_earned INTEGER DEFAULT 0
        );
        """,
        """
        CREATE TABLE IF NOT EXISTS daily_stats (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id TEXT NOT NULL REFERENCES users(id),
            study_day INTEGER NOT NULL,
            calendar_date TEXT NOT NULL,
            new_count INTEGER DEFAULT 0,
            review_count INTEGER DEFAULT 0,
            correct_count INTEGER DEFAULT 0,
            total_count INTEGER DEFAULT 0,
            xp_earned INTEGER DEFAULT 0,
            session_bonus INTEGER DEFAULT 0,
            study_minutes REAL DEFAULT 0,
            words_promoted INTEGER DEFAULT 0,
            words_demoted INTEGER DEFAULT 0,
            UNIQUE(user_id, study_day)
        );
        """,
        """
        CREATE TABLE IF NOT EXISTS streak_store (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id TEXT NOT NULL REFERENCES users(id),
            current_streak INTEGER DEFAULT 0,
            best_streak INTEGER DEFAULT 0,
            last_study_date TEXT,
            streak_3_claimed INTEGER DEFAULT 0,
            streak_7_claimed INTEGER DEFAULT 0,
            streak_14_claimed INTEGER DEFAULT 0,
            streak_30_claimed INTEGER DEFAULT 0,
            total_xp INTEGER DEFAULT 0,
            total_study_days INTEGER DEFAULT 0,
            UNIQUE(user_id)
        );
        """,
        """
        CREATE TABLE IF NOT EXISTS zone_state (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id TEXT NOT NULL REFERENCES users(id),
            zone_index INTEGER NOT NULL,
            unlocked INTEGER DEFAULT 0,
            test_passed INTEGER DEFAULT 0,
            test_attempts INTEGER DEFAULT 0,
            test_best_score REAL DEFAULT 0,
            unlocked_at TEXT,
            UNIQUE(user_id, zone_index)
        );
        """,
    ]

    /// Indexes for performance
    static let createIndexes: [String] = [
        "CREATE INDEX IF NOT EXISTS idx_word_state_due ON word_state(user_id, due_at);",
        "CREATE INDEX IF NOT EXISTS idx_word_state_box ON word_state(user_id, box_level);",
        "CREATE INDEX IF NOT EXISTS idx_word_state_status ON word_state(user_id, memory_status);",
        "CREATE INDEX IF NOT EXISTS idx_day_state_user ON day_state(user_id, study_day DESC);",
        "CREATE INDEX IF NOT EXISTS idx_daily_stats_date ON daily_stats(user_id, calendar_date DESC);",
        "CREATE INDEX IF NOT EXISTS idx_review_log_word ON review_log(word_id, user_id, reviewed_at DESC);",
        "CREATE INDEX IF NOT EXISTS idx_review_log_day ON review_log(user_id, study_day);",
        "CREATE INDEX IF NOT EXISTS idx_review_log_scored ON review_log(user_id, word_id, activity_type, superseded, reviewed_at DESC);",
        "CREATE INDEX IF NOT EXISTS idx_word_list_rank ON word_list(list_id, rank);",
        "CREATE INDEX IF NOT EXISTS idx_sat_contexts_word ON sat_contexts(word_id);",
        "CREATE INDEX IF NOT EXISTS idx_collocations_word ON collocations(word_id);",
        "CREATE INDEX IF NOT EXISTS idx_word_questions_word ON word_questions(word_id);",
        "CREATE UNIQUE INDEX IF NOT EXISTS idx_word_questions_unique ON word_questions(word_id, question_id);",
    ]

    /// Run all schema creation
    static func createAll(db: SQLiteDB) throws {
        try db.exec("PRAGMA foreign_keys = ON;")
        for sql in createStatements {
            try db.exec(sql)
        }
        for sql in createIndexes {
            try db.exec(sql)
        }
    }
}
```

- [ ] **Step 2: Verify build**

Run: `cd ios/SATVocabApp && xcodebuild -scheme SATVocabApp -destination 'platform=iOS Simulator,name=iPhone 16 Pro' build 2>&1 | tail -5`
Expected: BUILD SUCCEEDED

- [ ] **Step 3: Commit**

```bash
git add ios/SATVocabApp/Sources/SATVocabApp/Data/SchemaV2.swift
git commit -m "feat: add V2 schema DDL (all CREATE TABLE + indexes)"
```

---

### Task 3: Content Importer (JSON → SQLite)

**Files:**
- Create: `ios/SATVocabApp/Sources/SATVocabApp/Data/ContentImporter.swift`

- [ ] **Step 1: Create ContentImporter.swift**

```swift
// ios/SATVocabApp/Sources/SATVocabApp/Data/ContentImporter.swift
import Foundation
import SQLite3

/// Imports bundled word_list.json and sat_reading_questions into SQLite.
/// Called once on first launch. Runs in a single transaction for speed (~2-3s).
actor ContentImporter {

    private let db: SQLiteDB

    init(db: SQLiteDB) {
        self.db = db
    }

    func importBundledContent() throws {
        // 1. Load JSON from bundle
        guard let wordListURL = Bundle.main.url(forResource: "word_list", withExtension: "json"),
              let wordListData = try? Data(contentsOf: wordListURL)
        else { throw ImportError.missingFile("word_list.json") }

        guard let satURL = Bundle.main.url(forResource: "sat_reading_questions_deduplicated", withExtension: "json"),
              let satData = try? Data(contentsOf: satURL)
        else { throw ImportError.missingFile("sat_reading_questions_deduplicated.json") }

        let words = try JSONSerialization.jsonObject(with: wordListData) as? [[String: Any]] ?? []
        let satQuestions = try JSONSerialization.jsonObject(with: satData) as? [[String: Any]] ?? []

        guard !words.isEmpty else { throw ImportError.emptyData("word_list.json") }

        // 2. Import in transaction
        try db.exec("BEGIN TRANSACTION;")

        // Create list
        try db.exec("INSERT INTO lists (name, description, version) VALUES ('sat_core_1', 'SAT Core Vocabulary', 1);")
        let listId = Int(db.lastInsertRowId())

        // Import words
        for (rank, wordDict) in words.enumerated() {
            let word = wordDict["word"] as? String ?? ""
            let pos = wordDict["pos"] as? String
            let definition = wordDict["definition"] as? String
            let example = wordDict["example"] as? String
            let imageFilename = word.replacingOccurrences(of: " ", with: "_") + ".jpg"

            try insertWord(word: word, pos: pos, definition: definition,
                          example: example, imageFilename: imageFilename,
                          listId: listId, rank: rank, wordDict: wordDict)
        }

        // Import standalone SAT questions
        for q in satQuestions {
            try insertSatQuestion(q)
        }

        try db.exec("COMMIT;")
    }

    private func insertWord(word: String, pos: String?, definition: String?,
                           example: String?, imageFilename: String,
                           listId: Int, rank: Int, wordDict: [String: Any]) throws {
        // Insert word
        let stmt = try db.prepare(
            "INSERT INTO words (lemma, pos, definition, example, image_filename) VALUES (?,?,?,?,?)")
        defer { stmt?.finalize() }
        try SQLiteDB.bind(stmt, 1, word)
        try SQLiteDB.bind(stmt, 2, pos)
        try SQLiteDB.bind(stmt, 3, definition)
        try SQLiteDB.bind(stmt, 4, example)
        try SQLiteDB.bind(stmt, 5, imageFilename)
        guard sqlite3_step(stmt) == SQLITE_DONE else {
            throw ImportError.insertFailed("word: \(word)")
        }
        let wordId = Int(db.lastInsertRowId())

        // word_list mapping
        try db.exec("INSERT INTO word_list (word_id, list_id, rank) VALUES (\(wordId), \(listId), \(rank));")

        // SAT contexts
        if let contexts = wordDict["sat_context"] as? [String] {
            for ctx in contexts where !ctx.isEmpty {
                let s = try db.prepare("INSERT INTO sat_contexts (word_id, context) VALUES (?,?)")
                defer { s?.finalize() }
                try SQLiteDB.bind(s, 1, wordId)
                try SQLiteDB.bind(s, 2, ctx)
                _ = sqlite3_step(s)
            }
        }

        // Collocations
        if let collocations = wordDict["collocation"] as? [String] {
            for col in collocations where !col.isEmpty {
                let s = try db.prepare("INSERT INTO collocations (word_id, phrase) VALUES (?,?)")
                defer { s?.finalize() }
                try SQLiteDB.bind(s, 1, wordId)
                try SQLiteDB.bind(s, 2, col)
                _ = sqlite3_step(s)
            }
        }

        // Embedded SAT questions
        if let questions = wordDict["sat_questions"] as? [[String: Any]] {
            for q in questions {
                try insertSatQuestion(q)
                let qId = q["id"] as? String ?? ""
                if !qId.isEmpty {
                    try db.exec("INSERT OR IGNORE INTO word_questions (word_id, question_id) VALUES (\(wordId), '\(qId)');")
                }
            }
        }
    }

    private func insertSatQuestion(_ q: [String: Any]) throws {
        let qId = q["id"] as? String ?? ""
        guard !qId.isEmpty else { return }

        // Options can be dict {"A":"..","B":".."} or array ["..",".."]
        var optA: String?, optB: String?, optC: String?, optD: String?
        if let opts = q["options"] as? [String: String] {
            optA = opts["A"]; optB = opts["B"]; optC = opts["C"]; optD = opts["D"]
        } else if let opts = q["options"] as? [String], opts.count >= 4 {
            optA = opts[0]; optB = opts[1]; optC = opts[2]; optD = opts[3]
        }

        let stmt = try db.prepare("""
            INSERT OR IGNORE INTO sat_question_bank
            (id, section, module, q_type, passage, question,
             option_a, option_b, option_c, option_d, answer, source_pdf, page)
            VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)
        """)
        defer { stmt?.finalize() }

        try SQLiteDB.bind(stmt, 1, qId)
        try SQLiteDB.bind(stmt, 2, q["section"] as? String)
        try SQLiteDB.bind(stmt, 3, q["module"] as? Int)
        try SQLiteDB.bind(stmt, 4, q["type"] as? String)
        try SQLiteDB.bind(stmt, 5, q["passage"] as? String)
        try SQLiteDB.bind(stmt, 6, q["question"] as? String)
        try SQLiteDB.bind(stmt, 7, optA)
        try SQLiteDB.bind(stmt, 8, optB)
        try SQLiteDB.bind(stmt, 9, optC)
        try SQLiteDB.bind(stmt, 10, optD)
        try SQLiteDB.bind(stmt, 11, q["answer"] as? String)
        try SQLiteDB.bind(stmt, 12, q["source_pdf"] as? String)
        try SQLiteDB.bind(stmt, 13, q["page"] as? Int)
        _ = sqlite3_step(stmt)
    }

    enum ImportError: Error, CustomStringConvertible {
        case missingFile(String)
        case emptyData(String)
        case insertFailed(String)

        var description: String {
            switch self {
            case .missingFile(let f): return "Missing bundled file: \(f)"
            case .emptyData(let f): return "Empty data in: \(f)"
            case .insertFailed(let m): return "Insert failed: \(m)"
            }
        }
    }
}
```

- [ ] **Step 2: Update DataManager.initializeIfNeeded() to use new schema + import**

In `DataManager.swift`, change `private let db` to `let db` (internal access) so the new store classes can access it:

```swift
// Change from:
private let db = SQLiteDB()
// To:
let db = SQLiteDB()
```

Then replace the `initializeIfNeeded()` method:

```swift
func initializeIfNeeded() throws {
    if isInitialized { return }

    let writableURL = try DatabasePaths.writableDatabaseURL()
    let isFirstLaunch = !FileManager.default.fileExists(atPath: writableURL.path)

    try db.open(path: writableURL.path)

    if isFirstLaunch {
        // First launch: create schema + import content
        try SchemaV2.createAll(db: db)
        let importer = ContentImporter(db: db)
        try await importer.importBundledContent()

        // Create default user
        let userId = LocalIdentity.userId()
        try ensureUserExists(userId: userId)

        // Initialize streak + zone
        try db.exec("INSERT INTO streak_store (user_id) VALUES ('\(userId)');")
        try db.exec("INSERT INTO zone_state (user_id, zone_index, unlocked) VALUES ('\(userId)', 0, 1);")
        try db.exec("INSERT INTO day_state (user_id, study_day, zone_index) VALUES ('\(userId)', 0, 0);")
    }

    isInitialized = true
}
```

- [ ] **Step 3: Add word_list.json and sat questions JSON to Xcode bundle resources**

Update `ios/SATVocabApp/project.yml` to include JSON files in resources:

```yaml
# Add under sources → resources
- path: ../../word_list.json
  buildPhase: resources
- path: ../../sat_reading_questions_deduplicated.json
  buildPhase: resources
```

- [ ] **Step 4: Verify build and first-launch import**

Run app in simulator. Check console for import errors. Verify:
```swift
// Quick verification query
let count = try countWordsInList(listId: 1)
assert(count == 372, "Expected 372 words, got \(count)")
```

- [ ] **Step 5: Commit**

```bash
git add ios/SATVocabApp/Sources/SATVocabApp/Data/ContentImporter.swift ios/SATVocabApp/Sources/SATVocabApp/Data/DataManager.swift ios/SATVocabApp/project.yml
git commit -m "feat: first-launch content import (JSON → SQLite, 372 words + SAT questions)"
```

---

### Task 4: WordStateStore (Box Progression + Review Queue)

**Files:**
- Create: `ios/SATVocabApp/Sources/SATVocabApp/Data/WordStateStore.swift`

- [ ] **Step 1: Create WordStateStore.swift**

```swift
// ios/SATVocabApp/Sources/SATVocabApp/Data/WordStateStore.swift
import Foundation
import SQLite3

/// Manages word_state table: box progression, memory status, review queue.
/// Reference: docs/data-schema.md Section 5.5, 5.6, 5.7, 5.8, 5.12
actor WordStateStore {
    private let db: SQLiteDB

    init(db: SQLiteDB) { self.db = db }

    // MARK: - Read

    /// Get word state for a specific word. Returns nil if not yet introduced.
    func getWordState(userId: String, wordId: Int) throws -> WordState? {
        let sql = """
        SELECT id, user_id, word_id, box_level, due_at, intro_stage, memory_status,
               lapse_count, consecutive_wrong, total_correct, total_seen, day_touches,
               recent_accuracy, last_reviewed_at
        FROM word_state WHERE user_id = ? AND word_id = ?
        """
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }
        try SQLiteDB.bind(stmt, 1, userId)
        try SQLiteDB.bind(stmt, 2, wordId)
        guard sqlite3_step(stmt) == SQLITE_ROW else { return nil }
        return parseWordState(stmt)
    }

    /// Priority-sorted review queue: box 1 first, then memory_status priority, then oldest due.
    /// Reference: docs/data-schema.md Section 6 "Get Review Queue"
    func getReviewQueue(userId: String, limit: Int) throws -> [WordState] {
        let sql = """
        SELECT id, user_id, word_id, box_level, due_at, intro_stage, memory_status,
               lapse_count, consecutive_wrong, total_correct, total_seen, day_touches,
               recent_accuracy, last_reviewed_at
        FROM word_state
        WHERE user_id = ? AND due_at <= datetime('now') AND box_level > 0
        ORDER BY
            box_level ASC,
            CASE memory_status
                WHEN 'stubborn' THEN 0 WHEN 'fragile' THEN 1
                WHEN 'normal' THEN 2 WHEN 'easy' THEN 3
            END ASC,
            due_at ASC
        LIMIT ?
        """
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }
        try SQLiteDB.bind(stmt, 1, userId)
        try SQLiteDB.bind(stmt, 2, limit)
        var results: [WordState] = []
        while sqlite3_step(stmt) == SQLITE_ROW {
            results.append(parseWordState(stmt))
        }
        return results
    }

    /// Count overdue words (for back-pressure detection)
    func countOverdue(userId: String) throws -> Int {
        let sql = "SELECT COUNT(*) FROM word_state WHERE user_id = ? AND due_at <= datetime('now') AND box_level > 0"
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }
        try SQLiteDB.bind(stmt, 1, userId)
        guard sqlite3_step(stmt) == SQLITE_ROW else { return 0 }
        return SQLiteDB.columnInt(stmt, 0)
    }

    /// Box distribution for Stats tab
    func getBoxDistribution(userId: String) throws -> [Int: Int] {
        let sql = "SELECT box_level, COUNT(*) FROM word_state WHERE user_id = ? AND box_level > 0 GROUP BY box_level"
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }
        try SQLiteDB.bind(stmt, 1, userId)
        var result: [Int: Int] = [:]
        while sqlite3_step(stmt) == SQLITE_ROW {
            result[SQLiteDB.columnInt(stmt, 0)] = SQLiteDB.columnInt(stmt, 1)
        }
        return result
    }

    /// Words Fighting Back (stubborn words)
    func getStubbornWords(userId: String, limit: Int = 5) throws -> [(lemma: String, pos: String?, lapseCount: Int, boxLevel: Int)] {
        let sql = """
        SELECT w.lemma, w.pos, ws.lapse_count, ws.box_level
        FROM word_state ws JOIN words w ON w.id = ws.word_id
        WHERE ws.user_id = ? AND ws.memory_status = 'stubborn'
        ORDER BY ws.lapse_count DESC LIMIT ?
        """
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }
        try SQLiteDB.bind(stmt, 1, userId)
        try SQLiteDB.bind(stmt, 2, limit)
        var results: [(String, String?, Int, Int)] = []
        while sqlite3_step(stmt) == SQLITE_ROW {
            results.append((
                SQLiteDB.columnText(stmt, 0) ?? "",
                SQLiteDB.columnText(stmt, 1),
                SQLiteDB.columnInt(stmt, 2),
                SQLiteDB.columnInt(stmt, 3)
            ))
        }
        return results
    }

    // MARK: - Write

    /// Introduce a word (first time seen in flashcard). Sets intro_stage = 1.
    func introduceWord(userId: String, wordId: Int) throws {
        let sql = """
        INSERT INTO word_state (user_id, word_id, box_level, intro_stage, total_seen)
        VALUES (?, ?, 0, 1, 1)
        ON CONFLICT(user_id, word_id) DO UPDATE SET
            intro_stage = MAX(intro_stage, 1),
            total_seen = total_seen + 1,
            updated_at = datetime('now')
        """
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }
        try SQLiteDB.bind(stmt, 1, userId)
        try SQLiteDB.bind(stmt, 2, wordId)
        _ = sqlite3_step(stmt)
    }

    /// Record a scored answer. Updates word_state + returns box change info.
    /// Reference: docs/data-schema.md Section 5.5
    func recordScoredAnswer(userId: String, wordId: Int, correct: Bool) throws -> BoxChange {
        guard var ws = try getWordState(userId: userId, wordId: wordId) else {
            // Word not in word_state yet — shouldn't happen for scored events, but handle gracefully
            try introduceWord(userId: userId, wordId: wordId)
            return .none
        }

        let oldBox = ws.boxLevel
        ws.totalSeen += 1
        ws.dayTouches += 1

        if correct {
            ws.totalCorrect += 1
            ws.consecutiveWrong = 0
            if ws.boxLevel > 0 {
                ws.boxLevel = min(ws.boxLevel + 1, 5)
            }
        } else {
            ws.consecutiveWrong += 1
            if ws.boxLevel > 1 {
                ws.lapseCount += 1
            }
            if ws.boxLevel > 0 {
                ws.boxLevel = 1
            }
        }

        // Recalculate recent_accuracy
        ws.recentAccuracy = try computeRecentAccuracy(userId: userId, wordId: wordId)

        // Reclassify memory_status
        ws.memoryStatus = classifyMemoryStatus(ws)

        // Calculate due_at
        let dueAt: Date?
        if let interval = WordStrength(rawValue: ws.boxLevel)?.reviewIntervalDays {
            dueAt = Calendar.current.date(byAdding: .day, value: interval, to: Date())
        } else {
            dueAt = nil  // mastered or not introduced
        }

        // Update database
        let iso = ISO8601DateFormatter()
        let dueAtStr = dueAt.map { iso.string(from: $0) }
        let nowStr = iso.string(from: Date())

        let sql = """
        UPDATE word_state SET
            box_level = ?, due_at = ?, intro_stage = ?, memory_status = ?,
            lapse_count = ?, consecutive_wrong = ?, total_correct = ?,
            total_seen = ?, day_touches = ?, recent_accuracy = ?,
            last_reviewed_at = ?, updated_at = datetime('now')
        WHERE user_id = ? AND word_id = ?
        """
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }
        try SQLiteDB.bind(stmt, 1, ws.boxLevel)
        try SQLiteDB.bind(stmt, 2, dueAtStr)
        try SQLiteDB.bind(stmt, 3, ws.introStage)
        try SQLiteDB.bind(stmt, 4, ws.memoryStatus.rawValue)
        try SQLiteDB.bind(stmt, 5, ws.lapseCount)
        try SQLiteDB.bind(stmt, 6, ws.consecutiveWrong)
        try SQLiteDB.bind(stmt, 7, ws.totalCorrect)
        try SQLiteDB.bind(stmt, 8, ws.totalSeen)
        try SQLiteDB.bind(stmt, 9, ws.dayTouches)
        try SQLiteDB.bind(stmt, 10, ws.recentAccuracy)
        try SQLiteDB.bind(stmt, 11, nowStr)
        try SQLiteDB.bind(stmt, 12, userId)
        try SQLiteDB.bind(stmt, 13, wordId)
        _ = sqlite3_step(stmt)

        // Determine box change
        if ws.boxLevel > oldBox { return .promoted(from: oldBox, to: ws.boxLevel) }
        if ws.boxLevel < oldBox { return .demoted(from: oldBox, to: ws.boxLevel) }
        return .none
    }

    /// Day 1 promotion: run after evening session completes.
    /// Reference: docs/data-schema.md Section 5.8
    func runDay1Promotion(userId: String, studyDay: Int) throws -> (promoted: Int, notPromoted: Int) {
        // Find words at intro_stage = 1 or 2 (morning seen, evening done, not yet decided)
        let sql = """
        SELECT word_id FROM word_state
        WHERE user_id = ? AND intro_stage IN (1, 2) AND box_level = 0
        """
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }
        try SQLiteDB.bind(stmt, 1, userId)

        var wordIds: [Int] = []
        while sqlite3_step(stmt) == SQLITE_ROW {
            wordIds.append(SQLiteDB.columnInt(stmt, 0))
        }

        var promoted = 0, notPromoted = 0
        let iso = ISO8601DateFormatter()

        for wordId in wordIds {
            // Count scored correct today (non-superseded)
            let countSql = """
            SELECT
                SUM(CASE WHEN outcome = 'correct' THEN 1 ELSE 0 END) as correct_count,
                COUNT(*) as total_count
            FROM review_log
            WHERE user_id = ? AND word_id = ? AND study_day = ?
              AND activity_type IN ('image_game', 'quick_recall')
              AND superseded = 0
            """
            let cStmt = try db.prepare(countSql)
            defer { cStmt?.finalize() }
            try SQLiteDB.bind(cStmt, 1, userId)
            try SQLiteDB.bind(cStmt, 2, wordId)
            try SQLiteDB.bind(cStmt, 3, studyDay)

            var correctCount = 0, totalCount = 0
            if sqlite3_step(cStmt) == SQLITE_ROW {
                correctCount = SQLiteDB.columnInt(cStmt, 0)
                totalCount = SQLiteDB.columnInt(cStmt, 1)
            }

            // Check last recall was correct
            let lastSql = """
            SELECT outcome FROM review_log
            WHERE user_id = ? AND word_id = ? AND study_day = ?
              AND activity_type IN ('image_game', 'quick_recall')
              AND superseded = 0
            ORDER BY reviewed_at DESC LIMIT 1
            """
            let lStmt = try db.prepare(lastSql)
            defer { lStmt?.finalize() }
            try SQLiteDB.bind(lStmt, 1, userId)
            try SQLiteDB.bind(lStmt, 2, wordId)
            try SQLiteDB.bind(lStmt, 3, studyDay)
            let lastCorrect = sqlite3_step(lStmt) == SQLITE_ROW &&
                              SQLiteDB.columnText(lStmt, 0) == "correct"

            // Promotion rule: 2/3 scored correct AND correct final recall → Box 2
            let qualifies = totalCount >= 2 && correctCount >= 2 && lastCorrect

            let newBox = qualifies ? 2 : 1
            let dueDate = Calendar.current.date(byAdding: .day,
                value: newBox == 2 ? 3 : 1, to: Date())!
            let dueStr = iso.string(from: dueDate)

            try db.exec("""
            UPDATE word_state SET
                box_level = \(newBox), due_at = '\(dueStr)', intro_stage = 3,
                updated_at = datetime('now')
            WHERE user_id = '\(userId)' AND word_id = \(wordId)
            """)

            if qualifies { promoted += 1 } else { notPromoted += 1 }
        }

        return (promoted, notPromoted)
    }

    /// Reset day_touches for all words (called at start of new study day)
    func resetDayTouches(userId: String) throws {
        try db.exec("UPDATE word_state SET day_touches = 0 WHERE user_id = '\(userId)' AND day_touches > 0;")
    }

    // MARK: - Helpers

    private func computeRecentAccuracy(userId: String, wordId: Int) throws -> Double {
        let sql = """
        SELECT outcome FROM review_log
        WHERE user_id = ? AND word_id = ?
          AND activity_type IN ('image_game', 'quick_recall', 'sat_question')
          AND superseded = 0
        ORDER BY reviewed_at DESC LIMIT 5
        """
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }
        try SQLiteDB.bind(stmt, 1, userId)
        try SQLiteDB.bind(stmt, 2, wordId)

        var total = 0, correct = 0
        while sqlite3_step(stmt) == SQLITE_ROW {
            total += 1
            if SQLiteDB.columnText(stmt, 0) == "correct" { correct += 1 }
        }
        return total > 0 ? Double(correct) / Double(total) : 0
    }

    private func classifyMemoryStatus(_ ws: WordState) -> MemoryStatus {
        if ws.lapseCount >= 3 || ws.consecutiveWrong >= 2 { return .stubborn }
        if ws.recentAccuracy < 0.6 || ws.lapseCount >= 1 { return .fragile }
        if ws.boxLevel >= 3 && ws.recentAccuracy >= 0.85 && ws.lapseCount == 0 { return .easy }
        return .normal
    }

    private func parseWordState(_ stmt: OpaquePointer?) -> WordState {
        let iso = ISO8601DateFormatter()
        return WordState(
            id: SQLiteDB.columnInt(stmt, 0),
            userId: SQLiteDB.columnText(stmt, 1) ?? "",
            wordId: SQLiteDB.columnInt(stmt, 2),
            boxLevel: SQLiteDB.columnInt(stmt, 3),
            dueAt: SQLiteDB.columnText(stmt, 4).flatMap { iso.date(from: $0) },
            introStage: SQLiteDB.columnInt(stmt, 5),
            memoryStatus: MemoryStatus(rawValue: SQLiteDB.columnText(stmt, 6) ?? "normal") ?? .normal,
            lapseCount: SQLiteDB.columnInt(stmt, 7),
            consecutiveWrong: SQLiteDB.columnInt(stmt, 8),
            totalCorrect: SQLiteDB.columnInt(stmt, 9),
            totalSeen: SQLiteDB.columnInt(stmt, 10),
            dayTouches: SQLiteDB.columnInt(stmt, 11),
            recentAccuracy: Double(SQLiteDB.columnInt(stmt, 12)),  // stored as REAL but read as int
            lastReviewedAt: SQLiteDB.columnText(stmt, 13).flatMap { iso.date(from: $0) }
        )
    }
}

enum BoxChange {
    case none
    case promoted(from: Int, to: Int)
    case demoted(from: Int, to: Int)

    var isMastery: Bool {
        if case .promoted(_, let to) = self, to == 5 { return true }
        return false
    }
}
```

- [ ] **Step 2: Verify build**

- [ ] **Step 3: Commit**

```bash
git add ios/SATVocabApp/Sources/SATVocabApp/Data/WordStateStore.swift
git commit -m "feat: WordStateStore with box progression, review queue, Day 1 promotion"
```

---

### Task 5: SessionStateStore + StatsStore + ZoneStore

**Files:**
- Create: `ios/SATVocabApp/Sources/SATVocabApp/Data/SessionStateStore.swift`
- Create: `ios/SATVocabApp/Sources/SATVocabApp/Data/StatsStore.swift`
- Create: `ios/SATVocabApp/Sources/SATVocabApp/Data/ZoneStore.swift`

- [ ] **Step 1: Create SessionStateStore.swift**

Handles: session_state CRUD, day_state CRUD, pause/resume, session lifecycle.

```swift
// ios/SATVocabApp/Sources/SATVocabApp/Data/SessionStateStore.swift
import Foundation
import SQLite3

actor SessionStateStore {
    private let db: SQLiteDB

    init(db: SQLiteDB) { self.db = db }

    // MARK: - Day State

    func getCurrentDayState(userId: String) throws -> DayState? {
        let sql = "SELECT * FROM day_state WHERE user_id = ? ORDER BY study_day DESC LIMIT 1"
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }
        try SQLiteDB.bind(stmt, 1, userId)
        guard sqlite3_step(stmt) == SQLITE_ROW else { return nil }
        return parseDayState(stmt)
    }

    func getOrCreateDayState(userId: String, studyDay: Int, zoneIndex: Int) throws -> DayState {
        if let existing = try getDayState(userId: userId, studyDay: studyDay) {
            return existing
        }
        try db.exec("""
        INSERT INTO day_state (user_id, study_day, zone_index)
        VALUES ('\(userId)', \(studyDay), \(zoneIndex))
        """)
        return try getDayState(userId: userId, studyDay: studyDay)!
    }

    func getDayState(userId: String, studyDay: Int) throws -> DayState? {
        let sql = "SELECT * FROM day_state WHERE user_id = ? AND study_day = ?"
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }
        try SQLiteDB.bind(stmt, 1, userId)
        try SQLiteDB.bind(stmt, 2, studyDay)
        guard sqlite3_step(stmt) == SQLITE_ROW else { return nil }
        return parseDayState(stmt)
    }

    func markMorningComplete(userId: String, studyDay: Int, accuracy: Double, xp: Int, newWords: Int) throws {
        let now = ISO8601DateFormatter().string(from: Date())
        try db.exec("""
        UPDATE day_state SET
            morning_complete = 1, morning_complete_at = '\(now)',
            morning_accuracy = \(accuracy), morning_xp = \(xp), new_words_morning = \(newWords)
        WHERE user_id = '\(userId)' AND study_day = \(studyDay)
        """)
    }

    func markEveningComplete(userId: String, studyDay: Int, accuracy: Double, xp: Int, newWords: Int) throws {
        let now = ISO8601DateFormatter().string(from: Date())
        try db.exec("""
        UPDATE day_state SET
            evening_complete = 1, evening_complete_at = '\(now)',
            evening_accuracy = \(accuracy), evening_xp = \(xp), new_words_evening = \(newWords)
        WHERE user_id = '\(userId)' AND study_day = \(studyDay)
        """)
    }

    // MARK: - Session State (pause/resume)

    func getActiveSession(userId: String) throws -> SessionState? {
        let sql = "SELECT * FROM session_state WHERE user_id = ? AND is_paused = 1 AND completed_at IS NULL ORDER BY started_at DESC LIMIT 1"
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }
        try SQLiteDB.bind(stmt, 1, userId)
        guard sqlite3_step(stmt) == SQLITE_ROW else { return nil }
        return parseSessionState(stmt)
    }

    func createSession(userId: String, sessionType: SessionType, studyDay: Int) throws -> SessionState {
        let now = ISO8601DateFormatter().string(from: Date())
        try db.exec("""
        INSERT OR REPLACE INTO session_state (user_id, session_type, study_day, started_at)
        VALUES ('\(userId)', '\(sessionType.rawValue)', \(studyDay), '\(now)')
        """)
        return try getActiveSession(userId: userId)!
    }

    func pauseSession(userId: String, studyDay: Int, sessionType: SessionType,
                     stepIndex: Int, itemIndex: Int,
                     showAgainIds: [Int], requeuedIds: [Int]) throws {
        let now = ISO8601DateFormatter().string(from: Date())
        let showAgainJSON = try String(data: JSONSerialization.data(withJSONObject: showAgainIds), encoding: .utf8) ?? "[]"
        let requeuedJSON = try String(data: JSONSerialization.data(withJSONObject: requeuedIds), encoding: .utf8) ?? "[]"

        try db.exec("""
        UPDATE session_state SET
            step_index = \(stepIndex), item_index = \(itemIndex),
            is_paused = 1, paused_at = '\(now)',
            show_again_ids = '\(showAgainJSON)', requeued_ids = '\(requeuedJSON)'
        WHERE user_id = '\(userId)' AND study_day = \(studyDay) AND session_type = '\(sessionType.rawValue)'
        """)
    }

    func resumeSession(userId: String, studyDay: Int, sessionType: SessionType) throws {
        try db.exec("""
        UPDATE session_state SET is_paused = 0
        WHERE user_id = '\(userId)' AND study_day = \(studyDay) AND session_type = '\(sessionType.rawValue)'
        """)
    }

    func completeSession(userId: String, studyDay: Int, sessionType: SessionType) throws {
        let now = ISO8601DateFormatter().string(from: Date())
        try db.exec("""
        UPDATE session_state SET
            is_paused = 0, completed_at = '\(now)'
        WHERE user_id = '\(userId)' AND study_day = \(studyDay) AND session_type = '\(sessionType.rawValue)'
        """)
    }

    // MARK: - Parsing

    private func parseDayState(_ stmt: OpaquePointer?) -> DayState {
        let iso = ISO8601DateFormatter()
        return DayState(
            id: SQLiteDB.columnInt(stmt, 0),
            userId: SQLiteDB.columnText(stmt, 1) ?? "",
            studyDay: SQLiteDB.columnInt(stmt, 2),
            zoneIndex: SQLiteDB.columnInt(stmt, 3),
            morningComplete: SQLiteDB.columnInt(stmt, 4) != 0,
            eveningComplete: SQLiteDB.columnInt(stmt, 5) != 0,
            morningCompleteAt: SQLiteDB.columnText(stmt, 6).flatMap { iso.date(from: $0) },
            eveningCompleteAt: SQLiteDB.columnText(stmt, 7).flatMap { iso.date(from: $0) },
            newWordsMorning: SQLiteDB.columnInt(stmt, 8),
            newWordsEvening: SQLiteDB.columnInt(stmt, 9),
            morningAccuracy: 0, eveningAccuracy: 0,
            morningXP: SQLiteDB.columnInt(stmt, 12),
            eveningXP: SQLiteDB.columnInt(stmt, 13),
            isRecoveryDay: SQLiteDB.columnInt(stmt, 14) != 0,
            isReviewOnlyDay: SQLiteDB.columnInt(stmt, 15) != 0
        )
    }

    private func parseSessionState(_ stmt: OpaquePointer?) -> SessionState {
        let iso = ISO8601DateFormatter()
        let showAgainStr = SQLiteDB.columnText(stmt, 7) ?? "[]"
        let requeuedStr = SQLiteDB.columnText(stmt, 8) ?? "[]"
        let showAgainIds = (try? JSONSerialization.jsonObject(with: Data(showAgainStr.utf8)) as? [Int]) ?? []
        let requeuedIds = (try? JSONSerialization.jsonObject(with: Data(requeuedStr.utf8)) as? [Int]) ?? []

        return SessionState(
            id: SQLiteDB.columnInt(stmt, 0),
            userId: SQLiteDB.columnText(stmt, 1) ?? "",
            sessionType: SessionType(rawValue: SQLiteDB.columnText(stmt, 2) ?? "morning") ?? .morning,
            studyDay: SQLiteDB.columnInt(stmt, 3),
            stepIndex: SQLiteDB.columnInt(stmt, 4),
            itemIndex: SQLiteDB.columnInt(stmt, 5),
            isPaused: SQLiteDB.columnInt(stmt, 6) != 0,
            showAgainIds: showAgainIds,
            requeuedIds: requeuedIds,
            startedAt: SQLiteDB.columnText(stmt, 9).flatMap { iso.date(from: $0) },
            pausedAt: SQLiteDB.columnText(stmt, 10).flatMap { iso.date(from: $0) },
            completedAt: SQLiteDB.columnText(stmt, 11).flatMap { iso.date(from: $0) }
        )
    }
}
```

- [ ] **Step 2: Create StatsStore.swift**

```swift
// ios/SATVocabApp/Sources/SATVocabApp/Data/StatsStore.swift
import Foundation
import SQLite3

actor StatsStore {
    private let db: SQLiteDB

    init(db: SQLiteDB) { self.db = db }

    // MARK: - Daily Stats

    func getOrCreateDailyStats(userId: String, studyDay: Int) throws -> DailyStats {
        let today = DateFormatter.yyyyMMdd.string(from: Date())
        try db.exec("""
        INSERT OR IGNORE INTO daily_stats (user_id, study_day, calendar_date)
        VALUES ('\(userId)', \(studyDay), '\(today)')
        """)

        let sql = "SELECT * FROM daily_stats WHERE user_id = ? AND study_day = ?"
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }
        try SQLiteDB.bind(stmt, 1, userId)
        try SQLiteDB.bind(stmt, 2, studyDay)
        guard sqlite3_step(stmt) == SQLITE_ROW else {
            fatalError("daily_stats row should exist after INSERT OR IGNORE")
        }
        return parseDailyStats(stmt)
    }

    func recordCorrectAnswer(userId: String, studyDay: Int, xpPerCorrect: Int = 10) throws {
        try db.exec("""
        UPDATE daily_stats SET
            correct_count = correct_count + 1,
            total_count = total_count + 1,
            xp_earned = xp_earned + \(xpPerCorrect)
        WHERE user_id = '\(userId)' AND study_day = \(studyDay)
        """)
    }

    func recordWrongAnswer(userId: String, studyDay: Int) throws {
        try db.exec("""
        UPDATE daily_stats SET total_count = total_count + 1
        WHERE user_id = '\(userId)' AND study_day = \(studyDay)
        """)
    }

    func addSessionBonus(userId: String, studyDay: Int, bonus: Int = 30) throws {
        try db.exec("""
        UPDATE daily_stats SET session_bonus = session_bonus + \(bonus)
        WHERE user_id = '\(userId)' AND study_day = \(studyDay)
        """)
    }

    func recordWordPromoted(userId: String, studyDay: Int) throws {
        try db.exec("UPDATE daily_stats SET words_promoted = words_promoted + 1 WHERE user_id = '\(userId)' AND study_day = \(studyDay)")
    }

    func recordWordDemoted(userId: String, studyDay: Int) throws {
        try db.exec("UPDATE daily_stats SET words_demoted = words_demoted + 1 WHERE user_id = '\(userId)' AND study_day = \(studyDay)")
    }

    // MARK: - Streak

    func getStreak(userId: String) throws -> StreakInfo {
        let sql = "SELECT * FROM streak_store WHERE user_id = ?"
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }
        try SQLiteDB.bind(stmt, 1, userId)
        guard sqlite3_step(stmt) == SQLITE_ROW else {
            return StreakInfo(currentStreak: 0, bestStreak: 0, lastStudyDate: nil,
                           totalXP: 0, totalStudyDays: 0,
                           streak3Claimed: false, streak7Claimed: false,
                           streak14Claimed: false, streak30Claimed: false)
        }
        return StreakInfo(
            currentStreak: SQLiteDB.columnInt(stmt, 2),
            bestStreak: SQLiteDB.columnInt(stmt, 3),
            lastStudyDate: SQLiteDB.columnText(stmt, 4),
            totalXP: SQLiteDB.columnInt(stmt, 9),
            totalStudyDays: SQLiteDB.columnInt(stmt, 10),
            streak3Claimed: SQLiteDB.columnInt(stmt, 5) != 0,
            streak7Claimed: SQLiteDB.columnInt(stmt, 6) != 0,
            streak14Claimed: SQLiteDB.columnInt(stmt, 7) != 0,
            streak30Claimed: SQLiteDB.columnInt(stmt, 8) != 0
        )
    }

    func updateStreak(userId: String, xpToday: Int) throws -> (newStreak: Int, milestoneXP: Int) {
        let today = DateFormatter.yyyyMMdd.string(from: Date())
        var streak = try getStreak(userId: userId)

        // Calculate new streak
        if let last = streak.lastStudyDate {
            let yesterday = DateFormatter.yyyyMMdd.string(from: Calendar.current.date(byAdding: .day, value: -1, to: Date())!)
            if last == today {
                // Same day — keep streak
            } else if last == yesterday {
                streak.currentStreak += 1
            } else {
                streak.currentStreak = 1  // streak broken
            }
        } else {
            streak.currentStreak = 1
        }

        streak.bestStreak = max(streak.bestStreak, streak.currentStreak)
        streak.totalXP += xpToday
        streak.totalStudyDays += (streak.lastStudyDate == today ? 0 : 1)

        // Check milestones
        var milestoneXP = 0
        if streak.currentStreak >= 3 && !streak.streak3Claimed { milestoneXP += 20; streak.streak3Claimed = true }
        if streak.currentStreak >= 7 && !streak.streak7Claimed { milestoneXP += 50; streak.streak7Claimed = true }
        if streak.currentStreak >= 14 && !streak.streak14Claimed { milestoneXP += 100; streak.streak14Claimed = true }
        if streak.currentStreak >= 30 && !streak.streak30Claimed { milestoneXP += 200; streak.streak30Claimed = true }

        try db.exec("""
        UPDATE streak_store SET
            current_streak = \(streak.currentStreak),
            best_streak = \(streak.bestStreak),
            last_study_date = '\(today)',
            total_xp = \(streak.totalXP + milestoneXP),
            total_study_days = \(streak.totalStudyDays),
            streak_3_claimed = \(streak.streak3Claimed ? 1 : 0),
            streak_7_claimed = \(streak.streak7Claimed ? 1 : 0),
            streak_14_claimed = \(streak.streak14Claimed ? 1 : 0),
            streak_30_claimed = \(streak.streak30Claimed ? 1 : 0)
        WHERE user_id = '\(userId)'
        """)

        return (streak.currentStreak, milestoneXP)
    }

    // MARK: - Helpers

    private func parseDailyStats(_ stmt: OpaquePointer?) -> DailyStats {
        DailyStats(
            id: SQLiteDB.columnInt(stmt, 0),
            userId: SQLiteDB.columnText(stmt, 1) ?? "",
            studyDay: SQLiteDB.columnInt(stmt, 2),
            calendarDate: SQLiteDB.columnText(stmt, 3) ?? "",
            newCount: SQLiteDB.columnInt(stmt, 4),
            reviewCount: SQLiteDB.columnInt(stmt, 5),
            correctCount: SQLiteDB.columnInt(stmt, 6),
            totalCount: SQLiteDB.columnInt(stmt, 7),
            xpEarned: SQLiteDB.columnInt(stmt, 8),
            sessionBonus: SQLiteDB.columnInt(stmt, 9),
            studyMinutes: 0,
            wordsPromoted: SQLiteDB.columnInt(stmt, 11),
            wordsDemoted: SQLiteDB.columnInt(stmt, 12)
        )
    }
}

extension DateFormatter {
    static let yyyyMMdd: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()
}
```

- [ ] **Step 3: Create ZoneStore.swift**

```swift
// ios/SATVocabApp/Sources/SATVocabApp/Data/ZoneStore.swift
import Foundation

actor ZoneStore {
    private let db: SQLiteDB

    init(db: SQLiteDB) { self.db = db }

    func getZoneState(userId: String, zoneIndex: Int) throws -> ZoneState? {
        let sql = "SELECT * FROM zone_state WHERE user_id = ? AND zone_index = ?"
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }
        try SQLiteDB.bind(stmt, 1, userId)
        try SQLiteDB.bind(stmt, 2, zoneIndex)
        guard sqlite3_step(stmt) == SQLITE_ROW else { return nil }
        return ZoneState(
            id: SQLiteDB.columnInt(stmt, 0),
            userId: SQLiteDB.columnText(stmt, 1) ?? "",
            zoneIndex: SQLiteDB.columnInt(stmt, 2),
            unlocked: SQLiteDB.columnInt(stmt, 3) != 0,
            testPassed: SQLiteDB.columnInt(stmt, 4) != 0,
            testAttempts: SQLiteDB.columnInt(stmt, 5),
            testBestScore: 0
        )
    }

    func isZoneUnlocked(userId: String, zoneIndex: Int) throws -> Bool {
        if zoneIndex == 0 { return true }
        return try getZoneState(userId: userId, zoneIndex: zoneIndex)?.unlocked ?? false
    }

    func unlockZone(userId: String, zoneIndex: Int) throws {
        let now = ISO8601DateFormatter().string(from: Date())
        try db.exec("""
        INSERT INTO zone_state (user_id, zone_index, unlocked, unlocked_at)
        VALUES ('\(userId)', \(zoneIndex), 1, '\(now)')
        ON CONFLICT(user_id, zone_index) DO UPDATE SET
            unlocked = 1, unlocked_at = '\(now)'
        """)
    }

    func recordTestAttempt(userId: String, zoneIndex: Int, score: Double, passed: Bool) throws {
        try db.exec("""
        UPDATE zone_state SET
            test_attempts = test_attempts + 1,
            test_best_score = MAX(test_best_score, \(score)),
            test_passed = \(passed ? 1 : 0)
        WHERE user_id = '\(userId)' AND zone_index = \(zoneIndex)
        """)
    }
}
```

- [ ] **Step 4: Update AppConfig with new values**

Add to `ios/SATVocabApp/Sources/SATVocabApp/Data/AppConfig.swift`:

```swift
// Add to AppConfig enum:

// V2 Learning Model
static let morningNewWords = 11          // ⚙️ provisional
static let eveningNewWords = 10          // ⚙️ provisional
static let morningGameRounds = 12        // 8 new + 4 review
static let eveningGameRounds = 12        // 6 new + 6 review
static let morningSATQuestions = 3
static let eveningSATQuestions = 2
static let eveningUnlockHours = 4        // hours after morning
static let eveningUnlockFallbackHour = 17 // 5 PM
static let backPressureReduceAt = 18     // overdue count threshold
static let backPressureStopAt = 30
static let zoneTestPassThreshold = 0.8   // 80%
static let rushMinGameMs = 1000          // 1 second
static let rushMinSATMs = 3000           // 3 seconds
static let sessionBonusXP = 30
static let correctAnswerXP = 10
static let bonusPracticeXP = 5           // half XP
static let lateNightHour = 20            // 8 PM
```

- [ ] **Step 5: Verify build**

- [ ] **Step 6: Commit**

```bash
git add ios/SATVocabApp/Sources/SATVocabApp/Data/SessionStateStore.swift \
        ios/SATVocabApp/Sources/SATVocabApp/Data/StatsStore.swift \
        ios/SATVocabApp/Sources/SATVocabApp/Data/ZoneStore.swift \
        ios/SATVocabApp/Sources/SATVocabApp/Data/AppConfig.swift
git commit -m "feat: SessionStateStore, StatsStore, ZoneStore with full data lifecycle"
```

---

### Task 6: ReviewLogger (write to review_log)

**Files:**
- Create: `ios/SATVocabApp/Sources/SATVocabApp/Data/ReviewLogger.swift`

- [ ] **Step 1: Create ReviewLogger.swift**

```swift
// ios/SATVocabApp/Sources/SATVocabApp/Data/ReviewLogger.swift
import Foundation

/// Writes scored answers to review_log table.
/// Reference: docs/data-schema.md Section 5.5
actor ReviewLogger {
    private let db: SQLiteDB

    init(db: SQLiteDB) { self.db = db }

    func logReview(
        userId: String,
        wordId: Int,
        outcome: ReviewOutcome,
        activityType: ActivityType,
        sessionType: SessionType,
        studyDay: Int,
        durationMs: Int
    ) throws {
        let iso = ISO8601DateFormatter()
        let now = iso.string(from: Date())
        let deviceId = LocalIdentity.deviceId()

        let sql = """
        INSERT INTO review_log
        (user_id, word_id, outcome, activity_type, session_type, study_day,
         duration_ms, reviewed_at, device_id, superseded)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 0)
        """
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }
        try SQLiteDB.bind(stmt, 1, userId)
        try SQLiteDB.bind(stmt, 2, wordId)
        try SQLiteDB.bind(stmt, 3, outcome.rawValue)
        try SQLiteDB.bind(stmt, 4, activityType.rawValue)
        try SQLiteDB.bind(stmt, 5, sessionType.rawValue)
        try SQLiteDB.bind(stmt, 6, studyDay)
        try SQLiteDB.bind(stmt, 7, durationMs)
        try SQLiteDB.bind(stmt, 8, now)
        try SQLiteDB.bind(stmt, 9, deviceId)
        _ = sqlite3_step(stmt)
    }

    /// Mark all review_log entries for a session as superseded (for restart).
    func supersedeSession(userId: String, studyDay: Int, sessionType: SessionType) throws {
        try db.exec("""
        UPDATE review_log SET superseded = 1
        WHERE user_id = '\(userId)' AND study_day = \(studyDay)
          AND session_type = '\(sessionType.rawValue)' AND superseded = 0
        """)
    }
}
```

- [ ] **Step 2: Verify build + commit**

```bash
git add ios/SATVocabApp/Sources/SATVocabApp/Data/ReviewLogger.swift
git commit -m "feat: ReviewLogger for scored event logging + supersede support"
```

---

### Plan 1 Summary

**6 tasks, ~12 files created/modified:**

| Task | Component | Key Capability |
|------|-----------|---------------|
| 1 | Enums + Models | WordState, DayState, SessionState, StreakInfo, ZoneState types |
| 2 | SchemaV2 | All CREATE TABLE + indexes |
| 3 | ContentImporter | JSON → SQLite on first launch |
| 4 | WordStateStore | Box progression, review queue, Day 1 promotion, memory status |
| 5 | SessionStateStore + Stats + Zone | Pause/resume, daily stats, streak, zone unlock |
| 6 | ReviewLogger | Scored event logging, supersede for restart |

**After Plan 1, the app can:** create the database, import 372 words from JSON, track word learning state, manage sessions, calculate XP/streaks, and query review queues. No UI changes yet — that's Plan 2.

---

## Cross-Check Review

**P0 coverage is mostly complete:** all 10 P0 items from `docs/design-summary.md` have a home across the three plans (Plan 1 = data layer, Plan 2 = session loop + 4 activities + session complete/share + pause/resume, Plan 3 = Practice tab + lock timer + map).

The main problems are **cross-plan compatibility and missing glue**:

1. **Plan 2 does not use Plan 1’s write path correctly.** `SessionFlowViewModel.recordAnswer(correct:wordId:)` never calls `ReviewLogger.logReview`, so `review_log` stays empty even though `WordStateStore.computeRecentAccuracy()` and `runDay1Promotion()` depend on it. It also lacks `activityType` and `durationMs`, so rush detection and per-activity logging cannot work.

2. **Plan 2 never creates the rows it later updates.** It calls `completeSession`, `markMorningComplete`, `markEveningComplete`, and `StatsStore.recordCorrectAnswer`, but I do not see corresponding startup calls to `SessionStateStore.createSession`, `getOrCreateDayState`, or `StatsStore.getOrCreateDailyStats`. That is a blocking lifecycle gap.

3. **Plan 2 depends on APIs/types Plan 1 does not define.** It calls `DataManager.getDefaultList()` and `fetchSessionQueue(listId:limit:startIndex)` and uses `VocabCard`, but Plan 1 never assigns tasks for those. Likewise, Plan 1 lists `ReviewQueue.swift` and `AdventureSchedule.swift` in file structure, but no task actually creates/updates them.

4. **Plan 3 has type/view mismatches.** `navigationDestination(item:)` is used with `SessionType?`, but `SessionType` is not `Identifiable` in Plan 1. `PracticeTabView` also references `PracticeHeader`, `ReviewsDueRow`, `MorningCompleteCard`, and `EveningCompleteCard` without putting them in file structure or tasks. `Color(hex:)` is also used in Plan 3 even though that helper only appears inside Plan 2’s `Button3D.swift`.

5. **File structure is inconsistent in Plan 2.** The file tree lists `FlashcardStepViewModel.swift`, `ImageGameViewModel.swift`, `QuickRecallViewModel.swift`, `SATQuestionViewModel.swift`, `SessionCompleteViewModel.swift`, and `AnswerFeedbackView.swift`, but the tasks never create them.

6. **SQL injection risk is real in Plan 1.** Many `db.exec(""" ... \(userId) ... """)` patterns interpolate `userId`, `sessionType.rawValue`, timestamps, JSON strings, and question IDs directly. The riskiest spots are `runDay1Promotion`, `pauseSession`, `createSession`, `StatsStore` updates, `ZoneStore`, and `ReviewLogger.supersedeSession`. These should use prepared statements/bind parameters consistently.
