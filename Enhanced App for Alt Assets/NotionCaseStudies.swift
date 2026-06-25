 //
//  NotionCaseStudies.swift
//  Enhanced App for Alt Assets
//
//  Created by Victoria Case on 2/6/26.
//  Copyright 2026 Victoria Case. All rights reserved.
//
//  Description: Case studies for each module to illustrate concepts
//  through real-world scenarios and examples.
//

import Foundation

/// Case studies organized by module
struct NotionCaseStudies {

    // MARK: - Alternative Investing Case Studies
    static let altInvestingCaseStudies: [CaseStudy] = [
        CaseStudy(
            id: "case_alt_1",
            title: "The Yale Endowment Model",
            scenario: "In the 1980s, David Swensen transformed Yale's endowment by dramatically increasing allocations to alternative assets including private equity, real estate, and absolute return strategies. The endowment grew from $1 billion to over $30 billion.",
            context: "This approach, known as the 'Yale Model,' demonstrated how alternatives could enhance returns for long-term investors willing to accept illiquidity.",
            keyQuestions: [
                "Why might illiquidity be acceptable for a university endowment but not for an individual investor?",
                "How did diversification into alternatives help during market downturns?",
                "What resources enabled Yale to successfully invest in alternatives that individual investors might lack?"
            ],
            learningFocus: ["Illiquidity Premium", "Long-term Investing", "Institutional vs. Retail"],
            relatedSection: "sec_mod_alt_1",
            source: "Alternative Investing Module"
        ),
        CaseStudy(
            id: "case_alt_2",
            title: "WeWork's Valuation Collapse",
            scenario: "WeWork was valued at $47 billion before its planned 2019 IPO. After investor scrutiny of its business model and governance, the IPO was pulled and the company was eventually valued at $8 billion.",
            context: "This case illustrates how private market valuations can become disconnected from reality, and the importance of due diligence in private equity and venture capital.",
            keyQuestions: [
                "What red flags might have indicated WeWork's overvaluation?",
                "How do private market valuations differ from public market price discovery?",
                "What role did investor enthusiasm play in sustaining the high valuation?"
            ],
            learningFocus: ["Due Diligence", "Private Market Valuation", "Risk Assessment"],
            relatedSection: "sec_mod_alt_2",
            source: "Alternative Investing Module"
        )
    ]

    // MARK: - Behavioral Economics Case Studies
    static let behavioralCaseStudies: [CaseStudy] = [
        CaseStudy(
            id: "case_behav_1",
            title: "The Dot-Com Bubble",
            scenario: "From 1995-2000, investors poured money into internet companies regardless of fundamentals. The NASDAQ rose 400% before crashing 78% from its peak. Many investors who bought near the top lost their savings.",
            context: "This period exemplifies multiple cognitive biases working together: herd behavior, FOMO, overconfidence, and the belief that 'this time is different.'",
            keyQuestions: [
                "Which cognitive biases can you identify in the dot-com bubble?",
                "How might an awareness of behavioral economics have helped investors avoid losses?",
                "Why do market bubbles continue to occur despite historical precedent?"
            ],
            learningFocus: ["Herd Behavior", "FOMO", "Overconfidence Bias"],
            relatedSection: "sec_mod_behavioral_1",
            source: "Behavioral Economics Module"
        ),
        CaseStudy(
            id: "case_behav_2",
            title: "Loss Aversion in Action",
            scenario: "A study found that taxi drivers in New York work fewer hours on high-demand days (when they could earn more) and more hours on slow days. They had a mental daily income target and stopped working once they reached it.",
            context: "This counterintuitive behavior demonstrates loss aversion: drivers treated falling short of their target as a 'loss' that motivated more work, while exceeding it felt like a 'gain' worth protecting.",
            keyQuestions: [
                "How does this example show loss aversion affecting economic behavior?",
                "What would a purely rational actor do differently?",
                "Can you identify similar patterns in your own investment decisions?"
            ],
            learningFocus: ["Loss Aversion", "Mental Accounting", "Rational vs. Actual Behavior"],
            relatedSection: "sec_mod_behavioral_2",
            source: "Behavioral Economics Module"
        ),
        CaseStudy(
            id: "case_behav_3",
            title: "The Anchoring Effect in Real Estate",
            scenario: "Research shows that homes with higher listing prices sell for more, even when controlling for actual home value. Buyers anchor on the listing price and negotiate from there, even when they know the price is inflated.",
            context: "This demonstrates how anchoring influences financial decisions even when people are aware of the bias.",
            keyQuestions: [
                "How might anchoring affect your evaluation of investment opportunities?",
                "What strategies could help counteract anchoring bias?",
                "How do marketers and salespeople exploit anchoring?"
            ],
            learningFocus: ["Anchoring Bias", "Decision Making", "Price Psychology"],
            relatedSection: "sec_mod_behavioral_3",
            source: "Behavioral Economics Module"
        )
    ]

