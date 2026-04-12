import SwiftUI

struct ZoneProgressBar: View {
    let familiarCount: Int
    let totalCount: Int

    private var progress: Double {
        guard totalCount > 0 else { return 0 }
        return min(1.0, Double(familiarCount) / Double(totalCount))
    }

    var body: some View {
        VStack(spacing: 6) {
            HStack {
                Text("\(familiarCount)/\(totalCount) words learned")
                    .font(.system(.caption, design: .rounded).weight(.semibold))
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(Int(progress * 100))%")
                    .font(.system(.caption, design: .rounded).weight(.bold))
                    .foregroundStyle(Color(hex: "#58CC02"))
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                        .fill(Color.gray.opacity(0.15))
                        .frame(height: 8)

                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                        .fill(Color(hex: "#58CC02"))
                        .frame(width: geo.size.width * progress, height: 8)
                }
            }
            .frame(height: 8)
        }
    }
}
