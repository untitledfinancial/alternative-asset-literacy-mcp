//
//  BiodynamicModuleData.swift
//  Enhanced App for Alt Assets
//
//  Created by Victoria Case on 2026-06-03.
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//
//  Description: Biodynamic Viticulture — Deep Dive bonus module.
//  Parent module: mod_wine. Synthesized from research compendium compiled March–June 2026.
//  Citations numbered (1)–(27); footnotes listed in biodynamicModuleFootnotes below.
//  Section 8 added June 2026: California biodynamic estates (Frey, Benziger, Tablas Creek, AmByth, Grgich Hills, Robert Sinskey).
//  Sections 9–10 added June 2026: Oregon biodynamic estates and investment connections.
//  Section 11 (formerly 8/9): Questions for producers and advisors.
//

import Foundation

struct BiodynamicModuleData {

    static func loadModule() -> Module {
        Module(
            id: "mod_biodynamic",
            title: "Biodynamic Viticulture — Deep Dive",
            description: "A close study of biodynamic and regenerative winemaking — the philosophy, the certification, the estate case studies, the soil science, and what it all means for the investor.",
            icon: "🌕",
            color: "green",
            heroImageName: "hero_biodynamic",
            sections: [

                // MARK: - Section 1: Rudolf Steiner and the Origins
                Section(
                    id: "sec_mod_bio_1",
                    title: "🌕 1. Rudolf Steiner & the Origins of Biodynamics_",
                    content: [
                        .quote("The plant is not an independent entity. It is part of the landscape, of the cosmos. To understand the plant, one must understand the whole.", author: "Rudolf Steiner, Agriculture Course, 1924"),
                        .text("Biodynamic agriculture was born from a series of eight lectures delivered by the Austrian philosopher and esotericist Rudolf Steiner in June 1924 at Koberwitz, in what is now Poland. Steiner was responding to a request from farmers who had noticed alarming declines in soil fertility, animal health, and seed viability following the widespread adoption of synthetic fertilizers in the early 20th century. His response was not a technical manual — it was a philosophy."),
                        .text("Steiner's core proposition was that a farm is not a collection of separate elements to be optimized independently but a living organism in dynamic relationship with its surroundings — the soil, the plants, the animals, the seasons, and the rhythms of the sun, moon, and planets. This systems-thinking approach, radical at the time, anticipated much of what modern ecology and soil science have since confirmed about the interdependence of agricultural ecosystems."),
                        .callout(title: "Biodynamics in Historical Context", content: "1924: Steiner's Agriculture Course delivered at Koberwitz.\n1928: Demeter association founded in Germany — the first organic certification body in the world, predating the USDA Organic standard by over 70 years.\n1970s: Nicolas Joly begins converting Coulée de Serrant in the Loire Valley — becomes the most visible advocate for biodynamic wine globally.\n1990s–2000s: Major Burgundy domaines (Leflaive, Leroy, Comtes Lafon) adopt biodynamic practices, lending the movement credibility in the fine wine world.", type: .info),
                        .text("Steiner outlined a specific set of preparations — numbered 500 through 508 — that form the practical core of biodynamic farming. The most famous is Preparation 500: cow manure packed into a cow horn and buried in the earth over winter. In spring, the horn is exhumed and the transformed compost is stirred in water for an hour before being sprayed on the soil. The rationale, in Steiner's framework, is that the horn acts as a concentrating vessel for formative cosmic forces during the winter burial, and the rhythmic stirring creates a vortex that potentizes the preparation."),
                        .callout(title: "The Nine Core Preparations", content: "500 — Horn manure: buried cow dung, applied to soil to stimulate root growth and soil microbial life.\n501 — Horn silica: quartz crystal ground and buried in a cow horn over summer; applied to foliage to enhance light absorption and improve fruit quality.\n502–507 — Compost preparations: chamomile, yarrow, valerian, stinging nettle, oak bark, dandelion — each fermented and added to compost to influence specific mineral processes.\n508 — Horsetail tea: applied as a spray to reduce fungal disease pressure.", type: .info),
                        .text("To the skeptic, these preparations read as pre-scientific ritual. To the practitioner, they are a low-cost intervention system with measurable outcomes — not all of which can yet be explained by conventional soil science. The honest investor's position is empirical: what matters is whether biodynamic farming produces measurable differences in soil health, vine resilience, wine quality, and ultimately, investment returns. On the first three counts, a growing body of peer-reviewed research says yes. On the fourth, the emerging evidence is compelling but not yet definitive."),
                    ]
                ),

                // MARK: - Section 2: Demeter Certification
                Section(
                    id: "sec_mod_bio_2",
                    title: "📋 2. The Demeter Certification — What It Actually Requires_",
                    content: [
                        .text("Demeter International is the global body that certifies biodynamic agriculture. Founded in Germany in 1928, it is the oldest organic-equivalent certification organization in the world. (1) Its standards are significantly more demanding than USDA Organic or EU Organic, and the certification process is more rigorous and ongoing."),
                        .callout(title: "Demeter vs. Organic: Key Differences", content: "Organic certification: prohibits synthetic pesticides, herbicides, and fertilizers. Focuses on what you cannot use.\n\nDemeter biodynamic certification: requires everything organic forbids PLUS active implementation of biodynamic preparations (500–508), a diversity of crops and/or animals on the farm, on-farm composting, and alignment with biodynamic calendar rhythms. Focuses on what you must do.\n\nThe distinction is between removal of harmful inputs (organic) and active rebuilding of ecosystem vitality (biodynamic).", type: .info),
                        .text("The path to Demeter certification takes a minimum of three years. The farm must operate biodynamically for the full period before certification is granted — there is no provisional or transitional certification for marketing purposes, though in-conversion status can be disclosed. Annual re-inspection is required. Ongoing certification fees run approximately 0.4–0.6% of annual wine sales revenue, plus administrative costs. The total three-year certification process costs approximately $4,670 for a small to mid-sized operation, not including the labor premium of biodynamic farming itself. (2)"),
                        .callout(title: "Demeter Certification Requirements", content: "Prohibited inputs: all synthetic pesticides, herbicides, fungicides, fertilizers, growth regulators, and GMOs.\nRequired practices: all nine biodynamic preparations (500–508) applied on schedule; on-farm composting; crop diversity; documented observation of biodynamic calendar.\nLandscape requirement: at least 10% of total farm area must be maintained as biodiversity reserve (hedgerows, trees, uncultivated habitat).\nAnimal integration: livestock encouraged; cow manure for Preparation 500 must come from Demeter-certified animals.\nInspection: annual third-party inspection with soil testing.", type: .tip),
                        .text("As of 2024, approximately 17,000–20,000 hectares of vineyard globally carry Demeter biodynamic certification. (3) This represents less than 0.5% of the world's total vineyard area — a level of scarcity that has meaningful implications for premium pricing. France leads by certified area, followed by Germany, Austria, and Italy. Austria is notable for having the highest density of biodynamic producers relative to total vineyard area of any country in the world."),
                        .text("A second biodynamic certification body, Biodyvin, was established in 1995 specifically for wine producers. Based in Burgundy, it operates to Demeter standards but with additional wine-specific requirements, including a commitment to minimizing interventions in the winery as well as the vineyard. Biodyvin members include some of the most celebrated names in French wine — Domaine Leflaive, Domaine Leroy, and Domaine Zind-Humbrecht among them. The two certifications are complementary rather than competitive, and a number of estates hold both."),
                        .callout(title: "Biodyvin — The Wine-Specific Standard", content: "Founded 1995, Burgundy.\nMembership: ~100 estates, primarily French.\nRequirements: Demeter-equivalent field practices + winery minimalism — no acidification, limited SO2, no commercial yeasts, no fining agents except egg white or bentonite.\nNotable members: Domaine Leflaive, Domaine Leroy, Zind-Humbrecht, Coulée de Serrant, Domaine de Villaine.\nThis certification signals the fullest expression of biodynamic philosophy from vine to bottle.", type: .info),
                    ]
                ),

                // MARK: - Section 3: The Biodynamic Calendar
                Section(
                    id: "sec_mod_bio_3",
                    title: "📅 3. The Biodynamic Calendar — Farming by the Cosmos_",
                    content: [
                        .quote("We are not the only beings in the universe that have interests in our crops.", author: "Maria Thun, founder of the biodynamic planting calendar"),
                        .text("One of the most visually striking and intellectually provocative elements of biodynamic viticulture is the biodynamic planting calendar, developed by German researcher Maria Thun over four decades of systematic observation beginning in the 1950s. Thun's calendar, published annually, divides each month into four day-types based on the position of the moon relative to the twelve constellations of the zodiac."),
                        .callout(title: "The Four Day Types", content: "Root days (moon in Earth signs — Taurus, Virgo, Capricorn): Beneficial for root crops; in viticulture, used for pruning and cellar work. Wines are said to taste more closed and tannic.\n\nFlower days (moon in Air signs — Gemini, Libra, Aquarius): Ideal for vine canopy work. Wines said to be most aromatic.\n\nFruit days (moon in Fire signs — Aries, Leo, Sagittarius): Best for harvest and wine tasting. Wines said to express maximum fruit and complexity.\n\nLeaf days (moon in Water signs — Cancer, Scorpio, Pisces): Least favored for wine tasting; associated with vegetal character and reduced expression.", type: .info),
                        .text("Major auction houses and fine wine merchants have quietly incorporated the biodynamic calendar into their operations. Christie's and Sotheby's have been reported to schedule significant tastings on fruit or flower days. Château Pichon Comtesse de Lalande, Yquem, and DRC have all been documented scheduling important trade tastings around the biodynamic calendar. Whether or not the lunar mechanism is real, the cultural adoption of the calendar by influential market participants means it is exerting a real effect on how wine is presented and perceived on its most commercially significant days."),
                        .callout(title: "Scientific Status of the Calendar", content: "Peer-reviewed evidence for the biodynamic calendar's effect on wine quality is mixed. Some controlled studies (including work from Adelaide University and Hochschule Geisenheim) have found measurable differences in wine expression on different calendar day types. Others have found no statistically significant effect. The honest assessment: the calendar's influence on wine tasting perception may be as much psychological as physical — but at the auction and collector level, perception is price.", type: .research),
                        .text("The practical farming application of the calendar is more straightforwardly defensible than its wine-tasting applications. Timing pruning, harvesting, and soil applications around lunar and planetary cycles is a form of precision agriculture with deep roots — pre-scientific farmers worldwide used lunar calendars for planting. What biodynamics adds is a systematic, codified framework for this intuitive practice, combined with the soil-health interventions that produce the most clearly measurable results."),
                    ]
                ),

                // MARK: - Section 4: The Soil Science
                Section(
                    id: "sec_mod_bio_4",
                    title: "🌍 4. Soil as the Asset — Carbon, Microbiome & Water Retention_",
                    content: [
                        .quote("Healthy soil is not dirt. It is a living ecosystem more complex than the Amazon rainforest — and it is the foundation of everything we grow.", author: "David Montgomery, Growing a Revolution"),
                        .text("If there is one area where the investment case for biodynamic and regenerative viticulture is most scientifically solid, it is soil health. Decades of peer-reviewed research, supported by recent large-scale field trials, consistently show that biodynamic and regenerative practices build soil in ways that conventional farming depletes it — and that healthy soil translates directly into vine resilience, reduced input costs, and climate adaptation capacity."),
                        .callout(title: "2024 Field Trial Data", content: "A comprehensive 2024 comparative trial between regenerative and conventional vineyard management blocks found:\n\nAverage yield: Regenerative 2.17 tons/acre vs. Conventional 1.85 tons/acre — a +17% yield advantage for regenerative.\n\nSoil organic carbon: Regenerative 1.51% vs. Conventional 0.86% — a +76% improvement.\n\nThis data inverts the conventional assumption that sustainable farming sacrifices productivity. Source: WineDeals.com / Canopy Magazine field trial reporting. (4)", type: .research),
                        .text("Soil organic carbon is arguably the single most important metric for long-term vineyard value. It drives water retention — reducing drought vulnerability — and supports the microbial communities that make nutrients bioavailable to vines. A 1% increase in soil organic carbon in the top foot of soil increases water-holding capacity by approximately 20,000 gallons per acre. In a Napa Valley context, where irrigation costs and water rights carry significant economic weight, this represents a direct, quantifiable operational advantage."),
                        .text("A peer-reviewed meta-analysis published in OENO One in January 2025 reviewed 15 years of regenerative viticulture research across European and New World vineyards. (5) Key findings: compost and manure applications sustained over five or more years consistently increased soil nitrogen, phosphorus, potassium, organic matter, and microbial biomass relative to conventionally managed controls. Biochar application — a form of charcoal incorporated into biodynamic compost — enhanced carbon sequestration, improved soil water retention, and increased vine leaf water potential during drought stress."),
                        .callout(title: "Carbon Sequestration as Revenue", content: "Regenerative vineyards sequester an estimated 0.5–1 metric tonne of CO2 per hectare per year through soil carbon building alone. Some studies measuring total vineyard ecosystem carbon storage, including woody vine biomass, report 5–7 tonnes CO2 per hectare annually.\n\nAt voluntary carbon market prices of $10–$50 per tonne (2024), this translates to $5–$50 per hectare per year in potential carbon credit revenue — a nascent but real additional income stream as verification standards for agricultural carbon credits mature. (6)", type: .tip),
                        .text("The biodynamic vine's immune response is a specific area of emerging scientific interest. A study published in Scientific Reports (Nature Publishing Group) found that biodynamic vines showed significantly higher amplitude responses to both climatic stressors and pathogen attacks compared to conventional vines — associated with elevated expression of immunity genes, anti-oxidative compounds, and anti-fungal secondary metabolites. (7) In plain terms: biodynamic vines appear to build a more robust internal defense system, reducing reliance on copper sulfate and other permitted inputs for disease management."),
                        .text("For the investor, the soil health story translates into three financial propositions. First, transition value: a vineyard that has been under biodynamic management for ten or more years has built soil capital that is real but not yet reflected in standard appraisals — representing potential embedded undervaluation. Second, resilience value: as climate events make water availability and disease pressure more acute, the operational advantages of biodynamic soil management compound in value. Third, carbon asset value: as natural capital accounting frameworks (TNFD, SBTN) mature, the ecosystem service value embedded in healthy biodynamic soil may begin to appear in formal property valuations."),
                    ]
                ),

                // MARK: - Section 5: Estate Deep Dives
                Section(
                    id: "sec_mod_bio_5",
                    title: "🏰 5. Estate Deep Dives — Case Studies in Biodynamic Investment_",
                    content: [
                        .text("The clearest evidence for the investment case of biodynamic viticulture comes from tracing the trajectories of specific estates before and after their conversions. The following case studies represent the most documented examples of biodynamic conversion correlating with measurable quality improvement, secondary market appreciation, and estate repositioning."),
                        .callout(title: "Domaine Leflaive — Puligny-Montrachet, Burgundy", content: "Conversion led by Anne-Claude Leflaive. Biodynamic practice began 1990; full Demeter certification 1996. Biodyvin member.\n\nLiv-ex performance data:\n+25.73% over 12 months\n+34.78% over 24 months\n+80.27% over 5 years\n\nRanked 9th in Liv-ex Power 100 by price performance momentum. 1996 Chevalier-Montrachet (Parker 95): +43% value since release. Considered the canonical example of biodynamic conversion translating into both estate prestige and measurable secondary market appreciation. (8)", type: .research),
                        .callout(title: "Chateau Pontet-Canet — Pauillac, Bordeaux", content: "Conversion began 2004 (Merlot trial); fully biodynamic by 2005. AB (Agence Bio) organic certification 2010. First major Bordeaux classified growth to achieve full biodynamic certification.\n\nResult: Repriced from 5th Growth quality perception to near-2nd Growth — 'delivering First Growth quality at Fifth Growth price' (Decanter, Wine Spectator). Current en primeur release: EUR 72/bottle on the estate's top-scoring vintages. Investment thesis: biodynamic conversion directly preceded a quality inflection point that permanently repriced the wine upward relative to appellation peers. (8)", type: .research),
                        .callout(title: "Domaine de la Romanée-Conti — Vosne-Romanée, Burgundy", content: "Biodynamic experimentation began approximately 2000; formalized across the domaine by 2007.\n\nMarket position: Most expensive wine in the world. Average bottle price ~$26,000. A 1945 DRC sold for $812,500 in March 2026 — the world's most expensive wine ever sold at auction.\n\nDRC wines account for approximately 25% of all Burgundy trade on Liv-ex. The Burgundy region posted a +23.7% increase in secondary market value in the 12 months prior to 2025 reporting.\n\nNote: DRC's biodynamic conversion cannot be isolated as the singular cause of its returns — producer prestige, micro-terroir, and extreme scarcity are co-factors. DRC represents the apex of a quality argument, not a replicable investment model. (9)", type: .info),
                        .callout(title: "Coulée de Serrant — Savennières, Loire Valley", content: "Nicolas Joly converted Coulée de Serrant to biodynamic farming in 1981 — among the first serious wine estates in the world to do so. Joly is the global movement's most visible advocate, founding the Return to Terroir association of biodynamic producers.\n\nEstate facts: One of only three single-vineyard appellations in France (alongside Romanée-Conti and Château-Grillet). Total production: ~20,000 bottles annually. Current prices: Clos de la Coulée de Serrant $131–$170/bottle; Clos de la Bergerie $101/bottle; Les Vieux Clos $48–$75/bottle.\n\nInvestment note: Less relevant as a pure return play given small production and limited secondary market liquidity, but Joly's 40+ years of documented biodynamic farming provide the movement's most complete longitudinal record. (10)", type: .info),
                        .callout(title: "Domaine Leroy — Vosne-Romanée, Burgundy", content: "Lalou Bize-Leroy converted Domaine Leroy to biodynamic farming in the early 1990s. Biodyvin member.\n\nPricing: Bottles from Leroy command prices of $500–$2,000+ per bottle — 3–8x the price of conventional wines from the same appellation. Some micro-cuvées exceed $5,000/bottle in secondary market trading.\n\nPrinciple: Leroy's biodynamic commitment is inseparable from Lalou Bize-Leroy's radical reduction of yields (often 50% below appellation norms) and obsessive vineyard management. This makes the biodynamic premium impossible to isolate — but the investment performance is undeniable. (8)", type: .info),
                        .text("The pattern across these case studies is consistent: the strongest investment cases are estates where biodynamic conversion preceded or accompanied a quality inflection point — a moment where critical scores, collector demand, and secondary market prices all shifted upward together. The conversion itself did not cause the quality improvement in isolation; rather, it was part of a broader commitment to excellence that made the quality improvement possible. The investor takeaway is nuanced: biodynamic certification is a signal of producer seriousness that correlates with investment performance, but is not in itself a guarantee of it."),
                    ]
                ),

                // MARK: - Section 6: Biodynamic at Scale
                Section(
                    id: "sec_mod_bio_6",
                    title: "⚖️ 6. Biodynamic at Scale — Commercial Reality_",
                    content: [
                        .text("A persistent critique of biodynamic viticulture is that it is viable only for small, artisanal, high-price producers — that it does not scale. The evidence suggests this critique is partially correct but increasingly contested, as larger operations successfully implement biodynamic principles across significant acreage."),
                        .callout(title: "Scale Examples", content: "Emiliana Organic Vineyards (Chile): 1,256 hectares under organic and biodynamic management — the world's largest certified organic winery by area. Demonstrates that the model scales well beyond boutique production in the right agronomic context.\n\nFamilia Torres (Spain/Chile): Combining regenerative viticulture with renewable energy and packaging innovation across multiple large estates. Industry leadership on sustainability at commercial scale.\n\nJackson Family Wines (California): $2.6M regenerative viticulture research program with UC Davis, converting 15% of 14,000-acre operation by mid-2024, targeting 100% by 2030. The largest regenerative viticulture commitment by any single producer in California. (11)", type: .info),
                        .text("The primary commercial challenge at scale is labor. Biodynamic farming requires 300–400 hours of skilled labor per hectare annually, compared to 180–220 hours for conventional mechanized operations. AOC Bordeaux biodynamic production costs approximately EUR 1,923 per tonneau vs. EUR 1,731 per tonneau for conventional — an 11% cost premium at the input level. (12) This cost premium must be recovered through price premiums that, as documented, typically range from 20–94% depending on the producer and market tier."),
                        .text("The labor equation changes significantly in emerging wine regions where land costs are low, conventional farming infrastructure has not yet dominated, and new vineyard development can be designed as biodynamic from the ground up. England, Georgia, and high-altitude Argentina represent three geographies where new biodynamic operations face lower conversion costs because they are establishing fresh rather than converting established conventional vineyards."),
                        .callout(title: "The Organic Conversion Crisis — A Warning", content: "France experienced a significant organic vineyard conversion reversal in 2023–2024. Following years of strong organic conversion rates, a combination of challenging wet vintages (which hit organic producers harder due to limited disease intervention options), falling organic wine premiums at supermarket level, and high energy costs led a notable number of French producers to de-certify from organic — a documented and concerning reversal. The lesson for investors: the economics of organic and biodynamic farming are vulnerable to sequences of difficult vintages and periods of premium compression. Long-term commitment and financial resilience are prerequisites.", type: .warning),
                        .text("Biodynamic farming's relationship with disease pressure deserves specific attention. Copper sulfate is the primary permitted intervention for fungal disease in certified organic and biodynamic viticulture — and even copper accumulates in soils at levels that become toxic over decades of application. The EU has progressively tightened permitted copper application limits, reducing the maximum from 6 kg/ha/year to 3 kg/ha/year in 2023. This forces biodynamic producers to invest more heavily in biodiversity and landscape-level pest management to compensate — further increasing the labor and ecological sophistication required."),
                    ]
                ),

                // MARK: - Section 7: The Investment Case
                Section(
                    id: "sec_mod_bio_7",
                    title: "💰 7. The Investment Case — Does Biodynamic Add Value?_",
                    content: [
                        .quote("The best investment on earth is earth.", author: "Louis Glickman"),
                        .text("The question every investor needs answered directly: does biodynamic certification — the Steiner preparations, the biodiversity reserves, the lunar calendar, the Demeter inspection — translate into measurable financial return? The answer, assembled from secondary market data, academic research, land economics, and operational accounting, is yes — across multiple distinct value channels, not a single speculative premium."),

                        .callout(title: "The Biodynamic Market — Scale and Trajectory", content: "Global biodynamic wine market: $1.2 billion (2024).\nCAGR: 12.5% — among the fastest-growing segments in premium beverages globally.\nProjection: $3.4 billion by 2033.\n\nBiodynamic is the premium tier of the premium tier — defined by strict third-party certification (Demeter, Biodyvin), small production volumes, and a committed collector base. It is distinct from the broader organic wine category ($11.8–13B). Scarcity is structural: there is no mechanism to rapidly expand certified biodynamic supply. (13)", type: .info),

                        .text("**Value Channel 1 — Secondary Market Price Premium**\n\nThe most direct and immediate connection between biodynamic practice and investor return: certified wines trade at a documented per-unit premium in the secondary auction market.\n\niDealwine 2025 auction data shows organic and biodynamic wines at 28.4% of auction volume but 35.6% of auction value — a consistent ~25% per-unit premium over non-certified wines across the same appellations. The benchmark estates are illustrative: Domaine Leflaive has generated +80.27% five-year Liv-ex return; Domaine Leroy commands 3–8x premiums over non-certified appellation peers; Pontet-Canet has been effectively repriced from Fifth to Second Growth quality perception by critics and collectors since its biodynamic conversion. (8)"),

                        .text("**Value Channel 2 — Operating Cost Reduction**\n\nBiodynamic farming eliminates synthetic input spend (fertilizers, pesticides, herbicides, rodenticides) and substitutes biological systems that generate ongoing cost savings. Grgich Hills Estate's certified-regenerative vineyards cost ~$11,000/acre per year to farm — 27% below the Napa Valley average of ~$15,000. Peer-reviewed research documents that barn owl programs reduce rodent control costs 50–80% vs. rodenticide programs; insectary plantings reduce pesticide applications 30–60% in high pest-pressure years. The UC Davis / Giannini Foundation 2025 study found that regenerative viticulture achieves comparable profitability to conventional over a 30-year NPV horizon — averaging only 5% lower NPV without pricing in any premiums, credits, or ecosystem payments. At cost near-parity, the financial argument against biodynamic conversion weakens to near zero."),

                        .callout(title: "Value Channel 3 — Land Premium & Supply Constraint", content: "Certified organic farmland trades at a 20–30% premium over conventional equivalent land in established markets (USDA farmland data). (14)\n\nIn California specifically, only 4% of 550,000 bearing acres of wine grapes are CCOF certified organic — vs. 18% certified in major European wine regions. With domestic organic wine demand growing at 10%+ CAGR, this supply constraint is a structural price floor for certified California wine land.\n\nBiodynamic-specific land premium data is sparse — standard appraisals do not yet price soil health or certification systematically. This is both a current limitation and a future opportunity: natural capital accounting frameworks (TNFD, SBTN) are building the infrastructure to price these values explicitly. When they do, certified biodynamic land will command premiums not yet reflected in today's appraisals.", type: .info),

                        .callout(title: "Value Channel 4 — Brand Equity & DTC Pricing Independence", content: "Biodynamic certification supports DTC pricing that is independent of appellation averages. Collectors and direct buyers pay for the farming story — the ecology, the philosophy, the documented practice — in addition to the wine itself.\n\nThis is difficult to quantify in isolation but is documented through critical attention, earned media, and mailing list pricing structures. Tablas Creek's world-first ROC certification (2020) generated earned media equivalent to significant paid awareness spend. Benziger's biodynamic estate tours command premium visitor spend. Domaine Leflaive's biodynamic commitment is cited by négociants as the primary driver of its above-appellation Burgundy pricing. For bottle investors, DTC pricing power and sustained critical attention both support secondary market price formation over time.", type: .info),

                        .callout(title: "Value Channel 5 — Emerging Revenue Diversification", content: "The forward-looking channel — not yet fully realized, but structurally building:\n\nCarbon credits: Farmland LP and Carbon Friendly submitted the nation's first measured regenerative farming carbon credits to Verra for issuance in 2024, establishing the agricultural carbon verification precedent. (6) Certified regenerative vineyards sequestering 0.5–1 tonne CO₂/hectare/year may qualify for $5–$50/hectare/year in voluntary credit revenue once verified.\n\nConservation easements: creek restoration and Fish Friendly Farming certification qualify for easement payments — a non-correlated cash flow stream.\n\nBiodiversity credits: being actively developed under EU nature restoration mandates and TNFD corporate reporting frameworks. Vineyards with documented pollinator populations and hedgerow density may monetize these within 5–10 years.\n\nThe full stack — wine revenue + DTC premium + carbon credits + ecosystem service payments — is the economic model biodynamic vineyards are building toward. No estate has yet realized all five simultaneously, but Tablas Creek, Grgich Hills, and Jackson Family Wines are each building components of it.", type: .tip),

                        .callout(title: "Policy Tailwinds That Improve the Economics", content: "EU Farm to Fork Strategy: 25% of EU farmland under organic production by 2030 (currently ~9% — massive conversion subsidy required and funded).\nEU Common Agricultural Policy: ~EUR 340M annually for organic vineyard conversion + per-hectare maintenance payments.\nUSDA EQIP (USA): Covers up to 75% of certification costs, up to $140,000 per certified farm.\nUS Inflation Reduction Act: Additional conservation program funding for sustainable agriculture.\n\nThese subsidies materially improve conversion economics — particularly at mid-scale. They function as below-market financing for the transition period, reducing the effective cost of the 3-year Demeter certification conversion. (11)", type: .tip),

                        .text("The institutional capital signal confirms the direction. Tikehau Capital's EUR 560 million regenerative agriculture fund (closed October 2025, anchored by AXA and Unilever) is the clearest proof that major capital allocators treat regenerative agriculture as a serious asset class — not an ESG checkbox. (15) Iroquois Valley Farmland REIT has generated approximately 8% annualized returns since inception across organic and regenerative farmland. FarmTogether's first wine-specific regenerative acquisition (Oregon, December 2024) signals that fractional platforms are developing wine-sector regenerative products. Capital is moving toward this thesis, not away from it."),

                        .callout(title: "Investment Entry Points — Ranked by Accessibility", content: "Tier 1 (most accessible): Fine wine portfolio weighted to certified biodynamic estates via platforms (Cult Wines, WineCap, Vin-X). No native biodynamic filter exists — requires manual producer selection against Demeter or Biodyvin certification lists.\n\nTier 2: Fractional regenerative farmland platforms with vineyard exposure (FarmTogether; Iroquois Valley REIT for organic/regenerative exposure generally).\n\nTier 3: Groupement Foncier Viticole (GFV) — French tax-advantaged vineyard collective with IFI wealth tax exemption and inheritance benefits. Minimum ~€5,000–€50,000.\n\nTier 4: Direct vineyard land acquisition in emerging biodynamic regions — England, high-altitude South America, Etna, Mendocino — where conversion costs are lower and climate trajectory is favorable.\n\nTier 5: Full winery acquisition or development. Capital-intensive, operationally demanding, 10–25-year horizon.", type: .tip),
                    ]
                ),

                // MARK: - Section 8: California — US Biodynamic Leader
                Section(
                    id: "sec_mod_bio_8_ca",
                    title: "🇺🇸 8. California — The US Biodynamic Laboratory_",
                    content: [
                        .text("While the canonical biodynamic estates are French and German — DRC, Leflaive, Leroy, Coulée de Serrant, Zind-Humbrecht, Egon Müller — California has built the most developed biodynamic viticulture ecosystem in the United States, and in certain respects is advancing the model in directions that European producers are watching closely. Specifically: the integration of formal biodiversity programming as a measurable, auditable farming component, and the layering of multiple certification frameworks that create a more rigorous sustainability signal than any single standard alone."),
                        .callout(title: "Mendocino — 10× the Biodynamic Concentration of Any Other California Region", content: "Mendocino County holds 10× more Demeter-certified biodynamic acres than any other California grape-growing region, and roughly 25% of all Mendocino vineyard acreage is CCOF certified organic — about one-third of all certified organic vineyard acres statewide. The concentration traces to Frey Vineyards (1980) establishing a regional culture before commercial scale existed to push in the other direction. Source: Mendocino Winegrowers; CCOF. (16)", type: .info),
                        .text("**Frey Vineyards (Mendocino, Redwood Valley) — First US Biodynamic Winery**\n\nFounded 1980 by Paul and Beba Frey; first certified organic winery in the US; first certified biodynamic winery in the US. The 1,000-acre ranch holds 90% as undeveloped natural habitat — nine times Demeter's required 10% biodiversity reserve minimum. No added sulfites in any wine (the strictest interpretation of the US organic wine definition). All composts made from on-site winemaking byproducts. Farm animals rotate through the vineyards delivering manure directly to the soil. Elevation range 900–2,600 feet across a single property, creating meaningful terroir variation within a single biodynamic farm organism. (17)"),
                        .text("**Benziger Family Winery (Sonoma Mountain) — The Extinct Volcano Model**\n\nDemeter-certified since 2000. The estate occupies a natural extinct volcano caldera — a 360-degree bowl at 800 feet elevation that creates multiple microclimates, soil profiles, and drainage patterns within a compact area. Insectaries connected by 'habitat highways' across the property enable beneficial insects to move continuously without crossing bare ground; this insectary-corridor design has been replicated by producers across Sonoma and Napa. All four estate vineyards certified. Educational tram tours connect consumers directly to the biodiversity system, creating a DTC brand premium that is difficult to quantify but measurably real. (18)"),
                        .callout(title: "AmByth Estate (Paso Robles) — Dry-Farmed Biodynamic", content: "Demeter-certified since 2006; first biodynamic winery in Paso Robles. All vineyards dry-farmed, head-trained — no drip irrigation in one of California's driest wine regions. ~⅓ of vines are own-rooted (ungrafted). Chickens in portable coops range between vine rows, eating insects and fertilizing soil. Cows aerate soil with hooves. 600 Spanish-varietal olive trees provide a diversified product stream within the biodynamic farm organism. Linne calodo soil (calcareous clay loam with limestone cobbles) inoculated with biodynamic preparations. Source: AmByth Estate; Ag Water Stewards. (19)", type: .example),
                        .text("**Tablas Creek (Paso Robles) — First ROC Winery Worldwide**\n\nIn August 2020, Tablas Creek became the first winery in the world to achieve Regenerative Organic Certification — the most demanding sustainability credential available to any agricultural producer. The estate is a partnership between the Perrin family (Château Beaucastel, Châteauneuf-du-Pape) and Robert Haas. Tablas Creek imports Rhône varietals directly from Beaucastel for propagation, maintaining a certified Demeter plant nursery on-site that has become a source for Rhône varieties for other California producers. Sheep graze at approximately 100 head per acre per day on short-duration rotational schedules with extended recovery — a managed intensive grazing approach that builds soil biology without overgrazing and creates diverse groundcover regrowth. Two adjacent neighbors (Booker Wines, Villa Creek) have subsequently achieved ROC; Robert Hall Winery completed its three-year conversion in early 2025, creating a de facto ROC cluster in the Westside Paso Robles sub-appellation. (20)"),
                        .text("**Grgich Hills Estate (Napa Valley) — Regenerative Economics**\n\nFive estate vineyards; CCOF certified since 2006; Regenerative Organic Certified since 2022. Founded by Miljenko Grgich, the winemaker behind the 1973 Chateau Montelena Chardonnay that bested Burgundy's grand crus at the 1976 Judgment of Paris. The estate's regenerative farming approach has produced measurable cost efficiencies: ~$11,000/acre farming cost vs. a Napa Valley average of ~$15,000. The 27% cost differential comes from eliminated synthetic input spend, nitrogen from cover crop legumes, dry-farmed blocks reducing irrigation cost, and resilient soil biology reducing emergency interventions. (21)"),
                        .callout(title: "Grgich Hills — Biodiversity Infrastructure", content: "Four vine rows per replanted block committed to biodiversity plantings (flowering cover crops, insectary blends) — irrigated through summer, not converted back to vines.\nMultiple pollinator habitat corridors and islands across the estate.\nHoneybee hives; owl boxes; bird boxes; raptor perches throughout.\nDucks, chickens, guinea hens foraging the property.\nSheep grazing in-vineyard; neighboring Hereford cattle on periphery.\nSoil organic matter: 3.6 → 4.5 average in one year (126% increase). CO₂-C: +175%. Fungal networks rising across estate. Data: Regen Ag Lab. (21)", type: .research),
                        .text("**Robert Sinskey Vineyards (Carneros, Napa + Sonoma) — Certified Biodynamic at 200+ Acres**\n\nOne of the largest certified biodynamic vineyard operations in California by acreage. Five Carneros locations; all CCOF certified organic and Demeter Biodynamic. Hawk perches and owl boxes placed throughout for starling and rodent control; bird and bat boxes supplementing; sheep and chickens serving as living mowers for cover crops. The farm-to-table dimension — Rob Sinskey trained as a chef, Maria Helm Sinskey is a celebrated cookbook author — integrates biodiversity as a sensory narrative rather than a compliance checkbox. (22)"),
                        .callout(title: "The Certification Ladder — US Biodynamic Context", content: "CCOF Organic: foundation certification; federal NOP compliance; annual inspection.\nDemeter Biodynamic: gold standard; requires 10% biodiversity reserve, biodynamic preparations, three-year transition.\nRegenera­tive Organic Certified (ROC): most demanding; Organic + soil health + animal welfare + social fairness.\nNapa Green: Napa-specific; per-vineyard carbon farm plan (COMET-Planner); 120+ best practices.\nFish Friendly Farming: salmon and steelhead habitat protection; riparian buffer requirements.\n\nMany leading California estates hold multiple certifications simultaneously — Grgich Hills (CCOF + ROC + Napa Green); Robert Sinskey (CCOF + Demeter); Tablas Creek (CCOF + ROC). The stacking of certifications creates a compounding signal for buyers and investors that exceeds any single label.", type: .info),
                    ]
                ),

                // MARK: - Section 9: Oregon — A Different Model
                Section(
                    id: "sec_mod_bio_9_or",
                    title: "🌲 9. Oregon — Biodynamic at a Different Scale_",
                    content: [
                        .quote("Oregon is where the farming culture is. Sustainability isn't a marketing position here — it's the baseline.", author: "Rudy Marchesi, Montinore Estate"),
                        .text("Oregon's biodynamic wine sector is structurally different from California's — and in several important ways, more advanced. While California has pioneering estates (Frey, Benziger, Tablas Creek), Oregon has system-level certification density: 47% of Oregon vineyards are certified sustainable, 70%+ of all US LIVE-certified vineyards are in Oregon, and the Willamette Valley alone hosts 24 or more Demeter-certified wine producers. The culture is the baseline, not the exception."),
                        .callout(title: "Oregon's Certification Infrastructure", content: "Oregon developed LIVE (Low Input Viticulture and Enology) in 1997 — the first certification program of its kind in the US, created by Oregon winegrowers.\n\n47% of Oregon vineyards are certified sustainable — most of any major US wine region.\n35–40% of planted Oregon acreage holds at least one sustainability certification.\n24+ Demeter-certified wine producers in the Willamette Valley.\n70%+ of all US LIVE-certified vineyards are in Oregon.\nCooper Mountain: certified carbon neutral since 2010.\nTroon: world's only Demeter + ROC Gold winery.\nSource: Oregon Wine Board; LIVE; Willamette Valley Wineries Association. (23)", type: .info),
                        .text("**King Estate — North America's Largest Biodynamic Vineyard**\n\nAt 1,033 total acres in the southern Willamette Valley near Eugene, King Estate is the largest certified biodynamic vineyard in North America (Demeter-certified 2016). 465 acres are under vine — 143 acres Pinot Noir, 314 acres Pinot Gris. The Demeter certification required a minimum 10% biodiversity reserve; King Estate committed 150 acres — over 14% of the total property — to protected natural habitat: marshes, riparian corridor, and a remnant of wet prairie that supports up to 200 species of native wildlife, including several listed as rare, threatened, or endangered. The nine Steiner preparations (500–508) are made from herbs, minerals, and animal manures applied as sprays and compost. All fertilizers, pest control inputs, and livestock feed are generated on the farm itself. (23)"),
                        .text("**Troon Vineyard — World's Only Demeter + ROC Gold**\n\nTroon is located not in the Willamette Valley but in the Applegate Valley of the Siskiyou Mountains in Southern Oregon — warmer, drier, suited to Rhône and Italian varieties rather than Burgundian ones. It is the world's only winery with both Demeter Biodynamic certification and Regenerative Organic Certified Gold status simultaneously. Director of Agriculture Garett Long holds a Master's in soil science from UC Davis and co-founded Soil Life Services — bringing scientific measurement infrastructure to an operation most would describe in philosophical terms. Regular soil testing has documented dramatic increases in organic matter since the regenerative transition began. The farm integrates cider apples, a permaculture-style food forest, vegetable and herb gardens, re-wilded honeybee colonies, sheep, chickens, and hay fields on approximately 100 total acres. (24)"),
                        .callout(title: "Soter Vineyards — Seven Species, One Farm Organism", content: "240 acres, Carlton, Oregon (Yamhill-Carlton AVA). Demeter Biodynamic + B Corporation certified.\n\nSoter's stated philosophy: 'We focus more on biodiversity than biodynamics because we believe diversity of insects, plants, animals and humans is key to a more stable, resilient environment.'\n\nLivestock integrated:\n→ Chickens: pest control, fertility, food waste disposal\n→ Ducks: fresh eggs; slug and snail control (more effective than chickens for this; less soil compaction)\n→ Cows: root health, soil vitality, manure for Preparation 500\n→ Goats: brush and terrain management\n→ Sheep: cover crop management; wool; manure\n→ Donkeys: guard animals protecting sheep and goats from predators\n→ Dogs: property protection; livestock companion\n\nFlowering cover crops planted specifically to create insect habitat away from the grape canopy — diverting pest pressure rather than eliminating the insects. (25)", type: .example),
                        .text("**Johan Vineyards — Van Duzer Corridor & 30-Acre Oak Savannah**\n\nA 175-acre Demeter-certified estate in the Van Duzer Corridor AVA, with 87 acres under vine and over 30 acres maintained as a biodiversity preserve of virgin oak savannah and biologically active riparian zones. The Van Duzer Corridor is defined by the Pacific marine gap through which cold wind channels into the Willamette Valley, cooling afternoon temperatures and enabling slow, long ripening seasons. Johan's biodiversity preserve exceeds Demeter's 10% minimum by maintaining 17%+ of total acreage in native habitat. Sheep, chickens, cover crops, and the full Steiner preparation sequence. (23)"),
                        .text("**Cooper Mountain — Pioneer, Carbon Neutral, and Facing a Different Risk**\n\nDemeter certified since 1999; Oregon Tilth organic since 1995. Carbon neutral since 2010. Cooper Mountain represents two things simultaneously: the depth of Oregon's biodynamic commitment, and the specificity of Oregon's land risk. The estate sits on land within Beaverton's urban growth boundary — designated as future urban development. As the city expands, Cooper Mountain will eventually have to relocate its namesake vineyard. This is not a wildfire risk. It is a regulatory risk specific to Oregon's Senate Bill 100 land use framework — a risk that does not exist for estates sited in core rural Willamette AVAs. An investor diligencing any Oregon vineyard property should confirm its position relative to the nearest Urban Growth Boundary. (23)"),
                        .callout(title: "Maysara — 532 Acres, Self-Sufficient Biodynamic at Scale", content: "Founded by Moe and Flora Momtazi (McMinnville AVA). 532 total acres, Demeter certified. The largest single-property biodynamic estate in Oregon by total acreage, with the land area required for genuine closed-loop farming — all nutrient inputs generated on-site.\n\nFarming philosophy (Moe Momtazi): 'Doing things without bringing anything from outside the farm as a source of food for our plants.'\n\nCows central to preparations and soil management. Wild turkeys range freely through the vineyards, eating insects without any human management. Medicinal and dynamic flowers and herbs grown on-property; made into compost teas. (23)", type: .example),
                    ]
                ),

                // MARK: - Section 10: Oregon Investment Connections
                Section(
                    id: "sec_mod_bio_10_or",
                    title: "📈 10. Oregon — The Investment Connections_",
                    content: [
                        .text("The Oregon biodynamic investment case is built on different structural factors than California's. The wildfire risk that suppresses institutional appetite for Napa and Sonoma acquisitions does not apply in the Willamette Valley. What applies instead are three compounding forces: legislative land scarcity, documented capital migration from California, and the industry-leading certification density that creates a quality floor across the region."),
                        .callout(title: "Land Appreciation — 3× the National Average", content: "Oregon farmland appreciated 29% between 2017 and 2022 versus a 7% national average — three times the rate. Oregon Capital Chronicle (2024): 'Value of Oregon farm real estate on the rise, triple nationwide increases.'\n\nThe primary driver identified: a significant increase in California buyers drawn to the Willamette Valley by relative affordability and reduced exposure to drought and wildfire.\n\nNamed institutional buyers now in Oregon: The Family Coppola, Jackson Family Wines, Louis Jadot, Foley Wine Group.\n\nCurrent planted vineyard land prices: Dundee Hills and Ribbon Ridge have recorded sales at $90,000–$100,000/acre. Ribbon Ridge: ~$80,000/acre (2023 specific listing). General planted Willamette Valley: up to $100,000/acre. General plantable: $15,000–$50,000/acre.\n\nComparison: Napa Valley planted vineyard: $250,000–$1,000,000+/acre. (26)", type: .research),
                        .callout(title: "Senate Bill 100 — Legislative Supply Constraint", content: "Oregon's Senate Bill 100 (1973) established mandatory Urban Growth Boundaries around every city in the state. Prime agricultural land outside a UGB is legally protected from urban development.\n\nFor investors this means: Oregon Willamette Valley vineyard land in protected rural zones outside any UGB is subject to both natural supply constraint (finite prime terroir) and legal supply constraint (development prohibited). This is a double scarcity that does not exist in California to the same degree.\n\nThe risk inversion: Cooper Mountain faces eventual UGB displacement — a risk to watch. Estates in core rural AVAs (Dundee Hills, Ribbon Ridge, Yamhill-Carlton, Eola-Amity Hills) carry no equivalent exposure. UGB position should be confirmed in any vineyard acquisition diligence. (27)", type: .info),
                        .text("**The Price Premium — What Data Exists**\n\nOregon Wine Board economic data indicates certified biodynamic Willamette Valley Pinot Noir commands $32–$48/bottle at wholesale versus a Willamette Valley average of $24.75/bottle. That is a $7–$23 per-bottle premium at the wholesale level — before DTC markup. Nearly 30% of certified biodynamic Oregon vineyards report premium pricing power, stronger DTC customer loyalty, and measurable soil improvements.\n\n*Calibration note:* These figures are from aggregated industry sources, not a single independently audited publication. They should be treated as directionally accurate — the premium exists, the specific bounds are estimates. Oregon-specific Liv-ex or auction tracking for biodynamic Pinot Noir does not exist in the same form as Burgundy or Bordeaux index data. The ¡Salud! Oregon Pinot Noir Auction and Willamette: The Pinot Noir Auction are the primary Oregon secondary market venues — neither is an exchange-traded market with continuous pricing."),
                        .callout(title: "The California Exodus — A Structural Tailwind", content: "The California wildfire insurance crisis is not Oregon's problem. Napa County recorded $185M in smoke losses in 2024. Major insurers are exiting high-risk California counties. Institutional vineyard acquisition underwriting is being adjusted to reflect these risks.\n\nOregon's lower wildfire risk, lower land prices per acre, legislative land protection, and higher baseline sustainability certification density position it as the rational alternative destination for institutional wine-sector capital migrating out of California. This migration is already documented and named — it is not speculative.\n\nThe implication for Oregon biodynamic land specifically: as the cheapest certified-sustainable vineyard land with legislative supply protection and a documented institutional buyer base, Oregon biodynamic estates in protected core AVAs are well-positioned in the capital flows that are already underway. (26)", type: .research),
                        .callout(title: "What Oregon Biodynamic Does NOT Resolve", content: "→ Secondary market liquidity. Oregon Pinot Noir, including certified biodynamic estates, does not trade on Liv-ex or equivalent exchanges at meaningful volume. The secondary market is primarily the ¡Salud! auction and the Willamette Valley Pinot Noir auction — both annual events with limited transaction depth.\n\n→ Isolated biodynamic land premium. A Dundee Hills parcel commands $90,000–$100,000/acre whether or not it is Demeter-certified. The biodynamic premium on land value, isolated from the underlying terroir premium, is not separately measurable in current appraisal data.\n\n→ Urban Growth Boundary risk for some properties (notably Cooper Mountain near Beaverton). Any Oregon vineyard acquisition requires UGB position confirmation.\n\n→ Certification cost burden at small scale. Demeter annual fees, inspection costs, and practice compliance overhead are real. Smaller Oregon estates face the same cost-to-benefit calculation as their California counterparts.", type: .warning),
                    ]
                ),

                // MARK: - Section 11 (original 9): Questions for Producers and Advisors
                Section(
                    id: "sec_mod_bio_9",
                    title: "💬 9. Questions for Producers & Advisors_",
                    content: [
                        .text("Whether you are investing in biodynamic wine as a collector, evaluating a vineyard acquisition, or advising clients on sustainable tangible asset allocation, the following questions are designed to move past marketing language to verifiable practice."),
                        .callout(title: "Questions to Ask a Biodynamic Producer", content: "1. Which certification body certifies your biodynamic practice — Demeter, Biodyvin, or both? When was certification first granted?\n2. Can you share your most recent inspection report or certification documentation?\n3. What is the percentage of your total farm area maintained as biodiversity reserve (Demeter requires 10% minimum)?\n4. How do you source your biodynamic preparations — do you make them on-farm or purchase from certified suppliers?\n5. What has been your yield trend over the past five years relative to your pre-conversion average?\n6. Have you had any de-certification events or lapses in certification continuity?", type: .tip),
                        .callout(title: "Questions for a Financial Advisor on Biodynamic Wine Investment", content: "1. Can you identify which wines in this proposed portfolio carry verified biodynamic certification vs. those that are simply described as 'sustainable'?\n2. How does your platform screen for certified biodynamic producers vs. producers who use sustainability marketing without third-party verification?\n3. What is the expected additional premium for certified biodynamic estates vs. conventional equivalents in this portfolio — and how was that estimated?\n4. How are you thinking about the transition yield risk for any vineyards that are currently in-conversion?\n5. What is your view on the timing of natural capital accounting changes affecting biodynamic land valuations?", type: .tip),
                        .callout(title: "Red Flags — Greenwashing Signals", content: "Biodynamic or regenerative claims without named, verifiable certification (Demeter, Biodyvin, ROC).\nMarketing use of biodynamic aesthetics (moon imagery, preparation language) without documented practice.\nNo on-farm composting or documented use of Preparations 500–508.\nProducers who describe themselves as 'practicing biodynamically' but have not pursued certification after multiple seasons.\nCarbon credit claims without Verra, Gold Standard, or equivalent third-party verification.", type: .warning),
                        .text("The biodynamic wine sector, because of its cultural richness and philosophical depth, is particularly susceptible to sophisticated greenwashing. A producer who uses the language of biodynamics — the moon, the preparations, the living soil — without the substance of certified practice is not an outlier; they are common. For investors, this means that certification documentation is not optional diligence. It is the floor."),
                        .text("At the same time, there exists a meaningful category of excellent producers who farm biodynamically in practice but have not pursued certification — sometimes from philosophical objections to certification bureaucracy, sometimes from the cost and administrative burden of the process. Nicolas Joly's influence has inspired many producers who follow his practices without carrying his paperwork. Evaluating these producers requires deeper due diligence: farm visits, direct conversations with vignerons, and consultation with specialist merchants or sommeliers who know the estates firsthand."),
                        .callout(title: "Legal Disclaimer", content: "This module is for educational and informational purposes only. It does not constitute financial, legal, or tax advice. Untitled_ LuxPerpetua Technologies does not hold a FINRA license and does not offer investment advisory services. Wine and vineyard investment involves significant risk including total loss of capital. Past performance does not guarantee future results. Consult a qualified financial advisor before making any investment decision.", type: .warning),
                    ]
                ),
            ]
        )
    }

