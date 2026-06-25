//
//  Theme.swift
//  Enhanced App for Alt Assets
//
//  Created by Victoria Case on 2/4/26.
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//
//  Description: Central theme configuration that ties together colors,
//  typography, spacing, and animations. Provides a unified interface for
//  applying the design system throughout the app.
//

import SwiftUI

// MARK: - Accessibility: Reduce Motion Support
/// Checks the system Reduce Motion setting. Views that use animations
/// should gate on this to respect the user's accessibility preference.
struct AccessibilityManager {
    /// Returns true when the user has enabled Reduce Motion in iOS Settings
    static var prefersReducedMotion: Bool {
        #if os(iOS)
        return UIAccessibility.isReduceMotionEnabled
        #else
        return false
        #endif
    }
}

// MARK: - Theme Configuration
struct Theme {

    // MARK: - Animation Durations
    struct Animation {
        /// Quick feedback (button press, toggle)
        static let quick: Double = 0.15

        /// Standard transitions
        static let standard: Double = 0.3

        /// Calm, Headspace-inspired transitions
        static let calm: Double = 0.4

        /// Slow reveal (hero images, celebrations)
        static let slow: Double = 0.6

        /// Spring response for bouncy animations
        static let springResponse: Double = 0.4

        /// Spring damping for natural feel
        static let springDamping: Double = 0.75
    }

    // MARK: - Shadows
    struct Shadow {
        /// Subtle elevation (cards)
        static let sm = ShadowStyle(
            color: Color.black.opacity(0.05),
            radius: 4,
            x: 0,
            y: 2
        )

        /// Medium elevation (floating elements)
        static let md = ShadowStyle(
            color: Color.black.opacity(0.08),
            radius: 10,
            x: 0,
            y: 4
        )

        /// Large elevation (modals, hero cards)
        static let lg = ShadowStyle(
            color: Color.black.opacity(0.12),
            radius: 20,
            x: 0,
            y: 8
        )
    }

    // MARK: - Blur
    struct Blur {
        /// Light blur for overlays
        static let light: CGFloat = 10

        /// Medium blur for modals
        static let medium: CGFloat = 20

        /// Heavy blur for backgrounds
        static let heavy: CGFloat = 40
    }
}

// MARK: - Shadow Style
struct ShadowStyle {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

// MARK: - Shadow View Modifier
extension View {
    func shadow(_ style: ShadowStyle) -> some View {
        self.shadow(
            color: style.color,
            radius: style.radius,
            x: style.x,
            y: style.y
        )
    }
}

// MARK: - Custom Animations (Reduce Motion aware)
extension SwiftUI.Animation {

    /// Smooth spring animation for natural movement.
    /// Falls back to a quick linear fade when Reduce Motion is on.
    static var smoothSpring: SwiftUI.Animation {
        if AccessibilityManager.prefersReducedMotion {
            return .linear(duration: 0.15)
        }
        return .spring(
            response: Theme.Animation.springResponse,
            dampingFraction: Theme.Animation.springDamping
        )
    }

    /// Quick bounce for interactive feedback.
    /// Disabled (instant) when Reduce Motion is on.
    static var quickBounce: SwiftUI.Animation {
        if AccessibilityManager.prefersReducedMotion {
            return .linear(duration: 0.1)
        }
        return .spring(response: 0.3, dampingFraction: 0.6)
    }

    /// Calm fade for Headspace-style transitions.
    /// Shortened when Reduce Motion is on.
    static var calmFade: SwiftUI.Animation {
        if AccessibilityManager.prefersReducedMotion {
            return .linear(duration: 0.15)
        }
        return .easeInOut(duration: Theme.Animation.calm)
    }

    /// Gentle entrance animation.
    /// Becomes a simple quick fade when Reduce Motion is on.
    static var gentleEntrance: SwiftUI.Animation {
        if AccessibilityManager.prefersReducedMotion {
            return .linear(duration: 0.15)
        }
        return .easeOut(duration: Theme.Animation.slow)
    }
}

// MARK: - Custom Transitions (Reduce Motion aware)
extension AnyTransition {

