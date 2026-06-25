//
//  Spacing.swift
//  Enhanced App for Alt Assets
//
//  Created by Victoria Case on 2/4/26.
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//
//  Description: 8-point grid spacing system for consistent layout throughout
//  the app. Provides semantic spacing values that create visual rhythm and
//  hierarchy.
//

import SwiftUI

// MARK: - Spacing Scale
enum Spacing {

    /// 4pt - Tight internal spacing (icon gaps, tight element groups)
    static let xxs: CGFloat = 4

    /// 8pt - Compact spacing (between related elements)
    static let xs: CGFloat = 8

    /// 12pt - Small padding (component internal spacing)
    static let sm: CGFloat = 12

    /// 16pt - Standard padding (cards, list items)
    static let md: CGFloat = 16

    /// 24pt - Section spacing (between content groups)
    static let lg: CGFloat = 24

    /// 32pt - Major section breaks
    static let xl: CGFloat = 32

    /// 48pt - Hero spacing, page margins
    static let xxl: CGFloat = 48

    /// 64pt - Full-bleed margins, dramatic spacing
    static let xxxl: CGFloat = 64
}

// MARK: - Corner Radius
enum CornerRadius {

    /// 4pt - Subtle rounding (buttons, badges)
    static let xs: CGFloat = 4

    /// 8pt - Standard rounding (cards, inputs)
    static let sm: CGFloat = 8

    /// 12pt - Medium rounding (modal corners)
    static let md: CGFloat = 12

    /// 16pt - Large rounding (sheets, hero cards)
    static let lg: CGFloat = 16

    /// 24pt - Extra large (floating cards)
    static let xl: CGFloat = 24

    /// Fully rounded (pills, circular elements)
    static let full: CGFloat = 9999
}

// MARK: - Responsive Spacing
/// Platform-aware spacing that adapts to device size
struct ResponsiveSpacing {

    /// Page edge padding - larger on iPad/Mac
    static var pageEdge: CGFloat {
        #if os(macOS)
        return Spacing.xl
        #else
        return UIDevice.current.userInterfaceIdiom == .pad ? Spacing.xl : Spacing.md
        #endif
    }

    /// Content max width - constrain reading width on large screens
    static var contentMaxWidth: CGFloat {
        #if os(macOS)
        return 720
        #else
        return UIDevice.current.userInterfaceIdiom == .pad ? 680 : .infinity
        #endif
    }

    /// Hero section height
    static var heroHeight: CGFloat {
        #if os(macOS)
        return 450
        #else
        return UIDevice.current.userInterfaceIdiom == .pad ? 400 : 300
        #endif
    }

    /// Sidebar width (iPad/Mac only)
    static var sidebarWidth: CGFloat {
        #if os(macOS)
        return 280
        #else
        return 320
        #endif
    }
}

// MARK: - Spacing View Modifiers
extension View {

    /// Apply standard card padding
    func cardPadding() -> some View {
        self.padding(Spacing.md)
    }

    /// Apply section padding (vertical rhythm)
    func sectionPadding() -> some View {
        self.padding(.vertical, Spacing.lg)
    }

    /// Apply page edge padding (responsive)
    func pageEdgePadding() -> some View {
        self.padding(.horizontal, ResponsiveSpacing.pageEdge)
    }

    /// Constrain content width for readability
    func readableWidth() -> some View {
        self.frame(maxWidth: ResponsiveSpacing.contentMaxWidth)
    }

    /// Apply standard corner radius
    func standardCornerRadius() -> some View {
        self.clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
    }
}

// MARK: - Spacing Preview
#Preview("Spacing Scale") {
    ScrollView {
        VStack(alignment: .leading, spacing: Spacing.lg) {
            Text("Spacing Scale")
                .font(Typography.title1)
                .foregroundColor(.textPrimary)

            VStack(alignment: .leading, spacing: Spacing.sm) {
                spacingRow("xxs", Spacing.xxs)
                spacingRow("xs", Spacing.xs)
                spacingRow("sm", Spacing.sm)
                spacingRow("md", Spacing.md)
                spacingRow("lg", Spacing.lg)
                spacingRow("xl", Spacing.xl)
                spacingRow("xxl", Spacing.xxl)
                spacingRow("xxxl", Spacing.xxxl)
            }

            Divider()
                .padding(.vertical, Spacing.md)

            Text("Corner Radius")
                .font(Typography.title1)
                .foregroundColor(.textPrimary)

            HStack(spacing: Spacing.md) {
                radiusBox("xs", CornerRadius.xs)
                radiusBox("sm", CornerRadius.sm)
                radiusBox("md", CornerRadius.md)
                radiusBox("lg", CornerRadius.lg)
                radiusBox("xl", CornerRadius.xl)
            }
        }
        .padding(Spacing.xl)
    }
    .background(Color.surfacePrimary)
}

@ViewBuilder
private func spacingRow(_ name: String, _ value: CGFloat) -> some View {
    HStack(spacing: Spacing.md) {
        Text(name)
            .font(Typography.captionMedium)
            .foregroundColor(.textSecondary)
            .frame(width: 40, alignment: .leading)

        Rectangle()
            .fill(Color.brandPrimary)
            .frame(width: value, height: 24)

        Text("\(Int(value))pt")
            .font(Typography.caption)
            .foregroundColor(.textTertiary)
    }
}

@ViewBuilder
private func radiusBox(_ name: String, _ radius: CGFloat) -> some View {
    VStack(spacing: Spacing.xs) {
        RoundedRectangle(cornerRadius: radius)
            .fill(Color.brandPrimary)
            .frame(width: 50, height: 50)

        Text(name)
            .font(Typography.caption)
            .foregroundColor(.textSecondary)
    }
}
