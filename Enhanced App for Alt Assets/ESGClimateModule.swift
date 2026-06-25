//
//  ESGClimateModule.swift
//  Enhanced App for Alt Assets
//
//  Created by Victoria Case on 2/10/26.
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//
//  Description: Climate, Energy & Real World Assets module.
//  Source: Notion — Climate, Energy & Real World Assets (RWAs)
//  Rewritten from Notion source 2026-06-24.
//

import Foundation

// MARK: - ESG Climate Module Data
struct ESGClimateModuleData {

    static let esgClimateModule = Module(
        id: "mod_esg_climate",
        title: "Climate, Energy & Real World Assets",
        description: "A case for ESG investing — from foundations to financial flows, project finance, carbon markets, water rights, transition metals, and the circular economy.",
        icon: "🌍",
        color: "green",
        heroImageName: "hero_climate_energy_rwa",
        sections: [

            // MARK: - Section 1
            Section(
                id: "sec_esg_1",
                title: "1. Foundations of ESG & Sustainability Investing_",
                content: [
                    .callout(title: "Disclaimer", content: "This is not financial advice or a recommendation for any investment. The content is for informational purposes only. You should not construe any information or material here as legal, tax, investment, or financial advice.", type: .warning),
                    .text("Environmental, Social, and Governance (ESG) investing represents a structural evolution in how capital markets price risk, opportunity, and long-term value creation. While early forms of socially responsible investing (SRI) were rooted primarily in ethical exclusions — such as avoiding tobacco, weapons, or apartheid-linked companies — modern ESG investing integrates financially material sustainability factors directly into valuation frameworks and portfolio construction."),
                    .callout(title: "ESG Defined", content: "ESG criteria are a set of standards for a company's operations that socially conscious investors use to screen potential investments.\n\n• Environmental: Climate impact, resource use, waste\n• Social: Labor practices, diversity, community relations\n• Governance: Board structure, executive pay, transparency", type: .definition),
                    .text("The intellectual shift from values-based exclusion to financially material integration accelerated after the 2008 global financial crisis, which exposed governance failures, excessive risk-taking, and weak oversight mechanisms across financial institutions. Governance — particularly board independence, executive compensation alignment, and shareholder rights — became increasingly recognized as central to risk management and corporate resilience.¹"),
                    .heading("Environmental Risk as Financial Risk_", level: 3),
                    .text("The 'E' dimension gained prominence as climate change moved from being considered a reputational issue to a systemic financial risk. The landmark report by the Task Force on Climate-related Financial Disclosures (TCFD) framed climate change as a source of both physical risk (damage from extreme weather events) and transition risk (policy changes, technological disruption, stranded assets).² This was reinforced by the Network for Greening the Financial System (NGFS), a coalition of central banks that warned climate risk could pose threats to financial stability if not adequately priced.³"),
                    .heading("Social Factors_", level: 3),
                    .text("The 'S' dimension expanded significantly during the COVID-19 pandemic, when labor conditions, supply chain resilience, healthcare access, and human capital management became visible drivers of corporate performance. Research from Harvard Business School demonstrated that companies with strong employee satisfaction outperformed during crisis periods, highlighting human capital as a material asset rather than a peripheral ethical consideration.⁴"),
                    .statistic(value: "$30T+", label: "Global sustainable investment assets", context: "Global Sustainable Investment Alliance (GSIA)⁵"),
                    .callout(title: "ESG vs. Impact Investing", content: "These are not the same thing.\n\nESG integration primarily seeks to enhance risk-adjusted returns by incorporating additional data into financial analysis.\n\nImpact investing explicitly targets measurable environmental or social outcomes alongside financial returns.⁶\n\nUnderstanding this distinction is foundational for investors building climate- or sustainability-focused portfolios.", type: .keyPoint)
                ],
                isCollapsible: true,
                level: 2,
                reflectionPrompts: ["sec_esg_reflection_1"],
                glossaryTerms: ["ESG", "Sustainable Investing", "Impact Investing"],
                relatedResearch: []
            ),

            // MARK: - Section 2
            Section(
                id: "sec_esg_2",
                title: "2. Do You Sacrifice Returns?_",
                content: [
                    .text("One of the most persistent critiques of ESG and sustainability investing is the claim that investors must sacrifice financial returns to align portfolios with environmental or social goals. This assumption largely stems from early SRI models that relied heavily on exclusionary screening — removing entire sectors such as tobacco, firearms, or fossil fuels. Critics argued that restricting the investable universe would reduce diversification and therefore diminish risk-adjusted returns."),
                    .text("However, the empirical evidence over the past decade suggests a far more nuanced and often contradictory reality."),
                    .keyFact(emoji: "📈", title: "H1 2025 Performance", value: "12.5% median return", source: "Morgan Stanley Institute for Sustainable Investing¹"),
                    .text("In the first six months of 2025, sustainable funds posted a median return of 12.5%, compared to traditional funds' 9.2%. This continues a pattern observed over the past five years, where sustainable funds delivered superior median returns in eight of ten half-year intervals.¹"),
                    .statistic(value: "2.6x", label: "Greater shareholder returns", context: "Companies consistently scoring high on ESG factors (2013–2020)²"),
                    .text("A comprehensive meta-analysis reviewed more than 2,000 empirical studies and found that approximately 90% identified a non-negative relationship between ESG criteria and corporate financial performance, with the majority showing positive correlations.⁷ The NYU Stern Center for Sustainable Business found that 58% of corporate studies demonstrated a positive relationship between ESG and financial performance, while only 8% showed negative results.⁸"),
                    .callout(title: "Why Materiality Matters", content: "Research from Harvard Business School found that companies excelling on financially material ESG issues — those directly tied to their business models — outperformed firms that scored highly only on immaterial sustainability factors.⁹\n\nESG integration appears most effective when it focuses on issues that directly affect cash flows, operational risk, regulatory exposure, and competitive positioning.", type: .research),
                    .heading("Performance Dispersion_", level: 3),
                    .text("ESG funds often display sector tilts, frequently overweighting technology and underweighting traditional energy or extractive industries. During commodity booms or fossil fuel rallies, ESG portfolios may underperform broad benchmarks. Conversely, during periods of regulatory tightening, carbon pricing implementation, or rapid renewable energy adoption, ESG-tilted portfolios may outperform."),
                    .text("The question is not whether ESG always outperforms, but whether it improves risk-adjusted returns over full market cycles. Increasingly, the research suggests that when applied with financial rigor, ESG integration does not systematically reduce returns and may enhance long-term resilience."),
                    .callout(title: "A Note of Caution", content: "The market is still deciding how — and whether — it will integrate ESG assets from a returns standpoint. 'Green' assets have sometimes underperformed 'brown' assets in certain periods. Effective ESG integration requires rigorous data, forward-looking metrics, and scenario analysis — not simple labels or surface-level scores.", type: .warning)
                ],
                isCollapsible: true,
                level: 2,
                reflectionPrompts: ["sec_esg_reflection_2"],
                glossaryTerms: ["ESG Performance", "Materiality", "Risk-Adjusted Returns"],
                relatedResearch: []
            ),

            // MARK: - Section 2.1
            Section(
                id: "sec_esg_2_1",
                title: "2.1 The Current State of ESG Investing (2026)_",
                content: [
                    .heading("Performance: The 2025 Rebound_", level: 3),
                    .bulletList([
                        "Sustainable funds returned 12.5% in H1 2025, vs. 9.2% for traditional funds — the strongest outperformance since 2019¹⁰",
                        "A hypothetical $100 invested in December 2018 in a sustainable fund would be worth $136 by end of 2024, vs. $131 in a traditional fund¹¹",
                        "Global sustainable fund assets reached $3.92 trillion by June 2025 — a new high¹²"
                    ]),
                    .callout(title: "What This Means for Your Portfolio", content: "ESG strategies perform differently across market cycles — 2022 underperformed, 2023–2024 was mixed, 2025 rebounded strongly. Over extended horizons, the data supports competitive risk-adjusted returns.", type: .tip),
                    .heading("Fund Flows: A Story of Three Regions_", level: 3),
                    .text("The global ESG market is increasingly divergent across geographies."),
                    .callout(title: "United States", content: "Eleven consecutive quarters of outflows through Q2 2025. Political backlash during 2025–2026 intensified anti-ESG sentiment. Thirteen states have enacted laws prohibiting ESG factors in public pension investments.¹⁴ Many firms have scaled back ESG marketing — a practice termed 'greenhushing.'¹⁵", type: .warning),
                    .callout(title: "Europe", content: "Regulatory maturation rather than retrenchment. ~1,346 funds representing ~$1 trillion in assets were renamed in response to EU anti-greenwashing rules — dropping 'ESG' from names while largely maintaining underlying strategies.¹⁷ SFDR, CSRD, and EU Taxonomy are now embedded in the financial system.", type: .research),
                    .callout(title: "Asia-Pacific", content: "Growth leader. ESG ETFs expanding ~10% annually, expected to reach $50 billion by 2025.¹⁸ Taiwan accounts for more than half of regional ESG assets. Thailand offers tax incentives of up to 30% deductions for ESG fund investments.¹⁹ China introduced voluntary ESG standards in late 2024, with a comprehensive framework anticipated by 2030.²⁰", type: .example),
                    .heading("The Rebranding Wave_", level: 3),
                    .text("As European anti-greenwashing rules moved toward implementation in June 2025, hundreds of funds removed 'ESG' or 'sustainable' from their names. Many adopted alternative descriptors — 'transition,' 'select,' 'screened,' 'committed,' or 'tilt.' The majority of rebranded funds continue to apply ESG screening within their investment processes — it is the terminology that has shifted, not the underlying strategy.²¹"),
                    .callout(title: "Don't Judge a Fund by Its Name", content: "Focus on:\n• Actual holdings and exclusions\n• ESG integration methodologies\n• Impact measurement and reporting\n• Regulatory classification (EU Article 8 vs Article 9)", type: .keyPoint),
                    .heading("Regulatory Landscape_", level: 3),
                    .bulletList([
                        "United States: SEC climate disclosure rules paused; DOL amended ERISA guidance; state-level divergence between pro-ESG (California, Oregon, Illinois) and anti-ESG (Texas, Florida) legislation",
                        "Europe: CSRD in force; SFDR formalizes Article 8 ('light green') and Article 9 ('dark green') fund classifications; EU Taxonomy defines sustainable economic activity",
                        "Asia-Pacific: Hong Kong and Singapore mandate climate reporting from 2025; Japan has tightened ESG fund regulations; China building comprehensive framework by 2030"
                    ]),
                    .heading("Integration Strategies in Practice_", level: 3),
                    .text("As of 2025, ESG integration is now mainstream among sustainable investors:²⁴"),
                    .bulletList([
                        "~81% use comprehensive ESG integration",
                        "~75% use exclusionary screening",
                        "~68% explicitly exclude fossil fuels",
                        "~62% apply five or more negative screens"
                    ]),
                    .bulletList([
                        "ESG integration — systematic incorporation of financially material ESG factors into valuation",
                        "Best-in-class — selecting the strongest ESG performers within each sector",
                        "Thematic strategies — clean energy, water infrastructure, circular economy",
                        "Impact investing — measurable environmental or social outcomes alongside returns",
                        "Stewardship — proxy voting, shareholder resolutions, and corporate engagement"
                    ]),
                    .callout(title: "Emerging Priorities 2025–2026", content: "• AI-driven real-time ESG scoring\n• Nature and biodiversity capital (TNFD frameworks)\n• Just Transition — social implications of decarbonization embedded in portfolio construction\n• Transition finance — supporting high-emitting companies with credible decarbonization plans", type: .research),
                    .heading("Technology & Data: The AI Revolution_", level: 3),
                    .text("As of 2025, real-time ESG scoring systems continuously process new data inputs — news articles, earnings call transcripts, satellite imagery, supply chain disclosures — to provide up-to-date evaluations of corporate sustainability performance.²⁵"),
                    .callout(title: "Persistent Challenge: Rating Divergence", content: "Studies continue to show low correlation between major ESG rating agencies — MSCI, Sustainalytics, S&P, Bloomberg — reflecting differences in methodology, scope, and weighting.²⁶ Technology is improving transparency, but standardization is still evolving.", type: .warning),
                    .heading("Practical Guidance: Building an ESG Portfolio in 2026_", level: 3),
                    .numberedList([
                        "Define your objectives — risk management, impact-focused, values alignment, or blended approach",
                        "Understand your constraints — return expectations, risk tolerance, time horizon, potential lock-up periods, geographic exposure",
                        "Evaluate fund offerings — holdings transparency, ESG methodology, 3/5/10-year performance, expense ratios, impact reporting quality, regulatory classification",
                        "Monitor and adjust — review ESG metrics quarterly or annually; assess performance attribution; recalibrate as policies change",
                        "Engage and advocate — review proxy voting records; encourage advisors to prioritize stewardship"
                    ])
                ],
                isCollapsible: true,
                level: 2,
                reflectionPrompts: [],
                glossaryTerms: ["SFDR", "EU Taxonomy", "Greenwashing", "Greenhushing"],
                relatedResearch: []
            ),

            // MARK: - Section 3
            Section(
                id: "sec_esg_3",
                title: "3. The Paris Agreement & Financial Flows_",
                content: [
                    .text("The 2015 Paris Agreement represents a watershed moment in global climate policy — not only for its target of limiting warming to well below 2°C (with efforts toward 1.5°C), but for its explicit recognition that financial systems must be restructured to support climate goals. Article 2.1(c) commits signatories to 'making finance flows consistent with a pathway towards low greenhouse gas emissions and climate-resilient development.'²⁷"),
                    .statistic(value: "$3–5T", label: "Annual climate investment needed through 2030", context: "International Energy Agency²⁸"),
                    .text("Currently, global investment in clean energy and climate solutions falls significantly short of this target — what the United Nations Environment Programme has termed the 'climate finance gap.'²⁹"),
                    .statistic(value: "$130T", label: "Assets controlled by institutional investors globally", context: "Pension funds, sovereign wealth funds, insurance companies, asset managers³⁰"),
                    .text("How this capital is deployed will largely determine whether Paris targets are achievable."),
                    .callout(title: "Key Frameworks for Paris Alignment", content: "• Science Based Targets initiative (SBTi)³¹\n• Task Force on Climate-related Financial Disclosures (TCFD)³²\n• Network for Greening the Financial System (NGFS)³³\n\nParis alignment is not binary. A portfolio can support the energy transition through renewable energy deployment, investing in companies actively decarbonizing, supporting adaptation infrastructure, or financing breakthrough climate technologies.", type: .definition)
                ],
                isCollapsible: true,
                level: 2,
                reflectionPrompts: ["sec_esg_reflection_3"],
                glossaryTerms: ["Paris Agreement", "TCFD", "Climate Finance Gap", "Transition Risk"],
                relatedResearch: []
            ),

            // MARK: - Section 3.1
            Section(
                id: "sec_esg_3_1",
                title: "3.1 Where We Are in 2026_",
                content: [
                    .callout(title: "Global Emissions Trajectory", content: "Current policies place the world on track for approximately 2.5–3°C of warming by 2100.³⁴ To achieve 1.5°C requires cutting global emissions by roughly 43% by 2030 relative to 2019 levels.³⁵", type: .warning),
                    .heading("Sector-Specific Progress_", level: 3),
                    .bulletList([
                        "Renewable Energy: Global renewable electricity capacity grew by over 50% between 2019 and 2024, with solar and wind increasingly cost-competitive with fossil fuels even without subsidies³⁶",
                        "Electric Vehicles: EV sales surpassed 14 million units globally in 2024, approximately 18% of new car sales³⁷",
                        "Corporate Commitments: Over 5,000 companies have set science-based emissions reduction targets, covering roughly $38 trillion in market capitalization³⁸"
                    ]),
                    .heading("Financial Flows_", level: 3),
                    .keyFact(emoji: "💵", title: "Clean Energy Investment (2024)", value: "$1.8 trillion", source: "Record high, but still below the $3–5T needed annually³⁹"),
                    .keyFact(emoji: "⛽", title: "Oil & Gas Investment (2024)", value: "$500 billion", source: "Global exploration and production⁴⁰"),
                    .heading("Policy Landscape (2025–2026)_", level: 3),
                    .bulletList([
                        "United States: Rollback of climate policies — EPA greenhouse gas regulations paused, withdrawal from international climate finance commitments, potential re-exit from Paris Agreement⁴¹",
                        "European Union: Maintaining climate leadership — Carbon Border Adjustment Mechanism (CBAM), expanded emissions trading systems, continued European Green Deal support⁴²",
                        "China: Installed more solar capacity in 2023 than the entire world did in 2022⁴³",
                        "Developing Nations: Climate finance remains contentious — unfulfilled $100 billion annual pledge from wealthy nations, demands for greater adaptation and loss-and-damage support⁴⁴"
                    ]),
                    .heading("Physical Climate Impacts (2024–2026)_", level: 3),
                    .bulletList([
                        "2024 confirmed as the warmest year on record globally, exceeding pre-industrial temperatures by approximately 1.5°C for extended periods⁴⁵",
                        "Extreme weather events caused hundreds of billions in economic damages⁴⁶",
                        "Major insurers have withdrawn from high-risk markets in California, Florida, and Louisiana⁴⁷"
                    ]),
                    .callout(title: "The Investment Thesis", content: "The world is in the middle of a messy, uneven, but ultimately inevitable energy transition.\n\nRisks: Stranded assets, physical risk to real estate and agriculture, transition risk for slow-moving companies, litigation risk\n\nOpportunities: Climate solutions (renewables, storage, grid), adaptation infrastructure, transition finance for high-emitters with credible plans, breakthrough innovation (hydrogen, carbon capture, sustainable aviation fuels)", type: .keyPoint)
                ],
                isCollapsible: true,
                level: 2,
                reflectionPrompts: [],
                glossaryTerms: ["Stranded Assets", "Carbon Border Adjustment Mechanism", "Physical Risk"],
                relatedResearch: []
            ),

            // MARK: - Section 3.2
            Section(
                id: "sec_esg_3_2",
                title: "3.2 Investors as Market Movers_",
                content: [
                    .text("As of 2025, global institutional investors manage approximately $130 trillion in assets⁴⁹ — roughly equivalent to 120% of global GDP. Pension funds alone account for more than $50 trillion.⁵⁰"),
                    .heading("How Investors Move Markets_", level: 3),
                    .numberedList([
                        "Capital allocation: Firms with weak environmental or governance profiles may encounter a higher cost of capital⁵¹",
                        "Active ownership and stewardship: Climate Action 100+, representing over $68 trillion in assets, brings investors together to engage the world's largest corporate emitters⁵²",
                        "Policy advocacy: The IIGCC, representing more than €60 trillion in assets, regularly interacts with policymakers⁵³",
                        "Disclosure standards: The ISSB issued global baseline sustainability disclosure standards in 2023; the TCFD is now supported by institutions representing over $150 trillion in assets⁵⁴ ⁵⁵"
                    ]),
                    .callout(title: "Case Study: Coal Divestment", content: "Between 2010 and 2025, over 1,500 institutions representing more than $40 trillion in assets committed to full or partial coal divestment.⁵⁶\n\nImpact mechanisms:\n• Declining valuations — coal company stocks underperformed broader indices⁵⁷\n• Capital constraints — access to equity and debt for new coal projects severely restricted in developed markets\n• Strategic shifts — BP, Shell, and TotalEnergies announced plans to exit or reduce coal holdings⁵⁸\n• Coal's share of global electricity generation peaked in 2013 and has declined steadily since⁵⁹", type: .example),
                    .callout(title: "Case Study: Renewable Energy Investment Surge", content: "Between 2010 and 2024, global investment in renewable energy exceeded $4 trillion.⁶⁰\n\n• Solar costs fell ~90%, wind costs ~70%⁶¹\n• China installed 216 GW of solar in 2023 alone⁶²\n• Created new asset classes: yield-cos, green bonds, renewable infrastructure funds\n• Attracted institutional capital seeking stable, inflation-hedged returns", type: .example)
                ],
                isCollapsible: true,
                level: 2,
                reflectionPrompts: [],
                glossaryTerms: ["Climate Action 100+", "ISSB", "Shareholder Engagement"],
                relatedResearch: []
            ),

            // MARK: - Section 4
            Section(
                id: "sec_esg_4",
                title: "4. How ESG Works Inside a Portfolio_",
                content: [
                    .text("Inside a portfolio, ESG implementation can vary significantly depending on objectives and mandate constraints. ESG integration incorporates financially material sustainability data into traditional valuation models, adjusting forecasts for regulatory risk, carbon pricing exposure, or governance weaknesses. Thematic strategies target sectors expected to benefit from structural shifts. Impact investing seeks measurable environmental outcomes alongside financial returns. Transition finance focuses on funding emissions reductions within high-carbon industries."),
                    .heading("Key Concepts in Carbon & Climate Investing_", level: 3),
                    .callout(title: "Additionality", content: "Ensures that a carbon credit represents a reduction or removal that would not have happened without the project.\n\nExample: A new wind farm in a region without prior renewable projects generates credits. If the wind farm would have been built anyway, the credits are not additional.", type: .definition),
                    .callout(title: "Permanence", content: "The durability of the carbon reduction or removal — it must last over time and not be reversed.\n\nExample: A forest carbon project stores carbon in trees for decades, whereas some agricultural practices may sequester carbon only temporarily.", type: .definition),
                    .callout(title: "Leakage", content: "Happens when emissions reduced in one area cause an increase in emissions elsewhere.\n\nExample: Protecting a forest in one country might push logging to a neighboring country, reducing the overall environmental gain.", type: .definition),
                    .callout(title: "Market Risks in Carbon", content: "• Price volatility: Carbon credit prices can fluctuate due to policy changes, supply-demand shifts, or market speculation\n• Regulatory shifts: Governments may alter rules for compliance markets or offset eligibility\n• Verification challenges: Ensuring projects are genuinely reducing emissions requires reliable monitoring and auditing", type: .warning),
                    .callout(title: "Tokenization Benefits", content: "Representation of carbon credits on a blockchain or digital ledger:\n• Efficiency: Easier and faster to buy, sell, or retire credits\n• Transparency: On-chain records make it easier to track ownership and retirement\n• Traceability: Each credit can be audited from issuance to retirement, reducing fraud or double-counting", type: .research),
                    .heading("Materiality Assessment_", level: 3),
                    .text("Materiality assessment is the foundation of financially rigorous ESG integration. The Sustainability Accounting Standards Board (SASB) developed industry-specific materiality maps to identify which sustainability factors are most likely to affect financial performance within a given sector.⁶⁷"),
                    .text("Forward-looking scenario analysis shifts the focus from current sustainability performance to future resilience. The NGFS provides climate scenario models ranging from an 'orderly transition' to a 'hothouse world.'⁶⁸"),
                    .heading("Rating Divergence_", level: 3),
                    .callout(title: "A Structural Challenge", content: "Research from MIT Sloan shows low correlation among major ESG rating agencies due to differences in methodology, scope, and weighting (Berg, Kölbel & Rigobon, 2022). Regulators have increasingly addressed greenwashing concerns, introducing stricter labeling and disclosure standards (SEC Enforcement Actions, 2024; UK FCA Consultation, 2025).", type: .warning)
                ],
                isCollapsible: true,
                level: 2,
                reflectionPrompts: ["sec_esg_reflection_4"],
                glossaryTerms: ["Additionality", "Permanence", "Carbon Credit", "SASB", "Greenwashing"],
                relatedResearch: []
            ),

            // MARK: - Section 5
            Section(
                id: "sec_esg_5",
                title: "5. Renewable Project Finance_",
                content: [
                    .text("The transition to a low-carbon economy depends on building vast renewable energy infrastructure — solar farms, wind parks, battery storage facilities, and upgraded electricity grids. Unlike public equities, where returns are often tied to short-term market sentiment, renewable project finance emphasizes long-term cash flows anchored in contractual agreements such as power purchase agreements (PPAs) that guarantee revenue streams for decades."),
                    .heading("Access Mechanisms_", level: 3),
                    .bulletList([
                        "Green bonds and climate-linked debt instruments",
                        "Infrastructure funds specializing in renewable assets",
                        "Public-private blended finance structures"
                    ]),
                    .heading("How Project Finance Differs from Public Equities_", level: 3),
                    .text("Project finance is a method of funding infrastructure where repayment depends on the cash flows generated by the project itself, rather than the balance sheet of the sponsoring company."),
                    .table(
                        headers: ["Feature", "Project Finance", "Public Equities"],
                        rows: [
                            ["Source of Returns", "Cash flows from the specific project (e.g., energy sold under a PPA)", "Company profits/dividends from overall operations"],
                            ["Risk Profile", "High upfront construction and operational risk, mitigated by contracts", "Market risk, business risk, and management decisions across the company"],
                            ["Investment Horizon", "Long-term, often 10–25 years", "Can be short- or long-term, liquid"],
                            ["Collateral / Security", "Project assets often serve as collateral", "Shares have no direct collateral; value depends on market price"],
                            ["Securitization Potential", "Cash flows can be bundled into bonds or loans for investors", "Public equities are already tradable but not project-specific"]
                        ],
                        caption: nil
                    ),
                    .callout(title: "For Learners", content: "Understanding renewable project finance requires a shift from traditional equity analysis. Investors must evaluate project viability, contractual cash flows, policy incentives, and technology risk.", type: .tip)
                ],
                isCollapsible: true,
                level: 2,
                reflectionPrompts: [],
                glossaryTerms: ["Power Purchase Agreement", "Green Bonds", "Blended Finance", "Infrastructure Fund"],
                relatedResearch: []
            ),

            // MARK: - Section 6
            Section(
                id: "sec_esg_6",
                title: "6. Water Rights & Natural Assets_",
                content: [
                    .text("Water is increasingly recognized as a scarce and investable resource, especially in regions facing chronic shortages. Water rights — legal entitlements to use a portion of a water source — can be traded, leased, or securitized, allowing them to function as financial assets."),
                    .heading("Natural Asset Companies (NACs)_", level: 3),
                    .text("Complementing tradable water rights, Natural Asset Companies (NACs) have emerged to monetize broader ecosystem services, including water retention, biodiversity preservation, and carbon sequestration."),
                    .heading("Critical Factors_", level: 3),
                    .bulletList([
                        "Valuation challenges — arise from climate variability, seasonal droughts, and changing regulatory frameworks",
                        "Ecosystem service markets — beyond carbon, markets now exist for water quality, soil health, biodiversity credits, and other ecosystem outcomes",
                        "Jurisdictional variation — Australia's Murray–Darling Basin offers a mature market; in the U.S., California and Colorado allow water rights to be leased or sold; Chile has developed localized trading in arid regions such as the Limarí Valley"
                    ]),
                    .callout(title: "Investment Focus", content: "This space rewards investors who can quantify environmental value, model scarcity-driven returns, and integrate ecosystem services into a diversified portfolio.", type: .keyPoint)
                ],
                isCollapsible: true,
                level: 2,
                reflectionPrompts: [],
                glossaryTerms: ["Water Rights", "Natural Asset Company", "Ecosystem Services"],
                relatedResearch: []
            ),

            // MARK: - Section 7
            Section(
                id: "sec_esg_7",
                title: "7. Energy Transition Metals & Commodities_",
                content: [
                    .text("The global energy transition relies on a set of critical metals — lithium, cobalt, nickel, copper, and rare earths — that power electric vehicles, batteries, grid infrastructure, and renewable energy technologies. Demand for these metals is growing rapidly alongside electrification, decarbonization, and the scaling of renewable infrastructure."),
                    .heading("Key Investor Considerations_", level: 3),
                    .bulletList([
                        "Supply chain risks and geopolitical dynamics — many of these metals are concentrated in politically sensitive regions",
                        "Price drivers — global demand, production capacity, and policy incentives",
                        "Exposure vehicles — futures markets, ETFs, and physical commodities",
                        "ESG considerations — mining and processing activities can have profound social and environmental impacts"
                    ]),
                    .callout(title: "The Circularity Connection", content: "Advanced aluminum and steel recycling can reduce energy costs by up to 90% compared to primary production, making recycling economics directly relevant to transition metal investing.", type: .research)
                ],
                isCollapsible: true,
                level: 2,
                reflectionPrompts: [],
                glossaryTerms: ["Critical Minerals", "Lithium", "Supply Chain Risk"],
                relatedResearch: []
            ),

            // MARK: - Section 8
            Section(
                id: "sec_esg_8",
                title: "8. Circular Economy & Nature-Based Solutions_",
                content: [
                    .text("As investors expand from climate-aligned asset classes — carbon markets, renewable infrastructure, water rights, transition metals, tokenized real-world assets — the natural next evolution is the circular economy: an investment theme that moves beyond managing externalities to redesigning how economic systems function."),
                    .callout(title: "What Is the Circular Economy?", content: "A structural shift away from the traditional 'take–make–dispose' linear production model toward a regenerative system in which materials are reused, repaired, recycled, and kept in productive circulation for as long as possible.\n\nThe Ellen MacArthur Foundation estimates transitioning to a circular economy in Europe alone could generate €1.8 trillion in net economic benefits by 2030.", type: .definition),
                    .statistic(value: "~45%", label: "of global GHG emissions from product manufacturing & material use", context: "Circularity Gap Report, Circle Economy 2023"),
                    .statistic(value: "$4.5T", label: "Global economic opportunity from circular economy by 2030", context: "World Economic Forum, 2020"),
                    .heading("Why Governments Are Investing in Circularity_", level: 3),
                    .bulletList([
                        "Circularity directly reduces emissions — nearly 45% of global GHGs stem from product manufacturing and material use",
                        "Resource security — critical minerals for energy transition are concentrated in geopolitically sensitive regions, making recycling a strategic priority",
                        "Job creation — the ILO estimates circular practices could generate millions of net new jobs in repair, recycling, remanufacturing, and logistics",
                        "EU Circular Economy Action Plan links circularity to industrial strategy, climate targets, and strategic autonomy; China has integrated circular principles into its Five-Year Plans"
                    ]),
                    .heading("Investment Approaches_", level: 3),
                    .text("Traditional ESG investing often involves screening public equities. Circular economy investing frequently involves direct exposure to operational models that close material loops — reuse, remanufacturing, recycling, product-as-a-service systems, bio-based materials, and industrial symbiosis."),
                    .heading("Public Markets Exposure_", level: 3),
                    .bulletList([
                        "Veolia and Suez — waste management, recycling, and water recovery",
                        "Tomra — reverse vending and materials sorting technology",
                        "DS Smith — recyclable packaging",
                        "Unilever and Interface — circular product design",
                        "BlackRock Circular Economy ETF (ECON)"
                    ]),
                    .heading("Private Markets_", level: 3),
                    .bulletList([
                        "Venture capital and growth equity funds: advanced recycling technologies, biodegradable materials, industrial biotechnology, digital platforms for material traceability",
                        "Specialized private equity funds and infrastructure vehicles",
                        "Blended finance structures bridging public and private capital"
                    ]),
                    .callout(title: "The Circular Business Model Advantage", content: "Circular business models often improve margin stability. The IEA notes that advanced aluminum and steel recycling can reduce energy costs by up to 90% compared to primary production — making sustainability and profitability mutually reinforcing at the operational level.", type: .keyPoint)
                ],
                isCollapsible: true,
                level: 2,
                reflectionPrompts: ["sec_esg_reflection_4"],
                glossaryTerms: ["Circular Economy", "Nature-Based Solutions", "Natural Capital"],
                relatedResearch: []
            )
        ],
        reflectionPrompts: ESGReflectionPrompts.all,
        quizzes: [ESGQuizzes.fundamentalsQuiz, ESGQuizzes.climateFinanceQuiz],
        caseStudies: ESGCaseStudies.all,
        estimatedTime: 60,
        tags: ["ESG", "Climate", "Sustainable Investing", "Green Bonds", "RWA", "Carbon Markets", "Circular Economy"],
        parentModuleId: nil,
        isBonus: false
    )
}

