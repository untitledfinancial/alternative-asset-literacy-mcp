---
license: cc-by-nc-4.0
language:
- en
tags:
- finance
- investing
- alternative-assets
- defi
- esg
- behavioral-economics
- art-market
- gender-lens-investing
- financial-education
- glossary
pretty_name: Alternative Asset Literacy Glossary
size_categories:
- n<1K
task_categories:
- text-classification
- question-answering
- feature-extraction
---

# Alternative Asset Literacy Glossary

**351 research-sourced financial terms** across 6 categories: Alternative Assets, Art, DeFi & Crypto, ESG & Climate, Behavioral Economics, and Gender Lens Investing.

Built for the [Alternative Asset Literacy](https://alternativeassetliteracy.com) iOS platform by Victoria Lee Case, Untitled_ LuxPerpetua Technologies, Inc.

---

## Dataset Description

This glossary covers financial terminology used in alternative asset education. It is distinct from standard financial glossaries in two ways:

1. **DeFi depth** — 101 terms covering blockchain fundamentals, DeFi protocols, stablecoins, yield mechanics, CBDCs, MiCA/SEC regulation, and real world asset tokenization
2. **Gender lens investing** — 17 terms covering a category almost entirely absent from standard financial glossaries: gender bonds, the 2X Challenge, WEPs, board diversity metrics, and gender-smart portfolio construction

---

## Categories

| Category | Terms | Coverage |
|----------|-------|----------|
| Art | 111 | Auction mechanics, provenance, authentication, fractional ownership, art-secured lending, NFTs, artist estates |
| DeFi & Crypto | 101 | Blockchain, AMMs, stablecoins, yield farming, DAOs, CBDCs, regulation, RWAs |
| Alternative Assets | 47 | Private equity, venture capital, hedge funds, real estate, commodities, GP/LP structures, fee waterfall |
| ESG & Climate | 42 | Green bonds, carbon credits, TCFD, EU Taxonomy, SFDR, SBTi, blended finance, greenwashing |
| Behavioral Economics | 33 | Cognitive biases, loss aversion, anchoring, overconfidence, Kahneman/Tversky/Thaler frameworks |
| Gender Lens Investing | 17 | Gender bonds, 2X Challenge, WEPs, gender wealth gap, structural barriers, gender-smart strategies |

---

## Data Format

Each record contains:

```json
{
  "term": "Carried Interest",
  "definition": "The share of profits earned by a fund manager (general partner) as performance compensation, typically 20% of gains above a hurdle rate. Carried interest is taxed as capital gains rather than ordinary income in the US, a source of ongoing tax policy debate.",
  "category": "alternative-assets"
}
```

**Fields:**
- `term` (string) — Financial term, proper-cased
- `definition` (string) — Plain-language definition, research-sourced
- `category` (string) — One of: `alternative-assets`, `art`, `behavioral-economics`, `defi`, `esg-climate`, `gender-lens`

---

## Intended Uses

- Financial education NLP tasks
- RAG (Retrieval-Augmented Generation) for finance assistants
- Fine-tuning language models on alternative asset vocabulary
- Question-answering benchmarks for financial literacy
- Semantic search over specialized financial terminology

---

## Source and Attribution

Definitions are sourced from:
- MoMA (art terminology)
- Investopedia (general finance)
- CoinGecko (DeFi/crypto)
- GIIN (impact investing)
- Original research by Untitled_ LuxPerpetua Technologies, Inc.

Full bibliography: [ncbi.nlm.nih.gov/myncbi/1Ferik7yRl8Y6d/bibliography/public/](https://www.ncbi.nlm.nih.gov/myncbi/1Ferik7yRl8Y6d/bibliography/public/)

---

## License

[CC BY-NC 4.0](https://creativecommons.org/licenses/by-nc/4.0/) — Free for educational and research use. Commercial use requires written permission from Untitled_ LuxPerpetua Technologies, Inc.

Contact: legal@untitledfinancial.com

---

## Related Resources

- **Platform**: [alternativeassetliteracy.com](https://alternativeassetliteracy.com)
- **iOS App**: Alternative Asset Literacy — [App Store](https://apps.apple.com/app/id6762205964)
- **MCP Server**: [alternativeassetliteracy.com/mcp](https://alternativeassetliteracy.com/mcp) — 13 tools including `glossary.lookup`, `glossary.search`, `glossary.browse`
- **Machine-readable glossary**: [alternativeassetliteracy.com/aal-glossary.json](https://alternativeassetliteracy.com/aal-glossary.json)

---

## Citation

```bibtex
@dataset{aal_glossary_2026,
  title     = {Alternative Asset Literacy Glossary},
  author    = {Case, Victoria Lee},
  year      = {2026},
  publisher = {Untitled_ LuxPerpetua Technologies, Inc.},
  url       = {https://huggingface.co/datasets/untitledfinancial/alternative-asset-literacy-glossary},
  license   = {CC BY-NC 4.0}
}
```
