//
//  ArtNFTDeFiBridge.swift
//  Enhanced App for Alt Assets
//
//  Created by Victoria Case on 2/5/26.
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//
//  Description: A condensed learning session that bridges Art, NFTs, and DeFi.
//  Distills key facts and connections between traditional art investing
//  and the digital asset world. Designed as quick-digest format.
//

import SwiftUI
import Combine

// MARK: - Bridge Topic
struct BridgeTopic: Identifiable {
    let id: String
    var title: String
    var emoji: String
    var keyFact: String
    var details: String
    var connections: [String] // How it connects to other topics
    var source: String?
}

// MARK: - Bridge Section
struct BridgeSection: Identifiable {
    let id: String
    var title: String
    var subtitle: String
    var emoji: String
    var topics: [BridgeTopic]
    var transitionNote: String? // Note about how this section connects to the next
}

// MARK: - Art → NFT → DeFi Bridge Manager
class ArtNFTDeFiBridgeManager: ObservableObject {
    @Published var sections: [BridgeSection] = []
    @Published var viewedTopics: Set<String> = []

    static let shared = ArtNFTDeFiBridgeManager()

    private let progressKey = "artNftDefiBridgeProgress"

    init() {
        loadSections()
        loadProgress()
    }

    func loadSections() {
        sections = [
            // SECTION 1: Traditional Art Value
            BridgeSection(
                id: "art-value",
                title: "Art as Asset",
                subtitle: "Why art holds value",
                emoji: "🎨",
                topics: [
                    BridgeTopic(
                        id: "art-1",
                        title: "Art Market Size",
                        emoji: "📊",
                        keyFact: "The global art market was valued at $65 billion in 2023, declining to $57.5 billion in 2024",
                        details: "According to the Art Basel and UBS Global Art Market Report, the market contracted by 12% in 2024. The US remains the largest market at $27.2 billion, followed by China at $12.2 billion and the UK at $10.9 billion.",
                        connections: ["Provenance", "Scarcity", "Store of Value"],
                        source: "Art Basel & UBS Global Art Market Report 2024"
                    ),
                    BridgeTopic(
                        id: "art-2",
                        title: "Provenance = Value",
                        emoji: "📜",
                        keyFact: "Documented ownership history can dramatically increase artwork value",
                        details: "Provenance establishes authenticity and adds historical narrative. Example: Leonardo da Vinci's Salvator Mundi, traced to King Charles I's royal collection, sold for $450 million in 2017. Gaps in provenance can reduce value or make works difficult to sell.",
                        connections: ["Blockchain verification", "NFT provenance", "Immutable records"],
                        source: "Artefact Fine Art; Christie's auction records"
                    ),
                    BridgeTopic(
                        id: "art-3",
                        title: "Authentication Challenge",
                        emoji: "🔍",
                        keyFact: "Estimates suggest 20-40% of art may be misattributed, though experts debate these figures",
                        details: "Thomas Hoving (former Met director) estimated ~40% of art he saw was fake. Switzerland's Fine Art Expert Institute claimed 50% of circulating art is fake. However, others argue 95%+ of museum pieces are correctly attributed. The wide range reflects detection difficulty.",
                        connections: ["NFT certificates", "Blockchain verification", "Smart contracts"],
                        source: "Salon; Artnet News; Fine Art Expert Institute 2014"
                    ),
                    BridgeTopic(
                        id: "art-4",
                        title: "Fractional Ownership",
                        emoji: "🧩",
                        keyFact: "Traditional fractional art ownership has existed since the 1970s",
                        details: "Companies have offered shares in valuable artworks for decades, but with high minimums, illiquidity, and complex legal structures. Digital fractionalization now offers lower barriers.",
                        connections: ["Tokenization", "NFT fractionalization", "DeFi liquidity"]
                    )
                ],
                transitionNote: "These traditional art market concepts translate directly to digital assets..."
            ),

            // SECTION 2: The NFT Bridge
            BridgeSection(
                id: "nft-bridge",
                title: "NFTs: Digital Provenance",
                subtitle: "How blockchain transforms art ownership",
                emoji: "🌉",
                topics: [
                    BridgeTopic(
                        id: "nft-1",
                        title: "What NFTs Actually Do",
                        emoji: "💎",
                        keyFact: "NFTs create verifiable, immutable proof of ownership on the blockchain",
                        details: "Non-Fungible Tokens aren't the art itself—they're certificates of authenticity and ownership stored on a decentralized ledger that can't be altered or forged.",
                        connections: ["Traditional provenance", "Certificate of authenticity", "Blockchain"]
                    ),
                    BridgeTopic(
                        id: "nft-2",
                        title: "Beeple's $69M Sale",
                        emoji: "🎯",
                        keyFact: "Beeple's 'Everydays: The First 5000 Days' sold for $69.3M at Christie's on March 11, 2021",
                        details: "The first purely digital NFT sold by a major auction house. Purchased by Vignesh Sundaresan (MetaKovan). The work comprises 5,000 images made over 13 years, making Beeple the third-most expensive living artist at the time.",
                        connections: ["Auction houses", "Traditional art market", "Digital art value"],
                        source: "Christie's Auction; Artnet News; NPR, March 2021"
                    ),
                    BridgeTopic(
                        id: "nft-3",
                        title: "Smart Contract Royalties",
                        emoji: "💰",
                        keyFact: "Artists can set royalties of 2.5-10% on secondary sales, though enforcement varies",
                        details: "The mean NFT royalty rate is ~7.35%. However, major platforms like OpenSea moved to optional royalties in 2023. Only 60-70% of secondary trades reliably pay royalties due to platform fragmentation. Over 63% of active creators still earn more from royalties than initial mints.",
                        connections: ["Smart contracts", "DeFi automation", "Artist empowerment"],
                        source: "CoinLaw NFT Royalties Statistics 2025; OpenSea"
                    ),
                    BridgeTopic(
                        id: "nft-4",
                        title: "Physical + Digital",
                        emoji: "🔗",
                        keyFact: "NFTs can link to physical artworks, creating hybrid authentication",
                        details: "Some artists and galleries now pair physical works with NFT certificates, combining traditional ownership with blockchain verification.",
                        connections: ["Traditional art", "Hybrid assets", "Provenance bridge"]
                    ),
                    BridgeTopic(
                        id: "nft-5",
                        title: "Fractionalized NFTs",
                        emoji: "📊",
                        keyFact: "High-value NFTs can be split into tradeable tokens via platforms like Fractional.art and Unicly",
                        details: "Fractionalization allows broader participation in valuable digital art. Platforms like Fractional.art host 1100+ NFT vaults including CryptoPunks. However, major marketplaces don't yet fully support fractionalized NFTs, limiting liquidity.",
                        connections: ["Fractional art ownership", "DeFi tokens", "Liquidity pools"],
                        source: "CoinGape; Fractional.art; BitDegree 2025"
                    )
                ],
                transitionNote: "NFTs bridge into the broader DeFi ecosystem through tokenization and liquidity..."
            ),

            // SECTION 3: DeFi Integration
            BridgeSection(
                id: "defi-integration",
                title: "DeFi: Unlocking Liquidity",
                subtitle: "How decentralized finance transforms art assets",
                emoji: "⛓️",
                topics: [
                    BridgeTopic(
                        id: "defi-1",
                        title: "NFTs as Collateral",
                        emoji: "🏦",
                        keyFact: "NFTs can be used as collateral for short-term DeFi loans on platforms like NFTfi and Zharta",
                        details: "Platforms allow NFT owners to borrow against their digital art without selling. Key limitations: loan-to-value ratios are strict (30-50%), terms are short (7-90 days), and only certain NFT collections qualify. NFTfi offers no auto-liquidations, while peer-to-pool models provide faster funding.",
                        connections: ["Traditional art loans", "Smart contracts", "Liquidity"],
                        source: "NFTfi; Zharta; CoinLaw NFT Lending Statistics 2026"
                    ),
                    BridgeTopic(
                        id: "defi-2",
                        title: "Instant Liquidity",
                        emoji: "⚡",
                        keyFact: "DeFi enables 24/7 trading of art-backed tokens globally",
                        details: "Unlike traditional art that can take months to sell through galleries or auctions, tokenized art assets can be traded on decentralized exchanges. However, liquidity varies significantly by collection and platform support remains fragmented.",
                        connections: ["Traditional illiquidity", "DEX trading", "Global access"]
                    ),
                    BridgeTopic(
                        id: "defi-3",
                        title: "DAOs for Art",
                        emoji: "🏛️",
                        keyFact: "DAOs have collectively raised millions for art acquisitions",
                        details: "PleasrDAO acquired culturally significant pieces including a rare Wu-Tang Clan album and Edward Snowden's $5M NFT. ConstitutionDAO raised $47 million in one week to bid on a US Constitution copy (outbid at $43.2M by Ken Griffin). DAOs enable collective ownership governed by token voting.",
                        connections: ["Collective investing", "Governance tokens", "Democratized collecting"],
                        source: "PleasrDAO; Artnet News; Center for Art Law"
                    ),
                    BridgeTopic(
                        id: "defi-4",
                        title: "Yield on Art",
                        emoji: "🌱",
                        keyFact: "Some fractionalized NFT tokens can be staked for yield, though options are limited",
                        details: "Platforms like Unicly integrate AMMs and yield farming into NFT trading. Fractionalized tokens can be provided as liquidity to earn returns. This space is still evolving with regulatory uncertainty.",
                        connections: ["Yield farming", "Liquidity provision", "Passive income"],
                        source: "Unicly; CoinGape"
                    ),
                    BridgeTopic(
                        id: "defi-5",
                        title: "Programmable Ownership",
                        emoji: "🔧",
                        keyFact: "Smart contracts enable complex ownership structures automatically",
                        details: "Time-locked releases, conditional transfers, automatic royalty splits, and governance rights can all be encoded and enforced without intermediaries.",
                        connections: ["Smart contracts", "Automation", "Trust minimization"]
                    )
                ],
                transitionNote: nil
            ),

            // SECTION 4: Key Connections Summary
            BridgeSection(
                id: "connections",
                title: "Connecting the Dots",
                subtitle: "Key parallels and transformations",
                emoji: "🔗",
                topics: [
                    BridgeTopic(
                        id: "conn-1",
                        title: "Provenance → Blockchain",
                        emoji: "📜→⛓️",
                        keyFact: "Paper provenance becomes immutable on-chain history",
                        details: "What once required expert verification and physical documentation now lives permanently on a public ledger, viewable by anyone, forgeable by no one.",
                        connections: []
                    ),
                    BridgeTopic(
                        id: "conn-2",
                        title: "Gallery → DEX",
                        emoji: "🏛️→💱",
                        keyFact: "Gatekept access becomes permissionless markets",
                        details: "Traditional galleries curate who can buy. Decentralized exchanges allow anyone with a wallet to participate, removing geographic and social barriers.",
                        connections: []
                    ),
                    BridgeTopic(
                        id: "conn-3",
                        title: "Expert Opinion → Smart Contract",
                        emoji: "👔→📝",
                        keyFact: "Human judgment becomes code-enforced rules",
                        details: "Authentication, royalties, and ownership transfers that required lawyers and experts now execute automatically based on predefined conditions.",
                        connections: []
                    ),
                    BridgeTopic(
                        id: "conn-4",
                        title: "Illiquid → Liquid",
                        emoji: "🏔️→🌊",
                        keyFact: "Multi-year holding periods become instant trading",
                        details: "Art that once required finding the right buyer over months can be tokenized and traded in seconds on global, 24/7 markets.",
                        connections: []
                    ),
                    BridgeTopic(
                        id: "conn-5",
                        title: "Exclusive → Inclusive",
                        emoji: "🔒→🔓",
                        keyFact: "High minimums become fractional participation",
                        details: "Masterpieces once accessible only to the ultra-wealthy can now be owned in fractions by anyone, democratizing art investment.",
                        connections: []
                    )
                ],
                transitionNote: nil
            )
        ]
    }

