//
//  SampleQuizData.swift
//  Enhanced App for Alt Assets
//
//  Created by Victoria Case on 2/5/26.
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//
//  Description: Sample quiz data generated from Notion module content.
//  Includes quizzes for Alternative Investing, Behavioral Economics,
//  Women and Collective Investing, and Art as Investment modules.
//

import Foundation

// MARK: - Sample Quiz Generator
struct SampleQuizData {

    // MARK: - Alternative Investing Quiz
    static let alternativeInvestingQuiz = Quiz(
        id: "quiz-alt-investing-101",
        title: "Alternative Investing Fundamentals",
        description: "Test your understanding of alternative assets and their role in portfolio diversification",
        questions: [
            QuizQuestion(
                id: "q1-alt",
                question: "What distinguishes alternative investments from traditional investments?",
                options: [
                    "They are only available to wealthy investors",
                    "They don't fall into conventional categories like stocks, bonds, or cash",
                    "They always have higher returns",
                    "They are regulated by the SEC"
                ],
                correctAnswerIndex: 1,
                explanation: "Alternative investments are financial assets that don't fit into conventional categories like stocks, bonds, or cash equivalents. They include private equity, hedge funds, real estate, and commodities.",
                difficulty: .beginner,
                relatedConcepts: ["alternative-assets", "diversification"]
            ),
            QuizQuestion(
                id: "q2-alt",
                question: "According to the World Economic Forum, what is a key benefit of alternative investments?",
                options: [
                    "Guaranteed returns",
                    "Lower fees than traditional investments",
                    "Portfolio diversification and low correlation with traditional markets",
                    "Government insurance protection"
                ],
                correctAnswerIndex: 2,
                explanation: "Alternative investments often have low correlation with traditional markets, making them valuable for portfolio diversification. Source: WEF Alternative Investments 2020 Report",
                difficulty: .intermediate,
                relatedConcepts: ["correlation", "diversification"]
            ),
            QuizQuestion(
                id: "q3-alt",
                question: "Which of the following is typically considered an alternative asset?",
                options: [
                    "S&P 500 index fund",
                    "Treasury bonds",
                    "Private equity",
                    "Savings account"
                ],
                correctAnswerIndex: 2,
                explanation: "Private equity is a classic alternative asset, along with hedge funds, real estate, commodities, art, and other non-traditional investments.",
                difficulty: .beginner,
                relatedConcepts: ["private-equity", "alternative-assets"]
            ),
            QuizQuestion(
                id: "q4-alt",
                question: "What does 'illiquidity premium' refer to in alternative investing?",
                options: [
                    "A fee charged for early withdrawal",
                    "Higher potential returns as compensation for harder-to-sell assets",
                    "A government subsidy for investors",
                    "The cost of maintaining alternative investments"
                ],
                correctAnswerIndex: 1,
                explanation: "Illiquidity premium refers to the potentially higher returns investors may earn as compensation for investing in assets that are harder to sell quickly.",
                difficulty: .intermediate,
                relatedConcepts: ["liquidity", "risk-premium"]
            ),
            QuizQuestion(
                id: "q5-alt",
                question: "Real estate as an alternative investment is valued for all EXCEPT:",
                options: [
                    "Potential rental income",
                    "Inflation hedge properties",
                    "Guaranteed appreciation",
                    "Tangible asset ownership"
                ],
                correctAnswerIndex: 2,
                explanation: "While real estate offers many benefits including rental income, inflation hedging, and tangible ownership, appreciation is never guaranteed and depends on market conditions.",
                difficulty: .intermediate,
                relatedConcepts: ["real-estate", "inflation-hedge"]
            )
        ],
        passingScore: 0.7
    )