// MARK: - ESG Reflection Prompts
struct ESGReflectionPrompts {
    static let all: [ReflectionPrompt] = [
        ReflectionPrompt(
            id: "sec_esg_reflection_1",
            question: "How do you currently factor environmental, social, or governance considerations into your financial decisions — investment or otherwise? What would need to change for you to prioritize ESG more?",
            context: "Reflect on your personal values and how they align — or conflict — with your approach to money.",
            relatedSections: ["sec_esg_1"]
        ),
        ReflectionPrompt(
            id: "sec_esg_reflection_2",
            question: "The research suggests ESG investing doesn't require sacrificing returns — yet many people assume it does. Where do you think that assumption comes from? Has it shaped your own thinking?",
            context: "Consider how narratives about investing shape behavior, and whether the data changes your perspective.",
            relatedSections: ["sec_esg_2"]
        ),
        ReflectionPrompt(
            id: "sec_esg_reflection_3",
            question: "The Paris Agreement asks financial systems to realign toward climate goals. As an individual investor, how much agency do you feel you have in that? Does the scale of the challenge energize or overwhelm you?",
            context: "There is no right answer. This is about locating yourself in a global conversation.",
            relatedSections: ["sec_esg_3"]
        ),
        ReflectionPrompt(
            id: "sec_esg_reflection_4",
            question: "If you were to redesign part of your financial life with circular economy principles — reduce waste, extend the life of assets, close loops — what would that look like? Where would you start?",
            context: "Apply the module's concepts beyond the portfolio — to consumption, savings, and the systems you participate in.",
            relatedSections: ["sec_esg_8"]
        ),
        ReflectionPrompt(
            id: "sec_esg_reflection_5",
            question: "Green bonds and sustainability-linked loans now represent over $1 trillion in annual issuance. Does scale make the instrument more credible to you — or does it make greenwashing harder to detect?",
            context: "The growth of a market can be evidence of validation or of narrative capture. Which frame feels more accurate to you?",
            relatedSections: ["sec_esg_5"]
        ),
        ReflectionPrompt(
            id: "sec_esg_reflection_6",
            question: "Real-world assets tokenized on-chain — carbon credits, infrastructure, land — promise transparency but introduce new technical risks. What is your honest level of understanding of those risks right now?",
            context: "Knowing where your knowledge ends is the first step to managing exposure.",
            relatedSections: ["sec_esg_6"]
        ),
        ReflectionPrompt(
            id: "sec_esg_reflection_7",
            question: "Scope 3 emissions are the hardest to measure and often the largest portion of a company's footprint. How do you factor in what a company reports versus what it obscures?",
            context: "Disclosure is not the same as transparency. Where do you place the burden of proof when evaluating corporate ESG claims?",
            relatedSections: ["sec_esg_4"]
        ),
        ReflectionPrompt(
            id: "sec_esg_reflection_8",
            question: "If your entire portfolio shifted to ESG-aligned holdings tomorrow, which of your current investments would you miss the most — and what does that tell you about your real priorities?",
            context: "The gap between stated values and actual behavior is where the most honest self-knowledge lives.",
            relatedSections: ["sec_esg_1"]
        )
    ]
}

