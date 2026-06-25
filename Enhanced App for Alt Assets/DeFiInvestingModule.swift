//
//  DeFiInvestingModule.swift
//  Enhanced App for Alt Assets
//
//  Created by Victoria Case on 2/17/26.
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//
//  Description: Advanced DeFi investing module — "DeFi for Investors: From
//  Speculation to Infrastructure." Sourced from Notion page content.
//  This is a SEPARATE module from the DeFi 101 fundamentals module.
//
//  Sources: BIS (2021), IOSCO (2022), IMF (2023), Bloomberg Intelligence (2024),
//  BlackRock (2024–2025), Galaxy Digital (2025), Chainalysis (2026), CFA Institute,
//  Messari, a16z Crypto, Aave/Uniswap/MakerDAO documentation.
//
//  DISCLAIMER: This is not financial advice. Content is for informational and
//  educational purposes only.
//

import Foundation

// MARK: - DeFi Investing Module Data
struct DeFiInvestingModuleData {

    // MARK: - Main Module
    static let defiInvestingModule = Module(
        id: "mod_defi_investing",
        title: "DeFi Investing",
        
        description: "From Speculation to Infrastructure — a practical guide to protocol-level investing in the modern crypto landscape.",
        icon: "💰",
        color: "blue",
        heroImageName: "hero_defi_investing",
        sections: [

            // ──────────────────────────────────────────────
            // PART 1 — THE CURRENT STATE
            // ──────────────────────────────────────────────

            // MARK: Section 1 — Retail Reality
            Section(
                id: "sec_dinv_1",
                title: "1. The Retail Reality: Speculation vs. Investment_",
                content: [
                    .callout(title: "Disclaimer", content: "This is not financial advice or recommendation for any investment. The content is for informational purposes only; you should not construe any such information as legal, tax, investment, or financial advice.", type: .warning),
                    .text("Despite the increasing sophistication of the decentralized finance ecosystem, the majority of retail participation remains speculative rather than investment-oriented. This distinction is not semantic; it reflects fundamentally different approaches to capital deployment, risk management, and economic analysis."),
                    .text("The typical retail journey into crypto markets follows a familiar pattern. An investor opens an account on a centralized exchange, often drawn by headlines of rapid gains or social media narratives. Tokens are selected based on price momentum, trending lists, or perceived future hype. Purchases are made without detailed understanding of how the underlying protocol generates revenue, whether that revenue is sustainable, or whether token holders have any structural claim on it. [2]"),
                    .text("This pattern treats tokens less as equity-like claims on infrastructure and more as lottery tickets tied to market sentiment. The intellectual framework resembles short-term trading rather than long-term capital allocation."),
                    .heading("📈 1.1 Revenue Concentration in DeFi_", level: 3),
                    .text("Empirical analyses consistently show that a relatively small number of leading protocols generate the majority of ecosystem fees. [3] Yet retail capital often disperses into long-tail tokens with minimal revenue, unclear value capture, and limited competitive positioning. Narrative frequently overrides economic substance."),
                    .heading("🏛️ 1.2 The Governance Token Problem_", level: 3),
                    .text("The historical design of many governance tokens reinforced speculative behavior. Consider Uniswap, one of the most prominent decentralized exchanges. The protocol generated billions in cumulative trading fees while the UNI token initially functioned primarily as a governance instrument. Token holders could vote on proposals but had no automatic entitlement to protocol revenue. [4]"),
                    .text("Economically, this resembled ownership of voting shares in a company that produces substantial cash flow yet distributes none of it — while also providing no legal ownership protections. Price appreciation depended on expectations, not on enforceable economic linkage."),
                    .callout(title: "Key Insight", content: "Without clarity about what a token represents economically, capital allocation decisions become dependent on market psychology rather than on measurable production.", type: .info)
                ],
                isCollapsible: true,
                level: 2,
                reflectionPrompts: ["rp_dinv_1"],
                glossaryTerms: ["Governance token", "Total Value Locked", "Protocol revenue"],
                relatedResearch: []
            ),

            // MARK: Section 2 — Institutional Approach
            Section(
                id: "sec_dinv_2",
                title: "2. The Institutional Approach: Infrastructure Analysis_",
                content: [
                    .text("Institutional investors entering decentralized finance during 2025–2026 operate under a markedly different analytical framework. Reports projecting sustained growth in institutional participation reflect a transition toward systematic capital allocation rather than opportunistic speculation. [5] The shift is not merely quantitative but methodological."),
                    .text("Professional allocators begin with market structure. They assess total addressable market size, competitive positioning among protocols, regulatory trajectories, liquidity concentration, and technological resilience. This process mirrors how infrastructure, fintech, or early-stage financial services companies are evaluated in traditional markets."),
                    .heading("💡 2.1 Revenue Quality_", level: 3),
                    .text("Revenue quality becomes central. Institutions ask whether trading volume or lending activity is organic or artificially inflated by token incentive programs. They evaluate whether protocol usage persists after subsidy programs end. They compare revenue growth to token market capitalization, implicitly asking whether valuation aligns with production. [6]"),
                    .callout(title: "Aave as Example", content: "As a lending protocol, Aave generates income through borrower interest payments and liquidation fees. These revenues can be measured annually, compared to token valuation, and assessed for sustainability. A revenue multiple provides at least a preliminary analogue to equity valuation metrics. [7]", type: .info),
                    .heading("🔄 2.2 The Analytical Shift_", level: 3),
                    .text("Instead of asking whether sentiment will push price higher, the question becomes whether the protocol provides durable financial services with defensible competitive positioning. It is a move from chart analysis to business model analysis."),
                    .text("When capital is deployed with infrastructure-level expectations, time horizons extend, volatility is contextualized, and risk assessment becomes structural rather than reactive.")
                ],
                isCollapsible: true,
                level: 2,
                reflectionPrompts: ["rp_dinv_2"],
                glossaryTerms: ["Revenue quality", "Token valuation", "Infrastructure investing"],
                relatedResearch: []
            ),

            // MARK: Section 3 — What Are You Actually Buying?
            Section(
                id: "sec_dinv_3",
                title: "3. What Are You Actually Buying?_",
                content: [
                    .text("At the heart of infrastructure investing lies a simple but frequently overlooked question: What economic exposure does this token actually provide?"),
                    .text("Historically, many governance tokens offered influence without revenue participation. Research suggests that only a small percentage of protocol revenue flowed directly or indirectly to token holders during earlier phases of DeFi's development. [8] In such circumstances, price appreciation depended primarily on expectations of future growth rather than on present cash flow alignment."),
                    .heading("🔧 3.1 Value-Accrual Mechanisms_", level: 3),
                    .text("Over time, governance communities began implementing more explicit value-accrual mechanisms. Fee switches, token burns, and buyback programs emerged as attempts to link protocol success to token-holder benefit."),
                    .text("In the case of Uniswap, governance discussions culminated in supply reductions and fee-linked burn mechanisms designed to create structural alignment between protocol usage and token scarcity. [9] Similarly, Aave introduced buyback initiatives funded through protocol-generated revenue, establishing a clearer feedback loop between production and token demand. [10]"),
                    .heading("⚖️ 3.2 Critical Differences Remain_", level: 3),
                    .text("These developments represent a maturation in token design. They move tokens closer — though not fully — to equity-like instruments in economic structure. Yet critical differences remain. Token holders typically lack formal ownership rights, fiduciary protections, and legal claims enforceable in traditional courts. Governance rights are exercised on-chain, and outcomes depend on decentralized voting participation rather than corporate law."),
                    .callout(title: "Three-Layer Evaluation", content: "Infrastructure-level evaluation must examine three layers simultaneously: the protocol's underlying business model, the token's explicit value capture design, and the competitive moat sustaining revenue generation. If any of these layers are weak or undefined, the investment thesis reverts toward speculation.", type: .info)
                ],
                isCollapsible: true,
                level: 2,
                reflectionPrompts: ["rp_dinv_3"],
                glossaryTerms: ["Fee switch", "Token burns", "Buyback programs", "Value accrual"],
                relatedResearch: []
            ),

            // ──────────────────────────────────────────────
            // PART 2 — BUILDING THE INVESTMENT FRAMEWORK
            // ──────────────────────────────────────────────

            // MARK: Section 4 — The Risk Ladder
            Section(
                id: "sec_dinv_4",
                title: "4. The Risk Ladder: Strategic Entry_",
                content: [
                    .heading("🪜 Tier 1: Regulated Exposure_", level: 3),
                    .text("The approval of spot Bitcoin and Ethereum exchange-traded funds in January 2024 marked a watershed moment for the asset class. Institutional inflows accelerated dramatically — growing from approximately $15 billion pre-approval to roughly $75 billion within the first quarter following approval, representing a near 400% increase in capital allocation velocity. [11]"),
                    .text("Products such as BlackRock's IBIT accumulated more than $50 billion in assets under management in short order, underscoring the degree of pent-up institutional demand for compliant, custody-secure exposure. [12]"),
                    .text("For investors who prioritize regulatory clarity, capital preservation, and operational simplicity, ETFs provide a familiar wrapper. They offer institutional-grade custody, insurance frameworks, brokerage account integration, and streamlined tax reporting. The tradeoffs are equally clear: management fees generally range from 0.20% to 0.50% annually, participation in DeFi-native yield strategies is absent, and governance rights are nonexistent. [13]"),
                    .callout(title: "Stablecoin Yield", content: "Institutional treasury adoption of yield-bearing stablecoin strategies expanded from approximately $9.5 billion to over $20 billion during 2024–2025, with average yields near 5%. Unlike early DeFi yield farming, many of these platforms derive returns from U.S. Treasury bills and other low-risk instruments. [14]", type: .info),
                    .heading("🔐 Tier 2: Controlled Self-Custody_", level: 3),
                    .text("Advancing to the second tier introduces a qualitatively different risk profile. Here, the investor assumes direct responsibility for asset custody and begins interacting with smart contracts. Hardware wallets such as Ledger or Trezor are components within a broader security architecture that includes seed phrase storage, recovery testing, and attack vector awareness. [15]"),
                    .text("Exposure should begin with battle-tested protocols demonstrating longevity, liquidity depth, and revenue durability. Consider Aave, which as of late 2025 maintains over $40 billion in total value locked and borrow utilization rates around 67%. [16]"),
                    .heading("🔬 Tier 3: Active Protocol Investing_", level: 3),
                    .text("The third tier demands institutional-grade due diligence. Institutions applying capital in this category typically require evidence of:"),
                    .bulletList([
                        "Meaningful revenue generation (often exceeding $10 million annually)",
                        "A majority of that revenue derived organically rather than through token subsidies",
                        "A clear growth trajectory relative to market capitalization [17]",
                        "An explicit value accrual mechanism — fee switches, buybacks, or burn programs",
                        "Top-three category rank by total value locked",
                        "Multiple independent security audits",
                        "A multi-year operating history without catastrophic exploits"
                    ]),
                ],
                isCollapsible: true,
                level: 2,
                reflectionPrompts: ["rp_dinv_4"],
                glossaryTerms: ["ETF", "Self-custody", "Hardware wallet", "TVL"],
                relatedResearch: []
            ),

            // MARK: Section 5 — Position Sizing
            Section(
                id: "sec_dinv_5",
                title: "5. Position Sizing: The Mathematics of Risk_",
                content: [
                    .text("No framework is complete without disciplined allocation methodology. Even mature DeFi protocols, managing tens of billions in total value locked, remain exposed to smart contract vulnerabilities, governance failures, oracle manipulation, and unforeseen systemic contagion. In 2025 alone, smart contract exploits resulted in approximately $1.1 billion in losses across the ecosystem. [20]"),
                    .heading("📐 5.1 Conservative Allocation_", level: 3),
                    .text("For investors whose portfolios remain primarily allocated to traditional assets — equities, fixed income, and real estate — crypto exposure should generally reside within an alternatives sleeve:"),
                    .bulletList([
                        "Crypto allocation: 3–5% of total portfolio value",
                        "~60% in Bitcoin or Ethereum ETFs",
                        "~30% in stablecoin yield strategies",
                        "~10% in blue-chip DeFi protocols",
                        "Maximum single-protocol exposure: ~0.5% of total portfolio [18]"
                    ]),
                    .heading("📐 5.2 Growth-Oriented Allocation_", level: 3),
                    .text("For growth-oriented investors with higher technological fluency and risk tolerance, crypto allocations may reasonably expand within a 70–80% traditional asset core:"),
                    .bulletList([
                        "Crypto allocation: 10–20% of total portfolio value",
                        "~40% in BTC/ETH",
                        "~30% in established DeFi blue chips",
                        "~20% in emerging protocols with asymmetric upside potential",
                        "~10% in stablecoins serving as strategic liquidity reserves",
                        "Maximum single-protocol exposure: ~2% of total portfolio [19]"
                    ]),
                    .callout(title: "Diversification Warning", content: "Capital allocated to a single smart contract system must be considered fully at risk. Allocating across multiple Ethereum-based lending protocols does not meaningfully diversify systemic exposure — it concentrates risk within the same technical and economic substrate. True diversification spans protocol categories, blockchain ecosystems, and risk structures.", type: .warning)
                ],
                isCollapsible: true,
                level: 2,
                reflectionPrompts: ["rp_dinv_5"],
                glossaryTerms: ["Position sizing", "Diversification", "Smart contract risk"],
                relatedResearch: []
            ),

            // MARK: Section 6 — Education as Protection
            Section(
                id: "sec_dinv_6",
                title: "6. Education as Investment Protection_",
                content: [
                    .text("Perhaps the most overlooked yet highest-return allocation in DeFi is education itself. Deploying capital before achieving structural understanding transforms investment into speculation by default. In a financial system built atop novel cryptographic primitives and rapidly evolving governance structures, ignorance compounds risk."),
                    .heading("📚 6.1 Foundational Literacy_", level: 3),
                    .text("Investors must understand public and private key cryptography, transaction validation processes, consensus mechanisms, and network security assumptions. Without this knowledge, evaluating claims of decentralization or security becomes impossible. [21] One cannot assess protocol risk without understanding the base layer upon which it operates."),
                    .heading("🔍 6.2 Smart Contract Comprehension_", level: 3),
                    .text("Investors must grasp how smart contracts function, common vulnerability vectors, and the role of independent audits. Critically, audits reduce — but do not eliminate — risk. They are probabilistic safeguards, not guarantees. [22]"),
                    .heading("💰 6.3 Protocol Economics_", level: 3),
                    .text("Durable investment theses require clarity on how a protocol generates revenue, what drives user demand, how value accrues to token holders, and what competitive dynamics threaten sustainability. Incentive-driven liquidity surges are not equivalent to organic revenue growth. Distinguishing between the two is essential for separating transient arbitrage from structural advantage. [23]"),
                    .heading("⏱️ 6.4 Time Investment_", level: 3),
                    .text("Competency develops incrementally. Basic proficiency sufficient to avoid catastrophic errors typically requires 40–60 hours of focused study. Intermediate proficiency — enabling informed protocol selection and structured risk assessment — often demands 100–150 hours. Achieving advanced, institutional-grade analytical capability can require 300 or more hours of dedicated research and practical engagement. [27]"),
                    .callout(title: "Core Principle", content: "In DeFi, knowledge is not optional enrichment; it is capital preservation.", type: .info)
                ],
                isCollapsible: true,
                level: 2,
                reflectionPrompts: ["rp_dinv_6"],
                glossaryTerms: ["Smart contract audit", "Protocol economics", "Due diligence"],
                relatedResearch: []
            ),

            // ──────────────────────────────────────────────
            // PART 3 — PROTOCOL ANALYSIS
            // ──────────────────────────────────────────────

            // MARK: Section 7 — Protocol Deep Dives
            Section(
                id: "sec_dinv_7",
                title: "7. Protocol Analysis: Aave, Uniswap, MakerDAO_",
                content: [
                    .text("Protocol-specific analysis deepens competence beyond general frameworks. Each major protocol category — lending, exchange, stablecoin issuance — has distinct revenue mechanics, risk profiles, and governance structures that require separate evaluation."),

                    .heading("🏦 7.1 Aave: Lending Infrastructure_", level: 3),
                    .text("Understanding Aave requires examining its overcollateralization model, liquidation mechanics, algorithmic interest rate curves, and the function of the \"health factor\" in preventing insolvency cascades. Borrowers on Aave must deposit collateral exceeding the value of their loan. If the collateral value falls below a threshold — the health factor — the protocol automatically liquidates a portion to protect lenders. This mechanism operated through the volatility of 2022–2024 without systemic failure, processing billions in liquidations while maintaining protocol solvency. [24]"),
                    .text("Equally important is understanding how the protocol directs revenue. Aave introduced buyback initiatives funded through protocol-generated interest spreads, creating a feedback loop between usage growth and token demand. As of late 2025, Aave maintains over $40 billion in total value locked, with borrow utilization rates around 67% — suggesting organic demand rather than incentive-driven inflation. [16]"),

                    .heading("🔄 7.2 Uniswap: Decentralized Exchange_", level: 3),
                    .text("Evaluating Uniswap requires studying automated market maker design, impermanent loss dynamics, and the capital efficiency introduced through concentrated liquidity in Version 3. Unlike traditional order books, Uniswap uses algorithmic pools where liquidity providers deposit paired tokens and earn fees from trades executed against the pool. [25]"),
                    .text("The critical distinction for investors: liquidity providers assume different risks than token holders. Providers earn trading fees but face impermanent loss — a reduction in value that occurs when the price ratio of pooled tokens diverges from the ratio at deposit. This risk is not speculative; it is structural and measurable. The activation of Uniswap's fee switch — directing a portion of trading fees to UNI token holders — materially altered the token's value capture profile. [25]"),

                    .heading("🏗️ 7.3 MakerDAO (Sky): Stablecoin Infrastructure_", level: 3),
                    .text("Analyzing MakerDAO demands understanding how DAI maintains its peg through overcollateralization, real-world asset integration, and governance-directed monetary parameters such as the stability fee. Unlike algorithmic stablecoins that failed catastrophically (Terra/LUNA, 2022), Maker's model requires borrowers to lock collateral exceeding the value of DAI minted. [26]"),
                    .text("The introduction of real-world assets (RWAs) into collateral frameworks represents both innovation and regulatory exposure. As of 2025, a meaningful percentage of Maker's collateral derives from tokenized U.S. Treasury bills and other traditional instruments, blurring the boundary between DeFi and traditional finance. The coexistence of legacy (MKR/DAI) and rebranded (SKY/USDS) tokens introduces governance complexity requiring careful review. [26]")
                ],
                isCollapsible: true,
                level: 2,
                reflectionPrompts: ["rp_dinv_7"],
                glossaryTerms: ["Overcollateralization", "Liquidation", "AMM", "Impermanent loss", "Fee switch"],
                relatedResearch: []
            ),

            // MARK: Section 8 — Working with Advisors
            Section(
                id: "sec_dinv_8",
                title: "8. Working with Financial Advisors_",
                content: [
                    .text("The integration of decentralized finance into institutional capital strategies accelerated meaningfully in 2025. Yet this rapid institutional experimentation has not been matched by uniform competency across the financial advisory profession. [28] A structural knowledge gap persists — one that materially affects how clients receive guidance."),
                    .text("This gap should not be interpreted as professional negligence. Rather, it reflects the speed at which innovation in digital assets has outpaced traditional financial education cycles. CFP programs, CFA curricula, and Series 65/66 licensing examinations only began incorporating digital asset material in a meaningful way around 2023–2024. [30]"),
                    .heading("📊 8.1 Advisor Competency Spectrum_", level: 3),
                    .text("Competency exists along a spectrum. Industry surveys suggest the following approximate distribution: [29] [31]"),
                    .numberedList([
                        "Dismissive posture — characterizes cryptocurrency broadly as speculative or gambling (~50% of advisors)",
                        "Cautiously accommodating — offers Bitcoin or Ethereum ETF exposure while avoiding deeper DeFi engagement",
                        "Foundational understanding of Bitcoin and Ethereum beyond price narratives",
                        "Actively analyzes DeFi protocol mechanics and token value accrual",
                        "Consistently monitors governance proposals, protocol upgrades, and competitive tokenomics shifts"
                    ]),
                    .callout(title: "Guidance", content: "If DeFi exposure is under consideration, guidance ideally comes from advisors operating at Level 3 or above — those capable of discussing protocol mechanics and structural risks — or through supplementing a Level 2 advisor with specialized digital asset expertise.", type: .info),
                    .heading("🔍 8.2 Vetting Framework_", level: 3),
                    .text("Rather than relying on vague assurances of familiarity, investors can evaluate advisor competency across five domains: [32] [33] [34] [35]"),
                    .bulletList([
                        "Crypto literacy: Can they articulate the difference between crypto as a settlement layer and DeFi as an application layer?",
                        "Protocol knowledge: Can they distinguish Bitcoin's role as digital store of value from Ethereum's role as programmable smart contract platform?",
                        "Stablecoin understanding: Can they explain fiat-backed, crypto-collateralized, and algorithmic models — and what happened with Terra/LUNA? [35]",
                        "Risk management: Do they have a framework for position sizing and diversification in digital assets?",
                        "Regulatory awareness: Are they current on MiCA, SEC guidance, and evolving compliance landscape?"
                    ]),
                ],
                isCollapsible: true,
                level: 2,
                reflectionPrompts: ["rp_dinv_8"],
                glossaryTerms: ["Financial advisory", "Due diligence", "Regulatory compliance"],
                relatedResearch: []
            )
        ],
        reflectionPrompts: [
            ReflectionPrompt(
                id: "rp_dinv_1",
                question: "Consider your current exposure to cryptocurrency or digital assets. Is your allocation driven by analysis of protocol fundamentals, or by price momentum and social media narratives? What would need to change for you to approach it as infrastructure investing?",
                context: "This reflection helps distinguish between speculative behavior and structured capital allocation in DeFi.",
                relatedSections: ["sec_dinv_1"]
            ),
            ReflectionPrompt(
                id: "rp_dinv_2",
                question: "Think about the last financial product you evaluated. Did you ask how it generates revenue and whether that revenue is sustainable? How would applying that same scrutiny to a DeFi protocol change your analysis?",
                context: "Institutional-grade evaluation requires examining revenue quality, not just price performance.",
                relatedSections: ["sec_dinv_2"]
            ),
            ReflectionPrompt(
                id: "rp_dinv_3",
                question: "For any token you hold or are considering, can you articulate the specific economic rights it provides? Does it entitle you to revenue, governance, or nothing at all?",
                context: "Understanding what you are actually buying is the foundation of infrastructure-level investing.",
                relatedSections: ["sec_dinv_3"]
            ),
            ReflectionPrompt(
                id: "rp_dinv_4",
                question: "Where would you place yourself on the Risk Ladder (ETFs, self-custody, active protocol investing)? What knowledge gaps would you need to close before moving to the next tier?",
                context: "Self-assessment of risk tolerance and competency determines appropriate entry points.",
                relatedSections: ["sec_dinv_4"]
            ),
            ReflectionPrompt(
                id: "rp_dinv_5",
                question: "If your entire DeFi allocation lost 80% of its value tomorrow, would your overall financial stability be threatened? What does your answer reveal about your position sizing?",
                context: "Position sizing discipline is the mathematical foundation of risk management.",
                relatedSections: ["sec_dinv_5"]
            ),
            ReflectionPrompt(
                id: "rp_dinv_6",
                question: "Estimate the number of hours you have spent studying blockchain mechanics, smart contracts, and protocol economics. Where does that place you on the competency spectrum (40-60 hours basic, 100-150 intermediate, 300+ advanced)?",
                context: "In DeFi, education is not optional enrichment; it is capital preservation.",
                relatedSections: ["sec_dinv_6"]
            ),
            ReflectionPrompt(
                id: "rp_dinv_7",
                question: "Choose one protocol you are interested in (Aave, Uniswap, or MakerDAO). Can you explain its revenue model, primary risks, and competitive moat? Where are the gaps in your understanding?",
                context: "Protocol-specific analysis deepens competence beyond general frameworks.",
                relatedSections: ["sec_dinv_7"]
            ),
            ReflectionPrompt(
                id: "rp_dinv_8",
                question: "If you asked your financial advisor to explain the difference between a governance token and an equity share, how confident are you in the quality of their answer? What would an inadequate response reveal?",
                context: "Evaluating advisor competency is essential when DeFi exposure is under consideration.",
                relatedSections: ["sec_dinv_8"]
            ),

            // ── Personal & Emotional Readiness ──

            ReflectionPrompt(
                id: "rp_dinv_9",
                question: "Be honest with yourself: what is actually driving your interest in DeFi? Is it genuine conviction in decentralized infrastructure, fear of missing a generational opportunity, frustration with traditional finance, or something else entirely? Write it down without editing.",
                context: "Understanding your true impetus separates intentional capital allocation from reactive decision-making. The answer shapes every choice that follows.",
                relatedSections: ["sec_dinv_1"]
            ),
            ReflectionPrompt(
                id: "rp_dinv_10",
                question: "Imagine you allocate capital to DeFi and within six months it loses 70% of its value. Not temporarily — it stays there for two years. How would that outcome affect your daily life, your relationships, and your confidence in your own judgment? What would you tell yourself?",
                context: "Visualizing sustained loss — not a dramatic crash, but a long, quiet decline — reveals whether your allocation matches your actual emotional tolerance, not just your intellectual one.",
                relatedSections: ["sec_dinv_5"]
            ),
            ReflectionPrompt(
                id: "rp_dinv_11",
                question: "Have you ever made a financial decision primarily because someone you respect was doing the same thing? What happened? How does that pattern apply to your current thinking about DeFi?",
                context: "Social proof is one of the most powerful behavioral forces in alternative investing. Recognizing its influence on your own history is the first step toward independent analysis.",
                relatedSections: ["sec_dinv_1", "sec_dinv_6"]
            ),
            ReflectionPrompt(
                id: "rp_dinv_12",
                question: "If DeFi investing did not work out — if the protocols you chose failed, the technology shifted, or regulation changed the landscape entirely — what would you have lost beyond money? Time? Credibility? Trust in yourself? Which of those losses would be hardest to recover from?",
                context: "Financial loss is quantifiable. The non-financial costs of a failed conviction — self-doubt, strained relationships, opportunity cost — are often more consequential and less examined.",
                relatedSections: ["sec_dinv_5", "sec_dinv_4"]
            ),
            ReflectionPrompt(
                id: "rp_dinv_13",
                question: "What is the minimum amount of time you are genuinely willing to commit to understanding this space before deploying capital? Not the number you think sounds responsible — the actual hours you will realistically invest. Does that number meet even the basic 40-60 hour threshold?",
                context: "There is no shortcut. The gap between how much preparation people believe they need and how much they actually do is where most capital is lost.",
                relatedSections: ["sec_dinv_6"]
            ),
            ReflectionPrompt(
                id: "rp_dinv_14",
                question: "Think about your financial life five years from now. In the version where you did invest in DeFi and it went well — what changed? Now consider the version where you did not invest at all. What is actually different between those two futures? Be specific.",
                context: "This exercise separates material financial goals from identity narratives. Sometimes the desire to invest is less about returns and more about who we want to be.",
                relatedSections: ["sec_dinv_4"]
            ),
            ReflectionPrompt(
                id: "rp_dinv_15",
                question: "Who in your life would you tell about this investment, and who would you keep it from? What does the difference between those two lists reveal about your own confidence in the decision?",
                context: "Selective disclosure is a behavioral signal. If you would not defend an allocation to a skeptical but intelligent friend, the thesis may not be as strong as you believe.",
                relatedSections: ["sec_dinv_1", "sec_dinv_8"]
            ),
            ReflectionPrompt(
                id: "rp_dinv_16",
                question: "What is the maximum dollar amount you could lose in DeFi tomorrow and still sleep normally, still meet your obligations, and still feel fundamentally secure? That number — not your aspirational allocation — is your actual risk budget. Is your current plan within it?",
                context: "Risk tolerance is not a personality trait; it is a dollar figure. Anchoring allocation to this concrete number prevents the drift from disciplined investing to emotional gambling.",
                relatedSections: ["sec_dinv_5"]
            )
        ],
        quizzes: [
            Quiz(
                id: "quiz_defi_investing",
                title: "DeFi Investing Fundamentals",
                description: "Test your understanding of protocol-level investing, risk frameworks, and the institutional approach to decentralized finance.",
                questions: [
                    QuizQuestion(
                        id: "q_dinv_1",
                        question: "What primarily distinguishes DeFi speculation from DeFi investing?",
                        options: [
                            "The amount of capital deployed",
                            "Whether decisions are based on protocol fundamentals or price momentum",
                            "The type of exchange used (centralized vs decentralized)",
                            "Whether the investor holds Bitcoin or altcoins"
                        ],
                        correctAnswerIndex: 1,
                        explanation: "Infrastructure investing evaluates protocol revenue, competitive positioning, and value accrual mechanisms, while speculation relies on price momentum and market sentiment.",
                        difficulty: .intermediate,
                        relatedConcepts: ["Infrastructure investing", "Protocol revenue"]
                    ),
                    QuizQuestion(
                        id: "q_dinv_2",
                        question: "What does 'revenue quality' refer to in DeFi protocol analysis?",
                        options: [
                            "The total dollar amount of revenue generated",
                            "Whether revenue is organic or artificially inflated by token incentive programs",
                            "The speed at which revenue is distributed to token holders",
                            "The tax classification of protocol income"
                        ],
                        correctAnswerIndex: 1,
                        explanation: "Revenue quality distinguishes organic, sustainable protocol usage from activity inflated by temporary token subsidies. Institutions evaluate whether usage persists after incentive programs end.",
                        difficulty: .intermediate,
                        relatedConcepts: ["Revenue quality", "Token valuation"]
                    ),
                    QuizQuestion(
                        id: "q_dinv_3",
                        question: "A governance token historically provided holders with which of the following?",
                        options: [
                            "Guaranteed revenue distributions from protocol fees",
                            "Legal ownership of the protocol's intellectual property",
                            "Voting rights on proposals, often without direct revenue participation",
                            "Insurance against smart contract failures"
                        ],
                        correctAnswerIndex: 2,
                        explanation: "Many governance tokens initially functioned as voting instruments without automatic entitlement to protocol revenue, resembling voting shares in a company that distributes no dividends.",
                        difficulty: .beginner,
                        relatedConcepts: ["Governance token", "Value accrual"]
                    ),
                    QuizQuestion(
                        id: "q_dinv_4",
                        question: "Which value-accrual mechanism creates alignment between protocol usage and token scarcity?",
                        options: [
                            "Airdrop campaigns",
                            "Token burns funded by protocol revenue",
                            "Increasing the total token supply",
                            "Listing on additional exchanges"
                        ],
                        correctAnswerIndex: 1,
                        explanation: "Token burns, fee switches, and buyback programs link protocol success to token-holder benefit by reducing supply or directing revenue to holders.",
                        difficulty: .intermediate,
                        relatedConcepts: ["Token burns", "Fee switch", "Buyback programs"]
                    ),
                    QuizQuestion(
                        id: "q_dinv_5",
                        question: "On the Risk Ladder, Tier 1 (Regulated Exposure) primarily involves:",
                        options: [
                            "Providing liquidity to decentralized exchanges",
                            "Investing through Bitcoin and Ethereum ETFs with institutional custody",
                            "Running a validator node on Ethereum",
                            "Governance voting on protocol proposals"
                        ],
                        correctAnswerIndex: 1,
                        explanation: "Tier 1 offers compliant exposure through ETFs, providing institutional-grade custody, insurance frameworks, and simplified tax reporting, though without DeFi-native yield or governance participation.",
                        difficulty: .beginner,
                        relatedConcepts: ["ETF", "Self-custody"]
                    ),
                    QuizQuestion(
                        id: "q_dinv_6",
                        question: "For a conservative investor, what is the recommended maximum single-protocol exposure?",
                        options: [
                            "5% of total portfolio",
                            "2% of total portfolio",
                            "0.5% of total portfolio",
                            "10% of total portfolio"
                        ],
                        correctAnswerIndex: 2,
                        explanation: "Conservative allocation frameworks recommend limiting single-protocol exposure to approximately 0.5% of total portfolio value, recognizing that capital in a single smart contract system must be considered fully at risk.",
                        difficulty: .intermediate,
                        relatedConcepts: ["Position sizing", "Diversification"]
                    ),
                    QuizQuestion(
                        id: "q_dinv_7",
                        question: "What is Aave's primary mechanism for maintaining protocol solvency during market volatility?",
                        options: [
                            "Government insurance programs",
                            "Overcollateralization with automated liquidation via health factor thresholds",
                            "Manual review of all loan applications",
                            "Pausing all trading during downturns"
                        ],
                        correctAnswerIndex: 1,
                        explanation: "Aave requires borrowers to deposit collateral exceeding their loan value. If the health factor falls below threshold, automatic liquidation protects lenders. This processed billions in liquidations during 2022-2024 without systemic failure.",
                        difficulty: .advanced,
                        relatedConcepts: ["Overcollateralization", "Liquidation"]
                    ),
                    QuizQuestion(
                        id: "q_dinv_8",
                        question: "What is 'impermanent loss' in the context of decentralized exchanges like Uniswap?",
                        options: [
                            "A permanent loss of funds due to a hack",
                            "A reduction in value when pooled token price ratios diverge from deposit ratios",
                            "The fee charged for withdrawing liquidity",
                            "Loss from holding tokens during a bear market"
                        ],
                        correctAnswerIndex: 1,
                        explanation: "Impermanent loss occurs when the price ratio of tokens in a liquidity pool diverges from the ratio at deposit. It is structural and measurable, not speculative, and is a core risk for liquidity providers.",
                        difficulty: .advanced,
                        relatedConcepts: ["Impermanent loss", "AMM"]
                    ),
                    QuizQuestion(
                        id: "q_dinv_9",
                        question: "According to industry surveys, approximately what percentage of financial advisors dismiss cryptocurrency as speculative or gambling?",
                        options: [
                            "About 10%",
                            "About 25%",
                            "About 50%",
                            "About 75%"
                        ],
                        correctAnswerIndex: 2,
                        explanation: "Industry surveys suggest approximately 50% of advisors adopt a dismissive posture toward cryptocurrency. This structural knowledge gap reflects the speed at which digital asset innovation has outpaced traditional financial education.",
                        difficulty: .intermediate,
                        relatedConcepts: ["Financial advisory", "Due diligence"]
                    ),
                    QuizQuestion(
                        id: "q_dinv_10",
                        question: "Infrastructure-level evaluation of a DeFi protocol must examine which three layers simultaneously?",
                        options: [
                            "Price history, trading volume, and social media sentiment",
                            "Team LinkedIn profiles, whitepaper length, and logo design",
                            "The protocol's business model, token's value capture design, and competitive moat",
                            "Market capitalization, exchange listings, and celebrity endorsements"
                        ],
                        correctAnswerIndex: 2,
                        explanation: "If any of the three layers (business model, value capture design, competitive moat) are weak or undefined, the investment thesis reverts toward speculation rather than infrastructure investing.",
                        difficulty: .advanced,
                        relatedConcepts: ["Infrastructure investing", "Protocol economics", "Due diligence"]
                    )
                ],
                passingScore: 0.7
            )
        ],
        caseStudies: [
            CaseStudy(
                id: "case_dinv_1",
                title: "The Governance Token Dilemma",
                scenario: "An investor purchased UNI tokens in 2023 based on Uniswap's dominant position in decentralized exchange volume. Despite the protocol generating billions in cumulative trading fees, the UNI token's price did not track protocol revenue growth. The investor's thesis was that governance power would eventually translate to economic value. In 2025, governance discussions led to fee switch activation and supply reduction mechanisms.",
                context: "This case illustrates the historical disconnect between protocol revenue and token value, and how governance evolution can change the investment calculus.",
                keyQuestions: [
                    "Was purchasing UNI based on future governance expectations an investment or a speculation?",
                    "How did the activation of the fee switch change the token's economic profile?",
                    "What framework would you use to evaluate whether governance-driven value accrual is sustainable?"
                ],
                suggestedAnswers: [
                    "Without explicit value accrual, the purchase was closer to speculation because price depended on expectations rather than measurable economic linkage. The thesis relied on governance actors making favorable decisions.",
                    "The fee switch created a structural feedback loop between protocol usage and token demand, moving UNI closer to an equity-like instrument. However, token holders still lack legal ownership protections.",
                    "Evaluate three layers: (1) is the fee switch activated and generating meaningful revenue per token? (2) what percentage of protocol revenue flows to holders? (3) could governance reverse this decision?"
                ],
                learningFocus: ["Value Accrual Analysis", "Governance Risk", "Infrastructure vs. Speculation"],
                relatedSection: "sec_dinv_3",
                source: "From: What Are You Actually Buying? in DeFi Investing"
            ),
            CaseStudy(
                id: "case_dinv_2",
                title: "Position Sizing Under Stress",
                scenario: "A growth-oriented investor allocated 15% of their $200,000 portfolio to crypto: 40% BTC/ETH, 30% blue-chip DeFi protocols, 20% emerging protocols, and 10% stablecoin yield. During a market correction, their Aave position dropped 45%, an emerging protocol suffered a smart contract exploit losing 100% of that allocation, and their stablecoin yield strategy maintained value. Their total crypto allocation fell from $30,000 to approximately $18,500.",
                context: "This case demonstrates the mathematics of risk management and why maximum single-protocol exposure limits exist.",
                keyQuestions: [
                    "Was the investor's initial allocation consistent with a disciplined risk framework?",
                    "How did the smart contract exploit affect total portfolio value versus the Aave drawdown?",
                    "What position sizing changes would reduce the impact of similar events?"
                ],
                suggestedAnswers: [
                    "The 15% crypto allocation falls within the growth-oriented 10-20% range. However, the emerging protocol loss suggests single-protocol exposure may have exceeded the recommended 2% maximum.",
                    "The exploit destroyed approximately $1,800 (20% of $9,000 in DeFi protocols) versus the Aave drawdown of approximately $4,050. The total portfolio impact was a ~5.75% loss, manageable but concentrated.",
                    "Reduce maximum single-protocol exposure, diversify across blockchain ecosystems (not just Ethereum), and increase stablecoin reserves as strategic liquidity for rebalancing during downturns."
                ],
                learningFocus: ["Position Sizing", "Risk Management", "Portfolio Construction"],
                relatedSection: "sec_dinv_5",
                source: "From: Position Sizing in DeFi Investing"
            ),
            CaseStudy(
                id: "case_dinv_3",
                title: "Evaluating Advisor Crypto Competency",
                scenario: "An investor asks their financial advisor about adding DeFi exposure. The advisor responds: 'I wouldn't recommend crypto — it's too volatile and speculative. If you insist, I can help you buy some Bitcoin through our brokerage.' When pressed about specific protocols like Aave or Uniswap, the advisor says they are unfamiliar with those names. The advisor has 20 years of experience and manages $50M in assets.",
                context: "This case illustrates the structural knowledge gap in traditional financial advisory and how investors can assess advisor competency across five domains.",
                keyQuestions: [
                    "Where does this advisor fall on the competency spectrum (Level 1-5)?",
                    "Does the advisor's experience in traditional finance compensate for limited crypto knowledge?",
                    "What strategic pathway should the investor pursue given this assessment?"
                ],
                suggestedAnswers: [
                    "This advisor operates at Level 1 (Dismissive posture), characterizing cryptocurrency broadly as speculative without distinguishing between asset classes, protocols, or use cases.",
                    "Traditional finance expertise does not automatically transfer. The advisor may excel at equity analysis but cannot evaluate smart contract risk, tokenomics, or protocol governance. These are distinct competencies.",
                    "Three options: (1) supplement with a specialized digital asset advisor while keeping the primary advisor for traditional holdings, (2) negotiate an educational commitment with the advisor, or (3) self-direct the crypto allocation within a structured framework while maintaining the advisory relationship for traditional assets."
                ],
                learningFocus: ["Advisor Evaluation", "Competency Assessment", "Strategic Decision-Making"],
                relatedSection: "sec_dinv_8",
                source: "From: Working with Financial Advisors in DeFi Investing"
            )
        ],
        estimatedTime: 90,
        tags: ["DeFi", "Investing", "Infrastructure", "Advanced"]
    )

