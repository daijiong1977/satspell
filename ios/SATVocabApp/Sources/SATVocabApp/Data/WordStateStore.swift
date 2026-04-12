import Foundation
import SQLite3

// MARK: - BoxChange

enum BoxChange {
    case none
    case promoted(from: Int, to: Int)
    case demoted(from: Int, to: Int)

    var isMastery: Bool {
        switch self {
        case .promoted(_, let to): return to >= 5
        default: return false
        }
    }
}

// MARK: - WordStateStore

actor WordStateStore {
    private let db: SQLiteDB
    private let iso = ISO8601DateFormatter()

    init(db: SQLiteDB) {
        self.db = db
    }

    // MARK: - Read Methods

    func getWordState(userId: String, wordId: Int) throws -> WordState? {
        let sql = """
        SELECT id, user_id, word_id, box_level, due_at, intro_stage,
               memory_status, lapse_count, consecutive_wrong, total_correct,
               total_seen, day_touches, recent_accuracy, last_reviewed_at
        FROM word_state
        WHERE user_id = ? AND word_id = ?
        LIMIT 1;
        """
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }
        try SQLiteDB.bind(stmt, 1, userId)
        try SQLiteDB.bind(stmt, 2, wordId)
        if sqlite3_step(stmt) == SQLITE_ROW {
            return parseWordState(stmt)
        }
        return nil
    }

    func getReviewQueue(userId: String, limit: Int) throws -> [WordState] {
        let nowStr = iso.string(from: Date())
        let sql = """
        SELECT id, user_id, word_id, box_level, due_at, intro_stage,
               memory_status, lapse_count, consecutive_wrong, total_correct,
               total_seen, day_touches, recent_accuracy, last_reviewed_at
        FROM word_state
        WHERE user_id = ? AND due_at <= ? AND box_level > 0
        ORDER BY box_level ASC,
                 CASE memory_status
                     WHEN 'stubborn' THEN 0
                     WHEN 'fragile' THEN 1
                     WHEN 'normal' THEN 2
                     WHEN 'easy' THEN 3
                     ELSE 4
                 END,
                 due_at ASC
        LIMIT ?;
        """
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }
        try SQLiteDB.bind(stmt, 1, userId)
        try SQLiteDB.bind(stmt, 2, nowStr)
        try SQLiteDB.bind(stmt, 3, limit)

        var out: [WordState] = []
        while sqlite3_step(stmt) == SQLITE_ROW {
            out.append(parseWordState(stmt))
        }
        return out
    }

    func countOverdue(userId: String) throws -> Int {
        let nowStr = iso.string(from: Date())
        let sql = """
        SELECT COUNT(*) FROM word_state
        WHERE user_id = ? AND due_at <= ? AND box_level > 0;
        """
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }
        try SQLiteDB.bind(stmt, 1, userId)
        try SQLiteDB.bind(stmt, 2, nowStr)
        if sqlite3_step(stmt) == SQLITE_ROW {
            return SQLiteDB.columnInt(stmt, 0)
        }
        return 0
    }

    func getBoxDistribution(userId: String) throws -> [Int: Int] {
        let sql = """
        SELECT box_level, COUNT(*) FROM word_state
        WHERE user_id = ?
        GROUP BY box_level;
        """
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }
        try SQLiteDB.bind(stmt, 1, userId)

        var dist: [Int: Int] = [:]
        while sqlite3_step(stmt) == SQLITE_ROW {
            let box = SQLiteDB.columnInt(stmt, 0)
            let count = SQLiteDB.columnInt(stmt, 1)
            dist[box] = count
        }
        return dist
    }

    func getStubbornWords(userId: String, limit: Int) throws -> [(lemma: String, pos: String?, lapseCount: Int, boxLevel: Int)] {
        let sql = """
        SELECT w.lemma, w.pos, ws.lapse_count, ws.box_level
        FROM word_state ws
        JOIN words w ON w.id = ws.word_id
        WHERE ws.user_id = ? AND ws.memory_status = 'stubborn'
        ORDER BY ws.lapse_count DESC, ws.consecutive_wrong DESC
        LIMIT ?;
        """
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }
        try SQLiteDB.bind(stmt, 1, userId)
        try SQLiteDB.bind(stmt, 2, limit)

        var out: [(lemma: String, pos: String?, lapseCount: Int, boxLevel: Int)] = []
        while sqlite3_step(stmt) == SQLITE_ROW {
            let lemma = SQLiteDB.columnText(stmt, 0) ?? ""
            let pos = SQLiteDB.columnText(stmt, 1)
            let lapse = SQLiteDB.columnInt(stmt, 2)
            let box = SQLiteDB.columnInt(stmt, 3)
            out.append((lemma: lemma, pos: pos, lapseCount: lapse, boxLevel: box))
        }
        return out
    }

    // MARK: - Write Methods

    func introduceWord(userId: String, wordId: Int) throws {
        print("📝 introduceWord called: wordId=\(wordId)")
        let nowStr = iso.string(from: Date())
        let sql = """
        INSERT INTO word_state(user_id, word_id, box_level, intro_stage, total_seen, memory_status, created_at, updated_at)
        VALUES (?, ?, 0, 1, 1, 'normal', ?, ?)
        ON CONFLICT(user_id, word_id) DO UPDATE SET
            intro_stage = MAX(intro_stage, 1),
            total_seen = total_seen + 1,
            updated_at = excluded.updated_at;
        """
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }
        try SQLiteDB.bind(stmt, 1, userId)
        try SQLiteDB.bind(stmt, 2, wordId)
        try SQLiteDB.bind(stmt, 3, nowStr)
        try SQLiteDB.bind(stmt, 4, nowStr)
        if sqlite3_step(stmt) != SQLITE_DONE {
            throw SQLiteError.stepFailed(message: db.errorMessage())
        }
    }

    func recordScoredAnswer(userId: String, wordId: Int, correct: Bool) throws -> BoxChange {
        print("📝 recordScoredAnswer called: wordId=\(wordId) correct=\(correct)")
        // Fetch current state
        guard var ws = try getWordState(userId: userId, wordId: wordId) else {
            // Word not yet introduced; introduce it first
            try introduceWord(userId: userId, wordId: wordId)
            return .none
        }

        let oldBox = ws.boxLevel

        // Update box level
        // Box 0 words are NOT promoted here — they wait for Day 1 promotion (runDay1Promotion)
        if correct {
            if ws.boxLevel > 0 {
                ws.boxLevel = min(ws.boxLevel + 1, 5)
            }
            // Box 0 stays at 0 — only Day 1 promotion moves 0→1 or 0→2
            ws.consecutiveWrong = 0
            ws.totalCorrect += 1
        } else {
            if ws.boxLevel > 1 {
                ws.boxLevel = 1
                ws.lapseCount += 1
            }
            // Box 0 and Box 1 stay where they are on wrong answer
            ws.consecutiveWrong += 1
        }

        ws.totalSeen += 1
        ws.dayTouches += 1

        // Recalculate recent accuracy
        ws.recentAccuracy = try computeRecentAccuracy(userId: userId, wordId: wordId, includingCurrent: correct)

        // Classify memory status
        ws.memoryStatus = classifyMemoryStatus(ws)

        // Calculate due date based on new box level
        let now = Date()
        let nowStr = iso.string(from: now)
        let dueDate: Date?
        if let interval = WordStrength(rawValue: ws.boxLevel)?.reviewIntervalDays {
            dueDate = Calendar.current.date(byAdding: .day, value: interval, to: now)
        } else {
            dueDate = nil // box 0 or mastered (5)
        }
        let dueStr: String? = dueDate.map { iso.string(from: $0) }

        let sql = """
        UPDATE word_state SET
            box_level = ?,
            due_at = ?,
            memory_status = ?,
            lapse_count = ?,
            consecutive_wrong = ?,
            total_correct = ?,
            total_seen = ?,
            day_touches = ?,
            recent_accuracy = ?,
            last_reviewed_at = ?,
            updated_at = ?
        WHERE user_id = ? AND word_id = ?;
        """
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }
        try SQLiteDB.bind(stmt, 1, ws.boxLevel)
        try SQLiteDB.bind(stmt, 2, dueStr)
        try SQLiteDB.bind(stmt, 3, ws.memoryStatus.rawValue)
        try SQLiteDB.bind(stmt, 4, ws.lapseCount)
        try SQLiteDB.bind(stmt, 5, ws.consecutiveWrong)
        try SQLiteDB.bind(stmt, 6, ws.totalCorrect)
        try SQLiteDB.bind(stmt, 7, ws.totalSeen)
        try SQLiteDB.bind(stmt, 8, ws.dayTouches)
        try SQLiteDB.bind(stmt, 9, ws.recentAccuracy)
        try SQLiteDB.bind(stmt, 10, nowStr)
        try SQLiteDB.bind(stmt, 11, nowStr)
        try SQLiteDB.bind(stmt, 12, userId)
        try SQLiteDB.bind(stmt, 13, wordId)
        if sqlite3_step(stmt) != SQLITE_DONE {
            throw SQLiteError.stepFailed(message: db.errorMessage())
        }

        // Determine box change
        if ws.boxLevel > oldBox {
            return .promoted(from: oldBox, to: ws.boxLevel)
        } else if ws.boxLevel < oldBox {
            return .demoted(from: oldBox, to: ws.boxLevel)
        }
        return .none
    }

    func runDay1Promotion(userId: String, studyDay: Int) throws -> (promoted: Int, notPromoted: Int) {
        // Find words with intro_stage IN (1,2) AND box_level = 0
        let findSQL = """
        SELECT word_id FROM word_state
        WHERE user_id = ? AND intro_stage IN (1, 2) AND box_level = 0;
        """
        let findStmt = try db.prepare(findSQL)
        defer { findStmt?.finalize() }
        try SQLiteDB.bind(findStmt, 1, userId)

        var wordIds: [Int] = []
        while sqlite3_step(findStmt) == SQLITE_ROW {
            wordIds.append(SQLiteDB.columnInt(findStmt, 0))
        }

        var promoted = 0
        var notPromoted = 0
        let now = Date()
        let nowStr = iso.string(from: now)

        for wordId in wordIds {
            // Count scored correct answers from review_log
            let countSQL = """
            SELECT
                SUM(CASE WHEN outcome = 'correct' THEN 1 ELSE 0 END) AS correct_count,
                COUNT(*) AS total_count
            FROM review_log
            WHERE user_id = ? AND word_id = ? AND study_day = ?
              AND activity_type IN ('image_game', 'quick_recall')
              AND superseded = 0;
            """
            let countStmt = try db.prepare(countSQL)
            defer { countStmt?.finalize() }
            try SQLiteDB.bind(countStmt, 1, userId)
            try SQLiteDB.bind(countStmt, 2, wordId)
            try SQLiteDB.bind(countStmt, 3, studyDay)

            var correctCount = 0
            var totalCount = 0
            if sqlite3_step(countStmt) == SQLITE_ROW {
                correctCount = SQLiteDB.columnInt(countStmt, 0)
                totalCount = SQLiteDB.columnInt(countStmt, 1)
            }

            // Check if last recall was correct (same study day)
            let lastSQL = """
            SELECT outcome FROM review_log
            WHERE user_id = ? AND word_id = ? AND study_day = ?
              AND activity_type IN ('image_game', 'quick_recall')
              AND superseded = 0
            ORDER BY reviewed_at DESC, id DESC
            LIMIT 1;
            """
            let lastStmt = try db.prepare(lastSQL)
            defer { lastStmt?.finalize() }
            try SQLiteDB.bind(lastStmt, 1, userId)
            try SQLiteDB.bind(lastStmt, 2, wordId)
            try SQLiteDB.bind(lastStmt, 3, studyDay)

            var lastCorrect = false
            if sqlite3_step(lastStmt) == SQLITE_ROW {
                let outcome = SQLiteDB.columnText(lastStmt, 0)
                lastCorrect = (outcome == "correct")
            }

            // Rule: 2/3 correct AND last recall correct -> box 2, else -> box 1
            let meetsThreshold = totalCount >= 3 && correctCount >= 2 && lastCorrect
            let newBox: Int
            let dueDays: Int
            if meetsThreshold {
                newBox = 2
                dueDays = 3
                promoted += 1
            } else {
                newBox = 1
                dueDays = 1
                notPromoted += 1
            }

            let dueDate = Calendar.current.date(byAdding: .day, value: dueDays, to: now)!
            let dueStr = iso.string(from: dueDate)

            let updateSQL = """
            UPDATE word_state SET
                box_level = ?,
                due_at = ?,
                intro_stage = 3,
                updated_at = ?
            WHERE user_id = ? AND word_id = ?;
            """
            let updateStmt = try db.prepare(updateSQL)
            defer { updateStmt?.finalize() }
            try SQLiteDB.bind(updateStmt, 1, newBox)
            try SQLiteDB.bind(updateStmt, 2, dueStr)
            try SQLiteDB.bind(updateStmt, 3, nowStr)
            try SQLiteDB.bind(updateStmt, 4, userId)
            try SQLiteDB.bind(updateStmt, 5, wordId)
            if sqlite3_step(updateStmt) != SQLITE_DONE {
                throw SQLiteError.stepFailed(message: db.errorMessage())
            }
        }

        return (promoted: promoted, notPromoted: notPromoted)
    }

    func resetDayTouches(userId: String) throws {
        let sql = "UPDATE word_state SET day_touches = 0 WHERE user_id = ?;"
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }
        try SQLiteDB.bind(stmt, 1, userId)
        if sqlite3_step(stmt) != SQLITE_DONE {
            throw SQLiteError.stepFailed(message: db.errorMessage())
        }
    }

    // MARK: - Private Helpers

    private func computeRecentAccuracy(userId: String, wordId: Int, includingCurrent correct: Bool? = nil) throws -> Double {
        let sql = """
        SELECT outcome FROM review_log
        WHERE user_id = ? AND word_id = ?
          AND outcome IN ('correct', 'incorrect')
          AND superseded = 0
        ORDER BY reviewed_at DESC
        LIMIT 5;
        """
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }
        try SQLiteDB.bind(stmt, 1, userId)
        try SQLiteDB.bind(stmt, 2, wordId)

        var outcomes: [Bool] = []
        while sqlite3_step(stmt) == SQLITE_ROW {
            let outcome = SQLiteDB.columnText(stmt, 0) ?? ""
            outcomes.append(outcome == "correct")
        }

        // If we have a current answer that hasn't been logged yet, prepend it
        if let current = correct {
            outcomes.insert(current, at: 0)
            if outcomes.count > 5 {
                outcomes = Array(outcomes.prefix(5))
            }
        }

        guard !outcomes.isEmpty else { return 0.0 }
        let correctCount = outcomes.filter { $0 }.count
        return Double(correctCount) / Double(outcomes.count)
    }

    private func classifyMemoryStatus(_ ws: WordState) -> MemoryStatus {
        if ws.lapseCount >= 3 || ws.consecutiveWrong >= 2 {
            return .stubborn
        }
        if ws.recentAccuracy < 0.6 || ws.lapseCount >= 1 {
            return .fragile
        }
        if ws.boxLevel >= 3 && ws.recentAccuracy >= 0.85 && ws.lapseCount == 0 {
            return .easy
        }
        return .normal
    }

    private func parseWordState(_ stmt: OpaquePointer?) -> WordState {
        let id = SQLiteDB.columnInt(stmt, 0)
        let userId = SQLiteDB.columnText(stmt, 1) ?? ""
        let wordId = SQLiteDB.columnInt(stmt, 2)
        let boxLevel = SQLiteDB.columnInt(stmt, 3)
        let dueAtStr = SQLiteDB.columnText(stmt, 4)
        let introStage = SQLiteDB.columnInt(stmt, 5)
        let memStatusStr = SQLiteDB.columnText(stmt, 6) ?? "normal"
        let lapseCount = SQLiteDB.columnInt(stmt, 7)
        let consecutiveWrong = SQLiteDB.columnInt(stmt, 8)
        let totalCorrect = SQLiteDB.columnInt(stmt, 9)
        let totalSeen = SQLiteDB.columnInt(stmt, 10)
        let dayTouches = SQLiteDB.columnInt(stmt, 11)
        let recentAccuracy = SQLiteDB.columnDouble(stmt, 12)
        let lastReviewedStr = SQLiteDB.columnText(stmt, 13)

        let dueAt = dueAtStr.flatMap { iso.date(from: $0) }
        let lastReviewedAt = lastReviewedStr.flatMap { iso.date(from: $0) }
        let memoryStatus = MemoryStatus(rawValue: memStatusStr) ?? .normal

        return WordState(
            id: id,
            userId: userId,
            wordId: wordId,
            boxLevel: boxLevel,
            dueAt: dueAt,
            introStage: introStage,
            memoryStatus: memoryStatus,
            lapseCount: lapseCount,
            consecutiveWrong: consecutiveWrong,
            totalCorrect: totalCorrect,
            totalSeen: totalSeen,
            dayTouches: dayTouches,
            recentAccuracy: recentAccuracy,
            lastReviewedAt: lastReviewedAt
        )
    }
}
