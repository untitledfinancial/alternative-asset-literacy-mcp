//
//  Typography.swift
//  Enhanced App for Alt Assets
//
//  Created by Victoria Case on 2/4/26.
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//
//  Description: Art Space typography system inspired by gallery aesthetics
//  and sophisticated editorial design. Features large serif typography with
//  alternating regular/italic styles for an elegant, minimal look.
//

import SwiftUI

// MARK: - Typography Scale (Art Space Design)
/// Typography inspired by gallery and editorial aesthetics
struct Typography {

    // Access shared settings for dynamic fonts
    private static var settings: UserSettings { UserSettings.shared }
    private static var style: FontStyle { settings.fontStyle }
    private static var scale: CGFloat { settings.textSize.scaleFactor }

    // MARK: - Art Space Display Styles (Large Serif)

    /// 42pt Light Serif - Hero titles, dramatic headers
    static var displayLarge: Font {
        Font.system(size: 42 * scale, weight: .light, design: .serif)
    }

    /// 32pt Light Serif - Module titles, major headers
    static var displayMedium: Font {
        Font.system(size: 32 * scale, weight: .light, design: .serif)
    }

    /// 26pt Regular Serif - Page titles
    static var displaySmall: Font {
        Font.system(size: 26 * scale, weight: .regular, design: .serif)
    }

    // MARK: - Art Space Title Styles (Elegant Serif)

    /// 24pt Regular Serif - Section headers
    static var title1: Font {
        Font.system(size: 24 * scale, weight: .regular, design: .serif)
    }

    /// 20pt Regular Serif - Subsection headers
    static var title2: Font {
        Font.system(size: 20 * scale, weight: .regular, design: .serif)
    }

    /// 17pt Medium Serif - Card titles
    static var title3: Font {
        Font.system(size: 17 * scale, weight: .medium, design: .serif)
    }

    // MARK: - Art Space Italic Styles (Alternating emphasis)

    /// 24pt Italic Serif - Alternating list items, emphasis
    static var titleItalic: Font {
        Font.system(size: 24 * scale, weight: .regular, design: .serif).italic()
    }

    /// 20pt Italic Serif - Smaller italic emphasis
    static var title2Italic: Font {
        Font.system(size: 20 * scale, weight: .regular, design: .serif).italic()
    }

    // MARK: - Body Styles (Clean, readable)

    /// 17pt Regular - Primary reading content
    static var bodyLarge: Font {
        bodyFont(size: 17 * scale, weight: .regular)
    }

    /// 15pt Regular - Secondary content
    static var body: Font {
        bodyFont(size: 15 * scale, weight: .regular)
    }

    /// 15pt Medium - Emphasized body text
    static var bodyMedium: Font {
        bodyFont(size: 15 * scale, weight: .medium)
    }

    // MARK: - Caption Styles (Minimal, elegant)

    /// 13pt Regular - Captions, metadata
    static var caption: Font {
        Font.system(size: 13 * scale, weight: .regular, design: .default)
    }

    /// 13pt Medium - Emphasized captions
    static var captionMedium: Font {
        Font.system(size: 13 * scale, weight: .medium, design: .default)
    }

    /// 11pt Regular - Small print, annotations
    static var caption2: Font {
        Font.system(size: 11 * scale, weight: .regular, design: .default)
    }

    // MARK: - Special Art Space Styles

    /// 11pt Medium Uppercase - Category labels, minimal overlines
    static var overline: Font {
        Font.system(size: 11 * scale, weight: .medium, design: .default)
    }

    /// 19pt Italic Serif - Pull quotes, elegant emphasis
    static var quote: Font {
        Font.system(size: 19 * scale, weight: .light, design: .serif).italic()
    }

    /// 14pt Monospace - Code, technical terms
    static var code: Font {
        Font.system(size: 14 * scale, weight: .regular, design: .monospaced)
    }

    /// 9pt Regular - Superscript annotations (P,D,V style)
    static var superscript: Font {
        Font.system(size: 9 * scale, weight: .regular, design: .default)
    }

    // MARK: - Academic/Research Styles

    /// 12pt Italic - Academic citations, source attributions
    static var citation: Font {
        Font.system(size: 12 * scale, weight: .regular, design: .serif).italic()
    }

