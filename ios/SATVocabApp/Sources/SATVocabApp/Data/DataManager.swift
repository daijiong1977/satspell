import Foundation
import SQLite3

actor DataManager {
    static let shared = DataManager()

    private let db = SQLiteDB()
    private var isInitialized = false

    private init() {}

    deinit {
        db.close()
    }

    func initializeIfNeeded() throws {
        if isInitialized { return }

        let fm = FileManager.default
        let writableURL = try DatabasePaths.writableDatabaseURL()

        if !fm.fileExists(atPath: writableURL.path) {
            guard let bundledURL = Bundle.main.url(forResource: AppConfig.bundledDatabaseName, withExtension: AppConfig.bundledDatabaseExtension) else {
                throw NSError(domain: "SATVocabApp", code: 1, userInfo: [NSLocalizedDescriptionKey: "Missing bundled data.db. Add data.db to Copy Bundle Resources."])
            }
            try fm.copyItem(at: bundledURL, to: writableURL)
        }

        try db.open(path: writableURL.path)

        let userId = LocalIdentity.userId()
        try ensureUserExists(userId: userId)

        isInitialized = true
    }

    // MARK: - Users

    func ensureUserExists(userId: String) throws {
        let sql = "INSERT OR IGNORE INTO users(id, email) VALUES (?, NULL);"
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }
        try SQLiteDB.bind(stmt, 1, userId)
        if sqlite3_step(stmt) != SQLITE_DONE {
            throw SQLiteError.stepFailed(message: db.errorMessage())
        }
    }

    // MARK: - Lists

    func getDefaultList() throws -> ListInfo {
        let sql = """
        SELECT id, name, description, version
        FROM lists
        ORDER BY CASE WHEN name=? THEN 0 ELSE 1 END, id
        LIMIT 1;
        """
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }
        try SQLiteDB.bind(stmt, 1, AppConfig.defaultListName)
        if sqlite3_step(stmt) == SQLITE_ROW {
            let id = SQLiteDB.columnInt(stmt, 0)
            let name = SQLiteDB.columnText(stmt, 1) ?? ""
            let description = SQLiteDB.columnText(stmt, 2)
            let version = SQLiteDB.columnInt(stmt, 3)
            return ListInfo(id: id, name: name, description: description, version: version)
        }
        throw SQLiteError.stepFailed(message: "No list found")
    }

    // MARK: - Queue

    func fetchSessionQueue(listId: Int, limit: Int, startIndex: Int) throws -> [VocabCard] {
        // Deterministic sequential ordering (no jumping): offset = startIndex % totalInList
        let total = try countWordsInList(listId: listId)
        if total == 0 { return [] }
        let offset = ((startIndex % total) + total) % total

        // Fetch with wrap-around using two queries.
        let first = try fetchOrderedWords(listId: listId, limit: min(limit, total), offset: offset)
        if first.count >= limit { return first }
        let remaining = limit - first.count
        let second = try fetchOrderedWords(listId: listId, limit: remaining, offset: 0)
        return first + second
    }

    func fetchReviewQueue(userId: String, listId: Int, limit: Int) throws -> [VocabCard] {
        try fetchReviewQueue(userId: userId, listId: listId, limit: limit, restrictToWordIds: nil)
    }

    func fetchReviewQueue(userId: String, listId: Int, limit: Int, restrictToWordIds: [Int]?) throws -> [VocabCard] {
        // Words that currently "need review" are those whose latest logged outcome is incorrect.
        // Optionally restrict to a known subset of word IDs (e.g., zone difficulty review).

        if let ids = restrictToWordIds, ids.isEmpty {
            return []
        }

        let wordFilterSql: String
        if let ids = restrictToWordIds {
            let placeholders = Array(repeating: "?", count: ids.count).joined(separator: ",")
            wordFilterSql = "AND l.word_id IN (\(placeholders))"
        } else {
            wordFilterSql = ""
        }

        let sql = """
        WITH latest AS (
            SELECT rl.word_id,
                   rl.outcome,
                   rl.reviewed_at,
                   ROW_NUMBER() OVER (PARTITION BY rl.word_id ORDER BY rl.reviewed_at DESC) AS rn
            FROM review_log rl
            JOIN word_list wl ON wl.word_id = rl.word_id AND wl.list_id = ?
            WHERE rl.user_id = ?
        )
        SELECT w.id, w.lemma, w.pos, w.definition, w.example, w.image_filename
        FROM latest l
        JOIN words w ON w.id = l.word_id
        WHERE l.rn = 1
          AND l.outcome = 'incorrect'
          \(wordFilterSql)
        ORDER BY l.reviewed_at DESC
        LIMIT ?;
        """

        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }

        var bindIndex: Int32 = 1
        try SQLiteDB.bind(stmt, bindIndex, listId)
        bindIndex += 1
        try SQLiteDB.bind(stmt, bindIndex, userId)
        bindIndex += 1

        if let ids = restrictToWordIds {
            for id in ids {
                try SQLiteDB.bind(stmt, bindIndex, id)
                bindIndex += 1
            }
        }

        try SQLiteDB.bind(stmt, bindIndex, limit)

        var out: [VocabCard] = []
        while sqlite3_step(stmt) == SQLITE_ROW {
            out.append(VocabCard(
                id: SQLiteDB.columnInt(stmt, 0),
                lemma: SQLiteDB.columnText(stmt, 1) ?? "",
                pos: SQLiteDB.columnText(stmt, 2),
                definition: SQLiteDB.columnText(stmt, 3),
                example: SQLiteDB.columnText(stmt, 4),
                imageFilename: SQLiteDB.columnText(stmt, 5)
            ))
        }
        return out
    }

    private func countWordsInList(listId: Int) throws -> Int {
        let sql = "SELECT COUNT(*) FROM word_list WHERE list_id=?;"
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }
        try SQLiteDB.bind(stmt, 1, listId)
        if sqlite3_step(stmt) == SQLITE_ROW {
            return SQLiteDB.columnInt(stmt, 0)
        }
        return 0
    }

    private func fetchOrderedWords(listId: Int, limit: Int, offset: Int) throws -> [VocabCard] {
        let sql = """
        SELECT w.id, w.lemma, w.pos, w.definition, w.example, w.image_filename
        FROM word_list wl
        JOIN words w ON w.id = wl.word_id
        WHERE wl.list_id = ?
        ORDER BY COALESCE(wl.rank, 999999), w.id
        LIMIT ? OFFSET ?;
        """
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }
        try SQLiteDB.bind(stmt, 1, listId)
        try SQLiteDB.bind(stmt, 2, limit)
        try SQLiteDB.bind(stmt, 3, offset)

        var out: [VocabCard] = []
        while sqlite3_step(stmt) == SQLITE_ROW {
            out.append(VocabCard(
                id: SQLiteDB.columnInt(stmt, 0),
                lemma: SQLiteDB.columnText(stmt, 1) ?? "",
                pos: SQLiteDB.columnText(stmt, 2),
                definition: SQLiteDB.columnText(stmt, 3),
                example: SQLiteDB.columnText(stmt, 4),
                imageFilename: SQLiteDB.columnText(stmt, 5)
            ))
        }
        return out
    }

    // MARK: - Words

    func fetchWordById(wordId: Int) throws -> VocabCard? {
        let sql = """
        SELECT id, lemma, pos, definition, example, image_filename
        FROM words
        WHERE id = ?
        LIMIT 1;
        """
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }

        try SQLiteDB.bind(stmt, 1, wordId)
        if sqlite3_step(stmt) == SQLITE_ROW {
            return VocabCard(
                id: SQLiteDB.columnInt(stmt, 0),
                lemma: SQLiteDB.columnText(stmt, 1) ?? "",
                pos: SQLiteDB.columnText(stmt, 2),
                definition: SQLiteDB.columnText(stmt, 3),
                example: SQLiteDB.columnText(stmt, 4),
                imageFilename: SQLiteDB.columnText(stmt, 5)
            )
        }
        return nil
    }

    // MARK: - Contexts

    func randomSatContext(wordId: Int) throws -> String? {
        let sql = """
        SELECT context
        FROM sat_contexts
        WHERE word_id = ?
        ORDER BY RANDOM()
        LIMIT 1;
        """
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }
        try SQLiteDB.bind(stmt, 1, wordId)
        if sqlite3_step(stmt) == SQLITE_ROW {
            return SQLiteDB.columnText(stmt, 0)
        }
        return nil
    }

    func fetchCollocations(wordId: Int, limit: Int = 6) throws -> [String] {
        let sql = """
        SELECT phrase
        FROM collocations
        WHERE word_id = ?
        ORDER BY id
        LIMIT ?;
        """
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }
        try SQLiteDB.bind(stmt, 1, wordId)
        try SQLiteDB.bind(stmt, 2, limit)

        var out: [String] = []
        while sqlite3_step(stmt) == SQLITE_ROW {
            if let phrase = SQLiteDB.columnText(stmt, 0), !phrase.isEmpty {
                out.append(phrase)
            }
        }
        return out
    }

    // MARK: - Review Log

    func logReview(userId: String, wordId: Int, listId: Int?, outcome: ReviewOutcome, durationMs: Int, reviewedAt: Date, deviceId: String) throws {
        let sql = """
        INSERT INTO review_log(user_id, word_id, list_id, outcome, duration_ms, reviewed_at, device_id)
        VALUES (?, ?, ?, ?, ?, ?, ?);
        """
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }

        let iso = ISO8601DateFormatter()
        let reviewedAtStr = iso.string(from: reviewedAt)

        try SQLiteDB.bind(stmt, 1, userId)
        try SQLiteDB.bind(stmt, 2, wordId)
        try SQLiteDB.bind(stmt, 3, listId)
        try SQLiteDB.bind(stmt, 4, outcome.rawValue)
        try SQLiteDB.bind(stmt, 5, durationMs)
        try SQLiteDB.bind(stmt, 6, reviewedAtStr)
        try SQLiteDB.bind(stmt, 7, deviceId)

        if sqlite3_step(stmt) != SQLITE_DONE {
            throw SQLiteError.stepFailed(message: db.errorMessage())
        }
    }

    // MARK: - Session

    func startSession(userId: String, listId: Int?, itemsTotal: Int, startedAt: Date = Date()) throws -> Int {
        let sql = """
        INSERT INTO session(user_id, list_id, started_at, items_total, items_correct)
        VALUES (?, ?, ?, ?, 0);
        """
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }

        let iso = ISO8601DateFormatter()
        let startedAtStr = iso.string(from: startedAt)

        try SQLiteDB.bind(stmt, 1, userId)
        try SQLiteDB.bind(stmt, 2, listId)
        try SQLiteDB.bind(stmt, 3, startedAtStr)
        try SQLiteDB.bind(stmt, 4, itemsTotal)

        if sqlite3_step(stmt) != SQLITE_DONE {
            throw SQLiteError.stepFailed(message: db.errorMessage())
        }
        return Int(db.lastInsertRowId())
    }

    func finishSession(sessionId: Int, itemsCorrect: Int, endedAt: Date = Date()) throws {
        let sql = """
        UPDATE session
        SET ended_at = ?, items_correct = ?
        WHERE id = ?;
        """
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }

        let iso = ISO8601DateFormatter()
        let endedAtStr = iso.string(from: endedAt)

        try SQLiteDB.bind(stmt, 1, endedAtStr)
        try SQLiteDB.bind(stmt, 2, itemsCorrect)
        try SQLiteDB.bind(stmt, 3, sessionId)

        if sqlite3_step(stmt) != SQLITE_DONE {
            throw SQLiteError.stepFailed(message: db.errorMessage())
        }
    }

    // MARK: - Progress Snapshot

    func ensureProgressSnapshot(userId: String, listId: Int) throws {
        let sql = """
        INSERT OR IGNORE INTO progress_snapshot(user_id, list_id, mastered_count, total_seen, streak_days, last_reviewed_at, version)
        VALUES (?, ?, 0, 0, 0, NULL, 1);
        """
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }
        try SQLiteDB.bind(stmt, 1, userId)
        try SQLiteDB.bind(stmt, 2, listId)
        if sqlite3_step(stmt) != SQLITE_DONE {
            throw SQLiteError.stepFailed(message: db.errorMessage())
        }
    }

    func fetchProgressSnapshot(userId: String, listId: Int) throws -> ProgressSnapshot? {
        let sql = """
        SELECT user_id, list_id, mastered_count, total_seen, streak_days, last_reviewed_at, version
        FROM progress_snapshot
        WHERE user_id = ? AND list_id = ?
        LIMIT 1;
        """
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }
        try SQLiteDB.bind(stmt, 1, userId)
        try SQLiteDB.bind(stmt, 2, listId)
        if sqlite3_step(stmt) == SQLITE_ROW {
            let userId = SQLiteDB.columnText(stmt, 0) ?? ""
            let listId = SQLiteDB.columnInt(stmt, 1)
            let mastered = SQLiteDB.columnInt(stmt, 2)
            let totalSeen = SQLiteDB.columnInt(stmt, 3)
            let streak = SQLiteDB.columnInt(stmt, 4)
            let lastStr = SQLiteDB.columnText(stmt, 5)
            let version = SQLiteDB.columnInt(stmt, 6)

            var lastDate: Date? = nil
            if let lastStr {
                lastDate = ISO8601DateFormatter().date(from: lastStr)
            }

            return ProgressSnapshot(userId: userId, listId: listId, masteredCount: mastered, totalSeen: totalSeen, streakDays: streak, lastReviewedAt: lastDate, version: version)
        }
        return nil
    }

    func updateProgressAfterSession(userId: String, listId: Int, itemsTotal: Int, itemsCorrect: Int, finishedAt: Date = Date()) throws {
        try ensureProgressSnapshot(userId: userId, listId: listId)

        let iso = ISO8601DateFormatter()
        let finishedStr = iso.string(from: finishedAt)

        let current = try fetchProgressSnapshot(userId: userId, listId: listId)
        let calendar = Calendar.current

        var newStreak = current?.streakDays ?? 0
        if let last = current?.lastReviewedAt {
            if calendar.isDateInToday(last) {
                // keep streak
            } else if calendar.isDate(last, inSameDayAs: calendar.date(byAdding: .day, value: -1, to: finishedAt) ?? last) {
                newStreak += 1
            } else {
                newStreak = 1
            }
        } else {
            newStreak = 1
        }

        let sql = """
        UPDATE progress_snapshot
        SET mastered_count = mastered_count + ?,
            total_seen = total_seen + ?,
            streak_days = ?,
            last_reviewed_at = ?
        WHERE user_id = ? AND list_id = ?;
        """
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }

        try SQLiteDB.bind(stmt, 1, itemsCorrect)
        try SQLiteDB.bind(stmt, 2, itemsTotal)
        try SQLiteDB.bind(stmt, 3, newStreak)
        try SQLiteDB.bind(stmt, 4, finishedStr)
        try SQLiteDB.bind(stmt, 5, userId)
        try SQLiteDB.bind(stmt, 6, listId)

        if sqlite3_step(stmt) != SQLITE_DONE {
            throw SQLiteError.stepFailed(message: db.errorMessage())
        }
    }

    // MARK: - Task 3

    func fetchWeakWords(userId: String, listId: Int, limit: Int) throws -> [Int] {
        // Weak words heuristic:
        // - at least 3 attempts
        // - correct_rate < 0.7
        // Ordered by worst first.
        let sql = """
        SELECT rl.word_id
        FROM review_log rl
        JOIN word_list wl ON wl.word_id = rl.word_id AND wl.list_id = ?
        WHERE rl.user_id = ?
        GROUP BY rl.word_id
        HAVING COUNT(*) >= 3
           AND (SUM(CASE WHEN rl.outcome='correct' THEN 1 ELSE 0 END) * 1.0 / COUNT(*)) < 0.7
        ORDER BY (SUM(CASE WHEN rl.outcome='correct' THEN 1 ELSE 0 END) * 1.0 / COUNT(*)) ASC
        LIMIT ?;
        """
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }

        try SQLiteDB.bind(stmt, 1, listId)
        try SQLiteDB.bind(stmt, 2, userId)
        try SQLiteDB.bind(stmt, 3, limit)

        var out: [Int] = []
        while sqlite3_step(stmt) == SQLITE_ROW {
            out.append(SQLiteDB.columnInt(stmt, 0))
        }
        return out
    }

    func fetchDistractors(listId: Int, pos: String?, excludeWordId: Int, limit: Int) throws -> [VocabCard] {
        // Prefer same POS if available.
        let sqlWithPos = """
        SELECT w.id, w.lemma, w.pos, w.definition, w.example, w.image_filename
        FROM word_list wl
        JOIN words w ON w.id = wl.word_id
        WHERE wl.list_id = ? AND w.id != ? AND w.pos = ?
        ORDER BY RANDOM()
        LIMIT ?;
        """
        let sqlNoPos = """
        SELECT w.id, w.lemma, w.pos, w.definition, w.example, w.image_filename
        FROM word_list wl
        JOIN words w ON w.id = wl.word_id
        WHERE wl.list_id = ? AND w.id != ?
        ORDER BY RANDOM()
        LIMIT ?;
        """

        var out: [VocabCard] = []

        if let pos, !pos.isEmpty {
            let stmt = try db.prepare(sqlWithPos)
            defer { stmt?.finalize() }
            try SQLiteDB.bind(stmt, 1, listId)
            try SQLiteDB.bind(stmt, 2, excludeWordId)
            try SQLiteDB.bind(stmt, 3, pos)
            try SQLiteDB.bind(stmt, 4, limit)
            while sqlite3_step(stmt) == SQLITE_ROW {
                out.append(VocabCard(
                    id: SQLiteDB.columnInt(stmt, 0),
                    lemma: SQLiteDB.columnText(stmt, 1) ?? "",
                    pos: SQLiteDB.columnText(stmt, 2),
                    definition: SQLiteDB.columnText(stmt, 3),
                    example: SQLiteDB.columnText(stmt, 4),
                    imageFilename: SQLiteDB.columnText(stmt, 5)
                ))
            }
        }

        if out.count < limit {
            let remaining = limit - out.count
            let stmt = try db.prepare(sqlNoPos)
            defer { stmt?.finalize() }
            try SQLiteDB.bind(stmt, 1, listId)
            try SQLiteDB.bind(stmt, 2, excludeWordId)
            try SQLiteDB.bind(stmt, 3, remaining)
            while sqlite3_step(stmt) == SQLITE_ROW {
                out.append(VocabCard(
                    id: SQLiteDB.columnInt(stmt, 0),
                    lemma: SQLiteDB.columnText(stmt, 1) ?? "",
                    pos: SQLiteDB.columnText(stmt, 2),
                    definition: SQLiteDB.columnText(stmt, 3),
                    example: SQLiteDB.columnText(stmt, 4),
                    imageFilename: SQLiteDB.columnText(stmt, 5)
                ))
            }
        }

        // Ensure uniqueness by id.
        var seen = Set<Int>()
        return out.filter { seen.insert($0.id).inserted }.prefix(limit).map { $0 }
    }

    func fetchSatQuestionsForWord(wordId: Int, limit: Int, verifiedOnly: Bool) throws -> [SatQuestion] {
        let lemma = (try fetchWordById(wordId: wordId)?.lemma ?? "").trimmingCharacters(in: .whitespacesAndNewlines)

         let sql = """
         WITH fb AS (
             SELECT question_id,
                 answer AS deepseek_answer,
                 background AS deepseek_background,
                 reason_for_answer AS deepseek_reason,
                 ROW_NUMBER() OVER (PARTITION BY question_id ORDER BY created_at DESC, id DESC) AS rn
             FROM deepseek_sat_feedback
             WHERE ai_source = 'deepseek'
         )
         SELECT q.id, q.word_id, q.target_word, q.section, q.module, q.q_type,
             q.passage, q.question, q.option_a, q.option_b, q.option_c, q.option_d,
             q.answer, q.source_pdf, q.page,
             q.feedback_generated, q.answer_verified,
             fb.deepseek_answer, fb.deepseek_background, fb.deepseek_reason
         FROM sat_question_bank q
         JOIN word_questions wq ON wq.question_id = q.id
         LEFT JOIN fb ON fb.question_id = q.id AND fb.rn = 1
         WHERE wq.word_id = ?
           AND (? = 0 OR q.answer_verified = 1)
           AND q.answer IS NOT NULL AND TRIM(q.answer) <> ''
           AND q.option_a IS NOT NULL AND TRIM(q.option_a) <> ''
           AND q.option_b IS NOT NULL AND TRIM(q.option_b) <> ''
           AND q.option_c IS NOT NULL AND TRIM(q.option_c) <> ''
           AND q.option_d IS NOT NULL AND TRIM(q.option_d) <> ''
         ORDER BY RANDOM()
         LIMIT ?;
         """
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }

        try SQLiteDB.bind(stmt, 1, wordId)
        try SQLiteDB.bind(stmt, 2, verifiedOnly ? 1 : 0)
        try SQLiteDB.bind(stmt, 3, limit)

        var out: [SatQuestion] = []
        while sqlite3_step(stmt) == SQLITE_ROW {
            out.append(SatQuestion(
                id: SQLiteDB.columnText(stmt, 0) ?? "",
                wordId: sqlite3_column_type(stmt, 1) == SQLITE_NULL ? nil : SQLiteDB.columnInt(stmt, 1),
                targetWord: SQLiteDB.columnText(stmt, 2),
                section: SQLiteDB.columnText(stmt, 3),
                module: sqlite3_column_type(stmt, 4) == SQLITE_NULL ? nil : SQLiteDB.columnInt(stmt, 4),
                qType: SQLiteDB.columnText(stmt, 5),
                passage: SQLiteDB.columnText(stmt, 6),
                question: SQLiteDB.columnText(stmt, 7),
                optionA: SQLiteDB.columnText(stmt, 8),
                optionB: SQLiteDB.columnText(stmt, 9),
                optionC: SQLiteDB.columnText(stmt, 10),
                optionD: SQLiteDB.columnText(stmt, 11),
                answer: SQLiteDB.columnText(stmt, 12),
                sourcePdf: SQLiteDB.columnText(stmt, 13),
                page: sqlite3_column_type(stmt, 14) == SQLITE_NULL ? nil : SQLiteDB.columnInt(stmt, 14),
                feedbackGenerated: SQLiteDB.columnInt(stmt, 15),
                answerVerified: SQLiteDB.columnInt(stmt, 16),
                deepseekAnswer: SQLiteDB.columnText(stmt, 17),
                deepseekBackground: SQLiteDB.columnText(stmt, 18),
                deepseekReason: SQLiteDB.columnText(stmt, 19)
            ))
        }

        // Prefer questions where the *correct* answer is the target lemma.
        // This keeps Task 4 aligned: keyword == the word you're trying to pick.
        if !lemma.isEmpty {
            let preferred = out.filter { q in
                Self.answerMatchesTargetWord(answer: q.answer, targetWord: lemma)
            }
            if !preferred.isEmpty {
                return Array(preferred.prefix(limit))
            }
        }

        return out
    }

    private static func normalizedComparable(_ s: String) -> String {
        var t = s.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        // Collapse whitespace
        t = t.split(whereSeparator: { $0.isWhitespace }).joined(separator: " ")

        // Trim leading/trailing punctuation/quotes (so "Indeed," matches "indeed")
        let trimSet = CharacterSet.punctuationCharacters
            .union(.whitespacesAndNewlines)
            .union(CharacterSet(charactersIn: "\"\u{201C}\u{201D}\u{2018}\u{2019}"))

        while let first = t.unicodeScalars.first, trimSet.contains(first) {
            t = String(t.unicodeScalars.dropFirst())
        }
        while let last = t.unicodeScalars.last, trimSet.contains(last) {
            t = String(t.unicodeScalars.dropLast())
        }
        return t
    }

    private static func answerMatchesTargetWord(answer: String?, targetWord: String) -> Bool {
        let a = normalizedComparable(answer ?? "")
        let w = normalizedComparable(targetWord)
        guard !a.isEmpty, !w.isEmpty else { return false }

        if a == w { return true }

        // If the answer is longer text (rare), allow whole-word containment.
        if w.contains(" ") {
            return a.contains(w)
        }

        let pattern = "\\b" + NSRegularExpression.escapedPattern(for: w) + "\\b"
        let re = (try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]))
        let range = NSRange(location: 0, length: (a as NSString).length)
        return re?.firstMatch(in: a, range: range) != nil
    }
}
