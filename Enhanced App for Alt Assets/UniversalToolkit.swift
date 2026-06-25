//
//  UniversalToolkit.swift
//  Enhanced App for Alt Assets
//
//  Created by Victoria Case on 2/5/26.
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//
//  Description: Universal investor's toolkit accessible from all modules.
//  Provides research resources, due diligence checklists, and professional
//  guidance applicable across all alternative asset classes.
//

import SwiftUI
import Combine

// MARK: - Toolkit Category
enum ToolkitCategory: String, CaseIterable, Identifiable {
    case research = "Research"
    case dueDiligence = "Due Diligence"
    case professionals = "Professionals"
    case riskManagement = "Risk Management"
    case taxLegal = "Tax & Legal"

    var id: String { rawValue }

    var emoji: String {
        switch self {
        case .research: return "🔍"
        case .dueDiligence: return "✅"
        case .professionals: return "🤝"
        case .riskManagement: return "⚖️"
        case .taxLegal: return "📋"
        }
    }

    var color: Color {
        switch self {
        case .research: return .info
        case .dueDiligence: return .success
        case .professionals: return .brandPrimary
        case .riskManagement: return .warning
        case .taxLegal: return .brandAccent
        }
    }
}

// MARK: - Toolkit Item
struct ToolkitItem: Identifiable {
    let id: String
    var title: String
    var description: String
    var category: ToolkitCategory
    var details: [ToolkitDetail]
    var applicableTo: [String] // Asset classes this applies to
}

struct ToolkitDetail: Identifiable {
    let id = UUID().uuidString
    var heading: String?
    var content: String
    var isBulletList: Bool = false
    var bullets: [String] = []
    var isWarning: Bool = false
    var isTip: Bool = false
}

// MARK: - Universal Toolkit Manager
class UniversalToolkitManager: ObservableObject {
    @Published var items: [ToolkitItem] = []

    static let shared = UniversalToolkitManager()

    init() {
        loadItems()
    }

