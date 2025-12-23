import SwiftUI

enum TextHighlight {
    static func highlighted(_ text: String, term: String) -> Text {
        guard !text.isEmpty else { return Text("") }
        guard !term.isEmpty else { return Text(text) }

        let nsText = text as NSString
        let pattern = "\\b" + NSRegularExpression.escapedPattern(for: term) + "\\b"
        let regex = (try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]))
        let matches = regex?.matches(in: text, range: NSRange(location: 0, length: nsText.length)) ?? []

        guard !matches.isEmpty else { return Text(text) }

        var out = Text("")
        var cursor = 0
        for m in matches {
            if m.range.location > cursor {
                out = out + Text(nsText.substring(with: NSRange(location: cursor, length: m.range.location - cursor)))
            }

            let matched = nsText.substring(with: m.range)
            out = out + Text(matched).fontWeight(.bold)

            cursor = m.range.location + m.range.length
        }

        if cursor < nsText.length {
            out = out + Text(nsText.substring(from: cursor))
        }

        return out
    }
}
