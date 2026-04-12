import Foundation

enum SessionType: String, Codable, Identifiable {
    var id: String { rawValue }
    case morning
    case evening
    case recoveryEvening = "recovery_evening"
    case catchUp = "catch_up"
    case reEntry = "re_entry"
    case reviewOnly = "review_only"
    case zoneTest = "zone_test"
    case bonus
}

enum ActivityType: String, Codable {
    case imageGame = "image_game"
    case quickRecall = "quick_recall"
    case satQuestion = "sat_question"
}

enum MemoryStatus: String, Codable {
    case easy, normal, fragile, stubborn
}

enum CardState {
    case pending, current, completed, requeued
}

enum WordStrength: Int, CaseIterable {
    case notIntroduced = 0
    case lockedIn = 1
    case rising = 2
    case strong = 3
    case solid = 4
    case mastered = 5

    var label: String {
        switch self {
        case .notIntroduced: return ""
        case .lockedIn: return "Locked In"
        case .rising: return "Rising"
        case .strong: return "Strong"
        case .solid: return "Solid"
        case .mastered: return "Mastered"
        }
    }

    var reviewIntervalDays: Int? {
        switch self {
        case .notIntroduced: return nil
        case .lockedIn: return 1
        case .rising: return 3
        case .strong: return 7
        case .solid: return 14
        case .mastered: return nil
        }
    }

    var colorHex: String {
        switch self {
        case .notIntroduced: return "#E8ECF0"
        case .lockedIn: return "#FF7043"
        case .rising: return "#FFAB40"
        case .strong: return "#FFC800"
        case .solid: return "#89E219"
        case .mastered: return "#58CC02"
        }
    }
}
