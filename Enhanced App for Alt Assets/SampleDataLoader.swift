//
//  SampleDataLoader.swift
//  Enhanced App for Alt Assets
//
//  Created by Victoria Case on 2/1/26.
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//
//  Description: Provides sample module data for development and demonstration.
//  Now loads modules from NotionModulesData which contains content directly
//  imported from Victoria's Notion workspace.
//

import Foundation

struct SampleDataLoader {

    // MARK: - Load Modules from Notion Data
    /// Returns modules loaded from Notion content (NotionModulesData.swift)
    /// Enhanced with reflection prompts, quizzes, and case studies
    static func loadSampleModules() -> [Module] {
        // Load modules from Notion-imported data
        var modules = NotionModulesData.loadModules()

        // Add ESG/Climate module
        modules.append(ESGClimateModuleData.esgClimateModule)

        // Add DeFi Investing module (advanced, separate from DeFi 101)
        modules.append(DeFiInvestingModuleData.defiInvestingModule)

        // Venture Capital & Private Equity module (mod_vc_pe) is not yet ready for release.
        // Re-enable by appending VentureCapitalModuleData.vcModule and adding "mod_vc_pe" to displayOrder.

        // Reorder modules for display: Investing Primer first, then logical progression
        let displayOrder = [
            "mod_women",           // 1. Investing Primer (foundational)
            "mod_alt",             // 2. Alternative Investing
            "mod_behavioral",      // 3. Behavioral Economics
            "mod_gender",          // 4. Gender and Behavioral Investing
            "mod_defi",            // 5. Decentralized Finance
            "mod_art",             // 6. Art as Investment
            "mod_esg_climate",     // 7. Climate, Energy & Real World Assets
            "mod_defi_investing",  // 8. DeFi Investing (advanced)
            "mod_kahlo_basquiat"   // 9. Bonus: Kahlo x Basquiat
        ]
        modules.sort { a, b in
            let aIndex = displayOrder.firstIndex(of: a.id) ?? displayOrder.count
            let bIndex = displayOrder.firstIndex(of: b.id) ?? displayOrder.count
            return aIndex < bIndex
        }

        // Enhance each module with reflection prompts, quizzes, and case studies.
        // Only overwrite if the external source has data — modules like DeFi Investing
        // and ESG/Climate embed their own prompts, quizzes, and case studies directly.
        for i in 0..<modules.count {
            // Add reflection prompts (only if external source has them)
            let prompts = NotionReflectionPrompts.prompts(for: modules[i].id)
            if !prompts.isEmpty {
                modules[i].reflectionPrompts = prompts
            }

            // Add quizzes if available
            let quizzes = NotionQuizData.quizzes(for: modules[i].id)
            if !quizzes.isEmpty {
                modules[i].quizzes = quizzes
            }

            // Add case studies (only if external source has them)
            let cases = NotionCaseStudies.caseStudies(for: modules[i].id)
            if !cases.isEmpty {
                modules[i].caseStudies = cases
            }
        }

        return modules
    }

