//
//  ModuleFootnotes.swift
//  Enhanced App for Alt Assets
//
//  Created by Victoria Case on 2/5/26.
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//
//  Description: Module-specific footnotes that correspond to numbered
//  references within each educational module. Each module has its own
//  footnote numbering system like academic papers.
//

import SwiftUI
import Combine

// MARK: - Module Footnote
/// A footnote tied to a specific module with its own numbering
struct ModuleFootnote: Identifiable, Codable, Hashable {
    let id: String
    let moduleId: String
    let number: String  // Can be "1", "1.1", "2.1", etc.
    let title: String
    let author: String
    let source: String?
    let url: String?
    let year: String?
    let appleBooksURL: String?

    init(id: String, moduleId: String, number: String, title: String, author: String, source: String?, url: String?, year: String?, appleBooksURL: String? = nil) {
        self.id = id
        self.moduleId = moduleId
        self.number = number
        self.title = title
        self.author = author
        self.source = source
        self.url = url
        self.year = year
        self.appleBooksURL = appleBooksURL
    }

    var displayNumber: String {
        "(\(number))"
    }

    var citation: String {
        var parts: [String] = []
        if !author.isEmpty { parts.append(author) }
        parts.append("\"\(title)\"")
        if let source = source, !source.isEmpty { parts.append(source) }
        if let year = year, !year.isEmpty { parts.append("(\(year))") }
        return parts.joined(separator: ", ")
    }
}

// MARK: - Module Footnotes Manager
class ModuleFootnotesManager: ObservableObject {
    @Published var footnotesByModule: [String: [ModuleFootnote]] = [:]
    @Published var isLoading: Bool = false
    /// Footnotes parsed directly from a module's Notion page (# Footnotes section).
    /// Keyed by moduleId. Takes priority over hardcoded entries for the same module.
    @Published var pageFootnotesByModule: [String: [ModuleFootnote]] = [:]

    static let shared = ModuleFootnotesManager()

    private let notionAPIKey = AppConfiguration.notionAPIKey
    private let databaseId  = "4307a4fa71644aaf89cb29c2fb166f0b"

    // Maps Notion multi_select "Module" tag → internal module key.
    // Tags are lowercased before lookup (see fetchFromNotion).
    // Add every tag variant that appears in the Notion database here.
    private static let notionTagToKey: [String: String] = [
        // ── Module 1: Investing Primer (mod_women) ──────────────────────────
        "investing primer":                 "mod_women",
        "women and collective investing":   "mod_women",
        "women investing":                  "mod_women",
        "collective investing":             "mod_women",
        "women":                            "mod_women",
        "neuroeconomics":                   "mod_women",
        "neuro-economic":                   "mod_women",
        "neuro economic":                   "mod_women",
        // ── Module 2: Alternative Investing (mod_alt) ───────────────────────
        "alternative investing":            "mod_alt",
        "alt investing":                    "mod_alt",
        "alternative assets":               "mod_alt",
        // ── Module 3: Behavioral Economics (mod_behavioral) ─────────────────
        "behavioral economics":             "mod_behavioral",
        "behavioral finance":               "mod_behavioral",
        "behavioural economics":            "mod_behavioral",
        // ── Module 4: Gender & Behavioral Economics (mod_gender) ────────────
        "gender and behavioral economics":  "mod_gender",
        "gender economics":                 "mod_gender",
        "gender lens":                      "mod_gender",
        "gender lens investing":            "mod_gender",
        "gender":                           "mod_gender",
        // ── Module 5: DeFi (mod_defi) ───────────────────────────────────────
        "defi":                             "mod_defi",
        "decentralized finance":            "mod_defi",
        "decentralised finance":            "mod_defi",
        // ── Module 6: Art as Investment (mod_art) ───────────────────────────
        "art investing":                    "mod_art",
        "art as investment":                "mod_art",
        "art":                              "mod_art",
        "pop art module":                   "mod_art",
        "female artists":                   "mod_art",
        // ── Module 7: ESG / Climate / RWA (mod_esg_climate) ─────────────────
        "esg":                              "mod_esg_climate",
        "climate":                          "mod_esg_climate",
        "esg & climate":                    "mod_esg_climate",
        "esg/climate":                      "mod_esg_climate",
        "esg climate":                      "mod_esg_climate",
        "rwa":                              "mod_esg_climate",
        "real world assets":                "mod_esg_climate",
        "climate energy":                   "mod_esg_climate",
        "climate, energy & rwa":            "mod_esg_climate",
        // ── Module 8: Kahlo × Basquiat (mod_kahlo_basquiat) ─────────────────
        "frida kahlo":                      "mod_kahlo_basquiat",
        "frida kahlo, gratis":              "mod_kahlo_basquiat",
        "kahlo":                            "mod_kahlo_basquiat",
        "gratis":                           "mod_kahlo_basquiat",
        "gratis, jeanmichel basquiat":      "mod_kahlo_basquiat",
        "jeanmichel basquiat":              "mod_kahlo_basquiat",
        "jean-michel basquiat":             "mod_kahlo_basquiat",
        "basquiat":                         "mod_kahlo_basquiat",
        "kahlo basquiat":                   "mod_kahlo_basquiat",
        "kahlo × basquiat":                 "mod_kahlo_basquiat",
        // ── Module 9: DeFi Investing (mod_defi_investing) ───────────────────
        "defi investing":                   "mod_defi_investing",
        "decentralized finance investing":  "mod_defi_investing",
        "defi investment":                  "mod_defi_investing",
        // ── Wine & Vineyard Investing (mod_wine) ─────────────────────────────
        "wine":                             "mod_wine",
        "wine investing":                   "mod_wine",
        "vineyard":                         "mod_wine",
        "vineyard investing":               "mod_wine",
        "fine wine":                        "mod_wine",
        "organic wine":                     "mod_wine",
        // ── Biodynamic Deep Dive (mod_biodynamic) ───────────────────────────
        "biodynamic":                       "mod_biodynamic",
        "biodynamic wine":                  "mod_biodynamic",
        "biodynamic viticulture":           "mod_biodynamic",
        "regenerative viticulture":         "mod_biodynamic",
        "demeter":                          "mod_biodynamic",
        "biodyvin":                         "mod_biodynamic"
    ]

    init() {
        Task { await fetchFromNotion() }
    }

    /// Fetches all footnotes from the Notion database and populates footnotesByModule.
    func fetchFromNotion() async {
        await MainActor.run { isLoading = true }
        var all: [ModuleFootnote] = []
        var cursor: String? = nil

        repeat {
            var body: [String: Any] = ["page_size": 100]
            if let c = cursor { body["start_cursor"] = c }
            guard let url = URL(string: "https://api.notion.com/v1/databases/\(databaseId)/query"),
                  let bodyData = try? JSONSerialization.data(withJSONObject: body) else { break }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("Bearer \(notionAPIKey)", forHTTPHeaderField: "Authorization")
            request.setValue("2022-06-28", forHTTPHeaderField: "Notion-Version")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = bodyData

            guard let (data, _) = try? await URLSession.shared.data(for: request),
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let results = json["results"] as? [[String: Any]] else { break }

            for page in results {
                guard let props = page["properties"] as? [String: Any] else { continue }

                // FootNote (number) — entries without a number are kept with "—"
                let numRaw = (props["FootNote"] as? [String: Any])?["number"] as? Double
                let number: String
                if let n = numRaw {
                    number = n.truncatingRemainder(dividingBy: 1) == 0
                        ? String(format: "%.0f", n)
                        : String(format: "%.1f", n)
                } else {
                    number = "—"
                }

                // Source Article (title)
                let titleParts = ((props["Source Article"] as? [String: Any])?["title"] as? [[String: Any]]) ?? []
                let title = titleParts.compactMap { ($0["plain_text"] as? String) }.joined()
                guard !title.isEmpty else { continue }

                // Author (rich_text) = author name
                let authorParts = ((props["Author"] as? [String: Any])?["rich_text"] as? [[String: Any]]) ?? []
                let author = authorParts.compactMap { $0["plain_text"] as? String }.joined()

                // From (rich_text) = journal / publication source
                let fromParts = ((props["From"] as? [String: Any])?["rich_text"] as? [[String: Any]]) ?? []
                let source = fromParts.compactMap { $0["plain_text"] as? String }.joined()

                // Date (rich_text)
                let dateParts = ((props["Date"] as? [String: Any])?["rich_text"] as? [[String: Any]]) ?? []
                let year = dateParts.compactMap { $0["plain_text"] as? String }.joined()

                // URL (url)
                let urlValue = (props["URL"] as? [String: Any])?["url"] as? String

                // Module (multi_select)
                let moduleTags = ((props["Module"] as? [String: Any])?["multi_select"] as? [[String: Any]]) ?? []
                let moduleKeys: [String] = moduleTags.compactMap { tag in
                    guard let name = tag["name"] as? String else { return nil }
                    return Self.notionTagToKey[name.lowercased()]
                }

                let pageId = page["id"] as? String ?? UUID().uuidString

                for moduleKey in moduleKeys {
                    all.append(ModuleFootnote(
                        id: "\(pageId)_\(moduleKey)",
                        moduleId: moduleKey,
                        number: number,
                        title: title,
                        author: author,
                        source: source.isEmpty ? nil : source,
                        url: urlValue,
                        year: year.isEmpty ? nil : year
                    ))
                }
            }

            let hasMore = json["has_more"] as? Bool ?? false
            cursor = hasMore ? (json["next_cursor"] as? String) : nil
        } while cursor != nil

        // Group by moduleId
        var byModule: [String: [ModuleFootnote]] = [:]
        for fn in all {
            byModule[fn.moduleId, default: []].append(fn)
        }

        await MainActor.run {
            self.footnotesByModule = byModule
            self.isLoading = false
        }
    }


    // Legacy stub — no longer used; fetchFromNotion() populates footnotesByModule.
    func loadFootnotes() { /* no-op */ }


    /// Parses the # Footnotes section from a fetched module's sections and stores
    /// the result in pageFootnotesByModule. Call this after NotionService loads a module.
    @MainActor
    func loadFromModuleSections(_ sections: [Section], moduleId: String) {
        let keywords = ["footnote", "reference", "bibliography", "citation", "source"]
        func isFootnotesTitle(_ title: String) -> Bool {
            let t = title.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            return keywords.contains(where: { t.contains($0) })
        }

        // Collect content blocks — from a matching section OR from a toggle block inside any section
        var contentBlocks: [ContentBlock] = []

        if let footnotesSection = sections.first(where: { isFootnotesTitle($0.title) }) {
            contentBlocks = footnotesSection.content
        } else {
            // Search inside section content for a matching toggle block
            outer: for section in sections {
                for block in section.content {
                    if case .toggleBlock(let title, let t) = block, isFootnotesTitle(title) {
                        // toggleBlock content is a plain string — wrap it as a text block
                        contentBlocks = [.text(t)]
                        break outer
                    }
                }
            }
        }

        guard !contentBlocks.isEmpty else { return }

        var parsed: [ModuleFootnote] = []

        // Collect all text lines from the content blocks
        var lines: [String] = []
        func addLines(_ text: String) {
            lines.append(contentsOf: text.components(separatedBy: "\n")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty })
        }
        for block in contentBlocks {
            switch block {
            case .text(let t):          addLines(t)
            case .numberedList(let items): items.forEach { addLines($0) }
            case .bulletList(let items):   items.forEach { addLines($0) }
            case .toggleBlock(_, let t):   addLines(t)
            default: break
            }
        }

        for line in lines where !line.isEmpty {
            if let footnote = parseFootnoteLine(line, moduleId: moduleId, index: parsed.count + 1) {
                parsed.append(footnote)
            }
        }

