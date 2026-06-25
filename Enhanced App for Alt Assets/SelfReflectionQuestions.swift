//
//  SelfReflectionQuestions.swift
//  Enhanced App for Alt Assets
//
//  Created by Victoria Case on 2/5/26.
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//
//  Description: Self-reflection questions from module content designed to help
//  users understand their thinking within the lens of behavioral economics
//  and gender-aware investing. These are not graded - they're for personal insight.
//

import SwiftUI
import Combine

// MARK: - Reflection Question Model
struct ReflectionQuestion: Identifiable, Codable, Hashable {
    let id: String
    let question: String
    let category: ReflectionCategory
    let subcategory: String
    let moduleId: String

    enum ReflectionCategory: String, Codable, CaseIterable {
        case motivationIdentity = "Motivation & Identity"
        case genderLens = "The Gender Lens"
        case choiceArchitecture = "Choice Architecture & Biases"
        case timePatience = "Time, Patience & Long-Term Thinking"
        case socialInfluence = "Social Influence & Collective Behavior"
        case emotionalPatterns = "Emotional Patterns & Reactions"
        case investingPriorities = "Investing Priorities & Options"
        case generationalGains = "Generational Gains"
        case riskPerception = "Risk Perception"
        case socialScience = "Social Science Research"

        var emoji: String {
            switch self {
            case .motivationIdentity: return "🎯"
            case .genderLens: return "👁️"
            case .choiceArchitecture: return "🧩"
            case .timePatience: return "⏳"
            case .socialInfluence: return "👥"
            case .emotionalPatterns: return "💭"
            case .investingPriorities: return "📊"
            case .generationalGains: return "🌱"
            case .riskPerception: return "⚖️"
            case .socialScience: return "🔬"
            }
        }

        var color: Color {
            switch self {
            case .motivationIdentity: return .brandPrimary
            case .genderLens: return .brandHighlight
            case .choiceArchitecture: return .info
            case .timePatience: return .warning
            case .socialInfluence: return .success
            case .emotionalPatterns: return .error
            case .investingPriorities: return .brandAccent
            case .generationalGains: return .success
            case .riskPerception: return .warning
            case .socialScience: return .info
            }
        }
    }
}

// MARK: - User Self-Reflection Entry
struct SelfReflectionEntry: Identifiable, Codable {
    let id: String
    let questionId: String
    var response: String
    var createdAt: Date
    var updatedAt: Date

