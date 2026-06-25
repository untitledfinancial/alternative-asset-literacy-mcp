//
//  ModuleQuizzes.swift
//  Enhanced App for Alt Assets
//
//  Created by Victoria Case on 2/5/26.
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//
//  Description: Quizzes generated directly from Notion module content.
//  Each quiz corresponds to a specific module with questions drawn from
//  the actual educational material and footnoted sources.
//

import Foundation

// MARK: - Module Quizzes
struct ModuleQuizzes {

    // MARK: - Alternative Investing Module Quiz
    /// Quiz based on the Alternative Investing module content
    /// Footnotes reference: WEF Report (1), ERISA history, etc.
    static let alternativeInvestingQuiz = Quiz(
        id: "quiz-alternative-investing",
        title: "⛲ Alternative Assets Fundamentals",
        description: "Test your understanding of alternative investments, their features, and diverse strategies",
        questions: [
            // Question from Section 1.1 Features
            QuizQuestion(
                id: "alt-q1",
                question: "According to the module, what are the three basic features that alternative investments typically exhibit?",
                options: [
                    "High returns, low risk, easy access",
                    "Less regulatory oversight, illiquidity, and low correlation with traditional assets",
                    "Government backing, guaranteed returns, daily liquidity",
                    "Stock-like trading, bond-like income, cash-like stability"
                ],
                correctAnswerIndex: 1,
                explanation: "The module states: 'While these features offer opportunities for diversification and potentially higher returns, alternatives are characterized by less regulatory oversight, illiquidity, and low correlation with traditional assets.'",
                difficulty: .beginner,
                relatedConcepts: ["alternative-assets", "correlation", "liquidity"]
            ),
            // Question from Section 1.2 The Industry Itself
            QuizQuestion(
                id: "alt-q2",
                question: "How do alternative investments capture opportunities in rising interest rate environments?",
                options: [
                    "By avoiding the market entirely",
                    "Through long/short frameworks that invest in winners and short losers",
                    "By converting to traditional stocks",
                    "By holding only cash"
                ],
                correctAnswerIndex: 1,
                explanation: "The module explains: 'Alternative investment strategies are well-suited to capitalize on these cross-sectional opportunities through the implementation of a long/short framework. In this strategy, investments are made in companies expected to outperform while shorting those expected to underperform.'",
                difficulty: .intermediate,
                relatedConcepts: ["long-short-strategy", "interest-rates"]
            ),
            // Question from History section
            QuizQuestion(
                id: "alt-q3",
                question: "What regulatory change in 1974 significantly propelled the alternative investments industry?",
                options: [
                    "The Securities Act",
                    "The Dodd-Frank Act",
                    "ERISA (Employee Retirement Income Security Act)",
                    "The Glass-Steagall Act"
                ],
                correctAnswerIndex: 2,
                explanation: "The module states: 'The stock market crash of 1974 brought regulatory changes that further propelled the industry. The U.S. Government introduced the Employee Retirement Income Security Act (ERISA), permitting pension funds to invest in alternatives.'",
                difficulty: .intermediate,
                relatedConcepts: ["erisa", "pension-funds", "regulation"]
            ),
            // Question from Section 1.2 Facts and Figures
            QuizQuestion(
                id: "alt-q4",
                question: "According to the World Economic Forum report cited in the module, what percentage of buyouts have occurred since January 1, 2006?",
                options: [
                    "Over 20%",
                    "Over 30%",
                    "Over 40%",
                    "Over 50%"
                ],
                correctAnswerIndex: 2,
                explanation: "The module cites: 'Over 40% of buyouts occurring since January 1, 2006.' Source: World Economic Forum (1)",
                difficulty: .advanced,
                relatedConcepts: ["private-equity", "buyouts"]
            ),
            // Question from Diverse Strategies section
            QuizQuestion(
                id: "alt-q5",
                question: "What is the risk-return spectrum in alternative investments?",
                options: [
                    "A government rating system for investments",
                    "The connection between the level of return achieved and the degree of risk involved",
                    "A type of bond classification",
                    "A tax calculation method"
                ],
                correctAnswerIndex: 1,
                explanation: "As the module callout explains: 'The risk-return spectrum represents the connection between the level of return achieved in an investment and the degree of risk involved in that investment.'",
                difficulty: .beginner,
                relatedConcepts: ["risk-return", "portfolio-management"]
            )
        ],
        passingScore: 0.7
    )