    // MARK: - Gender and Behavioral Economics Case Studies
    static let genderCaseStudies: [CaseStudy] = [
        CaseStudy(
            id: "case_gender_1",
            title: "The Trading Frequency Study",
            scenario: "A study of 35,000 households found that men traded 45% more than women. This excess trading reduced men's net returns by 2.65 percentage points per year, compared to 1.72 points for women.",
            context: "Overconfidence leads to more trading, which incurs costs (fees, taxes, poor timing). Women's tendency to trade less resulted in better net returns.",
            keyQuestions: [
                "Why might overconfidence lead to more frequent trading?",
                "How do transaction costs compound over time?",
                "What does this suggest about the relationship between activity and investment success?"
            ],
            learningFocus: ["Overconfidence Bias", "Trading Frequency", "Net Returns"],
            relatedSection: "sec_mod_gender_1",
            source: "Gender & Behavioral Economics Module"
        ),
        CaseStudy(
            id: "case_gender_2",
            title: "Risk Perception Differences",
            scenario: "When presented with identical investment scenarios, women consistently rated the risk higher than men. However, when asked about specific potential losses (dollar amounts), the gap narrowed significantly.",
            context: "This suggests that perceived gender differences in risk tolerance may partly reflect differences in how risk is communicated, not just innate preferences.",
            keyQuestions: [
                "How might financial advisors inadvertently reinforce gender stereotypes?",
                "What role does financial education play in risk perception?",
                "How could framing investment risks differently create more equitable outcomes?"
            ],
            learningFocus: ["Risk Perception", "Communication", "Framing Effects"],
            relatedSection: "sec_mod_gender_2",
            source: "Gender & Behavioral Economics Module"
        )
    ]

    // MARK: - Women and Investing Case Studies
    static let womenCaseStudies: [CaseStudy] = [
        CaseStudy(
            id: "case_women_1",
            title: "The Longevity Gap",
            scenario: "Sarah, 65, and her husband Michael, 67, planned retirement together assuming they would both live to 85. Michael passed at 78, and Sarah lived to 92. She spent her final years facing financial insecurity.",
            context: "Women live on average 5-7 years longer than men but often have less saved for retirement due to wage gaps and career breaks. This creates a longevity risk disproportionately affecting women.",
            keyQuestions: [
                "How should longevity differences affect retirement planning for women?",
                "What investment strategies might help address the longevity gap?",
                "How do career breaks for caregiving compound over a lifetime?"
            ],
            learningFocus: ["Longevity Risk", "Retirement Planning", "Compound Effects"],
            relatedSection: "sec_mod_women_1",
            source: "Women & Investing Module"
        ),
        CaseStudy(
            id: "case_women_2",
            title: "The Confidence Gap",
            scenario: "A survey found that only 9% of women thought they would make better investors than men, even though research shows women often outperform. This confidence gap leads many women to delegate financial decisions or not invest at all.",
            context: "The gap between actual performance and perceived competence illustrates how cultural factors affect financial behavior.",
            keyQuestions: [
                "What factors contribute to lower financial confidence among women?",
                "How might increased financial education affect this confidence gap?",
                "What role do role models and representation play?"
            ],
            learningFocus: ["Confidence Gap", "Self-Efficacy", "Financial Empowerment"],
            relatedSection: "sec_mod_women_2",
            source: "Women & Investing Module"
        )
    ]