    init(questionId: String, response: String = "") {
        self.id = UUID().uuidString
        self.questionId = questionId
        self.response = response
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

// MARK: - Reflection Questions Manager
class ReflectionQuestionsManager: ObservableObject {
    @Published var questionsByModule: [String: [ReflectionQuestion]] = [:]
    @Published var userEntries: [String: SelfReflectionEntry] = [:] // questionId -> entry

    static let shared = ReflectionQuestionsManager()

    private let entriesKey = "userReflectionEntries"

    init() {
        loadQuestions()
        loadUserEntries()
    }

    func loadQuestions() {
        // MARK: - Gender & Behavioral Investing Self-Reflection Questions
        let genderBehavioralQuestions: [ReflectionQuestion] = [
            // 1. Align Your Investments with Your Purpose
            // 1.1 Motivation & Autonomy
            ReflectionQuestion(
                id: "gbi-1.1-1",
                question: "When choosing an investment, do you feel driven more by personal goals, external expectations, or societal trends?",
                category: .motivationIdentity,
                subcategory: "Motivation & Autonomy",
                moduleId: "women-collective-investing"
            ),
            ReflectionQuestion(
                id: "gbi-1.1-2",
                question: "How much control do you feel you have over your financial decisions?",
                category: .motivationIdentity,
                subcategory: "Motivation & Autonomy",
                moduleId: "women-collective-investing"
            ),
            ReflectionQuestion(
                id: "gbi-1.1-3",
                question: "Do you prioritize independence in investment choices, or collaboration and advice from others? Why?",
                category: .motivationIdentity,
                subcategory: "Motivation & Autonomy",
                moduleId: "women-collective-investing"
            ),

            // 1.2 The Gender Lens
            ReflectionQuestion(
                id: "gbi-1.2-1",
                question: "How has your gender influenced your confidence or approach in investing?",
                category: .genderLens,
                subcategory: "The Gender Lens",
                moduleId: "women-collective-investing"
            ),
            ReflectionQuestion(
                id: "gbi-1.2-2",
                question: "Can you recall a time when you felt your choices were shaped by gendered expectations? How did you respond?",
                category: .genderLens,
                subcategory: "The Gender Lens",
                moduleId: "women-collective-investing"
            ),
            ReflectionQuestion(
                id: "gbi-1.2-3",
                question: "Do you notice patterns in the types of investments women and men pursue differently? How does this resonate with your own preferences?",
                category: .genderLens,
                subcategory: "The Gender Lens",
                moduleId: "women-collective-investing"
            ),

            // 1.3 Understanding the Gender Gap in Investing
            ReflectionQuestion(
                id: "gbi-1.3-1",
                question: "Have you observed differences in risk tolerance between genders? How does this align with your own comfort level?",
                category: .genderLens,
                subcategory: "Understanding the Gender Gap",
                moduleId: "women-collective-investing"
            ),
            ReflectionQuestion(
                id: "gbi-1.3-2",
                question: "How do societal narratives about wealth, success, or security influence your investment decisions?",
                category: .genderLens,
                subcategory: "Understanding the Gender Gap",
                moduleId: "women-collective-investing"
            ),

            // 1.4 Diverse Investment Strategies
            ReflectionQuestion(
                id: "gbi-1.4-1",
                question: "Which investment strategies feel most natural to you: cautious, analytical, innovative, or socially-driven?",
                category: .investingPriorities,
                subcategory: "Diverse Investment Strategies",
                moduleId: "women-collective-investing"
            ),
            ReflectionQuestion(
                id: "gbi-1.4-2",
                question: "How willing are you to explore alternative investments or impact-oriented ventures? Why or why not?",
                category: .investingPriorities,
                subcategory: "Diverse Investment Strategies",
                moduleId: "women-collective-investing"
            ),

            // 2. The Social Science Research Lens
            // 2.1 Bend Toward the "Good"
            ReflectionQuestion(
                id: "gbi-2.1-1",
                question: "How important is it that your investments reflect your ethical or moral values?",
                category: .socialScience,
                subcategory: "Bend Toward the Good",
                moduleId: "women-collective-investing"
            ),
            ReflectionQuestion(
                id: "gbi-2.1-2",
                question: "Can you describe a time you invested with \"impact\" rather than purely financial return in mind?",
                category: .socialScience,
                subcategory: "Bend Toward the Good",
                moduleId: "women-collective-investing"
            ),

            // 2.2 Altruism and Values
            ReflectionQuestion(
                id: "gbi-2.2-1",
                question: "Are you motivated by helping others, community impact, or societal change in your financial choices?",
                category: .socialScience,
                subcategory: "Altruism and Values",
                moduleId: "women-collective-investing"
            ),
            ReflectionQuestion(
                id: "gbi-2.2-2",
                question: "How do you balance self-interest versus altruistic goals when investing?",
                category: .socialScience,
                subcategory: "Altruism and Values",
                moduleId: "women-collective-investing"
            ),

            // 2.3 The Long-Horizon Choice
            ReflectionQuestion(
                id: "gbi-2.3-1",
                question: "Do you naturally favor long-term, patient investments or short-term, high-return opportunities?",
                category: .timePatience,
                subcategory: "The Long-Horizon Choice",
                moduleId: "women-collective-investing"
            ),
            ReflectionQuestion(
                id: "gbi-2.3-2",
                question: "How does patience in investing feel emotionally for you?",
                category: .timePatience,
                subcategory: "The Long-Horizon Choice",
                moduleId: "women-collective-investing"
            ),

            // 2.4 Risk Perception and Aversion
            ReflectionQuestion(
                id: "gbi-2.4-1",
                question: "How do you perceive financial risk compared to peers of your gender or age?",
                category: .riskPerception,
                subcategory: "Risk Perception and Aversion",
                moduleId: "women-collective-investing"
            ),
            ReflectionQuestion(
                id: "gbi-2.4-2",
                question: "Do you avoid risk because of past experience, societal messaging, or instinctive preference?",
                category: .riskPerception,
                subcategory: "Risk Perception and Aversion",
                moduleId: "women-collective-investing"
            ),

            // 3. Investing Priorities and Options
            // 3.1 Understand Private Equity & Venture Capital
            ReflectionQuestion(
                id: "gbi-3.1-1",
                question: "How familiar do you feel with private equity or venture capital investing?",
                category: .investingPriorities,
                subcategory: "Private Equity & Venture Capital",
                moduleId: "women-collective-investing"
            ),
            ReflectionQuestion(
                id: "gbi-3.1-2",
                question: "What excites you most or least about these investment vehicles?",
                category: .investingPriorities,
                subcategory: "Private Equity & Venture Capital",
                moduleId: "women-collective-investing"
            ),

            // 3.2 Social Enterprises
            ReflectionQuestion(
                id: "gbi-3.2-1",
                question: "Would you invest in businesses explicitly designed for social impact? Why or why not?",
                category: .investingPriorities,
                subcategory: "Social Enterprises",
                moduleId: "women-collective-investing"
            ),
            ReflectionQuestion(
                id: "gbi-3.2-2",
                question: "How do you weigh financial return versus social benefit in these cases?",
                category: .investingPriorities,
                subcategory: "Social Enterprises",
                moduleId: "women-collective-investing"
            ),

            // 3.3 Innovative Startups
            ReflectionQuestion(
                id: "gbi-3.3-1",
                question: "Do you enjoy investing in disruptive or emerging companies? What draws or deters you?",
                category: .investingPriorities,
                subcategory: "Innovative Startups",
                moduleId: "women-collective-investing"
            ),

            // 3.4 Alternative Investing
            ReflectionQuestion(
                id: "gbi-3.4-1",
                question: "How comfortable are you exploring non-traditional investment types (art, collectibles, crypto, etc.)?",
                category: .investingPriorities,
                subcategory: "Alternative Investing",
                moduleId: "women-collective-investing"
            ),

            // 3.5 Renewable Energy Initiatives
            ReflectionQuestion(
                id: "gbi-3.5-1",
                question: "How important is sustainability or climate impact in guiding your financial decisions?",
                category: .investingPriorities,
                subcategory: "Renewable Energy Initiatives",
                moduleId: "women-collective-investing"
            ),

            // 3.6 Private Impact Investment Funds
            ReflectionQuestion(
                id: "gbi-3.6-1",
                question: "Would you prioritize funds explicitly focused on impact? Why or why not?",
                category: .investingPriorities,
                subcategory: "Private Impact Investment Funds",
                moduleId: "women-collective-investing"
            ),

            // 4. Generational Gains
            ReflectionQuestion(
                id: "gbi-4-1",
                question: "How does your perspective on wealth accumulation differ from your parents or peers?",
                category: .generationalGains,
                subcategory: "Generational Gains",
                moduleId: "women-collective-investing"
            ),
            ReflectionQuestion(
                id: "gbi-4-2",
                question: "How much do intergenerational considerations affect your investment choices?",
                category: .generationalGains,
                subcategory: "Generational Gains",
                moduleId: "women-collective-investing"
            ),
            ReflectionQuestion(
                id: "gbi-4-3",
                question: "Do you plan investments to create long-term generational benefits?",
                category: .generationalGains,
                subcategory: "Generational Gains",
                moduleId: "women-collective-investing"
            )
        ]

        // MARK: - Behavioral Economics Self-Reflection Questions
        let behavioralEconomicsQuestions: [ReflectionQuestion] = [
            // 1. Motivation & Identity in Decision-Making
            ReflectionQuestion(
                id: "be-1-1",
                question: "What motivates most of your financial decisions: fear, opportunity, habit, or something else?",
                category: .motivationIdentity,
                subcategory: "Motivation & Identity in Decision-Making",
                moduleId: "behavioral-economics"
            ),
            ReflectionQuestion(
                id: "be-1-2",
                question: "When you think about money, what emotion shows up first? Why?",
                category: .motivationIdentity,
                subcategory: "Motivation & Identity in Decision-Making",
                moduleId: "behavioral-economics"
            ),
            ReflectionQuestion(
                id: "be-1-3",
                question: "How would you describe your relationship with risk? What past experience shaped that?",
                category: .motivationIdentity,
                subcategory: "Motivation & Identity in Decision-Making",
                moduleId: "behavioral-economics"
            ),
            ReflectionQuestion(
                id: "be-1-4",
                question: "What personal story or identity narrative most influences your financial behavior?",
                category: .motivationIdentity,
                subcategory: "Motivation & Identity in Decision-Making",
                moduleId: "behavioral-economics"
            ),
            ReflectionQuestion(
                id: "be-1-5",
                question: "Do you tend to justify financial decisions logically after making them emotionally? Provide an example.",
                category: .motivationIdentity,
                subcategory: "Motivation & Identity in Decision-Making",
                moduleId: "behavioral-economics"
            ),

            // 2. Choice Architecture & Biases
            ReflectionQuestion(
                id: "be-2-1",
                question: "When faced with multiple options, what makes a choice feel \"safe\" to you?",
                category: .choiceArchitecture,
                subcategory: "Choice Architecture & Biases",
                moduleId: "behavioral-economics"
            ),
            ReflectionQuestion(
                id: "be-2-2",
                question: "What kinds of decisions cause you to freeze, delay, or avoid choosing at all?",
                category: .choiceArchitecture,
                subcategory: "Choice Architecture & Biases",
                moduleId: "behavioral-economics"
            ),
            ReflectionQuestion(
                id: "be-2-3",
                question: "Do defaults and recommendations influence you more than you realize? How?",
                category: .choiceArchitecture,
                subcategory: "Choice Architecture & Biases",
                moduleId: "behavioral-economics"
            ),
            ReflectionQuestion(
                id: "be-2-4",
                question: "How do you typically narrow down options when overwhelmed?",
                category: .choiceArchitecture,
                subcategory: "Choice Architecture & Biases",
                moduleId: "behavioral-economics"
            ),
            ReflectionQuestion(
                id: "be-2-5",
                question: "Which common cognitive bias do you relate to most, and where does it show up in your financial life?",
                category: .choiceArchitecture,
                subcategory: "Choice Architecture & Biases",
                moduleId: "behavioral-economics"
            ),

            // 3. Time, Patience & Long-Term Thinking
            ReflectionQuestion(
                id: "be-3-1",
                question: "Are you naturally more present-focused or future-oriented?",
                category: .timePatience,
                subcategory: "Time, Patience & Long-Term Thinking",
                moduleId: "behavioral-economics"
            ),
            ReflectionQuestion(
                id: "be-3-2",
                question: "What makes it difficult for you to delay gratification?",
                category: .timePatience,
                subcategory: "Time, Patience & Long-Term Thinking",
                moduleId: "behavioral-economics"
            ),
            ReflectionQuestion(
                id: "be-3-3",
                question: "How do you decide between short-term satisfaction and long-term benefit?",
                category: .timePatience,
                subcategory: "Time, Patience & Long-Term Thinking",
                moduleId: "behavioral-economics"
            ),
            ReflectionQuestion(
                id: "be-3-4",
                question: "What long-term goal do you struggle to stay committed to? Why?",
                category: .timePatience,
                subcategory: "Time, Patience & Long-Term Thinking",
                moduleId: "behavioral-economics"
            ),
            ReflectionQuestion(
                id: "be-3-5",
                question: "Do you feel more confident or anxious when planning years ahead?",
                category: .timePatience,
                subcategory: "Time, Patience & Long-Term Thinking",
                moduleId: "behavioral-economics"
            ),

            // 4. Social Influence & Collective Behavior
            ReflectionQuestion(
                id: "be-4-1",
                question: "Whose financial opinions influence you — peers, experts, family? Why them?",
                category: .socialInfluence,
                subcategory: "Social Influence & Collective Behavior",
                moduleId: "behavioral-economics"
            ),
            ReflectionQuestion(
                id: "be-4-2",
                question: "How often do you make decisions to \"not fall behind\"?",
                category: .socialInfluence,
                subcategory: "Social Influence & Collective Behavior",
                moduleId: "behavioral-economics"
            ),
            ReflectionQuestion(
                id: "be-4-3",
                question: "When have you followed the crowd financially, and how did it turn out?",
                category: .socialInfluence,
                subcategory: "Social Influence & Collective Behavior",
                moduleId: "behavioral-economics"
            ),
            ReflectionQuestion(
                id: "be-4-4",
                question: "Do social comparisons motivate or discourage you?",
                category: .socialInfluence,
                subcategory: "Social Influence & Collective Behavior",
                moduleId: "behavioral-economics"
            ),
            ReflectionQuestion(
                id: "be-4-5",
                question: "Where does your confidence increase in group settings? Where does it decrease?",
                category: .socialInfluence,
                subcategory: "Social Influence & Collective Behavior",
                moduleId: "behavioral-economics"
            ),

            // 5. Emotional Patterns & Reactions
            ReflectionQuestion(
                id: "be-5-1",
                question: "Which emotions most often shape your financial behavior: anxiety, excitement, guilt, confidence, avoidance?",
                category: .emotionalPatterns,
                subcategory: "Emotional Patterns & Reactions",
                moduleId: "behavioral-economics"
            ),
            ReflectionQuestion(
                id: "be-5-2",
                question: "What was your most emotionally driven financial decision?",
                category: .emotionalPatterns,
                subcategory: "Emotional Patterns & Reactions",
                moduleId: "behavioral-economics"
            ),
            ReflectionQuestion(
                id: "be-5-3",
                question: "How do you react when faced with financial uncertainty?",
                category: .emotionalPatterns,
                subcategory: "Emotional Patterns & Reactions",
                moduleId: "behavioral-economics"
            ),
            ReflectionQuestion(
                id: "be-5-4",
                question: "What beliefs about money did you inherit, and which have you intentionally unlearned?",
                category: .emotionalPatterns,
                subcategory: "Emotional Patterns & Reactions",
                moduleId: "behavioral-economics"
            ),
            ReflectionQuestion(
                id: "be-5-5",
                question: "When do you feel fully in control of your financial decisions?",
                category: .emotionalPatterns,
                subcategory: "Emotional Patterns & Reactions",
                moduleId: "behavioral-economics"
            )
        ]

        // MARK: - Alternative Investing Self-Reflection Questions
        let altInvestingQuestions: [ReflectionQuestion] = [
            ReflectionQuestion(
                id: "alt-1-1",
                question: "What first drew you to the idea of alternatives — was it a desire for diversification, a specific asset type, or something else entirely?",
                category: .motivationIdentity,
                subcategory: "Asset Attraction & Fit",
                moduleId: "mod_alt"
            ),
            ReflectionQuestion(
                id: "alt-1-2",
                question: "Which alternative asset class feels most personally meaningful to you — and which feels most alien?",
                category: .motivationIdentity,
                subcategory: "Asset Attraction & Fit",
                moduleId: "mod_alt"
            ),
            ReflectionQuestion(
                id: "alt-2-1",
                question: "How do you feel about locking up capital for five to ten years with no liquidity? Does that constraint create discomfort or discipline?",
                category: .timePatience,
                subcategory: "Illiquidity & Patience",
                moduleId: "mod_alt"
            ),
            ReflectionQuestion(
                id: "alt-2-2",
                question: "Have you experienced a moment when you needed access to money that was tied up? How did that shape your thinking about liquidity?",
                category: .timePatience,
                subcategory: "Illiquidity & Patience",
                moduleId: "mod_alt"
            ),
            ReflectionQuestion(
                id: "alt-3-1",
                question: "How do you evaluate an investment whose value cannot be priced daily? What metrics or instincts do you rely on instead?",
                category: .riskPerception,
                subcategory: "Complexity & Valuation",
                moduleId: "mod_alt"
            ),
            ReflectionQuestion(
                id: "alt-3-2",
                question: "What does your current portfolio say about who you are as an investor? What would you want it to say?",
                category: .investingPriorities,
                subcategory: "Portfolio Identity",
                moduleId: "mod_alt"
            ),
            ReflectionQuestion(
                id: "alt-4-1",
                question: "What would need to be true for you to make your first alternative investment — or a larger one than you currently hold?",
                category: .investingPriorities,
                subcategory: "Portfolio Identity",
                moduleId: "mod_alt"
            ),
            ReflectionQuestion(
                id: "alt-4-2",
                question: "How do you think about the relationship between your investable capital and your time horizon? Are those two things currently aligned?",
                category: .timePatience,
                subcategory: "Illiquidity & Patience",
                moduleId: "mod_alt"
            )
        ]

        // MARK: - Art as Investment Self-Reflection Questions
        let artInvestingQuestions: [ReflectionQuestion] = [
            ReflectionQuestion(
                id: "art-1-1",
                question: "When you look at a piece of art, do you find yourself thinking about its monetary value? Does that change your experience of it?",
                category: .motivationIdentity,
                subcategory: "Aesthetic vs. Financial",
                moduleId: "mod_art"
            ),
            ReflectionQuestion(
                id: "art-1-2",
                question: "Is there a work of art you love that you suspect has little investment value? What does that tell you about how you actually relate to art?",
                category: .motivationIdentity,
                subcategory: "Aesthetic vs. Financial",
                moduleId: "mod_art"
            ),
            ReflectionQuestion(
                id: "art-2-1",
                question: "How much of art's value do you believe is intrinsic versus constructed through narrative, provenance, and cultural context?",
                category: .socialScience,
                subcategory: "Cultural Value & Narrative",
                moduleId: "mod_art"
            ),
            ReflectionQuestion(
                id: "art-2-2",
                question: "When you think of Kahlo and Basquiat, what story comes to mind first — the art or the artist? How might that affect your valuation of their work?",
                category: .socialScience,
                subcategory: "Cultural Value & Narrative",
                moduleId: "mod_art"
            ),
            ReflectionQuestion(
                id: "art-3-1",
                question: "Would you buy an artwork you dislike aesthetically if you believed it would appreciate significantly? What does your answer reveal about your motivations?",
                category: .investingPriorities,
                subcategory: "Collector Identity",
                moduleId: "mod_art"
            ),
            ReflectionQuestion(
                id: "art-3-2",
                question: "How do you feel about the opacity of the art market — private sales, undisclosed estimates, and dealer relationships? Does it intrigue or concern you?",
                category: .riskPerception,
                subcategory: "Market Psychology",
                moduleId: "mod_art"
            ),
            ReflectionQuestion(
                id: "art-4-1",
                question: "What would owning a work by a significant artist mean to you beyond the financial return?",
                category: .motivationIdentity,
                subcategory: "Aesthetic vs. Financial",
                moduleId: "mod_art"
            ),
            ReflectionQuestion(
                id: "art-4-2",
                question: "Authentication and provenance are foundational to art's value. How do you think about trust and verification in other parts of your investment life?",
                category: .riskPerception,
                subcategory: "Market Psychology",
                moduleId: "mod_art"
            )
        ]

        // MARK: - DeFi & Digital Assets Self-Reflection Questions
        let defiQuestions: [ReflectionQuestion] = [
            ReflectionQuestion(
                id: "defi-1-1",
                question: "What aspects of traditional finance — banks, intermediaries, fees, access barriers — do you most want to move away from? Does DeFi address those specifically?",
                category: .motivationIdentity,
                subcategory: "Financial System Beliefs",
                moduleId: "mod_defi"
            ),
            ReflectionQuestion(
                id: "defi-1-2",
                question: "How much do you trust code over institutions? Where does that trust come from, and where does it have limits?",
                category: .motivationIdentity,
                subcategory: "Trust & Sovereignty",
                moduleId: "mod_defi"
            ),
            ReflectionQuestion(
                id: "defi-2-1",
                question: "Self-custody means you are the only one responsible for your assets. How comfortable are you with that level of personal accountability?",
                category: .riskPerception,
                subcategory: "Trust & Sovereignty",
                moduleId: "mod_defi"
            ),
            ReflectionQuestion(
                id: "defi-2-2",
                question: "Have you ever lost access to something important because of a forgotten password or failed backup? How did that affect your feelings about self-custody?",
                category: .emotionalPatterns,
                subcategory: "Trust & Sovereignty",
                moduleId: "mod_defi"
            ),
            ReflectionQuestion(
                id: "defi-3-1",
                question: "When you read about a smart contract exploit or a protocol collapse, what is your first reaction — caution, opportunity, or something else?",
                category: .emotionalPatterns,
                subcategory: "Risk Tolerance & Reaction",
                moduleId: "mod_defi"
            ),
            ReflectionQuestion(
                id: "defi-3-2",
                question: "How do you distinguish between early adoption and speculation? Where does DeFi currently sit for you on that spectrum?",
                category: .riskPerception,
                subcategory: "Risk Tolerance & Reaction",
                moduleId: "mod_defi"
            ),
            ReflectionQuestion(
                id: "defi-4-1",
                question: "If you had to explain your DeFi allocation to someone skeptical — a parent, a financial advisor — how would you justify it?",
                category: .socialInfluence,
                subcategory: "Portfolio Fit",
                moduleId: "mod_defi"
            ),
            ReflectionQuestion(
                id: "defi-4-2",
                question: "What would make you reduce or exit your crypto/DeFi exposure? Is that threshold defined, or do you decide in the moment?",
                category: .investingPriorities,
                subcategory: "Portfolio Fit",
                moduleId: "mod_defi"
            )
        ]

        // MARK: - DeFi Investing (Advanced) Self-Reflection Questions
        let defiInvestingQuestions: [ReflectionQuestion] = [
            ReflectionQuestion(
                id: "defi-inv-1-1",
                question: "Now that you understand how DeFi protocols generate revenue, does that change how you evaluate a token's investment case? What do you look for now that you didn't before?",
                category: .investingPriorities,
                subcategory: "Protocol Evaluation",
                moduleId: "mod_defi_investing"
            ),
            ReflectionQuestion(
                id: "defi-inv-1-2",
                question: "How do you think about the difference between owning a DeFi protocol token and owning equity in a traditional company? Are the risks the same, different, or simply re-named?",
                category: .riskPerception,
                subcategory: "Protocol Evaluation",
                moduleId: "mod_defi_investing"
            ),
            ReflectionQuestion(
                id: "defi-inv-2-1",
                question: "TVL, protocol revenue, token burns — these are the metrics DeFi investors rely on. How confident are you in reading these, and where do you still feel uncertain?",
                category: .choiceArchitecture,
                subcategory: "Research & Due Diligence",
                moduleId: "mod_defi_investing"
            ),
            ReflectionQuestion(
                id: "defi-inv-2-2",
                question: "When you look at a DeFi investment thesis, what is your first instinct — to find reasons it could work, or reasons it could fail? What does that pattern tell you?",
                category: .choiceArchitecture,
                subcategory: "Research & Due Diligence",
                moduleId: "mod_defi_investing"
            ),
            ReflectionQuestion(
                id: "defi-inv-3-1",
                question: "DeFi tax treatment can turn nominal gains into real losses. Have you fully accounted for that in how you think about your returns?",
                category: .investingPriorities,
                subcategory: "Portfolio Fit",
                moduleId: "mod_defi_investing"
            ),
            ReflectionQuestion(
                id: "defi-inv-3-2",
                question: "If an advisor you were evaluating couldn't explain the difference between Bitcoin and Ethereum, would you still work with them? Where is your knowledge threshold for the professionals you trust?",
                category: .socialInfluence,
                subcategory: "Advisor & Professional Trust",
                moduleId: "mod_defi_investing"
            )
        ]

        // MARK: - ESG & Climate Self-Reflection Questions
        let esgQuestions: [ReflectionQuestion] = [
            ReflectionQuestion(
                id: "esg-1-1",
                question: "When you say your investments should reflect your values, what does that actually mean for you in concrete terms? Which values take priority when they conflict?",
                category: .motivationIdentity,
                subcategory: "Values Alignment",
                moduleId: "mod_esg_climate"
            ),
            ReflectionQuestion(
                id: "esg-1-2",
                question: "Have you ever made a financial choice that you knew was less profitable but felt more right? What drove that decision?",
                category: .motivationIdentity,
                subcategory: "Values Alignment",
                moduleId: "mod_esg_climate"
            ),
            ReflectionQuestion(
                id: "esg-2-1",
                question: "The data suggests ESG doesn't require sacrificing returns — yet skepticism persists. Do you believe this? What would it take to convince you fully?",
                category: .socialScience,
                subcategory: "Impact vs. Returns",
                moduleId: "mod_esg_climate"
            ),
            ReflectionQuestion(
                id: "esg-2-2",
                question: "How much return would you be willing to sacrifice for measurable environmental or social impact? Is there a number in your head, or does the question feel uncomfortable to quantify?",
                category: .investingPriorities,
                subcategory: "Impact vs. Returns",
                moduleId: "mod_esg_climate"
            ),
            ReflectionQuestion(
                id: "esg-3-1",
                question: "Greenwashing is widespread. When you encounter an ESG claim from a fund or company, what is your default posture — trust, skepticism, or something in between?",
                category: .riskPerception,
                subcategory: "Greenwashing & Skepticism",
                moduleId: "mod_esg_climate"
            ),
            ReflectionQuestion(
                id: "esg-3-2",
                question: "Do you feel you have the tools to verify ESG claims independently? What would you need to feel confident in that evaluation?",
                category: .riskPerception,
                subcategory: "Greenwashing & Skepticism",
                moduleId: "mod_esg_climate"
            ),
            ReflectionQuestion(
                id: "esg-4-1",
                question: "What is your emotional relationship with the scale of climate risk — energized, overwhelmed, resigned, or something else? How does that affect your investment behavior?",
                category: .emotionalPatterns,
                subcategory: "Climate Conviction",
                moduleId: "mod_esg_climate"
            ),
            ReflectionQuestion(
                id: "esg-4-2",
                question: "If your children or grandchildren looked at your investment record, what would you want it to say about what you prioritized?",
                category: .generationalGains,
                subcategory: "Generational Responsibility",
                moduleId: "mod_esg_climate"
            )
        ]

        // MARK: - Kahlo × Basquiat Self-Reflection Questions
        let kahloBasquiatQuestions: [ReflectionQuestion] = [
            ReflectionQuestion(
                id: "kb-1-1",
                question: "Both Kahlo and Basquiat made their inner lives the subject of their work. Does knowing an artist's biography change how you experience — or value — their art?",
                category: .motivationIdentity,
                subcategory: "Biographical Value",
                moduleId: "mod_kahlo_basquiat"
            ),
            ReflectionQuestion(
                id: "kb-1-2",
                question: "Basquiat emerged from street art into institutional recognition. What does that trajectory suggest about how value is conferred in art — and in other fields you know?",
                category: .socialScience,
                subcategory: "Institutional Recognition",
                moduleId: "mod_kahlo_basquiat"
            ),
            ReflectionQuestion(
                id: "kb-2-1",
                question: "Kahlo's work appreciated dramatically after her death. How do you think about the relationship between an artist's market value and their mortality?",
                category: .riskPerception,
                subcategory: "Market & Time",
                moduleId: "mod_kahlo_basquiat"
            ),
            ReflectionQuestion(
                id: "kb-2-2",
                question: "Both artists addressed race, colonialism, identity, and power. How does the social commentary embedded in a work affect your sense of its long-term cultural — and financial — staying power?",
                category: .socialScience,
                subcategory: "Cultural Longevity",
                moduleId: "mod_kahlo_basquiat"
            ),
            ReflectionQuestion(
                id: "kb-3-1",
                question: "If you had purchased a Basquiat in 1983 for $5,000, what do you think your decision process would have looked like? What would you have seen that others didn't — or missed?",
                category: .choiceArchitecture,
                subcategory: "Contrarian Conviction",
                moduleId: "mod_kahlo_basquiat"
            ),
            ReflectionQuestion(
                id: "kb-3-2",
                question: "Kahlo was undervalued during her lifetime. What does that pattern suggest about how markets assess work by women and artists of color — and what might it imply for your own collecting thesis?",
                category: .genderLens,
                subcategory: "Valuation & Representation",
                moduleId: "mod_kahlo_basquiat"
            )
        ]

        // MARK: - Gender & Investing Self-Reflection Questions
        let genderInvestingQuestions: [ReflectionQuestion] = [
            ReflectionQuestion(
                id: "gi-1-1",
                question: "Research consistently shows women trade less and outperform men long-term. How do you interpret this? Is it a behavioral advantage, a structural constraint, or something else?",
                category: .genderLens,
                subcategory: "Performance & Behavior",
                moduleId: "mod_gender"
            ),
            ReflectionQuestion(
                id: "gi-1-2",
                question: "Have you ever held back from an investment decision — or pushed forward — partly because of how it might look? What were the gender dynamics, if any, in that moment?",
                category: .socialInfluence,
                subcategory: "Social Pressure & Identity",
                moduleId: "mod_gender"
            ),
            ReflectionQuestion(
                id: "gi-2-1",
                question: "The confidence gap between men and women in investing is well-documented. Do you recognize it in yourself or in others around you? Where does it come from?",
                category: .emotionalPatterns,
                subcategory: "Confidence & Self-Perception",
                moduleId: "mod_gender"
            ),
            ReflectionQuestion(
                id: "gi-2-2",
                question: "How have financial role models shaped your relationship with investing? Were they the same gender as you? Does that matter?",
                category: .socialInfluence,
                subcategory: "Role Models & Representation",
                moduleId: "mod_gender"
            ),
            ReflectionQuestion(
                id: "gi-3-1",
                question: "When profession or industry prestige shifts as gender composition changes, earnings and investable capital can follow. Have you seen this in your own field?",
                category: .genderLens,
                subcategory: "Economic Structures",
                moduleId: "mod_gender"
            ),
            ReflectionQuestion(
                id: "gi-3-2",
                question: "Gender lens investing directs capital toward companies that advance gender equity. Is that a framework you find compelling, performative, or somewhere in between?",
                category: .investingPriorities,
                subcategory: "Gender Lens Investing",
                moduleId: "mod_gender"
            ),
            ReflectionQuestion(
                id: "gi-4-1",
                question: "If financial systems were redesigned with gender equity as a core principle, what would change first? What does your answer reveal about where you see the most acute gap?",
                category: .socialScience,
                subcategory: "Systemic Thinking",
                moduleId: "mod_gender"
            )
        ]

        // Store by module
        questionsByModule = [
            "women-collective-investing": genderBehavioralQuestions,
            "behavioral-economics": behavioralEconomicsQuestions,
            "mod_alt": altInvestingQuestions,
            "mod_art": artInvestingQuestions,
            "mod_defi": defiQuestions,
            "mod_defi_investing": defiInvestingQuestions,
            "mod_esg_climate": esgQuestions,
            "mod_kahlo_basquiat": kahloBasquiatQuestions,
            "mod_gender": genderInvestingQuestions
        ]
    }

    // MARK: - User Entries Management
    func loadUserEntries() {
        // Try Keychain first, fall back to UserDefaults for pre-migration data
        let data = KeychainHelper.readData(key: entriesKey)
                   ?? UserDefaults.standard.data(forKey: entriesKey)
        if let data = data,
           let entries = try? JSONDecoder().decode([String: SelfReflectionEntry].self, from: data) {
            userEntries = entries
        }
    }

    func saveUserEntries() {
        if let data = try? JSONEncoder().encode(userEntries) {
            KeychainHelper.save(key: entriesKey, data: data)
        }
    }

    func saveResponse(for questionId: String, response: String) {
        if var entry = userEntries[questionId] {
            entry.response = response
            entry.updatedAt = Date()
            userEntries[questionId] = entry
        } else {
            let entry = SelfReflectionEntry(questionId: questionId, response: response)
            userEntries[questionId] = entry
        }
        saveUserEntries()
    }

    func getResponse(for questionId: String) -> String {
        userEntries[questionId]?.response ?? ""
    }

    func hasResponse(for questionId: String) -> Bool {
        guard let entry = userEntries[questionId] else { return false }
        return !entry.response.isEmpty
    }

    // MARK: - Query Methods
    func questions(for moduleId: String) -> [ReflectionQuestion] {
        // Try exact match first
        if let questions = questionsByModule[moduleId] {
            return questions
        }

        // Try partial match
        let lowercased = moduleId.lowercased()
        for (key, questions) in questionsByModule {
            if lowercased.contains(key) || key.contains(lowercased) {
                return questions
            }
        }

        return []
    }

    func questionsByCategory(for moduleId: String) -> [ReflectionQuestion.ReflectionCategory: [ReflectionQuestion]] {
        let moduleQuestions = questions(for: moduleId)
        return Dictionary(grouping: moduleQuestions, by: { $0.category })
    }

    func completionProgress(for moduleId: String) -> Double {
        let moduleQuestions = questions(for: moduleId)
        guard !moduleQuestions.isEmpty else { return 0 }

        let answeredCount = moduleQuestions.filter { hasResponse(for: $0.id) }.count
        return Double(answeredCount) / Double(moduleQuestions.count)
    }

    var allQuestions: [ReflectionQuestion] {
        questionsByModule.values.flatMap { $0 }
    }
}

// MARK: - Self-Reflection Section View (for Module Detail)
struct SelfReflectionSectionView: View {
    let moduleId: String
    @ObservedObject var manager = ReflectionQuestionsManager.shared
    @State private var expandedCategory: ReflectionQuestion.ReflectionCategory?

    var body: some View {
        let questionsByCategory = manager.questionsByCategory(for: moduleId)

        if !questionsByCategory.isEmpty {
            VStack(alignment: .leading, spacing: Spacing.md) {
                // Header
                HStack(spacing: Spacing.sm) {
                    Text("🪞")
                        .font(.system(size: 20))
                    Text("Questions for Self-Reflection")
                        .font(Typography.title3)
                        .foregroundColor(.textPrimary)
                }

                Text("These questions are designed for self-reflection only, to help you better understand how you think within the lens of behavioral economics.")
                    .font(Typography.caption)
                    .foregroundColor(.textTertiary)
                    .italic()

                // Progress indicator
                let progress = manager.completionProgress(for: moduleId)
                if progress > 0 {
                    HStack(spacing: Spacing.sm) {
                        ProgressView(value: progress)
                            .tint(.brandPrimary)
                        Text("\(Int(progress * 100))% reflected")
                            .font(Typography.caption2)
                            .foregroundColor(.textTertiary)
                    }
                }

                // Categories
                ForEach(Array(questionsByCategory.keys.sorted(by: { $0.rawValue < $1.rawValue })), id: \.self) { category in
                    if let questions = questionsByCategory[category] {
                        ReflectionCategoryCard(
                            category: category,
                            questions: questions,
                            isExpanded: expandedCategory == category,
                            onTap: {
                                withAnimation(.spring(response: 0.3)) {
                                    expandedCategory = expandedCategory == category ? nil : category
                                }
                            }
                        )
                    }
                }
            }
            .padding(Spacing.md)
            .background(Color.surfaceSecondary)
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
        }
    }
}

// MARK: - Reflection Category Card
struct ReflectionCategoryCard: View {
    let category: ReflectionQuestion.ReflectionCategory
    let questions: [ReflectionQuestion]
    let isExpanded: Bool
    let onTap: () -> Void

    @ObservedObject var manager = ReflectionQuestionsManager.shared

    var answeredCount: Int {
        questions.filter { manager.hasResponse(for: $0.id) }.count
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header button
            Button(action: onTap) {
                HStack(spacing: Spacing.sm) {
                    Text(category.emoji)
                        .font(.system(size: 18))

                    Text(category.rawValue)
                        .font(Typography.bodyMedium)
                        .foregroundColor(.textPrimary)

                    Spacer()

                    // Progress badge
                    Text("\(answeredCount)/\(questions.count)")
                        .font(Typography.caption2)
                        .foregroundColor(answeredCount == questions.count ? .success : .textTertiary)
                        .padding(.horizontal, Spacing.xs)
                        .padding(.vertical, 2)
                        .background(
                            (answeredCount == questions.count ? Color.success : Color.surfaceTertiary)
                                .opacity(0.2)
                        )
                        .clipShape(Capsule())

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundColor(.textTertiary)
                }
                .padding(Spacing.sm)
            }
            .buttonStyle(.plain)

            // Expanded questions
            if isExpanded {
                Divider()
                    .padding(.horizontal, Spacing.sm)

                VStack(alignment: .leading, spacing: Spacing.sm) {
                    ForEach(questions) { question in
                        ReflectionQuestionRow(question: question)
                    }
                }
                .padding(Spacing.sm)
            }
        }
        .background(Color.surfacePrimary)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.sm))
    }
}

