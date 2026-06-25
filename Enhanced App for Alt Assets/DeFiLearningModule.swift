//
//  DeFiLearningModule.swift
//  Enhanced App for Alt Assets
//
//  Created by Victoria Case on 2/5/26.
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//
//  Description: Comprehensive DeFi (Decentralized Finance) learning module
//  with interactive lessons, glossary integration, and practical guidance.
//  Content sourced from Notion module and World Economic Forum glossary.
//

import SwiftUI
import Combine

// MARK: - DeFi Concept Model
struct DeFiConcept: Identifiable, Hashable {
    let id: String
    var term: String
    var definition: String
    var category: DeFiCategory
    var source: String?

    enum DeFiCategory: String, CaseIterable {
        case fundamentals = "Fundamentals"
        case blockchain = "Blockchain"
        case tokens = "Tokens & Assets"
        case protocols = "Protocols"
        case governance = "Governance"
        case security = "Security"
        case regulatory = "Regulatory"

        var emoji: String {
            switch self {
            case .fundamentals: return "📚"
            case .blockchain: return "⛓️"
            case .tokens: return "🪙"
            case .protocols: return "🔧"
            case .governance: return "🏛️"
            case .security: return "🔐"
            case .regulatory: return "📋"
            }
        }

        var color: Color {
            switch self {
            case .fundamentals: return .brandPrimary
            case .blockchain: return .info
            case .tokens: return .warning
            case .protocols: return .success
            case .governance: return .brandAccent
            case .security: return .error
            case .regulatory: return .brandHighlight
            }
        }
    }
}

// MARK: - DeFi Lesson Model
struct DeFiLesson: Identifiable {
    let id: String
    var number: Int
    var title: String
    var subtitle: String
    var emoji: String
    var content: [DeFiContentBlock]
    var keyTakeaways: [String]
    var estimatedMinutes: Int
    var relatedConcepts: [String]
}

enum DeFiContentBlock: Identifiable {
    case text(String)
    case heading(String)
    case callout(emoji: String, title: String, content: String)
    case bulletList([String])
    case numberedList([String])
    case comparison(title1: String, items1: [String], title2: String, items2: [String])
    case warning(String)
    case tip(String)
    case quote(text: String, author: String?)

    var id: String {
        switch self {
        case .text(let s): return "text-\(s.prefix(20).hashValue)"
        case .heading(let s): return "heading-\(s.hashValue)"
        case .callout(_, let title, _): return "callout-\(title.hashValue)"
        case .bulletList(let items): return "bullets-\(items.count)"
        case .numberedList(let items): return "numbered-\(items.count)"
        case .comparison(let t1, _, _, _): return "compare-\(t1.hashValue)"
        case .warning(let s): return "warning-\(s.prefix(20).hashValue)"
        case .tip(let s): return "tip-\(s.prefix(20).hashValue)"
        case .quote(let text, _): return "quote-\(text.prefix(20).hashValue)"
        }
    }
}

// MARK: - DeFi Learning Manager
class DeFiLearningManager: ObservableObject {
    @Published var lessons: [DeFiLesson] = []
    @Published var glossary: [DeFiConcept] = []
    @Published var completedLessons: Set<String> = []

    static let shared = DeFiLearningManager()

    private let progressKey = "defiLessonProgress"

    init() {
        loadLessons()
        loadGlossary()
        loadProgress()
    }

