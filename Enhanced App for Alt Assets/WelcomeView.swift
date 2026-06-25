//
//  WelcomeView.swift
//  Enhanced App for Alt Assets
//
//  Created by Victoria Case on 2/7/26.
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//
//  Description: Welcome/onboarding screen that explains the app's annotation
//  system, superscript conventions, and navigation features. Shown on first launch
//  and accessible from settings.
//

import SwiftUI

// MARK: - Welcome View
struct OnboardingWelcomeView: View {
    @Binding var isPresented: Bool
    @State private var currentPage = 0

    var body: some View {
        VStack(spacing: 0) {
            // Page indicator
            HStack(spacing: 8) {
                ForEach(0..<4, id: \.self) { index in
                    Circle()
                        .fill(currentPage == index ? Color.brandPrimary : Color.divider)
                        .frame(width: 8, height: 8)
                        .animation(.smoothSpring, value: currentPage)
                }
            }
            .padding(.top, Spacing.lg)

            // Page content
            TabView(selection: $currentPage) {
                WelcomePage().tag(0)
                AnnotationKeyPage().tag(1)
                NavigationGuidePage().tag(2)
                GetStartedPage(isPresented: $isPresented).tag(3)
            }
            #if os(iOS)
            .tabViewStyle(.page(indexDisplayMode: .never))
            #endif

            // Navigation buttons
            HStack {
                if currentPage > 0 {
                    Button {
                        withAnimation { currentPage -= 1 }
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .font(Typography.bodyMedium)
                        .foregroundColor(.textSecondary)
                    }
                }

                Spacer()

                if currentPage < 3 {
                    Button {
                        withAnimation { currentPage += 1 }
                    } label: {
                        HStack(spacing: 4) {
                            Text("Next")
                            Image(systemName: "chevron.right")
                        }
                        .font(Typography.bodyMedium)
                        .foregroundColor(.brandPrimary)
                    }
                }
            }
            .padding(.horizontal, Spacing.xl)
            .padding(.bottom, Spacing.xl)
        }
        .background(Color.surfacePrimary)
    }
}

// MARK: - Welcome Page
struct WelcomePage: View {
    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.xl) {
                Spacer()
                    .frame(height: Spacing.xl)

                // App icon/logo area
                VStack(spacing: Spacing.md) {
                    Text("📊")
                        .font(.system(size: 64))

                    Text("Alternative Asset Education")
                        .font(Typography.displayMedium)
                        .foregroundColor(.textPrimary)
                        .multilineTextAlignment(.center)

                    Text("Research-based learning for modern investors")
                        .font(Typography.body)
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                }

                Spacer()

                // Key features
                VStack(alignment: .leading, spacing: Spacing.md) {
                    FeatureHighlight(
                        icon: "checkmark.seal.fill",
                        title: "Research-Based Content",
                        description: "Every module is backed by academic research and industry sources"
                    )

                    FeatureHighlight(
                        icon: "brain.head.profile",
                        title: "Behavioral Insights",
                        description: "Understand the psychology behind investment decisions"
                    )

                    FeatureHighlight(
                        icon: "arrow.clockwise.circle.fill",
                        title: "Spaced Repetition",
                        description: "Retain knowledge with scientifically-proven review intervals"
                    )
                }
                .padding(.horizontal, Spacing.lg)

                Spacer()
            }
            .padding(Spacing.lg)
        }
    }
}

