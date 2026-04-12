import SwiftUI

struct SessionHeaderView: View {
    let stepNumber: Int
    let totalSteps: Int
    let stepLabel: String
    let currentItem: Int
    let totalItems: Int
    let progressColor: Color
    let isScored: Bool
    let onClose: () -> Void

    var body: some View {
        VStack(spacing: 6) {
            HStack {
                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(hex: "#AFAFAF"))
                }

                Spacer()

                VStack(spacing: 2) {
                    Text("STEP \(stepNumber) OF \(totalSteps)")
                        .font(.system(size: 9, weight: .semibold, design: .rounded))
                        .foregroundColor(isScored ? progressColor : Color(hex: "#AFAFAF"))
                        .tracking(0.5)

                    Text("\(stepLabel) \u{00B7} \(currentItem)/\(totalItems)")
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: "#4B4B4B"))
                }

                Spacer()

                Button(action: {}) {
                    Image(systemName: "speaker.wave.2.fill")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color(hex: "#AFAFAF"))
                }
            }
            .padding(.horizontal, 16)

            // Progress bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3, style: .continuous)
                        .fill(Color(hex: "#E5E5E5"))

                    RoundedRectangle(cornerRadius: 3, style: .continuous)
                        .fill(progressColor)
                        .frame(width: geo.size.width * CGFloat(currentItem) / CGFloat(max(totalItems, 1)))
                }
            }
            .frame(height: 6)
            .padding(.horizontal, 16)
        }
        .padding(.top, 8)
        .padding(.bottom, 4)
    }
}