// MARK: - ESG Quizzes
struct ESGQuizzes {
    static let fundamentalsQuiz = Quiz(
        id: "quiz_esg_fundamentals",
        title: "ESG Fundamentals",
        description: "Test your understanding of ESG investing principles and current market landscape.",
        questions: [
            QuizQuestion(
                id: "q_esg_1",
                question: "What does the 'G' in ESG stand for, and why did it gain prominence after 2008?",
                options: [
                    "Growth — because markets rebounded strongly",
                    "Governance — because the crisis exposed failures in board oversight and risk management",
                    "Green — because climate became a priority",
                    "Global — because investing went international"
                ],
                correctAnswerIndex: 1,
                explanation: "Governance — board independence, executive compensation alignment, and shareholder rights — became central to risk management after the 2008 financial crisis exposed systemic oversight failures.",
                difficulty: .beginner,
                relatedConcepts: ["ESG", "Governance"]
            ),
            QuizQuestion(
                id: "q_esg_2",
                question: "How did sustainable funds perform in the first half of 2025 compared to traditional funds?",
                options: [
                    "Underperformed by 3%",
                    "Performed about the same",
                    "Outperformed — 12.5% vs. 9.2% median return",
                    "Data not yet available"
                ],
                correctAnswerIndex: 2,
                explanation: "Sustainable funds posted a median return of 12.5% in H1 2025 vs. 9.2% for traditional funds — the strongest outperformance since 2019, continuing a multi-year trend of competitive ESG performance.",
                difficulty: .intermediate,
                relatedConcepts: ["ESG Performance", "Sustainable Funds"]
            ),
            QuizQuestion(
                id: "q_esg_3",
                question: "What is 'greenhushing'?",
                options: [
                    "Planting trees to offset marketing costs",
                    "Quietly continuing ESG investment processes without prominent branding to avoid political scrutiny",
                    "A regulatory classification for Article 9 funds",
                    "A method of carbon accounting"
                ],
                correctAnswerIndex: 1,
                explanation: "Greenhushing refers to firms continuing ESG-related investment processes while scaling back public ESG marketing and commitments — particularly in response to US political backlash against ESG investing.",
                difficulty: .intermediate,
                relatedConcepts: ["Greenwashing", "ESG Regulation"]
            ),
            QuizQuestion(
                id: "q_esg_4",
                question: "What is the key difference between ESG integration and impact investing?",
                options: [
                    "ESG integration is only for institutional investors",
                    "Impact investing excludes all fossil fuels",
                    "ESG integration enhances risk-adjusted returns using sustainability data; impact investing explicitly targets measurable social or environmental outcomes",
                    "They are the same thing"
                ],
                correctAnswerIndex: 2,
                explanation: "ESG integration primarily seeks to improve financial analysis by incorporating sustainability data. Impact investing goes further — explicitly targeting measurable environmental or social outcomes alongside financial returns. Understanding this distinction is foundational.",
                difficulty: .intermediate,
                relatedConcepts: ["ESG Integration", "Impact Investing"]
            )
        ],
        passingScore: 0.6
    )

