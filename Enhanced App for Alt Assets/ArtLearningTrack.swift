//
//  ArtLearningTrack.swift
//  Enhanced App for Alt Assets
//
//  Created by Victoria Case on 2/5/26.
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//
//  Description: Art-focused learning track as a specialized subsection.
//  Contains Art Concepts & Practices, Female Artists module, and Toolkit.
//  Designed as an offshoot learning experience for deeper art investing education.
//

import SwiftUI
import Combine

// MARK: - Art Learning Track Models

/// A specialized learning track focused on art investing
struct ArtLearningTrack: Identifiable, Codable {
    let id: String
    var title: String
    var subtitle: String
    var description: String
    var heroImage: String?  // Asset name or URL
    var modules: [ArtLesson]
    var estimatedDuration: Int  // in minutes
    var difficulty: DifficultyLevel

    enum DifficultyLevel: String, Codable, CaseIterable {
        case beginner = "Beginner"
        case intermediate = "Intermediate"
        case advanced = "Advanced"

        var color: Color {
            switch self {
            case .beginner: return .success
            case .intermediate: return .warning
            case .advanced: return .error
            }
        }

        var emoji: String {
            switch self {
            case .beginner: return "🌱"
            case .intermediate: return "🌿"
            case .advanced: return "🌳"
            }
        }
    }
}

/// Individual art lesson within the track
struct ArtLesson: Identifiable, Codable, Hashable {
    let id: String
    var number: Int
    var title: String
    var subtitle: String
    var emoji: String
    var sections: [ArtLessonSection]
    var keyTakeaways: [String]
    var estimatedMinutes: Int
    var isLocked: Bool
    var prerequisites: [String]  // Lesson IDs

    static func == (lhs: ArtLesson, rhs: ArtLesson) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

/// Section within an art lesson
struct ArtLessonSection: Identifiable, Codable, Hashable {
    let id: String
    var title: String
    var emoji: String
    var content: [ArtContentBlock]
}

/// Content block types for art lessons
enum ArtContentBlock: Identifiable, Codable, Hashable {
    case text(String)
    case heading(String)
    case bulletList([String])
    case numberedList([String])
    case quote(text: String, author: String?)
    case artwork(title: String, artist: String, year: String?, description: String)
    case terminology(term: String, definition: String)
    case callout(emoji: String, text: String)
    case divider

    var id: String {
        switch self {
        case .text(let s): return "text-\(s.prefix(20).hashValue)"
        case .heading(let s): return "heading-\(s.hashValue)"
        case .bulletList(let items): return "bullets-\(items.count)"
        case .numberedList(let items): return "numbered-\(items.count)"
        case .quote(let text, _): return "quote-\(text.prefix(20).hashValue)"
        case .artwork(let title, _, _, _): return "artwork-\(title.hashValue)"
        case .terminology(let term, _): return "term-\(term.hashValue)"
        case .callout(_, let text): return "callout-\(text.prefix(20).hashValue)"
        case .divider: return "divider-\(UUID().uuidString)"
        }
    }
}

// MARK: - Art Learning Track Manager
class ArtLearningTrackManager: ObservableObject {
    @Published var tracks: [ArtLearningTrack] = []
    @Published var userProgress: [String: ArtLessonProgress] = [:]  // lessonId -> progress

    static let shared = ArtLearningTrackManager()

    private let progressKey = "artLearningProgress"

    init() {
        loadTracks()
        loadProgress()
    }

    func loadTracks() {
        tracks = [
            createArtConceptsTrack(),
            createFemaleArtistsTrack(),
            createToolkitTrack()
        ]
    }