        // Only store if we found a meaningful number of entries — avoids replacing
        // hardcoded bibliography with just toggle header/intro lines
        if parsed.count >= 5 {
            pageFootnotesByModule[moduleId] = parsed
        }
    }

    /// Parses a single footnote line in formats like:
    ///   **N.** Author (Year). Title. Source. https://url
    ///   N. Author (Year). Title. Source. https://url
    private func parseFootnoteLine(_ raw: String, moduleId: String, index: Int) -> ModuleFootnote? {
        var line = raw

        // Strip leading bold number: **67.** or **67**
        if line.hasPrefix("**") {
            line = line.replacingOccurrences(of: #"^\*\*(\d[\d.]*)\.\*\*\s*"#, with: "", options: .regularExpression)
                       .replacingOccurrences(of: #"^\*\*(\d[\d.]*)\*\*\s*"#, with: "", options: .regularExpression)
        }

        // Extract leading number: "67. " or "67 "
        var number = "\(index)"
        let numberPattern = #"^(\d[\d.]*)[.\s]\s*"#
        if let range = line.range(of: numberPattern, options: .regularExpression) {
            let numStr = String(line[range]).trimmingCharacters(in: .init(charactersIn: ". "))
            if !numStr.isEmpty { number = numStr }
            line = String(line[range.upperBound...]).trimmingCharacters(in: .whitespacesAndNewlines)
        }

        guard !line.isEmpty else { return nil }

        // Extract URL — last whitespace-separated token starting with http
        var url: String? = nil
        var remaining = line
        let tokens = line.components(separatedBy: .whitespaces)
        if let urlToken = tokens.last(where: { $0.hasPrefix("http") }) {
            url = urlToken
            remaining = line.replacingOccurrences(of: urlToken, with: "").trimmingCharacters(in: .whitespacesAndNewlines).trimmingCharacters(in: .init(charactersIn: "."))
        }

        // Extract year from (YYYY) pattern
        var year: String? = nil
        if let yearMatch = remaining.range(of: #"\((\d{4})\)"#, options: .regularExpression) {
            let full = String(remaining[yearMatch])
            year = full.trimmingCharacters(in: .init(charactersIn: "()"))
            remaining = remaining.replacingOccurrences(of: full, with: "").trimmingCharacters(in: .whitespacesAndNewlines).trimmingCharacters(in: .init(charactersIn: "."))
        }

        // First sentence-like fragment = title heuristic; everything before first period after 20 chars
        // Simpler: split on ". " and take the longest fragment as title
        let parts = remaining.components(separatedBy: ". ").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }
        let title = parts.first ?? remaining
        let source = parts.dropFirst().joined(separator: ". ")

        return ModuleFootnote(
            id: "\(moduleId)_page_\(number)",
            moduleId: moduleId,
            number: number,
            title: title,
            author: "",
            source: source.isEmpty ? nil : source,
            url: url,
            year: year
        )
    }

    func footnotes(for moduleId: String) -> [ModuleFootnote] {
        // Page-parsed footnotes take priority (ESG, DeFi Investing — full inline lists)
        if let footnotes = pageFootnotesByModule[moduleId], !footnotes.isEmpty {
            return footnotes
        }
        // Notion database footnotes (Art, Kahlo/Basquiat, Women, etc.)
        if let footnotes = footnotesByModule[moduleId], !footnotes.isEmpty {
            return footnotes.sorted {
                let num1 = Double($0.number) ?? 0
                let num2 = Double($1.number) ?? 0
                return num1 < num2
            }
        }
        // Hardcoded fallback when Notion is unreachable
        return Self.hardcodedFootnotes[moduleId] ?? []
    }

    // Hardcoded citation seeds — sourced directly from the Notion CSV export.
    // Used when the live Notion fetch returns empty (network failure, tag mismatch, etc.).
    // Numbers must match inline references in NotionModulesData.swift.
    // Note: citation 15 appears twice in the source data (two different works share the number).
    static let hardcodedFootnotes: [String: [ModuleFootnote]] = [
        "mod_women": [
            ModuleFootnote(id: "hw_1",   moduleId: "mod_women", number: "1",   title: "Nudges and Behavioral Economics",                                                              author: "Beryl Y. Chang",                                                                   source: "The SAGE Encyclopedia of Economics and Society (Vol. 3)",    url: nil,                                                                                                   year: "2015"),
            ModuleFootnote(id: "hw_2",   moduleId: "mod_women", number: "2",   title: "What is neuroeconomics?",                                                                      author: "Jonathan Cohen",                                                                   source: nil,                                                           url: "https://insights.som.yale.edu/insights/what-is-neuroeconomics",                                      year: "2010"),
            ModuleFootnote(id: "hw_2_1", moduleId: "mod_women", number: "2.1", title: "Consciousness and Cognition",                                                                  author: "Kane O Pryor and Robert A Veselis",                                                source: "Foundations of Anesthesia (Second Edition)",                  url: "https://www.sciencedirect.com/topics/medicine-and-dentistry/prefrontal-cortex",                      year: "2006"),
            ModuleFootnote(id: "hw_3",   moduleId: "mod_women", number: "3",   title: "Commencement Speech to the Stanford Class of 2008",                                           author: "Oprah Winfrey",                                                                    source: nil,                                                           url: "https://news.stanford.edu/news/2008/june18/como-061808.html",                                        year: "2008"),
            ModuleFootnote(id: "hw_4",   moduleId: "mod_women", number: "4",   title: "Fertility Rate in U.S. Hit a Record Low in 2018",                                            author: "Sabrina Tavernise",                                                                source: nil,                                                           url: "https://www.nytimes.com/2019/11/27/us/us-birth-fertility-rate.html",                                 year: "2019"),
            ModuleFootnote(id: "hw_5",   moduleId: "mod_women", number: "5",   title: "The Great Recession, Fertility, and Uncertainty: Evidence from the United States",           author: "Daniel Scheider",                                                                  source: "Journal of Marriage and Family, Vol. 77",                     url: nil,                                                                                                   year: "2015"),
            ModuleFootnote(id: "hw_6",   moduleId: "mod_women", number: "6",   title: "Fewer Births in a Bad Economy",                                                               author: "Catherine Rampell",                                                                source: nil,                                                           url: "https://economix.blogs.nytimes.com/2011/10/12/fewer-births-in-a-bad-economy/",                      year: "2011"),
            ModuleFootnote(id: "hw_7",   moduleId: "mod_women", number: "7",   title: "Recession Worries Boost Treasuries; Stocks Advance: Markets Wrap",                           author: "Isabelle Lee and Enrique Roces Gonzalez",                                         source: "Bloomberg",                                                   url: "https://www.bloomberg.com/news/articles/2022-06-22/growth-worries-spur-bonds-set-to-restrain-stocks-markets-wrap", year: "2022"),
            ModuleFootnote(id: "hw_8",   moduleId: "mod_women", number: "8",   title: "Merrill Lynch Age Wave Survey",                                                               author: "Merrill Lynch / Age Wave",                                                         source: nil,                                                           url: "https://agewave.com/what-we-do/landmark-research-and-consulting/research-studies/new-retirement-survey/", year: "2019"),
            ModuleFootnote(id: "hw_9",   moduleId: "mod_women", number: "9",   title: "The role of behavioral economics and behavioral decision making in Americans' retirement savings decisions", author: "Melissa A.Z. Knoll",                                           source: nil,                                                           url: nil,                                                                                                   year: "2010"),
            ModuleFootnote(id: "hw_10",  moduleId: "mod_women", number: "10",  title: "Study Shows Bias Against Investment Recommendations from Women",                              author: "Tristan L. Botelho",                                                               source: nil,                                                           url: "https://insights.som.yale.edu/insights/study-shows-bias-against-investment-recommendations-from-women", year: "2017"),
            ModuleFootnote(id: "hw_11",  moduleId: "mod_women", number: "11",  title: "Investors Like Me",                                                                            author: "Angie Lufrano",                                                                    source: "The Motley Fool",                                             url: "https://www.fool.com/investing/how-to-invest/investors-like-me/",                                    year: "2022"),
            ModuleFootnote(id: "hw_12",  moduleId: "mod_women", number: "12",  title: "Fast Facts: Gender Pay Gap",                                                                  author: "AAUW",                                                                             source: nil,                                                           url: "https://www.aauw.org/resources/article/fast-facts-pay-gap/",                                         year: nil),
            ModuleFootnote(id: "hw_13",  moduleId: "mod_women", number: "13",  title: "American Express State of Women Owned Business Report",                                      author: "American Express",                                                                 source: nil,                                                           url: "https://www.mbda.gov/sites/default/files/media/files/2018/2018-state-of-women-owned-businesses-report.pdf", year: "2019"),
            ModuleFootnote(id: "hw_14",  moduleId: "mod_women", number: "14",  title: "Half of New US Entrepreneurs are Women, Leading a Creation Boom",                            author: "Alexandre Tanzi",                                                                  source: "Bloomberg",                                                   url: nil,                                                                                                   year: "2022"),
            ModuleFootnote(id: "hw_15a", moduleId: "mod_women", number: "15",  title: "Married Women's Property Act",                                                                author: "",                                                                                 source: nil,                                                           url: "https://en.wikipedia.org/wiki/Married_Women%27s_Property_Acts_in_the_United_States",                year: nil),
            ModuleFootnote(id: "hw_15b", moduleId: "mod_women", number: "15",  title: "Women's Legal Rights in Ancient Egypt",                                                       author: "Janet H. Johnson",                                                                 source: nil,                                                           url: "https://fathom.lib.uchicago.edu/1/777777190170/",                                                    year: nil),
            ModuleFootnote(id: "hw_16",  moduleId: "mod_women", number: "16",  title: "JP Morgan Chase",                                                                             author: "",                                                                                 source: nil,                                                           url: "https://en.wikipedia.org/wiki/JPMorgan_Chase",                                                       year: nil),
            ModuleFootnote(id: "hw_17",  moduleId: "mod_women", number: "17",  title: "Bank of America",                                                                             author: "",                                                                                 source: nil,                                                           url: "https://en.wikipedia.org/wiki/Bank_of_America",                                                      year: nil),
            ModuleFootnote(id: "hw_18",  moduleId: "mod_women", number: "18",  title: "Citigroup",                                                                                   author: "",                                                                                 source: nil,                                                           url: "https://en.wikipedia.org/wiki/Citigroup",                                                            year: nil),
            ModuleFootnote(id: "hw_19",  moduleId: "mod_women", number: "19",  title: "New Deal For Artists: an unearthed film on how arts funding should work",                    author: "",                                                                                 source: "The Guardian",                                                url: "https://www.theguardian.com/film/2021/may/19/new-deal-for-artists-documentary-orson-welles",         year: nil),
            ModuleFootnote(id: "hw_20",  moduleId: "mod_women", number: "20",  title: "The Feminine Mystique",                                                                       author: "Betty Friedan",                                                                    source: "W. W. Norton (ISBN: 0-393-32257-2), p. 60",                  url: nil,                                                                                                   year: "1963"),
            ModuleFootnote(id: "hw_21",  moduleId: "mod_women", number: "21",  title: "The Origins and Evolution of the Market for Mortgage-Backed Securities",                     author: "John J. McConnell and Stephen A. Buser",                                          source: "The Annual Review of Financial Economics",                    url: "https://krannert.purdue.edu/faculty/mcconnell/publications/The-Origins-and-Evolution-of-the-Market.pdf", year: "2011"),
            ModuleFootnote(id: "hw_22",  moduleId: "mod_women", number: "22",  title: "American Business History: A Very Short Introduction",                                       author: "Walter A. Friedman",                                                               source: "Oxford University Press (ISBN: 9780190622473)",               url: nil,                                                                                                   year: "2020"),
            ModuleFootnote(id: "hw_23",  moduleId: "mod_women", number: "23",  title: "SEC Harmonizes and Improves \"Patchwork\" Exempt Offering Framework",                       author: "Securities and Exchange Commission",                                               source: "SEC Press Release",                                           url: "https://www.sec.gov/news/press-release/2020-273",                                                    year: "2020"),
            ModuleFootnote(id: "hw_24",  moduleId: "mod_women", number: "24",  title: "COVID-19 and gender equality: Countering the regressive effects",                            author: "Anu Madgavkar, Olivia White, Mekala Krishnan, Deepa Mahajan, and Xavier Azcue",  source: "McKinsey Global Institute",                                   url: "https://www.mckinsey.com/featured-insights/future-of-work/covid-19-and-gender-equality-countering-the-regressive-effects", year: "2020")
        ],

        // ── Behavioral Economics (mod_behavioral) ───────────────────────────────
        // Source: Notion CSV export, Module tag "Behavioral Economics"
        // Data issues noted: citations 1, 7.1, 10 have URLs in title/author fields;
        // 19.1 and 19.4 are incomplete; 38 has no title/author (omitted).
        "mod_behavioral": [
            ModuleFootnote(id: "be_1",    moduleId: "mod_behavioral", number: "1",    title: "How Individualism Changed the Economy",                                                         author: "Kyla Scanlon",                                                                         source: "Kyla's Newsletter (Substack)",                                url: "https://kyla.substack.com/p/how-individualism-changed-the-economy",                           year: "2023"),
            ModuleFootnote(id: "be_2",    moduleId: "mod_behavioral", number: "2",    title: "Behavioral Economics in Philosophy of Economics",                                              author: "Erik Angner and George Loewenstein",                                                   source: "Handbook of the Philosophy of Science, pgs. 641–689",        url: "https://www.sciencedirect.com/science/article/abs/pii/B9780444516763500221",                year: "2012"),
            ModuleFootnote(id: "be_3",    moduleId: "mod_behavioral", number: "3",    title: "Behavioral Economics in Philosophy of Economics",                                              author: "Erik Angner and George Loewenstein",                                                   source: "Handbook of the Philosophy of Science, pgs. 641–689",        url: "https://www.sciencedirect.com/science/article/abs/pii/B9780444516763500221",                year: "2012"),
            ModuleFootnote(id: "be_4",    moduleId: "mod_behavioral", number: "4",    title: "Neuroeconomic Foundations of Economic Choice — Recent Advances",                             author: "Ernst Fehr and Antonio Rangel",                                                        source: "Journal of Economic Perspectives, Vol. 25, No. 4, pgs. 3–30", url: "https://www.rnl.caltech.edu/publications/pdf/fehr2011.pdf",                                  year: "2011"),
            ModuleFootnote(id: "be_5",    moduleId: "mod_behavioral", number: "5",    title: "Revealed Preference (Wikipedia)",                                                             author: "",                                                                                     source: nil,                                                           url: "https://en.wikipedia.org/wiki/Revealed_preference",                                          year: nil),
            ModuleFootnote(id: "be_6",    moduleId: "mod_behavioral", number: "6",    title: "The Brain that Changes Itself",                                                               author: "Norman Doidge, MD",                                                                    source: "pages 46–60",                                                 url: nil,                                                                                          year: "2007"),
            ModuleFootnote(id: "be_7_1",  moduleId: "mod_behavioral", number: "7.1",  title: "The prefrontal landscape: implications of functional architecture for understanding human mentation and the central executive", author: "Patricia Goldman-Rakic",                             source: nil,                                                           url: "https://pubmed.ncbi.nlm.nih.gov/8941956/",                                                   year: "1996"),
            ModuleFootnote(id: "be_7_2",  moduleId: "mod_behavioral", number: "7.2",  title: "Contributions of the amygdala to emotion processing: From animal models to human behavior", author: "Phelps, E. A., and LeDoux, J. E.",                                                     source: "Neuron, 48(2), 175–187",                                      url: nil,                                                                                          year: "2005"),
            ModuleFootnote(id: "be_7_3",  moduleId: "mod_behavioral", number: "7.3",  title: "Neuroscience: 5th Edition",                                                                   author: "Purves, D., Augustine, G. J., Fitzpatrick, D., Katz, L. C., LaMantia, A. S., and McNamara, J. O.", source: "Sinauer Associates, Inc. ISBN: 978-0878936953",  url: nil,                                                                                          year: "2011"),
            ModuleFootnote(id: "be_7_4",  moduleId: "mod_behavioral", number: "7.4",  title: "The Molecule of More",                                                                        author: "Daniel Z. Lieberman, MD, and Michael E. Long",                                         source: "BenBella Books, Dallas, TX",                                  url: nil,                                                                                          year: "2018"),
            ModuleFootnote(id: "be_8",    moduleId: "mod_behavioral", number: "8",    title: "The Brain that Changes Itself",                                                               author: "Norman Doidge, MD",                                                                    source: "pages 46–60",                                                 url: nil,                                                                                          year: "2007"),
            ModuleFootnote(id: "be_9",    moduleId: "mod_behavioral", number: "9",    title: "A Course in Behavioral Economics: Second Edition",                                            author: "Erik Angner",                                                                          source: "page 25",                                                     url: nil,                                                                                          year: "2016"),
            ModuleFootnote(id: "be_10",   moduleId: "mod_behavioral", number: "10",   title: "Behavioral Economics (International Encyclopedia of the Social and Behavioral Sciences)",    author: "S. Mullainathan, R.H. Thaler",                                                         source: "Pages 1094–1100",                                             url: "https://www.sciencedirect.com/science/article/pii/B0080430767022476",                        year: "2001"),
            ModuleFootnote(id: "be_11_1", moduleId: "mod_behavioral", number: "11.1", title: "Confirmation Bias: A Ubiquitous Phenomenon in Many Guises",                                  author: "Raymond S. Nickerson",                                                                 source: "Review of General Psychology, 1998",                          url: "https://journals.sagepub.com/doi/10.1037/1089-2680.2.2.175",                                year: "1998"),
            ModuleFootnote(id: "be_11_2", moduleId: "mod_behavioral", number: "11.2", title: "Judgment under Uncertainty: Heuristics and Biases",                                          author: "Amos Tversky and Daniel Kahneman",                                                     source: "Science, 1974",                                               url: "https://www.science.org/doi/10.1126/science.185.4157.1124",                                  year: "1974"),
            ModuleFootnote(id: "be_11_3", moduleId: "mod_behavioral", number: "11.3", title: "The Overconfidence Effect in Social Prediction",                                             author: "Baruch Fischhoff, Paul Slovic, and Sarah Lichtenstein",                                source: "Journal of Personality and Social Psychology",                url: "https://psycnet.apa.org/record/1990-22524-001",                                              year: "1977"),
            ModuleFootnote(id: "be_12",   moduleId: "mod_behavioral", number: "12",   title: "Confirmation Bias: A Ubiquitous Phenomenon in Many Guises",                                  author: "Raymond S. Nickerson",                                                                 source: "Review of General Psychology, Vol. 2, No. 2, pgs. 175–176",  url: nil,                                                                                          year: "1998"),
            ModuleFootnote(id: "be_13",   moduleId: "mod_behavioral", number: "13",   title: "Economics and Gender Equality: A Lens from Within",                                          author: "Leonora Risse",                                                                        source: "Capitalism and Society, Vol. 14, Issue 1, Article 1",        url: "https://projects.iq.harvard.edu/files/wappp/files/risse_2019_economics_and_gender_equality_-_a_lens_from_within_capitalism_and_society.pdf", year: "2019"),
            ModuleFootnote(id: "be_14",   moduleId: "mod_behavioral", number: "14",   title: "Gender Quotas and the Crisis of the Mediocre Man: Theory and Evidence from Sweden",         author: "Timothy Besley, Olle Folke, Torsten Persson, Johanna Rickne",                         source: "American Economic Review, Vol. 107, No. 8, pgs. 2204–42",    url: "https://eprints.lse.ac.uk/69193/1/Besley_Gender%20quotas_2017.pdf",                          year: "2017"),
            ModuleFootnote(id: "be_15",   moduleId: "mod_behavioral", number: "15",   title: "The Brain that Changes Itself",                                                               author: "Norman Doidge, MD",                                                                    source: "pages 46–60",                                                 url: nil,                                                                                          year: "2007"),
            ModuleFootnote(id: "be_16",   moduleId: "mod_behavioral", number: "16",   title: "Neoclassical Finance: Alternative Finance and the Closed End Fund Puzzle",                   author: "Stephen A. Ross",                                                                      source: "European Financial Management, Vol. 8, No. 2, 2002, pgs. 129–137", url: nil,                                                                                       year: "2002"),
            ModuleFootnote(id: "be_17",   moduleId: "mod_behavioral", number: "17",   title: "Boys Will Be Boys: Gender, Overconfidence, and Common Stock Investment",                     author: "Brad M. Barber and Terrance Odean",                                                    source: "The Quarterly Journal of Economics, Feb 2001, pgs. 261–289",  url: "https://faculty.haas.berkeley.edu/odean/papers/gender/BoysWillBeBoys.pdf",                   year: "2001"),
            ModuleFootnote(id: "be_18",   moduleId: "mod_behavioral", number: "18",   title: "Gambling With the House Money and Trying to Break Even: The Effects of Prior Outcomes on Risky Choice", author: "Richard H. Thaler and Eric J. Johnson",                      source: "Management Science, 36(6):643–660",                           url: "https://www.researchgate.net/publication/227344939_Gambling_With_the_House_Money_and_Trying_to_Break_Even_The_Effects_of_Prior_Outcomes_on_Risky_Choice", year: "1990"),
            ModuleFootnote(id: "be_19_1", moduleId: "mod_behavioral", number: "19.1", title: "Intuitive prediction: Biases and corrective procedures",                                     author: "",                                                                                     source: nil,                                                           url: nil,                                                                                          year: nil),
            ModuleFootnote(id: "be_19_2", moduleId: "mod_behavioral", number: "19.2", title: "The Trouble With Overconfidence",                                                             author: "Don A. Moore and Paul J. Healy",                                                       source: "Psychological Review, 2008, Vol. 115, No. 2, pgs. 502–517",  url: "https://www.asc.ohio-state.edu/economics/healy/papers/Moore_Healy-TroubleWithOverconfidence.pdf", year: "2008"),
            ModuleFootnote(id: "be_19_3", moduleId: "mod_behavioral", number: "19.3", title: "How unrealistic optimism is maintained in the face of reality",                              author: "Sharot, T., Korn, C. W., & Dolan, R. J.",                                             source: "Nature Neuroscience, 14(11), pgs. 1475–1479",                 url: nil,                                                                                          year: "2011"),
            ModuleFootnote(id: "be_19_4", moduleId: "mod_behavioral", number: "19.4", title: "Lake Wobegon Effect",                                                                         author: "",                                                                                     source: nil,                                                           url: "https://www.oxfordreference.com/display/10.1093/oi/authority.20110810105237549",             year: nil),
            ModuleFootnote(id: "be_19_5", moduleId: "mod_behavioral", number: "19.5", title: "Anchoring and Overconfidence: The Influence of Culture and Cognitive Abilities",             author: "Monika Czerwonka",                                                                     source: "International Journal of Management and Economics, 53(3)",   url: "https://www.researchgate.net/publication/320591316_Anchoring_and_Overconfidence_The_Influence_of_Culture_and_Cognitive_Abilities", year: "2017"),
            ModuleFootnote(id: "be_20",   moduleId: "mod_behavioral", number: "20",   title: "Implicit Bias: Scientific Foundations",                                                       author: "Anthony G. Greenwald and Linda Hamilton Krieger",                                      source: "California Law Review, Vol. 94, No. 4",                       url: "https://lawcat.berkeley.edu/record/1120596",                                                 year: "2006"),
            ModuleFootnote(id: "be_21",   moduleId: "mod_behavioral", number: "21",   title: "How Subtle Is Anchoring?",                                                                    author: "Fritz Strack and Thomas Mussweiler",                                                   source: "Journal of Experimental Psychology: General, 117(2), pgs. 134–148", url: "https://bear.warrington.ufl.edu/brenner/mar7588/Papers/strack-mussweiler-jpsp97.pdf",      year: "1997"),
            ModuleFootnote(id: "be_22",   moduleId: "mod_behavioral", number: "22",   title: "Prospect Theory: An Analysis of Decision under Risk",                                        author: "Daniel Kahneman and Amos Tversky",                                                     source: "Econometrica, Vol. 47, No. 2, pgs. 263–292",                 url: "https://www.jstor.org/stable/i332789",                                                       year: "1979"),
            ModuleFootnote(id: "be_23",   moduleId: "mod_behavioral", number: "23",   title: "Advances in prospect theory: Cumulative representation of uncertainty",                      author: "Amos Tversky and Daniel Kahneman",                                                     source: "Journal of Risk and Uncertainty, Vol. 5, pgs. 297–323",      url: "https://link.springer.com/article/10.1007/BF00122574",                                      year: "1992"),
            ModuleFootnote(id: "be_24",   moduleId: "mod_behavioral", number: "24",   title: "Does the Stock Market Overreact?",                                                            author: "Werner F.M. DeBondt and Richard Thaler",                                               source: nil,                                                           url: "https://onlinelibrary.wiley.com/doi/full/10.1111/j.1540-6261.1985.tb05004.x",               year: "1985"),
            ModuleFootnote(id: "be_25",   moduleId: "mod_behavioral", number: "25",   title: "The Use of Pledges to Build and Sustain Commitment in Distribution Channels",                author: "Erin Anderson and Barton Weitz",                                                       source: "Journal of Marketing Research, Vol. 29, No. 1, pgs. 18–34",  url: "https://www.jstor.org/stable/3172490",                                                       year: "1992"),
            ModuleFootnote(id: "be_26",   moduleId: "mod_behavioral", number: "26",   title: "Anomalies: The Endowment Effect, Loss Aversion, and Status Quo Bias",                        author: "Daniel Kahneman, Jack L. Knetsch, and Richard H. Thaler",                             source: "Journal of Economic Perspectives, Vol. 5, No. 1",            url: "https://pubs.aeaweb.org/doi/pdf/10.1257/jep.5.1.193",                                       year: "1991"),
            ModuleFootnote(id: "be_27_1", moduleId: "mod_behavioral", number: "27.1", title: "Prospect Theory: An Analysis of Decision under Risk",                                        author: "Daniel Kahneman and Amos Tversky",                                                     source: "Econometrica, Vol. 47, No. 2, pgs. 263–292",                 url: "https://www.jstor.org/stable/i332789",                                                       year: "1979"),
            ModuleFootnote(id: "be_27_2", moduleId: "mod_behavioral", number: "27.2", title: "Advances in prospect theory: Cumulative representation of uncertainty",                      author: "Amos Tversky and Daniel Kahneman",                                                     source: "Journal of Risk and Uncertainty, Vol. 5, pgs. 297–323",      url: "https://link.springer.com/article/10.1007/BF00122574",                                      year: "1992"),
            ModuleFootnote(id: "be_27_3", moduleId: "mod_behavioral", number: "27.3", title: "The disposition to sell winners too early and ride losers too long: Theory and evidence",    author: "Hersh Shefrin and Meir Statman",                                                       source: "The Journal of Finance, 40(3), 777–790",                      url: "https://people.bath.ac.uk/mnsrf/Teaching%202011/Shefrin-Statman-85.pdf",                    year: "1985"),
            ModuleFootnote(id: "be_27_4", moduleId: "mod_behavioral", number: "27.4", title: "Choice in context: Tradeoff contrast and extremeness aversion",                              author: "Itamar Simonson and Amos Tversky",                                                     source: "Journal of Marketing Research, 29(3), 281–295",              url: "https://www.gsb.stanford.edu/faculty-research/publications/choice-context-tradeoff-contrast-extremeness-aversion", year: "1992"),
            ModuleFootnote(id: "be_28",   moduleId: "mod_behavioral", number: "28",   title: "The Psychological and Neural Basis of Loss Aversion",                                        author: "Peter Sokol-Hessner and Robb B. Rutledge",                                            source: nil,                                                           url: "https://journals.sagepub.com/doi/full/10.1177/0963721418806510",                            year: "2018"),
            ModuleFootnote(id: "be_29",   moduleId: "mod_behavioral", number: "29",   title: "Neural markers of loss aversion in resting-state brain activity",                            author: "Nicola Canessa, Chiara Crespi, Gabriel Baud-Bovy, Alessandra Dodich, Andrea Falini, Giulia Antonellis, and Stefano F Cappa", source: "Neuroimage. 2017 Feb 1;146:257–265", url: "https://pubmed.ncbi.nlm.nih.gov/27884798/",                                                year: nil),
            ModuleFootnote(id: "be_30",   moduleId: "mod_behavioral", number: "30",   title: "Amygdala damage eliminates monetary loss aversion",                                           author: "Benedetto De Martino, Colin F. Camerer and Ralph Adolphs",                            source: nil,                                                           url: "https://www.pnas.org/doi/abs/10.1073/pnas.0910230107",                                       year: nil),
            ModuleFootnote(id: "be_31",   moduleId: "mod_behavioral", number: "31",   title: "Emotion-induced loss aversion and striatal-amygdala coupling in low-anxious individuals",   author: "Caroline J Charpentier, Benedetto De Martino, Alena L Sim, Tali Sharot and Jonathan P Roiser", source: nil,                                         url: "https://pubmed.ncbi.nlm.nih.gov/26589451/",                                                 year: nil),
            ModuleFootnote(id: "be_32",   moduleId: "mod_behavioral", number: "32",   title: "On the descriptive value of loss aversion in decisions under risk: Six clarifications",     author: "Eyal Ert and Ido Erev",                                                                source: "Judgment and Decision Making, Vol. 8, No. 3, pp. 214–235",   url: "https://www.cambridge.org/core/services/aop-cambridge-core/content/view/A66ABDA683DC4437404217BF9BA63C47/S1930297500005945a.pdf/on_the_descriptive_value_of_loss_aversion_in_decisions_under_risk_six_clarifications.pdf", year: "2013"),
            ModuleFootnote(id: "be_33",   moduleId: "mod_behavioral", number: "33",   title: "Is loss-aversion magnitude-dependent? Measuring prospective affective judgments regarding gains and losses", author: "Sumitava Mukherjee, Arvind Sahay, V. S. Chandrasekhar and Pammi Narayanan Srinivasan", source: nil,                              url: "https://www.researchgate.net/publication/313421907_Is_loss-aversion_magnitude-dependent_Measuring_prospective_affective_judgments_regarding_gains_and_losses", year: "2017"),
            ModuleFootnote(id: "be_34",   moduleId: "mod_behavioral", number: "34",   title: "The Framing of Decisions and the Psychology of Choice",                                      author: "Amos Tversky and Daniel Kahneman",                                                     source: "Science, Vol. 211, No. 4481, pp. 453–458",                   url: nil,                                                                                          year: "1981"),
            ModuleFootnote(id: "be_35",   moduleId: "mod_behavioral", number: "35",   title: "The Difference: How the Power of Diversity Creates Better Groups, Firms, Schools, and Societies", author: "Scott E. Page",                                                    source: "Princeton University Press",                                  url: nil,                                                                                          year: "2007"),
            ModuleFootnote(id: "be_36",   moduleId: "mod_behavioral", number: "36",   title: "Heuristics and Biases: The Psychology of Intuitive Judgment",                                author: "Thomas Gilovich, Dale Griffin, Daniel Kahneman",                                       source: nil,                                                           url: "https://assets.cambridge.org/97805217/92608/sample/9780521792608ws.pdf",                    year: "2022"),
            ModuleFootnote(id: "be_37",   moduleId: "mod_behavioral", number: "37",   title: "Big Thinkers: Thomas Beauchamp & James Childress",                                           author: "Thomas L Beauchamp and James F Childress",                                             source: nil,                                                           url: "https://ethics.org.au/big-thinkers-thomas-beauchamp-james-childress/",                      year: "2017")
        ],

        "mod_defi": [
            ModuleFootnote(id: "defi_1",    moduleId: "mod_defi", number: "1",    title: "Cryptocurrencies, Decentralized Finance, and Key Lessons from the 2008 Financial Crisis", author: "Michael Hsu",                                                                          source: nil,                                                           url: "https://www.occ.gov/news-issuances/speeches/2021/pub-speech-2021-101.pdf",                  year: "2021"),
            ModuleFootnote(id: "defi_2",    moduleId: "mod_defi", number: "2",    title: "Regulating Crypto Assets: Securities and Commodities",                                        author: "Amy Aixi Zhang",                                                                       source: "Harvard Law School",                                          url: "https://projects.iq.harvard.edu/files/financialregulation/files/digital_assets_case_study.pdf", year: "2020"),
            ModuleFootnote(id: "defi_3",    moduleId: "mod_defi", number: "3",    title: "Why Web3 Matters",                                                                            author: "Chris Dixon",                                                                          source: nil,                                                           url: "https://a16zcrypto.com/posts/article/why-web3-matters/",                                    year: "2021"),
            ModuleFootnote(id: "defi_4",    moduleId: "mod_defi", number: "4",    title: "Decentralized Finance Analysis: How to Identify Value within Crypto Ecosystem",              author: "John Robison, Aryan Sheikhalian and Alex Tapscott",                                    source: nil,                                                           url: "https://www.blockchainresearchinstitute.org/project/decentralized-finance-analysis/",       year: "2023"),
            ModuleFootnote(id: "defi_5",    moduleId: "mod_defi", number: "5",    title: "What Is DeFi? Understanding Decentralized Finance",                                          author: "E. Napoletano",                                                                        source: nil,                                                           url: "https://www.forbes.com/advisor/investing/cryptocurrency/defi-decentralized-finance/",       year: "2023"),
            ModuleFootnote(id: "defi_6",    moduleId: "mod_defi", number: "6",    title: "Decentralized Finance—A Systematic Literature Review and Research Directions",               author: "Eva Meyer, Isabell M. Welpe and Philipp G. Sandner",                                   source: nil,                                                           url: "https://papers.ssrn.com/sol3/papers.cfm?abstract_id=4016497",                               year: "2022"),
            ModuleFootnote(id: "defi_7",    moduleId: "mod_defi", number: "7",    title: "DeFi deciphered: Navigating disruption within financial services",                           author: "Deloitte",                                                                             source: nil,                                                           url: "https://www2.deloitte.com/content/dam/Deloitte/us/Documents/risk/us-financial-advisory-defi-march-2022.pdf", year: "2022"),
            ModuleFootnote(id: "defi_8",    moduleId: "mod_defi", number: "8",    title: "Proof-of-Work vs. Proof-of-Stake: What Is the Difference?",                                 author: "Mike Antolin",                                                                         source: nil,                                                           url: "https://www.coindesk.com/learn/proof-of-work-vs-proof-of-stake-what-is-the-difference/",    year: "2023"),
            ModuleFootnote(id: "defi_9",    moduleId: "mod_defi", number: "9",    title: "Decentralized Finance: (DeFi) Policy-Maker Toolkit",                                         author: "World Economic Forum",                                                                 source: nil,                                                           url: "https://www.weforum.org/publications/decentralized-finance-defi-policy-maker-toolkit",       year: "2021"),
            ModuleFootnote(id: "defi_10",   moduleId: "mod_defi", number: "10",   title: "Demystifying DeFi tax",                                                                       author: "PwC",                                                                                  source: nil,                                                           url: "https://www.pwc.com/us/en/services/tax/library/demystifying-defi-tax.html",                 year: "2022"),
            ModuleFootnote(id: "defi_11",   moduleId: "mod_defi", number: "11",   title: "The Technology of Decentralized Finance (DeFi)",                                             author: "Raphael Auer, Bernhard Haslhofer, Stefan Kitzler, Pietro Saggese and Friedhelm Victor", source: nil,                                                          url: "https://www.bis.org/publ/work1066.htm",                                                      year: "2023"),
            ModuleFootnote(id: "defi_12",   moduleId: "mod_defi", number: "12",   title: "DeFi Beyond the Hype: The Emerging World of Decentralized Finance",                          author: "Wharton Blockchain and Digital Asset Project, in collaboration with the World Economic Forum", source: nil,                                                     url: "https://wifpr.wharton.upenn.edu/wp-content/uploads/2021/05/DeFi-Beyond-the-Hype.pdf",       year: "2021"),
            ModuleFootnote(id: "defi_13",   moduleId: "mod_defi", number: "13",   title: "DeFi: The Basics",                                                                            author: "Christian Hazim & Rohan Reddy",                                                        source: nil,                                                           url: "https://www.nasdaq.com/articles/defi%3A-the-basics",                                         year: "2022"),
            ModuleFootnote(id: "defi_13_1", moduleId: "mod_defi", number: "13.1", title: "Smart Contract",                                                                               author: "Wikipedia",                                                                            source: nil,                                                           url: "https://en.wikipedia.org/wiki/Smart_contract",                                               year: nil),
            ModuleFootnote(id: "defi_14",   moduleId: "mod_defi", number: "14",   title: "What is a DeFi Oracle? – DeFi Oracles Explained",                                            author: "Streamflow Finance",                                                                   source: nil,                                                           url: "https://blog.streamflow.finance/defi-oracle/",                                               year: nil),
            ModuleFootnote(id: "defi_15",   moduleId: "mod_defi", number: "15",   title: "Decentralized Autonomous Organization (DAO): Definition, Purpose, and Example",              author: "Nathan Reiff",                                                                         source: nil,                                                           url: "https://www.investopedia.com/tech/what-dao/",                                                year: "2023"),
            ModuleFootnote(id: "defi_16",   moduleId: "mod_defi", number: "16",   title: "The Latecomer's Guide to Crypto: What are DAOs?",                                             author: "Kevin Roose",                                                                          source: nil,                                                           url: "https://www.nytimes.com/interactive/2022/03/18/technology/what-are-daos.html",               year: nil),
            ModuleFootnote(id: "defi_17",   moduleId: "mod_defi", number: "17",   title: "Cryptocurrency vs Token",                                                                     author: "True Tamplin",                                                                         source: nil,                                                           url: "https://www.financestrategists.com/wealth-management/cryptocurrency/cryptocurrency-vs-token/", year: "2023"),
            ModuleFootnote(id: "defi_18",   moduleId: "mod_defi", number: "18",   title: "Guide to DeFi tokens and altcoins",                                                           author: "Coinbase",                                                                             source: nil,                                                           url: "https://www.coinbase.com/learn/crypto-basics/defi-tokens-and-altcoins",                      year: nil),
            ModuleFootnote(id: "defi_19",   moduleId: "mod_defi", number: "19",   title: "Central Bank Digital Currency Global Interoperability Principles",                            author: "World Economic Forum",                                                                 source: nil,                                                           url: "https://www3.weforum.org/docs/WEF_Central_Bank_Digital_Currency_Global_Interoperability_Principles_2023.pdf", year: "2023"),
            ModuleFootnote(id: "defi_20",   moduleId: "mod_defi", number: "20",   title: "Committee on Payments and Market Infrastructures: Central Bank Digital Currencies",          author: "Bank for International Settlements",                                                   source: nil,                                                           url: "https://www.bis.org/cpmi/publ/d174.pdf",                                                     year: "2018"),
            ModuleFootnote(id: "defi_21",   moduleId: "mod_defi", number: "21",   title: "DeFi Beyond the Hype: The Emerging World of Decentralized Finance",                          author: "Wharton Blockchain and Digital Asset Project",                                         source: nil,                                                           url: "https://wifpr.wharton.upenn.edu/wp-content/uploads/2021/05/DeFi-Beyond-the-Hype.pdf",       year: "2021"),
            ModuleFootnote(id: "defi_22",   moduleId: "mod_defi", number: "22",   title: "The Latecomer's Guide to Crypto",                                                             author: "Kevin Roose",                                                                          source: nil,                                                           url: "https://www.nytimes.com/interactive/2022/03/18/technology/cryptocurrency-crypto-guide.html", year: "2022"),
            ModuleFootnote(id: "defi_23",   moduleId: "mod_defi", number: "23",   title: "The Code That Controls Your Money",                                                           author: "Clive Thompson",                                                                       source: nil,                                                           url: "https://www.wealthsimple.com/en-ca/magazine/cobol-controls-your-money",                      year: "2020")
        ],

        "mod_art": [
            ModuleFootnote(id: "art_1",  moduleId: "mod_art", number: "1",  title: "3 Essential Skills for Success in the Alternative Investments Industry",                      author: "Tim Stobierski",                                                                       source: nil,                                                           url: "https://online.hbs.edu/blog/post/alternative-investment-skills",                            year: "2021"),
            ModuleFootnote(id: "art_2",  moduleId: "mod_art", number: "2",  title: "UBS Art Basel Art Market Report 2023",                                                        author: "UBS and Clare McAndrew",                                                               source: nil,                                                           url: "https://www.ubs.com/global/en/our-firm/art/collecting/art-market-survey.html",              year: "2023"),
            ModuleFootnote(id: "art_3",  moduleId: "mod_art", number: "3",  title: "Art Basel Market Report 2020",                                                                author: "Art Basel",                                                                            source: nil,                                                           url: "https://www.artbasel.com/stories/art-market-report-1",                                      year: "2020"),
            ModuleFootnote(id: "art_4",  moduleId: "mod_art", number: "4",  title: "ArtTactic Auction Review",                                                                    author: "Lindsay Dewar",                                                                        source: nil,                                                           url: "https://arttactic.com/product/auction-review-1st-half-2020/",                               year: "2020"),
            ModuleFootnote(id: "art_5",  moduleId: "mod_art", number: "5",  title: "Alternative Investments Improving Portfolio Performance",                                      author: "UBS",                                                                                  source: nil,                                                           url: "https://www.ubs.com/global/en/assetmanagement/insights/asset-class-perspectives/asset-allocation/articles/alternative-investments.html", year: "2021"),
            ModuleFootnote(id: "art_6",  moduleId: "mod_art", number: "6",  title: "Businessman Identified As Buyer of van Gogh",                                                 author: "Rita Reif",                                                                            source: nil,                                                           url: "https://www.nytimes.com/1990/05/18/arts/businessman-identified-as-buyer-of-van-gogh.html",  year: "1990"),
            ModuleFootnote(id: "art_7",  moduleId: "mod_art", number: "7",  title: "JPG File Sells for $69 Million, as 'NFT Mania' Gathers Pace",                               author: "Scott Reyburn",                                                                        source: nil,                                                           url: "https://www.nytimes.com/2021/03/11/arts/design/nft-auction-christies-beeple.html",          year: "2021"),
            ModuleFootnote(id: "art_8",  moduleId: "mod_art", number: "8",  title: "Crypto Whale Behind $69 Million NFT Sees 'Huge Risk' for Traders",                          author: "Joanna Ossinger",                                                                      source: nil,                                                           url: "https://www.bloomberg.com/news/articles/2021-04-06/crypto-whale-behind-69-million-nft-sees-huge-risk-for-traders", year: "2021"),
            ModuleFootnote(id: "art_9",  moduleId: "mod_art", number: "9",  title: "Five years since the $450m Salvator Mundi sale: a first-hand account",                     author: "Scott Reyburn",                                                                        source: nil,                                                           url: "https://www.theartnewspaper.com/2022/11/15/five-years-since-the-450m-salvator-mundi-sale-a-first-hand-account-of-the-nonsensical-auction", year: "2022"),
            ModuleFootnote(id: "art_10", moduleId: "mod_art", number: "10", title: "Mystery Buyer of $450 Million 'Salvator Mundi' Was a Saudi Prince",                        author: "David D. Kirkpatrick",                                                                 source: nil,                                                           url: "https://www.nytimes.com/2017/12/06/world/middleeast/salvator-mundi-da-vinci-saudi-prince-bader.html", year: "2017"),
            ModuleFootnote(id: "art_11", moduleId: "mod_art", number: "11", title: "A Clash of Wills Keeps a Leonardo Masterpiece Hidden",                                       author: "David D. Kirkpatrick and Elaine Sciolino",                                             source: nil,                                                           url: "https://www.nytimes.com/2021/04/11/arts/design/salvator-mundi-louvre-leonardo.html",        year: "2021"),
            ModuleFootnote(id: "art_12", moduleId: "mod_art", number: "12", title: "Winning Bidder for Shredded Banksy Painting Says She'll Keep It",                           author: "Scott Reyburn",                                                                        source: nil,                                                           url: "https://www.nytimes.com/2018/10/11/arts/design/winning-bidder-for-shredded-banksy-painting-says-shell-keep-it.html", year: "2018"),
            ModuleFootnote(id: "art_13", moduleId: "mod_art", number: "13", title: "Why putting £1m through the shredder is Banksy's greatest work",                            author: "Jonathan Jones",                                                                       source: nil,                                                           url: "https://www.theguardian.com/artanddesign/2018/oct/08/why-shredder-is-banksy-greatest-work",  year: "2018"),
            ModuleFootnote(id: "art_14", moduleId: "mod_art", number: "14", title: "Banksy's Shredding Artwork Is Auctioned for $25.4 Million at Sotheby's",                   author: "Scott Reyburn",                                                                        source: nil,                                                           url: "https://www.nytimes.com/2021/10/14/arts/design/banksy-art-sothebys-auction.html",           year: "2021"),
            ModuleFootnote(id: "art_15", moduleId: "mod_art", number: "15", title: "Cultural Economics",                                                                          author: "Wikipedia",                                                                            source: nil,                                                           url: nil,                                                                                          year: nil),
            ModuleFootnote(id: "art_16", moduleId: "mod_art", number: "16", title: "British Pension Fund Sells $65.6 Million in Artworks",                                       author: "Terry Trucco",                                                                         source: nil,                                                           url: "https://www.nytimes.com/1989/04/05/arts/british-pension-fund-sells-65.6-million-in-artworks.html", year: "1989"),
            ModuleFootnote(id: "art_17", moduleId: "mod_art", number: "17", title: "Art as an Investment",                                                                        author: "Britannica",                                                                           source: nil,                                                           url: "https://www.britannica.com/money/topic/art-market/Art-as-investment",                        year: nil),
            ModuleFootnote(id: "art_19", moduleId: "mod_art", number: "19", title: "Fine Art and High Finance: Expert Advice on the Economics of Ownership (Chapter 6)",        author: "Jeremy Eckstein and Randall Willette",                                                 source: "Bloomberg Press New York",                                    url: nil,                                                                                          year: "2010"),
            ModuleFootnote(id: "art_20", moduleId: "mod_art", number: "20", title: "The Complete Spot Paintings 1986–2011",                                                       author: "Damien Hirst",                                                                         source: nil,                                                           url: "https://gagosian.com/exhibitions/2012/damien-hirst-the-complete-spot-paintings-1986-2011-new-york/", year: "2012"),
            ModuleFootnote(id: "art_21", moduleId: "mod_art", number: "21", title: "Life With Picasso",                                                                           author: "Françoise Gilot",                                                                      source: nil,                                                           url: nil,                                                                                          year: "2015"),
            ModuleFootnote(id: "art_22", moduleId: "mod_art", number: "22", title: "Kunstmuseum Bern to Return Seven Works from Gurlitt Trove",                                  author: "Angelica Villa",                                                                       source: nil,                                                           url: "https://www.artnews.com/art-news/news/kunstmuseum-bern-returns-gurlitt-collection-works-1234613181/", year: "2021"),
            ModuleFootnote(id: "art_23", moduleId: "mod_art", number: "23", title: "Contested Modigliani seized from freeport as Swiss open investigation",                      author: "Martha M. Hamilton",                                                                   source: nil,                                                           url: "https://www.icij.org/investigations/panama-papers/swiss-art-freeport-search/",               year: "2016"),
            ModuleFootnote(id: "art_24", moduleId: "mod_art", number: "24", title: "Warhol After Warhol: Secrets, Lies, and Corruption in the Art World",                       author: "Richard Dorment",                                                                      source: "Pegasus Books",                                               url: nil,                                                                                          year: "2023"),
            ModuleFootnote(id: "art_25", moduleId: "mod_art", number: "25", title: "Appraisers Association of America",                                                           author: "",                                                                                     source: nil,                                                           url: "https://appraisersassociation.org",                                                          year: nil),
            ModuleFootnote(id: "art_26", moduleId: "mod_art", number: "26", title: "The Art Collector's Handbook: The Definitive Guide to Acquiring and Owning Art",             author: "Mary Rozell",                                                                          source: nil,                                                           url: nil,                                                                                          year: "2020")
        ],

        "mod_gender": [
            ModuleFootnote(id: "gen_1",   moduleId: "mod_gender", number: "1",   title: "Women Are 'Claiming Their Power' in Investment Clubs of Their Own",                     author: "Joshua Brockman",                                                                      source: nil,                                                           url: "https://www.nytimes.com/2020/04/24/business/women-investing-clubs-retirement.html",          year: "2020"),
            ModuleFootnote(id: "gen_2",   moduleId: "mod_gender", number: "2",   title: "2022 Proxy Preview",                                                                     author: "As You Sow",                                                                           source: "As You Sow, Sustainable Investments Institute, and Proxy Impact", url: "https://www.asyousow.org/reports/proxy-preview-2022",                                      year: nil),
            ModuleFootnote(id: "gen_3",   moduleId: "mod_gender", number: "3",   title: "Wake up and see the women: Wealth management's underserved segment",                    author: "McKinsey and Company",                                                                 source: nil,                                                           url: "https://www.mckinsey.com/industries/financial-services/our-insights/wake-up-and-see-the-women-wealth-managements-underserved-segment", year: "2020"),
            ModuleFootnote(id: "gen_4",   moduleId: "mod_gender", number: "4",   title: "Sustainable Signals: Individual Investor Interest Driven by Impact, Conviction and Choice", author: "Morgan Stanley Institute for Sustainable Investing",                                source: nil,                                                           url: "https://www.morganstanley.com/pub/content/dam/msdotcom/infographics/sustainable-investing/Sustainable_Signals_Individual_Investor_White_Paper_Final.pdf", year: nil),
            ModuleFootnote(id: "gen_4_1", moduleId: "mod_gender", number: "4.1", title: "Project Sage: Tracking Venture Capital, Private Equity and Private Debt with Women Leaders", author: "Suzanne Biegel, Maoz (Michael) Brown, and Sandi M. Hunt",                         source: nil,                                                           url: "https://issuu.com/whartonsocialimpact/docs/sage4.0_report_2021_final",                       year: "2019"),
            ModuleFootnote(id: "gen_5",   moduleId: "mod_gender", number: "5",   title: "Foundations of ESG Investing: How ESG Affects Equity Valuation, Risk, and Performance", author: "",                                                                                     source: nil,                                                           url: "https://www.researchgate.net/publication/334158531_Foundations_of_ESG_Investing_How_ESG_Affects_Equity_Valuation_Risk_and_Performance", year: nil),
            ModuleFootnote(id: "gen_6",   moduleId: "mod_gender", number: "6",   title: "Why Gender Diversity Matters",                                                           author: "Laura Sherbin and Ripa Rashid",                                                        source: "Harvard Business Review",                                     url: "https://hbr.org/2017/02/diversity-doesnt-stick-without-inclusion",                           year: "2017"),
            ModuleFootnote(id: "gen_7",   moduleId: "mod_gender", number: "7",   title: "Women, Millennials, and Investing for Impact: How Gender and Generation Could Help Reshape the World", author: "Jackie VanderBrug",                                                  source: nil,                                                           url: "https://investmentsandwealth.org/getattachment/b26c6e74-3d7a-4af3-8874-746f56fd7419/IWM17NovDec-WomenMillennialsInvestingForImpact.pdf", year: "2017"),
            ModuleFootnote(id: "gen_8",   moduleId: "mod_gender", number: "8",   title: "Gender differences in financial risk taking: The role of financial literacy and risk tolerance", author: "Christina E. Bannier and Milena Neubert",                                      source: "Economics Letters, Volume 145, August 2016, Pages 130–135",  url: "https://www.sciencedirect.com/science/article/abs/pii/S0165176516301999",                   year: nil),
            ModuleFootnote(id: "gen_9",   moduleId: "mod_gender", number: "9",   title: "ESG Investing Through the Gender Lens",                                                   author: "MSCI",                                                                                 source: nil,                                                           url: "https://www.msci.com",                                                                       year: "2019"),
            ModuleFootnote(id: "gen_10",  moduleId: "mod_gender", number: "10",  title: "What is Impact Investing?",                                                               author: "Global Impact Investing Network",                                                       source: nil,                                                           url: "https://thegiin.org/impact-investing/",                                                      year: nil),
            ModuleFootnote(id: "gen_11",  moduleId: "mod_gender", number: "11",  title: "Morgan Stanley Pulse Report",                                                             author: "Morgan Stanley Wealth Management",                                                      source: nil,                                                           url: "https://www.morganstanley.com/content/dam/msdotcom/en/assets/pdfs/CRC-4983257-2022-US-Investor-Pulse-Poll-Women-Report.pdf", year: "2022"),
            ModuleFootnote(id: "gen_12",  moduleId: "mod_gender", number: "12",  title: "Principles for Responsible Investing",                                                    author: "",                                                                                     source: nil,                                                           url: "https://www.unpri.org/sustainability-issues/environmental-social-and-governance-issues/environmental-issues", year: nil),
            ModuleFootnote(id: "gen_13",  moduleId: "mod_gender", number: "13",  title: "The Impact Investor: Lessons in Leadership and Strategy for Collaborative Capitalism",   author: "Cathy Clark, Jed Emerson, and Ben Thornley",                                          source: "Jossey-Bass",                                                 url: nil,                                                                                          year: "2014"),
            ModuleFootnote(id: "gen_14",  moduleId: "mod_gender", number: "14",  title: "Fund of Funds (FOF) Explained: How It Works, Pros & Cons, Example",                     author: "James Chen",                                                                           source: nil,                                                           url: "https://www.investopedia.com/terms/f/fundsoffunds.asp",                                      year: "2022"),
            ModuleFootnote(id: "gen_15",  moduleId: "mod_gender", number: "15",  title: "Community Development Financial Institution (CDFI) program evaluation",                  author: "Jamie R. McCall and Michele M. Hoyman",                                                source: nil,                                                           url: "https://www.tandfonline.com/doi/abs/10.1080/15575330.2021.1976807",                          year: "2021"),
            ModuleFootnote(id: "gen_16",  moduleId: "mod_gender", number: "16",  title: "The Economics of Microfinance, Second Edition",                                          author: "Beatriz Armendáriz and Jonathan Morduch",                                              source: "The MIT Press",                                               url: nil,                                                                                          year: "2010"),
            ModuleFootnote(id: "gen_17",  moduleId: "mod_gender", number: "17",  title: "Social Impact Bonds: The Role of Private Capital in Outcome-Based Commissioning",       author: "Daniel Edmiston and Alex Nicholls",                                                    source: "Cambridge University Press",                                  url: "https://www.cambridge.org/core/services/aop-cambridge-core/content/view/83B92D884934604E21EE2A963EB4E11C/S0047279417000125a.pdf/social_impact_bonds_the_role_of_private_capital_in_outcomebased_commissioning.pdf", year: "2017")
        ],

        "mod_alt": [
            ModuleFootnote(id: "alt_1",   moduleId: "mod_alt", number: "1",   title: "The Past, Present, and Future of the Alternative Assets Industry",                         author: "Preqin",                                                                               source: nil,                                                           url: "https://www.preqin.com/academy/lesson-1-alternative-assets/past-present-future-of-the-alternative-assets-industry", year: nil),
            ModuleFootnote(id: "alt_1_1", moduleId: "mod_alt", number: "1.1", title: "Alternative Investments 2020: The Future of Alternative Investments",                        author: "World Economic Forum",                                                                 source: nil,                                                           url: "https://www3.weforum.org/docs/WEF_Alternative_Investments_2020_Future.pdf",                  year: "2015"),
            ModuleFootnote(id: "alt_2",   moduleId: "mod_alt", number: "2",   title: "Globalization of Alternative Investments: The Global Economic Impact of Private Equity Report 2008", author: "World Economic Forum",                                                       source: nil,                                                           url: "https://www.insead.edu/sites/default/files/assets/dept/centres/gpei/docs/world-economic-forum-global-economic-impact-of-private-equity-2008.pdf", year: "2008"),
            ModuleFootnote(id: "alt_3",   moduleId: "mod_alt", number: "3",   title: "Sovereign Venture Capitalism: At a Crossroad",                                              author: "Robyn Klingler-Vidra and Juergen Braunstein",                                          source: nil,                                                           url: "https://www.belfercenter.org/publication/sovereign-venture-capitalism-crossroad",            year: "2018"),
            ModuleFootnote(id: "alt_4",   moduleId: "mod_alt", number: "4",   title: "Investing Outside the Box: Evidence from Alternative Vehicles in Private Equity",           author: "Josh Lerner, Jason Mao, Antoinette Schoar, and Nan R. Zhang",                         source: nil,                                                           url: "https://www.hbs.edu/ris/Publication%20Files/InvestingOutsidetheBox.20190518_863e324e-76dd-40f4-af1e-870ebf9348ed_6464bb85-f5e1-407c-b625-47ce92269844.pdf", year: "2019"),
            ModuleFootnote(id: "alt_5",   moduleId: "mod_alt", number: "5",   title: "BlackRock Investing Real Assets",                                                            author: "BlackRock",                                                                            source: nil,                                                           url: "https://www.blackrock.com/institutions/en-us/what-we-do/investment-options/real-assets",     year: nil),
            ModuleFootnote(id: "alt_6",   moduleId: "mod_alt", number: "6",   title: "A Multi-Asset Approach to Inflation",                                                        author: "Dan Lefkovitz",                                                                        source: nil,                                                           url: "https://www.morningstar.com/views/blog/portfolio-construction/asset-diversification-inflation-hedge", year: "2022"),
            ModuleFootnote(id: "alt_7",   moduleId: "mod_alt", number: "7",   title: "Real Estate Funds, Private REITs, and BREIT: What You Need to Know",                       author: "David Kathman",                                                                        source: nil,                                                           url: "https://www.morningstar.com/alternative-investments/real-estate-funds-private-reits-breit-what-you-need-know", year: "2023"),
            ModuleFootnote(id: "alt_8",   moduleId: "mod_alt", number: "8",   title: "How to Analyze a Real Estate Investment",                                                    author: "Catherine Cote",                                                                       source: nil,                                                           url: "https://online.hbs.edu/blog/post/real-estate-investment-analysis",                           year: "2021"),
            ModuleFootnote(id: "alt_9",   moduleId: "mod_alt", number: "9",   title: "ESG",                                                                                        author: "BlackRock",                                                                            source: nil,                                                           url: "https://www.blackrock.com/americas-offshore/en/education/sustainability-and-alternative-investing", year: nil),
            ModuleFootnote(id: "alt_10",  moduleId: "mod_alt", number: "10",  title: "How Natural Resources Fit into a 2023 Portfolio",                                           author: "Shawn Reynolds",                                                                       source: nil,                                                           url: "https://www.vaneck.com/us/en/blogs/natural-resources/how-natural-resources-fit-into-a-2023-portfolio/", year: "2023"),
            ModuleFootnote(id: "alt_11",  moduleId: "mod_alt", number: "11",  title: "Preqin Investor Update: Alternative Assets 2019",                                           author: "Preqin",                                                                               source: nil,                                                           url: "https://docs.preqin.com/reports/Preqin-Investor-Update-Alternative-Assets-H2-2019.pdf",      year: "2019"),
            ModuleFootnote(id: "alt_12",  moduleId: "mod_alt", number: "12",  title: "Investing in Farmland",                                                                      author: "Nuveen",                                                                               source: nil,                                                           url: "https://www.nuveen.com/global/insights/alternatives/investing-in-farmland",                  year: nil),
            ModuleFootnote(id: "alt_13",  moduleId: "mod_alt", number: "13",  title: "Farmland as an Inflation Hedge",                                                             author: "Jack H. Rubens and James R. Webb",                                                     source: nil,                                                           url: "https://link.springer.com/chapter/10.1007/978-94-009-0367-8_9",                             year: "1995"),
            ModuleFootnote(id: "alt_14",  moduleId: "mod_alt", number: "14",  title: "World Bank Infrastructure Investing",                                                        author: "World Bank",                                                                           source: nil,                                                           url: "https://www.worldbank.org/en/topic/infrastructure",                                          year: nil),
            ModuleFootnote(id: "alt_15",  moduleId: "mod_alt", number: "15",  title: "Energy, Resources & Industrials",                                                            author: "Deloitte",                                                                             source: nil,                                                           url: "https://www.deloitte.com/global/en/Industries/energy/about.html",                            year: nil),
            ModuleFootnote(id: "alt_16",  moduleId: "mod_alt", number: "16",  title: "BlackRock Alternatives",                                                                     author: "BlackRock",                                                                            source: nil,                                                           url: "https://www.blackrock.com/us/individual/investment-ideas/alternative-investments",            year: "2022"),
            ModuleFootnote(id: "alt_17",  moduleId: "mod_alt", number: "17",  title: "Predictability in commodity markets: Evidence from more than a century",                    author: "Fabian Hollstein, Marcel Prokopczuk, Björn Tharann and Chardin Wese Simen",           source: nil,                                                           url: "https://www.sciencedirect.com/science/article/abs/pii/S2405851321000052",                   year: nil),
            ModuleFootnote(id: "alt_18",  moduleId: "mod_alt", number: "18",  title: "The Mainstreaming of Alternative Investments: Fueling the Next Wave of Growth in Asset Management", author: "McKinsey",                                                              source: nil,                                                           url: "https://www.mckinsey.com/~/media/mckinsey/dotcom/client_service/financial%20services/latest%20thinking/reports/the_mainstreaming_of_alternative_investments.ashx", year: nil),
            ModuleFootnote(id: "alt_19",  moduleId: "mod_alt", number: "19",  title: "The Truth About Alternative Assets",                                                         author: "John Stepek",                                                                          source: nil,                                                           url: "https://www.bloomberg.com/news/newsletters/2022-12-07/the-truth-about-alternative-assets",   year: "2022")
        ],

        "mod_esg_climate": [
            ModuleFootnote(id: "esg_1", moduleId: "mod_esg_climate", number: "1", title: "Corporate Governance and Equity Prices", author: "Gompers, P., Ishii, J., & Metrick, A.", source: "The Quarterly Journal of Economics, 118(1), 107–156", url: "https://doi.org/10.1162/00335530360535162", year: "2003"),
            ModuleFootnote(id: "esg_2", moduleId: "mod_esg_climate", number: "2", title: "Recommendations of the Task Force on Climate-related Financial Disclosures", author: "Task Force on Climate-related Financial Disclosures (TCFD)", source: "Financial Stability Board", url: "https://www.fsb-tcfd.org/publications/final-recommendations-report/", year: "2017"),
            ModuleFootnote(id: "esg_3", moduleId: "mod_esg_climate", number: "3", title: "A Call for Action: Climate Change as a Source of Financial Risk", author: "Network for Greening the Financial System (NGFS)", source: "NGFS First Comprehensive Report", url: "https://www.ngfs.net/en/first-comprehensive-report-call-action", year: "2019"),
            ModuleFootnote(id: "esg_4", moduleId: "mod_esg_climate", number: "4", title: "Does the Stock Market Fully Value Intangibles? Employee Satisfaction and Equity Prices", author: "Edmans, A.; Eccles, R. G., Ioannou, I., & Serafeim, G.", source: "Journal of Financial Economics 101(3); Management Science 60(11)", url: "https://doi.org/10.1016/j.jfineco.2011.03.021", year: "2011"),
            ModuleFootnote(id: "esg_5", moduleId: "mod_esg_climate", number: "5", title: "Global Sustainable Investment Review 2020", author: "Global Sustainable Investment Alliance (GSIA)", source: "GSIA Biennial Report", url: "http://www.gsi-alliance.org/wp-content/uploads/2021/08/GSIR-20201.pdf", year: "2021"),
            ModuleFootnote(id: "esg_6", moduleId: "mod_esg_climate", number: "6", title: "Annual Impact Investor Survey", author: "Global Impact Investing Network (GIIN)", source: "GIIN Research", url: "https://thegiin.org/research/publication/2023-giin-impact-investor-survey/", year: "2023"),
            ModuleFootnote(id: "esg_7", moduleId: "mod_esg_climate", number: "7", title: "ESG and Financial Performance: Aggregated Evidence from More Than 2,000 Empirical Studies", author: "Friede, G., Busch, T., & Bassen, A.", source: "Journal of Sustainable Finance & Investment, 5(4), 210–233", url: "https://doi.org/10.1080/20430795.2015.1118917", year: "2015"),
            ModuleFootnote(id: "esg_8", moduleId: "mod_esg_climate", number: "8", title: "ESG and Financial Performance: Aggregated Evidence from More Than 2,000 Empirical Studies", author: "Friede, G., Busch, T., & Bassen, A.", source: "Journal of Sustainable Finance & Investment, 5(4), 210–233", url: "https://doi.org/10.1080/20430795.2015.1118917", year: "2015"),
            ModuleFootnote(id: "esg_9", moduleId: "mod_esg_climate", number: "9", title: "Corporate Sustainability: First Evidence on Materiality", author: "Khan, M., Serafeim, G., & Yoon, A.", source: "The Accounting Review, 91(6), 1697–1724", url: "https://doi.org/10.2308/accr-51383", year: "2016"),
            ModuleFootnote(id: "esg_10", moduleId: "mod_esg_climate", number: "10", title: "Sustainable Funds Performance & Flow Reports (2024–2025)", author: "Morningstar", source: "Morningstar Manager Research", url: "https://www.morningstar.com/sustainable-investing", year: "2025"),
            ModuleFootnote(id: "esg_11", moduleId: "mod_esg_climate", number: "11", title: "Sustainable Funds Performance & Flow Reports", author: "Morningstar", source: "Morningstar Manager Research", url: "https://www.morningstar.com/sustainable-investing", year: "2025"),
            ModuleFootnote(id: "esg_12", moduleId: "mod_esg_climate", number: "12", title: "Sustainable Funds Performance & Flow Reports", author: "Morningstar", source: "Morningstar Manager Research", url: "https://www.morningstar.com/sustainable-investing", year: "2025"),
            ModuleFootnote(id: "esg_13", moduleId: "mod_esg_climate", number: "13", title: "Sustainable Funds Performance & Flow Reports", author: "Morningstar", source: "Morningstar Manager Research", url: "https://www.morningstar.com/sustainable-investing", year: "2025"),
            ModuleFootnote(id: "esg_14", moduleId: "mod_esg_climate", number: "14", title: "State ESG Legislation Tracker", author: "US SIF Foundation", source: "US SIF Foundation Report", url: "https://www.ussif.org/", year: "2024"),
            ModuleFootnote(id: "esg_15", moduleId: "mod_esg_climate", number: "15", title: "Net Zero and Beyond: A Deep Dive into Climate Targets and Climate Action", author: "South Pole", source: "South Pole Annual Report", url: "https://www.south-pole.com/news/net-zero-and-beyond", year: "2023"),
            ModuleFootnote(id: "esg_16", moduleId: "mod_esg_climate", number: "16", title: "European Sustainable Fund Flows Report", author: "Morningstar", source: "Morningstar Manager Research", url: "https://www.morningstar.com/sustainable-investing", year: "2025"),
            ModuleFootnote(id: "esg_18", moduleId: "mod_esg_climate", number: "18", title: "Asia Sustainable Investment Review", author: "Asia Investor Group on Climate Change (AIGCC)", source: "AIGCC Annual Review", url: "https://www.aigcc.net/", year: "2024"),
            ModuleFootnote(id: "esg_19", moduleId: "mod_esg_climate", number: "19", title: "Asia Sustainable Investment Review", author: "Asia Investor Group on Climate Change (AIGCC)", source: "AIGCC Annual Review", url: "https://www.aigcc.net/", year: "2024"),
            ModuleFootnote(id: "esg_20", moduleId: "mod_esg_climate", number: "20", title: "Asia Sustainable Investment Review", author: "Asia Investor Group on Climate Change (AIGCC)", source: "AIGCC Annual Review", url: "https://www.aigcc.net/", year: "2024"),
            ModuleFootnote(id: "esg_21", moduleId: "mod_esg_climate", number: "21", title: "Guidelines on Funds' Names Using ESG or Sustainability-Related Terms", author: "European Securities and Markets Authority (ESMA)", source: "ESMA Guidelines", url: "https://www.esma.europa.eu/document/guidelines-funds-names-using-esg-or-sustainability-related-terms", year: "2024"),
            ModuleFootnote(id: "esg_27", moduleId: "mod_esg_climate", number: "27", title: "Paris Agreement, Article 2.1(c)", author: "United Nations Framework Convention on Climate Change (UNFCCC)", source: "UNFCCC Paris Agreement", url: "https://unfccc.int/sites/default/files/english_paris_agreement.pdf", year: "2015"),
            ModuleFootnote(id: "esg_28", moduleId: "mod_esg_climate", number: "28", title: "World Energy Outlook 2024", author: "International Energy Agency (IEA)", source: "IEA Annual Flagship Report", url: "https://www.iea.org/reports/world-energy-outlook-2024", year: "2024"),
            ModuleFootnote(id: "esg_29", moduleId: "mod_esg_climate", number: "29", title: "Global Landscape of Climate Finance 2023", author: "Climate Policy Initiative (CPI)", source: "CPI Annual Report", url: "https://climatepolicyinitiative.org/publication/global-landscape-of-climate-finance-2023/", year: "2023"),
            ModuleFootnote(id: "esg_30", moduleId: "mod_esg_climate", number: "30", title: "The Rise and Rise of the Global Balance Sheet", author: "McKinsey Global Institute", source: "McKinsey Global Institute Report", url: "https://www.mckinsey.com/mgi/", year: "2023"),
            ModuleFootnote(id: "esg_31", moduleId: "mod_esg_climate", number: "31", title: "Science Based Targets Initiative: Progress Report 2023", author: "Science Based Targets initiative (SBTi)", source: "SBTi Annual Progress Report", url: "https://sciencebasedtargets.org/resources/files/SBTi-Progress-Report-2023.pdf", year: "2024"),
            ModuleFootnote(id: "esg_34", moduleId: "mod_esg_climate", number: "34", title: "AR6 Working Group III: Mitigation of Climate Change", author: "Intergovernmental Panel on Climate Change (IPCC)", source: "IPCC AR6 Working Group III", url: "https://www.ipcc.ch/report/ar6/wg3/", year: "2022"),
            ModuleFootnote(id: "esg_35", moduleId: "mod_esg_climate", number: "35", title: "AR6 Synthesis Report: Climate Change 2023", author: "Intergovernmental Panel on Climate Change (IPCC)", source: "IPCC AR6 Synthesis Report", url: "https://www.ipcc.ch/report/ar6/syr/", year: "2023"),
            ModuleFootnote(id: "esg_36", moduleId: "mod_esg_climate", number: "36", title: "Renewable Power Generation Costs in 2023", author: "International Renewable Energy Agency (IRENA)", source: "IRENA Annual Cost Report", url: "https://www.irena.org/publications/2024/Sep/Renewable-power-generation-costs-in-2023", year: "2024"),
            ModuleFootnote(id: "esg_37", moduleId: "mod_esg_climate", number: "37", title: "Net Zero Stocktake 2024", author: "Net Zero Tracker", source: "Net Zero Tracker Annual Report", url: "https://zerotracker.net/", year: "2024"),
            ModuleFootnote(id: "esg_38", moduleId: "mod_esg_climate", number: "38", title: "Net Zero Stocktake 2024", author: "Net Zero Tracker", source: "Net Zero Tracker Annual Report", url: "https://zerotracker.net/", year: "2024"),
            ModuleFootnote(id: "esg_39", moduleId: "mod_esg_climate", number: "39", title: "World Energy Investment 2024", author: "International Energy Agency (IEA)", source: "IEA Annual Investment Report", url: "https://www.iea.org/reports/world-energy-investment-2024", year: "2024"),
            ModuleFootnote(id: "esg_40", moduleId: "mod_esg_climate", number: "40", title: "Energy Security in Net Zero Transitions", author: "International Energy Agency (IEA)", source: "IEA Report", url: "https://www.iea.org/reports/energy-security-in-net-zero-transitions", year: "2023"),
            ModuleFootnote(id: "esg_45", moduleId: "mod_esg_climate", number: "45", title: "sigma 1/2024: Natural Catastrophes in 2023", author: "Swiss Re Institute", source: "Swiss Re sigma Research", url: "https://www.swissre.com/institute/research/sigma-research/sigma-2024-01.html", year: "2024"),
            ModuleFootnote(id: "esg_46", moduleId: "mod_esg_climate", number: "46", title: "AR6 Working Group II: Impacts, Adaptation and Vulnerability", author: "Intergovernmental Panel on Climate Change (IPCC)", source: "IPCC AR6 Working Group II", url: "https://www.ipcc.ch/report/ar6/wg2/", year: "2022"),
            ModuleFootnote(id: "esg_47", moduleId: "mod_esg_climate", number: "47", title: "Adapt Now: A Global Call for Leadership on Climate Resilience", author: "Global Commission on Adaptation", source: "Global Commission on Adaptation Report", url: "https://gca.org/", year: "2023"),
            ModuleFootnote(id: "esg_48", moduleId: "mod_esg_climate", number: "48", title: "Climate Change Litigation Databases", author: "Sabin Center for Climate Change Law, Columbia Law School", source: "Sabin Center Research", url: "http://climatecasechart.com/", year: "2024"),
            ModuleFootnote(id: "esg_49", moduleId: "mod_esg_climate", number: "49", title: "Annual Report 2024", author: "Principles for Responsible Investment (PRI)", source: "PRI Annual Report", url: "https://www.unpri.org/annual-report-2024", year: "2024"),
            ModuleFootnote(id: "esg_50", moduleId: "mod_esg_climate", number: "50", title: "Annual Report 2024", author: "Principles for Responsible Investment (PRI)", source: "PRI Annual Report", url: "https://www.unpri.org/annual-report-2024", year: "2024"),
            ModuleFootnote(id: "esg_51", moduleId: "mod_esg_climate", number: "51", title: "CDP Global Report 2024", author: "Carbon Disclosure Project (CDP)", source: "CDP Annual Global Report", url: "https://www.cdp.net/en/research/global-reports/", year: "2024"),
            ModuleFootnote(id: "esg_52", moduleId: "mod_esg_climate", number: "52", title: "Investor Agenda for Corporate Climate Action", author: "Ceres", source: "Ceres Report", url: "https://www.ceres.org/", year: "2024"),
            ModuleFootnote(id: "esg_67", moduleId: "mod_esg_climate", number: "67", title: "SASB Standards", author: "Sustainability Accounting Standards Board (SASB)", source: "SASB Industry-Specific Standards", url: "https://www.sasb.org/standards/", year: "2024"),
            ModuleFootnote(id: "esg_68", moduleId: "mod_esg_climate", number: "68", title: "NGFS Climate Scenarios for Central Banks and Supervisors", author: "Network for Greening the Financial System (NGFS)", source: "NGFS Scenarios Report", url: "https://www.ngfs.net/en/ngfs-climate-scenarios-central-banks-and-supervisors-sep", year: "2023"),
            ModuleFootnote(id: "esg_69", moduleId: "mod_esg_climate", number: "69", title: "EU Emissions Trading System (EU ETS)", author: "European Commission", source: "EU ETS Program Documentation", url: "https://climate.ec.europa.eu/eu-action/eu-emissions-trading-system-eu-ets_en", year: "2025"),
            ModuleFootnote(id: "esg_70", moduleId: "mod_esg_climate", number: "70", title: "Regional Greenhouse Gas Initiative Program Overview", author: "Regional Greenhouse Gas Initiative (RGGI)", source: "RGGI Program Documentation", url: "https://www.rggi.org/program-overview-and-design/elements", year: "2025"),
            ModuleFootnote(id: "esg_71", moduleId: "mod_esg_climate", number: "71", title: "Cap-and-Trade Program", author: "California Air Resources Board (CARB)", source: "CARB Program Documentation", url: "https://ww2.arb.ca.gov/our-work/programs/cap-and-trade-program", year: "2024"),
            ModuleFootnote(id: "esg_72", moduleId: "mod_esg_climate", number: "72", title: "AR6 WG3 Chapter 12: Cross-Sectoral Perspectives on Carbon Dioxide Removal", author: "Intergovernmental Panel on Climate Change (IPCC)", source: "IPCC AR6 Working Group III", url: "https://www.ipcc.ch/report/ar6/wg3/", year: "2022"),
            ModuleFootnote(id: "esg_73", moduleId: "mod_esg_climate", number: "73", title: "State and Trends of Carbon Pricing 2024", author: "World Bank", source: "World Bank Annual Carbon Pricing Report", url: "https://openknowledge.worldbank.org/", year: "2024"),
            ModuleFootnote(id: "esg_74", moduleId: "mod_esg_climate", number: "74", title: "Carbon Market Outlook 2024", author: "BloombergNEF", source: "BloombergNEF Research", url: "https://about.bnef.com/", year: "2024"),
            ModuleFootnote(id: "esg_75", moduleId: "mod_esg_climate", number: "75", title: "Overstated Carbon Emission Reductions from Voluntary REDD+ Projects in the Brazilian Amazon", author: "West, T. A. P., et al.", source: "Science, 380(6646)", url: "https://doi.org/10.1126/science.ade3535", year: "2023"),
            ModuleFootnote(id: "esg_76", moduleId: "mod_esg_climate", number: "76", title: "Risk Mitigation and Buffer Pool Methodology", author: "Verra", source: "Verra VCS Program Methodology", url: "https://verra.org/methodologies/", year: "2023"),
            ModuleFootnote(id: "esg_77", moduleId: "mod_esg_climate", number: "77", title: "Revisiting the Concept of Payments for Environmental Services", author: "Wunder, S.", source: "Ecological Economics, 117, 234–243", url: "https://doi.org/10.1016/j.ecolecon.2014.02.016", year: "2016"),
            ModuleFootnote(id: "esg_78", moduleId: "mod_esg_climate", number: "78", title: "Carbon Standards Overview: VCS, Gold Standard, Climate Action Reserve", author: "Verra; Gold Standard; Climate Action Reserve", source: "Carbon Standards Documentation", url: nil, year: nil),
            ModuleFootnote(id: "esg_79", moduleId: "mod_esg_climate", number: "79", title: "Revealed: More Than 90% of Rainforest Carbon Offsets by Biggest Provider Are Worthless", author: "Greenfield, P.", source: "The Guardian", url: "https://www.theguardian.com/environment/2023/jan/18/revealed-forest-carbon-offsets-biggest-provider-worthless-verra-audi", year: "2023"),
            ModuleFootnote(id: "esg_88", moduleId: "mod_esg_climate", number: "88", title: "State of Digital Carbon Markets", author: "KlimaDAO", source: "KlimaDAO Documentation", url: "https://docs.klimadao.finance/", year: "2023"),
            ModuleFootnote(id: "esg_89", moduleId: "mod_esg_climate", number: "89", title: "Blockchain and Carbon Markets", author: "Tourvieille, J. & Gupta, A.", source: "Journal of Cleaner Production", url: "https://doi.org/10.1016/j.jclepro.2023.135965", year: "2023"),
            ModuleFootnote(id: "esg_92", moduleId: "mod_esg_climate", number: "92", title: "State of the Voluntary Carbon Markets 2024", author: "Ecosystem Marketplace", source: "Forest Trends / Ecosystem Marketplace Annual Report", url: "https://www.ecosystemmarketplace.com/publications/state-of-the-voluntary-carbon-markets-2024/", year: "2024"),
            ModuleFootnote(id: "esg_93", moduleId: "mod_esg_climate", number: "93", title: "State of the Voluntary Carbon Markets 2024", author: "Ecosystem Marketplace", source: "Forest Trends / Ecosystem Marketplace Annual Report", url: "https://www.ecosystemmarketplace.com/publications/state-of-the-voluntary-carbon-markets-2024/", year: "2024"),
            ModuleFootnote(id: "esg_94", moduleId: "mod_esg_climate", number: "94", title: "State of the Voluntary Carbon Markets 2024", author: "Ecosystem Marketplace", source: "Forest Trends / Ecosystem Marketplace Annual Report", url: "https://www.ecosystemmarketplace.com/publications/state-of-the-voluntary-carbon-markets-2024/", year: "2024"),
            ModuleFootnote(id: "esg_95", moduleId: "mod_esg_climate", number: "95", title: "State of the Voluntary Carbon Markets 2024", author: "Ecosystem Marketplace", source: "Forest Trends / Ecosystem Marketplace Annual Report", url: "https://www.ecosystemmarketplace.com/publications/state-of-the-voluntary-carbon-markets-2024/", year: "2024"),
            ModuleFootnote(id: "esg_96", moduleId: "mod_esg_climate", number: "96", title: "State of the Voluntary Carbon Markets 2024", author: "Ecosystem Marketplace", source: "Forest Trends / Ecosystem Marketplace Annual Report", url: "https://www.ecosystemmarketplace.com/publications/state-of-the-voluntary-carbon-markets-2024/", year: "2024"),
            ModuleFootnote(id: "esg_97", moduleId: "mod_esg_climate", number: "97", title: "Core Carbon Principles", author: "Integrity Council for the Voluntary Carbon Market (ICVCM)", source: "ICVCM Standards", url: "https://icvcm.org/the-core-carbon-principles/", year: "2023"),
            ModuleFootnote(id: "esg_98", moduleId: "mod_esg_climate", number: "98", title: "Voluntary Carbon Markets Convening Report", author: "U.S. Commodity Futures Trading Commission (CFTC)", source: "CFTC Report", url: "https://www.cftc.gov/PressRoom/PressReleases/8742-23", year: "2023"),
            ModuleFootnote(id: "esg_99", moduleId: "mod_esg_climate", number: "99", title: "Corporate Net Zero Targets", author: "Net Zero Tracker", source: "Net Zero Tracker Database", url: "https://zerotracker.net/", year: "2024"),
            ModuleFootnote(id: "esg_100", moduleId: "mod_esg_climate", number: "100", title: "Scaling Voluntary Carbon Markets", author: "World Economic Forum", source: "WEF Report", url: "https://www.weforum.org/reports/scaling-voluntary-carbon-markets", year: "2024"),
            ModuleFootnote(id: "esg_101", moduleId: "mod_esg_climate", number: "101", title: "Article 6 Cooperative Approaches", author: "United Nations Framework Convention on Climate Change (UNFCCC)", source: "UNFCCC Paris Agreement Implementation", url: "https://unfccc.int/process-and-meetings/the-paris-agreement/cooperative-implementation", year: "2023")
        ],

        "mod_defi_investing": [
            ModuleFootnote(id: "di_1", moduleId: "mod_defi_investing", number: "1", title: "DeFi Risks and the Decentralisation Illusion", author: "Bank for International Settlements (BIS)", source: "BIS Quarterly Review, December 2021", url: "https://www.bis.org/publ/qtrpdf/r_qt2112b.htm", year: "2021"),
            ModuleFootnote(id: "di_2", moduleId: "mod_defi_investing", number: "2", title: "DeFi Risks and the Decentralisation Illusion", author: "Bank for International Settlements (BIS)", source: "BIS Quarterly Review, December 2021", url: "https://www.bis.org/publ/qtrpdf/r_qt2112b.htm", year: "2021"),
            ModuleFootnote(id: "di_3", moduleId: "mod_defi_investing", number: "3", title: "Decentralized Finance Report", author: "International Organization of Securities Commissions (IOSCO)", source: "IOSCO Research Report", url: "https://www.iosco.org/library/pubdocs/pdf/IOSCOPD699.pdf", year: "2022"),
            ModuleFootnote(id: "di_4", moduleId: "mod_defi_investing", number: "4", title: "Decentralized Finance Report", author: "International Organization of Securities Commissions (IOSCO)", source: "IOSCO Research Report", url: "https://www.iosco.org/library/pubdocs/pdf/IOSCOPD699.pdf", year: "2022"),
            ModuleFootnote(id: "di_5", moduleId: "mod_defi_investing", number: "5", title: "Global Financial Stability Report", author: "International Monetary Fund (IMF)", source: "IMF Annual Report", url: "https://www.imf.org/en/Publications/GFSR", year: "2023"),
            ModuleFootnote(id: "di_6", moduleId: "mod_defi_investing", number: "6", title: "DeFi Risks and the Decentralisation Illusion", author: "Bank for International Settlements (BIS)", source: "BIS Quarterly Review, December 2021", url: "https://www.bis.org/publ/qtrpdf/r_qt2112b.htm", year: "2021"),
            ModuleFootnote(id: "di_7", moduleId: "mod_defi_investing", number: "7", title: "DeFi Risks and the Decentralisation Illusion", author: "Bank for International Settlements (BIS)", source: "BIS Quarterly Review, December 2021", url: "https://www.bis.org/publ/qtrpdf/r_qt2112b.htm", year: "2021"),
            ModuleFootnote(id: "di_8", moduleId: "mod_defi_investing", number: "8", title: "Decentralized Finance Report", author: "International Organization of Securities Commissions (IOSCO)", source: "IOSCO Research Report", url: "https://www.iosco.org/library/pubdocs/pdf/IOSCOPD699.pdf", year: "2022"),
            ModuleFootnote(id: "di_9", moduleId: "mod_defi_investing", number: "9", title: "Decentralized Finance Report", author: "International Organization of Securities Commissions (IOSCO)", source: "IOSCO Research Report", url: "https://www.iosco.org/library/pubdocs/pdf/IOSCOPD699.pdf", year: "2022"),
            ModuleFootnote(id: "di_10", moduleId: "mod_defi_investing", number: "10", title: "DeFi Risks and the Decentralisation Illusion", author: "Bank for International Settlements (BIS)", source: "BIS Quarterly Review, December 2021", url: "https://www.bis.org/publ/qtrpdf/r_qt2112b.htm", year: "2021"),
            ModuleFootnote(id: "di_11", moduleId: "mod_defi_investing", number: "11", title: "Spot Bitcoin ETFs: Market Impact and Institutional Flow Analysis", author: "Bloomberg Intelligence", source: "Bloomberg Intelligence Report", url: "https://www.bloomberg.com/professional/blog/", year: "2024"),
            ModuleFootnote(id: "di_12", moduleId: "mod_defi_investing", number: "12", title: "iShares Bitcoin Trust (IBIT) Assets Under Management Reports", author: "BlackRock iShares", source: "BlackRock iShares ETF Data", url: "https://www.ishares.com/us/products/333011/", year: "2024"),
            ModuleFootnote(id: "di_13", moduleId: "mod_defi_investing", number: "13", title: "Order Granting Approval of Spot Bitcoin Exchange-Traded Products", author: "U.S. Securities and Exchange Commission (SEC)", source: "SEC Release No. 34-99306", url: "https://www.sec.gov/rules/sro/cboebzx/2024/34-99306.pdf", year: "2024"),
            ModuleFootnote(id: "di_14", moduleId: "mod_defi_investing", number: "14", title: "The State of Stablecoins and Institutional Adoption", author: "Galaxy Digital Research", source: "Galaxy Digital Research Report", url: "https://www.galaxy.com/research/", year: "2025"),
            ModuleFootnote(id: "di_15", moduleId: "mod_defi_investing", number: "15", title: "Hardware Wallet Security Architecture Overview", author: "Ledger SAS", source: "Ledger Security Research", url: "https://www.ledger.com/academy/security", year: "2024"),
            ModuleFootnote(id: "di_16", moduleId: "mod_defi_investing", number: "16", title: "Aave Total Value Locked and Utilization Metrics", author: "DefiLlama", source: "DefiLlama Protocol Analytics", url: "https://defillama.com/protocol/aave", year: "2025"),
            ModuleFootnote(id: "di_17", moduleId: "mod_defi_investing", number: "17", title: "DeFi Token Value Accrual Framework", author: "Messari Crypto Research", source: "Messari Research", url: "https://messari.io", year: "2025"),
            ModuleFootnote(id: "di_18", moduleId: "mod_defi_investing", number: "18", title: "Crypto Crime Report 2026: DeFi Exploits and Smart Contract Risk", author: "Chainalysis", source: "Chainalysis Annual Report", url: "https://go.chainalysis.com/crypto-crime-report.html", year: "2026"),
            ModuleFootnote(id: "di_19", moduleId: "mod_defi_investing", number: "19", title: "Alternative Investments and Portfolio Construction", author: "CFA Institute Research Foundation", source: "CFA Institute Research Foundation", url: "https://rpc.cfainstitute.org/research/foundation/2023/alternative-investments-portfolio-construction", year: "2023"),
            ModuleFootnote(id: "di_20", moduleId: "mod_defi_investing", number: "20", title: "Institutional Digital Asset Allocation Framework", author: "Fidelity Digital Assets", source: "Fidelity Digital Assets Research", url: "https://www.fidelitydigitalassets.com/research-and-insights", year: "2024"),
            ModuleFootnote(id: "di_21", moduleId: "mod_defi_investing", number: "21", title: "Bitcoin and Cryptocurrency Technologies", author: "Narayanan, A., et al.", source: "Princeton University Press", url: "https://bitcoinbook.cs.princeton.edu", year: "2016"),
            ModuleFootnote(id: "di_22", moduleId: "mod_defi_investing", number: "22", title: "Smart Contract Security Reviews and Audit Limitations", author: "Trail of Bits", source: "Trail of Bits Research", url: "https://www.trailofbits.com/research", year: "2024"),
            ModuleFootnote(id: "di_23", moduleId: "mod_defi_investing", number: "23", title: "Evaluating Token Economic Design in DeFi Protocols", author: "a16z Crypto", source: "a16z Crypto Research", url: "https://a16zcrypto.com", year: "2025"),
            ModuleFootnote(id: "di_24", moduleId: "mod_defi_investing", number: "24", title: "Aave Documentation & Risk Framework Overview", author: "Aave", source: "Aave Protocol Documentation", url: "https://docs.aave.com", year: "2025"),
            ModuleFootnote(id: "di_25", moduleId: "mod_defi_investing", number: "25", title: "Uniswap v3 Whitepaper", author: "Uniswap Labs", source: "Uniswap Protocol Documentation", url: "https://uniswap.org/whitepaper-v3.pdf", year: "2021"),
            ModuleFootnote(id: "di_26", moduleId: "mod_defi_investing", number: "26", title: "MakerDAO Governance Documentation and RWA Framework Reports", author: "MakerDAO (Sky)", source: "MakerDAO Protocol Documentation", url: "https://docs.makerdao.com", year: "2025"),
            ModuleFootnote(id: "di_27", moduleId: "mod_defi_investing", number: "27", title: "Digital Assets and Decentralized Finance Education Guidelines", author: "CFA Institute", source: "CFA Institute Research", url: "https://www.cfainstitute.org", year: "2025"),
            ModuleFootnote(id: "di_28", moduleId: "mod_defi_investing", number: "28", title: "Global Blockchain Survey 2025: Institutional Adoption Trends", author: "Deloitte", source: "Deloitte Annual Survey", url: "https://www2.deloitte.com/us/en/pages/consulting/articles/blockchain-survey.html", year: "2025"),
            ModuleFootnote(id: "di_29", moduleId: "mod_defi_investing", number: "29", title: "Digital Assets in CFA Curriculum Update", author: "CFA Institute; CFP Board", source: "CFA Institute; CFP Board Continuing Education", url: "https://www.cfainstitute.org", year: "2024"),
            ModuleFootnote(id: "di_30", moduleId: "mod_defi_investing", number: "30", title: "U.S. Advisor Digital Asset Sentiment Report", author: "Cerulli Associates", source: "Cerulli U.S. Advisor Metrics", url: "https://www.cerulli.com", year: "2025"),
            ModuleFootnote(id: "di_31", moduleId: "mod_defi_investing", number: "31", title: "Advisor Adoption of Digital Assets Study", author: "Fidelity Digital Assets", source: "Fidelity Digital Assets Research", url: "https://www.fidelitydigitalassets.com/research-and-insights", year: "2025"),
            ModuleFootnote(id: "di_32", moduleId: "mod_defi_investing", number: "32", title: "The Layers of the Crypto Stack", author: "a16z Crypto", source: "a16z Crypto Research", url: "https://a16zcrypto.com", year: "2024"),
            ModuleFootnote(id: "di_33", moduleId: "mod_defi_investing", number: "33", title: "Big Ideas 2025: Bitcoin and Smart Contract Platforms", author: "Ark Invest", source: "Ark Invest Annual Report", url: "https://www.ark-invest.com/big-ideas-2025", year: "2025"),
            ModuleFootnote(id: "di_34", moduleId: "mod_defi_investing", number: "34", title: "Stablecoins: Risks and Regulatory Responses", author: "Bank for International Settlements (BIS)", source: "BIS Research", url: "https://www.bis.org", year: "2024"),
            ModuleFootnote(id: "di_35", moduleId: "mod_defi_investing", number: "35", title: "Digital Asset Report", author: "U.S. Treasury Financial Stability Oversight Council (FSOC)", source: "FSOC Annual Report", url: "https://home.treasury.gov/system/files/261/FSOC-2023-Annual-Report.pdf", year: "2023"),
            ModuleFootnote(id: "di_36", moduleId: "mod_defi_investing", number: "36", title: "State of DeFi 2025 Report", author: "Messari Crypto Research", source: "Messari Annual Report", url: "https://messari.io/report/state-of-defi-2025", year: "2025"),
            ModuleFootnote(id: "di_37", moduleId: "mod_defi_investing", number: "37", title: "Aave Governance & Tokenomics Documentation", author: "Aave", source: "Aave Governance Forum", url: "https://governance.aave.com", year: "2025"),
            ModuleFootnote(id: "di_38", moduleId: "mod_defi_investing", number: "38", title: "UNIfication Proposal", author: "Uniswap Governance Forum", source: "Uniswap Governance Forum", url: "https://gov.uniswap.org", year: "2025"),
            ModuleFootnote(id: "di_39", moduleId: "mod_defi_investing", number: "39", title: "Interpreting TVL Metrics in DeFi", author: "DefiLlama Research", source: "DefiLlama Research", url: "https://defillama.com", year: "2024"),
            ModuleFootnote(id: "di_40", moduleId: "mod_defi_investing", number: "40", title: "Crypto Crime Report 2026", author: "Chainalysis", source: "Chainalysis Annual Report", url: "https://go.chainalysis.com/crypto-crime-report.html", year: "2026"),
            ModuleFootnote(id: "di_41", moduleId: "mod_defi_investing", number: "41", title: "Alternative Investments and Portfolio Construction", author: "CFA Institute Research Foundation", source: "CFA Institute Research Foundation", url: "https://rpc.cfainstitute.org/research/foundation/2023/alternative-investments-portfolio-construction", year: "2023"),
            ModuleFootnote(id: "di_42", moduleId: "mod_defi_investing", number: "42", title: "Custody Considerations for Digital Assets", author: "Fidelity Digital Assets", source: "Fidelity Digital Assets Research", url: "https://www.fidelitydigitalassets.com/research-and-insights", year: "2024"),
            ModuleFootnote(id: "di_43", moduleId: "mod_defi_investing", number: "43", title: "IRS Notice 2014-21 and Digital Asset Tax Guidance", author: "Internal Revenue Service (IRS)", source: "IRS Notice 2014-21", url: "https://www.irs.gov/irb/2014-16_IRB", year: "2014"),
            ModuleFootnote(id: "di_44", moduleId: "mod_defi_investing", number: "44", title: "Spot Bitcoin & Ethereum ETF Approval Orders", author: "U.S. Securities and Exchange Commission (SEC)", source: "SEC Approval Orders", url: "https://www.sec.gov", year: "2024"),
            ModuleFootnote(id: "di_45", moduleId: "mod_defi_investing", number: "45", title: "USDC Settlement Expansion Announcement", author: "Visa Inc.", source: "Visa Press Release", url: "https://usa.visa.com/about-visa/newsroom/press-releases.releaseId.19881.html", year: "2024"),
            ModuleFootnote(id: "di_46", moduleId: "mod_defi_investing", number: "46", title: "Tokenization of Assets: Trillions by 2030", author: "Boston Consulting Group (BCG)", source: "BCG Research Report", url: "https://www.bcg.com/publications/2024/tokenization-of-assets", year: "2024"),
            ModuleFootnote(id: "di_47", moduleId: "mod_defi_investing", number: "47", title: "Markets in Crypto-Assets (MiCA) Regulation Overview", author: "European Parliament", source: "EU Official Journal", url: "https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32023R1114", year: "2024"),
            ModuleFootnote(id: "di_48", moduleId: "mod_defi_investing", number: "48", title: "SEC Enforcement Division Public Statements (December 2025)", author: "U.S. Securities and Exchange Commission (SEC)", source: "SEC Press Releases", url: "https://www.sec.gov/news/press-releases", year: "2025"),
            ModuleFootnote(id: "di_49", moduleId: "mod_defi_investing", number: "49", title: "Estate Planning for Digital Assets", author: "National Law Review", source: "National Law Review Article", url: "https://www.natlawreview.com", year: "2024"),
            ModuleFootnote(id: "di_50", moduleId: "mod_defi_investing", number: "50", title: "Institutional Digital Asset Due Diligence Framework", author: "Fidelity Digital Assets", source: "Fidelity Digital Assets Research", url: "https://www.fidelitydigitalassets.com/research-and-insights", year: "2025"),
            ModuleFootnote(id: "di_51", moduleId: "mod_defi_investing", number: "51", title: "Fiduciary Standards Guidance — Digital Assets", author: "U.S. Department of Labor", source: "DOL Guidance Document", url: "https://www.dol.gov", year: "2024"),
            ModuleFootnote(id: "di_52", moduleId: "mod_defi_investing", number: "52", title: "Advisor Competency Benchmarks in Digital Assets", author: "Cerulli Associates", source: "Cerulli Research", url: "https://www.cerulli.com", year: "2025"),
            ModuleFootnote(id: "di_53", moduleId: "mod_defi_investing", number: "53", title: "Continuing Education in Digital Assets", author: "CFA Institute", source: "CFA Institute Research", url: "https://www.cfainstitute.org", year: "2025"),
            ModuleFootnote(id: "di_54", moduleId: "mod_defi_investing", number: "54", title: "Managing Multi-Advisor Structures in Alternative Investments", author: "EY", source: "EY Research", url: "https://www.ey.com", year: "2024"),
            ModuleFootnote(id: "di_55", moduleId: "mod_defi_investing", number: "55", title: "Self-Directed Investing and Behavioral Risk", author: "Vanguard Research", source: "Vanguard Research Paper", url: "https://corporate.vanguard.com/content/corporatesite/us/en/corp/articles-and-reports.html", year: "2023"),
            ModuleFootnote(id: "di_56", moduleId: "mod_defi_investing", number: "56", title: "Advisor Bias and Portfolio Construction Outcomes", author: "Morningstar Research", source: "Morningstar Research", url: "https://www.morningstar.com", year: "2024"),
            ModuleFootnote(id: "di_57", moduleId: "mod_defi_investing", number: "57", title: "Order Granting Approval of Spot Bitcoin Exchange-Traded Products", author: "U.S. Securities and Exchange Commission (SEC)", source: "SEC Release No. 34-99306", url: "https://www.sec.gov/rules/sro/cboebzx/2024/34-99306.pdf", year: "2024"),
            ModuleFootnote(id: "di_58", moduleId: "mod_defi_investing", number: "58", title: "GBTC Structure and Historical Premium/Discount Data", author: "Grayscale Investments", source: "Grayscale Research", url: "https://grayscale.com/products/grayscale-bitcoin-trust/", year: "2023"),
            ModuleFootnote(id: "di_59", moduleId: "mod_defi_investing", number: "59", title: "iShares Bitcoin Trust (IBIT) Prospectus; Spot Bitcoin ETF Fee Schedule", author: "BlackRock; Fidelity Digital Assets", source: "BlackRock iShares; Fidelity Digital Assets", url: "https://www.ishares.com/us/products/333011/", year: "2024"),
            ModuleFootnote(id: "di_60", moduleId: "mod_defi_investing", number: "60", title: "Cryptoassets and ETF Structures: Implications for Portfolio Construction", author: "CFA Institute", source: "CFA Institute Research", url: "https://www.cfainstitute.org", year: "2024"),
            ModuleFootnote(id: "di_61", moduleId: "mod_defi_investing", number: "61", title: "Stablecoins: Risks, Potential and Regulation", author: "Arner, D., Auer, R., & Frost, J.", source: "BIS Working Paper No. 905", url: "https://www.bis.org/publ/work905.pdf", year: "2020"),
            ModuleFootnote(id: "di_62", moduleId: "mod_defi_investing", number: "62", title: "Remittance Prices Worldwide Quarterly", author: "World Bank", source: "World Bank Quarterly Report", url: "https://remittanceprices.worldbank.org", year: "2023"),
            ModuleFootnote(id: "di_63", moduleId: "mod_defi_investing", number: "63", title: "USDC Transparency Report", author: "Circle Internet Financial", source: "Circle Monthly Report", url: "https://www.circle.com/en/transparency", year: "2024"),
            ModuleFootnote(id: "di_64", moduleId: "mod_defi_investing", number: "64", title: "Visa Expands USDC Settlement Capabilities", author: "Visa Inc.", source: "Visa Press Release", url: "https://usa.visa.com/about-visa/newsroom", year: "2025"),
            ModuleFootnote(id: "di_65", moduleId: "mod_defi_investing", number: "65", title: "My Onchain Net Yield Fund (MONY) Overview", author: "JPMorgan Asset Management", source: "JPMorgan Fund Documentation", url: "https://am.jpmorgan.com", year: "2025"),
            ModuleFootnote(id: "di_66", moduleId: "mod_defi_investing", number: "66", title: "Stablecoin Transparency Reports", author: "Circle; Tether; MakerDAO", source: "Circle; Tether; MakerDAO Documentation", url: "https://www.circle.com/en/transparency", year: "2024"),
            ModuleFootnote(id: "di_67", moduleId: "mod_defi_investing", number: "67", title: "JPM Coin and Blockchain-Based Settlement Overview", author: "JPMorgan Payments", source: "JPMorgan Documentation", url: "https://www.jpmorgan.com/onyx/coin-system.htm", year: "2024"),
            ModuleFootnote(id: "di_68", moduleId: "mod_defi_investing", number: "68", title: "Aave Arc Documentation; Compound Treasury Overview", author: "Aave; Compound", source: "Protocol Documentation", url: "https://docs.aave.com", year: "2024"),
            ModuleFootnote(id: "di_69", moduleId: "mod_defi_investing", number: "69", title: "OnChain U.S. Government Money Fund (BENJI) Prospectus", author: "Franklin Templeton", source: "Franklin Templeton Fund Filing", url: "https://www.franklintempleton.com", year: "2024"),
            ModuleFootnote(id: "di_70", moduleId: "mod_defi_investing", number: "70", title: "Digital Asset Adoption Timeline Report", author: "Deloitte", source: "Deloitte Research", url: "https://www2.deloitte.com", year: "2024"),
            ModuleFootnote(id: "di_71", moduleId: "mod_defi_investing", number: "71", title: "Institutional Digital Asset Allocation Framework", author: "Fidelity Digital Assets", source: "Fidelity Digital Assets Research", url: "https://www.fidelitydigitalassets.com/research-and-insights", year: "2024"),
            ModuleFootnote(id: "di_72", moduleId: "mod_defi_investing", number: "72", title: "The Tokenization of Financial Assets", author: "McKinsey & Company", source: "McKinsey Global Institute Report", url: "https://www.mckinsey.com/industries/financial-services/our-insights/from-ripples-to-waves-the-transformational-power-of-tokenizing-assets", year: "2024"),
            ModuleFootnote(id: "di_73", moduleId: "mod_defi_investing", number: "73", title: "Digital Assets: The Road to Mainstream Adoption", author: "Boston Consulting Group (BCG)", source: "BCG Research Report", url: "https://www.bcg.com", year: "2024"),
            ModuleFootnote(id: "di_74", moduleId: "mod_defi_investing", number: "74", title: "Aave Documentation; Compound Documentation", author: "Aave; Compound", source: "Protocol Documentation", url: "https://docs.aave.com", year: "2024"),
            ModuleFootnote(id: "di_75", moduleId: "mod_defi_investing", number: "75", title: "Thinking, Fast and Slow", author: "Kahneman, D.", source: "Farrar, Straus and Giroux", url: nil, year: "2011"),
            ModuleFootnote(id: "di_76", moduleId: "mod_defi_investing", number: "76", title: "Misbehaving: The Making of Behavioral Economics", author: "Thaler, R.", source: "W.W. Norton", url: nil, year: "2015"),
            ModuleFootnote(id: "di_77", moduleId: "mod_defi_investing", number: "77", title: "Cryptoassets: Market Structure and Investment Framework", author: "CFA Institute", source: "CFA Institute Research Foundation", url: "https://www.cfainstitute.org", year: "2023"),
            ModuleFootnote(id: "di_78", moduleId: "mod_defi_investing", number: "78", title: "The Market for Lemons", author: "Akerlof, G.", source: "Quarterly Journal of Economics", url: "https://doi.org/10.2307/1879431", year: "1970"),
            ModuleFootnote(id: "di_79", moduleId: "mod_defi_investing", number: "79", title: "Behavioral Corporate Finance", author: "Shefrin, H.", source: "McGraw-Hill", url: nil, year: "2007"),
            ModuleFootnote(id: "di_80", moduleId: "mod_defi_investing", number: "80", title: "Digital Asset Due Diligence Framework", author: "CFA Institute", source: "CFA Institute Research", url: "https://www.cfainstitute.org", year: "2024"),
            ModuleFootnote(id: "di_81", moduleId: "mod_defi_investing", number: "81", title: "Prospect Theory: An Analysis of Decision under Risk", author: "Kahneman, D., & Tversky, A.", source: "Econometrica, 47(2), 263–292", url: "https://doi.org/10.2307/1914185", year: "1979"),
            ModuleFootnote(id: "di_82", moduleId: "mod_defi_investing", number: "82", title: "Expert Political Judgment", author: "Tetlock, P.", source: "Princeton University Press", url: nil, year: "2005"),
            ModuleFootnote(id: "di_83", moduleId: "mod_defi_investing", number: "83", title: "DefiLlama Documentation; Token Terminal Methodology", author: "DefiLlama; Token Terminal", source: "Protocol Analytics Documentation", url: "https://defillama.com", year: "2024"),
            ModuleFootnote(id: "di_84", moduleId: "mod_defi_investing", number: "84", title: "Smart Contract Security Audits", author: "Trail of Bits; OpenZeppelin", source: "Security Audit Reports", url: "https://www.trailofbits.com/research", year: "2024"),
            ModuleFootnote(id: "di_85", moduleId: "mod_defi_investing", number: "85", title: "Token Incentives and Liquidity Mining Analysis", author: "Messari Research", source: "Messari Research", url: "https://messari.io", year: "2024"),
            ModuleFootnote(id: "di_86", moduleId: "mod_defi_investing", number: "86", title: "Smart Contract Upgradeability and Governance", author: "Ethereum Foundation", source: "Ethereum Foundation Research", url: "https://ethereum.org/en/developers/docs/", year: "2024"),
            ModuleFootnote(id: "di_87", moduleId: "mod_defi_investing", number: "87", title: "Legal Structures in Digital Asset Protocols", author: "Deloitte", source: "Deloitte Research", url: "https://www2.deloitte.com", year: "2024"),
            ModuleFootnote(id: "di_88", moduleId: "mod_defi_investing", number: "88", title: "On-Chain Indicators and Market Structure", author: "Coin Metrics", source: "Coin Metrics Research", url: "https://coinmetrics.io", year: "2024"),
            ModuleFootnote(id: "di_89", moduleId: "mod_defi_investing", number: "89", title: "Protocol Revenue Analytics Framework", author: "Token Terminal", source: "Token Terminal Research", url: "https://tokenterminal.com", year: "2024"),
            ModuleFootnote(id: "di_90", moduleId: "mod_defi_investing", number: "90", title: "On-Chain Supply Distribution Metrics", author: "Glassnode", source: "Glassnode Research", url: "https://glassnode.com", year: "2024"),
            ModuleFootnote(id: "di_91", moduleId: "mod_defi_investing", number: "91", title: "Custody Solutions: Coinbase Prime; Anchorage Digital; BitGo", author: "Coinbase Prime; Anchorage Digital; BitGo", source: "Custody Whitepapers", url: "https://prime.coinbase.com", year: "2024"),
            ModuleFootnote(id: "di_92", moduleId: "mod_defi_investing", number: "92", title: "Crypto Tax Guidance: IRS Notice 2014-21; Koinly; TokenTax; CoinTracker", author: "IRS; Koinly; TokenTax; CoinTracker", source: "Tax Guidance and Tools", url: "https://www.irs.gov/irb/2014-16_IRB", year: "2024"),
            ModuleFootnote(id: "di_93", moduleId: "mod_defi_investing", number: "93", title: "Blockchain and Money; Blockchain and Digital Assets Program", author: "MIT; Wharton School", source: "MIT OpenCourseWare; Wharton Online", url: "https://ocw.mit.edu/courses/15-s12-blockchain-and-money-fall-2018/", year: "2024"),
            ModuleFootnote(id: "di_94", moduleId: "mod_defi_investing", number: "94", title: "Ongoing Monitoring in Alternative Investments", author: "CFA Institute", source: "CFA Institute Research", url: "https://www.cfainstitute.org", year: "2024"),
            ModuleFootnote(id: "di_95", moduleId: "mod_defi_investing", number: "95", title: "Fiduciary Standards and Best Practices", author: "CFP Board", source: "CFP Board Standards", url: "https://www.cfp.net", year: "2024"),
            ModuleFootnote(id: "di_96", moduleId: "mod_defi_investing", number: "96", title: "Investment Adviser Fiduciary Duty Interpretation", author: "U.S. Securities and Exchange Commission (SEC)", source: "SEC Interpretation", url: "https://www.sec.gov", year: "2024"),
            ModuleFootnote(id: "di_97", moduleId: "mod_defi_investing", number: "97", title: "Continuing Education Standards", author: "Financial Planning Association (FPA)", source: "FPA Standards", url: "https://www.onefpa.org", year: "2024"),
            ModuleFootnote(id: "di_98", moduleId: "mod_defi_investing", number: "98", title: "Chainlink Proof of Reserve; Armanino LLP Digital Asset Attestation", author: "Chainlink; Armanino LLP", source: "Attestation Reports", url: "https://chain.link/proof-of-reserve", year: "2024"),
            ModuleFootnote(id: "di_99", moduleId: "mod_defi_investing", number: "99", title: "Coinbase Insurance Disclosure; Gemini Custody Overview", author: "Coinbase; Gemini", source: "Custody Insurance Documentation", url: "https://www.coinbase.com/legal/insurance", year: "2024"),
            ModuleFootnote(id: "di_100", moduleId: "mod_defi_investing", number: "100", title: "Digital Asset Custody Security Guidelines", author: "NIST", source: "NIST Research", url: "https://www.nist.gov", year: "2023"),
            ModuleFootnote(id: "di_101", moduleId: "mod_defi_investing", number: "101", title: "FTX Collapse Hearing Record", author: "U.S. House Financial Services Committee", source: "Congressional Hearing Record", url: "https://financialservices.house.gov", year: "2023"),
            ModuleFootnote(id: "di_102", moduleId: "mod_defi_investing", number: "102", title: "Gas Fee Market and Layer 2 Scaling", author: "Ethereum Foundation", source: "Ethereum Foundation Research", url: "https://ethereum.org/en/developers/docs/gas/", year: "2024"),
            ModuleFootnote(id: "di_103", moduleId: "mod_defi_investing", number: "103", title: "Asset Listing Frameworks: Coinbase; Kraken", author: "Coinbase; Kraken", source: "Exchange Listing Standards", url: "https://www.coinbase.com/asset-framework", year: "2024"),
            ModuleFootnote(id: "di_106", moduleId: "mod_defi_investing", number: "106", title: "Pioneering Portfolio Management", author: "Swensen, D. F.", source: "Free Press", url: nil, year: "2009"),
            ModuleFootnote(id: "di_108", moduleId: "mod_defi_investing", number: "108", title: "Digital Asset Due Diligence Framework", author: "CFA Institute", source: "CFA Institute Research", url: "https://www.cfainstitute.org/en/research/foundation/2024/digital-asset-due-diligence", year: "2024"),
            ModuleFootnote(id: "di_110", moduleId: "mod_defi_investing", number: "110", title: "Trading Is Hazardous to Your Wealth", author: "Barber, B. M., & Odean, T.", source: "Journal of Finance, 55(2), 773–806", url: "https://doi.org/10.1111/0022-1082.00226", year: "2000"),
            ModuleFootnote(id: "di_111", moduleId: "mod_defi_investing", number: "111", title: "Ongoing Monitoring in Alternative Investments", author: "CFA Institute", source: "CFA Institute Research", url: "https://www.cfainstitute.org", year: "2024"),
            ModuleFootnote(id: "di_112", moduleId: "mod_defi_investing", number: "112", title: "The Sharpe Ratio", author: "Sharpe, W. F.", source: "Journal of Portfolio Management, 21(1), 49–58", url: "https://doi.org/10.3905/jpm.1994.409501", year: "1994"),
            ModuleFootnote(id: "di_117", moduleId: "mod_defi_investing", number: "117", title: "Alternative Investments and Portfolio Construction", author: "CFA Institute Research Foundation", source: "CFA Institute Research Foundation", url: "https://rpc.cfainstitute.org/research/foundation/2023/alternative-investments-portfolio-construction", year: "2023"),
            ModuleFootnote(id: "di_121", moduleId: "mod_defi_investing", number: "121", title: "State of DeFi 2025 Report", author: "Messari Crypto Research", source: "Messari Annual Report", url: "https://messari.io/report/state-of-defi-2025", year: "2025"),
            ModuleFootnote(id: "di_122", moduleId: "mod_defi_investing", number: "122", title: "State of DeFi 2025 Report", author: "Messari Crypto Research", source: "Messari Annual Report", url: "https://messari.io/report/state-of-defi-2025", year: "2025"),
            ModuleFootnote(id: "di_126", moduleId: "mod_defi_investing", number: "126", title: "Poor Charlie's Almanack", author: "Munger, C. T.", source: "Donning Company Publishers", url: nil, year: "2005")
        ],

        "mod_kahlo_basquiat": [
            ModuleFootnote(id: "kb_frida_1",   moduleId: "mod_kahlo_basquiat", number: "1",   title: "Frida, A Biography",                                                         author: "Hayden Herrera",                                                                       source: "New York: Harper & Row, pg. 48",                              url: nil,                                                                                          year: "1983"),
            ModuleFootnote(id: "kb_frida_2",   moduleId: "mod_kahlo_basquiat", number: "2",   title: "Frida Kahlo",                                                                 author: "",                                                                                     source: "Biography",                                                   url: "https://www.biography.com/news/frida-kahlo-bus-accident",                                    year: nil),
            ModuleFootnote(id: "kb_frida_3",   moduleId: "mod_kahlo_basquiat", number: "3",   title: "Sep 17 1925, Frida Kahlo Involved in Bus Accident",                           author: "",                                                                                     source: "World History Project",                                       url: "https://worldhistoryproject.org/1925/9/17/frida-kahlo-involved-in-bus-accident",             year: nil),
            ModuleFootnote(id: "kb_frida_4",   moduleId: "mod_kahlo_basquiat", number: "4",   title: "Medical Imagery In The Art Of Frida Kahlo",                                   author: "David Lomas and Rosemary Howell",                                                      source: nil,                                                           url: "https://www.jstor.org/stable/29706431",                                                      year: nil),
            ModuleFootnote(id: "kb_frida_5",   moduleId: "mod_kahlo_basquiat", number: "5",   title: "Kahlo, Letters, pg 25",                                                       author: "",                                                                                     source: nil,                                                           url: nil,                                                                                          year: nil),
            ModuleFootnote(id: "kb_frida_6",   moduleId: "mod_kahlo_basquiat", number: "6",   title: "Inside Frida Kahlo and Diego Rivera's Life in San Francisco",                 author: "Marisol Medina-Cadena",                                                                source: nil,                                                           url: "https://www.kqed.org/news/11848986/inside-frida-kahlo-and-diego-riveras-life-in-san-francisco", year: "2020"),
            ModuleFootnote(id: "kb_frida_6_1", moduleId: "mod_kahlo_basquiat", number: "6.1", title: "Frida in America",                                                            author: "Celia Stahr",                                                                          source: nil,                                                           url: nil,                                                                                          year: nil),
            ModuleFootnote(id: "kb_frida_8",   moduleId: "mod_kahlo_basquiat", number: "8",   title: "Luke 22:44–45",                                                               author: "Multiple",                                                                             source: nil,                                                           url: nil,                                                                                          year: nil),
            ModuleFootnote(id: "kb_frida_9",   moduleId: "mod_kahlo_basquiat", number: "9",   title: "Frida in America, pg 140",                                                    author: "Celia Stahr",                                                                          source: nil,                                                           url: nil,                                                                                          year: nil),
            ModuleFootnote(id: "kb_bas_10",    moduleId: "mod_kahlo_basquiat", number: "10",  title: "Basquiat: Rage to Riches",                                                    author: "David Shulman",                                                                        source: "PBS",                                                         url: "https://www.pbs.org/wnet/americanmasters/basquiat-rage-riches-documentary/10456/",           year: "2018"),
            ModuleFootnote(id: "kb_bas_11",    moduleId: "mod_kahlo_basquiat", number: "11",  title: "Sotheby's",                                                                   author: "",                                                                                     source: nil,                                                           url: "https://www.sothebys.com/en/auctions/ecatalogue/2013/nov-2013-contemporary-day-n09038/lot.249.html", year: nil),
            ModuleFootnote(id: "kb_bas_12",    moduleId: "mod_kahlo_basquiat", number: "12",  title: "The Moon King",                                                               author: "Gianni Mercurio",                                                                      source: "Cat. Fondazione La Triennale de Milano, The Jean Michel Basquiat Show, p. 25", url: nil,                                                               year: "2006"),
            ModuleFootnote(id: "kb_bas_13",    moduleId: "mod_kahlo_basquiat", number: "13",  title: "Christie's Auction House",                                                    author: "",                                                                                     source: "2017 Live Auction 14187 Post-War and Contemporary Art Evening Sale", url: "https://www.christies.com/en/lot/lot-6076435",                     year: "2017"),
            ModuleFootnote(id: "kb_bas_14",    moduleId: "mod_kahlo_basquiat", number: "14",  title: "The Art of Jean-Michel Basquiat",                                             author: "Fred Hoffman",                                                                         source: nil,                                                           url: "https://issuu.com/jeanmichelhoffman/docs/the_art_of_jean-michel_basquiat_by_", year: "2017"),
            ModuleFootnote(id: "kb_bas_15",    moduleId: "mod_kahlo_basquiat", number: "15",  title: "Telling a New Story: Jean-Michel Basquiat",                                   author: "Seph Rodney for Phillips Auction House",                                               source: nil,                                                           url: "https://www.phillips.com/article/94178056/telling-a-new-story-jean-michel-basquiat",         year: nil)
        ]
    ]

    func footnote(number: String, for moduleId: String) -> ModuleFootnote? {
        footnotes(for: moduleId).first { $0.number == number }
    }
}