    // MARK: - Women and Collective Investing Module Quiz
    /// Quiz based on the Women and Collective Investing module
    /// Footnotes: Merrill Lynch/Age Wave study (8), Behavioral Economics research
    static let womenCollectiveInvestingQuiz = Quiz(
        id: "quiz-women-collective-investing",
        title: "👑 Women and Collective Investing",
        description: "Explore the concepts of personal power, behavioral economics, and financial embodiment",
        questions: [
            // Question from Section 1.1 The Myth
            QuizQuestion(
                id: "wci-q1",
                question: "What does the module suggest we should move away from in our approach to financial thinking?",
                options: [
                    "Long-term planning",
                    "Binary thought processes (+/-) toward an intuitive ecosystem",
                    "Diversification strategies",
                    "Professional advice"
                ],
                correctAnswerIndex: 1,
                explanation: "The module states: 'It is better to move away from a binary thought process of (+-) to an intuitive ecosystem. By that statement I am suggesting we look at multiple factors in financial wellness, outside of just money in the bank.'",
                difficulty: .beginner,
                relatedConcepts: ["mindset", "intuitive-investing"]
            ),
            // Question from Section 1.2 The Brain and Money
            QuizQuestion(
                id: "wci-q2",
                question: "According to Dr. Jonathan Cohen at Princeton Neuroscience Institute, what are the two types of decision-making processes?",
                options: [
                    "Fast and slow",
                    "Logical and emotional",
                    "Deliberative and emotional",
                    "Conscious and unconscious"
                ],
                correctAnswerIndex: 2,
                explanation: "The module explains: 'Dr. Jonathan Cohen, the co-director at the Princeton Neuroscience Institute breaks down two terms in decision making: \"deliberative\" and \"emotional\".'",
                difficulty: .intermediate,
                relatedConcepts: ["neuroeconomics", "decision-making"]
            ),
            // Question from New Ways Forward section
            QuizQuestion(
                id: "wci-q3",
                question: "What does the module recommend using instead of 'gut' reaction?",
                options: [
                    "Pure data analysis only",
                    "Following market trends",
                    "Intuition",
                    "Random selection"
                ],
                correctAnswerIndex: 2,
                explanation: "The module's callout states: 'Moving forward, my theory is to utilize your intuition versus \"gut\" reaction.' This is because the terminology of 'gut reaction' has evolved in business to be dismissive rather than grounded in neuro-economic understanding.",
                difficulty: .beginner,
                relatedConcepts: ["intuition", "behavioral-finance"]
            ),
            // Question from Data Drivers section - Merrill Lynch study (8)
            QuizQuestion(
                id: "wci-q4",
                question: "According to the Merrill Lynch/Age Wave study cited in the module, what do women want their relationship with money to be linked to?",
                options: [
                    "Status and prestige",
                    "Their values, goals and priorities",
                    "Retirement only",
                    "Short-term gains"
                ],
                correctAnswerIndex: 1,
                explanation: "The module cites the Merrill Lynch/Age Wave study (8) with a key callout: 'Women want their relationship with money to be linked to their values, goals and priorities.'",
                difficulty: .beginner,
                relatedConcepts: ["values-based-investing", "financial-goals"]
            ),
            // Question from Financial Embodiment section
            QuizQuestion(
                id: "wci-q5",
                question: "What two baseline questions does the module suggest considering for financial embodiment?",
                options: [
                    "What is my income? What are my expenses?",
                    "What is my Baseline Readiness? What is my Baseline Resilience?",
                    "What stocks should I buy? What bonds should I sell?",
                    "What is my credit score? What is my debt ratio?"
                ],
                correctAnswerIndex: 1,
                explanation: "The module states: 'Question One: What is my Baseline Readiness? Question Two: What is my Baseline Resilience?' These terms from disaster preparedness help in considering and preparing for future outcomes.",
                difficulty: .intermediate,
                relatedConcepts: ["financial-embodiment", "preparedness"]
            )
        ],
        passingScore: 0.7
    )