    /// 10pt Regular - Footnote references
    static var footnote: Font {
        Font.system(size: 10 * scale, weight: .regular, design: .default)
    }

    /// 14pt Medium Serif - Research paper titles
    static var researchTitle: Font {
        Font.system(size: 14 * scale, weight: .medium, design: .serif)
    }

    /// 13pt Regular - Journal/publication names
    static var publication: Font {
        Font.system(size: 13 * scale, weight: .regular, design: .serif).italic()
    }

    // MARK: - Emoticon Typography Styles (Inline emoji with text - hellosunrise style)

    /// 28pt Light Serif Italic - Hero emoticon text
    static var emoticonHero: Font {
        Font.system(size: 28 * scale, weight: .light, design: .serif).italic()
    }

    /// 22pt Regular Serif Italic - Feature emoticon text
    static var emoticonFeature: Font {
        Font.system(size: 22 * scale, weight: .regular, design: .serif).italic()
    }

    /// 18pt Light Serif - Body emoticon text
    static var emoticonBody: Font {
        Font.system(size: 18 * scale, weight: .light, design: .serif)
    }

    // MARK: - Private Helpers

    private static func bodyFont(size: CGFloat, weight: Font.Weight) -> Font {
        if settings.useSerifForBody && style == .system {
            return Font.system(size: size, weight: weight, design: .serif)
        }
        return style.bodyFont(size: size, weight: weight)
    }
}

// MARK: - Text Style Modifiers
extension View {

    /// Apply display large style
    func displayLargeStyle() -> some View {
        self
            .font(Typography.displayLarge)
            .tracking(-0.5)
            .lineSpacing(4)
    }

    /// Apply display medium style
    func displayMediumStyle() -> some View {
        self
            .font(Typography.displayMedium)
            .tracking(-0.3)
            .lineSpacing(2)
    }

    /// Apply title 1 style
    func title1Style() -> some View {
        self
            .font(Typography.title1)
            .tracking(0)
            .lineSpacing(2)
    }

    /// Apply title 2 style
    func title2Style() -> some View {
        self
            .font(Typography.title2)
            .tracking(0)
    }

    /// Apply title 3 style
    func title3Style() -> some View {
        self
            .font(Typography.title3)
            .tracking(0)
    }

    /// Apply body large style with comfortable reading line height
    func bodyLargeStyle() -> some View {
        self
            .font(Typography.bodyLarge)
            .tracking(0.2)
            .lineSpacing(6)
    }

    /// Apply standard body style
    func bodyStyle() -> some View {
        self
            .font(Typography.body)
            .tracking(0.2)
            .lineSpacing(4)
    }

    /// Apply caption style
    func captionStyle() -> some View {
        self
            .font(Typography.caption)
            .tracking(0.3)
    }

    /// Apply overline style (uppercase category labels)
    func overlineStyle() -> some View {
        self
            .font(Typography.overline)
            .tracking(1.5)
            .textCase(.uppercase)
    }

    /// Apply quote style (italic serif)
    func quoteStyle() -> some View {
        self
            .font(Typography.quote)
            .tracking(0.2)
            .lineSpacing(6)
    }
}

// MARK: - Emoji Section Header
/// Preserves the Notion-style emoji prefix system
struct EmojiSectionHeader: View {
    let emoji: String
    let title: String
    var level: Int = 2  // H2 = 2, H3 = 3

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            Text(emoji)
                .font(.system(size: level == 2 ? 24 : 20))

            Text(title)
                .font(level == 2 ? Typography.title1 : Typography.title2)
                .foregroundColor(.textPrimary)
        }
    }
}

// MARK: - Editorial Section Number
/// Numbered section headers in editorial style
struct EditorialSectionNumber: View {
    let number: Int
    let title: String

    var body: some View {
        HStack(alignment: .bottom, spacing: 12) {
            Text(String(format: "%02d", number))
                .font(Typography.overline)
                .foregroundColor(.textTertiary)
                .tracking(1.5)

            VStack(alignment: .leading, spacing: 4) {
                Rectangle()
                    .fill(Color.brandAccent)
                    .frame(width: 40, height: 2)

                Text(title)
                    .font(Typography.title1)
                    .foregroundColor(.textPrimary)
            }
        }
    }
}