// MARK: - Inline Footnote Reference View
struct FootnoteReferenceView: View {
    let number: String
    let moduleId: String
    @State private var showingDetail = false
    @ObservedObject var manager = ModuleFootnotesManager.shared

    var body: some View {
        Button {
            showingDetail = true
        } label: {
            Text(superscriptNumber)
                .font(Typography.superscript)
                .foregroundColor(.brandPrimary)
                .baselineOffset(6)
        }
        .sheet(isPresented: $showingDetail) {
            if let footnote = manager.footnote(number: number, for: moduleId) {
                FootnoteDetailView(footnote: footnote)
            }
        }
    }

    // Convert number to Unicode superscript
    private var superscriptNumber: String {
        let superscriptDigits: [Character: Character] = [
            "0": "⁰", "1": "¹", "2": "²", "3": "³", "4": "⁴",
            "5": "⁵", "6": "⁶", "7": "⁷", "8": "⁸", "9": "⁹",
            ".": "·"
        ]
        return String(number.map { superscriptDigits[$0] ?? $0 })
    }
}

// MARK: - Superscript Text Helper
/// Converts a number string to Unicode superscript characters
func toSuperscript(_ number: String) -> String {
    let superscriptDigits: [Character: Character] = [
        "0": "⁰", "1": "¹", "2": "²", "3": "³", "4": "⁴",
        "5": "⁵", "6": "⁶", "7": "⁷", "8": "⁸", "9": "⁹",
        ".": "·"
    ]
    return String(number.map { superscriptDigits[$0] ?? $0 })
}

