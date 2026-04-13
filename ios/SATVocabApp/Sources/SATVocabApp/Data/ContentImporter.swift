import Foundation
import SQLite3

// MARK: - Import errors

enum ImportError: Error, CustomStringConvertible {
    case bundleResourceNotFound(name: String)
    case jsonDecodingFailed(name: String, underlying: Error)
    case insertFailed(table: String, message: String)

    var description: String {
        switch self {
        case .bundleResourceNotFound(let n): return "Bundle resource not found: \(n)"
        case .jsonDecodingFailed(let n, let e): return "JSON decoding failed for \(n): \(e)"
        case .insertFailed(let t, let m): return "Insert into \(t) failed: \(m)"
        }
    }
}

// MARK: - JSON shapes

private struct WordEntry: Decodable {
    let word: String
    let pos: String?
    let definition: String?
    let example: String?
    let sat_context: [String]?
    let collocation: [String]?
    let sat_questions: [EmbeddedQuestion]?
}

private struct EmbeddedQuestion: Decodable {
    let id: String
    let section: String?
    let module: Int?
    let type: String?
    let passage: String?
    let question: String?
    let options: QuestionOptions?
    let answer: String?
    let source_pdf: String?
    let page: Int?
}

private enum QuestionOptions: Decodable {
    case array([String])
    case dict([String: String])

    init(from decoder: Decoder) throws {
        if let arr = try? decoder.singleValueContainer().decode([String].self) {
            self = .array(arr)
        } else if let dict = try? decoder.singleValueContainer().decode([String: String].self) {
            self = .dict(dict)
        } else {
            self = .array([])
        }
    }

    var abcd: (String?, String?, String?, String?) {
        switch self {
        case .array(let a):
            return (a.indices.contains(0) ? a[0] : nil,
                    a.indices.contains(1) ? a[1] : nil,
                    a.indices.contains(2) ? a[2] : nil,
                    a.indices.contains(3) ? a[3] : nil)
        case .dict(let d):
            return (d["A"] ?? d["a"], d["B"] ?? d["b"], d["C"] ?? d["c"], d["D"] ?? d["d"])
        }
    }
}

private struct StandaloneQuestion: Decodable {
    let id: String
    let section: String?
    let module: Int?
    let type: String?
    let passage: String?
    let question: String?
    let options: QuestionOptions?
    let answer: String?
    let source_pdf: String?
    let page: Int?
}

// MARK: - ContentImporter