    // MARK: - DeFi Case Studies
    static let defiCaseStudies: [CaseStudy] = [
        CaseStudy(
            id: "case_defi_1",
            title: "The DAO Hack of 2016",
            scenario: "The DAO, an early decentralized investment fund on Ethereum, raised $150 million. A flaw in its smart contract code allowed an attacker to drain $60 million. This led to a controversial 'hard fork' of Ethereum to reverse the theft.",
            context: "This case illustrates both the potential and risks of DeFi: code vulnerabilities can have massive consequences, and 'decentralized' systems may still require human intervention in emergencies.",
            keyQuestions: [
                "What does 'code is law' mean in DeFi, and what are its limitations?",
                "How did the community response to the hack challenge decentralization principles?",
                "What lessons should DeFi investors take from this incident?"
            ],
            learningFocus: ["Smart Contract Risk", "Decentralization Trade-offs", "Code Auditing"],
            relatedSection: "sec_mod_defi_1",
            source: "DeFi Module"
        ),
        CaseStudy(
            id: "case_defi_2",
            title: "NFT Royalties: Promise vs. Reality",
            scenario: "Artist Sarah sold an NFT for $1,000 with a 10% royalty programmed into the smart contract. Over two years, the piece was resold multiple times reaching $50,000. However, when platforms stopped enforcing royalties, Sarah received nothing from later sales.",
            context: "This illustrates how NFT royalties depend on platform enforcement, not just smart contract code, challenging assumptions about creator economics in Web3.",
            keyQuestions: [
                "Why can't smart contracts fully guarantee royalty payments?",
                "How does this affect the value proposition of NFTs for artists?",
                "What solutions are being developed to address royalty enforcement?"
            ],
            learningFocus: ["NFT Economics", "Platform Dependencies", "Creator Rights"],
            relatedSection: "sec_mod_defi_2",
            source: "DeFi Module"
        ),
        CaseStudy(
            id: "case_defi_3",
            title: "Terra/LUNA Collapse",
            scenario: "In May 2022, the Terra ecosystem collapsed when its algorithmic stablecoin UST lost its peg. LUNA, worth $80 at its peak, fell to fractions of a cent. Investors lost approximately $40 billion in days.",
            context: "The collapse demonstrated systemic risks in DeFi, how algorithmic mechanisms can fail catastrophically, and the importance of understanding what backs stablecoins.",
            keyQuestions: [
                "What made the Terra/UST mechanism vulnerable to collapse?",
                "How did social factors (panic, herd behavior) accelerate the crash?",
                "What due diligence might have revealed the risks?"
            ],
            learningFocus: ["Stablecoin Mechanisms", "Systemic Risk", "Due Diligence"],
            relatedSection: "sec_mod_defi_3",
            source: "DeFi Module"
        )
    ]

