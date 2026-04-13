import SwiftUI

struct Button3D: View {
    let title: String
    let color: Color
    let pressedColor: Color
    let textColor: Color
    let action: () -> Void

    @State private var isPressed = false

    init(_ title: String, color: Color = Color(hex: "#58CC02"),
         pressedColor: Color = Color(hex: "#58A700"),
         textColor: Color = .white, action: @escaping () -> Void) {
        self.title = title
        self.color = color
        self.pressedColor = pressedColor
        self.textColor = textColor
        self.action = action
    }

    var body: some View {
        Text(title)
            .font(.system(size: 20, weight: .heavy, design: .rounded))
            .tracking(0.3)
            .foregroundColor(textColor)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(pressedColor)
                    .frame(height: isPressed ? 2 : 4)
                    .frame(maxHeight: .infinity, alignment: .bottom)
            )
            .offset(y: isPressed ? 2 : 0)
            .animation(.easeOut(duration: 0.12), value: isPressed)
            .onTapGesture {
                isPressed = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                    isPressed = false
                    action()
                }
            }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
