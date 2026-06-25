//
//  NotionReflectionPrompts.swift
//  Enhanced App for Alt Assets
//
//  Created by Victoria Case on 2/6/26.
//  Copyright 2026 Victoria Case. All rights reserved.
//
//  Description: Reflection prompts for each module to encourage deeper learning
//  and personal connection to the material.
//

import Foundation

/// Reflection prompts organized by module
struct NotionReflectionPrompts {

    // MARK: - Alternative Investing Module Prompts
    static let altInvestingPrompts: [ReflectionPrompt] = [
        ReflectionPrompt(
            id: "reflect_alt_1",
            question: "How might adding alternative assets to your portfolio change your relationship with market volatility?",
            context: "Consider how traditional stocks and bonds react to market downturns versus alternatives like real estate or commodities.",
            relatedSections: ["sec_mod_alt_1"]
        ),
        ReflectionPrompt(
            id: "reflect_alt_2",
            question: "What alternative asset class resonates most with your personal values or interests, and why?",
            context: "Think about whether you're drawn to tangible assets like real estate, mission-driven impact investing, or technology-forward options like crypto.",
            relatedSections: ["sec_mod_alt_2"]
        ),
        ReflectionPrompt(
            id: "reflect_alt_3",
            question: "How comfortable are you with illiquidity, and how might this affect your alternative investment choices?",
            context: "Many alternatives cannot be sold quickly. Reflect on your time horizon and need for accessible funds.",
            relatedSections: ["sec_mod_alt_1", "sec_mod_alt_2"]
        ),
        ReflectionPrompt(
            id: "reflect_alt_4",
            question: "What role do you see ESG (Environmental, Social, Governance) factors playing in your investment decisions?",
            context: "Consider how your investments might align with your values around sustainability and social responsibility.",
            relatedSections: ["sec_mod_alt_2"]
        ),
        ReflectionPrompt(
            id: "reflect_alt_5",
            question: "If you could invest in any real asset (art, real estate, farmland, etc.), what would it be and what does that choice reveal about you?",
            context: "Your attraction to certain assets often reflects deeper values, interests, or life experiences.",
            relatedSections: ["sec_mod_alt_2", "sec_mod_alt_3"]
        ),
        ReflectionPrompt(
            id: "reflect_alt_6",
            question: "Have you ever experienced a time when your savings or investments moved in lockstep with a market crash — falling all at once? What would low-correlation assets have meant to you in that moment?",
            context: "Lived experience with market volatility often motivates interest in diversification more than any data.",
            relatedSections: ["sec_mod_alt_1"]
        ),
        ReflectionPrompt(
            id: "reflect_alt_7",
            question: "Of the major alternative asset categories — real assets, private capital, collectibles, and digital assets — which resonates most with you personally right now, and why?",
            context: "Personal interest in an asset class is a legitimate starting point for research. The best investments are often ones you understand because you care about them.",
            relatedSections: ["sec_mod_alt_2", "sec_mod_alt_3"]
        )
    ]

    // MARK: - Behavioral Economics Module Prompts
    static let behavioralPrompts: [ReflectionPrompt] = [
        ReflectionPrompt(
            id: "reflect_behav_1",
            question: "Recall a financial decision you made emotionally rather than rationally. What cognitive bias might have influenced you?",
            context: "Common biases include loss aversion, confirmation bias, and herd mentality. Which resonates with your experience?",
            relatedSections: ["sec_mod_behavioral_1"]
        ),
        ReflectionPrompt(
            id: "reflect_behav_2",
            question: "How does your upbringing or family history with money influence your current investment behavior?",
            context: "Our early experiences with money create lasting mental models that affect how we perceive risk and reward.",
            relatedSections: ["sec_mod_behavioral_2"]
        ),
        ReflectionPrompt(
            id: "reflect_behav_3",
            question: "When have you experienced FOMO (Fear of Missing Out) in investing, and how did it affect your decision?",
            context: "FOMO often leads to buying at market peaks or chasing trends without proper analysis.",
            relatedSections: ["sec_mod_behavioral_3"]
        ),
        ReflectionPrompt(
            id: "reflect_behav_4",
            question: "What anchors (reference points) do you unconsciously use when evaluating investment opportunities?",
            context: "Anchoring bias means we rely heavily on the first piece of information we receive, like an initial price or estimate.",
            relatedSections: ["sec_mod_behavioral_4"]
        ),
        ReflectionPrompt(
            id: "reflect_behav_5",
            question: "How do you typically react to investment losses versus gains? Does this align with rational decision-making?",
            context: "Loss aversion suggests we feel losses about twice as strongly as equivalent gains.",
            relatedSections: ["sec_mod_behavioral_5"]
        ),
        ReflectionPrompt(
            id: "reflect_behav_6",
            question: "What strategies could you implement to counteract your most common cognitive biases?",
            context: "Awareness is the first step. Consider checklists, cooling-off periods, or seeking contrary opinions.",
            relatedSections: ["sec_mod_behavioral_6"]
        )
    ]

