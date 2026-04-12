import Foundation
import ActivityKit

// MARK: - Activity Attributes

struct SessionActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var stepLabel: String      // "ABRUPT"
        var progress: String       // "2/11"
        var stepNumber: Int        // 1
        var totalSteps: Int        // 3
        var xpEarned: Int          // 40
    }
    var sessionType: String  // "morning" or "evening"
}

// MARK: - Manager

@MainActor
final class LiveActivityManager {
    static let shared = LiveActivityManager()

    private var currentActivity: Activity<SessionActivityAttributes>?

    private init() {}

    func start(sessionType: String, stepLabel: String, totalSteps: Int) {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }

        let attributes = SessionActivityAttributes(sessionType: sessionType)
        let initialState = SessionActivityAttributes.ContentState(
            stepLabel: stepLabel,
            progress: "1/\(totalSteps)",
            stepNumber: 1,
            totalSteps: totalSteps,
            xpEarned: 0
        )

        do {
            let content = ActivityContent(state: initialState, staleDate: nil)
            let activity = try Activity<SessionActivityAttributes>.request(
                attributes: attributes,
                content: content,
                pushType: nil
            )
            currentActivity = activity
        } catch {
            print("Live Activity start error: \(error)")
        }
    }

    func update(stepLabel: String, progress: String, stepNumber: Int, totalSteps: Int, xpEarned: Int) {
        guard let activity = currentActivity else { return }

        let updatedState = SessionActivityAttributes.ContentState(
            stepLabel: stepLabel,
            progress: progress,
            stepNumber: stepNumber,
            totalSteps: totalSteps,
            xpEarned: xpEarned
        )

        Task {
            let content = ActivityContent(state: updatedState, staleDate: nil)
            await activity.update(content)
        }
    }

    func end(xpEarned: Int) {
        guard let activity = currentActivity else { return }

        let finalState = SessionActivityAttributes.ContentState(
            stepLabel: "Done!",
            progress: "",
            stepNumber: 0,
            totalSteps: 0,
            xpEarned: xpEarned
        )

        Task {
            let content = ActivityContent(state: finalState, staleDate: nil)
            await activity.end(content, dismissalPolicy: .after(.now + 5))
            currentActivity = nil
        }
    }
}
