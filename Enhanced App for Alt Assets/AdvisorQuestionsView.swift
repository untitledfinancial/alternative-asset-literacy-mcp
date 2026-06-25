//
//  AdvisorQuestionsView.swift
//  Enhanced App for Alt Assets
//
//  Created by Victoria Case on 2/24/26.
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//
//  Description: Reusable interactive "Questions for Your Financial Advisor" tab.
//  Supports DeFi, ESG, and future module-specific question sets.
//  Features: checkboxes, competency scoring, "Why This Matters" reveals, notes.
//

import SwiftUI
import Combine

// MARK: - Data Models

/// A single question to evaluate your advisor's competency
struct AdvisorQuestion: Identifiable {
    let id: String
    let question: String                // The question to ask
    let inadequateAnswers: [String]     // Signs of insufficient knowledge
    let competentAnswers: [String]      // Signs of competent knowledge
    let whyItMatters: String            // Explanation of importance
}

/// A category grouping related advisor questions
struct AdvisorQuestionCategory: Identifiable {
    let id: String
    let emoji: String
    let title: String
    let subtitle: String?
    let questions: [AdvisorQuestion]
}

/// Full question set for a module
struct AdvisorQuestionSet: Identifiable {
    let id: String
    let moduleId: String               // Which module this belongs to
    let title: String                  // e.g., "Questions for Your Financial Advisor"
    let subtitle: String               // e.g., "Evaluating DeFi Competency"
    let disclaimer: String
    let categories: [AdvisorQuestionCategory]
}

// MARK: - Persistence Manager
/// Tracks which questions have been marked as "asked", notes, and when last discussed
class AdvisorQuestionsTracker: ObservableObject {
    @Published var askedQuestions: Set<String> = []
    @Published var notes: [String: String] = [:]  // questionId → note
    @Published var lastDiscussedDates: [String: Date] = [:]  // questionId → date last marked asked

    private let askedKey: String
    private let notesKey: String
    private let datesKey: String

    init(moduleId: String) {
        self.askedKey = "advisor_asked_\(moduleId)"
        self.notesKey = "advisor_notes_\(moduleId)"
        self.datesKey = "advisor_discussed_dates_\(moduleId)"

        // Load persisted state — notes from Keychain (sensitive), checkmarks from UserDefaults
        if let saved = UserDefaults.standard.array(forKey: askedKey) as? [String] {
            self.askedQuestions = Set(saved)
        }
        if let data = KeychainHelper.readData(key: notesKey),
           let saved = try? JSONDecoder().decode([String: String].self, from: data) {
            self.notes = saved
        } else if let saved = UserDefaults.standard.dictionary(forKey: notesKey) as? [String: String] {
            // Fall back to UserDefaults for pre-migration data
            self.notes = saved
        }
        if let data = UserDefaults.standard.data(forKey: datesKey),
           let saved = try? JSONDecoder().decode([String: Date].self, from: data) {
            self.lastDiscussedDates = saved
        }
    }

    func toggleAsked(_ questionId: String) {
        if askedQuestions.contains(questionId) {
            askedQuestions.remove(questionId)
        } else {
            askedQuestions.insert(questionId)
            lastDiscussedDates[questionId] = Date()
        }
        save()
    }

    func setNote(_ questionId: String, note: String) {
        notes[questionId] = note.isEmpty ? nil : note
        save()
    }

    var askedCount: Int { askedQuestions.count }

    /// Returns true if the question was discussed more than 180 days ago
    func isStale(_ questionId: String) -> Bool {
        guard let date = lastDiscussedDates[questionId] else { return false }
        let days = Calendar.current.dateComponents([.day], from: date, to: Date()).day ?? 0
        return days > 180
    }

    func relativeDiscussedDate(_ questionId: String) -> String? {
        guard let date = lastDiscussedDates[questionId] else { return nil }
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }

    private func save() {
        UserDefaults.standard.set(Array(askedQuestions), forKey: askedKey)
        // Notes are user-generated text — store securely in Keychain
        if let data = try? JSONEncoder().encode(notes) {
            KeychainHelper.save(key: notesKey, data: data)
        }
        if let data = try? JSONEncoder().encode(lastDiscussedDates) {
            UserDefaults.standard.set(data, forKey: datesKey)
        }
    }
}

// MARK: - Main Interactive View

struct AdvisorQuestionsInteractiveView: View {
    let questionSet: AdvisorQuestionSet
    @StateObject private var tracker: AdvisorQuestionsTracker
    @State private var expandedQuestions: Set<String> = []
    @State private var expandedCategories: Set<String> = []
    @State private var showCompetencyDetails: Set<String> = []

    init(questionSet: AdvisorQuestionSet) {
        self.questionSet = questionSet
        self._tracker = StateObject(wrappedValue: AdvisorQuestionsTracker(moduleId: questionSet.moduleId))
    }

