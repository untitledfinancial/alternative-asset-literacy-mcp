//
//  InvestingFactsFeature.swift
//  Enhanced App for Alt Assets
//
//  Created by Victoria Case on 2/5/26.
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//
//  Description: Investing facts and statistics from research, particularly
//  focused on women and finance. Used for "Daily Facts," loading screens,
//  motivational cards, and educational tidbits throughout the app.
//

import SwiftUI
import Combine

// MARK: - Investing Fact Model
struct InvestingFact: Identifiable, Codable {
    let id: String
    let fact: String
    let source: String
    let category: FactCategory
    let emoji: String

    enum FactCategory: String, Codable, CaseIterable {
        case womenAndFinance = "Women & Finance"
        case behavioralEconomics = "Behavioral Economics"
        case alternativeInvesting = "Alternative Investing"
        case artMarket = "Art Market"
        case general = "General"

        var color: Color {
            switch self {
            case .womenAndFinance: return .brandHighlight
            case .behavioralEconomics: return .info
            case .alternativeInvesting: return .success
            case .artMarket: return .warning
            case .general: return .brandPrimary
            }
        }
    }
}

// MARK: - Facts Manager
class InvestingFactsManager: ObservableObject {
    @Published var facts: [InvestingFact] = []
    @Published var dailyFact: InvestingFact?

    static let shared = InvestingFactsManager()

    init() {
        loadFacts()
        selectDailyFact()
    }

    func loadFacts() {
        facts = [
            // Women and Finance Facts
            InvestingFact(
                id: "wf-1",
                fact: "Women control over $10 trillion in US household financial assets.",
                source: "McKinsey & Company",
                category: .womenAndFinance,
                emoji: "💪"
            ),
            InvestingFact(
                id: "wf-2",
                fact: "50% of new US entrepreneurs are now women, leading a business creation boom.",
                source: "Alexandre Tanzi, Bloomberg",
                category: .womenAndFinance,
                emoji: "🚀"
            ),
            InvestingFact(
                id: "wf-3",
                fact: "Women-led companies deliver 35% higher ROI than all-male leadership teams.",
                source: "Kauffman Foundation",
                category: .womenAndFinance,
                emoji: "📈"
            ),
            InvestingFact(
                id: "wf-4",
                fact: "Women investors trade 45% less frequently than men, often leading to better long-term returns.",
                source: "Barber & Odean Research",
                category: .womenAndFinance,
                emoji: "🎯"
            ),
            InvestingFact(
                id: "wf-5",
                fact: "By 2030, women are expected to control two-thirds of the nation's wealth.",
                source: "BMO Wealth Management",
                category: .womenAndFinance,
                emoji: "✨"
            ),
            InvestingFact(
                id: "wf-6",
                fact: "Women are more likely to consider ESG (Environmental, Social, Governance) factors in investment decisions.",
                source: "MSCI ESG Research",
                category: .womenAndFinance,
                emoji: "🌍"
            ),

            // Behavioral Economics Facts
            InvestingFact(
                id: "be-1",
                fact: "The 'Lake Wobegon Effect' shows that 90% of people believe they're above-average investors.",
                source: "Oxford Reference",
                category: .behavioralEconomics,
                emoji: "🧠"
            ),
            InvestingFact(
                id: "be-2",
                fact: "Analysis paralysis: Having too many investment options can lead to worse decisions or no decision at all.",
                source: "Behavioral Finance Research",
                category: .behavioralEconomics,
                emoji: "😵‍💫"
            ),
            InvestingFact(
                id: "be-3",
                fact: "Neuroplasticity means your brain can form new financial habits at any age.",
                source: "Norman Doidge, MD",
                category: .behavioralEconomics,
                emoji: "🔄"
            ),
            InvestingFact(
                id: "be-4",
                fact: "Overconfident investors trade excessively, reducing their annual returns by up to 2.65%.",
                source: "Barber & Odean",
                category: .behavioralEconomics,
                emoji: "📉"
            ),

            // Alternative Investing Facts
            InvestingFact(
                id: "ai-1",
                fact: "Alternative investments often have low correlation with traditional markets, providing diversification.",
                source: "World Economic Forum",
                category: .alternativeInvesting,
                emoji: "🎲"
            ),
            InvestingFact(
                id: "ai-2",
                fact: "The global alternative investments market is projected to exceed $17 trillion.",
                source: "Preqin",
                category: .alternativeInvesting,
                emoji: "💰"
            ),
            InvestingFact(
                id: "ai-3",
                fact: "Real estate has historically provided both income and inflation protection.",
                source: "Harvard Business School",
                category: .alternativeInvesting,
                emoji: "🏠"
            ),
            InvestingFact(
                id: "ai-4",
                fact: "Illiquidity premium: Less liquid assets may offer higher returns as compensation.",
                source: "Investment Research",
                category: .alternativeInvesting,
                emoji: "⏳"
            ),

            // Art Market Facts
            InvestingFact(
                id: "am-1",
                fact: "In 2021, Beeple's NFT artwork sold for $69 million, transforming digital art markets.",
                source: "New York Times",
                category: .artMarket,
                emoji: "🖼️"
            ),
            InvestingFact(
                id: "am-2",
                fact: "The global art market reached $65.1 billion in sales in 2023.",
                source: "Art Basel Report",
                category: .artMarket,
                emoji: "🎨"
            ),
            InvestingFact(
                id: "am-3",
                fact: "Art as an asset class has averaged 7.6% annual returns over the past 25 years.",
                source: "Art Market Research",
                category: .artMarket,
                emoji: "📊"
            )
        ]
    }

