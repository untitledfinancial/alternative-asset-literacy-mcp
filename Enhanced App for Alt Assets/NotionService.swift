//
//  NotionService.swift
//  Enhanced App for Alt Assets
//
//  Created by Victoria Case on 2/1/26.
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//
//  Description: Handles Notion API integration, fetches module content from Notion
//  databases, parses blocks into structured content, and automatically generates
//  case studies, reflection prompts, and quizzes from academically-vetted material.
//

import Foundation
import Combine

// MARK: - Further Reading Model
struct FurtherReading: Identifiable, Codable {
    let id: String
    let title: String
    let url: String
    let category: String      // Art, DeFi, Behavioral, etc.
    let type: ReadingType     // Article, Paper, Video, Book
    let author: String?
    let description: String?
    let moduleId: String?     // Optional relation to a module

    enum ReadingType: String, Codable {
        case article = "Article"
        case paper = "Paper"
        case video = "Video"
        case book = "Book"
        case podcast = "Podcast"
        case tool = "Tool"
    }
}

// MARK: - Module Page Configuration
/// Maps Notion page IDs to app module metadata.
/// Since modules are standalone Notion pages (not database rows), we define
/// the mapping here so we know which pages to fetch and how to display them.
struct ModulePageConfig {
    let notionPageId: String       // Notion page UUID
    let moduleId: String           // App-internal module ID (e.g., "mod_alt")
    let title: String              // Display title
    let description: String        // Short description
    let icon: String               // Emoji icon
    let color: String              // Theme color name
    let estimatedTime: Int         // Minutes
    let tags: [String]             // Topic tags
    let displayOrder: Int          // Sort order on home screen
    let parentModuleId: String?    // Non-nil = sub-module (won't show on home)
    let isBonus: Bool              // Bonus/supplemental module
    let heroImageName: String?     // Asset catalog image name for module card cover
}

class NotionService: ObservableObject {
    @Published var modules: [Module] = []
    @Published var furtherReadings: [FurtherReading] = []  // Dynamic from Notion
    @Published var isLoading = false
    @Published var error: String?
    @Published var lastSyncDate: Date?

    private var _apiKey: String
    private var databaseId: String
    private var furtherReadingDatabaseId: String = ""  // Set this to your Further Reading database ID
    private let baseURL = "https://api.notion.com/v1"

    /// Public read-only access to check if API key is available
    var apiKey: String { _apiKey }

    /// Public method to fetch database entries (used by Art Library, etc.)
    func fetchDatabaseEntries(databaseId: String) async throws -> [NotionPage] {
        return try await fetchAllDatabaseEntries(databaseId: databaseId)
    }

    // MARK: - Notion Page → Module Mapping
    //
    // ONLY include modules whose Notion page IDs have been confirmed to exist.
    // Modules served from local Swift code go in localOnlyModuleIds below.
    // Planned modules with no Notion page yet go in plannedModuleIds below — they
    // are never fetched, so they cannot contribute to sync failures.
    //
    static let modulePages: [ModulePageConfig] = [
        ModulePageConfig(
            notionPageId: "aacca103-7532-441f-951f-b9f937c86fa1",
            moduleId: "mod_women",
            title: "Investing Primer",
            description: "Foundational investing concepts, behavioral patterns, and building your personal investment framework.",
            icon: "🌷",
            color: "rose",
            estimatedTime: 45,
            tags: ["Foundational", "Behavioral", "Investing"],
            displayOrder: 1,
            parentModuleId: nil,
            isBonus: false,
            heroImageName: "hero_women"
        ),
        ModulePageConfig(
            notionPageId: "abd003f2-9981-4f1b-992a-8ffab12e7765",
            moduleId: "mod_alt",
            title: "Alternative Investing",
            description: "Explore asset classes beyond stocks and bonds — real estate, private equity, art, and more.",
            icon: "🌍",
            color: "blue",
            estimatedTime: 40,
            tags: ["Alternative Assets", "Portfolio", "Diversification"],
            displayOrder: 2,
            parentModuleId: nil,
            isBonus: false,
            heroImageName: "hero_alt_assets"
        ),
        ModulePageConfig(
            notionPageId: "e6d4a5e9-da36-465b-a4d2-abf8c6591fc1",
            moduleId: "mod_behavioral",
            title: "Behavioral Economics",
            description: "Understand cognitive biases, heuristics, and the psychology behind financial decisions.",
            icon: "🧠",
            color: "purple",
            estimatedTime: 35,
            tags: ["Behavioral Economics", "Psychology", "Biases"],
            displayOrder: 3,
            parentModuleId: nil,
            isBonus: false,
            heroImageName: "hero_behavioral"
        ),
        ModulePageConfig(
            notionPageId: "06600c44-d2b4-4af8-b49b-06974f846f96",
            moduleId: "mod_gender",
            title: "Gender & Behavioral Investing",
            description: "Research on gender dynamics in investing, confidence gaps, and overcoming structural barriers.",
            icon: "⚖️",
            color: "pink",
            estimatedTime: 30,
            tags: ["Gender", "Behavioral", "Research"],
            displayOrder: 4,
            parentModuleId: nil,
            isBonus: false,
            heroImageName: "hero_gender"
        ),
        ModulePageConfig(
            notionPageId: "a6ca3780-97c5-4086-b865-592110b7f87a",
            moduleId: "mod_defi",
            title: "Decentralized Finance",
            description: "Introduction to blockchain, DeFi protocols, smart contracts, and the new financial infrastructure.",
            icon: "⛓️",
            color: "indigo",
            estimatedTime: 40,
            tags: ["DeFi", "Blockchain", "Crypto"],
            displayOrder: 5,
            parentModuleId: nil,
            isBonus: false,
            heroImageName: "hero_defi"
        ),
        ModulePageConfig(
            notionPageId: "7570e1ff-4be1-47d6-bc46-33c8e2b7c8b3",
            moduleId: "mod_art",
            title: "Art as an Alternative Asset",
            description: "How art markets work, valuation frameworks, and art's role in portfolio diversification.",
            icon: "🎨",
            color: "orange",
            estimatedTime: 35,
            tags: ["Art", "Alternative Assets", "Valuation"],
            displayOrder: 6,
            parentModuleId: nil,
            isBonus: false,
            heroImageName: "hero_art"
        ),
        ModulePageConfig(
            notionPageId: "f26db27e-981d-49bc-8509-0d8f5b40b33f",
            moduleId: "mod_kahlo_basquiat",
            title: "Kahlo × Basquiat: Art & Identity",
            description: "How Frida Kahlo and Jean-Michel Basquiat reshaped the art world and alternative asset markets.",
            icon: "🖼️",
            color: "red",
            estimatedTime: 25,
            tags: ["Art", "Case Study", "Culture"],
            displayOrder: 9,
            parentModuleId: "mod_art",
            isBonus: true,
            heroImageName: "hero_kahlo_basquiat"
        ),
        ModulePageConfig(
            notionPageId: "b14fbfdc-835a-43d0-b160-ce20d440d35d",
            moduleId: "mod_high_risk_defi",
            title: "High-Risk DeFi Strategies",
            description: "Advanced exploration of high-risk DeFi protocols, leverage, and risk assessment frameworks.",
            icon: "⚡",
            color: "yellow",
            estimatedTime: 30,
            tags: ["DeFi", "Advanced", "Risk"],
            displayOrder: 10,
            parentModuleId: "mod_defi",
            isBonus: true,
            heroImageName: nil
        ),
    ]

    // Modules served entirely from local Swift data — never fetched from Notion.
    // ESGClimateModuleData and DeFiInvestingModuleData contain the full content.
    // To migrate a module to Notion: add a real page ID to modulePages above and
    // remove it from this list.
    static let localOnlyModules: [Module] = [
        ESGClimateModuleData.esgClimateModule,
        DeFiInvestingModuleData.defiInvestingModule,
    ]

    // Planned modules — Notion pages not yet created.
    // Listed here so their IDs are reserved; they are never fetched.
    // To activate: create the Notion page, copy its real UUID into modulePages above.
    //   mod_wine          — Wine & Vineyard Investing
    //   mod_biodynamic    — Biodynamic Viticulture Deep Dive
    //   mod_esg_portfolio — Advanced Portfolio ESG Construction
    //   mod_esg_advisor   — Questions for Your Financial Advisor (ESG)
    //   mod_defi_advisor  — Evaluating Financial Advisor Crypto Knowledge

    // MARK: - Known Notion Database IDs
    static let footnotesDbId = "4307a4fa-7164-4aaf-89cb-29c2fb166f0b"
    static let termsDbId = "79153c22-f378-4ed8-86a1-99a0c5b964a9"
    static let defiCbdcDbId = "43a959e2-201e-4bea-b8fb-e2c6eb3cae92"
    static let brainTipsDbId = "7e1a82d3-1039-4c28-a7f3-0de0da06c0d4"

    init() {
        // Load from AppConfiguration (handles dev vs production mode)
        self._apiKey = AppConfiguration.notionAPIKey
        self.databaseId = AppConfiguration.notionDatabaseID

        // Load from local cache first (instant, works offline).
        // Reject cache if it has fewer modules than static data — indicates a partial/corrupted save.
        let staticModules = SampleDataLoader.loadSampleModules()
        if let cached = ModuleCache.load(), cached.count >= staticModules.count {
            self.modules = cached
            debugLog("✅ [Cache] Loaded \(cached.count) modules from local cache")
        } else {
            self.modules = staticModules
            debugLog("Loaded \(staticModules.count) modules from static data")
        }
    }

    // MARK: - Configuration
    func configure(apiKey: String, databaseId: String) {
        // Save securely (only matters in development mode)
        KeychainHelper.save(key: "notion_api_key", value: apiKey)
        UserDefaults.standard.set(databaseId, forKey: "notion_database_id")

        // Update instance variables so they're used immediately
        self._apiKey = apiKey
        self.databaseId = databaseId

        debugLog("Configured with API key: \(apiKey.prefix(10))... and database: \(databaseId)")
    }

