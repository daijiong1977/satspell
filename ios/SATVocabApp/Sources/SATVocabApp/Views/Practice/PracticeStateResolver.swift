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
            let unlockAt = calculateEveningUnlock(morningCompleteAt: day.morningCompleteAt, now: now)
            if now >= unlockAt {
                return .eveningAvailable
            } else {
                return .morningDoneEveningLocked(unlockAt: unlockAt)
            }
        }

        // Morning not done
        return .morningAvailable
    }

    static func calculateEveningUnlock(morningCompleteAt: Date?, now: Date = Date()) -> Date {
        let cal = Calendar.current

        // Build the fallback hour — if today's fallback is already past, use tomorrow's
        let fallback: Date = {
            let todayFallback = cal.date(bySettingHour: AppConfig.eveningUnlockFallbackHour,
                                         minute: 0, second: 0, of: now) ?? now
            if todayFallback > now {
                return todayFallback
            }
            // Today's fallback already passed — use tomorrow
            return cal.date(byAdding: .day, value: 1, to: todayFallback) ?? todayFallback
        }()

        guard let morningDone = morningCompleteAt else {
            // morningCompleteAt is nil — fall back to now + unlock hours,
            // capped by the fallback hour so it never unlocks immediately
            let hoursFromNow = now.addingTimeInterval(TimeInterval(AppConfig.eveningUnlockHours * 3600))
            return min(hoursFromNow, fallback)
        }

        let hoursLater = morningDone.addingTimeInterval(TimeInterval(AppConfig.eveningUnlockHours * 3600))
        return min(hoursLater, fallback)
    }
}
