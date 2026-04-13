# Content Delivery Design

How word lists, images, and SAT questions get from the project repo into the student's app.

---

## 1. Decision: V1 = Bundled, V2 = Downloadable

| Aspect | V1 (Ship Now) | V2 (Later) |
|--------|--------------|------------|
| **Content source** | Bundled inside app | Downloaded from Supabase Storage / CDN |
| **Word lists** | 1 list: "SAT Core 372" | Multiple: SAT Core, SAT Advanced, GRE, etc. |
| **Images** | Bundled in app Resources/ | Downloaded per pack |
| **Internet required** | No (fully offline) | Only for downloading new packs |
| **App update needed for new words** | Yes (new app version) | No (publish new pack, students download) |
| **Implementation effort** | Low (JSON import on first launch) | Medium (download UI, hosting, versioning) |
| **When to build** | Now | When second word list is ready |

---

## 2. V1: Bundled Auto-Import

### What Ships Inside the App

```
SATVocabApp.app/
├── Resources/
│   ├── data.db              ← Empty (schema only, created at build time)
│   ├── word_list.json       ← 372 words with definitions, examples, contexts, collocations, SAT questions
│   ├── sat_questions.json   ← 1,553 deduplicated SAT reading questions
│   └── Images/
│       ├── ephemeral.jpg    ← 372 mnemonic illustrations
│       ├── abrupt.jpg
│       └── ...
```

### First Launch Flow

```
┌─────────────────────────────────┐
│         First Launch            │
│                                 │
│  1. Create empty data.db        │
│     (all table schemas)         │
│                                 │
│  2. Read bundled JSON files     │
│     word_list.json              │
│     sat_questions.json          │
│                                 │
│  3. Import into SQLite          │  ← ~2-3 seconds
│     lists (1 row)               │
│     words (372 rows)            │
│     word_list (372 rows)        │
│     sat_contexts (~744 rows)    │
│     collocations (~1000 rows)   │
│     sat_question_bank (1553)    │
│     word_questions (~1100)      │
│                                 │
│  4. Create user + defaults      │
│     users (1 row)               │
│     streak_store (1 row)        │
│     zone_state (zone 0 unlock)  │
│                                 │
│  5. Show Practice tab           │
│     Student starts learning     │
└─────────────────────────────────┘
```

### Implementation: initializeIfNeeded()

```swift
func initializeIfNeeded() throws {
    if isInitialized { return }
    
    let writableURL = try DatabasePaths.writableDatabaseURL()
    
    if !FileManager.default.fileExists(atPath: writableURL.path) {
        // First launch: create DB and import content
        try db.open(path: writableURL.path)
        try createSchema()          // CREATE TABLE statements
        try importBundledContent()  // Read JSON → INSERT into SQLite
        try createDefaultUser()     // users, streak_store, zone_state
    } else {
        // Subsequent launch: just open
        try db.open(path: writableURL.path)
        try checkMigrations()       // Schema upgrades if app version changed
    }
    
    isInitialized = true
}
```

### importBundledContent() Detail