// MARK: - Emoticon Text (hellosunrise style - inline emojis in flowing text)
/// Creates beautiful editorial text with emojis woven into the sentence
struct EmoticonTextView: View {
    let text: String
    let number: String?
    var style: EmoticonStyle = .hero
    var textColor: Color = .textPrimary

    enum EmoticonStyle {
        case hero       // Large, dramatic (28pt)
        case feature    // Medium (22pt)
        case body       // Smaller (18pt)

        var font: Font {
            switch self {
            case .hero: return Typography.emoticonHero
            case .feature: return Typography.emoticonFeature
            case .body: return Typography.emoticonBody
            }
        }
    }

    init(_ text: String, number: String? = nil, style: EmoticonStyle = .hero, color: Color = .textPrimary) {
        self.text = text
        self.number = number
        self.style = style
        self.textColor = color
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let num = number {
                HStack(alignment: .firstTextBaseline, spacing: 0) {
                    Text("\(num). ")
                        .font(Typography.overline)
                        .foregroundColor(textColor.opacity(0.6))
                        .tracking(1)
                    Text(text)
                        .font(style.font)
                        .foregroundColor(textColor)
                }
            } else {
                Text(text)
                    .font(style.font)
                    .foregroundColor(textColor)
            }
        }
        .lineSpacing(8)
    }
}

// MARK: - Feature Card with Emoticon Text (hellosunrise style)
struct EmoticonFeatureCard: View {
    let number: String
    let text: String
    let backgroundColor: Color
    let textColor: Color

    init(number: String, text: String, backgroundColor: Color = .brandPrimary, textColor: Color = .white) {
        self.number = number
        self.text = text
        self.backgroundColor = backgroundColor
        self.textColor = textColor
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.lg) {
            EmoticonTextView(text, number: number, style: .hero, color: textColor)
        }
        .padding(Spacing.xl)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.xl))
    }
}

// MARK: - Inline Stat with Emoticon
struct EmoticonStat: View {
    let emoji: String
    let value: String
    let label: String

    var body: some View {
        HStack(spacing: Spacing.sm) {
            Text(emoji)
                .font(.system(size: 24))

            VStack(alignment: .leading, spacing: 0) {
                Text(value)
                    .font(Typography.title3)
                    .foregroundColor(.textPrimary)
                Text(label)
                    .font(Typography.caption)
                    .foregroundColor(.textSecondary)
            }
        }
    }
}

// MARK: - Typography Preview
#Preview("Typography Scale") {
    ScrollView {
        VStack(alignment: .leading, spacing: 32) {
            // Display styles
            Group {
                Text("Display Styles")
                    .overlineStyle()
                    .foregroundColor(.textTertiary)

                Text("Display Large")
                    .displayLargeStyle()
                    .foregroundColor(.textPrimary)

                Text("Display Medium")
                    .displayMediumStyle()
                    .foregroundColor(.textPrimary)
            }

            Divider()

            // Title styles
            Group {
                Text("Title Styles")
                    .overlineStyle()
                    .foregroundColor(.textTertiary)

                Text("Title 1 - Section Headers")
                    .title1Style()
                    .foregroundColor(.textPrimary)

                Text("Title 2 - Subsections")
                    .title2Style()
                    .foregroundColor(.textPrimary)

                Text("Title 3 - Card Titles")
                    .title3Style()
                    .foregroundColor(.textPrimary)
            }

            Divider()

            // Body styles
            Group {
                Text("Body Styles")
                    .overlineStyle()
                    .foregroundColor(.textTertiary)

                Text("Body Large - This is the primary reading style with comfortable line height for long-form content. It should feel easy on the eyes during extended reading sessions.")
                    .bodyLargeStyle()
                    .foregroundColor(.textPrimary)

                Text("Body - Secondary content and shorter descriptions use this slightly smaller size.")
                    .bodyStyle()
                    .foregroundColor(.textSecondary)

                Text("Caption - Metadata, timestamps, and supplementary information")
                    .captionStyle()
                    .foregroundColor(.textTertiary)
            }

            Divider()

            // Special styles
            Group {
                Text("Special Styles")
                    .overlineStyle()
                    .foregroundColor(.textTertiary)

                Text("\"The best investment you can make is in yourself.\"")
                    .quoteStyle()
                    .foregroundColor(.textSecondary)

                EmojiSectionHeader(emoji: "🌍", title: "Alternative Assets", level: 2)

                EditorialSectionNumber(number: 1, title: "Features")
            }
        }
        .padding(32)
    }
    .background(Color.surfacePrimary)
}

