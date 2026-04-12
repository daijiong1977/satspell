import Foundation

enum PracticeState {
    case morningAvailable                           // A
    case paused(SessionState)                       // B
    case morningDoneEveningLocked(unlockAt: Date)   // C
    case eveningAvailable                           // D
    case bothComplete                               // E
}

struct PracticeStateResolver {
    static func resolve(
        dayState: DayState?,
        activeSession: SessionState?,
        now: Date = Date()
    ) -> PracticeState {
        // Priority 1: Paused session
        if let session = activeSession, session.isPaused {
            return .paused(session)
        }

        guard let day = dayState else {
            return .morningAvailable
        }

        // Both done
        if day.morningComplete && day.eveningComplete {
            return .bothComplete
        }

        // Morning done, check evening
        if day.morningComplete {
            let unlockAt = calculateEveningUnlock(morningCompleteAt: day.morningCompleteAt)
            if now >= unlockAt {
                return .eveningAvailable
            } else {
                return .morningDoneEveningLocked(unlockAt: unlockAt)
            }
        }

        // Morning not done
        return .morningAvailable
    }

    static func calculateEveningUnlock(morningCompleteAt: Date?) -> Date {
        guard let morningDone = morningCompleteAt else {
            // Fallback to 5 PM today
            return Calendar.current.date(bySettingHour: AppConfig.eveningUnlockFallbackHour,
                                         minute: 0, second: 0, of: Date()) ?? Date()
        }

        let hoursLater = morningDone.addingTimeInterval(TimeInterval(AppConfig.eveningUnlockHours * 3600))
        let fallback = Calendar.current.date(bySettingHour: AppConfig.eveningUnlockFallbackHour,
                                             minute: 0, second: 0, of: Date()) ?? Date()

        return min(hoursLater, fallback)
    }
}
