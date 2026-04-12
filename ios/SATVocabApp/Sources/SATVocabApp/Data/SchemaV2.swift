import Foundation

/// Complete SQLite schema DDL for SAT Vocab V2.
/// Covers all 17 tables: content (bundled), user/log (modified), and new learning-state tables.
enum SchemaV2 {

    // MARK: - CREATE TABLE statements (17 tables)

    static let createStatements: [String] = [

        // ── Content tables (read-only, bundled) ──

        """
        CREATE TABLE IF NOT EXISTS lists (
            id          INTEGER PRIMARY KEY,
            name        TEXT NOT NULL,
            description TEXT,
            version     INTEGER DEFAULT 1
        )
        """,

        """
        CREATE TABLE IF NOT EXISTS words (
            id              INTEGER PRIMARY KEY,
            lemma           TEXT NOT NULL,
            pos             TEXT,
            definition      TEXT,
            example         TEXT,
            image_filename  TEXT
        )
        """,

        """
        CREATE TABLE IF NOT EXISTS word_list (
            id      INTEGER PRIMARY KEY,
            word_id INTEGER NOT NULL REFERENCES words(id),
            list_id INTEGER NOT NULL REFERENCES lists(id),
            rank    INTEGER
        )
        """,

        """
        CREATE TABLE IF NOT EXISTS sat_contexts (
            id      INTEGER PRIMARY KEY,
            word_id INTEGER NOT NULL REFERENCES words(id),
            context TEXT NOT NULL
        )
        """,

        """
        CREATE TABLE IF NOT EXISTS collocations (
            id      INTEGER PRIMARY KEY,
            word_id INTEGER NOT NULL REFERENCES words(id),
            phrase  TEXT NOT NULL
        )
        """,

        """
        CREATE TABLE IF NOT EXISTS sat_question_bank (
            id                 TEXT PRIMARY KEY,
            word_id            INTEGER,
            target_word        TEXT,
            section            TEXT,
            module             INTEGER,
            q_type             TEXT,
            passage            TEXT,
            question           TEXT,
            option_a           TEXT,
            option_b           TEXT,
            option_c           TEXT,
            option_d           TEXT,
            answer             TEXT,
            source_pdf         TEXT,
            page               INTEGER,
            feedback_generated INTEGER DEFAULT 0,
            answer_verified    INTEGER DEFAULT 0
        )
        """,

        """
        CREATE TABLE IF NOT EXISTS word_questions (
            id          INTEGER PRIMARY KEY,
            word_id     INTEGER NOT NULL REFERENCES words(id),
            question_id TEXT NOT NULL REFERENCES sat_question_bank(id)
        )
        """,

        """
        CREATE TABLE IF NOT EXISTS deepseek_sat_feedback (
            id                INTEGER PRIMARY KEY,
            question_id       TEXT REFERENCES sat_question_bank(id),
            ai_source         TEXT,
            answer            TEXT,
            background        TEXT,
            reason_for_answer TEXT,
            created_at        TEXT
        )
        """,

        // ── User / identity ──

        """
        CREATE TABLE IF NOT EXISTS users (
            id           TEXT PRIMARY KEY,
            email        TEXT,
            supabase_uid TEXT,
            display_name TEXT,
            created_at   TEXT DEFAULT (datetime('now'))
        )
        """,

        // ── Learning-state tables (new) ──

        """
        CREATE TABLE IF NOT EXISTS word_state (
            id                INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id           TEXT NOT NULL REFERENCES users(id),
            word_id           INTEGER NOT NULL REFERENCES words(id),
            box_level         INTEGER NOT NULL DEFAULT 0,
            due_at            TEXT,
            intro_stage       INTEGER DEFAULT 0,
            memory_status     TEXT DEFAULT 'normal',
            lapse_count       INTEGER DEFAULT 0,
            consecutive_wrong INTEGER DEFAULT 0,
            total_correct     INTEGER DEFAULT 0,
            total_seen        INTEGER DEFAULT 0,
            day_touches       INTEGER DEFAULT 0,
            recent_accuracy   REAL DEFAULT 0,
            last_reviewed_at  TEXT,
            created_at        TEXT DEFAULT (datetime('now')),
            updated_at        TEXT DEFAULT (datetime('now')),
            UNIQUE(user_id, word_id)
        )
        """,

        """
        CREATE TABLE IF NOT EXISTS day_state (
            id                  INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id             TEXT NOT NULL REFERENCES users(id),
            study_day           INTEGER NOT NULL,
            zone_index          INTEGER NOT NULL,
            morning_complete    INTEGER DEFAULT 0,
            evening_complete    INTEGER DEFAULT 0,
            morning_complete_at TEXT,
            evening_complete_at TEXT,
            new_words_morning   INTEGER DEFAULT 0,
            new_words_evening   INTEGER DEFAULT 0,
            morning_accuracy    REAL DEFAULT 0,
            evening_accuracy    REAL DEFAULT 0,
            morning_xp          INTEGER DEFAULT 0,
            evening_xp          INTEGER DEFAULT 0,
            is_recovery_day     INTEGER DEFAULT 0,
            is_review_only_day  INTEGER DEFAULT 0,
            created_at          TEXT DEFAULT (datetime('now')),
            UNIQUE(user_id, study_day)
        )
        """,

        """
        CREATE TABLE IF NOT EXISTS session_state (
            id             INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id        TEXT NOT NULL REFERENCES users(id),
            session_type   TEXT NOT NULL,
            study_day      INTEGER NOT NULL,
            step_index     INTEGER DEFAULT 0,
            item_index     INTEGER DEFAULT 0,
            is_paused      INTEGER DEFAULT 0,
            show_again_ids TEXT,
            requeued_ids   TEXT,
            started_at     TEXT,
            paused_at      TEXT,
            completed_at   TEXT,
            UNIQUE(user_id, study_day, session_type)
        )
        """,

        """
        CREATE TABLE IF NOT EXISTS review_log (
            id            INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id       TEXT NOT NULL REFERENCES users(id),
            word_id       INTEGER NOT NULL REFERENCES words(id),
            list_id       INTEGER,
            outcome       TEXT NOT NULL,
            duration_ms   INTEGER,
            reviewed_at   TEXT NOT NULL,
            device_id     TEXT,
            activity_type TEXT,
            session_type  TEXT,
            study_day     INTEGER,
            superseded    INTEGER DEFAULT 0
        )
        """,

        """
        CREATE TABLE IF NOT EXISTS session (
            id            INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id       TEXT NOT NULL,
            list_id       INTEGER,
            started_at    TEXT,
            ended_at      TEXT,
            items_total   INTEGER,
            items_correct INTEGER DEFAULT 0,
            session_type  TEXT,
            study_day     INTEGER,
            xp_earned     INTEGER DEFAULT 0
        )
        """,

        """
        CREATE TABLE IF NOT EXISTS daily_stats (
            id             INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id        TEXT NOT NULL REFERENCES users(id),
            study_day      INTEGER NOT NULL,
            calendar_date  TEXT NOT NULL,
            new_count      INTEGER DEFAULT 0,
            review_count   INTEGER DEFAULT 0,
            correct_count  INTEGER DEFAULT 0,
            total_count    INTEGER DEFAULT 0,
            xp_earned      INTEGER DEFAULT 0,
            session_bonus  INTEGER DEFAULT 0,
            study_minutes  REAL DEFAULT 0,
            words_promoted INTEGER DEFAULT 0,
            words_demoted  INTEGER DEFAULT 0,
            UNIQUE(user_id, study_day)
        )
        """,

        """
        CREATE TABLE IF NOT EXISTS streak_store (
            id                INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id           TEXT NOT NULL REFERENCES users(id),
            current_streak    INTEGER DEFAULT 0,
            best_streak       INTEGER DEFAULT 0,
            last_study_date   TEXT,
            streak_3_claimed  INTEGER DEFAULT 0,
            streak_7_claimed  INTEGER DEFAULT 0,
            streak_14_claimed INTEGER DEFAULT 0,
            streak_30_claimed INTEGER DEFAULT 0,
            total_xp          INTEGER DEFAULT 0,
            total_study_days  INTEGER DEFAULT 0,
            UNIQUE(user_id)
        )
        """,

        """
        CREATE TABLE IF NOT EXISTS zone_state (
            id              INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id         TEXT NOT NULL REFERENCES users(id),
            zone_index      INTEGER NOT NULL,
            unlocked        INTEGER DEFAULT 0,
            test_passed     INTEGER DEFAULT 0,
            test_attempts   INTEGER DEFAULT 0,
            test_best_score REAL DEFAULT 0,
            unlocked_at     TEXT,
            UNIQUE(user_id, zone_index)
        )
        """,
    ]