    // MARK: - Art as Investment Module Quiz
    /// Quiz based on the Art as Investment module
    /// Footnotes: UBS Art Market Report, Art Basel Report, Christie's sales
    static let artInvestmentQuiz = Quiz(
        id: "quiz-art-investment",
        title: "🎨 Art as Investment",
        description: "Explore the art market, emotional premiums, and famous sales that shaped art investing",
        questions: [
            // Question from Section 1.1 Inside the Seemingly Opaque Industry
            QuizQuestion(
                id: "art-q1",
                question: "According to the module, what comprises the global art market?",
                options: [
                    "Only auction houses and galleries",
                    "A network of auction houses, dealers, galleries, advisors, agents, collectors, museums, and public institutions",
                    "Government-controlled institutions only",
                    "Online platforms exclusively"
                ],
                correctAnswerIndex: 1,
                explanation: "The module states: 'The global art market is comprised of a network of auction houses, dealers, galleries, advisors, agents, individual collectors, museums, public institutions and more.'",
                difficulty: .beginner,
                relatedConcepts: ["art-market", "market-participants"]
            ),
            // Question from Section 1.2 By the Numbers - UBS Report
            QuizQuestion(
                id: "art-q2",
                question: "According to the 2023 UBS Art Market Report cited in the module, how did the global art market perform post-pandemic?",
                options: [
                    "It collapsed completely",
                    "It maintained steady growth despite economic uncertainty",
                    "It returned to pre-2008 levels",
                    "It only served wealthy collectors"
                ],
                correctAnswerIndex: 1,
                explanation: "The module cites: 'According to the 2023 UBS Art Market Report, the global art market maintained steady growth in the face of profound unpredictability underscores the robustness of the post-pandemic art market.'",
                difficulty: .intermediate,
                relatedConcepts: ["art-market-reports", "market-resilience"]
            ),
            // Question from Section 2.2 Dr. Gachet
            QuizQuestion(
                id: "art-q3",
                question: "What was significant about van Gogh's 'Portrait of Dr. Gachet' sale at Christie's in 1990?",
                options: [
                    "It was the first art NFT",
                    "It broke all records at the time at $82.5 million with a substantial emotional premium",
                    "It was sold by a museum",
                    "It was purchased by a government"
                ],
                correctAnswerIndex: 1,
                explanation: "The module describes: 'The groundbreaking sale of van Gogh's Portrait of Dr. Gachet at Christie's New York in 1990 broke all records at the time. The work itself fetched $82.5 million... a substantial emotional component significantly influenced the final winning bid.'",
                difficulty: .intermediate,
                relatedConcepts: ["auction-records", "emotional-premium"]
            ),
            // Question from Section 2.3 NFT and Beeple
            QuizQuestion(
                id: "art-q4",
                question: "According to the module, what was unique about Beeple's 'Everydays — The First 5000 Days' NFT?",
                options: [
                    "It was painted on canvas",
                    "It was a collage of artworks created over 5000 days (14+ years)",
                    "It was created in one day",
                    "It was a sculpture"
                ],
                correctAnswerIndex: 1,
                explanation: "The module explains: 'The digital artwork is a culmination and collage of multiple artworks done over the course of 5000 days or a bit over fourteen years. This fact alone is what intrigued the collector the most.'",
                difficulty: .beginner,
                relatedConcepts: ["nft", "digital-art", "beeple"]
            ),
            // Question from Section 2.4 Salvator Mundi
            QuizQuestion(
                id: "art-q5",
                question: "What is unique about Leonardo da Vinci's 'Salvator Mundi' according to the module?",
                options: [
                    "It's displayed in the Louvre",
                    "It's the only da Vinci in private hands, sold for $450.3 million",
                    "It was authenticated in the 1800s",
                    "It's owned by a museum"
                ],
                correctAnswerIndex: 1,
                explanation: "The module states: 'To this day, the Salvator Mundi is the only da Vinci in private hands.' It sold at Christie's in 2017 for $450.3 million, making it the most expensive painting ever sold.",
                difficulty: .advanced,
                relatedConcepts: ["da-vinci", "auction-records", "private-collections"]
            ),
            // Question from Section 2.5 Banksy
            QuizQuestion(
                id: "art-q6",
                question: "What happened to Banksy's 'Girl With Balloon' during its 2018 auction at Sotheby's?",
                options: [
                    "It was stolen",
                    "It self-destructed through a shredder hidden in the frame",
                    "The auction was cancelled",
                    "It sold below estimate"
                ],
                correctAnswerIndex: 1,
                explanation: "The module describes: 'After the hammer hit to confirm the Sotheby's sale for $1.4 million, the work began to self-destruct through a shredder hidden within the frame.' It later sold as 'Love is in the Bin' for $25.4 million in 2021.",
                difficulty: .beginner,
                relatedConcepts: ["banksy", "conceptual-art", "auction-events"]
            ),
            // Question from Section 3.1 Cultural Economics
            QuizQuestion(
                id: "art-q7",
                question: "What is 'cultural capital' as defined in the Cultural Economics section?",
                options: [
                    "Money invested in museums",
                    "The reservoir of knowledge, education, and cultural awareness held by individuals or societies",
                    "A government art fund",
                    "The price of artworks"
                ],
                correctAnswerIndex: 1,
                explanation: "The module explains: 'A key concept in cultural economics is the notion of \"cultural capital.\" This term refers to the reservoir of knowledge, education, and cultural awareness held by individuals or societies.'",
                difficulty: .intermediate,
                relatedConcepts: ["cultural-capital", "cultural-economics"]
            )
        ],
        passingScore: 0.7
    )

