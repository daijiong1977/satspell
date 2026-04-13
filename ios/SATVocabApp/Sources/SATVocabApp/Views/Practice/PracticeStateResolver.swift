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
            let mode = LocalIdentity.eveningUnlockMode()
            if mode == 0 {
                // No wait — evening available immediately
                return .eveningAvailable
            }
            let unlockAt = calculateEveningUnlock(morningCompleteAt: day.morningCompleteAt, now: now, mode: mode)
            if now >= unlockAt {
                return .eveningAvailable
            } else {
                return .morningDoneEveningLocked(unlockAt: unlockAt)
            }
        }

        // Morning not done
        return .morningAvailable
    }

    static func calculateEveningUnlock(morningCompleteAt: Date?, now: Date = Date(), mode: Int = 1) -> Date {
        let cal = Calendar.current

        if mode == 2 {
            // Mode 2: after 5:00 PM — return today's 5PM or tomorrow's if past
            let todayFive = cal.date(bySettingHour: 17, minute: 0, second: 0, of: now) ?? now
            if todayFive > now {
                return todayFive
            }
            return cal.date(byAdding: .day, value: 1, to: todayFive) ?? todayFive
        }

        // Mode 1: wait 3 hours after morning completion
        guard let morningDone = morningCompleteAt else {
            return now.addingTimeInterval(TimeInterval(3 * 3600))
        }
        return morningDone.addingTimeInterval(TimeInterval(3 * 3600))
    }
}