    // MARK: - CREATE INDEX statements

    static let createIndexes: [String] = [
        // word_state
        "CREATE INDEX IF NOT EXISTS idx_word_state_due ON word_state(user_id, due_at)",
        "CREATE INDEX IF NOT EXISTS idx_word_state_box ON word_state(user_id, box_level)",
        "CREATE INDEX IF NOT EXISTS idx_word_state_status ON word_state(user_id, memory_status)",

        // day_state
        "CREATE INDEX IF NOT EXISTS idx_day_state_user ON day_state(user_id, study_day DESC)",

        // review_log
        "CREATE INDEX IF NOT EXISTS idx_review_log_word ON review_log(word_id, user_id, reviewed_at DESC)",
        "CREATE INDEX IF NOT EXISTS idx_review_log_day ON review_log(user_id, study_day)",
        "CREATE INDEX IF NOT EXISTS idx_review_log_scored ON review_log(user_id, word_id, activity_type, superseded, reviewed_at DESC)",

        // content tables
        "CREATE INDEX IF NOT EXISTS idx_word_list_rank ON word_list(list_id, rank)",
        "CREATE INDEX IF NOT EXISTS idx_sat_contexts_word ON sat_contexts(word_id)",
        "CREATE INDEX IF NOT EXISTS idx_collocations_word ON collocations(word_id)",
        "CREATE INDEX IF NOT EXISTS idx_word_questions_word ON word_questions(word_id)",
        "CREATE UNIQUE INDEX IF NOT EXISTS idx_word_questions_unique ON word_questions(word_id, question_id)",

        // daily_stats
        "CREATE INDEX IF NOT EXISTS idx_daily_stats_date ON daily_stats(user_id, calendar_date DESC)",
    ]

    // MARK: - Apply all

    /// Creates all tables and indexes. Safe to call multiple times (IF NOT EXISTS).
    static func createAll(db: SQLiteDB) throws {
        try db.exec("PRAGMA foreign_keys = ON")
        for sql in createStatements {
            try db.exec(sql)
        }
        for sql in createIndexes {
            try db.exec(sql)
        }
    }
}