    // MARK: - Due Diligence Checklist Data
    // Standalone checklist for the dedicated tab
    struct DueDiligenceItem: Identifiable {
        let id = UUID()
        let category: String
        let categoryEmoji: String
        let questions: [String]
        let source: String
    }

    static let dueDiligenceChecklist: [DueDiligenceItem] = [
        DueDiligenceItem(
            category: "Technical",
            categoryEmoji: "🔐",
            questions: [
                "Multiple professional audits",
                "Bug bounty program active",
                "Open-source code",
                "Formal verification (where applicable)"
            ],
            source: "Framework derived from Trail of Bits (2024), Chainalysis (2026)"
        ),
        DueDiligenceItem(
            category: "Economic",
            categoryEmoji: "💰",
            questions: [
                "Clear revenue model",
                "Token value accrual mechanism",
                "Sustainable tokenomics (low inflation)",
                "Treasury management transparency"
            ],
            source: "Framework derived from BIS (2021), IOSCO (2022), Messari (2025)"
        ),
        DueDiligenceItem(
            category: "Governance",
            categoryEmoji: "🏛️",
            questions: [
                "Decentralized decision-making",
                "Active community participation",
                "Clear upgrade process",
                "Time-locked admin functions"
            ],
            source: "Framework derived from MakerDAO governance documentation (2025), IOSCO (2022)"
        ),
        DueDiligenceItem(
            category: "Market",
            categoryEmoji: "📊",
            questions: [
                "Growing TVL (not just incentivized)",
                "Increasing organic usage",
                "Developer ecosystem activity",
                "Integration partnerships"
            ],
            source: "Framework derived from DefiLlama data (2025), Messari (2025)"
        )
    ]
}

