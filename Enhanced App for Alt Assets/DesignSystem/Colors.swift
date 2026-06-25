//
//  Colors.swift
//  Enhanced App for Alt Assets
//
//  Created by Victoria Case on 2/4/26.
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//
//  Description: Design system color palette derived from Dutch Golden Age
//  still life paintings. Features warm, sophisticated tones that complement
//  historical artwork while maintaining excellent readability.
//

import SwiftUI

// MARK: - App Colors (Adaptive Light/Dark for Liquid Glass)
extension Color {

    // MARK: - Brand Colors

    /// Deep slate blue - primary brand color for headers and key UI elements
    static let brandPrimary = Color.adaptive(
        light: Color(hex: "2B3A4D"),
        dark: Color(hex: "8BA4C4")
    )

    /// Sage white from narcissus petals - subtle accent for interactive elements
    static let brandAccent = Color.adaptive(
        light: Color(hex: "E5E2D8"),
        dark: Color(hex: "3A3832")
    )

    /// Coral-red from flower corona - reserved for important CTAs only
    static let brandHighlight = Color.adaptive(
        light: Color(hex: "C75D5D"),
        dark: Color(hex: "E07A7A")
    )

    // MARK: - Surface Colors

    /// Warm cream / dark charcoal - primary background
    static let surfacePrimary = Color.adaptive(
        light: Color(hex: "FDFBF7"),
        dark: Color(hex: "1C1C1E")
    )

    /// Lighter parchment / elevated dark - secondary backgrounds, cards
    static let surfaceSecondary = Color.adaptive(
        light: Color(hex: "F5F3EE"),
        dark: Color(hex: "2C2C2E")
    )

    /// Aged paper / deep dark - tertiary backgrounds, dividers
    static let surfaceTertiary = Color.adaptive(
        light: Color(hex: "EDE8DD"),
        dark: Color(hex: "3A3A3C")
    )

    /// Dark surface for contrast sections
    static let surfaceDark = Color(hex: "1C1C1E")

    // MARK: - Text Colors

    /// Near black / near white - primary text
    static let textPrimary = Color.adaptive(
        light: Color(hex: "1A1A1A"),
        dark: Color(hex: "F5F5F5")
    )

    /// Dark gray / light gray - secondary text, descriptions
    static let textSecondary = Color.adaptive(
        light: Color(hex: "4A4A4A"),
        dark: Color(hex: "ABABAB")
    )

    /// Medium gray - tertiary text, captions, metadata
    static let textTertiary = Color.adaptive(
        light: Color(hex: "7A7A7A"),
        dark: Color(hex: "8E8E93")
    )

    /// Light text for dark backgrounds
    static let textOnDark = Color(hex: "FDFBF7")

    // MARK: - Semantic Colors

    /// Forest green from foliage - success states, completion
    static let success = Color.adaptive(
        light: Color(hex: "4A5D4A"),
        dark: Color(hex: "7AAF7A")
    )

    /// Muted amber - warning states
    static let warning = Color.adaptive(
        light: Color(hex: "B8860B"),
        dark: Color(hex: "E0A82E")
    )

    /// Muted rose - error states
    static let error = Color.adaptive(
        light: Color(hex: "8B4049"),
        dark: Color(hex: "CF6679")
    )

    /// Steel blue - informational states
    static let info = Color.adaptive(
        light: Color(hex: "4A6B8A"),
        dark: Color(hex: "7AAFCF")
    )

    // MARK: - Progress Colors

    /// Progress bar fill - uses brand accent
    static let progressFill = Color.adaptive(
        light: Color(hex: "4A5D4A"),
        dark: Color(hex: "7AAF7A")
    )

    /// Progress bar track - light parchment / dark track
    static let progressTrack = Color.adaptive(
        light: Color(hex: "E8E0D0"),
        dark: Color(hex: "3A3A3C")
    )

    // MARK: - Interactive States

    /// Hover/focus state overlay
    static let interactiveHover = Color.adaptive(
        light: Color(hex: "2B3A4D").opacity(0.08),
        dark: Color(hex: "FFFFFF").opacity(0.08)
    )

    /// Pressed state overlay
    static let interactivePressed = Color.adaptive(
        light: Color(hex: "2B3A4D").opacity(0.12),
        dark: Color(hex: "FFFFFF").opacity(0.12)
    )

    /// Selected state background
    static let interactiveSelected = Color.adaptive(
        light: Color(hex: "E5E2D8").opacity(0.5),
        dark: Color(hex: "3A3832").opacity(0.5)
    )

    // MARK: - Dividers and Borders

    /// Subtle divider
    static let divider = Color.adaptive(
        light: Color(hex: "E0DCD4"),
        dark: Color(hex: "3A3A3C")
    )

    /// Card border
    static let border = Color.adaptive(
        light: Color(hex: "D8D4CC"),
        dark: Color(hex: "48484A")
    )

    /// Focus ring
    static let focusRing = Color.adaptive(
        light: Color(hex: "4A6B8A"),
        dark: Color(hex: "7AAFCF")
    )
}

// MARK: - Hex Color Initializer
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Dark Mode Support
extension Color {
    /// Returns the appropriate color for the current color scheme
    static func adaptive(light: Color, dark: Color) -> Color {
        #if os(macOS)
        return Color(NSColor(name: nil) { appearance in
            appearance.bestMatch(from: [.aqua, .darkAqua]) == .darkAqua
                ? NSColor(dark)
                : NSColor(light)
        })
        #else
        return Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(dark)
                : UIColor(light)
        })
        #endif
    }
}

// MARK: - Color Palette Preview
#Preview("Color Palette") {
    ScrollView {
        VStack(alignment: .leading, spacing: 24) {
            // Brand Colors
            colorSection(title: "Brand Colors", colors: [
                ("Brand Primary", Color.brandPrimary),
                ("Brand Accent", Color.brandAccent),
                ("Brand Highlight", Color.brandHighlight)
            ])

            // Surface Colors
            colorSection(title: "Surface Colors", colors: [
                ("Surface Primary", Color.surfacePrimary),
                ("Surface Secondary", Color.surfaceSecondary),
                ("Surface Tertiary", Color.surfaceTertiary),
                ("Surface Dark", Color.surfaceDark)
            ])

            // Text Colors
            colorSection(title: "Text Colors", colors: [
                ("Text Primary", Color.textPrimary),
                ("Text Secondary", Color.textSecondary),
                ("Text Tertiary", Color.textTertiary)
            ])

            // Semantic Colors
            colorSection(title: "Semantic Colors", colors: [
                ("Success", Color.success),
                ("Warning", Color.warning),
                ("Error", Color.error),
                ("Info", Color.info)
            ])
        }
        .padding(32)
    }
    .background(Color.surfacePrimary)
}

@ViewBuilder
private func colorSection(title: String, colors: [(String, Color)]) -> some View {
    VStack(alignment: .leading, spacing: 12) {
        Text(title)
            .font(.headline)
            .foregroundColor(.textPrimary)

        LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))], spacing: 12) {
            ForEach(colors, id: \.0) { name, color in
                VStack(spacing: 8) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(color)
                        .frame(height: 60)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.border, lineWidth: 1)
                        )

                    Text(name)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
            }
        }
    }
}
