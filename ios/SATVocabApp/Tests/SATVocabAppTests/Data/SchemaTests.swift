import XCTest
import SQLite3
@testable import SATVocabApp

final class SchemaTests: XCTestCase {

    func testSchemaCreatesAllTables() throws {
        let db = try TestDatabase.create()

        let expectedTables = [
            "lists", "words", "word_list", "sat_contexts", "collocations",
            "sat_question_bank", "word_questions", "deepseek_sat_feedback",
            "users", "word_state", "day_state", "session_state",
            "review_log", "session", "daily_stats", "streak_store", "zone_state"
        ]

        for table in expectedTables {
            let stmt = try db.prepare("SELECT name FROM sqlite_master WHERE type='table' AND name=?")
            defer { stmt?.finalize() }
            try SQLiteDB.bind(stmt, 1, table)
            XCTAssertEqual(sqlite3_step(stmt), SQLITE_ROW, "Table '\(table)' should exist")
        }
    }

    func testSchemaIsIdempotent() throws {
        let db = try TestDatabase.create()
        // Running createAll twice should not fail
        XCTAssertNoThrow(try SchemaV2.createAll(db: db))
    }

    func testForeignKeysEnabled() throws {
        let db = try TestDatabase.create()
        let stmt = try db.prepare("PRAGMA foreign_keys;")
        defer { stmt?.finalize() }
        guard sqlite3_step(stmt) == SQLITE_ROW else { XCTFail(); return }
        XCTAssertEqual(SQLiteDB.columnInt(stmt, 0), 1, "Foreign keys should be enabled")
    }
}
