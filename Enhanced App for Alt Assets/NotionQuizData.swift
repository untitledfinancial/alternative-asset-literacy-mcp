//
//  NotionQuizData.swift
//  Enhanced App for Alt Assets
//
//  Created by Victoria Case on 2/6/26.
//  Copyright 2026 Victoria Case. All rights reserved.
//
//  Description: Quiz questions for each module to test comprehension
//  and reinforce learning.
//

import Foundation

/// Quiz data organized by module
struct NotionQuizData {

    // MARK: - Alternative Investing Module Quiz
    static let altInvestingQuiz = Quiz(
        id: "quiz_alt",
        title: "Alternative Investing Fundamentals",
        description: "Test your understanding of alternative asset classes and their role in portfolios.",
        questions: [
            QuizQuestion(
                id: "q_alt_1",
                question: "What distinguishes alternative investments from traditional investments?",
                options: [
                    "They are only available to wealthy investors",
                    "They include assets outside stocks, bonds, and cash with lower correlation to traditional markets",
                    "They always generate higher returns",
                    "They are regulated by different agencies"
                ],
                correctAnswerIndex: 1,
                explanation: "Alternative investments encompass asset classes beyond traditional stocks, bonds, and cash. They typically have lower correlation with traditional markets, offering diversification benefits.",
                difficulty: .beginner,
                relatedConcepts: ["Alternative Assets"]
            ),
            QuizQuestion(
                id: "q_alt_2",
                question: "What is the 'illiquidity premium' in alternative investments?",
                options: [
                    "A fee charged for early withdrawal",
                    "The additional return expected for holding investments that cannot be easily sold",
                    "A discount on purchase price for bulk buying",
                    "Insurance against market downturns"
                ],
                correctAnswerIndex: 1,
                explanation: "The illiquidity premium is the extra return investors expect as compensation for not being able to quickly sell their investments. This is a key characteristic of many alternative assets.",
                difficulty: .intermediate,
                relatedConcepts: ["Illiquidity Premium"]
            ),
            QuizQuestion(
                id: "q_alt_3",
                question: "What role do Limited Partners (LPs) play in private equity?",
                options: [
                    "They make day-to-day investment decisions",
                    "They provide capital but have limited involvement in management",
                    "They are employees of the fund",
                    "They regulate the fund's activities"
                ],
                correctAnswerIndex: 1,
                explanation: "Limited Partners are passive investors who provide capital to private funds. Their liability is limited to their investment amount, and they don't participate in daily management decisions.",
                difficulty: .intermediate,
                relatedConcepts: ["Limited Partner (LP)"]
            ),
            QuizQuestion(
                id: "q_alt_4",
                question: "Why might an investor add real assets to their portfolio?",
                options: [
                    "They always appreciate faster than stocks",
                    "They offer diversification, income, and potential inflation protection",
                    "They have zero risk",
                    "They are easier to manage than stocks"
                ],
                correctAnswerIndex: 1,
                explanation: "Real assets like real estate and commodities offer portfolio diversification, potential income streams, and can serve as a hedge against inflation, though they come with their own risks.",
                difficulty: .beginner,
                relatedConcepts: ["Tangible Asset"]
            ),
            QuizQuestion(
                id: "q_alt_5",
                question: "What is a 'long/short strategy' in alternative investing?",
                options: [
                    "Investing for both short and long time periods",
                    "Buying undervalued assets (long) while selling overvalued ones (short)",
                    "A strategy only used during market downturns",
                    "Investing in both large and small companies"
                ],
                correctAnswerIndex: 1,
                explanation: "A long/short strategy involves taking long positions in assets expected to increase in value and short positions in those expected to decline, aiming to profit from relative performance.",
                difficulty: .advanced,
                relatedConcepts: []
            )
        ],
        passingScore: 0.7
    )