// MARK: - Rich Text View (Dynamic Typography)
/// Parses text with markdown-like formatting for dynamic styling
/// Supports: **bold**, *italic*, _underline_, `code`, and footnote references like (1)
struct RichTextView: View {
    let text: String
    let baseFont: Font
    let textColor: Color
    let moduleId: String?

    init(_ text: String, font: Font = Typography.body, color: Color = .textPrimary, moduleId: String? = nil) {
        self.text = text
        self.baseFont = font
        self.textColor = color
        self.moduleId = moduleId
    }

    var body: some View {
        DynamicTextView(text, color: textColor)
            .font(baseFont)
    }
}

// MARK: - Dynamic Text Parser
/// Parses and renders text with inline formatting using AttributedString
/// Supports: **bold**, *italic*, `code`
struct DynamicTextView: View {
    let text: String
    let baseColor: Color

    init(_ text: String, color: Color = .textPrimary) {
        self.text = text
        self.baseColor = color
    }

    var body: some View {
        Text(parseToAttributedString())
            .foregroundColor(baseColor)
    }

    private func parseToAttributedString() -> AttributedString {
        var result = AttributedString()
        var currentText = ""
        var index = text.startIndex

        while index < text.endIndex {
            let remaining = String(text[index...])

            // Check for **bold**
            if remaining.hasPrefix("**") {
                if !currentText.isEmpty {
                    result.append(AttributedString(currentText))
                    currentText = ""
                }
                let afterMarker = remaining.dropFirst(2)
                if let endRange = afterMarker.range(of: "**") {
                    let boldText = String(afterMarker[..<endRange.lowerBound])
                    var boldAttr = AttributedString(boldText)
                    boldAttr.font = Typography.bodyMedium
                    result.append(boldAttr)
                    index = text.index(index, offsetBy: boldText.count + 4)
                    continue
                }
            }

            // Check for *italic* (but not **)
            if remaining.hasPrefix("*") && !remaining.hasPrefix("**") {
                if !currentText.isEmpty {
                    result.append(AttributedString(currentText))
                    currentText = ""
                }
                let afterAsterisk = remaining.dropFirst()
                if let endRange = afterAsterisk.range(of: "*") {
                    let italicText = String(afterAsterisk[..<endRange.lowerBound])
                    if !italicText.isEmpty && !italicText.hasPrefix("*") {
                        var italicAttr = AttributedString(italicText)
                        italicAttr.font = Typography.body.italic()
                        result.append(italicAttr)
                        index = text.index(index, offsetBy: italicText.count + 2)
                        continue
                    }
                }
            }

            // Check for inline footnote references like [1], [2], [12]
            if remaining.hasPrefix("[") {
                // Try to match [digits]
                let afterBracket = remaining.dropFirst()
                if let closeBracket = afterBracket.firstIndex(of: "]") {
                    let inside = String(afterBracket[..<closeBracket])
                    if !inside.isEmpty && inside.allSatisfy({ $0.isNumber }) {
                        // It's a footnote reference like [2]
                        if !currentText.isEmpty {
                            result.append(AttributedString(currentText))
                            currentText = ""
                        }
                        // Convert to Unicode superscript digits
                        let superscriptDigits: [Character: Character] = [
                            "0": "⁰", "1": "¹", "2": "²", "3": "³", "4": "⁴",
                            "5": "⁵", "6": "⁶", "7": "⁷", "8": "⁸", "9": "⁹"
                        ]
                        let superNum = String(inside.map { superscriptDigits[$0] ?? $0 })
                        var footnoteAttr = AttributedString(superNum)
                        footnoteAttr.font = .system(size: 8, weight: .bold)
                        footnoteAttr.foregroundColor = Color.brandPrimary
                        footnoteAttr.baselineOffset = 8
                        result.append(footnoteAttr)
                        let totalLength = inside.count + 2 // [digits]
                        index = text.index(index, offsetBy: totalLength)
                        continue
                    }
                }
            }

            // Check for parenthetical footnote references like (2), (26), (32-34)
            if remaining.hasPrefix("(") {
                let afterParen = remaining.dropFirst()
                if let closeParen = afterParen.firstIndex(of: ")") {
                    let inside = String(afterParen[..<closeParen])
                    // Match citation numbers only: (2), (26), (32-34) — NOT year ranges like (2013-2020) or (2015)
                    // Rule: all parts of a range must be ≤ 3 digits (max citation number ~999)
                    let isFootnoteRef: Bool = {
                        guard !inside.isEmpty, inside.first?.isNumber == true else { return false }
                        guard inside.allSatisfy({ $0.isNumber || $0 == "." || $0 == "-" || $0 == "," || $0 == " " }) else { return false }
                        // Reject if any numeric segment is 4+ digits (year)
                        let segments = inside.components(separatedBy: CharacterSet(charactersIn: "-,. "))
                        return segments.allSatisfy { seg in
                            let digits = seg.filter { $0.isNumber }
                            return digits.isEmpty || digits.count <= 3
                        }
                    }()
                    if isFootnoteRef {
                        if !currentText.isEmpty {
                            result.append(AttributedString(currentText))
                            currentText = ""
                        }
                        let superscriptDigits: [Character: Character] = [
                            "0": "\u{2070}", "1": "\u{00B9}", "2": "\u{00B2}", "3": "\u{00B3}", "4": "\u{2074}",
                            "5": "\u{2075}", "6": "\u{2076}", "7": "\u{2077}", "8": "\u{2078}", "9": "\u{2079}"
                        ]
                        // Convert digits to superscript, keep separators as-is at small size
                        let superNum = String(inside.map { superscriptDigits[$0] ?? $0 })
                        var footnoteAttr = AttributedString("(" + superNum + ")")
                        footnoteAttr.font = .system(size: 9, weight: .medium)
                        footnoteAttr.foregroundColor = Color.textTertiary
                        footnoteAttr.baselineOffset = 6
                        result.append(footnoteAttr)
                        let totalLength = inside.count + 2 // (digits)
                        index = text.index(index, offsetBy: totalLength)
                        continue
                    }
                }
            }

            // Check for `code`
            if remaining.hasPrefix("`") {
                if !currentText.isEmpty {
                    result.append(AttributedString(currentText))
                    currentText = ""
                }
                let afterBacktick = remaining.dropFirst()
                if let endRange = afterBacktick.range(of: "`") {
                    let codeText = String(afterBacktick[..<endRange.lowerBound])
                    var codeAttr = AttributedString(codeText)
                    codeAttr.font = Typography.code
                    codeAttr.backgroundColor = Color.surfaceTertiary
                    result.append(codeAttr)
                    index = text.index(index, offsetBy: codeText.count + 2)
                    continue
                }
            }

            currentText.append(text[index])
            index = text.index(after: index)
        }

        if !currentText.isEmpty {
            result.append(AttributedString(currentText))
        }

        return result
    }
}

// MARK: - Styled Text Components
/// Pre-styled text for common content patterns

/// Italic emphasis text
struct ItalicText: View {
    let text: String

    var body: some View {
        Text(text)
            .font(Typography.body.italic())
            .foregroundColor(.textPrimary)
    }
}

/// Bold emphasis text
struct BoldText: View {
    let text: String

    var body: some View {
        Text(text)
            .font(Typography.bodyMedium)
            .foregroundColor(.textPrimary)
    }
}

/// Highlighted/key term text
struct KeyTermText: View {
    let text: String

    var body: some View {
        Text(text)
            .font(Typography.bodyMedium)
            .foregroundColor(.brandPrimary)
    }
}

/// Citation-style text
struct CitationText: View {
    let text: String
    let source: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(text)
                .font(Typography.body.italic())
                .foregroundColor(.textSecondary)

            if let source = source {
                Text("— \(source)")
                    .font(Typography.caption)
                    .foregroundColor(.textTertiary)
            }
        }
    }
}
