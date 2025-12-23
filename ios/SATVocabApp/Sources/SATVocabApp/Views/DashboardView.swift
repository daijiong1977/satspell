import SwiftUI

struct DashboardView: View {
    @StateObject private var bootstrap = AppBootstrap()
    @StateObject private var vm = DashboardViewModel()

    @State private var route: Route? = nil

    var body: some View {
        NavigationStack {
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
                    content
                        .onAppear { vm.load() }
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(item: $route) { route in
                switch route {
                case .flashcards(let mode):
                    FlashcardSessionView(mode: mode) { completedTaskIndex in
                        TaskProgressStore.shared.setCompleted(taskIndex: completedTaskIndex, completed: true)
                        vm.load()
                    }
                case .game(let mode):
                    GameSessionView(mode: mode) { completedTaskIndex in
                        TaskProgressStore.shared.setCompleted(taskIndex: completedTaskIndex, completed: true)
                        vm.load()
                    }
                }
            }
        }
    }

    private var content: some View {
        VStack(spacing: 16) {
            header
            TimelineView(states: vm.taskStates()) { tappedIndex in
                let states = vm.taskStates()
                // Allow replaying completed tasks; only block locked ones.
                guard states[tappedIndex] != .locked else { return }

                switch tappedIndex {
                case 0:
                    route = .flashcards(mode: .task1)
                case 1:
                    route = .flashcards(mode: .task2)
                case 2:
                    route = .game(mode: .task3Images)
                case 3:
                    route = .game(mode: .task4Sat)
                case 4:
                    // Task 5 is not implemented yet; route to Task 3 for testing.
                    route = .game(mode: .task3Images)
                case 5:
                    // Task 6 is not implemented yet; route to Task 4 for testing.
                    route = .game(mode: .task4Sat)
                default:
                    break
                }
            }
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }

    private var header: some View {
        HStack(alignment: .firstTextBaseline) {
            Text("Today’s Path")
                .font(.system(.largeTitle, design: .rounded).weight(.bold))

            Spacer()

            HStack(spacing: 12) {
                HStack(spacing: 6) {
                    Image(systemName: "flame.fill")
                        .foregroundStyle(.orange)
                    Text("\(vm.stats.streakDays)")
                        .font(.system(.headline, design: .rounded).weight(.semibold))
                }

                HStack(spacing: 6) {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.yellow)
                    Text("\(vm.stats.xp)")
                        .font(.system(.headline, design: .rounded).weight(.semibold))
                }
            }
        }
        .padding(.top, 6)
    }
}

private enum Route: Hashable, Identifiable {
    case flashcards(mode: FlashcardSessionMode)
    case game(mode: GameSessionMode)

    var id: String {
        switch self {
        case .flashcards(let mode): return "flashcards_\(mode.rawValue)"
        case .game(let mode): return "game_\(mode.rawValue)"
        }
    }
}

#Preview {
    DashboardView()
}
