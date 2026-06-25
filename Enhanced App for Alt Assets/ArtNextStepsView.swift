//
//  ArtNextStepsView.swift
//  Enhanced App for Alt Assets
//
//  Created by Victoria Case on 3/12/26.
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//
//  Description: Practical next-steps guide for users interested in art investing.
//  Covers key professionals to engage, essential reading, and online resources
//  for navigating the art market ecosystem.
//

import SwiftUI

// MARK: - Art Next Steps Tab View
struct ArtNextStepsTabView: View {
    @State private var expandedSections: Set<String> = []

    private let sections = ArtNextStepsData.allSections

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.lg) {
            // Header
            VStack(alignment: .leading, spacing: Spacing.sm) {
                Text("Your Next Steps")
                    .font(Typography.title2)
                    .foregroundColor(.textPrimary)
                    .padding(.top, Spacing.lg)

                Text("Navigating the art market requires the right relationships, research, and resources. Here is a practical guide to moving from learning to collecting.")
                    .font(Typography.body)
                    .foregroundColor(.textSecondary)
                    .lineSpacing(4)
            }
            .padding(.horizontal, Spacing.lg)

            // Expandable sections
            ForEach(sections) { section in
                nextStepsSectionView(section)
            }
            .padding(.horizontal, Spacing.lg)

            Spacer()
                .frame(height: Spacing.xxxl)
        }
    }

    // MARK: - Section View
    @ViewBuilder
    private func nextStepsSectionView(_ section: ArtNextStepsSection) -> some View {
        let isExpanded = expandedSections.contains(section.id)

        VStack(alignment: .leading, spacing: 0) {
            // Toggle header
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

            // Expanded content
            if isExpanded {
                VStack(alignment: .leading, spacing: Spacing.md) {
                    ForEach(section.items) { item in
                        nextStepsItemView(item)
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
    private func nextStepsItemView(_ item: ArtNextStepsItem) -> some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            // Title
            Text(item.title)
                .font(Typography.bodyMedium)
                .foregroundColor(.textPrimary)

            // Description
            Text(item.description)
                .font(Typography.body)
                .foregroundColor(.textSecondary)
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)

            // Practical tip
            if let tip = item.practicalTip {
                HStack(alignment: .top, spacing: Spacing.xs) {
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.caption)
                        .foregroundColor(.brandPrimary)
                        .padding(.top, 3)

                    Text(tip)
                        .font(Typography.caption)
                        .foregroundColor(.brandPrimary)
                        .italic()
                        .lineSpacing(2)
                }
                .padding(.top, Spacing.xxs)
            }

            // Source attribution
            if let source = item.source {
                Text(source)
                    .font(Typography.caption2)
                    .foregroundColor(.textTertiary)
                    .padding(.top, Spacing.xxs)
            }

            // Apple Books link
            if let urlString = item.appleBooksURL, let url = URL(string: urlString) {
                Link(destination: url) {
                    HStack(spacing: Spacing.xs) {
                        Image(systemName: "book.fill")
                            .font(.system(size: 11))
                        Text("View on Apple Books")
                            .font(Typography.caption)
                    }
                    .foregroundColor(.brandPrimary)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 12)
                    .background(Color.brandPrimary.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: CornerRadius.sm))
                }
                .padding(.top, Spacing.xs)
            }
        }
        .padding(.vertical, Spacing.sm)

        if item.id != "last" {
            Rectangle()
                .fill(Color.divider)
                .frame(height: 1)
        }
    }
}

// MARK: - Data Models
struct ArtNextStepsSection: Identifiable {
    let id: String
    let title: String
    let emoji: String
    let items: [ArtNextStepsItem]

    var itemCount: Int? {
        items.count > 1 ? items.count : nil
    }
}

struct ArtNextStepsItem: Identifiable {
    let id: String
    let title: String
    let description: String
    let practicalTip: String?
    let source: String?
    let appleBooksURL: String?

    init(id: String, title: String, description: String, practicalTip: String? = nil, source: String? = nil, appleBooksURL: String? = nil) {
        self.id = id
        self.title = title
        self.description = description
        self.practicalTip = practicalTip
        self.source = source
        self.appleBooksURL = appleBooksURL
    }
}

// MARK: - Art Next Steps Data
enum ArtNextStepsData {

    static var allSections: [ArtNextStepsSection] {
        [whoToTalkTo, essentialReading, practicalConsiderations, onlineResources]
    }

    // MARK: - Who to Talk To