    // MARK: - Progress
    func loadProgress() {
        if let data = UserDefaults.standard.data(forKey: progressKey),
           let viewed = try? JSONDecoder().decode(Set<String>.self, from: data) {
            viewedTopics = viewed
        }
    }

    func saveProgress() {
        if let data = try? JSONEncoder().encode(viewedTopics) {
            UserDefaults.standard.set(data, forKey: progressKey)
        }
    }

    func markTopicViewed(_ topicId: String) {
        viewedTopics.insert(topicId)
        saveProgress()
    }

    var totalTopics: Int {
        sections.reduce(0) { $0 + $1.topics.count }
    }

    var viewedCount: Int {
        viewedTopics.count
    }

    var progress: Double {
        guard totalTopics > 0 else { return 0 }
        return Double(viewedCount) / Double(totalTopics)
    }
}

// MARK: - Bridge Overview View
struct ArtNFTDeFiBridgeView: View {
    @ObservedObject var manager = ArtNFTDeFiBridgeManager.shared

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                // Header
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    HStack(spacing: Spacing.sm) {
                        Text("🎨")
                        Text("→")
                            .foregroundColor(.textTertiary)
                        Text("🌉")
                        Text("→")
                            .foregroundColor(.textTertiary)
                        Text("⛓️")
                    }
                    .font(.system(size: 28))