    private var totalQuestions: Int {
        questionSet.categories.reduce(0) { $0 + $1.questions.count }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.lg) {
            // Header
            headerSection

            // Progress bar
            progressSection

            // Categories
            ForEach(questionSet.categories) { category in
                categoryView(category)
            }

            // Disclaimer
            disclaimerSection

            Spacer()
                .frame(height: Spacing.xxxl)
        }
        .padding(.horizontal, Spacing.lg)
    }

    // MARK: - Header
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack(spacing: Spacing.sm) {
                Text("💬")
                    .font(.system(size: 28))
                Text(questionSet.title)
                    .font(Typography.title2)
                    .foregroundColor(.textPrimary)
                Spacer()
                ShareLink(item: exportText, preview: SharePreview("Advisor Prep — \(questionSet.title)")) {
                    HStack(spacing: 5) {
                        Image(systemName: "square.and.arrow.up")
                        Text("Export")
                    }
                    .font(Typography.caption)
                    .foregroundColor(.brandPrimary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.brandPrimary.opacity(0.1))
                    .clipShape(Capsule())
                }
            }
            .padding(.top, Spacing.lg)

            Text(questionSet.subtitle)
                .font(Typography.body)
                .foregroundColor(.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var exportText: String {
        var lines: [String] = []
        lines.append("ADVISOR SESSION PREP")
        lines.append(questionSet.title)
        lines.append(String(repeating: "─", count: 40))
        lines.append("")

        for category in questionSet.categories {
            let askedInCategory = category.questions.filter { tracker.askedQuestions.contains($0.id) }
            let staleInCategory = category.questions.filter { tracker.isStale($0.id) }
            guard !askedInCategory.isEmpty || !staleInCategory.isEmpty else { continue }

            lines.append(category.title.uppercased())
            lines.append("")

            for question in category.questions {
                let isAsked = tracker.askedQuestions.contains(question.id)
                let isStale = tracker.isStale(question.id)
                guard isAsked || isStale else { continue }

                let marker = isStale ? "↺ REVISIT" : "✓"
                lines.append("\(marker)  \(question.question)")

                if let note = tracker.notes[question.id], !note.isEmpty {
                    lines.append("   Note: \(note)")
                }
                if let date = tracker.relativeDiscussedDate(question.id) {
                    lines.append("   Last discussed: \(date)")
                }
                lines.append("")
            }
        }

        let dateStr = DateFormatter.localizedString(from: Date(), dateStyle: .long, timeStyle: .none)
        lines.append(String(repeating: "─", count: 40))
        lines.append("Generated \(dateStr) · alternativeassetsliteracy.com")
        return lines.joined(separator: "\n")
    }

    // MARK: - Progress
    private var progressSection: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            HStack {
                Text("\(tracker.askedCount) of \(totalQuestions) discussed")
                    .font(Typography.captionMedium)
                    .foregroundColor(.textSecondary)

                Spacer()

                if tracker.askedCount == totalQuestions {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(.green)
                        Text("Complete")
                            .font(Typography.captionMedium)
                            .foregroundColor(.green)
                    }
                }
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.surfaceTertiary)
                        .frame(height: 6)

                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.brandPrimary)
                        .frame(width: totalQuestions > 0
                               ? geo.size.width * CGFloat(tracker.askedCount) / CGFloat(totalQuestions)
                               : 0,
                               height: 6)
                        .animation(.easeInOut(duration: 0.3), value: tracker.askedCount)
                }
            }
            .frame(height: 6)
        }
        .padding(Spacing.md)
        .background(Color.surfaceSecondary)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
    }

    // MARK: - Category View
    @ViewBuilder
    private func categoryView(_ category: AdvisorQuestionCategory) -> some View {
        let isExpanded = expandedCategories.contains(category.id)
        let categoryAsked = category.questions.filter { tracker.askedQuestions.contains($0.id) }.count

        VStack(alignment: .leading, spacing: 0) {
            // Category header
            Button {
                withAnimation(.smoothSpring) {
                    if isExpanded {
                        expandedCategories.remove(category.id)
                    } else {
                        expandedCategories.insert(category.id)
                    }
                }
            } label: {
                HStack(spacing: Spacing.sm) {
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.textTertiary)
                        .frame(width: 16)

                    Text(category.emoji)
                        .font(.system(size: 22))

                    VStack(alignment: .leading, spacing: 2) {
                        Text(category.title)
                            .font(Typography.bodyMedium)
                            .foregroundColor(.textPrimary)
                        if let subtitle = category.subtitle {
                            Text(subtitle)
                                .font(Typography.caption)
                                .foregroundColor(.textTertiary)
                        }
                    }

                    Spacer()

                    // Progress badge
                    Text("\(categoryAsked)/\(category.questions.count)")
                        .font(Typography.caption)
                        .foregroundColor(categoryAsked == category.questions.count ? .green : .textTertiary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(
                            categoryAsked == category.questions.count
                            ? Color.green.opacity(0.1)
                            : Color.surfaceTertiary
                        )
                        .clipShape(Capsule())
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .padding(Spacing.md)

            // Expanded questions
            if isExpanded {
                Divider()
                    .padding(.horizontal, Spacing.md)

                VStack(alignment: .leading, spacing: Spacing.sm) {
                    ForEach(category.questions) { question in
                        questionRow(question)
                    }
                }
                .padding(Spacing.md)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(Color.surfaceSecondary)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
    }

    // MARK: - Question Row
    @ViewBuilder
    private func questionRow(_ question: AdvisorQuestion) -> some View {
        let isAsked = tracker.askedQuestions.contains(question.id)
        let isExpanded = expandedQuestions.contains(question.id)
        let showCompetency = showCompetencyDetails.contains(question.id)
        let stale = tracker.isStale(question.id)

        VStack(alignment: .leading, spacing: Spacing.sm) {
            // Question + checkbox row
            HStack(alignment: .top, spacing: Spacing.sm) {
                // Checkbox
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        tracker.toggleAsked(question.id)
                    }
                } label: {
                    Image(systemName: isAsked ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 20))
                        .foregroundColor(isAsked ? .green : .textTertiary)
                }
                .buttonStyle(.plain)

                // Question text + expand
                Button {
                    withAnimation(.smoothSpring) {
                        if isExpanded {
                            expandedQuestions.remove(question.id)
                        } else {
                            expandedQuestions.insert(question.id)
                        }
                    }
                } label: {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(question.question)
                                .font(Typography.body)
                                .foregroundColor(isAsked ? .textSecondary : .textPrimary)
                                .strikethrough(isAsked, color: .textTertiary)
                                .fixedSize(horizontal: false, vertical: true)
                                .multilineTextAlignment(.leading)

                            // Last discussed date + Revisit badge
                            if isAsked {
                                HStack(spacing: Spacing.xs) {
                                    if let dateStr = tracker.relativeDiscussedDate(question.id) {
                                        Text("Last discussed \(dateStr)")
                                            .font(Typography.caption)
                                            .foregroundColor(.textTertiary)
                                    }
                                    if stale {
                                        Text("Revisit")
                                            .font(Typography.caption)
                                            .foregroundColor(.textTertiary)
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 2)
                                            .overlay(
                                                Capsule()
                                                    .stroke(Color.textTertiary.opacity(0.5), lineWidth: 1)
                                            )
                                    }
                                }
                            }
                        }

                        Spacer()

                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.textTertiary)
                            .padding(.top, 4)
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }

            // Expanded competency details
            if isExpanded {
                VStack(alignment: .leading, spacing: Spacing.md) {
                    // Toggle: Inadequate vs Competent
                    HStack(spacing: Spacing.sm) {
                        Button {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                if showCompetency {
                                    showCompetencyDetails.remove(question.id)
                                } else {
                                    showCompetencyDetails.insert(question.id)
                                }
                            }
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: showCompetency ? "eye.fill" : "eye")
                                    .font(.caption)
                                Text(showCompetency ? "Showing Competent Answers" : "Show What Good Looks Like")
                                    .font(Typography.captionMedium)
                            }
                            .foregroundColor(.brandPrimary)
                        }
                        .buttonStyle(.plain)

                        Spacer()
                    }

                    if !showCompetency {
                        // Inadequate answers (red flags)
                        VStack(alignment: .leading, spacing: Spacing.xs) {
                            HStack(spacing: 4) {
                                Image(systemName: "exclamationmark.triangle")
                                    .font(.caption2)
                                    .foregroundColor(.orange)
                                Text("Red Flags")
                                    .font(Typography.captionMedium)
                                    .foregroundColor(.orange)
                            }

                            ForEach(question.inadequateAnswers, id: \.self) { answer in
                                HStack(alignment: .top, spacing: 6) {
                                    Text("•")
                                        .font(Typography.caption)
                                        .foregroundColor(.orange)
                                    Text(answer)
                                        .font(Typography.caption)
                                        .foregroundColor(.textSecondary)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                            }
                        }
                        .padding(Spacing.sm)
                        .background(Color.orange.opacity(0.05))
                        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.sm))
                    } else {
                        // Competent answers (green)
                        VStack(alignment: .leading, spacing: Spacing.xs) {
                            HStack(spacing: 4) {
                                Image(systemName: "checkmark.shield")
                                    .font(.caption2)
                                    .foregroundColor(.green)
                                Text("Competent Understanding")
                                    .font(Typography.captionMedium)
                                    .foregroundColor(.green)
                            }

                            ForEach(question.competentAnswers, id: \.self) { answer in
                                HStack(alignment: .top, spacing: 6) {
                                    Text("✓")
                                        .font(Typography.caption)
                                        .foregroundColor(.green)
                                    Text(answer)
                                        .font(Typography.caption)
                                        .foregroundColor(.textSecondary)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                            }
                        }
                        .padding(Spacing.sm)
                        .background(Color.green.opacity(0.05))
                        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.sm))
                    }

                    // Why It Matters
                    HStack(alignment: .top, spacing: 6) {
                        Image(systemName: "lightbulb.fill")
                            .font(.caption2)
                            .foregroundColor(.brandPrimary)
                            .padding(.top, 2)
                        Text(question.whyItMatters)
                            .font(Typography.caption)
                            .foregroundColor(.textTertiary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(Spacing.sm)
                    .background(Color.brandPrimary.opacity(0.04))
                    .clipShape(RoundedRectangle(cornerRadius: CornerRadius.sm))
                }
                .padding(.leading, 32) // Align with question text
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(.vertical, Spacing.xs)
    }

    // MARK: - Disclaimer
    private var disclaimerSection: some View {
        VStack(spacing: Spacing.sm) {
            Divider()
            Text(questionSet.disclaimer)
                .font(Typography.caption2)
                .foregroundColor(.textTertiary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, Spacing.md)
    }
}

// MARK: - DeFi Advisor Questions Data

struct DeFiAdvisorQuestionsData {

