import Foundation

enum LocalIdentity {
    private static let userIdKey = "local.user_id"
    private static let deviceIdKey = "local.device_id"
    private static let learningStartDateKey = "local.learning_start_date"

    static func userId() -> String {
        if let v = UserDefaults.standard.string(forKey: userIdKey) {
            return v
        }
        let v = UUID().uuidString
        UserDefaults.standard.set(v, forKey: userIdKey)
        return v
    }

    static func deviceId() -> String {
        if let v = UserDefaults.standard.string(forKey: deviceIdKey) {
            return v
        }
        let v = UUID().uuidString
        UserDefaults.standard.set(v, forKey: deviceIdKey)
        return v
    }

    static func learningStartDate() -> Date {
        let defaults = UserDefaults.standard
        if let stored = defaults.object(forKey: learningStartDateKey) as? Double {
            return Date(timeIntervalSince1970: stored)
        }

        let startOfToday = Calendar.current.startOfDay(for: Date())
        defaults.set(startOfToday.timeIntervalSince1970, forKey: learningStartDateKey)
        return startOfToday
    }

    static func dailyStartIndex(dailyWordCount: Int, today: Date = Date()) -> Int {
        let cal = Calendar.current
        let start = cal.startOfDay(for: learningStartDate())
        let end = cal.startOfDay(for: today)
        let day = cal.dateComponents([.day], from: start, to: end).day ?? 0
        return max(0, day) * max(1, dailyWordCount)
    }
}