    func loadItems() {
        items = [
            // MARK: - Professionals (Advisor Questions first)
            ToolkitItem(
                id: "prof-advisor-questions",
                title: "Discussion Questions for Your Advisor",
                description: "Prepared questions to evaluate your advisor's expertise across asset classes",
                category: .professionals,
                details: [
                    ToolkitDetail(content: "Knowing what to ask is just as important as finding the right advisor. These question sets help you evaluate competency, spot red flags, and have more productive conversations.", isTip: true)
                ],
                applicableTo: ["DeFi", "Crypto", "ESG", "Climate"]
            ),

            // MARK: - Research Tools
            ToolkitItem(
                id: "research-artist",
                title: "Asset Research Framework",
                description: "How to research any alternative asset before investing",
                category: .research,
                details: [
                    ToolkitDetail(heading: "Key Research Areas", content: "", isBulletList: true, bullets: [
                        "Track Record: Historical performance and provenance",
                        "Market Position: Current standing and trajectory",
                        "Comparable Analysis: Similar assets and their values",
                        "Expert Opinions: Reviews, ratings, scholarly attention",
                        "Liquidity Profile: How easily can this be sold?"
                    ]),
                    ToolkitDetail(heading: "For Art", content: "Research artist CV, exhibition history, museum holdings, critical reception, and auction records."),
                    ToolkitDetail(heading: "For DeFi/Crypto", content: "Review protocol audits, team background, tokenomics, TVL (Total Value Locked), and community activity."),
                    ToolkitDetail(heading: "For Private Equity", content: "Analyze fund manager track record, strategy, fee structure, and portfolio company performance.")
                ],
                applicableTo: ["Art", "Private Equity", "Crypto", "DeFi", "NFTs", "Collectibles"]
            ),

            // MARK: - Due Diligence
            ToolkitItem(
                id: "dd-checklist",
                title: "Universal Due Diligence Checklist",
                description: "Essential questions before any alternative investment",
                category: .dueDiligence,
                details: [
                    ToolkitDetail(heading: "Authenticity & Legitimacy", content: "", isBulletList: true, bullets: [
                        "Is the asset/protocol verified and authenticated?",
                        "Who performed the verification? Are they reputable?",
                        "Can ownership/provenance be documented?",
                        "For DeFi: Has the smart contract been audited?"
                    ]),
                    ToolkitDetail(heading: "Condition & Security", content: "", isBulletList: true, bullets: [
                        "Physical assets: What is the condition? Conservation needs?",
                        "Digital assets: Is the wallet/custody solution secure?",
                        "Are there any liens, claims, or disputes?"
                    ]),
                    ToolkitDetail(heading: "Market & Liquidity", content: "", isBulletList: true, bullets: [
                        "What have comparable assets sold for recently?",
                        "How liquid is this market? Time to exit?",
                        "What are the transaction costs (fees, commissions)?"
                    ]),
                    ToolkitDetail(heading: "Seller/Counterparty", content: "", isBulletList: true, bullets: [
                        "Why is the seller/issuer offering this?",
                        "Is their motivation clear and reasonable?",
                        "What's their reputation in the market?"
                    ]),
                    ToolkitDetail(content: "If a deal seems too good to be true, it usually is. Trust your instincts and do extra due diligence.", isWarning: true)
                ],
                applicableTo: ["Art", "Private Equity", "Crypto", "DeFi", "NFTs", "Collectibles", "Real Estate"]
            ),

            ToolkitItem(
                id: "dd-red-flags",
                title: "Red Flags to Watch For",
                description: "Warning signs across all alternative investments",
                category: .dueDiligence,
                details: [
                    ToolkitDetail(heading: "Universal Red Flags", content: "", isBulletList: true, bullets: [
                        "Pressure to buy/invest quickly without time for research",
                        "Reluctance to provide documentation or verification",
                        "Price significantly below market with no clear explanation",
                        "Promises of guaranteed returns (nothing is guaranteed)",
                        "Lack of transparency about fees, risks, or terms",
                        "Stories that don't add up or change over time"
                    ]),
                    ToolkitDetail(heading: "DeFi-Specific Red Flags", content: "", isBulletList: true, bullets: [
                        "Anonymous team with no verifiable track record",
                        "Unaudited smart contracts",
                        "Unrealistic APY promises (>100% often unsustainable)",
                        "Token economics that heavily favor insiders",
                        "No clear use case beyond speculation"
                    ]),
                    ToolkitDetail(heading: "Art-Specific Red Flags", content: "", isBulletList: true, bullets: [
                        "Missing or incomplete provenance",
                        "Seller won't allow independent condition assessment",
                        "No certificate of authenticity from recognized expert",
                        "Gallery not willing to provide written guarantees"
                    ])
                ],
                applicableTo: ["Art", "Private Equity", "Crypto", "DeFi", "NFTs", "Collectibles"]
            ),

            // MARK: - Professionals
            ToolkitItem(
                id: "prof-team",

                title: "Building Your Advisory Team",
                description: "Key professionals for alternative investments",
                category: .professionals,
                details: [
                    ToolkitDetail(heading: "Core Team Members", content: "", isBulletList: true, bullets: [
                        "Investment Advisor: Strategic guidance, portfolio construction",
                        "Tax Professional: Crypto/alternative asset tax expertise",
                        "Legal Counsel: Contracts, regulations, estate planning",
                        "Insurance Specialist: Coverage for valuable assets"
                    ]),
                    ToolkitDetail(heading: "Specialized by Asset Class", content: ""),
                    ToolkitDetail(heading: "Art & Collectibles", content: "", isBulletList: true, bullets: [
                        "Art Advisor: Collection building, market access",
                        "Conservator: Condition assessment and care",
                        "Appraiser: Valuations for insurance and tax"
                    ]),
                    ToolkitDetail(heading: "DeFi & Digital Assets", content: "", isBulletList: true, bullets: [
                        "Crypto Tax Specialist: On-chain transaction reporting",
                        "Security Auditor: Smart contract review",
                        "Custody Solution Provider: Secure asset storage"
                    ]),
                    ToolkitDetail(content: "For emerging collectors/investors, start with one trusted advisor. As your portfolio grows, expand your team.", isTip: true)
                ],
                applicableTo: ["Art", "Private Equity", "Crypto", "DeFi", "NFTs", "Collectibles", "Real Estate"]
            ),

            ToolkitItem(
                id: "prof-costs",
                title: "Understanding Total Costs",
                description: "Beyond the purchase price: all-in costs by asset class",
                category: .professionals,
                details: [
                    ToolkitDetail(heading: "Art & Collectibles", content: "", isBulletList: true, bullets: [
                        "Buyer's Premium: 20-26% at major auction houses",
                        "Sales Tax: Varies by jurisdiction",
                        "Insurance: 0.1-0.5% of value annually",
                        "Storage: $50-500+/month depending on size",
                        "Conservation: As needed, can be significant",
                        "Advisory Fees: 5-10% of purchase or retainer"
                    ]),
                    ToolkitDetail(heading: "DeFi & Crypto", content: "", isBulletList: true, bullets: [
                        "Gas Fees: Network transaction costs (can fluctuate wildly)",
                        "Exchange Fees: 0.1-1% per trade",
                        "Custody Fees: 0-0.5% annually (varies by solution)",
                        "Tax Preparation: Crypto tax software + professional",
                        "Slippage: Price movement during large trades"
                    ]),
                    ToolkitDetail(heading: "Private Equity", content: "", isBulletList: true, bullets: [
                        "Management Fee: 1.5-2% annually",
                        "Performance Fee (Carry): 20% of profits above hurdle",
                        "Fund Expenses: Legal, audit, admin",
                        "Capital Call Requirements: Must have liquidity ready"
                    ]),
                    ToolkitDetail(content: "Factor in all carrying costs when calculating potential returns. Alternative assets aren't free to own.", isWarning: true)
                ],
                applicableTo: ["Art", "Private Equity", "Crypto", "DeFi", "NFTs", "Collectibles"]
            ),

            // MARK: - Risk Management
            ToolkitItem(
                id: "risk-framework",
                title: "Risk Assessment Framework",
                description: "Evaluating risk across alternative investments",
                category: .riskManagement,
                details: [
                    ToolkitDetail(heading: "Key Risk Categories", content: "", isBulletList: true, bullets: [
                        "Market Risk: Price volatility and market conditions",
                        "Liquidity Risk: Difficulty selling quickly at fair value",
                        "Counterparty Risk: Other parties failing to meet obligations",
                        "Operational Risk: Technical failures, human error",
                        "Regulatory Risk: Changing laws and regulations",
                        "Concentration Risk: Too much in one asset/sector"
                    ]),
                    ToolkitDetail(heading: "DeFi-Specific Risks", content: "", isBulletList: true, bullets: [
                        "Smart Contract Risk: Bugs or exploits in code",
                        "Oracle Risk: Incorrect external data feeds",
                        "Impermanent Loss: LP position value changes",
                        "Rug Pull Risk: Malicious project abandonment",
                        "Regulatory Uncertainty: Evolving legal landscape"
                    ]),
                    ToolkitDetail(heading: "Art-Specific Risks", content: "", isBulletList: true, bullets: [
                        "Authentication Risk: Forgeries and misattributions",
                        "Condition Risk: Physical deterioration",
                        "Taste Risk: Changing collector preferences",
                        "Storage/Handling Risk: Damage or loss"
                    ])
                ],
                applicableTo: ["Art", "Private Equity", "Crypto", "DeFi", "NFTs", "Collectibles", "Real Estate"]
            ),

            ToolkitItem(
                id: "risk-position",
                title: "Position Sizing Guidelines",
                description: "How much to allocate to alternative investments",
                category: .riskManagement,
                details: [
                    ToolkitDetail(heading: "General Guidelines", content: "", isBulletList: true, bullets: [
                        "Alternative assets: 5-20% of total portfolio (varies by risk tolerance)",
                        "No single position > 5% of total portfolio",
                        "High-risk positions (DeFi, early-stage): Only what you can afford to lose",
                        "Maintain liquidity reserve for capital calls and opportunities"
                    ]),
                    ToolkitDetail(heading: "By Risk Level", content: ""),
                    ToolkitDetail(content: "Conservative: 5-10% alternatives, focus on established assets"),
                    ToolkitDetail(content: "Moderate: 10-15% alternatives, mix of established and emerging"),
                    ToolkitDetail(content: "Aggressive: 15-25% alternatives, includes higher-risk positions"),
                    ToolkitDetail(content: "Never invest more than you can afford to lose in any single alternative asset. These markets can be highly volatile.", isWarning: true)
                ],
                applicableTo: ["Art", "Private Equity", "Crypto", "DeFi", "NFTs", "Collectibles", "Real Estate"]
            ),

            // MARK: - Tax & Legal
            ToolkitItem(
                id: "tax-considerations",
                title: "Tax Considerations Overview",
                description: "Key tax issues for alternative investments",
                category: .taxLegal,
                details: [
                    ToolkitDetail(heading: "General Principles", content: "", isBulletList: true, bullets: [
                        "Capital gains apply to most alternative asset sales",
                        "Holding period matters: Short-term vs long-term rates",
                        "Cost basis tracking is essential",
                        "Consult a tax professional for your specific situation"
                    ]),
                    ToolkitDetail(heading: "Crypto & DeFi", content: "", isBulletList: true, bullets: [
                        "Every trade is potentially a taxable event",
                        "Staking rewards may be taxable as income when received",
                        "Airdrops often taxable at fair market value",
                        "DeFi yields may be ordinary income or capital gains",
                        "Record-keeping is critical and complex"
                    ]),
                    ToolkitDetail(heading: "Art & Collectibles", content: "", isBulletList: true, bullets: [
                        "Collectibles taxed at higher 28% rate (US)",
                        "Like-kind exchanges no longer apply (post-2017)",
                        "Charitable donations can provide tax benefits",
                        "Estate planning considerations for collections"
                    ]),
                    ToolkitDetail(content: "Tax laws vary by jurisdiction and change frequently. Always consult a qualified tax professional.", isWarning: true)
                ],
                applicableTo: ["Art", "Private Equity", "Crypto", "DeFi", "NFTs", "Collectibles", "Real Estate"]
            ),

            ToolkitItem(
                id: "legal-docs",
                title: "Essential Legal Documents",
                description: "Key documents to understand and retain",
                category: .taxLegal,
                details: [
                    ToolkitDetail(heading: "For All Alternative Investments", content: "", isBulletList: true, bullets: [
                        "Purchase/Sale Agreements",
                        "Proof of Ownership/Title",
                        "Condition Reports",
                        "Insurance Policies",
                        "Appraisals and Valuations"
                    ]),
                    ToolkitDetail(heading: "Private Funds", content: "", isBulletList: true, bullets: [
                        "Limited Partnership Agreement (LPA)",
                        "Private Placement Memorandum (PPM)",
                        "Subscription Documents",
                        "Capital Call Notices",
                        "K-1 Tax Forms"
                    ]),
                    ToolkitDetail(heading: "Art & Collectibles", content: "", isBulletList: true, bullets: [
                        "Certificate of Authenticity",
                        "Provenance Documentation",
                        "Condition Reports",
                        "Export/Import Certificates",
                        "Conservation Records"
                    ]),
                    ToolkitDetail(heading: "DeFi & Crypto", content: "", isBulletList: true, bullets: [
                        "Wallet addresses and transaction records",
                        "Smart contract addresses",
                        "Exchange statements",
                        "Tax lot tracking records",
                        "Recovery phrase backup (secure location)"
                    ])
                ],
                applicableTo: ["Art", "Private Equity", "Crypto", "DeFi", "NFTs", "Collectibles", "Real Estate"]
            ),

            // MARK: - Reference Databases
            ToolkitItem(
                id: "research-databases",
                title: "Price & Market Databases",
                description: "Essential resources for market research across asset classes",
                category: .research,
                details: [
                    ToolkitDetail(heading: "Art Market", content: "", isBulletList: true, bullets: [
                        "Artnet: Comprehensive auction price database (subscription)",
                        "Artprice: Global auction results and market reports",
                        "MutualArt: Free tier with limited results",
                        "Invaluable: Accessible price points"
                    ]),
                    ToolkitDetail(heading: "Alternative Assets", content: "", isBulletList: true, bullets: [
                        "Preqin: Private equity and hedge fund data",
                        "PitchBook: Venture capital and M&A data",
                        "Cambridge Associates: Benchmark data",
                        "Burgiss: Private capital analytics"
                    ]),
                    ToolkitDetail(heading: "Digital Assets / DeFi", content: "", isBulletList: true, bullets: [
                        "CoinGecko: Cryptocurrency prices and market data",
                        "DeFi Llama: DeFi protocol analytics",
                        "Dune Analytics: On-chain data dashboards",
                        "Nansen: Blockchain analytics"
                    ]),
                    ToolkitDetail(content: "Auction prices don't tell the whole story. Gallery sales and private transactions often occur at different price levels.", isWarning: true)
                ],
                applicableTo: ["Art", "Private Equity", "Crypto", "DeFi", "NFTs"]
            ),

            ToolkitItem(
                id: "research-policy-papers",
                title: "Policy Paper Library",
                description: "Curated policy papers and research from regulators, think tanks, and institutions",
                category: .research,
                details: [
                    ToolkitDetail(content: "Browse policy papers from central banks, regulators, and research institutions covering alternative assets, DeFi, ESG, and financial markets.", isTip: true)
                ],
                applicableTo: ["Art", "Private Equity", "Crypto", "DeFi", "ESG", "NFTs", "Climate"]
            )
        ]
    }