    static let climateFinanceQuiz = Quiz(
        id: "quiz_climate_finance",
        title: "Climate Finance & Real Assets",
        description: "Test your knowledge of carbon markets, project finance, and the energy transition.",
        questions: [
            QuizQuestion(
                id: "q_climate_1",
                question: "What does 'additionality' mean in the context of carbon credits?",
                options: [
                    "Adding more carbon to the atmosphere",
                    "The credit represents a reduction that would not have happened without the project",
                    "Additional fees charged by carbon registries",
                    "A bonus payment to project developers"
                ],
                correctAnswerIndex: 1,
                explanation: "Additionality ensures a carbon credit represents a genuine reduction that would not have occurred anyway. If a project would have happened regardless of carbon credit revenue, the credits are not considered additional.",
                difficulty: .intermediate,
                relatedConcepts: ["Carbon Credits", "Additionality", "Permanence"]
            ),
            QuizQuestion(
                id: "q_climate_2",
                question: "How does project finance differ from investing in public equities?",
                options: [
                    "Project finance is only available to governments",
                    "Returns depend on cash flows from the specific project, not the sponsor's overall balance sheet",
                    "Project finance has no risk",
                    "Public equities always outperform project finance"
                ],
                correctAnswerIndex: 1,
                explanation: "In project finance, repayment depends on the cash flows generated by the project itself — often secured by power purchase agreements (PPAs). This is distinct from public equities, where returns depend on overall company performance and market sentiment.",
                difficulty: .intermediate,
                relatedConcepts: ["Project Finance", "Power Purchase Agreement", "Green Bonds"]
            ),
            QuizQuestion(
                id: "q_climate_3",
                question: "The Paris Agreement's Article 2.1(c) commits to what?",
                options: [
                    "Eliminating all fossil fuel subsidies by 2030",
                    "Making finance flows consistent with a low greenhouse gas emissions pathway",
                    "Requiring all pension funds to divest from coal",
                    "Establishing a global carbon price"
                ],
                correctAnswerIndex: 1,
                explanation: "Article 2.1(c) commits signatory nations to 'making finance flows consistent with a pathway towards low greenhouse gas emissions and climate-resilient development' — explicitly embedding financial system transformation into the climate agreement.",
                difficulty: .advanced,
                relatedConcepts: ["Paris Agreement", "Climate Finance", "TCFD"]
            ),
            QuizQuestion(
                id: "q_climate_4",
                question: "What is 'leakage' in carbon markets?",
                options: [
                    "Carbon escaping from underground storage",
                    "When reducing emissions in one area causes emissions to increase elsewhere",
                    "A technical problem with carbon credit blockchain systems",
                    "Carbon credits that expire without being used"
                ],
                correctAnswerIndex: 1,
                explanation: "Leakage occurs when emissions reduced in one location cause an increase in emissions elsewhere, reducing the overall environmental benefit. For example, protecting a forest in one country may push logging activity into a neighboring region.",
                difficulty: .intermediate,
                relatedConcepts: ["Carbon Credits", "Additionality", "Leakage"]
            ),
            QuizQuestion(
                id: "q_climate_5",
                question: "According to the Circularity Gap Report, approximately what share of global greenhouse gas emissions stems from product manufacturing and material use?",
                options: ["Less than 10%", "About 20%", "Nearly 45%", "Over 70%"],
                correctAnswerIndex: 2,
                explanation: "The Circularity Gap Report estimates that nearly 45% of global greenhouse gas emissions stem from the production and use of products and materials — making the circular economy one of the highest-leverage interventions for climate action.",
                difficulty: .advanced,
                relatedConcepts: ["Circular Economy", "Emissions", "Nature-Based Solutions"]
            )
        ],
        passingScore: 0.6
    )
}