    func loadLessons() {
        lessons = [
            // Lesson 1: DeFi 101
            DeFiLesson(
                id: "defi-101",
                number: 1,
                title: "DeFi 101: The Basics",
                subtitle: "Understanding Decentralized Finance",
                emoji: "🌐",
                content: [
                    .callout(emoji: "🌒", title: "Key Insight", content: "The building of DeFi without representation is the next great wealth gap."),
                    .heading("What is DeFi?"),
                    .text("Decentralized Finance describes a financial system that operates on blockchain technology and aims to recreate and improve upon traditional financial services in a decentralized manner. DeFi encompasses a diverse array of technologies, business models, and organizational structures, with the overarching goal of replacing traditional intermediaries."),
                    .text("DeFi is orchestrating shifts within the global financial landscape. In an era where the crypto and digital asset domain is accelerating through transformation, organizations find themselves at the crossroads of a remarkable opportunity to reimagine future business paradigms."),
                    .text("Source: Wharton Blockchain and Digital Asset Project, in collaboration with the World Economic Forum"),
                    .heading("Why Does It Matter?"),
                    .bulletList([
                        "Removes middlemen from financial transactions",
                        "Provides financial services to the unbanked",
                        "Enables programmable, transparent finance",
                        "Creates new investment opportunities",
                        "Operates 24/7 globally without borders"
                    ]),
                    .callout(emoji: "💡", title: "The Numbers", content: "The DeFi sector grew from $4 billion to over $104 billion in Total Value Locked (TVL) in just three years, demonstrating rapid adoption and market interest. The market capitalization surpassed $130 billion as of December 2021. (6)(7)"),
                    .warning("DeFi investments come with inherent risks, including smart contract vulnerabilities, market volatility, and regulatory uncertainties. Only invest what you can afford to lose.")
                ],
                keyTakeaways: [
                    "DeFi uses blockchain to recreate financial services without intermediaries",
                    "The sector has seen explosive growth but remains volatile",
                    "Understanding the technology is crucial before investing"
                ],
                estimatedMinutes: 12,
                relatedConcepts: ["Blockchain", "Smart contract", "Distributed ledger technology (DLT)"]
            ),

            // Lesson 2: Web3 and Ownership
            DeFiLesson(
                id: "defi-web3",
                number: 2,
                title: "Web3 and Ownership",
                subtitle: "The evolution of the internet and digital property",
                emoji: "🧊",
                content: [
                    .heading("The Evolution of the Web"),
                    .comparison(
                        title1: "Web1 - Read Only",
                        items1: [
                            "Early days of the internet",
                            "Static web pages",
                            "Only creators could input content",
                            "Limited user interaction"
                        ],
                        title2: "Web2 - Read & Write",
                        items2: [
                            "Social media platforms emerge",
                            "Users create content",
                            "Platforms own and monetize user data",
                            "Centralized control"
                        ]
                    ),
                    .heading("Web3 - Read, Write & Own"),
                    .text("Through decentralized networks versus centralized servers, users are now in control of their own data. Users can be fully in control of anything and everything they create. As a tech driven society the use of Web3 will naturally evolve what we think the economy should look like."),
                    .bulletList([
                        "True digital ownership through blockchain",
                        "Users control their data and identity",
                        "Value flows to creators, not just platforms",
                        "Decentralized governance through DAOs"
                    ]),
                    .callout(emoji: "🔑", title: "Key Concept", content: "In Web3, your wallet is your identity. It holds your assets, credentials, and access to decentralized applications — all controlled by you through your private keys."),
                    .warning("With ownership comes responsibility. Losing your private keys means losing access to your assets forever — there's no 'forgot password' option in DeFi.")
                ],
                keyTakeaways: [
                    "Web3 represents a shift from platform ownership to user ownership",
                    "Blockchain enables true digital property rights",
                    "Self-custody requires careful security practices"
                ],
                estimatedMinutes: 10,
                relatedConcepts: ["Digital wallet", "Digital identity (ID)", "Privacy"]
            ),

            // Lesson 3: Blockchain Fundamentals
            DeFiLesson(
                id: "defi-blockchain",
                number: 3,
                title: "DeFi Powered by Blockchain",
                subtitle: "The technology foundation",
                emoji: "🧨",
                content: [
                    .heading("How Blockchain Works"),
                    .text("At the heart of DeFi lies blockchain and cryptocurrency — the core technologies that breathe life into this financial revolution. When we say blockchain is distributed, it means all parties engaged in a DeFi application possess an identical copy of the public ledger. It documents each transaction, concealing them in encrypted code. (4)"),
                    .callout(emoji: "⛓️", title: "Distributed", content: "All participants have an identical copy of the ledger. Transactions are encrypted for anonymity while being transparent and verifiable."),
                    .callout(emoji: "🔓", title: "Decentralized", content: "No intermediaries or gatekeepers. Transactions are validated by solving complex mathematical puzzles and adding new blocks to the chain."),
                    .heading("Consensus Mechanisms"),
                    .bulletList([
                        "Proof of Work (PoW): Energy-intensive validation through computation",
                        "Proof of Stake (PoS): Validation based on staked tokens",
                        "Each has trade-offs between security, decentralization, and efficiency"
                    ]),
                    .callout(emoji: "💰", title: "Proof of Stake Consideration", content: "PoS requires substantial initial investment to become a validator. This can lead to systems controlled by wealthy individuals with large stakes. (8)"),
                    .heading("Smart Contracts"),
                    .text("Smart contracts are self-executing programs stored on the blockchain. They automatically enforce agreements when conditions are met — no lawyers or middlemen required."),
                    .tip("Understanding smart contracts is essential for DeFi. They're the building blocks of every DeFi protocol.")
                ],
                keyTakeaways: [
                    "Blockchain provides a transparent, distributed ledger",
                    "Consensus mechanisms validate transactions without central authority",
                    "Smart contracts automate financial agreements"
                ],
                estimatedMinutes: 15,
                relatedConcepts: ["Blockchain", "Smart contract", "Distributed ledger technology (DLT)", "Peer-to-peer (P2P)"]
            ),

            // Lesson 4: Digital Assets
            DeFiLesson(
                id: "defi-assets",
                number: 4,
                title: "Digital Assets",
                subtitle: "Cryptocurrencies, tokens, and stablecoins",
                emoji: "🍭",
                content: [
                    .heading("Cryptocurrencies vs. Tokens"),
                    .text("Cryptocurrencies and tokens are both digital assets, but they serve different purposes and have distinct characteristics. (17)(18)"),
                    .comparison(
                        title1: "Cryptocurrencies",
                        items1: [
                            "Native to their own blockchain",
                            "Primarily used as currency/store of value",
                            "Examples: Bitcoin, Ethereum, Litecoin",
                            "Independent monetary systems"
                        ],
                        title2: "Tokens",
                        items2: [
                            "Built on existing blockchains",
                            "Various use cases beyond currency",
                            "Examples: USDC (stablecoin), LINK (utility)",
                            "Depend on host blockchain"
                        ]
                    ),
                    .heading("Stablecoins"),
                    .text("Stablecoins are designed to retain consistent value relative to a chosen asset, typically the U.S. dollar. Theoretically, $1 = 1 Token. (19)"),
                    .bulletList([
                        "Bridge between crypto volatility and traditional stability",
                        "Fiat-backed: Held reserves of actual currency",
                        "Crypto-backed: Overcollateralized with other crypto",
                        "Algorithmic: Use smart contracts to maintain peg"
                    ]),
                    .callout(emoji: "💡", title: "Fiat Currency", content: "Fiat is traditional government-issued money like USD, EUR, or JPY. 'Fiat' means 'by decree' — its value comes from government backing, not intrinsic worth."),
                    .heading("DeFi vs. CBDC"),
                    .text("DeFi and CBDCs represent contrasting approaches to digital finance — one decentralized and permissionless, the other centralized and regulated. DeFi champions decentralization and blockchain technology, while CBDCs emerge as centralized digital avatars of a nation's fiat currency. (20)"),
                    .warning("Not all stablecoins are equally stable. Research the backing mechanism and track record before holding significant amounts.")
                ],
                keyTakeaways: [
                    "Cryptocurrencies are native to their blockchain; tokens are built on top",
                    "Stablecoins provide price stability in the volatile crypto market",
                    "Different backing mechanisms carry different risks"
                ],
                estimatedMinutes: 12,
                relatedConcepts: ["Crypto-assets", "Digital token", "Stablecoin", "Fiat currency", "CBDC"]
            ),

            // Lesson 5: The DeFi Stack
            DeFiLesson(
                id: "defi-stack",
                number: 5,
                title: "The DeFi Stack",
                subtitle: "Layers of decentralized finance",
                emoji: "🎱",
                content: [
                    .heading("Understanding the Layers"),
                    .text("DeFi is built in layers, each serving a specific function in the ecosystem. (13)(14)"),
                    .numberedList([
                        "Settlement Layer: The blockchain itself (Ethereum, Solana, etc.)",
                        "Protocol Layer: Smart contracts that define financial operations",
                        "Application Layer: User-facing interfaces (wallets, exchanges)",
                        "Aggregation Layer: Services that combine multiple protocols"
                    ]),
                    .heading("Oracles: The Bridge to Real-World Data"),
                    .text("Oracles act as conduits for reliable data that originates outside the blockchain. For instance, a price feed can tap into external markets to bring current asset prices on-chain."),
                    .callout(emoji: "🎱", title: "Oracle Risk", content: "If an oracle provides incorrect data, smart contracts may execute improperly. This is a critical vulnerability in DeFi systems."),
                    .heading("Key DeFi Services"),
                    .bulletList([
                        "Exchanges (DEXs): Decentralized trading platforms",
                        "Lending/Borrowing: Earn interest or borrow against collateral",
                        "Staking: Lock tokens to earn rewards and secure networks",
                        "Yield Farming: Optimize returns across protocols",
                        "Insurance: Coverage against smart contract failures"
                    ]),
                    .tip("Start simple. Understand one layer well before adding complexity. Many losses come from not understanding how protocols interact.")
                ],
                keyTakeaways: [
                    "DeFi operates in distinct layers, from blockchain to applications",
                    "Oracles bridge on-chain and off-chain data",
                    "Multiple service types exist: exchanges, lending, staking, etc."
                ],
                estimatedMinutes: 14,
                relatedConcepts: ["Decentralized atomic cross-chain swap", "Centralized exchange", "Peer-to-peer (P2P)"]
            ),

            // Lesson 6: Governance and DAOs
            DeFiLesson(
                id: "defi-governance",
                number: 6,
                title: "Decentralized Governance & DAOs",
                subtitle: "How decisions are made in DeFi",
                emoji: "🏛️",
                content: [
                    .heading("What is a DAO?"),
                    .text("A Decentralized Autonomous Organization (DAO) is a community-led entity with no central authority. Decisions are made collectively by token holders through voting. (15)(16)"),
                    .bulletList([
                        "Rules encoded in smart contracts",
                        "Token holders vote on proposals",
                        "Transparent and auditable governance",
                        "No single point of failure or control"
                    ]),
                    .heading("Governance Tokens"),
                    .text("Many DeFi projects have governance tokens that bestow voting rights for specific decisions. These tokens are often traded on exchanges."),
                    .callout(emoji: "🗳️", title: "How Voting Works", content: "Token holders propose changes, discuss them, and vote. When a proposal passes, smart contracts automatically implement the changes."),
                    .heading("Questions for Policy-Makers"),
                    .text("DAOs raise novel questions about legal status, liability, and regulation:"),
                    .bulletList([
                        "Who is liable when a DAO makes a harmful decision?",
                        "How should DAOs be taxed?",
                        "Can DAOs enter legal contracts?",
                        "How do securities laws apply to governance tokens?"
                    ]),
                    .warning("Governance token ownership doesn't mean equal influence. Large holders (whales) can dominate voting, creating centralization within 'decentralized' systems.")
                ],
                keyTakeaways: [
                    "DAOs enable community governance through token voting",
                    "Governance tokens grant voting rights but are also traded assets",
                    "Decentralization doesn't guarantee equal power distribution"
                ],
                estimatedMinutes: 12,
                relatedConcepts: ["Digital token", "Smart contract"]
            ),

            // Lesson 7: Defining Traits of DeFi
            DeFiLesson(
                id: "defi-traits",
                number: 7,
                title: "Defining Traits of DeFi",
                subtitle: "What makes DeFi different from traditional finance",
                emoji: "🌿",
                content: [
                    .heading("Not Everything is DeFi"),
                    .text("Not every instance of blockchain technology implementation can be classified as DeFi. Similarly, not every component within the DeFi ecosystem is itself a DeFi service. As the landscape evolves, a set of distinct characteristics has emerged. (9)"),
                    .heading("Core Characteristics"),
                    .bulletList([
                        "Within Financial Services: Directly facilitates the transmission and interchange of value",
                        "Trust-Minimized: Operates on public, permissionless blockchains with smart contracts",
                        "Non-Custodial: Assets remain under user control, not held by third parties",
                        "Open & Composable: Open-source code with public APIs enabling integration"
                    ]),
                    .heading("The Smart Contract Paradigm"),
                    .text("When delving into the distinction between DeFi and traditional finance, the introduction of smart contracts aimed to revolutionize the financial service industry by offering a completely automated approach. Programmability equates to reliability. (23)"),
                    .text("Engaging with a financial advisor, coupled with a solid understanding of DeFi fundamentals, significantly enriches the ability to diversify your investment portfolio and navigate the path toward long-term wealth creation."),
                    .callout(emoji: "🏛️", title: "Source", content: "Wharton Blockchain and Digital Asset Project, in collaboration with the World Economic Forum"),
                    .warning("DeFi still faces substantial challenges, particularly in terms of widespread adoption. The innovations are constantly changing — approach with caution and curiosity.")
                ],
                keyTakeaways: [
                    "DeFi has specific defining traits: trust-minimized, non-custodial, composable",
                    "Not everything on blockchain qualifies as DeFi",
                    "Smart contracts enable automation but don't eliminate all risk"
                ],
                estimatedMinutes: 10,
                relatedConcepts: ["Smart contract", "Non-custodial", "Composability"]
            ),

            // Lesson 8: Security & Risk
            DeFiLesson(
                id: "defi-security",
                number: 8,
                title: "Security & Risk Management",
                subtitle: "Protecting yourself in DeFi",
                emoji: "🔐",
                content: [
                    .heading("Key Risks in DeFi"),
                    .bulletList([
                        "Smart Contract Risk: Bugs or exploits in code",
                        "Oracle Risk: Incorrect external data",
                        "Liquidity Risk: Unable to exit positions",
                        "Impermanent Loss: Value changes in liquidity pools",
                        "Rug Pull Risk: Malicious project abandonment",
                        "Regulatory Risk: Changing legal landscape"
                    ]),
                    .heading("Security Best Practices"),
                    .numberedList([
                        "Use hardware wallets for significant holdings",
                        "Never share private keys or recovery phrases",
                        "Verify smart contract addresses before interacting",
                        "Start with small amounts to test protocols",
                        "Use only audited protocols from reputable teams",
                        "Enable all available security features (2FA, etc.)",
                        "Establish proper backup and recovery mechanisms"
                    ]),
                    .callout(emoji: "💰", title: "Wallet Security", content: "With DeFi, you must secure your own wallets. If you lose a private key, you lose access to your funds forever — there's no way to recover a lost private key."),
                    .heading("Due Diligence Checklist"),
                    .bulletList([
                        "Has the protocol been audited? By whom?",
                        "How long has it been operating without incidents?",
                        "Is the team known and reputable?",
                        "Are the tokenomics sustainable?",
                        "What's the TVL trend? Steady growth or volatile?"
                    ]),
                    .text("Consider potential tax implications associated with DeFi transactions, as tax obligations may vary by jurisdiction. Seeking guidance from a tax professional can help you understand and appropriately report crypto-related income. (10)"),
                    .callout(emoji: "⚖️", title: "Legal Disclaimer", content: "We recommend you work with your financial advisor. This content does not constitute financial advice."),
                    .warning("If yields seem too good to be true, they probably are. Extremely high APYs often indicate unsustainable tokenomics or hidden risks.")
                ],
                keyTakeaways: [
                    "DeFi carries unique risks beyond traditional investing",
                    "Self-custody means self-responsibility for security",
                    "Due diligence is essential before committing funds"
                ],
                estimatedMinutes: 15,
                relatedConcepts: ["Digital wallet", "Privacy-enhancing technology (PET)", "Know Your Customer (KYC)"]
            )
        ]
    }

