import Foundation
import Combine

@MainActor
final class PracticeTabViewModel: ObservableObject {
    @Published var state: PracticeState = .morningAvailable
    @Published var studyDay: Int = 0
    @Published var zoneIndex: Int = 0
    @Published var streak: StreakInfo = StreakInfo(
        currentStreak: 0, bestStreak: 0, lastStudyDate: nil,
        totalXP: 0, totalStudyDays: 0,
        streak3Claimed: false, streak7Claimed: false,
        streak14Claimed: false, streak30Claimed: false
    )
    @Published var reviewsDueCount: Int = 0
    @Published var isLoading: Bool = true

    let userId = LocalIdentity.userId()

    func load() async {
        isLoading = true
        do {
            let dm = DataManager.shared
            try await dm.initializeIfNeeded()

            let sessionStore = SessionStateStore.shared
            let statsStore = StatsStore.shared
            let wsStore = WordStateStore(db: dm.db)

            let dayState = try await sessionStore.getCurrentDayState(userId: userId)
            let activeSession = try await sessionStore.getActiveSession(userId: userId)
            streak = try await statsStore.getStreak(userId: userId)
            reviewsDueCount = try await wsStore.countOverdue(userId: userId)

            studyDay = dayState?.studyDay ?? 0
            zoneIndex = dayState?.zoneIndex ?? 0

            state = PracticeStateResolver.resolve(
                dayState: dayState,
                activeSession: activeSession
            )
        } catch {
            // Default to morning available on error
            state = .morningAvailable
        }
        isLoading = false
    }
}