    // MARK: - Art Concepts & Practices Track
    private func createArtConceptsTrack() -> ArtLearningTrack {
        ArtLearningTrack(
            id: "art-concepts-track",
            title: "Art Concepts, Ideas & Practices",
            subtitle: "Module One",
            description: "Foundation course exploring the intersection of art appreciation and investment strategy. Learn how to evaluate art as both cultural artifact and financial asset.",
            heroImage: nil,
            modules: [
                ArtLesson(
                    id: "art-concepts-1",
                    number: 1,
                    title: "Understanding Art Value",
                    subtitle: "What makes art worth investing in?",
                    emoji: "🎨",
                    sections: [
                        ArtLessonSection(
                            id: "uc-intro",
                            title: "Introduction",
                            emoji: "📖",
                            content: [
                                .heading("The Dual Nature of Art"),
                                .text("Art exists in a unique space where cultural significance meets financial value. Unlike stocks or bonds, art carries emotional and historical weight that influences its worth."),
                                .callout(emoji: "💡", text: "Art is the only asset class where the story behind the piece directly impacts its market value.")
                            ]
                        ),
                        ArtLessonSection(
                            id: "uc-value-factors",
                            title: "Factors That Determine Value",
                            emoji: "⚖️",
                            content: [
                                .heading("Key Value Drivers"),
                                .bulletList([
                                    "Provenance: The documented history of ownership",
                                    "Authenticity: Verified attribution to the artist",
                                    "Condition: Physical state and conservation history",
                                    "Rarity: Scarcity within the artist's body of work",
                                    "Historical Significance: Cultural and art historical importance",
                                    "Market Demand: Current collector interest and trends"
                                ]),
                                .terminology(term: "Provenance", definition: "The documented chain of ownership of an artwork from its creation to the present day. Strong provenance increases value and reduces risk."),
                                .terminology(term: "Catalogue Raisonné", definition: "A comprehensive, scholarly catalog of all known works by an artist, used to verify authenticity.")
                            ]
                        )
                    ],
                    keyTakeaways: [
                        "Art value combines aesthetic, historical, and market factors",
                        "Provenance is crucial for both authenticity and value",
                        "Understanding the art market requires different skills than traditional investing"
                    ],
                    estimatedMinutes: 15,
                    isLocked: false,
                    prerequisites: []
                ),
                ArtLesson(
                    id: "art-concepts-2",
                    number: 2,
                    title: "Art Market Fundamentals",
                    subtitle: "How the art market works",
                    emoji: "📊",
                    sections: [
                        ArtLessonSection(
                            id: "amf-primary",
                            title: "Primary vs Secondary Markets",
                            emoji: "🏛️",
                            content: [
                                .heading("Two Markets, Two Approaches"),
                                .text("The art market operates through two distinct channels, each with different dynamics and opportunities."),
                                .terminology(term: "Primary Market", definition: "Where artworks are sold for the first time, typically through galleries representing living artists."),
                                .terminology(term: "Secondary Market", definition: "Where previously owned artworks are resold, typically through auction houses or private sales."),
                                .callout(emoji: "📈", text: "The secondary market is where price transparency exists — auction results are public, while gallery prices often remain confidential.")
                            ]
                        ),
                        ArtLessonSection(
                            id: "amf-players",
                            title: "Key Market Players",
                            emoji: "👥",
                            content: [
                                .heading("Who Shapes the Market?"),
                                .numberedList([
                                    "Galleries: Represent artists, set primary market prices, cultivate collectors",
                                    "Auction Houses: Christie's, Sotheby's, Phillips dominate secondary sales",
                                    "Art Advisors: Guide collectors through purchases and collection building",
                                    "Museums: Validate artists through exhibitions, rarely sell (deaccessioning)",
                                    "Collectors: From individual enthusiasts to institutional buyers"
                                ])
                            ]
                        )
                    ],
                    keyTakeaways: [
                        "Primary market = buying from galleries; Secondary = resale through auctions",
                        "Auction results provide the only transparent pricing data",
                        "Multiple stakeholders influence an artist's market position"
                    ],
                    estimatedMinutes: 20,
                    isLocked: false,
                    prerequisites: ["art-concepts-1"]
                ),
                ArtLesson(
                    id: "art-concepts-3",
                    number: 3,
                    title: "Evaluating Artwork",
                    subtitle: "Developing your collector's eye",
                    emoji: "👁️",
                    sections: [
                        ArtLessonSection(
                            id: "ea-looking",
                            title: "How to Look at Art",
                            emoji: "🔍",
                            content: [
                                .heading("Beyond First Impressions"),
                                .text("Developing an eye for art requires both knowledge and practice. Here's a framework for evaluation:"),
                                .numberedList([
                                    "Initial Response: What do you feel? Trust your intuition.",
                                    "Formal Analysis: Composition, color, technique, scale",
                                    "Contextual Research: Artist's career, art historical significance",
                                    "Market Analysis: Comparable sales, price trajectory",
                                    "Condition Assessment: Conservation needs, display requirements"
                                ]),
                                .callout(emoji: "🪞", text: "The best collectors combine passion with pragmatism — loving what you buy while understanding its market position.")
                            ]
                        )
                    ],
                    keyTakeaways: [
                        "Combine emotional response with analytical evaluation",
                        "Research the artist's career trajectory and market history",
                        "Always verify condition and authenticity before purchasing"
                    ],
                    estimatedMinutes: 18,
                    isLocked: false,
                    prerequisites: ["art-concepts-2"]
                )
            ],
            estimatedDuration: 53,
            difficulty: .beginner
        )
    }

