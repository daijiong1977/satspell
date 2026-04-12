import Foundation

@MainActor
final class SessionFlowViewModel: ObservableObject {
    // Session config
    let sessionType: SessionType
    let studyDay: Int
    let userId: String

    // State
    @Published var currentStepIndex: Int = 0
    @Published var isComplete: Bool = false
    @Published var isPaused: Bool = false
    @Published var showStepTransition: Bool = false

    // Scoring
    @Published var totalCorrect: Int = 0
    @Published var totalAttempts: Int = 0
    @Published var xpEarned: Int = 0
    @Published var wordsPromoted: Int = 0
    @Published var wordsDemoted: Int = 0
    @Published var comboCount: Int = 0

    // Show Again from flashcard step -> image game step
    var showAgainWordIds: [Int] = []

    // Words for each step (loaded at session start)
    var newWords: [VocabCard] = []
    var reviewWords: [VocabCard] = []
    var morningWords: [VocabCard] = []  // for evening quick recall

    // Step definitions
    struct StepDef {
        let type: StepType
        let label: String
        let itemCount: Int
    }

    enum StepType {
        case flashcard
        case imageGame
        case quickRecall
        case satQuestion
    }

    var steps: [StepDef] = []

    var currentStep: StepDef? {
        steps.indices.contains(currentStepIndex) ? steps[currentStepIndex] : nil
    }

    var totalSteps: Int { steps.count }

    var progressLabel: String {
        guard let step = currentStep else { return "" }
        return step.label
    }

    init(sessionType: SessionType, studyDay: Int) {
        self.sessionType = sessionType
        self.studyDay = studyDay
        self.userId = LocalIdentity.userId()

        // Define steps based on session type
        switch sessionType {
        case .morning:
            steps = [
                StepDef(type: .flashcard, label: "Explore New Words", itemCount: AppConfig.morningNewWords),
                StepDef(type: .imageGame, label: "Image Practice", itemCount: AppConfig.morningGameRounds),
                StepDef(type: .satQuestion, label: "SAT Questions", itemCount: AppConfig.morningSATQuestions),
            ]
        case .evening:
            steps = [
                StepDef(type: .flashcard, label: "Explore New Words", itemCount: AppConfig.eveningNewWords),
                StepDef(type: .quickRecall, label: "Quick Recall", itemCount: AppConfig.morningNewWords),
                StepDef(type: .imageGame, label: "Image Practice", itemCount: AppConfig.eveningGameRounds),
                StepDef(type: .satQuestion, label: "SAT Questions", itemCount: AppConfig.eveningSATQuestions),
            ]
        default:
            // Recovery/review/bonus sessions — simplified
            steps = [
                StepDef(type: .imageGame, label: "Practice", itemCount: 12),
                StepDef(type: .satQuestion, label: "SAT Questions", itemCount: 3),
            ]
        }
    }

    func loadWords() async throws {
        let dm = DataManager.shared
        try await dm.initializeIfNeeded()

        // Create required rows BEFORE any updates
        let sessionStore = SessionStateStore.shared
        let statsStore = StatsStore.shared
        let zoneIdx = studyDay / 4  // approximate zone
        _ = try await sessionStore.getOrCreateDayState(userId: userId, studyDay: studyDay, zoneIndex: zoneIdx)

        // Check for an existing paused session before creating a new one
        if let existingSession = try await sessionStore.getActiveSession(userId: userId),
           existingSession.sessionType == sessionType,
           existingSession.studyDay == studyDay {
            // Resume: restore saved step/item index instead of resetting
            currentStepIndex = existingSession.stepIndex
            showAgainWordIds = existingSession.showAgainIds
            try await sessionStore.resumeSession(userId: userId, studyDay: studyDay, sessionType: sessionType)
        } else {
            _ = try await sessionStore.createSession(userId: userId, sessionType: sessionType, studyDay: studyDay)
        }

        _ = try await statsStore.getOrCreateDailyStats(userId: userId, studyDay: studyDay)

        let list = try await dm.getDefaultList()
        let startIndex = studyDay * (AppConfig.morningNewWords + AppConfig.eveningNewWords)

        switch sessionType {
        case .morning:
            newWords = try await dm.fetchSessionQueue(listId: list.id, limit: AppConfig.morningNewWords, startIndex: startIndex)
        case .evening:
            let morningStart = studyDay * (AppConfig.morningNewWords + AppConfig.eveningNewWords)
            morningWords = try await dm.fetchSessionQueue(listId: list.id, limit: AppConfig.morningNewWords, startIndex: morningStart)
            let eveningStart = morningStart + AppConfig.morningNewWords
            newWords = try await dm.fetchSessionQueue(listId: list.id, limit: AppConfig.eveningNewWords, startIndex: eveningStart)
        default:
            break
        }

        // Load review words from word_state
        let wsStore = WordStateStore(db: dm.db)
        let reviews = try await wsStore.getReviewQueue(userId: userId, limit: 6)
        // Convert WordState to VocabCard — would need a lookup
        // (simplified — full implementation maps wordId -> VocabCard)
        _ = reviews // suppress unused warning
    }

