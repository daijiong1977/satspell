import SwiftUI

struct ReviewTarget: Hashable, Identifiable {
    let sessionType: SessionType
    let startStep: Int
    var id: String { "\(sessionType.rawValue)-\(startStep)" }
}

struct PracticeTabView: View {
    @StateObject private var vm = PracticeTabViewModel()
    @State private var navigateToSession: SessionType? = nil
    @State private var reviewTarget: ReviewTarget? = nil
    @State private var showRestartConfirm = false
    @State private var pendingRestartSession: SessionState? = nil

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
                            .accessibilityIdentifier("practiceLoading")
                            .padding(.top, 40)
                    } else {
                        stateContent
                    }
                }
                .padding(.horizontal, 16)
        }
        .background {
            if let bgImg = ZoneBackgroundHelper.image(forZoneIndex: vm.zoneIndex) {
                Image(uiImage: bgImg)
                    .resizable()
                    .scaledToFill()
                    .opacity(0.35)
                    .ignoresSafeArea()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if navigateToSession != nil {
                navigateToSession = nil
            }
            if reviewTarget != nil {
                reviewTarget = nil
            }
            Task { await vm.load() }
        }
        .navigationDestination(item: $navigateToSession) { type in
            SessionFlowView(vm: SessionFlowViewModel(sessionType: type, studyDay: vm.studyDay))
        }
        .navigationDestination(item: $reviewTarget) { target in
            SessionFlowView(vm: SessionFlowViewModel(sessionType: target.sessionType, studyDay: vm.studyDay, isReview: true, startStep: target.startStep))
        }
        .alert("Start Over?", isPresented: $showRestartConfirm) {
            Button("Cancel", role: .cancel) {
                pendingRestartSession = nil
            }
            Button("Start Over", role: .destructive) {
                if let session = pendingRestartSession {
                    Task {
                        // Mark old reviews as superseded
                        let dm = DataManager.shared
                        try? await dm.initializeIfNeeded()
                        let logger = ReviewLogger(db: dm.db)
                        try? await logger.supersedeSession(
                            userId: vm.userId,
                            studyDay: session.studyDay,
                            sessionType: session.sessionType
                        )
                        // Discard the session
                        try? await SessionStateStore.shared.discardSession(
                            userId: vm.userId,
                            studyDay: session.studyDay,
                            sessionType: session.sessionType
                        )
                        pendingRestartSession = nil
                        navigateToSession = session.sessionType
                    }
                }
            }
        } message: {
            Text("This will restart the session from the beginning. Your previous answers from this session will not count.")
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
            ResumeCard(
                session: session,
                onResume: {
                    navigateToSession = session.sessionType
                },
                onRestart: {
                    pendingRestartSession = session
                    showRestartConfirm = true
                }
            )
            if session.sessionType == .evening {
                MorningCompleteCard(reviewable: true, onReviewStep: { step in
                    reviewTarget = ReviewTarget(sessionType: .morning, startStep: step)
                })
            }

        case .morningDoneEveningLocked(let unlockAt):
            MorningCompleteCard(reviewable: true, onReviewStep: { step in
                reviewTarget = ReviewTarget(sessionType: .morning, startStep: step)
            })
            EveningSessionCard(locked: true, unlockAt: unlockAt)
            ReviewsDueRow(count: vm.reviewsDueCount)

        case .eveningAvailable:
            MorningCompleteCard(reviewable: true, onReviewStep: { step in
                reviewTarget = ReviewTarget(sessionType: .morning, startStep: step)
            })
            EveningSessionCard(locked: false, unlockAt: nil) {
                navigateToSession = .evening
            }
            ReviewsDueRow(count: vm.reviewsDueCount)

        case .bothComplete:
            MorningCompleteCard(reviewable: true, onReviewStep: { step in
                reviewTarget = ReviewTarget(sessionType: .morning, startStep: step)
            })
            EveningCompleteCard(reviewable: true, onReviewStep: { step in
                reviewTarget = ReviewTarget(sessionType: .evening, startStep: step)
            })
            DayCompleteSummary(studyDay: vm.studyDay, userId: vm.userId)
            ReviewsDueRow(count: vm.reviewsDueCount)
        }
    }
}