    // MARK: - Female Artists Track
    private func createFemaleArtistsTrack() -> ArtLearningTrack {
        ArtLearningTrack(
            id: "female-artists-track",
            title: "Female Artists: An Overlooked Asset Class",
            subtitle: "Special Module",
            description: "Exploring the historical undervaluation and emerging recognition of women artists. Learn why female artists represent a unique investment opportunity with cultural impact.",
            heroImage: nil,
            modules: [
                ArtLesson(
                    id: "female-artists-1",
                    number: 1,
                    title: "The Historical Gap",
                    subtitle: "Why women artists were overlooked",
                    emoji: "📜",
                    sections: [
                        ArtLessonSection(
                            id: "hg-history",
                            title: "Centuries of Exclusion",
                            emoji: "🏛️",
                            content: [
                                .heading("Understanding the Gap"),
                                .text("For centuries, women were systematically excluded from formal art education, major exhibitions, and institutional recognition. This created a market where female artists were dramatically undervalued."),
                                .quote(text: "The story of art has been told predominantly by men, about men, for men. We're only now beginning to rewrite that narrative.", author: "Museum Curator"),
                                .bulletList([
                                    "Women were barred from life drawing classes until the late 19th century",
                                    "Major museums historically collected few works by women",
                                    "Art historical canons excluded or minimized female contributions",
                                    "Gallery representation favored male artists"
                                ])
                            ]
                        ),
                        ArtLessonSection(
                            id: "hg-data",
                            title: "The Numbers Tell the Story",
                            emoji: "📊",
                            content: [
                                .heading("Market Data"),
                                .callout(emoji: "📈", text: "Works by female artists have historically sold for 47% less than comparable works by male artists at auction."),
                                .text("However, this gap represents opportunity. As institutions and collectors actively seek to diversify their holdings, demand for works by women artists is accelerating faster than the broader market."),
                                .terminology(term: "Correction Rally", definition: "When an undervalued sector experiences rapid price appreciation as the market recognizes its true value.")
                            ]
                        )
                    ],
                    keyTakeaways: [
                        "Historical exclusion created systematic undervaluation",
                        "The price gap between male and female artists represents opportunity",
                        "Institutional collecting priorities are actively shifting"
                    ],
                    estimatedMinutes: 12,
                    isLocked: false,
                    prerequisites: []
                ),
                ArtLesson(
                    id: "female-artists-2",
                    number: 2,
                    title: "Artists to Know",
                    subtitle: "Key figures driving market change",
                    emoji: "🌟",
                    sections: [
                        ArtLessonSection(
                            id: "atk-historical",
                            title: "Historical Rediscoveries",
                            emoji: "🔮",
                            content: [
                                .heading("Rediscovered Masters"),
                                .artwork(
                                    title: "Self-Portrait as the Allegory of Painting",
                                    artist: "Artemisia Gentileschi",
                                    year: "1638-39",
                                    description: "Baroque master whose powerful narratives and technical skill rival her male contemporaries. Prices have increased 10x over the past two decades."
                                ),
                                .artwork(
                                    title: "The Horse Fair",
                                    artist: "Rosa Bonheur",
                                    year: "1852-55",
                                    description: "One of the most famous paintings of the 19th century, yet Bonheur remains undervalued relative to male Realists."
                                ),
                                .text("These artists achieved recognition in their lifetimes but were subsequently written out of art history. Their market \"rediscovery\" offers lessons for identifying undervalued contemporary artists.")
                            ]
                        ),
                        ArtLessonSection(
                            id: "atk-contemporary",
                            title: "Contemporary Market Leaders",
                            emoji: "🚀",
                            content: [
                                .heading("Breaking Records"),
                                .bulletList([
                                    "Jenny Saville: First living female artist to break $10M at auction",
                                    "Yayoi Kusama: Global phenomenon with museum-level demand",
                                    "Julie Mehretu: Abstract paintings commanding $5-10M+",
                                    "Cecily Brown: Leading figure in contemporary painting market"
                                ]),
                                .callout(emoji: "💡", text: "Study the career trajectories of successful female artists to identify patterns that might predict future market leaders.")
                            ]
                        )
                    ],
                    keyTakeaways: [
                        "Historical female artists offer value relative to male peers",
                        "Contemporary women artists are breaking auction records",
                        "Career trajectory patterns can help identify emerging talent"
                    ],
                    estimatedMinutes: 15,
                    isLocked: false,
                    prerequisites: ["female-artists-1"]
                ),
                ArtLesson(
                    id: "female-artists-3",
                    number: 3,
                    title: "Building a Collection",
                    subtitle: "Strategic approaches to collecting women artists",
                    emoji: "🎯",
                    sections: [
                        ArtLessonSection(
                            id: "bc-strategy",
                            title: "Collection Strategies",
                            emoji: "📋",
                            content: [
                                .heading("Approaches to Consider"),
                                .numberedList([
                                    "Thematic Focus: Collect around movements, periods, or themes",
                                    "Emerging Artists: Support early-career female artists with gallery representation",
                                    "Historical Rediscovery: Acquire works by undervalued historical figures",
                                    "Blue-Chip Pivot: Add established female artists to diversify traditional collections"
                                ]),
                                .text("Each approach carries different risk/reward profiles. Emerging artists offer higher potential returns with greater uncertainty, while established artists provide more stability.")
                            ]
                        ),
                        ArtLessonSection(
                            id: "bc-impact",
                            title: "Impact Collecting",
                            emoji: "🌍",
                            content: [
                                .heading("Values-Aligned Investing"),
                                .text("Collecting women artists allows you to align financial goals with values. By supporting female artists, you contribute to:"),
                                .bulletList([
                                    "Correcting historical market imbalances",
                                    "Supporting living artists' careers and livelihoods",
                                    "Influencing museum collections and art historical narratives",
                                    "Creating more equitable representation in the art world"
                                ]),
                                .callout(emoji: "✨", text: "Impact and return are not mutually exclusive — the market correction for female artists suggests both can be achieved.")
                            ]
                        )
                    ],
                    keyTakeaways: [
                        "Multiple strategies exist for building a collection focused on women artists",
                        "Risk/reward varies by approach — from emerging to established",
                        "Values-aligned collecting can complement financial goals"
                    ],
                    estimatedMinutes: 14,
                    isLocked: false,
                    prerequisites: ["female-artists-2"]
                )
            ],
            estimatedDuration: 41,
            difficulty: .intermediate
        )
    }

