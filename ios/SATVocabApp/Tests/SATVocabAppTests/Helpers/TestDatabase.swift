import Foundation
@testable import SATVocabApp

/// Creates a fresh in-memory SQLite database with full schema for each test.
/// Usage: let db = try TestDatabase.create()
enum TestDatabase {

    /// Create in-memory DB with schema + optional test words
    static func create(withWords: Bool = false) throws -> SQLiteDB {
        let db = SQLiteDB()
        try db.open(path: ":memory:")
        try SchemaV2.createAll(db: db)

        if withWords {
            try insertTestWords(db: db)
        }
        return db
    }

    /// Insert a minimal set of test words (10 words for fast tests)
    static func insertTestWords(db: SQLiteDB, count: Int = 10) throws {
        try db.exec("INSERT INTO lists (name, description, version) VALUES ('test_list', 'Test', 1);")

        for i in 1...count {
            try db.exec("""
            INSERT INTO words (lemma, pos, definition, example, image_filename)
            VALUES ('word\(i)', 'adj.', 'definition \(i)', 'example sentence \(i)', 'word\(i).jpg');
            """)
            try db.exec("INSERT INTO word_list (word_id, list_id, rank) VALUES (\(i), 1, \(i));")

            // Add 2 SAT contexts per word
            try db.exec("INSERT INTO sat_contexts (word_id, context) VALUES (\(i), 'context A for word\(i)');")
            try db.exec("INSERT INTO sat_contexts (word_id, context) VALUES (\(i), 'context B for word\(i)');")

            // Add 1 collocation per word
            try db.exec("INSERT INTO collocations (word_id, phrase) VALUES (\(i), 'word\(i) phrase');")
        }
    }

    /// Create a test user and return userId
    static func createTestUser(db: SQLiteDB, name: String = "test_user") throws -> String {
        let userId = "test-\(UUID().uuidString.prefix(8))"
        try db.exec("INSERT INTO users (id, display_name) VALUES ('\(userId)', '\(name)');")
        try db.exec("INSERT INTO streak_store (user_id) VALUES ('\(userId)');")
        try db.exec("INSERT INTO zone_state (user_id, zone_index, unlocked) VALUES ('\(userId)', 0, 1);")
        try db.exec("INSERT INTO day_state (user_id, study_day, zone_index) VALUES ('\(userId)', 0, 0);")
        return userId
    }
}