// MARK: - Reflection Question Row
struct ReflectionQuestionRow: View {
    let question: ReflectionQuestion
    @State private var showingJournal = false
    @ObservedObject var manager = ReflectionQuestionsManager.shared

    var hasAnswer: Bool {
        manager.hasResponse(for: question.id)
    }

    var body: some View {
        Button {
            showingJournal = true
        } label: {
            HStack(alignment: .top, spacing: Spacing.sm) {
                // Status indicator
                Image(systemName: hasAnswer ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(hasAnswer ? .success : .textTertiary)
                    .font(.system(size: 14))

                Text(question.question)
                    .font(Typography.body)
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)

                Spacer()

                Image(systemName: "pencil")
                    .font(.caption)
                    .foregroundColor(.brandPrimary)
            }
            .padding(.vertical, Spacing.xs)
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showingJournal) {
            ReflectionJournalEntryView(question: question)
        }
    }
}

// MARK: - Reflection Journal Entry View
struct ReflectionJournalEntryView: View {
    let question: ReflectionQuestion
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var manager = ReflectionQuestionsManager.shared
    @State private var response: String = ""
    @FocusState private var isFocused: Bool

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.lg) {
                    // Category badge
                    HStack(spacing: Spacing.xs) {
                        Text(question.category.emoji)
                            .font(.system(size: 14))
                        Text(question.category.rawValue)
                            .font(Typography.caption)
                    }
                    .foregroundColor(question.category.color)
                    .padding(.horizontal, Spacing.sm)
                    .padding(.vertical, Spacing.xs)
                    .background(question.category.color.opacity(0.1))
                    .clipShape(Capsule())

                    // Question
                    Text(question.question)
                        .font(Typography.title3)
                        .foregroundColor(.textPrimary)

                    // Subcategory
                    Text(question.subcategory)
                        .font(Typography.caption)
                        .foregroundColor(.textTertiary)

                    Divider()

                    // Response area
                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        Text("Your Reflection")
                            .font(Typography.captionMedium)
                            .foregroundColor(.textSecondary)

                        TextEditor(text: $response)
                            .font(Typography.body)
                            .frame(minHeight: 200)
                            .padding(Spacing.sm)
                            .background(Color.surfaceSecondary)
                            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.sm))
                            .focused($isFocused)
                    }

                    // Hint
                    Text("💡 Take your time. There are no right or wrong answers — this is for your personal insight.")
                        .font(Typography.caption)
                        .foregroundColor(.textTertiary)
                        .padding(Spacing.sm)
                        .background(Color.info.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.sm))
                }
                .padding(Spacing.lg)
            }
            .background(Color.surfacePrimary)
            .navigationTitle("Self-Reflection")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        manager.saveResponse(for: question.id, response: response)
                        dismiss()
                    }
                    .disabled(response.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .onAppear {
                response = manager.getResponse(for: question.id)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isFocused = true
                }
            }
        }
    }
}