// MARK: - Footnote Detail View
struct FootnoteDetailView: View {
    let footnote: ModuleFootnote
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.lg) {
                    // Number badge
                    Text(footnote.displayNumber)
                        .font(Typography.title2)
                        .foregroundColor(.brandPrimary)

                    // Title
                    Text(footnote.title)
                        .font(Typography.title3)
                        .foregroundColor(.textPrimary)

                    // Author
                    if !footnote.author.isEmpty {
                        HStack(spacing: Spacing.sm) {
                            Image(systemName: "person.fill")
                                .foregroundColor(.textTertiary)
                            Text(footnote.author)
                                .font(Typography.body)
                                .foregroundColor(.textSecondary)
                        }
                    }

                    // Source
                    if let source = footnote.source, !source.isEmpty {
                        HStack(spacing: Spacing.sm) {
                            Image(systemName: "book.fill")
                                .foregroundColor(.textTertiary)
                            Text(source)
                                .font(Typography.body)
                                .foregroundColor(.textSecondary)
                        }
                    }

                    // Year
                    if let year = footnote.year, !year.isEmpty {
                        HStack(spacing: Spacing.sm) {
                            Image(systemName: "calendar")
                                .foregroundColor(.textTertiary)
                            Text(year)
                                .font(Typography.body)
                                .foregroundColor(.textSecondary)
                        }
                    }

                    // URL Link
                    if let urlString = footnote.url, let url = URL(string: urlString) {
                        Divider()
                            .padding(.vertical, Spacing.sm)

                        Link(destination: url) {
                            HStack {
                                Image(systemName: "link")
                                Text("View Original Source")
                                Spacer()
                                Image(systemName: "arrow.up.right")
                            }
                            .font(Typography.bodyMedium)
                            .foregroundColor(.brandPrimary)
                            .padding(Spacing.md)
                            .background(Color.brandPrimary.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
                        }
                    }

                    // Apple Books Link
                    if let urlString = footnote.appleBooksURL, let url = URL(string: urlString) {
                        if footnote.url == nil {
                            Divider()
                                .padding(.vertical, Spacing.sm)
                        }

                        Link(destination: url) {
                            HStack(spacing: Spacing.xs) {
                                Image(systemName: "book.fill")
                                    .font(.system(size: 13))
                                Text("View on Apple Books")
                                Spacer()
                                Image(systemName: "arrow.up.right")
                            }
                            .font(Typography.bodyMedium)
                            .foregroundColor(.brandPrimary)
                            .padding(Spacing.md)
                            .background(Color.brandPrimary.opacity(0.08))
                            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
                        }
                    }
                }
                .padding(Spacing.lg)
            }
            .background(Color.surfacePrimary)
            .navigationTitle("Source \(footnote.displayNumber)")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

