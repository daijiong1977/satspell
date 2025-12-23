import Foundation

final class AdventureProgressStore {
    static let shared = AdventureProgressStore()

    private let defaults = UserDefaults.standard
    private init() {}

    private func dayKey(dayIndex: Int) -> String {
        "adventure.day.\(AdventureSchedule.clampDayIndex(dayIndex))"
    }

    private func zoneUnlockedKey(zoneIndex: Int) -> String {
        "adventure.zone_unlocked.\(zoneIndex)"
    }

    // MARK: - Day Tasks (4 per day)

    func loadDayTasks(dayIndex: Int) -> [Bool] {
        let k = dayKey(dayIndex: dayIndex)
        if let arr = defaults.array(forKey: k) as? [Bool], arr.count == 4 {
            return arr
        }
        return [false, false, false, false]
    }

    func setDayTaskCompleted(dayIndex: Int, taskIndex: Int, completed: Bool) {
        precondition((0..<4).contains(taskIndex))
        var state = loadDayTasks(dayIndex: dayIndex)
        state[taskIndex] = completed
        defaults.set(state, forKey: dayKey(dayIndex: dayIndex))
    }

    func isDayCompleted(dayIndex: Int) -> Bool {
        loadDayTasks(dayIndex: dayIndex).allSatisfy { $0 }
    }

    func firstIncompleteDayIndex() -> Int {
        for day in 0..<AdventureSchedule.totalDays {
            if !isDayCompleted(dayIndex: day) { return day }
        }
        return AdventureSchedule.totalDays - 1
    }

    // MARK: - Zone Unlocks

    func isZoneUnlocked(zoneIndex: Int) -> Bool {
        if AppConfig.unlockAllAdventureForTesting { return true }
        if zoneIndex <= 0 { return true }
        return defaults.bool(forKey: zoneUnlockedKey(zoneIndex: zoneIndex))
    }

    func setZoneUnlocked(zoneIndex: Int, unlocked: Bool) {
        defaults.set(unlocked, forKey: zoneUnlockedKey(zoneIndex: zoneIndex))
    }

    func isZoneCompleted(zoneIndex: Int) -> Bool {
        let start = zoneIndex * AdventureSchedule.daysPerZone
        let end = min(start + AdventureSchedule.daysPerZone, AdventureSchedule.totalDays)
        guard start < end else { return false }
        return (start..<end).allSatisfy { isDayCompleted(dayIndex: $0) }
    }
}