    // MARK: - Behavioral Economics Module Quiz
    static let behavioralQuiz = Quiz(
        id: "quiz_behavioral",
        title: "Behavioral Economics in Investing",
        description: "Assess your understanding of cognitive biases and their impact on financial decisions.",
        questions: [
            QuizQuestion(
                id: "q_behav_1",
                question: "What is 'loss aversion' in behavioral economics?",
                options: [
                    "Preferring to avoid all risky investments",
                    "The tendency to feel losses more strongly than equivalent gains",
                    "Fear of the stock market",
                    "Always selling investments at a loss"
                ],
                correctAnswerIndex: 1,
                explanation: "Loss aversion describes how the pain of losing is psychologically about twice as powerful as the pleasure of gaining. This can lead to holding losing investments too long.",
                difficulty: .beginner,
                relatedConcepts: ["Loss Aversion"]
            ),
            QuizQuestion(
                id: "q_behav_2",
                question: "How does 'anchoring bias' affect investment decisions?",
                options: [
                    "It makes investors prefer stable assets",
                    "It causes over-reliance on the first piece of information encountered",
                    "It leads to diversified portfolios",
                    "It encourages long-term thinking"
                ],
                correctAnswerIndex: 1,
                explanation: "Anchoring causes people to rely too heavily on initial information (like a stock's original purchase price) when making decisions, even when that anchor is irrelevant to current value.",
                difficulty: .intermediate,
                relatedConcepts: ["Anchoring"]
            ),
            QuizQuestion(
                id: "q_behav_3",
                question: "What is 'herd behavior' in financial markets?",
                options: [
                    "Following professional analysts' recommendations",
                    "The tendency to mimic the actions of a larger group",
                    "Investing only in agricultural stocks",
                    "Avoiding volatile markets"
                ],
                correctAnswerIndex: 1,
                explanation: "Herd behavior is the tendency to follow the crowd, whether rational or not. This can create market bubbles when everyone buys, or crashes when everyone sells.",
                difficulty: .beginner,
                relatedConcepts: ["Herd Behavior"]
            ),
            QuizQuestion(
                id: "q_behav_4",
                question: "What is the 'disposition effect'?",
                options: [
                    "The tendency to sell winners too early and hold losers too long",
                    "Preferring to invest in familiar companies",
                    "Making decisions based on mood",
                    "Avoiding all investment decisions"
                ],
                correctAnswerIndex: 0,
                explanation: "The disposition effect describes how investors tend to sell winning investments too quickly to 'lock in gains' while holding onto losing investments hoping they'll recover.",
                difficulty: .intermediate,
                relatedConcepts: ["Disposition Effect"]
            ),
            QuizQuestion(
                id: "q_behav_5",
                question: "How can awareness of cognitive biases improve investment decisions?",
                options: [
                    "It eliminates all emotional responses",
                    "It allows for implementing checks like cooling-off periods and seeking contrary opinions",
                    "It guarantees better returns",
                    "It replaces the need for financial advisors"
                ],
                correctAnswerIndex: 1,
                explanation: "While we cannot eliminate biases, awareness enables us to implement strategies like checklists, cooling-off periods, and actively seeking contrary viewpoints to counteract their effects.",
                difficulty: .intermediate,
                relatedConcepts: ["Behavioral Economics"]
            )
        ],
        passingScore: 0.7
    )

