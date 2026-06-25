//
//  InteractiveBehavioralEconomics.swift
//  Enhanced App for Alt Assets
//
//  Created by Victoria Case on 2/5/26.
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//
//  Description: Interactive learning experiences for Behavioral Economics module.
//  Includes scenario-based learning, bias identification exercises, decision
//  simulations, and "What Would You Do?" challenges.
//

import SwiftUI
import Combine

// MARK: - Interactive Scenario Model
struct BehavioralScenario: Identifiable, Codable {
    let id: String
    var title: String
    var emoji: String
    var context: String
    var situation: String
    var choices: [ScenarioChoice]
    var biasInvolved: [String]
    var learningPoint: String
    var followUpQuestion: String?
    var category: ScenarioCategory

    enum ScenarioCategory: String, Codable, CaseIterable {
        case confirmationBias = "Confirmation Bias"
        case overconfidence = "Overconfidence"
        case lossAversion = "Loss Aversion"
        case anchoring = "Anchoring"
        case herdMentality = "Herd Mentality"
        case recencyBias = "Recency Bias"
        case genderLens = "Gender Lens"
        case choiceArchitecture = "Choice Architecture"

        var color: Color {
            switch self {
            case .confirmationBias: return .info
            case .overconfidence: return .warning
            case .lossAversion: return .error
            case .anchoring: return .brandPrimary
            case .herdMentality: return .brandAccent
            case .recencyBias: return .brandHighlight
            case .genderLens: return .success
            case .choiceArchitecture: return .info
            }
        }

        var emoji: String {
            switch self {
            case .confirmationBias: return "🔍"
            case .overconfidence: return "🦚"
            case .lossAversion: return "😰"
            case .anchoring: return "⚓"
            case .herdMentality: return "🐑"
            case .recencyBias: return "📅"
            case .genderLens: return "👁️"
            case .choiceArchitecture: return "🧩"
            }
        }
    }
}

struct ScenarioChoice: Identifiable, Codable, Hashable {
    let id: String
    var text: String
    var isOptimal: Bool
    var feedback: String
    var biasRevealed: String?
}

// MARK: - Brain Region Data
struct BrainRegionInfo: Identifiable {
    let id: String
    var name: String
    var emoji: String
    var function: String
    var investingRelevance: String
    var investingDecisions: [String]
    var hijackPatterns: [String]
    var navigationStrategies: [String]
    var color: Color
}

// MARK: - Interactive Behavioral Economics Manager
class InteractiveBEManager: ObservableObject {
    @Published var scenarios: [BehavioralScenario] = []
    @Published var completedScenarios: Set<String> = []
    @Published var userResponses: [String: String] = [:] // scenarioId -> choiceId

    static let shared = InteractiveBEManager()

    private let completedKey = "completedBEScenarios"
    private let responsesKey = "beScenarioResponses"

    init() {
        loadScenarios()
        loadProgress()
    }

