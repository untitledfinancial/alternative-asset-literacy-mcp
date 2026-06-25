//
//  WineNextStepsView.swift
//  Enhanced App for Alt Assets
//
//  Created by Victoria Case on 2026-06-03.
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//
//  Description: Practical next-steps guide for users interested in wine and
//  vineyard investing. Covers key professionals, essential reading, platforms,
//  online resources, and practical considerations before investing.
//

import SwiftUI

// MARK: - Data Models

struct WineNextStepsSection: Identifiable {
    let id: String
    let title: String
    let emoji: String
    let items: [WineNextStepsItem]
    var itemCount: Int? { items.count > 0 ? items.count : nil }
}

struct WineNextStepsItem: Identifiable {
    let id: String
    let title: String
    let description: String
    let practicalTip: String?
    let url: String?
    let appleBooksURL: String?

    init(id: String, title: String, description: String, practicalTip: String? = nil, url: String? = nil, appleBooksURL: String? = nil) {
        self.id = id
        self.title = title
        self.description = description
        self.practicalTip = practicalTip
        self.url = url
        self.appleBooksURL = appleBooksURL
    }
}

// MARK: - Next Steps Tab View

struct WineNextStepsTabView: View {
    @State private var expandedSections: Set<String> = []
    private let sections = WineNextStepsData.allSections

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.lg) {

            // Header
            VStack(alignment: .leading, spacing: Spacing.sm) {
                Text("Your Next Steps")
                    .font(Typography.title2)
                    .foregroundColor(.textPrimary)
                    .padding(.top, Spacing.lg)

                Text("Navigating wine and vineyard investment requires the right relationships, research, and resources. Here is a practical guide to moving from learning to investing.")
                    .font(Typography.body)
                    .foregroundColor(.textSecondary)
                    .lineSpacing(4)
            }
            .padding(.horizontal, Spacing.lg)

            // Sections
            ForEach(sections) { section in
                sectionView(section)
            }
            .padding(.horizontal, Spacing.lg)

            Spacer().frame(height: Spacing.xxxl)
        }
    }

    // MARK: - Section View
    @ViewBuilder
    private func sectionView(_ section: WineNextStepsSection) -> some View {
        let isExpanded = expandedSections.contains(section.id)

        VStack(alignment: .leading, spacing: 0) {
            Button {
                withAnimation(.smoothSpring) {
                    if isExpanded {
                        expandedSections.remove(section.id)
                    } else {
                        expandedSections.insert(section.id)
                    }
                }
            } label: {
                HStack(spacing: Spacing.sm) {
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.textTertiary)
                        .frame(width: 16)

                    Text(section.emoji)
                        .font(.system(size: 18))

                    Text(section.title)
                        .font(Typography.bodyMedium)
                        .foregroundColor(.textPrimary)

                    if let count = section.itemCount {
                        Text("(\(count))")
                            .font(Typography.caption)
                            .foregroundColor(.textTertiary)
                    }

                    Spacer()
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .padding(.vertical, Spacing.sm)

            if isExpanded {
                VStack(alignment: .leading, spacing: Spacing.md) {
                    ForEach(section.items) { item in
                        itemView(item)
                    }
                }
                .padding(.leading, Spacing.lg)
                .padding(.top, Spacing.xs)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(Spacing.md)
        .background(Color.surfaceSecondary)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
    }

    // MARK: - Item View
    @ViewBuilder
    private func itemView(_ item: WineNextStepsItem) -> some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text(item.title)
                .font(Typography.bodyMedium)
                .foregroundColor(.textPrimary)

            Text(item.description)
                .font(Typography.body)
                .foregroundColor(.textSecondary)
                .lineSpacing(3)

            if let tip = item.practicalTip {
                HStack(alignment: .top, spacing: Spacing.xs) {
                    Text("→")
                        .font(Typography.caption)
                        .foregroundColor(.brandHighlight)
                    Text(tip)
                        .font(Typography.caption)
                        .foregroundColor(.textTertiary)
                        .lineSpacing(2)
                }
                .padding(.top, Spacing.xxs)
            }

            HStack(spacing: Spacing.sm) {
                if let urlString = item.url, let url = URL(string: urlString) {
                    Link("Visit →", destination: url)
                        .font(Typography.caption)
                        .foregroundColor(.brandHighlight)
                }
                if let booksURL = item.appleBooksURL, let url = URL(string: booksURL) {
                    Link("Apple Books →", destination: url)
                        .font(Typography.caption)
                        .foregroundColor(.brandHighlight)
                }
            }
            .padding(.top, Spacing.xxs)
        }
        .padding(.bottom, Spacing.xs)
    }
}