    func loadGlossary() {
        // DeFi Glossary - Core concepts for infrastructure investing
        glossary = [
            // Fundamentals
            DeFiConcept(id: "fiat", term: "Fiat Currency", definition: "Government-issued currency not backed by a physical commodity but by the issuing government.", category: .fundamentals, source: "World Economic Forum"),
            DeFiConcept(id: "financial-inclusion", term: "Financial Inclusion", definition: "Efforts to make financial services accessible to all individuals and businesses, regardless of personal net worth or company size.", category: .fundamentals, source: "World Economic Forum"),
            DeFiConcept(id: "tvl", term: "Total Value Locked (TVL)", definition: "The total amount of assets deposited in a DeFi protocol, measured in USD. A key metric for assessing protocol adoption and liquidity.", category: .fundamentals, source: "DeFi Infrastructure"),
            DeFiConcept(id: "protocol-revenue", term: "Protocol Revenue", definition: "Income generated by a DeFi protocol through fees, interest spreads, or other mechanisms. Organic revenue (from real usage) is more sustainable than incentivized revenue.", category: .fundamentals, source: "DeFi Infrastructure"),
            DeFiConcept(id: "value-accrual", term: "Value Accrual", definition: "Mechanisms by which protocol success translates to token-holder benefit, including fee switches, token burns, and buyback programs.", category: .fundamentals, source: "DeFi Infrastructure"),

            // Blockchain
            DeFiConcept(id: "blockchain", term: "Blockchain", definition: "A distributed, immutable ledger that records transactions across many computers so that records cannot be altered retroactively.", category: .blockchain, source: "World Economic Forum"),
            DeFiConcept(id: "dlt", term: "Distributed Ledger Technology (DLT)", definition: "Technology that allows data to be stored and shared across multiple sites, countries, or institutions without central administration.", category: .blockchain, source: "World Economic Forum"),
            DeFiConcept(id: "layer-1", term: "Layer 1 (L1)", definition: "The base blockchain network (e.g., Ethereum, Solana) that provides the settlement layer for transactions and smart contracts.", category: .blockchain, source: "DeFi Infrastructure"),
            DeFiConcept(id: "layer-2", term: "Layer 2 (L2)", definition: "Scaling solutions built on top of Layer 1 blockchains to increase transaction throughput and reduce costs.", category: .blockchain, source: "DeFi Infrastructure"),

            // Tokens & Assets
            DeFiConcept(id: "cbdc", term: "Central Bank Digital Currency (CBDC)", definition: "A digital form of a country's fiat currency, issued and regulated by the central bank.", category: .tokens, source: "World Economic Forum"),
            DeFiConcept(id: "crypto-assets", term: "Crypto-assets", definition: "Digital representations of value or rights that can be transferred and stored electronically using blockchain technology.", category: .tokens, source: "World Economic Forum"),
            DeFiConcept(id: "digital-token", term: "Digital Token", definition: "A unit of value issued on a blockchain, representing assets, access rights, or other utilities.", category: .tokens, source: "World Economic Forum"),
            DeFiConcept(id: "stablecoin", term: "Stablecoin", definition: "Cryptocurrency designed to maintain stable value relative to a reference asset, typically fiat currency.", category: .tokens, source: "World Economic Forum"),
            DeFiConcept(id: "governance-token", term: "Governance Token", definition: "Tokens that grant holders voting rights on protocol decisions. May or may not include economic rights to protocol revenue.", category: .tokens, source: "DeFi Infrastructure"),
            DeFiConcept(id: "retail-cbdc", term: "Retail CBDC", definition: "Central bank digital currency designed for use by the general public.", category: .tokens, source: "World Economic Forum"),
            DeFiConcept(id: "wholesale-cbdc", term: "Wholesale CBDC", definition: "Central bank digital currency for use by financial institutions in interbank settlements.", category: .tokens, source: "World Economic Forum"),

            // Protocols
            DeFiConcept(id: "smart-contract", term: "Smart Contract", definition: "Self-executing contracts with terms directly written into code, automatically enforcing agreements when conditions are met.", category: .protocols, source: "World Economic Forum"),
            DeFiConcept(id: "amm", term: "Automated Market Maker (AMM)", definition: "A type of decentralized exchange that uses algorithmic pools of tokens instead of order books. Users trade against liquidity pools rather than other users.", category: .protocols, source: "DeFi Infrastructure"),
            DeFiConcept(id: "dex", term: "Decentralized Exchange (DEX)", definition: "A cryptocurrency exchange operating without a central authority, allowing peer-to-peer trading through smart contracts.", category: .protocols, source: "DeFi Infrastructure"),
            DeFiConcept(id: "cex", term: "Centralized Exchange", definition: "A cryptocurrency trading platform operated by a central organization that acts as intermediary and custodian.", category: .protocols, source: "World Economic Forum"),
            DeFiConcept(id: "lending-protocol", term: "Lending Protocol", definition: "DeFi platforms (like Aave) that enable users to lend assets for interest or borrow against collateral.", category: .protocols, source: "DeFi Infrastructure"),
            DeFiConcept(id: "overcollateralization", term: "Overcollateralization", definition: "Requiring borrowers to deposit more value in collateral than they borrow, protecting lenders from default risk.", category: .protocols, source: "DeFi Infrastructure"),
            DeFiConcept(id: "fee-switch", term: "Fee Switch", definition: "A governance-controlled mechanism that enables protocol fees to be directed to token holders instead of solely to liquidity providers.", category: .protocols, source: "DeFi Infrastructure"),
            DeFiConcept(id: "atomic-swap", term: "Atomic Swaps", definition: "Peer-to-peer exchange of cryptocurrencies from different blockchains without intermediaries, using smart contracts.", category: .protocols, source: "World Economic Forum"),
            DeFiConcept(id: "p2p", term: "Peer-to-peer (P2P)", definition: "Direct transactions between parties without intermediaries, enabled by decentralized networks.", category: .protocols, source: "World Economic Forum"),

            // Governance
            DeFiConcept(id: "dao", term: "DAO (Decentralized Autonomous Organization)", definition: "A community-led entity with no central authority, where decisions are made collectively by token holders through on-chain voting.", category: .governance, source: "DeFi Infrastructure"),
            DeFiConcept(id: "on-chain-governance", term: "On-Chain Governance", definition: "Protocol governance where proposals and votes are recorded directly on the blockchain, with outcomes automatically executed by smart contracts.", category: .governance, source: "DeFi Infrastructure"),
            DeFiConcept(id: "proposal", term: "Governance Proposal", definition: "A formal suggestion for protocol changes submitted by token holders for community vote. Passing proposals can modify protocol parameters.", category: .governance, source: "DeFi Infrastructure"),

            // Security
            DeFiConcept(id: "digital-wallet", term: "Digital Wallet", definition: "Software or hardware that stores private keys and enables users to send, receive, and manage digital assets.", category: .security, source: "World Economic Forum"),
            DeFiConcept(id: "hardware-wallet", term: "Hardware Wallet", definition: "Physical devices (like Ledger or Trezor) that store private keys offline, providing enhanced security against digital attacks.", category: .security, source: "DeFi Infrastructure"),
            DeFiConcept(id: "smart-contract-risk", term: "Smart Contract Risk", definition: "The risk of bugs, exploits, or vulnerabilities in smart contract code that could result in loss of funds.", category: .security, source: "DeFi Infrastructure"),
            DeFiConcept(id: "oracle-risk", term: "Oracle Risk", definition: "The risk that external data feeds (oracles) provide incorrect information to smart contracts, causing improper execution.", category: .security, source: "DeFi Infrastructure"),
            DeFiConcept(id: "impermanent-loss", term: "Impermanent Loss", definition: "Temporary loss of value experienced by liquidity providers when the price ratio of pooled tokens changes relative to when they were deposited.", category: .security, source: "DeFi Infrastructure"),
            DeFiConcept(id: "liquidation", term: "Liquidation", definition: "Automatic selling of collateral when a borrower's position falls below required health factor, protecting the protocol from bad debt.", category: .security, source: "DeFi Infrastructure"),
            DeFiConcept(id: "pki", term: "Public Key Infrastructure (PKI)", definition: "Framework for creating, managing, and using public-key cryptography for secure communications.", category: .security, source: "World Economic Forum"),
            DeFiConcept(id: "pet", term: "Privacy-enhancing Technology (PET)", definition: "Technologies that protect personal data while enabling data processing and analysis.", category: .security, source: "World Economic Forum"),

            // Regulatory
            DeFiConcept(id: "aml", term: "Anti-money laundering (AML)/CFT", definition: "Regulations and procedures to prevent money laundering and terrorist financing in financial systems.", category: .regulatory, source: "World Economic Forum"),
            DeFiConcept(id: "kyc", term: "Know Your Customer (KYC)", definition: "Due diligence processes financial institutions use to verify the identity of their clients.", category: .regulatory, source: "World Economic Forum"),
            DeFiConcept(id: "mica", term: "MiCA (Markets in Crypto-Assets)", definition: "The EU's comprehensive regulatory framework for crypto-assets, including stablecoin issuance requirements and service provider licensing.", category: .regulatory, source: "European Union")
        ]
    }