    func items(for category: ToolkitCategory) -> [ToolkitItem] {
        items.filter { $0.category == category }
    }

    func items(for assetClass: String) -> [ToolkitItem] {
        items.filter { $0.applicableTo.contains(assetClass) }
    }
}

// MARK: - Universal Toolkit View
struct UniversalToolkitView: View {
    @ObservedObject var manager = UniversalToolkitManager.shared
    @State private var selectedCategory: ToolkitCategory?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                // Header
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Text("🧰")
                        .font(.system(size: 40))

                    Text("Investor's Toolkit")
                        .font(Typography.title1)
                        .foregroundColor(.textPrimary)

                    Text("Essential resources, checklists, and guidance for all alternative investments")
                        .font(Typography.body)
                        .foregroundColor(.textSecondary)
                }
                .padding(.horizontal, Spacing.lg)

                // Category Tabs
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: Spacing.sm) {
                        ForEach(ToolkitCategory.allCases) { category in
                            ToolkitCategoryTab(
                                category: category,
                                isSelected: selectedCategory == category
                            ) {
                                withAnimation(.spring(response: 0.3)) {
                                    selectedCategory = selectedCategory == category ? nil : category
                                }
                            }
                        }
                    }
                    .padding(.horizontal, Spacing.lg)
                }

                // Items
                let displayedItems: [ToolkitItem] = {
                    guard let category = selectedCategory else { return manager.items }
                    return manager.items(for: category)
                }()

                LazyVStack(spacing: Spacing.md) {
                    ForEach(displayedItems) { item in
                        NavigationLink(destination: toolkitDestination(for: item)) {
                            ToolkitItemCard(item: item)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, Spacing.lg)
            }
            .padding(.vertical, Spacing.lg)
        }
        .background(Color.surfacePrimary)
        .navigationTitle("Toolkit")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    @ViewBuilder
    private func toolkitDestination(for item: ToolkitItem) -> some View {
        if item.id == "prof-advisor-questions" {
            AdvisorQuestionsHubView()
        } else if item.id == "research-policy-papers" {
            PolicyPaperLibraryView()
        } else {
            ToolkitItemDetailView(item: item)
        }
    }
}