    // MARK: - Behavioral Economics Module Quiz
    /// Quiz based on behavioral economics content from multiple modules
    /// Footnotes: Barber & Odean research, Norman Doidge, Beryl Chang
    static let behavioralEconomicsQuiz = Quiz(
        id: "quiz-behavioral-economics",
        title: "🧠 Behavioral Economics",
        description: "Understand how psychology, biases, and brain function affect financial decisions",
        questions: [
            // From Women module - Barber & Odean research
            QuizQuestion(
                id: "be-q1",
                question: "According to Barber and Odean's research cited in the modules, what did they find about gender and trading frequency?",
                options: [
                    "Women trade more frequently",
                    "Men trade 45% more than women, often reducing their returns due to overconfidence",
                    "There is no difference between genders",
                    "Both trade equally but with different outcomes"
                ],
                correctAnswerIndex: 1,
                explanation: "The research 'Boys Will Be Boys: Gender, Overconfidence, and Common Stock Investment' found that men trade 45% more than women, and this overconfidence leads to reduced returns.",
                difficulty: .intermediate,
                relatedConcepts: ["overconfidence", "gender-bias", "trading-behavior"]
            ),
            // From Women module - Analysis Paralysis
            QuizQuestion(
                id: "be-q2",
                question: "What is 'analysis paralysis' in the context of investment decisions?",
                options: [
                    "A medical condition affecting traders",
                    "When endless choices and variant outcomes make it difficult to filter options and decide",
                    "A type of market analysis",
                    "A regulatory term"
                ],
                correctAnswerIndex: 1,
                explanation: "The module explains: 'Due to advancements of technology (and the \"scrolling effect\") we are now given endless choices with variant outcomes. The concept of \"analysis paralysis\" is not new, but can be overwhelming given we have few ways to properly filter our options.'",
                difficulty: .beginner,
                relatedConcepts: ["decision-making", "choice-overload"]
            ),
            // From Women module - Beryl Chang research
            QuizQuestion(
                id: "be-q3",
                question: "According to Beryl Chang's 'Nudges and Behavioral Economics' research, what affects Americans' savings decisions?",
                options: [
                    "Only income levels",
                    "Natural biases and limitations in decision-making",
                    "Government mandates",
                    "Stock market performance only"
                ],
                correctAnswerIndex: 1,
                explanation: "The module cites: 'According to a study on behavioral economics and decision making with Americans' savings decisions, there is a role around natural biases and limitations.' - Beryl Chang, 'Nudges and Behavioral Economics'",
                difficulty: .intermediate,
                relatedConcepts: ["nudges", "savings-behavior", "biases"]
            ),
            // From Women module - Yale/Columbia study on gender bias
            QuizQuestion(
                id: "be-q4",
                question: "What did the joint Yale/Columbia Business School study reveal about gender biases in investing?",
                options: [
                    "There are no gender biases",
                    "Unconscious gender biases exist within the investing space",
                    "Women receive better investment advice",
                    "Men are naturally better investors"
                ],
                correctAnswerIndex: 1,
                explanation: "The module states: 'It is also important to recognize unconscious gender biases within the investing space. Studies conducted by a joint study with the Yale School of Management and Columbia Business School shed light on unconscious gender biases.'",
                difficulty: .intermediate,
                relatedConcepts: ["unconscious-bias", "gender-investing"]
            ),
            // From Alternative Investing - Portfolio management
            QuizQuestion(
                id: "be-q5",
                question: "What is the primary principle underpinning portfolio management according to the Alternative Investing module?",
                options: [
                    "Maximizing returns at any cost",
                    "Effective diversification through combining assets with low correlations",
                    "Investing only in stocks",
                    "Avoiding all risk"
                ],
                correctAnswerIndex: 1,
                explanation: "The module states: 'The primary principle underpinning portfolio management is effective diversification. This involves identifying and combining assets that exhibit low correlations with each other, thereby achieving a more balanced risk-reward profile.'",
                difficulty: .intermediate,
                relatedConcepts: ["diversification", "correlation", "portfolio-management"]
            )
        ],
        passingScore: 0.7
    )

    // MARK: - All Module Quizzes
    static var allQuizzes: [Quiz] {
        [
            alternativeInvestingQuiz,
            womenCollectiveInvestingQuiz,
            artInvestmentQuiz,
            behavioralEconomicsQuiz
        ]
    }

    // MARK: - Get Quiz for Module
    static func quiz(for moduleId: String) -> Quiz? {
        let lowercased = moduleId.lowercased()
        if lowercased.contains("alternative") || lowercased.contains("alt-invest") {
            return alternativeInvestingQuiz
        } else if lowercased.contains("women") || lowercased.contains("collective") {
            return womenCollectiveInvestingQuiz
        } else if lowercased.contains("art") {
            return artInvestmentQuiz
        } else if lowercased.contains("behavioral") || lowercased.contains("econ") {
            return behavioralEconomicsQuiz
        }
        return nil
    }
}