    // MARK: - Progress
    func loadProgress() {
        if let data = UserDefaults.standard.data(forKey: progressKey),
           let completed = try? JSONDecoder().decode(Set<String>.self, from: data) {
            completedLessons = completed
        }
    }

    func saveProgress() {
        if let data = try? JSONEncoder().encode(completedLessons) {
            UserDefaults.standard.set(data, forKey: progressKey)
        }
    }

    func markLessonComplete(_ lessonId: String) {
        completedLessons.insert(lessonId)
        saveProgress()
    }

    func isLessonComplete(_ lessonId: String) -> Bool {
        completedLessons.contains(lessonId)
    }

    var completionProgress: Double {
        guard !lessons.isEmpty else { return 0 }
        return Double(completedLessons.count) / Double(lessons.count)
    }

    func conceptsByCategory(_ category: DeFiConcept.DeFiCategory) -> [DeFiConcept] {
        glossary.filter { $0.category == category }
    }
}

// MARK: - DeFi Module Overview View
struct DeFiModuleOverviewView: View {
    @ObservedObject var manager = DeFiLearningManager.shared

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                // Header
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Text("⛓️")
                        .font(.system(size: 40))

                    Text("Decentralized Finance")
                        .font(Typography.title1)
                        .foregroundColor(.textPrimary)

                    Text("A little bit utopian meets a little bit utilitarian...")
                        .font(Typography.body)
                        .italic()
                        .foregroundColor(.textSecondary)
                }
                .padding(.horizontal, Spacing.lg)

                // Progress
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    HStack {
                        Text("Progress")
                            .font(Typography.captionMedium)
                            .foregroundColor(.textTertiary)
                        Spacer()
                        Text("\(manager.completedLessons.count)/\(manager.lessons.count) lessons")
                            .font(Typography.caption)
                            .foregroundColor(.textSecondary)
                    }

                    ProgressView(value: manager.completionProgress)
                        .tint(.brandPrimary)
                }
                .padding(.horizontal, Spacing.lg)

                // Lessons
                Text("Lessons")
                    .font(Typography.title3)
                    .foregroundColor(.textPrimary)
                    .padding(.horizontal, Spacing.lg)

                LazyVStack(spacing: Spacing.md) {
                    ForEach(manager.lessons) { lesson in
                        NavigationLink(destination: DeFiLessonDetailView(lesson: lesson)) {
                            DeFiLessonCard(lesson: lesson)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, Spacing.lg)

                // Glossary Section
                NavigationLink(destination: DeFiGlossaryView()) {
                    HStack {
                        Text("📖")
                            .font(.system(size: 24))
                        VStack(alignment: .leading, spacing: 2) {
                            Text("DeFi Glossary")
                                .font(Typography.bodyMedium)
                                .foregroundColor(.textPrimary)
                            Text("\(manager.glossary.count) terms from World Economic Forum")
                                .font(Typography.caption)
                                .foregroundColor(.textTertiary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.textTertiary)
                    }
                    .padding(Spacing.md)
                    .background(Color.surfaceSecondary)
                    .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
                }
                .buttonStyle(.plain)
                .padding(.horizontal, Spacing.lg)

                // Research Library Section
                NavigationLink(destination: PolicyPaperLibraryView()) {
                    HStack {
                        Text("📚")
                            .font(.system(size: 24))
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Research Library")
                                .font(Typography.bodyMedium)
                                .foregroundColor(.textPrimary)
                            Text("\(PolicyPaperLibrary.papers.count) papers on CBDC & Stablecoins")
                                .font(Typography.caption)
                                .foregroundColor(.textTertiary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.textTertiary)
                    }
                    .padding(Spacing.md)
                    .background(Color.brandPrimary.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
                }
                .buttonStyle(.plain)
                .padding(.horizontal, Spacing.lg)
            }
            .padding(.vertical, Spacing.lg)
        }
        .background(Color.surfacePrimary)
        .navigationTitle("DeFi")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

// MARK: - DeFi Lesson Card
struct DeFiLessonCard: View {
    let lesson: DeFiLesson
    @ObservedObject var manager = DeFiLearningManager.shared

    var isComplete: Bool {
        manager.isLessonComplete(lesson.id)
    }

    var body: some View {
        HStack(spacing: Spacing.md) {
            // Lesson number
            ZStack {
                Circle()
                    .fill(isComplete ? Color.success : Color.surfaceTertiary)
                    .frame(width: 36, height: 36)

                if isComplete {
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                        .font(.system(size: 12, weight: .bold))
                } else {
                    Text("\(lesson.number)")
                        .font(Typography.bodyMedium)
                        .foregroundColor(.textSecondary)
                }
            }

            VStack(alignment: .leading, spacing: Spacing.xxs) {
                HStack(spacing: Spacing.xs) {
                    Text(lesson.emoji)
                    Text(lesson.title)
                        .font(Typography.bodyMedium)
                        .foregroundColor(.textPrimary)
                }

                Text(lesson.subtitle)
                    .font(Typography.caption)
                    .foregroundColor(.textTertiary)

                HStack(spacing: Spacing.sm) {
                    Label("\(lesson.estimatedMinutes) min", systemImage: "clock")
                }
                .font(Typography.caption2)
                .foregroundColor(.textTertiary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.textTertiary)
        }
        .padding(Spacing.md)
        .background(Color.surfaceSecondary)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
    }
}

// MARK: - DeFi Lesson Detail View
struct DeFiLessonDetailView: View {
    let lesson: DeFiLesson
    @ObservedObject var manager = DeFiLearningManager.shared

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.xl) {
                // Header
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    HStack {
                        Text(lesson.emoji)
                            .font(.system(size: 32))
                        Text("Lesson \(lesson.number)")
                            .font(Typography.caption)
                            .foregroundColor(.textTertiary)
                    }

                    Text(lesson.title)
                        .font(Typography.title2)
                        .foregroundColor(.textPrimary)

                    Text(lesson.subtitle)
                        .font(Typography.body)
                        .foregroundColor(.textSecondary)
                }

                // Content
                ForEach(lesson.content) { block in
                    DeFiContentBlockView(block: block)
                }

                // Key Takeaways
                if !lesson.keyTakeaways.isEmpty {
                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        HStack(spacing: Spacing.sm) {
                            Text("💡")
                            Text("Key Takeaways")
                                .font(Typography.bodyMedium)
                                .foregroundColor(.textPrimary)
                        }

                        ForEach(lesson.keyTakeaways, id: \.self) { takeaway in
                            HStack(alignment: .top, spacing: Spacing.sm) {
                                Text("•")
                                    .foregroundColor(.brandPrimary)
                                Text(takeaway)
                                    .font(Typography.body)
                                    .foregroundColor(.textSecondary)
                            }
                        }
                    }
                    .padding(Spacing.md)
                    .background(Color.brandPrimary.opacity(0.05))
                    .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
                }

                // Related Concepts
                if !lesson.relatedConcepts.isEmpty {
                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        Text("Related Terms")
                            .font(Typography.captionMedium)
                            .foregroundColor(.textTertiary)

                        FlowLayout(spacing: Spacing.xs) {
                            ForEach(lesson.relatedConcepts, id: \.self) { concept in
                                Text(concept)
                                    .font(Typography.caption)
                                    .foregroundColor(.info)
                                    .padding(.horizontal, Spacing.sm)
                                    .padding(.vertical, Spacing.xs)
                                    .background(Color.info.opacity(0.1))
                                    .clipShape(Capsule())
                            }
                        }
                    }
                }

                // Complete button
                if !manager.isLessonComplete(lesson.id) {
                    Button {
                        manager.markLessonComplete(lesson.id)
                    } label: {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Mark as Complete")
                        }
                        .font(Typography.bodyMedium)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(Spacing.md)
                        .background(Color.brandPrimary)
                        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
                    }
                } else {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.success)
                        Text("Lesson Complete")
                            .font(Typography.bodyMedium)
                            .foregroundColor(.success)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(Spacing.md)
                    .background(Color.success.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
                }
            }
            .padding(Spacing.lg)
        }
        .background(Color.surfacePrimary)
        .navigationTitle(lesson.title)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

