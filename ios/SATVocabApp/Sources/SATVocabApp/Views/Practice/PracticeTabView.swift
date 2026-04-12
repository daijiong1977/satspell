import SwiftUI

struct PracticeTabView: View {
    @StateObject private var vm = PracticeTabViewModel()
    @State private var navigateToSession: SessionType? = nil

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                PracticeHeader(
                    studyDay: vm.studyDay,
                    zoneIndex: vm.zoneIndex,
                    streak: vm.streak.currentStreak,
                    totalXP: vm.streak.totalXP
                )

                if vm.isLoading {
                    ProgressView()
                        .padding(.top, 40)
                } else {
                    stateContent
                }
            }
            .padding(.horizontal, 16)
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { Task { await vm.load() } }
        .navigationDestination(item: $navigateToSession) { type in
            SessionFlowView(vm: SessionFlowViewModel(sessionType: type, studyDay: vm.studyDay))
        }
    }

    @ViewBuilder
    private var stateContent: some View {
        switch vm.state {
        case .morningAvailable:
            MorningSessionCard {
                navigateToSession = .morning
            }
            EveningSessionCard(locked: true, unlockAt: nil)
            ReviewsDueRow(count: vm.reviewsDueCount)

        case .paused(let session):
            ResumeCard(session: session) {
                navigateToSession = session.sessionType
            }
            EveningSessionCard(locked: true, unlockAt: nil)

        case .morningDoneEveningLocked(let unlockAt):
            MorningCompleteCard()
            EveningSessionCard(locked: true, unlockAt: unlockAt)
            ReviewsDueRow(count: vm.reviewsDueCount)

        case .eveningAvailable:
            MorningCompleteCard()
            EveningSessionCard(locked: false, unlockAt: nil) {
                navigateToSession = .evening
            }
            ReviewsDueRow(count: vm.reviewsDueCount)

        case .bothComplete:
            MorningCompleteCard()
            EveningCompleteCard()
            DayCompleteSummary(studyDay: vm.studyDay, userId: vm.userId)
            ReviewsDueRow(count: vm.reviewsDueCount)
        }
    }
}