    // MARK: - Toolkit Track
    private func createToolkitTrack() -> ArtLearningTrack {
        ArtLearningTrack(
            id: "art-toolkit-track",
            title: "The Art Investor's Toolkit",
            subtitle: "Practical Guide",
            description: "Hands-on tools, resources, and frameworks for making informed art investment decisions. From due diligence checklists to market research techniques.",
            heroImage: nil,
            modules: [
                ArtLesson(
                    id: "toolkit-1",
                    number: 1,
                    title: "Research Resources",
                    subtitle: "Where to find information",
                    emoji: "🔍",
                    sections: [
                        ArtLessonSection(
                            id: "rr-databases",
                            title: "Price Databases",
                            emoji: "💰",
                            content: [
                                .heading("Auction Price Research"),
                                .bulletList([
                                    "Artnet: Comprehensive auction price database (subscription required)",
                                    "Artprice: Global auction results and market reports",
                                    "MutualArt: Free tier available with limited results",
                                    "Invaluable: Focuses on more accessible price points"
                                ]),
                                .callout(emoji: "⚠️", text: "Auction prices don't tell the whole story. Gallery sales and private transactions are often conducted at different price levels."),
                                .terminology(term: "Hammer Price", definition: "The winning bid at auction, before buyer's premium and taxes are added."),
                                .terminology(term: "Buyer's Premium", definition: "Fee charged by auction houses to buyers, typically 20-26% on top of hammer price.")
                            ]
                        ),
                        ArtLessonSection(
                            id: "rr-research",
                            title: "Artist Research",
                            emoji: "📚",
                            content: [
                                .heading("Due Diligence Sources"),
                                .numberedList([
                                    "Artist's CV: Exhibition history, collections, awards",
                                    "Gallery Representation: Quality and stability of gallery relationships",
                                    "Museum Holdings: Which institutions own their work",
                                    "Critical Reception: Reviews, catalog essays, scholarly attention",
                                    "Market Trajectory: Price trends over time"
                                ])
                            ]
                        )
                    ],
                    keyTakeaways: [
                        "Multiple price databases exist — cross-reference for accuracy",
                        "Auction data is only part of the pricing picture",
                        "Artist research should cover career, market, and critical reception"
                    ],
                    estimatedMinutes: 12,
                    isLocked: false,
                    prerequisites: []
                ),
                ArtLesson(
                    id: "toolkit-2",
                    number: 2,
                    title: "Due Diligence Checklist",
                    subtitle: "Before you buy",
                    emoji: "✅",
                    sections: [
                        ArtLessonSection(
                            id: "dd-checklist",
                            title: "Pre-Purchase Checklist",
                            emoji: "📋",
                            content: [
                                .heading("Essential Questions"),
                                .numberedList([
                                    "Authenticity: Is the work authenticated? By whom?",
                                    "Provenance: Can ownership history be documented?",
                                    "Condition: Has a conservator examined the work?",
                                    "Title: Are there any liens, claims, or ownership disputes?",
                                    "Import/Export: Are there any restrictions on moving the work?",
                                    "Comparables: What have similar works sold for recently?",
                                    "Why Selling: Is the seller's motivation clear and reasonable?"
                                ]),
                                .callout(emoji: "🚨", text: "If a deal seems too good to be true, it usually is. Trust your instincts and do extra due diligence.")
                            ]
                        ),
                        ArtLessonSection(
                            id: "dd-red-flags",
                            title: "Red Flags",
                            emoji: "🚩",
                            content: [
                                .heading("Warning Signs"),
                                .bulletList([
                                    "Pressure to buy quickly without time for research",
                                    "Reluctance to provide provenance documentation",
                                    "Price significantly below market with no clear explanation",
                                    "Seller unwilling to allow independent condition assessment",
                                    "Missing or incomplete authenticity documentation",
                                    "Stories that don't add up about ownership history"
                                ])
                            ]
                        )
                    ],
                    keyTakeaways: [
                        "Never skip due diligence, regardless of the price point",
                        "Red flags should prompt additional investigation or walking away",
                        "Documentation protects your investment"
                    ],
                    estimatedMinutes: 15,
                    isLocked: false,
                    prerequisites: ["toolkit-1"]
                ),
                ArtLesson(
                    id: "toolkit-3",
                    number: 3,
                    title: "Working with Professionals",
                    subtitle: "Building your team",
                    emoji: "🤝",
                    sections: [
                        ArtLessonSection(
                            id: "wwp-team",
                            title: "Your Art Advisory Team",
                            emoji: "👥",
                            content: [
                                .heading("Key Relationships"),
                                .bulletList([
                                    "Art Advisor: Strategic guidance, market access, negotiation",
                                    "Conservator: Condition assessment and care recommendations",
                                    "Art Lawyer: Contracts, title issues, estate planning",
                                    "Insurance Specialist: Coverage for fine art collections",
                                    "Art Storage/Shipping: Proper handling and climate control"
                                ]),
                                .terminology(term: "Art Advisor", definition: "Professional who provides guidance on building and managing art collections, often with access to off-market opportunities."),
                                .text("For emerging collectors, an art advisor can provide invaluable guidance. For larger collections, a full team becomes essential.")
                            ]
                        ),
                        ArtLessonSection(
                            id: "wwp-costs",
                            title: "Understanding Costs",
                            emoji: "💵",
                            content: [
                                .heading("Beyond the Purchase Price"),
                                .numberedList([
                                    "Buyer's Premium: 20-26% at major auction houses",
                                    "Sales Tax: Varies by jurisdiction, sometimes avoidable",
                                    "Insurance: 0.1-0.5% of value annually",
                                    "Storage: $50-500+ per month depending on size and requirements",
                                    "Conservation: As needed, can be significant for older works",
                                    "Advisory Fees: 5-10% of purchase price or retainer"
                                ]),
                                .callout(emoji: "📊", text: "Factor in carrying costs when calculating potential returns. Art isn't free to own.")
                            ]
                        )
                    ],
                    keyTakeaways: [
                        "Building relationships with professionals is essential as collections grow",
                        "Total cost of ownership extends well beyond purchase price",
                        "The right advisor can provide access and guidance worth their fee"
                    ],
                    estimatedMinutes: 14,
                    isLocked: false,
                    prerequisites: ["toolkit-2"]
                )
            ],
            estimatedDuration: 41,
            difficulty: .intermediate
        )
    }