// MARK: - Module Bibliography View
struct ModuleBibliographyView: View {
    let moduleId: String
    let moduleName: String
    @ObservedObject var manager = ModuleFootnotesManager.shared

    var body: some View {
        let footnotes = manager.footnotes(for: moduleId)

        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack(spacing: Spacing.sm) {
                Text("📚")
                    .font(.system(size: 20))
                Text("Sources & References")
                    .font(Typography.bodyMedium)
                    .foregroundColor(.textPrimary)
            }

            if footnotes.isEmpty {
                Text("No sources available for this module.")
                    .font(Typography.caption)
                    .foregroundColor(.textTertiary)
            } else {
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    ForEach(footnotes) { footnote in
                        FootnoteBibliographyRow(footnote: footnote)
                    }
                }
            }
        }
        .padding(Spacing.md)
        .background(Color.surfaceSecondary)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
    }
}

struct FootnoteBibliographyRow: View {
    let footnote: ModuleFootnote
    @State private var showingDetail = false

    var body: some View {
        Button {
            showingDetail = true
        } label: {
            HStack(alignment: .top, spacing: Spacing.sm) {
                Text(footnote.displayNumber)
                    .font(Typography.caption)
                    .foregroundColor(.brandPrimary)
                    .frame(width: 35, alignment: .leading)

                VStack(alignment: .leading, spacing: 2) {
                    Text(footnote.title)
                        .font(Typography.caption)
                        .foregroundColor(.textPrimary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)

                    if !footnote.author.isEmpty {
                        Text(footnote.author)
                            .font(Typography.caption2)
                            .foregroundColor(.textTertiary)
                            .italic()
                    }
                }

                Spacer()

                if footnote.url != nil {
                    Image(systemName: "link")
                        .font(.caption2)
                        .foregroundColor(.brandPrimary)
                }
            }
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showingDetail) {
            FootnoteDetailView(footnote: footnote)
        }
    }
}