    func loadScenarios() {
        scenarios = [
            // MARK: - Confirmation Bias Scenarios
            BehavioralScenario(
                id: "scenario-cb-1",
                title: "The Research Rabbit Hole",
                emoji: "🐇",
                context: "You're researching a renewable energy startup you believe in. After two hours of reading, you've found 10 articles — 7 bullish, 3 critical.",
                situation: "The 3 critical articles focus on the company's weak financials and tough competitive position. You haven't read them yet. What do you do?",
                choices: [
                    ScenarioChoice(
                        id: "cb1-a",
                        text: "Focus on the 7 positive articles - they represent the majority opinion",
                        isOptimal: false,
                        feedback: "This demonstrates confirmation bias. The majority of articles agreeing doesn't make them right. The 3 critical articles might contain crucial information about company-specific risks.",
                        biasRevealed: "Confirmation Bias"
                    ),
                    ScenarioChoice(
                        id: "cb1-b",
                        text: "Deliberately read the 3 critical articles first, then re-evaluate",
                        isOptimal: true,
                        feedback: "Excellent approach! Actively seeking disconfirming evidence is one of the best ways to combat confirmation bias. The critical articles might reveal risks you hadn't considered.",
                        biasRevealed: nil
                    ),
                    ScenarioChoice(
                        id: "cb1-c",
                        text: "Find more articles until you have a clearer picture",
                        isOptimal: false,
                        feedback: "Be careful - if you're not deliberately seeking opposing views, you might just find more articles that confirm your existing belief. Quality of analysis matters more than quantity.",
                        biasRevealed: "Confirmation Bias (continued)"
                    )
                ],
                biasInvolved: ["Confirmation Bias"],
                learningPoint: "Actively seek information that challenges your thesis. The best investors practice 'steel-manning' - making the strongest possible argument against their own position.",
                followUpQuestion: "Think of a recent decision where you might have only sought confirming information. What opposing view could you have considered?",
                category: .confirmationBias
            ),

            // MARK: - Overconfidence Scenarios
            BehavioralScenario(
                id: "scenario-oc-1",
                title: "The Hot Streak",
                emoji: "🔥",
                context: "You've picked 5 winners in a row, beating the market by 15% over the past 6 months. You're feeling sharp.",
                situation: "Now you want to put 40% of your portfolio into a single biotech bet. Your normal position size limit is 10%. What do you do?",
                choices: [
                    ScenarioChoice(
                        id: "oc1-a",
                        text: "Go for it - your track record proves you have skill at picking winners",
                        isOptimal: false,
                        feedback: "This is classic overconfidence bias. A 5-trade winning streak could easily be luck in a market that's been generally rising. Studies show even professional fund managers rarely beat the market consistently over 10+ years.",
                        biasRevealed: "Overconfidence Bias"
                    ),
                    ScenarioChoice(
                        id: "oc1-b",
                        text: "Stick to your normal position sizing rules regardless of recent success",
                        isOptimal: true,
                        feedback: "Smart move. Position sizing rules exist precisely to protect you from the overconfidence that comes with winning streaks. The market doesn't care about your past performance.",
                        biasRevealed: nil
                    ),
                    ScenarioChoice(
                        id: "oc1-c",
                        text: "Increase position to 25% - a compromise between confidence and caution",
                        isOptimal: false,
                        feedback: "Even a 'moderate' increase based on past success is overconfidence in action. Ask yourself: would you have considered 25% before your winning streak? If not, you're letting recency bias drive decisions.",
                        biasRevealed: "Overconfidence + Recency Bias"
                    )
                ],
                biasInvolved: ["Overconfidence Bias", "Recency Bias"],
                learningPoint: "Research by Barber and Odean shows that overconfident investors trade more frequently and earn lower returns. Past performance truly doesn't guarantee future results.",
                followUpQuestion: "How do you distinguish between genuine skill and luck in your past decisions?",
                category: .overconfidence
            ),

            // MARK: - Loss Aversion Scenarios
            BehavioralScenario(
                id: "scenario-la-1",
                title: "The Underwater Position",
                emoji: "🌊",
                context: "You invested $10,000 in a tech stock six months ago. It's now worth $6,500 — a $3,500 loss.",
                situation: "The company just lost a major contract, and two competitors launched better products. Analysts have slashed their price targets. What do you do?",
                choices: [
                    ScenarioChoice(
                        id: "la1-a",
                        text: "Hold until you break even - you can't afford to lock in this loss",
                        isOptimal: false,
                        feedback: "This is loss aversion in action. The stock doesn't know what price you bought it at. If you wouldn't buy it today at $6,500, you probably shouldn't hold it. Waiting to 'break even' is emotional, not rational.",
                        biasRevealed: "Loss Aversion"
                    ),
                    ScenarioChoice(
                        id: "la1-b",
                        text: "Evaluate the stock as if you were considering buying it fresh today at $6,500",
                        isOptimal: true,
                        feedback: "This is the rational approach. Your purchase price is a 'sunk cost' - irrelevant to the decision of whether to hold or sell. The only question is: given what you know now, is this stock worth holding?",
                        biasRevealed: nil
                    ),
                    ScenarioChoice(
                        id: "la1-c",
                        text: "Buy more to lower your average cost - if it recovers, you'll profit more",
                        isOptimal: false,
                        feedback: "'Averaging down' on a deteriorating position is often loss aversion disguised as strategy. Unless the new information makes you MORE bullish (which seems unlikely here), this is throwing good money after bad.",
                        biasRevealed: "Loss Aversion + Sunk Cost Fallacy"
                    )
                ],
                biasInvolved: ["Loss Aversion", "Sunk Cost Fallacy"],
                learningPoint: "Losses hurt about 2x as much as gains feel good. This asymmetry causes us to make irrational decisions to avoid 'realizing' losses, even when selling would be the smarter move.",
                followUpQuestion: "Is there a position in your life (financial or otherwise) you're holding onto mainly because you've already invested so much?",
                category: .lossAversion
            ),

            // MARK: - Anchoring Scenarios
            BehavioralScenario(
                id: "scenario-an-1",
                title: "The IPO Anchor",
                emoji: "⚓",
                context: "A company you follow went public at $50/share three months ago. The IPO price was everywhere — news, podcasts, group chats.",
                situation: "The stock is now at $35. Analysts say the IPO was overpriced and $30–35 is fair value. The fundamentals haven't changed. What do you do?",
                choices: [
                    ScenarioChoice(
                        id: "an1-a",
                        text: "It's a bargain at $35 - that's 30% below the IPO price!",
                        isOptimal: false,
                        feedback: "You're anchoring to the IPO price, which was an arbitrary number set by investment bankers to maximize proceeds. The fact that it's 'down 30%' from a potentially inflated price tells you nothing about value.",
                        biasRevealed: "Anchoring Bias"
                    ),
                    ScenarioChoice(
                        id: "an1-b",
                        text: "Ignore the IPO price entirely and analyze the company's intrinsic value",
                        isOptimal: true,
                        feedback: "This is the right approach. The IPO price was a marketing number, not a measure of value. Only the company's fundamentals - earnings, growth, competitive position - should drive your analysis.",
                        biasRevealed: nil
                    ),
                    ScenarioChoice(
                        id: "an1-c",
                        text: "Wait for it to drop more - it might return to pre-IPO levels",
                        isOptimal: false,
                        feedback: "You're still anchoring, just to a different reference point. There's no rule that says stocks must trade at any particular level relative to their IPO price.",
                        biasRevealed: "Anchoring Bias (different anchor)"
                    )
                ],
                biasInvolved: ["Anchoring Bias"],
                learningPoint: "The first number you see becomes a powerful anchor. IPO prices, 52-week highs, analyst price targets - these are all arbitrary anchors that shouldn't drive your investment decisions.",
                followUpQuestion: "What anchors might be influencing your current financial decisions?",
                category: .anchoring
            ),

            // MARK: - Herd Mentality Scenarios
            BehavioralScenario(
                id: "scenario-hm-1",
                title: "The Social Media Frenzy",
                emoji: "📱",
                context: "A stock you've never heard of is up 200% this week. It's all over social media, the news, and your group chats.",
                situation: "Friends are posting screenshots of their gains. Influencers say it's going higher. You feel like you're the only one not in. What do you do?",
                choices: [
                    ScenarioChoice(
                        id: "hm1-a",
                        text: "Jump in quickly before you miss more gains",
                        isOptimal: false,
                        feedback: "FOMO (Fear Of Missing Out) is herd mentality in action. By the time something is trending everywhere, the early gains have often already been made. You might be buying at the top.",
                        biasRevealed: "Herd Mentality / FOMO"
                    ),
                    ScenarioChoice(
                        id: "hm1-b",
                        text: "Do your own research before making any decision",
                        isOptimal: true,
                        feedback: "This is the rational approach. Social buzz is not due diligence. Understanding WHY something is moving and whether that reason is sustainable is more important than not missing out.",
                        biasRevealed: nil
                    ),
                    ScenarioChoice(
                        id: "hm1-c",
                        text: "Put in a small 'fun money' position so you don't feel left out",
                        isOptimal: false,
                        feedback: "This is still herd behavior, just with a rationalization attached. If you can't explain why the investment makes sense beyond 'everyone's doing it,' you're speculating, not investing.",
                        biasRevealed: "Herd Mentality (rationalized)"
                    )
                ],
                biasInvolved: ["Herd Mentality", "FOMO", "Social Proof"],
                learningPoint: "Humans evolved to follow the crowd for survival. In investing, this instinct often leads us to buy high (when everyone's excited) and sell low (when everyone's panicking).",
                followUpQuestion: "When have you made a decision primarily because 'everyone else was doing it'?",
                category: .herdMentality
            ),

            // MARK: - Gender Lens Scenarios
            BehavioralScenario(
                id: "scenario-gl-1",
                title: "The Investment Club",
                emoji: "👥",
                context: "You're in an investment club debating a stock that's up 15% in 3 months. The group's original thesis was a 2-year hold.",
                situation: "Half the club wants to sell and 'lock in gains.' The other half says nothing has changed — stick to the plan. What do you do?",
                choices: [
                    ScenarioChoice(
                        id: "gl1-a",
                        text: "Sell now - a 15% gain in 3 months is great, take the win",
                        isOptimal: false,
                        feedback: "This reflects short-term thinking. If your original thesis was 2 years, and nothing has changed except the price went up, why would you abandon the strategy? Research shows frequent trading often reduces returns.",
                        biasRevealed: "Short-termism"
                    ),
                    ScenarioChoice(
                        id: "gl1-b",
                        text: "Re-evaluate the original thesis - has anything fundamentally changed?",
                        isOptimal: true,
                        feedback: "This is disciplined investing. The fact that a stock is up doesn't mean your thesis is complete. Studies show investors (particularly women) who trade less and stick to long-term strategies often outperform.",
                        biasRevealed: nil
                    ),
                    ScenarioChoice(
                        id: "gl1-c",
                        text: "Sell half to reduce risk while keeping upside exposure",
                        isOptimal: false,
                        feedback: "While this sounds balanced, it's often a way to feel good about 'doing something' without a clear strategic reason. If the thesis is intact, selling half doesn't serve the strategy.",
                        biasRevealed: "Action Bias"
                    )
                ],
                biasInvolved: ["Short-termism", "Action Bias"],
                learningPoint: "Research by Barber & Odean found that women investors outperformed men by about 1% annually, largely because they traded less frequently and avoided overconfidence-driven decisions.",
                followUpQuestion: "Do you tend to take action for the sake of 'doing something' even when waiting might be better?",
                category: .genderLens
            ),

            // MARK: - Choice Architecture
            BehavioralScenario(
                id: "scenario-ca-1",
                title: "The Default Dilemma",
                emoji: "🎯",
                context: "Your employer just rolled out a new retirement plan. You're auto-enrolled in a target-date fund with moderate fees.",
                situation: "You can stick with the default, pick your own funds, or opt out. You've been meaning to look into it but haven't yet. What do you do?",
                choices: [
                    ScenarioChoice(
                        id: "ca1-a",
                        text: "Stick with the default - it's probably fine for most people",
                        isOptimal: false,
                        feedback: "Defaults are powerful. They're chosen by someone else based on average needs, not your specific situation. 'Fine for most people' might not be optimal for you.",
                        biasRevealed: "Status Quo Bias"
                    ),
                    ScenarioChoice(
                        id: "ca1-b",
                        text: "Research all options and make an active choice that fits your goals",
                        isOptimal: true,
                        feedback: "Excellent! Being aware of choice architecture helps you make intentional decisions. The best option for you depends on your age, risk tolerance, and retirement timeline.",
                        biasRevealed: nil
                    ),
                    ScenarioChoice(
                        id: "ca1-c",
                        text: "Opt out - you'll figure it out later when you have more time",
                        isOptimal: false,
                        feedback: "Delaying important financial decisions is costly. Every year you wait to invest for retirement is compound growth you miss. This is analysis paralysis meeting procrastination.",
                        biasRevealed: "Analysis Paralysis / Procrastination"
                    )
                ],
                biasInvolved: ["Status Quo Bias", "Choice Architecture", "Analysis Paralysis"],
                learningPoint: "Defaults are incredibly powerful - studies show up to 90% of people stick with them. Being aware of this helps you make active, intentional choices instead of passive acceptance.",
                followUpQuestion: "What defaults in your life have you accepted without questioning?",
                category: .choiceArchitecture
            )
        ]
    }