    // MARK: - Progress Management
    func loadProgress() {
        if let data = UserDefaults.standard.data(forKey: progressKey),
           let progress = try? JSONDecoder().decode([String: ArtLessonProgress].self, from: data) {
            userProgress = progress
        }
    }

    func saveProgress() {
        if let data = try? JSONEncoder().encode(userProgress) {
            UserDefaults.standard.set(data, forKey: progressKey)
        }
    }

    func markLessonComplete(_ lessonId: String) {
        var progress = userProgress[lessonId] ?? ArtLessonProgress(lessonId: lessonId)
        progress.isComplete = true
        progress.completedAt = Date()
        userProgress[lessonId] = progress
        saveProgress()
    }

    func isLessonComplete(_ lessonId: String) -> Bool {
        userProgress[lessonId]?.isComplete ?? false
    }

    func trackProgress(for trackId: String) -> Double {
        guard let track = tracks.first(where: { $0.id == trackId }) else { return 0 }
        let completedCount = track.modules.filter { isLessonComplete($0.id) }.count
        return Double(completedCount) / Double(track.modules.count)
    }
}

// MARK: - Art Lesson Progress
struct ArtLessonProgress: Codable {
    let lessonId: String
    var isComplete: Bool = false
    var sectionsViewed: [String] = []
    var completedAt: Date?
    var timeSpent: Int = 0  // seconds
}

// MARK: - Art Track Overview View
struct ArtTrackOverviewView: View {
    @ObservedObject var trackManager = ArtLearningTrackManager.shared

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.xl) {
                    // Header
                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        Text("🖼️")
                            .font(.system(size: 40))

                        Text("Art Learning Track")
                            .font(Typography.title1)
                            .foregroundColor(.textPrimary)

                        Text("Specialized courses for understanding art as an investment. A deeper exploration beyond the main curriculum.")
                            .font(Typography.body)
                            .foregroundColor(.textSecondary)
                    }
                    .padding(.horizontal, Spacing.lg)