// MARK: - Preview
#Preview("Module Bibliography") {
    ScrollView {
        VStack(spacing: 20) {
            ModuleBibliographyView(moduleId: "art-investment", moduleName: "Art as Investment")
            ModuleBibliographyView(moduleId: "alternative-investing", moduleName: "Alternative Investing")
        }
        .padding()
    }
    .background(Color.surfacePrimary)
}

// MARK: - Footnotes Database View (Toolkit)
/// Comprehensive view showing all footnotes across all modules,
/// with optional Notion database integration for additional citations.
struct FootnotesDatabaseView: View {
    @EnvironmentObject var notionService: NotionService
    @ObservedObject var manager = ModuleFootnotesManager.shared

    @State private var searchText = ""
    @State private var selectedModule: String? = nil

    /// Display names for mod_* keys (matches ModuleFootnotesManager.notionTagToKey values)
    private static let moduleDisplayNames: [String: String] = [
        "mod_alt":            "Alternative Investing",
        "mod_women":          "Investing Primer",
        "mod_art":            "Art as Investment",
        "mod_behavioral":     "Behavioral Economics",
        "mod_gender":         "Gender & Behavioral",
        "mod_defi":           "DeFi",
        "mod_kahlo_basquiat": "Kahlo × Basquiat",
        "mod_esg_climate":    "ESG / Climate",
        "mod_defi_investing": "DeFi Investing"
    ]