    static let questionSet = AdvisorQuestionSet(
        id: "defi_advisor_qs",
        moduleId: "mod_defi_investing",
        title: "Questions for Your Financial Advisor",
        subtitle: "Evaluate whether your advisor has sufficient knowledge to guide crypto and DeFi investment decisions. Each question reveals what inadequate versus competent answers look like.",
        disclaimer: "This framework is for educational purposes only and is not financial advice. Content sourced from BIS, IOSCO, CFA Institute, Messari, and protocol documentation. We recommend working with a licensed financial advisor.",
        categories: [

            // Section A: Fundamental Crypto Understanding
            AdvisorQuestionCategory(
                id: "defi_adv_a",
                emoji: "🧱",
                title: "Fundamental Crypto Understanding",
                subtitle: "Core literacy every advisor should have",
                questions: [
                    AdvisorQuestion(
                        id: "defi_q1",
                        question: "\"How would you explain the difference between cryptocurrency and DeFi?\"",
                        inadequateAnswers: [
                            "Treats them as interchangeable terms",
                            "Can't articulate a clear distinction",
                            "Vague or circular definitions"
                        ],
                        competentAnswers: [
                            "Cryptocurrency is the foundational digital asset/money layer",
                            "DeFi is financial services (lending, trading, derivatives) built on crypto networks",
                            "Explains how DeFi uses crypto as infrastructure",
                            "Example: \"Bitcoin is a cryptocurrency. Aave is DeFi — it lets you lend Bitcoin to earn interest.\""
                        ],
                        whyItMatters: "If an advisor can't distinguish the base layer from applications, they can't properly evaluate different investment opportunities or risks."
                    ),
                    AdvisorQuestion(
                        id: "defi_q2",
                        question: "\"What's the difference between Bitcoin and Ethereum as investments?\"",
                        inadequateAnswers: [
                            "\"They're basically the same thing\"",
                            "Only discusses price movements",
                            "Pure speculation framing",
                            "Can't explain use case differences"
                        ],
                        competentAnswers: [
                            "Bitcoin: Digital store of value, \"digital gold,\" fixed supply (21M), value from scarcity",
                            "Ethereum: Programmable platform enabling smart contracts, value from utility and network activity",
                            "Different risk/reward profiles and investment theses",
                            "Bitcoin = better gold. Ethereum = infrastructure for a new financial system."
                        ],
                        whyItMatters: "These represent fundamentally different investment theses. An advisor who can't distinguish them can't build appropriate portfolio allocations."
                    ),
                    AdvisorQuestion(
                        id: "defi_q3",
                        question: "\"How do stablecoins work and why do they matter?\"",
                        inadequateAnswers: [
                            "\"They're just pegged to the dollar\"",
                            "No explanation of backing mechanisms",
                            "Doesn't mention different types"
                        ],
                        competentAnswers: [
                            "Fiat-backed (USDC): Actual US dollars in bank accounts, 1:1 backing, centralized",
                            "Crypto-backed (DAI): Overcollateralized with cryptocurrency, decentralized",
                            "Algorithmic (failed Terra/UST): No backing, relied on market incentives — collapsed",
                            "Mentions uses: trading pairs, DeFi liquidity, cross-border payments, yield generation"
                        ],
                        whyItMatters: "Stablecoins are foundational to DeFi. Understanding their mechanics reveals whether an advisor grasps systemic risks and infrastructure dependencies."
                    ),
                    AdvisorQuestion(
                        id: "defi_q4",
                        question: "\"What happened with Terra/Luna in 2022?\"",
                        inadequateAnswers: [
                            "Unaware of the event",
                            "Dismisses as \"crypto is all scams\"",
                            "Can't explain the mechanics"
                        ],
                        competentAnswers: [
                            "Algorithmic stablecoin (UST) maintained peg through arbitrage with LUNA token",
                            "Lost peg in May 2022, triggering a death spiral",
                            "UST selling → LUNA minting → LUNA collapse → more UST selling",
                            "$60 billion evaporated — demonstrates reflexive risk in crypto"
                        ],
                        whyItMatters: "An advisor who understands this failure can identify similar risks in other protocols. Those who don't may recommend dangerous products."
                    ),
                ]
            ),

            // Section B: DeFi Protocol Knowledge
            AdvisorQuestionCategory(
                id: "defi_adv_b",
                emoji: "⚙️",
                title: "DeFi Protocol Knowledge",
                subtitle: "Active research and protocol understanding",
                questions: [
                    AdvisorQuestion(
                        id: "defi_q5",
                        question: "\"Which DeFi protocols do you actively monitor?\"",
                        inadequateAnswers: [
                            "Can't name any protocols",
                            "Names defunct or discredited projects",
                            "Vague references without specifics"
                        ],
                        competentAnswers: [
                            "Aave — leading lending protocol with $40B+ locked",
                            "Uniswap — largest decentralized exchange, trading without intermediaries",
                            "MakerDAO/Sky — issues DAI stablecoin backed by crypto and real-world assets",
                            "Explains why these specific protocols: market leadership, multi-year track records, institutional adoption"
                        ],
                        whyItMatters: "Familiarity with leading protocols indicates active research. Inability to name any suggests the advisor isn't following the space."
                    ),
                    AdvisorQuestion(
                        id: "defi_q6",
                        question: "\"How does Aave make money, and do token holders benefit?\"",
                        inadequateAnswers: [
                            "\"I'd have to look that up\"",
                            "Can't explain revenue sources",
                            "Unaware of token holder value capture"
                        ],
                        competentAnswers: [
                            "Revenue: 0.05–0.1% protocol fees on deposits, borrows, liquidations",
                            "Value Accrual: As of 2025, $50M annual buyback program from protocol revenue",
                            "Business Model: Usage-based — more lending/borrowing = more revenue",
                            "Shifted from governance-only token to value-capturing asset"
                        ],
                        whyItMatters: "Understanding how protocols generate and distribute revenue is fundamental to evaluating them as investments versus speculation."
                    ),
                    AdvisorQuestion(
                        id: "defi_q7",
                        question: "\"What changed with Uniswap's tokenomics in late 2025?\"",
                        inadequateAnswers: [
                            "Unaware of the UNIfication proposal",
                            "No knowledge of fee switch activation",
                            "Can't explain the significance"
                        ],
                        competentAnswers: [
                            "Fee Switch Activated: Protocol now captures a portion of trading fees",
                            "100M Token Burn: Retroactive burn from treasury (~16% of supply)",
                            "Ongoing Burns: Fees now fund continuous token buybacks/burns",
                            "Changed from governance-only to value-accruing asset"
                        ],
                        whyItMatters: "This represents the shift from speculation to investment-grade assets. Advisors unaware of this miss fundamental market evolution."
                    ),
                    AdvisorQuestion(
                        id: "defi_q8",
                        question: "\"What is TVL and how should it factor into investment decisions?\"",
                        inadequateAnswers: [
                            "\"Higher TVL = better investment\" (oversimplified)",
                            "Doesn't understand limitations",
                            "Uses it as sole metric"
                        ],
                        competentAnswers: [
                            "Definition: Total dollar value of assets locked in a protocol's smart contracts",
                            "Indicates user trust, liquidity depth, protocol adoption",
                            "Limitations: Can be inflated by incentive programs, double-counted across protocols",
                            "Proper Use: One metric among several — analyze alongside revenue, user growth, network effects"
                        ],
                        whyItMatters: "TVL is heavily marketed but frequently misunderstood. Proper interpretation separates informed analysis from surface-level evaluation."
                    ),
                ]
            ),

            // Section C: Risk Assessment
            AdvisorQuestionCategory(
                id: "defi_adv_c",
                emoji: "🛡️",
                title: "Risk Assessment",
                subtitle: "Understanding DeFi-specific risks",
                questions: [
                    AdvisorQuestion(
                        id: "defi_q9",
                        question: "\"What are the unique risks in DeFi investing?\"",
                        inadequateAnswers: [
                            "Generic answers: \"volatility\" or \"regulation\"",
                            "Can't identify DeFi-specific risks",
                            "No concrete examples"
                        ],
                        competentAnswers: [
                            "Smart Contract Exploits: Code vulnerabilities enabling theft ($1.1B lost in 2025)",
                            "Oracle Manipulation: Price feed attacks enabling unfair liquidations",
                            "Governance Centralization: Team control despite decentralization claims",
                            "Liquidation Cascades: Rapid price drops triggering automated liquidations",
                            "Composability Risk: Interconnected protocols creating contagion"
                        ],
                        whyItMatters: "DeFi risks differ fundamentally from traditional finance. Advisors who only cite generic risks can't properly evaluate exposure."
                    ),
                    AdvisorQuestion(
                        id: "defi_q10",
                        question: "\"How much should someone allocate to DeFi in a traditional portfolio?\"",
                        inadequateAnswers: [
                            "\"Put 30%+ in crypto!\"",
                            "No framework or rationale",
                            "One-size-fits-all recommendation"
                        ],
                        competentAnswers: [
                            "Range: 3–10% maximum for most investors",
                            "Positioning: Alternative/speculative allocation bucket",
                            "Factors: Risk tolerance, time horizon, existing portfolio, income stability",
                            "Tiered Approach: ETFs for conservative, direct protocols for experienced"
                        ],
                        whyItMatters: "Appropriate sizing protects clients from catastrophic losses while enabling participation. Poor sizing guidance creates unacceptable risk."
                    ),
                    AdvisorQuestion(
                        id: "defi_q11",
                        question: "\"How should I hold my crypto investments?\"",
                        inadequateAnswers: [
                            "\"Just keep it on Coinbase\" (no tradeoffs discussed)",
                            "Doesn't mention self-custody option",
                            "Unaware of security considerations"
                        ],
                        competentAnswers: [
                            "Exchange Custody: Easier, sometimes insured, but counterparty risk",
                            "Self-Custody: Full control, no counterparty risk, but requires technical competence",
                            "Institutional Custody: Fireblocks, Anchorage — regulated, insured, but fees",
                            "Matches solution to client capability and amount"
                        ],
                        whyItMatters: "Custody mistakes can result in total loss. Advisors must understand tradeoffs to give appropriate guidance."
                    ),
                    AdvisorQuestion(
                        id: "defi_q12",
                        question: "\"How are DeFi earnings taxed differently than buy-and-hold?\"",
                        inadequateAnswers: [
                            "\"It's just capital gains\"",
                            "Doesn't understand yield taxation",
                            "No awareness of reporting complexity"
                        ],
                        competentAnswers: [
                            "Buy and Hold: Capital gains when sold (long-term vs. short-term rates)",
                            "Yield Farming/Staking: Ordinary income when received, regardless of whether sold",
                            "Impermanent Loss: Complex tax treatment, potential loss despite profit appearance",
                            "Common Mistake: Earning $20K in tokens that drop to $2K, but owing taxes on $20K"
                        ],
                        whyItMatters: "Tax treatment can turn nominal profits into real losses. Advisors must understand this to set proper expectations."
                    ),
                ]
            ),

            // Section D: Market Awareness
            AdvisorQuestionCategory(
                id: "defi_adv_d",
                emoji: "📡",
                title: "Market Awareness",
                subtitle: "Staying current with developments",
                questions: [
                    AdvisorQuestion(
                        id: "defi_q13",
                        question: "\"How did Bitcoin/Ethereum ETF approvals change the landscape?\"",
                        inadequateAnswers: [
                            "Sees it as validation to buy everything crypto",
                            "Doesn't understand what changed",
                            "Conflates ETF approval with DeFi investing"
                        ],
                        competentAnswers: [
                            "What Changed: Institutional access via brokerage accounts, regulatory legitimacy",
                            "What Didn't Change: DeFi protocols remain unregulated, still need direct interaction",
                            "Impact: $75B institutional inflows in Q1 2024, 400% acceleration",
                            "ETFs are entry point, not complete solution"
                        ],
                        whyItMatters: "ETFs opened the door but only for basic exposure. Advisors must understand limitations to guide full allocation strategy."
                    ),
                    AdvisorQuestion(
                        id: "defi_q14",
                        question: "\"How are stablecoins changing traditional finance?\"",
                        inadequateAnswers: [
                            "\"They're just for trading crypto\"",
                            "No awareness of payment use cases",
                            "Doesn't follow institutional adoption"
                        ],
                        competentAnswers: [
                            "Payments: Visa enabling USDC settlement (December 2025)",
                            "Cross-Border: Minutes vs. days, 0.1% cost vs. 3–5%",
                            "Treasury Management: $20B+ in corporate treasuries earning yield",
                            "Regulatory acceptance accelerating real-world integration"
                        ],
                        whyItMatters: "Stablecoins are bridging traditional and decentralized finance. Advisors unaware of this convergence may miss significant opportunities."
                    ),
                ]
            ),
        ]
    )
}