                    // Track Cards
                    ForEach(trackManager.tracks) { track in
                        NavigationLink(destination: ArtTrackDetailView(track: track)) {
                            ArtTrackCard(track: track)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, Spacing.lg)
                }
                .padding(.vertical, Spacing.lg)
            }
            .background(Color.surfacePrimary)
            .navigationTitle("Art Investing")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
            #endif
        }
    }
}

// MARK: - Art Track Card
struct ArtTrackCard: View {
    let track: ArtLearningTrack
    @ObservedObject var trackManager = ArtLearningTrackManager.shared

    var progress: Double {
        trackManager.trackProgress(for: track.id)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(track.subtitle)
                        .font(Typography.caption)
                        .foregroundColor(.textTertiary)

                    Text(track.title)
                        .font(Typography.title3)
                        .foregroundColor(.textPrimary)
                        .multilineTextAlignment(.leading)
                }

                Spacer()

                // Difficulty badge
                HStack(spacing: 4) {
                    Text(track.difficulty.emoji)
                    Text(track.difficulty.rawValue)
                        .font(Typography.caption2)
                }
                .foregroundColor(track.difficulty.color)
                .padding(.horizontal, Spacing.sm)
                .padding(.vertical, Spacing.xs)
                .background(track.difficulty.color.opacity(0.1))
                .clipShape(Capsule())
            }

            // Description
            Text(track.description)
                .font(Typography.body)
                .foregroundColor(.textSecondary)
                .lineLimit(2)

            // Progress and metadata
            HStack(spacing: Spacing.md) {
                // Lessons count
                HStack(spacing: Spacing.xs) {
                    Text("📚")
                    Text("\(track.modules.count) lessons")
                        .font(Typography.caption)
                        .foregroundColor(.textTertiary)
                }

                // Duration
                HStack(spacing: Spacing.xs) {
                    Text("⏱️")
                    Text("\(track.estimatedDuration) min")
                        .font(Typography.caption)
                        .foregroundColor(.textTertiary)
                }

                Spacer()

                // Progress indicator
                if progress > 0 {
                    HStack(spacing: Spacing.xs) {
                        ProgressView(value: progress)
                            .frame(width: 50)
                            .tint(.brandPrimary)
                        Text("\(Int(progress * 100))%")
                            .font(Typography.caption2)
                            .foregroundColor(.textTertiary)
                    }
                }
            }

            // Arrow indicator
            HStack {
                Spacer()
                Image(systemName: "arrow.right")
                    .font(.caption)
                    .foregroundColor(.brandPrimary)
            }
        }
        .padding(Spacing.lg)
        .background(Color.surfaceSecondary)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.lg))
    }
}