// MARK: - DeFi Checklist Tab View
import SwiftUI

struct DeFiChecklistTabView: View {
    @State private var expandedCategories: Set<UUID> = []

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.lg) {
            // Header
            VStack(alignment: .leading, spacing: Spacing.sm) {
                HStack(spacing: Spacing.sm) {
                    Text("📋")
                        .font(.system(size: 28))
                    Text("Due Diligence Checklist")
                        .font(Typography.title2)
                        .foregroundColor(.textPrimary)
                }

                Text("Questions to evaluate before allocating capital to any DeFi protocol. This is an educational framework, not financial advice.")
                    .font(Typography.body)
                    .foregroundColor(.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.top, Spacing.lg)

            // Checklist categories
            LazyVStack(spacing: Spacing.md) {
                ForEach(DeFiInvestingModuleData.dueDiligenceChecklist) { item in
                    ChecklistCategoryCard(
                        item: item,
                        isExpanded: expandedCategories.contains(item.id)
                    ) {
                        withAnimation(.smoothSpring) {
                            if expandedCategories.contains(item.id) {
                                expandedCategories.remove(item.id)
                            } else {
                                expandedCategories.insert(item.id)
                            }
                        }
                    }
                }
            }

            // Footer
            VStack(spacing: Spacing.sm) {
                Divider()
                Text("Framework derived from BIS, IOSCO, CFA Institute, Trail of Bits, Messari, and protocol documentation. For educational purposes only.")
                    .font(Typography.caption2)
                    .foregroundColor(.textTertiary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, Spacing.md)

            Spacer()
                .frame(height: Spacing.xxl)
        }
        .padding(.horizontal, Spacing.lg)
    }
}