// MARK: - DeFi Advisor Tab (Drop-in replacement)

struct DeFiAdvisorQuestionsTabView: View {
    var body: some View {
        VStack(spacing: 0) {
            AdvisorQuestionsInteractiveView(
                questionSet: DeFiAdvisorQuestionsData.questionSet
            )

            // Due Diligence Checklist — appended below advisor questions
            DeFiChecklistTabView()
        }
    }
}

// MARK: - Updated ESG Advisor Tab (Uses interactive component)

struct ESGAdvisorQuestionsInteractiveView: View {
    var body: some View {
        AdvisorQuestionsInteractiveView(
            questionSet: ESGAdvisorInteractiveData.questionSet
        )
    }
}

/// Re-mapped ESG questions into the new interactive format
struct ESGAdvisorInteractiveData {

    static let questionSet = AdvisorQuestionSet(
        id: "esg_advisor_qs",
        moduleId: "mod_esg_climate",
        title: "Questions for Your Financial Advisor",
        subtitle: "Key questions to ask when discussing ESG investing with your advisor. Use this guide to evaluate their expertise and approach.",
        disclaimer: "This framework is for educational purposes only. We recommend working with a licensed financial advisor for personalized investment guidance.",
        categories: [
            AdvisorQuestionCategory(
                id: "esg_adv_strategy",
                emoji: "🎯",
                title: "Understanding ESG Strategy",
                subtitle: "How your advisor approaches ESG",
                questions: [
                    AdvisorQuestion(
                        id: "esg_q1",
                        question: "\"How do you define ESG investing, and what approaches do you use?\"",
                        inadequateAnswers: [
                            "Vague answer without specifics",
                            "Conflates ESG with simple exclusion",
                            "Can't differentiate ESG integration from screening"
                        ],
                        competentAnswers: [
                            "Explains the Environmental, Social, and Governance framework clearly",
                            "Distinguishes between ESG integration, screening, and impact investing",
                            "Names specific data providers (MSCI, Sustainalytics) and their roles",
                            "Describes how ESG factors are weighted by sector materiality"
                        ],
                        whyItMatters: "ESG is a broad field with many approaches. An advisor who can't articulate their methodology may be using ESG as a marketing label without substance."
                    ),
                    AdvisorQuestion(
                        id: "esg_q2",
                        question: "\"What ESG data providers or ratings do you rely on for analysis?\"",
                        inadequateAnswers: [
                            "Can't name any data providers",
                            "Relies solely on fund marketing materials",
                            "Doesn't understand rating divergence"
                        ],
                        competentAnswers: [
                            "Names providers: MSCI ESG, Sustainalytics, S&P Global, CDP",
                            "Acknowledges rating divergence between providers",
                            "Explains how they triangulate or reconcile conflicting ratings",
                            "Uses multiple sources rather than relying on just one"
                        ],
                        whyItMatters: "ESG ratings from different providers can vary significantly. Understanding this complexity is essential for making informed investment decisions."
                    ),
                    AdvisorQuestion(
                        id: "esg_q3",
                        question: "\"How do you balance ESG considerations with financial performance goals?\"",
                        inadequateAnswers: [
                            "\"ESG always outperforms\" (oversimplified)",
                            "Treats ESG as purely a constraint",
                            "No framework for balancing"
                        ],
                        competentAnswers: [
                            "Discusses risk-adjusted returns, not just absolute returns",
                            "Identifies material ESG factors that impact financial performance by sector",
                            "Shows historical performance data for their ESG strategies",
                            "Acknowledges trade-offs honestly while explaining long-term thesis"
                        ],
                        whyItMatters: "The relationship between ESG and returns is nuanced. Advisors who oversimplify either way aren't providing sound guidance."
                    ),
                    AdvisorQuestion(
                        id: "esg_q4",
                        question: "\"Can you explain the difference between ESG integration, screening, and impact investing?\"",
                        inadequateAnswers: [
                            "Uses terms interchangeably",
                            "Only describes one approach",
                            "Can't explain trade-offs between approaches"
                        ],
                        competentAnswers: [
                            "ESG Integration: Incorporating ESG factors into traditional financial analysis",
                            "Screening: Excluding (negative) or including (positive) based on ESG criteria",
                            "Impact Investing: Targeting measurable social/environmental outcomes alongside returns",
                            "Explains which approach fits different client goals"
                        ],
                        whyItMatters: "These represent different strategies with different implications. Matching the right approach to your goals determines investment success."
                    ),
                ]
            ),
            AdvisorQuestionCategory(
                id: "esg_adv_portfolio",
                emoji: "📊",
                title: "Portfolio Construction",
                subtitle: "Building an ESG-aligned portfolio",
                questions: [
                    AdvisorQuestion(
                        id: "esg_q5",
                        question: "\"What percentage of my portfolio could be allocated to ESG strategies?\"",
                        inadequateAnswers: [
                            "\"Just put everything in ESG\"",
                            "No consideration of existing portfolio",
                            "One-size-fits-all recommendation"
                        ],
                        competentAnswers: [
                            "Assesses current portfolio composition first",
                            "Considers risk tolerance, time horizon, and income needs",
                            "Suggests phased transition if appropriate",
                            "Explains that ESG can be applied across the entire portfolio or as a satellite allocation"
                        ],
                        whyItMatters: "Portfolio construction should be personalized. Generic ESG allocation advice may not align with your specific financial situation."
                    ),
                    AdvisorQuestion(
                        id: "esg_q6",
                        question: "\"How would adding ESG investments affect my overall risk profile?\"",
                        inadequateAnswers: [
                            "\"ESG reduces risk\" (oversimplified)",
                            "No quantitative analysis",
                            "Doesn't discuss concentration risk"
                        ],
                        competentAnswers: [
                            "Discusses sector tilts that ESG creates (underweight energy, overweight tech)",
                            "Quantifies tracking error relative to benchmark",
                            "Explains diversification impact of exclusionary screens",
                            "Provides scenario analysis or stress testing"
                        ],
                        whyItMatters: "ESG strategies can change your portfolio's risk characteristics in unexpected ways. Understanding these shifts is critical."
                    ),
                ]
            ),
            AdvisorQuestionCategory(
                id: "esg_adv_costs",
                emoji: "💰",
                title: "Costs & Performance",
                subtitle: "Fees, returns, and transparency",
                questions: [
                    AdvisorQuestion(
                        id: "esg_q7",
                        question: "\"What are the typical fees for ESG funds compared to traditional options?\"",
                        inadequateAnswers: [
                            "Unaware of fee differences",
                            "Dismisses fees as irrelevant",
                            "Can't provide specific ranges"
                        ],
                        competentAnswers: [
                            "ESG index funds: 0.10–0.30% vs. traditional 0.03–0.10%",
                            "Active ESG: 0.50–1.50% with significant variation",
                            "Fee gap has been narrowing as competition increases",
                            "Shows net-of-fee performance comparisons"
                        ],
                        whyItMatters: "Fees compound over time and directly reduce returns. Transparency about costs helps you make informed decisions."
                    ),
                    AdvisorQuestion(
                        id: "esg_q8",
                        question: "\"How do you measure and report ESG performance separately from financial returns?\"",
                        inadequateAnswers: [
                            "Only reports financial returns",
                            "No ESG-specific metrics",
                            "Can't explain impact measurement"
                        ],
                        competentAnswers: [
                            "Tracks both financial returns and ESG metrics (carbon intensity, diversity scores)",
                            "Uses frameworks like SFDR, TCFD, or UN SDGs for reporting",
                            "Provides regular impact reports alongside financial statements",
                            "Explains methodology for measuring non-financial outcomes"
                        ],
                        whyItMatters: "If you're investing for impact, you need to measure it. Advisors who can't separate ESG performance from financial returns may not be delivering on ESG promises."
                    ),
                ]
            ),
            AdvisorQuestionCategory(
                id: "esg_adv_impact",
                emoji: "🌍",
                title: "Impact & Greenwashing",
                subtitle: "Ensuring real impact",
                questions: [
                    AdvisorQuestion(
                        id: "esg_q9",
                        question: "\"How do you ensure investments aren't 'greenwashed'?\"",
                        inadequateAnswers: [
                            "\"We only use ESG-labeled funds\" (insufficient)",
                            "No due diligence process",
                            "Unaware of greenwashing as an issue"
                        ],
                        competentAnswers: [
                            "Reviews fund holdings to verify ESG claims match reality",
                            "Checks for SFDR Article 8/9 classification (EU regulatory framework)",
                            "Monitors corporate ESG commitments vs. actual actions",
                            "Uses independent verification and multiple data sources"
                        ],
                        whyItMatters: "Greenwashing is widespread. Without robust verification, you may invest in funds that market ESG but don't deliver."
                    ),
                    AdvisorQuestion(
                        id: "esg_q10",
                        question: "\"Can you show me the carbon footprint of my current portfolio?\"",
                        inadequateAnswers: [
                            "\"We don't track that\"",
                            "Can't access carbon data",
                            "Dismisses carbon metrics"
                        ],
                        competentAnswers: [
                            "Can calculate weighted average carbon intensity (WACI)",
                            "Compares portfolio carbon to benchmark",
                            "Discusses Scope 1, 2, and 3 emissions and data limitations",
                            "Shows trajectory and reduction targets"
                        ],
                        whyItMatters: "Carbon data is increasingly available and decision-useful. Advisors who can't provide it may lack the tools for modern ESG analysis."
                    ),
                ]
            ),
            AdvisorQuestionCategory(
                id: "esg_adv_future",
                emoji: "🔮",
                title: "Future Planning",
                subtitle: "Long-term ESG considerations",
                questions: [
                    AdvisorQuestion(
                        id: "esg_q11",
                        question: "\"How might climate regulations affect my current investments?\"",
                        inadequateAnswers: [
                            "\"Regulations won't matter\"",
                            "Only discusses risk, not opportunity",
                            "Unaware of regulatory landscape"
                        ],
                        competentAnswers: [
                            "Identifies transition risks: carbon pricing, stranded assets, regulatory compliance costs",
                            "Discusses physical risks: extreme weather impact on supply chains and assets",
                            "Highlights opportunities: clean energy, adaptation infrastructure, green bonds",
                            "Provides portfolio stress testing under different climate scenarios"
                        ],
                        whyItMatters: "Climate regulation is accelerating globally. Understanding its portfolio impact is essential for long-term planning."
                    ),
                    AdvisorQuestion(
                        id: "esg_q12",
                        question: "\"Are there emerging ESG themes I should consider for long-term growth?\"",
                        inadequateAnswers: [
                            "Only mentions mainstream themes",
                            "No forward-looking analysis",
                            "Can't discuss specific opportunities"
                        ],
                        competentAnswers: [
                            "Nature/biodiversity as emerging investment theme",
                            "Water scarcity and circular economy opportunities",
                            "Social factors: affordable housing, healthcare access, digital inclusion",
                            "Tokenized carbon credits and green RWAs as frontier opportunities"
                        ],
                        whyItMatters: "ESG investing is evolving rapidly. Advisors who stay ahead of emerging themes can position portfolios for long-term value creation."
                    ),
                ]
            ),
        ]
    )
}

