//
//  WineModuleData.swift
//  Enhanced App for Alt Assets
//
//  Created by Victoria Case on 2026-06-03.
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//
//  Description: Wine & Vineyard Investing module data.
//  Synthesized from research compendium compiled March–June 2026.
//  Citations numbered (1)–(45); footnotes listed in wineModuleFootnotes below.
//  Sections 11–12 added June 2026: California biodynamic estates and biodiversity as investment signal.
//

import Foundation

struct WineModuleData {

    static func loadModule() -> Module {
        Module(
            id: "mod_wine",
            title: "Wine & Vineyard Investing",
            description: "From fine wine indices and auction markets to regenerative vineyards, biodynamic estates, and the global organic wine movement — a comprehensive look at wine as an alternative asset class.",
            icon: "🍷",
            color: "red",
            heroImageName: "hero_wine",
            sections: [

                // MARK: - Section 1: Wine as an Alternative Asset
                Section(
                    id: "sec_mod_wine_1",
                    title: "🍷 1. Wine as an Alternative Asset_",
                    content: [
                        .quote("Wine is one of the most civilized things in the world and one of the most natural things of the world that has been brought to the greatest perfection, and it offers a greater range for enjoyment and appreciation than, possibly, any other purely sensory thing.", author: "Ernest Hemingway"),
                        .text("Fine wine occupies a distinctive position in the alternative asset universe. Unlike equities or bonds, it is a physical, consumable good with inherent scarcity — production is limited by appellation laws, climate, and the finite capacity of the world's greatest vineyards. These constraints, combined with growing global wealth and a deepening collector culture, have driven fine wine from a connoisseur's indulgence into a recognized investment category tracked by institutional indices and managed by dedicated platforms."),
                        .text("The global wine market was valued at $461–508 billion in 2024, depending on methodology, with a projected CAGR of approximately 5–5.7% through 2032. (1) Within that broader market, investment-grade fine wine — the top tier of classified estates and cult producers — behaves very differently from the commodity wine sector, exhibiting price dynamics driven more by secondary market demand, critical scores, and collector psychology than by production economics."),
                        .callout(title: "What Is Fine Wine Investment?", content: "Fine wine investment typically refers to buying bottles or cases of investment-grade wine — wines from classified estates and celebrated producers — with the intention of reselling at a profit on the secondary market. This is distinct from vineyard ownership, winery equity, or wine fund investing, each of which carries different return profiles, timelines, and risk structures.", type: .info),
                        .text("The investment case for fine wine rests on several structural features. First, near-zero correlation with traditional financial assets: numerous studies and platform data confirm that fine wine exhibits low to negative correlation with equities, bonds, and gold. In 2025, demand for fine wine rose 16% specifically because of its independence from mainstream markets. (2) Second, scarcity: production in the world's top appellations is strictly regulated and cannot be expanded. When a great vintage is consumed, that supply is permanently reduced. Third, a long record: the Liv-ex Investables Index has returned over 2,050% since 1988, a compound annual growth rate of approximately 9.0%. (3)"),
                        .callout(title: "Portfolio Allocation Insight", content: "Allocating 5–10% of a portfolio to fine wine has been shown to improve stability, lower overall risk, and enhance long-term returns. In 2025, fine wine was rated the most in-demand collectible among financial advisors and wealth managers in both the UK and US for the third consecutive year. Over 35% of ultra-high-net-worth individuals globally reported owning investment-grade wine.", type: .tip),
                        .text("Despite these strengths, fine wine is not without structural headwinds. Global wine consumption hit a 63-year low of 214.2 million hectolitres in 2024, down 12.6% from the 2017 peak, as generational shifts in drinking behavior and competitive pressure from non-alcoholic alternatives reshape the consumer landscape. (4) Understanding the distinction between fine wine as a collectible asset — which trades on scarcity, provenance, and cultural capital — and wine as a beverage category is essential for investors. The two markets are related but not identical in their dynamics."),
                        .callout(title: "Legal Disclaimer", content: "This module is for educational purposes only and does not constitute financial advice. Wine investment involves significant risk including illiquidity, physical loss, and market volatility. Past performance does not indicate future performance. Please consult a qualified financial advisor before making investment decisions.", type: .warning),
                    ]
                ),

                // MARK: - Section 2: Fine Wine Returns & Indices
                Section(
                    id: "sec_mod_wine_2",
                    title: "📈 2. Fine Wine Returns — What the Data Shows_",
                    content: [
                        .text("The most widely cited benchmarks for fine wine investment performance are the Liv-ex (London International Vintners Exchange) family of indices. Launched in 2001, Liv-ex provides live pricing data on investment-grade wines traded between merchants globally and publishes a series of indices tracking different market segments."),
                        .callout(title: "Key Liv-ex Benchmarks", content: "Liv-ex Investables Index (1988–July 2024): +2,050% total return, ~9.0% CAGR.\nLiv-ex Fine Wine 100 (Jan 2004–Jul 2024): +272.5% total return, ~6.7% CAGR.\nLiv-ex Fine Wine 1000 (Jan 2004–Jul 2024): +288.3% total return, ~7.0% CAGR.\nLiv-ex Fine Wine 1000 (10-year to Q4 2023): +146%.\nSource: Cult Wines / Liv-ex. (3)", type: .info),
                        .text("Independent portfolio data from Cult Wine Investment shows a 9.35% compound annual growth rate since October 2009 through 2024. (5) One-year returns at regional peaks reached exceptional levels: Burgundy +44.1% and Champagne +35.8% in the year to September 2022, before the broader market entered a correction phase."),
                        .text("By region, Italian wines have been the standout performer over the five years to 2025, with the Liv-ex Italy regional index returning +33.7% — compared to Bordeaux's +0.8% over the same period. Bruno Giacosa's Falletto Riserva appreciated +62.5% in 2025 alone, illustrating how individual producer momentum can dramatically outpace index averages. California cult wines have also produced strong long-term results: Screaming Eagle +89.2%, Dominus +65.3%, Harlan +55.5%, and Opus One +57% on Liv-ex since July 2014. (6)"),
                        .callout(title: "The 2022–2025 Market Cycle", content: "Fine wine peaked in summer 2022 — briefly the best-performing asset class, up +20% in a year. A correction of approximately -26.6% followed over 18 months as central bank rate hikes cooled consumer demand. Q4 2024 was the market nadir. Q3 2025 showed the strongest monthly gains in three years, marking the beginning of a recovery cycle. The worst drawdown in Liv-ex recorded history was also the sharpest buying opportunity in a decade.", type: .research),
                        .text("One important structural characteristic is volatility — or rather, the relative absence of it. The Liv-ex 1000 standard deviation is approximately 4.94%, compared to roughly 17% for gold and 15–18% for the S&P 500. (7) This low volatility, combined with the low correlation to financial markets, is a key part of the investment case. However, it also means fine wine is a slow-moving asset — gains accumulate over years, not weeks, and transaction costs are high enough that short holding periods typically produce poor net returns."),
                        .callout(title: "Average Annual Return Ranges", content: "Baseline: 7–10% average annual return on investment-grade wine (2025 consensus).\nTop-tier cult wines: 9–15% depending on vintage and provenance.\nPlatform-managed portfolios: 8–12% per annum net of fees in normal market conditions.\nSource: Knight Frank 2024 Wealth Report; Vin-X; Cult Wines; The Luxury Playbook.", type: .tip),
                        .text("Tax treatment varies significantly by jurisdiction. In the United Kingdom, fine wine classified as a 'wasting asset' — with an expected lifespan under 50 years — is generally exempt from Capital Gains Tax on profits. In-bond storage avoids VAT and duty. In the United States, vineyard owners can utilize IRS Schedule F deductions for soil preparation, trellising, and labor. Investors should consult tax professionals for jurisdiction-specific guidance, particularly as CGT rules evolve. (8)"),
                    ]
                ),

                // MARK: - Section 3: The Auction Market
                Section(
                    id: "sec_mod_wine_3",
                    title: "🔨 3. The Auction Market & Price Discovery_",
                    content: [
                        .text("The fine wine auction market is the primary mechanism for secondary market price discovery and liquidity. It is also the clearest window into the collectible tier of the wine world, where bottles from celebrated producers, exceptional vintages, and legendary cellars change hands at prices that bear little relationship to production cost."),
                        .text("The global fine wine auction market was valued at approximately $480–580 million in 2024, with a projected CAGR of 9.2%, pointing toward a $1 billion+ market by 2033. (9) This figure represents only the auction channel — over-the-counter trading through wine merchants and platforms is considerably larger."),
                        .callout(title: "Major Auction Houses", content: "Acker Wines: $175M in 2024 sales; 35% market share in fine wine auction; $2B+ lifetime sales.\nChristie's: wine and spirits more than doubled year-over-year in 2024.\nSotheby's: strong growth in wine and spirits despite broader market pressures.\nHart Davis Hart, Zachys, and Spectrum also handle significant volume.", type: .info),
                        .text("Auction prices are shaped by several converging forces: critic scores (Robert Parker, Wine Spectator, Decanter, Jancis Robinson), vintage quality, provenance and storage history, production volume, and the psychology of collector demand. A wine's journey from cellar to auction block is itself an asset-qualifying process — provenance gaps, poor storage records, or damaged labels can dramatically reduce a wine's realized price."),
                        .callout(title: "En Primeur — Wine Futures", content: "En primeur is the practice of buying Bordeaux (and some other) wines as futures, before bottling, at a discount to expected release price. The theory: buy early, pay less. The reality: Justin Gibbs of Liv-ex documented that in more than half of all en primeur campaigns since 2005, wines were available more cheaply at physical release than at the original futures price. En primeur is no longer systematically profitable and requires careful vintage-by-vintage evaluation.", type: .warning),
                        .text("The regional composition of the auction market has shifted significantly over the past decade. Bordeaux, once accounting for 90%+ of fine wine trade, fell to approximately 40% of the Liv-ex 1000 by 2024. Burgundy now represents roughly 25%, Champagne 15%, and the remainder is distributed across Italy, Rhône, California, and other regions. This diversification has been a healthy development for investors — it reduces concentration risk and reflects the genuine quality evolution in non-Bordeaux regions. (10)"),
                        .text("The emergence of digital trading platforms has transformed liquidity. Liv-ex itself operates an exchange where accredited merchants trade continuously. Consumer-facing platforms including Cult Wines, WineCap, WineFi, Vin-X, and Vinovest have made fine wine investment accessible to individual investors at lower minimums than traditional merchant relationships required. Vint takes a fractional ownership model, allowing investors to buy shares in specific cases. Each platform carries distinct fee structures, liquidity terms, and portfolio composition strategies."),
                        .callout(title: "Transaction Cost Reality", content: "Auction selling costs: 10–15% seller's commission + 20–25% buyer's premium on the other side of the trade. Professional storage: £12–18/case/year (UK bonded). Insurance: 0.15–0.25% of portfolio value annually. Over a 10-year hold, total transaction and carrying costs can consume 25–35% of gross return. Net return modeling is essential before committing capital.", type: .warning),
                    ]
                ),

                // MARK: - Section 4: Vineyard & Land Investment
                Section(
                    id: "sec_mod_wine_4",
                    title: "🌿 4. Vineyard & Land Investment_",
                    content: [
                        .quote("Land is the only thing in the world that amounts to anything, for 'tis the only thing in this world that lasts.", author: "Margaret Mitchell, Gone with the Wind"),
                        .text("Vineyard land investment is a fundamentally different asset class from fine wine bottle investment. Where bottles offer relatively liquid exposure to secondary market price dynamics, vineyard land is an illiquid real asset with a dual return structure: capital appreciation of the land itself, and operational income from farming, lease arrangements, or winery production. The two can move independently — and in the divergent 2024 data, they did dramatically."),
                        .callout(title: "Burgundy vs. Bordeaux: 2024 Land Data", content: "Burgundy Cote-d'Or vineyard land crossed the EUR 1 million per hectare average in 2024 — up 11%, marking 28 consecutive years of appreciation. Premier Cru Chardonnay land reached EUR 2.55M/ha. Grand Cru land trades above EUR 30M/ha.\n\nBordeaux average AOP land fell 18% in 2024 to EUR 112,500/ha — the fourth consecutive year of decline. Pauillac land fell 32% in a single year.\n\nSource: Decanter; En Primeur Club 2025. (11)", type: .info),
                        .text("The Burgundy story is instructive: a tiny production region with globally recognized appellations, a cultural cachet that transcends wine, and a strictly regulated supply that cannot expand to meet demand. Land there has appreciated in 28 of the last 28 years, producing an estimated CAGR of 5–7% on the land value itself — before any operational income. (11) Compare this to Bordeaux, where oversupply at lower price tiers, the collapse of the Chinese export market, and consumer preference shifts have pushed land values into a multi-year correction."),
                        .text("Vineyard establishment and operational costs are substantial. In California, establishing a new vineyard from bare land costs $30,000–$100,000 per acre, with existing premium Napa Valley vineyards trading at $250,000–$1,000,000+ per acre. Annual operating costs run $6,000–$20,000 per acre. Break-even for a new operation is typically 5–10 years. (12) University of California Davis publishes detailed sample cost studies for specific varietals and regions that provide granular budget models for prospective investors. (13)"),
                        .callout(title: "Winery Equity Valuation", content: "Buying into a winery means acquiring a business, not just land. Industry valuation benchmarks: EV/EBITDA of 3–6x for standard operations, 5–15x for celebrated brands with strong DTC and export channels. Revenue multiples: 1.0–1.5x for commodity producers; 2.0–3.0x for prestige appellations with direct-to-consumer concentration. Operating margins for premium wineries: 15–45%. Hold period: typically 5–10 years with limited exit options outside strategic sale.", type: .info),
                        .text("For international investors, regulatory complexity is significant. In France, the SAFER (Societe d'Amenagement Foncier et d'Etablissement Rural) holds a right of first refusal on agricultural land sales, and foreign investors commonly enter via acquisition of the operating company rather than direct land title. In California, straightforward direct purchase is possible but triggers substantial water rights and environmental review considerations in drought-affected appellations."),
                        .text("The operating return from vineyard investment is modest relative to land values. Regulated lease income in top French AOPs typically generates 1–2% of land value annually — vineyard land investment is primarily an appreciation play, not an income vehicle. Investors who also operate the winery can achieve operating margins of 15–45% on wine revenues, but this requires management expertise, brand investment, and a tolerance for agricultural risk that pure financial investors rarely possess."),
                        .callout(title: "Due Diligence Questions", content: "Water rights: Is the property permitted for the volume required? Who holds the rights?\nRegulatory status: Are there AOP/AOC restrictions on varietals, yields, and farming methods?\nFrench SAFER pre-emption: Has the right of first refusal process been cleared?\nSoil health: Has an independent soil assessment been commissioned?\nClimate trajectory: What is the 30-year climate model for this specific microclimate?", type: .tip),
                    ]
                ),

                // MARK: - Section 5: Regenerative & Biodynamic Vineyards
                Section(
                    id: "sec_mod_wine_5",
                    title: "🌱 5. Regenerative & Biodynamic Vineyards_",
                    content: [
                        .quote("The goal of life is to make your heartbeat match the beat of the universe — to match your nature with Nature.", author: "Joseph Campbell"),
                        .text("Biodynamic viticulture is the most rigorous certification system in winemaking. Based on the agricultural philosophy of Rudolf Steiner (1924), biodynamic farming treats the vineyard as a self-sustaining ecosystem: soil, plant, animal, and cosmos in dynamic relationship. Certified under Demeter International, it requires organic farming as a baseline, then adds holistic practices including composting with fermented medicinal herbs, planting and harvesting according to lunar cycles, and complete prohibition on synthetic inputs."),
                        .callout(title: "Sustainability Hierarchy in Wine", content: "Conventional — Sustainable — Organic — Biodynamic — Regenerative\n\nOrganic: No synthetic pesticides, herbicides, or fertilizers. USDA/EU certified.\nBiodynamic: Organic + holistic ecosystem approach. Demeter-certified. Rudolf Steiner principles (1924).\nRegenerative: Newest tier — soil-first approach; increases organic carbon, biodiversity, water retention. No single global certification standard yet.", type: .info),
                        .text("The global biodynamic wine market was valued at approximately $1.2 billion in 2024, growing at a 12.5% CAGR, with projections pointing toward $3.4 billion by 2033. (14) This is a distinct market from the broader organic wine category ($11.8–13B) — biodynamic represents a premium subset, defined by strict certification requirements and a consumer base willing to pay for philosophical as well as gustatory differentiation."),
                        .text("The investment case for biodynamic wine is documented most clearly through estate performance on the Liv-ex secondary market. Domaine Leflaive in Puligny-Montrachet, which completed its biodynamic conversion under Anne-Claude Leflaive in 1996, has returned +25.73% over 12 months, +34.78% over 24 months, and +80.27% over five years on Liv-ex — placing it among the best-performing producers on the exchange. (15) Chateau Pontet-Canet in Pauillac, which began biodynamic conversion in 2004 and achieved full certification by 2010, has been repriced from Fifth Growth to near-Second Growth quality perception, with current en primeur releases at EUR 72/bottle and consistently near-perfect critical scores. (15)"),
                        .callout(title: "Biodynamic Premium Evidence", content: "Willamette Valley, Oregon: Certified biodynamic Pinot Noir commands $32–$48/bottle wholesale vs. the appellation average of $24.75/bottle — a premium of +29% to +94%.\n\nAcademic finding (ScienceDirect, 2021): Willingness-to-pay for biodynamic wines was higher than conventional, but lower than organic — and significantly increased among consumers educated about biodynamic practices. The premium is real but contingent on consumer awareness.", type: .research),
                        .text("Regenerative viticulture goes further than biodynamic by centering soil health as the primary metric of success. A comprehensive 2024 field trial comparing regenerative and conventional vineyard management blocks produced striking data: regenerative blocks averaged 2.17 tons per acre vs. 1.85 tons for conventional — a +17% yield advantage. Soil organic carbon measured 1.51% in regenerative blocks vs. 0.86% in conventional — a +76% increase. (16) The carbon storage implication is significant: regenerative vineyards sequester an estimated 0.5–1 tonne of CO2 per hectare per year, potentially qualifying for carbon credit income of $5–50 per hectare annually as voluntary carbon markets mature."),
                        .callout(title: "Transition Risk", content: "Converting to biodynamic or regenerative farming carries meaningful short-term yield risk. During the 3–5 year certification period (Demeter requires a minimum of 3 years), yield declines of 8–30% are documented — front-loaded risk that must be modeled into any investment thesis. Total Demeter certification costs run approximately $4,670 for the 3-year process, plus ongoing fees of 0.4–0.6% of wine sales. This is not a fast or cheap conversion.", type: .warning),
                        .text("Institutional capital is beginning to find its way into regenerative agriculture broadly, with wine-adjacent exposure emerging. Tikehau Capital closed a EUR 560 million Regenerative Agriculture Strategy fund in October 2025, with AXA and Unilever as EUR 100 million anchor investors each. (17) Farmland LP received investment from Microsoft's Climate Innovation Fund in November 2024. (17) FarmTogether made its first wine-specific regenerative acquisition in December 2024 — Josephine Vineyard and Pearl Vineyard in Oregon's Willamette Valley — for $5.9 million. These represent early institutional proof points for a category that has not yet produced its own benchmark index."),
                        .text("EU policy is providing meaningful tailwinds for the regenerative transition. The Farm to Fork Strategy targets 25% of EU farmland under organic production by 2030. EU Common Agricultural Policy (CAP) distributes approximately EUR 340 million annually for organic vineyard conversion, plus per-hectare maintenance payments. In the United States, USDA EQIP covers up to 75% of organic certification costs, up to $140,000 per certified farm. (18)"),
                    ]
                ),

                // MARK: - Section 6: The Global Wine Map
                Section(
                    id: "sec_mod_wine_6",
                    title: "🗺 6. The Global Wine Map — Regions, Returns & Climate Shifts_",
                    content: [
                        .text("The geography of fine wine investment is undergoing its most significant reconfiguration in centuries. Climate change is simultaneously threatening established production zones and opening new regions — creating what some analysts call a 'climate refugee' dynamic in vineyard acquisition, as sophisticated buyers move capital toward latitudes and altitudes that will be viable in 2050."),
                        .localWebView(filename: "wine_regions_map", title: "Interactive Global Wine Regions Map", caption: "Tap any pin to explore grape varieties, wine styles, organic presence, notable producers, and investment data for 63 wine regions worldwide. Filter by cluster, organic level, or wine style."),
                        .callout(title: "Regional Return Performance (5-Year to 2025)", content: "Italy (Liv-ex): +33.7%\nBurgundy (Liv-ex): ~+28% (est.)\nCalifornia Cult Wines: +15–89% (wide range by producer)\nBordeaux (Liv-ex): +0.8%\n\nSource: Liv-ex regional data; Cult Wines performance reports. (6)", type: .info),
                        .text("Burgundy remains the apex of the fine wine investment world — the Cote-d'Or's combination of regulatory scarcity, global demand, and the prestige of its classified estates creates price dynamics unlike any other region. The 2024 vintage is expected to be among the smallest in recent history, constraining supply further and applying upward pressure on prices. Italy's emergence as the strongest-performing major region reflects genuine quality improvements in Piedmont (Barolo, Barbaresco) and Tuscany (Super Tuscans, Brunello), combined with the growing influence of collectors from Asia and the United States."),
                        .text("Bordeaux's structural challenges are instructive. The collapse of the Chinese market — which fell from 1.93 billion liters of wine imported in 2017 to 680 million liters in 2023, a 64% decline (19) — removed a major demand driver that had supported Bordeaux prices for a decade. This, combined with the en primeur model's declining credibility and the rise of competitive alternatives, has produced four consecutive years of land value declines and a significant repricing of secondary market bottles at all but the very top estates."),
                        .callout(title: "Emerging Regions Worth Watching", content: "England/UK: Over 1,100 commercial vineyards; 246% hectarage growth 2004–2017. English sparkling wine — from the same chalk seam as Champagne — is winning international medals and attracting serious investment.\n\nDenmark: 90 commercial vineyards today vs. 8 in 2000. Climate warming enabling production that was impossible a generation ago.\n\nHigh-altitude Argentina (Salta/Cafayate): 1,700–3,111m elevation; unique terroir for Torrontes and Malbec.\n\nGeorgia: 8,000 years of winemaking; qvevri clay vessel tradition recognized by UNESCO; growing international collector interest.", type: .research),
                        .text("The climate projections are stark. Under the IPCC's high-emissions scenario, suitable viticulture area globally could shrink by 25–73% by 2050. Southern Spain, parts of southern France, and significant portions of California's Central Valley may become too warm for traditional European varieties. Conversely, England, Wales, parts of Scandinavia, Poland, and higher-altitude regions in the Alps, Andes, and New Zealand South Island are gaining viable viticulture windows. (20)"),
                        .text("California-specific climate risk has become an acute investment consideration. Insurance costs for Napa Valley vineyards have risen from approximately $600 per acre before 2017 to $1,200–$2,000 per acre in 2025, following a series of catastrophic wildfire years. (21) The 2024 fire season produced an estimated $185 million in smoke-related losses in Napa County alone. Smoke taint — the absorption of volatile phenols into grape clusters from wildfire smoke — is now a dual threat to both current vintages and estate valuations."),
                        .callout(title: "Biodynamic Vineyards and Climate Resilience", content: "Research from Geisenheim University found that biodynamic vineyards now outperform conventional counterparts in hot, dry years — the conditions that are becoming more frequent with climate change. Higher soil organic carbon content improves water retention; biodiverse landscapes reduce pest pressure without synthetic intervention. The resilience thesis for regenerative and biodynamic farming becomes more compelling as climate volatility increases.", type: .tip),
                    ]
                ),

                // MARK: - Section 7: Organic Wine & the Global Market
                Section(
                    id: "sec_mod_wine_7",
                    title: "🌍 7. Organic Wine — The Global Market_",
                    content: [
                        .text("The organic wine market represents the intersection of two powerful structural trends: the premiumization of wine consumption and the mainstreaming of sustainability as a purchase criterion. From a market size of approximately $11.8–13 billion in 2024 — roughly 2.5–2.8% of the total wine market by value — organic wine is growing at 10–11.5% annually, nearly double the rate of the overall wine industry. (22)"),
                        .callout(title: "Important Label Note — US vs. EU", content: "The United States requires zero added sulfites to label a wine 'organic wine.' The EU allows up to 100–150 mg/L of added sulfites in organic wine. This explains why very few wines on US shelves carry the 'organic wine' label even when produced from certified organic vineyards — most US producers label as 'made with organic grapes' instead. Investors and consumers should understand this distinction when reading data on organic wine market penetration.", type: .info),
                        .text("Europe dominates global organic wine production — over 77.5% of the market by value — driven by France, Italy, and Spain. Spain holds the global record for certified organic vineyard hectares at 150,000–166,000 hectares, while Austria leads the world in percentage terms, with approximately 25% of all Austrian vineyards certified organic. (23) Italy is the world's second-largest organic vineyard country by hectares with approximately 132,000 certified hectares, led by Sicily, Tuscany, Puglia, and Veneto."),
                        .text("Outside Europe, Chile is the most important organic wine producer and exporter in the Americas. Emiliana Organic Vineyards in Chile's Colchagua and Casablanca valleys manages 1,256 hectares of certified organic and biodynamic land — the largest certified organic winery in the world by area. (24) New Zealand's Central Otago region has achieved extraordinary organic density, with an estimated 23–25% of the entire region now certified, anchored by pioneering estates like Felton Road (biodynamic since 2010) and Rippon."),
                        .callout(title: "Non-Obvious Organic Regions", content: "Georgia: Ancient qvevri winemaking tradition is de facto organic — synthetic inputs are culturally foreign to traditional Georgian viticulture. UNESCO-recognized as an intangible cultural heritage.\n\nLebanon: Chateau Musar has been certified organic since 2006 and practicing organic farming since the 1960s — one of the world's longest organic viticultural histories.\n\nSlovenia: Producers like Movia and Simcic have pioneered natural and biodynamic wine with international acclaim.\n\nHungary: Royal Tokaji and Királyudvar both practice biodynamic farming in Tokaj, adding a sustainability layer to one of Europe's most historic wine cultures.", type: .research),
                        .text("The organic price premium is well-documented: organic wines are priced 20–30% higher than conventional equivalents on average, according to the USDA Economic Research Service. (25) This premium is most pronounced in the $15–40 retail price range, where consumer sustainability awareness is highest. At the investment tier, the biodynamic premium layers on top of the organic premium — the most celebrated biodynamic estates command multiples of appellation peer pricing, though quality improvement and scarcity factors make isolating a pure certification premium methodologically difficult."),
                        .text("From an investment perspective, organic vineyard land commands a 20–30% premium over conventional equivalent land in most markets. Governments in multiple jurisdictions offer substantial financial support for conversion: the EU CAP distributes approximately EUR 340 million per year for organic vineyard conversion, and the USDA EQIP program covers 75% of certification costs up to $140,000 per farm in the United States. (18) These subsidy structures reduce the net cost of transition and improve the long-term investment case for early-adopter estates."),
                        .callout(title: "Fastest-Growing Organic Segments", content: "Canned organic wine: 14.2% CAGR — fastest-growing packaging format.\nOrange wine (skin-contact): $619M in 2024, projected $1.05B by 2035; near-total overlap with organic and natural producers.\nPet-nat (naturally sparkling): +23% year-over-year growth in California, strongly organic-associated.\nRegenerative Organic Certification (ROC): The next premium tier above organic, pioneered by Tablas Creek Vineyard in Paso Robles, California.", type: .tip),
                    ]
                ),

                // MARK: - Section 8: Gen Z, Non-Alcoholic & Market Headwinds
                Section(
                    id: "sec_mod_wine_8",
                    title: "⚖️ 8. Market Headwinds — Gen Z, Non-Alcoholic & Volume Decline_",
                    content: [
                        .text("Any honest analysis of wine as an investment must engage with the structural headwinds facing the wine category. Global wine consumption reached a 63-year low of 214.2 million hectolitres in 2024 — the lowest volume since 1961 — down 12.6% from the 2017 peak. (4) In the United States, wine volume fell 5.8% in 2024 alone. Direct-to-consumer wine sales had their worst year on record, with volume down 10% and value down 5%. (26)"),
                        .callout(title: "Premiumization: The Counterforce", content: "The sub-$10 wine segment is in structural freefall. The $20–$50 tier posted 12% median sales growth in 2024. The industry is selling materially fewer bottles at significantly higher average prices — a premiumization dynamic that supports the investment-grade wine thesis even as the mass market erodes. Fine wine investment operates in the collectible tier where scarcity, not consumption, drives pricing.", type: .info),
                        .text("The most discussed structural force is generational. Generation Z — those born approximately 1997–2012 — drinks approximately 20% less than Millennials at comparable life stages, according to analysis of industry consumption data. (27) Approximately 19–22% of legal-drinking-age Gen Z individuals identify as non-drinkers or very occasional drinkers. However, the data is more nuanced than 'Gen Z doesn't drink': IWSR's March 2025 Bevtrac data showed legal-drinking-age Gen Z consumption actually rising from 66% to 73% of the cohort over two years — the story is moderation and selectivity, not total abstinence. (27)"),
                        .callout(title: "Why Gen Z Drinks Less", content: "Multiple surveys identify overlapping reasons:\n— Health and mental health consciousness\n— Cannabis substitution: 56% of 18–24-year-olds report replacing some alcohol with cannabis\n— GLP-1 medications (Ozempic, Wegovy): Users show a 29% reduction in drinking frequency — a macro-scale pharmacological shift just beginning to register in consumption data (28)\n— Social media and appearance culture\n— Cost of living pressures reducing discretionary spending\n— Growing awareness of WHO statements on alcohol and health risk", type: .research),
                        .text("Cannabis substitution and GLP-1 drug adoption represent the two structural accelerants most concerning for the wine industry's long-term consumer volume trajectory. Neither is reversing. The GLP-1 effect is particularly notable: these drugs reduce addictive behaviors broadly, and early data consistently shows meaningful reductions in alcohol consumption among users. As GLP-1 adoption grows into the tens of millions of users globally, the aggregate consumption impact on alcoholic beverages could be material. (28)"),
                        .text("The non-alcoholic wine market has grown rapidly in this context. Global non-alcoholic wine is estimated at $2–4 billion in 2024, growing at 9–10% CAGR, within a broader no/low beverage category exceeding $13 billion globally. (29) Key brands gaining retail shelf space include Leitz Eins Zwei Zero, Giesen 0%, Oddbird, Thomson & Scott Noughty, and Surely. Athletic Brewing in non-alcoholic beer raised at an $800 million valuation on +60% year-over-year revenue growth in 2024 — the benchmark proof-of-concept for the category's investment potential. (30)"),
                        .callout(title: "Fine Wine Investment: Insulated, Not Immune", content: "The critical distinction for investors: fine wine investment operates in the collectible tier, where scarcity and provenance drive prices — not aggregate consumer demand. The Liv-ex market is influenced far more by Chinese import volumes, currency movements, and collector sentiment than by US Gen Z drinking habits. That said, a multi-decade erosion of the consumer base that introduces younger collectors to wine appreciation represents a long-term demand risk the investment community is beginning to price.", type: .warning),
                        .text("The geographic dimension matters too. The steepest decline in wine consumption over the past decade has come from China. Chinese wine imports fell from 1.93 billion liters in 2017 to 680 million liters in 2023 — a 64% collapse. (19) This has been the single largest driver of Bordeaux's correction, given how much First Growth and Classed Growth demand had been fueled by Chinese collector appetite. European consumers — particularly the French, Italians, and Spaniards with deep cultural roots in wine — have shown far more stable consumption patterns."),
                    ]
                ),

                // MARK: - Section 9: Risk Factors & Due Diligence
                Section(
                    id: "sec_mod_wine_9",
                    title: "⚠️ 9. Risk Factors & Due Diligence_",
                    content: [
                        .text("Fine wine investment carries a distinctive risk profile that differs from both financial asset classes and other tangible asset categories. Understanding the specific risks — and the mitigations available — is essential before committing capital."),
                        .callout(title: "Risk Summary Matrix", content: "Market correction — High severity, medium likelihood. Mitigation: long hold periods; buy during corrections.\nClimate/wildfire — High severity (California), rising likelihood. Mitigation: geographic diversification.\nCounterfeit/fraud — High severity, low-medium likelihood. Mitigation: certified auction houses and platforms only.\nIlliquidity — Medium severity, high certainty. Mitigation: treat as a 5–10+ year investment.\nVintage variability — Medium severity, high frequency. Mitigation: diversify across years and regions.\nTariff/political — Medium severity, episodic. Mitigation: portfolio diversification by region.", type: .warning),
                        .text("Market cycles are the most immediately relevant risk. The 2022–2025 correction of approximately -26.6% on the Liv-ex 1000 — the worst in the exchange's recorded history — caught investors who entered at or near the 2022 peak with significant paper losses. (7) The pattern is historically consistent: wine appreciates strongly during periods of low interest rates and high liquidity, then corrects when monetary conditions tighten. The appropriate response, as documented by RareWine Invest's client communications during the period, is patience — realized returns of +88% (2022), +46.3% (2023), and +18.7% (2024) for those who sold into strength. (31)"),
                        .text("Counterfeit wine is a material risk at the premium end of the market. The Rudy Kurniawan case — in which a collector fabricated bottles of DRC, Petrus, and other blue-chip wines, selling tens of millions of dollars of fraudulent wine at auction — demonstrated how sophisticated counterfeiting can be. (7) The practical mitigation is straightforward: purchase only from established auction houses with professional provenance review, or regulated platforms with documented custody chains. Blockchain-based provenance tracking is being piloted by several estates but is not yet industry standard."),
                        .callout(title: "Climate Risk — The California Case", content: "Insurance costs for Napa Valley vineyards rose from ~$600/acre before 2017 to $1,200–$2,000/acre in 2025. The 2024 fire season produced an estimated $185M in smoke-related losses in Napa County. Smoke taint — phenol absorption into grape clusters — is now a dual threat: direct destruction and quality degradation that can render an entire vintage unmarketable. California's Department of Insurance launched a Sustainable Insurance Strategy in 2025 to address coverage gaps using climate-informed catastrophe models. (21)", type: .warning),
                        .text("Climate risk extends beyond wildfires. Under the IPCC's high-emissions trajectory, 25–73% of current suitable viticulture area globally could become non-viable by 2050. (20) This is not a uniform risk — it represents a redistribution of productive capacity from some regions to others. Investors who understand this dynamic and position capital in climate-resilient regions stand to benefit. Estates with demonstrably higher soil organic carbon through regenerative practices show better drought resilience, making biodynamic and regenerative properties an implicit climate hedge."),
                        .text("For biodynamic and organic producers specifically, the ESG risk set includes a transition-period yield decline of 8–30%, certification costs, and the risk that a premium certification becomes table stakes rather than a differentiator as organic adoption grows toward the mainstream. The greenwashing risk — estates claiming sustainability credentials without verifiable practice — is also real and requires investors to look beyond marketing to third-party certification records. (32)"),
                        .callout(title: "Phylloxera Watch — 2026 Update", content: "Phylloxera, the root louse that devastated European vineyards in the 19th century, has been documented spreading in multiple regions as of March 2026. Climate warming is accelerating spread into previously cool regions that relied on natural temperature-based suppression. Organic and biodynamic vineyards have fewer chemical intervention options, making this an elevated risk for sustainability-certified estates.", type: .warning),
                    ]
                ),

                // MARK: - Section 10: How to Invest
                Section(
                    id: "sec_mod_wine_10",
                    title: "💼 10. How to Invest — Entry Points & Vehicles_",
                    content: [
                        .quote("An investment in knowledge pays the best interest.", author: "Benjamin Franklin"),
                        .text("Wine investment encompasses a spectrum of vehicles ranging from buying a single case of Bordeaux futures to acquiring a Burgundy vineyard. Each vehicle carries different return expectations, liquidity profiles, minimum capital requirements, and management burdens. Understanding the landscape before allocating is fundamental."),
                        .callout(title: "Investment Vehicle Comparison", content: "Bottle/Case Investment: Min ~$1,000–$5,000. Hold 5–12 years. Auction exit 2–8 weeks. Annual cost: storage + insurance ~1% of value.\n\nWine Platforms (Cult Wines, WineCap, Vinovest, Vin-X, WineFi): Min $1,000–£10,000. Hold 3–7 years. Platform manages logistics. Fee: 1.5–2.5% annually.\n\nVineyard Land: Min $500K–$1M+. Hold 10–25 years. Illiquid — 12–36 months to exit. Return: land appreciation + modest lease income.\n\nWinery Equity: Min $1M+. Hold 5–10 years. Very illiquid. Return: brand appreciation + operating margins 15–45%. High management and climate risk.", type: .info),
                        .text("For most individual investors, the practical entry point is either direct bottle or case investment through an established platform or merchant, or allocation to a managed fine wine portfolio service. Platforms like Cult Wines, WineCap, and Vin-X provide professional selection, bonded storage, insurance, and eventual resale in a structure that functions similarly to a separately managed account. Vint and similar fractional platforms allow lower minimums by enabling ownership of shares in specific cases, improving accessibility without sacrificing the underlying asset quality."),
                        .text("Investors specifically interested in regenerative and biodynamic vineyard exposure currently have limited structured options. No dedicated index or fund specifically targeting this segment exists as of 2026. Options include: acquiring direct vineyard ownership and committing to biodynamic conversion (capital-intensive, requires operational expertise); investing through generalist regenerative farmland platforms like FarmTogether or Iroquois Valley with vineyard exposure; or constructing a fine wine portfolio weighted toward certified biodynamic estates — Domaine Leflaive, Pontet-Canet, DRC, Zind-Humbrecht — through existing platforms. (33)"),
                        .callout(title: "Carbon & Ecosystem Service Revenue", content: "Regenerative vineyards sequestering 0.5–1 tonne CO2 per hectare per year may qualify for voluntary carbon credit revenue of $5–$50 per hectare annually under frameworks like Verra's VCS or Gold Standard. This is a nascent revenue stream — most vineyard operators are 2–4 years from first issuance — but as natural capital accounting frameworks (TNFD, SBTN) mature, the ecosystem service value of biodynamic and regenerative land may begin to be reflected in appraisals and investment pricing.", type: .research),
                        .text("Geographic diversification is a core principle for wine portfolio construction. Concentrating exposure in a single region — particularly one with elevated climate, tariff, or market cycle risk — amplifies rather than mitigates overall risk. A well-constructed wine investment portfolio might hold exposure across Burgundy (long-term appreciation, regulated scarcity), Italy (strong momentum, quality trajectory), England (climate-gain region, premium sparkling), and California cult wines (scarcity premium, low supply). The 2025 US-EU tariff resolution — a 15% tariff, lower than the feared 25%+ — demonstrated that geopolitical risk is real but manageable with diversified regional exposure. (34)"),
                        .callout(title: "Questions for Your Advisor", content: "How does fine wine or vineyard investment fit my overall alternative asset allocation?\nWhich vehicle — bottles, platforms, land, or equity — aligns with my liquidity needs and hold horizon?\nHow do I verify provenance and storage integrity for physical wine?\nWhat is the tax treatment of fine wine gains in my jurisdiction?\nHow should I think about climate risk in my geographic exposure?\nIf I am interested in regenerative or biodynamic estates, how do I identify certified producers vs. greenwashing claims?", type: .tip),
                        .callout(title: "Legal Disclaimer", content: "This module is for educational and informational purposes only. It does not constitute financial, legal, or tax advice. Untitled_ LuxPerpetua Technologies does not hold a FINRA license and does not offer investment advisory services. Wine investment involves significant risk including total loss of capital. Past performance of fine wine indices does not guarantee future results. Consult a qualified financial advisor and tax professional before making any investment decision.", type: .warning),
                    ]
                ),

                // MARK: - Section 11: California — Biodynamic & Biodiversity Leader
                Section(
                    id: "sec_mod_wine_11",
                    title: "🌿 11. California — Biodynamic & Biodiversity Leader_",
                    content: [
                        .quote("The land is the source. Everything else is a story we tell about it.", author: "Ted Lemon, Littorai Wines"),
                        .text("California occupies a singular position in American wine: it is simultaneously the country's largest commercial wine producer and its most concentrated laboratory for biodynamic viticulture and biodiversity programming. While the state accounts for roughly 80% of US wine production by volume, a small but highly influential cluster of certified biodynamic, regenerative, and organic estates have established California — particularly Mendocino County — as the US benchmark for sustainable viticulture."),
                        .callout(title: "California Sustainability at Scale", content: "82% of California's wine cases by volume are produced by certified-sustainable wineries.\n54% of California winegrape acres hold at least one sustainability certification.\n23,187 acres are CCOF certified organic — only 4% of the state's 550,000 bearing acres, vs. 18% certified organic in major European wine regions.\nMendocino County holds 10× more Demeter-certified biodynamic acres than any other California grape-growing region.\nSource: California Sustainable Winegrowing Alliance; CCOF 2024 data. (35)", type: .info),
                        .text("The gulf between California's 4% certified organic rate and Europe's 18% is one of the clearest signals of both structural opportunity and market undersupply. As domestic consumer demand for certified organic wine accelerates — driven by health consciousness, Gen Z's 'sober curious' movement's corollary interest in cleaner products, and a growing collector culture around biodynamic producers — the supply constraint becomes a structural premium."),

                        .text("**Mendocino County — America's Biodynamic Capital**\n\nMendocino County's concentration of certified biodynamic viticulture traces directly to the Frey family. Frey Vineyards, founded by Paul and Beba Frey in 1980 in Redwood Valley, is the first certified organic and first certified biodynamic winery in the United States. Their 1,000-acre ranch — rising from 900 to 2,600 feet elevation — holds 90% of its land as undeveloped natural habitat: oak and conifer forests, meadows, upland chaparral, ancient redwood, Douglas fir, and ponderosa pine. The 99-acre vineyard operates within this habitat matrix rather than replacing it. (36)"),
                        .callout(title: "Frey Vineyards — Biodiversity by Design", content: "Demeter certification requires 10% of a farm be preserved as a biodiversity reserve. Frey holds 90% — nine times the minimum. No added sulfites in any wine (the purest expression of the US organic standard). Composts made entirely from on-site winemaking byproducts. Farm animals rotate through the vineyards, delivering manure directly to soil rather than through stored applications. This integrated organism approach is the foundational model for US biodynamic viticulture.", type: .research),
                        .text("Bonterra Organic Estates (the former Fetzer Bonterra label) represents the commercial-scale counterpart to Frey's artisan model. Across 960 acres of Mendocino County estate vineyards, Bonterra achieved Regenerative Organic Certification — the most demanding sustainability credential available — demonstrating that regenerative practices can operate profitably at commercial volume. Jackson Family Wines completed CCOF organic certification for their Napa Valley estate vineyards in 2023 and has committed to transitioning all 120+ California and Oregon ranches to regenerative practices by 2030. (37)"),

                        .text("**Sonoma County — Diversity of Practice**\n\nSonoma County has the broadest sustainability certification mix of any California wine county. Its notable biodynamic estates span the full philosophical range — from Demeter-certified operations to producers who farm biodynamically without carrying the certification."),
                        .text("Benziger Family Winery on Sonoma Mountain holds the county's most fully realized biodynamic ecosystem. The estate is situated in an extinct volcano caldera — a 360-degree bowl at 800 feet elevation with multiple sun exposures, soil profiles, and drainage patterns created by the volcanic geology. All four estate vineyards are Demeter-certified. Insectaries (gardens of flowering annual and perennial plants) are linked by 'habitat highways' across the property, creating continuous corridors for beneficial insects — parasitic wasps, lacewings, and hoverflies that control grape leafhopper and mealybug without pesticides. Sheep and cattle complete the nutrient cycle. Benziger has been certified since 2000 and celebrated 20 years of Demeter certification in 2020. (38)"),
                        .text("Quivira Vineyards in Dry Creek Valley achieved Demeter certification in 2009 but made a deliberate decision in 2015 to withdraw, finding that certain required Demeter practices 'were not having any measurable effect' on the specific ecology of their site. They shifted to CCOF Organic as their primary certification, continuing biodynamic practices selectively. This documented transition is honest and instructive — it surfaces the tension between universal biodynamic protocols and site-specific knowledge. Quivira's most enduring contribution is ecological: as the first Dry Creek winery to invest in active creek restoration, they restored Wine Creek — a coho salmon and steelhead spawning stream running through the center of the estate — and sparked a restoration that now extends 14 miles downstream. (39)"),
                        .text("Littorai, Ted Lemon's estate on the True Sonoma Coast, has farmed biodynamically since 2001 without Demeter certification — a deliberate choice. The coastal fog terroir of Fort Ross-Seaview and Annapolis creates among the most expensive vineyard land in California outside Napa Valley, driven entirely by the marine-fog premium. Littorai's Pinot Noir and Chardonnay are consistent benchmarks for biodynamic coastal California wine."),

                        .text("**Napa Valley — Regenerative at Premium Prices**\n\nNapa Valley's certification landscape skews toward Napa Green and CCOF rather than Demeter — the economics of premium Napa farming favor soil health investment as a value driver without the full Demeter compliance burden. The results, however, are measurable."),
                        .callout(title: "Grgich Hills — Regenerative Cost Efficiency", content: "Grgich Hills Estate — founded by 1976 Judgment of Paris winemaker Miljenko Grgich — achieved Regenerative Organic Certification in 2022. Farming cost: ~$11,000/acre vs. Napa Valley average of ~$15,000. The 27% cost differential reflects reduced purchased inputs (no synthetic fertilizers or pesticides), nitrogen fixed by cover crops, dry-farmed blocks requiring less irrigation, and resilient soil biology reducing emergency interventions.\n\nSoil metrics (Regen Ag Lab): organic matter rose from 3.6 to 4.5 average in one year (126% increase); CO₂-C jumped 175%. Fungal networks rising across the estate. (40)", type: .research),
                        .text("Grgich Hills' biodiversity program is among the most systematic in California. Four vine rows in each replanted block are committed to biodiversity rather than grapevines — planted with flowering cover crops and insectary blends, irrigated through the dry California summer. Multiple pollinator habitat islands and corridors connect these biodiversity strips. Honeybee hives, owl and bird boxes, and raptor perches are distributed throughout. Ducks, chickens, and guinea hens forage through the property; sheep graze in the vineyards; neighboring Hereford cattle work the peripheral land. (41)"),
                        .text("Robert Sinskey Vineyards manages over 200 acres across five Carneros locations (Napa and Sonoma), all CCOF certified organic and Demeter Biodynamic. The biodiversity infrastructure is deliberately visible: hawk perches and owl boxes placed throughout for starling and rodent control; bird and bat boxes for insect management; sheep and chickens serving as living mowers for cover crops. The farm-to-table dimension is integrated into the brand — Rob Sinskey is a trained chef, Maria Helm Sinskey a celebrated cookbook author — making biodiversity a narrative the consumer can taste in. (42)"),
                        .callout(title: "Napa Green Program — 2025", content: "52 vineyards certified across 102 sites and ~5,500 acres. 99 certified wineries. Each vineyard receives a customized carbon farm plan modeled with COMET-Planner, quantifying potential sequestration from cover cropping, reduced tillage, and hedgerow planting. 120+ required best practices. RISE 2025 event marks expansion into formal regenerative certification pathway. Source: Napa Green, 2025. (43)", type: .info),

                        .text("**Paso Robles — Regenerative Frontier**\n\nPaso Robles represents the clearest emerging cluster for California regenerative viticulture. In August 2020, Tablas Creek Vineyard — a partnership between Bordeaux's Perrin family (Château Beaucastel) and importer Robert Haas — became the first winery in the world to achieve Regenerative Organic Certification. The Westside's calcareous soils and continental climate are biologically productive and reward low-intervention farming. Tablas Creek's intensive rotational sheep grazing (approximately 100 head per acre per day on short-duration cycles with extended recovery) builds soil biology without overgrazing. Two adjacent neighbors — Booker Wines and Villa Creek — subsequently achieved ROC; a third, Robert Hall Winery, completed its three-year conversion in early 2025. (44)"),
                        .text("AmByth Estate, certified by Demeter since 2006, was Paso Robles' first biodynamic winery. Founder Phillip Hart dry-farms all vineyards with head-trained vines; approximately one-third are own-rooted — significant in a region where calcareous soils have historically limited phylloxera pressure. Chickens in portable coops range through the vine rows eating insects and fertilizing the soil; cows aerate with their hooves; 600 Spanish-varietal olive trees contribute a diversified product stream within the biodynamic farm organism. (45)"),

                        .text("**Smaller Estates — The Scale Where Biodynamic Is Most Authentic**\n\nThe most fully realized biodynamic farm organisms in California are typically under 50 acres. At this scale, integrated livestock, on-farm composting, insectary systems, and cover crop diversity can be managed as a true closed-loop system. Several Sonoma County small estates are building documented practices worth knowing."),
                        .callout(title: "DaVero Farms & Winery — Healdsburg, Westside Road", content: "Demeter certified + CCOF Organic. One of the most visitor-oriented biodynamic estates in Sonoma, with guided tours explicitly walking through the biodiversity system. Italian varietal wines + biodynamic olive oil from an integrated farm organism. Swallows and other birds are the primary leafhopper control — a pest that conventionally requires spray programs. Sheep and chickens work the same land sequentially. Native flowers, bees, snakes, interplanted olives and figs throughout. Spontaneous fermentation with native yeasts from the biodynamic farm ecosystem. Located on Westside Road in Healdsburg — the highest concentration of biodynamic practice in Sonoma County. (46)", type: .example),
                        .callout(title: "Eco Terreno — Alexander Valley", content: "CCOF Organic + biodynamic practices. Chickens, ducks, and geese range freely through the vineyard blocks as natural pest control. Sheep graze cover crops through winter. One-acre edible garden on the Lyon Vineyard producing vegetables, fruits, and herbs year-round — sold to Bay Area restaurants, creating diversified revenue within the farm organism. On-site compost from cow manure, straw, pomace, and garden waste. Cover crops explicitly cited for moisture retention — directly relevant to wildfire resilience. (46)", type: .example),
                        .callout(title: "Westwood Estate — Annadel Gap, Sonoma Valley", content: "33 acres. Demeter Biodynamic (2016) + CCOF Organic (2017). Sited in the Annadel Gap — the geographic corridor between Sonoma Mountain and Mount Hood through which cool Pacific air rolls in most mornings and evenings. 13 acres Pinot Noir; balance in Rhône varieties. 'Extreme biodiversity' is cited as a core operating principle. Closed nutrient system; all inputs generated on-farm. One of the smallest Demeter-certified estates in California by acreage — and one of the most purely realized biodynamic operations as a result. (43)", type: .example),
                        .callout(title: "Belden Barns — Sonoma Mountain, 1,000 ft Elevation", content: "18.5 acres estate vineyard. Family-owned, eco-conscious farming. Farmstead tours walk visitors through the three-acre vegetable garden and 25-variety apple orchard — the kind of integrated production system biodynamic philosophy advocates. Fresh produce sold directly to Bay Area restaurants. At 1,000 feet on Sonoma Mountain, the site receives reliable cooling and sits above much of the valley fog — a microclimate that reduces irrigation demand and the fire-intensity risk associated with hotter, drier valley floor sites. (46)", type: .example),
                        .callout(title: "Mendocino County — 570 Vineyards, Median 14 Acres", content: "The structural foundation of the US biodynamic wine movement is not a handful of estates — it is 570 Mendocino County vineyards with a median size of 14 acres, 25% certified organic, with 10 times more Demeter-certified biodynamic acreage than any other California region. The small scale is what enables authenticity: integrated livestock, on-farm composting, and diverse cover crops are practical at 14 acres in a way they are not at 500 acres of monoculture viticulture. For investors, this also means supply is genuinely difficult to replicate at scale — the most authentic certified small-farm biodynamic California wine cannot be manufactured by a large acquirer without transforming the operation that made it valuable. (35)", type: .info),
                    ]
                ),

                // MARK: - Section 12: What the Data Shows — Biodiversity & Investment
                Section(
                    id: "sec_mod_wine_12",
                    title: "📊 12. What the Data Shows — Biodiversity & Investment_",
                    content: [
                        .text("The honest framing: biodiversity programming in vineyards — owl boxes, insectary plantings, cover crops, livestock integration, creek restoration — has historically been treated as an ethical preference. What follows is what the research and market data actually show, without editorial slant. Some findings support an investment thesis. Some complicate it. Both are presented here."),

                        .callout(title: "Finding 1 — Secondary Market Premium: Confirmed, with Caveats", content: "iDealwine's 2025 auction barometer: organic and biodynamic wines represent 28.4% of auction volume but 35.6% of auction value. That is a consistent ~25% per-unit premium over non-certified wines across the same auction events.\n\nThe benchmark estates driving this data are predominantly French — Leflaive, Leroy, Pontet-Canet, Coulée de Serrant. California biodynamic producers (Robert Sinskey, Benziger reserves, Littorai) show collector premiums, though not at the same magnitude.\n\nCaveat: the top biodynamic estates are also, in most cases, simply the best terroirs and winemakers in their appellations. The premium may reflect quality as much as certification. Controlled studies isolating certification as the variable from underlying quality are limited. The correlation is clear. Causation is harder to separate. (35)", type: .research),

                        .callout(title: "Finding 2 — Operating Cost Reduction: Documented", content: "Grgich Hills Estate farms its Napa Valley regenerative vineyards for ~$11,000/acre vs. a regional average of ~$15,000. The 27% differential is attributed to eliminated synthetic inputs, nitrogen fixed by cover crop legumes, reduced irrigation on dry-farmed blocks, and lower emergency intervention costs from resilient soil biology. (40)\n\nPeer-reviewed data (PMC5746791): barn owl programs reduce rodent control costs 50–80% vs. rodenticide programs. Insectary plantings reduce pesticide applications 30–60% in high pest-pressure years.\n\nUC Davis / Giannini Foundation (2025): regenerative viticulture over a 30-year horizon averages only 5% lower NPV than conventional — without accounting for any certification premium, carbon credit, or ecosystem service payment. Cost efficiency is real and measurable at the farm level. (40)", type: .research),

                        .callout(title: "Finding 3 — Wildfire Resilience: Partial, Mechanistically Sound", content: "This is the finding that most surprises people. Vineyards — particularly organically farmed ones — have documented fire-resilience properties. The mechanism is physical, not speculative.\n\nGrapevines as firebreaks: well-pruned grapevines hold significant moisture in their green leaves during the growing season. They are stripped of dead wood annually. During the 2020 Glass Fire (Napa/Sonoma), a vineyard was documented blocking fire advancement at its perimeter. Fire managers across the 2017 Tubbs, 2019 Kincade, and 2020 Glass events observed fire slowing or routing around vineyard land. Vineyards are now described in California fire management literature as 'great firebreaks.'\n\nSoil moisture and ignition: NASA SMAP satellite data (Scientific Reports, PMC7335103) confirms fire activity is strongly correlated with pre-fire soil moisture anomalies — drier soil = higher ignition risk. Soil organic matter from cover crops and compost holds more moisture. Biodynamic farming systematically builds soil organic matter over time. Therefore: biodynamic farming → higher SOM → higher soil moisture retention → marginally lower ignition susceptibility at the field scale.\n\nThe honest limit: this does not stop a high-intensity wind-driven fire. The 2020 wine industry losses — $601M in grapes, $3.7B total — included biodynamic vineyards. Smoke taint risk is unaffected by farming practice. The California insurance crisis treats conventional and biodynamic properties identically by location. Biodiversity creates a margin of resilience, not immunity. (26)(35)", type: .research),

                        .callout(title: "Finding 4 — Biodiversity Infrastructure Is Post-Fire Resilient", content: "A 2021 peer-reviewed study (PMC8717278, Huysman & Johnson) tracked 32 barn owls nesting in 24 Napa Valley vineyard nest boxes before and after the 2017 Tubbs Fire, which burned ~60,000 ha surrounding Napa Valley.\n\nKey finding: barn owl habitat selection was resilient to wildfire. Selection patterns before and after the fire were similar. The biodiversity infrastructure continued to function through and after the fire event.\n\nInvestment implication: the pest management ecosystem biodynamic vineyards build — barn owls, insectaries, hedgerows — does not collapse after a wildfire. It recovers faster than conventional inputs that must be re-purchased and re-applied. This is a documented operational advantage in a post-fire recovery scenario, not a hypothetical one. (35)", type: .research),

                        .callout(title: "Finding 5 — Sheep Grazing Reduces Fuel Load", content: "California winemakers are now actively using grazing animals as wildfire prevention tools — reducing the accumulated fuel load in vineyard understory and surrounding land. Modern Farmer (2023): 'fire-prevention sheep' are among the primary proactive wildfire management tools being adopted across wine country.\n\nBiodynamic vineyards that already integrate sheep are performing ongoing fuel-load management as a secondary function of their biodiversity program, without additional cost or equipment. The sheep don't know they are doing wildfire prevention. The effect is the same.", type: .info),

                        .callout(title: "Finding 6 — Land Premium: Documented for Organic, Sparse for Biodynamic Specifically", content: "USDA farmland data shows organic farmland trading at a 20–30% premium over conventional equivalent land in established markets. This is documented.\n\nBiodynamic-specific land premium data is sparse — standard appraisals do not price soil health improvements or certification status as line items. This is an acknowledged gap. The inference is that biodynamic land, as a subset of organic land, participates in the organic premium — but no published data isolates the biodynamic premium specifically.\n\nCalifornia supply constraint: 4% of California's 550,000 bearing wine grape acres are CCOF certified organic, vs. 18% in major European regions. With domestic demand growing at 10%+ CAGR, the supply constraint is structural. (35)", type: .info),

                        .callout(title: "Finding 7 — Brand Equity and DTC: Real but Hard to Quantify", content: "Tablas Creek's world-first ROC certification (2020) generated documented earned media at scale. Benziger's biodynamic tram tours support a visitor-experience premium. Quivira's creek restoration created regional leadership positioning. DaVero Farms' guided biodiversity tours in Healdsburg directly connect visitor experience to farming philosophy — and that connection supports a DTC price point above appellation average.\n\nNone of this is cleanly quantifiable in isolation from brand quality and vineyard location. But the pattern is consistent: certified biodynamic estates with well-articulated biodiversity narratives sustain higher DTC pricing than equivalent-appellation conventional producers.", type: .info),

                        .callout(title: "What the Data Does Not Show", content: "→ Biodiversity certification as a hedge against fine wine market cycles. The 2022–2025 Liv-ex correction (-26.6% peak to trough) affected certified and conventional estates equally.\n\n→ Wildfire immunity. High-intensity wind-driven fires cross vineyard boundaries. The Glass Fire, Tubbs Fire, and Kincade Fire all caused losses at certified sustainable properties.\n\n→ Smoke taint immunity. Smoke management decisions — green harvest, early pick, detailed analysis — are the relevant tools. Farming certification is not.\n\n→ Certification economics neutral at small scale. Demeter and ROC carry real annual costs. Preston Farm & Winery withdrew Demeter certification in 2019. Quivira withdrew in 2015. At under 20 acres, certification overhead is a genuine burden.\n\n→ Poor terroir compensated by certification. A marginal site with a Demeter certificate is still a marginal site. (26)", type: .warning),

                        .callout(title: "How to Read These Findings as an Investor", content: "The data supports a calibrated conclusion: biodiversity and biodynamic farming are correlated with measurable financial benefits across multiple channels — secondary market premium, operating cost efficiency, marginal wildfire resilience, post-fire ecosystem recovery, and emerging revenue stacking. None of these findings prove that certification alone drives return. The best biodynamic vineyards are also well-located, well-farmed, and produce genuinely excellent wine.\n\nThe more defensible framing: biodiversity and regenerative farming practice, at quality-level vineyards, appears to amplify existing advantages rather than create them from nothing. Whether that amplification justifies a certification premium on acquisition price is a question each investment must answer with site-specific diligence.", type: .tip),
                    ]
                ),

            ]
        )
    }