    // MARK: - Gender and Behavioral Economics Quiz
    static let genderQuiz = Quiz(
        id: "quiz_gender",
        title: "Gender in Behavioral Economics",
        description: "Explore how gender influences investing behavior and financial decision-making.",
        questions: [
            QuizQuestion(
                id: "q_gender_1",
                question: "Research suggests that women investors typically:",
                options: [
                    "Take more risks than men",
                    "Trade less frequently and often achieve better long-term returns",
                    "Avoid all stock market investments",
                    "Only invest in bonds"
                ],
                correctAnswerIndex: 1,
                explanation: "Studies show that women generally trade less frequently than men, which often leads to better long-term returns due to lower transaction costs and avoiding market-timing mistakes.",
                difficulty: .beginner,
                relatedConcepts: ["Gender Investing Gap"]
            ),
            QuizQuestion(
                id: "q_gender_2",
                question: "Overconfidence bias in investing tends to:",
                options: [
                    "Affect all genders equally",
                    "Be more prevalent among male investors, leading to excessive trading",
                    "Only affect professional traders",
                    "Improve investment returns"
                ],
                correctAnswerIndex: 1,
                explanation: "Research shows overconfidence bias is more common among male investors, leading to more frequent trading, which typically reduces net returns due to fees and poor market timing.",
                difficulty: .intermediate,
                relatedConcepts: ["Overconfidence Bias"]
            ),
            QuizQuestion(
                id: "q_gender_3",
                question: "What contributes to the gender investing gap?",
                options: [
                    "Biological factors alone",
                    "Systemic, cultural, psychological, and informational barriers",
                    "Lack of money among women",
                    "Women's disinterest in finance"
                ],
                correctAnswerIndex: 1,
                explanation: "The gender investing gap results from multiple factors including historical exclusion, cultural expectations, psychological barriers like lower financial confidence, and less access to financial education.",
                difficulty: .intermediate,
                relatedConcepts: ["Gender Investing Gap", "Wealth Gap"]
            ),
            QuizQuestion(
                id: "q_gender_5",
                question: "Research on occupational devaluation shows that when women become the majority in a profession:",
                options: [
                    "Wages increase due to greater labor supply",
                    "Wages decline even after controlling for education and skill requirements",
                    "Wages remain stable but benefits decrease",
                    "The profession gains higher social prestige"
                ],
                correctAnswerIndex: 1,
                explanation: "Paula England and other researchers have documented that a 10 percentage-point increase in the share of women in an occupation is associated with a 3\u{2013}5% decrease in median wages, independent of education or skill changes. This pay penalty compounds over a career and directly reduces women\u{2019}s investable capital.",
                difficulty: .intermediate,
                relatedConcepts: ["Occupational Devaluation", "Gender Wealth Gap"]
            ),
            QuizQuestion(
                id: "q_gender_4",
                question: "How might closing the gender investing gap benefit society?",
                options: [
                    "It would only benefit women",
                    "It could enhance economic empowerment, wealth distribution, and generational wealth building",
                    "It would have no measurable impact",
                    "It would decrease market stability"
                ],
                correctAnswerIndex: 1,
                explanation: "Closing the gap could lead to broader economic empowerment, more equitable wealth distribution, stronger generational wealth building, and potentially more stable markets.",
                difficulty: .beginner,
                relatedConcepts: ["Wealth Gap", "Financial Literacy"]
            )
        ],
        passingScore: 0.7
    )

    // MARK: - Women and Investing Quiz
    static let womenQuiz = Quiz(
        id: "quiz_women",
        title: "Women and Investing",
        description: "Test your knowledge about women's unique financial challenges and opportunities.",
        questions: [
            QuizQuestion(
                id: "q_women_1",
                question: "What unique financial challenges do women face that make investing important?",
                options: [
                    "Only retirement planning",
                    "The wage gap, career breaks for caregiving, and longer lifespans",
                    "They face no unique challenges",
                    "Higher tax rates"
                ],
                correctAnswerIndex: 1,
                explanation: "Women face several unique challenges: the wage gap means less income to invest, career breaks for caregiving affect earning potential, and longer lifespans require more retirement savings.",
                difficulty: .beginner,
                relatedConcepts: ["Wealth Gap"]
            ),
            QuizQuestion(
                id: "q_women_2",
                question: "What does 'values-based investing' mean?",
                options: [
                    "Only investing in valuable companies",
                    "Linking investment choices to personal values, goals, and priorities",
                    "Investing based on stock valuations",
                    "Following traditional investment advice"
                ],
                correctAnswerIndex: 1,
                explanation: "Values-based investing means choosing investments that align with your personal values, goals, and priorities, such as ESG-focused companies or impact investments.",
                difficulty: .beginner,
                relatedConcepts: []
            ),
            QuizQuestion(
                id: "q_women_3",
                question: "Why is financial literacy particularly important for women?",
                options: [
                    "Women are naturally worse at finance",
                    "It helps address unique challenges like longer lifespans, wage gaps, and historical exclusion",
                    "It's equally important for everyone with no gender differences",
                    "Women have more money to invest"
                ],
                correctAnswerIndex: 1,
                explanation: "Financial literacy helps women address unique challenges: planning for longer lifespans, maximizing earnings despite wage gaps, and overcoming historical barriers to financial education.",
                difficulty: .intermediate,
                relatedConcepts: ["Financial Literacy"]
            ),
            QuizQuestion(
                id: "q_women_4",
                question: "What role does representation play in women's financial confidence?",
                options: [
                    "It has no effect",
                    "Seeing women in financial roles can inspire confidence and provide role models",
                    "It only matters for professional investors",
                    "It decreases confidence"
                ],
                correctAnswerIndex: 1,
                explanation: "Representation matters for developing financial confidence. Seeing women successfully managing finances and investments provides role models and helps normalize women's participation in investing.",
                difficulty: .beginner,
                relatedConcepts: []
            )
        ],
        passingScore: 0.7
    )