// MARK: - Advisor Questions Hub (all module question sets)
struct AdvisorQuestionsHubView: View {
    private let questionSets: [(title: String, subtitle: String, emoji: String, set: AdvisorQuestionSet)] = [
        ("Any Financial Advisor", "6 questions on fiduciary duty, behavior & planning", "🛡️", GeneralAdvisorData.questionSet),
        ("Alternative Investing", "7 questions on liquidity, fees & portfolio construction", "🔒", AltInvestingAdvisorData.questionSet),
        ("ESG & Climate", "12 questions across 5 categories", "🌱", ESGAdvisorInteractiveData.questionSet),
        ("DeFi & Crypto", "14 questions across 4 categories", "🔗", DeFiAdvisorQuestionsData.questionSet),
        ("Art & Collecting", "5 questions on conflicts, provenance & market knowledge", "🖼️", ArtInvestingAdvisorData.questionSet),
        ("Behavioral Finance", "5 questions on bias, decision-making & goal-based planning", "🧠", BehavioralAdvisorData.questionSet),
        ("Gender Lens Investing", "4 questions on the advice gap & gender lens strategies", "⚖️", GenderLensAdvisorData.questionSet)
    ]

    @State private var sessionNotes: String = UserDefaults.standard.string(forKey: "advisor_hub_session_notes") ?? ""
    @State private var notesExpanded: Bool = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                // Header
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    HStack {
                        Text("🤝")
                            .font(.system(size: 32))
                        Text("Professionals")
                            .font(Typography.caption)
                            .foregroundColor(.brandPrimary)
                            .padding(.horizontal, Spacing.sm)
                            .padding(.vertical, Spacing.xxs)
                            .background(Color.brandPrimary.opacity(0.1))
                            .clipShape(Capsule())
                    }