// MARK: - ESG Case Studies
struct ESGCaseStudies {
    static let all: [CaseStudy] = [

        CaseStudy(
            id: "case_esg_1",
            title: "KlimaDAO: Tokenized Carbon Credits",
            scenario: "KlimaDAO, launched in 2021, created a 'carbon-backed currency' by purchasing voluntary carbon credits and locking them in a DAO-governed treasury, issuing KLIMA tokens backed by tokenized carbon tonnes. At its peak, KlimaDAO held over 17 million tonnes of carbon credits. The model funds and digitizes real carbon credits linked to on-chain assets and governance mechanisms — but faced criticism for initially acquiring lower-quality credits at scale, raising questions about whether tokenization alone can ensure environmental integrity.",
            context: "KlimaDAO acquires and tokenizes carbon credits from traditional registries, bridging them onto the blockchain via infrastructure protocols like Toucan. Each verified credit becomes an on-chain token representing one tonne of CO₂ offset. These tokens can be traded, retired, or held transparently.\n\nReal projects supported include Improved Cookstoves for Rohingya Refugees in Bangladesh and Ocean Alkalinity Enhancement with Limenet.\n\nThe investment thesis rests on two legs: (1) the quality of the underlying carbon project and its registry verification, and (2) the governance and operational soundness of the tokenization infrastructure. KlimaDAO's experience suggests that DeFi governance mechanisms can allocate capital toward verified climate projects, but are not substitutes for rigorous off-chain verification.",
            keyQuestions: [
                "How does tokenization improve transparency in voluntary carbon markets — what specific problems does it solve, and what problems does it leave unsolved?",
                "What are the governance implications of community-controlled carbon credits via DAO structures?",
                "How can blockchain infrastructure verify the integrity of carbon offset claims, and what complementary off-chain mechanisms are still required?"
            ],
            learningFocus: ["Carbon Tokenization", "DAO Governance", "Climate Impact"],
            relatedSection: "sec_esg_4",
            source: "Climate, Energy & Real World Assets"
        ),

        CaseStudy(
            id: "case_esg_2",
            title: "AirCarbon Exchange: Regulated Tokenized Carbon Market",
            scenario: "AirCarbon Exchange (ACX) operates as a regulated carbon exchange under the Abu Dhabi Global Market (ADGM), demonstrating how tokenization can transform carbon markets by enhancing transparency, liquidity, and access for both retail and institutional investors.",
            context: "ACX deploys distributed ledger technology to record the full lifecycle of tokenized credits — from issuance and custody to trading and retirement — in an immutable ledger that enhances auditability. Partnering with verification and ratings firms like Sylvera helps distinguish high-quality credits from lower-integrity ones.\n\nRegulatory oversight creates institutional trust, enables custodial clarity, and supports corporate compliance use cases. Airlines managing CORSIA obligations and corporates with net-zero commitments require the compliance framework that regulated platforms provide.",
            keyQuestions: [
                "How does regulatory oversight enhance trust in tokenized carbon markets compared to unregulated alternatives?",
                "What role do ratings firms like Sylvera play in distinguishing carbon asset quality?",
                "How might tokenized carbon integrate into broader ESG portfolios for institutional investors?"
            ],
            learningFocus: ["Regulated Markets", "Carbon Trading", "Transparency"],
            relatedSection: "sec_esg_4",
            source: "Climate, Energy & Real World Assets"
        ),

        CaseStudy(
            id: "case_esg_3",
            title: "Apple's Restore Fund & Amazon's Agroforestry",
            scenario: "Traditional corporate carbon finance demonstrates how institutional capital can fund ecological assets — forestry and land restoration — that generate both verified carbon removal credits and financial returns. Apple launched the Restore Fund in 2021 with a $200 million commitment targeting sustainably managed forestry assets in Brazil and Paraguay.",
            context: "Apple's Restore Fund, created in partnership with Conservation International and Goldman Sachs' Climate Asset Management, aims to remove at least 1 million metric tonnes of CO₂ per year from the atmosphere while generating financial returns. Initial investments restored 150,000 acres of sustainably certified working forests.\n\nThe fund uses third-party verified carbon standards (Verra, IPCC guidelines) and deploys remote sensing — satellite imagery and habitat carbon mapping — to monitor and verify project impact over time.\n\nAmazon's agroforestry investments combine carbon revenue with agricultural productivity, supply chain resilience, and biodiversity outcomes.",
            keyQuestions: [
                "How do traditional forestry-based carbon finance models differ structurally from tokenized carbon approaches?",
                "What are the key due diligence considerations when evaluating nature-based carbon projects?",
                "How does the triple bottom line manifest in agroforestry projects — where do People, Planet, and Profit reinforce each other, and where are the tensions?"
            ],
            learningFocus: ["Traditional Carbon Finance", "Natural Capital", "Triple Bottom Line"],
            relatedSection: "sec_esg_5",
            source: "Climate, Energy & Real World Assets"
        ),

        CaseStudy(
            id: "case_esg_4",
            title: "World Bank & Climate Investment Funds",
            scenario: "The Climate Investment Funds (CIF) deploy concessional public capital — low-interest loans, partial guarantees, and first-loss instruments — to lower the risk profile of early-stage clean energy projects in developing countries. As of 2024, 15 contributor countries have pledged over $12 billion to CIF, which has attracted more than $64 billion in additional public and private financing.",
            context: "The UK Green Investment Bank, established in 2012 as the world's first institution of its type, acted as a cornerstone investor in sectors perceived as novel or risky — particularly offshore wind. For every £1 GIB invested, approximately £2.50 of private capital followed. In 2017 it was privatized, sold to a Macquarie-led consortium for £2.3 billion.\n\nBlended finance structures work by using concessional public capital to absorb the first tranche of losses, reducing the risk-adjusted return threshold for private investors. The GIB privatization offers a replicable template: establish with public capital to catalyze a nascent sector, then design for private ownership transfer once the sector has matured.",
            keyQuestions: [
                "How does blended finance change the investable universe for institutional capital in emerging markets?",
                "What is the difference between 'crowding in' and 'crowding out' private capital, and why does this distinction matter?",
                "What lessons from the UK Green Investment Bank's privatization apply to the design of future green investment vehicles?"
            ],
            learningFocus: ["Blended Finance", "Public-Private Partnership", "Emerging Markets"],
            relatedSection: "sec_esg_5",
            source: "Climate, Energy & Real World Assets"
        ),

        CaseStudy(
            id: "case_esg_5",
            title: "The Orsted Transformation",
            scenario: "Danish energy company Orsted (formerly DONG Energy) executed one of the most dramatic corporate transformations in modern energy history — pivoting from one of Europe's most coal-intensive utilities to the world's leading offshore wind developer within roughly a decade.",
            context: "When DONG Energy formed in 2006, it was responsible for approximately a third of Denmark's total carbon emissions. By 2008, 85% of its heat and power production came from fossil fuels. In 2009, management announced a strategic reversal: generate 85% from renewable sources by 2040.\n\nBy 2025, the company reduced energy-generation emissions by 98% relative to its 2006 baseline, achieving a 99% renewable share in its generation portfolio. Orsted actively sold equity stakes in offshore wind farms to institutional investors — pension funds, sovereign wealth funds — to fund the transition without over-leveraging the balance sheet (the 'farm-down' model).\n\nOrsted also contributed to reducing offshore wind costs by more than 60% between 2012 and 2017, winning two German offshore wind projects with zero-subsidy bids in 2016.",
            keyQuestions: [
                "How did Orsted manage the financial risks of such a dramatic transformation — particularly the bridge period when legacy assets were being wound down but renewable revenues had not yet scaled?",
                "What role did investor pressure play in accelerating the transition, and what does this suggest about the mechanisms and limitations of shareholder engagement as a climate strategy?",
                "How can investors identify other companies with similar transformation potential?"
            ],
            learningFocus: ["ESG Transformation", "Clean Energy", "Corporate Strategy"],
            relatedSection: "sec_esg_3_1",
            source: "Climate, Energy & Real World Assets"
        ),

        CaseStudy(
            id: "case_esg_6",
            title: "Gender Lens at Work: The Ellevest Model",
            scenario: "Ellevest, a digital investment platform designed specifically for women, applies gender lens principles to both its business model and investment philosophy — treating structural inequalities not as edge cases but as inputs to financial planning.",
            context: "Founded by former Merrill Lynch and Smith Barney executive Sallie Krawcheck, Ellevest was built on the premise that traditional financial planning tools systematically underserve women by ignoring three structural realities: longer average lifespans, more frequent career interruptions, and the persistent gender pay gap.\n\nGender lens investing extends beyond portfolio screening. At the asset class level, it encompasses public equity funds tilted toward gender-diverse companies, private credit and venture vehicles targeting women-led businesses, and fixed income instruments such as gender bonds.\n\nWomen control an increasing share of household financial decisions globally and represent a growing professional cohort with distinct planning needs.",
            keyQuestions: [
                "How does gender-aware financial planning differ structurally from traditional approaches?",
                "What investment opportunities emerge from addressing underserved demographics at the platform, asset, and policy level?",
                "How can gender lens principles be applied to your own portfolio construction, and how would you verify that a gender lens fund is applying rigorous criteria versus using the label as marketing?"
            ],
            learningFocus: ["Gender Lens Investing", "Financial Inclusion", "Impact"],
            relatedSection: "sec_esg_1",
            source: "Climate, Energy & Real World Assets"
        ),

        CaseStudy(
            id: "case_esg_7",
            title: "Tokenized Solar: The Sun Exchange",
            scenario: "The Sun Exchange is a South Africa-based platform that allows investors worldwide to purchase individual solar cells powering businesses, schools, and clinics in emerging markets — earning rental income paid in cryptocurrency.",
            context: "Through tokenization, investors can own as little as one solar cell (approximately $5–10 per cell), earning monthly returns as the underlying asset generates and sells electricity. Income is distributed in Bitcoin or South African Rand.\n\nThree characteristics distinguish this from traditional infrastructure investing: access thresholds are dramatically lower; liquidity dynamics differ; and impact traceability is enhanced — investors can see precisely which school or clinic their cells are powering.\n\nCounterparty and credit risk remain key concerns. The model illustrates the central tension in RWA tokenization: tokenization can lower access barriers and improve transparency, but it does not eliminate the fundamental risks of the underlying asset — and it can introduce new ones (smart contract risk, platform custody risk, regulatory uncertainty).",
            keyQuestions: [
                "How does fractional ownership change who can invest in renewable infrastructure?",
                "What are the structural risks and rewards of this model compared to traditional energy investments?",
                "How might this approach scale to address global energy access challenges?"
            ],
            learningFocus: ["RWA Tokenization", "Renewable Energy", "Financial Inclusion"],
            relatedSection: "sec_esg_5",
            source: "Climate, Energy & Real World Assets"
        )
    ]
}