// MARK: - Alternative Investing Advisor Questions

struct AltInvestingAdvisorData {
    static let questionSet = AdvisorQuestionSet(
        id: "alt_advisor_qs",
        moduleId: "mod_alt",
        title: "Questions for Your Financial Advisor",
        subtitle: "Evaluate whether your advisor has genuine expertise in alternative assets — private equity, hedge funds, real assets, and illiquid markets.",
        disclaimer: "For educational purposes only. Not financial advice. Content informed by CFA Institute, CAIA curriculum, Preqin, and Cambridge Associates research.",
        categories: [
            AdvisorQuestionCategory(
                id: "alt_adv_a",
                emoji: "🔒",
                title: "Liquidity & Lock-Up Reality",
                subtitle: "Understanding what illiquidity actually means for your capital",
                questions: [
                    AdvisorQuestion(
                        id: "alt_q1",
                        question: "\"What happens to my capital if I need it during the lock-up period?\"",
                        inadequateAnswers: [
                            "\"You just can't access it\"",
                            "Vague reassurances without specifics",
                            "Doesn't mention secondary market options"
                        ],
                        competentAnswers: [
                            "Explains the secondary market for fund interests and typical discounts (20–40%)",
                            "Distinguishes between hard lock-ups and redemption gates",
                            "Mentions capital call lines of credit some managers offer",
                            "Discusses whether the fund has any early redemption provisions"
                        ],
                        whyItMatters: "Illiquidity isn't just inconvenient — it can be catastrophic if you face an emergency. A good advisor stress-tests your liquidity needs before recommending alternatives."
                    ),
                    AdvisorQuestion(
                        id: "alt_q2",
                        question: "\"How do capital calls work and how should I plan for them?\"",
                        inadequateAnswers: [
                            "Can't explain what a capital call is",
                            "\"Just keep the money available\"",
                            "No discussion of timing or sizing"
                        ],
                        competentAnswers: [
                            "Explains that PE funds draw capital over time (3–5 year investment period), not all at once",
                            "Discusses maintaining a liquidity reserve (often 25–35% of commitment)",
                            "Mentions overcommitment strategies and the risks",
                            "Addresses what happens if you fail to meet a capital call"
                        ],
                        whyItMatters: "Capital call defaults can result in severe penalties including losing your entire invested capital. This is one of the most underestimated operational risks in private equity."
                    )
                ]
            ),
            AdvisorQuestionCategory(
                id: "alt_adv_b",
                emoji: "📊",
                title: "Performance Measurement",
                subtitle: "Whether they can read beyond the headline numbers",
                questions: [
                    AdvisorQuestion(
                        id: "alt_q3",
                        question: "\"How do you evaluate private equity performance — and what are the limitations of IRR?\"",
                        inadequateAnswers: [
                            "Only cites IRR without qualification",
                            "Can't explain the J-curve",
                            "Doesn't mention TVPI or DPI"
                        ],
                        competentAnswers: [
                            "Discusses IRR, TVPI (total value to paid-in), and DPI (distributions to paid-in) as complementary metrics",
                            "Explains J-curve: early negative returns due to fees and unrealized investments",
                            "Notes that IRR can be manipulated by timing of capital calls",
                            "Compares fund performance to public market equivalent (PME)"
                        ],
                        whyItMatters: "IRR alone is often misleading. An advisor who only quotes IRR may not be reading the full picture — or may be selecting the most favorable metric."
                    ),
                    AdvisorQuestion(
                        id: "alt_q4",
                        question: "\"What vintage year diversification would you recommend for my alternatives allocation?\"",
                        inadequateAnswers: [
                            "Doesn't know what vintage year means",
                            "Recommends concentrating in current market conditions",
                            "No mention of manager diversification"
                        ],
                        competentAnswers: [
                            "Explains vintage year risk: funds formed in peak market years often underperform",
                            "Recommends spreading commitments across 3–5 vintage years",
                            "Discusses manager diversification within asset class",
                            "Notes that some vintage years (e.g., 2008–2010) historically outperform due to buying at distressed prices"
                        ],
                        whyItMatters: "Vintage year diversification is one of the most important — and least discussed — risk management tools in private markets."
                    )
                ]
            ),
            AdvisorQuestionCategory(
                id: "alt_adv_c",
                emoji: "💰",
                title: "Fees & Alignment",
                subtitle: "What you're actually paying and who benefits",
                questions: [
                    AdvisorQuestion(
                        id: "alt_q5",
                        question: "\"Can you walk me through the full fee stack — management fee, carry, and any additional layers?\"",
                        inadequateAnswers: [
                            "\"It's just 2 and 20\"",
                            "Doesn't mention fund-of-funds layers",
                            "Can't explain how carry works in practice"
                        ],
                        competentAnswers: [
                            "Explains management fee (typically 1.5–2%) on committed vs. invested capital distinction",
                            "Explains carried interest (typically 20% above hurdle rate, usually 8%)",
                            "Distinguishes whole-fund carry from deal-by-deal carry",
                            "Mentions additional expenses: legal, audit, portfolio monitoring fees",
                            "If fund-of-funds: quantifies the additional 0.5–1% management and 5–10% carry layer"
                        ],
                        whyItMatters: "The total fee drag in alternatives can easily exceed 3–4% annually. This significantly affects net returns and should be factored into any performance comparison."
                    ),
                    AdvisorQuestion(
                        id: "alt_q6",
                        question: "\"How do you get compensated when you recommend an alternative fund to me?\"",
                        inadequateAnswers: [
                            "Deflects or gives a vague answer",
                            "Doesn't disclose placement fees",
                            "Claims no compensation without full explanation"
                        ],
                        competentAnswers: [
                            "Discloses any placement fees or revenue sharing from fund managers",
                            "Explains their fiduciary duty and how it applies to alternatives recommendations",
                            "Distinguishes between fee-only and commission-based compensation",
                            "Offers to put all compensation disclosures in writing"
                        ],
                        whyItMatters: "Placement fees — where advisors receive compensation from fund managers for directing client capital — create significant conflicts of interest that may not always be disclosed proactively."
                    )
                ]
            ),
            AdvisorQuestionCategory(
                id: "alt_adv_d",
                emoji: "🏗️",
                title: "Portfolio Construction",
                subtitle: "How alternatives fit your overall strategy",
                questions: [
                    AdvisorQuestion(
                        id: "alt_q7",
                        question: "\"What percentage of my portfolio should be in alternatives, and how did you arrive at that number?\"",
                        inadequateAnswers: [
                            "Generic answer not tied to your situation",
                            "\"More is better\" without qualification",
                            "No mention of liquidity needs or time horizon"
                        ],
                        competentAnswers: [
                            "Ties the allocation to your specific liquidity needs, time horizon, and risk tolerance",
                            "References institutional benchmarks (endowments: 30–50%; retail recommendation: 5–20%)",
                            "Discusses the impact of illiquidity on your overall portfolio flexibility",
                            "Addresses how alternatives interact with public market exposure (correlation, diversification)"
                        ],
                        whyItMatters: "There is no universal right answer. An advisor who gives you a percentage without understanding your full financial picture is guessing, not advising."
                    )
                ]
            )
        ]
    )
}