// MARK: - Checklist Category Card
struct ChecklistCategoryCard: View {
    let item: DeFiInvestingModuleData.DueDiligenceItem
    let isExpanded: Bool
    let onToggle: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            Button(action: onToggle) {
                HStack(spacing: Spacing.sm) {
                    Text(item.categoryEmoji)
                        .font(.system(size: 22))

                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.category)
                            .font(Typography.bodyMedium)
                            .foregroundColor(.textPrimary)
                        Text("\(item.questions.count) questions")
                            .font(Typography.caption2)
                            .foregroundColor(.textTertiary)
                    }

                    Spacer()

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundColor(.textTertiary)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .padding(Spacing.md)

            // Expanded content
            if isExpanded {
                Divider()
                    .padding(.horizontal, Spacing.md)

                VStack(alignment: .leading, spacing: Spacing.sm) {
                    ForEach(Array(item.questions.enumerated()), id: \.offset) { index, question in
                        HStack(alignment: .top, spacing: Spacing.sm) {
                            Text("\(index + 1).")
                                .font(Typography.bodyMedium)
                                .foregroundColor(.brandPrimary)
                                .frame(width: 22, alignment: .trailing)

                            Text(question)
                                .font(Typography.body)
                                .foregroundColor(.textSecondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }

                    // Source
                    Text(item.source)
                        .font(Typography.caption2)
                        .foregroundColor(.textTertiary)
                        .padding(.top, Spacing.xs)
                }
                .padding(Spacing.md)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(Color.surfaceSecondary)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
    }
}

// MARK: - DeFi Investing Citations & Further Reading

struct DeFiInvestingCitation: Identifiable {
    let id = UUID()
    let title: String
    let author: String
    let source: String?
    let year: String?
    let category: CitationCategory
    let url: String?

    enum CitationCategory: String, CaseIterable {
        case academic = "Academic Research"
        case regulatory = "Regulatory"
        case industry = "Industry"

        var emoji: String {
            switch self {
            case .academic: return "📄"
            case .regulatory: return "🏛️"
            case .industry: return "📊"
            }
        }
    }
}

struct DeFiInvestingCitationsData {
    static let citations: [DeFiInvestingCitation] = [
        // Academic Research
        DeFiInvestingCitation(
            title: "Decentralized Finance (DeFi) Projects: A Study of Key Performance Indicators in Terms of DeFi Protocols' Valuations",
            author: "Metelski, D., & Sobieraj, J.",
            source: "IJFS, MDPI, vol. 10(4)",
            year: "2022",
            category: .academic,
            url: nil
        ),
        DeFiInvestingCitation(
            title: "What drives DeFi market returns?",
            author: "Soiman et al.",
            source: "Journal of International Financial Markets",
            year: "2022",
            category: .academic,
            url: nil
        ),
        // Regulatory
        DeFiInvestingCitation(
            title: "DeFi Risks and Opportunities",
            author: "Bank for International Settlements",
            source: "BIS Quarterly Review",
            year: "2021",
            category: .regulatory,
            url: nil
        ),
        DeFiInvestingCitation(
            title: "Stablecoin Run Dynamics",
            author: "Federal Reserve",
            source: nil,
            year: "2022",
            category: .regulatory,
            url: nil
        ),
        DeFiInvestingCitation(
            title: "Stablecoin Reserve Transparency",
            author: "International Monetary Fund",
            source: "Global Financial Stability Report",
            year: "2023",
            category: .regulatory,
            url: nil
        ),
        // Industry
        DeFiInvestingCitation(
            title: "Real-time TVL and protocol data",
            author: "DefiLlama",
            source: "defillama.com",
            year: nil,
            category: .industry,
            url: "https://defillama.com"
        ),
        DeFiInvestingCitation(
            title: "Protocol metrics and research",
            author: "Messari",
            source: "messari.io",
            year: nil,
            category: .industry,
            url: "https://messari.io"
        ),
        DeFiInvestingCitation(
            title: "On-chain data visualization",
            author: "Dune Analytics",
            source: "dune.com",
            year: nil,
            category: .industry,
            url: "https://dune.com"
        )
    ]
}

// MARK: - DeFi Investing Research View

struct DeFiInvestingResearchView: View {
    @State private var selectedCategory: DeFiInvestingCitation.CitationCategory?

    var filteredCitations: [DeFiInvestingCitation] {
        if let category = selectedCategory {
            return DeFiInvestingCitationsData.citations.filter { $0.category == category }
        }
        return DeFiInvestingCitationsData.citations
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                // Header
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Text("📚")
                        .font(.system(size: 40))

                    Text("Citations & Further Reading")
                        .font(Typography.title2)
                        .foregroundColor(.textPrimary)

                    Text("Academic research, regulatory frameworks, and industry resources referenced in this module.")
                        .font(Typography.body)
                        .foregroundColor(.textSecondary)
                }
                .padding(.horizontal, Spacing.lg)

                // Category filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: Spacing.sm) {
                        FilterChipView(title: "All", emoji: "📚", isSelected: selectedCategory == nil) {
                            selectedCategory = nil
                        }
                        ForEach(DeFiInvestingCitation.CitationCategory.allCases, id: \.self) { cat in
                            FilterChipView(title: cat.rawValue, emoji: cat.emoji, isSelected: selectedCategory == cat) {
                                selectedCategory = cat
                            }
                        }
                    }
                    .padding(.horizontal, Spacing.lg)
                }