// MARK: - DeFi Content Block View
struct DeFiContentBlockView: View {
    let block: DeFiContentBlock

    var body: some View {
        switch block {
        case .text(let text):
            Text(text)
                .font(Typography.body)
                .foregroundColor(.textSecondary)

        case .heading(let text):
            Text(text)
                .font(Typography.title3)
                .foregroundColor(.textPrimary)
                .padding(.top, Spacing.sm)

        case .callout(let emoji, let title, let content):
            VStack(alignment: .leading, spacing: Spacing.sm) {
                HStack(spacing: Spacing.sm) {
                    Text(emoji)
                        .font(.system(size: 18))
                    Text(title)
                        .font(Typography.bodyMedium)
                        .foregroundColor(.textPrimary)
                }
                Text(content)
                    .font(Typography.body)
                    .foregroundColor(.textSecondary)
            }
            .padding(Spacing.md)
            .background(Color.info.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.sm))

        case .bulletList(let items):
            VStack(alignment: .leading, spacing: Spacing.xs) {
                ForEach(items, id: \.self) { item in
                    HStack(alignment: .top, spacing: Spacing.sm) {
                        Text("•")
                            .foregroundColor(.brandPrimary)
                        Text(item)
                            .font(Typography.body)
                            .foregroundColor(.textSecondary)
                    }
                }
            }

        case .numberedList(let items):
            VStack(alignment: .leading, spacing: Spacing.xs) {
                ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                    HStack(alignment: .top, spacing: Spacing.sm) {
                        Text("\(index + 1).")
                            .font(Typography.bodyMedium)
                            .foregroundColor(.brandPrimary)
                            .frame(width: 20, alignment: .trailing)
                        Text(item)
                            .font(Typography.body)
                            .foregroundColor(.textSecondary)
                    }
                }
            }

        case .comparison(let title1, let items1, let title2, let items2):
            HStack(alignment: .top, spacing: Spacing.md) {
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Text(title1)
                        .font(Typography.bodyMedium)
                        .foregroundColor(.textPrimary)
                    ForEach(items1, id: \.self) { item in
                        HStack(alignment: .top, spacing: Spacing.xs) {
                            Text("•")
                                .foregroundColor(.info)
                            Text(item)
                                .font(Typography.caption)
                                .foregroundColor(.textSecondary)
                        }
                    }
                }
                .padding(Spacing.sm)
                .background(Color.info.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: CornerRadius.sm))

                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Text(title2)
                        .font(Typography.bodyMedium)
                        .foregroundColor(.textPrimary)
                    ForEach(items2, id: \.self) { item in
                        HStack(alignment: .top, spacing: Spacing.xs) {
                            Text("•")
                                .foregroundColor(.warning)
                            Text(item)
                                .font(Typography.caption)
                                .foregroundColor(.textSecondary)
                        }
                    }
                }
                .padding(Spacing.sm)
                .background(Color.warning.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: CornerRadius.sm))
            }

        case .warning(let text):
            HStack(alignment: .top, spacing: Spacing.sm) {
                Text("⚠️")
                    .font(.system(size: 18))
                Text(text)
                    .font(Typography.body)
                    .foregroundColor(.textSecondary)
            }
            .padding(Spacing.md)
            .background(Color.warning.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.sm))

        case .tip(let text):
            HStack(alignment: .top, spacing: Spacing.sm) {
                Text("💡")
                    .font(.system(size: 18))
                Text(text)
                    .font(Typography.body)
                    .foregroundColor(.textSecondary)
            }
            .padding(Spacing.md)
            .background(Color.success.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.sm))

        case .quote(let text, let author):
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text("\"\(text)\"")
                    .font(Typography.body)
                    .italic()
                    .foregroundColor(.textSecondary)
                if let author = author {
                    Text("— \(author)")
                        .font(Typography.caption)
                        .foregroundColor(.textTertiary)
                }
            }
            .padding(Spacing.md)
            .background(Color.surfaceTertiary.opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.sm))
        }
    }
}

// MARK: - DeFi Glossary View
struct DeFiGlossaryView: View {
    @ObservedObject var manager = DeFiLearningManager.shared
    @State private var selectedCategory: DeFiConcept.DeFiCategory?
    @State private var searchText = ""

    var filteredConcepts: [DeFiConcept] {
        var concepts = manager.glossary

        if let category = selectedCategory {
            concepts = concepts.filter { $0.category == category }
        }

        if !searchText.isEmpty {
            concepts = concepts.filter {
                $0.term.localizedCaseInsensitiveContains(searchText) ||
                $0.definition.localizedCaseInsensitiveContains(searchText)
            }
        }

        return concepts.sorted { $0.term < $1.term }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                // Search
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.textTertiary)
                    TextField("Search terms...", text: $searchText)
                }
                .padding(Spacing.sm)
                .background(Color.surfaceSecondary)
                .clipShape(RoundedRectangle(cornerRadius: CornerRadius.sm))
                .padding(.horizontal, Spacing.lg)

                // Category filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: Spacing.sm) {
                        CategoryChip(
                            title: "All",
                            emoji: "📚",
                            isSelected: selectedCategory == nil,
                            color: .brandPrimary
                        ) {
                            selectedCategory = nil
                        }

                        ForEach(DeFiConcept.DeFiCategory.allCases, id: \.self) { category in
                            CategoryChip(
                                title: category.rawValue,
                                emoji: category.emoji,
                                isSelected: selectedCategory == category,
                                color: category.color
                            ) {
                                selectedCategory = category
                            }
                        }
                    }
                    .padding(.horizontal, Spacing.lg)
                }

                // Terms
                LazyVStack(spacing: Spacing.sm) {
                    ForEach(filteredConcepts) { concept in
                        DeFiConceptCard(concept: concept)
                    }
                }
                .padding(.horizontal, Spacing.lg)
            }
            .padding(.vertical, Spacing.lg)
        }
        .background(Color.surfacePrimary)
        .navigationTitle("DeFi Glossary")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