    // MARK: - Behavioral Economics Quiz
    static let behavioralEconomicsQuiz = Quiz(
        id: "quiz-behavioral-econ-101",
        title: "Behavioral Economics & Decision Making",
        description: "Explore how psychology affects financial decisions and investment behavior",
        questions: [
            QuizQuestion(
                id: "q1-be",
                question: "According to Barber and Odean's research 'Boys Will Be Boys,' what did they find about gender and trading?",
                options: [
                    "Women trade more frequently than men",
                    "Men trade more frequently, often to their detriment due to overconfidence",
                    "There is no difference in trading behavior",
                    "Both genders trade equally well"
                ],
                correctAnswerIndex: 1,
                explanation: "The study found that men trade 45% more than women, and this overconfidence leads to reduced returns. Overconfident investors trade excessively and hurt their performance.",
                difficulty: .intermediate,
                relatedConcepts: ["overconfidence", "behavioral-bias"]
            ),
            QuizQuestion(
                id: "q2-be",
                question: "What is 'analysis paralysis' in investment decision-making?",
                options: [
                    "A legal term for frozen assets",
                    "When too many choices lead to inability to make decisions",
                    "A type of market analysis",
                    "A regulatory requirement"
                ],
                correctAnswerIndex: 1,
                explanation: "Analysis paralysis occurs when faced with too many options, making it difficult to make any decision at all. This is particularly relevant in today's world of endless investment choices.",
                difficulty: .beginner,
                relatedConcepts: ["decision-making", "cognitive-bias"]
            ),
            QuizQuestion(
                id: "q3-be",
                question: "What is the 'Lake Wobegon Effect' in behavioral economics?",
                options: [
                    "A tendency for markets to stay stable",
                    "The illusion that everyone is above average",
                    "A pricing mechanism",
                    "A type of market bubble"
                ],
                correctAnswerIndex: 1,
                explanation: "Named after the fictional town where 'all the children are above average,' this refers to people's tendency to overestimate their own abilities compared to others.",
                difficulty: .intermediate,
                relatedConcepts: ["overconfidence", "self-assessment"]
            ),
            QuizQuestion(
                id: "q4-be",
                question: "What does neuroeconomics study?",
                options: [
                    "The economics of healthcare",
                    "How brain function affects economic decision-making",
                    "Neural network trading algorithms",
                    "The cost of brain research"
                ],
                correctAnswerIndex: 1,
                explanation: "Neuroeconomics combines neuroscience, psychology, and economics to understand how people make decisions. Dr. Jonathan Cohen's research explores how different brain regions compete in decision-making.",
                difficulty: .advanced,
                relatedConcepts: ["neuroeconomics", "decision-making"]
            ),
            QuizQuestion(
                id: "q5-be",
                question: "According to Norman Doidge's 'The Brain That Changes Itself,' what is neuroplasticity?",
                options: [
                    "The brain's fixed structure at birth",
                    "The brain's ability to reorganize and form new connections throughout life",
                    "A type of brain surgery",
                    "A mental illness"
                ],
                correctAnswerIndex: 1,
                explanation: "Neuroplasticity refers to the brain's remarkable ability to change and adapt, forming new neural connections throughout life. This has implications for learning new financial behaviors.",
                difficulty: .intermediate,
                relatedConcepts: ["neuroplasticity", "learning"]
            )
        ],
        passingScore: 0.7
    )

    // MARK: - Women and Collective Investing Quiz
    static let womenInvestingQuiz = Quiz(
        id: "quiz-women-investing-101",
        title: "Women and Collective Investing",
        description: "Understanding the unique perspectives and power of women in wealth creation",
        questions: [
            QuizQuestion(
                id: "q1-wi",
                question: "What does the module suggest about women's approach to wealth creation?",
                options: [
                    "Women should follow traditional male investment strategies",
                    "Women should embrace their own power and unique perspectives in financial ecosystems",
                    "Women are naturally bad at investing",
                    "Investing is the same regardless of gender"
                ],
                correctAnswerIndex: 1,
                explanation: "The module emphasizes embracing personal power and recognizing that women have unique strengths and perspectives that can be leveraged in wealth creation.",
                difficulty: .beginner,
                relatedConcepts: ["empowerment", "investing-mindset"]
            ),
            QuizQuestion(
                id: "q2-wi",
                question: "What percentage of new US entrepreneurs are women, according to recent data?",
                options: [
                    "25%",
                    "35%",
                    "50%",
                    "75%"
                ],
                correctAnswerIndex: 2,
                explanation: "According to Alexandre Tanzi's research, half of new US entrepreneurs are women, leading a business creation boom.",
                difficulty: .beginner,
                relatedConcepts: ["entrepreneurship", "women-in-business"]
            ),
            QuizQuestion(
                id: "q3-wi",
                question: "What does the module recommend using instead of 'gut' reaction?",
                options: [
                    "Data analysis only",
                    "Following others' advice",
                    "Intuition combined with informed decision-making",
                    "Avoiding all decisions"
                ],
                correctAnswerIndex: 2,
                explanation: "The module suggests utilizing intuition versus 'gut' reaction, recognizing that intuition informed by knowledge creates better decision-making frameworks.",
                difficulty: .intermediate,
                relatedConcepts: ["intuition", "decision-making"]
            ),
            QuizQuestion(
                id: "q4-wi",
                question: "What concept does the module suggest moving away from?",
                options: [
                    "Collaborative investing",
                    "Binary thought processes (+/-)",
                    "Long-term planning",
                    "Diversification"
                ],
                correctAnswerIndex: 1,
                explanation: "The module recommends moving from binary thinking to an intuitive ecosystem approach, recognizing the complexity of financial decisions.",
                difficulty: .intermediate,
                relatedConcepts: ["mindset", "holistic-thinking"]
            ),
            QuizQuestion(
                id: "q5-wi",
                question: "Why is understanding personal power important before investing?",
                options: [
                    "It's not important",
                    "To impress financial advisors",
                    "To break down foundational myths and make empowered choices",
                    "To follow trends"
                ],
                correctAnswerIndex: 2,
                explanation: "Understanding personal power helps break down the foundational myths that have historically limited women's participation in wealth creation.",
                difficulty: .beginner,
                relatedConcepts: ["empowerment", "myths"]
            )
        ],
        passingScore: 0.7
    )