// MARK: - ESG Extended Tab Data

struct ESGTipsRealitiesData {

    struct TipItem: Identifiable {
        let id = UUID()
        let emoji: String
        let title: String
        let content: String
        let category: Category

        enum Category: String, CaseIterable {
            case tip = "Tips"
            case reality = "Realities"
            case optionality = "Optionality"
        }
    }

    static let items: [TipItem] = [
        TipItem(emoji: "💡", title: "Start with Materiality", content: "Focus on ESG factors that are financially material to the specific sector. A governance issue at a bank is not the same as a water risk at a mining company — materiality maps (SASB) help prioritize what actually affects performance.", category: .tip),
        TipItem(emoji: "🔍", title: "Look Beyond the Label", content: "Many funds removed 'ESG' from their names in 2024–2025 due to regulatory pressure — but maintained their underlying strategies. And some funds kept the label while loosening their criteria. Judge funds by holdings and methodology, not marketing.", category: .tip),
        TipItem(emoji: "📊", title: "Cross-Reference Ratings", content: "ESG ratings vary significantly between providers — MSCI, Sustainalytics, Bloomberg, and S&P can rate the same company differently. Low correlation between agencies is a documented structural issue, not an anomaly.", category: .tip),
        TipItem(emoji: "⏰", title: "Think in Market Cycles", content: "ESG strategies perform differently across cycles. 2022 underperformed (fossil fuel rally). 2025 rebounded strongly. Over extended horizons the data supports competitive risk-adjusted returns — but short-term volatility is real.", category: .tip),
        TipItem(emoji: "⚠️", title: "Greenwashing Is Real", content: "Regulatory enforcement has increased — but the risk remains. Look for third-party verification, clear use-of-proceeds documentation, and specific impact metrics. 'Sustainable' in a fund name is not sufficient evidence.", category: .reality),
        TipItem(emoji: "🌍", title: "Geography Matters", content: "US, European, and Asia-Pacific ESG markets are diverging rapidly. US faces political headwinds. Europe has the most developed regulatory framework but highest compliance costs. Asia-Pacific is the fastest-growing region.", category: .reality),
        TipItem(emoji: "📉", title: "Sector Tilts Affect Performance", content: "Most ESG funds overweight technology and underweight extractive industries. During commodity booms or fossil fuel rallies, this creates relative underperformance — not failure of the ESG thesis, but a structural factor to understand.", category: .reality),
        TipItem(emoji: "💰", title: "Fees Vary Widely", content: "Active ESG strategies often charge higher fees for research and engagement. Passive ESG ETFs have narrowed the gap significantly. Compare expense ratios carefully relative to the depth of ESG integration being offered.", category: .reality),
        TipItem(emoji: "🔄", title: "Transition Finance", content: "Consider investing in companies actively decarbonizing — not just those already green. Credible transition plans at high-emitting companies may offer more upside than already-green leaders, and the capital is arguably more impactful.", category: .optionality),
        TipItem(emoji: "🌱", title: "Emerging Markets ESG", content: "ESG in emerging markets is less developed but growing fastest — particularly Asia-Pacific. Early positioning may capture significant long-term value as regulatory frameworks mature and institutional capital flows increase.", category: .optionality),
        TipItem(emoji: "🔗", title: "Green RWAs & Tokenization", content: "Tokenized green assets represent an emerging frontier — fractional renewable energy, tokenized carbon credits, digital green bonds. Still early stage with platform and regulatory risk, but worth monitoring as infrastructure matures.", category: .optionality),
        TipItem(emoji: "♻️", title: "Circular Economy Exposure", content: "Public market exposure to circular economy themes is available via waste management, packaging, and materials companies. Private markets offer deeper access through recycling technology and industrial biotechnology venture funds.", category: .optionality)
    ]
}

struct ESGAdvisorQuestionsData {

    struct QuestionCategory: Identifiable {
        let id = UUID()
        let emoji: String
        let title: String
        let questions: [String]
    }

    static let categories: [QuestionCategory] = [
        QuestionCategory(emoji: "📈", title: "Performance", questions: [
            "How have your ESG strategies performed relative to benchmarks over 3, 5, and 10-year periods?",
            "What explains performance variations across different market environments?",
            "How do you measure and report ESG performance separate from ESG impact?",
            "Has 2022 underperformance changed how you construct ESG portfolios?"
        ]),
        QuestionCategory(emoji: "🌍", title: "Geography & Regulation", questions: [
            "What geographic exposure do your recommended ESG funds have?",
            "How do you evaluate regulatory risk across different regions — US, Europe, Asia-Pacific?",
            "Are there opportunities in Asia-Pacific ESG strategies appropriate for my portfolio?",
            "How do regulatory requirements affect the funds you recommend, and are compliance costs embedded in expense ratios?"
        ]),
        QuestionCategory(emoji: "🔍", title: "Fund Quality", questions: [
            "Has this fund been recently renamed or reclassified? Did the underlying strategy change?",
            "What specific ESG criteria and exclusions does this fund apply?",
            "Which ESG rating agencies does this fund rely on?",
            "Does the fund use AI or advanced analytics in ESG assessment?"
        ]),
        QuestionCategory(emoji: "🌱", title: "Impact & Reporting", questions: [
            "How will I know the actual environmental or social impact of my investments?",
            "Do you provide impact reporting alongside financial statements?",
            "How do you ensure investments aren't greenwashed?",
            "Can you show me the carbon footprint of my current portfolio?"
        ]),
        QuestionCategory(emoji: "🔮", title: "Forward-Looking", questions: [
            "How might climate regulations affect my current investments?",
            "What transition risks should I be aware of in my existing holdings?",
            "Are there emerging themes — circular economy, nature capital, just transition — appropriate for my portfolio?",
            "How do you stay current on evolving ESG standards and regulations?"
        ])
    ]
}

struct ESGAdvancedPortfolioData {

    struct StrategySection: Identifiable {
        let id = UUID()
        let emoji: String
        let title: String
        let content: String
        let considerations: [String]
    }

    static let strategies: [StrategySection] = [
        StrategySection(emoji: "🎯", title: "ESG Integration", content: "Systematic incorporation of financially material ESG factors into fundamental analysis without restricting the investment universe.", considerations: [
            "Assign ESG scores to all holdings using consistent methodology",
            "Weight ESG factors based on sector-specific materiality (SASB maps)",
            "Integrate ESG into valuation models — discount rates, growth assumptions, regulatory exposure",
            "Monitor ESG trajectory, not just current scores"
        ]),
        StrategySection(emoji: "⚖️", title: "Tilting & Optimization", content: "Adjusting portfolio weights to improve ESG characteristics while maintaining desired risk/return profile.", considerations: [
            "Use mean-variance optimization with ESG constraints",
            "Set tracking error limits to manage deviation from benchmark",
            "Consider sector-neutral approaches to avoid unintended factor bets",
            "Rebalance periodically as ESG scores and company trajectories change"
        ]),
        StrategySection(emoji: "🚫", title: "Exclusionary Screening", content: "Removing companies or sectors that don't meet ESG criteria from the investable universe.", considerations: [
            "Define clear exclusion criteria — revenue thresholds, specific activities",
            "Consider impact on diversification and tracking error",
            "Review exclusion list periodically as companies evolve or exit sectors",
            "Balance values alignment with portfolio efficiency"
        ]),
        StrategySection(emoji: "🏆", title: "Best-in-Class Selection", content: "Selecting top ESG performers within each sector to maintain diversification.", considerations: [
            "Define 'best-in-class' threshold — top quartile, decile",
            "Use sector-relative, not absolute, ESG rankings",
            "Combine with financial quality screens",
            "Consider engagement strategy for holdings near the threshold"
        ]),
        StrategySection(emoji: "📈", title: "Thematic Allocation", content: "Concentrating investments in specific sustainability themes aligned with investor values.", considerations: [
            "Clean energy, water, circular economy, sustainable agriculture, energy transition metals",
            "Higher concentration increases both risk and potential impact",
            "Combine with diversified core for balanced exposure",
            "Monitor theme valuations to avoid overpaying into crowded trades"
        ]),
        StrategySection(emoji: "🎯", title: "Transition Finance", content: "Directing capital to high-emitting companies with credible, science-based decarbonization plans.", considerations: [
            "Evaluate credibility of transition plans — interim targets, capital allocation, board accountability",
            "Higher engagement and monitoring requirements than best-in-class",
            "Potentially higher returns if transition is priced in before market recognition",
            "Requires comfort with short-term ESG score underperformance while transition is underway"
        ])
    ]