// MARK: - Category Chip
struct CategoryChip: View {
    let title: String
    let emoji: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.xxs) {
                Text(emoji)
                    .font(.system(size: 12))
                Text(title)
                    .font(Typography.caption2)
            }
            .padding(.horizontal, Spacing.sm)
            .padding(.vertical, Spacing.xs)
            .background(isSelected ? color : Color.surfaceSecondary)
            .foregroundColor(isSelected ? .white : .textSecondary)
            .clipShape(Capsule())
        }
    }
}

// MARK: - DeFi Concept Card
struct DeFiConceptCard: View {
    let concept: DeFiConcept
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                withAnimation(.spring(response: 0.3)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack(spacing: Spacing.sm) {
                    Text(concept.category.emoji)
                        .font(.system(size: 16))

                    Text(concept.term)
                        .font(Typography.bodyMedium)
                        .foregroundColor(.textPrimary)

                    Spacer()

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundColor(.textTertiary)
                }
                .padding(Spacing.md)
            }
            .buttonStyle(.plain)

            if isExpanded {
                Divider()
                    .padding(.horizontal, Spacing.md)

                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Text(concept.definition)
                        .font(Typography.body)
                        .foregroundColor(.textSecondary)

                    if let source = concept.source {
                        Text("Source: \(source)")
                            .font(Typography.caption2)
                            .foregroundColor(.textTertiary)
                    }
                }
                .padding(Spacing.md)
            }
        }
        .background(Color.surfaceSecondary)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
    }
}

// MARK: - Policy Paper Library Data
// External research papers on CBDC, Stablecoins, and Digital Currency Policy
// This section can be easily updated with new papers from your Notion library

struct PolicyPaperLibrary {

    struct ResearchPaper: Identifiable {
        let id = UUID()
        let title: String
        let author: String
        let organization: String
        let date: String // e.g., "2024" or "March 2024"
        let category: Category
        let summary: String
        let keyFindings: [String]
        let url: String? // Link to full paper
        let tags: [String]

        enum Category: String, CaseIterable {
            case cbdc = "CBDC Research"
            case stablecoins = "Stablecoins"
            case regulation = "Regulation & Policy"
            case crossBorder = "Cross-Border Payments"
            case privacy = "Privacy & Security"
            case technical = "Technical Standards"

            var emoji: String {
                switch self {
                case .cbdc: return "🏛️"
                case .stablecoins: return "🪙"
                case .regulation: return "📋"
                case .crossBorder: return "🌍"
                case .privacy: return "🔐"
                case .technical: return "⚙️"
                }
            }

            var color: Color {
                switch self {
                case .cbdc: return .brandPrimary
                case .stablecoins: return .warning
                case .regulation: return .info
                case .crossBorder: return .success
                case .privacy: return .error
                case .technical: return .brandAccent
                }
            }
        }
    }

    // MARK: - Papers Data
    // Add new papers here as you find them in your Notion library
    static let papers: [ResearchPaper] = [
        // CBDC Research
        ResearchPaper(
            title: "Central Bank Digital Currencies: Foundational Principles and Core Features",
            author: "BIS Innovation Hub",
            organization: "Bank for International Settlements",
            date: "2020",
            category: .cbdc,
            summary: "Joint report from leading central banks outlining the fundamental principles for CBDC development, including design considerations and policy implications.",
            keyFindings: [
                "CBDCs should complement, not replace, existing forms of money",
                "Central banks must maintain monetary sovereignty",
                "Privacy protections are essential but must balance with compliance",
                "Interoperability should be a core design principle"
            ],
            url: "https://www.bis.org/publ/othp33.htm",
            tags: ["BIS", "Central Banks", "Design Principles"]
        ),
        ResearchPaper(
            title: "Money and Payments: The U.S. Dollar in the Age of Digital Transformation",
            author: "Federal Reserve Board",
            organization: "Federal Reserve System",
            date: "January 2022",
            category: .cbdc,
            summary: "The Fed's first major discussion paper on the potential benefits and risks of a U.S. CBDC, examining design options and policy considerations.",
            keyFindings: [
                "A CBDC could provide a safe digital payment option",
                "Privacy protections would be critical for public trust",
                "Technology infrastructure would need significant investment",
                "International coordination is necessary for cross-border use"
            ],
            url: "https://www.federalreserve.gov/publications/money-and-payments-discussion-paper.htm",
            tags: ["Federal Reserve", "US Dollar", "Policy"]
        ),
        ResearchPaper(
            title: "Digital Euro: Progress on the Investigation Phase",
            author: "European Central Bank",
            organization: "ECB",
            date: "2024",
            category: .cbdc,
            summary: "Latest updates on the ECB's digital euro project, covering technical prototypes, privacy considerations, and stakeholder feedback.",
            keyFindings: [
                "Offline functionality is technically feasible",
                "Privacy can be preserved while meeting AML requirements",
                "Distribution through existing banks preferred",
                "Public consultation shows strong privacy concerns"
            ],
            url: "https://www.ecb.europa.eu/paym/digital_euro/html/index.en.html",
            tags: ["ECB", "Digital Euro", "Privacy"]
        ),

        // Stablecoins
        ResearchPaper(
            title: "Stablecoins: Growth Potential and Impact on Banking",
            author: "Federal Reserve Bank of New York",
            organization: "NY Fed",
            date: "2023",
            category: .stablecoins,
            summary: "Analysis of stablecoin market growth, reserve composition, and potential systemic risks to the traditional banking sector.",
            keyFindings: [
                "Stablecoin reserves increasingly held in Treasury bills",
                "Run risks remain if reserves are not fully liquid",
                "Bank deposit disintermediation is a growing concern",
                "Regulatory clarity would accelerate institutional adoption"
            ],
            url: nil,
            tags: ["Stablecoins", "Banking", "Reserves"]
        ),
        ResearchPaper(
            title: "The Future of Money and Payments",
            author: "G7 Working Group",
            organization: "G7 Finance Ministers",
            date: "2022",
            category: .stablecoins,
            summary: "G7 position on global stablecoin regulation and the need for consistent international standards.",
            keyFindings: [
                "Global stablecoins pose unique financial stability risks",
                "Same activity, same risk, same regulation principle",
                "Reserve requirements should be stringent and audited",
                "Consumer protection must be prioritized"
            ],
            url: nil,
            tags: ["G7", "Global Standards", "Regulation"]
        ),

        // Regulation & Policy
        ResearchPaper(
            title: "Markets in Crypto-Assets Regulation (MiCA)",
            author: "European Commission",
            organization: "European Union",
            date: "2023",
            category: .regulation,
            summary: "Comprehensive regulatory framework for crypto-assets in the EU, including stablecoin issuance requirements and service provider licensing.",
            keyFindings: [
                "Stablecoin issuers must maintain 1:1 reserves",
                "Asset-referenced tokens have additional capital requirements",
                "Service providers need authorization in one EU state",
                "Environmental disclosures required for PoW consensus"
            ],
            url: "https://eur-lex.europa.eu/eli/reg/2023/1114/oj",
            tags: ["MiCA", "EU", "Licensing"]
        ),
        ResearchPaper(
            title: "Regulating the Crypto Ecosystem",
            author: "Financial Stability Board",
            organization: "FSB",
            date: "July 2023",
            category: .regulation,
            summary: "Global regulatory framework recommendations for crypto-asset activities and markets, with focus on financial stability.",
            keyFindings: [
                "Crypto regulations should be proportionate to risks",
                "Cross-border cooperation is essential",
                "DeFi presents unique regulatory challenges",
                "Functional approach preferred over entity-based"
            ],
            url: "https://www.fsb.org/2023/07/fsb-finalises-global-regulatory-framework-for-crypto-asset-activities/",
            tags: ["FSB", "Global Framework", "DeFi"]
        ),

        // Cross-Border Payments
        ResearchPaper(
            title: "mBridge: Building a Multi-CBDC Platform for International Payments",
            author: "BIS Innovation Hub",
            organization: "BIS, HKMA, BOT, PBOC, CBUAE",
            date: "2024",
            category: .crossBorder,
            summary: "Technical and operational learnings from the mBridge project connecting multiple Asian central banks for cross-border CBDC transactions.",
            keyFindings: [
                "Cross-border settlements reduced from days to seconds",
                "Transaction costs significantly lower than correspondent banking",
                "Privacy preserved through purpose-bound money design",
                "Scalability tested with thousands of transactions"
            ],
            url: "https://www.bis.org/about/bisih/topics/cbdc/mcbdc_bridge.htm",
            tags: ["mBridge", "Cross-Border", "Asia"]
        ),
        ResearchPaper(
            title: "Project Icebreaker: Breaking New Ground for Cross-Border Retail CBDC Payments",
            author: "BIS Innovation Hub Nordic Centre",
            organization: "BIS, Bank of Israel, Norges Bank, Sveriges Riksbank",
            date: "2023",
            category: .crossBorder,
            summary: "Exploration of how retail CBDCs could be used for international payments through a hub-and-spoke model.",
            keyFindings: [
                "Retail CBDC cross-border payments are technically feasible",
                "FX conversion can happen in real-time",
                "Hub model reduces complexity vs bilateral connections",
                "Regulatory harmonization remains a challenge"
            ],
            url: "https://www.bis.org/publ/othp61.htm",
            tags: ["Icebreaker", "Retail CBDC", "Nordic"]
        ),

        // Privacy & Security
        ResearchPaper(
            title: "Privacy-Enhancing Technologies for CBDC",
            author: "MIT Digital Currency Initiative",
            organization: "MIT Media Lab",
            date: "2023",
            category: .privacy,
            summary: "Technical survey of privacy-preserving techniques applicable to CBDC design, including zero-knowledge proofs and hardware security.",
            keyFindings: [
                "Zero-knowledge proofs can enable private transactions",
                "Hardware-based privacy offers offline capabilities",
                "Tiered privacy based on transaction size is feasible",
                "No single solution addresses all privacy requirements"
            ],
            url: "https://dci.mit.edu/",
            tags: ["MIT", "Privacy", "ZK Proofs"]
        ),
        ResearchPaper(
            title: "Cybersecurity Considerations for CBDC",
            author: "IMF Monetary and Capital Markets",
            organization: "International Monetary Fund",
            date: "2022",
            category: .privacy,
            summary: "Framework for addressing cybersecurity risks in CBDC systems, including threat modeling and operational resilience.",
            keyFindings: [
                "CBDCs create new attack vectors for nation-states",
                "Quantum-resistant cryptography should be planned for",
                "Incident response procedures critical for confidence",
                "Third-party vendor risks must be managed"
            ],
            url: nil,
            tags: ["IMF", "Cybersecurity", "Resilience"]
        ),

        // Technical Standards
        ResearchPaper(
            title: "ISO 20022: The Standard for Digital Payments",
            author: "SWIFT",
            organization: "SWIFT/ISO",
            date: "2023",
            category: .technical,
            summary: "Overview of ISO 20022 messaging standard adoption and its implications for CBDC and digital payment interoperability.",
            keyFindings: [
                "ISO 20022 enables richer payment data",
                "Migration deadline for cross-border is November 2025",
                "CBDC systems should adopt ISO 20022 natively",
                "API-based implementation recommended"
            ],
            url: "https://www.swift.com/standards/iso-20022",
            tags: ["ISO 20022", "Standards", "Interoperability"]
        ),
        ResearchPaper(
            title: "DLT Reference Architecture for CBDCs",
            author: "R3",
            organization: "R3 / World Economic Forum",
            date: "2024",
            category: .technical,
            summary: "Technical reference architecture for distributed ledger-based CBDC implementations, with case studies from live pilots.",
            keyFindings: [
                "Permissioned DLT preferred for CBDCs",
                "Smart contracts enable programmable money",
                "Token vs account-based models have different trade-offs",
                "Hybrid architectures common in production"
            ],
            url: nil,
            tags: ["R3", "DLT", "Architecture"]
        )
    ]
}

