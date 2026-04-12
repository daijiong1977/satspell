import SwiftUI

struct PracticeHeader: View {
    let studyDay: Int
    let zoneIndex: Int
    let streak: Int
    let totalXP: Int

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Day \(studyDay)")
                        .font(.system(.largeTitle, design: .rounded).weight(.bold))
                    Text(AdventureSchedule.zoneTitle(zoneIndex: zoneIndex))
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(.secondary)
                }

                Spacer()

                HStack(spacing: 14) {
                    HStack(spacing: 5) {
                        Image(systemName: "flame.fill")
                            .foregroundStyle(.orange)
                        Text("\(streak)")
                            .font(.system(.headline, design: .rounded).weight(.bold))
                    }

                    HStack(spacing: 5) {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                        Text("\(totalXP)")
                            .font(.system(.headline, design: .rounded).weight(.bold))
                    }
                }
            }
        }
        .padding(.top, 8)
    }
}