    // MARK: - Legacy Sample Modules (kept for reference)
    static func loadLegacySampleModules() -> [Module] {
        [
            // Module 1: Introduction to Alternative Investing
            Module(
                id: "mod_1",
                title: "Introduction to Alternative Investing",
                description: "Explore the foundations of alternative assets, from private equity to collectibles, and understand why they're gaining prominence in modern portfolios.",
                icon: "📊",
                color: "blue",
                sections: [
                    Section(
                        id: "sec_1_1",
                        title: "What Are Alternative Assets?",
                        content: [
                            .text("Alternative investments encompass asset classes beyond traditional stocks, bonds, and cash. These include real estate, private equity, hedge funds, commodities, art, and more recently, cryptocurrency and digital assets."),
                            .callout(
                                title: "Key Distinction",
                                content: "Alternative assets often have lower correlation with traditional markets, offering potential diversification benefits for investors.",
                                type: .info
                            ),
                            .text("The alternative investment market has grown significantly, with institutional investors allocating increasing portions of their portfolios to these assets. This growth reflects recognition of their potential to enhance returns and manage risk."),
                            .bulletList([
                                "Private Equity: Investments in private companies",
                                "Real Estate: Direct property ownership or REITs",
                                "Hedge Funds: Pooled investments using various strategies",
                                "Commodities: Physical goods like gold, oil, agricultural products",
                                "Collectibles: Art, wine, classic cars, rare items",
                                "Digital Assets: Cryptocurrency, NFTs, digital collectibles"
                            ])
                        ],
                        isCollapsible: true,
                        level: 2,
                        reflectionPrompts: ["prompt_1"],
                        glossaryTerms: ["Alternative Assets", "Diversification"],
                        relatedResearch: []
                    ),
                    Section(
                        id: "sec_1_2",
                        title: "Why Alternative Investments Matter",
                        content: [
                            .text("Alternative investments play a crucial role in modern portfolio construction. They offer several potential advantages that traditional assets may not provide."),
                            .heading("Diversification Benefits", level: 3),
                            .text("One of the primary reasons investors turn to alternatives is diversification. Because these assets often move independently of stock and bond markets, they can help reduce overall portfolio volatility."),
                            .callout(
                                title: "Research Finding",
                                content: "Studies show that portfolios with 15-20% alternative asset allocation can reduce volatility by up to 25% while maintaining similar returns.",
                                type: .research
                            ),
                            .heading("Access to Unique Opportunities", level: 3),
                            .text("Alternative investments provide access to market segments unavailable through public markets. Private equity allows investment in promising companies before they go public. Real estate offers direct ownership of income-producing properties."),
                            .quote("In investing, what is comfortable is rarely profitable.", author: "Robert Arnott")
                        ],
                        isCollapsible: true,
                        level: 2,
                        reflectionPrompts: ["prompt_2"],
                        glossaryTerms: ["Diversification", "Volatility"],
                        relatedResearch: []
                    ),
                    Section(
                        id: "sec_1_3",
                        title: "Risks and Considerations",
                        content: [
                            .text("While alternative investments offer potential benefits, they also come with unique risks and considerations that investors must understand."),
                            .callout(
                                title: "Important Warning",
                                content: "Alternative investments are not suitable for all investors and require careful due diligence.",
                                type: .warning
                            ),
                            .numberedList([
                                "Liquidity Risk: Many alternatives cannot be quickly converted to cash",
                                "Complexity: These investments often require specialized knowledge",
                                "Higher Fees: Management and performance fees can be substantial",
                                "Limited Regulation: Less oversight than traditional investments",
                                "Valuation Challenges: Difficult to determine fair market value",
                                "Minimum Investments: Often require significant capital commitments"
                            ]),
                            .text("Understanding these risks is essential before incorporating alternatives into your investment strategy. This knowledge helps set realistic expectations and avoid common pitfalls.")
                        ],
                        isCollapsible: true,
                        level: 2,
                        reflectionPrompts: ["prompt_3"],
                        glossaryTerms: ["Liquidity Risk", "Due Diligence"],
                        relatedResearch: []
                    )
                ],
                reflectionPrompts: [
                    ReflectionPrompt(
                        id: "prompt_1",
                        question: "Think about your current investment portfolio. What percentage is in alternative assets? Why did you choose that allocation?",
                        context: "Understanding your current allocation helps identify opportunities for diversification.",
                        relatedSections: ["sec_1_1"]
                    ),
                    ReflectionPrompt(
                        id: "prompt_2",
                        question: "Consider the concept of correlation. Can you identify assets in your life that have low correlation (move independently)?",
                        context: "This exercise helps build intuition about diversification beyond finance.",
                        relatedSections: ["sec_1_2"]
                    ),
                    ReflectionPrompt(
                        id: "prompt_3",
                        question: "Reflect on a time when you faced liquidity constraints. How did it affect your decision-making?",
                        context: "Personal experience with liquidity helps understand why it matters in investing.",
                        relatedSections: ["sec_1_3"]
                    )
                ],
                quizzes: [
                    Quiz(
                        id: "quiz_1",
                        title: "Alternative Investing Fundamentals",
                        description: "Test your understanding of alternative asset basics",
                        questions: [
                            QuizQuestion(
                                id: "q1_1",
                                question: "Which of the following is NOT typically considered an alternative investment?",
                                options: [
                                    "Private equity",
                                    "Index mutual funds",
                                    "Hedge funds",
                                    "Collectible art"
                                ],
                                correctAnswerIndex: 1,
                                explanation: "Index mutual funds are traditional investments that track public stock market indices. Alternative investments are those outside traditional stocks, bonds, and cash.",
                                difficulty: .beginner,
                                relatedConcepts: ["Alternative Assets"]
                            ),
                            QuizQuestion(
                                id: "q1_2",
                                question: "What is the primary benefit of adding alternative investments to a portfolio?",
                                options: [
                                    "Guaranteed higher returns",
                                    "Complete elimination of risk",
                                    "Diversification and reduced correlation",
                                    "Lower management fees"
                                ],
                                correctAnswerIndex: 2,
                                explanation: "The main benefit of alternative investments is diversification. They typically have low correlation with traditional assets, which can help reduce overall portfolio volatility without guaranteeing higher returns.",
                                difficulty: .intermediate,
                                relatedConcepts: ["Diversification", "Correlation"]
                            ),
                            QuizQuestion(
                                id: "q1_3",
                                question: "Liquidity risk in alternative investments refers to:",
                                options: [
                                    "The risk of the investment losing value",
                                    "The difficulty of quickly converting the investment to cash",
                                    "The risk of regulatory changes",
                                    "The complexity of understanding the investment"
                                ],
                                correctAnswerIndex: 1,
                                explanation: "Liquidity risk specifically refers to the difficulty of converting an investment into cash quickly without significant loss of value. Many alternative investments have lock-up periods or limited secondary markets.",
                                difficulty: .beginner,
                                relatedConcepts: ["Liquidity Risk"]
                            )
                        ],
                        passingScore: 0.7
                    )
                ],
                caseStudies: [
                    CaseStudy(
                        id: "case_1_1",
                        title: "The Portfolio Diversification Decision",
                        scenario: "An investor has $500,000 in a portfolio currently allocated 80% stocks and 20% bonds. They're considering adding alternative investments but are concerned about liquidity and complexity. Research suggests that portfolios with 15-20% alternative asset allocation can reduce volatility by up to 25% while maintaining similar returns, but these investments often have 3-7 year lock-up periods.",
                        context: "Educational example demonstrating risk-return tradeoffs",
                        keyQuestions: [
                            "What factors should influence the decision to add alternative investments?",
                            "How does liquidity risk weigh against diversification benefits?",
                            "What questions should the investor ask before committing capital?"
                        ],
                        learningFocus: ["Risk Assessment", "Portfolio Construction", "Critical Thinking"],
                        relatedSection: "sec_1_2",
                        source: "From: Why Alternative Investments Matter in Introduction to Alternative Investing"
                    )
                ],
                estimatedTime: 30,
                tags: ["Fundamentals", "Alternative Assets", "Portfolio Management"]
            ),
            
            // Module 2: Behavioral Economics in Investing (Enhanced from Notion content)
            Module(
                id: "mod_2",
                title: "Behavioral Economics & Investing Psychology",
                description: "Understand how cognitive biases affect investment decisions. Explore the intersection of neuroscience, psychology, and finance to make more informed choices.",
                icon: "🧠",
                color: "purple",
                sections: [
                    // Section 1: The Why
                    Section(
                        id: "sec_2_1",
                        title: "1. The Why: Understanding Motivation",
                        content: [
                            .text("Boiled down, discerning one's motivation is the basis of Behavioral Economics. Many times, when it comes to investing, an advisor and/or investor will learn more by asking the question \"Why?\""),
                            .callout(
                                title: "Key Insight",
                                content: "The best way to understand one's own investment strategies, or another's, is to not look at what they are doing but why they are doing it.",
                                type: .tip
                            ),
                            .quote("Motivation rather than action leads to a truer sense of comprehension.", author: nil),
                            .heading("What is Neuroeconomics?", level: 3),
                            .text("Neuroeconomics emerges as a crucial interdisciplinary frontier, weaving together the threads of economics, neuroscience, and psychology. A branch stemming from the tree of behavioral economics."),
                            .text("The foundations of behavioral economics are elucidated as \"commonly observed economic phenomena that were inconsistent with standard (economic) theory.\""),
                            .heading("The Objectives", level: 3),
                            .text("Neuroeconomics research aims to advance our comprehension of decision-making processes, from the neural calculations involved to their real-world implications."),
                            .bulletList([
                                "Understand how the brain processes financial decisions",
                                "Identify neural patterns that lead to bias",
                                "Develop strategies to counteract irrational behavior",
                                "Create more effective financial education"
                            ])
                        ],
                        isCollapsible: true,
                        level: 2,
                        reflectionPrompts: ["prompt_4"],
                        glossaryTerms: ["Neuroeconomics", "Behavioral Economics"],
                        relatedResearch: []
                    ),
                    // Section 2: Brain Regions
                    Section(
                        id: "sec_2_1b",
                        title: "1.3 The Parts that Influence the Whole",
                        content: [
                            .callout(
                                title: "A Brief Overview of the Brain",
                                content: "Understanding which brain regions activate during financial decisions helps explain why we make certain choices.",
                                type: .info
                            ),
                            .heading("Brain Regions and Investing", level: 3),
                            .bulletList([
                                "Prefrontal Cortex: Executive function, planning, rational decision-making",
                                "Amygdala: Fear response, emotional reactions, fight-or-flight during market crashes",
                                "Nucleus Accumbens: Reward processing, dopamine release during winning trades",
                                "Anterior Insula: Risk perception, gut feelings about investments"
                            ]),
                            .text("As Michael Merzenich explains in The Brain that Changes Itself, the concept of competitive plasticity sheds light on the roots of our persistent bad habits along with the challenges of breaking them."),
                            .callout(
                                title: "Neuroplasticity Insight",
                                content: "When we endeavor to alter well-established neural networks associated with learned behaviors, most attempts involve 'adding' positive habits. However, the crux lies in replacing the old patterns entirely.",
                                type: .research
                            )
                        ],
                        isCollapsible: true,
                        level: 2,
                        reflectionPrompts: [],
                        glossaryTerms: ["Neuroplasticity", "Competitive Plasticity"],
                        relatedResearch: []
                    ),
                    // Section 3: Choices
                    Section(
                        id: "sec_2_2",
                        title: "2. Choices Under Uncertainty",
                        content: [
                            .text("One fundamental concept in Behavioral Economics is the principle of Choice under Certainty. It's akin to a menu presenting a range of options, each with known outcomes."),
                            .text("However, life rarely adheres to such simplicity, and the same holds true for the world of investments."),
                            .callout(
                                title: "The Question",
                                content: "So how does one make sound choices under ever-changing market uncertainty? First, learn the layout of the proverbial land.",
                                type: .tip
                            ),
                            .heading("Cognitive Biases in Alternative Asset Investments", level: 3),
                            .text("Cognitive biases are blinders, both intentional and unintentional, that often lead to perceptual distortion, inaccurate judgment, or illogical interpretation.")
                        ],
                        isCollapsible: true,
                        level: 2,
                        reflectionPrompts: ["prompt_5"],
                        glossaryTerms: ["Choice Under Certainty", "Cognitive Bias"],
                        relatedResearch: []
                    ),
                    // Section 4: Confirmation Bias
                    Section(
                        id: "sec_2_3",
                        title: "2.2 Confirmation Bias",
                        content: [
                            .text("Confirmation bias, a cognitive tendency that plays a pivotal role in the world of alternative asset investments, can wield a substantial influence over our decision-making processes."),
                            .text("It revolves around our natural inclination to seek out information that confirms our existing beliefs while ignoring contradictory evidence."),
                            .callout(
                                title: "Deliberate versus Spontaneous Case Building",
                                content: "Research distinguishes between deliberate confirmation bias (actively seeking confirming evidence) and spontaneous bias (unconsciously filtering information).",
                                type: .research
                            ),
                            .bulletList([
                                "Seek diverse perspectives, especially contrarian views",
                                "Actively look for information that challenges your thesis",
                                "Use a devil's advocate approach in investment decisions",
                                "Document your investment reasoning to review later"
                            ])
                        ],
                        isCollapsible: true,
                        level: 2,
                        reflectionPrompts: [],
                        glossaryTerms: ["Confirmation Bias"],
                        relatedResearch: []
                    ),
                    // Section 5: Overconfidence Bias
                    Section(
                        id: "sec_2_4",
                        title: "2.3 Overconfidence Bias",
                        content: [
                            .heading("The Exaggeration Paradox", level: 3),
                            .text("Overconfidence bias is a curious cognitive quirk that resides within our decision-making psyche. It manifests as a propensity to overestimate one's capabilities, knowledge, or skills."),
                            .callout(
                                title: "Research Finding",
                                content: "Studies by Barber and Odean found that overconfident investors trade more frequently and earn lower returns. Men traded 45% more than women and earned annual risk-adjusted returns that were 1.4% lower.",
                                type: .research
                            ),
                            .heading("How Does It Unfold?", level: 3),
                            .bulletList([
                                "Illusion of control over market outcomes",
                                "Overestimation of personal stock-picking ability",
                                "Underestimation of risks in familiar investments",
                                "Excessive trading based on perceived expertise"
                            ]),
                            .text("While acknowledging that overconfidence bias can lead to errors in judgment, it's essential to recognize that a moderate level of confidence can prove beneficial in specific situations.")
                        ],
                        isCollapsible: true,
                        level: 2,
                        reflectionPrompts: [],
                        glossaryTerms: ["Overconfidence Bias"],
                        relatedResearch: []
                    ),
                    // Section 6: The Gender Factor
                    Section(
                        id: "sec_2_5",
                        title: "A Deeper Look into the Gender Factor",
                        content: [
                            .callout(
                                title: "Side Step Here",
                                content: "Before we can go any further into Biases we need to highlight first the Gender Factor...",
                                type: .info
                            ),
                            .text("Money currently represents a form of freedom for women, albeit there are significant ethical dilemmas considering the perspective that Capitalism equates to Individualism."),
                            .text("Finance and money serve as emotional instruments. Whether for an individual consumer or a family office, viewing finances solely as data points on a spreadsheet fails to capture the full essence of financial decision-making."),
                            .heading("The Economic Reality", level: 3),
                            .text("From a strictly economic perspective, there isn't a single country worldwide, even in developed nations, where women's average workforce earnings equal those of men."),
                            .callout(
                                title: "Behavioral Economics Lens",
                                content: "When we examine this from the lens of behavioral economics, the gender dimension has often been overlooked. This is where subjective perception comes into play.",
                                type: .research
                            ),
                            .heading("Investment Behavior Differences", level: 3),
                            .text("Gender-related differences in investment behavior encompass a broad spectrum, spanning from risk aversion and financial literacy to diversification strategies."),
                            .bulletList([
                                "Women tend to trade less frequently (often leading to better returns)",
                                "Research shows women focus more on long-term value",
                                "Different approaches to risk assessment and diversification",
                                "Preference for socially responsible investing"
                            ])
                        ],
                        isCollapsible: true,
                        level: 2,
                        reflectionPrompts: ["prompt_gender"],
                        glossaryTerms: ["Gender Lens Investing"],
                        relatedResearch: []
                    ),
                    // Section 7: Loss Aversion
                    Section(
                        id: "sec_2_6",
                        title: "Loss Aversion and Risk Perception",
                        content: [
                            .text("Behavioral economists have found that losses hurt psychologically about twice as much as gains feel good. This asymmetry profoundly affects investment behavior."),
                            .callout(
                                title: "Key Insight",
                                content: "Loss aversion explains why investors often sell winners too early (to lock in gains) and hold losers too long (to avoid realizing losses).",
                                type: .tip
                            ),
                            .quote("The investor's chief problem—and even his worst enemy—is likely to be himself.", author: "Benjamin Graham"),
                            .quote("People are capable of reasoning and know exactly what they are looking for all the time. The inconsistency in preference, judgment, and choice among humans is largely due to the structure of the human brain.", author: "Beryl Y. Chang"),
                            .text("Understanding your own loss aversion can help you develop more rational investment strategies. It's not about eliminating emotion—that's impossible—but about recognizing how it influences decisions.")
                        ],
                        isCollapsible: true,
                        level: 2,
                        reflectionPrompts: ["prompt_5"],
                        glossaryTerms: ["Loss Aversion", "Risk Perception"],
                        relatedResearch: []
                    )
                ],
                reflectionPrompts: [
                    ReflectionPrompt(
                        id: "prompt_4",
                        question: "What motivates most of your financial decisions: fear, opportunity, habit, or something else?",
                        context: "Understanding your primary motivator helps identify potential biases.",
                        relatedSections: ["sec_2_1"]
                    ),
                    ReflectionPrompt(
                        id: "prompt_5",
                        question: "Think about a recent financial decision where you felt strong emotions. How might loss aversion have influenced your choice?",
                        context: "Emotional awareness is the first step to making more rational decisions.",
                        relatedSections: ["sec_2_6"]
                    ),
                    ReflectionPrompt(
                        id: "prompt_gender",
                        question: "How has your gender influenced your confidence or approach in investing?",
                        context: "Recognizing gendered patterns in financial behavior can reveal blind spots.",
                        relatedSections: ["sec_2_5"]
                    )
                ],
                quizzes: [
                    Quiz(
                        id: "quiz_2",
                        title: "Behavioral Economics Fundamentals",
                        description: "Test your understanding of cognitive biases and behavioral finance",
                        questions: [
                            QuizQuestion(
                                id: "q2_1",
                                question: "What is the primary goal of Neuroeconomics?",
                                options: [
                                    "To maximize investment returns",
                                    "To understand how the brain processes financial decisions",
                                    "To create new financial products",
                                    "To predict stock market movements"
                                ],
                                correctAnswerIndex: 1,
                                explanation: "Neuroeconomics weaves together economics, neuroscience, and psychology to understand how we make financial decisions at a neural level.",
                                difficulty: .beginner,
                                relatedConcepts: ["Neuroeconomics"]
                            ),
                            QuizQuestion(
                                id: "q2_2",
                                question: "According to behavioral economics research, losses hurt approximately how much more than gains feel good?",
                                options: [
                                    "1.5 times more",
                                    "2 times more",
                                    "3 times more",
                                    "5 times more"
                                ],
                                correctAnswerIndex: 1,
                                explanation: "Studies consistently show that losses are felt approximately twice as strongly as equivalent gains—this is loss aversion.",
                                difficulty: .beginner,
                                relatedConcepts: ["Loss Aversion"]
                            ),
                            QuizQuestion(
                                id: "q2_3",
                                question: "Confirmation bias in investing leads to:",
                                options: [
                                    "Seeking diverse perspectives on investments",
                                    "Actively looking for contradictory evidence",
                                    "Favoring information that confirms existing beliefs",
                                    "Making decisions based purely on data"
                                ],
                                correctAnswerIndex: 2,
                                explanation: "Confirmation bias makes us seek out information that confirms what we already believe while ignoring contradictory evidence.",
                                difficulty: .beginner,
                                relatedConcepts: ["Confirmation Bias"]
                            ),
                            QuizQuestion(
                                id: "q2_4",
                                question: "Research by Barber and Odean found that overconfident investors:",
                                options: [
                                    "Trade less and earn higher returns",
                                    "Trade more frequently and earn lower returns",
                                    "Have the same returns as other investors",
                                    "Only invest in safe assets"
                                ],
                                correctAnswerIndex: 1,
                                explanation: "Overconfident investors trade 45% more frequently and earn annual risk-adjusted returns that are 1.4% lower than less active traders.",
                                difficulty: .intermediate,
                                relatedConcepts: ["Overconfidence Bias"]
                            ),
                            QuizQuestion(
                                id: "q2_5",
                                question: "Which brain region is primarily associated with fear responses during market crashes?",
                                options: [
                                    "Prefrontal Cortex",
                                    "Nucleus Accumbens",
                                    "Amygdala",
                                    "Hippocampus"
                                ],
                                correctAnswerIndex: 2,
                                explanation: "The amygdala processes fear and emotional reactions, including the fight-or-flight response that can cause panic selling during market downturns.",
                                difficulty: .intermediate,
                                relatedConcepts: ["Neuroeconomics", "Amygdala"]
                            ),
                            QuizQuestion(
                                id: "q2_6",
                                question: "According to the module, the best way to understand investment strategies is to focus on:",
                                options: [
                                    "What investments are being made",
                                    "Why the investments are being made",
                                    "How much money is being invested",
                                    "When the investments are made"
                                ],
                                correctAnswerIndex: 1,
                                explanation: "\"The best way to understand one's own investment strategies, or another's, is to not look at what they are doing but why they are doing it.\"",
                                difficulty: .beginner,
                                relatedConcepts: ["Behavioral Economics"]
                            ),
                            QuizQuestion(
                                id: "q2_7",
                                question: "Research shows that women investors compared to men tend to:",
                                options: [
                                    "Trade more frequently with higher returns",
                                    "Trade less frequently with often better returns",
                                    "Have identical trading patterns",
                                    "Avoid the stock market entirely"
                                ],
                                correctAnswerIndex: 1,
                                explanation: "Studies show women trade less frequently and focus more on long-term value, which often leads to better risk-adjusted returns.",
                                difficulty: .intermediate,
                                relatedConcepts: ["Gender Lens Investing"]
                            ),
                            QuizQuestion(
                                id: "q2_8",
                                question: "What is 'competitive plasticity' in the context of behavioral change?",
                                options: [
                                    "The brain's inability to change old habits",
                                    "The challenge of replacing well-established neural networks",
                                    "A type of investment strategy",
                                    "Competition between different brain regions"
                                ],
                                correctAnswerIndex: 1,
                                explanation: "Competitive plasticity explains why simply 'adding' positive habits often fails—we must replace old neural patterns entirely.",
                                difficulty: .advanced,
                                relatedConcepts: ["Neuroplasticity"]
                            )
                        ],
                        passingScore: 0.7
                    )
                ],
                caseStudies: [
                    CaseStudy(
                        id: "case_2_1",
                        title: "The Dot-Com Bubble Anchor",
                        scenario: "During the 2000 dot-com bubble, many investors anchored to peak stock prices. Investors who bought shares at $100 during the IPO boom held losing positions as prices fell to $20, waiting years to 'break even' at their anchor point rather than reassessing the company's actual value.",
                        context: "Real historical example from academically-vetted research on behavioral finance",
                        keyQuestions: [
                            "What cognitive bias is demonstrated in this scenario?",
                            "How might anchoring to the initial price affect rational decision-making?",
                            "What alternative approach could investors have taken?"
                        ],
                        learningFocus: ["Anchoring Bias", "Pattern Recognition", "Decision Analysis"],
                        relatedSection: "sec_2_2",
                        source: "From: Behavioral Economics Module"
                    ),
                    CaseStudy(
                        id: "case_2_2",
                        title: "The Winner-Loser Paradox",
                        scenario: "Research shows investors often sell winning positions too early to 'lock in gains' while holding losing positions too long to avoid 'realizing losses.' An investor sells a stock up 20% but holds another down 30%, hoping it will recover.",
                        context: "Educational example based on behavioral economics research",
                        keyQuestions: [
                            "How does loss aversion influence these investment decisions?",
                            "What would a more rational approach look like?",
                            "How can awareness of this bias improve decision-making?"
                        ],
                        learningFocus: ["Loss Aversion", "Behavioral Patterns", "Critical Thinking"],
                        relatedSection: "sec_2_6",
                        source: "From: Loss Aversion section"
                    ),
                    CaseStudy(
                        id: "case_2_3",
                        title: "The Overconfident Trader",
                        scenario: "A retail investor with a 5-trade winning streak decides to increase their position sizes by 50% and trade more frequently. Over the next year, their returns drop below market average despite their 'proven track record.'",
                        context: "Based on Barber and Odean's research on overconfidence",
                        keyQuestions: [
                            "What role did overconfidence play in this outcome?",
                            "How might recency bias have contributed?",
                            "What position sizing rules could have helped?"
                        ],
                        learningFocus: ["Overconfidence Bias", "Recency Bias", "Risk Management"],
                        relatedSection: "sec_2_4",
                        source: "From: Overconfidence Bias section"
                    )
                ],
                estimatedTime: 45,
                tags: ["Behavioral Economics", "Psychology", "Decision Making", "Neuroeconomics"]
            )
        ]
    }
    