    static let allocationExample = """
    Sample ESG-Integrated Portfolio (Moderate Risk):

    Core Holdings (60%)
    • 30% Global ESG-Integrated Equity
    • 20% Sustainable Bond Fund
    • 10% Green Bond Allocation

    Alternative ESG (25%)
    • 10% Sustainable Real Estate
    • 8% Clean Energy Infrastructure
    • 5% Impact Private Equity
    • 2% Carbon Credits

    Thematic (10%)
    • 5% Climate Solutions / Clean Energy Fund
    • 3% Water, Circular Economy & Natural Assets
    • 2% Emerging Markets ESG

    Innovation (5%)
    • 3% Climate Tech Venture / Transition Finance
    • 2% Green RWAs / Tokenized Assets
    """
}

struct ESGTermsData {

    struct Term: Identifiable {
        let id = UUID()
        let term: String
        let definition: String
        let category: Category
        let related: [String]

        enum Category: String, CaseIterable {
            case fundamentals = "ESG Fundamentals"
            case climateFinance = "Climate Finance"
            case metrics = "Metrics & Reporting"
            case strategies = "Investment Strategies"
            case rwa = "RWA & Tokenization"
        }
    }

    static let terms: [Term] = [
        Term(term: "ESG", definition: "Environmental, Social, and Governance — a framework for evaluating a company's sustainability and ethical impact beyond traditional financial metrics.", category: .fundamentals, related: ["Sustainable Investing", "Double Materiality"]),
        Term(term: "Double Materiality", definition: "The principle that companies should report on both how sustainability issues affect their value (financial materiality) and how their operations impact society and environment (impact materiality).", category: .fundamentals, related: ["ESG", "CSRD"]),
        Term(term: "Greenwashing", definition: "Making misleading claims about the environmental benefits of a product, service, or investment to appear more sustainable than warranted.", category: .fundamentals, related: ["Greenhushing", "SFDR"]),
        Term(term: "Greenhushing", definition: "The practice of continuing ESG-related investment processes without prominent public branding or promotion, often to avoid political or reputational scrutiny.", category: .fundamentals, related: ["Greenwashing", "ESG"]),
        Term(term: "Additionality", definition: "In carbon markets, ensures that a carbon credit represents a reduction or removal that would not have happened without the specific project — credits that are not additional do not represent real climate benefit.", category: .climateFinance, related: ["Carbon Credit", "Permanence", "Leakage"]),
        Term(term: "Permanence", definition: "The durability of a carbon reduction or removal over time. Projects like forest conservation face permanence risk if trees are later cut down, releasing stored carbon.", category: .climateFinance, related: ["Additionality", "Carbon Credit"]),
        Term(term: "Leakage", definition: "When emissions reduced in one area cause an increase in emissions elsewhere, reducing the net environmental benefit. A key challenge in nature-based carbon projects.", category: .climateFinance, related: ["Additionality", "Carbon Markets"]),
        Term(term: "Green Bond", definition: "A fixed-income instrument specifically earmarked to raise capital for climate and environmental projects — renewable energy, clean transportation, sustainable buildings.", category: .climateFinance, related: ["Climate Finance", "Carbon Credit"]),
        Term(term: "Carbon Credit", definition: "A tradeable certificate representing one metric ton of CO₂ (or equivalent greenhouse gas) that has been avoided, reduced, or removed from the atmosphere.", category: .climateFinance, related: ["Additionality", "Carbon Markets", "Tokenization"]),
        Term(term: "Stranded Assets", definition: "Assets that have suffered unexpected write-downs, devaluations, or conversion to liabilities — often due to climate-related transitions such as fossil fuel reserves that become unburnable under carbon constraints.", category: .climateFinance, related: ["Transition Risk", "Paris Agreement"]),
        Term(term: "SFDR", definition: "Sustainable Finance Disclosure Regulation — EU regulation requiring financial market participants to disclose how they integrate sustainability risks. Defines Article 8 ('light green') and Article 9 ('dark green') fund classifications.", category: .metrics, related: ["EU Taxonomy", "CSRD"]),
        Term(term: "CSRD", definition: "Corporate Sustainability Reporting Directive — EU directive expanding ESG disclosure requirements for companies operating within the EU, including non-EU companies with significant EU operations.", category: .metrics, related: ["SFDR", "EU Taxonomy"]),
        Term(term: "EU Taxonomy", definition: "A classification system establishing science-based criteria for what constitutes environmentally sustainable economic activity, providing a common language for sustainable investing in Europe.", category: .metrics, related: ["SFDR", "CSRD"]),
        Term(term: "TCFD", definition: "Task Force on Climate-related Financial Disclosures — framework for companies to disclose climate risks and opportunities. Supported by institutions representing over $150 trillion in assets.", category: .metrics, related: ["NGFS", "Climate Risk"]),
        Term(term: "SASB", definition: "Sustainability Accounting Standards Board — developed industry-specific materiality maps identifying which sustainability factors are most likely to affect financial performance within a given sector.", category: .metrics, related: ["Double Materiality", "ESG Integration"]),
        Term(term: "Impact Investing", definition: "Investments made with the intention to generate positive, measurable social and environmental impact alongside a financial return. Distinct from ESG integration, which primarily seeks to improve risk-adjusted returns.", category: .strategies, related: ["ESG Integration", "Blended Finance"]),
        Term(term: "Transition Finance", definition: "Capital directed toward helping high-emitting companies and industries decarbonize — supporting credible transition plans rather than simply excluding carbon-intensive sectors.", category: .strategies, related: ["Just Transition", "Paris Agreement"]),
        Term(term: "Blended Finance", definition: "The strategic use of concessional public capital (grants, low-interest loans, first-loss guarantees) to mobilize private investment into sustainable development or climate-aligned projects.", category: .strategies, related: ["Impact Investing", "Project Finance"]),
        Term(term: "Power Purchase Agreement (PPA)", definition: "A long-term contract between an electricity producer and a buyer, guaranteeing a set price for electricity over a defined period. PPAs underpin the revenue certainty that makes renewable project finance viable.", category: .climateFinance, related: ["Project Finance", "Green Bonds"]),
        Term(term: "Real World Asset (RWA)", definition: "Physical or traditional financial assets that have been tokenized — represented as digital tokens on a blockchain — enabling fractional ownership and increased liquidity.", category: .rwa, related: ["Tokenization", "Green RWA"]),
        Term(term: "Tokenization", definition: "The process of converting rights to an asset into a digital token on a blockchain, enabling 24/7 trading, fractional ownership, and programmable compliance.", category: .rwa, related: ["RWA", "Smart Contract", "Additionality"]),
        Term(term: "Circular Economy", definition: "An economic system designed to eliminate waste and keep materials in productive use — through reuse, repair, remanufacturing, and recycling — as an alternative to the traditional 'take–make–dispose' linear model.", category: .strategies, related: ["Nature-Based Solutions", "ESG"]),
        Term(term: "Natural Asset Company (NAC)", definition: "A specialized company structure designed to manage and monetize the ecosystem services of natural assets — forests, wetlands, water systems — including carbon sequestration, biodiversity, and water purification.", category: .climateFinance, related: ["Ecosystem Services", "Carbon Credit"]),
        Term(term: "Just Transition", definition: "The principle that the shift to a low-carbon economy should be fair and inclusive — protecting workers and communities in fossil fuel-dependent sectors and ensuring the benefits of the clean economy are broadly shared.", category: .strategies, related: ["Transition Finance", "ESG"])
    ]
}

// MARK: - ESG Tab Views

import SwiftUI

struct ESGTipsRealitiesTabView: View {
    @State private var selectedCategory: ESGTipsRealitiesData.TipItem.Category = .tip

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("Tips, Realities & Optionality")
                .font(Typography.title2)
                .foregroundColor(.textPrimary)
                .padding(.top, Spacing.lg)

            Text("Practical guidance for navigating ESG investing.")
                .font(Typography.body)
                .foregroundColor(.textSecondary)

            Picker("Category", selection: $selectedCategory) {
                ForEach(ESGTipsRealitiesData.TipItem.Category.allCases, id: \.self) { category in
                    Text(category.rawValue).tag(category)
                }
            }
            .pickerStyle(.segmented)
            .padding(.vertical, Spacing.sm)

            let filteredItems = ESGTipsRealitiesData.items.filter { $0.category == selectedCategory }

            ForEach(filteredItems) { item in
                ESGTipCard(item: item)
            }

            Spacer().frame(height: Spacing.xxxl)
        }
        .padding(.horizontal, Spacing.lg)
    }
}

struct ESGTipCard: View {
    let item: ESGTipsRealitiesData.TipItem