    // MARK: - Progress Management
    func loadProgress() {
        if let data = UserDefaults.standard.data(forKey: completedKey),
           let completed = try? JSONDecoder().decode(Set<String>.self, from: data) {
            completedScenarios = completed
        }

        if let data = UserDefaults.standard.data(forKey: responsesKey),
           let responses = try? JSONDecoder().decode([String: String].self, from: data) {
            userResponses = responses
        }
    }

    func saveProgress() {
        if let data = try? JSONEncoder().encode(completedScenarios) {
            UserDefaults.standard.set(data, forKey: completedKey)
        }
        if let data = try? JSONEncoder().encode(userResponses) {
            UserDefaults.standard.set(data, forKey: responsesKey)
        }
    }

    func markScenarioComplete(_ scenarioId: String, choiceId: String) {
        completedScenarios.insert(scenarioId)
        userResponses[scenarioId] = choiceId
        saveProgress()
    }

    func isScenarioComplete(_ scenarioId: String) -> Bool {
        completedScenarios.contains(scenarioId)
    }

    func scenariosByCategory(_ category: BehavioralScenario.ScenarioCategory) -> [BehavioralScenario] {
        scenarios.filter { $0.category == category }
    }

    var completionProgress: Double {
        guard !scenarios.isEmpty else { return 0 }
        return Double(completedScenarios.count) / Double(scenarios.count)
    }
}

