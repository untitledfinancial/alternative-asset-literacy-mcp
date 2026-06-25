//
//  HardcodedDatabases.swift
//  Enhanced App for Alt Assets
//
//  Fallback content for Notion inline databases.
//  Used when the live Notion API fetch fails or returns empty results.
//  Keyed by Notion database ID (without hyphens).
//
//  Databases included:
//    - db6c2f01: Neuro-economic Terms (Investing Primer)
//    - a6aced94: Alternative Investment (Alt Investing)
//    - 79153c22: Terms to Know (Alt Investing)
//    - 217e9e2f: Contribution to the Economy (Alt Investing)
//    - 7e1a82d3: Brain Tips and Tricks (Behavioral Economics)
//    - 5761243d: Comparing Traditional Finance to DeFi (DeFi)
//    - 43a959e2: DeFi vs. CBDC (DeFi)
//

import Foundation

enum HardcodedDatabases {

    /// Returns fallback entries for a known database ID, or nil if unknown.
    /// The dictionary format matches what prefetchChildDatabases() produces:
    ///   "_title" = display name, other keys = field values.
    static func entries(forDatabaseId id: String) -> [[String: String]]? {
        let clean = id.replacingOccurrences(of: "-", with: "")
        return all[clean]
    }

    // MARK: - Data