    static let whoToTalkTo = ArtNextStepsSection(
        id: "who_to_talk_to",
        title: "Who to Talk To",
        emoji: "\u{1F91D}",
        items: [
            ArtNextStepsItem(
                id: "art_advisor",
                title: "Art Advisor",
                description: "Your most important relationship. An art advisor guides collectors in acquiring, managing, and valuing art based on market expertise. Unlike dealers, they represent your interests without directly selling works themselves. Galleries often give advisors a discount on works, and many advisors collect that discount as their fee \u{2014} meaning you pay no more than if you walked in off the street, but with the benefit of someone who has been in dozens of galleries over the past few months.",
                practicalTip: "Start with the Association of Professional Art Advisors (APAA). Their member directory lets you filter by specialty, media, and region.",
                source: nil
            ),
            ArtNextStepsItem(
                id: "gallerists",
                title: "Gallerists",
                description: "Gallerists represent living artists or their estates, and their primary job is to advance careers by securing institutional recognition. Once you have identified an artist \u{2014} say, after spotting their work in a smaller museum \u{2014} the gallery is your point of contact for acquisition. They will also be key when you eventually want to sell.",
                practicalTip: "Build genuine relationships. Gallerists prioritize collectors who support artists long-term over those looking to flip.",
                source: nil
            ),
            ArtNextStepsItem(
                id: "auction_specialists",
                title: "Auction House Specialists",
                description: "Sotheby's, Christie's, and Phillips all have private client teams and specialist departments (contemporary, post-war, etc.) who will speak with serious collectors. If you are buying with the intent to eventually sell through auction, building this relationship before you need it is smart.",
                practicalTip: "Attend auction previews. Even if you are not bidding, it builds familiarity with the process and the people.",
                source: nil
            ),
            ArtNextStepsItem(
                id: "appraiser",
                title: "Art Appraiser",
                description: "Separate from an advisor. You will want a certified appraiser for insurance, estate planning, and pre-sale valuations. Look for ASA (American Society of Appraisers) or AAA (Appraisers Association of America) credentials.",
                practicalTip: "Get appraisals updated every 2\u{2013}3 years, especially for appreciating works.",
                source: nil
            )
        ]
    )

    // MARK: - Essential Reading

    static let essentialReading = ArtNextStepsSection(
        id: "essential_reading",
        title: "Essential Reading",
        emoji: "\u{1F4DA}",
        items: [
            ArtNextStepsItem(
                id: "book_worth_of_art",
                title: "The Worth of Art",
                description: "By Arturo Cifuentes & Ventura Charlin (Columbia University Press, 2023). Uses empirical and quantitative methods to analyze art like any other asset class, covering portfolio management, art-secured lending, and auction guarantees. Probably the most rigorous, financially-focused book on art investing available.",
                practicalTip: nil,
                source: nil
            ),
            ArtNextStepsItem(
                id: "book_art_high_finance",
                title: "Art and High Finance (Collected Edition)",
                description: "By Clare McAndrew. A seminal work on the intersection of art and financial markets. Covers the economics of the art market, art as a financial asset, and the institutional frameworks that underpin art transactions. Essential context for understanding why this asset class behaves differently from equities or real estate.",
                practicalTip: nil,
                source: nil
            ),
            ArtNextStepsItem(
                id: "book_collectors_handbook",
                title: "The Art Collector's Handbook",
                description: "By Mary Rozell. Covers the practical mechanics of collecting: acquisition strategies, insurance, storage, conservation, art financing, and deaccessioning. Legally informed and highly practical \u{2014} essential for understanding the tax, lending, and storage considerations before you buy.",
                practicalTip: "Read this before your first significant purchase. It covers what most collectors learn the hard way.",
                source: nil,
                appleBooksURL: "https://books.apple.com/us/book/the-art-collectors-handbook/id1529188766?at=1000l3by8"
            ),
            ArtNextStepsItem(
                id: "book_skates",
                title: "Skate's Art Investment Handbook",
                description: "By Sergey Skaterschikov. Described by a Sotheby's Institute professor as indispensable for anyone researching the art market, pulling together hard-to-find statistics alongside original data.",
                practicalTip: nil,
                source: nil
            ),
            ArtNextStepsItem(
                id: "book_stuffed_shark",
                title: "The $12 Million Stuffed Shark",
                description: "By Don Thompson. An economist's deep dive into the psychology and economics of the contemporary art market. Essential for understanding why prices move and how branding, scarcity, and social signaling drive valuations.",
                practicalTip: nil,
                source: nil,
                appleBooksURL: "https://books.apple.com/us/book/the-$12-million-stuffed-shark/id499937665?at=1000l3by8"
            ),
            ArtNextStepsItem(
                id: "book_art_collecting_today",
                title: "Art Collecting Today",
                description: "By Doug Woodham. Written by an art financial consultant, it walks through how to evaluate artwork and covers tax and cultural property law \u{2014} valuable for long-term collecting and understanding the legal landscape.",
                practicalTip: nil,
                source: nil,
                appleBooksURL: "https://books.apple.com/us/book/art-collecting-today/id1448415792?at=1000l3by8"
            ),
            ArtNextStepsItem(
                id: "book_boom",
                title: "Boom: Mad Money, Mega Dealers, and the Rise of Contemporary Art",
                description: "By Michael Shnayerson. A primer on the opaque network that dealers like Gagosian and Zwirner cultivate \u{2014} the world you need to understand if you want to eventually sell through major channels.",
                practicalTip: nil,
                source: nil,
                appleBooksURL: "https://books.apple.com/us/book/boom/id1435036811?at=1000l3by8"
            )
        ]
    )