    /// Configure the Further Reading database separately
    func configureFurtherReading(databaseId: String) {
        self.furtherReadingDatabaseId = databaseId
        UserDefaults.standard.set(databaseId, forKey: "notion_further_reading_db")
        debugLog("Configured Further Reading database: \(databaseId)")
    }

    // MARK: - Fetch Further Reading (Dynamic from Notion)
    /// Fetches reading resources from your Notion "Further Reading" database
    /// Create a database with: Title, URL, Category (select), Type (select), Author, Description, Module (relation)
    func fetchFurtherReading() async {
        guard !apiKey.isEmpty, !furtherReadingDatabaseId.isEmpty else {
            debugLog("Further Reading database not configured")
            return
        }

        do {
            guard let url = URL(string: "\(baseURL)/databases/\(furtherReadingDatabaseId)/query") else {
                throw NSError(domain: "Invalid URL", code: 0)
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            request.setValue("2022-06-28", forHTTPHeaderField: "Notion-Version")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let (data, _) = try await URLSession.shared.data(for: request)
            let response = try JSONDecoder().decode(NotionDatabaseResponse.self, from: data)

            var readings: [FurtherReading] = []

            for page in response.results {
                let props = page.properties

                guard let title = props["Title"]?.title?.first?.plainText ?? props["Name"]?.title?.first?.plainText else {
                    continue
                }

                let urlString = props["URL"]?.url ?? ""
                let category = props["Category"]?.select?.name ?? "General"
                let typeString = props["Type"]?.select?.name ?? "Article"
                let author = props["Author"]?.richText?.first?.plainText
                let description = props["Description"]?.richText?.first?.plainText
                let moduleId = props["Module"]?.relation?.first?.id

                let readingType: FurtherReading.ReadingType
                switch typeString.lowercased() {
                case "paper": readingType = .paper
                case "video": readingType = .video
                case "book": readingType = .book
                case "podcast": readingType = .podcast
                case "tool": readingType = .tool
                default: readingType = .article
                }

                let reading = FurtherReading(
                    id: page.id,
                    title: title,
                    url: urlString,
                    category: category,
                    type: readingType,
                    author: author,
                    description: description,
                    moduleId: moduleId
                )

                readings.append(reading)
            }

            await MainActor.run {
                self.furtherReadings = readings
                debugLog("Fetched \(readings.count) further reading items")
            }

        } catch {
            debugLog("Error fetching further reading: \(error.localizedDescription)")
        }
    }

    /// Get readings filtered by module
    func readings(for moduleId: String) -> [FurtherReading] {
        return furtherReadings.filter { $0.moduleId == moduleId }
    }

    /// Get readings by category
    func readings(category: String) -> [FurtherReading] {
        return furtherReadings.filter { $0.category == category }
    }

    /// Check if Notion is properly configured (only API key needed — page IDs are hardcoded)
    var isConfigured: Bool {
        return !apiKey.isEmpty
    }

    // MARK: - Fetch Modules (Page-Based)
    /// Fetches module content from Notion by retrieving each known page's blocks.
    /// Since modules are standalone workspace pages (not database rows), we iterate
    /// through `modulePages` and fetch blocks for each page individually.
    func fetchModules() async {
        debugLog("🔄 [NotionService] fetchModules() STARTING — API key present: \(!apiKey.isEmpty), modules count: \(modules.count)")
        guard !apiKey.isEmpty else {
            debugLog("⚠️ [NotionService] No API key — using sample data only")
            debugLog("Notion API key not configured - using sample data")
            await MainActor.run {
                self.error = "Notion API key not configured"
                if self.modules.isEmpty && AppConfiguration.useSampleDataFallback {
                    self.modules = SampleDataLoader.loadSampleModules()
                }
            }
            return
        }

        debugLog("Fetching modules from Notion (page-based)...")
        debugLog("API Key: \(apiKey.prefix(15))...")
        debugLog("Fetching \(Self.modulePages.count) module pages...")

        await MainActor.run { self.isLoading = true }

        var loadedModules: [Module] = []
        var failedCount = 0

        // Fetch each module page's content sequentially — safe because NotionService is a
        // non-Sendable ObservableObject; concurrent task groups would race on shared state.
        for config in Self.modulePages {
            do {
                let blocks = try await fetchPageBlocks(pageId: config.notionPageId)
                debugLog("Fetched \(blocks.count) blocks for \(config.title)")

                let childDBs = await prefetchChildDatabases(from: blocks)
                let sections = parseSections(from: blocks, childDatabases: childDBs)
                let caseStudies = extractCaseStudies(from: sections, moduleTitle: config.title)
                let reflectionPrompts = generateReflectionPrompts(from: sections, moduleTitle: config.title)
                let quizzes = generateQuizzes(from: sections, moduleId: config.moduleId)

                var module = Module(
                    id: config.moduleId,
                    title: config.title,
                    description: config.description,
                    icon: config.icon,
                    color: config.color,
                    sections: sections,
                    reflectionPrompts: reflectionPrompts,
                    quizzes: quizzes,
                    caseStudies: caseStudies,
                    estimatedTime: config.estimatedTime,
                    tags: config.tags,
                    parentModuleId: config.parentModuleId,
                    isBonus: config.isBonus
                )
                module.heroImageName = config.heroImageName

                loadedModules.append(module)
                debugLog("✅ Parsed module: \(config.title) (\(sections.count) sections)")

            } catch {
                failedCount += 1
                let msg = "❌ \(config.moduleId): \(error.localizedDescription)"
                debugLog(msg)
                await MainActor.run { self.error = msg }
            }
        }

        // Module fetch summary (always printed for diagnostics)
        debugLog("📋 [NotionService] Module fetch summary: \(loadedModules.count) succeeded, \(failedCount) failed")
        for module in loadedModules {
            let imageCount = module.sections.flatMap { $0.content }.filter {
                if case .image = $0 { return true }; return false
            }.count
            let extras = imageCount > 0 ? " (\(imageCount) images)" : ""
            debugLog("   ✅ \(module.id): \(module.sections.count) sections\(extras)")
        }

        // Sort by display order
        loadedModules.sort { lhs, rhs in
            let lhsOrder = Self.modulePages.first(where: { $0.moduleId == lhs.id })?.displayOrder ?? 99
            let rhsOrder = Self.modulePages.first(where: { $0.moduleId == rhs.id })?.displayOrder ?? 99
            return lhsOrder < rhsOrder
        }

        await MainActor.run {
            if loadedModules.isEmpty && AppConfiguration.useSampleDataFallback {
                debugLog("No modules from Notion — keeping sample data")
            } else if !loadedModules.isEmpty {
                // Carry over heroImageName and locally-assigned quizzes/reflections
                // from existing modules so thumbnails and enriched data persist
                for i in 0..<loadedModules.count {
                    if let existing = self.modules.first(where: { $0.id == loadedModules[i].id }) {
                        if loadedModules[i].heroImageName == nil {
                            loadedModules[i].heroImageName = existing.heroImageName
                        }
                        // Preserve sample-data quizzes/reflections if Notion didn't provide any
                        if loadedModules[i].quizzes.isEmpty && !existing.quizzes.isEmpty {
                            loadedModules[i].quizzes = existing.quizzes
                            debugLog("   📝 \(loadedModules[i].id): preserved \(existing.quizzes.count) quizzes from sample data")
                        }
                        if loadedModules[i].reflectionPrompts.isEmpty && !existing.reflectionPrompts.isEmpty {
                            loadedModules[i].reflectionPrompts = existing.reflectionPrompts
                            debugLog("   💭 \(loadedModules[i].id): preserved \(existing.reflectionPrompts.count) reflections from sample data")
                        }
                        if loadedModules[i].caseStudies.isEmpty && !existing.caseStudies.isEmpty {
                            loadedModules[i].caseStudies = existing.caseStudies
                        }
                        // Warn if Notion content is significantly less than sample data
                        if loadedModules[i].sections.count < existing.sections.count / 2 && existing.sections.count > 5 {
                            debugLog("⚠️ \(loadedModules[i].id): Notion has \(loadedModules[i].sections.count) sections vs sample \(existing.sections.count)")
                        }
                    }
                }
                // Always append local-only modules (defined in Swift, never fetched from Notion)
                let notionIds = Set(loadedModules.map { $0.id })
                let localModules = Self.localOnlyModules.filter { !notionIds.contains($0.id) }
                loadedModules.append(contentsOf: localModules)

                // Apply enrichment data (quizzes, reflection prompts, case studies)
                for i in 0..<loadedModules.count {
                    let prompts = NotionReflectionPrompts.prompts(for: loadedModules[i].id)
                    if !prompts.isEmpty { loadedModules[i].reflectionPrompts = prompts }
                    let quizzes = NotionQuizData.quizzes(for: loadedModules[i].id)
                    if !quizzes.isEmpty { loadedModules[i].quizzes = quizzes }
                    let cases = NotionCaseStudies.caseStudies(for: loadedModules[i].id)
                    if !cases.isEmpty { loadedModules[i].caseStudies = cases }
                }

                // Sort by canonical display order
                let displayOrder = [
                    "mod_women", "mod_alt", "mod_behavioral", "mod_gender",
                    "mod_defi", "mod_art", "mod_esg_climate", "mod_defi_investing",
                    "mod_kahlo_basquiat", "mod_high_risk_defi"
                ]
                loadedModules.sort {
                    let a = displayOrder.firstIndex(of: $0.id) ?? displayOrder.count
                    let b = displayOrder.firstIndex(of: $1.id) ?? displayOrder.count
                    return a < b
                }

                self.modules = loadedModules
                debugLog("✅ [NotionService] Sync complete — \(loadedModules.count) modules (\(localModules.count) local, \(failedCount) Notion failures)")
                debugLog("Loaded \(loadedModules.count) modules from Notion (\(failedCount) failed)")
                // Persist to local cache so next launch is instant even if Notion is unreachable
                // Only cache when all Notion modules succeeded — partial sets corrupt the cache
                // and cause previously-working modules to vanish on the next cold launch.
                if failedCount == 0 { ModuleCache.save(loadedModules) }
            }
            self.isLoading = false
            self.error = failedCount > 0 ? "\(failedCount) module(s) failed to sync" : nil
            self.lastSyncDate = Date()
        }
    }

    /// Fetch a single module by its app module ID (e.g., "mod_alt").
    /// Useful for refreshing one module without reloading everything.
    func fetchSingleModule(moduleId: String) async -> Module? {
        guard !apiKey.isEmpty else { return nil }
        guard let config = Self.modulePages.first(where: { $0.moduleId == moduleId }) else {
            debugLog("No page config found for module: \(moduleId)")
            return nil
        }

        do {
            let blocks = try await fetchPageBlocks(pageId: config.notionPageId)
            let childDBs = await prefetchChildDatabases(from: blocks)
            let sections = parseSections(from: blocks, childDatabases: childDBs)
            let caseStudies = extractCaseStudies(from: sections, moduleTitle: config.title)
            let reflectionPrompts = generateReflectionPrompts(from: sections, moduleTitle: config.title)
            let quizzes = generateQuizzes(from: sections, moduleId: config.moduleId)

            return Module(
                id: config.moduleId,
                title: config.title,
                description: config.description,
                icon: config.icon,
                color: config.color,
                sections: sections,
                reflectionPrompts: reflectionPrompts,
                quizzes: quizzes,
                caseStudies: caseStudies,
                estimatedTime: config.estimatedTime,
                tags: config.tags,
                parentModuleId: config.parentModuleId,
                isBonus: config.isBonus
            )
        } catch {
            debugLog("Failed to fetch module \(moduleId): \(error.localizedDescription)")
            return nil
        }
    }

    // MARK: - Legacy Database Fetch (kept for future use)
    /// Original database-based fetch — use if modules are ever migrated to a Notion database.
    func fetchModulesFromDatabase() async {
        guard !apiKey.isEmpty, !databaseId.isEmpty else { return }

        do {
            let pages = try await fetchDatabasePages()
            var loadedModules: [Module] = []
            for page in pages {
                if let module = try await parseModule(from: page) {
                    loadedModules.append(module)
                }
            }
            await MainActor.run {
                if !loadedModules.isEmpty {
                    self.modules = loadedModules.sorted { $0.title < $1.title }
                }
                self.lastSyncDate = Date()
            }
        } catch {
            debugLog("Database fetch error: \(error.localizedDescription)")
        }
    }

    // MARK: - Fetch Notion Databases (Terms, Footnotes)

    /// Fetches glossary terms from the "Terms to Know" Notion database.
    /// Database schema: Name (title), Info (rich_text), Status (select — e.g., "Public v. Private")
    func fetchTermsFromNotion() async -> [(term: String, definition: String, category: String)] {
        guard !apiKey.isEmpty else { return [] }

        do {
            let entries = try await fetchAllDatabaseEntries(databaseId: Self.termsDbId)
            var terms: [(term: String, definition: String, category: String)] = []

            for page in entries {
                let props = page.properties
                guard let termName = props["Name"]?.title?.first?.plainText else { continue }

                let definition = props["Info"]?.richText?.map { $0.plainText }.joined() ?? ""
                let category = props["Status"]?.select?.name ?? "General"

                terms.append((term: termName, definition: definition, category: category))
            }

            debugLog("Fetched \(terms.count) terms from Notion")
            return terms
        } catch {
            debugLog("Error fetching terms: \(error.localizedDescription)")
            return []
        }
    }

    /// Fetches footnotes/citations from the Footnotes database.
    /// Database schema: Source Article (title), FootNote (number), Module (multi_select),
    ///                  Author (rich_text), From (rich_text), Date (rich_text), URL (url)
    /// Returns footnotes grouped by module name.
    func fetchFootnotesFromNotion() async -> [String: [(number: Int, sourceArticle: String, author: String, from: String, date: String, url: String)]] {
        guard !apiKey.isEmpty else { return [:] }

        do {
            let entries = try await fetchAllDatabaseEntries(databaseId: Self.footnotesDbId)
            var footnotesByModule: [String: [(number: Int, sourceArticle: String, author: String, from: String, date: String, url: String)]] = [:]

            for page in entries {
                let props = page.properties
                let sourceArticle = props["Source Article"]?.title?.first?.plainText ?? ""
                let author = props["Author"]?.richText?.map { $0.plainText }.joined() ?? ""
                let from = props["From"]?.richText?.map { $0.plainText }.joined() ?? ""
                let date = props["Date"]?.richText?.map { $0.plainText }.joined() ?? ""
                let url = props["URL"]?.url ?? ""
                let number = Int(props["FootNote"]?.number ?? 0)

                // Module is multi_select — a footnote can belong to multiple modules
                let modules = props["Module"]?.multiSelect?.map { $0.name } ?? ["general"]

                if !sourceArticle.isEmpty {
                    for moduleName in modules {
                        footnotesByModule[moduleName, default: []].append(
                            (number: number, sourceArticle: sourceArticle, author: author,
                             from: from, date: date, url: url)
                        )
                    }
                }
            }

            // Sort each module's footnotes by number
            for key in footnotesByModule.keys {
                footnotesByModule[key]?.sort { $0.number < $1.number }
            }

            debugLog("Fetched footnotes for \(footnotesByModule.count) modules from Notion")
            return footnotesByModule
        } catch {
            debugLog("Error fetching footnotes: \(error.localizedDescription)")
            return [:]
        }
    }

    /// Fetches DeFi vs. CBDC comparison data from the inline Notion database.
    /// Returns comparison items grouped by category, suitable for ComparisonItem display.
    func fetchDeFiCBDCComparison() async -> [ComparisonItem] {
        guard !apiKey.isEmpty else { return [] }

        do {
            let entries = try await fetchAllDatabaseEntries(databaseId: Self.defiCbdcDbId)
            var categorized: [String: (defi: String, cbdc: String)] = [:]

            for page in entries {
                let props = page.properties
                let name = props["Name"]?.title?.first?.plainText ?? ""
                let status = props["Status"]?.select?.name ?? ""
                let info = props["Info"]?.richText?.map { $0.plainText }.joined() ?? ""

                guard !name.isEmpty, !info.isEmpty else { continue }

                if status == "DeFi" {
                    categorized[name, default: (defi: "", cbdc: "")].defi = info
                } else if status == "CBDC" {
                    categorized[name, default: (defi: "", cbdc: "")].cbdc = info
                }
            }

            let items = categorized.map { category, pair in
                ComparisonItem(label: category, values: [pair.defi, pair.cbdc])
            }.sorted { $0.label < $1.label }

            debugLog("Fetched \(items.count) DeFi vs. CBDC comparison categories from Notion")
            return items
        } catch {
            debugLog("Error fetching DeFi vs. CBDC data: \(error.localizedDescription)")
            return []
        }
    }

    /// Fetches the "Brain Tips and Tricks" database entries for the Behavioral Economics module.
    /// Returns toggle blocks grouped by status (Dopamine, Serotonin, Brain Plasticity).
    func fetchBrainTipsAndTricks() async -> [ContentBlock] {
        guard !apiKey.isEmpty else { return [] }

        do {
            let entries = try await fetchAllDatabaseEntries(databaseId: Self.brainTipsDbId)
            var grouped: [String: [(name: String, info: String)]] = [:]

            for page in entries {
                let props = page.properties
                let name = props["Name"]?.title?.first?.plainText ?? ""
                let status = props["Status"]?.select?.name ?? ""
                let info = props["Info"]?.richText?.map { $0.plainText }.joined() ?? ""

                guard !name.isEmpty else { continue }
                grouped[status, default: []].append((name: name, info: info))
            }

            // Convert to toggle blocks grouped by category
            var blocks: [ContentBlock] = []
            blocks.append(.heading("Brain Tips and Tricks", level: 3))
            for (category, items) in grouped.sorted(by: { $0.key < $1.key }) {
                let content = items.map { item in
                    item.info.isEmpty ? item.name : "\(item.name): \(item.info)"
                }.joined(separator: "\n")
                blocks.append(.toggleBlock(title: category, content: content))
            }

            debugLog("   🧠 Fetched \(entries.count) Brain Tips entries across \(grouped.count) categories")
            return blocks
        } catch {
            debugLog("⚠️ Error fetching Brain Tips database: \(error.localizedDescription)")
            return []
        }
    }

    /// Enriches loaded modules with targeted Notion database content.
    /// Only injects database data when it wasn't already picked up inline by the page fetch.
    /// This acts as a safety net for sample-data fallback scenarios.
    /// When the page fetch works, databases are already rendered inline as .database blocks.
    func enrichModulesWithDatabases() async {
        guard !apiKey.isEmpty else { return }

        // Check if any modules have .database blocks (from successful page fetch)
        let hasInlineDatabases: Bool = await MainActor.run {
            self.modules.contains { module in
                module.sections.contains { section in
                    section.content.contains { block in
                        if case .database = block { return true }
                        return false
                    }
                }
            }
        }

        if hasInlineDatabases {
            debugLog("Database cards already present from inline page fetch — no enrichment needed")
        }

        // Additional databases can be added here following the same pattern:
        //    - Only fetch separately if missing (sample data fallback)

        debugLog("✅ [NotionService] Database enrichment complete")
    }

    /// Generic paginated fetch for all entries in a Notion database.
    private func fetchAllDatabaseEntries(databaseId: String) async throws -> [NotionPage] {
        var allPages: [NotionPage] = []
        var cursor: String? = nil

        repeat {
            guard let url = URL(string: "\(baseURL)/databases/\(databaseId)/query") else {
                throw NSError(domain: "Invalid URL", code: 0)
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            request.setValue("2022-06-28", forHTTPHeaderField: "Notion-Version")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            if let cursor = cursor {
                let body = ["start_cursor": cursor]
                request.httpBody = try JSONSerialization.data(withJSONObject: body)
            }

            let (data, httpResponse) = try await URLSession.shared.data(for: request)

            // Check for API errors (permissions, not found, etc.)
            if let statusCode = (httpResponse as? HTTPURLResponse)?.statusCode, statusCode >= 400 {
                let errorBody = String(data: data, encoding: .utf8) ?? "Unknown error"
                debugLog("⚠️ Database query failed (\(statusCode)) for \(databaseId): \(errorBody)")
                throw NSError(domain: "NotionAPI", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Notion API \(statusCode): \(errorBody.prefix(200))"])
            }

            // Decode with pagination support
            struct PaginatedDB: Codable {
                let results: [NotionPage]
                let hasMore: Bool
                let nextCursor: String?
                enum CodingKeys: String, CodingKey {
                    case results
                    case hasMore = "has_more"
                    case nextCursor = "next_cursor"
                }
            }

            let response = try JSONDecoder().decode(PaginatedDB.self, from: data)
            allPages.append(contentsOf: response.results)
            cursor = response.hasMore ? response.nextCursor : nil

        } while cursor != nil

        return allPages
    }

    // MARK: - Parse Notion Content
    private func parseModule(from page: NotionPage) async throws -> Module? {
        let pageId = page.id
        let properties = page.properties
        
        // Extract basic properties
        guard let title = properties["Name"]?.title?.first?.plainText ?? properties["Title"]?.title?.first?.plainText else {
            return nil
        }

        let description = properties["Description"]?.richText?.first?.plainText ?? ""
        let icon = properties["Icon"]?.richText?.first?.plainText ?? "📚"
        let color = properties["Color"]?.select?.name ?? "blue"
        let tags = properties["Tags"]?.multiSelect?.map { $0.name } ?? []
        let estimatedTime = properties["Estimated Time"]?.number ?? 30
        
        // Fetch page blocks (content)
        let blocks = try await fetchPageBlocks(pageId: pageId)
        let childDBs = await prefetchChildDatabases(from: blocks)
        let sections = parseSections(from: blocks, childDatabases: childDBs)
        
        // Extract case studies from content
        let caseStudies = extractCaseStudies(from: sections, moduleTitle: title)
        
        // Generate reflection prompts from content
        let reflectionPrompts = generateReflectionPrompts(from: sections, moduleTitle: title)
        
        // Generate quizzes from content
        let quizzes = generateQuizzes(from: sections, moduleId: pageId)
        
        return Module(
            id: pageId,
            title: title,
            description: description,
            icon: icon,
            color: color,
            sections: sections,
            reflectionPrompts: reflectionPrompts,
            quizzes: quizzes,
            caseStudies: caseStudies,
            estimatedTime: Int(estimatedTime),
            tags: tags
        )
    }
    
    // MARK: - Extract Case Studies
    private func extractCaseStudies(from sections: [Section], moduleTitle: String) -> [CaseStudy] {
        var caseStudies: [CaseStudy] = []
        
        for section in sections {
            for content in section.content {
                if case .callout(let calloutTitle, let calloutContent, let type) = content {
                    // Examples and Research callouts become case studies
                    if (type == .example || type == .research) && calloutContent.count > 150 {
                        
                        // Determine learning focus based on section title and content
                        var learningFocus: [String] = []
                        let combinedText = (section.title + " " + calloutContent).lowercased()
                        
                        if combinedText.contains("bias") {
                            learningFocus.append("Bias Identification")
                        }
                        if combinedText.contains("pattern") || combinedText.contains("behavior") {
                            learningFocus.append("Pattern Recognition")
                        }
                        if combinedText.contains("decision") {
                            learningFocus.append("Decision Analysis")
                        }
                        if combinedText.contains("question") {
                            learningFocus.append("Critical Thinking")
                        }
                        if combinedText.contains("valuation") || combinedText.contains("price") {
                            learningFocus.append("Valuation Methods")
                        }
                        if combinedText.contains("gender") || combinedText.contains("diversity") {
                            learningFocus.append("Social Dynamics")
                        }
                        
                        if learningFocus.isEmpty {
                            learningFocus = ["Critical Analysis", "Conceptual Understanding"]
                        }
                        
                        // Generate key questions based on content
                        var keyQuestions: [String] = []
                        
                        if section.title.lowercased().contains("bias") {
                            keyQuestions.append("What cognitive biases can you identify in this scenario?")
                            keyQuestions.append("How might these biases affect the decision-making process?")
                        } else if section.title.lowercased().contains("gender") {
                            keyQuestions.append("What structural or behavioral factors are at play?")
                            keyQuestions.append("How might societal messaging influence these patterns?")
                        } else if section.title.lowercased().contains("art") || section.title.lowercased().contains("alternative") {
                            keyQuestions.append("What factors influence valuation in this context?")
                            keyQuestions.append("How does this compare to traditional asset classes?")
                        } else {
                            keyQuestions.append("What patterns or principles can you identify?")
                            keyQuestions.append("How would you approach this situation?")
                        }
                        
                        keyQuestions.append("What questions would you want to ask before proceeding?")
                        
                        let caseStudy = CaseStudy(
                            id: "case_\(section.id)_\(calloutTitle.hashValue)",
                            title: calloutTitle.isEmpty ? "\(section.title) Example" : calloutTitle,
                            scenario: calloutContent,
                            context: "Educational example from academically-vetted research",
                            keyQuestions: keyQuestions,
                            learningFocus: learningFocus,
                            relatedSection: section.id,
                            source: "From: \(section.title) in \(moduleTitle)"
                        )
                        
                        caseStudies.append(caseStudy)
                    }
                }
            }
        }
        
        return caseStudies
    }
    
    // MARK: - Generate Educational Content
    private func generateReflectionPrompts(from sections: [Section], moduleTitle: String) -> [ReflectionPrompt] {
        var prompts: [ReflectionPrompt] = []
        
        for section in sections {
            // Look for sections with bias, theory, gap, or behavioral concepts
            let title = section.title.lowercased()
            
            if title.contains("bias") {
                prompts.append(ReflectionPrompt(
                    id: "reflection_\(section.id)_bias",
                    question: "Describe a time when you encountered \(section.title.lowercased()) in your own decision-making or observed it in others.",
                    context: "From: \(section.title) in \(moduleTitle)",
                    relatedSections: [section.id]
                ))
            }
            
            if title.contains("gap") || title.contains("disparity") {
                prompts.append(ReflectionPrompt(
                    id: "reflection_\(section.id)_gap",
                    question: "How might the patterns discussed in \(section.title) affect professional environments or investment decisions you've witnessed?",
                    context: "From: \(section.title) in \(moduleTitle)",
                    relatedSections: [section.id]
                ))
            }
            
            if title.contains("behavior") || title.contains("psychology") {
                prompts.append(ReflectionPrompt(
                    id: "reflection_\(section.id)_behavior",
                    question: "Consider your own financial or investment decisions - which behavioral patterns from \(section.title) resonate with your experience?",
                    context: "From: \(section.title) in \(moduleTitle)",
                    relatedSections: [section.id]
                ))
            }
            
            if title.contains("art") || title.contains("alternative") {
                prompts.append(ReflectionPrompt(
                    id: "reflection_\(section.id)_alternative",
                    question: "What assumptions did you hold about \(section.title.lowercased()) before reading this section? How has your perspective shifted?",
                    context: "From: \(section.title) in \(moduleTitle)",
                    relatedSections: [section.id]
                ))
            }
            
            // Extract case studies from callouts and examples
            for content in section.content {
                if case .callout(let calloutTitle, let calloutContent, let type) = content {
                    if type == .example || type == .research {
                        // This is educational case study material
                        if calloutContent.count > 100 {
                            prompts.append(ReflectionPrompt(
                                id: "reflection_\(section.id)_case_\(calloutTitle.hashValue)",
                                question: "In the example about '\(calloutTitle.isEmpty ? "this scenario" : calloutTitle)', what patterns or biases can you identify? How would you approach this situation?",
                                context: "Case study from: \(section.title)",
                                relatedSections: [section.id]
                            ))
                        }
                    }
                }
            }
        }
        
        // Add general module reflection
        prompts.append(ReflectionPrompt(
            id: "reflection_module_\(moduleTitle.hashValue)",
            question: "After completing \(moduleTitle), what are three key insights you've gained? How might you apply them?",
            context: "Module reflection",
            relatedSections: sections.map { $0.id }
        ))
        
        return Array(prompts.prefix(8)) // Limit to 8 most relevant prompts
    }
    
    private func generateQuizzes(from sections: [Section], moduleId: String) -> [Quiz] {
        var allQuestions: [QuizQuestion] = []
        
        for section in sections {
            // Generate conceptual questions based on content
            let title = section.title.lowercased()
            
            if title.contains("anchoring") {
                allQuestions.append(QuizQuestion(
                    id: "quiz_\(section.id)_1",
                    question: "What is anchoring bias?",
                    options: [
                        "Over-relying on the first piece of information encountered",
                        "Making decisions based on emotions",
                        "Following the crowd's investment choices",
                        "Avoiding risk at all costs"
                    ],
                    correctAnswerIndex: 0,
                    explanation: "Anchoring bias occurs when we give disproportionate weight to the first piece of information we receive, which then 'anchors' our subsequent judgments. This is particularly relevant in valuation and pricing decisions.",
                    difficulty: .beginner,
                    relatedConcepts: ["anchoring bias", "cognitive bias"]
                ))
            }
            
            if title.contains("gender") && title.contains("gap") {
                allQuestions.append(QuizQuestion(
                    id: "quiz_\(section.id)_2",
                    question: "Which factor contributes to the gender investment gap?",
                    options: [
                        "Women are naturally more risk-averse than men",
                        "Societal messaging, confidence gaps, and structural barriers",
                        "Women prefer savings accounts over investments",
                        "Women earn too little to invest"
                    ],
                    correctAnswerIndex: 1,
                    explanation: "Research shows the gender investment gap stems from complex factors including societal messaging about women and finance, confidence gaps created by these messages, and structural barriers in the financial industry - not inherent risk aversion.",
                    difficulty: .intermediate,
                    relatedConcepts: ["gender gap", "behavioral economics", "structural barriers"]
                ))
            }
            
            if title.contains("alternative") || title.contains("art") {
                allQuestions.append(QuizQuestion(
                    id: "quiz_\(section.id)_3",
                    question: "What distinguishes alternative investments from traditional investments?",
                    options: [
                        "They are always more profitable",
                        "They include assets beyond stocks, bonds, and cash",
                        "They require less research and due diligence",
                        "They are only available to institutional investors"
                    ],
                    correctAnswerIndex: 1,
                    explanation: "Alternative investments are defined as asset classes outside the traditional categories of stocks, bonds, and cash. They include real estate, private equity, art, commodities, and more - each requiring thorough research and understanding.",
                    difficulty: .beginner,
                    relatedConcepts: ["alternative assets", "portfolio diversification"]
                ))
            }
            
            if title.contains("behavioral") {
                allQuestions.append(QuizQuestion(
                    id: "quiz_\(section.id)_4",
                    question: "Why is understanding behavioral economics important for investing?",
                    options: [
                        "It helps predict exact market movements",
                        "It eliminates all investment risk",
                        "It helps identify patterns in decision-making that may affect financial choices",
                        "It guarantees better investment returns"
                    ],
                    correctAnswerIndex: 2,
                    explanation: "Behavioral economics helps us recognize psychological patterns and biases that influence financial decisions. While it doesn't eliminate risk or predict markets, it provides valuable insight into decision-making processes.",
                    difficulty: .intermediate,
                    relatedConcepts: ["behavioral economics", "decision-making", "cognitive bias"]
                ))
            }
        }
        
        // Create quiz from questions if we have enough
        if allQuestions.count >= 3 {
            return [Quiz(
                id: "quiz_\(moduleId)",
                title: "Knowledge Check",
                description: "Test your understanding of key concepts from this module",
                questions: Array(allQuestions.prefix(5)),
                passingScore: 0.6
            )]
        }
        
        return []
    }
    
    // MARK: - Pre-fetch Child Databases
    /// Scans blocks for child_database types and fetches their entries.
    /// Returns a dictionary mapping database ID -> array of parsed entries.
    private func prefetchChildDatabases(from blocks: [NotionBlock]) async -> [String: [[String: String]]] {
        var result: [String: [[String: String]]] = [:]

        // Recursively collect all child_database blocks from the full block tree
        func collectChildDBBlocks(_ blocks: [NotionBlock]) -> [NotionBlock] {
            var found: [NotionBlock] = []
            for block in blocks {
                if block.type == "child_database" {
                    found.append(block)
                }
                if let children = block.children {
                    found.append(contentsOf: collectChildDBBlocks(children))
                }
            }
            return found
        }

        let childDBBlocks = collectChildDBBlocks(blocks)
        if !childDBBlocks.isEmpty {
            debugLog("📊 Found \(childDBBlocks.count) child database(s) to prefetch")
        }

        for block in childDBBlocks {
            let dbId = block.id
            let dbTitle = block.childDatabase?.title ?? dbId
            debugLog("📊 Prefetching child DB: \"\(dbTitle)\" (id: \(dbId))")
            do {
                let pages = try await fetchAllDatabaseEntries(databaseId: dbId)
                debugLog("📊 Got \(pages.count) pages from \"\(dbTitle)\"")
                var entries: [[String: String]] = []

                for page in pages {
                    var entry: [String: String] = [:]
                    for (key, prop) in page.properties {
                        if let titleParts = prop.title, !titleParts.isEmpty {
                            entry["_title"] = titleParts.map { $0.plainText }.joined()
                            entry[key] = entry["_title"]
                        } else if let rtParts = prop.richText, !rtParts.isEmpty {
                            entry[key] = rtParts.map { $0.plainText }.joined()
                        } else if let sel = prop.select {
                            entry[key] = sel.name
                        } else if let multiSel = prop.multiSelect, !multiSel.isEmpty {
                            entry[key] = multiSel.map { $0.name }.joined(separator: ", ")
                        } else if let num = prop.number {
                            entry[key] = String(format: "%.0f", num)
                        } else if let url = prop.url {
                            entry[key] = url
                        } else if let checkbox = prop.checkbox {
                            entry[key] = checkbox ? "✓" : "✗"
                        } else if let date = prop.date {
                            entry[key] = date.start ?? ""
                        }
                    }
                    if !entry.isEmpty {
                        entries.append(entry)
                    }
                }
                if entries.isEmpty, let fallback = HardcodedDatabases.entries(forDatabaseId: dbId) {
                    debugLog("📊 Live fetch returned 0 entries for \"\(dbTitle)\" — using hardcoded fallback (\(fallback.count) entries)")
                    result[dbId] = fallback
                } else {
                    result[dbId] = entries
                    debugLog("📊 Prefetched DB \"\(dbTitle)\": \(entries.count) entries with keys: \(entries.first?.keys.sorted().joined(separator: ", ") ?? "none")")
                }
            } catch {
                // Always print child database errors to console (critical for debugging)
                debugLog("⚠️ [NotionService] Failed to prefetch child DB \"\(dbTitle)\" (\(dbId)): \(error.localizedDescription)")
                // Use hardcoded fallback if available, otherwise store error sentinel
                if let fallback = HardcodedDatabases.entries(forDatabaseId: dbId) {
                    debugLog("📊 Using hardcoded fallback for \"\(dbTitle)\" (\(fallback.count) entries)")
                    result[dbId] = fallback
                } else {
                    result[dbId] = [["_error": error.localizedDescription, "_title": dbTitle]]
                }
            }
        }

        return result
    }

    /// Returns true for short Notion in-page navigation lines containing pointing emoji.
    /// These are internal Notion links/anchors and should not render as app content.
    /// Detects sequences of orphaned percentage-only text blocks followed by their label texts
    /// (a common Notion formatting pattern for survey statistics) and converts them into
    /// grouped `.statistic()` blocks for proper chart-style rendering.
    ///
    /// Example: ["41%", "59%", "60%", "34%", "Label A", "Label B", "Label C", "Label D"]
    /// becomes four `.statistic(value:label:context:)` blocks.
    private func groupOrphanedStatistics(_ blocks: [ContentBlock]) -> [ContentBlock] {
        var result: [ContentBlock] = []
        var i = 0

        while i < blocks.count {
            // Look for a run of pure-percentage text blocks
            guard case .text(let candidateText) = blocks[i] else {
                result.append(blocks[i])
                i += 1
                continue
            }

            let trimmed = candidateText.trimmingCharacters(in: .whitespacesAndNewlines)
            let percentRegex = try? NSRegularExpression(pattern: #"^\d{1,3}%$"#)
            let isPercent = percentRegex?.firstMatch(
                in: trimmed, range: NSRange(trimmed.startIndex..., in: trimmed)) != nil

            guard isPercent else {
                result.append(blocks[i])
                i += 1
                continue
            }

            // Collect the run of consecutive percent blocks
            var percentages: [String] = [trimmed]
            var j = i + 1
            while j < blocks.count {
                if case .text(let t) = blocks[j] {
                    let t2 = t.trimmingCharacters(in: .whitespacesAndNewlines)
                    let isP = percentRegex?.firstMatch(
                        in: t2, range: NSRange(t2.startIndex..., in: t2)) != nil
                    if isP { percentages.append(t2); j += 1; continue }
                }
                break
            }

            // Need at least 2 percentages to trigger grouping
            guard percentages.count >= 2 else {
                result.append(blocks[i])
                i += 1
                continue
            }

            // Collect the same number of following label blocks
            var labels: [String] = []
            var k = j
            while k < blocks.count && labels.count < percentages.count {
                if case .text(let labelText) = blocks[k] {
                    let lt = labelText.trimmingCharacters(in: .whitespacesAndNewlines)
                    // Skip emoji-only lines and dividers
                    if !lt.isEmpty && lt.count > 3 {
                        labels.append(lt)
                        k += 1
                        continue
                    }
                }
                break
            }

            // If we matched at least half the labels, emit statistics
            if labels.count >= percentages.count / 2 {
                for idx in 0..<percentages.count {
                    let label = idx < labels.count ? labels[idx] : ""
                    result.append(.statistic(value: percentages[idx], label: label, context: nil))
                }
                i = k  // Advance past both percent and label blocks
            } else {
                // No good match — emit the percentage as plain text and move on
                result.append(blocks[i])
                i += 1
            }
        }

        return result
    }

    private func isNotionNavBlock(_ text: String) -> Bool {
        guard text.count < 120 else { return false }
        let navEmoji = ["👉", "→", "👆", "⬇️", "☞", "➡️", "👇", "☛"]
        return navEmoji.contains { text.contains($0) }
    }

    /// Convenience overload that parses without pre-fetched databases (for backward compat)
    private func parseSections(from blocks: [NotionBlock]) -> [Section] {
        return parseSections(from: blocks, childDatabases: [:])
    }

    private func parseSections(from blocks: [NotionBlock], childDatabases: [String: [[String: String]]]) -> [Section] {
        var sections: [Section] = []
        var currentSection: Section?
        var currentContent: [ContentBlock] = []
        var consecutiveBullets: [String] = []
        var consecutiveNumbers: [String] = []
        
        func flushLists() {
            if !consecutiveBullets.isEmpty {
                currentContent.append(.bulletList(consecutiveBullets))
                consecutiveBullets = []
            }
            if !consecutiveNumbers.isEmpty {
                currentContent.append(.numberedList(consecutiveNumbers))
                consecutiveNumbers = []
            }
        }
        
        for (index, block) in blocks.enumerated() {
            switch block.type {
            case "heading_2", "heading_3":
                // Flush any pending lists
                flushLists()

                let level = block.type == "heading_2" ? 2 : 3
                let headingText = block.heading?.richText.map { $0.plainText }.joined() ?? ""
                let trimmed = headingText.trimmingCharacters(in: .whitespaces)

                // Detect quotes disguised as headings (text in quotation marks)
                let isQuoteAsHeading = (trimmed.hasPrefix("\u{201C}") || trimmed.hasPrefix("\"")) &&
                    (trimmed.contains("\u{201D}") || trimmed.hasSuffix("\"") ||
                     trimmed.contains("_") || trimmed.contains("—"))

                if isQuoteAsHeading {
                    // Parse as a styled quote instead of a section header
                    // Try to extract author after _ or — or closing quote
                    var quoteText = trimmed
                    var author: String? = nil

                    // Check for "quote text" _ Author or "quote text" — Author
                    for separator in ["_ ", " _", "\u{2014} ", " \u{2014}", "— ", " —"] {
                        if let range = quoteText.range(of: separator, options: .backwards) {
                            let possibleAuthor = String(quoteText[range.upperBound...]).trimmingCharacters(in: .whitespaces)
                            if !possibleAuthor.isEmpty && possibleAuthor.count < 80 {
                                author = possibleAuthor
                                quoteText = String(quoteText[..<range.lowerBound])
                                break
                            }
                        }
                    }

                    // Clean up quote marks
                    quoteText = quoteText
                        .trimmingCharacters(in: .whitespaces)
                        .replacingOccurrences(of: "\u{201C}", with: "")
                        .replacingOccurrences(of: "\u{201D}", with: "")
                        .trimmingCharacters(in: CharacterSet(charactersIn: "\""))
                        .trimmingCharacters(in: .whitespaces)

                    currentContent.append(.quote(quoteText, author: author))
                    continue
                }

                // Save previous section
                if var section = currentSection {
                    section.content = groupOrphanedStatistics(currentContent)
                    sections.append(section)
                }

                // Start new section
                let title = headingText

                // Extract glossary terms and reflection opportunities
                let (glossaryTerms, shouldHaveReflection) = analyzeSection(
                    title: title,
                    upcomingBlocks: Array(blocks.suffix(from: index + 1).prefix(10))
                )

                currentSection = Section(
                    id: block.id,
                    title: title,
                    content: [],
                    isCollapsible: true,
                    level: level,
                    reflectionPrompts: shouldHaveReflection ? [UUID().uuidString] : [],
                    glossaryTerms: glossaryTerms,
                    relatedResearch: []
                )
                currentContent = []
                
            case "paragraph":
                flushLists()
                if let paragraphData = block.paragraph {
                    let richTexts = paragraphData.richText
                    let fullText = richTexts.map { $0.plainText }.joined()
                    let trimmed = fullText.trimmingCharacters(in: .whitespacesAndNewlines)
                    if !trimmed.isEmpty && !isNotionNavBlock(trimmed) {
                        currentContent.append(.text(fullText))
                    }
                }
                
            case "bulleted_list_item":
                let text = block.bulletedListItem?.richText.map { $0.plainText }.joined() ?? ""
                if !text.isEmpty && !isNotionNavBlock(text) {
                    if !consecutiveNumbers.isEmpty { flushLists() }
                    consecutiveBullets.append(text)
                }

            case "numbered_list_item":
                let text = block.numberedListItem?.richText.map { $0.plainText }.joined() ?? ""
                if !text.isEmpty {
                    if !consecutiveBullets.isEmpty { flushLists() }
                    consecutiveNumbers.append(text)
                }
                
            case "callout":
                flushLists()
                if let calloutData = block.callout {
                    let richTexts = calloutData.richText
                    let fullText = richTexts.map { $0.plainText }.joined()
                    let icon = calloutData.icon?.emoji ?? "ℹ️"
                    let type: CalloutType = determineCalloutType(from: icon)

                    // Try to extract title from first sentence if it looks like a title
                    let components = fullText.components(separatedBy: "\n")
                    let title = components.count > 1 ? components[0] : ""
                    let content = components.count > 1 ? components.dropFirst().joined(separator: "\n") : fullText

                    currentContent.append(.callout(title: title, content: content, type: type))

                    // Parse callout children (toggles, paragraphs, lists nested inside)
                    if let children = block.children, !children.isEmpty {
                        for child in children {
                            switch child.type {
                            case "toggle":
                                if let toggleData = child.toggle {
                                    let toggleTitle = toggleData.richText.map { $0.plainText }.joined()
                                    var childText = ""
                                    if let grandchildren = child.children {
                                        let texts = grandchildren.compactMap { gc -> String? in
                                            switch gc.type {
                                            case "paragraph":
                                                return gc.paragraph?.richText.map { $0.plainText }.joined()
                                            case "bulleted_list_item":
                                                if let t = gc.bulletedListItem?.richText.map({ $0.plainText }).joined() {
                                                    return "• \(t)"
                                                }
                                                return nil
                                            case "numbered_list_item":
                                                return gc.numberedListItem?.richText.map { $0.plainText }.joined()
                                            default:
                                                return nil
                                            }
                                        }
                                        childText = texts.joined(separator: "\n")
                                    }
                                    if !toggleTitle.isEmpty {
                                        currentContent.append(.toggleBlock(title: toggleTitle, content: childText))
                                    }
                                }
                            case "paragraph":
                                let text = child.paragraph?.richText.map { $0.plainText }.joined() ?? ""
                                if !text.isEmpty {
                                    currentContent.append(.text(text))
                                }
                            case "bulleted_list_item":
                                let text = child.bulletedListItem?.richText.map { $0.plainText }.joined() ?? ""
                                if !text.isEmpty {
                                    currentContent.append(.text("• \(text)"))
                                }
                            case "child_database":
                                // Inline database inside a callout
                                let dbId = child.id
                                let dbTitle = child.childDatabase?.title ?? "Database"
                                if let entries = childDatabases[dbId], !entries.isEmpty,
                                   !(entries.first?["_error"] != nil) {
                                    let groupKey = entries.first.flatMap { entry in
                                        entry.keys.first(where: { ["status", "category", "type", "group"].contains($0.lowercased()) })
                                    }
                                    let dbEntries: [DatabaseEntry] = entries.compactMap { raw -> DatabaseEntry? in
                                        let name = raw["_title"] ?? raw["Name"] ?? ""
                                        guard !name.isEmpty else { return nil }
                                        let group = groupKey.flatMap { raw[$0] } ?? ""
                                        let info = raw["Info"] ?? raw["Description"] ?? raw["Definition"] ?? ""
                                        var skipKeys: Set<String> = ["_title", "Name", "Info", "Description", "Definition", "Priority", "Added", ""]
                                        if let gk = groupKey { skipKeys.insert(gk) }
                                        let fields = raw.filter { !skipKeys.contains($0.key) && !$0.value.isEmpty }
                                        return DatabaseEntry(name: name, group: group, info: info, fields: fields)
                                    }
                                    if !dbEntries.isEmpty {
                                        currentContent.append(.database(title: dbTitle, entries: dbEntries, groupKey: groupKey))
                                    }
                                }
                            default:
                                break
                            }
                        }
                    }
                }
                
            case "quote":
                flushLists()
                if let quoteData = block.quote {
                    let richTexts = quoteData.richText
                    let fullText = richTexts.map { $0.plainText }.joined()
                    if fullText.isEmpty {
                        debugLog("⚠️ Quote block \(block.id) has empty rich_text")
                    }
                    // Try to extract author if present (usually after "—" or "-")
                    if let dashRange = fullText.range(of: "—") ?? fullText.range(of: " - ") {
                        let text = String(fullText[..<dashRange.lowerBound]).trimmingCharacters(in: .whitespacesAndNewlines)
                        let author = String(fullText[dashRange.upperBound...]).trimmingCharacters(in: .whitespacesAndNewlines)
                        currentContent.append(.quote(text, author: author.isEmpty ? nil : author))
                    } else {
                        currentContent.append(.quote(fullText, author: nil))
                    }
                } else {
                    debugLog("⚠️ Quote block \(block.id) has nil quote data — block may not be decoded correctly")
                }
                
            case "heading_1":
                flushLists()
                let h1Text = block.heading?.richText.map { $0.plainText }.joined() ?? ""
                let h1Trimmed = h1Text.trimmingCharacters(in: .whitespaces)

                // Detect quotes disguised as heading_1
                let isH1Quote = (h1Trimmed.hasPrefix("\u{201C}") || h1Trimmed.hasPrefix("\"")) ||
                    (h1Trimmed.contains("_") && h1Trimmed.count > 60)

                if isH1Quote {
                    // Parse as quote
                    var quoteText = h1Trimmed
                    var author: String? = nil
                    for separator in ["_ ", " _", "_"] {
                        if let range = quoteText.range(of: separator, options: .backwards) {
                            let possibleAuthor = String(quoteText[range.upperBound...]).trimmingCharacters(in: .whitespaces)
                            if !possibleAuthor.isEmpty && possibleAuthor.count < 80 && possibleAuthor.count > 2 {
                                author = possibleAuthor
                                quoteText = String(quoteText[..<range.lowerBound])
                                break
                            }
                        }
                    }
                    quoteText = quoteText
                        .trimmingCharacters(in: .whitespaces)
                        .replacingOccurrences(of: "\u{201C}", with: "")
                        .replacingOccurrences(of: "\u{201D}", with: "")
                        .trimmingCharacters(in: CharacterSet(charactersIn: "\""))
                        .trimmingCharacters(in: .whitespaces)
                    currentContent.append(.quote(quoteText, author: author))
                    continue
                }

                // Treat heading_1 as a top-level section header
                if var section = currentSection {
                    section.content = groupOrphanedStatistics(currentContent)
                    sections.append(section)
                }
                currentSection = Section(
                    id: block.id, title: h1Text, content: [],
                    isCollapsible: true, level: 1,
                    reflectionPrompts: [], glossaryTerms: [], relatedResearch: []
                )
                currentContent = []

            case "toggle":
                flushLists()
                if let toggleData = block.toggle {
                    let toggleTitle = toggleData.richText.map { $0.plainText }.joined()
                    // Parse toggle children into content text
                    var childText = ""
                    if let children = block.children {
                        let childTexts = children.compactMap { child -> String? in
                            switch child.type {
                            case "paragraph":
                                return child.paragraph?.richText.map { $0.plainText }.joined()
                            case "bulleted_list_item":
                                if let t = child.bulletedListItem?.richText.map({ $0.plainText }).joined() {
                                    return "• \(t)"
                                }
                                return nil
                            case "numbered_list_item":
                                return child.numberedListItem?.richText.map { $0.plainText }.joined()
                            case "callout":
                                return child.callout?.richText.map { $0.plainText }.joined()
                            default:
                                return nil
                            }
                        }
                        childText = childTexts.joined(separator: "\n")
                    }
                    if !toggleTitle.isEmpty {
                        currentContent.append(.toggleBlock(title: toggleTitle, content: childText))
                    }
                }

            case "table":
                flushLists()
                // Table block itself holds metadata; rows are children
                if let children = block.children {
                    let hasHeader = block.table?.hasColumnHeader ?? false
                    var headers: [String] = []
                    var rows: [[String]] = []
                    for (rowIdx, rowBlock) in children.enumerated() {
                        if rowBlock.type == "table_row", let rowData = rowBlock.tableRow {
                            let cellTexts = rowData.cells.map { cell in
                                cell.map { $0.plainText }.joined()
                            }
                            if rowIdx == 0 && hasHeader {
                                headers = cellTexts
                            } else {
                                rows.append(cellTexts)
                            }
                        }
                    }
                    if !headers.isEmpty || !rows.isEmpty {
                        currentContent.append(.table(headers: headers, rows: rows, caption: nil))
                    }
                }

            case "image":
                flushLists()
                if let imageData = block.image, let url = imageData.url {
                    currentContent.append(.image(url: url, caption: imageData.captionText))
                }

            case "bookmark":
                flushLists()
                if let bookmarkData = block.bookmark {
                    let caption = bookmarkData.caption?.map { $0.plainText }.joined() ?? bookmarkData.url
                    currentContent.append(.text("🔗 \(caption)"))
                }

            case "embed":
                flushLists()
                if let embedData = block.embed {
                    currentContent.append(.text("🔗 Embedded: \(embedData.url)"))
                }

            case "code":
                flushLists()
                if let codeData = block.code {
                    let codeText = codeData.richText.map { $0.plainText }.joined()
                    let lang = codeData.language ?? "text"
                    currentContent.append(.callout(title: "Code (\(lang))", content: codeText, type: .info))
                }

            case "child_database":
                flushLists()
                let dbId = block.id
                let dbTitle = block.childDatabase?.title ?? "Database"

                if let rawEntries = childDatabases[dbId], !rawEntries.isEmpty {
                    // Check for error sentinel from failed prefetch
                    if let firstEntry = rawEntries.first, firstEntry["_error"] != nil {
                        let errorMsg = firstEntry["_error"] ?? "Unknown error"
                        currentContent.append(.callout(title: dbTitle, content: "Could not load database: \(errorMsg)", type: .warning))
                    } else {
                        // Detect grouping key (Status, Category, Type, Group)
                        let groupKey = rawEntries.first.flatMap { entry in
                            entry.keys.first(where: { k in
                                let lower = k.lowercased()
                                return lower == "status" || lower == "category" || lower == "type" || lower == "group"
                            })
                        }

                        // Convert raw dictionaries to DatabaseEntry models
                        let dbEntries: [DatabaseEntry] = rawEntries.compactMap { raw -> DatabaseEntry? in
                            let name = raw["_title"] ?? raw["Name"] ?? ""
                            guard !name.isEmpty else { return nil }
                            let group = groupKey.flatMap { raw[$0] } ?? ""
                            // Collect info from rich-text fields
                            let info = raw["Info"] ?? raw["Description"] ?? raw["Definition"] ?? raw["Context of Investing"] ?? ""
                            // Collect extra fields (exclude internal/grouping/title keys)
                            var skipKeys: Set<String> = ["_title", "Name", "Info", "Description", "Definition", "Context of Investing", "Priority", "Added", ""]
                            if let gk = groupKey { skipKeys.insert(gk) }
                            let fields = raw.filter { !skipKeys.contains($0.key) && !$0.value.isEmpty }
                            return DatabaseEntry(name: name, group: group, info: info, fields: fields)
                        }

                        if !dbEntries.isEmpty {
                            currentContent.append(.database(title: dbTitle, entries: dbEntries, groupKey: groupKey))
                            debugLog("📊 Added database card \"\(dbTitle)\" with \(dbEntries.count) entries")
                        }
                    }
                } else if let fallback = HardcodedDatabases.entries(forDatabaseId: dbId), !fallback.isEmpty {
                    // Not found in prefetch map — use hardcoded fallback
                    let groupKey = fallback.first.flatMap { entry in
                        entry.keys.first(where: { k in
                            let lower = k.lowercased()
                            return lower == "status" || lower == "category" || lower == "type" || lower == "group"
                        })
                    }
                    let dbEntries: [DatabaseEntry] = fallback.compactMap { raw -> DatabaseEntry? in
                        let name = raw["_title"] ?? raw["Name"] ?? raw["Term"] ?? ""
                        guard !name.isEmpty else { return nil }
                        let group = groupKey.flatMap { raw[$0] } ?? ""
                        let info = raw["Info"] ?? raw["Description"] ?? raw["Definition"] ?? ""
                        var skipKeys: Set<String> = ["_title", "Name", "Term", "Info", "Description", "Definition", "Priority", "Added", ""]
                        if let gk = groupKey { skipKeys.insert(gk) }
                        let fields = raw.filter { !skipKeys.contains($0.key) && !$0.value.isEmpty }
                        return DatabaseEntry(name: name, group: group, info: info, fields: fields)
                    }
                    if !dbEntries.isEmpty {
                        currentContent.append(.database(title: dbTitle, entries: dbEntries, groupKey: groupKey))
                        debugLog("📊 Added hardcoded database card \"\(dbTitle)\" with \(dbEntries.count) entries")
                    }
                } else {
                    // No data and no fallback — show placeholder
                    currentContent.append(.callout(title: dbTitle, content: "Database content loading — please refresh.", type: .info))
                }

            case "to_do":
                flushLists()
                if let toDoData = block.toDo {
                    let text = toDoData.richText.map { $0.plainText }.joined()
                    let check = (toDoData.checked ?? false) ? "☑" : "☐"
                    currentContent.append(.text("\(check) \(text)"))
                }

            case "column_list":
                // Column lists contain column children, parse them sequentially
                flushLists()
                if let children = block.children {
                    for colBlock in children {
                        if colBlock.type == "column", let colChildren = colBlock.children {
                            for child in colChildren {
                                // Re-parse each child as a top-level block
                                switch child.type {
                                case "paragraph":
                                    if let text = child.paragraph?.richText.map({ $0.plainText }).joined(), !text.isEmpty {
                                        currentContent.append(.text(text))
                                    }
                                case "callout":
                                    if let calloutData = child.callout {
                                        let fullText = calloutData.richText.map { $0.plainText }.joined()
                                        let icon = calloutData.icon?.emoji ?? "ℹ️"
                                        let type: CalloutType = determineCalloutType(from: icon)
                                        let components = fullText.components(separatedBy: "\n")
                                        let title = components.count > 1 ? components[0] : ""
                                        let content = components.count > 1 ? components.dropFirst().joined(separator: "\n") : fullText
                                        currentContent.append(.callout(title: title, content: content, type: type))
                                    }
                                case "bulleted_list_item":
                                    if let text = child.bulletedListItem?.richText.map({ $0.plainText }).joined() {
                                        consecutiveBullets.append(text)
                                    }
                                default:
                                    break
                                }
                            }
                        }
                    }
                }

            case "synced_block":
                // Synced blocks reference content from another block; their children are the actual content
                flushLists()
                if let children = block.children {
                    for child in children {
                        switch child.type {
                        case "paragraph":
                            let text = child.paragraph?.richText.map { $0.plainText }.joined() ?? ""
                            if !text.isEmpty { currentContent.append(.text(text)) }
                        case "callout":
                            if let calloutData = child.callout {
                                let fullText = calloutData.richText.map { $0.plainText }.joined()
                                let icon = calloutData.icon?.emoji ?? "ℹ️"
                                let type: CalloutType = determineCalloutType(from: icon)
                                let components = fullText.components(separatedBy: "\n")
                                let title = components.count > 1 ? components[0] : ""
                                let content = components.count > 1 ? components.dropFirst().joined(separator: "\n") : fullText
                                currentContent.append(.callout(title: title, content: content, type: type))
                            }
                        case "bulleted_list_item":
                            if let text = child.bulletedListItem?.richText.map({ $0.plainText }).joined(), !text.isEmpty {
                                consecutiveBullets.append(text)
                            }
                        case "numbered_list_item":
                            if let text = child.numberedListItem?.richText.map({ $0.plainText }).joined(), !text.isEmpty {
                                consecutiveNumbers.append(text)
                            }
                        case "heading_2", "heading_3":
                            let childTitle = child.heading?.richText.map { $0.plainText }.joined() ?? ""
                            if !childTitle.isEmpty { currentContent.append(.heading(childTitle, level: child.type == "heading_2" ? 2 : 3)) }
                        case "toggle":
                            if let toggleData = child.toggle {
                                let toggleTitle = toggleData.richText.map { $0.plainText }.joined()
                                var childText = ""
                                if let grandchildren = child.children {
                                    childText = grandchildren.compactMap { gc -> String? in
                                        gc.paragraph?.richText.map { $0.plainText }.joined()
                                    }.joined(separator: "\n")
                                }
                                if !toggleTitle.isEmpty { currentContent.append(.toggleBlock(title: toggleTitle, content: childText)) }
                            }
                        default:
                            break
                        }
                    }
                }

            case "table_of_contents":
                // Skip — this is a Notion UI element, not content
                break

            case "divider":
                flushLists()
                currentContent.append(.divider)

            case "table_row", "column":
                // These are children of table/column_list — handled by parent
                break

            default:
                debugLog("Unhandled Notion block type: \(block.type)")
                break
            }
        }
        
        // Flush any remaining lists
        flushLists()
        
        // Save last section
        if var section = currentSection {
            section.content = groupOrphanedStatistics(currentContent)
            sections.append(section)
        }

        // Deduplicate sections by title — keeps the first occurrence of each title.
        var seenTitles: Set<String> = []
        var dedupedSections = sections.filter { section in
            let key = section.title.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            guard !key.isEmpty else { return true }
            return seenTitles.insert(key).inserted
        }

        // Deduplicate content blocks within each section — remove repeated paragraphs.
        for i in 0..<dedupedSections.count {
            var seenContent: Set<String> = []
            dedupedSections[i].content = dedupedSections[i].content.filter { block in
                // Only deduplicate text blocks; leave structural blocks (lists, tables, etc.) as-is
                if case .text(let str) = block {
                    let key = str.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                    guard key.count > 20 else { return true } // keep short lines
                    return seenContent.insert(key).inserted
                }
                return true
            }
        }

        // Block type summary for diagnostics
        #if DEBUG
        let blockTypeCounts = Dictionary(grouping: blocks, by: { $0.type }).mapValues { $0.count }
        let typesSummary = blockTypeCounts.sorted { $0.key < $1.key }.map { "\($0.key): \($0.value)" }.joined(separator: ", ")
        let totalContent = dedupedSections.reduce(0) { $0 + $1.content.count }
        if dedupedSections.count < sections.count {
            debugLog("🔁 [parseSections] Removed \(sections.count - dedupedSections.count) duplicate section(s)")
        }
        debugLog("📊 [parseSections] \(blocks.count) blocks → \(dedupedSections.count) sections, \(totalContent) content blocks | Types: \(typesSummary)")
        #endif

        return dedupedSections
    }
    
    // Analyze section content to identify key terms and reflection opportunities
    private func analyzeSection(title: String, upcomingBlocks: [NotionBlock]) -> (glossaryTerms: [String], shouldHaveReflection: Bool) {
        let lowercaseTitle = title.lowercased()
        
        // Keywords that suggest important concepts
        let conceptKeywords = ["bias", "theory", "effect", "principle", "gap", "behavior", "pattern", "strategy"]
        let hasKeyword = conceptKeywords.contains { lowercaseTitle.contains($0) }
        
        // Check if section has substantial content (good for reflection)
        let blockCount = upcomingBlocks.prefix(5).count
        let shouldHaveReflection = hasKeyword && blockCount >= 2
        
        // Extract potential glossary terms from title
        var glossaryTerms: [String] = []
        if hasKeyword {
            glossaryTerms.append(title)
        }
        
        return (glossaryTerms, shouldHaveReflection)
    }
    
    private func determineCalloutType(from emoji: String) -> CalloutType {
        switch emoji {
        case "💡": return .tip
        case "⚠️": return .warning
        case "📊", "📈": return .research
        case "✏️", "📝": return .example
        default: return .info
        }
    }
    
    // MARK: - API Calls
    private func fetchDatabasePages() async throws -> [NotionPage] {
        guard let url = URL(string: "\(baseURL)/databases/\(databaseId)/query") else {
            throw NSError(domain: "Invalid URL", code: 0)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("2022-06-28", forHTTPHeaderField: "Notion-Version")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(NotionDatabaseResponse.self, from: data)
        return response.results
    }
    
    private func fetchPageBlocks(pageId: String) async throws -> [NotionBlock] {
        let cleanId = pageId.replacingOccurrences(of: "-", with: "")
        var allBlocks: [NotionBlock] = []
        var cursor: String? = nil

        // Paginate through all blocks (Notion returns max 100 per call)
        repeat {
            var urlString = "\(baseURL)/blocks/\(cleanId)/children?page_size=100"
            if let cursor = cursor {
                urlString += "&start_cursor=\(cursor)"
            }
            guard let url = URL(string: urlString) else {
                throw NSError(domain: "Invalid URL", code: 0)
            }

            var request = URLRequest(url: url)
            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            request.setValue("2022-06-28", forHTTPHeaderField: "Notion-Version")

            let (data, _) = try await URLSession.shared.data(for: request)
            let response = try JSONDecoder().decode(NotionPaginatedBlocksResponse.self, from: data)
            allBlocks.append(contentsOf: response.results)
            cursor = response.hasMore ? response.nextCursor : nil
        } while cursor != nil

        // Fetch children only for block types that parseSections actually reads.
        // Paragraph/heading/bullet children are indented sub-content we don't render —
        // fetching them causes hundreds of unnecessary API calls on large pages.
        let childFetchTypes: Set<String> = ["column_list", "callout", "toggle", "synced_block", "table"]
        // Note: child_database blocks are handled by prefetchChildDatabases() via the
        // database query API — do NOT call /blocks/{id}/children on them, it will fail.
        var enrichedBlocks: [NotionBlock] = []
        for var block in allBlocks {
            if block.hasChildren == true && childFetchTypes.contains(block.type) {
                do {
                    let children = try await fetchPageBlocks(pageId: block.id)
                    block.children = children
                } catch {
                    debugLog("Failed to fetch children for block \(block.id): \(error)")
                }
            }
            enrichedBlocks.append(block)
        }

        return enrichedBlocks
    }
}

// MARK: - Notion API Models
struct NotionDatabaseResponse: Codable {
    let results: [NotionPage]
}

struct NotionPage: Codable {
    let id: String
    let properties: [String: NotionProperty]
}

struct NotionProperty: Codable {
    let title: [NotionRichText]?
    let richText: [NotionRichText]?
    let select: NotionSelect?
    let multiSelect: [NotionSelect]?
    let number: Double?
    let url: String?
    let relation: [NotionRelation]?
    let checkbox: Bool?
    let date: NotionDate?

    enum CodingKeys: String, CodingKey {
        case title
        case richText = "rich_text"
        case select
        case multiSelect = "multi_select"
        case number
        case url
        case relation
        case checkbox
        case date
    }
}

struct NotionDate: Codable {
    let start: String?
    let end: String?
}

struct NotionRelation: Codable {
    let id: String
}

struct NotionRichText: Codable {
    let plainText: String
    let href: String?
    let annotations: NotionAnnotations?

    enum CodingKeys: String, CodingKey {
        case plainText = "plain_text"
        case href
        case annotations
    }
}

struct NotionAnnotations: Codable {
    let bold: Bool?
    let italic: Bool?
    let strikethrough: Bool?
    let underline: Bool?
    let code: Bool?
    let color: String?
}

struct NotionSelect: Codable {
    let name: String
}

struct NotionBlocksResponse: Codable {
    let results: [NotionBlock]
}

struct NotionPaginatedBlocksResponse: Codable {
    let results: [NotionBlock]
    let hasMore: Bool
    let nextCursor: String?

    enum CodingKeys: String, CodingKey {
        case results
        case hasMore = "has_more"
        case nextCursor = "next_cursor"
    }
}

struct NotionBlock: Codable {
    let id: String
    let type: String
    let hasChildren: Bool?
    let heading_1: NotionHeading?
    let heading_2: NotionHeading?
    let heading_3: NotionHeading?
    let paragraph: NotionParagraph?
    let bulletedListItem: NotionListItem?
    let numberedListItem: NotionListItem?
    let callout: NotionCallout?
    let quote: NotionQuote?
    let toggle: NotionToggle?
    let image: NotionImage?
    let table: NotionTable?
    let tableRow: NotionTableRow?
    let code: NotionCode?
    let bookmark: NotionBookmark?
    let embed: NotionEmbed?
    let childDatabase: NotionChildDatabase?
    let columnList: NotionEmpty?
    let column: NotionEmpty?
    let toDo: NotionToDo?

    // Mutable children fetched separately for toggle/column blocks
    var children: [NotionBlock]?

    var heading: NotionHeading? {
        return heading_1 ?? heading_2 ?? heading_3
    }

    enum CodingKeys: String, CodingKey {
        case id, type
        case hasChildren = "has_children"
        case heading_1 = "heading_1"
        case heading_2 = "heading_2"
        case heading_3 = "heading_3"
        case paragraph
        case bulletedListItem = "bulleted_list_item"
        case numberedListItem = "numbered_list_item"
        case callout, quote, toggle, image, table, code, bookmark, embed
        case tableRow = "table_row"
        case childDatabase = "child_database"
        case columnList = "column_list"
        case column
        case toDo = "to_do"
    }
}

struct NotionToggle: Codable {
    let richText: [NotionRichText]
    let color: String?

    enum CodingKeys: String, CodingKey {
        case richText = "rich_text"
        case color
    }
}

struct NotionImage: Codable {
    let type: String?          // "file" or "external"
    let file: NotionFileURL?
    let external: NotionFileURL?
    let caption: [NotionRichText]?

    var url: String? {
        file?.url ?? external?.url
    }
    var captionText: String? {
        caption?.map { $0.plainText }.joined()
    }
}

struct NotionFileURL: Codable {
    let url: String
}

struct NotionTable: Codable {
    let tableWidth: Int?
    let hasColumnHeader: Bool?
    let hasRowHeader: Bool?

    enum CodingKeys: String, CodingKey {
        case tableWidth = "table_width"
        case hasColumnHeader = "has_column_header"
        case hasRowHeader = "has_row_header"
    }
}

struct NotionTableRow: Codable {
    let cells: [[NotionRichText]]
}

struct NotionCode: Codable {
    let richText: [NotionRichText]
    let language: String?

    enum CodingKeys: String, CodingKey {
        case richText = "rich_text"
        case language
    }
}

struct NotionBookmark: Codable {
    let url: String
    let caption: [NotionRichText]?
}

struct NotionEmbed: Codable {
    let url: String
}

struct NotionChildDatabase: Codable {
    let title: String
}

struct NotionToDo: Codable {
    let richText: [NotionRichText]
    let checked: Bool?

    enum CodingKeys: String, CodingKey {
        case richText = "rich_text"
        case checked
    }
}

struct NotionEmpty: Codable {}

struct NotionHeading: Codable {
    let richText: [NotionRichText]
    
    enum CodingKeys: String, CodingKey {
        case richText = "rich_text"
    }
}

struct NotionParagraph: Codable {
    let richText: [NotionRichText]
    
    enum CodingKeys: String, CodingKey {
        case richText = "rich_text"
    }
}

struct NotionListItem: Codable {
    let richText: [NotionRichText]
    
    enum CodingKeys: String, CodingKey {
        case richText = "rich_text"
    }
}

struct NotionCallout: Codable {
    let richText: [NotionRichText]
    let icon: NotionIcon?
    
    enum CodingKeys: String, CodingKey {
        case richText = "rich_text"
        case icon
    }
}

struct NotionIcon: Codable {
    let emoji: String?
}

struct NotionQuote: Codable {
    let richText: [NotionRichText]
    
    enum CodingKeys: String, CodingKey {
        case richText = "rich_text"
    }
}