    static let all: [String: [[String: String]]] = [

        // ── Alternative Investment ────────────────────────────────────────────
        "a6aced949bca40b8b9b2e0b050606e09": [
            [
                "_title": "LPs (Limited Partners)",
                "Term": "LPs (Limited Partners)",
                "Description": "Think of LPs as the money behind the curtain. They provide the capital but hand off day-to-day decisions to someone else — a fund manager or firm — to invest on their behalf. You hand over the check; they do the work."
            ],
            [
                "_title": "GPs (General Partners)",
                "Term": "GPs (General Partners)",
                "Description": "GPs are the fund managers — the ones actually making investment decisions with the capital LPs provide. A private equity firm, a venture capital firm, a hedge fund: these are all GPs. They take on more responsibility, and typically take a share of the profits in return."
            ],
            [
                "_title": "Retail Investors",
                "Term": "Retail Investors",
                "Description": "Everyday people investing their own money — not on behalf of an institution. This includes individual investors, high-net-worth individuals, and family offices. Historically locked out of many alternative investments, that access is slowly expanding."
            ],
            [
                "_title": "Institutional Investors",
                "Term": "Institutional Investors",
                "Description": "Large organizations that invest vast pools of money — pension funds, university endowments, insurance companies, sovereign wealth funds. They have the scale and legal standing to access investment vehicles that most individuals cannot."
            ],
            [
                "_title": "Investors",
                "Term": "Investors",
                "Description": "A broad term that covers everyone in the room — GPs who put money into companies, and LPs who put money into GPs. In alternative investing, understanding which side of that table you're on shapes everything about your rights, risks, and returns."
            ]
        ],

        // ── Terms to Know ─────────────────────────────────────────────────────
        "79153c22f3784ed886a199a0c5b964a9": [
            // Public v. Private
            [
                "_title": "Public Market Investment",
                "Status": "Public v. Private",
                "Info": "Public market vehicles are situated within the public markets and encompass publicly traded instruments such as equities, bonds, and funds."
            ],
            [
                "_title": "Private Market Investment",
                "Status": "Public v. Private",
                "Info": "Private market vehicles differ by having less liquidity compared to their public counterparts and are not traded on public exchanges."
            ],
            [
                "_title": "Difference",
                "Status": "Public v. Private",
                "Info": "Alternative investment vehicles are present in both public and private markets. What distinguishes them is that alternatives operate outside traditional asset classes."
            ],
            // Liquid v. Illiquid
            [
                "_title": "Liquid Alternatives",
                "Status": "Liquid v. Illiquid",
                "Info": "Liquid alternatives are designed to offer diversification and hedge-fund-like strategies while maintaining daily liquidity and regulatory oversight."
            ],
            [
                "_title": "Illiquid Alternatives",
                "Status": "Liquid v. Illiquid",
                "Info": "Illiquid alternatives, on the other hand, are characterized by limited liquidity, longer investment horizons, and potential for higher returns."
            ],
            [
                "_title": "Difference",
                "Status": "Liquid v. Illiquid",
                "Info": "Liquidity refers to the ease with which an asset can be transacted in the market. Liquid assets can be quickly converted to cash; illiquid assets require more time."
            ],
            // Open End v. Closed End
            [
                "_title": "Open End",
                "Status": "Open End v. Closed End",
                "Info": "Open-end funds, commonly known as mutual funds, provide daily liquidity and are priced at net asset value (NAV) at the end of each trading day."
            ],
            [
                "_title": "Closed End",
                "Status": "Open End v. Closed End",
                "Info": "A closed-end fund (CEF) is a type of investment fund or collective investment scheme with a fixed number of shares, traded on a stock exchange."
            ],
            [
                "_title": "Difference",
                "Status": "Open End v. Closed End",
                "Info": "The key contrast between these two types of funds lies in how they are structured and traded. Open-end funds issue new shares as investors buy in; closed-end funds have a fixed share count."
            ]
        ],

        // ── Contribution to the Economy ───────────────────────────────────────
        "217e9e2f441f453e8a413119c82c2a49": [
            // Real Economy
            [
                "_title": "Economic Impact",
                "Status": "Real Economy",
                "Info": "Increased GDP growth. Increased competition within industries."
            ],
            [
                "_title": "Innovation",
                "Status": "Real Economy",
                "Info": "Funds technologies that will change the world tomorrow."
            ],
            [
                "_title": "Employment",
                "Status": "Real Economy",
                "Info": "VC creates new employment. PE slightly decreases employment."
            ],
            [
                "_title": "Corporate Governance",
                "Status": "Real Economy",
                "Info": "Strengthens governance structures. Reduces principle-agent issues."
            ],
            [
                "_title": "Firm Productivity",
                "Status": "Real Economy",
                "Info": "Improves the productivity of firms. Invests in new research."
            ],
            // Capital Markets
            [
                "_title": "Liquidity",
                "Status": "Capital Markets",
                "Info": "Enables investors to buy and sell assets when they want."
            ],
            [
                "_title": "Financial Innovation",
                "Status": "Capital Markets",
                "Info": "Develops new and innovative products — can also produce new risks."
            ],
            [
                "_title": "Long-term Capital",
                "Status": "Capital Markets",
                "Info": "Provides capital needed to invest in long-term projects."
            ],
            [
                "_title": "High-risk Capital",
                "Status": "Capital Markets",
                "Info": "Provides capital to projects that are too risky for normal investors."
            ],
            [
                "_title": "Transaction Costs",
                "Status": "Capital Markets",
                "Info": "Supports businesses and customers by reducing the cost of deals and trades."
            ]
        ],

        // ── Brain Tips and Tricks ─────────────────────────────────────────────
        "7e1a82d310394c28a7f30de0da06c0d4": [
            [
                "_title": "Choices",
                "Status": "Dopamine",
                "Info": "Run · Sun · Cold Plunges · Notice Moments · Work towards Goals · Be Bored · Screens Off · Increase Protein · Hydrate · Try New Things · Human Connections · Sleep · Meditate · Move · Laugh"
            ],
            [
                "_title": "Decades",
                "Status": "Dopamine",
                "Info": "As each decade passes, we experience a natural decline of 5–10% in our dopaminergic neurons. This can challenge motivation for physical activity and cognitive engagement — but it remains crucial to persevere, maintain an open mindset, and continually explore new learning opportunities."
            ],
            [
                "_title": "Timing",
                "Status": "Serotonin",
                "Info": "Serotonin levels typically peak in the late afternoon, as you prepare for sleep. Serotonin is closely linked to the pathway of melatonin, which regulates your sleep-wake cycle. As a result, you might experience heightened emotions and increased drowsiness during this time."
            ],
            [
                "_title": "Take a Walk",
                "Status": "Brain Plasticity",
                "Info": "Walking deactivates the Amygdala. One can process thoughts and feelings without attachment."
            ],
            [
                "_title": "Meditate",
                "Status": "Brain Plasticity",
                "Info": "Neuroplastic alterations in amygdala function related to negative emotional processing occur as a result of meditation practice. The stress-relieving benefits gained from meditation can extend to everyday situations."
            ]
        ]
        ,

        // ── Neuro-economic Terms (Investing Primer) ───────────────────────────
        "db6c2f019b9d43768d0e9a535d8edfa4": [
            [
                "_title": "Deliberation",
                "Context of Investing": "In the context of \"deep dives\". When learning and engaging with either new investments or evolving investments, one can think through the long-term effects over time.",
                "Assumptions": "Careful thinking about complex relationships. It takes time."
            ],
            [
                "_title": "Emotional",
                "Context of Investing": "The \"gut\" response. Helpful in trusting one's initial response when navigating what investment and/or strategy is best.",
                "Assumptions": "Emotions"
            ],
            [
                "_title": "Rational",
                "Context of Investing": "Understanding both the pros and cons, your personal preferences, and taking both into account. \"To the best of my ability at the time.\"",
                "Assumptions": "Implies Optimality."
            ]
        ],

        // ── Comparing Traditional Finance to DeFi (DeFi module) ──────────────
        "5761243d35934774a5759f643f332430": [
            [
                "_title": "Custody of Assets",
                "DeFi": "Held directly by users in non-custodial wallets or via smart contract-based escrow.",
                "Traditional": "Held by a regulated service provider or custodian on asset owners' behalf."
            ],
            [
                "_title": "Execution",
                "DeFi": "Via smart contracts operating on the user's assets.",
                "Traditional": "Intermediaries typically process transactions between parties."
            ],
            [
                "_title": "Collateral Requirements",
                "DeFi": "Overcollateralization generally required, due to digital asset volatility and absence of credit scoring.",
                "Traditional": "Transactions may involve no collateral, or collateral less than or equal to the funds provided."
            ],
            [
                "_title": "Clearing and Settlement",
                "DeFi": "Writing transactions to the underlying blockchain completes the settlement process.",
                "Traditional": "Processed by service providers or clearinghouses, typically after a period of time."
            ],
            [
                "_title": "Units of Account",
                "DeFi": "Denominated in digital assets or stablecoins (which may themselves be denominated in fiat money).",
                "Traditional": "Typically denominated in fiat currency."
            ],
            [
                "_title": "Governance",
                "DeFi": "Managed by protocol developers or determined by users holding tokens granting voting rights.",
                "Traditional": "Specified by the rules of the service provider, marketplace, regulator and/or self-regulatory organization."
            ],
            [
                "_title": "Auditability",
                "DeFi": "Open-source code and public ledger allow auditors to verify protocols and activity.",
                "Traditional": "Authorized third-party audits of proprietary code, or potential for open-source code that is publicly verified."
            ],
            [
                "_title": "Security",
                "DeFi": "Vulnerable to hacks and other technical and operational risks of smart contracts.",
                "Traditional": "Vulnerable to hacks and data breaches in software systems controlling assets."
            ],
            [
                "_title": "Investor Protection",
                "DeFi": "Users assume all risks as a default, although private redress arrangements such as DeFi insurance offer some protection against losses.",
                "Traditional": "Government-mandated disclosure and consumer protections, anti-fraud enforcement, exposure limits, and insurance schemes."
            ],
            [
                "_title": "Cross-service Interaction",
                "DeFi": "Any service may integrate with any other service on the same blockchain, and potentially across chains.",
                "Traditional": "Limited. Movement toward Open Finance via application programming interfaces or dedicated intermediaries."
            ],
            [
                "_title": "Access and Privacy",
                "DeFi": "Identity verification requirements under discussion by anti-money laundering regulators. User balances and transaction activity are generally public.",
                "Traditional": "Identity checks conducted by service providers. Personal data subject to national privacy laws."
            ]
        ],

        // ── DeFi vs. CBDC (DeFi module) ───────────────────────────────────────
        "43a959e2201e4beab8fbe2c6eb3cae92": [
            // DeFi entries
            [
                "_title": "Authority and Issuance",
                "Status": "DeFi",
                "Info": "DeFi unfurls in a decentralized fashion, untouched by the influence of central authorities. It springs to life and operates under the governance of code, predominantly within blockchain domains like Ethereum."
            ],
            [
                "_title": "Stability and Value",
                "Status": "DeFi",
                "Info": "DeFi assets, including cryptocurrencies and tokens, often voyage through turbulent market waters, buffeted by volatile forces, leading to significant value oscillations."
            ],
            [
                "_title": "Access and Inclusivity",
                "Status": "DeFi",
                "Info": "DeFi unfurls the banner of financial inclusivity, granting access to financial services for all, as long as one possesses an internet connection and a digital wallet, thereby encompassing the unbanked and underbanked populations."
            ],
            [
                "_title": "Regulation and Compliance",
                "Status": "DeFi",
                "Info": "DeFi platforms often navigate the regulatory twilight zone, potentially not conforming to the same standards of oversight and compliance upheld by conventional financial institutions. This landscape can vary contingent on jurisdiction and project."
            ],
            [
                "_title": "Property and Use Cases",
                "Status": "DeFi",
                "Info": "DeFi's core mission orbits around establishing an alternative, unbarred, and permissionless financial ecosystem — lending, borrowing, trading, and yield farming, all operating outside the traditional banking framework."
            ],
            [
                "_title": "Privacy and Security",
                "Status": "DeFi",
                "Info": "DeFi transactions adopt pseudonymity and etch their legacy on public blockchains, amplifying transparency while casting the spotlight on privacy concerns. Users remain the stewards of their private keys."
            ],
            // CBDC entries
            [
                "_title": "Authority and Issuance",
                "Status": "CBDC",
                "Info": "CBDCs are digital currencies issued and regulated by central banks. They stand as sovereign currency, bearing the full endorsement of the government."
            ],
            [
                "_title": "Stability and Value",
                "Status": "CBDC",
                "Info": "CBDCs are purposefully architected to maintain a steady value, frequently tethered to the national fiat currency. Their compass points towards price stability, steering clear of speculative ambitions."
            ],
            [
                "_title": "Access and Inclusivity",
                "Status": "CBDC",
                "Info": "CBDCs bolster financial inclusion by extending the realm of digital currency to a broader populace. Central banks may introduce measures to ensure inclusivity."
            ],
            [
                "_title": "Regulation and Compliance",
                "Status": "CBDC",
                "Info": "CBDCs submit themselves to rigorous regulatory scrutiny and adherence to financial statutes and regulations within the jurisdiction of their issuance."
            ],
            [
                "_title": "Property and Use Cases",
                "Status": "CBDC",
                "Info": "CBDCs typically emerge with the intent of refining the efficiency of the existing monetary infrastructure — expediting cost-effective cross-border transactions, minimizing cash reliance, and ensuring a firm grip on the money supply."
            ],
            [
                "_title": "Centralization vs. Decentralization",
                "Status": "CBDC",
                "Info": "CBDCs manifest as centralized digital renditions of a nation's fiat currency. They spring forth and are overseen by central banks, retaining significant sway over their issuance and management."
            ],
            [
                "_title": "Privacy and Security",
                "Status": "CBDC",
                "Info": "CBDC transactions are engineered with an array of privacy and traceability options, sculpted by the policies and regulatory mandates of the central bank. Privacy attributes can diverge across distinct CBDC implementations."
            ]
        ]
    ]
}