// MARK: - Brain Regions Data
let brainRegionsForInvesting: [BrainRegionInfo] = [
    BrainRegionInfo(
        id: "prefrontal",
        name: "Prefrontal Cortex",
        emoji: "🧠",
        function: "Executive function, planning, rational analysis",
        investingRelevance: "Your investing ally — engaged when analyzing data, building strategies, and resisting impulse decisions",
        investingDecisions: [
            "Setting and sticking to an investment thesis",
            "Comparing risk/reward before entering a position",
            "Rebalancing your portfolio on a schedule",
            "Walking away from a bad deal despite social pressure"
        ],
        hijackPatterns: [
            "Gets overridden when you're tired, stressed, or emotionally charged",
            "Shuts down during market panic — amygdala takes the wheel",
            "Can rationalize bad decisions after the fact (post-hoc justification)"
        ],
        navigationStrategies: [
            "Write your investment thesis BEFORE buying — refer back when tempted to deviate",
            "Make major decisions in the morning when this region is freshest",
            "Use checklists to keep rational analysis in control",
            "Sleep on any decision over 5% of your portfolio"
        ],
        color: .info
    ),
    BrainRegionInfo(
        id: "amygdala",
        name: "Amygdala",
        emoji: "⚡",
        function: "Fear response, threat detection, fight-or-flight",
        investingRelevance: "The panic button — activates during crashes and volatility, flooding you with urgency to act NOW",
        investingDecisions: [
            "Panic selling during market downturns",
            "Pulling money out of volatile assets at the worst time",
            "Avoiding entire asset classes because of one bad experience",
            "Freezing and doing nothing when action is actually needed"
        ],
        hijackPatterns: [
            "Turns a -10% dip into 'I'm going to lose everything'",
            "Makes you sell at the bottom and miss the recovery",
            "Creates outsized fear of losses (losses hurt 2x more than gains feel good)",
            "Triggers snap decisions you regret within days"
        ],
        navigationStrategies: [
            "Pre-set stop-losses so you don't decide in the moment",
            "24-hour cooling-off rule: no trades during high emotion",
            "Keep a 'panic protocol' written down — read it before acting",
            "Zoom out: look at 5-year charts, not 5-minute ones"
        ],
        color: .error
    ),
    BrainRegionInfo(
        id: "nucleus-accumbens",
        name: "Nucleus Accumbens",
        emoji: "🎰",
        function: "Reward center, pleasure, dopamine release",
        investingRelevance: "The thrill-seeker — lights up with every green number, creating addictive trading patterns",
        investingDecisions: [
            "Chasing meme stocks and trending assets for the rush",
            "FOMO buying because everyone else is making money",
            "Overtrading — the dopamine hit of placing another trade",
            "Doubling down on winners instead of taking profits"
        ],
        hijackPatterns: [
            "Treats investing like a slot machine — craves the next 'win'",
            "Confuses excitement with good judgment",
            "Makes you check your portfolio 20 times a day",
            "Drives you toward high-risk bets for bigger dopamine hits"
        ],
        navigationStrategies: [
            "Limit portfolio checks to once a week (or less)",
            "Automate investments to remove the 'thrill of the trade'",
            "Separate a small 'play money' account from your real portfolio",
            "Track your trade frequency — if it's rising, this region is in charge"
        ],
        color: .warning
    ),
    BrainRegionInfo(
        id: "anterior-insula",
        name: "Anterior Insula",
        emoji: "🌡️",
        function: "Risk perception, gut feelings, bodily awareness",
        investingRelevance: "The gut-check — creates physical sensations about risk that can be signal or noise",
        investingDecisions: [
            "That 'something feels off' instinct about a deal",
            "Physical discomfort when a position gets too large",
            "Sensing that a pitch is too good to be true",
            "Feeling uneasy about an advisor's recommendation"
        ],
        hijackPatterns: [
            "Can't distinguish real risk signals from general anxiety",
            "Makes 'safe' feel synonymous with 'good' — avoiding all volatility",
            "Gut feelings get amplified by recent losses (even unrelated ones)",
            "Creates false confidence when things feel familiar"
        ],
        navigationStrategies: [
            "Journal your gut feelings — track when they're right vs. wrong",
            "Use gut instinct as a prompt to investigate, not as a final answer",
            "Ask: 'Is this feeling based on this investment or my last one?'",
            "Pair intuition with data — if both agree, the signal is stronger"
        ],
        color: .brandPrimary
    )
]