    // MARK: - DeFi Module Quiz
    static let defiQuiz = Quiz(
        id: "quiz_defi",
        title: "DeFi and Blockchain Fundamentals",
        description: "Test your understanding of decentralized finance and blockchain technology.",
        questions: [
            QuizQuestion(
                id: "q_defi_1",
                question: "What is a blockchain?",
                options: [
                    "A type of cryptocurrency",
                    "A distributed digital ledger that records transactions across many computers",
                    "A digital wallet",
                    "A type of smart contract"
                ],
                correctAnswerIndex: 1,
                explanation: "A blockchain is a distributed digital ledger that records transactions across many computers so that records cannot be altered retroactively. It's the foundational technology for cryptocurrencies and NFTs.",
                difficulty: .beginner,
                relatedConcepts: ["Blockchain"]
            ),
            QuizQuestion(
                id: "q_defi_2",
                question: "What makes an NFT 'non-fungible'?",
                options: [
                    "It cannot be sold",
                    "Each NFT is unique and cannot be exchanged one-for-one with another",
                    "It's made of physical materials",
                    "It has no monetary value"
                ],
                correctAnswerIndex: 1,
                explanation: "Non-fungible means each token is unique and not interchangeable. Unlike cryptocurrencies where one Bitcoin equals any other Bitcoin, each NFT represents a distinct item with its own value.",
                difficulty: .beginner,
                relatedConcepts: ["NFT (Non-Fungible Token)"]
            ),
            QuizQuestion(
                id: "q_defi_3",
                question: "What is a smart contract?",
                options: [
                    "A legal document stored digitally",
                    "Self-executing code that automatically enforces agreement terms when conditions are met",
                    "An agreement between two parties",
                    "A type of cryptocurrency"
                ],
                correctAnswerIndex: 1,
                explanation: "Smart contracts are self-executing code stored on a blockchain that automatically enforce the terms of an agreement when predetermined conditions are met, without requiring intermediaries.",
                difficulty: .intermediate,
                relatedConcepts: ["Smart Contract"]
            ),
            QuizQuestion(
                id: "q_defi_4",
                question: "What does 'gas' refer to in blockchain transactions?",
                options: [
                    "The energy used to mine cryptocurrencies",
                    "The fee required to execute transactions on blockchain networks",
                    "A type of token",
                    "Network speed"
                ],
                correctAnswerIndex: 1,
                explanation: "Gas is the fee required to execute transactions on blockchain networks like Ethereum. Gas prices fluctuate based on network demand and transaction complexity.",
                difficulty: .intermediate,
                relatedConcepts: ["Gas"]
            ),
            QuizQuestion(
                id: "q_defi_5",
                question: "What is a DAO?",
                options: [
                    "A type of cryptocurrency",
                    "An organization governed by smart contracts and collective token-holder decision-making",
                    "A digital wallet",
                    "A blockchain network"
                ],
                correctAnswerIndex: 1,
                explanation: "A DAO (Decentralized Autonomous Organization) is governed by smart contracts and collective decision-making by token holders, rather than traditional corporate hierarchy.",
                difficulty: .intermediate,
                relatedConcepts: ["DAO (Decentralized Autonomous Organization)"]
            ),
            QuizQuestion(
                id: "q_defi_6",
                question: "What is a key risk of DeFi and cryptocurrency investments?",
                options: [
                    "Government guarantees make them risk-free",
                    "They have high volatility, regulatory uncertainty, and if you lose your private key you lose your funds",
                    "They are only risky for large investors",
                    "Banks protect your investments"
                ],
                correctAnswerIndex: 1,
                explanation: "DeFi investments carry significant risks: high volatility, uncertain regulation, no FDIC-type protection, and losing access to funds if private keys are lost. Self-custody means full responsibility.",
                difficulty: .beginner,
                relatedConcepts: ["Wallet"]
            )
        ],
        passingScore: 0.7
    )

