import SwiftUI

struct XPChipView: View {
    let xp: Int
    @State private var offsetY: CGFloat = 0
    @State private var opacity: Double = 1.0

    var body: some View {
        Text("+\(xp) XP")
            .font(.system(size: 14, weight: .heavy, design: .rounded))
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color(hex: "#FFC800"))
            .clipShape(Capsule())
            .offset(y: offsetY)
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeOut(duration: 0.8)) {
                    offsetY = -30
                }
                withAnimation(.easeOut(duration: 0.8).delay(0.5)) {
                    opacity = 0
                }
            }
    }
}