```swift
func importBundledContent() throws {
    // 1. Read word_list.json from bundle
    guard let wordListURL = Bundle.main.url(forResource: "word_list", withExtension: "json"),
          let wordListData = try? Data(contentsOf: wordListURL),
          let words = try? JSONSerialization.jsonObject(with: wordListData) as? [[String: Any]]
    else { throw AppError.missingBundledData("word_list.json") }
    
    // 2. Read sat_questions.json from bundle
    guard let satURL = Bundle.main.url(forResource: "sat_reading_questions_deduplicated", withExtension: "json"),
          let satData = try? Data(contentsOf: satURL),
          let satQuestions = try? JSONSerialization.jsonObject(with: satData) as? [[String: Any]]
    else { throw AppError.missingBundledData("sat_questions.json") }
    
    // 3. Create list
    try db.exec("INSERT INTO lists (name, description, version) VALUES ('sat_core_1', 'SAT Core Vocabulary', 1);")
    let listId = db.lastInsertRowId()
    
    // 4. Import words (in transaction for speed)
    try db.exec("BEGIN TRANSACTION;")
    
    for (rank, wordDict) in words.enumerated() {
        let word = wordDict["word"] as? String ?? ""
        let pos = wordDict["pos"] as? String
        let definition = wordDict["definition"] as? String
        let example = wordDict["example"] as? String
        let imageFilename = word.replacingOccurrences(of: " ", with: "_") + ".jpg"
        
        // Insert word
        let insertWord = try db.prepare(
            "INSERT INTO words (lemma, pos, definition, example, image_filename) VALUES (?,?,?,?,?)")
        try SQLiteDB.bind(insertWord, 1, word)
        try SQLiteDB.bind(insertWord, 2, pos)
        try SQLiteDB.bind(insertWord, 3, definition)
        try SQLiteDB.bind(insertWord, 4, example)
        try SQLiteDB.bind(insertWord, 5, imageFilename)
        sqlite3_step(insertWord)
        insertWord?.finalize()
        let wordId = Int(db.lastInsertRowId())
        
        // Insert word_list mapping
        try db.exec("INSERT INTO word_list (word_id, list_id, rank) VALUES (\(wordId), \(listId), \(rank));")
        
        // Insert SAT contexts
        if let contexts = wordDict["sat_context"] as? [String] {
            for ctx in contexts {
                let stmt = try db.prepare("INSERT INTO sat_contexts (word_id, context) VALUES (?,?)")
                try SQLiteDB.bind(stmt, 1, wordId)
                try SQLiteDB.bind(stmt, 2, ctx)
                sqlite3_step(stmt)
                stmt?.finalize()
            }
        }
        
        // Insert collocations
        if let collocations = wordDict["collocation"] as? [String] {
            for col in collocations {
                let stmt = try db.prepare("INSERT INTO collocations (word_id, phrase) VALUES (?,?)")
                try SQLiteDB.bind(stmt, 1, wordId)
                try SQLiteDB.bind(stmt, 2, col)
                sqlite3_step(stmt)
                stmt?.finalize()
            }
        }
        
        // Insert embedded SAT questions + word_questions mapping
        if let questions = wordDict["sat_questions"] as? [[String: Any]] {
            for q in questions {
                let qId = q["id"] as? String ?? UUID().uuidString
                let opts = q["options"] as? [String: String] ?? [:]
                
                let stmt = try db.prepare("""
                    INSERT OR IGNORE INTO sat_question_bank
                    (id, word_id, target_word, section, module, q_type, passage, question,
                     option_a, option_b, option_c, option_d, answer, source_pdf, page, explanation)
                    VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
                """)
                try SQLiteDB.bind(stmt, 1, qId)
                try SQLiteDB.bind(stmt, 2, wordId)
                try SQLiteDB.bind(stmt, 3, word)
                try SQLiteDB.bind(stmt, 4, q["section"] as? String)
                try SQLiteDB.bind(stmt, 5, q["module"] as? Int)
                try SQLiteDB.bind(stmt, 6, q["type"] as? String)
                try SQLiteDB.bind(stmt, 7, q["passage"] as? String)
                try SQLiteDB.bind(stmt, 8, q["question"] as? String)
                try SQLiteDB.bind(stmt, 9, opts["A"])
                try SQLiteDB.bind(stmt, 10, opts["B"])
                try SQLiteDB.bind(stmt, 11, opts["C"])
                try SQLiteDB.bind(stmt, 12, opts["D"])
                try SQLiteDB.bind(stmt, 13, q["answer"] as? String)
                try SQLiteDB.bind(stmt, 14, q["source_pdf"] as? String)
                try SQLiteDB.bind(stmt, 15, q["page"] as? Int)
                try SQLiteDB.bind(stmt, 16, q["explanation"] as? String)
                sqlite3_step(stmt)
                stmt?.finalize()
                
                try db.exec("INSERT OR IGNORE INTO word_questions (word_id, question_id) VALUES (\(wordId), '\(qId)');")
            }
        }
    }
    
    // 5. Import standalone SAT questions (not embedded in word_list.json)
    for q in satQuestions {
        let qId = q["id"] as? String ?? ""
        let opts = q["options"] as? [String] ?? []
        
        let stmt = try db.prepare("""
            INSERT OR IGNORE INTO sat_question_bank
            (id, section, module, q_type, passage, question,
             option_a, option_b, option_c, option_d, answer, source_pdf, page)
            VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)
        """)
        try SQLiteDB.bind(stmt, 1, qId)
        try SQLiteDB.bind(stmt, 2, q["section"] as? String)
        try SQLiteDB.bind(stmt, 3, q["module"] as? Int)
        try SQLiteDB.bind(stmt, 4, q["type"] as? String)
        try SQLiteDB.bind(stmt, 5, q["passage"] as? String)
        try SQLiteDB.bind(stmt, 6, q["question"] as? String)
        try SQLiteDB.bind(stmt, 7, opts.count > 0 ? opts[0] : nil)
        try SQLiteDB.bind(stmt, 8, opts.count > 1 ? opts[1] : nil)
        try SQLiteDB.bind(stmt, 9, opts.count > 2 ? opts[2] : nil)
        try SQLiteDB.bind(stmt, 10, opts.count > 3 ? opts[3] : nil)
        try SQLiteDB.bind(stmt, 11, q["answer"] as? String)
        try SQLiteDB.bind(stmt, 12, q["source_pdf"] as? String)
        try SQLiteDB.bind(stmt, 13, q["page"] as? Int)
        sqlite3_step(stmt)
        stmt?.finalize()
    }
    
    try db.exec("COMMIT;")
}
```