    // MARK: - Gender and Behavioral Economics Module Prompts
    static let genderPrompts: [ReflectionPrompt] = [
        ReflectionPrompt(
            id: "reflect_gender_1",
            question: "How might societal expectations around gender have shaped your approach to investing?",
            context: "Consider messages you received growing up about who should handle finances and how.",
            relatedSections: ["sec_mod_gender_1"]
        ),
        ReflectionPrompt(
            id: "reflect_gender_2",
            question: "Research suggests women trade less frequently and often outperform men long-term. How do you interpret this finding?",
            context: "Consider the roles of patience, overconfidence, and risk assessment in investment success.",
            relatedSections: ["sec_mod_gender_2"]
        ),
        ReflectionPrompt(
            id: "reflect_gender_3",
            question: "What barriers have you observed or experienced that discourage certain groups from investing?",
            context: "Barriers can be systemic, cultural, psychological, or informational.",
            relatedSections: ["sec_mod_gender_3"]
        ),
        ReflectionPrompt(
            id: "reflect_gender_4",
            question: "How might increasing financial literacy across all genders and demographics benefit society?",
            context: "Consider economic empowerment, wealth distribution, and generational wealth building.",
            relatedSections: ["sec_mod_gender_4"]
        ),
        ReflectionPrompt(
            id: "reflect_gender_5",
            question: "Have you noticed how the perceived value of a profession changes as its gender composition shifts? How might this pattern affect your own career earnings and investable capital?",
            context: "Consider fields you have worked in or considered. Think about whether the prestige or compensation of those roles has shifted as more women entered them, and how that might shape your long-term wealth trajectory.",
            relatedSections: ["sec_mod_gender_3b"]
        )
    ]

    // MARK: - Women and Investing Module Prompts
    static let womenPrompts: [ReflectionPrompt] = [
        ReflectionPrompt(
            id: "reflect_women_1",
            question: "What unique financial challenges do women face, and how might investing address them?",
            context: "Consider the wage gap, career breaks, longer lifespans, and the pink tax.",
            relatedSections: ["sec_mod_women_1"]
        ),
        ReflectionPrompt(
            id: "reflect_women_2",
            question: "Who were your financial role models growing up? How did their gender influence what you learned?",
            context: "Representation matters in developing financial confidence and knowledge.",
            relatedSections: ["sec_mod_women_2"]
        ),
        ReflectionPrompt(
            id: "reflect_women_3",
            question: "How might you contribute to closing the gender investment gap, whether for yourself or others?",
            context: "Consider education, mentorship, advocacy, or leading by example.",
            relatedSections: ["sec_mod_women_3"]
        ),
        ReflectionPrompt(
            id: "reflect_women_4",
            question: "What would financial empowerment look like in your life, and what steps could move you toward it?",
            context: "Financial empowerment is personal - it might mean independence, security, generosity, or freedom.",
            relatedSections: ["sec_mod_women_4"]
        ),
        ReflectionPrompt(
            id: "reflect_women_5",
            question: "Apply the three risk tolerance questions to yourself honestly: When might you need this money? Can you afford to have it locked up? How well do you understand the assets that interest you?",
            context: "Self-knowledge is one of the most underrated investment skills. Understanding your own constraints before you invest saves more than any market analysis.",
            relatedSections: ["sec_mod_women_4"]
        ),
        ReflectionPrompt(
            id: "reflect_women_6",
            question: "Think about how you currently handle money. Is the majority of it saving or investing? What would it mean for your financial future if that balance shifted?",
            context: "There's no right answer — this is about understanding your current relationship with money.",
            relatedSections: ["sec_mod_women_1"]
        ),
        ReflectionPrompt(
            id: "reflect_women_7",
            question: "Which of the four caveats about alternatives — liquidity lock-up, complexity of valuation, regulatory landscape, or readiness prerequisites — feels most relevant to your situation right now, and why?",
            context: "Understanding which constraint is most relevant to you personally is a practical first step before pursuing any specific alternative investment.",
            relatedSections: ["sec_mod_women_7"]
        ),
        ReflectionPrompt(
            id: "reflect_women_8",
            question: "Think about the difference between an asset and a liability in your own life. What do you currently own that you consider an asset? Is there anything you thought was an asset that might actually be a liability?",
            context: "Context changes everything — the same object can be either depending on whether it generates or drains resources. This is worth examining honestly.",
            relatedSections: ["sec_mod_women_1"]
        ),
        ReflectionPrompt(
            id: "reflect_women_9",
            question: "What are the first words or emotions that arise when you read about women's legal and economic history?",
            context: "Notice whether your reaction is anger, grief, resignation, determination, or something else. That emotional response is data — it tells you where your energy is and what you care most about changing.",
            relatedSections: ["sec_mod_women_5"]
        ),
        ReflectionPrompt(
            id: "reflect_women_10",
            question: "How has society changed since the legal milestones you read about? Where do you see progress, and where do gaps remain?",
            context: "Consider your own experience in the workforce, in banking, or in conversations about money. The gap between legislation and lived reality is often significant.",
            relatedSections: ["sec_mod_women_5"]
        ),
        ReflectionPrompt(
            id: "reflect_women_11",
            question: "Do you currently feel economically empowered? How does that make you feel?",
            context: "There is no correct answer. Economic empowerment looks different at different life stages and circumstances. This question is about honest self-assessment, not aspiration.",
            relatedSections: ["sec_mod_women_5"]
        )
    ]

