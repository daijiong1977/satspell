import Foundation

enum AdventureSchedule {
    static let totalDays = 20
    static let daysPerZone = 4

    static let totalZones = totalDays / daysPerZone
    
    static let zoneNames: [String] = [
        "Foundation",
        "Cloud Realm",
        "Island",
        "Space",
        "Future City"
    ]
    
    static func zoneTitle(zoneIndex: Int) -> String {
        let idx = min(max(0, zoneIndex), totalZones - 1)
        let name = zoneNames.indices.contains(idx) ? zoneNames[idx] : "Zone \(idx + 1)"
        return "Zone \(idx + 1): \(name)"
    }

    static func clampDayIndex(_ dayIndex: Int) -> Int {
        min(max(0, dayIndex), totalDays - 1)
    }

    static func dayIndexForToday(today: Date = Date()) -> Int {
        let cal = Calendar.current
        let start = cal.startOfDay(for: LocalIdentity.learningStartDate())
        let end = cal.startOfDay(for: today)
        let day = cal.dateComponents([.day], from: start, to: end).day ?? 0
        return clampDayIndex(day)
    }

    static func zoneIndex(forDayIndex dayIndex: Int) -> Int {
        let d = clampDayIndex(dayIndex)
        return d / daysPerZone
    }

    static func dayNumberInZone(forDayIndex dayIndex: Int) -> Int {
        let d = clampDayIndex(dayIndex)
        return (d % daysPerZone) + 1
    }

    static func globalDayNumber(forDayIndex dayIndex: Int) -> Int {
        clampDayIndex(dayIndex) + 1
    }
}