    // MARK: - Art as Investment Case Studies
    static let artCaseStudies: [CaseStudy] = [
        CaseStudy(
            id: "case_art_1",
            title: "Beeple's $69 Million Sale",
            scenario: "In March 2021, digital artist Beeple sold 'Everydays: The First 5000 Days' as an NFT at Christie's for $69 million, making him the third most valuable living artist. The buyer received a digital file and NFT, not a physical artwork.",
            context: "This sale legitimized NFTs in the traditional art world and challenged assumptions about what constitutes valuable art.",
            keyQuestions: [
                "What factors contributed to this unprecedented price for digital art?",
                "How might this sale change the relationship between physical and digital art?",
                "What risks does the buyer face that traditional art collectors don't?"
            ],
            learningFocus: ["Digital Art Value", "NFT Market", "Paradigm Shifts"],
            relatedSection: "sec_mod_art_1",
            source: "Art as Investment Module"
        ),
        CaseStudy(
            id: "case_art_2",
            title: "The Salvator Mundi Mystery",
            scenario: "A painting attributed to Leonardo da Vinci was bought for $1,175 in 2005, restored, and sold for $450 million in 2017 - the highest price ever for an artwork. Its authenticity remains disputed, and it hasn't been publicly displayed since.",
            context: "This case illustrates how authentication uncertainty, provenance, and scarcity drive art market dynamics.",
            keyQuestions: [
                "How does authentication uncertainty affect art valuation?",
                "What role did the Leonardo attribution play in the price?",
                "What are the risks of investing in works with disputed authenticity?"
            ],
            learningFocus: ["Authentication", "Provenance", "Trophy Asset Premium"],
            relatedSection: "sec_mod_art_2",
            source: "Art as Investment Module"
        ),
        CaseStudy(
            id: "case_art_3",
            title: "Banksy's Shredded Artwork",
            scenario: "In 2018, Banksy's 'Girl with Balloon' self-destructed moments after selling at Sotheby's for $1.4 million. Rather than decreasing in value, the partially shredded work, renamed 'Love is in the Bin,' sold in 2021 for $25.4 million.",
            context: "The artwork's destruction became part of its story, dramatically increasing its cultural significance and market value.",
            keyQuestions: [
                "Why did destruction increase rather than decrease the work's value?",
                "What does this say about the relationship between art, narrative, and value?",
                "How does this challenge traditional notions of art preservation?"
            ],
            learningFocus: ["Narrative Value", "Cultural Significance", "Market Psychology"],
            relatedSection: "sec_mod_art_3",
            source: "Art as Investment Module"
        )
    ]

    // MARK: - Kahlo x Basquiat Case Studies
    static let kahloBasquiatCaseStudies: [CaseStudy] = [
        CaseStudy(
            id: "case_kahlo_1",
            title: "Basquiat's Record-Breaking Sales",
            scenario: "Jean-Michel Basquiat's 'Untitled' (1982) sold for $110.5 million in 2017, making it the sixth most expensive artwork ever sold. Basquiat died at 27 with works selling for a few thousand dollars; now they routinely sell for tens of millions.",
            context: "The meteoric rise in Basquiat's prices reflects both his artistic significance and the market's recognition of his cultural impact as a Black artist addressing race, identity, and power.",
            keyQuestions: [
                "What factors drive posthumous appreciation of an artist's work?",
                "How does cultural relevance affect long-term art value?",
                "What role did Basquiat's early death play in his market value?"
            ],
            learningFocus: ["Posthumous Value", "Cultural Capital", "Market Timing"],
            relatedSection: "sec_kahlo_1",
            source: "Kahlo x Basquiat Module"
        ),
        CaseStudy(
            id: "case_kahlo_2",
            title: "Frida Kahlo's Market Renaissance",
            scenario: "For decades, Frida Kahlo was primarily known as Diego Rivera's wife. Since the 1990s, her work has appreciated dramatically, with 'Diego y Yo' selling for $34.9 million in 2021 - a record for Latin American art.",
            context: "Kahlo's market rise coincides with broader recognition of women artists and Latinx culture, showing how social movements affect art markets.",
            keyQuestions: [
                "How do changing social values affect art valuations?",
                "What role did feminism play in Kahlo's market recognition?",
                "How might other undervalued artist categories appreciate similarly?"
            ],
            learningFocus: ["Market Corrections", "Social Movements", "Undervalued Assets"],
            relatedSection: "sec_kahlo_2",
            source: "Kahlo x Basquiat Module"
        )
    ]

    // MARK: - Helper to get case studies by module ID
    static func caseStudies(for moduleId: String) -> [CaseStudy] {
        switch moduleId {
        case "mod_alt":
            return altInvestingCaseStudies
        case "mod_behavioral":
            return behavioralCaseStudies
        case "mod_gender":
            return genderCaseStudies
        case "mod_women":
            return womenCaseStudies
        case "mod_defi":
            return defiCaseStudies
        case "mod_art":
            return artCaseStudies
        case "mod_kahlo":
            return kahloBasquiatCaseStudies
        default:
            return []
        }
    }

    // MARK: - All Case Studies
    static var allCaseStudies: [CaseStudy] {
        altInvestingCaseStudies + behavioralCaseStudies + genderCaseStudies + womenCaseStudies + defiCaseStudies + artCaseStudies + kahloBasquiatCaseStudies
    }
}