                    Text("Art → NFT → DeFi")
                        .font(Typography.title1)
                        .foregroundColor(.textPrimary)

                    Text("A quick-digest journey from traditional art to decentralized finance")
                        .font(Typography.body)
                        .foregroundColor(.textSecondary)
                }
                .padding(.horizontal, Spacing.lg)

                // Progress
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    HStack {
                        Text("Progress")
                            .font(Typography.captionMedium)
                            .foregroundColor(.textTertiary)
                        Spacer()
                        Text("\(manager.viewedCount)/\(manager.totalTopics) facts")
                            .font(Typography.caption)
                            .foregroundColor(.textSecondary)
                    }

                    ProgressView(value: manager.progress)
                        .tint(.brandPrimary)
                }
                .padding(.horizontal, Spacing.lg)

                // Sections
                ForEach(manager.sections) { section in
                    BridgeSectionView(section: section)
                }
            }
            .padding(.vertical, Spacing.lg)
        }
        .background(Color.surfacePrimary)
        .navigationTitle("Art → DeFi")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

// MARK: - Bridge Section View
struct BridgeSectionView: View {
    let section: BridgeSection
    @State private var isExpanded = true

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            // Section Header
            Button {
                withAnimation(.spring(response: 0.3)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack(spacing: Spacing.sm) {
                    Text(section.emoji)
                        .font(.system(size: 24))

                    VStack(alignment: .leading, spacing: 2) {
                        Text(section.title)
                            .font(Typography.bodyMedium)
                            .foregroundColor(.textPrimary)
                        Text(section.subtitle)
                            .font(Typography.caption)
                            .foregroundColor(.textTertiary)
                    }

                    Spacer()

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundColor(.textTertiary)
                }
                .padding(.horizontal, Spacing.lg)
            }
            .buttonStyle(.plain)

            if isExpanded {
                // Topics
                VStack(spacing: Spacing.sm) {
                    ForEach(section.topics) { topic in
                        BridgeTopicCard(topic: topic)
                    }
                }
                .padding(.horizontal, Spacing.lg)

                // Transition Note
                if let note = section.transitionNote {
                    HStack(spacing: Spacing.sm) {
                        Image(systemName: "arrow.down")
                            .font(.caption)
                            .foregroundColor(.brandPrimary)
                        Text(note)
                            .font(Typography.caption)
                            .foregroundColor(.textTertiary)
                            .italic()
                    }
                    .padding(.horizontal, Spacing.lg)
                    .padding(.vertical, Spacing.sm)
                }
            }
        }
    }
}

