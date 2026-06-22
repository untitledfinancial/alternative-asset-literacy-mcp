# Alternative Asset Literacy — MCP Server

Research-backed financial education platform covering alternative assets, DeFi, behavioral economics, art investing, ESG & climate finance, and gender lens investing.

**7 tools. 351 glossary terms. 43 institutional research papers. Not financial advice.**

→ [alternativeassetliteracy.com](https://alternativeassetliteracy.com)

---

## Connect

Add to your MCP client (Claude Desktop, Cursor, Windsurf, etc.):

```json
{
  "mcpServers": {
    "alternative-asset-literacy": {
      "url": "https://alternativeassetliteracy.com/mcp"
    }
  }
}
```

No API key required. No authentication.

---

## Tools

### `search_glossary`
Full-text search across all 351 financial terms and definitions.

```json
{ "query": "yield farming risk" }
{ "query": "carbon market" }
{ "query": "cognitive bias investing" }
```

### `lookup_term`
Look up any specific financial term by name.

```json
{ "term": "carried interest" }
{ "term": "impermanent loss" }
{ "term": "greenwashing" }
{ "term": "J-curve" }
{ "term": "2X Challenge" }
```

### `browse_glossary`
Browse all terms by category. Returns terms with full definitions.

| Category | Terms |
|---|---|
| Art | 111 |
| DeFi & Crypto | 101 |
| Alternative Assets | 47 |
| ESG & Climate | 42 |
| Behavioral Economics | 33 |
| Gender Lens Investing | 17 |

```json
{ "category": "Art" }
{ "category": "DeFi & Crypto", "limit": 50 }
{ "category": "Behavioral Economics" }
```

### `find_module`
Find the most relevant learning module for a topic.

```json
{ "topic": "private equity ETFs and the SEC 2024 ruling" }
{ "topic": "loss aversion and overconfidence bias" }
{ "topic": "green bonds and carbon credits" }
{ "topic": "fractional art ownership" }
```

### `route_user_profile`
Given a user description, returns the most relevant learning profile and recommended starting module.

```json
{ "user_description": "HNW woman post-liquidity event meeting with UBS" }
{ "user_description": "ESG investor curious about greenwashing" }
{ "user_description": "financial advisor looking for client education on DeFi" }
```

### `get_platform_overview`
Returns the full platform manifest — modules, tools, pricing, and target audiences.

```json
{}
```

### `get_research_papers`
Returns institutional research papers by category. 43 papers from IMF, BIS, World Bank, FSB, UN, Federal Reserve, EU, IFC, OECD, TCFD.

```json
{ "category": "ESG" }
{ "category": "CBDC" }
{ "category": "Behavioral Economics" }
{ "category": "Gender Lens" }
```

---

## What It Covers

- **Alternative Assets** — private equity, venture capital, hedge funds, real estate, commodities, private credit, family offices, carried interest, J-curve
- **DeFi & Crypto** — blockchain, stablecoins, DAOs, smart contracts, yield farming, liquidity pools, CBDCs, MiCA regulation
- **Behavioral Economics** — loss aversion, anchoring, overconfidence, confirmation bias, prospect theory, Kahneman & Tversky
- **Art Investing** — auction mechanics, hammer price vs. buyer's premium, provenance, fractional ownership, art-secured lending, NFTs
- **ESG & Climate** — green bonds, carbon credits, TCFD, EU Taxonomy, SFDR, greenwashing detection, real-world asset tokenization
- **Gender Lens Investing** — gender bonds, 2X Challenge, WEPs, gender-smart investing, the $34 trillion wealth transfer
- **Private Asset ETFs** — SEC 2024 rule change, GP/LP structures, J-curve, fee waterfall, liquidity risk in new structures

---

## Modules (13 total)

| Module | Duration | Type |
|---|---|---|
| Investing Primer | 45 min | Core — Free |
| Alternative Investing | 45 min | Core |
| Behavioral Economics | 45 min | Core |
| Gender & Behavioral Investing | 45 min | Core |
| Decentralized Finance | 45 min | Core |
| Art as Investment | 45 min | Core |
| Climate, Energy & Real World Assets | 45 min | Core |
| DeFi Investing | 90 min | Core |
| Kahlo × Basquiat: Art & Identity | 25 min | Bonus |
| High-Risk DeFi Strategies | 30 min | Bonus |
| Advanced Portfolio ESG Construction | 20 min | Bonus |
| Questions for Your Advisor — ESG | 10 min | Bonus |
| Evaluating Your Advisor's Crypto Knowledge | 15 min | Bonus |

---

## Research Foundation

43 institutional papers across 7 categories:

- **CBDC & Digital Currency** — Project Hamilton, IMF Rise of Digital Money, BIS surveys, ECB Digital Euro
- **Stablecoin Regulation** — BIS risk analysis, FSB oversight framework, EU MiCA
- **ESG & Sustainability** — TCFD, EU Taxonomy, NGFS, UN PRI, IMF climate working paper
- **Behavioral Economics** — Kahneman & Tversky (1979), Thaler & Sunstein, World Bank WDR 2015
- **Gender Lens Investing** — IFC Gender Smart Investing, 2X Challenge, McKinsey Women's Wealth
- **Fintech & Regulation** — MiCA, OCC crypto guidance, World Bank DLT, IOSCO DeFi
- **Cross-Border Payments** — G20 Roadmap, BIS Project Nexus, IMF payment frictions

Full library: [alternativeassetliteracy.com/policy-papers.html](https://alternativeassetliteracy.com/policy-papers.html)

---

## Who It's For

- High-net-worth women investors and female entrepreneurs
- ESG and climate-focused investors
- DeFi and crypto investors seeking education beyond speculation
- Art collectors and art banking clients
- Family office clients
- Financial advisors seeking client education tools
- Wealth management firms (UBS, Morgan Stanley, RBC women's wealth divisions)

---

## Endpoints

| Resource | URL |
|---|---|
| MCP Server | `https://alternativeassetliteracy.com/mcp` |
| MCP Manifest | `https://alternativeassetliteracy.com/.well-known/mcp.json` |
| Platform Overview | `https://alternativeassetliteracy.com/aal-api.json` |
| Course Catalog | `https://alternativeassetliteracy.com/aal-courses.json` |
| Full Glossary (JSON) | `https://alternativeassetliteracy.com/aal-glossary.json` |
| Research Papers (JSON) | `https://alternativeassetliteracy.com/policy-papers.json` |
| LLMs.txt | `https://alternativeassetliteracy.com/llms.txt` |

---

## Legal

Educational content only. Not financial advice.

© 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
Created by Victoria Lee Case — [contact](https://alternativeassetliteracy.com/contact.html)
