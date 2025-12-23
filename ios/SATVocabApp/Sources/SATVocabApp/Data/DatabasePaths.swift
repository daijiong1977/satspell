import Foundation

enum DatabasePaths {
    static func appSupportDirectory() throws -> URL {
        let fm = FileManager.default
        let base = try fm.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let dir = base.appendingPathComponent("SATVocabApp", isDirectory: true)
        if !fm.fileExists(atPath: dir.path) {
            try fm.createDirectory(at: dir, withIntermediateDirectories: true)
        }
        return dir
    }

    static func writableDatabaseURL() throws -> URL {
        try appSupportDirectory().appendingPathComponent("data.db", isDirectory: false)
    }
}
