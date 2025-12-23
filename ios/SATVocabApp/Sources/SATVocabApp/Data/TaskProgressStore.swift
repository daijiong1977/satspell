import Foundation

final class TaskProgressStore {
    static let shared = TaskProgressStore()

    private let defaults = UserDefaults.standard

    private init() {}

    private func key(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar.current
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return "tasks.\(formatter.string(from: date))"
    }

    func load(date: Date = Date()) -> [Bool] {
        let k = key(for: date)
        if let arr = defaults.array(forKey: k) as? [Bool] {
            if arr.count == 6 { return arr }
            if arr.count == 5 { return arr + [false] }
        }
        return [false, false, false, false, false, false]
    }

    func setCompleted(taskIndex: Int, date: Date = Date(), completed: Bool) {
        precondition((0..<6).contains(taskIndex))
        var state = load(date: date)
        state[taskIndex] = completed
        defaults.set(state, forKey: key(for: date))
    }

    func nextActiveTaskIndex(date: Date = Date()) -> Int {
        let state = load(date: date)
        if let idx = state.firstIndex(where: { !$0 }) {
            return idx
        }
        return 5
    }
}
