//
//  WhiskyModuleData.swift
//  Enhanced App for Alt Assets
//
//  Created by Victoria Case on 2026-06-11.
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//
//  Description: Whisky & Whiskey Investing module data.
//  Covers: secondary market, cask investment, production mechanics, geography & terroir,
//  regional investment profiles, sustainability & biodiversity (large and small distilleries),
//  distillery equity (public stocks, PE, community shares, crowdfunding, Waterford case study),
//  risk factors, and investment vehicles.
//  Synthesized from research compendium compiled June 2026.
//  Citations numbered (1)–(77); footnotes listed in whiskyModuleFootnotes below.
//

import Foundation

struct WhiskyModuleData {

    static func loadModule() -> Module {
        Module(
            id: "mod_whisky",
            title: "Whisky & Whiskey Investing",
            description: "From rare Scotch auction records and cask ownership programmes to the geology of Kentucky limestone, Islay peat, and the craft distilleries rewilding Scotland — a comprehensive look at whisky as an alternative asset class.",
            icon: "🥃",
            color: "amber",
            heroImageName: "hero_whisky",
            sections: [

                // MARK: - Section 1: Whisky as an Alternative Asset
                Section(
                    id: "sec_mod_whisky_1",
                    title: "🥃 1. Whisky as an Alternative Asset_",
                    content: [
                        .quote("Too much of anything is bad, but too much good whisky is barely enough.", author: "Mark Twain"),
                        .text("Whisky occupies a unique position in the alternative asset universe. Unlike wine — another consumable collectible — whisky does not deteriorate once bottled. A sealed bottle of single malt Scotch is effectively immortal; its contents will not change. This characteristic, combined with fixed production from closed distilleries and the legally regulated scarcity of certain regional styles, has elevated whisky from a connoisseur's pleasure into a recognized investment category tracked by dedicated indices and traded on global auction platforms."),
                        .text("The global whiskey market was valued at $77.92 billion in 2025, projected to reach $116.01 billion by 2033 — a compound annual growth rate of 5.1%. (1) Within that broader market, investment-grade rare whisky behaves very differently from the commodity segment, exhibiting price dynamics driven by secondary market demand, provenance, closed distillery scarcity, and the psychology of collector culture."),
                        .callout(title: "Two Investment Angles", content: "Whisky investing operates on two distinct tracks that can be pursued independently or together:\n\n1. Whisky on the Market — buying bottles or casks of matured or maturing whisky with the intention of reselling at a profit on the secondary market.\n\n2. Whisky in Production — purchasing casks of new-make or young spirit from a distillery, holding through maturation, and exiting via trade sale, bottling, or secondary cask market.\n\nBoth tracks have distinct mechanics, timelines, tax treatments, and risk profiles covered in the sections below.", type: .info),
                        .text("The investment case for whisky rests on several structural features. First, genuine scarcity: closed distilleries produce no new stock, and as each bottle is consumed or each cask opened, the remaining supply contracts permanently. Second, a long track record: the Rare Whisky 101 Apex 1000 Index returned +407.8% from inception in December 2012 through 2024 — an average annual growth rate of approximately 16.7% over more than a decade. (2) Third, a favorable tax position in the UK: whisky casks are classified as 'wasting chattels' and are generally exempt from Capital Gains Tax when sold by private investors — one of the few appreciating tangible assets with this treatment. (3)"),
                        .callout(title: "Portfolio Allocation Insight", content: "The Knight Frank Luxury Investment Index tracked rare whisky as the best-performing luxury asset class over the prior ten years through 2022 — ahead of art, fine wine, watches, handbags, coins, and cars. A hypothetical $1 million allocated to the KFLII in 2005 had grown to $5.4 million by end 2024; the same sum in the S&P 500 grew to $5.0 million over the same period. (4) Whisky should be considered alongside other tangible alternatives rather than as a replacement for diversified financial assets.", type: .tip),
                        .callout(title: "Legal Disclaimer", content: "This module is for educational purposes only and does not constitute financial advice. Whisky investment involves significant risk including illiquidity, physical loss, fraud, and market volatility. The whisky cask market is unregulated — there is no recourse to the Financial Services Compensation Scheme. Past performance does not indicate future performance. Please consult a qualified financial advisor before making investment decisions.", type: .warning),
                    ]
                ),

                // MARK: - Section 2: Returns & Indices
                Section(
                    id: "sec_mod_whisky_2",
                    title: "📈 2. Returns — What the Data Shows_",
                    content: [
                        .text("The most authoritative indices tracking secondary market bottle prices are published by Rare Whisky 101 (RW101), a data platform that monitors auction results across all major UK platforms. The Knight Frank Luxury Investment Index provides broader context, benchmarking whisky against other luxury collectible categories."),
                        .callout(title: "Key Rare Whisky 101 Benchmarks", content: "Apex 1000 Index (Dec 2012–2024): +407.8% total return, ~16.7% average annual growth rate.\nJapanese 100 Index (2014–2024): approximately +580%.\nYamazaki Sub-Index (end 2014–2024): +917.56%.\nKnight Frank Luxury Index (20-year to 2024): rare whisky up approximately +280% over 10 years despite 2022–2024 correction.\nSource: Rare Whisky 101; Knight Frank Wealth Report 2024. (2)(4)", type: .info),
                        .text("The whisky market experienced a significant correction from its 2022 peak. Values fell approximately 9% in both 2023 and 2024, leaving the market roughly 19.3% below its summer 2022 high. (4) This correction followed an irrational COVID-era bull market in 2021–2022, during which speculative demand and global liquidity drove prices well above sustainable fundamentals. Signs of stabilization emerged in H1 2025."),
                        .callout(title: "The 2022–2025 Market Cycle", content: "Secondary market value tracked by major platforms dropped approximately 40% from a peak of £8.9 million to £5.4 million in the monitored period, with transaction volumes falling 26%. (5) This mirrors the fine wine correction of the same period. In both cases, investors who held through the correction and sold into the prior peak captured the best returns; those who bought at the 2021–2022 peak are still underwater in many cases.", type: .warning),
                        .text("For cask investment, historical net returns (after storage, insurance, and warehousing fees) have averaged approximately 11.7% per annum for 8-year-old Scotch bought new and sold between 2015 and 2024. High-end casks from premium distilleries can deliver 20%+ but carry commensurately higher risk and illiquidity. (6) A more conservative long-term expected return for quality investment-grade bottles is 8–12% per annum, reflecting the post-correction market normalization."),
                        .callout(title: "Comparative Returns Context", content: "Over 10 years to 2024: rare whisky still up approximately +280%, ahead of art (-18.3% in 2024), fine wine (-9% in 2024), and comparable to global equity returns over the same period. The important caveat: the 10-year figure encompasses an extraordinary bull run. A more conservative long-run expected return is 8–12% per annum for quality investment-grade expressions. Source: Knight Frank Luxury Investment Index 2024. (4)", type: .research),
                        .text("The market is bifurcated in ways that aggregate index returns obscure. The top 5% of Japanese whisky lots delivered a CAGR of 9.2% from 2015 to 2024; the bottom 50% of lots posted a CAGR of -1.3% over the same period. Only the top tier of any region or distillery has consistently appreciated. This concentration means that selection — the specific distillery, expression, and vintage — matters enormously, and that average index returns are not representative of the median lot's performance."),
                    ]
                ),

                // MARK: - Section 3: The Secondary Market
                Section(
                    id: "sec_mod_whisky_3",
                    title: "🔨 3. The Secondary Market & Price Discovery_",
                    content: [
                        .text("The secondary whisky market has matured into a global trading floor, with thousands of bottles changing hands monthly through dedicated online and traditional auction platforms. Unlike fine wine, which trades across multiple established auction houses, whisky has developed its own specialist platforms that operate on monthly cycles with transparent online bidding."),
                        .callout(title: "Major Auction Platforms", content: "Whisky Auctioneer (Perth, Scotland): The largest dedicated online whisky auction by lot volume. Monthly auctions; 10–15% seller and buyer fees; most transparent price discovery for the mass market.\n\nScotch Whisky Auctions: 6,000–7,000 lots per month; ~10% buyer's premium; competitive on cost.\n\nWhisky.Auction (London): 3,000–4,000 lots; more curated; 15% buyer's premium (+VAT).\n\nBonhams & Christie's: Handle the most prestigious consignments. Christie's London sold two full casks of Karuizawa for £4.25 million in 2025 — a record for cask lots.\n\nHart Davis Hart (Chicago): Primary US entry point for Scotch, bourbon, and Japanese whisky.", type: .info),
                        .text("Price discovery in the whisky market is driven by several converging forces: distillery reputation, age statements, production volume, whether the distillery is still operating, independent bottler reputation, and the broader collector psychology that amplifies demand for allocated or limited releases. The single most powerful appreciation driver is distillery closure — when a distillery stops producing, its existing stock becomes finite, and each bottle consumed permanently reduces the remaining supply."),
                        .callout(title: "What Makes a Bottle Appreciate", content: "Distillery reputation: Macallan achieved £12 million in auction value January 2024–July 2025 — nearly 4× the next closest brand.\n\nClosed/ghost distilleries: Port Ellen (closed 1983), Brora (closed 1983), Karuizawa (closed 2000) — finite, diminishing stock; most powerful driver.\n\nAge statements: Investment grade begins ~18 years. 21, 25, 30+ year expressions command the strongest premiums.\n\nLimited editions: Annual special releases, one-time collaborations, distillery exclusives.\n\nIndependent bottlers: Gordon & MacPhail, Berry Bros & Rudd, Adelphi, Cadenhead's — a second layer of collectibility on top of the distillery premium. Note: G&M announced cessation of independent bottling in 2024, making extant bottles more valuable. (7)", type: .tip),
                        .text("The independent bottling trade represents one of the most sophisticated corners of the whisky investment world. Independent bottlers purchase casks from distilleries — often decades-old stock — and release small quantities under their own labels, frequently at cask strength and without chill-filtration. A 4-year-old Ledaig bottled by Berry Bros & Rudd that originally sold for £35 later fetched £180 at auction — illustrating how the bottler's imprimatur can dramatically amplify value on top of the underlying spirit."),
                        .callout(title: "Notable Auction Records", content: "Macallan Valerio Adami 60YO 1926: £2,187,500 ($2,734,254) — current world record for any whisky. Sold at Sotheby's London, 2023.\n\nKaruizawa two full casks: £4,250,000. Christie's London, 2025.\n\nKaruizawa 52-Year-Old: $372,684. Hong Kong, 2024.\n\nPappy Van Winkle (unique expression): $162,500. US auction, 2024.\n\nKaruizawa bottle (from £12,000 to £100,100 within two years, 2013–2015).\n\nSource: Guinness World Records; Christie's; auction house reports. (8)", type: .research),
                        .callout(title: "Transaction Cost Reality", content: "Auction selling costs: 10–15% seller's commission, plus 10–15% buyer's premium on the other side of any trade.\nStorage: £10–30 per cask per year (bonded warehouse); variable for bottle collections.\nInsurance: Specialist broker required for high-value collections; standard warehouse insurance may not cover full market value.\nOver a 10-year hold, total transaction and carrying costs can materially reduce gross return. Net return modeling is essential before committing capital. (6)", type: .warning),
                    ]
                ),

                // MARK: - Section 4: Cask Investment — Whisky in Production
                Section(
                    id: "sec_mod_whisky_4",
                    title: "🪣 4. Cask Investment — Whisky in Production_",
                    content: [
                        .quote("Whisky is liquid sunshine.", author: "George Bernard Shaw"),
                        .text("Cask investment is the whisky-specific vehicle that has no direct parallel in other collectible categories. The investor purchases a whole barrel of maturing spirit stored in an HMRC-bonded warehouse. The whisky continues to mature — legally, chemically, and economically — while in the investor's ownership. The result, ideally, is a liquid asset that increases in complexity and market value over time."),
                        .callout(title: "How Cask Ownership Works", content: "Ownership is evidenced by a delivery order or warehouse receipt held in the investor's name at a licensed bonded warehouse. Title transfer occurs via warehouse documentation, not physical exchange. Key documents: a valid delivery order in the investor's name, warehouse receipts, and HMRC warehouse approval records.\n\nCritical warning: The 2024 Cask Whisky Ltd fraud investigation centered on investors who lacked proper delivery orders proving ownership. Common frauds include multiple investors sold the same cask, non-existent casks, and guaranteed return promises (illegal under UK financial promotion rules). The sector is unregulated — no FCA oversight, no FSCS recourse. (9)", type: .warning),
                        .text("The maturation timeline is the core mechanic of cask investment. In Scotland, spirit must mature for a minimum of 3 years in oak casks in a licensed Scottish warehouse before it can legally be called Scotch whisky. Investment grade begins in earnest around 12 years, with the premium tier running from 18 to 25+ years. Value increases as the spirit matures, taking on color, flavor, and complexity from the wood — but the angel's share erodes volume throughout."),
                        .callout(title: "Maturation Timeline & Investment Grade", content: "Under 3 years: Legally not Scotch whisky.\n3–8 years: Entry-level; limited investment premium.\n8–12 years: Bottler interest begins; standard category.\n12–18 years: Investment grade starts in earnest.\n18–25 years: Premium investment tier; exponential value per additional year.\n25+ years: Ultra-premium; risk of over-extraction from wood increases.\n\nThe Angel's Share: In Scotland's cool, damp climate, a cask loses 1–2% of its volume per year to evaporation. Over 20 years, a 200-litre cask may contain only 140–160 litres. This concentrates the spirit but permanently reduces the volume available for sale. (6)", type: .info),
                        .text("Cask type is one of the most significant investment variables. The choice of cask — its size, wood species, and prior contents — shapes the flavor of the matured whisky and, by extension, the bottler demand and secondary market value. First-fill sherry butts from reputable cooperages (e.g., Tevasa in Spain) are the most prized by the market and command the highest exit prices, but also the highest entry cost. Ex-bourbon barrels are the most abundant (US law requires single-use bourbon barrels, flooding the market with cheap used casks) and the most accessible investment entry point."),
                        .callout(title: "Cask Types & Investment Notes", content: "Ex-Bourbon Barrel (~200L): Vanilla, caramel, coconut. Cheapest, most abundant. Reliable entry-level investment.\n\nHogshead (~250L): Similar to barrel but reconstructed American oak. Good value investment grade.\n\nSherry Butt (~500L, European or American oak): Rich dried fruit, chocolate, spice. Most expensive; commands strongest market premium.\n\nPort Pipe (~550–650L): Fruit, sweetness, pink tinge. Rare; highly desirable.\n\nSTR (Shaved, Toasted, Re-charred): Red fruit, vanilla, faster maturation. Pioneered by Kavalan for hot-climate aging.\n\nMadeira Drum (~650L): Honeyed, nutty, floral. Rare; used by Glenfarclas, Balvenie. (6)", type: .info),
                        .text("Exit routes from cask investment include: sale as a maturing cask to a trade buyer (bottler or blending house) — the most efficient exit, potentially executed in 4 days for liquid markets; transfer of ownership documentation to another investor; or bottling, which triggers HMRC excise duty (approximately £28.74 per litre of pure alcohol as of 2024). Investors should model excise duty as a significant cost in any bottling exit scenario."),
                        .callout(title: "Key Risks in Cask Investment", content: "Fraud: Unregulated sector. No FCA protection. Multiple documented cases including £13M US scheme (FBI arrest, 2022) and Cask Whisky Ltd liquidation (2024).\n\nAngel's Share: 1–2% volume loss per year permanently — a compounding cost.\n\nIlliquidity: No open exchange, no instant exit. Time to liquidate: weeks to months in normal markets, longer in a downturn.\n\nMarket concentration: Macallan dominates auction value. Obscure distilleries may have no viable trade buyer.\n\nStorage risk: Warehouse fire, flood, or structural failure can destroy an irreplaceable asset. Verify insurance coverage explicitly. (9)", type: .warning),
                    ]
                ),

                // MARK: - Section 5: Geography & Terroir — How Place Creates Taste
                Section(
                    id: "sec_mod_whisky_5",
                    title: "🗺 5. Geography & Terroir — How Place Creates Taste_",
                    content: [
                        .text("The flavor of whisky is not accidental. It is the product of geology, hydrology, climate, vegetation, grain, and still architecture working together across years or decades of maturation. Understanding these geographic variables is not merely an academic exercise — it is the foundation of the investment case for geographic authenticity and regional scarcity."),
                        .callout(title: "The Science Is Settled", content: "For decades, the terroir concept in whisky was treated as romantic marketing. That changed in 2021 when a peer-reviewed study published in the journal Foods identified more than 42 flavor compounds in whisky, half of which were directly and demonstrably influenced by the barley's growing terroir. Two Irish farms with different soil chemistry (one limestone-based, one higher in iron) produced analytically and sensorially distinct whiskies from the same distillery and production process.\n\nThe soil chemistry traveled from the ground, through the plant, through malting, mashing, fermentation, and distillation — into the glass. (10)", type: .research),

                        .text("**Water & Geology**\n\nThe limestone geology of Kentucky is the defining example. Woodford Reserve, like all Kentucky bourbon distilleries, draws from water filtered through a thick shelf of Ordovician limestone — the same formation that makes the Bluegrass region famous for thoroughbred racehorses. The limestone performs two critical functions: it strips iron from the water (iron is toxic to bourbon, reacting with wood compounds to produce off-flavors), and it enriches the water with calcium and magnesium — yeast nutrients that support healthy fermentation and the lactic acid bacteria responsible for the characteristic sour mash profile. Since bourbon can comprise up to 60% water by volume at bottling proof, the mineral profile of source water is not a trivial variable. It is a primary ingredient. The geology of Kentucky's limestone belt cannot be transplanted — and this irreplicability is one structural source of bourbon's investment premium. (11)"),
                        .text("In Scotland, the granite Cairngorm massif that feeds the River Spey produces some of the world's softest, lowest-mineral water — directly enabling the light, clean, fruity character of Speyside malt. Islay's water passes through peat bogs before reaching the mash tun, arriving slightly acidic and already carrying phenolic precursors. Japan's Yamazaki Distillery was deliberately sited at the confluence of three rivers whose water had been celebrated in Japanese poetry since the Nara period (710–794 CE); the soft, filtered water from snowmelt and sedimentary rock filtration supports the delicate, elegant spirit that founder Shinjiro Torii sought to produce."),

                        .text("**Peat & Vegetation**\n\nPeat is the geological and botanical archive of a landscape — formed over thousands of years from the partial decomposition of sphagnum moss, heather, sedge, and coastal vegetation in waterlogged, low-oxygen conditions. When burned to dry malted barley in the kiln, it releases volatile organic phenolic compounds that adsorb onto the wet barley and survive mashing, fermentation, and distillation into the final spirit."),
                        .callout(title: "Phenolic Compounds in Peated Whisky", content: "Guaiacol — smoky, woody, savory\n4-methylguaiacol — smoky, sweet-spicy\nCresols — iodine, hospital, TCP (the signature of Islay)\nSyringols — sweet, spicy, vanilla-adjacent\n\nPhenol levels are measured in PPM (parts per million) at the malt stage. Note: levels drop significantly through distillation — a 50 ppm malt may yield a spirit at 15–20 ppm. Laphroaig: ~40–45 ppm. Ardbeg: ~50 ppm. Lagavulin: ~35 ppm. Highland Park (Orkney): ~20 ppm.", type: .info),
                        .text("The critical investment insight: vegetation composition determines phenolic character, not just quantity. Islay peat is coastal bog peat rich in decomposed seaweed and sea moss — when burned, it produces the iodine, TCP, brine, and tarry cresol compounds that define the Islay style. Orkney peat (used by Highland Park) comes from clifftop moorland rich in heather roots, without seaweed — producing a sweeter, more floral, aromatic smoke with honey and warm spice. These phenolic fingerprints are measurable and region-specific, making Islay and Campbeltown whisky among the most readily authenticated styles. Geographic authenticity in whisky is verifiable chemistry, not just marketing."),

                        .text("**Climate & Maturation**\n\nClimate is the throttle on the maturation reaction. Kentucky's dramatic continental temperature swings — summer highs reaching 90–100°F, winters below freezing — cause barrels to breathe aggressively: spirit expands into the charred oak stave on warming, contracts and pulls back saturated with extracted compounds on cooling. This cyclical exchange extracts vanillin, oak lactones, caramelized sugars, and eugenol rapidly and deeply. The Angel's Share runs 3–4% per year. A well-matured 8-year Kentucky bourbon may carry more extractive wood character than a 12-year Scotch precisely because the climate has run the reaction faster."),
                        .callout(title: "Angel's Share by Climate", content: "Scotland (cool, damp): 1–2% per year. Slow maturation; age statements carry verifiable weight.\nKentucky (continental extremes): 3–4% per year. Rapid extraction; age less central to premium.\nTaiwan (subtropical monsoon): 10–15% per year. One Taiwanese year ≈ 3–5 Scottish years in extraction intensity.\nIndia (tropical): 11–12% per year. One Indian year ≈ 3 Scottish years. A 4-year-old Amrut has the equivalent of 12 Scottish years of barrel contact.\nAustralia Tasmania (cool maritime): Similar to Scotland; barrels can actually increase in ABV over time.\nSource: Kavalan; Amrut; Glass Revolution Imports; multiple distillery documentation. (12)", type: .research),
                        .text("**Grain & Heritage Varieties**\n\nGrain choice is the flavor decision made before geography, climate, or cask type enter the equation. Corn provides bourbon's sweetness and body; rye adds spice and pepper; wheat softens and adds honey notes; unmalted barley (mandatory in Irish Single Pot Still whiskey) contributes a distinctive spiciness and creaminess unique to the Irish style. Malted barley — the universal base for single malt — varies dramatically by variety. The industry shift from heritage varieties (Golden Promise, Bere barley, Maris Otter) to modern high-yield varieties improved economics but traded away flavor. Golden Promise yields ~380 litres per tonne vs. ~400 for modern varieties; Bere barley only ~350 — but both carry a richer, oilier, more textured grain character that survives into the finished spirit. Several craft distilleries now use heritage varieties as a deliberate quality and scarcity signal, creating a direct parallel to single-vineyard wine."),
                    ]
                ),

                // MARK: - Section 6: Regional Investment Guide
                Section(
                    id: "sec_mod_whisky_6",
                    title: "🌍 6. Regional Investment Guide_",
                    content: [
                        .text("The geography of whisky investment spans seven distinct production traditions, each with its own regulatory framework, flavor identity, and investment mechanics. Understanding regional character — and the geographic factors that create it — is the foundation of intelligent portfolio construction."),

                        .callout(title: "Speyside", content: "Geographic factors: Granite Cairngorm watershed; soft, low-mineral water; River Spey and tributaries; cool, consistent inland-maritime climate.\n\nFlavor: Light to medium body; high ester character (apple, pear, peach); floral, vanilla, honey; sherry cask maturation adds dried fruit and Christmas cake richness.\n\nInvestment: Home to the world's most-collected Scotch brands. Macallan holds the £2.19M world auction record. Glenfiddich and Glenlivet dominate volume. The broadest consumer appeal creates the most liquid collector market — but also the most competitive investment space. Macallan operates in its own tier; other Speyside distilleries offer more accessible entry points. (7)", type: .research),
                        .callout(title: "Islay", content: "Geographic factors: Island isolation; Atlantic maritime climate; coastal peat bogs rich in seaweed-influenced vegetation; sea air permeating warehouses during decades of maturation.\n\nFlavor: Heavily phenolic (40–50 ppm); iodine, brine, TCP, seaweed, tar; underneath: rich vanilla and coastal sweetness. Eight active distilleries on an island of ~3,000 people.\n\nInvestment: Ardbeg, Laphroaig, Lagavulin, Bowmore command secondary premiums. Port Ellen (closed 1983, reopened 2024) remains supremely valuable — old stock is finite and irreplaceable. The phenolic fingerprint is measurable and region-specific, supporting authentication. Islay's geographic isolation creates permanent production constraints that underpin long-term investment value. (7)", type: .research),
                        .callout(title: "Campbeltown", content: "Geographic factors: Kintyre Peninsula; exposed to North Atlantic and Irish Sea; maritime bogs providing mildly peated, coastal-influenced water. Formerly the whisky capital of Scotland with 30+ distilleries — now three.\n\nFlavor: Salty, briny maritime character; light to medium peat smoke; oily, waxy texture; the distinctive 'Campbeltown funk.' Springbank is the only Scottish distillery to mash, distill, mature, and bottle entirely on-site — 100% self-sufficient.\n\nInvestment: Three active distilleries, all small-batch, serving a global collector market. Springbank is the most collectible actively-producing Scottish distillery after Macallan — £3 million at auction January 2024–July 2025. The rarest regional designation in Scotch whisky. (7)", type: .research),
                        .callout(title: "Highland & Lowland", content: "Highland: Scotland's largest and most geographically diverse region. No single style — ranges from smoky, coastal Talisker to unpeated, sherried Dalmore. Investment standouts: Dalmore limited editions, Clynelish (prized by blenders), Glenmorangie premium expressions.\n\nLowland: Only ~5% of national malt production. Light, delicate, grassy, unpeated. Auchentoshan (Scotland's only remaining triple-distillation distillery) and Daftmill (one of the most collectible craft distilleries in Scotland — ~100 casks/year maximum, auction records £3,779–£5,931 per bottle) represent opposite ends of the Lowland investment spectrum. (7)", type: .info),
                        .callout(title: "Japanese Whisky", content: "Geographic factors: Structural scarcity from an 80% production collapse from the mid-1980s through early 2000s. Virtually no aged stock from this period exists. Every bottle consumed reduces remaining supply permanently. New authenticity rules effective April 2024 require genuine Japanese whisky to use Japanese water and complete all production within Japan.\n\nFlavor: Elegant, precise, layered; floral, fruity, delicate. Mizunara oak (Japanese Quercus mongolica) adds incense, sandalwood, and exotic spice found nowhere else in the whisky world.\n\nInvestment: RW101 Yamazaki sub-index: +917.56% since 2014. Karuizawa (closed 2000): 1,000%+ appreciation since 2010; two full casks sold for £4.25 million at Christie's 2025. Chichibu releases achieve 3–10× retail. Market bifurcated — top 5% of lots: +9.2% CAGR; bottom 50%: -1.3% CAGR. Selection discipline is essential. (13)", type: .research),
                        .callout(title: "Irish Whiskey", content: "Fastest-growing major whisky category: market valued at $6.96 billion in 2024, projected to reach $15.65 billion by 2033 (9.4% CAGR). (14)\n\nIrish Single Pot Still — the unique style: mandatory minimum 30% malted + 30% unmalted barley; triple-distilled. The unmalted barley contributes a distinctive spiciness (green pepper, clove-like pungency) and creamy mouthfeel found nowhere else in whisky. Protected designation under EU and Irish law.\n\nInvestment: Redbreast 21 Year Old, 27 Year Old, 32 Year Old. Midleton Very Rare (40-year series commemorated in 2024). An underserved collector category with improving quality credentials and strong tailwind from market growth.", type: .info),
                        .callout(title: "American Whiskey", content: "Kentucky Bourbon: Limestone geology filters iron; calcium-magnesium-rich water supports healthy fermentation. Legal requirements (51%+ corn, new charred oak, Kentucky maturation) create geographic authentication comparable to Scotch.\n\nCollector market: Pappy Van Winkle ($299 MSRP → $5,000–$8,000+ secondary). Buffalo Trace Antique Collection. Blanton's ($45 retail → $150–$300+ secondary). The December 2024 TTB establishment of American Single Malt Whisky as a distinct official category creates a new collector segment to watch.\n\nTennessee Whiskey distinction: The Lincoln County Process — filtering new-make spirit through ten feet of sugar maple charcoal before barrel entry — removes ~one-third of branched-chain alcohols and adds a hint of maple sweetness, creating Tennessee's signature smooth, pillowy character. Legally protected since 2013. (15)", type: .info),
                        .callout(title: "Emerging Markets", content: "Taiwan (Kavalan): World Whiskies Awards Distiller of the Year 2026. Snow Mountain watershed; subtropical climate accelerates maturation (1 Taiwanese year ≈ 3–5 Scottish years); 10–15% Angel's Share. Award wins confirm that geographic terroir outside Scotland/Kentucky can produce world-class spirit. Growing secondary market premiums for Solist series.\n\nIndia (Amrut, Paul John, Indri): World's largest whisky market by volume now producing investment-grade single malts. 11–12% annual Angel's Share; Himalayan six-row barley; tropical heat creates rapid complexity. Amrut was named third finest whisky in the world in 2010. Ground-floor collector opportunity before international demand fully prices in.\n\nAustralia (Sullivan's Cove, Starward, Lark): Sullivan's Cove won World's Best Single Malt 2014. Starward named Most Awarded International Distillery at 2024 San Francisco World Spirits Competition. Described as at 'an inflexion point.' Tasmania's cool maritime climate produces world-class spirit at slower maturation rates. (12)", type: .research),
                    ]
                ),

                // MARK: - Section 7: Closed Distilleries — The Scarcity Premium
                Section(
                    id: "sec_mod_whisky_7",
                    title: "🏚 7. Closed Distilleries — The Scarcity Premium_",
                    content: [
                        .quote("Rarity is the mother of value.", author: "Sir Francis Bacon"),
                        .text("The most powerful appreciation driver in whisky investment is distillery closure. When a distillery stops producing, its existing stock becomes finite and diminishing — each bottle consumed, each cask opened, reduces the remaining pool permanently. This creates a supply curve that can only contract, never expand, while global awareness and collector demand can grow indefinitely. The result, in well-known cases, has been among the most extraordinary appreciation stories in any collectible category."),
                        .callout(title: "Karuizawa — The Definitive Case", content: "Karuizawa Distillery in Nagano Prefecture, Japan, operated from 1955 to 2000. When it closed, few outside Japan knew its name. By 2010, collectors had discovered the exceptional quality of its surviving stock. Appreciation since: 1,000%+.\n\nA bottle trading at £12,000 in 2013 sold for £100,100 within two years. A 52-year-old expression sold for $372,684 in Hong Kong in 2024. Two full casks sold for £4.25 million at Christie's London in 2025.\n\nThe stock is finite and diminishing. Each release reduces the remaining pool. There will be no new Karuizawa. (8)(13)", type: .research),
                        .callout(title: "Port Ellen — Islay's Grail", content: "Operated under Diageo predecessors from 1825 until the 1983 whisky loch closures. Stock has been released by Diageo annually since 2001 — each release among the most anticipated bottles of the year. Pre-closure stock is finite.\n\nThe Icon 100 index tracked 20–25% annual appreciation for top Port Ellen vintages vs. 7% across the broader Scotch market. A 1979 40-Year-Old Special Release appreciated from approximately £7,000 at release to £8,000–£12,000+ at auction.\n\nNote: Port Ellen reopened in 2024 as a luxury visitor destination distillery. New production is entirely different from old — collectors treat pre-1983 and post-2024 Port Ellen as completely separate propositions. Old stock remains supremely valuable. (7)", type: .research),
                        .callout(title: "Brora & Rosebank", content: "Brora (Highland, closed 1983, reopened 2021): Operating since 1819 until the same 1983 closures as Port Ellen. Reopened under Diageo as an ultra-premium distillery. Pre-closure stock is a diminishing, irreplaceable asset distinct from the new production.\n\nRosebank (Lowland, closed 1993, reopened 2023): The benchmark Lowland distillery. Closed by United Distillers in 1993. Reopened in 2023. Old Rosebank is highly collectible given the small volume that survived. New Rosebank will need decades to produce the age-stated expressions that made the original famous.", type: .info),
                        .text("The investor lesson from closed distilleries is not simply 'buy anything from a closed distillery.' The Karuizawa case was exceptional because the quality was genuinely outstanding — it would have been collectible even from an operating distillery. What closure did was remove any possibility of further supply, converting a quality collector's item into a permanently scarce one. The investment discipline required: identify quality first, then benefit from scarcity as a multiplier, not a substitute for quality."),
                        .callout(title: "Current Top-Performing Categories (2025–2026)", content: "1. Karuizawa and Japanese closed distillery stock — highest-growth, highest floor prices.\n2. Springbank — most collectible active Scottish distillery after Macallan; growing auction share.\n3. Old Macallan (pre-1990 vintages) — consistent auction leader by value.\n4. American Single Malt (emerging) — new TTB category; early collector anticipation.\n5. Campbeltown as a region — three distilleries, global demand, growing recognition.\n6. Sustainability-forward craft distilleries — small production volumes, ESG-aligned collector base.\n7. Aged Irish whiskey — Redbreast 21+, Midleton Very Rare — underserved, improving. (2)(7)", type: .tip),
                    ]
                ),

                // MARK: - Section 8: Sustainability & Biodiversity — Large Distilleries
                Section(
                    id: "sec_mod_whisky_8",
                    title: "🌱 8. Sustainability & Biodiversity — Established Distilleries_",
                    content: [
                        .text("Environmental stewardship in the whisky industry has moved from peripheral marketing to core strategy over the past decade, driven by regulatory pressure, consumer expectation, and the genuine recognition that the raw materials of whisky — water, barley, peat — are living ecological systems. The Scotch Whisky Association has set a sector-wide target of net zero for Scope 1 and 2 emissions by 2040. Individual distilleries are at very different stages of that transition."),
                        .callout(title: "Bruichladdich — B Corp Pioneer", content: "Islay. Owned by Rémy Cointreau. B Corp certified since 2020 — one of the first major Scotch distilleries.\n\n100% Scottish-grown barley with traceability to individual farms. Single farm vintage releases name the specific farmer and field. Has secured £2.6 million to demonstrate a green hydrogen production system (Direct Combustion Chamber boiler), targeting zero-emission distillation by ~2027. Employee-first Islay employer. (16)", type: .info),
                        .callout(title: "Nc'nean — Scotland's Net Zero Benchmark", content: "Morvern Peninsula, Highland. Founded 2017 by Annabel Thomas. B Corp certified since February 2022.\n\nScotland's first certified net zero whisky distillery in production. Scotland's only certified organic whisky at commercial scale. 100% renewable energy via biomass boiler burning local wood chip (all replanted). 100% recycled glass bottles. Free postage bottle return scheme (2024).\n\nPreviously raised £1.7 million through a Seedrs crowdfunding campaign — a direct-to-investor model in a small production distillery. Releases sell out rapidly, creating genuine collector scarcity. (17)", type: .info),
                        .callout(title: "Glenmorangie — The DEEP Oyster Reef", content: "Easter Ross, Highland. Owned by LVMH (Moët Hennessy). Situated on the Dornoch Firth.\n\nDEEP (Dornoch Environmental Enhancement Project): A 2014 partnership with Heriot-Watt University and the Marine Conservation Society to restore native European oyster reefs to the Dornoch Firth — directly adjacent to the distillery. Target: 4 million oysters over 40 hectares.\n\nThe mechanism is elegant and circular: oysters filter and clean the residual effluent produced by the distilling process — the waste water created at the distillery is the food source that sustains the reef. An anaerobic digestion plant handles 95% of the distillery's wastewater; the oyster reef handles the remaining 5%.\n\nAs BBC Scotland reported in April 2026 — alongside coverage of Annandale's heat system — Glenmorangie's reef was cited as a benchmark example of the Scotch industry innovating for sustainability. The oysters perform a measurable ecological function: a single adult oyster filters up to 200 litres of water per day, removing excess nitrogen, phosphorus, and suspended solids that would otherwise degrade the Firth's water quality.\n\nInvestment relevance: The DEEP project is not a marketing exercise — it is LVMH's public commitment to making Glenmorangie's production ecologically net-positive in its local marine environment. For collectors and ESG-aligned investors, it represents credible, third-party verifiable environmental stewardship from a distillery whose expressions already trade at significant secondary market premiums. (18)(78)", type: .research),
                        .callout(title: "Laphroaig — Peatland Stewardship", content: "Islay. Owned by Suntory Global Spirits.\n\nPeatland Water Sanctuary™ (est. 2021): Restoring and replenishing Islay's peatlands at Glenmachrie-Grianan and The Oa — directly addressing the ecological impact of the peat this distillery depends on. Peatlands are among the world's most important land-based carbon sinks.\n\n2023 packaging redesign reduced carbon emissions by 30%. Suntory Global Spirits net zero across full value chain by 2040. A peated distillery taking stewardship responsibility for the peatland ecosystem it consumes is coherent and credible. (19)", type: .info),
                        .callout(title: "Highland Park — Hobbister Moor", content: "Kirkwall, Orkney. Owned by The Edrington Group.\n\nNet zero target 2045; 50% emissions reduction by 2030. March 2025: new heat recovery system captures heat from distillation condensers and redirects it to kilns for drying malted barley — eliminating coke-burning for kiln heat.\n\nResponsibly Managed Peatlands Certification (2023). Custodial responsibility for Hobbister Moor alongside RSPB — a nature reserve managed under strict ecological protocols for 48+ years, protecting breeding habitat for golden plover, dunlin, and curlew.\n\nHySpirits 2 green hydrogen project with the European Marine Energy Centre (EMEC) — £58,781 public funding. ISO 14001 certified. (20)", type: .info),
                        .callout(title: "Maker's Mark — B Corp at Scale", content: "Loretto, Kentucky. Owned by Suntory Global Spirits.\n\nLargest distillery in the world to achieve B Corp certification (January 2022).\n\nStar Hill Farm: Home to the world's first distillery with Regenified™ Tier 3 certification — the highest standard in regenerative agriculture. 86% of grains now sourced from 10 select growers practicing regenerative farming. Solar array offsets energy for all 50 barrel warehouses.\n\nStar Hill Farm Whisky is a limited annual release directly celebrating the regenerative programme — the rarest case where a product is literally the agricultural practice made drinkable. (21)", type: .research),
                    ]
                ),

                // MARK: - Section 9: Sustainability & Biodiversity — Craft & Independent Distilleries
                Section(
                    id: "sec_mod_whisky_9",
                    title: "🌿 9. Sustainability & Biodiversity — Craft Distilleries_",
                    content: [
                        .text("The most innovative sustainability and biodiversity work in whisky is often happening not at the large corporate distilleries but at the small, independent, and craft level — where founders have built environmental principles into the business from day one, production scales are small enough to run genuinely closed-loop systems, and limited annual output creates the natural scarcity that drives collector interest. Several of these distilleries also offer direct investment routes — community shares, cask ownership programmes, and equity crowdfunding — that are unavailable at the larger corporate operations."),
                        .text("**Galloway Distillery** (Newton Stewart) was founded in 2017 and re-launched in October 2025 under actor Sam Heughan and entrepreneur Alex Norouzi. A new expanded production facility has planning approval (ref: 24/2133/FUL) for 200,000 litres of pure alcohol per annum. The distillery sits within the Galloway & Southern Ayrshire UNESCO Biosphere Reserve — a 5,500 km² landscape covering some of the most ecologically diverse terrain in the UK. The production design is net-zero, using natural wind for cooling and renewable energy, with 100% Scottish malted barley.\n\nSpecific third-party environmental certifications and formal biodiversity partnerships have not yet been publicly announced. Sam Heughan at the 2025 re-launch: 'I want to celebrate our heritage, our stories and nature — while inviting others to experience it with us.' (22)"),
                        .callout(title: "Ardnamurchan — Sustainable Distillery of the Year", content: "Ardnamurchan Peninsula, Highlands. Founded 2014. Adelphi Distillery Ltd (private, family).\n\nWon Global Sustainable Distillery of the Year, Whisky Magazine Icons of Whisky 2024 — the highest sustainability recognition in Scotch. Energy: biomass woodchip boiler from locally planted forestry on a 100-year replanting plan; hydro-electric generator on the Glenmore river; 138 solar panels (50kW, 2023). Watermiser system reduced cooling water from 400m³/day to 20m³/day — a 95% reduction. Heritage Golden Promise barley release (2025): reviving pre-Green Revolution varieties.\n\nInvestment angle: Single cask bottlings as few as 335 bottles per release; secondary auction is the route. Heritage barley expressions especially collectible. (23)", type: .example),
                        .callout(title: "GlenWyvis — Scotland's Community Distillery", content: "Dingwall, Highlands. Founded 2015. Owned by 3,000+ community shareholders from 30+ countries — Scotland's first 100% community-owned distillery.\n\n100% off-grid: wind, hydro, solar, and biomass — entirely off the National Grid. Three crowdfunding rounds have raised £3.7M+ total. Revival of Dingwall's distilling heritage lost since 1926.\n\nInvestment angle: This IS the investment model — community shares. The purest example of community-owned, sustainability-first distillery investment in Scotland. (24)", type: .example),
                        .callout(title: "Annandale — World-First Low-Carbon Heat System", content: "Annan, Dumfries & Galloway. Original distillery closed 1919; restored and officially opened by HRH The Princess Royal in 2015. In 2024 the distillery celebrated its first 10-year-old single malt since resuming operations.\n\nApril 2026 — BBC Scotland confirmed: Annandale claims to be the first distillery in the world to produce high-temperature, high-pressure distillation steam from stored green electricity rather than fossil fuels. The system stores wind-generated electricity not in batteries but as heat — up to 1,200°C — in a thermal store with a physical footprint no larger than an average garage.\n\nTechnology: Three modules providing 30MWh storage capacity feed hot air to a 3MW Cochran boiler, converting it to steam at 10 bar pressure. Technology partners: Exergy3 (clean-heat technology) and Cochran Ltd (boiler-makers).\n\n'This is a first — not just for the whisky industry or Scotland — but globally.' — Prof. David Thomson, co-founder.\n\nThe hard problem it solves: Creating high-temperature, high-pressure steam accounts for the majority of a distillery's direct carbon emissions. Industrial heat processes represent 13% of Scotland's total greenhouse gas emissions — the hardest segment to decarbonise. Annandale's system addresses the challenge the rest of the industry has not yet solved.\n\nCaveat on cost: Prof. Thomson noted that the UK has the highest electricity costs in Europe; even off-peak green electricity becomes expensive once the green levy is applied — the primary remaining barrier to sector-wide adoption.\n\nScotch Whisky Association industry target: Full decarbonisation of operations by 2030. (25)(78)", type: .research),
                        .callout(title: "Daftmill — The True Farm Distillery", content: "Cupar, Fife. Founded 2005, first releases 2018. Cuthbert family (6th generation farmers). ~100 casks per year maximum.\n\nGrows all barley on Daftmill Farm. Seasonal production only — distills in winter and midsummer when farm calendar allows, mirroring pre-industrial Scottish practice abandoned ~100 years ago. Draff fed to on-farm cattle; pot ale and spent lees fertilise the fields. Fully closed circular loop.\n\nInvestment angle: Among the most collectible Scotch in existence. First 2018 release: 629 bottles, sold out immediately. Auction records: £35,300 for seven bottles on World Whisky Day; individual bottles £3,779–£5,931 at secondary market. Pure secondary auction play — extreme scarcity, no investment programme. (26)", type: .example),
                        .callout(title: "Struie / Thompson Brothers — Crowdfunded Innovation", content: "Dornoch, Highlands. Crowdcube campaign (March 2025) raised £2.39 million — 129% of target — from 720 investors. Overall raise £5M including Series A investors.\n\nPatent-pending condenser design + heat pump targeting 3 kWh per litre of alcohol produced — against the industry average of 7.5–8 kWh/LPA. Aiming to be the world's most energy-efficient distillery. Solar generation + battery storage; primarily off-grid renewable operation.\n\nParent distillery Dornoch uses heritage barley varieties (Plumage Archer, Maris Otter, Orkney Bere) floor-malted in a restored 1880s fire station.\n\nInvestment angle: Oversubscribed equity crowdfund is the model here — direct investor participation in world-record energy efficiency ambition. (27)", type: .research),
                        .callout(title: "Highland Boundary — Rewilding from the Start", content: "Alyth, Perthshire. Founded 2015. Dr. Marian Bruce & Simon Montador. Micro-scale.\n\nFounding member of the Scottish Rewilding Alliance — a direct political and ecological commitment built into the distillery's founding principles. Rewilding of 7-acre smallholding: 600+ native trees planted, wildflower meadows, hedgerows, wildlife pond. Spirits infused with foraged native plants grown directly on the rewilded land: silver birch, sloe, elderflower. Botanical terroir from rewilded ground. Cooling water from Alyth Hill spring, returned to wildlife pond (closed loop). 100% solar PV; biomass boiler; no plastics in packaging. Free wildflower seed mixes included with online purchases.\n\nPossibly the most directly integrated distillery-rewilding operation in Scotland. (28)", type: .research),
                        .callout(title: "Lochlea — Single-Estate Closed Loop", content: "Ayrshire, Scottish Lowlands. Founded 2018. Neil McGeoch (private, family farm).\n\nTrue single-estate: barley grown on ~90 hectares of the farm; distilled and matured on the same land. On-site environmental treatment pond for spent lees — eliminates 2,300+ road miles per year vs. off-site treatment. Draff to local farmers; straw returned as farmyard manure — fully closed circular farming. Built on the farm where Robert Burns once lived and worked.\n\nInvestment angle: Active private cask programme. Cask types: first-fill bourbon barrels, first-fill Oloroso sherry hogsheads, ex-Grenache. Cask owners attend dedicated Cask Owner's Day; draw samples during maturation. (29)", type: .example),
                        .callout(title: "Waterford — Terroir Pioneer (Cautionary Note)", content: "Waterford, Ireland. Founded 2015 by Mark Reynier. Now owned by Tennessee Distilling Group (acquired March 2026 after receivership November 2024).\n\nPioneered the most rigorous terroir philosophy in whisky: 97 Irish farms across 19 distinct soil types, each harvest kept entirely separate from grain to glass. World's largest producer of organic and biodynamic whiskies. World's first biodynamic whisky (Biodynamic: Luna — Demeter certified). Won Global Drinks Intel ESG Awards 2024, Biodiversity Achievement category.\n\nCautionary note: Entered receivership November 2024. The most ambitious terroir and sustainability philosophy in whisky failed financially. Extraordinary concept; challenging unit economics. Early single farm releases now command secondary premiums for their scarcity and uniqueness — but the investment lesson is that environmental innovation alone does not guarantee financial viability. (30)", type: .warning),
                        .callout(title: "Arbikie — Climate-Positive Distilling", content: "Inverkeilor, Angus. Founded 2014. Stirling family (brothers John, Iain, David).\n\nField-to-bottle at estate scale: own barley, rye, wheat, potatoes, juniper, and botanicals — all grown on the estate. World's first climate-positive gin (Nàdar): made from peas with a carbon footprint of -1.54 kg CO₂e per bottle (peas fix nitrogen from air; require zero synthetic fertiliser). World's only Rye Scotch Whisky (Highland Rye) — reviving a documented 1794 estate recipe. Green hydrogen electrolyser (£3M government-funded) will make Arbikie the world's first climate-positive distillery for all production.\n\nInvestment angle: Former cask investment bonds (£10,000 via Fine+Rare, 8-year buy-back guarantee). May revisit investor programmes as green hydrogen facility comes online. (31)", type: .research),
                        .callout(title: "Clonakilty & Boatyard — Irish B Corp Leaders", content: "Clonakilty Distillery (Cork, Ireland, est. 2019, Scully family): B Corp certified. 100% local barley from family farm or within 15km. 100% renewable energy. 400+ native trees, shrubs, and hedgerows planted for wildlife habitat. On-site wildflower meadow for pollinators. 100% distillation residue to local farmers. Won Global Drinks Intel ESG Awards 2023.\n\nBoatyard Distillery (Fermanagh, Northern Ireland, est. 2016, Joe McGirr): First Irish distillery to achieve B Corp certification (2023) — B Impact score 92.1 vs. the 80 requirement and a median of 50.9. Eco-refill station: any 70cl bottle refilled in-store; 2.8L eco-pouches to bars. 100% organic ingredients. Spent botanicals become chocolate and jam; liquid waste to local bio-digester. (32)", type: .info),
                        .callout(title: "Slane — Salmon on the Boyne", content: "Slane, County Meath, Ireland. Founded 2017. Conyngham family / Brown-Forman.\n\nAtlantic salmon fish ladder: Reconstructed section of Harlinstown Stream (tributary of the River Boyne) allowing salmon to bypass the mill pond and travel upstream to spawn — a concrete, specific, verifiable biodiversity intervention. Bat and barn owl nesting boxes installed in historic castle buildings. Rainwater harvesting; heat recovery; anaerobic digester under construction.\n\nPursuing ISO 14001 — would be the first Brown-Forman production site globally to achieve this. (33)", type: .example),
                        .callout(title: "Westland — Salmon-Safe Barley", content: "Seattle, Washington. Founded 2010. Owned by Rémy Cointreau. American Single Malt.\n\nWashington State University Bread Lab Fellowship: Funded academic research to develop Pacific Northwest barley varietals (Skagit Valley, Palouse region) that are certified organic, regenerative-organic, or Salmon-safe and capable of withstanding climate change. Goal: 100% off commodity market, 100% regenerative barley systems. 70% water use reduction via cooling tower. Washington wine cask maturation reduces transport carbon vs. imported casks.\n\nThe 'Salmon-safe' standard connects distilling to Pacific Northwest watershed protection in a manner unique to this region. Limited releases (Garryana, Colere, Peat Week) command growing secondary premiums. (34)", type: .example),
                        .callout(title: "Beachtree & Starward — Australian Leadership", content: "Beachtree Distilling Co. (Sunshine Coast, Queensland): World's Best Sustainable Distillery 2025 (international award). Australia's only certified organic whisky. Fully solar-powered. You Sip, We Plant™ initiative: 25,000+ native trees planted with local nurseries, community organisations, and First Nations growers.\n\nStarward Whisky (Port Melbourne, Victoria): 100% Australian wine casks (shiraz, cabernet, pinot noir from Yarra Valley, Barossa) — the sustainability story and flavor story are a single unified narrative. 35% electricity reduction per litre; 300% water reduction. Net zero target by 2026 (Scope 1&2). (35)", type: .info),
                    ]
                ),

                // MARK: - Section 10: The Science of Distillation
                Section(
                    id: "sec_mod_whisky_10",
                    title: "⚗️ 10. The Science of Distillation — Still, Wood & Yeast_",
                    content: [
                        .text("The flavor of whisky emerges from the interaction of four primary variables: the still's shape and material, the wood of the cask, the yeast strain used in fermentation, and time. Understanding these variables is not only fascinating — it is the basis for authenticating regional styles and identifying the distilleries whose flavor signatures are genuinely unreproducible."),
                        .callout(title: "Copper Still Geometry — Architecture as Flavor", content: "More reflux = lighter, fruitier spirit. Less reflux = heavier, oilier, richer spirit.\n\nTall, thin stills with long necks (Glenmorangie's at 5.14m — the tallest in Scotland): maximum reflux; only the lightest, most volatile esters exit. Result: Scotland's most delicate style.\n\nShort, squat stills (Lagavulin): heavier vapors pass over with less separation; rich, full-bodied spirit suited to heavy peat.\n\nBoil balls: increase turbulence and copper contact; lighter, fruitier result.\n\nLyne arm angle: upward-angled = more reflux, lighter; downward-angled = heavier spirit.\n\nWorm tub condensers (Mortlach, Craigellachie, Springbank): less copper contact than modern shell-and-tube condensers → heavier, meatier, more sulfurous new-make that becomes extraordinary after long maturation. (36)", type: .info),
                        .text("Copper itself is an active ingredient. Copper reacts with dimethyl sulfide (DMS) and other sulfur compounds in the distillate, binding them and removing what would otherwise be rubbery, eggy, or cooked-vegetable off-notes. More copper contact equals a cleaner, fruitier spirit. Less copper contact allows sulfur-derived complexity notes to survive — which can be extraordinary after decades of maturation but challenging in young expressions. Distilleries replacing worn stills historically required exact replicas of the original dimensions, knowing that any geometric change would alter the character of the spirit produced."),
                        .callout(title: "Wood Science — Two Oaks, Two Flavor Systems", content: "American white oak (Quercus alba) — mandatory for bourbon (new, charred barrels only by law):\n• Very high vanillin — bourbon's characteristic vanilla note\n• Very high oak lactones (cis-β-methyl-γ-octalactone) — coconut, woody, sweet\n• Low tannin density — pores plugged with tyloses; faster flavor extraction without astringency\n• High eugenol — clove-like warmth\n\nEuropean sessile oak (Quercus petraea) — primary sherry butt species:\n• High ellagitannins — astringency, structure, antioxidants\n• Christmas cake, dark raisin, leather, dark chocolate\n\nJapanese Mizunara oak (Quercus mongolica) — rare, costly, extremely difficult to work:\n• Sandalwood, incense, aloeswood, exotic spice\n• Requires minimum 10–15 years to express properly — premature release produces only bitterness\n• Severe supply constraints explain extraordinary auction premiums for aged Yamazaki mizunara expressions. (36)", type: .research),
                        .callout(title: "Yeast — The Hidden Variable", content: "Yeast converts fermentable sugars into alcohol and — critically — produces the esters, aldehydes, and higher alcohols that constitute a substantial part of whisky's flavor. Distilleries guard proprietary yeast strains with the same secrecy as production recipes.\n\nKey esters:\n• Ethyl hexanoate — apple, anise\n• Ethyl octanoate — pear, fat\n• Isoamyl acetate — banana\n• Ethyl decanoate — floral, fatty, waxy\n\nLonger fermentation generally increases ester production. Daftmill and Waterford both use 96–120-hour fermentations explicitly to develop secondary ester character. Macallan's multi-strain yeast approach uses brewer's yeast that attenuates earlier, allowing lactic acid bacteria to build hexanoate and octanoate esters toward the end of fermentation — contributing to Macallan's distinctive fruity richness. (37)", type: .info),
                        .text("The warehouse environment completes the maturation picture. Traditional dunnage warehouses (stone walls, earthen floors, maximum three casks high) maintain high ground-level humidity and consistent cool conditions, slowing maturation further and — at coastal distilleries — allowing sea air to permeate the porous wood over decades. This is the mechanism behind the marine salinity that defines old Springbank, coastal Laphroaig, and Old Pulteney. The earthen floor, the thick stone walls, the proximity to the sea — these are not aesthetic choices. They are flavor variables that have been deliberately maintained for generations."),
                    ]
                ),

                // MARK: - Section 11: Distillery Equity Investment
                Section(
                    id: "sec_mod_whisky_11",
                    title: "🏭 11. Investing in Distilleries — Equity, Stocks & Community Shares_",
                    content: [
                        .text("The whisky investment universe has three distinct tracks: buying bottles on the secondary market, purchasing maturing casks, and investing in the distilleries themselves as businesses. The third track — distillery equity — operates by entirely different mechanics and is often misunderstood. The critical finding from the data: the largest publicly traded spirits companies have dramatically underperformed the broader equity market over the past decade, while the most innovative equity formats are small community-owned and crowdfunded distilleries with limited liquidity and no guaranteed exit. The Waterford receivership case provides the most instructive cautionary lesson in the sector."),
                        .callout(title: "The Three Formats for Distillery Equity", content: "1. Publicly Traded Spirits Stocks — Diageo, Pernod Ricard, Brown-Forman, Rémy Cointreau, LVMH (conglomerate). Liquid, correlated to financial markets, convenient — but have significantly underperformed the S&P 500 over 5 and 10 years.\n\n2. Private Equity & M&A — PE firms buying craft distilleries; major corporate acquisitions. Generally unavailable to individual investors. Relevant as context for exit scenarios.\n\n3. Community Shares & Equity Crowdfunding — GlenWyvis, Struie/Thompson Brothers, Nc'nean. Direct equity stakes in small, independent distilleries. Illiquid; no guaranteed exit; but offer alignment with sustainability values and early-stage upside if an acquisition occurs.", type: .info),

                        .text("**Publicly Traded Spirits Stocks — The Data**\n\nThe major publicly listed spirits companies have underperformed equity markets significantly over recent years, driven by post-COVID inventory gluts, US tariff uncertainty, and structural headwinds in the premium spirits segment."),
                        .callout(title: "Large-Cap Spirits Stocks vs. Market (to June 2026)", content: "Diageo (LSE: DGE / NYSE: DEO): ~£44.8B market cap. 10-year annualised total return: approximately 0% — effectively flat. Down ~64% from peak. Fiscal 2024: organic net sales -0.6%; organic operating profit -4.8%. Dividend yield ~4.8% provides partial compensation.\n\nPernod Ricard (EPA: RI): ~£24.7B market cap. Stock down ~37% from peak. Key Scotch brands: Chivas Regal, Aberlour, Longmorn. Merger talks with Brown-Forman collapsed April 2026 over control structure.\n\nBrown-Forman (NYSE: BF.B): 42 consecutive years of dividend increases — a Dividend Aristocrat. Down ~69% from peak. Rejected Sazerac's $15 billion takeover bid (May 2026). Key brands: Woodford Reserve, Jack Daniel's, BenRiach.\n\nRémy Cointreau (EPA: RCO): ~$2.4B market cap. Primarily a cognac play; Scotch exposure via Bruichladdich. B Corp certification adds ESG differentiation.\n\nComparison: S&P 500 annualised total return 2015–2025: ~13–14%. All major spirits stocks significantly underperformed over this period. (39)", type: .warning),
                        .callout(title: "Why Spirits Stocks Underperformed", content: "The Post-COVID Inventory Hangover: The 2021–2022 boom created an estimated $22 billion global inventory glut as distributors over-ordered during peak demand. Destocking 2023–2025 crushed volumes across all major producers.\n\nUS Tariff Risk: The Scotch Whisky Association estimates tariff exposure could cost the industry nearly £20 million per month. Exports to the US — the single most important export market — fell 7% in value and 15% in volume in 2025 alone. An escalation from 10% to the threatened 35% would be a material earnings shock for Diageo and Pernod Ricard.\n\nGLP-1 Headwinds: Analyst notes in 2025–2026 have flagged that widespread adoption of GLP-1 drugs (Ozempic, Wegovy) may structurally reduce alcohol consumption volumes — a long-term macro risk for spirits businesses.\n\nPremium Paradox: Even as rare whisky bottles appreciated 400%+, the businesses that produce them were restructuring or declining in market cap. Value accumulates in the liquid, not the company that made it. (40)", type: .research),

                        .text("**Private Equity — Craft Distillery Acquisitions**\n\nThe craft distillery M&A market is active but largely inaccessible to individual investors. It does, however, define the exit landscape for community-funded distilleries — and illustrates the kind of multiples that might be achievable in a successful exit. Compass Box (the Scotch whisky blender) was acquired by Caelum Capital private equity in May 2022. Eden Mill (St Andrews, gin and whisky) received PE backing from Inverleith. The 2026 Brown-Forman saga — rejected $15 billion all-cash bid from Sazerac, preceded by collapsed merger talks with Pernod Ricard — illustrates how consolidation pressure at the top of the market creates acquisition appetite for smaller brands that are acquired on the way up."),
                        .callout(title: "Notable M&A Reference Points", content: "Glenmorangie Company (Glenmorangie + Ardbeg): Acquired by LVMH for £300 million in 2004. Both brands have since become globally recognised premium expressions — Ardbeg's auction premiums are in large part a product of LVMH's distribution and marketing investment.\n\nCasamigos: Acquired by Diageo for $700M + $300M earn-out in 2017. Became a 2.7M-case brand by 2021 — illustrating how spirits brands can scale dramatically with major distributor backing.\n\nCompass Box: PE-backed 2022. Bespoke blending house; investment thesis based on brand premium and inventory appreciation rather than volume.\n\nThe Lesson for Small Distillery Investors: Exit events do happen — but they depend on brand reputation, distribution, and inventory quality. Financial viability matters more than concept excellence. (41)", type: .info),

                        .text("**Community Shares & Equity Crowdfunding — The Direct Democracy Model**\n\nThe most innovative formats for individual investors are community ownership and equity crowdfunding — structures that allow direct investment in a specific distillery's future, with returns tied to the distillery's success rather than broader market movements."),
                        .callout(title: "GlenWyvis — The Community Ownership Model", content: "Dingwall, Highland. Founded 2015. Scotland's first 100% community-owned distillery.\n\nShare Offer 1 (April 2016): £2.6 million raised in 77 days — described as the largest community crowdfunding campaign in UK history at the time.\nShare Offer 2 (2017–2019): Further £1.1 million; 3,626 investors total from 30+ countries.\nShare Offer 3 (ongoing): Target £2.75 million by 2027 (£2M equity + £750K member bonds).\n\nBond Instrument: 6.25% fixed annual return over 5–7 years (from April 2024) — the most concrete near-term financial return available to GlenWyvis investors.\n\nEquity investor returns: Shares do not pay traditional dividends. Returns are member benefits — exclusive bottlings, 20% discount on all sales, voting rights on key decisions. No exit event has occurred. Shares are non-transferable except to other members.\n\nThe 6.25% bond is the closest to a standard financial instrument; equity shares are a long-horizon, community-aligned investment with no guaranteed exit path. (24)(42)", type: .research),
                        .callout(title: "Struie / Thompson Brothers — World's Most Energy-Efficient Distillery Ambition", content: "Dornoch, Sutherland. Crowdcube campaign (March 2025): Raised £2.2 million+ — 129% of target — from investors attracted to the world-record energy efficiency technology and the Thompson Brothers' existing reputation from Dornoch Distillery.\n\nThe raise is part of a wider £8 million investment plan (£5M Series A total). Post-raise, industry board members described as 'titans of the drinks trade' joined the board.\n\nInvestment structure: Standard equity crowdfunding on Crowdcube — shares in a private company. Returns are dependent on: (a) achieving the energy efficiency targets, (b) building sales distribution, (c) ultimately an acquisition or secondary sale exit.\n\nThe ESG and sustainability premium: investors here are not just buying whisky upside — they are taking a position on whether a net-zero, patent-pending distillery technology can achieve commercial scale. The overlap between sustainability investors and whisky collectors creates a potentially differentiated demand profile. (27)(43)", type: .research),
                        .callout(title: "Nc'nean and Other Crowdfunded Distilleries", content: "Nc'nean (Seedrs, 2019–2020): £1.7 million raised; EIS-qualifying (significant UK tax relief — 30% income tax credit, CGT deferral, loss relief). Minimum investment £12. Net zero certified, B Corp. Sells out rapidly on each release.\n\nDunphail (Speyside): £2.75 million across two rounds (2022, 2024). Phase 3 investment open.\n\nIsle of Barra: Combined cask + equity offer (2024) — minimum £5,000 (£3,995 cask + equity stake in distillery opening 2027).\n\nCritical note on EIS relief: The UK Enterprise Investment Scheme provides 30% income tax relief on investments in qualifying smaller companies, CGT deferral, and loss relief if the company fails. For distillery crowdfunding in particular, EIS qualifying status materially changes the risk/reward calculus — confirm EIS status before investing. (42)", type: .tip),

                        .text("**The Waterford Case Study — Equity Failure Despite Asset Value**\n\nThe Waterford Distillery receivership of November 2024 is the most important case study in distillery equity investment, because it illustrates a fundamental structural problem: a whisky company can possess genuinely valuable assets — a maturing stock worth approximately €140 million — while being unable to generate sufficient cash flow to service its debt and operating costs."),
                        .callout(title: "Waterford — Timeline of an Equity Failure", content: "Founded: Waterford, Ireland, 2015. Mark Reynier (former MD of Bruichladdich).\nConcept: World's most rigorous terroir-driven Irish whisky — 97 farms, 19 soil types, biodynamic certification. Genuinely innovative.\nFinancing: Private investors + UK Business Growth Fund + PNC bank + HSBC (2022 refinancing).\nTotal debt accumulated: ~€70 million.\nAnnual turnover: never exceeded €3 million.\nEstimated stock value: ~€140 million.\n\nNovember 2024: Receivers appointed (Interpath Advisory) after failing to agree a turnaround plan with HSBC or raise fresh equity.\nMarch 2026: Distillery and brand sold to Tennessee Distilling Group for approximately €6 million. Stock sold separately.\nEquity investor outcome: Near-total loss. The company that made a €140M asset sold for €6M.\n\nThe Lesson: Whisky stock appreciates in barrels over decades. The company that owns the barrels needs cash flow to survive those decades. Great whisky and great equity returns are not the same thing — and may actually be in tension. (30)(44)", type: .warning),

                        .callout(title: "Distillery Equity vs. Bottle/Cask — Side by Side", content: "Large-cap spirits stock: High liquidity. Moderate market correlation. Dividend income (2–5%). Underperformed S&P 500 over 5–10 years.\n\nPrivate equity / M&A: Very low liquidity. Low market correlation. Exit-dependent returns. Not accessible to most individual investors.\n\nCommunity shares (GlenWyvis): Very low liquidity. Very low market correlation. 6.25% bond available; equity no guaranteed exit. ESG-aligned.\n\nEquity crowdfunding (Struie, Nc'nean): Low liquidity. Very low market correlation. EIS relief possible. Acquisition-dependent exit. Long horizon.\n\nDistillery equity failure (Waterford): Zero. Near-total capital loss despite exceptional underlying asset. Distribution/cash flow failure.\n\nConclusion: For most individual investors, bottle and cask investment offers a more direct route to whisky as an asset class than distillery equity. Public spirits stocks offer convenience and liquidity but have materially underperformed. Community shares and crowdfunding are viable for sustainability-aligned investors with long horizons who qualify for EIS relief — but should be sized as a small, high-risk allocation.", type: .info),
                    ]
                ),

                // MARK: - Section 12: Risk Factors & Due Diligence
                Section(
                    id: "sec_mod_whisky_13",
                    title: "⚠️ 12. Risk Factors & Due Diligence_",
                    content: [
                        .text("Whisky investment carries a distinctive risk profile that differs from financial assets, fine wine, and other tangible collectibles. Understanding the specific risks — particularly those unique to the whisky cask market — and the available mitigations is essential before committing capital."),
                        .callout(title: "Risk Summary Matrix", content: "Fraud (cask market) — High severity, real likelihood. Unregulated sector; no FCA protection; documented cases in 2022 and 2024. Mitigation: verify delivery orders; use only established, reputable brokers.\n\nMarket correction — High severity (2022–2024 demonstrated -40% possible). Mitigation: long hold periods; buy during corrections, not peaks.\n\nAngel's Share — Certain, ongoing cost. 1–2%/year Scotland; 10–15%/year Taiwan/India. Mitigation: model as a carrying cost in all return projections.\n\nIlliquidity — Certain characteristic. No open exchange; weeks to months to exit. Mitigation: treat as a 5–15+ year investment.\n\nMarket concentration — High: Macallan dominates. Mitigation: diversify across distilleries, regions, and styles.\n\nCounterfeiting — Growing as values rise. Mitigation: certified auction houses only; documented provenance.\n\nStorage disaster — Low probability, catastrophic severity. Mitigation: verify insurance coverage explicitly. (9)(38)", type: .warning),
                        .text("Fraud deserves extended treatment because it is the most acute risk specific to this asset class. The whisky cask market is entirely unregulated. There is no Financial Conduct Authority oversight, no Financial Services Compensation Scheme, and no standardized documentation requirement. Common fraud schemes include: selling the same cask to multiple investors simultaneously; selling interests in non-existent casks; misrepresenting a cask's age, distillery of origin, or current volume; and offering 'guaranteed returns' (which are illegal under UK financial promotion rules)."),
                        .callout(title: "The Fraud Landscape", content: "2022: A British man was arrested by the FBI for defrauding US investors of $13 million through a cask whisky scheme.\n\n2024: Cask Whisky Ltd entered liquidation following a City of London Police fraud investigation. Investors who lacked proper delivery orders proving their ownership of specific casks were unable to establish legal title to assets.\n\nMarch 2025: BBC investigation exposed widespread cask whisky scams, generating industry-wide responses and calls for regulatory oversight.\n\nProtection: Always insist on a delivery order in your own name. Verify the warehouse is HMRC-approved. Never accept guaranteed return promises. Use solicitors to review documentation. The due diligence burden falls entirely on the investor in an unregulated market. (9)", type: .warning),
                        .text("Market concentration risk is structural and persistent. The whisky investment market is not a diversified market like equities — it is concentrated around a small number of distilleries, with Macallan representing a disproportionate share of total auction value. Diversification within whisky is essential: across distilleries, across regions (Scotch, Japanese, Irish, American), and across styles (peated/unpeated, sherry-matured/bourbon-matured). An investor concentrated in a single distillery is exposed to brand-specific events — a quality controversy, a corporate sale, a change in production methods — that would not affect a diversified whisky portfolio."),
                        .callout(title: "Tax Treatment Summary", content: "United Kingdom: Whisky casks — classified as 'wasting chattels' (assets with predictable lifespan under 50 years) — are generally CGT-exempt when sold by private UK investors. Exception: if HMRC determines the activity constitutes a trading business, profits may be taxed as income. Bottled whisky does NOT qualify as a wasting chattel and IS subject to CGT at 18% (basic rate) or 24% (higher rate). Excise duty (~£28.74/LPA as of 2024) is payable on removal from bond.\n\nUnited States: Whisky classified as a collectible under IRS rules. Long-term capital gains on collectibles taxed at maximum 28% vs. 15–20% for equities. Peer-to-peer resale without a license is legally restricted or prohibited in most US states.\n\nGermany: Gains on personal property held 1+ year are tax-free.\n\nIreland: Similar wasting chattel CGT treatment to UK for casks. (3)(38)", type: .info),
                    ]
                ),

                // MARK: - Section 13: How to Invest
                Section(
                    id: "sec_mod_whisky_14",
                    title: "💼 13. How to Invest — Entry Points & Vehicles_",
                    content: [
                        .quote("Do not put all your eggs in one basket.", author: "Miguel de Cervantes, Don Quixote"),
                        .text("Whisky investment encompasses a spectrum of vehicles ranging from buying a single bottle of collectible Scotch to equity investment in a craft distillery's Crowdcube raise. Each vehicle carries different return expectations, liquidity profiles, minimum capital requirements, management burdens, and tax treatment. Understanding the landscape before allocating is fundamental."),
                        .callout(title: "Investment Vehicle Comparison", content: "Bottle/Case Investment: Min ~$500–$5,000. Hold 5–15 years. Auction exit 2–8 weeks. Annual cost: storage + insurance. CGT applicable in UK.\n\nCask Investment: Min ~£2,000–£20,000+. Hold 5–20 years. Exit: trade sale, secondary cask market, or bottling. Ongoing storage costs £10–30/year. CGT-exempt in UK as wasting chattel (with caveats).\n\nCask Ownership Programmes (Raasay, Lochlea, Benbecula, Springbank): Structured programmes with distillery support, storage, and community benefits. Min typically £2,000–£10,000.\n\nCommunity Shares (GlenWyvis): Direct equity investment in a community-owned distillery. 3,000+ shareholders; multiple crowdfunding rounds.\n\nEquity Crowdfunding (Struie/Thompson Brothers, Nc'nean): Crowdcube/Seedrs raises. Struie raised £2.39M at 129% of target in March 2025. Long hold period; illiquid until exit event.\n\nSecondary Market Platforms: For bottles, Whisky Auctioneer, Scotch Whisky Auctions, Whisky.Auction handle everything. For US investors, Hart Davis Hart provides licensed channel. (6)(24)(27)(29)", type: .info),
                        .text("For most individual investors, the practical entry point is either direct bottle investment via an established auction platform or a structured cask ownership programme from a reputable distillery. The key due diligence questions for any cask investment: Is the delivery order in your name? Is the warehouse HMRC-approved? Is the distillery independently verifiable? What are the specific exit routes and their associated costs? What is the estimated excise duty on a bottling exit?"),
                        .callout(title: "Sustainability-Focused Portfolio Construction", content: "Investors specifically interested in sustainability-forward whisky have more options than their wine counterparts. Structured routes include:\n\n1. Cask ownership at Raasay (hydrogen research, island stewardship), Lochlea (single-estate closed loop), or Benbecula (croft barley, seaweed fertiliser).\n\n2. Community shares in GlenWyvis (100% off-grid, community-owned).\n\n3. Equity crowdfunding in Struie (world's most energy-efficient distillery ambition) or Nc'nean (net zero certified, B Corp).\n\n4. Secondary market bottle portfolio weighted toward B Corp-certified producers: Bruichladdich, Nc'nean, Maker's Mark, Clonakilty, Boatyard.\n\n5. Collector-grade bottles from distilleries with documented rewilding programmes: Highland Boundary (Scottish Rewilding Alliance founding member), Arbikie (climate-positive production), Lagg/Arran (325 hectares of peatland restored). (16)(17)(24)(27)(28)(29)(32)", type: .tip),
                        .text("Geographic diversification is as important in whisky as in any alternative asset. Concentrating in a single region — particularly one with currency, tariff, or market concentration risk — amplifies rather than mitigates overall portfolio risk. A well-constructed whisky investment portfolio might hold exposure across Scotch (long-term appreciation, regulated scarcity), Japanese (structural scarcity, established collector demand), Irish (growth market, improving credentials), and American (allocated collector bourbon, new American Single Malt category)."),
                        .callout(title: "Questions for Your Advisor", content: "How does whisky investment fit my overall alternative asset allocation?\nWhich vehicle — bottles, casks, cask programmes, community shares, or equity crowdfunding — aligns with my liquidity needs and hold horizon?\nWhat documentation do I need to prove legal ownership of a cask?\nWhat is the tax treatment of whisky investment gains in my jurisdiction, specifically the wasting chattel analysis for casks vs. bottles?\nHow should I think about the angel's share as an ongoing cost in my return model?\nIf I am interested in sustainability-forward distilleries, which ones have third-party certification (B Corp, organic, Demeter) vs. unverified marketing claims?", type: .tip),
                        .callout(title: "Legal Disclaimer", content: "This module is for educational and informational purposes only. It does not constitute financial, legal, or tax advice. Untitled_ LuxPerpetua Technologies does not hold a FINRA license and does not offer investment advisory services. The whisky cask market is unregulated and there is no Financial Services Compensation Scheme recourse. Whisky investment involves significant risk including fraud, total loss of capital, and prolonged illiquidity. Past performance of whisky indices does not guarantee future results. Consult a qualified financial advisor and tax professional before making any investment decision.", type: .warning),
                    ]
                ),

            ]
        )
    }

