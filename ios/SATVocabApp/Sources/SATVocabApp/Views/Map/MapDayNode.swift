import SwiftUI

struct MapDayNode: View {
    enum NodeState {
        case completed(morningDone: Bool, eveningDone: Bool)
        case current
        case available
        case locked
        case zoneTest(passed: Bool)
    }

    let label: String       // "I", "II", "III", "IV", "V", "TEST"
    let state: NodeState
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            ZStack {
                // Golden glow for current day
                if case .current = state {
                    Circle()
                        .fill(Color(hex: "#FFD700").opacity(0.25))
                        .frame(width: 72, height: 72)
                        .blur(radius: 10)
                    Circle()
                        .stroke(Color(hex: "#FFD700").opacity(0.5), lineWidth: 2)
                        .frame(width: 68, height: 68)
                    Circle()
                        .stroke(Color(hex: "#FFD700").opacity(0.35), lineWidth: 1.5)
                        .frame(width: 76, height: 76)
                }

                // Label text — no background circle, transparent over painted circles
                Text(label)
                    .font(.system(size: fontSize, weight: .bold, design: .serif))
                    .foregroundStyle(textColor)
                    .shadow(color: shadowColor, radius: 2, x: 0, y: 1)
                    .shadow(color: shadowColor, radius: 1, x: 0, y: 0)
            }
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.8 : 1.0)
    }

    private var fontSize: CGFloat {
        switch state {
        case .current: return 24
        case .zoneTest: return 18
        default: return 20
        }
    }

    private var textColor: Color {
        switch state {
        case .current:
            return Color(hex: "#FFD700")                    // golden
        case .completed:
            return Color(hex: "#C0C8D4").opacity(0.9)       // silver for completed
        case .available:
            return Color(hex: "#64C8FF")                    // icy blue for uncompleted
        case .locked:
            return Color(hex: "#64C8FF").opacity(0.6)       // dimmer icy blue
        case .zoneTest(let passed):
            return passed ? Color(hex: "#C0C8D4").opacity(0.9) : Color(hex: "#64C8FF").opacity(0.7)
        }
    }

    private var shadowColor: Color {
        switch state {
        case .current:
            return Color(hex: "#4A2D00").opacity(0.9)
        case .completed:
            return Color.black.opacity(0.7)
        case .available, .locked:
            return Color(hex: "#001E40").opacity(0.8)
        default:
            return Color.black.opacity(0.7)
        }
    }

    private var isDisabled: Bool {
        switch state {
        case .locked, .available: return true
        default: return false
        }
    }
}
