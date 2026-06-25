//
//  VentureCapitalModule.swift
//  Enhanced App for Alt Assets
//
//  Created by Victoria Case on 6/6/26.
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//
//  Description: Venture Capital & Private Equity through a Gender Lens —
//  a comprehensive module introducing women investors to private markets:
//  fundamentals, the funding gap, pathways in, SPV structures, due diligence,
//  advisor conversations, reading list, and risk framework.
//
//  Sources cited inline with footnote references.
//

import Foundation

// MARK: - Module Data

struct VentureCapitalModuleData {

    static let vcModule = Module(
        id: "mod_vc_pe",
        title: "Venture Capital & Private Equity",
        description: "From LP/GP fundamentals to SPV structures, due diligence, and how to get involved — through a gender lens. Built for women entering private markets.",
        icon: "🚀",
        color: "indigo",
        heroImageName: "hero_vc",
        sections: [

            // MARK: - Section 1: Fundamentals
            Section(
                id: "sec_vc_1",
                title: "1. What Is VC & PE — The Fundamentals_",
                content: [
                    .text("Venture capital and private equity are the engines behind some of the most significant wealth creation of the last fifty years. They are also among the least understood asset classes — and historically, the least accessible to women, both as investors and as founders receiving capital. This section builds the foundation."),
                    .callout(title: "The Core Distinction", content: "Venture Capital (VC) invests in early-stage companies with high growth potential — often pre-revenue or early-revenue startups. Private Equity (PE) invests in mature companies, often acquiring a controlling stake, improving operations, and selling at a higher multiple.\n\nBoth operate through a fund structure. Both require a long time horizon. Both have historically generated returns that outperform public markets — but only when you get access to the right managers.", type: .definition),

                    .heading("1.1 The LP/GP Structure_", level: 3),
                    .text("All private funds operate through a partnership structure built around two roles:"),
                    .bulletList([
                        "General Partners (GPs): The fund managers. They source deals, conduct due diligence, sit on boards, and execute exits. They typically commit 1–3% of the total fund capital themselves — called the GP commit — to align their interests with investors.",
                        "Limited Partners (LPs): The capital providers. LPs commit 97–99% of the fund's capital but have no management role and bear liability only up to the amount they invested. Most institutional investors — endowments, pension funds, family offices — are LPs in multiple funds simultaneously."
                    ]),
                    .callout(title: "Why 'Limited' Partner?", content: "The 'limited' refers to liability, not influence. LPs cannot lose more than they invest, but they also cannot direct how the GP deploys capital — they are trusting the GP's judgment within the investment mandate they reviewed before committing. This is the core risk of private investing: you are betting on the manager.", type: .keyPoint),

                    .heading("1.2 The Fund Lifecycle_", level: 3),
                    .numberedList([
                        "Fundraising (Year 0–2): The GP issues a Private Placement Memorandum (PPM), pitches potential LPs, and holds a final close when the target capital is raised.",
                        "Deployment / Investment Period (Years 1–5): Capital is called from LPs via capital calls as investments are made. LPs do not wire all their committed capital upfront — it is drawn down as needed, typically with 10–14 days' notice.",
                        "Management Period (Years 3–10): Portfolio companies are actively managed, follow-on rounds are reserved for, and exit opportunities are pursued.",
                        "Exit / Harvest (Years 5–12+): Returns flow back to LPs as companies are sold via acquisition, IPO, or recapitalization.",
                        "Wind-Down: Final audit, capital account reconciliation, and any clawback settlement."
                    ]),
                    .text("Standard fund life is 10 years, with two optional 1-year extensions. This is why VC and PE are called long-horizon assets — your capital is typically committed for a decade."),

                    .heading("1.3 Key Terms You Need to Know_", level: 3),
                    .callout(title: "Capital Call", content: "A formal notice from the GP requesting LPs fund a portion of their committed capital. LPs do not transfer all committed capital upfront — it is called in tranches as investments are made, typically 5–15% of commitment at a time.", type: .definition),
                    .callout(title: "Carried Interest (Carry)", content: "The GP's share of profits — typically 20% — taken after returning LPs' capital plus any preferred return. Example: A $100M fund returns $250M. After returning $100M to LPs and any hurdle, the remaining $150M is split 80/20. The GP retains $30M as carry. Carry is taxed as long-term capital gains in the US (currently 20%).", type: .definition),
                    .callout(title: "The J-Curve", content: "The characteristic performance pattern of a private fund — early years show negative returns as management fees are charged and investments are marked conservatively, followed by an upswing as companies mature and exits occur. New LPs must prepare psychologically and financially for 3–5 years of apparent underperformance before the curve inflects.", type: .definition),
                    .callout(title: "Vintage Year", content: "The year a fund made its first investment. Vintage year matters enormously for benchmarking — funds raised at market peaks (2000, 2007, 2021) often underperform those raised during downturns when entry valuations are lower.", type: .definition),
                    .callout(title: "DPI vs. TVPI", content: "DPI (Distributed to Paid-In): Realized cash returned to LPs divided by capital invested. Only counts actual distributions — the most conservative and honest measure.\n\nTVPI (Total Value to Paid-In): DPI plus the remaining unrealized value of portfolio companies. Includes 'paper gains' that may never materialize.\n\nAlways ask for DPI first. A fund with strong TVPI but low DPI is still a fund that has not returned your money.", type: .keyPoint),
                    .callout(title: "IRR, MOIC, and Dry Powder", content: "IRR (Internal Rate of Return): Annualized return accounting for cash flow timing. Can be misleading — early exits inflate IRR even if absolute returns are modest.\n\nMOIC (Multiple on Invested Capital): Total value returned ÷ total capital invested. A 3x MOIC means $3 returned for every $1 invested, regardless of time.\n\nDry Powder: Committed but undeployed capital. Global PE dry powder reached approximately $3.9 trillion as of Q1 2024.¹", type: .definition),
                    .callout(title: "The 2-and-20 Fee Structure", content: "Standard GP compensation: 2% annual management fee (charged on committed capital during the investment period, stepping down to 1–1.5% of net asset value thereafter) + 20% carried interest on profits.\n\nOn a $100M fund: $2M/year in management fees covers GP salaries, operations, legal, and travel. The real GP upside comes from carry — and only if the fund performs.", type: .definition),
                    .callout(title: "Waterfall, Hurdle Rate & Clawback", content: "Hurdle Rate (Preferred Return): The minimum return LPs must receive before the GP earns carry — typically 8% annually. Some VC funds waive this entirely.\n\nWaterfall: The distribution order defining when LPs and GPs receive proceeds. 'European waterfall' (whole-fund) requires returning all LP capital before any carry flows to the GP — more LP-friendly. 'American waterfall' (deal-by-deal) allows carry on each deal — more GP-friendly.\n\nClawback: Requires GPs to return carry if, at fund wind-down, total distributions fall below the LP-favorable threshold. Protects LPs against GPs being overpaid on early wins offset by later losses.", type: .definition),

                    .heading("1.4 VC vs. PE — Key Differences_", level: 3),
                    .table(
                        headers: ["Dimension", "Venture Capital", "Private Equity (Buyout)"],
                        rows: [
                            ["Stage", "Early-stage (Seed, Series A–C)", "Mature, cash-flow-positive companies"],
                            ["Control", "Minority stakes", "Majority or full control"],
                            ["Leverage", "Rarely used", "Core tool (leveraged buyouts)"],
                            ["Revenue profile", "Pre-revenue to early revenue", "EBITDA-positive"],
                            ["Target return", "3x+ MOIC; power law driven", "2–3x MOIC; more predictable"],
                            ["Hold period", "7–10 years", "3–7 years"],
                            ["Failure rate", "80%+ of deals return ≤1x", "Much lower; distressed is higher"]
                        ],
                        caption: "VC vs. PE comparison. Growth Equity sits between the two: proven revenue, no leverage, minority investment."
                    ),

                    .heading("1.5 Types of Private Equity_", level: 3),
                    .toggleBlock(title: "Leveraged Buyout (LBO)", content: "The GP acquires a company using significant debt (typically 60–70% of purchase price), improves operations or financials, then sells at a higher multiple. The debt amplifies returns — and risk. Blackstone, KKR, and Carlyle are the defining firms."),
                    .toggleBlock(title: "Growth Equity", content: "Minority investment in companies with proven revenue ($10M–$100M ARR) seeking expansion capital without giving up control. No leverage. Lower risk than VC, lower upside than buyout. General Atlantic and TA Associates are key examples."),
                    .toggleBlock(title: "Secondaries", content: "Purchasing existing LP interests from original investors seeking liquidity. Secondary buyers acquire at a discount to NAV, providing liquidity to sellers. Global secondary volume reached $132 billion in 2023.² Firms: Lexington Partners, Hamilton Lane, Ardian."),
                    .toggleBlock(title: "Co-Investments", content: "Direct investments alongside a GP into a specific portfolio company, usually fee-free and carry-free. Increasingly popular with large LPs (sovereign wealth funds, endowments) as a way to reduce the blended fee load of the fund relationship."),
                    .toggleBlock(title: "Distressed / Special Situations", content: "Investing in financially troubled companies through discounted debt or bankruptcy proceedings. Oaktree Capital is the defining firm in this category. Highest risk, highest potential return if the restructuring thesis is correct.")
                ],
                isCollapsible: true,
                level: 2,
                reflectionPrompts: ["sec_vc_reflection_1"],
                glossaryTerms: ["Venture Capital", "Private Equity", "Carried Interest", "Illiquidity Premium", "Due Diligence"],
                relatedResearch: []
            ),

            // MARK: - Section 2: The Gender Gap
            Section(
                id: "sec_vc_2",
                title: "2. The Gender Gap — Data, Research & Why It Matters_",
                content: [
                    .text("The gender gap in venture capital is not anecdotal. It is one of the most thoroughly documented structural inequities in modern finance — measurable at every level of the industry, from who manages funds to who receives capital."),

                    .heading("2.1 Women as Fund Managers_", level: 3),
                    .statistic(value: "15.4%", label: "of decision-making partners at U.S. venture firms were women (2022)", context: "All Raise, 'VC Diversity in Numbers,' 2022³ — up from 9% in 2016, but progress has stalled"),
                    .statistic(value: "5%", label: "of VC fund managers (GPs) are women", context: "Analysis of Pitchbook data by Diversio, 2022⁴"),
                    .statistic(value: "11%", label: "of senior investing roles (VP and above) at U.S. VC firms held by women", context: "Deloitte / All Raise, 2023⁵"),
                    .text("These numbers have barely moved in a decade despite sustained industry attention. The pipeline problem is real: becoming a GP partner typically requires 10–15 years at a firm — a timeline that spans the years when women most often reduce workforce participation for caregiving responsibilities. Carry structures mean wealth accumulates only at fund exit, often 15+ years after joining."),

                    .heading("2.2 The Funding Gap — Women Receiving Capital_", level: 3),
                    .statistic(value: "2.0%", label: "of total U.S. VC dollars went to all-women founding teams in 2023", context: "Pitchbook/NVCA Venture Monitor, Q4 2023⁶ — the lowest figure since 2016"),
                    .text("This is not a market failure in the abstract. It is a specific, documented pattern with real economic consequences — for the founders who cannot access growth capital, for the investors who miss those returns, and for the industries those companies would have transformed."),
                    .callout(title: "The Valuation Gap", content: "The median pre-money valuation for female-founded seed companies is 28% lower than for equivalent male-founded companies — even controlling for sector and stage.\n\nSource: Pitchbook, 2022 VC Female Founders Report⁷", type: .warning),

                    .heading("2.3 The Research on Returns_", level: 3),
                    .text("The most important reframe: this is not just an equity argument. It is a returns argument."),
                    .keyFact(emoji: "📈", title: "First Round Capital 10-Year Study", value: "63% better performance", source: "Portfolio companies with at least one female founder outperformed all-male founding teams over 10 years — First Round Capital, 2015⁸"),
                    .keyFact(emoji: "💰", title: "BCG / MassChallenge", value: "$0.78 revenue per $1 invested", source: "Women-founded companies generated $0.78 revenue per $1 invested vs. $0.31 for male-founded companies — BCG/MassChallenge, 2018⁹"),
                    .keyFact(emoji: "🌐", title: "Peterson Institute", value: "+6 percentage points net profit margin", source: "Companies with 30% female leadership added 6 points to net profit margins across 21,980 firms in 91 countries — Peterson Institute for International Economics, 2016¹⁰"),
                    .text("Note on methodology: The First Round and BCG studies are widely cited but have methodological limitations — selection bias being the most significant. Companies in accelerator programs (MassChallenge) and a single VC's portfolio (First Round) may not represent the broader startup population. These figures should be treated as directional evidence, not universal laws."),
                    .callout(title: "Kauffman Fellows Research (2021)", content: "Funds with higher female GP representation demonstrated stronger DPI and TVPI at equivalent vintage years — meaning more cash returned to investors, not just paper gains.\n\nSource: Kauffman Fellows, 'When Women Invest, Returns Rise,' 2021¹¹", type: .keyPoint),

                    .heading("2.4 The Structural Barriers_", level: 3),
                    .bulletList([
                        "Network exclusion: VC has historically relied on warm introductions. Women are underrepresented in the social and professional networks — Harvard Business School, Stanford, Goldman Sachs alumni — that produce both deal flow and LP relationships.",
                        "LP conservatism: Large endowments and pension funds favor established managers with 10+ year track records — creating circular exclusion of emerging managers, who are disproportionately women and people of color.",
                        "Carry economics and partnership timelines: Becoming a GP partner typically requires 10–15 years at a firm, spanning the years women most often reduce workforce participation. Carry only pays at exit — meaning wealth accumulates 15+ years after first joining a firm.",
                        "Fundraising bias: Research by Dana Kanze (Columbia Business School, published 2017) found VCs asked female founders primarily prevention-focused questions (risk, loss avoidance) while asking male founders promotion-focused questions (vision, upside). Founders who answered in the 'wrong' frame raised significantly less capital.¹²",
                        "Solo GP stigma: Women launching their own funds face disproportionate skepticism about solo GP structures — despite evidence that emerging manager funds often outperform established managers."
                    ]),

                    .heading("2.5 The Pattern Matching Problem_", level: 3),
                    .callout(title: "What Is Pattern Matching?", content: "'Pattern matching' is the cognitive shortcut VCs use to evaluate founders based on resemblance to prior successful founders. Since the canonical successful founder is a young, technical, college-dropout white male from an elite university, pattern matching systematically disadvantages women, people of color, older founders, and non-STEM founders.\n\nThis is not always conscious bias. It is institutional memory operating as a filter.", type: .warning),
                    .quote("Investors prefer entrepreneurial ventures pitched by attractive men — even when the business plan is identical.", author: "Alison Wood Brooks et al., Harvard Business School, 2014¹³"),
                    .text("All Raise has documented that female-led deals are more likely to require a warm introduction from a known GP to receive consideration — adding a gatekeeping layer that male founders can more easily bypass through cold outreach. The structural result is that the best deals from women-founded companies are systematically less likely to reach investors who would fund them.")
                ],
                isCollapsible: true,
                level: 2,
                reflectionPrompts: ["sec_vc_reflection_2"],
                glossaryTerms: ["Venture Capital", "Gender Lens Investing", "Emerging Manager"],
                relatedResearch: []
            ),

            // MARK: - Section 3: How to Get Involved
            Section(
                id: "sec_vc_3",
                title: "3. How to Get Involved — Pathways In_",
                content: [
                    .text("Access to private markets has expanded dramatically in the past decade. The pathways in vary by capital available, risk tolerance, and how actively you want to engage. Here is the full map — from the lowest entry point to institutional LP investing."),

                    .heading("3.1 Are You an Accredited Investor?_", level: 3),
                    .callout(title: "Accredited Investor Definition (Current — Updated 2020)", content: "Income Test: Individual income exceeding $200,000 in each of the two most recent years, or joint income with a spouse exceeding $300,000, with expectation of the same level in the current year.\n\nNet Worth Test: Net worth exceeding $1,000,000, individually or jointly with spouse, excluding the value of the primary residence. Mortgage debt on the primary residence also reduces the net worth calculation.\n\n2020 Update — New Professional Pathways: Holders of Series 7, Series 65, or Series 82 licenses in good standing now qualify — regardless of income or net worth. Registered investment advisers and exempt reporting advisers also qualify.\n\nNote: The $200,000/$300,000 income thresholds were set in 1982 and have never been inflation-adjusted.", type: .definition),
                    .text("If you do not currently qualify as an accredited investor, platforms operating under Regulation A+ and Regulation CF (crowdfunding) allow non-accredited investors to participate in some private investment offerings — though with investment limits based on income."),

                    .heading("3.2 Angel Investing — The Entry Point_", level: 3),
                    .text("Angel investing — direct individual investment in early-stage companies — is the most accessible and educational entry point to startup equity. Typical angel check size: $10,000–$50,000 per company."),
                    .callout(title: "The Diversification Imperative", content: "VC and angel returns follow a power law: a small number of investments generate most returns, and 50%+ of investments return zero. Serious angel investing requires a portfolio of 20–50 companies to have meaningful diversification across this distribution.\n\nThis means angel investing done correctly requires $500,000–$2M+ deployed over time. Individual deal access with $10K checks is possible through syndicates (see SPV section).", type: .keyPoint),
                    .callout(title: "QSBS Tax Advantage", content: "Section 1202 Qualified Small Business Stock (QSBS) exempts up to $10M (or 10x your cost basis) in capital gains for eligible early-stage investments held 5+ years. This is one of the most significant tax incentives available to angel investors — and one of the least discussed. Ask your tax advisor before investing.", type: .tip),

                    .heading("3.3 Gender-Focused Angel Networks_", level: 3),
                    .toggleBlock(title: "Golden Seeds", content: "Founded 2005. One of the largest and most established angel groups focused on women-led businesses. Members are both men and women; chapters across New York, Boston, Atlanta, Dallas, Silicon Valley, and online. Has invested $150M+ in 200+ companies. Annual membership required; members must be accredited investors. goldenseeds.com"),
                    .toggleBlock(title: "37 Angels", content: "New York-based. Invests in early-stage companies while specifically recruiting and training women as angels. Has invested in 90+ companies. Emphasizes education alongside deal access — a good entry point for those new to angel investing. 37angels.com"),
                    .toggleBlock(title: "Pipeline Angels", content: "Founded by Natalia Oberti Noguera. Pitching bootcamp + angel network model specifically for women and non-binary investors. Focuses on social ventures and BIPOC-led companies. Training cohorts are a core product — you learn deal evaluation by doing it. pipelineangels.com"),
                    .toggleBlock(title: "Portfolia", content: "Led by Carol Dougherty and Trish Costello. Fund-of-funds model specifically designed for women investors. Multiple thematic funds (FemTech, AgeTech, Rising America). Minimums around $10,000. Intentionally integrates education and community into the LP experience — not just financial return. portfolia.co"),
                    .toggleBlock(title: "Women's Venture Capital Fund", content: "Bay Area focused. Invests in early-stage companies with women in leadership. LP-style structure rather than angel network. womensvccapital.com"),

                    .heading("3.4 Retail-Accessible Platforms_", level: 3),
                    .text("These platforms have lowered minimums dramatically by pooling investor capital or structuring under alternative regulatory exemptions:"),
                    .table(
                        headers: ["Platform", "Minimum", "Structure", "Accredited Required"],
                        rows: [
                            ["Republic", "$100–$500", "Reg CF / Reg A+", "No (some offerings)"],
                            ["Sweater Ventures", "$500", "Evergreen fund", "No"],
                            ["Yieldstreet", "$1,000–$10,000", "Various structures", "Mostly yes"],
                            ["Allocate", "$25,000", "Fund feeder", "Yes"],
                            ["Moonfare", "$75,000–$100,000", "Fund feeder", "Yes"],
                            ["iCapital", "$25,000–$100,000", "Advisor-intermediated", "Yes"],
                            ["Forge Global", "$50,000+", "Secondary market", "Yes"]
                        ],
                        caption: "Retail alternative investment platforms. Minimums and structures change — verify current terms directly with each platform. These are not endorsements."
                    ),

                    .heading("3.5 AngelList Syndicates_", level: 3),
                    .callout(title: "How Syndicates Work", content: "AngelList pioneered the syndicate model — a lead investor sets up an SPV (Special Purpose Vehicle) and brings a network of investors into a single deal. Key features:\n\n• Investors review each deal individually and opt in or out — no blind pool commitment\n• Minimums typically $1,000–$10,000 per deal\n• Lead carry is typically 15–20%\n• Allows women investors to start with small check sizes and learn deal evaluation one deal at a time\n• No locked-up capital between deals — you only invest when you choose to\n\nAngelList is one of the most accessible entry points to VC deal flow for new investors.", type: .tip),

                    .heading("3.6 Getting Into a Fund as an LP_", level: 3),
                    .text("The process of becoming an LP in a traditional VC or PE fund:"),
                    .numberedList([
                        "Find the GP: Most established funds are oversubscribed and not accepting new LPs. Entry pathways include warm introduction from an existing LP, family office conferences (iConnections, Tiger 21), emerging manager platforms (Allocate, iCapital, Moonfare), or direct outreach to emerging managers.",
                        "Due diligence: Review the PPM, LPA, audited financials of prior funds. Schedule calls with the GP team. See Section 5 for a full due diligence question framework.",
                        "Subscription documents: Complete subscription agreement confirming accredited investor status, source of funds (AML/KYC), and investment amount.",
                        "Admission: GP countersigns. You are now an LP in the fund.",
                        "Capital calls begin: You will receive capital call notices as the GP deploys. Typically 5–15% of commitment per call, with 10–14 days' notice to wire."
                    ]),
                    .callout(title: "Emerging Manager Funds — Why They Matter", content: "Emerging managers (first through third fund, typically under $300M AUM) are disproportionately women and people of color. They also have structural reasons to outperform:\n\n• Lower minimums ($100K–$500K)\n• More flexible LP terms\n• Greater motivation to build strong LP relationships\n• Cambridge Associates data shows first-time funds have historically outperformed established manager benchmarks by 200–400 basis points — though with higher dispersion\n\nInvesting in emerging managers is both a gender-lens strategy and, on average, a solid return strategy.", type: .keyPoint)
                ],
                isCollapsible: true,
                level: 2,
                reflectionPrompts: ["sec_vc_reflection_3"],
                glossaryTerms: ["Accredited Investor", "Illiquidity Premium", "Angel Investing"],
                relatedResearch: []
            ),

            // MARK: - Section 4: SPV Structures
            Section(
                id: "sec_vc_4",
                title: "4. SPV Structures — Legal Framework & How to Set One Up_",
                content: [
                    .text("Special Purpose Vehicles (SPVs) are one of the most powerful and underutilized tools for women entering private investing. They allow deal-by-deal participation without blind pool commitment — you see each investment before you decide to participate."),

                    .callout(title: "What Is an SPV?", content: "A Special Purpose Vehicle is a single-purpose legal entity — typically a Delaware LLC — created to pool investor capital for one specific investment.\n\nIn VC, SPVs are used for:\n• Syndication: A lead investor brings additional capital from their network into a deal they have secured an allocation in\n• Deal-by-deal investing: Investors evaluate each opportunity individually\n• Pro-rata rights: Existing investors exercise their right to invest in a company's next funding round\n• Rolling funds: Quarterly commitment vehicles popularized by AngelList", type: .definition),

                    .heading("4.1 Why SPVs Exist_", level: 3),
                    .text("SPVs solve two core problems. First, founders prefer a single entity on their cap table rather than 50 individual investors — one voting entity simplifies governance and future fundraising. Second, investors who want deal-by-deal control rather than blind pool commitment can evaluate each opportunity before committing capital."),

                    .heading("4.2 How to Set Up an SPV — Legal Steps_", level: 3),
                    .numberedList([
                        "Lead investor (SPV manager) identifies a deal and negotiates an allocation with the company.",
                        "Delaware LLC is formed — either through an SPV platform or a law firm specializing in venture. Filing fee is approximately $90.",
                        "An operating agreement is drafted, defining carry, fees, voting rights, and management authority.",
                        "SEC exemption is selected: typically Regulation D Rule 506(b) or 506(c) (see below).",
                        "Form D is filed with the SEC within 15 days of first sale.",
                        "Subscription documents are sent to prospective investors; they sign and wire funds.",
                        "SPV closes and funds the investment into the target company. Investors receive their pro-rata interest in the SPV."
                    ]),

                    .heading("4.3 Costs_", level: 3),
                    .statistic(value: "$3,000–$10,000", label: "Typical SPV formation cost", context: "Depending on platform vs. law firm, number of investors, and complexity. Annual administration: $2,000–$2,500/year"),

                    .heading("4.4 SPV Platforms_", level: 3),
                    .toggleBlock(title: "AngelList (angellist.com/syndicates)", content: "The largest SPV platform. Automated formation, investor onboarding, subscription agreements, capital calls, and reporting. SPV-as-a-Service available at ~$8,000 flat plus expenses for custom structures. Also charges carry on top of lead carry in some structures — verify current fee model."),
                    .toggleBlock(title: "Sydecar (sydecar.io)", content: "Modern, streamlined SPV formation with flat-fee pricing (~$3,000–$4,000 per SPV). Known for speed — can form and close an SPV in 24–48 hours. Strong in the emerging manager community. Good starting point for first-time leads."),
                    .toggleBlock(title: "Assure (assure.co)", content: "Dedicated SPV administration. Handles formation, compliance, tax (K-1s), and reporting. Common in the independent SPV market outside AngelList. Pricing typically $4,000–$8,000 setup plus ~$2,500/year administration."),
                    .toggleBlock(title: "Carta (carta.com)", content: "Primarily cap table management software for startups, but offers SPV administration through Carta Launch. Integrates with cap table management for portfolio companies — useful if you are already using Carta."),

                    .heading("4.5 Why Delaware LLC?_", level: 3),
                    .callout(title: "The Delaware Standard", content: "Delaware LLCs are standard for SPVs because:\n\n• Delaware has the most well-developed and predictable corporate law, including the Delaware Court of Chancery — a specialized business court with experienced judges and no juries\n• Delaware LLCs are pass-through entities for federal tax (no entity-level tax; gains/losses pass to investors' K-1s)\n• Most VC-backed companies are also Delaware corporations, simplifying the legal interface\n• Delaware registered agent requirements are straightforward (~$100–$300/year)", type: .definition),

                    .heading("4.6 Reg D 506(b) vs. 506(c)_", level: 3),
                    .table(
                        headers: ["Rule", "Advertising Allowed?", "Investor Verification", "Non-Accredited Investors"],
                        rows: [
                            ["506(b)", "No — private networks only", "Self-certification (check a box)", "Up to 35 'sophisticated' investors"],
                            ["506(c)", "Yes — public advertising allowed", "Must verify accredited status (tax returns, bank statements, or CPA letter)", "None — all must be accredited and verified"]
                        ],
                        caption: "Reg D exemptions under the JOBS Act. Most SPVs and VC funds use 506(b). The no-advertising restriction means deals circulate through trusted networks — reinforcing existing gatekeeping that disadvantages women."
                    ),
                    .callout(title: "The 506(c) Opportunity", content: "506(c) allows public advertising of investment opportunities — meaning a GP can post about a deal on LinkedIn or social media. This theoretically opens deal access to women who are not in traditional VC networks. The catch: all investors must have their accredited status formally verified, adding friction.\n\nThe SEC proposed updates to streamline 506(c) verification in 2023 — watch this space.", type: .tip),

                    .heading("4.7 Lead vs. Passive LP in an SPV_", level: 3),
                    .callout(title: "Two Roles in an SPV", content: "Lead Investor (SPV Manager/GP):\n• Sourced the deal, negotiated terms, conducted initial due diligence\n• Sets the SPV carry (typically 15–20%)\n• Signs investment documents with the portfolio company\n• Files Form D with the SEC\n• Bears management liability\n\nPassive LP:\n• Reviews deal materials provided by the lead\n• Signs subscription documents and wires capital\n• Receives pro-rata economics through the SPV\n• Has no direct relationship with the portfolio company\n• Receives K-1 at tax time", type: .definition),

                    .heading("4.8 SPV vs. Fund — Key Risk Differences_", level: 3),
                    .table(
                        headers: ["Risk", "SPV", "Fund"],
                        rows: [
                            ["Diversification", "Single-deal concentration", "Portfolio of 20–50+ companies"],
                            ["Information quality", "Dependent on lead's disclosure", "Regular LP reporting required"],
                            ["Follow-on capital", "SPV may not have pro-rata rights", "Fund reserves capital for follow-ons"],
                            ["GP quality signal", "Highly variable lead quality", "GP has established track record"],
                            ["Adverse selection risk", "High — leads syndicate overflow", "Lower — GP deploys fund capital first"]
                        ],
                        caption: "The adverse selection risk is real: experienced lead investors typically use their best allocations for their own fund or reserved pro-rata, syndicating the overflow. Not universal — some leads use SPVs as their primary vehicle — but a key due diligence consideration."
                    ),

                    .heading("4.9 Timeline_", level: 3),
                    .bulletList([
                        "SPV formation to first close: 24 hours (Sydecar, fast-moving deal) to 2 weeks (custom legal structure)",
                        "Fundraising period: 1–30 days (VC deals may close in days; secondary deals have more time)",
                        "Investment into portfolio company: Same day as SPV close, or within a few days",
                        "Total SPV formation to investment: typically 1–6 weeks"
                    ])
                ],
                isCollapsible: true,
                level: 2,
                reflectionPrompts: ["sec_vc_reflection_4"],
                glossaryTerms: ["Due Diligence", "Accredited Investor", "Illiquidity Premium"],
                relatedResearch: []
            ),

            // MARK: - Section 5: Due Diligence
            Section(
                id: "sec_vc_5",
                title: "5. Due Diligence — Questions, Frameworks & Red Flags_",
                content: [
                    .text("Private market due diligence is entirely different from evaluating a public stock. There is no daily price, no SEC filing to google, and no analyst consensus. Everything depends on what you ask and how you interpret the answers."),

                    .heading("5.1 Questions for Evaluating a VC Fund (LP Perspective)_", level: 3),
                    .callout(title: "Team Questions", content: "1. What is each partner's individual deal attribution from prior funds? (Ask for deal-by-deal attribution, not blended fund returns.)\n2. How long has the team been together? Any partnership changes since Fund I?\n3. What is the investment committee structure — who has veto power?\n4. What are the key man provisions? If [Lead GP] leaves, what happens?\n5. How is carry allocated among the GP team?\n6. What is the GP's personal financial commitment to this fund?", type: .info),
                    .callout(title: "Track Record Questions", content: "7. Can you provide audited financials and performance figures from prior funds, verified by a third-party administrator?\n8. What is the DPI (realized returns) from prior funds? (TVPI includes paper gains — DPI is what actually returned to LPs.)\n9. What is your loss ratio — what percentage of deals returned ≤1x?\n10. Which deals drove fund returns — were they outliers or did the portfolio broadly perform?\n11. How has your strategy evolved since Fund I and why?", type: .info),
                    .callout(title: "Terms & Governance Questions", content: "12. What is the management fee structure and how does it step down after the investment period?\n13. Is the waterfall American (deal-by-deal) or European (whole-fund)?\n14. What is the hurdle rate, if any?\n15. What is the clawback provision and has it ever been triggered?\n16. Are there LP Advisory Committee (LPAC) rights and what is the LPAC's authority?\n17. Are there co-investment rights for LPs?\n18. What is the most-favored-nation (MFN) provision for smaller LPs?\n19. What are the conditions for transferring my LP interest?", type: .info),

                    .heading("5.2 Questions for an SPV / Individual Deal_", level: 3),
                    .callout(title: "SPV Due Diligence", content: "1. How did you source this deal? What is your relationship with the company?\n2. What is the current round structure — valuation, round size, other investors?\n3. What due diligence have you personally conducted? Can you share your investment memo?\n4. What are the company's current revenue, growth rate, and burn rate?\n5. Does the SPV have pro-rata rights for future rounds?\n6. What is your carry on this SPV? Any fees beyond the carry?\n7. What is your exit thesis — likely acquirers or IPO comparables?\n8. Have you invested in this company before? If so, at what valuation?\n9. Who are the other institutional investors in this round — and have you spoken with them?", type: .info),

                    .heading("5.3 How to Read a PPM_", level: 3),
                    .text("A Private Placement Memorandum (PPM) is the primary offering document. Key sections:"),
                    .numberedList([
                        "Executive Summary: Fund size, strategy, target returns, key terms. Read this last — it is written to impress.",
                        "Risk Factors: The most important section. GPs are required to disclose all conceivable risks. Read carefully for unusual disclosures — anything specific to this GP or fund structure is a signal.",
                        "Management Team: Biographies and track record. Cross-reference every deal mentioned against Pitchbook, Crunchbase, or LinkedIn.",
                        "Prior Fund Performance: Often in the PPM or in a separate data room. Look for DPI, not just TVPI or IRR.",
                        "Fees and Expenses: Detailed breakdown of what comes out of management fees vs. what is charged additionally. Organizational expenses can be substantial.",
                        "Conflicts of Interest: Does the GP manage other funds or SMAs that compete for the same deals? Who gets the best allocations?",
                        "Distribution and Waterfall: Exact mechanics of how returns flow to LPs and GPs. The devil is in the catch-up provision."
                    ]),

                    .heading("5.4 Red Flags_", level: 3),
                    .callout(title: "Manager-Level Red Flags", content: "• DPI is zero or minimal across prior funds — all returns are unrealized paper gains\n• GP cannot provide audited financials from a verifiable administrator\n• Track record attribution is blended, not individual (common in spin-outs where GPs claim credit for deals they did not lead)\n• Key man provisions are weak or absent\n• Management fee never steps down\n• GP commit is under 1% of fund\n• One deal represents more than 30% of fund NAV\n• GP is unwilling to share the full LPA with a prospective LP\n• Placement agent fees above 2% that LPs indirectly bear", type: .warning),
                    .callout(title: "SPV-Level Red Flags", content: "• Lead investor cannot clearly explain how they sourced the deal\n• No institutional co-investors in the underlying round\n• Rushed timeline with limited information ('close in 48 hours')\n• Lead has not personally invested a meaningful amount\n• Carry structure above 25% without exceptional justification\n• No information rights or pro-rata rights for the SPV\n• Lead has a history of SPVs with poor outcomes and no explanation", type: .warning),

                    .heading("5.5 Reference Check Questions_", level: 3),
                    .text("Ask for 3–5 LP references from prior funds and 3–5 portfolio company CEO references:"),
                    .callout(title: "Questions for LP References", content: "• How did the GP communicate during periods of portfolio underperformance?\n• Were capital calls predictable and well-communicated?\n• Did the GP ever surprise you with significant write-downs without warning?\n• Would you commit to another fund with this team? Why or why not?\n• How accessible are the partners day-to-day?", type: .info),
                    .callout(title: "Questions for CEO References", content: "• How did the GP add value beyond capital — board work, introductions, recruiting?\n• Did the GP behave consistently during difficult situations — down rounds, pivots, layoffs?\n• Would you want them on your board again?\n• Were there any moments where GP interests conflicted with company interests? How were they handled?", type: .info),

                    .heading("5.6 Key Documents to Know_", level: 3),
                    .bulletList([
                        "LPA (Limited Partner Agreement): The governing document of the fund relationship. Typically 50–150 pages. Large LPs negotiate terms individually; smaller LPs typically receive a standard form.",
                        "Subscription Agreement: Your contract with the fund. Includes representations about accredited investor status, source of funds (AML/KYC), and investment suitability.",
                        "Capital Account Statements: Quarterly or semi-annual statements showing your NAV, contributions, distributions, and unrealized value. Ask what methodology is used for NAV calculation.",
                        "K-1 (Schedule K-1, Form 1065): Annual tax document showing your share of income, gains, losses, and deductions. PE/VC K-1s are often delivered late (September–October for the prior tax year) — build in a tax extension.",
                        "NVCA Model Legal Documents: The National Venture Capital Association publishes free, standardized term sheets, stockholder agreements, and fund documents at nvca.org — an excellent reference for understanding what 'standard' terms look like."
                    ])
                ],
                isCollapsible: true,
                level: 2,
                reflectionPrompts: ["sec_vc_reflection_5"],
                glossaryTerms: ["Due Diligence", "Illiquidity Premium", "Risk-Adjusted Return"],
                relatedResearch: []
            ),

            // MARK: - Section 6: Talking to Your Advisor
            Section(
                id: "sec_vc_6",
                title: "6. Talking to Your Financial Advisor_",
                content: [
                    .text("Your financial advisor is an important partner in this process — but they have structural limits on what they can do, and not all advisors have deep alternatives expertise. This section gives you the framework to have a productive, informed conversation."),

                    .heading("6.1 What Your Advisor Can and Cannot Do_", level: 3),
                    .callout(title: "What They Can Do", content: "• Advise on whether private investments fit your overall financial plan and risk tolerance\n• Help you understand tax implications (QSBS, K-1 filings, opportunity zones)\n• Model out liquidity needs vs. illiquid investment horizon\n• Review PPMs and fund documents for red flags (if they have alternatives experience)\n• Source and recommend specific funds or platforms if they are registered as an RIA with appropriate licenses", type: .tip),
                    .callout(title: "What They Cannot Do", content: "• An advisor without securities licenses cannot place you in private fund investments or earn a commission for doing so\n• Broker-dealers can only offer private placements from their approved product shelf — most major firms only offer third-party fund access through iCapital or CAIS feeder structures with additional fees\n• AUM-based advisors face a structural conflict of interest: once capital is called into a private fund, it moves off their platform and they no longer earn fees on it — creating a subtle disincentive to recommend illiquid alternatives, even when appropriate", type: .warning),

                    .heading("6.2 Finding the Right Advisor for This_", level: 3),
                    .callout(title: "Fee-Only vs. AUM-Based", content: "Fee-only advisors (charging flat or hourly fees unrelated to AUM) have no conflict of interest when recommending illiquid investments — your capital leaving their platform does not reduce their income.\n\nNAPFA (National Association of Personal Financial Advisors) maintains a directory of fee-only advisors: napfa.org\n\nFor alternatives specifically, boutique RIAs specializing in family office services, or advisors affiliated with iCapital's advisor education platform, will have deeper expertise than generalist wealth managers.", type: .tip),

                    .heading("6.3 Questions to Open the Conversation_", level: 3),
                    .bulletList([
                        "I'm exploring adding private equity and venture capital exposure to my portfolio. What percentage of my total investable assets do you think is appropriate for illiquid alternatives, given my financial situation and timeline?",
                        "Which platforms or fund managers do you currently work with in the alternatives space, and what are the minimums?",
                        "What is your own experience and knowledge base around venture capital specifically? Have you had clients invest in VC funds before?",
                        "How would capital calls work with my overall cash flow planning? Can we model out the timing?"
                    ]),

                    .heading("6.4 Questions to Test Alternatives Expertise_", level: 3),
                    .text("If your advisor cannot answer these questions substantively, consider seeking a specialist for this piece of your portfolio:"),
                    .callout(title: "Advisor Competency Questions", content: "1. Can you explain the difference between DPI and TVPI, and why that matters when evaluating a fund's track record?\n2. What is the J-curve and how should I prepare for it financially and psychologically?\n3. How do capital calls work and how should I set aside capital for them without disrupting my liquidity?\n4. What is the carried interest tax treatment and how might that affect my tax planning?\n5. Which fund administrators do you consider reputable? (Citco, Apex, State Street, SS&C are examples.)\n6. What is the difference between an American and European waterfall and why does it matter to me as an LP?", type: .info),

                    .heading("6.5 What to Know Going In_", level: 3),
                    .text("Before meeting your advisor, prepare:"),
                    .numberedList([
                        "Your current portfolio allocation and any existing illiquidity (real estate, business equity, retirement accounts you cannot touch)",
                        "Your investment horizon — when might you need this capital?",
                        "The percentage of your portfolio you are genuinely comfortable making illiquid for 10 years",
                        "Specific funds, platforms, or networks you have already researched",
                        "Your accredited investor status and whether you can verify it (for 506(c) opportunities)"
                    ]),
                    .callout(title: "The Key Framing", content: "The conversation with your advisor is not 'should I invest in VC?' It is: 'given my full financial picture, what allocation to illiquid alternatives makes sense, and which pathways give me appropriate risk-adjusted access?' You are the decision-maker. They are the technical resource.", type: .tip)
                ],
                isCollapsible: true,
                level: 2,
                reflectionPrompts: ["sec_vc_reflection_6"],
                glossaryTerms: ["Due Diligence", "Risk-Adjusted Return"],
                relatedResearch: []
            ),

            // MARK: - Section 7: Your Reading List
            Section(
                id: "sec_vc_7",
                title: "7. Your Reading List — Books, Research & Organizations_",
                content: [
                    .text("The private markets world has a defined canon of reading. This section gives you the full stack — from foundational books to annual reports to organizations actively working to change who has access to this asset class."),

                    .heading("7.1 Essential Books_", level: 3),
                    .callout(title: "Venture Deals", content: "Brad Feld & Jason Mendelson (4th edition, 2019, Wiley)\n\nThe definitive introduction to VC term sheets. Covers every key term, negotiation dynamic, and mechanic of venture investment from both sides of the table. Required reading for anyone entering VC — whether as a founder, investor, or LP.", type: .definition),
                    .callout(title: "The Power Law: Venture Capital and the Making of the New Future", content: "Sebastian Mallaby (2022, Penguin Press)\n\nNarrative history of VC from Arthur Rock through Sequoia, Kleiner Perkins, Benchmark, and Andreessen Horowitz. Extensively researched and readable. The best overall introduction to how VC actually works, its culture, and its power dynamics — including Mallaby's candid writing on gender dynamics in Silicon Valley.", type: .definition),
                    .callout(title: "Secrets of Sand Hill Road", content: "Scott Kupor (2019, Portfolio/Penguin)\n\nKupor is managing partner of Andreessen Horowitz. An extremely practical guide to VC mechanics written from the GP perspective — highly useful for LPs wanting to understand how funds actually think and make decisions.", type: .definition),
                    .callout(title: "It's About Damn Time", content: "Arlan Hamilton (2020, Currency)\n\nHamilton built a VC fund (Backstage Capital) while homeless, investing exclusively in underrepresented founders — women, people of color, LGBTQ+ entrepreneurs. Highly readable and directly relevant to women entering venture. One of the most important books in this canon for its combination of personal narrative and structural critique.", type: .definition),
                    .callout(title: "VC: An American History", content: "Tom Nicholas (2019, Harvard University Press)\n\nAcademic history of venture capital from its pre-WWII origins through Silicon Valley's rise. Essential for understanding the structural and economic forces that shaped the industry — including why VC has historically favored certain geographies and demographics.", type: .definition),
                    .callout(title: "Pioneering Portfolio Management", content: "David Swensen (2000, updated 2009, Free Press)\n\nThe foundational text of the Yale Endowment Model — up to 40%+ in alternatives. Swensen's framework for institutional allocation to private markets is the intellectual basis for the endowment approach. Read this to understand why institutional money flowed into VC/PE in the first place.", type: .definition),

                    .heading("7.2 Gender-Focused Reading_", level: 3),
                    .callout(title: "The Moment of Lift", content: "Melinda Gates (2019, Flatiron Books)\n\nExtensively covers the evidence base for investing in women as an economic multiplier — including data on gender-lens finance, microfinance, and the structural barriers women face in accessing capital globally. Essential context for why the gender gap in VC is not just an equity issue.", type: .definition),
                    .callout(title: "Angel", content: "Jason Calacanis (2017, HarperBusiness)\n\nPractical, opinionated guide to angel investing. Useful entry point for new investors learning deal evaluation, portfolio construction, and the psychology of early-stage investing. Calacanis's self-promotional style is noted but the tactical content is valuable.", type: .definition),

                    .heading("7.3 Key Research Reports_", level: 3),
                    .bulletList([
                        "Pitchbook/NVCA Venture Monitor (quarterly): The definitive source for U.S. VC statistics — deal volume, valuations, exits, dry powder, and gender data. Free basic versions at nvca.org.",
                        "All Raise 'VC Diversity in Numbers' (annual): The most focused gender-specific data source for the VC industry. Tracks women as GP partners and LP decision-makers. allraise.org",
                        "Kauffman Foundation 'We Have Met the Enemy and He Is Us' (2012): Landmark report analyzing 20 years of VC fund performance. Found most VC funds underperform public markets after fees. Essential reading for calibrating expectations. Free at kauffman.org",
                        "ILPA Principles 3.0 (2019): The LP industry's best practices for fund governance, fee structures, and reporting. The benchmark for what 'standard' fund terms should look like. Free at ilpa.org",
                        "Cambridge Associates Private Equity Benchmarks: The most widely used benchmarks for PE/VC fund performance comparisons. Summary data frequently cited in industry publications.",
                        "Atomico 'State of European Tech' (annual): Best data on European VC including gender statistics. Free at stateofeuropeantech.com"
                    ]),

                    .heading("7.4 Organizations to Know_", level: 3),
                    .toggleBlock(title: "All Raise (allraise.org)", content: "Founded 2018 by prominent women VCs including Aileen Lee and Jess Lee. Mission: increase the number of women in VC as both investors and founders. Runs programs for aspiring VCs, hosts events, and publishes the most rigorous annual data on gender diversity in VC. Over 700 GP members."),
                    .toggleBlock(title: "Portfolia (portfolia.co)", content: "Thematic fund series designed specifically for women investors — FemTech, AgeTech, Rising America funds. Minimum investments around $10,000. Intentionally integrates education and community into the LP experience. One of the most accessible institutional-grade entry points for women new to VC."),
                    .toggleBlock(title: "Backstage Capital (backstagecapital.com)", content: "Founded by Arlan Hamilton. Invests exclusively in companies led by underrepresented founders — women, people of color, LGBTQ+. Has raised 30+ SPVs and multiple funds. A direct embodiment of gender-lens investing in practice."),
                    .toggleBlock(title: "SoGal Ventures (sogalventures.com)", content: "One of the first global VC funds led by women of color (Pocket Sun and Elizabeth Galbut). Early-stage focus on diverse founders and diverse emerging markets. Active community alongside the fund."),
                    .toggleBlock(title: "Kapor Capital (kaporcapital.com)", content: "Freada Kapor Klein and Mitch Kapor's fund. Invests in 'gap-closing' companies that improve access and opportunity for underrepresented communities. Kapor Klein is one of the most rigorous researchers on structural bias in tech and VC."),
                    .toggleBlock(title: "ILPA (ilpa.org)", content: "Institutional Limited Partners Association — the LP-side trade group. Best practices documents, model LPA terms, and education resources. Essential reference for understanding what good fund governance looks like from the investor's perspective."),
                    .toggleBlock(title: "NVCA (nvca.org)", content: "National Venture Capital Association — primary industry trade association. Publishes free model legal documents (standardized term sheets, stockholder agreements) highly useful for due diligence education."),

                    .heading("7.5 Online Tools & Databases_", level: 3),
                    .bulletList([
                        "SEC EDGAR (sec.gov): All Form Ds (private offering notices) are publicly filed. Search for any fund's Form D to verify offering size, exempt offering category, and key principals — useful for verifying GP claims before investing.",
                        "SEC Investment Adviser Public Disclosure (adviserinfo.sec.gov): Look up any registered investment adviser and their ADV Part 2 — required disclosure including fee structures, conflicts of interest, and disciplinary history. Free and public.",
                        "FINRA BrokerCheck (brokercheck.finra.org): Look up any broker-dealer or registered representative for complaints or disciplinary history.",
                        "Crunchbase (crunchbase.com): Free basic tier. Company and funding round data — essential for cross-referencing GP track record claims.",
                        "AngelList (angellist.com): Deal flow, syndicate access, fund formation, rolling fund subscriptions.",
                        "NAPFA Directory (napfa.org): Find fee-only financial advisors without AUM conflicts of interest."
                    ])
                ],
                isCollapsible: true,
                level: 2,
                reflectionPrompts: ["sec_vc_reflection_7"],
                glossaryTerms: ["Venture Capital", "Private Equity", "Impact Investing"],
                relatedResearch: []
            ),

            // MARK: - Section 8: Risk Framework
            Section(
                id: "sec_vc_8",
                title: "8. Risk Framework — What You Need to Know Before You Invest_",
                content: [
                    .text("Private investing carries risks that are structurally different from public markets — and that are easy to underestimate when the return narratives are compelling. This section is designed to give you a clear-eyed accounting before you commit any capital."),

                    .heading("8.1 The Base Rate — Most VC Funds Underperform_", level: 3),
                    .callout(title: "The Uncomfortable Truth", content: "The Kauffman Foundation analyzed their own 20-year, $3.1 billion VC portfolio and found that only 20 of 100 funds generated returns sufficient to justify the fees, risks, and illiquidity of VC. Most fund managers delivered returns below comparable public equity benchmarks.\n\nMedian VC funds have historically generated net IRRs of 8–12% — comparable to or below the S&P 500 on a risk-adjusted basis.\n\nTop-quartile VC funds have generated 20–30%+ net IRR — significantly above public markets.\n\nThe critical insight: returns in VC are strongly concentrated in a small number of managers. Getting access to those managers is itself the primary challenge.\n\nSource: Kauffman Foundation, 'We Have Met the Enemy and He Is Us,' 2012¹⁴", type: .warning),
                    .statistic(value: "~3–4%", label: "Private equity annual outperformance over the S&P 500 (net of fees, 1986–2019)", context: "Harris, Jenkinson & Kaplan, Journal of Finance — but this average masks enormous dispersion between top and bottom quartile managers¹⁵"),

                    .heading("8.2 Illiquidity Risk_", level: 3),
                    .callout(title: "The Lock-Up Reality", content: "Private fund investments have a typical 7–12 year lock-up with no guaranteed exit mechanism. You cannot redeem your capital — you wait for the GP to exit investments and distribute proceeds.\n\nThe secondary market provides some liquidity: LPs can sell fund interests to secondary buyers (Lexington Partners, Hamilton Lane, Ardian). However:\n• Secondary sales typically occur at a 10–30% discount to NAV\n• Not all LP interests find buyers\n• The GP must approve transfers\n• Transaction costs are significant\n\nRule: Never invest capital you may need within 10 years.", type: .warning),

                    .heading("8.3 The J-Curve — Preparing for the Valley_", level: 3),
                    .text("In the first 3–5 years of a fund: capital is called and deployed (cash out), management fees reduce reported NAV, portfolio companies are valued at cost (conservative accounting), and no distributions occur yet. TVPI and DPI look poor regardless of underlying investment quality."),
                    .callout(title: "The 'Valley of Death' for New LPs", content: "Many first-time LP investors, unfamiliar with the J-curve, become alarmed by early negative performance signals and regret their commitment. Some attempt to sell at a secondary discount.\n\nThose who hold through the valley typically see the J-curve inflect as portfolio companies mature and exits begin.\n\nBefore committing: model out your capital call schedule and the J-curve explicitly. Do not judge performance for the first 3–5 years against public market benchmarks.", type: .tip),

                    .heading("8.4 Manager Risk — The Most Critical Variable_", level: 3),
                    .callout(title: "Manager Persistence in VC", content: "Unlike public markets, past performance in VC has historically been predictive of future performance — GPs in the top quartile are significantly more likely to be top-quartile in subsequent funds.\n\nThis is why access to top-tier GPs is itself the primary return driver — and why network exclusion of women from these relationships has direct financial consequences.\n\nSource: Braun, Jenkinson & Stoff, Journal of Finance, 2017¹⁶", type: .keyPoint),

                    .heading("8.5 Power Law and Diversification_", level: 3),
                    .callout(title: "The Power Law Distribution", content: "In a diversified VC portfolio, approximately 6% of deals generate 60% of returns, and 50%+ of deals return zero.\n\nThis is the power law distribution that distinguishes VC from nearly every other asset class. It means:\n• A portfolio of fewer than 15–20 VC investments is insufficiently diversified\n• The chance of missing the outlier return in a small portfolio is very high\n• Individual SPV investing without broader diversification carries enormous concentration risk\n• Fund-of-funds and platforms exist partly to solve this diversification problem for smaller LPs", type: .warning),

                    .heading("8.6 How Much Should Be in Alternatives?_", level: 3),
                    .callout(title: "Portfolio Allocation Guidance", content: "There is no universal rule, but common frameworks:\n\n• General wealth management guidance: 5–15% of total investable assets in illiquid alternatives for HNW individuals, depending on liquidity needs and time horizon\n• Large family offices and ultra-HNW investors: 20–40%+\n• Yale Endowment (David Swensen's model): 40%+ in private equity and VC — but this requires institutional-grade access and multi-decade commitment most individuals cannot replicate\n\nCritical caveat: Individual investors typically lack vintage year diversification that endowments achieve by investing in 30–50 funds simultaneously. A single VC fund commitment has far higher variance than an endowment's blended VC allocation.", type: .tip),
                    .statistic(value: "5–15%", label: "Suggested alternatives allocation for high-net-worth individual investors", context: "General wealth management guidance — varies significantly based on liquidity needs, time horizon, and total portfolio size"),

                    .heading("8.7 Vintage Year Risk_", level: 3),
                    .bulletList([
                        "Funds that deployed capital during recessions (2009–2010, 2020) benefited from lower entry valuations and often generated strong returns.",
                        "Funds that deployed aggressively at peak valuations (2000, 2007, 2021–2022) suffered as those valuations corrected.",
                        "Average pre-money valuations fell 40–60% from 2021 peaks by 2023 — the 2021 VC vintage is widely expected to perform poorly.",
                        "Strategy: Commit across multiple vintage years (2020, 2022, 2024) rather than concentrating in one year. This is called vintage year diversification."
                    ]),

                    .heading("8.8 The Case for Selectivity — Not Avoidance_", level: 3),
                    .callout(title: "The Right Frame", content: "The data in this section is not an argument against VC and PE investing. It is an argument for selectivity.\n\nTop-quartile managers in private equity have outperformed the S&P 500 by 3–4% annually over three decades. Top-quartile VC funds have generated 20–30%+ IRR. The women-led companies and funds that are currently underfunded represent a structural inefficiency — one that disciplined investors with gender-lens frameworks can potentially exploit.\n\nThe tools to do this well are now more accessible than at any point in history: lower minimums, better platforms, more transparent reporting, and a growing community of women who are building the networks and track records that create future access.", type: .keyPoint),

                    .divider,
                    .callout(title: "Legal Disclaimer", content: "This module is for educational purposes only. It is not financial advice, investment advice, or a solicitation to invest in any particular fund, SPV, or security. All investment decisions require your own due diligence and, ideally, consultation with a qualified financial professional. Past performance does not indicate future results. Alternative investments involve significant risk, including the possible loss of the entire amount invested.", type: .info)
                ],
                isCollapsible: true,
                level: 2,
                reflectionPrompts: ["sec_vc_reflection_8"],
                glossaryTerms: ["Risk-Adjusted Return", "Illiquidity Premium", "Correlation", "Volatility"],
                relatedResearch: []
            )

        ],
        reflectionPrompts: VCReflectionPrompts.all,
        quizzes: [],
        caseStudies: VCCaseStudies.all,
        estimatedTime: 75,
        tags: ["Venture Capital", "Private Equity", "Gender Lens", "Advanced", "SPV", "Due Diligence", "Investing"],
        parentModuleId: nil,
        isBonus: false
    )
}