// MARK: - Data

enum WineNextStepsData {

    static var allSections: [WineNextStepsSection] {
        [whoToTalkTo, essentialReading, investmentPlatforms, onlineResources, practicalConsiderations]
    }

    // MARK: - Who to Talk To
    static let whoToTalkTo = WineNextStepsSection(
        id: "wine_who_to_talk_to",
        title: "Who to Talk To",
        emoji: "🤝",
        items: [
            WineNextStepsItem(
                id: "wine_merchant",
                title: "Fine Wine Merchant",
                description: "Your most important starting relationship. An established fine wine merchant — Berry Bros. & Rudd, Justerini & Brooks, Farr Vintners, or Bordeaux Index — can advise on investment-grade selections, provide provenance documentation, arrange bonded storage, and facilitate eventual resale. Many offer portfolio review services. Unlike platforms, they provide human expertise and market context that algorithms cannot replicate.",
                practicalTip: "Berry Bros. & Rudd (bbr.com) and Farr Vintners (farrvintners.com) both offer portfolio consultations and have offices in the UK and US.",
                url: "https://www.bbr.com"
            ),
            WineNextStepsItem(
                id: "wine_investment_platform",
                title: "Wine Investment Platform",
                description: "For managed exposure without building merchant relationships yourself, platforms like Cult Wines, WineCap, and Vin-X offer portfolio construction, bonded storage, insurance, and eventual resale. Cult Wines has a 9.35% CAGR since 2009. Minimum investments range from £1,000 (WineCap) to £10,000 (Cult Wines). Fees typically run 1.5–2.5% annually — understand the full cost structure before committing.",
                practicalTip: "Request each platform's published performance data and ask specifically how returns are calculated — gross or net of fees.",
                url: "https://www.wineinvestment.com"
            ),
            WineNextStepsItem(
                id: "wine_auction_specialist",
                title: "Auction House Wine Specialist",
                description: "Christie's, Acker Wines, Hart Davis Hart, Zachys, and Sotheby's all have specialist wine departments. They are the right contact when selling significant collections, seeking provenance verification on secondary market purchases, or attending major auction previews. Acker posted $175M in 2024 sales and holds 35% market share. Building this relationship before you need to sell is strategic.",
                practicalTip: "Attend a major auction preview — Christie's and Sotheby's regularly host wine previews in New York and London. Access is usually free.",
                url: "https://www.ackerwines.com"
            ),
            WineNextStepsItem(
                id: "wine_tax_advisor",
                title: "Tax Advisor Specializing in Collectibles",
                description: "Wine investment has jurisdiction-specific tax treatment that general financial advisors often mishandle. In the UK, fine wine stored in-bond qualifies as a wasting asset, typically exempt from CGT — but this requires the wine to be purchased and stored correctly. In the US, vineyard investment uses IRS Schedule F; the GFV (Groupement Foncier Viticole) offers specific French tax advantages. Find an advisor with documented experience in wine or tangible asset investment.",
                practicalTip: "In France, the GFV structure deserves specific discussion with a notaire familiar with agricultural land vehicles — it offers wealth tax (IFI) advantages unavailable in direct ownership.",
                url: nil
            ),
            WineNextStepsItem(
                id: "wine_vineyard_agent",
                title: "Vineyard Real Estate Specialist",
                description: "If considering vineyard land acquisition, specialist agents — Knight Frank's rural team, Savills Wine Estates, Home Hunts — have dedicated vineyard desks across Bordeaux, Burgundy, Tuscany, and California. In France, any land transaction requires navigating the SAFER right of first refusal; a specialist agent and notaire familiar with this process are essential.",
                practicalTip: "Knight Frank's annual Wealth Report includes vineyard investment data and their rural team can facilitate introductions across most major wine regions.",
                url: "https://www.knightfrank.com/wealthreport"
            ),
            WineNextStepsItem(
                id: "wine_biodynamic_consultant",
                title: "Biodynamic Consultant (for Vineyard Investors)",
                description: "If purchasing or converting a vineyard to biodynamic production, engaging a certified Demeter consultant before acquisition is critical. They can assess conversion feasibility, estimate the 3–5 year transition timeline and cost, identify soil health baselines, and connect you with the Demeter certification process. The Demeter International network maintains a directory of certified consultants.",
                practicalTip: "Demeter-usa.org and Demeter.net both maintain consultant directories. In France, Biodyvin (biodyvin.com) connects producers with experienced advisors.",
                url: "https://www.demeter.net"
            ),
        ]
    )