// MARK: - Interactive Scenarios List View
struct InteractiveScenariosListView: View {
    @ObservedObject var manager = InteractiveBEManager.shared
    @State private var selectedCategory: BehavioralScenario.ScenarioCategory?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                // Header
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Text("🧠")
                        .font(.system(size: 40))

                    Text("What Would You Do?")
                        .font(Typography.title1)
                        .foregroundColor(.textPrimary)

                    Text("Interactive scenarios to understand your behavioral patterns in investing")
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
                        Text("\(manager.completedScenarios.count)/\(manager.scenarios.count)")
                            .font(Typography.caption)
                            .foregroundColor(.textSecondary)
                    }

                    ProgressView(value: manager.completionProgress)
                        .tint(.brandPrimary)
                }
                .padding(.horizontal, Spacing.lg)

                // Category Filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: Spacing.sm) {
                        CategoryFilterChip(
                            title: "All",
                            emoji: "📚",
                            isSelected: selectedCategory == nil,
                            color: .brandPrimary
                        ) {
                            selectedCategory = nil
                        }

                        ForEach(BehavioralScenario.ScenarioCategory.allCases, id: \.self) { category in
                            CategoryFilterChip(
                                title: category.rawValue,
                                emoji: category.emoji,
                                isSelected: selectedCategory == category,
                                color: category.color
                            ) {
                                selectedCategory = category
                            }
                        }
                    }
                    .padding(.horizontal, Spacing.lg)
                }

                // Scenarios
                let filteredScenarios: [BehavioralScenario] = {
                    guard let category = selectedCategory else { return manager.scenarios }
                    return manager.scenariosByCategory(category)
                }()

                LazyVStack(spacing: Spacing.md) {
                    ForEach(filteredScenarios) { scenario in
                        NavigationLink(destination: ScenarioDetailView(scenario: scenario)) {
                            ScenarioCard(scenario: scenario)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, Spacing.lg)
            }
            .padding(.vertical, Spacing.lg)
        }
        .background(Color.surfacePrimary)
        .navigationTitle("Interactive Learning")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

// MARK: - Category Filter Chip
struct CategoryFilterChip: View {
    let title: String
    let emoji: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.xs) {
                Text(emoji)
                    .font(.system(size: 12))
                Text(title)
                    .font(Typography.caption)
            }
            .padding(.horizontal, Spacing.sm)
            .padding(.vertical, Spacing.xs)
            .background(isSelected ? color : Color.surfaceSecondary)
            .foregroundColor(isSelected ? .white : .textSecondary)
            .clipShape(Capsule())
        }
    }
}

// MARK: - Scenario Card
struct ScenarioCard: View {
    let scenario: BehavioralScenario
    @ObservedObject var manager = InteractiveBEManager.shared

    var isComplete: Bool {
        manager.isScenarioComplete(scenario.id)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack {
                Text(scenario.emoji)
                    .font(.system(size: 24))

                VStack(alignment: .leading, spacing: 2) {
                    Text(scenario.title)
                        .font(Typography.bodyMedium)
                        .foregroundColor(.textPrimary)

                    Text(scenario.category.rawValue)
                        .font(Typography.caption2)
                        .foregroundColor(scenario.category.color)
                }

                Spacer()

                if isComplete {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.success)
                } else {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.textTertiary)
                }
            }

            Text(scenario.context)
                .font(Typography.caption)
                .foregroundColor(.textSecondary)
                .lineLimit(2)
        }
        .padding(Spacing.md)
        .background(Color.surfaceSecondary)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
    }
}