// MARK: - Reflection Prompts

struct VCReflectionPrompts {
    static let all: [ReflectionPrompt] = [
        ReflectionPrompt(
            id: "reflect_vc_1",
            question: "After reading about the LP/GP structure and the J-curve, what surprised you most about how private funds actually work? What assumptions did you hold before that have shifted?",
            context: "Most people entering private investing have mental models built from public market experience. The blind pool, the capital call schedule, and the 10-year lock-up are genuinely different from anything in public markets. Naming the shift is the first step.",
            relatedSections: ["sec_vc_1"]
        ),
        ReflectionPrompt(
            id: "reflect_vc_2",
            question: "The data shows that all-women founding teams received just 2% of U.S. venture capital in 2023 — while research shows they generate stronger returns on invested capital. What does this gap tell you about how markets actually work versus how they are supposed to work?",
            context: "This is one of the clearest examples of a market inefficiency driven by structural bias rather than performance data. The implications for investors who understand this — and can act on it — are significant.",
            relatedSections: ["sec_vc_2"]
        ),
        ReflectionPrompt(
            id: "reflect_vc_3",
            question: "Of the pathways into private markets outlined — angel networks, syndicates, platforms, direct LP investing, emerging managers — which feels most accessible given your current situation? What is the first concrete step you would need to take?",
            context: "The distance between 'interested' and 'invested' in private markets is mostly information and network, not capital. For many accredited investors, the barrier is knowing which door to knock on.",
            relatedSections: ["sec_vc_3"]
        ),
        ReflectionPrompt(
            id: "reflect_vc_4",
            question: "If you were to lead an SPV today — finding a deal, setting up the legal structure, and bringing in co-investors — what would be the biggest obstacle? What would you need to learn or build first?",
            context: "The SPV model democratizes the lead investor role. Many successful SPV leads started with one deal in an industry they knew deeply as an operator or expert — not as a finance professional.",
            relatedSections: ["sec_vc_4"]
        ),
        ReflectionPrompt(
            id: "reflect_vc_5",
            question: "Looking at the due diligence question frameworks, which questions would you feel most confident asking a GP today? Which would you need to understand better before you could evaluate the answer? What does that tell you about where to focus your learning?",
            context: "Due diligence is a skill, not a checklist. The questions you cannot yet evaluate the answers to are a precise roadmap for what to learn next.",
            relatedSections: ["sec_vc_5"]
        ),
        ReflectionPrompt(
            id: "reflect_vc_6",
            question: "Have you had a conversation with a financial advisor about private investing before? If so, how did it go? If not, what has held you back? After reading this section, what would you do differently?",
            context: "Many women report feeling dismissed or underestimated in financial advisory conversations. The tools in this section — specific, technical questions — shift the power dynamic of that conversation.",
            relatedSections: ["sec_vc_6"]
        ),
        ReflectionPrompt(
            id: "reflect_vc_7",
            question: "Of the books, organizations, and resources listed — which three resonate most with where you are in your investing journey right now, and why? What would you want to read or join first?",
            context: "The most valuable resource is the one you will actually use. Your answer to this question is itself a useful signal about what kind of investor you are becoming.",
            relatedSections: ["sec_vc_7"]
        ),
        ReflectionPrompt(
            id: "reflect_vc_8",
            question: "The Kauffman Foundation found that most VC funds underperform public markets after fees. How does that change — or not change — your interest in this asset class? What would need to be true for VC to make sense as part of your portfolio?",
            context: "The honest answer is that VC is not appropriate for everyone, and not appropriate for all of anyone's portfolio. The question is not whether to engage, but how much, through which vehicles, and with which managers. This question is about building your own framework.",
            relatedSections: ["sec_vc_8"]
        )
    ]
}

