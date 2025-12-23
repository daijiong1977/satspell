import Foundation

@MainActor
final class DashboardViewModel: ObservableObject {
    enum LoadState {
        case idle
        case loading
        case loaded
        case failed(String)
    }

    struct Stats {
        let streakDays: Int
        let xp: Int
    }

    @Published var loadState: LoadState = .idle
    @Published var list: ListInfo? = nil
    @Published var stats: Stats = .init(streakDays: 0, xp: 0)

    let userId = LocalIdentity.userId()

    func load() {
        loadState = .loading
        Task {
            do {
                let list = try await DataManager.shared.getDefaultList()
                self.list = list
                try await DataManager.shared.ensureProgressSnapshot(userId: userId, listId: list.id)
                let snap = try await DataManager.shared.fetchProgressSnapshot(userId: userId, listId: list.id)

                let streak = snap?.streakDays ?? 0
                let xp = (snap?.masteredCount ?? 0) * AppConfig.xpPerCorrect

                self.stats = Stats(streakDays: streak, xp: xp)
                self.loadState = .loaded
            } catch {
                self.loadState = .failed(String(describing: error))
            }
        }
    }

    func taskStates(date: Date = Date()) -> [TaskState] {
        let completed = TaskProgressStore.shared.load(date: date)
        if AppConfig.unlockAllTasksForTesting {
            return (0..<6).map { idx in
                completed[idx] ? .completed : .active
            }
        }

        let activeIndex = TaskProgressStore.shared.nextActiveTaskIndex(date: date)

        return (0..<6).map { idx in
            if completed[idx] { return .completed }
            if idx == activeIndex { return .active }
            return .locked
        }
    }
}

enum TaskState {
    case completed
    case active
    case locked
}