// MARK: - Scenario Detail View
struct ScenarioDetailView: View {
    let scenario: BehavioralScenario
    @ObservedObject var manager = InteractiveBEManager.shared
    @State private var selectedChoice: ScenarioChoice?
    @State private var showingResult = false
    @State private var showingFollowUp = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.xl) {
                // Header
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    HStack {
                        Text(scenario.emoji)
                            .font(.system(size: 32))
                        Text(scenario.category.rawValue)
                            .font(Typography.caption)
                            .foregroundColor(scenario.category.color)
                            .padding(.horizontal, Spacing.sm)
                            .padding(.vertical, Spacing.xxs)
                            .background(scenario.category.color.opacity(0.1))
                            .clipShape(Capsule())
                    }

                    Text(scenario.title)
                        .font(Typography.title2)
                        .foregroundColor(.textPrimary)
                }

                // Context
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Text("Context")
                        .font(Typography.captionMedium)
                        .foregroundColor(.textTertiary)

                    Text(scenario.context)
                        .font(Typography.body)
                        .foregroundColor(.textSecondary)
                }
                .padding(Spacing.md)
                .background(Color.surfaceSecondary)
                .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))

                // Situation
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Text("The Situation")
                        .font(Typography.captionMedium)
                        .foregroundColor(.textTertiary)

                    Text(scenario.situation)
                        .font(Typography.body)
                        .foregroundColor(.textPrimary)
                }
                .padding(Spacing.md)
                .background(Color.info.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))

                // Choices
                if !showingResult {
                    VStack(alignment: .leading, spacing: Spacing.md) {
                        Text("What would you do?")
                            .font(Typography.bodyMedium)
                            .foregroundColor(.textPrimary)

                        ForEach(scenario.choices) { choice in
                            ChoiceButton(
                                choice: choice,
                                isSelected: selectedChoice?.id == choice.id
                            ) {
                                selectedChoice = choice
                            }
                        }

                        if let choice = selectedChoice {
                            Button {
                                withAnimation {
                                    showingResult = true
                                    manager.markScenarioComplete(scenario.id, choiceId: choice.id)
                                }
                            } label: {
                                Text("See Result")
                                    .font(Typography.bodyMedium)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(Spacing.md)
                                    .background(Color.brandPrimary)
                                    .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
                            }
                        }
                    }
                } else if let choice = selectedChoice {
                    // Result
                    VStack(alignment: .leading, spacing: Spacing.lg) {
                        // Feedback
                        VStack(alignment: .leading, spacing: Spacing.sm) {
                            HStack {
                                Image(systemName: choice.isOptimal ? "checkmark.circle.fill" : "lightbulb.fill")
                                    .foregroundColor(choice.isOptimal ? .success : .warning)
                                Text(choice.isOptimal ? "Good Thinking!" : "Learning Opportunity")
                                    .font(Typography.bodyMedium)
                                    .foregroundColor(choice.isOptimal ? .success : .warning)
                            }

                            Text(choice.feedback)
                                .font(Typography.body)
                                .foregroundColor(.textSecondary)

                            if let biasRevealed = choice.biasRevealed {
                                HStack(spacing: Spacing.sm) {
                                    Text("🔍")
                                    Text("Bias identified: \(biasRevealed)")
                                        .font(Typography.caption)
                                        .foregroundColor(.textTertiary)
                                }
                                .padding(Spacing.sm)
                                .background(Color.surfaceTertiary)
                                .clipShape(RoundedRectangle(cornerRadius: CornerRadius.sm))
                            }
                        }
                        .padding(Spacing.md)
                        .background(choice.isOptimal ? Color.success.opacity(0.1) : Color.warning.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))

                        // Learning Point
                        VStack(alignment: .leading, spacing: Spacing.sm) {
                            HStack(spacing: Spacing.sm) {
                                Text("💡")
                                Text("Key Takeaway")
                                    .font(Typography.bodyMedium)
                                    .foregroundColor(.textPrimary)
                            }

                            Text(scenario.learningPoint)
                                .font(Typography.body)
                                .foregroundColor(.textSecondary)
                        }
                        .padding(Spacing.md)
                        .background(Color.brandPrimary.opacity(0.05))
                        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))

                        // Follow-up Question
                        if let followUp = scenario.followUpQuestion {
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                HStack(spacing: Spacing.sm) {
                                    Text("🪞")
                                    Text("Reflect")
                                        .font(Typography.bodyMedium)
                                        .foregroundColor(.textPrimary)
                                }

                                Text(followUp)
                                    .font(Typography.body)
                                    .foregroundColor(.textSecondary)
                                    .italic()
                            }
                            .padding(Spacing.md)
                            .background(Color.surfaceSecondary)
                            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
                        }

                        // Done button
                        Button {
                            dismiss()
                        } label: {
                            Text("Done")
                                .font(Typography.bodyMedium)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(Spacing.md)
                                .background(Color.brandPrimary)
                                .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
                        }
                    }
                }
            }
            .padding(Spacing.lg)
        }
        .background(Color.surfacePrimary)
        .navigationTitle(scenario.title)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