                    Text("Discussion Questions for Your Advisor")
                        .font(Typography.title2)
                        .foregroundColor(.textPrimary)

                    Text("Prepared questions to evaluate competency, spot red flags, and have more productive conversations with your financial advisor.")
                        .font(Typography.body)
                        .foregroundColor(.textSecondary)
                }
                .padding(.horizontal, Spacing.lg)

                // Tip
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    HStack(spacing: Spacing.xs) {
                        Image(systemName: "lightbulb.fill")
                            .foregroundColor(.warning)
                        Text("How to use these")
                            .font(Typography.captionMedium)
                            .foregroundColor(.textPrimary)
                    }

                    Text("Review the questions before meeting your advisor. Each question includes signs of inadequate vs. competent answers so you can evaluate their responses in real time.")
                        .font(Typography.body)
                        .foregroundColor(.textSecondary)
                }
                .padding(Spacing.md)
                .background(Color.warning.opacity(0.06))
                .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
                .padding(.horizontal, Spacing.lg)

                // Session notes
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) { notesExpanded.toggle() }
                    } label: {
                        HStack {
                            Image(systemName: "note.text")
                                .font(.system(size: 14))
                                .foregroundColor(.textSecondary)
                            Text("Session Notes")
                                .font(Typography.captionMedium)
                                .foregroundColor(.textPrimary)
                            Spacer()
                            Image(systemName: notesExpanded ? "chevron.up" : "chevron.down")
                                .font(.system(size: 11))
                                .foregroundColor(.textTertiary)
                        }
                    }
                    .buttonStyle(.plain)

                    if notesExpanded {
                        TextEditor(text: $sessionNotes)
                            .font(Typography.body)
                            .foregroundColor(.textPrimary)
                            .frame(minHeight: 120)
                            .padding(Spacing.sm)
                            .background(Color.surfaceSecondary)
                            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.sm))
                            .onChange(of: sessionNotes) {
                                UserDefaults.standard.set(sessionNotes, forKey: "advisor_hub_session_notes")
                            }

                        Text("Notes are saved automatically and private to your device.")
                            .font(Typography.caption)
                            .foregroundColor(.textTertiary)
                    }
                }
                .padding(Spacing.md)
                .background(Color.surfaceSecondary)
                .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
                .padding(.horizontal, Spacing.lg)

                // Question set cards
                ForEach(questionSets, id: \.set.id) { item in
                    NavigationLink(destination: AdvisorQuestionsInteractiveView(questionSet: item.set)) {
                        HStack(spacing: Spacing.md) {
                            Text(item.emoji)
                                .font(.system(size: 28))
                                .frame(width: 44, height: 44)
                                .background(Color.surfaceTertiary)
                                .clipShape(RoundedRectangle(cornerRadius: CornerRadius.sm))

                            VStack(alignment: .leading, spacing: 2) {
                                Text(item.title)
                                    .font(Typography.bodyMedium)
                                    .foregroundColor(.textPrimary)

                                Text(item.subtitle)
                                    .font(Typography.caption)
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
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, Spacing.lg)
            }
            .padding(.vertical, Spacing.lg)
        }
        .background(Color.surfacePrimary)
        .navigationTitle("Advisor Questions")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

// MARK: - Category Tab
struct ToolkitCategoryTab: View {
    let category: ToolkitCategory
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.xs) {
                Text(category.emoji)
                    .font(.system(size: 14))
                Text(category.rawValue)
                    .font(Typography.caption)
            }
            .padding(.horizontal, Spacing.md)
            .padding(.vertical, Spacing.sm)
            .background(isSelected ? category.color : Color.surfaceSecondary)
            .foregroundColor(isSelected ? .white : .textSecondary)
            .clipShape(Capsule())
        }
    }
}

