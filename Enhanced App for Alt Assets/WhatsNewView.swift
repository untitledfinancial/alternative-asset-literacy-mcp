//
//  WhatsNewView.swift
//  Enhanced App for Alt Assets
//
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//

import SwiftUI

private struct WhatsNewFeature: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let description: String
}

private let whatsNewFeatures: [WhatsNewFeature] = [
    WhatsNewFeature(
        icon: "bell.badge",
        title: "Review Reminders",
        description: "Daily notifications remind you when concepts are due for spaced review — keeping retention on schedule."
    ),
    WhatsNewFeature(
        icon: "rosette",
        title: "Module Certificates",
        description: "Complete a module quiz and receive a certificate you can save or share."
    ),
    WhatsNewFeature(
        icon: "arrow.triangle.2.circlepath",
        title: "Cross-Module Insights",
        description: "After completing multiple modules, discover how themes connect — behavioral finance meets DeFi, gender lens meets ESG."
    ),
    WhatsNewFeature(
        icon: "square.and.arrow.up",
        title: "Export Your Work",
        description: "Export your Reflection Journal and Advisor Session Prep as formatted text — ready for a meeting or personal archive."
    ),
    WhatsNewFeature(
        icon: "person.fill.questionmark",
        title: "More Advisor Questions",
        description: "New question sets for Behavioral Finance and Gender Lens Investing join the existing five advisor guides."
    ),
    WhatsNewFeature(
        icon: "arrow.down",
        title: "Pull to Refresh",
        description: "Pull down on the Learn tab to fetch the latest module content from Notion."
    )
]

// Bump this key when you want to show What's New again for a future update.
private let whatsNewSeenKey = "whats_new_seen_v2"

struct WhatsNewSheet: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.xl) {
                    // Header
                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        Text("What's New")
                            .font(.system(size: 32, weight: .light, design: .serif))
                            .foregroundColor(.textPrimary)
                        Text("A few things we've added to improve your learning experience.")
                            .font(Typography.body)
                            .foregroundColor(.textSecondary)
                    }
                    .padding(.top, Spacing.md)

                    // Feature list
                    VStack(alignment: .leading, spacing: Spacing.lg) {
                        ForEach(whatsNewFeatures) { feature in
                            HStack(alignment: .top, spacing: Spacing.md) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.brandPrimary.opacity(0.12))
                                        .frame(width: 44, height: 44)
                                    Image(systemName: feature.icon)
                                        .font(.system(size: 18))
                                        .foregroundColor(.brandPrimary)
                                }

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(feature.title)
                                        .font(Typography.bodyMedium)
                                        .foregroundColor(.textPrimary)
                                    Text(feature.description)
                                        .font(Typography.body)
                                        .foregroundColor(.textSecondary)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                            }
                        }
                    }

                    // Footer
                    Text("alternativeassetsliteracy.com")
                        .font(Typography.caption)
                        .foregroundColor(.textTertiary)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .padding(.top, Spacing.sm)
                }
                .padding(Spacing.lg)
            }
            .background(Color.surfacePrimary)
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Continue") {
                        UserDefaults.standard.set(true, forKey: whatsNewSeenKey)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

struct WhatsNewModifier: ViewModifier {
    @State private var showingWhatsNew = !UserDefaults.standard.bool(forKey: whatsNewSeenKey)

    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $showingWhatsNew) {
                WhatsNewSheet()
            }
    }
}

extension View {
    func showWhatsNewIfNeeded() -> some View {
        modifier(WhatsNewModifier())
    }
}