// MARK: - Choice Button
struct ChoiceButton: View {
    let choice: ScenarioChoice
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(alignment: .top, spacing: Spacing.sm) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .brandPrimary : .textTertiary)

                Text(choice.text)
                    .font(Typography.body)
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.leading)

                Spacer()
            }
            .padding(Spacing.md)
            .background(isSelected ? Color.brandPrimary.opacity(0.1) : Color.surfaceSecondary)
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.md)
                    .stroke(isSelected ? Color.brandPrimary : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Brain Map View
struct BrainMapView: View {
    @State private var selectedRegion: BrainRegionInfo?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                // Header
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Text("Tap a region to explore")
                        .font(Typography.caption)
                        .foregroundColor(.textTertiary)

                    Text("Your Investor Brain")
                        .font(Typography.title1)
                        .foregroundColor(.textPrimary)

                    Text("Every investing decision starts here. Tap a region to see what decisions it drives — and how to stay in control.")
                        .font(Typography.body)
                        .foregroundColor(.textSecondary)
                }
                .padding(.horizontal, Spacing.lg)

                // Tappable Brain Diagram
                BrainDiagramView(
                    selectedRegion: $selectedRegion,
                    regions: brainRegionsForInvesting
                )
                .padding(.horizontal, Spacing.lg)

                // Selected Region Detail
                if let region = selectedRegion {
                    BrainRegionDetailPanel(region: region)
                        .transition(.asymmetric(
                            insertion: .opacity.combined(with: .move(edge: .bottom)),
                            removal: .opacity
                        ))
                        .padding(.horizontal, Spacing.lg)
                }

                // Key Insight
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    HStack(spacing: Spacing.sm) {
                        Text("💡")
                        Text("Key Insight")
                            .font(Typography.bodyMedium)
                            .foregroundColor(.textPrimary)
                    }

                    Text("You can't remove emotion from investing. But you can learn which part of your brain is talking — and decide whether to listen.")
                        .font(Typography.body)
                        .foregroundColor(.textSecondary)
                }
                .padding(Spacing.md)
                .background(Color.brandPrimary.opacity(0.05))
                .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
                .padding(.horizontal, Spacing.lg)
            }
            .padding(.vertical, Spacing.lg)
        }
        .background(Color.surfacePrimary)
        .navigationTitle("Brain & Investing")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

// MARK: - Tappable Brain Diagram
struct BrainDiagramView: View {
    @Binding var selectedRegion: BrainRegionInfo?
    let regions: [BrainRegionInfo]

    // Region positions as proportions of the diagram size
    private let regionPositions: [String: (x: CGFloat, y: CGFloat)] = [
        "prefrontal": (x: 0.30, y: 0.30),
        "amygdala": (x: 0.55, y: 0.65),
        "nucleus-accumbens": (x: 0.45, y: 0.50),
        "anterior-insula": (x: 0.65, y: 0.42)
    ]

    var body: some View {
        GeometryReader { geo in
            let size = geo.size
            ZStack {
                // Brain silhouette
                BrainShape()
                    .fill(Color.surfaceSecondary)
                    .overlay(
                        BrainShape()
                            .stroke(Color.divider, lineWidth: 1.5)
                    )

                // Tappable region markers
                ForEach(regions) { region in
                    if let pos = regionPositions[region.id] {
                        let isSelected = selectedRegion?.id == region.id
                        BrainRegionMarker(
                            region: region,
                            isSelected: isSelected
                        )
                        .position(x: size.width * pos.x, y: size.height * pos.y)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                if selectedRegion?.id == region.id {
                                    selectedRegion = nil
                                } else {
                                    selectedRegion = region
                                }
                            }
                        }
                    }
                }
            }
        }
        .aspectRatio(1.2, contentMode: .fit)
    }
}

// MARK: - Brain Silhouette Shape
struct BrainShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height

        // Simplified brain profile (left hemisphere view)
        path.move(to: CGPoint(x: w * 0.45, y: h * 0.08))

        // Top of brain — frontal lobe curve
        path.addCurve(
            to: CGPoint(x: w * 0.18, y: h * 0.28),
            control1: CGPoint(x: w * 0.30, y: h * 0.06),
            control2: CGPoint(x: w * 0.18, y: h * 0.12)
        )

        // Front of brain
        path.addCurve(
            to: CGPoint(x: w * 0.15, y: h * 0.55),
            control1: CGPoint(x: w * 0.14, y: h * 0.38),
            control2: CGPoint(x: w * 0.12, y: h * 0.48)
        )

        // Bottom front — temporal lobe
        path.addCurve(
            to: CGPoint(x: w * 0.35, y: h * 0.78),
            control1: CGPoint(x: w * 0.16, y: h * 0.65),
            control2: CGPoint(x: w * 0.22, y: h * 0.76)
        )

        // Brain stem area
        path.addCurve(
            to: CGPoint(x: w * 0.55, y: h * 0.88),
            control1: CGPoint(x: w * 0.42, y: h * 0.82),
            control2: CGPoint(x: w * 0.48, y: h * 0.88)
        )

        // Back bottom — cerebellum
        path.addCurve(
            to: CGPoint(x: w * 0.78, y: h * 0.68),
            control1: CGPoint(x: w * 0.65, y: h * 0.88),
            control2: CGPoint(x: w * 0.78, y: h * 0.80)
        )

        // Back of brain — occipital
        path.addCurve(
            to: CGPoint(x: w * 0.82, y: h * 0.40),
            control1: CGPoint(x: w * 0.82, y: h * 0.58),
            control2: CGPoint(x: w * 0.85, y: h * 0.48)
        )

        // Top back — parietal lobe
        path.addCurve(
            to: CGPoint(x: w * 0.65, y: h * 0.12),
            control1: CGPoint(x: w * 0.82, y: h * 0.28),
            control2: CGPoint(x: w * 0.76, y: h * 0.14)
        )

        // Close to top
        path.addCurve(
            to: CGPoint(x: w * 0.45, y: h * 0.08),
            control1: CGPoint(x: w * 0.56, y: h * 0.08),
            control2: CGPoint(x: w * 0.50, y: h * 0.06)
        )

        path.closeSubpath()
        return path
    }
}