    func advanceToNextStep() {
        showStepTransition = true
    }

    func continueAfterTransition() {
        showStepTransition = false
        currentStepIndex += 1
        if currentStepIndex >= steps.count {
            completeSession()
        }
    }

    func recordAnswer(correct: Bool, wordId: Int, activityType: ActivityType, durationMs: Int) async {
        totalAttempts += 1
        if correct {
            totalCorrect += 1
            xpEarned += AppConfig.correctAnswerXP
            comboCount += 1
        } else {
            comboCount = 0
        }

        // Record in data layer
        do {
            let dm = DataManager.shared
            let reviewLogger = ReviewLogger(db: dm.db)
            let wsStore = WordStateStore(db: dm.db)
            let statsStore = StatsStore.shared

            // 1. Write review_log entry
            let outcome: ReviewOutcome = correct ? .correct : .incorrect
            try await reviewLogger.logReview(
                userId: userId, wordId: wordId, outcome: outcome,
                activityType: activityType, sessionType: sessionType,
                studyDay: studyDay, durationMs: durationMs)

            // 2. Update word_state (box progression)
            let boxChange = try await wsStore.recordScoredAnswer(userId: userId, wordId: wordId, correct: correct)

            switch boxChange {
            case .promoted(_, _): wordsPromoted += 1
            case .demoted(_, _): wordsDemoted += 1
            case .none: break
            }

            if correct {
                try await statsStore.recordCorrectAnswer(userId: userId, studyDay: studyDay)
            } else {
                try await statsStore.recordWrongAnswer(userId: userId, studyDay: studyDay)
            }
        } catch {
            // Non-fatal for v1
        }
    }

    func receiveShowAgainIds(_ ids: [Int]) {
        showAgainWordIds = ids
    }

    private func completeSession() {
        isComplete = true

        Task {
            do {
                let sessionStore = SessionStateStore.shared
                let statsStore = StatsStore.shared

                // Mark session complete
                try await sessionStore.completeSession(userId: userId, studyDay: studyDay, sessionType: sessionType)

                // Session bonus
                try await statsStore.addSessionBonus(userId: userId, studyDay: studyDay)
                xpEarned += AppConfig.sessionBonusXP

                // Mark day state
                if sessionType == .morning {
                    try await sessionStore.markMorningComplete(userId: userId, studyDay: studyDay,
                        accuracy: totalAttempts > 0 ? Double(totalCorrect) / Double(totalAttempts) : 0,
                        xp: xpEarned, newWords: newWords.count)
                } else if sessionType == .evening {
                    try await sessionStore.markEveningComplete(userId: userId, studyDay: studyDay,
                        accuracy: totalAttempts > 0 ? Double(totalCorrect) / Double(totalAttempts) : 0,
                        xp: xpEarned, newWords: newWords.count)

                    // Run Day 1 promotion
                    let dm = DataManager.shared
                    let wsStore = WordStateStore(db: dm.db)
                    let promotion = try await wsStore.runDay1Promotion(userId: userId, studyDay: studyDay)
                    wordsPromoted += promotion.promoted
                }

                // Update streak
                let (_, milestoneXP) = try await statsStore.updateStreak(userId: userId, xpToday: xpEarned)
                xpEarned += milestoneXP
            } catch {
                // Non-fatal
            }
        }
    }

    // MARK: - Pause/Resume

    func pause(stepIndex: Int, itemIndex: Int, showAgainIds: [Int], requeuedIds: [Int]) async {
        isPaused = true
        do {
            let store = SessionStateStore.shared
            try await store.pauseSession(userId: userId, studyDay: studyDay, sessionType: sessionType,
                                        stepIndex: stepIndex, itemIndex: itemIndex,
                                        showAgainIds: showAgainIds, requeuedIds: requeuedIds)
        } catch {}
    }
}
