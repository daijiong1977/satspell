import SwiftUI

struct WordStrengthMeter: View {
    let boxLevel: Int  // 0-5
    let memoryStatus: MemoryStatus

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 2) {
                ForEach(1...5, id: \.self) { level in
                    RoundedRectangle(cornerRadius: 3, style: .continuous)
                        .fill(level <= boxLevel
                              ? Color(hex: WordStrength(rawValue: level)?.colorHex ?? "#E8ECF0")
                              : Color(hex: "#E8ECF0"))
                        .frame(height: 6)
                }
            }

            if boxLevel > 0 {
                HStack(spacing: 4) {
                    if memoryStatus == .fragile {
                        Circle().fill(Color(hex: "#FFC800")).frame(width: 6, height: 6)
                    } else if memoryStatus == .stubborn {
                        Circle().fill(Color(hex: "#FF7043")).frame(width: 6, height: 6)
                    }

                    Text(WordStrength(rawValue: boxLevel)?.label ?? "")
                        .font(.system(size: 9, weight: .semibold, design: .rounded))
                        .foregroundColor(Color(hex: WordStrength(rawValue: boxLevel)?.colorHex ?? "#AFAFAF"))
                }
            }
        }
    }
}