                // Citations list
                LazyVStack(spacing: Spacing.sm) {
                    ForEach(filteredCitations) { citation in
                        CitationCardView(citation: citation)
                    }
                }
                .padding(.horizontal, Spacing.lg)

                // Footer
                VStack(spacing: Spacing.sm) {
                    Divider()
                    Text("This module references 136 footnotes from BIS, IOSCO, IMF, CFA Institute, Messari, a16z Crypto, and protocol documentation. See the Footnotes section within module content for the complete list.")
                        .font(Typography.caption2)
                        .foregroundColor(.textTertiary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, Spacing.lg)
                .padding(.top, Spacing.md)

                Spacer().frame(height: Spacing.xxl)
            }
            .padding(.top, Spacing.lg)
        }
    }
}

// MARK: - Filter Chip
private struct FilterChipView: View {
    let title: String
    let emoji: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Text(emoji).font(.caption)
                Text(title)
                    .font(Typography.caption)
                    .foregroundColor(isSelected ? .white : .textSecondary)
            }
            .padding(.horizontal, Spacing.sm)
            .padding(.vertical, 6)
            .background(isSelected ? Color.brandPrimary : Color.surfaceSecondary)
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Citation Card
private struct CitationCardView: View {
    let citation: DeFiInvestingCitation

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            HStack(alignment: .top, spacing: Spacing.sm) {
                Text(citation.category.emoji)
                    .font(.system(size: 18))

                VStack(alignment: .leading, spacing: 2) {
                    Text(citation.title)
                        .font(Typography.bodyMedium)
                        .foregroundColor(.textPrimary)
                        .fixedSize(horizontal: false, vertical: true)

                    HStack(spacing: Spacing.xs) {
                        Text(citation.author)
                            .font(Typography.caption)
                            .foregroundColor(.textSecondary)

                        if let year = citation.year {
                            Text("(\(year))")
                                .font(Typography.caption)
                                .foregroundColor(.textTertiary)
                        }
                    }

                    if let source = citation.source, !source.isEmpty {
                        Text(source)
                            .font(Typography.caption2)
                            .foregroundColor(.textTertiary)
                            .italic()
                    }
                }
            }
        }
        .padding(Spacing.md)
        .background(Color.surfaceSecondary)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
    }
}