// MARK: - Toolkit Item Card
struct ToolkitItemCard: View {
    let item: ToolkitItem

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack {
                Text(item.category.emoji)
                    .font(.system(size: 20))

                VStack(alignment: .leading, spacing: 2) {
                    Text(item.title)
                        .font(Typography.bodyMedium)
                        .foregroundColor(.textPrimary)

                    Text(item.category.rawValue)
                        .font(Typography.caption2)
                        .foregroundColor(item.category.color)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.textTertiary)
            }

            Text(item.description)
                .font(Typography.caption)
                .foregroundColor(.textSecondary)
                .lineLimit(2)

            // Applicable asset classes
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.xs) {
                    ForEach(item.applicableTo.prefix(4), id: \.self) { asset in
                        Text(asset)
                            .font(Typography.caption2)
                            .foregroundColor(.textTertiary)
                            .padding(.horizontal, Spacing.xs)
                            .padding(.vertical, 2)
                            .background(Color.surfaceTertiary)
                            .clipShape(Capsule())
                    }
                    if item.applicableTo.count > 4 {
                        Text("+\(item.applicableTo.count - 4)")
                            .font(Typography.caption2)
                            .foregroundColor(.textTertiary)
                    }
                }
            }
        }
        .padding(Spacing.md)
        .background(Color.surfaceSecondary)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
    }
}

