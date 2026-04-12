import SwiftUI

struct ComboCalloutView: View {
    let comboCount: Int

    var message: String {
        switch comboCount {
        case 3: return "On a roll."
        case 5: return "Unstoppable!"
        case 8: return "Legendary!"
        default: return "\(comboCount)x combo"
        }
    }

    var body: some View {
        Text(message)
            .font(.system(size: 13, weight: .bold, design: .rounded))
            .foregroundColor(Color(hex: "#FFC800"))
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(Color(hex: "#FFC800").opacity(0.15))
            )
            .transition(.scale.combined(with: .opacity))
    }
}