    /// All footnotes from the manager (live Notion data)
    private var allFootnotes: [ModuleFootnote] {
        manager.footnotesByModule.values.flatMap { $0 }
    }

    /// Footnotes filtered by search and module selection
    private var filteredFootnotes: [ModuleFootnote] {
        allFootnotes.filter { fn in
            let matchesModule = selectedModule == nil || fn.moduleId == selectedModule
            let matchesSearch = searchText.isEmpty ||
                fn.title.localizedCaseInsensitiveContains(searchText) ||
                fn.author.localizedCaseInsensitiveContains(searchText) ||
                (fn.source ?? "").localizedCaseInsensitiveContains(searchText)
            return matchesModule && matchesSearch
        }
        .sorted {
            if $0.moduleId == $1.moduleId {
                let num1 = Double($0.number) ?? 0
                let num2 = Double($1.number) ?? 0
                return num1 < num2
            }
            return $0.moduleId < $1.moduleId
        }
    }

    /// Grouped by module for section display
    private var groupedFootnotes: [(String, [ModuleFootnote])] {
        let grouped = Dictionary(grouping: filteredFootnotes) { $0.moduleId }
        return grouped.sorted { $0.key < $1.key }
    }

    /// Module keys that have footnotes
    private var availableModules: [String] {
        Array(Set(allFootnotes.map { $0.moduleId })).sorted()
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                // Header
                headerSection

                // Search
                searchBar

                // Module filter chips
                moduleFilterChips

                // Stats bar
                statsBar

                // Footnote list
                if manager.isLoading {
                    loadingState
                } else if groupedFootnotes.isEmpty {
                    emptyState
                } else {
                    footnoteSections
                }
            }
            .padding(.bottom, Spacing.xxl)
        }
        .background(Color.surfacePrimary)
        .navigationTitle("Research Footnotes")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .task {
            // Kick off a fresh fetch if data hasn't loaded yet
            if manager.footnotesByModule.isEmpty && !manager.isLoading {
                await manager.fetchFromNotion()
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if manager.isLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                } else {
                    Button {
                        Task { await manager.fetchFromNotion() }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
        }
    }

    // MARK: - Header
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("📑")
                .font(.system(size: 40))

            Text("Research Footnotes")
                .font(Typography.title1)
                .foregroundColor(.textPrimary)

            Text("All sources and citations referenced across modules")
                .font(Typography.body)
                .foregroundColor(.textSecondary)
        }
        .padding(.horizontal, Spacing.lg)
        .padding(.top, Spacing.sm)
    }

    // MARK: - Search
    private var searchBar: some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.textTertiary)
            TextField("Search sources...", text: $searchText)
                .textFieldStyle(.plain)
                .font(Typography.body)
            if !searchText.isEmpty {
                Button { searchText = "" } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.textTertiary)
                }
            }
        }
        .padding(Spacing.sm)
        .background(Color.surfaceSecondary)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
        .padding(.horizontal, Spacing.lg)
    }

    // MARK: - Module Filter
    private var moduleFilterChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.xs) {
                // "All" chip
                Button {
                    selectedModule = nil
                } label: {
                    Text("All")
                        .font(Typography.captionMedium)
                        .foregroundColor(selectedModule == nil ? .white : .textSecondary)
                        .padding(.horizontal, Spacing.md)
                        .padding(.vertical, Spacing.xs)
                        .background(selectedModule == nil ? Color.brandPrimary : Color.surfaceSecondary)
                        .clipShape(Capsule())
                }

                // Module chips
                ForEach(availableModules, id: \.self) { moduleKey in
                    Button {
                        selectedModule = (selectedModule == moduleKey) ? nil : moduleKey
                    } label: {
                        Text(Self.moduleDisplayNames[moduleKey] ?? moduleKey.capitalized)
                            .font(Typography.captionMedium)
                            .foregroundColor(selectedModule == moduleKey ? .white : .textSecondary)
                            .padding(.horizontal, Spacing.md)
                            .padding(.vertical, Spacing.xs)
                            .background(selectedModule == moduleKey ? Color.brandPrimary : Color.surfaceSecondary)
                            .clipShape(Capsule())
                    }
                }
            }
            .padding(.horizontal, Spacing.lg)
        }
    }

    // MARK: - Stats
    private var statsBar: some View {
        HStack(spacing: Spacing.lg) {
            Label("\(allFootnotes.count) Sources", systemImage: "doc.text.fill")
            Label("\(availableModules.count) Modules", systemImage: "square.stack.3d.up.fill")
        }
        .font(Typography.caption)
        .foregroundColor(.textTertiary)
        .padding(.horizontal, Spacing.lg)
    }

    // MARK: - Loading State
    private var loadingState: some View {
        VStack(spacing: Spacing.md) {
            ProgressView()
                .scaleEffect(1.2)
            Text("Loading sources…")
                .font(Typography.caption)
                .foregroundColor(.textTertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.xxl)
    }

    // MARK: - Empty State
    private var emptyState: some View {
        VStack(spacing: Spacing.md) {
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 40))
                .foregroundColor(.textTertiary)
            Text("No matching sources found")
                .font(Typography.bodyMedium)
                .foregroundColor(.textSecondary)
            if !searchText.isEmpty {
                Text("Try a different search term")
                    .font(Typography.caption)
                    .foregroundColor(.textTertiary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.xxl)
    }

    // MARK: - Footnote Sections
    private var footnoteSections: some View {
        LazyVStack(spacing: Spacing.lg, pinnedViews: [.sectionHeaders]) {
            ForEach(groupedFootnotes, id: \.0) { moduleKey, footnotes in
                SwiftUI.Section {
                    VStack(spacing: 0) {
                        ForEach(footnotes) { footnote in
                            FootnoteDatabaseRow(footnote: footnote)

                            if footnote.id != footnotes.last?.id {
                                Divider()
                                    .padding(.leading, 50)
                            }
                        }
                    }
                    .background(Color.surfaceSecondary)
                    .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
                    .padding(.horizontal, Spacing.lg)
                } header: {
                    HStack(spacing: Spacing.sm) {
                        Text(Self.moduleDisplayNames[moduleKey] ?? moduleKey.capitalized)
                            .font(Typography.captionMedium)
                            .foregroundColor(.textPrimary)
                        Spacer()
                        Text("\(footnotes.count) sources")
                            .font(Typography.caption2)
                            .foregroundColor(.textTertiary)
                    }
                    .padding(.horizontal, Spacing.lg)
                    .padding(.vertical, Spacing.xs)
                    .background(Color.surfacePrimary)
                }
            }
        }
    }

}