    // MARK: - DeFi Module Prompts
    static let defiPrompts: [ReflectionPrompt] = [
        ReflectionPrompt(
            id: "reflect_defi_1",
            question: "What aspects of traditional finance frustrate you, and could decentralized alternatives address them?",
            context: "DeFi aims to solve issues like high fees, slow transfers, limited access, and lack of transparency.",
            relatedSections: ["sec_mod_defi_1"]
        ),
        ReflectionPrompt(
            id: "reflect_defi_2",
            question: "How do you evaluate the risk-reward tradeoff of new technologies like cryptocurrency and NFTs?",
            context: "Consider volatility, regulatory uncertainty, and technological risks versus potential returns and innovation.",
            relatedSections: ["sec_mod_defi_2"]
        ),
        ReflectionPrompt(
            id: "reflect_defi_3",
            question: "What role might blockchain technology play in democratizing access to alternative investments?",
            context: "Think about fractional ownership, global access, and reduced barriers to entry.",
            relatedSections: ["sec_mod_defi_3"]
        ),
        ReflectionPrompt(
            id: "reflect_defi_4",
            question: "How do you balance the promise of decentralization with concerns about security and regulation?",
            context: "Self-custody means full control but also full responsibility. What level of responsibility are you comfortable with?",
            relatedSections: ["sec_mod_defi_4"]
        ),
        ReflectionPrompt(
            id: "reflect_defi_5",
            question: "What would need to change for you to feel comfortable allocating a portion of your portfolio to crypto or DeFi?",
            context: "Consider education, regulation, security improvements, or simply gaining experience.",
            relatedSections: ["sec_mod_defi_5"]
        )
    ]

    // MARK: - Art as Investment Module Prompts
    static let artPrompts: [ReflectionPrompt] = [
        ReflectionPrompt(
            id: "reflect_art_1",
            question: "What draws you to art - aesthetic appreciation, cultural significance, investment potential, or something else?",
            context: "Understanding your motivation helps clarify whether art belongs in your portfolio and how to approach it.",
            relatedSections: ["sec_mod_art_1"]
        ),
        ReflectionPrompt(
            id: "reflect_art_2",
            question: "How do you feel about owning an asset whose value is largely subjective and determined by cultural consensus?",
            context: "Art valuation differs fundamentally from traditional financial analysis.",
            relatedSections: ["sec_mod_art_2"]
        ),
        ReflectionPrompt(
            id: "reflect_art_3",
            question: "What emotional premium would you pay for an artwork you love versus one that is purely an investment?",
            context: "The intersection of passion and profit creates unique dynamics in art investing.",
            relatedSections: ["sec_mod_art_3"]
        ),
        ReflectionPrompt(
            id: "reflect_art_4",
            question: "How might NFTs change your perception of art ownership and what constitutes a valuable artwork?",
            context: "Digital art and blockchain provenance challenge traditional notions of authenticity and scarcity.",
            relatedSections: ["sec_mod_art_4"]
        ),
        ReflectionPrompt(
            id: "reflect_art_5",
            question: "If you could own any artwork in the world, what would it be and why?",
            context: "Your answer reveals what you value - history, beauty, status, innovation, or personal meaning.",
            relatedSections: ["sec_mod_art_5"]
        ),
        ReflectionPrompt(
            id: "reflect_art_6",
            question: "How do provenance and authentication concerns affect your confidence in art as an investment?",
            context: "Trust and verification are fundamental to art markets. Consider how blockchain might address these issues.",
            relatedSections: ["sec_mod_art_6"]
        )
    ]

