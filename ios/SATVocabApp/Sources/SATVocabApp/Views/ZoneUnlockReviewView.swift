import SwiftUI

struct ZoneUnlockReviewView: View {
    let zoneIndex: Int

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 14) {
            Text("Zone \(zoneIndex + 1) Review")
                .font(.system(.largeTitle, design: .rounded).weight(.bold))
                .multilineTextAlignment(.center)

            Text("Review difficult words from this zone to unlock the next zone.")
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            NavigationLink {
                ZoneReviewSessionView(zoneIndex: zoneIndex) {
                    AdventureProgressStore.shared.setZoneUnlocked(zoneIndex: zoneIndex + 1, unlocked: true)
                    dismiss()
                }
            } label: {
                Text("Start Review")
                    .font(.system(.headline, design: .rounded).weight(.bold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.purple.opacity(0.85))
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
            .disabled(zoneIndex >= AdventureSchedule.totalZones - 1)

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
        .padding(.top, 10)
        .navigationBarTitleDisplayMode(.inline)
    }
}
