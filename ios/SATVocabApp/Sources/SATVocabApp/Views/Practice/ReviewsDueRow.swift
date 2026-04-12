import SwiftUI

struct ReviewsDueRow: View {
    let count: Int

    var body: some View {
        if count > 0 {
            HStack(spacing: 10) {
                Image(systemName: "arrow.counterclockwise.circle.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.blue)

                Text("\(count) review\(count == 1 ? "" : "s") due today")
                    .font(.system(.subheadline, design: .rounded).weight(.semibold))

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.secondary)
            }
            .padding(14)
            .background(Color.blue.opacity(0.06))
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
    }
}