    // MARK: - Essential Reading
    static let essentialReading = WineNextStepsSection(
        id: "wine_essential_reading",
        title: "Essential Reading",
        emoji: "📚",
        items: [
            WineNextStepsItem(
                id: "book_wine_investment",
                title: "Wine Investment for Portfolio Diversification",
                description: "By Mahesh Kumar. The most quantitatively rigorous book on wine as an investable asset class — covering index construction, risk-adjusted returns, correlation properties, and portfolio optimization. Essential reading before committing significant capital.",
                practicalTip: nil,
                url: nil,
                appleBooksURL: nil
            ),
            WineNextStepsItem(
                id: "book_original_wine",
                title: "The Original Wine of Bordeaux",
                description: "By Dewey Markham. The definitive history of the 1855 Classification that still defines the most actively traded investment wines today. Understanding why Pétrus, DRC, and the First Growths command their prices requires understanding the classification history.",
                practicalTip: nil,
                url: nil,
                appleBooksURL: nil
            ),
            WineNextStepsItem(
                id: "book_biodynamic_wine",
                title: "Biodynamic Wine",
                description: "By Monty Waldin. The most accessible serious treatment of biodynamic viticulture — covering Rudolf Steiner's principles, the nine preparations, Demeter certification, and estate case studies. Essential reading for investors specifically interested in the biodynamic segment.",
                practicalTip: nil,
                url: nil,
                appleBooksURL: nil
            ),
            WineNextStepsItem(
                id: "book_terroir",
                title: "Godforsaken Grapes",
                description: "By Jason Wilson. An engaging exploration of obscure, terroir-driven wine regions — Jura, Canary Islands, Georgia, Slovenia — that have become the frontiers of collector interest and emerging investment. A cultural and market intelligence document disguised as a travel book.",
                practicalTip: "The regions Wilson covers in 2018 are exactly the regions commanding price premiums in 2025–2026.",
                url: nil,
                appleBooksURL: nil
            ),
            WineNextStepsItem(
                id: "book_noble_rot",
                title: "Noble Rot Magazine",
                description: "London-based print and digital publication at the intersection of wine culture, gastronomy, and serious wine knowledge. Regularly covers natural, biodynamic, and terroir-expressive producers before they appear on investment platforms. Essential for tracking emerging collector interest.",
                practicalTip: nil,
                url: "https://noblerot.co.uk",
                appleBooksURL: nil
            ),
            WineNextStepsItem(
                id: "book_wine_spectator",
                title: "Wine Spectator — The Investment Issue (Annual)",
                description: "Wine Spectator publishes annual coverage of wine investment, including auction results, top-performing producers, and emerging regions. Their 100-point scores are one of the most influential price drivers in the fine wine market.",
                practicalTip: nil,
                url: "https://www.winespectator.com",
                appleBooksURL: nil
            ),
            WineNextStepsItem(
                id: "book_decanter",
                title: "Decanter",
                description: "The UK's most authoritative wine publication. Decanter scores, producer profiles, and regional analyses directly influence secondary market pricing. Their annual Power List and regional reports are essential market intelligence.",
                practicalTip: nil,
                url: "https://www.decanter.com",
                appleBooksURL: nil
            ),
            WineNextStepsItem(
                id: "book_knight_frank",
                title: "Knight Frank Wealth Report — Luxury Investment Index",
                description: "Published annually. The Luxury Investment Index section compares fine wine returns against other passion assets (classic cars, watches, art, rare whisky). The 2024 report showed fine wine ranked second only to rare whisky over a 10-year period. Free to download.",
                practicalTip: nil,
                url: "https://www.knightfrank.com/wealthreport",
                appleBooksURL: nil
            ),
        ]
    )