// MARK: - Bridge Topic Card
struct BridgeTopicCard: View {
    let topic: BridgeTopic
    @ObservedObject var manager = ArtNFTDeFiBridgeManager.shared
    @State private var isExpanded = false

    var isViewed: Bool {
        manager.viewedTopics.contains(topic.id)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header (always visible)
            Button {
                withAnimation(.spring(response: 0.3)) {
                    isExpanded.toggle()
                    if isExpanded {
                        manager.markTopicViewed(topic.id)
                    }
                }
            } label: {
                HStack(alignment: .top, spacing: Spacing.sm) {
                    Text(topic.emoji)
                        .font(.system(size: 18))

                    VStack(alignment: .leading, spacing: Spacing.xs) {
                        Text(topic.title)
                            .font(Typography.bodyMedium)
                            .foregroundColor(.textPrimary)

                        Text(topic.keyFact)
                            .font(Typography.body)
                            .foregroundColor(.brandPrimary)
                            .lineLimit(isExpanded ? nil : 2)
                    }

                    Spacer()

                    VStack {
                        if isViewed {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.success)
                                .font(.system(size: 14))
                        }

                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .font(.caption)
                            .foregroundColor(.textTertiary)
                    }
                }
                .padding(Spacing.md)
            }
            .buttonStyle(.plain)