    /// Calm fade with subtle scale - Headspace inspired.
    /// Opacity-only when Reduce Motion is on.
    static var calmFade: AnyTransition {
        if AccessibilityManager.prefersReducedMotion {
            return .opacity
        }
        return .opacity
            .combined(with: .scale(scale: 0.98))
    }

    /// Slide up with fade.
    /// Opacity-only when Reduce Motion is on (no sliding).
    static var slideUp: AnyTransition {
        if AccessibilityManager.prefersReducedMotion {
            return .opacity
        }
        return .asymmetric(
            insertion: .move(edge: .bottom).combined(with: .opacity),
            removal: .move(edge: .top).combined(with: .opacity)
        )
    }

    /// Expand from center.
    /// Opacity-only when Reduce Motion is on (no scaling).
    static var expandFromCenter: AnyTransition {
        if AccessibilityManager.prefersReducedMotion {
            return .opacity
        }
        return .scale(scale: 0.9)
            .combined(with: .opacity)
    }

    /// Card entrance (slide up with spring).
    /// Opacity-only when Reduce Motion is on.
    static var cardEntrance: AnyTransition {
        if AccessibilityManager.prefersReducedMotion {
            return .opacity
        }
        return .asymmetric(
            insertion: .move(edge: .bottom).combined(with: .opacity),
            removal: .opacity
        )
    }
}

// MARK: - Pressable Button Style
/// Button style with subtle press feedback.
/// Skips scale effect when Reduce Motion is on, keeps opacity change.
struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(
                AccessibilityManager.prefersReducedMotion
                    ? 1.0
                    : (configuration.isPressed ? 0.97 : 1.0)
            )
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.quickBounce, value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == PressableButtonStyle {
    static var pressable: PressableButtonStyle {
        PressableButtonStyle()
    }
}

// MARK: - Card Style Modifier
struct CardStyle: ViewModifier {
    var padding: CGFloat = Spacing.md
    var cornerRadius: CGFloat = CornerRadius.md
    var shadow: ShadowStyle = Theme.Shadow.sm

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(Color.surfacePrimary)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .shadow(shadow)
    }
}

extension View {
    func cardStyle(
        padding: CGFloat = Spacing.md,
        cornerRadius: CGFloat = CornerRadius.md,
        shadow: ShadowStyle = Theme.Shadow.sm
    ) -> some View {
        modifier(CardStyle(padding: padding, cornerRadius: cornerRadius, shadow: shadow))
    }
}

// MARK: - Glass Card Style (iOS 26 Liquid Glass)
/// Card style using Liquid Glass material instead of solid background.
/// Best for floating navigation-layer elements, not content cards.
struct GlassCardStyle: ViewModifier {
    var padding: CGFloat = Spacing.md
    var cornerRadius: CGFloat = CornerRadius.md

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: cornerRadius))
    }
}

extension View {
    /// Apply Liquid Glass card style (iOS 26)
    func glassCardStyle(
        padding: CGFloat = Spacing.md,
        cornerRadius: CGFloat = CornerRadius.md
    ) -> some View {
        modifier(GlassCardStyle(padding: padding, cornerRadius: cornerRadius))
    }
}

// MARK: - Shimmer Loading Effect
/// Animated shimmer for loading states. Disabled when Reduce Motion is on —
/// shows a static subtle overlay instead of the moving gradient.
struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = -200

    func body(content: Content) -> some View {
        if AccessibilityManager.prefersReducedMotion {
            // Static subtle overlay instead of animation
            content
                .overlay(
                    Color.surfaceSecondary.opacity(0.3)
                        .mask(content)
                )
        } else {
            content
                .overlay(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0),
                            Color.white.opacity(0.3),
                            Color.white.opacity(0)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .offset(x: phase)
                    .mask(content)
                )
                .onAppear {
                    withAnimation(
                        .linear(duration: 1.5)
                        .repeatForever(autoreverses: false)
                    ) {
                        phase = 400
                    }
                }
        }
    }
}