// MARK: - Policy Paper Library View
struct PolicyPaperLibraryView: View {
    @EnvironmentObject var notionService: NotionService
    @State private var selectedCategory: PolicyPaperLibrary.ResearchPaper.Category?
    @State private var searchText = ""
    @State private var expandedPapers: Set<UUID> = []
    @State private var papers: [PolicyPaperLibrary.ResearchPaper] = PolicyPaperLibrary.papers

    private static let notionDatabaseId = "148f0f41c8198005ad62da451a0e026d"

    var filteredPapers: [PolicyPaperLibrary.ResearchPaper] {
        var result = papers

        if let category = selectedCategory {
            result = result.filter { $0.category == category }
        }

        if !searchText.isEmpty {
            result = result.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.organization.localizedCaseInsensitiveContains(searchText) ||
                $0.summary.localizedCaseInsensitiveContains(searchText) ||
                $0.tags.contains { $0.localizedCaseInsensitiveContains(searchText) }
            }
        }

        return result
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                // Header
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Text("📚")
                        .font(.system(size: 40))

                    Text("Research Library")
                        .font(Typography.title2)
                        .foregroundColor(.textPrimary)

                    Text("Industry white papers and technical research on CBDC, stablecoins, and digital currency policy.")
                        .font(Typography.body)
                        .foregroundColor(.textSecondary)
                }
                .padding(.horizontal, Spacing.lg)

                // Search
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.textTertiary)
                    TextField("Search papers...", text: $searchText)
                        .font(Typography.body)

                    if !searchText.isEmpty {
                        Button {
                            searchText = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.textTertiary)
                        }
                    }
                }
                .padding(Spacing.sm)
                .background(Color.surfaceSecondary)
                .clipShape(RoundedRectangle(cornerRadius: CornerRadius.sm))
                .padding(.horizontal, Spacing.lg)

                // Category filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: Spacing.sm) {
                        CategoryChip(
                            title: "All",
                            emoji: "📚",
                            isSelected: selectedCategory == nil,
                            color: .brandPrimary
                        ) {
                            selectedCategory = nil
                        }

                        ForEach(PolicyPaperLibrary.ResearchPaper.Category.allCases, id: \.self) { category in
                            CategoryChip(
                                title: category.rawValue,
                                emoji: category.emoji,
                                isSelected: selectedCategory == category,
                                color: category.color
                            ) {
                                selectedCategory = category
                            }
                        }
                    }
                    .padding(.horizontal, Spacing.lg)
                }

                // Papers count
                Text("\(filteredPapers.count) papers")
                    .font(Typography.caption)
                    .foregroundColor(.textTertiary)
                    .padding(.horizontal, Spacing.lg)

                // Papers list
                LazyVStack(spacing: Spacing.md) {
                    ForEach(filteredPapers) { paper in
                        PolicyPaperCard(
                            paper: paper,
                            isExpanded: expandedPapers.contains(paper.id)
                        ) {
                            withAnimation(.smoothSpring) {
                                if expandedPapers.contains(paper.id) {
                                    expandedPapers.remove(paper.id)
                                } else {
                                    expandedPapers.insert(paper.id)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, Spacing.lg)

                // Footer
                VStack(spacing: Spacing.sm) {
                    Divider()
                    Text("Papers sourced from central banks, BIS, IMF, and academic institutions. This library is for educational purposes.")
                        .font(Typography.caption2)
                        .foregroundColor(.textTertiary)
                        .multilineTextAlignment(.center)
                }
                .padding(Spacing.lg)
            }
            .padding(.vertical, Spacing.lg)
        }
        .background(Color.surfacePrimary)
        .navigationTitle("Research Library")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .task {
            await fetchFromNotion()
        }
    }

    private func fetchFromNotion() async {
        guard !notionService.apiKey.isEmpty else { return }

        do {
            let pages = try await notionService.fetchDatabaseEntries(databaseId: Self.notionDatabaseId)
            var fetched: [PolicyPaperLibrary.ResearchPaper] = []

            for page in pages {
                let title = page.properties.first(where: { $0.value.title != nil })?.value.title?.map { $0.plainText }.joined() ?? ""
                let author = page.properties["Author"]?.richText?.map { $0.plainText }.joined()
                    ?? page.properties["Authors"]?.richText?.map { $0.plainText }.joined()
                    ?? ""
                let organization = page.properties["Organization"]?.richText?.map { $0.plainText }.joined()
                    ?? page.properties["Publication"]?.richText?.map { $0.plainText }.joined()
                    ?? page.properties["Source"]?.richText?.map { $0.plainText }.joined()
                    ?? ""
                let date = page.properties["Date"]?.richText?.map { $0.plainText }.joined()
                    ?? page.properties["Year"]?.richText?.map { $0.plainText }.joined()
                    ?? (page.properties["Year"]?.number.map { String(Int($0)) })
                    ?? ""
                let summary = page.properties["Summary"]?.richText?.map { $0.plainText }.joined()
                    ?? page.properties["Description"]?.richText?.map { $0.plainText }.joined()
                    ?? ""
                let url = page.properties["URL"]?.url
                    ?? page.properties["Link"]?.url
                let categoryName = page.properties["Category"]?.select?.name
                    ?? page.properties["Topic"]?.select?.name
                    ?? ""
                let tags = page.properties["Tags"]?.multiSelect?.map { $0.name } ?? []

                let category = mapNotionCategory(categoryName)

                if !title.isEmpty {
                    fetched.append(PolicyPaperLibrary.ResearchPaper(
                        title: title, author: author, organization: organization,
                        date: date, category: category, summary: summary,
                        keyFindings: [], url: url, tags: tags
                    ))
                }
            }

            debugLog("📄 Fetched \(fetched.count) papers from Notion database")
            if !fetched.isEmpty {
                await MainActor.run {
                    // Merge: keep static papers that don't have a matching title in Notion results
                    let fetchedTitles = Set(fetched.map { $0.title.lowercased() })
                    let uniqueStatic = PolicyPaperLibrary.papers.filter {
                        !fetchedTitles.contains($0.title.lowercased())
                    }
                    papers = (fetched + uniqueStatic).sorted { $0.title < $1.title }
                    debugLog("📄 Merged papers: \(fetched.count) from Notion + \(uniqueStatic.count) static = \(papers.count) total")
                }
            }
        } catch {
            debugLog("⚠️ [PolicyPaperLibrary] Failed to fetch from Notion DB \(Self.notionDatabaseId): \(error.localizedDescription)")
        }
    }

    private func mapNotionCategory(_ name: String) -> PolicyPaperLibrary.ResearchPaper.Category {
        let lower = name.lowercased()
        if lower.contains("cbdc") || lower.contains("central bank digital") { return .cbdc }
        if lower.contains("stablecoin") { return .stablecoins }
        if lower.contains("cross") || lower.contains("border") || lower.contains("payment") { return .crossBorder }
        if lower.contains("privacy") || lower.contains("security") { return .privacy }
        if lower.contains("technical") || lower.contains("standard") { return .technical }
        return .regulation
    }
}