// MARK: - Art Investing Advisor Questions

struct ArtInvestingAdvisorData {
    static let questionSet = AdvisorQuestionSet(
        id: "art_advisor_qs",
        moduleId: "mod_art",
        title: "Questions for Your Art Advisor",
        subtitle: "Evaluate whether your art advisor has the expertise, independence, and ethics to guide your collecting and investment decisions.",
        disclaimer: "For educational purposes only. Not financial or art advisory advice. Content informed by the Art Dealers Association of America, TEFAF, and the Association of Professional Art Advisors (APAA) guidelines.",
        categories: [
            AdvisorQuestionCategory(
                id: "art_adv_a",
                emoji: "⚖️",
                title: "Conflicts of Interest",
                subtitle: "Understanding who your advisor actually works for",
                questions: [
                    AdvisorQuestion(
                        id: "art_q1",
                        question: "\"Do you receive any compensation from galleries or auction houses when you recommend a work to me?\"",
                        inadequateAnswers: [
                            "Deflects the question",
                            "Claims no compensation without specifics",
                            "\"It's just how the industry works\""
                        ],
                        competentAnswers: [
                            "Full disclosure of any referral fees, commissions, or finder's fees from dealers or auction houses",
                            "Explains the distinction between buy-side and sell-side compensation",
                            "Offers written disclosure of all compensation arrangements",
                            "Describes how they manage or avoid conflicts when they exist"
                        ],
                        whyItMatters: "Unlike regulated financial advisors, art advisors operate with minimal disclosure requirements. Undisclosed commissions from sellers are common and can reach 10–15% of the purchase price."
                    ),
                    AdvisorQuestion(
                        id: "art_q2",
                        question: "\"Do you have any ownership stake in galleries or works you might recommend to me?\"",
                        inadequateAnswers: [
                            "Dismisses the question",
                            "Non-specific answer",
                            "Claims it doesn't affect their advice"
                        ],
                        competentAnswers: [
                            "Clear disclosure of any gallery relationships, co-ownership arrangements, or inventory interests",
                            "Explains how they separate their personal collecting from client advising",
                            "Willing to provide written representation of independence"
                        ],
                        whyItMatters: "An advisor recommending works they or their partners own has a direct financial interest in the sale price — not just in your outcome."
                    )
                ]
            ),
            AdvisorQuestionCategory(
                id: "art_adv_b",
                emoji: "🔍",
                title: "Due Diligence & Provenance",
                subtitle: "Their process for authenticating and vetting works",
                questions: [
                    AdvisorQuestion(
                        id: "art_q3",
                        question: "\"What databases do you consult to check provenance and verify a work is not stolen or subject to restitution claims?\"",
                        inadequateAnswers: [
                            "Relies only on seller's representations",
                            "Doesn't mention specific databases",
                            "\"Provenance is rarely an issue\""
                        ],
                        competentAnswers: [
                            "Names specific databases: Art Loss Register, Interpol's stolen works database, AAM, Carabinieri",
                            "Discusses Nazi-era provenance research protocols (Washington Principles)",
                            "Explains their standard process for every acquisition above a threshold",
                            "Mentions engagement with provenance researchers for complex cases"
                        ],
                        whyItMatters: "Title disputes and restitution claims can surface years after purchase, resulting in forced return of works with no compensation. Provenance gaps are a known risk in any collection built before the 1990s."
                    ),
                    AdvisorQuestion(
                        id: "art_q4",
                        question: "\"How do you verify authenticity, and which experts or catalogues raisonnés do you rely on?\"",
                        inadequateAnswers: [
                            "Only relies on gallery certificates",
                            "Can't name relevant authentication bodies",
                            "No mention of technical analysis"
                        ],
                        competentAnswers: [
                            "Distinguishes between catalogue raisonné inclusion, foundation authentication, and technical analysis",
                            "Names relevant bodies for target artists (e.g., Warhol Foundation, Basquiat Authentication Committee)",
                            "Discusses scientific methods: pigment analysis, carbon dating, X-ray imaging",
                            "Explains what happens when authentication is disputed"
                        ],
                        whyItMatters: "Authentication is the single most important determinant of value for works by significant artists. A certificate from the wrong source — or no certificate — can make a work unmarketable."
                    )
                ]
            ),
            AdvisorQuestionCategory(
                id: "art_adv_c",
                emoji: "📈",
                title: "Market Knowledge",
                subtitle: "Whether they understand the market, not just the art",
                questions: [
                    AdvisorQuestion(
                        id: "art_q5",
                        question: "\"How is the primary market for this artist performing relative to the secondary market?\"",
                        inadequateAnswers: [
                            "Can't distinguish primary from secondary market dynamics",
                            "Only cites auction records without context",
                            "\"The artist is very hot right now\""
                        ],
                        competentAnswers: [
                            "Explains the difference: primary (gallery sales, artist estate) vs. secondary (auction, private resale)",
                            "Discusses whether auction prices are tracking above or below gallery prices",
                            "Addresses buy-in rates and bought-in lots as indicators of true demand",
                            "Notes whether the artist has institutional museum support — a key long-term value driver"
                        ],
                        whyItMatters: "Auction records can be misleading. High auction prices with low buy-in rates, or works that frequently fail to sell, signal speculative demand rather than sustained market depth."
                    )
                ]
            )
        ]
    )
}

