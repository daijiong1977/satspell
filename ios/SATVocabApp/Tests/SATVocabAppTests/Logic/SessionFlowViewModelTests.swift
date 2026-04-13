import XCTest
@testable import SATVocabApp

// MARK: - SessionFlowViewModel Logic Tests
//
// These tests verify the step progression logic, resume behavior,
// and session type step definitions without touching the database.
// Bugs targeted:
//   - Step index not advancing correctly
//   - Resume starts from wrong item
//   - Evening session missing quick recall step
//   - Morning/evening word counts mismatched

@MainActor
final class SessionFlowViewModelTests: XCTestCase {

    // MARK: - Step Definitions

    func testMorningSession_hasThreeSteps() {
        let vm = SessionFlowViewModel(sessionType: .morning, studyDay: 0)
        XCTAssertEqual(vm.steps.count, 3, "Morning session should have 3 steps")
        XCTAssertEqual(vm.steps[0].type, .flashcard)
        XCTAssertEqual(vm.steps[1].type, .imageGame)
        XCTAssertEqual(vm.steps[2].type, .satQuestion)
    }

    func testEveningSession_hasFourSteps() {
        let vm = SessionFlowViewModel(sessionType: .evening, studyDay: 0)
        XCTAssertEqual(vm.steps.count, 4, "Evening session should have 4 steps (including quick recall)")
        XCTAssertEqual(vm.steps[0].type, .flashcard)
        XCTAssertEqual(vm.steps[1].type, .quickRecall, "Evening step 2 must be quickRecall")
        XCTAssertEqual(vm.steps[2].type, .imageGame)
        XCTAssertEqual(vm.steps[3].type, .satQuestion)
    }

    /// BUG: Evening session quick recall step uses morningNewWords count,
    /// which is correct (it reviews the morning words).
    func testEveningQuickRecall_usesCorrectWordCount() {
        let vm = SessionFlowViewModel(sessionType: .evening, studyDay: 0)
        let quickRecallStep = vm.steps[1]
        XCTAssertEqual(quickRecallStep.itemCount, AppConfig.morningNewWords,
            "Quick recall step should use morningNewWords count (\(AppConfig.morningNewWords)), " +
            "not eveningNewWords")
    }

    func testRecoverySession_hasTwoSteps() {
        let vm = SessionFlowViewModel(sessionType: .recoveryEvening, studyDay: 0)
        XCTAssertEqual(vm.steps.count, 2, "Recovery session should have 2 steps")
        XCTAssertEqual(vm.steps[0].type, .imageGame)
        XCTAssertEqual(vm.steps[1].type, .satQuestion)
    }

    // MARK: - Step Counts Match Config

    func testMorningFlashcard_matchesConfig() {
        let vm = SessionFlowViewModel(sessionType: .morning, studyDay: 0)
        XCTAssertEqual(vm.steps[0].itemCount, AppConfig.morningNewWords)
    }

    func testMorningGameRounds_matchesConfig() {
        let vm = SessionFlowViewModel(sessionType: .morning, studyDay: 0)
        XCTAssertEqual(vm.steps[1].itemCount, AppConfig.morningGameRounds)
    }

    func testMorningSATQuestions_matchesConfig() {
        let vm = SessionFlowViewModel(sessionType: .morning, studyDay: 0)
        XCTAssertEqual(vm.steps[2].itemCount, AppConfig.morningSATQuestions)
    }

    func testEveningFlashcard_matchesConfig() {
        let vm = SessionFlowViewModel(sessionType: .evening, studyDay: 0)
        XCTAssertEqual(vm.steps[0].itemCount, AppConfig.eveningNewWords)
    }

    func testEveningGameRounds_matchesConfig() {
        let vm = SessionFlowViewModel(sessionType: .evening, studyDay: 0)
        XCTAssertEqual(vm.steps[2].itemCount, AppConfig.eveningGameRounds)
    }

    func testEveningSATQuestions_matchesConfig() {
        let vm = SessionFlowViewModel(sessionType: .evening, studyDay: 0)
        XCTAssertEqual(vm.steps[3].itemCount, AppConfig.eveningSATQuestions)
    }

    // MARK: - Step Progression

    func testAdvanceToNextStep_setsShowStepTransition() {
        let vm = SessionFlowViewModel(sessionType: .morning, studyDay: 0)
        XCTAssertEqual(vm.currentStepIndex, 0)
        XCTAssertFalse(vm.showStepTransition)

        vm.advanceToNextStep()
        XCTAssertTrue(vm.showStepTransition, "advanceToNextStep should trigger transition")
        // Step index should NOT advance yet (transition screen shows first)
        XCTAssertEqual(vm.currentStepIndex, 0, "Step index should not advance until continueAfterTransition")
    }

