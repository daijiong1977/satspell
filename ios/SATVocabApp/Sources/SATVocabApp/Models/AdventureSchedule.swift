import Foundation

enum AdventureSchedule {
    static let totalDays = 20
    static let daysPerZone = 5
    static let totalZones = 4  // 3 full zones (5 days) + 1 zone (5 days) = 20 days

    // Zone themes: name, emoji, description
    static let zones: [(name: String, emoji: String, desc: String)] = [
        ("Enchanted Forest", "🌲", "Begin your journey through ancient woods"),
        ("Cloud Kingdom", "☁️", "Rise above the clouds to master new words"),
        ("Crystal Caverns", "💎", "Discover hidden gems of vocabulary"),
        ("Starlight Summit", "⭐", "Reach the peak of word mastery"),
    ]

    static func zoneTitle(zoneIndex: Int) -> String {
        let idx = min(max(0, zoneIndex), totalZones - 1)
        let zone = zones.indices.contains(idx) ? zones[idx] : (name: "Zone \(idx + 1)", emoji: "📚", desc: "")
        return "\(zone.emoji) \(zone.name)"
    }

    static func zoneEmoji(zoneIndex: Int) -> String {
        let idx = min(max(0, zoneIndex), totalZones - 1)
        return zones.indices.contains(idx) ? zones[idx].emoji : "📚"
    }

    static func zoneDescription(zoneIndex: Int) -> String {
        let idx = min(max(0, zoneIndex), totalZones - 1)
        return zones.indices.contains(idx) ? zones[idx].desc : ""
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
        return min(d / daysPerZone, totalZones - 1)
    }

    static func dayNumberInZone(forDayIndex dayIndex: Int) -> Int {
        let d = clampDayIndex(dayIndex)
        return (d % daysPerZone) + 1
    }

    static func globalDayNumber(forDayIndex dayIndex: Int) -> Int {
        clampDayIndex(dayIndex) + 1
    }
}