// MARK: - Case Studies

struct VCCaseStudies {
    static let all: [CaseStudy] = [
        CaseStudy(
            id: "cs_vc_1",
            title: "Arlan Hamilton and the Emerging Manager Model",
            scenario: "Arlan Hamilton founded Backstage Capital while experiencing homelessness — pitching a fund thesis that underrepresented founders were systematically underfunded relative to their performance. She used SPVs and rolling funds before raising a traditional closed-end fund.",
            context: "Backstage Capital invests exclusively in companies led by underrepresented founders — women, people of color, LGBTQ+ entrepreneurs. The fund has made 200+ investments across 30+ SPVs and multiple funds.",
            keyQuestions: [
                "How did Hamilton's thesis (underrepresented founders are mispriced by the market) function as an investment argument, not just an equity argument?",
                "Why do SPVs and rolling funds lower the barrier to starting an investment vehicle compared to a traditional closed-end fund?",
                "What does Backstage Capital's sourcing advantage illustrate about network access and deal flow in VC?"
            ],
            suggestedAnswers: [
                "If a group of founders is systematically underfunded relative to their performance, the market is mispricing their risk — creating an opportunity for investors who understand this. Hamilton's thesis is a classic contrarian value argument.",
                "SPVs allow deal-by-deal raising without the infrastructure of a full fund vehicle. Rolling funds accept quarterly commitments from LPs, creating ongoing capital without a single fund close event. Both structures reduce the capital and legal overhead required to start.",
                "Founders from underrepresented backgrounds are more likely to take meetings with investors who share their experience or explicitly signal alignment. This gives Backstage access to deal flow that traditional VC networks cannot easily access."
            ],
            learningFocus: ["Emerging Manager", "SPV Structures", "Gender Lens Investing", "Network Effects"],
            relatedSection: "sec_vc_3",
            source: "Backstage Capital; Arlan Hamilton, 'It's About Damn Time,' 2020"
        ),
        CaseStudy(
            id: "cs_vc_2",
            title: "The 2% Funding Statistic — What It Means for Investors",
            scenario: "In 2023, all-women founding teams received 2% of total U.S. VC dollars — the lowest figure since 2016. BCG/MassChallenge research shows women-founded companies generate $0.78 revenue per $1 invested vs. $0.31 for male-founded companies.",
            context: "This data points to a structural market inefficiency: companies with stronger capital efficiency are receiving less capital, and at lower valuations. For investors who understand this, it implies uncrowded opportunity — particularly at early stages before institutional capital enters.",
            keyQuestions: [
                "If women-founded companies are more capital-efficient but receive lower valuations, what is the investment implication for early-stage angels and seed investors?",
                "Why does the funding gap widen at Series B and beyond, and what does that mean for portfolio construction?",
                "What does the gap cost the overall VC industry in terms of returns left on the table?"
            ],
            suggestedAnswers: [
                "Lower entry valuations + stronger capital efficiency = better return potential for early-stage investors who can identify these companies before Series A institutional investors enter at higher valuations.",
                "The gap widens later because Series B decisions are increasingly driven by existing investor networks and social proof — both of which disadvantage women-founded companies. Early-stage investors who identify and back strong women-founded companies before Series B can capture the most growth.",
                "If top-performing companies are being systematically passed over, the industry is leaving returns unrealized. The Kauffman Fellows research suggesting gender-diverse funds have stronger DPI is consistent with this thesis."
            ],
            learningFocus: ["Gender Lens Investing", "Market Inefficiency", "Portfolio Construction", "Due Diligence"],
            relatedSection: "sec_vc_2",
            source: "Pitchbook/NVCA Venture Monitor Q4 2023; BCG/MassChallenge 2018; Kauffman Fellows 2021"
        )
    ]
}