    // MARK: - Art as Investment Module Quiz
    static let artQuiz = Quiz(
        id: "quiz_art",
        title: "Art as an Alternative Investment",
        description: "Test your knowledge of art markets, valuation, and art investing fundamentals.",
        questions: [
            QuizQuestion(
                id: "q_art_1",
                question: "What is 'provenance' in the art world?",
                options: [
                    "The price of an artwork",
                    "The documented history of ownership from creation to present",
                    "The artist's signature style",
                    "The medium used to create the work"
                ],
                correctAnswerIndex: 1,
                explanation: "Provenance is the documented ownership history of an artwork. It's crucial for establishing authenticity and can significantly affect an artwork's value.",
                difficulty: .beginner,
                relatedConcepts: ["Provenance"]
            ),
            QuizQuestion(
                id: "q_art_2",
                question: "What is the 'primary market' in art?",
                options: [
                    "The largest auction houses",
                    "The market where artworks are sold for the first time, typically through galleries",
                    "Online art sales",
                    "Art fairs"
                ],
                correctAnswerIndex: 1,
                explanation: "The primary market is where artworks are sold for the first time, usually through galleries representing artists. Prices are set by galleries rather than competitive bidding.",
                difficulty: .intermediate,
                relatedConcepts: ["Primary Market"]
            ),
            QuizQuestion(
                id: "q_art_3",
                question: "Why might art be considered a good portfolio diversifier?",
                options: [
                    "Art always increases in value",
                    "Art values typically have low correlation with stock and bond markets",
                    "Art is easy to sell quickly",
                    "Art has no maintenance costs"
                ],
                correctAnswerIndex: 1,
                explanation: "Art values typically show low correlation with traditional financial markets, meaning art may perform differently than stocks and bonds, providing diversification benefits.",
                difficulty: .intermediate,
                relatedConcepts: ["Correlation"]
            ),
            QuizQuestion(
                id: "q_art_4",
                question: "What is 'blue chip art'?",
                options: [
                    "Art with blue as the dominant color",
                    "Art by established artists with consistent market demand and stable values",
                    "The most expensive art",
                    "Art made with expensive materials"
                ],
                correctAnswerIndex: 1,
                explanation: "Blue chip art refers to works by established, highly recognized artists with consistent market demand. These works are considered lower risk in the art market.",
                difficulty: .beginner,
                relatedConcepts: ["Blue Chip Art"]
            ),
            QuizQuestion(
                id: "q_art_5",
                question: "What is 'fractional ownership' in art investing?",
                options: [
                    "Owning a damaged artwork",
                    "Multiple investors each owning a percentage of an artwork",
                    "Renting art temporarily",
                    "Owning only the frame"
                ],
                correctAnswerIndex: 1,
                explanation: "Fractional ownership allows multiple investors to each own a percentage of an expensive artwork, making art investment accessible to those who couldn't afford to buy a whole piece.",
                difficulty: .beginner,
                relatedConcepts: ["Fractional Ownership"]
            ),
            QuizQuestion(
                id: "q_art_6",
                question: "How do NFTs potentially change art ownership?",
                options: [
                    "They make physical art obsolete",
                    "They provide blockchain-verified provenance and enable digital art ownership",
                    "They eliminate the need for artists",
                    "They only work for famous artists"
                ],
                correctAnswerIndex: 1,
                explanation: "NFTs provide blockchain-verified proof of ownership and provenance for digital art. They enable artists to sell digital works directly and potentially receive royalties on resales.",
                difficulty: .intermediate,
                relatedConcepts: ["NFT (Non-Fungible Token)", "Royalties"]
            )
        ],
        passingScore: 0.7
    )