    // MARK: - Module Footnotes
    static let whiskyModuleFootnotes: [ModuleFootnote] = [
        ModuleFootnote(
            id: "fn_whisky_01",
            moduleId: "mod_whisky",
            number: "1",
            title: "Global Whiskey Market Size, Share & Trends 2033",
            author: "Grand View Research",
            source: "grandviewresearch.com",
            url: "https://www.grandviewresearch.com/industry-analysis/whiskey-market",
            year: "2025"
        ),
        ModuleFootnote(
            id: "fn_whisky_02",
            moduleId: "mod_whisky",
            number: "2",
            title: "Rare Whisky 101 — Market Performance Indices (Apex 1000, Japanese 100, Yamazaki)",
            author: "Rare Whisky 101",
            source: "rarewhisky101.com",
            url: "https://www.rarewhisky101.com/indices/market-performance-indices",
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_whisky_03",
            moduleId: "mod_whisky",
            number: "3",
            title: "The Taxation of Wasting Chattels: A Focus on Whisky Casks",
            author: "Gerald Edelman Chartered Accountants",
            source: "geraldedelman.com",
            url: "https://www.geraldedelman.com/insights/taxation-of-wasting-chattels-a-focus-on-whisky-casks/",
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_whisky_04",
            moduleId: "mod_whisky",
            number: "4",
            title: "Knight Frank Luxury Investment Index 2024; Rare Whisky as Investment Category",
            author: "Knight Frank; The Whiskey Wash",
            source: "knightfrank.com; thewhiskeywash.com",
            url: "https://thewhiskeywash.com/whiskey-news/knight-frank-2024-and-the-takeaways-for-whisky/",
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_whisky_05",
            moduleId: "mod_whisky",
            number: "5",
            title: "Secondary Whisky Market Value Drops 40% as Stabilization Emerges in 2025",
            author: "Vinetur",
            source: "vinetur.com",
            url: "https://www.vinetur.com/en/2025101492181/secondary-whisky-market-value-drops-40-as-stabilization-emerges-in-2025.html",
            year: "2025"
        ),
        ModuleFootnote(
            id: "fn_whisky_06",
            moduleId: "mod_whisky",
            number: "6",
            title: "The Truth About Cask Investment 10–18% PA Returns; Cask Types and Maturation",
            author: "Mark Littler Ltd; Whisky Solutions",
            source: "marklittler.com; whiskysolutions.uk",
            url: "https://www.marklittler.com/the-truth-about-cask-investment-10-18-per-annum-returns/",
            year: "2025"
        ),
        ModuleFootnote(
            id: "fn_whisky_07",
            moduleId: "mod_whisky",
            number: "7",
            title: "Scotch Regions Ranked; Springbank and Macallan Auction Performance",
            author: "Spiritory; Whisky Advocate",
            source: "spiritory.com; whiskyadvocate.com",
            url: "https://spiritory.com/news/scotch-regions-ranked-speyside-highlands-islay-lowlands-and-campbeltown-en",
            year: "2025"
        ),
        ModuleFootnote(
            id: "fn_whisky_08",
            moduleId: "mod_whisky",
            number: "8",
            title: "Most Expensive Whisky Sold at Auction — Guinness World Records; Christie's Karuizawa Cask Sale 2025",
            author: "Guinness World Records; Christie's",
            source: "guinnessworldrecords.com",
            url: "https://www.guinnessworldrecords.com/world-records/most-expensive-whisky-whiskey-sold-at-auction",
            year: "2025"
        ),
        ModuleFootnote(
            id: "fn_whisky_09",
            moduleId: "mod_whisky",
            number: "9",
            title: "Beyond the Cask: The Hidden Risks of Whisky Cask Investments; BBC Whisky Cask Scams",
            author: "Fladgate LLP; The Spirits Business",
            source: "fladgate.com; thespiritsbusiness.com",
            url: "https://www.fladgate.com/insights/beyond-the-cask-the-hidden-risks-of-whisky-cask-investments",
            year: "2025"
        ),
        ModuleFootnote(
            id: "fn_whisky_10",
            moduleId: "mod_whisky",
            number: "10",
            title: "The Impact of Terroir on the Flavour of Single Malt Whisk(e)y — peer-reviewed",
            author: "Waterford Distillery / Dr. Dustin Herb; Foods journal (MDPI)",
            source: "ncbi.nlm.nih.gov/pmc",
            url: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7922972/",
            year: "2021"
        ),
        ModuleFootnote(
            id: "fn_whisky_11",
            moduleId: "mod_whisky",
            number: "11",
            title: "The Essential Role of Kentucky Limestone Water; How Kentucky's Mineral Water Helps Make Bourbon Unique",
            author: "Heaven Hill Distillery; Tasting Table",
            source: "blog.heavenhilldistillery.com; tastingtable.com",
            url: "https://blog.heavenhilldistillery.com/detail.php?post_name=essential-role-kentucky-limestone-water%2F",
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_whisky_12",
            moduleId: "mod_whisky",
            number: "12",
            title: "Kavalan Changed The Whisky World: Warm Weather Maturation; Angel's Share by Climate",
            author: "Spirited Drinks; Glass Revolution Imports; Amrut Distilleries",
            source: "spiriteddrinks.com; glassrev.com",
            url: "https://www.spiriteddrinks.com/kavalan-changed-the-whisky-world-and-put-warm-weather-maturation-on-the-map/",
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_whisky_13",
            moduleId: "mod_whisky",
            number: "13",
            title: "Japanese Whisky: Complete 2026 Investment Guide; Investment in Karuizawa",
            author: "Vinovest; Timeless Investments",
            source: "vinovest.co; timeless.investments",
            url: "https://www.vinovest.co/blog/japanese-whisky-2026-guide-investment",
            year: "2026"
        ),
        ModuleFootnote(
            id: "fn_whisky_14",
            moduleId: "mod_whisky",
            number: "14",
            title: "Irish Whiskey and the Global Market: Growth and Opportunities",
            author: "IMAP M&A Intelligence",
            source: "imap.com",
            url: "https://www.imap.com/en/insights/2025/Irish-Whiskey-and-the-Global-Market-Growth-and-Opportunities~cv",
            year: "2025"
        ),
        ModuleFootnote(
            id: "fn_whisky_15",
            moduleId: "mod_whisky",
            number: "15",
            title: "Lincoln County Process — Charcoal Mellowing in Tennessee Whiskey; TTB American Single Malt Category",
            author: "Distiller Magazine; TTB",
            source: "distiller.com; ttb.gov",
            url: "https://distiller.com/articles/lincoln-county-process",
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_whisky_16",
            moduleId: "mod_whisky",
            number: "16",
            title: "Bruichladdich: Sustainability at the Beating Heart of the Business; B Corp Certification",
            author: "TRBusiness; B Lab Global",
            source: "trbusiness.com; bcorporation.net",
            url: "https://www.trbusiness.com/sustainability/sustainability-news/bruichladdich-sustainability-at-the-beating-heart-of-the-business/260469",
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_whisky_17",
            moduleId: "mod_whisky",
            number: "17",
            title: "Nc'nean Sustainability; Net Zero Certification; B Corp; Seedrs Crowdfunding £1.7M",
            author: "Nc'nean Distillery; EU-Startups",
            source: "ncnean.com; eu-startups.com",
            url: "https://ncnean.com/pages/sustainability",
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_whisky_18",
            moduleId: "mod_whisky",
            number: "18",
            title: "DEEP — Dornoch Environmental Enhancement Project",
            author: "Glenmorangie / LVMH; Marine Conservation Society",
            source: "glenmorangie.com",
            url: "https://www.glenmorangie.com/en-us/pages/our-commitments-deep",
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_whisky_19",
            moduleId: "mod_whisky",
            number: "19",
            title: "Laphroaig Peatland Water Sanctuary; Restoring Islay's Peatlands",
            author: "Laphroaig / Suntory Global Spirits",
            source: "laphroaig.com",
            url: "https://www.laphroaig.com/whisky-stories/restoring-islays-peatlands",
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_whisky_20",
            moduleId: "mod_whisky",
            number: "20",
            title: "Highland Park Environmental Sustainability; HySpirits 2 Green Hydrogen; Hobbister Moor RSPB",
            author: "Highland Park / The Edrington Group; EMEC",
            source: "highlandparkwhisky.com; emec.org.uk",
            url: "https://www.highlandparkwhisky.com/en/environmental-sustainability",
            year: "2025"
        ),
        ModuleFootnote(
            id: "fn_whisky_21",
            moduleId: "mod_whisky",
            number: "21",
            title: "Maker's Mark B Corp; Star Hill Farm Regenified Tier 3 Certification",
            author: "Carbon Neutral Copy; Breaking Bourbon",
            source: "carbonneutralcopy.com; breakingbourbon.com",
            url: "https://www.carbonneutralcopy.com/makers-mark/",
            year: "2025"
        ),
        ModuleFootnote(
            id: "fn_whisky_22",
            moduleId: "mod_whisky",
            number: "22",
            title: "Galloway Distillery Re-launch 2025; Galloway and Southern Ayrshire UNESCO Biosphere Reserve",
            author: "Dumfries & Galloway Council; UNESCO Man and the Biosphere Programme",
            source: "dumfriesandgalloway.gov.uk; unesco.org",
            url: "https://www.unesco.org/en/mab/galloway-and-southern-ayrshire",
            year: "2025"
        ),
        ModuleFootnote(
            id: "fn_whisky_23",
            moduleId: "mod_whisky",
            number: "23",
            title: "Ardnamurchan Responsible Distilling; Global Sustainable Distillery of the Year 2024",
            author: "Ardnamurchan Distillery; Whisky Magazine",
            source: "ardnamurchandistillery.com",
            url: "https://ardnamurchandistillery.com/responsible-distilling",
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_whisky_24",
            moduleId: "mod_whisky",
            number: "24",
            title: "GlenWyvis Community Ownership; 100% Off-Grid Distillery; Crowdfunding Rounds",
            author: "GlenWyvis Distillery; Community Shares Scotland",
            source: "glenwyvis.com; communitysharesscotland.org.uk",
            url: "https://glenwyvis.com/our-story/",
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_whisky_25",
            moduleId: "mod_whisky",
            number: "25",
            title: "Annandale Makes Major Breakthrough in Net Zero Whisky — World-First Thermal Energy Storage",
            author: "The Spirits Business; Annandale Distillery",
            source: "thespiritsbusiness.com; annandaledistillery.com",
            url: "https://www.thespiritsbusiness.com/2026/04/annandale-makes-major-breakthrough-in-net-zero-whisky/",
            year: "2026"
        ),
        ModuleFootnote(
            id: "fn_whisky_26",
            moduleId: "mod_whisky",
            number: "26",
            title: "Collecting Daftmill Whisky; Daftmill Distillery",
            author: "Whisky Advocate; Daftmill Distillery",
            source: "whiskyadvocate.com; daftmill.com",
            url: "https://whiskyadvocate.com/Collecting-Daftmill-Whisky",
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_whisky_27",
            moduleId: "mod_whisky",
            number: "27",
            title: "Struie Smashes Crowdfunding Target by 129%; World's Most Energy-Efficient Distillery",
            author: "The Spirits Business",
            source: "thespiritsbusiness.com",
            url: "https://www.thespiritsbusiness.com/2025/04/struie-smashes-crowdfunding-target-by-129/",
            year: "2025"
        ),
        ModuleFootnote(
            id: "fn_whisky_28",
            moduleId: "mod_whisky",
            number: "28",
            title: "Highland Boundary: Sustainable Distillery Boosting Nature Recovery; Scottish Rewilding Alliance",
            author: "The Scotsman; Highland Boundary",
            source: "scotsman.com; highlandboundary.com",
            url: "https://www.scotsman.com/news/environment/sustainable-scotland-how-a-craft-distillery-in-perthshire-is-bottling-a-taste-of-the-wild-and-boosting-nature-recovery-3868645",
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_whisky_29",
            moduleId: "mod_whisky",
            number: "29",
            title: "Lochlea Single Estate Distillery; Private Cask Programme 2026",
            author: "Lochlea Distillery",
            source: "lochleadistillery.com",
            url: "https://lochleadistillery.com/",
            year: "2025"
        ),
        ModuleFootnote(
            id: "fn_whisky_30",
            moduleId: "mod_whisky",
            number: "30",
            title: "Waterford Single Farm Origin; Biodiversity Award 2024; US Whiskey Maker Takes Over Waterford",
            author: "Waterford Whisky; Global Drinks Intel; The Spirits Business",
            source: "waterfordwhisky.com; drinks-intel.com; thespiritsbusiness.com",
            url: "https://waterfordwhisky.com/single-farm-origin/",
            year: "2026"
        ),
        ModuleFootnote(
            id: "fn_whisky_31",
            moduleId: "mod_whisky",
            number: "31",
            title: "Arbikie Sustainability; World's First Climate-Positive Gin; Rye Scotch Whisky",
            author: "Arbikie Highland Estate; Scotch Whisky magazine",
            source: "arbikie.com; scotchwhisky.com",
            url: "https://arbikie.com/pages/sustainability",
            year: "2025"
        ),
        ModuleFootnote(
            id: "fn_whisky_32",
            moduleId: "mod_whisky",
            number: "32",
            title: "Clonakilty B Corp Certification and Sustainability; Boatyard — First B Corp Irish Distillery",
            author: "Clonakilty Distillery; The Drinks Business",
            source: "clonakiltydistillery.ie; thedrinksbusiness.com",
            url: "https://clonakiltydistillery.ie/b-corp/",
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_whisky_33",
            moduleId: "mod_whisky",
            number: "33",
            title: "Slane Distillery Sustainability; Salmon Ladder and Biodiversity Programmes",
            author: "Slane Irish Whiskey / Brown-Forman",
            source: "slaneirishwhiskey.com",
            url: "https://www.slaneirishwhiskey.com/who-we-are/sustainability/",
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_whisky_34",
            moduleId: "mod_whisky",
            number: "34",
            title: "Westland Distillery Bread Lab Barley Research Fellowship; Salmon-Safe Certification",
            author: "The Manual; Bartender Field Guide",
            source: "themanual.com; bartenderfieldguide.com",
            url: "https://www.themanual.com/food-and-drink/westland-distillery-barley-research-fellowship/",
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_whisky_35",
            moduleId: "mod_whisky",
            number: "35",
            title: "Beachtree World's Best Sustainable Distillery 2025; Starward Sustainability",
            author: "Beachtree Distilling Co.; Starward Whisky",
            source: "beachtree.com.au; starward.com.au",
            url: "https://beachtree.com.au/blogs/news/beachtree-named-world-s-best-craft-producer-and-sustainable-distillery-at-global-awards",
            year: "2025"
        ),
        ModuleFootnote(
            id: "fn_whisky_36",
            moduleId: "mod_whisky",
            number: "36",
            title: "Why and How Stills Influence Whisky; Why and How Oak Matters in Whisky",
            author: "Whisky Advocate",
            source: "whiskyadvocate.com",
            url: "https://whiskyadvocate.com/why-stills-matter",
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_whisky_37",
            moduleId: "mod_whisky",
            number: "37",
            title: "The Potential for Scotch Malt Whisky Flavour Diversification by Yeast — peer-reviewed",
            author: "PMC / Fermentation journal",
            source: "pmc.ncbi.nlm.nih.gov",
            url: "https://pmc.ncbi.nlm.nih.gov/articles/PMC11095643/",
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_whisky_38",
            moduleId: "mod_whisky",
            number: "38",
            title: "Tax Implications of Whiskey Cask Investments; Whisky Casks and Capital Gains Tax",
            author: "Irish Trading Whiskey; Mark Littler Ltd",
            source: "irishtradingwhiskey.com; marklittler.com",
            url: "https://www.irishtradingwhiskey.com/blog/tax-implications-of-whiskey-cask-investments",
            year: "2025"
        ),
        ModuleFootnote(
            id: "fn_whisky_39",
            moduleId: "mod_whisky",
            number: "39",
            title: "Is Whisky Investment Coming Back in 2026?",
            author: "Spiritory",
            source: "spiritory.com",
            url: "https://spiritory.com/news/will-whisky-investment-make-a-comeback-in-2026-en",
            year: "2026"
        ),
        ModuleFootnote(
            id: "fn_whisky_40",
            moduleId: "mod_whisky",
            number: "40",
            title: "Kavalan Named 2026 Distiller of the Year at World Whiskies Awards",
            author: "PR Newswire / Kavalan Distillery",
            source: "prnewswire.com",
            url: "https://www.prnewswire.com/news-releases/kavalan-is-2026-distiller-of-the-year-at-world-whiskies-awards-302730955.html",
            year: "2026"
        ),
        ModuleFootnote(
            id: "fn_whisky_41",
            moduleId: "mod_whisky",
            number: "41",
            title: "Single Malt Whisky in India: The Next Big Investment Wave",
            author: "Saras Market",
            source: "saras.market",
            url: "https://www.saras.market/blogs/single-malt-whisky-india-investment-wave",
            year: "2025"
        ),
        ModuleFootnote(
            id: "fn_whisky_42",
            moduleId: "mod_whisky",
            number: "42",
            title: "Premium Australian Whisky Is at an Inflexion Point",
            author: "Drinks Trade",
            source: "drinkstrade.com.au",
            url: "https://www.drinkstrade.com.au/premium-australian-whisky-is-at-an-inflexion-point-how-should-it-adjust/",
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_whisky_43",
            moduleId: "mod_whisky",
            number: "43",
            title: "Terroir in Whisky? Proven, At Last; Like Wine, Environmental Conditions Impact Flavor of Whiskey",
            author: "SevenFifty Daily; ScienceDaily",
            source: "daily.sevenfifty.com; sciencedaily.com",
            url: "https://daily.sevenfifty.com/terroir-in-whisky-proven-at-last/",
            year: "2021"
        ),
        ModuleFootnote(
            id: "fn_whisky_44",
            moduleId: "mod_whisky",
            number: "44",
            title: "Peat Terroir and Its Impact on Whisky; Everything You Need to Know About Peat in Whisky",
            author: "Scotch Whisky magazine; Whisky Advocate",
            source: "scotchwhisky.com; whiskyadvocate.com",
            url: "https://scotchwhisky.com/magazine/features/9292/peat-terroir-and-its-impact-on-whisky/",
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_whisky_45",
            moduleId: "mod_whisky",
            number: "45",
            title: "Whisky Makers Rediscover Bere Barley; Golden Promise — The Complete Story",
            author: "Scotch Whisky magazine; Simpsons Malt",
            source: "scotchwhisky.com; simpsonsmalt.co.uk",
            url: "https://scotchwhisky.com/magazine/features/27418/whisky-makers-rediscover-bere-barley/",
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_whisky_46",
            moduleId: "mod_whisky",
            number: "46",
            title: "Port Ellen: How a Silent Distillery Became a Collector's Grail",
            author: "The Exclusivist",
            source: "theexclusivist.com",
            url: "https://theexclusivist.com/xport-ellenthe-islay-whisky-that-gained-value-in-silence/",
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_whisky_47",
            moduleId: "mod_whisky",
            number: "47",
            title: "Pappy Van Winkle Collectors Investment Guide",
            author: "Dram Finance",
            source: "dram.finance",
            url: "https://www.dram.finance/blog/van-winkle-pappy-collectors-investment-guide",
            year: "2025"
        ),
        ModuleFootnote(
            id: "fn_whisky_48",
            moduleId: "mod_whisky",
            number: "48",
            title: "Whisky Highlights 2025 — Top Lots and Records",
            author: "Whisky.Auction",
            source: "magazine.whisky.auction",
            url: "https://magazine.whisky.auction/articles/whisky-auction-highlights-of-2025/",
            year: "2025"
        ),
        ModuleFootnote(
            id: "fn_whisky_49",
            moduleId: "mod_whisky",
            number: "49",
            title: "Lagg/Isle of Arran — 325 Hectares Peatland Restoration Partnership with Dougarie Estate",
            author: "Whisky Magazine; Dram Scotland",
            source: "whiskymag.com; dramscotland.co.uk",
            url: "https://www.whiskymag.com/articles/arrans-lagg-distillery-announces-peat-restoration-project/",
            year: "2025"
        ),
        ModuleFootnote(
            id: "fn_whisky_50",
            moduleId: "mod_whisky",
            number: "50",
            title: "Borders Distillery — FSA Gold Local Barley Partnership; Borders Growers & Distillers",
            author: "Simpsons Malt",
            source: "simpsonsmalt.co.uk",
            url: "https://www.simpsonsmalt.co.uk/latest/news/simpsons-malt-and-the-borders-distillery-launch-borders-growers-distillers-partnership/",
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_whisky_51",
            moduleId: "mod_whisky",
            number: "51",
            title: "Kingsbarns Distillery — £150,000 Heat Recovery Investment; Cartonless Packaging",
            author: "The Spirits Business; Kingsbarns Distillery",
            source: "thespiritsbusiness.com; kingsbarnsdistillery.com",
            url: "https://www.thespiritsbusiness.com/2025/02/kingsbarns-cuts-carbon-output-with-150k-investment/",
            year: "2025"
        ),
        ModuleFootnote(
            id: "fn_whisky_52",
            moduleId: "mod_whisky",
            number: "52",
            title: "Raasay Distillery Sustainable Future; Hydrogen from Whisky By-Products Research",
            author: "Isle of Raasay Distillery; University of Strathclyde",
            source: "raasaydistillery.com",
            url: "https://raasaydistillery.com/raasay-distillery-blog/our-sustainable-future/",
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_whisky_53",
            moduleId: "mod_whisky",
            number: "53",
            title: "Benbecula Distillery — Bere Barley, Seaweed Fertiliser, First Production",
            author: "The Spirits Business; Highlands and Islands Enterprise",
            source: "thespiritsbusiness.com; hie.co.uk",
            url: "https://www.thespiritsbusiness.com/2024/06/benbecula-distillery-begins-whisky-production/",
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_whisky_54",
            moduleId: "mod_whisky",
            number: "54",
            title: "Scapegrace Distilling — New Zealand's Largest Distillery; 7,000 Native Bushes; Hydro Boiler",
            author: "The Whiskey Wash",
            source: "thewhiskeywash.com",
            url: "https://thewhiskeywash.com/whiskey-styles/world/scapegrace-unveils-new-zealands-largest-distillery/",
            year: "2025"
        ),
        ModuleFootnote(
            id: "fn_whisky_55",
            moduleId: "mod_whisky",
            number: "55",
            title: "How Paul John's Indian Single Malt Matures 3× Faster Than Scotch",
            author: "Whisky Advocate",
            source: "whiskyadvocate.com",
            url: "https://whiskyadvocate.com/paul-john-indian-single-malt-whisky-explained",
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_whisky_56",
            moduleId: "mod_whisky",
            number: "56",
            title: "Whisky Returns — How Cask Investment Works",
            author: "WhiskyInvestDirect",
            source: "whiskyinvestdirect.com",
            url: "https://www.whiskyinvestdirect.com/about-whisky/whisky-guides/whisky-returns",
            year: "2025"
        ),
        ModuleFootnote(
            id: "fn_whisky_57",
            moduleId: "mod_whisky",
            number: "57",
            title: "Whisky Tax Guide for Investors 2025–2026",
            author: "Whisky Investments",
            source: "whiskyinvestments.com",
            url: "https://whiskyinvestments.com/guides/Whisky-Investment-Tax-Guide-2025-2026.pdf",
            year: "2025"
        ),
        ModuleFootnote(
            id: "fn_whisky_58",
            moduleId: "mod_whisky",
            number: "58",
            title: "New Challenges for Japanese Whisky — Authenticity Rules 2024",
            author: "The Spirits Business",
            source: "thespiritsbusiness.com",
            url: "https://www.thespiritsbusiness.com/2025/01/new-challenges-for-japanese-whisky/",
            year: "2025"
        ),
        ModuleFootnote(
            id: "fn_whisky_59",
            moduleId: "mod_whisky",
            number: "59",
            title: "Nikka Whisky — Yoichi and Miyagikyo Distillery",
            author: "Nikka Whisky / Asahi Group",
            source: "nikka.com",
            url: "https://www.nikka.com/en/distilleries/yoichi/",
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_whisky_60",
            moduleId: "mod_whisky",
            number: "60",
            title: "A Comprehensive Guide to Japanese Whisky",
            author: "Whisky Advocate",
            source: "whiskyadvocate.com",
            url: "https://whiskyadvocate.com/A-Comprehensive-Guide-To-Japanese-Whisky",
            year: "2025"
        ),
        ModuleFootnote(
            id: "fn_whisky_61",
            moduleId: "mod_whisky",
            number: "61",
            title: "Discover Tasmanian Whisky; Sullivan's Cove — Jewel of Tasmanian Whisky",
            author: "Decanter; Upscale Living Magazine",
            source: "decanter.com; upscalelivingmag.com",
            url: "https://www.decanter.com/spirits/discover-tasmanian-whisky/",
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_whisky_62",
            moduleId: "mod_whisky",
            number: "62",
            title: "Campbeltown's Comeback: Reviving a Lost Whisky Legacy",
            author: "The Whisky Shed",
            source: "thewhiskyshed.com",
            url: "https://thewhiskyshed.com/campbeltowns-comeback-reviving-a-lost-whisky-legacy/",
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_whisky_63",
            moduleId: "mod_whisky",
            number: "63",
            title: "Rare Whisky as an Investment: Collecting Strategies for 2026",
            author: "Borro Asset Finance",
            source: "borro.com",
            url: "https://borro.com/collecting-rare-whisky-investment-strategies-and-tasting-notes/",
            year: "2026"
        ),
        ModuleFootnote(
            id: "fn_whisky_64",
            moduleId: "mod_whisky",
            number: "64",
            title: "Diageo vs Brown-Forman: Which Consumer Goods Stock Is a Better Buy in 2026?",
            author: "The Motley Fool",
            source: "fool.com",
            url: "https://www.fool.com/coverage/better-buy/2026/06/04/diageo-vs-brown-forman-which-consumer-goods-stock-is-a-better-buy-in-2026/",
            year: "2026"
        ),
        ModuleFootnote(
            id: "fn_whisky_65",
            moduleId: "mod_whisky",
            number: "65",
            title: "Analysts Tip Major Alcohol Stocks to Rebound in 2025",
            author: "The Drinks Business",
            source: "thedrinksbusiness.com",
            url: "https://www.thedrinksbusiness.com/2025/03/analysts-tip-major-alcohol-stocks-to-rebound-in-2025/",
            year: "2025"
        ),
        ModuleFootnote(
            id: "fn_whisky_66",
            moduleId: "mod_whisky",
            number: "66",
            title: "US Tariffs Hit Scotch Whisky — Exports Fall 15% by Volume; SWA 2025 Export Figures",
            author: "The Drinks Business; Scotch Whisky Association",
            source: "thedrinksbusiness.com; scotch-whisky.org.uk",
            url: "https://www.thedrinksbusiness.com/2026/02/us-tariffs-hit-scotch-whisky-as-exports-fall-15-by-volume/",
            year: "2026"
        ),
        ModuleFootnote(
            id: "fn_whisky_67",
            moduleId: "mod_whisky",
            number: "67",
            title: "US Tariffs Cost Scotch Whisky £20m a Month",
            author: "The Spirits Business",
            source: "thespiritsbusiness.com",
            url: "https://www.thespiritsbusiness.com/2025/09/us-tariffs-cost-scotch-whisky-20m-a-month/",
            year: "2025"
        ),
        ModuleFootnote(
            id: "fn_whisky_68",
            moduleId: "mod_whisky",
            number: "68",
            title: "GlenWyvis Investment — Community Shares and Bond Instrument (6.25% Fixed)",
            author: "GlenWyvis Distillery; Crowdfunder",
            source: "glenwyvis.com; crowdfunder.co.uk",
            url: "https://glenwyvis.com/investment/",
            year: "2025"
        ),
        ModuleFootnote(
            id: "fn_whisky_69",
            moduleId: "mod_whisky",
            number: "69",
            title: "Thompson Brothers / TITL Crowdcube Campaign Raises £2.2M+ — Board Additions",
            author: "The Spirits Business; Thompson Brothers",
            source: "thespiritsbusiness.com; thompsonbrosdistillers.com",
            url: "https://www.thompsonsbrosdistillers.com/2025/04/",
            year: "2025"
        ),
        ModuleFootnote(
            id: "fn_whisky_70",
            moduleId: "mod_whisky",
            number: "70",
            title: "Whisky — Financing the Journey; EIS Relief in Craft Distillery Investment",
            author: "DLA Piper",
            source: "dlapiper.com",
            url: "https://www.dlapiper.com/en-eu/insights/topics/whisky-law-insights/2025/whisky---financing-the-journey",
            year: "2025"
        ),
        ModuleFootnote(
            id: "fn_whisky_71",
            moduleId: "mod_whisky",
            number: "71",
            title: "Scotch Whisky M&A Overview; Compass Box PE Acquisition (Caelum Capital)",
            author: "WhiskyInvestDirect; The Spirits Business",
            source: "whiskyinvestdirect.com; thespiritsbusiness.com",
            url: "https://www.whiskyinvestdirect.com/whisky-news/scotch-mergers-072920221",
            year: "2025"
        ),
        ModuleFootnote(
            id: "fn_whisky_72",
            moduleId: "mod_whisky",
            number: "72",
            title: "Waterford Distillery Enters Receivership After Funding Efforts Fall Short",
            author: "Whisky Advocate; Irish Times; The Drinks Business",
            source: "whiskyadvocate.com; irishtimes.com; thedrinksbusiness.com",
            url: "https://whiskyadvocate.com/Waterford-Goes-into-Receivership-After-Funding-Efforts-Fall-Short",
            year: "2024"
        ),
        ModuleFootnote(
            id: "fn_whisky_73",
            moduleId: "mod_whisky",
            number: "73",
            title: "Receivers Agree Sale of Waterford Whisky to Tennessee Distilling Group for €6m",
            author: "Irish Times",
            source: "irishtimes.com",
            url: "https://www.irishtimes.com/business/2026/03/23/receivers-agree-sale-of-waterford-whisky-to-tennessee-distilling-group-for-6m/",
            year: "2026"
        ),
        ModuleFootnote(
            id: "fn_whisky_74",
            moduleId: "mod_whisky",
            number: "74",
            title: "Pernod Ricard and Brown-Forman Call Off Merger Talks",
            author: "The Drinks Business",
            source: "thedrinksbusiness.com",
            url: "https://www.thedrinksbusiness.com/2026/04/pernod-ricard-and-brown-forman-call-off-merger-talks/",
            year: "2026"
        ),
        ModuleFootnote(
            id: "fn_whisky_75",
            moduleId: "mod_whisky",
            number: "75",
            title: "Brown-Forman Rejects Sazerac's $15bn Takeover Approach",
            author: "The Drinks Business",
            source: "thedrinksbusiness.com",
            url: "https://www.thedrinksbusiness.com/2026/05/brown-forman-rejects-sazeracs-15bn-takeover-approach/",
            year: "2026"
        ),
        ModuleFootnote(
            id: "fn_whisky_76",
            moduleId: "mod_whisky",
            number: "76",
            title: "LVMH Spirits Sales Fall 15% in H1 2025",
            author: "The Spirits Business",
            source: "thespiritsbusiness.com",
            url: "https://www.thespiritsbusiness.com/2025/07/lvmh-spirits-sales-fall-15-in-h1/",
            year: "2025"
        ),
        ModuleFootnote(
            id: "fn_whisky_77",
            moduleId: "mod_whisky",
            number: "77",
            title: "Isle of Barra Distillers Offers Combined Cask and Equity Investment Opportunity",
            author: "The Spirits Business",
            source: "thespiritsbusiness.com",
            url: "https://www.thespiritsbusiness.com/2025/11/isle-of-barra-distillers-offers-investment-opportunity/",
            year: "2025"
        ),
        ModuleFootnote(
            id: "fn_whisky_78",
            moduleId: "mod_whisky",
            number: "78",
            title: "Distillery Claims 'World First' in Bid to Produce Low-Carbon Whisky",
            author: "BBC Scotland News",
            source: "bbc.com/news",
            url: "https://www.bbc.com/news/articles/cg54npv62r3o",
            year: "2026"
        ),
    ]
}