// MARK: - Behavioral Economics Advisor Questions

struct BehavioralAdvisorData {
    static let questionSet = AdvisorQuestionSet(
        id: "behavioral_advisor_qs",
        moduleId: "mod_behavioral",
        title: "Questions for Your Financial Advisor",
        subtitle: "Evaluate whether your advisor understands behavioral finance — and whether they apply it to how they work with you.",
        disclaimer: "For educational purposes only. Not financial advice. Content informed by Kahneman & Thaler research, CFA Institute Behavioral Finance curriculum, and NBER behavioral economics literature.",
        categories: [
            AdvisorQuestionCategory(
                id: "beh_adv_a",
                emoji: "🧠",
                title: "Behavioral Self-Awareness",
                subtitle: "Whether they recognize and manage their own biases",
                questions: [
                    AdvisorQuestion(
                        id: "beh_q1",
                        question: "\"What cognitive biases do you think most commonly affect financial advisors — and how do you guard against them in your own practice?\"",
                        inadequateAnswers: [
                            "\"I don't really have biases — I follow a process\"",
                            "Generic answer not tied to their actual practice",
                            "Can only name one bias with no mitigation strategy"
                        ],
                        competentAnswers: [
                            "Names specific biases: overconfidence, recency bias, confirmation bias, herding",
                            "Describes concrete process-level safeguards: checklists, investment committees, devil's advocate reviews",
                            "Discusses how they document and review past decisions to identify patterns",
                            "Acknowledges that no advisor is fully immune — the goal is mitigation, not elimination"
                        ],
                        whyItMatters: "Advisors who believe they are unaffected by cognitive bias are exhibiting overconfidence — itself a major bias. Self-aware advisors build better systems and make fewer systematic errors."
                    ),
                    AdvisorQuestion(
                        id: "beh_q2",
                        question: "\"Have you ever caught yourself making a recommendation influenced more by recent market events than by your client's long-term plan? How did you handle it?\"",
                        inadequateAnswers: [
                            "Denies it ever happens",
                            "Can't give a specific example",
                            "Frames recency bias as rational updating rather than a bias"
                        ],
                        competentAnswers: [
                            "Gives a credible, specific example without violating client confidentiality",
                            "Explains how they caught it — a checklist, a colleague, a process step",
                            "Describes what they changed in their practice as a result",
                            "Distinguishes between recency bias and genuine new information"
                        ],
                        whyItMatters: "Recency bias — overweighting recent events — is one of the most common drivers of advisor performance chasing. An advisor who can describe catching and correcting it is more trustworthy than one who claims immunity."
                    )
                ]
            ),
            AdvisorQuestionCategory(
                id: "beh_adv_b",
                emoji: "📉",
                title: "Managing Client Behavior",
                subtitle: "Their framework for helping you make better decisions",
                questions: [
                    AdvisorQuestion(
                        id: "beh_q3",
                        question: "\"What is your process for helping clients avoid panic selling during a significant drawdown?\"",
                        inadequateAnswers: [
                            "\"I remind them that markets always recover\"",
                            "Relies entirely on verbal reassurance in the moment",
                            "No pre-established protocol or written plan"
                        ],
                        competentAnswers: [
                            "References a written investment policy statement (IPS) that defines acceptable volatility in advance",
                            "Describes a pre-commitment protocol: rules agreed to before volatility occurs",
                            "Explains their communication cadence during drawdowns (proactive, not reactive)",
                            "Mentions behavioral coaching techniques: reframing, historical context, outcome visualization"
                        ],
                        whyItMatters: "The average investor significantly underperforms the average fund because of behavioral mistakes made during volatility. An advisor's value is highest precisely when markets are worst — their process matters more than their reassurances."
                    ),
                    AdvisorQuestion(
                        id: "beh_q4",
                        question: "\"How do you present portfolio options to clients — and do you think about how the framing of those options affects their choices?\"",
                        inadequateAnswers: [
                            "No awareness of framing effects",
                            "Presents options identically regardless of client psychology",
                            "\"I just give people the facts\""
                        ],
                        competentAnswers: [
                            "Demonstrates awareness of framing effects (same information presented differently yields different choices)",
                            "Discusses how they use loss framing vs. gain framing thoughtfully",
                            "Mentions default options and how they set them deliberately",
                            "Describes how they adjust presentation style for different client risk temperaments"
                        ],
                        whyItMatters: "Research by Kahneman and Thaler shows that how options are framed — not just their content — substantially affects decisions. Advisors who understand this either use it to nudge clients toward better choices or, less ethically, toward higher-commission products."
                    )
                ]
            ),
            AdvisorQuestionCategory(
                id: "beh_adv_c",
                emoji: "🎯",
                title: "Goal-Based Planning",
                subtitle: "Whether they align your portfolio to your actual life goals",
                questions: [
                    AdvisorQuestion(
                        id: "beh_q5",
                        question: "\"Do you use mental accounting in your planning — separating money into distinct buckets for different goals — or do you treat the portfolio as a single unit? Why?\"",
                        inadequateAnswers: [
                            "Has no view on this",
                            "Dismisses mental accounting as irrational without engaging with its practical benefits",
                            "No awareness of the trade-offs between approaches"
                        ],
                        competentAnswers: [
                            "Explains both approaches honestly: unified portfolio is mathematically optimal; bucketing is behaviorally effective",
                            "Discusses how they choose based on client psychology and planning complexity",
                            "Notes that bucketing can reduce panic selling by making long-term funds feel 'off limits'",
                            "Mentions liability-matching and goal-based investing frameworks"
                        ],
                        whyItMatters: "Mental accounting is technically irrational but behaviorally powerful. The best advisors use it deliberately — not because they don't know better, but because they understand that a plan clients can stick to beats a mathematically perfect plan they abandon."
                    )
                ]
            )
        ]
    )
}

// MARK: - Gender Lens Investing Advisor Questions

struct GenderLensAdvisorData {
    static let questionSet = AdvisorQuestionSet(
        id: "gender_advisor_qs",
        moduleId: "mod_gender",
        title: "Questions for Your Financial Advisor",
        subtitle: "Evaluate whether your advisor understands the gender dimensions of investing — from the confidence gap to gender lens investing strategies.",
        disclaimer: "For educational purposes only. Not financial advice. Content informed by OECD research, UN Women Economic Empowerment reports, Catalyst, and Veris Wealth Partners gender lens investing research.",
        categories: [
            AdvisorQuestionCategory(
                id: "gen_lens_a",
                emoji: "⚖️",
                title: "Understanding the Advice Gap",
                subtitle: "Whether they recognize structural differences in how women are served",
                questions: [
                    AdvisorQuestion(
                        id: "gla_q1",
                        question: "\"Research shows women are more likely to be given conservative investment advice than men with identical financial profiles. How do you ensure that doesn't happen in your practice?\"",
                        inadequateAnswers: [
                            "Dismisses the research",
                            "\"I treat everyone the same\" without a process to verify this",
                            "No structured way to calibrate advice against client-stated preferences"
                        ],
                        competentAnswers: [
                            "Acknowledges the research and its implications",
                            "Describes a process for calibrating recommendations against stated risk tolerance — not assumed tolerance",
                            "Reviews portfolio construction decisions for gender-correlated patterns",
                            "Distinguishes between a client choosing conservative allocations and an advisor defaulting to them"
                        ],
                        whyItMatters: "The advice gap is well-documented: women are systematically steered toward more conservative allocations regardless of their stated risk tolerance and time horizon. This compounds over decades into materially lower outcomes."
                    ),
                    AdvisorQuestion(
                        id: "gla_q2",
                        question: "\"How do you handle situations where a client's partner or spouse disagrees with the investment approach — particularly when the client you're working with is a woman?\"",
                        inadequateAnswers: [
                            "Defers to the higher-earning spouse by default",
                            "Doesn't engage with the dynamics",
                            "No process for ensuring both partners are genuinely heard"
                        ],
                        competentAnswers: [
                            "Describes how they establish individual client relationships even within couples",
                            "Has a process for ensuring each partner's goals and risk tolerance are captured independently",
                            "Discusses how they handle disagreement without defaulting to the highest earner's preference",
                            "Recognizes life transitions — divorce, widowhood — and has a plan for supporting clients through them"
                        ],
                        whyItMatters: "Women are statistically likely to outlive their partners and manage significant assets alone. Advisors who have never built an independent relationship with both partners leave clients profoundly underserved at exactly the wrong moment."
                    )
                ]
            ),
            AdvisorQuestionCategory(
                id: "gen_lens_b",
                emoji: "🌱",
                title: "Gender Lens Investing",
                subtitle: "Whether they can implement a gender lens strategy if you want one",
                questions: [
                    AdvisorQuestion(
                        id: "gla_q3",
                        question: "\"Can you describe what gender lens investing is and whether you have experience implementing it for clients?\"",
                        inadequateAnswers: [
                            "Has never heard of it",
                            "Conflates it entirely with ESG without distinguishing the specific gender focus",
                            "\"We don't do that kind of investing\""
                        ],
                        competentAnswers: [
                            "Defines gender lens investing: directing capital to companies that advance gender equity — board diversity, pay equity, supply chain practices, products serving women",
                            "Distinguishes between screening approaches and proactive impact strategies",
                            "Names specific funds, indices, or managers with gender lens mandates",
                            "Discusses the performance data: evidence that gender-diverse leadership correlates with stronger returns"
                        ],
                        whyItMatters: "Gender lens investing is a distinct and growing strategy with its own data, managers, and performance literature. An advisor who can't describe it cannot implement it — and may not raise it as an option even if it aligns with your values."
                    ),
                    AdvisorQuestion(
                        id: "gla_q4",
                        question: "\"How do you measure and report on gender lens metrics in a portfolio — and what data sources do you use?\"",
                        inadequateAnswers: [
                            "No awareness of gender data providers",
                            "Relies solely on company self-reporting",
                            "Can't distinguish between input metrics (board composition) and outcome metrics (pay equity)"
                        ],
                        competentAnswers: [
                            "Names data providers: Equileap, Bloomberg Gender-Equality Index, MSCI Women on Boards",
                            "Distinguishes between governance metrics (board representation) and operational metrics (pay equity, parental leave)",
                            "Discusses limitations of self-reported data and how they verify it",
                            "Explains how they incorporate gender metrics into regular portfolio reporting"
                        ],
                        whyItMatters: "Without reliable data, gender lens claims become marketing. Advisors who can name specific data sources and distinguish between metric types are actually implementing the strategy — not just describing it."
                    )
                ]
            )
        ]
    )
}