// MARK: - Annotation Key Page
struct AnnotationKeyPage: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                // Header
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Text("Understanding Annotations")
                        .font(Typography.displaySmall)
                        .foregroundColor(.textPrimary)

                    Text("Throughout the app, you'll see superscript annotations that indicate the type and depth of content.")
                        .font(Typography.body)
                        .foregroundColor(.textSecondary)
                }
                .padding(.top, Spacing.xl)

                // Module Type Annotations
                VStack(alignment: .leading, spacing: Spacing.md) {
                    Text("MODULE TYPES")
                        .font(Typography.overline)
                        .foregroundColor(.textTertiary)

                    AnnotationExplanationRow(
                        annotation: "(E)",
                        title: "Empirical Research",
                        description: "Content based on peer-reviewed studies, surveys, and quantitative data",
                        color: .brandPrimary
                    )

                    AnnotationExplanationRow(
                        annotation: "(C)",
                        title: "Case Studies",
                        description: "In-depth analysis of specific examples, artists, or market events",
                        color: .info
                    )

                    AnnotationExplanationRow(
                        annotation: "(R)",
                        title: "Research-Based",
                        description: "General research-backed educational content",
                        color: .success
                    )

                    AnnotationExplanationRow(
                        annotation: "(T)",
                        title: "Technical Analysis",
                        description: "Technical or quantitative methodology-focused content",
                        color: .purple
                    )
                }
                .padding(Spacing.md)
                .background(Color.surfaceSecondary)
                .clipShape(RoundedRectangle(cornerRadius: CornerRadius.lg))

                // Content Annotations
                VStack(alignment: .leading, spacing: Spacing.md) {
                    Text("CONTENT INDICATORS")
                        .font(Typography.overline)
                        .foregroundColor(.textTertiary)

                    AnnotationExplanationRow(
                        annotation: "³Q",
                        title: "Quiz Count",
                        description: "Number of knowledge-check quizzes in the module",
                        color: .success
                    )

                    AnnotationExplanationRow(
                        annotation: "²R",
                        title: "Reflection Prompts",
                        description: "Number of reflection prompts for deeper learning",
                        color: .brandHighlight
                    )

                    AnnotationExplanationRow(
                        annotation: "⁴C",
                        title: "Case Studies",
                        description: "Number of real-world case studies included",
                        color: .info
                    )

                    AnnotationExplanationRow(
                        annotation: "¹⁵",
                        title: "Footnote References",
                        description: "Numbered citations linking to sources and bibliography",
                        color: .textSecondary
                    )
                }
                .padding(Spacing.md)
                .background(Color.surfaceSecondary)
                .clipShape(RoundedRectangle(cornerRadius: CornerRadius.lg))

                Spacer()
                    .frame(height: Spacing.xl)
            }
            .padding(.horizontal, Spacing.lg)
        }
    }
}

// MARK: - Navigation Guide Page
struct NavigationGuidePage: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                // Header
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Text("Navigating Your Learning")
                        .font(Typography.displaySmall)
                        .foregroundColor(.textPrimary)

                    Text("Each module is organized with tabs for easy access to different types of content.")
                        .font(Typography.body)
                        .foregroundColor(.textSecondary)
                }
                .padding(.top, Spacing.xl)

                // Tab explanations
                VStack(alignment: .leading, spacing: Spacing.md) {
                    Text("MODULE TABS")
                        .font(Typography.overline)
                        .foregroundColor(.textTertiary)

                    TabExplanationRow(
                        tab: "Content",
                        icon: "doc.text.fill",
                        description: "Main educational content with expandable sections, callouts, and research findings"
                    )

                    TabExplanationRow(
                        tab: "Quizzes",
                        icon: "checkmark.circle.fill",
                        description: "Test your knowledge with multiple-choice questions and detailed explanations"
                    )

                    TabExplanationRow(
                        tab: "Reflection",
                        icon: "sparkles",
                        description: "Thoughtful prompts to deepen understanding and connect concepts to your life"
                    )

                    TabExplanationRow(
                        tab: "Cases",
                        icon: "doc.text.magnifyingglass",
                        description: "Real-world case studies that apply concepts to actual investment scenarios"
                    )
                }
                .padding(Spacing.md)
                .background(Color.surfaceSecondary)
                .clipShape(RoundedRectangle(cornerRadius: CornerRadius.lg))

                // Footnotes explanation
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Text("SOURCES & FOOTNOTES")
                        .font(Typography.overline)
                        .foregroundColor(.textTertiary)

                    Text("Throughout the content, you'll see superscript numbers like ¹⁵ that link to academic sources and references. Tap any footnote to view the full citation.")
                        .font(Typography.body)
                        .foregroundColor(.textSecondary)

                    Text("A complete bibliography is available at the bottom of each module's Content tab.")
                        .font(Typography.caption)
                        .foregroundColor(.textTertiary)
                        .padding(.top, Spacing.xs)
                }
                .padding(Spacing.md)
                .background(Color.surfaceSecondary)
                .clipShape(RoundedRectangle(cornerRadius: CornerRadius.lg))

                Spacer()
                    .frame(height: Spacing.xl)
            }
            .padding(.horizontal, Spacing.lg)
        }
    }
}

// MARK: - Get Started Page
struct GetStartedPage: View {
    @Binding var isPresented: Bool

    var body: some View {
        VStack(spacing: Spacing.xl) {
            Spacer()

            VStack(spacing: Spacing.lg) {
                Text("🚀")
                    .font(.system(size: 64))

                Text("Ready to Begin")
                    .font(Typography.displaySmall)
                    .foregroundColor(.textPrimary)

                Text("Start your journey into alternative asset education. Learn at your own pace, track your progress, and build lasting knowledge.")
                    .font(Typography.body)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Spacing.lg)
            }

            Spacer()

            // Start button
            Button {
                isPresented = false
            } label: {
                Text("Get Started")
                    .font(Typography.bodyMedium)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Spacing.md)
                    .background(Color.brandPrimary)
                    .clipShape(RoundedRectangle(cornerRadius: CornerRadius.lg))
            }
            .padding(.horizontal, Spacing.xl)

