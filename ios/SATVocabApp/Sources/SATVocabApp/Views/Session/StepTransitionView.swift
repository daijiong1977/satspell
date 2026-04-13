import SwiftUI

struct StepTransitionView: View {
    let stepNumber: Int
    let totalSteps: Int
    let nextStepLabel: String
    let onContinue: () -> Void

    @State private var autoAdvanceTask: Task<Void, Never>?

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            // Celebration
            Text("Step \(stepNumber) Complete!")
                .font(.system(size: 22, weight: .black, design: .rounded))
                .foregroundColor(Color(hex: "#4B4B4B"))

            // Step dots
            HStack(spacing: 8) {
                ForEach(1...totalSteps, id: \.self) { step in
                    Circle()
                        .fill(step <= stepNumber
                              ? Color(hex: "#58CC02")
                              : Color(hex: "#E5E5E5"))
                        .frame(width: 12, height: 12)
                        .overlay(
                            step <= stepNumber
                                ? Image(systemName: "checkmark")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(.white)
                                : nil
                        )
                }
            }

            // Next step card
            VStack(spacing: 8) {
                Text("UP NEXT")
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "#AFAFAF"))
                    .tracking(0.5)

                Text(nextStepLabel)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "#4B4B4B"))
            }
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(Color(hex: "#F7F7F7"))
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .padding(.horizontal, 24)

            Spacer()

            Button3D("Continue", action: {
                autoAdvanceTask?.cancel()
                onContinue()
            })
                .padding(.horizontal, 40)
                .padding(.bottom, 30)
        }
        .background(Color.white)
        .onAppear {
            autoAdvanceTask = Task {
                try? await Task.sleep(nanoseconds: 3_000_000_000)
                if !Task.isCancelled {
                    await MainActor.run { onContinue() }
                }
            }
        }
        .onDisappear {
            autoAdvanceTask?.cancel()
        }
    }
}