    // MARK: - Sample Glossary Terms
    static func loadSampleGlossaryTerms() -> [GlossaryTerm] {
        [
            GlossaryTerm(
                id: "term_1",
                term: "Anchoring Bias",
                definition: "A cognitive bias where an individual relies too heavily on an initial piece of information (the anchor) when making decisions.",
                simpleExplanation: "When the first number or fact you see influences your judgment, even if it's not relevant.",
                examples: [
                    "Seeing a $100 price tag makes a $50 item seem like a great deal, even if it's only worth $30",
                    "A high starting salary in negotiations can anchor the final agreed amount upward",
                    "An IPO price becomes a mental reference point for judging the stock's value"
                ],
                relatedTerms: ["term_2", "term_3"],
                usedInModules: ["mod_2"],
                usedInSections: ["sec_2_1"],
                category: .behavioral,
                userNotes: nil
            ),
            GlossaryTerm(
                id: "term_2",
                term: "Alternative Assets",
                definition: "Investment categories outside of traditional stocks, bonds, and cash, including real estate, private equity, hedge funds, commodities, and collectibles.",
                simpleExplanation: "Investments that aren't regular stocks or bonds, like art, real estate, or cryptocurrency.",
                examples: [
                    "Fine art and collectibles",
                    "Private equity investments",
                    "Cryptocurrency and digital assets",
                    "Real estate investment trusts (REITs)"
                ],
                relatedTerms: ["term_4", "term_5"],
                usedInModules: ["mod_1"],
                usedInSections: ["sec_1_1", "sec_1_2"],
                category: .altAssets,
                userNotes: nil
            ),
            GlossaryTerm(
                id: "term_3",
                term: "Confirmation Bias",
                definition: "The tendency to search for, interpret, favor, and recall information in a way that confirms one's preexisting beliefs or hypotheses.",
                simpleExplanation: "We tend to notice and remember information that agrees with what we already believe.",
                examples: [
                    "Only reading news sources that align with your views",
                    "Remembering times your intuition was right but forgetting when it was wrong",
                    "Seeking out analysts who agree with your investment thesis"
                ],
                relatedTerms: ["term_1"],
                usedInModules: ["mod_2"],
                usedInSections: ["sec_2_1"],
                category: .behavioral,
                userNotes: nil
            ),
            GlossaryTerm(
                id: "term_4",
                term: "Diversification",
                definition: "A risk management strategy that mixes a wide variety of investments within a portfolio to reduce exposure to any single asset or risk.",
                simpleExplanation: "Don't put all your eggs in one basket - spread your investments across different types to reduce risk.",
                examples: [
                    "Owning stocks from different industries and countries",
                    "Combining stocks, bonds, and alternative assets",
                    "Investing in both growth and value stocks"
                ],
                relatedTerms: ["term_2", "term_5"],
                usedInModules: ["mod_1"],
                usedInSections: ["sec_1_1", "sec_1_2"],
                category: .investing,
                userNotes: nil
            ),
            GlossaryTerm(
                id: "term_5",
                term: "Liquidity Risk",
                definition: "The risk that an investor will not be able to quickly convert an investment into cash without significant loss of value.",
                simpleExplanation: "The chance you won't be able to sell an investment quickly when you need the money.",
                examples: [
                    "Real estate that takes months to sell",
                    "Private equity with 7-10 year lock-up periods",
                    "Art that requires finding the right buyer",
                    "Illiquid small-cap stocks with low trading volume"
                ],
                relatedTerms: ["term_2"],
                usedInModules: ["mod_1"],
                usedInSections: ["sec_1_3"],
                category: .risk,
                userNotes: nil
            ),
            GlossaryTerm(
                id: "term_6",
                term: "Loss Aversion",
                definition: "The psychological principle that losses hurt approximately twice as much as gains feel good, leading to asymmetric decision-making.",
                simpleExplanation: "Losing $100 feels worse than gaining $100 feels good, affecting how we make decisions.",
                examples: [
                    "Holding losing stocks too long to avoid realizing the loss",
                    "Selling winning stocks too early to lock in gains",
                    "Being more cautious after experiencing losses"
                ],
                relatedTerms: ["term_1", "term_3"],
                usedInModules: ["mod_2"],
                usedInSections: ["sec_2_2"],
                category: .behavioral,
                userNotes: nil
            )
        ]
    }
}