            // Skip for now
            Button {
                isPresented = false
            } label: {
                Text("Skip for now")
                    .font(Typography.caption)
                    .foregroundColor(.textTertiary)
            }
            .padding(.bottom, Spacing.md)
        }
    }
}

// MARK: - Supporting Views

struct FeatureHighlight: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(alignment: .top, spacing: Spacing.md) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.brandPrimary)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(Typography.bodyMedium)
                    .foregroundColor(.textPrimary)

                Text(description)
                    .font(Typography.caption)
                    .foregroundColor(.textSecondary)
            }
        }
    }
}

struct AnnotationExplanationRow: View {
    let annotation: String
    let title: String
    let description: String
    let color: Color

    var body: some View {
        HStack(alignment: .top, spacing: Spacing.md) {
            // Annotation badge
            Text(annotation)
                .font(Typography.bodyMedium)
                .foregroundColor(color)
                .frame(width: 40, alignment: .center)
                .padding(.vertical, 4)
                .background(color.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 4))

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(Typography.bodyMedium)
                    .foregroundColor(.textPrimary)

                Text(description)
                    .font(Typography.caption)
                    .foregroundColor(.textSecondary)
            }

            Spacer()
        }
    }
}

struct TabExplanationRow: View {
    let tab: String
    let icon: String
    let description: String

    var body: some View {
        HStack(alignment: .top, spacing: Spacing.md) {
            Image(systemName: icon)
                .font(.body)
                .foregroundColor(.brandPrimary)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 2) {
                Text(tab)
                    .font(Typography.bodyMedium)
                    .foregroundColor(.textPrimary)

                Text(description)
                    .font(Typography.caption)
                    .foregroundColor(.textSecondary)
            }

            Spacer()
        }
    }
}

// MARK: - Annotation Key View (Standalone for Settings)
struct AnnotationKeyView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.lg) {
                    // Module Type Annotations
                    VStack(alignment: .leading, spacing: Spacing.md) {
                        Text("MODULE TYPES")
                            .font(Typography.overline)
                            .foregroundColor(.textTertiary)

                        AnnotationExplanationRow(
                            annotation: "(E)",
                            title: "Empirical Research",
                            description: "Content based on peer-reviewed studies and quantitative data",
                            color: .brandPrimary
                        )

                        AnnotationExplanationRow(
                            annotation: "(C)",
                            title: "Case Studies",
                            description: "In-depth analysis of specific examples or market events",
                            color: .info
                        )

                        AnnotationExplanationRow(
                            annotation: "(R)",
                            title: "Research-Based",
                            description: "General research-backed educational content",
                            color: .success
                        )

                        AnnotationExplanationRow(
                            annotation: "(T)",
                            title: "Technical Analysis",
                            description: "Technical or quantitative methodology-focused content",
                            color: .purple
                        )
                    }
                    .padding(Spacing.md)
                    .background(Color.surfaceSecondary)
                    .clipShape(RoundedRectangle(cornerRadius: CornerRadius.lg))

                    // Content Indicators
                    VStack(alignment: .leading, spacing: Spacing.md) {
                        Text("CONTENT INDICATORS")
                            .font(Typography.overline)
                            .foregroundColor(.textTertiary)

                        AnnotationExplanationRow(
                            annotation: "³Q",
                            title: "Quiz Count",
                            description: "Number of knowledge-check quizzes",
                            color: .success
                        )

                        AnnotationExplanationRow(
                            annotation: "²R",
                            title: "Reflection Prompts",
                            description: "Number of reflection prompts",
                            color: .brandHighlight
                        )

                        AnnotationExplanationRow(
                            annotation: "⁴C",
                            title: "Case Studies",
                            description: "Number of real-world case studies",
                            color: .info
                        )

                        AnnotationExplanationRow(
                            annotation: "¹⁵",
                            title: "Footnotes",
                            description: "Numbered citations to sources",
                            color: .textSecondary
                        )
                    }
                    .padding(Spacing.md)
                    .background(Color.surfaceSecondary)
                    .clipShape(RoundedRectangle(cornerRadius: CornerRadius.lg))
                }
                .padding(Spacing.lg)
            }
            .background(Color.surfacePrimary)
            .navigationTitle("Annotation Key")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

// MARK: - Preview
#Preview("Onboarding") {
    OnboardingWelcomeView(isPresented: .constant(true))
}

#Preview("Annotation Key") {
    AnnotationKeyView()
}