### Performance

- Import ~3,000 rows total: ~2-3 seconds on iPhone
- Wrapped in a single transaction for speed
- Shows a brief loading spinner on first launch
- Subsequent launches skip import (DB already exists)

---

## 3. V2: Downloadable Content Packs (Future)

### Architecture

```
┌──────────┐         ┌──────────────┐         ┌─────────────┐
│  Student  │ ──────► │  Pack Store  │ ──────► │  Supabase   │
│  (iPhone) │         │  (in-app UI) │         │  Storage    │
└──────────┘         └──────────────┘         └─────────────┘
                           │
                           ▼
                     ┌──────────────┐
                     │  Local       │
                     │  SQLite      │
                     │  (import)    │
                     └──────────────┘
```

### Pack Store UI

```
┌──────────────────────────────────┐
│  Word Lists                      │
│                                  │
│  ┌────────────────────────────┐  │
│  │ ✅ SAT Core Vocabulary     │  │
│  │ 372 words · Installed      │  │
│  └────────────────────────────┘  │
│  ┌────────────────────────────┐  │
│  │ 📥 SAT Advanced            │  │
│  │ 200 words · Free           │  │
│  │            [ DOWNLOAD ]    │  │
│  └────────────────────────────┘  │
│  ┌────────────────────────────┐  │
│  │ 📥 GRE Essentials          │  │
│  │ 500 words · Free           │  │
│  │            [ DOWNLOAD ]    │  │
│  └────────────────────────────┘  │
└──────────────────────────────────┘
```

### Pack Hosting (Supabase Storage)

```
supabase-storage/
└── word-packs/
    ├── sat_core_1/
    │   ├── manifest.json       ← Pack metadata + word data
    │   └── images.zip          ← 372 images (~30MB)
    ├── sat_advanced/
    │   ├── manifest.json
    │   └── images.zip
    └── registry.json           ← List of all available packs
```

### Download Flow

```
1. App fetches registry.json → shows available packs
2. Student taps DOWNLOAD on a pack
3. Download manifest.json (word data, ~2MB)
4. Download images.zip (~30MB) with progress bar
5. Unzip images to app Documents/Images/<pack_name>/
6. Import manifest.json into SQLite (same as V1 import logic)
7. Pack appears as installed with checkmark
```

### Multi-List Support (Already in Schema)

The current schema already supports multiple lists:

```sql
-- Each downloaded pack creates a new list
INSERT INTO lists VALUES (2, 'sat_advanced', 'SAT Advanced Vocabulary', 1);

-- Words can belong to multiple lists via word_list table
-- word_state tracks progress per word (not per list)
-- If the same word appears in two packs, progress carries over
```

### What to Build for V2

| Component | Description |
|-----------|------------|
| `registry.json` on Supabase | List of available packs with metadata |
| `PackStoreView` | Browse/download packs UI |
| `PackDownloader` | Download manager with progress bar |
| `ImageZipImporter` | Unzip and move images to correct location |
| Pack-aware `DataManager` | Import from downloaded JSON (reuse V1 import logic) |
| `ImageResolver` update | Look up images in per-pack directories |

### NOT Needed for V2

- No schema migration (schema already supports multiple lists)
- No changes to learning model (works per-word, not per-list)
- No changes to UI (Practice tab works with any list)

---

## 4. Image Delivery

### V1: Bundled

- 372 JPG images in `Resources/Images/`
- Total size: ~30MB
- Loaded via `ImageResolver.uiImage(for: filename)`
- No network needed

### V2: Per-Pack Download

- Images downloaded as zip per pack
- Stored in `Documents/Images/<pack_name>/`
- `ImageResolver` updated to check pack directory first, then bundled
- Supports offline after initial download

### Image Filename Convention

```
word_list.json "word" field → image filename:
  "ephemeral"      → "ephemeral.jpg"
  "accustomed to"  → "accustomed_to.jpg"   (spaces → underscores)
  "air"            → "air.jpg"
```

This convention is consistent across both V1 and V2.

---

## 5. Summary

| Phase | What Ships | How Content Arrives | When to Build |
|-------|-----------|-------------------|---------------|
| **V1** | App + bundled JSON + images | Auto-import on first launch (~3s) | **Now** |
| **V2** | App (smaller) + pack store | Download from Supabase Storage | When second word list is ready |

The transition from V1 → V2:
1. Move bundled JSON/images to Supabase Storage
2. Add PackStoreView and PackDownloader
3. Keep V1 import logic as the pack importer (same code)
4. App size drops from ~35MB to ~5MB (words + images downloaded separately)
