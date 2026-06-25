//
//  ArtLibraryView.swift
//  Enhanced App for Alt Assets
//
//  Created by Victoria Case on 2/25/26.
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//
//  Description: Art Library sourced from Notion — books, podcasts, and digital
//  resources curated for art investing education.
//  Notion page: 02fd68e8-5f9e-452e-b856-f67d0f6fe422
//

import SwiftUI

// MARK: - Art Library Item Model
struct ArtLibraryItem: Identifiable {
    let id = UUID()
    var title: String
    var author: String
    var summary: String
    var type: String         // "Art Books", "Podcast", "Digital"
    var source: String
    var picksBy: String
    var category: LibraryCategory
    var appleBooksURL: String?

    enum LibraryCategory: String, CaseIterable {
        case books = "Books"
        case podcasts = "Podcasts"
        case digital = "Digital Library"

        var emoji: String {
            switch self {
            case .books: return "📚"
            case .podcasts: return "🎙️"
            case .digital: return "💻"
            }
        }

        var color: Color {
            switch self {
            case .books: return .orange
            case .podcasts: return .purple
            case .digital: return .blue
            }
        }
    }
}

// MARK: - Art Library Data (from Notion)
struct ArtLibraryData {

    // Database IDs for Notion fetching
    static let libraryDbId = "d1477dc0-2093-4187-8637-75b57f2301ff"
    static let podcastsDbId = "4b30f8a0-0224-4892-ac74-8605ca75194d"
    static let digitalDbId = "4351b4ce-fe9a-4e0e-ab12-e4a5689abba2"

    // Curated static data (fallback / initial load)
    static let items: [ArtLibraryItem] = [
        // Books
        ArtLibraryItem(title: "Bruce Nauman: Disappearing Acts", author: "", summary: "Chosen by the New York Times as one of the Best Art Books.", type: "Art Books", source: "", picksBy: "", category: .books),
        ArtLibraryItem(title: "Girl's Window", author: "Betye Saar", summary: "In 1969 Betye Saar created Black Girl's Window, assembling found images and personal symbols.", type: "Art Books", source: "", picksBy: "", category: .books),
        ArtLibraryItem(title: "Ellsworth Kelly", author: "", summary: "Ellsworth Kelly will forever be remembered as one of the most important abstract artists.", type: "Art Books", source: "", picksBy: "", category: .books),
        ArtLibraryItem(title: "Hilma af Klint: Paintings for the Future", author: "", summary: "When Swedish artist Hilma af Klint died in 1944, she left behind more than 1,000 paintings.", type: "Art Books", source: "", picksBy: "", category: .books),
        ArtLibraryItem(title: "Jasper Johns", author: "", summary: "The art of Jasper Johns has affected nearly every artistic movement since the 1950s.", type: "Art Books", source: "", picksBy: "", category: .books),
        ArtLibraryItem(title: "Wall and Piece", author: "Banksy", summary: "Banksy, Britain's legendary guerilla street artist, has created provocative art worldwide.", type: "Art Books", source: "", picksBy: "", category: .books),

        // Podcasts
        ArtLibraryItem(title: "Georgia O'Keeffe: Watercolors", author: "", summary: "Exploring the watercolor works of Georgia O'Keeffe.", type: "Podcast", source: "", picksBy: "", category: .podcasts),
        ArtLibraryItem(title: "Young, Gifted and Black", author: "", summary: "A New Generation of Artists: The Lumpkin-Boccuzzi Family Collection of Contemporary Art.", type: "Podcast", source: "", picksBy: "", category: .podcasts),

        // Digital
        ArtLibraryItem(title: "A History of Pictures", author: "David Hockney", summary: "From the Cave to the Computer Screen — a visual journey through art history.", type: "Digital", source: "", picksBy: "", category: .digital),
        ArtLibraryItem(title: "A Year in the Art World", author: "", summary: "An inside look at the contemporary art world over the course of a year.", type: "Digital", source: "", picksBy: "", category: .digital),
    ]
}

// MARK: - Art Library View
struct ArtLibraryView: View {
    @State private var selectedCategory: ArtLibraryItem.LibraryCategory?
    @State private var searchText = ""
    @State private var items: [ArtLibraryItem] = ArtLibraryData.items
    @EnvironmentObject var notionService: NotionService

    var filteredItems: [ArtLibraryItem] {
        items.filter { item in
            let matchesSearch = searchText.isEmpty ||
                item.title.localizedCaseInsensitiveContains(searchText) ||
                item.author.localizedCaseInsensitiveContains(searchText) ||
                item.summary.localizedCaseInsensitiveContains(searchText)
            let matchesCategory = selectedCategory == nil || item.category == selectedCategory
            return matchesSearch && matchesCategory
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                // Header
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Text("🎨")
                        .font(.system(size: 40))

                    Text("Art Library")
                        .font(Typography.title1)
                        .foregroundColor(.textPrimary)

                    Text("Curated books, podcasts, and digital resources for art investing")
                        .font(Typography.body)
                        .foregroundColor(.textSecondary)

                    // Stats
                    HStack(spacing: Spacing.lg) {
                        let bookCount = items.filter { $0.category == .books }.count
                        let podcastCount = items.filter { $0.category == .podcasts }.count
                        let digitalCount = items.filter { $0.category == .digital }.count

                        Label("\(bookCount) Books", systemImage: "book.fill")
                        Label("\(podcastCount) Podcasts", systemImage: "headphones")
                        Label("\(digitalCount) Digital", systemImage: "display")
                    }
                    .font(Typography.caption)
                    .foregroundColor(.textTertiary)
                }
                .padding(.horizontal, Spacing.lg)

                // Search
                HStack(spacing: Spacing.sm) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.textTertiary)
                    TextField("Search library...", text: $searchText)
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

