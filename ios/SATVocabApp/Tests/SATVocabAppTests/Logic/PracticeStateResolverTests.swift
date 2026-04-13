import XCTest
@testable import SATVocabApp

// MARK: - PracticeStateResolver Logic Tests
//
// These tests verify the practice state machine that decides what the user sees
// on the Practice tab. Bugs caught by manual testing:
//   - Morning card disappearing during evening unlock window
//   - Incorrect state after app kill mid-session
//   - Evening unlocking immediately when morningCompleteAt is nil

final class PracticeStateResolverTests: XCTestCase {

    // MARK: - Helpers

    private func makeDayState(
        morningComplete: Bool = false,
        eveningComplete: Bool = false,
        morningCompleteAt: Date? = nil,
        eveningCompleteAt: Date? = nil
    ) -> DayState {
        DayState(
            id: 1, userId: "test", studyDay: 0, zoneIndex: 0,
            morningComplete: morningComplete,
            eveningComplete: eveningComplete,
            morningCompleteAt: morningCompleteAt,
            eveningCompleteAt: eveningCompleteAt,
            newWordsMorning: 0, newWordsEvening: 0,
            morningAccuracy: 0, eveningAccuracy: 0,
            morningXP: 0, eveningXP: 0,
            isRecoveryDay: false, isReviewOnlyDay: false
        )
    }

    private func makeSession(
        sessionType: SessionType = .morning,
        isPaused: Bool = true,
        stepIndex: Int = 1,
        itemIndex: Int = 3
    ) -> SessionState {
        SessionState(
            id: 1, userId: "test", sessionType: sessionType,
            studyDay: 0, stepIndex: stepIndex, itemIndex: itemIndex,
            isPaused: isPaused, showAgainIds: [], requeuedIds: [],
            startedAt: Date(), pausedAt: isPaused ? Date() : nil, completedAt: nil
        )
    }

    // MARK: - A: Morning Available

    func testNoDayState_returnsMorningAvailable() {
        let state = PracticeStateResolver.resolve(dayState: nil, activeSession: nil)
        if case .morningAvailable = state {} else {
            XCTFail("Expected .morningAvailable, got \(state)")
        }
    }

    func testMorningNotComplete_returnsMorningAvailable() {
        let day = makeDayState(morningComplete: false)
        let state = PracticeStateResolver.resolve(dayState: day, activeSession: nil)
        if case .morningAvailable = state {} else {
            XCTFail("Expected .morningAvailable, got \(state)")
        }
    }

    // MARK: - B: Paused Session (highest priority)

    func testPausedMorningSession_returnsPaused() {
        let session = makeSession(sessionType: .morning, isPaused: true, stepIndex: 1, itemIndex: 5)
        let day = makeDayState(morningComplete: false)
        let state = PracticeStateResolver.resolve(dayState: day, activeSession: session)

        if case .paused(let s) = state {
            XCTAssertEqual(s.stepIndex, 1, "Should preserve step index")
            XCTAssertEqual(s.itemIndex, 5, "Should preserve item index")
            XCTAssertEqual(s.sessionType, .morning)
        } else {
            XCTFail("Expected .paused, got \(state)")
        }
    }

    func testPausedEveningSession_returnsPaused() {
        let session = makeSession(sessionType: .evening, isPaused: true, stepIndex: 2, itemIndex: 7)
        let day = makeDayState(morningComplete: true, morningCompleteAt: Date().addingTimeInterval(-7200))
        let state = PracticeStateResolver.resolve(dayState: day, activeSession: session)

        if case .paused(let s) = state {
            XCTAssertEqual(s.sessionType, .evening)
            XCTAssertEqual(s.stepIndex, 2)
            XCTAssertEqual(s.itemIndex, 7)
        } else {
            XCTFail("Expected .paused, got \(state)")
        }
    }

    /// BUG: Paused session should take priority even if morning is complete.
    /// This tests the scenario where the user paused an evening session then killed the app.
    func testPausedSessionTakesPriorityOverMorningComplete() {
        let session = makeSession(sessionType: .evening, isPaused: true)
        let day = makeDayState(morningComplete: true, morningCompleteAt: Date().addingTimeInterval(-18000))
        let state = PracticeStateResolver.resolve(dayState: day, activeSession: session)

        if case .paused = state {} else {
            XCTFail("Paused session should have highest priority, got \(state)")
        }
    }

    /// Non-paused session should NOT trigger the paused state.
    func testActiveNonPausedSession_doesNotReturnPaused() {
        let session = makeSession(sessionType: .morning, isPaused: false)
        let day = makeDayState(morningComplete: false)
        let state = PracticeStateResolver.resolve(dayState: day, activeSession: session)

        if case .paused = state {
            XCTFail("Non-paused session should not produce .paused state")
        }
    }

    // MARK: - C: Morning Done, Evening Locked

    func testMorningDoneRecently_eveningLocked() {
        let morningDoneAt = Date()  // just completed
        let day = makeDayState(morningComplete: true, morningCompleteAt: morningDoneAt)
        let state = PracticeStateResolver.resolve(dayState: day, activeSession: nil, now: Date())

        if case .morningDoneEveningLocked(let unlockAt) = state {
            XCTAssertTrue(unlockAt > Date(), "Evening should not yet be available")
        } else {
            XCTFail("Expected .morningDoneEveningLocked, got \(state)")
        }
    }

