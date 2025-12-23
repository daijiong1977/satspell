import SwiftUI

struct TimelineView: View {
    let states: [TaskState] // expected 6
    let onTapTask: (Int) -> Void

    var body: some View {
        VStack(spacing: 18) {
            ForEach(0..<6, id: \.self) { idx in
                TimelineRow(
                    index: idx,
                    state: states[safe: idx] ?? .locked,
                    title: title(for: idx),
                    onTap: { onTapTask(idx) }
                )
            }
        }
        .padding(.top, 4)
    }

    private func title(for idx: Int) -> String {
        switch idx {
        case 0: return "Task 1  Learning 20 new words"
        case 1: return "Task 2  Review"
        case 2: return "Task 3  Image to Word (20)"
        case 3: return "Task 4  SAT Questions (20)"
        case 4: return "Task 5"
        default: return "Task 6"
        }
    }
}

private struct TimelineRow: View {
    let index: Int
    let state: TaskState
    let title: String
    let onTap: () -> Void

    @State private var pulse = false

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(spacing: 0) {
                ZStack {
                    if state == .active {
                        Circle()
                            .stroke(.orange, lineWidth: 4)
                            .frame(width: 26, height: 26)
                            .scaleEffect(pulse ? 1.08 : 0.92)
                            .opacity(pulse ? 0.55 : 1.0)
                            .animation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true), value: pulse)
                            .onAppear { pulse = true }
                    }

                    Circle()
                        .fill(nodeFill)
                        .frame(width: 14, height: 14)

                    Image(systemName: nodeIcon)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(nodeIconColor)
                        .opacity(state == .active ? 0.0 : 1.0)
                }

                Rectangle()
                    .fill(.gray.opacity(0.25))
                    .frame(width: 2, height: 44)
                    .opacity(index == 4 ? 0 : 1)
            }

            TaskCard(state: state, title: title, onTap: onTap)

            Spacer(minLength: 0)
        }
    }

    private var nodeFill: Color {
        switch state {
        case .completed: return .green
        case .active: return .orange
        case .locked: return .gray.opacity(0.4)
        }
    }

    private var nodeIcon: String {
        switch state {
        case .completed: return "checkmark"
        case .active: return ""
        case .locked: return "lock.fill"
        }
    }

    private var nodeIconColor: Color {
        switch state {
        case .completed: return .white
        case .active: return .clear
        case .locked: return .white
        }
    }
}

private struct TaskCard: View {
    let state: TaskState
    let title: String
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.system(.headline, design: .rounded).weight(.bold))
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }

                Spacer()

                if state == .active {
                    Text("Play")
                        .font(.system(.headline, design: .rounded).weight(.semibold))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color.green)
                        .foregroundStyle(.white)
                        .clipShape(Capsule())
                }
            }
            .padding(16)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .strokeBorder(state == .active ? Color.green.opacity(0.35) : Color.gray.opacity(0.12), lineWidth: 1)
            )
            .opacity(opacity)
        }
        .buttonStyle(.plain)
        .disabled(state == .locked)
    }

    private var opacity: Double {
        switch state {
        case .completed: return 0.55
        case .active: return 1.0
        case .locked: return 0.35
        }
    }
}

private extension Array {
    subscript(safe index: Int) -> Element? {
        guard indices.contains(index) else { return nil }
        return self[index]
    }
}