// MARK: - Evaluation Framework Tab

struct DeFiEvalFrameworkTabView: View {
    @State private var expandedSections: Set<String> = []

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.lg) {

            VStack(alignment: .leading, spacing: Spacing.sm) {
                HStack(spacing: Spacing.sm) {
                    Text("🔬")
                        .font(.system(size: 28))
                    Text("Advanced Evaluation Framework")
                        .font(Typography.title2)
                        .foregroundColor(.textPrimary)
                }
                Text("A protocol-level due diligence framework for evaluating DeFi investments. Not financial advice.")
                    .font(Typography.body)
                    .foregroundColor(.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.top, Spacing.lg)

            ForEach(EvalFrameworkSection.all) { section in
                EvalFrameworkCard(
                    section: section,
                    isExpanded: expandedSections.contains(section.id)
                ) {
                    withAnimation(.smoothSpring) {
                        if expandedSections.contains(section.id) {
                            expandedSections.remove(section.id)
                        } else {
                            expandedSections.insert(section.id)
                        }
                    }
                }
            }

            VStack(spacing: Spacing.sm) {
                Divider()
                Text("Framework derived from BIS, IOSCO, CFA Institute, DefiLlama, Messari, Trail of Bits, and protocol documentation. For educational purposes only.")
                    .font(Typography.caption2)
                    .foregroundColor(.textTertiary)
                    .italic()
                    .multilineTextAlignment(.center)
            }
            .padding(.top, Spacing.sm)
        }
        .padding(Spacing.md)
    }
}

