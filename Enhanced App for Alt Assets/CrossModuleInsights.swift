//
//  CrossModuleInsights.swift
//  Enhanced App for Alt Assets
//
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//
//  Editorial connections surfaced when a user completes two or more related modules.

import SwiftUI

// MARK: - Data
struct CrossModuleInsight: Identifiable {
    let id: String
    let moduleIds: [String]       // Both must be complete for this to appear
    let headline: String
    let body: String
    let icon: String
}

struct CrossModuleInsightsData {
    static let all: [CrossModuleInsight] = [
        CrossModuleInsight(
            id: "insight_behavioral_defi",
            moduleIds: ["mod_behavioral", "mod_defi"],
            headline: "Behavioral Economics × DeFi",
            body: "The loss aversion and herd behavior patterns you studied in behavioral economics are amplified in crypto markets — where 24/7 pricing, social media feedback loops, and asymmetric information create near-ideal conditions for cognitive bias. Your behavioral toolkit applies directly here.",
            icon: "🧠"
        ),
        CrossModuleInsight(
            id: "insight_women_gender",
            moduleIds: ["mod_women", "mod_gender"],
            headline: "Investing Primer × Gender Lens",
            body: "The foundational investing principles from the Investing Primer take on new dimension when viewed through the gender lens: the confidence gap, the advice gap, and structural wage differences all affect how those principles are applied in practice — and by whom.",
            icon: "⚖️"
        ),
        CrossModuleInsight(
            id: "insight_art_behavioral",
            moduleIds: ["mod_art", "mod_behavioral"],
            headline: "Art Markets × Behavioral Economics",
            body: "Art markets are among the most behaviorally complex investment environments — anchoring drives auction bidding, social proof determines which artists gain institutional recognition, and the endowment effect makes collectors overvalue what they already own. The two modules together are a unified lens.",
            icon: "🖼️"
        ),
        CrossModuleInsight(
            id: "insight_esg_alt",
            moduleIds: ["mod_esg_climate", "mod_alt"],
            headline: "ESG × Alternative Assets",
            body: "ESG and alternative assets converge in infrastructure, timberland, and real assets: these categories offer both the illiquidity premium you studied in the alt module and the environmental alignment that ESG frameworks demand. The overlap is one of the fastest-growing areas in institutional capital allocation.",
            icon: "🌱"
        ),
        CrossModuleInsight(
            id: "insight_defi_alt",
            moduleIds: ["mod_defi", "mod_alt"],
            headline: "DeFi × Alternative Investing",
            body: "DeFi protocols share structural characteristics with alternative assets: illiquidity windows (lock-up periods), high information asymmetry, and returns that are uncorrelated with public markets. The risk framework you built for alternatives translates — with modifications — to on-chain capital allocation.",
            icon: "⛓️"
        ),
        CrossModuleInsight(
            id: "insight_kahlo_behavioral",
            moduleIds: ["mod_kahlo_basquiat", "mod_behavioral"],
            headline: "Kahlo × Basquiat × Behavioral Economics",
            body: "The dramatic appreciation of Kahlo and Basquiat's work after institutional recognition is a case study in narrative anchoring, retrospective value attribution, and the availability heuristic — we reinterpret earlier prices as obviously wrong, even though few saw it coming. Both modules illuminate why.",
            icon: "🎨"
        ),
        CrossModuleInsight(
            id: "insight_defi_investing_alt",
            moduleIds: ["mod_defi_investing", "mod_alt"],
            headline: "DeFi Investing × Alternative Assets",
            body: "The due diligence framework you developed for evaluating DeFi protocols — TVL, revenue model, governance structure, smart contract risk — maps onto how institutional investors evaluate private equity and venture funds. The vocabulary differs; the analytical instinct is the same.",
            icon: "📊"
        )
    ]
}

// MARK: - Card View
struct CrossModuleInsightCard: View {
    let insight: CrossModuleInsight
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack(spacing: Spacing.sm) {
                Text(insight.icon)
                    .font(.system(size: 20))
                Text(insight.headline)
                    .font(Typography.captionMedium)
                    .foregroundColor(.brandPrimary)
                Spacer()
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.textTertiary)
            }

            if isExpanded {
                Text(insight.body)
                    .font(Typography.body)
                    .foregroundColor(.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(Spacing.md)
        .background(Color.brandPrimary.opacity(0.05))
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.md)
                .stroke(Color.brandPrimary.opacity(0.15), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
                isExpanded.toggle()
            }
        }
    }
}

// MARK: - Section View
struct CrossModuleInsightsSection: View {
    @EnvironmentObject var progressManager: ProgressManager

    private var visibleInsights: [CrossModuleInsight] {
        CrossModuleInsightsData.all.filter { insight in
            insight.moduleIds.allSatisfy { progressManager.isModuleComplete($0) }
        }
    }

    var body: some View {
        if !visibleInsights.isEmpty {
            VStack(alignment: .leading, spacing: Spacing.sm) {
                HStack(spacing: 6) {
                    Image(systemName: "arrow.triangle.merge")
                        .font(.system(size: 13))
                        .foregroundColor(.textTertiary)
                    Text("Connections Across Modules")
                        .font(Typography.captionMedium)
                        .foregroundColor(.textTertiary)
                }

                ForEach(visibleInsights) { insight in
                    CrossModuleInsightCard(insight: insight)
                }
            }
        }
    }
}