    // MARK: - Module Footnotes
    static let biodynamicModuleFootnotes: [ModuleFootnote] = [
        ModuleFootnote(
            id: "fn_bio_01",
            moduleId: "mod_biodynamic",
            number: "1",
            title: "Demeter International — History and Standards",
            author: "Demeter International",
            source: "demeter.net",
            url: "https://www.demeter.net",
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_bio_02",
            moduleId: "mod_biodynamic",
            number: "2",
            title: "Demeter Certification Process and Costs",
            author: "Demeter USA",
            source: "demeter-usa.org",
            url: "https://www.demeter-usa.org",
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_bio_03",
            moduleId: "mod_biodynamic",
            number: "3",
            title: "Organic and Biodynamic Vineyard Area — Global Data",
            author: "Frontiers in Sustainable Food Systems / OIV",
            source: "frontiersin.org",
            url: "https://www.frontiersin.org/journals/sustainable-food-systems/articles/10.3389/fsufs.2023.1241062/full",
            year: "2023"
        ),
        ModuleFootnote(
            id: "fn_bio_04",
            moduleId: "mod_biodynamic",
            number: "4",
            title: "How Green Vineyards Use Biodynamic and Regenerative Methods — 2024 Field Trial",
            author: "WineDeals.com / Canopy Magazine",
            source: "winedeals.com",
            url: "https://www.winedeals.com/blog/post/green-vineyards-biodynamic-practices",
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_bio_05",
            moduleId: "mod_biodynamic",
            number: "5",
            title: "Regenerative Viticulture Meta-Analysis — 15 Years of Research",
            author: "OENO One — International Journal of Vine and Wine Sciences",
            source: "oeno-one.eu",
            url: "https://oeno-one.eu",
            year: "2025"
        ),
        ModuleFootnote(
            id: "fn_bio_06",
            moduleId: "mod_biodynamic",
            number: "6",
            title: "Farmland LP and Carbon Friendly — First Measured Regenerative Farming Carbon Credits to Verra",
            author: "Farmland LP",
            source: "farmlandlp.com",
            url: "https://www.farmlandlp.com",
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_bio_07",
            moduleId: "mod_biodynamic",
            number: "7",
            title: "Biodynamic Vine Immune Response Study",
            author: "Scientific Reports — Nature Publishing Group",
            source: "nature.com",
            url: "https://www.nature.com/scientificreports",
            year: "2023"
        ),
        ModuleFootnote(
            id: "fn_bio_08",
            moduleId: "mod_biodynamic",
            number: "8",
            title: "Biodynamic Estate Case Studies — Domaine Leflaive, Pontet-Canet, Leroy",
            author: "Cult Wines / Liv-ex Power 100; Vinovest Liv-ex data analysis",
            source: "wineinvestment.com; vinovest.co",
            url: "https://www.wineinvestment.com/us/learn/insights/how-to-invest-in-a-winery-a-guide-to-winery-investment-opportunities/",
            year: "2025"
        ),
        ModuleFootnote(
            id: "fn_bio_09",
            moduleId: "mod_biodynamic",
            number: "9",
            title: "DRC 1945 Bottle Sale — World Record",
            author: "Cult Wines — Fine Wine in 2025: Repricing, Liquidity and Clearer 2026",
            source: "wineinvestment.com",
            url: "https://www.wineinvestment.com/learn/magazine/2025/12/fine-wine-in-2025-repricing-liquidity-and-clearer-2026/",
            year: "2026"
        ),
        ModuleFootnote(
            id: "fn_bio_10",
            moduleId: "mod_biodynamic",
            number: "10",
            title: "Coulée de Serrant — Estate and Production Data",
            author: "Coulée de Serrant / Nicolas Joly",
            source: "coulee-de-serrant.com",
            url: "https://www.coulee-de-serrant.com",
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_bio_11",
            moduleId: "mod_biodynamic",
            number: "11",
            title: "FFAR Seeding Solutions Grant — Jackson Family Wines and UC Davis Regenerative Viticulture Program",
            author: "Foundation for Food and Agriculture Research; UC Davis",
            source: "foundationfar.org",
            url: "https://foundationfar.org/news/uc-davis-receives-ffar-grant-to-help-improve-vineyard-soil-health/",
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_bio_12",
            moduleId: "mod_biodynamic",
            number: "12",
            title: "Biodynamic Production Cost Premium — Bordeaux AOC Data",
            author: "Internal Research Compendium — Regenerative and Biodynamic Vineyard Investment",
            source: "wineinfo research compendium",
            url: nil,
            year: "2026"
        ),
        ModuleFootnote(
            id: "fn_bio_13",
            moduleId: "mod_biodynamic",
            number: "13",
            title: "Biodynamic Wine Market Research Report 2033",
            author: "Market Intelo",
            source: "marketintelo.com",
            url: nil,
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_bio_14",
            moduleId: "mod_biodynamic",
            number: "14",
            title: "Organic Farmland Price Premium",
            author: "AcreTrader / industry estimates",
            source: "acretrader.com",
            url: "https://www.acretrader.com",
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_bio_15",
            moduleId: "mod_biodynamic",
            number: "15",
            title: "Tikehau Capital Regenerative Agriculture Strategy — EUR 560M Final Close",
            author: "InvestInAg; Tikehau Capital Q3 2025 Results",
            source: "investinag.com; tikehaucapital.com",
            url: nil,
            year: "2025"
        ),

        // California Section (Section 8)
        ModuleFootnote(
            id: "fn_bio_16",
            moduleId: "mod_biodynamic",
            number: "16",
            title: "Mendocino County Biodynamic Acreage; CCOF Organic Statistics",
            author: "Mendocino Winegrowers Inc.; California Certified Organic Farmers",
            source: "mendowine.com; winecountrygeographic.blogspot.com",
            url: "https://mendowine.com/",
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_bio_17",
            moduleId: "mod_biodynamic",
            number: "17",
            title: "Frey Vineyards — Biodynamic Vineyard; America's First Organic & Biodynamic Winery",
            author: "Frey Vineyards; Frank's Spirits and Wine",
            source: "freywine.com; franksspirits.com",
            url: "https://www.freywine.com/blog/biodynamic-vineyard",
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_bio_18",
            moduleId: "mod_biodynamic",
            number: "18",
            title: "Benziger Family Winery — Biodynamic Estate; 20 Years of Certification",
            author: "Benziger Family Winery; Pull That Cork",
            source: "benziger.com; pullthatcork.com",
            url: "https://benziger.com/sustainable-farming/",
            year: "2020"
        ),
        ModuleFootnote(
            id: "fn_bio_19",
            moduleId: "mod_biodynamic",
            number: "19",
            title: "AmByth Estate — Vineyard; Dry Farming to Produce Quality Winegrapes",
            author: "AmByth Estate; Agricultural Water Stewards",
            source: "ambythestate.com; agwaterstewards.org",
            url: "https://www.ambythestate.com/vineyard",
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_bio_20",
            moduleId: "mod_biodynamic",
            number: "20",
            title: "Tablas Creek — First Regenerative Organic Certified Winery in America; A Step Forward for Regenerative Farming",
            author: "Tablas Creek Vineyard; Daniel Moretti Wine Line",
            source: "tablascreek.com; dmwineline.substack.com",
            url: "https://tablascreek.com/news/2020/tablas_creek_is_the_first_regenerative_organic_certified_roc_winery_in_america",
            year: "2025"
        ),
        ModuleFootnote(
            id: "fn_bio_21",
            moduleId: "mod_biodynamic",
            number: "21",
            title: "Grgich Hills Regenerative Farming; Napa Valley Climate Connection — Cultivating Biodiversity",
            author: "Grgich Hills Estate; Napa Valley Register; Giannini Foundation",
            source: "grgich.com; napavalleyregister.com; giannini.ucop.edu",
            url: "https://grgich.com/regenerative-farming/",
            year: "2025"
        ),
        ModuleFootnote(
            id: "fn_bio_22",
            moduleId: "mod_biodynamic",
            number: "22",
            title: "Robert Sinskey Vineyards — New Horizons; Biodynamic & Organic Vineyards in Carneros",
            author: "Robert Sinskey Vineyards; NorthBay Biz",
            source: "robertsinskey.com; northbaybiz.com",
            url: "https://www.robertsinskey.com/the-dirt/new-horizons/",
            year: "2024"
        ),

        // Oregon Sections (Sections 9–10)
        ModuleFootnote(
            id: "fn_bio_23",
            moduleId: "mod_biodynamic",
            number: "23",
            title: "Oregon Wine a Leader in Biodynamics; King Estate — Largest Biodynamic Vineyard in US; Five Great Biodynamic Wineries in the Willamette Valley",
            author: "Wine Industry Advisor; King Estate Winery; WillametteValley.org",
            source: "wineindustryadvisor.com; kingestate.com; willamettevalley.org",
            url: "https://wineindustryadvisor.com/2020/03/24/oregon-wine-leader-biodynamics/",
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_bio_24",
            moduleId: "mod_biodynamic",
            number: "24",
            title: "Troon Vineyard — Regenerative Organic Certified; World's Only Demeter + ROC Gold Winery",
            author: "Troon Vineyard; PR Newswire; Vintner Project",
            source: "troonvineyard.com; prnewswire.com; vintnerproject.com",
            url: "https://www.troonvineyard.com/regenerative-organic-certified",
            year: "2022"
        ),
        ModuleFootnote(
            id: "fn_bio_25",
            moduleId: "mod_biodynamic",
            number: "25",
            title: "Soter Vineyards — Biodynamics at the Ranch; B Corporation Certification",
            author: "Soter Vineyards; B Lab",
            source: "sotervineyards.com; bcorporation.net",
            url: "https://www.sotervineyards.com/biodynamics",
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_bio_26",
            moduleId: "mod_biodynamic",
            number: "26",
            title: "Oregon Farmland Value Up 23% — Triple Nationwide Increases; Oregon Agriculture by the Numbers",
            author: "Oregon Capital Chronicle; OSU Extension Service",
            source: "oregoncapitalchronicle.com; extension.oregonstate.edu",
            url: "https://oregoncapitalchronicle.com/2024/06/14/value-of-oregon-farm-real-estate-on-the-rise-triple-nationwide-increases/",
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_bio_27",
            moduleId: "mod_biodynamic",
            number: "27",
            title: "Oregon Senate Bill 100 — Statewide Land Use Planning",
            author: "Oregon Encyclopedia; Oregon Environmental Council",
            source: "oregonencyclopedia.org; oeconline.org",
            url: "https://www.oregonencyclopedia.org/articles/senate_bill_100/",
            year: "2024"
        ),
    ]
}