                // Category filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: Spacing.xs) {
                        CategoryFilterChip(title: "All", emoji: "📖", isSelected: selectedCategory == nil, color: .brandPrimary) {
                            selectedCategory = nil
                        }
                        ForEach(ArtLibraryItem.LibraryCategory.allCases, id: \.self) { cat in
                            CategoryFilterChip(title: cat.rawValue, emoji: cat.emoji, isSelected: selectedCategory == cat, color: cat.color) {
                                selectedCategory = (selectedCategory == cat) ? nil : cat
                            }
                        }
                    }
                    .padding(.horizontal, Spacing.lg)
                }

                // Items
                LazyVStack(spacing: Spacing.sm) {
                    ForEach(filteredItems) { item in
                        ArtLibraryCard(item: item)
                    }
                }
                .padding(.horizontal, Spacing.lg)
            }
            .padding(.vertical, Spacing.lg)
        }
        .background(Color.surfacePrimary)
        .navigationTitle("Art Library")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .task {
            await fetchFromNotion()
        }
    }

    // MARK: - Fetch from Notion
    private func fetchFromNotion() async {
        guard !notionService.apiKey.isEmpty else { return }

        var fetched: [ArtLibraryItem] = []

        // Fetch each database
        for (dbId, category) in [
            (ArtLibraryData.libraryDbId, ArtLibraryItem.LibraryCategory.books),
            (ArtLibraryData.podcastsDbId, ArtLibraryItem.LibraryCategory.podcasts),
            (ArtLibraryData.digitalDbId, ArtLibraryItem.LibraryCategory.digital)
        ] {
            do {
                let pages = try await notionService.fetchDatabaseEntries(databaseId: dbId)
                for page in pages {
                    let title = page.properties.first(where: { $0.value.title != nil })?.value.title?.map { $0.plainText }.joined() ?? ""
                    let author = page.properties["Author"]?.richText?.map { $0.plainText }.joined() ?? ""
                    let summary = page.properties["Summery"]?.richText?.map { $0.plainText }.joined() ?? ""
                    let type = page.properties["Type"]?.select?.name ?? category.rawValue
                    let source = page.properties["Source"]?.richText?.map { $0.plainText }.joined() ?? ""
                    let picksBy = page.properties["Picks by_"]?.richText?.map { $0.plainText }.joined() ?? ""
                    let appleBooksURL = page.properties["Apple Books URL"]?.url ?? page.properties["Apple Books"]?.richText?.map { $0.plainText }.joined()

                    if !title.isEmpty {
                        fetched.append(ArtLibraryItem(
                            title: title, author: author, summary: summary,
                            type: type, source: source, picksBy: picksBy,
                            category: category,
                            appleBooksURL: appleBooksURL
                        ))
                    }
                }
            } catch {
                debugLog("Failed to fetch Art Library DB \(dbId): \(error)")
            }
        }

        if !fetched.isEmpty {
            // Deduplicate by title (Notion databases may return overlapping entries)
            var seen = Set<String>()
            let unique = fetched.filter { item in
                let key = item.title.lowercased().trimmingCharacters(in: .whitespaces)
                guard !seen.contains(key) else { return false }
                seen.insert(key)
                return true
            }
            await MainActor.run {
                items = unique.sorted { $0.title < $1.title }
            }
        }
    }
}

// MARK: - Art Library Card
struct ArtLibraryCard: View {
    let item: ArtLibraryItem

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack(alignment: .top) {
                // Category icon
                Text(item.category.emoji)
                    .font(.system(size: 24))

                VStack(alignment: .leading, spacing: 3) {
                    Text(item.title)
                        .font(Typography.bodyMedium)
                        .foregroundColor(.textPrimary)
                        .lineLimit(2)

                    if !item.author.isEmpty {
                        Text(item.author)
                            .font(Typography.caption)
                            .foregroundColor(.textTertiary)
                            .italic()
                    }
                }

                Spacer()

                // Type badge
                Text(item.type)
                    .font(.system(size: 9, weight: .medium))
                    .foregroundColor(item.category.color)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(item.category.color.opacity(0.1))
                    .clipShape(Capsule())
            }

            if !item.summary.isEmpty {
                Text(item.summary)
                    .font(Typography.caption)
                    .foregroundColor(.textSecondary)
                    .lineLimit(3)
            }

            // Apple Books link
            if let urlString = item.appleBooksURL, let url = URL(string: urlString) {
                Link(destination: url) {
                    HStack(spacing: Spacing.xs) {
                        Image(systemName: "book.fill")
                            .font(.system(size: 11))
                        Text("View on Apple Books")
                            .font(Typography.caption)
                    }
                    .foregroundColor(.brandPrimary)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 12)
                    .background(Color.brandPrimary.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: CornerRadius.sm))
                }
            }
        }
        .padding(Spacing.md)
        .background(Color.surfaceSecondary)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
    }
}

#Preview {
    NavigationStack {
        ArtLibraryView()
            .environmentObject(NotionService())
    }
}