// MARK: - Art Track Detail View
struct ArtTrackDetailView: View {
    let track: ArtLearningTrack
    @ObservedObject var trackManager = ArtLearningTrackManager.shared

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                // Track header
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    HStack {
                        Text(track.difficulty.emoji)
                        Text(track.difficulty.rawValue)
                            .font(Typography.caption)
                    }
                    .foregroundColor(track.difficulty.color)

                    Text(track.description)
                        .font(Typography.body)
                        .foregroundColor(.textSecondary)

                    HStack(spacing: Spacing.lg) {
                        Label("\(track.modules.count) lessons", systemImage: "book.fill")
                        Label("\(track.estimatedDuration) min", systemImage: "clock.fill")
                    }
                    .font(Typography.caption)
                    .foregroundColor(.textTertiary)
                }
                .padding(Spacing.lg)
                .background(Color.surfaceSecondary)
                .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))

                // Lessons
                Text("Lessons")
                    .font(Typography.title3)
                    .foregroundColor(.textPrimary)

                ForEach(track.modules) { lesson in
                    NavigationLink(destination: ArtLessonView(lesson: lesson)) {
                        ArtLessonRow(lesson: lesson, isComplete: trackManager.isLessonComplete(lesson.id))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(Spacing.lg)
        }
        .background(Color.surfacePrimary)
        .navigationTitle(track.title)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.large)
        #endif
    }
}

// MARK: - Art Lesson Row
struct ArtLessonRow: View {
    let lesson: ArtLesson
    let isComplete: Bool

    var body: some View {
        HStack(spacing: Spacing.md) {
            // Lesson number with status
            ZStack {
                Circle()
                    .fill(isComplete ? Color.success : Color.surfaceTertiary)
                    .frame(width: 40, height: 40)

                if isComplete {
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                        .font(.system(size: 14, weight: .bold))
                } else {
                    Text("\(lesson.number)")
                        .font(Typography.bodyMedium)
                        .foregroundColor(.textSecondary)
                }
            }

            // Lesson info
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                HStack(spacing: Spacing.xs) {
                    Text(lesson.emoji)
                    Text(lesson.title)
                        .font(Typography.bodyMedium)
                        .foregroundColor(.textPrimary)
                }

                Text(lesson.subtitle)
                    .font(Typography.caption)
                    .foregroundColor(.textTertiary)

                HStack(spacing: Spacing.sm) {
                    Label("\(lesson.estimatedMinutes) min", systemImage: "clock")
                    Label("\(lesson.sections.count) sections", systemImage: "list.bullet")
                }
                .font(Typography.caption2)
                .foregroundColor(.textTertiary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.textTertiary)
        }
        .padding(Spacing.md)
        .background(Color.surfaceSecondary)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
    }
}

// MARK: - Art Lesson View
struct ArtLessonView: View {
    let lesson: ArtLesson
    @ObservedObject var trackManager = ArtLearningTrackManager.shared
    @State private var currentSectionIndex = 0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.xl) {
                // Lesson header
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    HStack {
                        Text(lesson.emoji)
                            .font(.system(size: 32))
                        Text("Lesson \(lesson.number)")
                            .font(Typography.caption)
                            .foregroundColor(.textTertiary)
                    }

                    Text(lesson.title)
                        .font(Typography.title2)
                        .foregroundColor(.textPrimary)

                    Text(lesson.subtitle)
                        .font(Typography.body)
                        .foregroundColor(.textSecondary)
                }

                // Sections
                ForEach(lesson.sections) { section in
                    ArtSectionView(section: section)
                }

                // Key Takeaways
                if !lesson.keyTakeaways.isEmpty {
                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        HStack(spacing: Spacing.sm) {
                            Text("💡")
                            Text("Key Takeaways")
                                .font(Typography.title3)
                                .foregroundColor(.textPrimary)
                        }

                        ForEach(lesson.keyTakeaways, id: \.self) { takeaway in
                            HStack(alignment: .top, spacing: Spacing.sm) {
                                Text("•")
                                    .foregroundColor(.brandPrimary)
                                Text(takeaway)
                                    .font(Typography.body)
                                    .foregroundColor(.textSecondary)
                            }
                        }
                    }
                    .padding(Spacing.md)
                    .background(Color.brandPrimary.opacity(0.05))
                    .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
                }

                // Complete button
                if !trackManager.isLessonComplete(lesson.id) {
                    Button {
                        trackManager.markLessonComplete(lesson.id)
                    } label: {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Mark as Complete")
                        }
                        .font(Typography.bodyMedium)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(Spacing.md)
                        .background(Color.brandPrimary)
                        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
                    }
                } else {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.success)
                        Text("Lesson Complete")
                            .font(Typography.bodyMedium)
                            .foregroundColor(.success)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(Spacing.md)
                    .background(Color.success.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
                }
            }
            .padding(Spacing.lg)
        }
        .background(Color.surfacePrimary)
        .navigationTitle(lesson.title)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