// MARK: - Brain Region Marker (tappable dot)
struct BrainRegionMarker: View {
    let region: BrainRegionInfo
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                // Pulse ring when selected
                if isSelected {
                    Circle()
                        .stroke(region.color.opacity(0.3), lineWidth: 2)
                        .frame(width: 52, height: 52)
                }

                Circle()
                    .fill(isSelected ? region.color : region.color.opacity(0.7))
                    .frame(width: isSelected ? 44 : 36, height: isSelected ? 44 : 36)
                    .shadow(color: region.color.opacity(isSelected ? 0.4 : 0.2), radius: isSelected ? 8 : 4)

                Text(region.emoji)
                    .font(.system(size: isSelected ? 20 : 16))
            }

            Text(region.name)
                .font(isSelected ? Typography.captionMedium : Typography.caption2)
                .foregroundColor(isSelected ? region.color : .textSecondary)
                .lineLimit(1)
                .fixedSize()
        }
        .animation(.spring(response: 0.3), value: isSelected)
    }
}

// MARK: - Brain Region Detail Panel
struct BrainRegionDetailPanel: View {
    let region: BrainRegionInfo
    @State private var selectedTab = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Region header
            HStack(spacing: Spacing.sm) {
                Text(region.emoji)
                    .font(.system(size: 28))

                VStack(alignment: .leading, spacing: 2) {
                    Text(region.name)
                        .font(Typography.title3)
                        .foregroundColor(.textPrimary)

                    Text(region.investingRelevance)
                        .font(Typography.caption)
                        .foregroundColor(.textSecondary)
                }
            }
            .padding(Spacing.md)

            Divider()

            // Tab selector
            HStack(spacing: 0) {
                BrainDetailTab(title: "Decisions", isSelected: selectedTab == 0) { selectedTab = 0 }
                BrainDetailTab(title: "Hijacks", isSelected: selectedTab == 1) { selectedTab = 1 }
                BrainDetailTab(title: "Navigate", isSelected: selectedTab == 2) { selectedTab = 2 }
            }
            .padding(.horizontal, Spacing.sm)
            .padding(.top, Spacing.xs)

            Divider()

            // Tab content
            VStack(alignment: .leading, spacing: Spacing.sm) {
                switch selectedTab {
                case 0:
                    ForEach(region.investingDecisions, id: \.self) { decision in
                        BrainBulletRow(text: decision, icon: "arrow.right.circle.fill", color: region.color)
                    }
                case 1:
                    ForEach(region.hijackPatterns, id: \.self) { pattern in
                        BrainBulletRow(text: pattern, icon: "exclamationmark.triangle.fill", color: .warning)
                    }
                case 2:
                    ForEach(region.navigationStrategies, id: \.self) { strategy in
                        BrainBulletRow(text: strategy, icon: "checkmark.shield.fill", color: .success)
                    }
                default:
                    EmptyView()
                }
            }
            .padding(Spacing.md)
            .animation(.easeInOut(duration: 0.2), value: selectedTab)
        }
        .background(Color.surfaceSecondary)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
    }
}

// MARK: - Brain Detail Tab Button
struct BrainDetailTab: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(title)
                    .font(isSelected ? Typography.captionMedium : Typography.caption)
                    .foregroundColor(isSelected ? .textPrimary : .textTertiary)
                    .padding(.horizontal, Spacing.sm)
                    .padding(.top, Spacing.xs)

                Rectangle()
                    .fill(isSelected ? Color.textPrimary : Color.clear)
                    .frame(height: 2)
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Brain Bullet Row
struct BrainBulletRow: View {
    let text: String
    let icon: String
    let color: Color

    var body: some View {
        HStack(alignment: .top, spacing: Spacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundColor(color)
                .frame(width: 16, height: 16)
                .padding(.top, 2)

            Text(text)
                .font(Typography.body)
                .foregroundColor(.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

// MARK: - Preview
#Preview("Interactive Scenarios") {
    NavigationStack {
        InteractiveScenariosListView()
    }
}

#Preview("Scenario Detail") {
    NavigationStack {
        ScenarioDetailView(scenario: InteractiveBEManager.shared.scenarios[0])
    }
}

#Preview("Brain Map") {
    NavigationStack {
        BrainMapView()
    }
}