    // MARK: - Kahlo x Basquiat Module Quiz
    static let kahloBasquiatQuiz = Quiz(
        id: "quiz_kahlo",
        title: "Kahlo and Basquiat: Art and Market Value",
        description: "Explore how personal narrative and cultural identity affect artistic and market value.",
        questions: [
            QuizQuestion(
                id: "q_kahlo_1",
                question: "What themes do Frida Kahlo and Jean-Michel Basquiat have in common?",
                options: [
                    "They both painted landscapes",
                    "Both used personal pain and identity as central subjects in their work",
                    "They worked together",
                    "They both used the same painting techniques"
                ],
                correctAnswerIndex: 1,
                explanation: "Both artists transformed personal experience into powerful art. Kahlo explored physical suffering and Mexican identity, while Basquiat addressed race, mortality, and social critique.",
                difficulty: .beginner,
                relatedConcepts: ["Portrait"]
            ),
            QuizQuestion(
                id: "q_kahlo_2",
                question: "How does an artist's biography affect the value of their work?",
                options: [
                    "Biography has no effect on art value",
                    "Compelling life stories and cultural significance can increase collector interest and prices",
                    "Only the artwork quality matters",
                    "Biography only matters for living artists"
                ],
                correctAnswerIndex: 1,
                explanation: "An artist's biography significantly influences market value. Compelling narratives of struggle, identity, and cultural impact create emotional connections that drive collector interest and prices.",
                difficulty: .intermediate,
                relatedConcepts: []
            ),
            QuizQuestion(
                id: "q_kahlo_3",
                question: "What parallel exists between Basquiat's rise and contemporary NFT artists?",
                options: [
                    "Both use the same medium",
                    "Both emerged from outside traditional art institutions to achieve market success",
                    "Neither achieved commercial success",
                    "Both were classically trained"
                ],
                correctAnswerIndex: 1,
                explanation: "Like Basquiat who emerged from street art, many NFT artists gain recognition outside traditional gallery systems, demonstrating how outsider artists can achieve significant market value.",
                difficulty: .intermediate,
                relatedConcepts: ["Graffiti"]
            ),
            QuizQuestion(
                id: "q_kahlo_4",
                question: "What role does cultural identity play in the long-term value of art?",
                options: [
                    "Cultural identity decreases art value",
                    "Works addressing identity, race, and social structures often gain cultural significance and value over time",
                    "Cultural identity is irrelevant to art value",
                    "Only Western cultural identity adds value"
                ],
                correctAnswerIndex: 1,
                explanation: "Art addressing cultural identity, social structures, and marginalized perspectives often appreciates as society recognizes the importance of diverse voices. Both Kahlo and Basquiat exemplify this.",
                difficulty: .intermediate,
                relatedConcepts: []
            )
        ],
        passingScore: 0.7
    )

    // MARK: - Helper to get quizzes by module ID
    static func quizzes(for moduleId: String) -> [Quiz] {
        switch moduleId {
        case "mod_alt":
            return [altInvestingQuiz]
        case "mod_behavioral":
            return [behavioralQuiz]
        case "mod_gender":
            return [genderQuiz]
        case "mod_women":
            return [womenQuiz]
        case "mod_defi":
            return [defiQuiz]
        case "mod_art":
            return [artQuiz]
        case "mod_kahlo":
            return [kahloBasquiatQuiz]
        case "mod_esg_climate":
            return [ESGQuizzes.fundamentalsQuiz, ESGQuizzes.climateFinanceQuiz]
        default:
            return []
        }
    }

    // MARK: - All Quizzes
    static var allQuizzes: [Quiz] {
        [altInvestingQuiz, behavioralQuiz, genderQuiz, womenQuiz, defiQuiz, artQuiz, kahloBasquiatQuiz,
         ESGQuizzes.fundamentalsQuiz, ESGQuizzes.climateFinanceQuiz]
    }
}