// MARK: - Footnote Database Row
struct FootnoteDatabaseRow: View {
    let footnote: ModuleFootnote
    @State private var showingDetail = false

    var body: some View {
        Button {
            showingDetail = true
        } label: {
            HStack(alignment: .top, spacing: Spacing.sm) {
                // Number badge
                Text(footnote.displayNumber)
                    .font(Typography.caption)
                    .foregroundColor(.brandPrimary)
                    .frame(width: 40, alignment: .leading)

                // Content
                VStack(alignment: .leading, spacing: 2) {
                    Text(footnote.title)
                        .font(Typography.caption)
                        .foregroundColor(.textPrimary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)

                    if !footnote.author.isEmpty {
                        Text(footnote.author)
                            .font(Typography.caption2)
                            .foregroundColor(.textTertiary)
                            .italic()
                    }

                    HStack(spacing: Spacing.xs) {
                        if let source = footnote.source, !source.isEmpty {
                            Text(source)
                                .font(Typography.caption2)
                                .foregroundColor(.textTertiary)
                        }
                        if let year = footnote.year, !year.isEmpty {
                            Text("(\(year))")
                                .font(Typography.caption2)
                                .foregroundColor(.textTertiary)
                        }
                    }
                }

                Spacer()

                if footnote.url != nil {
                    Image(systemName: "link")
                        .font(.caption2)
                        .foregroundColor(.brandPrimary)
                }
            }
            .padding(.horizontal, Spacing.md)
            .padding(.vertical, Spacing.sm)
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showingDetail) {
            FootnoteDetailView(footnote: footnote)
        }
    }
}

// MARK: - Footnotes Database Preview
#Preview("Footnotes Database") {
    NavigationStack {
        FootnotesDatabaseView()
            .environmentObject(NotionService())
    }
}