            // Expanded Content
            if isExpanded {
                Divider()
                    .padding(.horizontal, Spacing.md)

                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Text(topic.details)
                        .font(Typography.body)
                        .foregroundColor(.textSecondary)

                    if !topic.connections.isEmpty {
                        HStack(spacing: Spacing.xs) {
                            Text("🔗")
                                .font(.system(size: 12))
                            Text("Connects to:")
                                .font(Typography.caption2)
                                .foregroundColor(.textTertiary)
                        }

                        FlowLayout(spacing: Spacing.xs) {
                            ForEach(topic.connections, id: \.self) { connection in
                                Text(connection)
                                    .font(Typography.caption2)
                                    .foregroundColor(.info)
                                    .padding(.horizontal, Spacing.xs)
                                    .padding(.vertical, 2)
                                    .background(Color.info.opacity(0.1))
                                    .clipShape(Capsule())
                            }
                        }
                    }

                    if let source = topic.source {
                        Text("Source: \(source)")
                            .font(Typography.caption2)
                            .foregroundColor(.textTertiary)
                    }
                }
                .padding(Spacing.md)
            }
        }
        .background(Color.surfaceSecondary)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
    }
}

// MARK: - Quick Facts View (Alternative presentation)
struct QuickFactsCarouselView: View {
    @ObservedObject var manager = ArtNFTDeFiBridgeManager.shared
    @State private var currentIndex = 0

    var allTopics: [BridgeTopic] {
        manager.sections.flatMap { $0.topics }
    }

    var body: some View {
        VStack(spacing: Spacing.lg) {
            // Carousel
            TabView(selection: $currentIndex) {
                ForEach(Array(allTopics.enumerated()), id: \.element.id) { index, topic in
                    QuickFactCard(topic: topic)
                        .tag(index)
                }
            }
            #if os(iOS)
            .tabViewStyle(.page(indexDisplayMode: .automatic))
            #endif
            .frame(height: 300)

            // Progress dots
            HStack(spacing: Spacing.xs) {
                ForEach(0..<allTopics.count, id: \.self) { index in
                    Circle()
                        .fill(index == currentIndex ? Color.brandPrimary : Color.surfaceTertiary)
                        .frame(width: 8, height: 8)
                }
            }

            // Navigation
            HStack {
                Button {
                    withAnimation {
                        currentIndex = max(0, currentIndex - 1)
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .padding(Spacing.md)
                        .background(Color.surfaceSecondary)
                        .clipShape(Circle())
                }
                .disabled(currentIndex == 0)

                Spacer()

                Text("\(currentIndex + 1) of \(allTopics.count)")
                    .font(Typography.caption)
                    .foregroundColor(.textTertiary)

                Spacer()

                Button {
                    withAnimation {
                        currentIndex = min(allTopics.count - 1, currentIndex + 1)
                        manager.markTopicViewed(allTopics[currentIndex].id)
                    }
                } label: {
                    Image(systemName: "chevron.right")
                        .padding(Spacing.md)
                        .background(Color.surfaceSecondary)
                        .clipShape(Circle())
                }
                .disabled(currentIndex == allTopics.count - 1)
            }
            .padding(.horizontal, Spacing.lg)
        }
        .padding(.vertical, Spacing.lg)
        .background(Color.surfacePrimary)
    }
}

// MARK: - Quick Fact Card
struct QuickFactCard: View {
    let topic: BridgeTopic

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            // Emoji and title
            HStack(spacing: Spacing.sm) {
                Text(topic.emoji)
                    .font(.system(size: 32))
                Text(topic.title)
                    .font(Typography.title3)
                    .foregroundColor(.textPrimary)
            }

            // Key fact (highlighted)
            Text(topic.keyFact)
                .font(Typography.body)
                .foregroundColor(.brandPrimary)
                .padding(Spacing.md)
                .background(Color.brandPrimary.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: CornerRadius.sm))

            // Details
            Text(topic.details)
                .font(Typography.caption)
                .foregroundColor(.textSecondary)
                .lineLimit(4)

            Spacer()
        }
        .padding(Spacing.lg)
        .background(Color.surfaceSecondary)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.lg))
        .padding(.horizontal, Spacing.lg)
    }
}

// MARK: - Preview
#Preview("Art → NFT → DeFi Bridge") {
    NavigationStack {
        ArtNFTDeFiBridgeView()
    }
}

#Preview("Quick Facts Carousel") {
    QuickFactsCarouselView()
}