    func testContinueAfterTransition_advancesStep() {
        let vm = SessionFlowViewModel(sessionType: .morning, studyDay: 0)
        vm.advanceToNextStep()
        vm.continueAfterTransition()

        XCTAssertEqual(vm.currentStepIndex, 1, "Should be on step 1 after transition")
        XCTAssertFalse(vm.showStepTransition, "Transition flag should be cleared")
        XCTAssertEqual(vm.currentItemIndex, 0, "Item index should reset to 0 on new step")
    }

    /// Advancing past the last step should complete the session.
    func testAdvancePastLastStep_completesSession() {
        let vm = SessionFlowViewModel(sessionType: .morning, studyDay: 0)
        // Advance through all 3 steps
        for _ in 0..<3 {
            vm.advanceToNextStep()
            vm.continueAfterTransition()
        }
        // After step 3, currentStepIndex = 3 which is >= steps.count (3)
        // completeSession should have been called
        XCTAssertTrue(vm.isComplete, "Session should be complete after advancing past last step")
    }

    // MARK: - Resume Item Index

    func testResumeItemIndex_defaultsToZero() {
        let vm = SessionFlowViewModel(sessionType: .morning, studyDay: 0)
        XCTAssertEqual(vm.resumeItemIndex, 0, "Default resume index should be 0")
    }

    /// BUG: After setting resumeItemIndex, advanceToNextStep should reset it to 0
    /// so the next step starts from the beginning.
    func testAdvanceToNextStep_resetsResumeIndex() {
        let vm = SessionFlowViewModel(sessionType: .morning, studyDay: 0)
        vm.resumeItemIndex = 5

        vm.advanceToNextStep()
        XCTAssertEqual(vm.resumeItemIndex, 0,
            "advanceToNextStep must reset resumeItemIndex to 0")
    }

    func testContinueAfterTransition_resetsResumeIndex() {
        let vm = SessionFlowViewModel(sessionType: .morning, studyDay: 0)
        vm.resumeItemIndex = 5
        vm.advanceToNextStep()
        vm.continueAfterTransition()
        XCTAssertEqual(vm.resumeItemIndex, 0,
            "continueAfterTransition must reset resumeItemIndex to 0")
    }

    // MARK: - Item Tracking

    func testDidAdvanceItem_updatesCurrentItemIndex() {
        let vm = SessionFlowViewModel(sessionType: .morning, studyDay: 0)
        vm.didAdvanceItem(to: 3)
        XCTAssertEqual(vm.currentItemIndex, 3)

        vm.didAdvanceItem(to: 4)
        XCTAssertEqual(vm.currentItemIndex, 4)
    }

    // MARK: - ShowAgainIds

    func testReceiveShowAgainIds_storesIds() {
        let vm = SessionFlowViewModel(sessionType: .morning, studyDay: 0)
        vm.receiveShowAgainIds([1, 5, 9])
        XCTAssertEqual(vm.showAgainWordIds, [1, 5, 9])
    }

    // MARK: - Scoring

    func testScoringDefaults() {
        let vm = SessionFlowViewModel(sessionType: .morning, studyDay: 0)
        XCTAssertEqual(vm.totalCorrect, 0)
        XCTAssertEqual(vm.totalAttempts, 0)
        XCTAssertEqual(vm.xpEarned, 0)
        XCTAssertEqual(vm.comboCount, 0)
        XCTAssertFalse(vm.isComplete)
        XCTAssertFalse(vm.isPaused)
    }

    // MARK: - Current Step

    func testCurrentStep_returnsCorrectStep() {
        let vm = SessionFlowViewModel(sessionType: .morning, studyDay: 0)
        XCTAssertEqual(vm.currentStep?.type, .flashcard)
        XCTAssertEqual(vm.currentStep?.label, "Explore New Words")
    }

    func testCurrentStep_nilAfterAllSteps() {
        let vm = SessionFlowViewModel(sessionType: .morning, studyDay: 0)
        vm.advanceToNextStep()
        vm.continueAfterTransition()
        vm.advanceToNextStep()
        vm.continueAfterTransition()
        vm.advanceToNextStep()
        vm.continueAfterTransition()
        // Now past all steps
        XCTAssertNil(vm.currentStep, "currentStep should be nil when past all steps")
    }

    // MARK: - Progress Label

    func testProgressLabel_matchesCurrentStep() {
        let vm = SessionFlowViewModel(sessionType: .morning, studyDay: 0)
        XCTAssertEqual(vm.progressLabel, "Explore New Words")

        vm.advanceToNextStep()
        vm.continueAfterTransition()
        XCTAssertEqual(vm.progressLabel, "Image Practice")
    }

    // MARK: - Total Steps

    func testTotalSteps_morningIs3() {
        let vm = SessionFlowViewModel(sessionType: .morning, studyDay: 0)
        XCTAssertEqual(vm.totalSteps, 3)
    }

    func testTotalSteps_eveningIs4() {
        let vm = SessionFlowViewModel(sessionType: .evening, studyDay: 0)
        XCTAssertEqual(vm.totalSteps, 4)
    }
}