actor ContentImporter {

    /// Import bundled JSON content into the given SQLite database.
    /// Must be called AFTER SchemaV2.createAll(db:).
    static func importBundledContent(db: SQLiteDB) throws {
        // --- Load JSON data ---
        let words = try loadJSON([WordEntry].self, resource: "word_list", ext: "json")
        let standaloneQuestions = try loadJSON([StandaloneQuestion].self, resource: "sat_reading_questions_deduplicated", ext: "json")

        // --- Begin transaction ---
        try db.exec("BEGIN TRANSACTION")

        do {
            // 1. Insert list
            try insertRow(db: db, sql: "INSERT INTO lists(name, description, version) VALUES (?, ?, 1)",
                          bindings: [.text("sat_core_1"), .text("Core Vocabulary List")])
            let listId = Int(db.lastInsertRowId())

            // 2. Insert words + word_list + sat_contexts + collocations + embedded questions
            // Track all question IDs already inserted to avoid duplicates
            var insertedQuestionIds = Set<String>()

            for (rank, entry) in words.enumerated() {
                let imageFilename = entry.word.replacingOccurrences(of: " ", with: "_") + ".jpg"

                // words
                try insertRow(db: db, sql: "INSERT INTO words(lemma, pos, definition, example, image_filename) VALUES (?, ?, ?, ?, ?)",
                              bindings: [.text(entry.word), .textOpt(entry.pos), .textOpt(entry.definition), .textOpt(entry.example), .text(imageFilename)])
                let wordId = Int(db.lastInsertRowId())

                // word_list
                try insertRow(db: db, sql: "INSERT INTO word_list(word_id, list_id, rank) VALUES (?, ?, ?)",
                              bindings: [.int(wordId), .int(listId), .int(rank)])

                // sat_contexts
                if let contexts = entry.sat_context {
                    for ctx in contexts {
                        try insertRow(db: db, sql: "INSERT INTO sat_contexts(word_id, context) VALUES (?, ?)",
                                      bindings: [.int(wordId), .text(ctx)])
                    }
                }

                // collocations
                if let colls = entry.collocation {
                    for phrase in colls {
                        try insertRow(db: db, sql: "INSERT INTO collocations(word_id, phrase) VALUES (?, ?)",
                                      bindings: [.int(wordId), .text(phrase)])
                    }
                }

                // embedded sat_questions
                if let questions = entry.sat_questions {
                    for q in questions {
                        if !insertedQuestionIds.contains(q.id) {
                            let opts = q.options?.abcd ?? (nil, nil, nil, nil)
                            try insertRow(db: db,
                                sql: """
                                INSERT INTO sat_question_bank(id, word_id, target_word, section, module, q_type, passage, question, option_a, option_b, option_c, option_d, answer, source_pdf, page)
                                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                                """,
                                bindings: [
                                    .text(q.id), .int(wordId), .text(entry.word),
                                    .textOpt(q.section), .intOpt(q.module), .textOpt(q.type),
                                    .textOpt(q.passage), .textOpt(q.question),
                                    .textOpt(opts.0), .textOpt(opts.1), .textOpt(opts.2), .textOpt(opts.3),
                                    .textOpt(q.answer), .textOpt(q.source_pdf), .intOpt(q.page)
                                ])
                            insertedQuestionIds.insert(q.id)
                        }

                        // word_questions link
                        try insertRow(db: db,
                            sql: "INSERT OR IGNORE INTO word_questions(word_id, question_id) VALUES (?, ?)",
                            bindings: [.int(wordId), .text(q.id)])
                    }
                }
            }

            // 3. Insert standalone questions (sat_reading_questions_deduplicated.json)
            for q in standaloneQuestions {
                if insertedQuestionIds.contains(q.id) { continue }
                let opts = q.options?.abcd ?? (nil, nil, nil, nil)
                try insertRow(db: db,
                    sql: """
                    INSERT INTO sat_question_bank(id, section, module, q_type, passage, question, option_a, option_b, option_c, option_d, answer, source_pdf, page)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                    """,
                    bindings: [
                        .text(q.id),
                        .textOpt(q.section), .intOpt(q.module), .textOpt(q.type),
                        .textOpt(q.passage), .textOpt(q.question),
                        .textOpt(opts.0), .textOpt(opts.1), .textOpt(opts.2), .textOpt(opts.3),
                        .textOpt(q.answer), .textOpt(q.source_pdf), .intOpt(q.page)
                    ])
                insertedQuestionIds.insert(q.id)
            }

            try db.exec("COMMIT")
        } catch {
            try? db.exec("ROLLBACK")
            throw error
        }
    }

    // MARK: - Helpers

    private enum BindValue {
        case text(String)
        case textOpt(String?)
        case int(Int)
        case intOpt(Int?)
    }

    private static func loadJSON<T: Decodable>(_ type: T.Type, resource: String, ext: String) throws -> T {
        guard let url = Bundle.main.url(forResource: resource, withExtension: ext) else {
            throw ImportError.bundleResourceNotFound(name: "\(resource).\(ext)")
        }
        let data = try Data(contentsOf: url)
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw ImportError.jsonDecodingFailed(name: "\(resource).\(ext)", underlying: error)
        }
    }

    private static func insertRow(db: SQLiteDB, sql: String, bindings: [BindValue]) throws {
        let stmt = try db.prepare(sql)
        defer { stmt?.finalize() }

        for (i, val) in bindings.enumerated() {
            let idx = Int32(i + 1)
            switch val {
            case .text(let s):
                try SQLiteDB.bind(stmt, idx, s)
            case .textOpt(let s):
                try SQLiteDB.bind(stmt, idx, s)
            case .int(let v):
                try SQLiteDB.bind(stmt, idx, v)
            case .intOpt(let v):
                try SQLiteDB.bind(stmt, idx, v)
            }
        }

        if sqlite3_step(stmt) != SQLITE_DONE {
            throw ImportError.insertFailed(table: sql, message: db.errorMessage())
        }
    }
}