    // MARK: - Investment Platforms
    static let investmentPlatforms = WineNextStepsSection(
        id: "wine_platforms",
        title: "Investment Platforms & Entry Points",
        emoji: "💼",
        items: [
            WineNextStepsItem(
                id: "platform_cult_wines",
                title: "Cult Wines",
                description: "UK-based, the largest dedicated fine wine investment manager. Minimum £10,000. Approximately 1.5–2% annual management fee. 9.35% CAGR since October 2009. Holds physical wine in bonded warehouses; provides portfolio dashboard. Offices in UK, US, Hong Kong, Singapore. Best for investors wanting professionally managed, diversified exposure.",
                practicalTip: nil,
                url: "https://www.wineinvestment.com"
            ),
            WineNextStepsItem(
                id: "platform_winecap",
                title: "WineCap",
                description: "UK-based. Minimum £1,000 — lowest entry point of the major managed platforms. Emphasizes sustainable and ESG-aligned wine selection. Data-driven portfolio construction. Bonded storage arranged. Growing focus on organic and biodynamic producers.",
                practicalTip: nil,
                url: "https://winecap.com"
            ),
            WineNextStepsItem(
                id: "platform_vinx",
                title: "Vin-X",
                description: "UK-based trading desk model — more active than managed portfolio services. Suitable for investors who want to make specific wine selections rather than delegate the decision. Access to live market pricing. Bonded storage and insurance facilitated.",
                practicalTip: nil,
                url: "https://www.vin-x.com"
            ),
            WineNextStepsItem(
                id: "platform_vinovest",
                title: "Vinovest",
                description: "US-based. Minimum $1,000. Fee: 1.9–2.5% annually. AI-driven wine selection. Stores wine in bonded facilities. Primarily targets US retail investors. Does not publish independently audited returns — request performance data before committing.",
                practicalTip: nil,
                url: "https://www.vinovest.co"
            ),
            WineNextStepsItem(
                id: "platform_vint",
                title: "Vint",
                description: "US-based fractional wine ownership. SEC-qualified offerings. Investors buy shares in specific wine cases rather than a managed portfolio. Low minimums (often under $100 per share). Exit via Vint's secondary market. Suited to investors who want specific wine exposure without large minimums.",
                practicalTip: nil,
                url: "https://www.vint.co"
            ),
            WineNextStepsItem(
                id: "platform_farmtogether",
                title: "FarmTogether (Vineyard/Regenerative)",
                description: "US-based fractional farmland platform. Made its first wine-specific acquisition in December 2024 — Josephine and Pearl Vineyards in Oregon's Willamette Valley ($5.9M). Minimum ~$15,000. Sustainable and regenerative mandate. Best for investors specifically seeking regenerative vineyard exposure without full acquisition.",
                practicalTip: nil,
                url: "https://www.farmtogether.com"
            ),
            WineNextStepsItem(
                id: "platform_iroquois",
                title: "Iroquois Valley Farmland REIT",
                description: "US-based REIT focused on organic and regenerative farmland. Approximately 8% annualized return since inception. Not wine-specific but provides organic farmland exposure that may include vineyard assets. Impact-oriented; B Corp certified.",
                practicalTip: nil,
                url: "https://www.iroquoisvalley.com"
            ),
            WineNextStepsItem(
                id: "platform_rarewineinvest",
                title: "RareWine Invest",
                description: "Denmark-based. Realized returns: +88% (2022), +46.3% (2023), +18.7% (2024), +0.4% (2025). Transparent about annual realized performance. European focus. For investors seeking alternatives to UK-centric platforms.",
                practicalTip: nil,
                url: "https://www.rarewineinvest.com"
            ),
        ]
    )