    // MARK: - Practical Considerations

    static let practicalConsiderations = ArtNextStepsSection(
        id: "practical_considerations",
        title: "Before You Buy",
        emoji: "\u{1F4CB}",
        items: [
            ArtNextStepsItem(
                id: "tax_implications",
                title: "Tax Implications",
                description: "Art is classified as a collectible by the IRS, subject to a maximum long-term capital gains rate of 28% (vs. 20% for equities). Sales tax varies by state and can apply at purchase. Donations to qualified institutions may offer fair market value deductions. Like-kind exchanges (1031) no longer apply to art after the 2017 Tax Cuts and Jobs Act. Consult a tax advisor experienced with collectibles.",
                practicalTip: "The Art Collector's Handbook (Rozell) and Art Collecting Today (Woodham) both dedicate chapters to this.",
                source: nil
            ),
            ArtNextStepsItem(
                id: "art_lending",
                title: "Art-Secured Lending",
                description: "Major lenders (Athena Art Finance, Sotheby's Financial Services, bank private wealth divisions) will lend against art collections, typically at 50\u{2013}60% loan-to-value. This allows collectors to access liquidity without selling. Requires professional appraisals and may require specific storage and insurance conditions.",
                practicalTip: "The Worth of Art (Cifuentes & Charlin) covers art-secured lending with quantitative rigor.",
                source: nil
            ),
            ArtNextStepsItem(
                id: "storage_conservation",
                title: "Storage and Conservation",
                description: "Professional art storage facilities (sometimes called freeports or bonded warehouses) offer climate-controlled environments, security, and in some jurisdictions, tax deferral on imports. Storage costs are ongoing and vary by size and medium. Conservation (cleaning, restoration, condition reports) is essential for maintaining value and should only be done by qualified conservators.",
                practicalTip: "Factor annual storage and insurance costs into your total cost of ownership before purchasing.",
                source: nil
            ),
            ArtNextStepsItem(
                id: "insurance",
                title: "Insurance",
                description: "Standard homeowner's policies rarely cover fine art adequately. Specialized art insurance (AXA XL, Chubb, PURE) provides wall-to-wall coverage including transit, exhibition loans, and natural disasters. Require regular appraisals to ensure coverage matches current market value.",
                practicalTip: nil,
                source: nil
            ),
            ArtNextStepsItem(
                id: "provenance_authentication",
                title: "Provenance and Authentication",
                description: "Before any significant purchase, verify the chain of ownership (provenance) and authenticity. For living artists, the gallery of record is the simplest verification. For secondary-market works, consult the catalogue raisonn\u{00E9} if one exists, and consider independent authentication services.",
                practicalTip: nil,
                source: nil
            )
        ]
    )

    // MARK: - Online Resources

    static let onlineResources = ArtNextStepsSection(
        id: "online_resources",
        title: "Online Resources",
        emoji: "\u{1F310}",
        items: [
            ArtNextStepsItem(
                id: "res_artnet_artprice",
                title: "Artnet and Artprice",
                description: "Auction price databases. Essential for researching what an artist's work has sold for historically before you buy. Artnet also provides market analytics and news coverage.",
                practicalTip: nil,
                source: nil
            ),
            ArtNextStepsItem(
                id: "res_artsy",
                title: "Artsy",
                description: "Research gallery representation and find who represents a specific artist. Also useful for discovering emerging artists through curated collections and fair previews.",
                practicalTip: nil,
                source: nil
            ),
            ArtNextStepsItem(
                id: "res_publications",
                title: "The Art Newspaper and Frieze",
                description: "Trade publications that track market trends and institutional recognition (museum shows, biennales). Institutional recognition directly affects resale value \u{2014} an artist with a solo show at a mid-tier museum, picked up by a reputable gallery, with work entering major private collections, is following a path that auction houses recognize.",
                practicalTip: nil,
                source: nil
            ),
            ArtNextStepsItem(
                id: "res_art_collecting",
                title: "art-collecting.com",
                description: "Directory of advisors, galleries, and appraisers by region. A practical starting point for finding professionals near you.",
                practicalTip: nil,
                source: nil
            )
        ]
    )
}

// MARK: - Preview
#Preview {
    ScrollView {
        ArtNextStepsTabView()
    }
    .background(Color.surfacePrimary)
}