    // MARK: - Module Footnotes
    static let wineModuleFootnotes: [ModuleFootnote] = [
        ModuleFootnote(
            id: "fn_wine_01",
            moduleId: "mod_wine",
            number: "1",
            title: "Wine Market Global Analysis",
            author: "Maximize Market Research",
            source: "Maximize Market Research",
            url: "https://www.maximizemarketresearch.com/market-report/wine-market/189448/",
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_wine_02",
            moduleId: "mod_wine",
            number: "2",
            title: "The 2025 Guide to Investing in Alternative Assets",
            author: "WineCap",
            source: "WineCap Editorial",
            url: "https://winecap.com/editorial/learn/the-2025-guide-to-investing-in-alternative-assets",
            year: "2025"
        ),
        ModuleFootnote(
            id: "fn_wine_03",
            moduleId: "mod_wine",
            number: "3",
            title: "Evaluating the Investment Performance of Fine Wine: Returns and Opportunities",
            author: "Cult Wine Investment",
            source: "wineinvestment.com",
            url: "https://www.wineinvestment.com/learn/magazine/2024/07/evaluating-the-investment-performance-of-fine-wine/",
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_wine_04",
            moduleId: "mod_wine",
            number: "4",
            title: "State of the World Vine and Wine Sector in 2024",
            author: "OIV — International Organisation of Vine and Wine",
            source: "oiv.int",
            url: "https://www.oiv.int/sites/default/files/documents/OIV-State_of_the_World_Vine-and-Wine-Sector-in-2024.pdf",
            year: "2025"
        ),
        ModuleFootnote(
            id: "fn_wine_05",
            moduleId: "mod_wine",
            number: "5",
            title: "Cult Wine Investment Portfolio Performance",
            author: "Cult Wine Investment",
            source: "wineinvestment.com",
            url: "https://www.wineinvestment.com/our-performance/",
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_wine_06",
            moduleId: "mod_wine",
            number: "6",
            title: "Fine Wine Investment Market Outlook and Forecasts 2025",
            author: "The Luxury Playbook",
            source: "theluxuryplaybook.com",
            url: "https://theluxuryplaybook.com/fine-wine-investment-market/",
            year: "2025"
        ),
        ModuleFootnote(
            id: "fn_wine_07",
            moduleId: "mod_wine",
            number: "7",
            title: "Wine as an Investment: Storage, Valuation and Platform Risk",
            author: "Mittchen",
            source: "mittchen.com",
            url: "https://www.mittchen.com/post/wine-as-an-investment-storage-valuation-and-platform-risk",
            year: "2025"
        ),
        ModuleFootnote(
            id: "fn_wine_08",
            moduleId: "mod_wine",
            number: "8",
            title: "Historic Wine Investment Performance — Tax Treatment",
            author: "Vin-X",
            source: "vin-x.com",
            url: "https://www.vin-x.com/historical-wine-performance",
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_wine_09",
            moduleId: "mod_wine",
            number: "9",
            title: "Wine Auction Market Research Report 2033",
            author: "DataIntelo",
            source: "dataintelo.com",
            url: "https://dataintelo.com/report/wine-auction-market",
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_wine_10",
            moduleId: "mod_wine",
            number: "10",
            title: "How to Invest in Fine Wine — Full Guide 2025",
            author: "The Luxury Playbook",
            source: "theluxuryplaybook.com",
            url: "https://theluxuryplaybook.com/how-to-invest-in-fine-wine-2024-full-guide/",
            year: "2025"
        ),
        ModuleFootnote(
            id: "fn_wine_11",
            moduleId: "mod_wine",
            number: "11",
            title: "Burgundy Vineyard Prices Set New Records in 2024",
            author: "Decanter",
            source: "decanter.com",
            url: "https://www.decanter.com/wine/burgundy-vineyard-prices-set-new-records-in-2024-557625/",
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_wine_12",
            moduleId: "mod_wine",
            number: "12",
            title: "Buying a Vineyard in 2025",
            author: "Vinovest",
            source: "vinovest.co",
            url: "https://www.vinovest.co/blog/buy-a-vineyard",
            year: "2025"
        ),
        ModuleFootnote(
            id: "fn_wine_13",
            moduleId: "mod_wine",
            number: "13",
            title: "Sample Costs to Establish a Vineyard and Produce Wine — Livermore Valley",
            author: "UC Davis Agricultural and Resource Economics",
            source: "coststudyfiles.ucdavis.edu",
            url: "https://coststudyfiles.ucdavis.edu",
            year: "2021"
        ),
        ModuleFootnote(
            id: "fn_wine_14",
            moduleId: "mod_wine",
            number: "14",
            title: "Biodynamic Wine Market Research Report 2033",
            author: "Market Intelo",
            source: "marketintelo.com",
            url: nil,
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_wine_15",
            moduleId: "mod_wine",
            number: "15",
            title: "Domaine Leflaive and Pontet-Canet — Biodynamic Estate Case Studies",
            author: "Cult Wines / Liv-ex Power 100; Vinovest analysis of Liv-ex data",
            source: "wineinvestment.com; vinovest.co",
            url: "https://www.wineinvestment.com/us/learn/insights/how-to-invest-in-a-winery-a-guide-to-winery-investment-opportunities/",
            year: "2025"
        ),
        ModuleFootnote(
            id: "fn_wine_16",
            moduleId: "mod_wine",
            number: "16",
            title: "How Green Vineyards Use Biodynamic and Regenerative Methods — 2024 Field Trial Data",
            author: "WineDeals.com / Canopy Magazine",
            source: "winedeals.com",
            url: "https://www.winedeals.com/blog/post/green-vineyards-biodynamic-practices",
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_wine_17",
            moduleId: "mod_wine",
            number: "17",
            title: "Tikehau Capital Regenerative Agriculture Strategy — EUR 560M Final Close",
            author: "InvestInAg; Tikehau Capital Q3 2025 Results",
            source: "investinag.com; tikehaucapital.com",
            url: nil,
            year: "2025"
        ),
        ModuleFootnote(
            id: "fn_wine_18",
            moduleId: "mod_wine",
            number: "18",
            title: "FFAR Seeding Solutions Grant — UC Davis Vineyard Soil Health Program",
            author: "Foundation for Food and Agriculture Research; UC Davis",
            source: "foundationfar.org",
            url: "https://foundationfar.org/news/uc-davis-receives-ffar-grant-to-help-improve-vineyard-soil-health/",
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_wine_19",
            moduleId: "mod_wine",
            number: "19",
            title: "State of the World Vine and Wine Sector in 2024 — China Import Data",
            author: "OIV — International Organisation of Vine and Wine",
            source: "oiv.int",
            url: "https://www.oiv.int/sites/default/files/documents/OIV-State_of_the_World_Vine-and-Wine-Sector-in-2024.pdf",
            year: "2025"
        ),
        ModuleFootnote(
            id: "fn_wine_20",
            moduleId: "mod_wine",
            number: "20",
            title: "Climate Change Impacts on Global Wine Suitability",
            author: "IPCC Sixth Assessment Report",
            source: "ipcc.ch",
            url: "https://www.ipcc.ch/report/ar6/wg2/",
            year: "2023"
        ),
        ModuleFootnote(
            id: "fn_wine_21",
            moduleId: "mod_wine",
            number: "21",
            title: "Climate Risk and Agricultural Assets — California Wildfire Impact (Estimated)",
            author: "AInvest — AI news aggregator. Note: treat as estimate; primary USDA/CDFA source not independently confirmed.",
            source: "ainvest.com",
            url: nil,
            year: "2025"
        ),
        ModuleFootnote(
            id: "fn_wine_22",
            moduleId: "mod_wine",
            number: "22",
            title: "Organic Wine Market Size, Share and Trends Analysis Report",
            author: "Grand View Research",
            source: "grandviewresearch.com",
            url: "https://www.grandviewresearch.com/industry-analysis/organic-wine-market-report",
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_wine_23",
            moduleId: "mod_wine",
            number: "23",
            title: "Austria Organic Wine — 25% of Vineyards Certified Organic",
            author: "Austrian Wine; The Drinks Business",
            source: "austrianwine.com; thedrinksbusiness.com",
            url: nil,
            year: "2025"
        ),
        ModuleFootnote(
            id: "fn_wine_24",
            moduleId: "mod_wine",
            number: "24",
            title: "Emiliana Organic Vineyards — About Our Estate",
            author: "Emiliana Organic Vineyards",
            source: "emiliana.cl",
            url: "https://www.emiliana.cl",
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_wine_25",
            moduleId: "mod_wine",
            number: "25",
            title: "Organic Price Premium Analysis",
            author: "USDA Economic Research Service",
            source: "ers.usda.gov",
            url: "https://www.ers.usda.gov",
            year: "2023"
        ),
        ModuleFootnote(
            id: "fn_wine_26",
            moduleId: "mod_wine",
            number: "26",
            title: "Direct-to-Consumer Wine Shipping Report",
            author: "Sovos ShipCompliant",
            source: "sovos.com",
            url: "https://www.sovos.com/shipcompliant/",
            year: "2025"
        ),
        ModuleFootnote(
            id: "fn_wine_27",
            moduleId: "mod_wine",
            number: "27",
            title: "Gen Z Drinking Behavior — IWSR Bevtrac and Circana Consumer Data",
            author: "IWSR; Circana",
            source: "theiwsr.com; circana.com",
            url: "https://www.theiwsr.com",
            year: "2025"
        ),
        ModuleFootnote(
            id: "fn_wine_28",
            moduleId: "mod_wine",
            number: "28",
            title: "Drinking Differently: GLP-1 and Alcohol",
            author: "KAM Research / Drinkaware — reported in Harpers Wine and Spirit",
            source: "harpers.co.uk",
            url: "https://harpers.co.uk/news/drinkaware-report-glp-1-users-drink-29-less/",
            year: "2025"
        ),
        ModuleFootnote(
            id: "fn_wine_29",
            moduleId: "mod_wine",
            number: "29",
            title: "Non-Alcoholic Wine and No/Low Beverage Market Size — Multiple Sources",
            author: "Multiple market research aggregators — directional estimates",
            source: "Various",
            url: nil,
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_wine_30",
            moduleId: "mod_wine",
            number: "30",
            title: "Athletic Brewing $800M Valuation — General Atlantic Series C",
            author: "Athletic Brewing Company",
            source: "athleticbrewing.com",
            url: "https://www.athleticbrewing.com",
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_wine_31",
            moduleId: "mod_wine",
            number: "31",
            title: "Wine Investment in 2025: Tension and Resolution",
            author: "RareWine Invest",
            source: "rarewineinvest.com",
            url: "https://www.rarewineinvest.com/news/2026/wine-investment-in-2025-tension-and-resolution/",
            year: "2026"
        ),
        ModuleFootnote(
            id: "fn_wine_32",
            moduleId: "mod_wine",
            number: "32",
            title: "Nature-based Solutions to Increase Sustainability and Resilience of Vineyard-Dominated Landscapes",
            author: "ScienceDirect — peer-reviewed",
            source: "sciencedirect.com",
            url: "https://www.sciencedirect.com/science/article/pii/S1439179124000963",
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_wine_33",
            moduleId: "mod_wine",
            number: "33",
            title: "FarmTogether Sustainable Farmland Fund — Josephine and Pearl Vineyard Acquisition",
            author: "FarmTogether",
            source: "farmtogether.com",
            url: "https://www.farmtogether.com",
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_wine_34",
            moduleId: "mod_wine",
            number: "34",
            title: "US-EU Tariff Agreement on Wine and Spirits — July 2025",
            author: "Decanter; The Drinks Business",
            source: "decanter.com; thedrinksbusiness.com",
            url: nil,
            year: "2025"
        ),

        // California Biodynamic & Biodiversity (Sections 11–12)
        ModuleFootnote(
            id: "fn_wine_35",
            moduleId: "mod_wine",
            number: "35",
            title: "California Wine Sustainability Milestones; CCOF Organic Vineyard Acreage",
            author: "California Sustainable Winegrowing Alliance; California Certified Organic Farmers",
            source: "californiasustainablewinegrowing.org; winecountrygeographic.blogspot.com",
            url: "https://www.californiasustainablewinegrowing.org/",
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_wine_36",
            moduleId: "mod_wine",
            number: "36",
            title: "Frey Vineyards — Biodynamic Vineyard",
            author: "Frey Vineyards",
            source: "freywine.com",
            url: "https://www.freywine.com/blog/biodynamic-vineyard",
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_wine_37",
            moduleId: "mod_wine",
            number: "37",
            title: "Bonterra Bets Big on Regenerative Farming; Jackson Family Wines CCOF Certification",
            author: "Wine Spectator; Wine Industry Advisor",
            source: "winespectator.com; wineindustryadvisor.com",
            url: "https://www.winespectator.com/articles/bonterra-boost-regenerative-organic-certification-with-new-wine-release",
            year: "2023"
        ),
        ModuleFootnote(
            id: "fn_wine_38",
            moduleId: "mod_wine",
            number: "38",
            title: "Benziger Family Winery Celebrates 20 Years of Biodynamic Certification",
            author: "Pull That Cork",
            source: "pullthatcork.com",
            url: "https://pullthatcork.com/2020/benziger-family-winery-2/",
            year: "2020"
        ),
        ModuleFootnote(
            id: "fn_wine_39",
            moduleId: "mod_wine",
            number: "39",
            title: "Quivira Vineyards Celebrates 40-Year Commitment to Sustainability",
            author: "BusinessWire",
            source: "businesswire.com",
            url: "https://www.businesswire.com/news/home/20211117005441/en/Quivira-Vineyards-Celebrates-40-Year-Commitment-to-Sustainability",
            year: "2021"
        ),
        ModuleFootnote(
            id: "fn_wine_40",
            moduleId: "mod_wine",
            number: "40",
            title: "Grgich Hills Regenerative Farming; UC Davis / Giannini Foundation Study — Profitability of Regenerative Viticulture in Sonoma County",
            author: "Grgich Hills Estate; Giannini Foundation / ARE Update",
            source: "grgich.com; giannini.ucop.edu",
            url: "https://grgich.com/regenerative-farming/",
            year: "2025"
        ),
        ModuleFootnote(
            id: "fn_wine_41",
            moduleId: "mod_wine",
            number: "41",
            title: "Napa Valley Climate Connection: Cultivating Biodiversity in the Vineyard — Grgich Hills Estate",
            author: "Napa Valley Register",
            source: "napavalleyregister.com",
            url: "https://napavalleyregister.com/opinion/column/napa-climate-biodiversity-grgich-hills-estate/article_4f612de4-3f41-4949-a342-d6056fd48b2d.html",
            year: "2025"
        ),
        ModuleFootnote(
            id: "fn_wine_42",
            moduleId: "mod_wine",
            number: "42",
            title: "Robert Sinskey Vineyards — New Horizons",
            author: "Robert Sinskey Vineyards",
            source: "robertsinskey.com",
            url: "https://www.robertsinskey.com/the-dirt/new-horizons/",
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_wine_43",
            moduleId: "mod_wine",
            number: "43",
            title: "Napa Green Celebrates Over 80 Vineyards & 40 Growers Certified as Regenerative",
            author: "Napa Green",
            source: "napagreen.org",
            url: "http://napagreen.org/news/napa-green-celebrates-over-80-vineyards-40-growers-certified-as-regenerative-climate-smart-napa-green-vineyards/",
            year: "2025"
        ),
        ModuleFootnote(
            id: "fn_wine_44",
            moduleId: "mod_wine",
            number: "44",
            title: "Tablas Creek — First Regenerative Organic Certified Winery in America",
            author: "Tablas Creek Vineyard",
            source: "tablascreek.com",
            url: "https://tablascreek.com/news/2020/tablas_creek_is_the_first_regenerative_organic_certified_roc_winery_in_america",
            year: "2020"
        ),
        ModuleFootnote(
            id: "fn_wine_45",
            moduleId: "mod_wine",
            number: "45",
            title: "AmByth Estate — Vineyard; Dry Farming to Produce Quality Winegrapes",
            author: "AmByth Estate; Agricultural Water Stewards",
            source: "ambythestate.com; agwaterstewards.org",
            url: "https://www.ambythestate.com/vineyard",
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_wine_46",
            moduleId: "mod_wine",
            number: "46",
            title: "DaVero Farms & Winery — Regenerative Farming; Eco Terreno — Farming Practices; Belden Barns — Farmstead; Sonoma County Small Biodynamic Estates",
            author: "DaVero Farms; Eco Terreno; Belden Barns; Sonoma County Tourism",
            source: "davero.com; ecoterreno.com; beldenbarns.com; sonomacounty.com",
            url: "https://davero.com/about/regenerative-farming/",
            year: "2025"
        ),
    ]
}