    func selectDailyFact() {
        // Use the day of year to consistently show the same fact each day
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        let index = dayOfYear % facts.count
        dailyFact = facts[index]
    }

    func randomFact() -> InvestingFact {
        facts.randomElement() ?? facts[0]
    }

    func facts(for category: InvestingFact.FactCategory) -> [InvestingFact] {
        facts.filter { $0.category == category }
    }
}

// MARK: - Daily Fact Card
struct DailyFactCard: View {
    @ObservedObject var factsManager = InvestingFactsManager.shared

    var body: some View {
        if let fact = factsManager.dailyFact {
            VStack(alignment: .leading, spacing: Spacing.sm) {
                HStack {
                    Text("📅")
                        .font(.system(size: 18))
                    Text("Today's Insight")
                        .font(Typography.captionMedium)
                        .foregroundColor(.textTertiary)
                    Spacer()
                    Text(fact.category.rawValue)
                        .font(Typography.caption2)
                        .padding(.horizontal, Spacing.xs)
                        .padding(.vertical, 2)
                        .background(fact.category.color.opacity(0.1))
                        .foregroundColor(fact.category.color)
                        .clipShape(Capsule())
                }

                HStack(alignment: .top, spacing: Spacing.sm) {
                    Text(fact.emoji)
                        .font(.system(size: 28))

                    Text(fact.fact)
                        .font(Typography.body)
                        .foregroundColor(.textPrimary)
                }

                Text("Source: \(fact.source)")
                    .font(Typography.caption2)
                    .foregroundColor(.textTertiary)
            }
            .padding(Spacing.md)
            .background(Color.surfaceSecondary)
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
        }
    }
}

// MARK: - Motivational Fact Banner
struct MotivationalFactBanner: View {
    let fact: InvestingFact

    var body: some View {
        HStack(spacing: Spacing.md) {
            Text(fact.emoji)
                .font(.system(size: 32))

            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text(fact.fact)
                    .font(Typography.bodyMedium)
                    .foregroundColor(.white)
                    .lineLimit(3)

                Text(fact.source)
                    .font(Typography.caption2)
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .padding(Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                colors: [fact.category.color, fact.category.color.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
    }
}

// MARK: - Mini Fact Chip
struct MiniFactChip: View {
    let fact: InvestingFact
    @State private var showingDetail = false

    var body: some View {
        Button {
            showingDetail = true
        } label: {
            HStack(spacing: Spacing.xs) {
                Text(fact.emoji)
                    .font(.system(size: 14))
                Text(fact.fact.prefix(50) + "...")
                    .font(Typography.caption)
                    .foregroundColor(.textSecondary)
                    .lineLimit(1)
            }
            .padding(.horizontal, Spacing.sm)
            .padding(.vertical, Spacing.xs)
            .background(Color.surfaceSecondary)
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showingDetail) {
            FactDetailSheet(fact: fact)
        }
    }
}

// MARK: - Fact Detail Sheet
struct FactDetailSheet: View {
    let fact: InvestingFact
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: Spacing.xl) {
                Text(fact.emoji)
                    .font(.system(size: 64))

                Text(fact.fact)
                    .font(Typography.title3)
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.center)

                VStack(spacing: Spacing.sm) {
                    Text(fact.category.rawValue)
                        .font(Typography.captionMedium)
                        .padding(.horizontal, Spacing.md)
                        .padding(.vertical, Spacing.xs)
                        .background(fact.category.color.opacity(0.1))
                        .foregroundColor(fact.category.color)
                        .clipShape(Capsule())

                    Text("Source: \(fact.source)")
                        .font(Typography.caption)
                        .foregroundColor(.textTertiary)
                }

                Spacer()
            }
            .padding(Spacing.xl)
            .background(Color.surfacePrimary)
            .navigationTitle("Investing Insight")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Loading Screen Fact View
struct LoadingFactView: View {
    @State private var currentFact: InvestingFact?
    @State private var opacity: Double = 0

    var body: some View {
        VStack(spacing: Spacing.lg) {
            ProgressView()
                .scaleEffect(1.5)

            if let fact = currentFact {
                VStack(spacing: Spacing.sm) {
                    Text(fact.emoji)
                        .font(.system(size: 32))

                    Text(fact.fact)
                        .font(Typography.body)
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                }
                .opacity(opacity)
                .animation(.easeIn(duration: 0.5), value: opacity)
            }
        }
        .padding(Spacing.xl)
        .onAppear {
            currentFact = InvestingFactsManager.shared.randomFact()
            withAnimation {
                opacity = 1
            }
        }
    }
}

// MARK: - Preview
#Preview("Daily Fact") {
    VStack(spacing: 20) {
        DailyFactCard()

        MotivationalFactBanner(
            fact: InvestingFact(
                id: "test",
                fact: "Women-led companies deliver 35% higher ROI than all-male leadership teams.",
                source: "Kauffman Foundation",
                category: .womenAndFinance,
                emoji: "📈"
            )
        )
    }
    .padding()
    .background(Color.surfacePrimary)
}