// MARK: - Policy Paper Card
struct PolicyPaperCard: View {
    let paper: PolicyPaperLibrary.ResearchPaper
    let isExpanded: Bool
    let onToggle: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header (always visible)
            Button(action: onToggle) {
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    HStack(spacing: Spacing.sm) {
                        Text(paper.category.emoji)
                            .font(.system(size: 20))

                        VStack(alignment: .leading, spacing: 2) {
                            Text(paper.category.rawValue)
                                .font(Typography.caption2)
                                .foregroundColor(paper.category.color)

                            Text(paper.date)
                                .font(Typography.caption2)
                                .foregroundColor(.textTertiary)
                        }

                        Spacer()

                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .font(.caption)
                            .foregroundColor(.textTertiary)
                    }

                    Text(paper.title)
                        .font(Typography.bodyMedium)
                        .foregroundColor(.textPrimary)
                        .multilineTextAlignment(.leading)

                    Text(paper.organization)
                        .font(Typography.caption)
                        .foregroundColor(.textSecondary)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .padding(Spacing.md)

            // Expanded content
            if isExpanded {
                Divider()
                    .padding(.horizontal, Spacing.md)

                VStack(alignment: .leading, spacing: Spacing.md) {
                    // Author
                    HStack(spacing: Spacing.xs) {
                        Image(systemName: "person.fill")
                            .font(.caption2)
                            .foregroundColor(.textTertiary)
                        Text(paper.author)
                            .font(Typography.caption)
                            .foregroundColor(.textSecondary)
                    }

                    // Summary
                    Text(paper.summary)
                        .font(Typography.body)
                        .foregroundColor(.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)

                    // Key Findings
                    if !paper.keyFindings.isEmpty {
                        VStack(alignment: .leading, spacing: Spacing.sm) {
                            Text("Key Findings")
                                .font(Typography.captionMedium)
                                .foregroundColor(.textPrimary)

                            ForEach(paper.keyFindings, id: \.self) { finding in
                                HStack(alignment: .top, spacing: Spacing.sm) {
                                    Circle()
                                        .fill(paper.category.color)
                                        .frame(width: 6, height: 6)
                                        .padding(.top, 6)

                                    Text(finding)
                                        .font(Typography.caption)
                                        .foregroundColor(.textSecondary)
                                }
                            }
                        }
                        .padding(Spacing.sm)
                        .background(paper.category.color.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.sm))
                    }

                    // Tags
                    FlowLayout(spacing: Spacing.xs) {
                        ForEach(paper.tags, id: \.self) { tag in
                            Text(tag)
                                .font(Typography.caption2)
                                .foregroundColor(.textSecondary)
                                .padding(.horizontal, Spacing.sm)
                                .padding(.vertical, Spacing.xxs)
                                .background(Color.surfaceTertiary)
                                .clipShape(Capsule())
                        }
                    }

                    // Link if available
                    if let url = paper.url, let linkURL = URL(string: url) {
                        Link(destination: linkURL) {
                            HStack(spacing: Spacing.xs) {
                                Image(systemName: "arrow.up.right.square")
                                Text("View Full Paper")
                            }
                            .font(Typography.captionMedium)
                            .foregroundColor(.brandPrimary)
                        }
                        .padding(.top, Spacing.xs)
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

// MARK: - Updated DeFi Module Overview with Research Library Link
extension DeFiModuleOverviewView {
    var researchLibraryLink: some View {
        NavigationLink(destination: PolicyPaperLibraryView()) {
            HStack {
                Text("📚")
                    .font(.system(size: 24))
                VStack(alignment: .leading, spacing: 2) {
                    Text("Research Library")
                        .font(Typography.bodyMedium)
                        .foregroundColor(.textPrimary)
                    Text("CBDC, stablecoins & digital currency policy papers")
                        .font(Typography.caption)
                        .foregroundColor(.textTertiary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.textTertiary)
            }
            .padding(Spacing.md)
            .background(Color.brandPrimary.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
        }
        .buttonStyle(.plain)
        .padding(.horizontal, Spacing.lg)
    }
}

// MARK: - DeFi Lessons Tab View (for embedding in ModuleDetailView)
/// Tab view showing DeFi lessons - used when DeFi module is selected
struct DeFiLessonsTabView: View {
    @ObservedObject var manager = DeFiLearningManager.shared

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.lg) {
            // Header
            VStack(alignment: .leading, spacing: Spacing.sm) {
                Text("⛓️ DeFi Learning Path")
                    .font(Typography.title2)
                    .foregroundColor(.textPrimary)

                Text("8 lessons covering blockchain fundamentals, digital assets, governance, and security.")
                    .font(Typography.body)
                    .foregroundColor(.textSecondary)
            }
            .padding(.top, Spacing.lg)

            // Progress
            VStack(alignment: .leading, spacing: Spacing.sm) {
                HStack {
                    Text("Your Progress")
                        .font(Typography.captionMedium)
                        .foregroundColor(.textTertiary)
                    Spacer()
                    Text("\(manager.completedLessons.count)/\(manager.lessons.count) lessons")
                        .font(Typography.caption)
                        .foregroundColor(.textSecondary)
                }

                ProgressView(value: manager.completionProgress)
                    .tint(.brandPrimary)
            }

            // Lessons list
            LazyVStack(spacing: Spacing.md) {
                ForEach(manager.lessons) { lesson in
                    NavigationLink(destination: DeFiLessonDetailView(lesson: lesson)) {
                        DeFiLessonCard(lesson: lesson)
                    }
                    .buttonStyle(.plain)
                }
            }

            Spacer()
                .frame(height: Spacing.xxl)
        }
        .padding(.horizontal, Spacing.lg)
    }
}

// MARK: - Preview
#Preview("DeFi Module") {
    NavigationStack {
        DeFiModuleOverviewView()
    }
}

#Preview("DeFi Lessons Tab") {
    NavigationStack {
        DeFiLessonsTabView()
    }
}

#Preview("Policy Paper Library") {
    NavigationStack {
        PolicyPaperLibraryView()
    }
}