    // MARK: - Art as Investment Quiz
    static let artInvestingQuiz = Quiz(
        id: "quiz-art-investing-101",
        title: "Art as an Investment",
        description: "Explore the world of art collecting and investment",
        questions: [
            QuizQuestion(
                id: "q1-art",
                question: "What landmark NFT sale occurred in 2021, according to the New York Times?",
                options: [
                    "A digital painting sold for $1 million",
                    "Beeple's JPG file sold for $69 million",
                    "A physical painting was tokenized",
                    "The first NFT was created"
                ],
                correctAnswerIndex: 1,
                explanation: "In March 2021, a digital artwork by Beeple sold at Christie's for $69 million, marking a watershed moment for NFTs in the art world.",
                difficulty: .beginner,
                relatedConcepts: ["nft", "digital-art"]
            ),
            QuizQuestion(
                id: "q2-art",
                question: "What is a key consideration when investing in art according to Mary Rozell's handbook?",
                options: [
                    "Only buy what's trending",
                    "Understanding provenance, condition, and market dynamics",
                    "Always buy the most expensive piece",
                    "Only invest in living artists"
                ],
                correctAnswerIndex: 1,
                explanation: "The Art Collector's Handbook emphasizes understanding provenance (ownership history), condition, and market dynamics as key factors in art investment.",
                difficulty: .intermediate,
                relatedConcepts: ["provenance", "art-market"]
            ),
            QuizQuestion(
                id: "q3-art",
                question: "What famous project did Damien Hirst complete between 1986-2011?",
                options: [
                    "Shark in formaldehyde series",
                    "The Complete Spot Paintings",
                    "Diamond skull",
                    "Butterfly series"
                ],
                correctAnswerIndex: 1,
                explanation: "Damien Hirst's Complete Spot Paintings (1986-2011) were exhibited at Gagosian galleries worldwide, demonstrating conceptual art's market value.",
                difficulty: .advanced,
                relatedConcepts: ["contemporary-art", "damien-hirst"]
            ),
            QuizQuestion(
                id: "q4-art",
                question: "What makes art unique as an alternative asset?",
                options: [
                    "It always appreciates in value",
                    "It combines aesthetic enjoyment with potential financial returns",
                    "It's guaranteed by the government",
                    "It can be easily liquidated"
                ],
                correctAnswerIndex: 1,
                explanation: "Art is unique because it offers both aesthetic and cultural enjoyment alongside potential financial appreciation, though returns are never guaranteed.",
                difficulty: .beginner,
                relatedConcepts: ["art-value", "alternative-assets"]
            ),
            QuizQuestion(
                id: "q5-art",
                question: "What should investors understand about the art market's liquidity?",
                options: [
                    "Art can be sold instantly like stocks",
                    "Art is generally illiquid and may take time to sell",
                    "There's a central exchange for art",
                    "All art holds its value"
                ],
                correctAnswerIndex: 1,
                explanation: "Unlike stocks, art is generally illiquid. Selling artwork can take time, and finding the right buyer at the right price requires patience and expertise.",
                difficulty: .intermediate,
                relatedConcepts: ["liquidity", "art-market"]
            )
        ],
        passingScore: 0.7
    )

    // MARK: - All Sample Quizzes
    static var allQuizzes: [Quiz] {
        [
            alternativeInvestingQuiz,
            behavioralEconomicsQuiz,
            womenInvestingQuiz,
            artInvestingQuiz
        ]
    }

    // MARK: - Quiz by Module ID
    static func quiz(for moduleId: String) -> Quiz? {
        switch moduleId.lowercased() {
        case let id where id.contains("alternative") || id.contains("alt-invest"):
            return alternativeInvestingQuiz
        case let id where id.contains("behavioral") || id.contains("econ"):
            return behavioralEconomicsQuiz
        case let id where id.contains("women") || id.contains("collective"):
            return womenInvestingQuiz
        case let id where id.contains("art"):
            return artInvestingQuiz
        default:
            return nil
        }
    }
}