// MARK: - Footnotes
extension VentureCapitalModuleData {
    static let footnotes: [String: String] = [
        "1": "Preqin, 'Global Private Equity & Venture Capital Report 2024.' Global PE dry powder as of Q1 2024. https://www.preqin.com",
        "2": "Jefferies, 'Global Secondary Market Review 2024.' H1 2023 global secondary transaction volume.",
        "3": "All Raise, 'VC Diversity in Numbers 2022.' Annual survey of U.S. venture firm partner demographics. https://www.allraise.org",
        "4": "Diversio, analysis of Pitchbook data on VC fund manager demographics, 2022. https://diversio.com",
        "5": "Deloitte / All Raise, 'Women in the VC Ecosystem 2023.' Senior investing role demographics at U.S. VC firms.",
        "6": "Pitchbook / NVCA, 'Venture Monitor Q4 2023.' Annual venture capital investment data including gender breakdowns. https://nvca.org/research",
        "7": "Pitchbook, '2022 VC Female Founders Report.' Valuation analysis by founder gender at seed stage.",
        "8": "First Round Capital, '10 Years of Venture Capital: How Times Have Changed.' Portfolio performance analysis, 2015. http://10years.firstround.com",
        "9": "BCG / MassChallenge, 'Why Women-Owned Startups Are a Better Bet.' 2018. https://www.bcg.com/publications/2018/why-women-owned-startups-are-better-bet",
        "10": "Peterson Institute for International Economics, 'Is Gender Diversity Profitable? Evidence from a Global Survey.' Marcus Noland, Tyler Moran, Barbara Kotschwar, 2016.",
        "11": "Kauffman Fellows, 'When Women Invest, Returns Rise.' 2021. Analysis of VC fund performance by GP gender composition. https://www.kauffmanfellows.org",
        "12": "Kanze, Dana et al., 'We Ask Men to Win & Women Not to Lose: Closing the Gender Gap in Startup Funding.' Academy of Management Journal, 2018. Based on 2013–2014 TechCrunch Disrupt pitch data.",
        "13": "Brooks, Alison Wood et al., 'Investors Prefer Entrepreneurial Ventures Pitched by Attractive Men.' Proceedings of the National Academy of Sciences, 2014.",
        "14": "Kauffman Foundation, 'We Have Met the Enemy and He Is Us: Lessons from Twenty Years of the Kauffman Foundation's Investments in Venture Capital Funds.' May 2012. https://www.kauffman.org",
        "15": "Harris, Robert S., Tim Jenkinson, and Steven N. Kaplan. 'Private Equity Performance: What Do We Know?' Journal of Finance, 2014; updated analysis 2021.",
        "16": "Braun, Reiner, Tim Jenkinson, and Ingo Stoff. 'How Persistent Is Private Equity Performance? Evidence from Deal-Level Data.' Journal of Financial Economics, 2017."
    ]
}