// MARK: - Toolkit Item Detail View
struct ToolkitItemDetailView: View {
    let item: ToolkitItem

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                // Header
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    HStack {
                        Text(item.category.emoji)
                            .font(.system(size: 32))

                        Text(item.category.rawValue)
                            .font(Typography.caption)
                            .foregroundColor(item.category.color)
                            .padding(.horizontal, Spacing.sm)
                            .padding(.vertical, Spacing.xxs)
                            .background(item.category.color.opacity(0.1))
                            .clipShape(Capsule())
                    }

                    Text(item.title)
                        .font(Typography.title2)
                        .foregroundColor(.textPrimary)

                    Text(item.description)
                        .font(Typography.body)
                        .foregroundColor(.textSecondary)
                }

                // Applicable to
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Text("Applies to:")
                        .font(Typography.captionMedium)
                        .foregroundColor(.textTertiary)

                    FlowLayout(spacing: Spacing.xs) {
                        ForEach(item.applicableTo, id: \.self) { asset in
                            Text(asset)
                                .font(Typography.caption)
                                .foregroundColor(.textSecondary)
                                .padding(.horizontal, Spacing.sm)
                                .padding(.vertical, Spacing.xs)
                                .background(Color.surfaceTertiary)
                                .clipShape(Capsule())
                        }
                    }
                }
                .padding(Spacing.md)
                .background(Color.surfaceSecondary)
                .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))

                // Details
                ForEach(item.details) { detail in
                    ToolkitDetailView(detail: detail)
                }
            }
            .padding(Spacing.lg)
        }
        .background(Color.surfacePrimary)
        .navigationTitle(item.title)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

// MARK: - Toolkit Detail View
struct ToolkitDetailView: View {
    let detail: ToolkitDetail

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            if let heading = detail.heading {
                Text(heading)
                    .font(Typography.bodyMedium)
                    .foregroundColor(.textPrimary)
            }

            if detail.isBulletList {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    ForEach(detail.bullets, id: \.self) { bullet in
                        HStack(alignment: .top, spacing: Spacing.sm) {
                            Text("•")
                                .foregroundColor(.brandPrimary)
                            Text(bullet)
                                .font(Typography.body)
                                .foregroundColor(.textSecondary)
                        }
                    }
                }
            } else if !detail.content.isEmpty {
                Text(detail.content)
                    .font(Typography.body)
                    .foregroundColor(detail.isWarning ? .warning : (detail.isTip ? .info : .textSecondary))
            }
        }
        .padding(Spacing.md)
        .background(
            detail.isWarning ? Color.warning.opacity(0.1) :
            detail.isTip ? Color.info.opacity(0.1) :
            Color.surfaceSecondary
        )
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
    }
}

// NOTE: FlowLayout is defined in FootnotesFeature.swift and shared across the app
// NOTE: PolicyPaperLibraryView is defined in DeFiLearningModule.swift

// MARK: - Preview
#Preview("Universal Toolkit") {
    NavigationStack {
        UniversalToolkitView()
    }
}
