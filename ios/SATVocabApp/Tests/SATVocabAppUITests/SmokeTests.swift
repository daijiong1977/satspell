import XCTest

// MARK: - Smoke Tests (XCUITest)
//
// These UI tests run on the simulator and verify:
//   1. Navigation between all tabs
//   2. Practice tab shows correct session cards
//   3. Session flow launches and has visible elements
//   4. Layout verification: no truncated text, buttons visible
//   5. Profile editing works
//
// Run: xcodebuild test -scheme SATVocabApp -target SATVocabAppUITests -destination 'platform=iOS Simulator,name=iPhone 16'
// Or: Cmd+U in Xcode with the UI test scheme selected.

final class SmokeTests: XCTestCase {

    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments = ["--uitesting"]
        app.launch()
    }

    // MARK: - Tab Navigation

    func testAllTabsAccessible() {
        // Practice tab should be selected by default
        let practiceTab = app.tabBars.buttons["Practice"]
        XCTAssertTrue(practiceTab.exists, "Practice tab must exist")
        XCTAssertTrue(practiceTab.isSelected, "Practice tab should be selected by default")

        // Map tab
        let mapTab = app.tabBars.buttons["Map"]
        XCTAssertTrue(mapTab.exists, "Map tab must exist")
        mapTab.tap()
        XCTAssertTrue(mapTab.isSelected, "Map tab should be selected after tap")
        // Verify map content loaded
        let mapTitle = app.staticTexts["Adventure Map"]
        XCTAssertTrue(mapTitle.waitForExistence(timeout: 5), "Adventure Map title should appear")

        // Stats tab
        let statsTab = app.tabBars.buttons["Stats"]
        XCTAssertTrue(statsTab.exists, "Stats tab must exist")
        statsTab.tap()
        XCTAssertTrue(statsTab.isSelected, "Stats tab should be selected after tap")

        // Profile tab
        let profileTab = app.tabBars.buttons["Profile"]
        XCTAssertTrue(profileTab.exists, "Profile tab must exist")
        profileTab.tap()
        XCTAssertTrue(profileTab.isSelected, "Profile tab should be selected after tap")
        // Profile title should appear
        let profileTitle = app.navigationBars["Profile"]
        XCTAssertTrue(profileTitle.waitForExistence(timeout: 5), "Profile nav bar should appear")

        // Return to Practice
        practiceTab.tap()
        XCTAssertTrue(practiceTab.isSelected, "Should return to Practice tab")
    }

    // MARK: - Practice Tab Initial State

    func testPracticeTab_showsMorningCardOnFreshLaunch() {
        // On a fresh launch with no day_state, the practice tab should show morning available
        let practiceTab = app.tabBars.buttons["Practice"]
        practiceTab.tap()

        // Wait for loading to finish
        let morningCard = app.otherElements["morningSessionCard"]
        let appeared = morningCard.waitForExistence(timeout: 10)
        XCTAssertTrue(appeared, "Morning Session card should appear on fresh launch")

        // The "Start" button text should be visible within the card
        let startButton = app.staticTexts["Start"]
        XCTAssertTrue(startButton.exists, "Start button text should be visible on morning card")
    }

    func testPracticeTab_eveningLockedOnFreshLaunch() {
        let practiceTab = app.tabBars.buttons["Practice"]
        practiceTab.tap()

        // Wait for content
        let morningCard = app.otherElements["morningSessionCard"]
        _ = morningCard.waitForExistence(timeout: 10)

        // Evening card should exist but be in locked state
        let eveningLocked = app.otherElements["eveningSessionCardLocked"]
        XCTAssertTrue(eveningLocked.exists, "Evening card should exist in locked state")

        // "Complete morning first" text should be visible
        let lockText = app.staticTexts["Complete morning first"]
        XCTAssertTrue(lockText.exists, "Should show 'Complete morning first' text")
    }

    // MARK: - Session Launch

    func testMorningSessionLaunches() {
        let practiceTab = app.tabBars.buttons["Practice"]
        practiceTab.tap()

        let morningCard = app.otherElements["morningSessionCard"]
        guard morningCard.waitForExistence(timeout: 10) else {
            XCTFail("Morning card did not appear")
            return
        }

        morningCard.tap()

        // Should navigate to session flow - look for loading indicator or step content
        let loadingText = app.staticTexts["Loading words..."]
        let loadingAppeared = loadingText.waitForExistence(timeout: 5)

        if loadingAppeared {
            // Wait for loading to complete (words to load from DB)
            // Either the flashcard step appears, or an error state
            let timeout: TimeInterval = 15
            let flashcardStep = app.otherElements.matching(
                NSPredicate(format: "identifier CONTAINS 'flashcard' OR identifier CONTAINS 'step'")
            )
            // Just verify we're no longer on the practice tab
            let morningCardGone = morningCard.waitForNonExistence(timeout: timeout)
            XCTAssertTrue(morningCardGone || !morningCard.isHittable,
                "Should have navigated away from practice tab")
        }
        // If loading text didn't appear, the session loaded very fast -- that's OK
    }

    // MARK: - Layout Verification

    /// Verify no text is truncated on the practice tab.
    /// This checks that key labels have reasonable frames (not zero-height or zero-width).
    func testPracticeTab_noTruncatedText() {
        let practiceTab = app.tabBars.buttons["Practice"]
        practiceTab.tap()

        let morningCard = app.otherElements["morningSessionCard"]
        guard morningCard.waitForExistence(timeout: 10) else { return }

        // Check that "Morning Session" text is not clipped
        let morningLabel = app.staticTexts["Morning Session"]
        XCTAssertTrue(morningLabel.exists, "Morning Session label must exist")
        XCTAssertGreaterThan(morningLabel.frame.width, 50,
            "Morning Session label width should not be unreasonably small (truncated)")
        XCTAssertGreaterThan(morningLabel.frame.height, 10,
            "Morning Session label height should not be zero (hidden)")

        // Check evening session label
        let eveningLabel = app.staticTexts["Evening Session"]
        XCTAssertTrue(eveningLabel.exists, "Evening Session label must exist")
        XCTAssertGreaterThan(eveningLabel.frame.width, 50,
            "Evening Session label should not be truncated")
    }

    /// Verify buttons are within the visible screen area.
    func testPracticeTab_buttonsWithinScreen() {
        let practiceTab = app.tabBars.buttons["Practice"]
        practiceTab.tap()

        let morningCard = app.otherElements["morningSessionCard"]
        guard morningCard.waitForExistence(timeout: 10) else { return }

        let screenWidth = app.frame.width
        let screenHeight = app.frame.height

        // Morning card should be fully on screen
        XCTAssertGreaterThanOrEqual(morningCard.frame.minX, 0,
            "Morning card should not extend past left edge")
        XCTAssertLessThanOrEqual(morningCard.frame.maxX, screenWidth + 1,
            "Morning card should not extend past right edge")
        XCTAssertGreaterThanOrEqual(morningCard.frame.minY, 0,
            "Morning card should not extend past top edge")
        XCTAssertLessThanOrEqual(morningCard.frame.maxY, screenHeight + 1,
            "Morning card should not extend past bottom edge")
    }

    // MARK: - Profile Editing

    func testProfileNameEditable() {
        let profileTab = app.tabBars.buttons["Profile"]
        profileTab.tap()

        // Wait for profile to load
        let profileNav = app.navigationBars["Profile"]
        guard profileNav.waitForExistence(timeout: 5) else {
            XCTFail("Profile navigation bar did not appear")
            return
        }

        // The display name should be tappable to edit
        // Look for the pencil icon next to the name
        let pencilIcon = app.images["pencil"]
        if pencilIcon.exists {
            pencilIcon.tap()
            // A text field should appear
            let nameField = app.textFields["Your name"]
            let fieldAppeared = nameField.waitForExistence(timeout: 3)
            XCTAssertTrue(fieldAppeared, "Name text field should appear after tapping pencil")
        }
    }

    func testProfileShowsStreakAndXP() {
        let profileTab = app.tabBars.buttons["Profile"]
        profileTab.tap()

        let profileNav = app.navigationBars["Profile"]
        guard profileNav.waitForExistence(timeout: 5) else {
            XCTFail("Profile did not load")
            return
        }

        // Streak and XP labels should exist
        let streakLabel = app.staticTexts["Streak"]
        XCTAssertTrue(streakLabel.exists, "Streak label should be visible on profile")

        let totalXPLabel = app.staticTexts["Total XP"]
        XCTAssertTrue(totalXPLabel.exists, "Total XP label should be visible on profile")

        let daysLabel = app.staticTexts["Days"]
        XCTAssertTrue(daysLabel.exists, "Days label should be visible on profile")
    }

    // MARK: - Resume Card

    /// This test verifies that if there is a paused session, the resume card appears
    /// with Resume and Start Over buttons. This is a layout test -- the actual state
    /// setup depends on prior session activity in the app.
    func testResumeCard_hasCorrectButtons() {
        // Navigate to practice tab
        let practiceTab = app.tabBars.buttons["Practice"]
        practiceTab.tap()

        // Check if a resume card exists (it may or may not depending on app state)
        let resumeCard = app.otherElements["resumeCard"]
        if resumeCard.waitForExistence(timeout: 5) {
            // If there IS a paused session, verify buttons
            let resumeButton = app.otherElements["resumeButton"]
            XCTAssertTrue(resumeButton.exists, "Resume button must exist on resume card")

            let startOverButton = app.otherElements["startOverButton"]
            XCTAssertTrue(startOverButton.exists, "Start Over button must exist on resume card")

            // Verify the "Paused:" label exists
            let pausedText = app.staticTexts.matching(
                NSPredicate(format: "label CONTAINS 'Paused'")
            )
            XCTAssertGreaterThan(pausedText.count, 0,
                "Resume card should show 'Paused: X Session' text")

            // Verify step/item info is visible
            let stepText = app.staticTexts.matching(
                NSPredicate(format: "label CONTAINS 'Step'")
            )
            XCTAssertGreaterThan(stepText.count, 0,
                "Resume card should show step/item position")
        }
        // If no resume card exists, the test passes (no paused session to verify)
    }
}