// MARK: - Reflection Progress Card (for Dashboard)
struct ReflectionProgressCard: View {
    @ObservedObject var manager = ReflectionQuestionsManager.shared

    var totalQuestions: Int {
        manager.allQuestions.count
    }

    var answeredQuestions: Int {
        manager.allQuestions.filter { manager.hasResponse(for: $0.id) }.count
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack(spacing: Spacing.sm) {
                Text("🪞")
                    .font(.system(size: 18))
                Text("Self-Reflection Journal")
                    .font(Typography.bodyMedium)
                    .foregroundColor(.textPrimary)
                Spacer()
            }

            HStack(spacing: Spacing.md) {
                // Progress ring
                ZStack {
                    Circle()
                        .stroke(Color.surfaceTertiary, lineWidth: 4)

                    Circle()
                        .trim(from: 0, to: totalQuestions > 0 ? Double(answeredQuestions) / Double(totalQuestions) : 0)
                        .stroke(Color.brandPrimary, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                        .rotationEffect(.degrees(-90))

                    Text("\(answeredQuestions)")
                        .font(Typography.bodyMedium)
                        .foregroundColor(.textPrimary)
                }
                .frame(width: 50, height: 50)

                VStack(alignment: .leading, spacing: 2) {
                    Text("\(answeredQuestions) of \(totalQuestions) reflections")
                        .font(Typography.body)
                        .foregroundColor(.textPrimary)

                    Text("Understanding your financial mindset")
                        .font(Typography.caption)
                        .foregroundColor(.textTertiary)
                }
            }
        }
        .padding(Spacing.md)
        .background(Color.surfaceSecondary)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
    }
}

// MARK: - Preview
#Preview("Self-Reflection Section") {
    ScrollView {
        VStack(spacing: 20) {
            SelfReflectionSectionView(moduleId: "behavioral-economics")
            SelfReflectionSectionView(moduleId: "women-collective-investing")
        }
        .padding()
    }
    .background(Color.surfacePrimary)
}

#Preview("Reflection Progress") {
    ReflectionProgressCard()
        .padding()
        .background(Color.surfacePrimary)
}