    // MARK: - Kahlo x Basquiat Module Prompts
    static let kahloBasquiatPrompts: [ReflectionPrompt] = [
        ReflectionPrompt(
            id: "reflect_kahlo_1",
            question: "How do Kahlo and Basquiat use personal pain and identity as subjects for their art? How does this affect the value of their work?",
            context: "Both artists transformed personal struggle into powerful artistic expression.",
            relatedSections: ["sec_kahlo_1"]
        ),
        ReflectionPrompt(
            id: "reflect_kahlo_2",
            question: "What role does an artist's biography play in determining the value of their work?",
            context: "Consider how Kahlo's physical suffering and Basquiat's meteoric rise affect how we perceive their art.",
            relatedSections: ["sec_kahlo_2"]
        ),
        ReflectionPrompt(
            id: "reflect_kahlo_3",
            question: "How do cultural identity and social commentary influence the long-term value of artworks?",
            context: "Both artists addressed themes of identity, race, colonialism, and social structures.",
            relatedSections: ["sec_kahlo_3"]
        ),
        ReflectionPrompt(
            id: "reflect_kahlo_4",
            question: "What parallels do you see between Basquiat's emergence from street art and the rise of NFT artists?",
            context: "Consider how outsider artists gain recognition and market value.",
            relatedSections: ["sec_kahlo_4"]
        ),
        ReflectionPrompt(
            id: "reflect_kahlo_5",
            question: "If you could have a conversation with either Kahlo or Basquiat about art and money, what would you ask?",
            context: "Both artists had complex relationships with the commercial art world.",
            relatedSections: ["sec_kahlo_5"]
        )
    ]

    // MARK: - DeFi Investing Module Prompts
    static let defiInvestingPrompts: [ReflectionPrompt] = [
        ReflectionPrompt(
            id: "reflect_defi_inv_1",
            question: "After learning how DeFi protocols generate revenue — fees, buybacks, governance — does your view of crypto as speculative versus investment-grade shift at all?",
            context: "There is a meaningful difference between buying a token because it might go up and buying it because its underlying protocol has durable cash flows.",
            relatedSections: ["sec_defi_inv_2"]
        ),
        ReflectionPrompt(
            id: "reflect_defi_inv_2",
            question: "The Terra/Luna collapse erased $60 billion in weeks. What does that case study reveal about how you personally evaluate systemic risk in emerging asset classes?",
            context: "Risk that cannot be modeled historically is different from risk that can. How do you make decisions when past data does not exist?",
            relatedSections: ["sec_defi_inv_3"]
        ),
        ReflectionPrompt(
            id: "reflect_defi_inv_3",
            question: "If your financial advisor could not explain TVL, fee switches, or stablecoin backing mechanisms — would that concern you? How much expertise do you expect from the professionals you rely on?",
            context: "The advisor questions framework works in both directions: what you expect from advisors reflects what you expect from yourself.",
            relatedSections: ["sec_defi_inv_4"]
        ),
        ReflectionPrompt(
            id: "reflect_defi_inv_4",
            question: "DeFi taxation can turn nominal token gains into net losses when timing and ordinary income rules apply. Have you accounted for this in how you think about your real returns?",
            context: "What you earn and what you keep are different numbers. Tax clarity is part of investment literacy.",
            relatedSections: ["sec_defi_inv_5"]
        ),
        ReflectionPrompt(
            id: "reflect_defi_inv_5",
            question: "You now have a framework for evaluating DeFi advisors and protocols. What is your honest current position — ready to act, gathering more information, or uncertain about fit?",
            context: "Knowing where you actually stand — not where you think you should stand — is the most useful output of this module.",
            relatedSections: ["sec_defi_inv_6"]
        )
    ]

    // MARK: - Helper to get prompts by module ID
    static func prompts(for moduleId: String) -> [ReflectionPrompt] {
        switch moduleId {
        case "mod_alt":
            return altInvestingPrompts
        case "mod_behavioral":
            return behavioralPrompts
        case "mod_gender":
            return genderPrompts
        case "mod_women":
            return womenPrompts
        case "mod_defi":
            return defiPrompts
        case "mod_defi_investing":
            return defiInvestingPrompts
        case "mod_art":
            return artPrompts
        case "mod_kahlo_basquiat":
            return kahloBasquiatPrompts
        case "mod_esg_climate":
            return ESGReflectionPrompts.all
        default:
            return []
        }
    }

    // MARK: - All Prompts
    static var allPrompts: [ReflectionPrompt] {
        altInvestingPrompts + behavioralPrompts + genderPrompts + womenPrompts + defiPrompts + defiInvestingPrompts + artPrompts + kahloBasquiatPrompts + ESGReflectionPrompts.all
    }
}
