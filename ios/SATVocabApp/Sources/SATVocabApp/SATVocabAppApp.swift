import SwiftUI

@main
struct SATVocabAppApp: App {
    @StateObject private var bootstrap = AppBootstrap()
    @Environment(\.scenePhase) private var scenePhase
    @State private var backgroundedAt: Date?

    var body: some Scene {
        WindowGroup {
            Group {
                if let err = bootstrap.errorMessage {
                    VStack(spacing: 12) {
                        Text("Failed to start")
                            .font(.title3.weight(.semibold))
                        Text(err)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                } else if !bootstrap.isReady {
                    ProgressView()
                        .onAppear { bootstrap.start() }
                } else {
                    RootTabView()
                }
            }
        }
        .onChange(of: scenePhase) { _, newPhase in
            switch newPhase {
            case .background:
                backgroundedAt = Date()
            case .active:
                // If backgrounded for more than 30 minutes, auto-pause any active session
                if let bg = backgroundedAt,
                   Date().timeIntervalSince(bg) > 1800 {
                    Task {
                        // The session auto-save already marked is_paused=1 on every item advance,
                        // so on next launch PracticeTabView will show the ResumeCard automatically.
                        // Just end any Live Activity that might still be running.
                        await MainActor.run {
                            LiveActivityManager.shared.end(xpEarned: 0)
                        }
                    }
                }
                backgroundedAt = nil
            default:
                break
            }
        }
    }
}
