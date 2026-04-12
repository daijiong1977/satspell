import Foundation
import SQLite3

private let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)

enum SQLiteError: Error, CustomStringConvertible {
    case openFailed(message: String)
    case prepareFailed(message: String)
    case stepFailed(message: String)
    case bindFailed(message: String)

    var description: String {
        switch self {
        case .openFailed(let m): return "SQLite open failed: \(m)"
        case .prepareFailed(let m): return "SQLite prepare failed: \(m)"
        case .stepFailed(let m): return "SQLite step failed: \(m)"
        case .bindFailed(let m): return "SQLite bind failed: \(m)"
        }
    }
}

final class SQLiteDB: @unchecked Sendable {
    private var db: OpaquePointer?
    private let lock = NSLock()

    func open(path: String) throws {
        // Use FULLMUTEX (serialized mode) so multiple actors/threads can safely
        // share this connection. Without this, concurrent access from different
        // actor executors triggers "illegal multi-threaded access" crashes.
        let flags = SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE | SQLITE_OPEN_FULLMUTEX
        if sqlite3_open_v2(path, &db, flags, nil) != SQLITE_OK {
            throw SQLiteError.openFailed(message: String(cString: sqlite3_errmsg(db)))
        }
        // WAL mode allows concurrent reads and serializes writes without SQLITE_BUSY
        _ = sqlite3_exec(db, "PRAGMA journal_mode = WAL;", nil, nil, nil)
        // Busy timeout: wait up to 5 s for locks instead of failing immediately
        sqlite3_busy_timeout(db, 5000)
        _ = sqlite3_exec(db, "PRAGMA foreign_keys = ON;", nil, nil, nil)
    }

    func close() {
        if let db {
            sqlite3_close(db)
        }
        db = nil
    }

    func withLock<T>(_ body: () throws -> T) rethrows -> T {
        lock.lock()
        defer { lock.unlock() }
        return try body()
    }

    func prepare(_ sql: String) throws -> OpaquePointer? {
        lock.lock()
        defer { lock.unlock() }
        var stmt: OpaquePointer?
        if sqlite3_prepare_v2(db, sql, -1, &stmt, nil) != SQLITE_OK {
            throw SQLiteError.prepareFailed(message: String(cString: sqlite3_errmsg(db)))
        }
        return stmt
    }

    func exec(_ sql: String) throws {
        lock.lock()
        defer { lock.unlock() }
        var errMsg: UnsafeMutablePointer<Int8>?
        if sqlite3_exec(db, sql, nil, nil, &errMsg) != SQLITE_OK {
            let msg = errMsg.map { String(cString: $0) } ?? "unknown"
            sqlite3_free(errMsg)
            throw SQLiteError.stepFailed(message: msg)
        }
    }

    func lastInsertRowId() -> Int64 {
        sqlite3_last_insert_rowid(db)
    }

    func errorMessage() -> String {
        String(cString: sqlite3_errmsg(db))
    }
}

extension OpaquePointer {
    func finalize() {
        sqlite3_finalize(self)
    }
}

extension SQLiteDB {
    static func bind(_ stmt: OpaquePointer?, _ index: Int32, _ value: String?) throws {
        let rc: Int32
        if let v = value {
            rc = sqlite3_bind_text(stmt, index, v, -1, SQLITE_TRANSIENT)
        } else {
            rc = sqlite3_bind_null(stmt, index)
        }
        if rc != SQLITE_OK {
            throw SQLiteError.bindFailed(message: "bind text/null failed")
        }
    }

    static func bind(_ stmt: OpaquePointer?, _ index: Int32, _ value: Int?) throws {
        let rc: Int32
        if let v = value {
            rc = sqlite3_bind_int(stmt, index, Int32(v))
        } else {
            rc = sqlite3_bind_null(stmt, index)
        }
        if rc != SQLITE_OK {
            throw SQLiteError.bindFailed(message: "bind int/null failed")
        }
    }

    static func bind(_ stmt: OpaquePointer?, _ index: Int32, _ value: Int64?) throws {
        let rc: Int32
        if let v = value {
            rc = sqlite3_bind_int64(stmt, index, v)
        } else {
            rc = sqlite3_bind_null(stmt, index)
        }
        if rc != SQLITE_OK {
            throw SQLiteError.bindFailed(message: "bind int64/null failed")
        }
    }

    static func columnText(_ stmt: OpaquePointer?, _ idx: Int32) -> String? {
        guard let c = sqlite3_column_text(stmt, idx) else { return nil }
        return String(cString: c)
    }

    static func columnInt(_ stmt: OpaquePointer?, _ idx: Int32) -> Int {
        Int(sqlite3_column_int(stmt, idx))
    }

    static func columnInt64(_ stmt: OpaquePointer?, _ idx: Int32) -> Int64 {
        sqlite3_column_int64(stmt, idx)
    }

    static func columnDouble(_ stmt: OpaquePointer?, _ idx: Int32) -> Double {
        sqlite3_column_double(stmt, idx)
    }

    static func bind(_ stmt: OpaquePointer?, _ index: Int32, _ value: Double?) throws {
        let rc: Int32
        if let v = value {
            rc = sqlite3_bind_double(stmt, index, v)
        } else {
            rc = sqlite3_bind_null(stmt, index)
        }
        if rc != SQLITE_OK {
            throw SQLiteError.bindFailed(message: "bind double/null failed")
        }
    }
}
