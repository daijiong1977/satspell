import SwiftUI

@main
struct SATVocabAppApp: App {
    @StateObject private var bootstrap = AppBootstrap()

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
    }
}