// MARK: - Data Model

struct EvalFrameworkSection: Identifiable {
    let id: String
    let emoji: String
    let title: String
    let subtitle: String
    let items: [EvalItem]

    static let all: [EvalFrameworkSection] = [
        EvalFrameworkSection(
            id: "business_model",
            emoji: "🏗️",
            title: "Step 1 — Business Model Classification",
            subtitle: "Identify how the protocol generates revenue and where it sits in the DeFi stack.",
            items: [
                EvalItem(label: "Lending (Aave, Compound)", detail: "Revenue: interest spreads, liquidations. Scalability: High (multi-chain). Capital intensity: Medium."),
                EvalItem(label: "DEXs (Uniswap, Curve)", detail: "Revenue: trading fees. Scalability: Very High. Capital intensity: Low — liquidity provided by users."),
                EvalItem(label: "Stablecoins (Maker, Frax)", detail: "Revenue: stability fees, RWA yields. Scalability: Extremely High. Capital intensity: High."),
                EvalItem(label: "Derivatives (dYdX, GMX)", detail: "Revenue: trading fees, liquidations. Scalability: High. Capital intensity: Medium."),
                EvalItem(label: "RWA Platforms (Centrifuge, Maple)", detail: "Revenue: origination fees, servicing. Scalability: Medium. Capital intensity: Very High."),
            ]
        ),
        EvalFrameworkSection(
            id: "revenue_quality",
            emoji: "📊",
            title: "Step 2 — Revenue Quality Assessment",
            subtitle: "Not all revenue is equal. Evaluate sustainability, source, and efficiency.",
            items: [
                EvalItem(label: "Price-to-Revenue ratio", detail: "Mature protocols: 20–50×. High-growth: 100–300×. Uniswap has traded near 200× at peak. Higher multiples mean more future growth is priced in."),
                EvalItem(label: "Organic vs. incentivized revenue", detail: "Organic revenue comes from real user fees. Incentivized revenue depends on token rewards (liquidity mining) and can disappear when rewards are reduced."),
                EvalItem(label: "Revenue cyclicality", detail: "DEX trading fees rise and fall with market volatility. Stablecoin interest income is more stable. Identify which category a protocol falls into."),
                EvalItem(label: "Capital efficiency", detail: "In lending markets, measure utilization rates. In DEXs, examine volume-to-TVL ratio. High TVL with low revenue may signal inefficiency or incentive dependency."),
                EvalItem(label: "TVL interpretation", detail: "TVL is influenced by crypto prices — it can rise without any change in user activity. Use alongside revenue and active user metrics, not in isolation."),
            ]
        ),
        EvalFrameworkSection(
            id: "tokenomics",
            emoji: "🪙",
            title: "Step 3 — Tokenomics Evaluation",
            subtitle: "Does the token actually capture value from protocol success?",
            items: [
                EvalItem(label: "Value accrual mechanisms", detail: "Look for fee switches (directing fees to token holders), buyback-and-burn programs, staking rewards, or revenue sharing. Without these, a token may be governance-only."),
                EvalItem(label: "Token velocity", detail: "If users earn and immediately sell tokens, this creates continuous downward price pressure. Protocols counter this with staking lockups, governance rights, or utility requirements."),
                EvalItem(label: "Supply dynamics", detail: "Review inflation rate, burn rate, insider vesting schedules, and treasury size. Sudden unlocks or aggressive inflation can significantly impact price stability."),
                EvalItem(label: "Profitability discipline", detail: "Aave targets at least $2M in annual revenue per chain deployment before expanding — a sign of disciplined growth. Look for similar evidence of financial standards."),
            ]
        ),
        EvalFrameworkSection(
            id: "competitive_moat",
            emoji: "🏰",
            title: "Step 4 — Competitive Moat Assessment",
            subtitle: "What prevents a competitor from displacing this protocol?",
            items: [
                EvalItem(label: "Network effects", detail: "In DeFi, more liquidity → better pricing → more users → more liquidity. Once a protocol reaches critical mass, displacement becomes increasingly difficult."),
                EvalItem(label: "User acquisition quality", detail: "Over time, a healthy protocol relies less on paid incentives and more on organic growth. Customer acquisition costs should fall, not rise."),
                EvalItem(label: "Retention and engagement", detail: "Strong protocols show improving user retention and increasing numbers of highly active users — not just total wallet counts."),
                EvalItem(label: "Critical mass threshold", detail: "The point at which a network becomes more valuable than competitors and difficult to displace. Identify whether the protocol has crossed this line."),
            ]
        ),
        EvalFrameworkSection(
            id: "risk_framework",
            emoji: "⚠️",
            title: "Risk Framework",
            subtitle: "Systemic risks that must be assessed regardless of protocol quality.",
            items: [
                EvalItem(label: "Smart contract risk", detail: "Reported DeFi losses declined to ~$1.1B in 2025, but flash loan exploits and bridge hacks persist. Code audits reduce risk but do not eliminate it."),
                EvalItem(label: "Collateral correlation risk", detail: "Heavy reliance on a single asset type as collateral can trigger cascading liquidations if prices fall sharply. Assess collateral diversification."),
                EvalItem(label: "Regulatory risk", detail: "The SEC concluded a multi-year investigation into Aave in late 2025 without enforcement — but the process itself illustrates the uncertainty. MiCA and U.S. legislation continue to evolve."),
                EvalItem(label: "Centralization vectors", detail: "Even 'decentralized' protocols may rely on centralized price oracles, admin keys held by small multisig groups, or custodians for RWA collateral. Each introduces trust assumptions."),
            ]
        ),
        EvalFrameworkSection(
            id: "rwa_integration",
            emoji: "🌐",
            title: "Real-World Asset (RWA) Integration",
            subtitle: "The fastest-growing area in DeFi — with distinct tradeoffs.",
            items: [
                EvalItem(label: "What RWAs are", detail: "Tokenized assets — Treasury bills, loans, real estate, bonds — valued in the hundreds of billions in 2024, projected to grow dramatically by 2030."),
                EvalItem(label: "Key protocols", detail: "Aave (Horizon initiative), MakerDAO/Sky (early RWA collateral adopter), Centrifuge (invoices and real estate). Each has different collateral focus and risk profile."),
                EvalItem(label: "Benefits", detail: "Lower volatility than pure crypto collateral. Institutional-grade yields (e.g., U.S. Treasury bill rates). Bridges between TradFi and DeFi infrastructure."),
                EvalItem(label: "Tradeoffs", detail: "Greater centralization, reliance on off-chain custodians, and dependence on legal systems. Understand which legal jurisdiction governs the underlying asset."),
                EvalItem(label: "Growth driver", detail: "Institutional demand for compliant on-chain yield is the primary growth engine. RWA integration is increasingly a requirement for protocols targeting institutional capital."),
            ]
        ),
    ]
}

