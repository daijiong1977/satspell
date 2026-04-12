import SwiftUI

struct PauseSheet: View {
    let onKeepGoing: () -> Void
    let onPauseExit: () -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 20) {
            // Handle
            RoundedRectangle(cornerRadius: 3)
                .fill(Color(hex: "#E5E5E5"))
                .frame(width: 40, height: 4)
                .padding(.top, 12)

            Text("Take a break?")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(Color(hex: "#4B4B4B"))

            Text("Your progress is saved. You can pick up where you left off.")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(Color(hex: "#AFAFAF"))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)

            // Focus tip
            VStack(spacing: 6) {
                Text("FOCUS TIP")
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "#CE82FF"))
                    .tracking(0.5)
                Text("Short, focused sessions work better than long ones. Even 5 minutes counts!")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color(hex: "#666666"))
                    .multilineTextAlignment(.center)
            }
            .padding(16)
            .background(Color(hex: "#CE82FF").opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .padding(.horizontal, 20)

            Spacer()

            // Buttons
            VStack(spacing: 10) {
                Button3D("Keep Going", action: onKeepGoing)

                Button3D("Pause & Exit",
                         color: .white,
                         pressedColor: Color(hex: "#E5E5E5"),
                         textColor: Color(hex: "#AFAFAF"),
                         action: {
                             dismiss()
                             DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                                 onPauseExit()
                             }
                         })
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 30)
        }
        .presentationDetents([.fraction(0.5)])
    }
}