    // MARK: - Online Resources
    static let onlineResources = WineNextStepsSection(
        id: "wine_online_resources",
        title: "Online Resources",
        emoji: "🌐",
        items: [
            WineNextStepsItem(
                id: "res_livex",
                title: "Liv-ex",
                description: "The London International Vintners Exchange — the primary benchmark for fine wine investment performance. Their indices (Fine Wine 100, Fine Wine 1000, Investables) are the most cited in the industry. Market reports, trade data, and the Liv-ex Power 100 producer rankings are published regularly. Trade access requires merchant membership; investor insights are partially available publicly.",
                practicalTip: nil,
                url: "https://www.liv-ex.com"
            ),
            WineNextStepsItem(
                id: "res_wine_searcher",
                title: "Wine-Searcher",
                description: "The most comprehensive wine price database — tracks retail and auction prices globally across millions of listings. Essential for understanding current market value of any specific wine before buying or selling. Pro subscription unlocks historical price charts.",
                practicalTip: "Use Wine-Searcher to benchmark any wine you are considering purchasing. If the platform price is significantly above Wine-Searcher retail, understand why before committing.",
                url: "https://www.wine-searcher.com"
            ),
            WineNextStepsItem(
                id: "res_cellartracker",
                title: "CellarTracker",
                description: "The largest wine review database, with over 10 million tasting notes from collectors worldwide. Useful for tracking drinking windows (critical for knowing when to sell), community reviews, and cellar management. Free basic access.",
                practicalTip: nil,
                url: "https://www.cellartracker.com"
            ),
            WineNextStepsItem(
                id: "res_jancis",
                title: "JancisRobinson.com",
                description: "Jancis Robinson MW is among the world's most respected wine critics. Her scores and producer profiles directly influence secondary market prices. Subscription-based but essential for serious investors wanting critical intelligence beyond Parker and Wine Spectator.",
                practicalTip: nil,
                url: "https://www.jancisrobinson.com"
            ),
            WineNextStepsItem(
                id: "res_oiv",
                title: "OIV — International Organisation of Vine and Wine",
                description: "The global intergovernmental body for wine statistics. Publishes the annual State of the World Vine and Wine Sector report — the authoritative source for global production, consumption, and trade data. Free to download.",
                practicalTip: nil,
                url: "https://www.oiv.int"
            ),
            WineNextStepsItem(
                id: "res_demeter",
                title: "Demeter International",
                description: "The global biodynamic certification body. Search for Demeter-certified producers worldwide, find certified consultants for vineyard conversion, and access the full certification standards. Essential for investors specifically interested in biodynamic wine or vineyard conversion.",
                practicalTip: nil,
                url: "https://www.demeter.net"
            ),
            WineNextStepsItem(
                id: "res_svb",
                title: "Silicon Valley Bank — State of the US Wine Industry",
                description: "Annual report on US wine industry economics, DTC trends, generational consumption shifts, and market outlook. The most data-rich publicly available analysis of the American wine market. Free download.",
                practicalTip: nil,
                url: "https://www.svb.com/trends-insights/reports/wine-report/"
            ),
        ]
    )

