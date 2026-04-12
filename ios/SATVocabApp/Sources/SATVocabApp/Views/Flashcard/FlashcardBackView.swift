import SwiftUI

struct FlashcardBackView: View {
    let card: VocabCard
    let cardIndex: Int
    let totalCards: Int
    let boxLevel: Int
    let memoryStatus: MemoryStatus
    let isReadOnly: Bool
    let onShowAgain: () -> Void
    let onGotIt: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            // Header removed — SessionHeaderView handles this

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Thumbnail + Word + POS + Strength
                    HStack(alignment: .top, spacing: 12) {
                        if let ui = ImageResolver.uiImage(for: card.imageFilename) {
                            Image(uiImage: ui)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        } else {
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(Color(hex: "#E8ECF0"))
                                .frame(width: 60, height: 60)
                                .overlay(
                                    Text(String(card.lemma.prefix(1)).uppercased())
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(Color(hex: "#AFAFAF"))
                                )
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text(card.lemma.uppercased())
                                .font(.system(size: 26, weight: .black, design: .rounded))
                                .foregroundColor(Color(hex: "#FFC800"))
                                .tracking(0.5)

                            if let pos = card.pos, !pos.isEmpty {
                                Text(pos)
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(Color(hex: "#AFAFAF"))
                            }

                            if boxLevel > 0 {
                                WordStrengthMeter(boxLevel: boxLevel, memoryStatus: memoryStatus)
                                    .frame(width: 140)
                            }
                        }
                    }
                    .padding(.horizontal, 16)

                    // Definition
                    sectionView(label: "DEFINITION") {
                        Text(card.definition ?? "")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(Color(hex: "#1A1A2E"))
                            .lineSpacing(4)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    // Example
                    if let example = card.example, !example.isEmpty {
                        sectionView(label: "EXAMPLE") {
                            HStack(spacing: 0) {
                                Rectangle()
                                    .fill(Color(hex: "#FFC800"))
                                    .frame(width: 4)
                                Text(highlightedExample(example, word: card.lemma))
                                    .font(.system(size: 21, weight: .regular))
                                    .foregroundColor(Color(hex: "#4B4B4B"))
                                    .lineSpacing(4)
                                    .padding(12)
                            }
                            .background(Color(hex: "#FFFDE7"))
                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                        }
                    }

                    // Collocations
                    if let collocations = card.collocations, !collocations.isEmpty {
                        sectionView(label: "COLLOCATIONS") {
                            FlowLayout(spacing: 8) {
                                ForEach(collocations, id: \.self) { phrase in
                                    Text(phrase)
                                        .font(.system(size: 19, weight: .medium))
                                        .foregroundColor(Color(hex: "#4B4B4B"))
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(Color(hex: "#FFF8E1"))
                                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                                }
                            }
                        }
                    }

                    // SAT Context
                    if let satContext = card.satContext, !satContext.isEmpty {
                        sectionView(label: "SAT CONTEXT") {
                            Text(satContext)
                                .font(.system(size: 19, weight: .regular))
                                .foregroundColor(Color(hex: "#666666"))
                                .lineSpacing(3)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
                .padding(.bottom, 16)
            }
            .frame(minHeight: UIScreen.main.bounds.height * 0.7 - 80)

            Spacer(minLength: 0)

            // Bottom buttons
            VStack(spacing: 6) {
                Text("tap to flip back \u{00B7} swipe \u{2192}")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(Color(hex: "#AFAFAF"))

                HStack(spacing: 10) {
                    if !isReadOnly {
                        Button3D("SHOW AGAIN",
                                color: .white,
                                pressedColor: Color(hex: "#E5E5E5"),
                                textColor: Color(hex: "#AFAFAF"),
                                action: onShowAgain)
                    }
                    Button3D("GOT IT \u{2192}", action: onGotIt)
                }
                .padding(.horizontal, 16)
            }
            .padding(.bottom, 12)
        }
        .background(Color.white)
    }

    @ViewBuilder
    private func sectionView(label: String, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.system(size: 10, weight: .semibold, design: .rounded))
                .foregroundColor(Color(hex: "#AFAFAF"))
                .tracking(0.5)
            content()
        }
        .padding(.horizontal, 16)
    }

    private func highlightedExample(_ text: String, word: String) -> AttributedString {
        let cleanText = text.replacingOccurrences(of: "**", with: "")
        var attr = AttributedString(cleanText)
        if let range = attr.range(of: word, options: .caseInsensitive) {
            attr[range].font = .system(size: 24, weight: .bold)
            attr[range].foregroundColor = Color(hex: "#FFC800")
        }
        return attr
    }
}

// Simple flow layout for collocations
struct FlowLayout: Layout {
    var spacing: CGFloat = 6

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = arrange(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrange(proposal: proposal, subviews: subviews)
        for (index, origin) in result.origins.enumerated() {
            subviews[index].place(at: CGPoint(x: bounds.minX + origin.x, y: bounds.minY + origin.y), proposal: .unspecified)
        }
    }

    private func arrange(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, origins: [CGPoint]) {
        let maxWidth = proposal.width ?? .infinity
        var origins: [CGPoint] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        var maxX: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth && x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            origins.append(CGPoint(x: x, y: y))
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
            maxX = max(maxX, x)
        }

        return (CGSize(width: maxX, height: y + rowHeight), origins)
    }
}
