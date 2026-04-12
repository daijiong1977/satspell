import SwiftUI

struct MapDayNode: View {
    enum NodeState {
        case completed(morningDone: Bool, eveningDone: Bool)
        case current
        case available
        case locked
        case zoneTest(passed: Bool)
    }

    let title: String
    let state: NodeState
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 6) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(fillColor)
                        .frame(width: 68, height: 48)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .strokeBorder(borderColor, lineWidth: borderWidth)
                        )

                    nodeIcon
                }

                Text(title)
                    .font(.system(.footnote, design: .rounded).weight(.bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.black.opacity(0.22))
                    .clipShape(Capsule())

                // Session dots for completed days
                sessionDots
            }
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
    }

    @ViewBuilder
    private var nodeIcon: some View {
        switch state {
        case .completed:
            Image(systemName: "checkmark")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.white)
        case .current:
            Circle()
                .fill(.white.opacity(0.95))
                .frame(width: 10, height: 10)
        case .available:
            Circle()
                .fill(.white.opacity(0.8))
                .frame(width: 10, height: 10)
        case .locked:
            Image(systemName: "lock.fill")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(.white.opacity(0.95))
        case .zoneTest(let passed):
            if passed {
                Text("\u{1F3C6}")
                    .font(.system(size: 20))
            } else {
                Image(systemName: "flag.checkered")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
            }
        }
    }

    @ViewBuilder
    private var sessionDots: some View {
        switch state {
        case .completed(let morningDone, let eveningDone):
            HStack(spacing: 4) {
                if morningDone {
                    Text("\u{2600}\u{FE0F}")
                        .font(.system(size: 12))
                }
                if eveningDone {
                    Text("\u{1F319}")
                        .font(.system(size: 12))
                }
            }
        default:
            EmptyView()
        }
    }

    private var fillColor: Color {
        switch state {
        case .completed:
            return Color(hex: "#58CC02")
        case .current:
            return Color.blue.opacity(0.92)
        case .available:
            return Color(hex: "#58CC02").opacity(0.75)
        case .locked:
            return Color.gray.opacity(0.55)
        case .zoneTest(let passed):
            return passed ? Color.purple.opacity(0.85) : Color.indigo.opacity(0.8)
        }
    }

    private var borderColor: Color {
        switch state {
        case .current:
            return Color.white.opacity(0.5)
        default:
            return Color.black.opacity(0.10)
        }
    }

    private var borderWidth: CGFloat {
        switch state {
        case .current: return 2
        default: return 1
        }
    }

    private var isDisabled: Bool {
        switch state {
        case .locked: return true
        default: return false
        }
    }
}