// MARK: - General Portfolio & Behavioral Advisor Questions

struct GeneralAdvisorData {
    static let questionSet = AdvisorQuestionSet(
        id: "general_advisor_qs",
        moduleId: "mod_women",
        title: "Questions for Any Financial Advisor",
        subtitle: "Foundational questions to evaluate any financial advisor's competency, ethics, and alignment with your interests — regardless of asset class.",
        disclaimer: "For educational purposes only. Not financial advice. Content informed by the CFP Board, NAPFA, SEC fiduciary standards, and CFA Institute Code of Ethics.",
        categories: [
            AdvisorQuestionCategory(
                id: "gen_adv_a",
                emoji: "🛡️",
                title: "Fiduciary Duty",
                subtitle: "Whether they are legally required to act in your interest",
                questions: [
                    AdvisorQuestion(
                        id: "gen_q1",
                        question: "\"Are you a fiduciary at all times when advising me — and will you put that in writing?\"",
                        inadequateAnswers: [
                            "\"I always act in your best interest\" without confirming fiduciary status",
                            "Explains they operate under a suitability standard, not fiduciary",
                            "Hesitates or deflects on the written confirmation"
                        ],
                        competentAnswers: [
                            "Clearly confirms fiduciary status under the Investment Advisers Act",
                            "Distinguishes fiduciary duty from the broker-dealer suitability standard",
                            "Willing to provide written fiduciary acknowledgment",
                            "Explains what fiduciary means in practice for your engagement"
                        ],
                        whyItMatters: "The suitability standard allows an advisor to recommend a product that is 'suitable' for you even if it is not the best option available. Fiduciary advisors must act in your best interest — the distinction matters enormously over a long relationship."
                    ),
                    AdvisorQuestion(
                        id: "gen_q2",
                        question: "\"How are you compensated, and do you receive any payments from product providers?\"",
                        inadequateAnswers: [
                            "Vague answer about compensation",
                            "Claims to be \"fee-only\" while receiving 12b-1 fees or referral payments",
                            "Doesn't proactively disclose all revenue sources"
                        ],
                        competentAnswers: [
                            "Clearly explains fee structure: AUM-based, flat fee, hourly, or commission",
                            "Discloses any 12b-1 fund fees, referral fees, or revenue sharing arrangements",
                            "References their Form ADV Part 2 for full compensation disclosure",
                            "Distinguishes between fee-only (no product commissions) and fee-based (may include commissions)"
                        ],
                        whyItMatters: "Hidden compensation creates conflicts of interest. Advisors who earn commissions from product sales have an incentive to recommend those products over potentially better alternatives."
                    )
                ]
            ),
            AdvisorQuestionCategory(
                id: "gen_adv_b",
                emoji: "🧠",
                title: "Behavioral Awareness",
                subtitle: "Whether they account for the psychology of investing",
                questions: [
                    AdvisorQuestion(
                        id: "gen_q3",
                        question: "\"How do you help clients avoid making emotional decisions during market volatility?\"",
                        inadequateAnswers: [
                            "\"I tell them not to panic\"",
                            "No structured process beyond reassurance",
                            "Relies entirely on the client's self-discipline"
                        ],
                        competentAnswers: [
                            "Describes a written investment policy statement (IPS) that guides behavior in advance",
                            "Discusses pre-commitment strategies: rules agreed upon before volatility occurs",
                            "References specific behavioral biases they help clients manage (loss aversion, recency bias)",
                            "Has a documented process for client communication during drawdowns"
                        ],
                        whyItMatters: "Studies consistently show that investor returns lag fund returns — the gap is largely explained by behavioral mistakes made during volatility. An advisor without a behavioral framework is leaving one of their most valuable functions unfulfilled."
                    ),
                    AdvisorQuestion(
                        id: "gen_q4",
                        question: "\"Have you ever recommended against a client's wishes because you believed they were making a behavioral mistake? What happened?\"",
                        inadequateAnswers: [
                            "\"I always do what the client wants\"",
                            "Can't give a specific example",
                            "Frames pushback as a service failure rather than a fiduciary act"
                        ],
                        competentAnswers: [
                            "Gives a specific, credible example without violating client confidentiality",
                            "Explains their process for documenting disagreements",
                            "Distinguishes between client autonomy and enabling demonstrably harmful decisions",
                            "Discusses how they balance respecting client wishes with their fiduciary obligation"
                        ],
                        whyItMatters: "An advisor who never pushes back is not advising — they are order-taking. The most valuable advisor moments often involve uncomfortable conversations."
                    )
                ]
            ),
            AdvisorQuestionCategory(
                id: "gen_adv_c",
                emoji: "📋",
                title: "Planning Process",
                subtitle: "How they build and maintain your financial plan",
                questions: [
                    AdvisorQuestion(
                        id: "gen_q5",
                        question: "\"How often do you review my plan, and what triggers an unscheduled review?\"",
                        inadequateAnswers: [
                            "\"Whenever you call us\"",
                            "Annual review only with no proactive triggers",
                            "No clear process for life event integration"
                        ],
                        competentAnswers: [
                            "Describes scheduled review cadence (minimum annual, often semi-annual)",
                            "Lists specific triggers for unscheduled reviews: job change, inheritance, marriage, divorce, health event",
                            "Explains how they stay current on your situation between reviews",
                            "Discusses how tax law changes or market regime shifts prompt proactive outreach"
                        ],
                        whyItMatters: "A financial plan that is only reviewed annually is already out of date. Life changes rapidly — an advisor should have a clear protocol for keeping pace."
                    ),
                    AdvisorQuestion(
                        id: "gen_q6",
                        question: "\"What happens to my account if you retire, leave the firm, or the firm is acquired?\"",
                        inadequateAnswers: [
                            "\"Don't worry about that\"",
                            "Vague references to the firm handling it",
                            "No succession plan in place"
                        ],
                        competentAnswers: [
                            "Describes a written succession plan with a named successor advisor",
                            "Explains the custodial structure and how assets are held separately from the firm",
                            "Discusses client notification requirements and transition process",
                            "Notes that client assets at independent custodians (Schwab, Fidelity) are protected regardless of firm events"
                        ],
                        whyItMatters: "Advisor transitions are disruptive. Clients who haven't asked this question often discover the answer during a stressful moment — after a departure or acquisition — rather than before."
                    )
                ]
            )
        ]
    )
}

// MARK: - Preview

#Preview("DeFi Advisor Questions") {
    ScrollView {
        DeFiAdvisorQuestionsTabView()
    }
    .background(Color.surfacePrimary)
}