extension View {
    /// Apply shimmer loading effect (respects Reduce Motion)
    func shimmer() -> some View {
        modifier(ShimmerModifier())
    }
}

// MARK: - Glass Effect Helpers (iOS 26)
extension View {
    /// Apply interactive glass effect for navigation-layer floating controls
    func interactiveGlass(in shape: some Shape = Capsule()) -> some View {
        self.glassEffect(.regular.interactive(), in: shape)
    }

    /// Apply tinted glass effect for primary actions
    func primaryGlass(in shape: some Shape = Capsule()) -> some View {
        self.glassEffect(.regular.tint(.brandPrimary).interactive(), in: shape)
    }
}

// MARK: - Haptic Feedback
enum HapticFeedback {
    case light
    case medium
    case success
    case error
    case selection

    func trigger() {
        #if os(iOS)
        switch self {
        case .light:
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        case .medium:
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        case .success:
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        case .error:
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        case .selection:
            UISelectionFeedbackGenerator().selectionChanged()
        }
        #endif
    }
}

// MARK: - Platform Detection
enum Platform {
    case iPhone
    case iPad
    case mac

    static var current: Platform {
        #if os(macOS)
        return .mac
        #else
        if UIDevice.current.userInterfaceIdiom == .pad {
            return .iPad
        }
        return .iPhone
        #endif
    }

    var isCompact: Bool {
        self == .iPhone
    }

    var supportsHover: Bool {
        self == .mac
    }
}

// MARK: - Theme Preview
#Preview("Theme Components") {
    ScrollView {
        VStack(alignment: .leading, spacing: Spacing.xl) {
            // Shadows
            Text("Shadows")
                .font(Typography.title2)
                .foregroundColor(.textPrimary)

            HStack(spacing: Spacing.lg) {
                shadowPreview("sm", Theme.Shadow.sm)
                shadowPreview("md", Theme.Shadow.md)
                shadowPreview("lg", Theme.Shadow.lg)
            }

            Divider()

            // Buttons
            Text("Button Styles")
                .font(Typography.title2)
                .foregroundColor(.textPrimary)

            Button("Pressable Button") {}
                .buttonStyle(.pressable)
                .padding(.horizontal, Spacing.lg)
                .padding(.vertical, Spacing.sm)
                .background(Color.brandPrimary)
                .foregroundColor(.textOnDark)
                .clipShape(RoundedRectangle(cornerRadius: CornerRadius.sm))

            Divider()

            // Card
            Text("Card Style")
                .font(Typography.title2)
                .foregroundColor(.textPrimary)

            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text("Card Title")
                    .font(Typography.title3)
                Text("This is a card with the standard card style applied.")
                    .font(Typography.body)
                    .foregroundColor(.textSecondary)
            }
            .cardStyle()

            Divider()

            // Loading shimmer
            Text("Loading Shimmer")
                .font(Typography.title2)
                .foregroundColor(.textPrimary)

            RoundedRectangle(cornerRadius: CornerRadius.md)
                .fill(Color.surfaceSecondary)
                .frame(height: 100)
                .shimmer()
        }
        .padding(Spacing.xl)
    }
    .background(Color.surfacePrimary)
}

@ViewBuilder
private func shadowPreview(_ name: String, _ shadow: ShadowStyle) -> some View {
    VStack(spacing: Spacing.sm) {
        RoundedRectangle(cornerRadius: CornerRadius.md)
            .fill(Color.surfacePrimary)
            .frame(width: 80, height: 80)
            .shadow(shadow)

        Text(name)
            .font(Typography.caption)
            .foregroundColor(.textSecondary)
    }
}