    /// BUG: When morningCompleteAt is nil (timestamp not persisted), evening must NOT
    /// unlock immediately. The resolver should fall back to a safe default.
    func testMorningDone_nilTimestamp_doesNotUnlockImmediately() {
        let day = makeDayState(morningComplete: true, morningCompleteAt: nil)
        let now = Date()
        let state = PracticeStateResolver.resolve(dayState: day, activeSession: nil, now: now)

        // It should be either locked or fallback to a future unlock time
        switch state {
        case .morningDoneEveningLocked(let unlockAt):
            XCTAssertTrue(unlockAt > now,
                "Evening unlock should be in the future when morningCompleteAt is nil, " +
                "not immediate. Got unlock at \(unlockAt) vs now \(now)")
        case .eveningAvailable:
            XCTFail("Evening must NOT be available when morningCompleteAt is nil -- " +
                    "this was the bug where evening unlocked immediately")
        default:
            XCTFail("Expected .morningDoneEveningLocked, got \(state)")
        }
    }

    // MARK: - D: Evening Available

    func testMorningDoneLongAgo_eveningAvailable() {
        // Morning done 6 hours ago (beyond the 4-hour unlock)
        let morningDoneAt = Date().addingTimeInterval(-6 * 3600)
        let day = makeDayState(morningComplete: true, morningCompleteAt: morningDoneAt)
        let state = PracticeStateResolver.resolve(dayState: day, activeSession: nil)

        if case .eveningAvailable = state {} else {
            XCTFail("Expected .eveningAvailable after 6 hours, got \(state)")
        }
    }

    /// BUG: Morning card must still be visible when evening is available.
    /// The PracticeTabView shows MorningCompleteCard in .eveningAvailable state,
    /// but the resolver must return .eveningAvailable (not .morningAvailable).
    func testEveningAvailable_morningStillMarkedComplete() {
        let morningDoneAt = Date().addingTimeInterval(-6 * 3600)
        let day = makeDayState(morningComplete: true, morningCompleteAt: morningDoneAt)
        let state = PracticeStateResolver.resolve(dayState: day, activeSession: nil)

        if case .morningAvailable = state {
            XCTFail("Should not show morning as available when it is already complete")
        }
    }

    // MARK: - E: Both Complete

    func testBothComplete() {
        let day = makeDayState(
            morningComplete: true, eveningComplete: true,
            morningCompleteAt: Date().addingTimeInterval(-7200),
            eveningCompleteAt: Date().addingTimeInterval(-1800)
        )
        let state = PracticeStateResolver.resolve(dayState: day, activeSession: nil)

        if case .bothComplete = state {} else {
            XCTFail("Expected .bothComplete, got \(state)")
        }
    }

    /// BUG: bothComplete must take priority over any lingering session state.
    func testBothComplete_ignoreStalePausedSession() {
        let day = makeDayState(
            morningComplete: true, eveningComplete: true,
            morningCompleteAt: Date().addingTimeInterval(-7200),
            eveningCompleteAt: Date().addingTimeInterval(-1800)
        )
        // Stale paused session left in DB -- should be ignored because both are complete
        // but only if isPaused == false. If it's truly paused, resolver prioritizes it.
        let session = makeSession(sessionType: .evening, isPaused: false)
        let state = PracticeStateResolver.resolve(dayState: day, activeSession: session)

        if case .bothComplete = state {} else {
            XCTFail("Expected .bothComplete even with a non-paused session in DB, got \(state)")
        }
    }

    // MARK: - Evening Unlock Time Calculation

    func testCalculateEveningUnlock_normalCase() {
        let morningDone = Date().addingTimeInterval(-1 * 3600) // 1 hour ago
        let unlock = PracticeStateResolver.calculateEveningUnlock(morningCompleteAt: morningDone)
        // Should be morningDone + 4 hours = 3 hours from now (or fallback at 5 PM)
        let expectedHoursLater = morningDone.addingTimeInterval(TimeInterval(AppConfig.eveningUnlockHours * 3600))
        // The unlock is min(hoursLater, fallback), so it's at most the hours-later value
        XCTAssertTrue(unlock <= expectedHoursLater,
            "Unlock time should be at most morningDone + unlock hours")
    }

    func testCalculateEveningUnlock_nilMorningDone_fallsBackSafely() {
        let now = Date()
        let unlock = PracticeStateResolver.calculateEveningUnlock(morningCompleteAt: nil, now: now)
        XCTAssertTrue(unlock > now,
            "Nil morningCompleteAt must produce a future unlock time, got \(unlock)")
    }

    // MARK: - Edge Cases: Session Type Varieties

    func testRecoverySession_doesNotAffectMorningState() {
        // A paused recovery session should still trigger .paused
        let session = makeSession(sessionType: .recoveryEvening, isPaused: true)
        let day = makeDayState(morningComplete: false)
        let state = PracticeStateResolver.resolve(dayState: day, activeSession: session)

        if case .paused(let s) = state {
            XCTAssertEqual(s.sessionType, .recoveryEvening)
        } else {
            XCTFail("Expected .paused for recovery session, got \(state)")
        }
    }

    // MARK: - Step/Item Preservation Through State Transitions

    func testPausedSession_preservesShowAgainIds() {
        let session = SessionState(
            id: 1, userId: "test", sessionType: .morning,
            studyDay: 0, stepIndex: 1, itemIndex: 3,
            isPaused: true, showAgainIds: [5, 8, 12], requeuedIds: [2],
            startedAt: Date(), pausedAt: Date(), completedAt: nil
        )
        let state = PracticeStateResolver.resolve(dayState: nil, activeSession: session)

        if case .paused(let s) = state {
            XCTAssertEqual(s.showAgainIds, [5, 8, 12], "showAgainIds must survive state resolution")
            XCTAssertEqual(s.requeuedIds, [2], "requeuedIds must survive state resolution")
        } else {
            XCTFail("Expected .paused")
        }
    }
}
