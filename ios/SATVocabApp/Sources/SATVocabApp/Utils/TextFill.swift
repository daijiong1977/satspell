import Foundation

enum TextFill {
    static func fillBlankPlaceholders(_ text: String, with word: String) -> String {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return text }
        guard !word.isEmpty else { return text }

        // Common patterns in our SAT contexts:
        // - "_______ blank" / "______ blank"
        // - "_______" (underscores-only)
        var out = trimmed

        if let r1 = try? NSRegularExpression(pattern: "_{2,}\\s*blank", options: [.caseInsensitive]) {
            let range = NSRange(out.startIndex..<out.endIndex, in: out)
            out = r1.stringByReplacingMatches(in: out, options: [], range: range, withTemplate: word)
        }

        if let r2 = try? NSRegularExpression(pattern: "_{2,}", options: []) {
            let range = NSRange(out.startIndex..<out.endIndex, in: out)
            out = r2.stringByReplacingMatches(in: out, options: [], range: range, withTemplate: word)
        }

        return out
    }
}
