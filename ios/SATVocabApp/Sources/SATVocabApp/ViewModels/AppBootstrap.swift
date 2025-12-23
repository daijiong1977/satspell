import Foundation

@MainActor
final class AppBootstrap: ObservableObject {
    @Published var isReady: Bool = false
    @Published var errorMessage: String? = nil

    func start() {
        Task {
            do {
                try await DataManager.shared.initializeIfNeeded()
                isReady = true
            } catch {
                errorMessage = String(describing: error)
            }
        }
    }
}