struct EvalItem: Identifiable {
    let id = UUID()
    let label: String
    let detail: String
}

// MARK: - Card Component

struct EvalFrameworkCard: View {
    let section: EvalFrameworkSection
    let isExpanded: Bool
    let onToggle: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: onToggle) {
                HStack(spacing: Spacing.sm) {
                    Text(section.emoji)
                        .font(.system(size: 22))
                    VStack(alignment: .leading, spacing: 2) {
                        Text(section.title)
                            .font(Typography.bodyMedium)
                            .foregroundColor(.textPrimary)
                            .multilineTextAlignment(.leading)
                        Text(section.subtitle)
                            .font(Typography.caption)
                            .foregroundColor(.textSecondary)
                            .multilineTextAlignment(.leading)
                    }
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.textTertiary)
                }
                .contentShape(Rectangle())
                .padding(Spacing.md)
            }
            .buttonStyle(.plain)

            if isExpanded {
                Divider()
                    .padding(.horizontal, Spacing.md)

                VStack(alignment: .leading, spacing: Spacing.sm) {
                    ForEach(section.items) { item in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.label)
                                .font(Typography.bodyMedium)
                                .foregroundColor(.textPrimary)
                            Text(item.detail)
                                .font(Typography.body)
                                .foregroundColor(.textSecondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(.vertical, Spacing.xs)

                        if item.id != section.items.last?.id {
                            Divider()
                        }
                    }
                }
                .padding(Spacing.md)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(Color.surfaceSecondary)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
    }
}