    // MARK: - Practical Considerations
    static let practicalConsiderations = WineNextStepsSection(
        id: "wine_practical_considerations",
        title: "Before You Invest",
        emoji: "📋",
        items: [
            WineNextStepsItem(
                id: "wine_storage",
                title: "Storage Is Not Optional",
                description: "Investment-grade wine stored outside a professional bonded warehouse loses its investment value. Provenance — the documented chain of ownership and storage conditions — is what auction houses and platforms verify before accepting wine for resale. Self-storage, regardless of how carefully maintained, breaks the provenance chain. UK bonded warehouses (Octavian, London City Bond) and US equivalents (Iron Gate, Domaine) provide climate control, insurance integration, and the documentation required for future resale.",
                practicalTip: "Annual bonded storage costs approximately £12–18 per case in the UK. Factor this into your total cost of ownership and required return threshold."
            ),
            WineNextStepsItem(
                id: "wine_costs",
                title: "Understand the Full Cost Stack",
                description: "Wine investment costs are layered and significant. Buying: platform or merchant margin. Holding: storage (£12–18/case/year), insurance (0.15–0.25% of portfolio value/year), management fees on platforms (1.5–2.5%/year). Selling: auction seller's commission (10–15%) plus buyer's premium on the other side (20–25%). Over a 10-year hold, these costs can consume 25–35% of gross return. Model your net return before committing, not after.",
                practicalTip: "The break-even annual return needed to profit after all costs over a 10-year hold is approximately 3.5–5% depending on vehicle. Below that, you have paid for the privilege of owning wine."
            ),
            WineNextStepsItem(
                id: "wine_provenance",
                title: "Provenance Verification Is Non-Negotiable",
                description: "The Rudy Kurniawan case — tens of millions of dollars of fabricated DRC, Pétrus, and blue-chip wine sold at major auction houses — demonstrated that counterfeit risk is real even at the highest level. Only purchase from established auction houses with provenance review processes, or regulated platforms with documented custody chains. When buying from private sellers, require original purchase receipts, storage records, and shipping documentation.",
                practicalTip: "If provenance cannot be fully documented, the price should reflect the discount. If the seller will not provide documentation, do not buy."
            ),
            WineNextStepsItem(
                id: "wine_hold",
                title: "Fine Wine Rewards Patience",
                description: "The optimal hold period for most investment-grade wine is 5–12 years — selling 2–3 years before the peak of the drinking window. Short-term trades rarely produce net positive returns after transaction costs. The 2022–2025 market correction of -26.6% was the worst in Liv-ex recorded history; investors who sold at the nadir realized losses that long-term holders avoided entirely. Treat fine wine as a 7–10 year minimum commitment.",
                practicalTip: "If you need liquidity within 3 years, fine wine is the wrong vehicle. Consider shorter-duration platforms like Vint with secondary market mechanisms."
            ),
            WineNextStepsItem(
                id: "wine_diversify",
                title: "Diversify Across Regions and Vintages",
                description: "A portfolio concentrated in a single region — particularly one with elevated climate, tariff, or market cycle risk — amplifies rather than mitigates overall risk. Bordeaux's 2024 correction was -18% on land values and -0.8% on bottles; Italy returned +33.7% in the same period. A well-constructed wine portfolio holds exposure across at least three regions, multiple vintages, and a mix of investment tiers.",
                practicalTip: "The Liv-ex Fine Wine 1000 (broader, 1,000 wines) has consistently outperformed the Fine Wine 100 (Bordeaux-concentrated) over the past decade precisely because of regional diversification."
            ),
            WineNextStepsItem(
                id: "wine_disclaimer",
                title: "Disclaimer",
                description: "This content is for educational purposes only and does not constitute financial, legal, or tax advice. Untitled_ LuxPerpetua Technologies does not hold a FINRA license and does not offer investment advisory services. Wine investment involves significant risk including total loss of capital. Past performance does not guarantee future results. Consult a qualified financial advisor and tax professional before making any investment decision.",
                practicalTip: nil
            ),
        ]
    )
}

// MARK: - Preview
#Preview {
    ScrollView {
        WineNextStepsTabView()
    }
    .background(Color.surfacePrimary)
}