// MARK: - Art Section View
struct ArtSectionView: View {
    let section: ArtLessonSection

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            // Section header
            HStack(spacing: Spacing.sm) {
                Text(section.emoji)
                    .font(.system(size: 18))
                Text(section.title)
                    .font(Typography.bodyMedium)
                    .foregroundColor(.textPrimary)
            }

            // Content blocks
            ForEach(section.content) { block in
                ArtContentBlockView(block: block)
            }
        }
        .padding(Spacing.md)
        .background(Color.surfaceSecondary)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
    }
}

// MARK: - Art Content Block View
struct ArtContentBlockView: View {
    let block: ArtContentBlock

    var body: some View {
        switch block {
        case .text(let text):
            Text(text)
                .font(Typography.body)
                .foregroundColor(.textSecondary)

        case .heading(let text):
            Text(text)
                .font(Typography.title3)
                .foregroundColor(.textPrimary)
                .padding(.top, Spacing.sm)

        case .bulletList(let items):
            VStack(alignment: .leading, spacing: Spacing.xs) {
                ForEach(items, id: \.self) { item in
                    HStack(alignment: .top, spacing: Spacing.sm) {
                        Text("•")
                            .foregroundColor(.brandPrimary)
                        Text(item)
                            .font(Typography.body)
                            .foregroundColor(.textSecondary)
                    }
                }
            }

        case .numberedList(let items):
            VStack(alignment: .leading, spacing: Spacing.xs) {
                ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                    HStack(alignment: .top, spacing: Spacing.sm) {
                        Text("\(index + 1).")
                            .font(Typography.bodyMedium)
                            .foregroundColor(.brandPrimary)
                            .frame(width: 20, alignment: .trailing)
                        Text(item)
                            .font(Typography.body)
                            .foregroundColor(.textSecondary)
                    }
                }
            }

        case .quote(let text, let author):
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text("\u{201C}\(text)\u{201D}")
                    .font(Typography.body)
                    .italic()
                    .foregroundColor(.textSecondary)
                if let author = author {
                    Text("— \(author)")
                        .font(Typography.caption)
                        .foregroundColor(.textTertiary)
                }
            }
            .padding(Spacing.md)
            .background(Color.surfaceTertiary.opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.sm))

        case .artwork(let title, let artist, let year, let description):
            VStack(alignment: .leading, spacing: Spacing.sm) {
                HStack {
                    Text("🖼️")
                    Text(title)
                        .font(Typography.bodyMedium)
                        .foregroundColor(.textPrimary)
                }
                Text("\(artist)\(year != nil ? ", \(year!)" : "")")
                    .font(Typography.caption)
                    .foregroundColor(.brandPrimary)
                Text(description)
                    .font(Typography.body)
                    .foregroundColor(.textSecondary)
            }
            .padding(Spacing.md)
            .background(Color.brandPrimary.opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.sm))

        case .terminology(let term, let definition):
            HStack(alignment: .top, spacing: Spacing.sm) {
                Text("📖")
                VStack(alignment: .leading, spacing: 2) {
                    Text(term)
                        .font(Typography.bodyMedium)
                        .foregroundColor(.textPrimary)
                    Text(definition)
                        .font(Typography.caption)
                        .foregroundColor(.textSecondary)
                }
            }
            .padding(Spacing.sm)
            .background(Color.info.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.sm))

        case .callout(let emoji, let text):
            HStack(alignment: .top, spacing: Spacing.sm) {
                Text(emoji)
                    .font(.system(size: 18))
                Text(text)
                    .font(Typography.body)
                    .foregroundColor(.textSecondary)
            }
            .padding(Spacing.md)
            .background(Color.warning.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.sm))

        case .divider:
            Divider()
                .padding(.vertical, Spacing.sm)
        }
    }
}

// MARK: - Preview
#Preview("Art Track Overview") {
    ArtTrackOverviewView()
}

#Preview("Art Track Card") {
    ArtTrackCard(track: ArtLearningTrackManager.shared.tracks[0])
        .padding()
        .background(Color.surfacePrimary)
}