    var body: some View {
        HStack(alignment: .top, spacing: Spacing.md) {
            Text(item.emoji).font(.system(size: 28))
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(item.title)
                    .font(Typography.bodyMedium)
                    .foregroundColor(.textPrimary)
                Text(item.content)
                    .font(Typography.body)
                    .foregroundColor(.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
    }

    private var cardBackground: Color {
        switch item.category {
        case .tip: return Color.success.opacity(0.08)
        case .reality: return Color.warning.opacity(0.08)
        case .optionality: return Color.brandPrimary.opacity(0.08)
        }
    }
}

struct ESGAdvisorQuestionsTabView: View {
    @State private var expandedCategories: Set<UUID> = []

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("Questions for Your Financial Advisor")
                .font(Typography.title2)
                .foregroundColor(.textPrimary)
                .padding(.top, Spacing.lg)

            Text("Key questions to ask when discussing ESG investing.")
                .font(Typography.body)
                .foregroundColor(.textSecondary)

            ForEach(ESGAdvisorQuestionsData.categories) { category in
                AdvisorQuestionCategoryView(
                    category: category,
                    isExpanded: expandedCategories.contains(category.id)
                ) {
                    withAnimation(.smoothSpring) {
                        if expandedCategories.contains(category.id) {
                            expandedCategories.remove(category.id)
                        } else {
                            expandedCategories.insert(category.id)
                        }
                    }
                }
            }

            Spacer().frame(height: Spacing.xxxl)
        }
        .padding(.horizontal, Spacing.lg)
    }
}

struct AdvisorQuestionCategoryView: View {
    let category: ESGAdvisorQuestionsData.QuestionCategory
    let isExpanded: Bool
    let onToggle: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: onToggle) {
                HStack(spacing: Spacing.sm) {
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.textTertiary)
                        .frame(width: 16)
                    Text(category.emoji).font(.system(size: 20))
                    Text(category.title)
                        .font(Typography.bodyMedium)
                        .foregroundColor(.textPrimary)
                    Spacer()
                    Text("\(category.questions.count)")
                        .font(Typography.caption)
                        .foregroundColor(.textTertiary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.surfaceSecondary)
                        .clipShape(Capsule())
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .padding(.vertical, Spacing.sm)

            if isExpanded {
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    ForEach(category.questions, id: \.self) { question in
                        HStack(alignment: .top, spacing: Spacing.sm) {
                            Image(systemName: "questionmark.circle")
                                .font(.caption)
                                .foregroundColor(.brandPrimary)
                                .padding(.top, 2)
                            Text(question)
                                .font(Typography.body)
                                .foregroundColor(.textPrimary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(.vertical, Spacing.xs)
                    }
                }
                .padding(.leading, Spacing.lg)
                .padding(.bottom, Spacing.md)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(Spacing.md)
        .background(Color.surfaceSecondary)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
    }
}

struct ESGAdvancedPortfolioTabView: View {
    @State private var expandedStrategies: Set<UUID> = []
    @State private var showAllocation = false

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("Possible Advanced Portfolio Construction Options")
                .font(Typography.title2)
                .foregroundColor(.textPrimary)
                .padding(.top, Spacing.lg)

            Text("Strategic frameworks for building sophisticated ESG-integrated portfolios.")
                .font(Typography.body)
                .foregroundColor(.textSecondary)

            HStack(alignment: .top, spacing: Spacing.sm) {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.info)
                    .font(.system(size: 16))
                Text("**For illustrative and educational purposes only.** These examples demonstrate possible portfolio construction approaches. Always consult with a qualified financial advisor before making investment decisions.")
                    .font(Typography.caption)
                    .foregroundColor(.textSecondary)
            }
            .padding(Spacing.md)
            .background(Color.info.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
            .padding(.bottom, Spacing.sm)

            ForEach(ESGAdvancedPortfolioData.strategies) { strategy in
                ESGStrategyCard(
                    strategy: strategy,
                    isExpanded: expandedStrategies.contains(strategy.id)
                ) {
                    withAnimation(.smoothSpring) {
                        if expandedStrategies.contains(strategy.id) {
                            expandedStrategies.remove(strategy.id)
                        } else {
                            expandedStrategies.insert(strategy.id)
                        }
                    }
                }
            }

            VStack(alignment: .leading, spacing: Spacing.sm) {
                Button {
                    withAnimation(.smoothSpring) { showAllocation.toggle() }
                } label: {
                    HStack(spacing: Spacing.sm) {
                        Image(systemName: showAllocation ? "chevron.down" : "chevron.right")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.textTertiary)
                            .frame(width: 16)
                        Text("📊").font(.system(size: 20))
                        Text("Sample ESG Portfolio Allocation")
                            .font(Typography.bodyMedium)
                            .foregroundColor(.textPrimary)
                        Spacer()
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)

                if showAllocation {
                    Text(ESGAdvancedPortfolioData.allocationExample)
                        .font(Typography.caption)
                        .foregroundColor(.textSecondary)
                        .padding(Spacing.md)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.surfaceTertiary)
                        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.sm))
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .padding(Spacing.md)
            .background(Color.brandPrimary.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))

            Spacer().frame(height: Spacing.xxxl)
        }
        .padding(.horizontal, Spacing.lg)
    }
}

struct ESGStrategyCard: View {
    let strategy: ESGAdvancedPortfolioData.StrategySection
    let isExpanded: Bool
    let onToggle: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: onToggle) {
                HStack(spacing: Spacing.sm) {
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.textTertiary)
                        .frame(width: 16)
                    Text(strategy.emoji).font(.system(size: 20))
                    VStack(alignment: .leading, spacing: 2) {
                        Text(strategy.title)
                            .font(Typography.bodyMedium)
                            .foregroundColor(.textPrimary)
                        if !isExpanded {
                            Text(strategy.content)
                                .font(Typography.caption)
                                .foregroundColor(.textTertiary)
                                .lineLimit(1)
                        }
                    }
                    Spacer()
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .padding(.vertical, Spacing.sm)

            if isExpanded {
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Text(strategy.content)
                        .font(Typography.body)
                        .foregroundColor(.textSecondary)
                    Text("Key Considerations:")
                        .font(Typography.captionMedium)
                        .foregroundColor(.textPrimary)
                        .padding(.top, Spacing.xs)
                    ForEach(strategy.considerations, id: \.self) { consideration in
                        HStack(alignment: .top, spacing: Spacing.sm) {
                            Circle()
                                .fill(Color.brandPrimary)
                                .frame(width: 6, height: 6)
                                .padding(.top, 6)
                            Text(consideration)
                                .font(Typography.caption)
                                .foregroundColor(.textPrimary)
                        }
                    }
                }
                .padding(.leading, Spacing.lg)
                .padding(.bottom, Spacing.md)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(Spacing.md)
        .background(Color.surfaceSecondary)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
    }
}

struct ESGTermsTabView: View {
    @State private var searchText = ""
    @State private var selectedCategory: ESGTermsData.Term.Category?

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("ESG Terminology")
                .font(Typography.title2)
                .foregroundColor(.textPrimary)
                .padding(.top, Spacing.lg)

            Text("Key terms and definitions for ESG and sustainable investing.")
                .font(Typography.body)
                .foregroundColor(.textSecondary)

            HStack {
                Image(systemName: "magnifyingglass").foregroundColor(.textTertiary)
                TextField("Search terms...", text: $searchText).font(Typography.body)
                if !searchText.isEmpty {
                    Button { searchText = "" } label: {
                        Image(systemName: "xmark.circle.fill").foregroundColor(.textTertiary)
                    }
                }
            }
            .padding(Spacing.sm)
            .background(Color.surfaceSecondary)
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.sm))

            ZStack(alignment: .trailing) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: Spacing.sm) {
                        ESGCategoryFilterChip(title: "All", isSelected: selectedCategory == nil) { selectedCategory = nil }
                        ForEach(ESGTermsData.Term.Category.allCases, id: \.self) { category in
                            ESGCategoryFilterChip(title: category.rawValue, isSelected: selectedCategory == category) { selectedCategory = category }
                        }
                        Spacer().frame(width: Spacing.xl)
                    }
                }
                HStack(spacing: 0) {
                    LinearGradient(colors: [Color.surfacePrimary.opacity(0), Color.surfacePrimary.opacity(0.9), Color.surfacePrimary], startPoint: .leading, endPoint: .trailing)
                        .frame(width: 40)
                    Image(systemName: "chevron.compact.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.textTertiary)
                        .padding(.trailing, 2)
                }
                .allowsHitTesting(false)
            }

            ScrollView {
                LazyVStack(spacing: Spacing.sm) {
                    ForEach(filteredTerms) { term in
                        ESGTermRow(term: term)
                    }
                }
            }

            Spacer().frame(height: Spacing.xxxl)
        }
        .padding(.horizontal, Spacing.lg)
    }

    private var filteredTerms: [ESGTermsData.Term] {
        var terms = ESGTermsData.terms
        if let category = selectedCategory { terms = terms.filter { $0.category == category } }
        if !searchText.isEmpty {
            terms = terms.filter {
                $0.term.localizedCaseInsensitiveContains(searchText) ||
                $0.definition.localizedCaseInsensitiveContains(searchText)
            }
        }
        return terms
    }
}

struct ESGCategoryFilterChip: View {
    let title: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Text(title)
                .font(Typography.caption)
                .foregroundColor(isSelected ? .white : .textSecondary)
                .padding(.horizontal, Spacing.md)
                .padding(.vertical, Spacing.xs)
                .background(isSelected ? Color.brandPrimary : Color.surfaceSecondary)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

struct ESGTermRow: View {
    let term: ESGTermsData.Term
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Button {
                withAnimation(.smoothSpring) { isExpanded.toggle() }
            } label: {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(term.term)
                            .font(Typography.bodyMedium)
                            .foregroundColor(.textPrimary)
                        Text(term.category.rawValue)
                            .font(Typography.caption2)
                            .foregroundColor(.textTertiary)
                    }
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundColor(.textTertiary)
                }
            }
            .buttonStyle(.plain)

            if isExpanded {
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Text(term.definition)
                        .font(Typography.body)
                        .foregroundColor(.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                    if !term.related.isEmpty {
                        HStack(spacing: Spacing.xs) {
                            Text("Related:")
                                .font(Typography.caption2)
                                .foregroundColor(.textTertiary)
                            ForEach(term.related, id: \.self) { related in
                                Text(related)
                                    .font(Typography.caption2)
                                    .foregroundColor(.brandPrimary)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color.brandPrimary.opacity(0.1))
                                    .clipShape(Capsule())
                            }
                        }
                    }
                }
                .padding(.top, Spacing.xs)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(Spacing.md)
        .background(Color.surfaceSecondary)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
    }
}
