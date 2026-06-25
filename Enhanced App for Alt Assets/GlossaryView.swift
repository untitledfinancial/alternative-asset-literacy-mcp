//
//  GlossaryView.swift
//  Enhanced App for Alt Assets
//
//  Created by Victoria Case on 2/1/26.
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//
//  Description: Unified glossary combining ALL module-specific terms from every
//  source: Notion (Art, DeFi, Investing, Jargon), ESG/Climate, and DeFi Learning.
//  Displayed alphabetically with search, category filtering, and section index.
//

import SwiftUI

struct GlossaryView: View {
    @State private var searchText = ""
    @State private var selectedCategory: GlossaryTerm.Category?
    @State private var selectedTerm: GlossaryTerm?

    // All terms from every module, unified and deduplicated
    @State private var terms: [GlossaryTerm] = []

    var filteredTerms: [GlossaryTerm] {
        terms.filter { term in
            let matchesSearch = searchText.isEmpty ||
                term.term.localizedCaseInsensitiveContains(searchText) ||
                term.definition.localizedCaseInsensitiveContains(searchText)
            let matchesCategory = selectedCategory == nil || term.category == selectedCategory
            return matchesSearch && matchesCategory
        }
    }

    /// Group filtered terms by first letter for alphabetical sections
    var groupedTerms: [(String, [GlossaryTerm])] {
        let dict = Dictionary(grouping: filteredTerms) { term -> String in
            let first = term.term.prefix(1).uppercased()
            return first.isEmpty ? "#" : first
        }
        return dict.sorted { $0.key < $1.key }
    }

    /// All available section letters for the side index
    var sectionLetters: [String] {
        groupedTerms.map { $0.0 }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Stats header
            statsHeader

            // Search bar
            searchBar

            // Category filter chips
            categoryFilter

            Divider()

            // Terms list grouped alphabetically
            if filteredTerms.isEmpty {
                emptyStateView
            } else {
                termsList
            }
        }
        .background(Color.surfacePrimary)
        .navigationTitle("Terms")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.large)
        #endif
        .onAppear {
            loadAllTerms()
        }
        .sheet(item: $selectedTerm) { term in
            NavigationStack {
                TermDetailSheet(term: term, allTerms: terms, onSelectRelated: { related in
                    selectedTerm = related
                })
            }
        }
    }

    // MARK: - Stats Header
    private var statsHeader: some View {
        HStack(spacing: Spacing.lg) {
            GlossaryStatBadge(
                value: "\(terms.count)",
                label: "Total Terms",
                color: .brandPrimary
            )

            GlossaryStatBadge(
                value: "\(categoryCountsActive)",
                label: "Categories",
                color: .info
            )

            GlossaryStatBadge(
                value: "\(sourceCount)",
                label: "Databases",
                color: .success
            )
        }
        .padding(.horizontal, Spacing.lg)
        .padding(.vertical, Spacing.sm)
    }

    private var categoryCountsActive: Int {
        Set(terms.map { $0.category }).count
    }

    private var sourceCount: Int {
        // Art (MoMA), DeFi (WEF), Investing, Jargon, ESG, DeFi Module
        let modules = Set(terms.flatMap { $0.usedInModules })
        return max(modules.count, 4)
    }

    // MARK: - Search Bar
    private var searchBar: some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.textTertiary)
                .font(.body)

            TextField("Search \(terms.count) terms...", text: $searchText)
                .textFieldStyle(.plain)
                .font(Typography.body)

            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.textTertiary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(Spacing.sm)
        .background(Color.surfaceSecondary)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
        .padding(.horizontal, Spacing.lg)
        .padding(.vertical, Spacing.xs)
    }

    // MARK: - Category Filter
    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.xs) {
                CategoryPill(
                    title: "All",
                    emoji: nil,
                    isSelected: selectedCategory == nil,
                    count: terms.count
                ) {
                    selectedCategory = nil
                }

                ForEach(GlossaryTerm.Category.allCases, id: \.self) { category in
                    let count = terms.filter { $0.category == category }.count
                    if count > 0 {
                        CategoryPill(
                            title: category.rawValue,
                            emoji: categoryEmoji(for: category),
                            isSelected: selectedCategory == category,
                            count: count
                        ) {
                            selectedCategory = (selectedCategory == category) ? nil : category
                        }
                    }
                }
            }
            .padding(.horizontal, Spacing.lg)
        }
        .padding(.vertical, Spacing.xs)
    }

    // MARK: - Terms List
    private var termsList: some View {
        ScrollViewReader { proxy in
            ZStack(alignment: .trailing) {
                ScrollView {
                    LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                        ForEach(groupedTerms, id: \.0) { letter, termsInSection in
                            SwiftUI.Section {
                                ForEach(termsInSection) { term in
                                    Button {
                                        selectedTerm = term
                                    } label: {
                                        UnifiedTermRow(term: term)
                                    }
                                    .buttonStyle(.plain)
                                    .padding(.horizontal, Spacing.lg)

                                    Divider()
                                        .padding(.leading, Spacing.lg)
                                }
                            } header: {
                                Text(letter)
                                    .font(Typography.title3)
                                    .foregroundColor(.textPrimary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal, Spacing.lg)
                                    .padding(.vertical, Spacing.xs)
                                    .background(Color.surfacePrimary)
                                    .id(letter)
                            }
                        }
                    }
                }

                // Alphabet side index (iPhone-style) — tappable, scrolls to section
                if sectionLetters.count > 3 {
                    VStack(spacing: 1) {
                        ForEach(sectionLetters, id: \.self) { letter in
                            Button {
                                withAnimation {
                                    proxy.scrollTo(letter, anchor: .top)
                                }
                            } label: {
                                Text(letter)
                                    .font(.system(size: 10, weight: .semibold))
                                    .foregroundColor(.brandPrimary)
                                    .frame(width: 16, height: 14)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.trailing, 4)
                    .padding(.vertical, Spacing.xs)
                }
            }
        }
    }

    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack(spacing: Spacing.md) {
            Spacer()
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundColor(.textTertiary)

            Text("No terms found")
                .font(Typography.bodyMedium)
                .foregroundColor(.textSecondary)

            if !searchText.isEmpty {
                Text("Try a different search term")
                    .font(Typography.caption)
                    .foregroundColor(.textTertiary)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Data Loading
    private func loadAllTerms() {
        // Load ALL terms from every module source, deduplicated and alphabetized
        terms = NotionGlossaryData.allTermsUnified()
    }

    // MARK: - Helpers
    private func categoryEmoji(for category: GlossaryTerm.Category) -> String {
        switch category {
        case .art: return "🎨"
        case .behavioral: return "🧠"
        case .finance: return "💵"
        case .investing: return "📊"
        case .altAssets: return "🖼️"
        case .risk: return "⚠️"
        case .gender: return "♀️"
        case .defi: return "⛓️"
        case .esg: return "🌱"
        case .general: return "📖"
        }
    }
}

// MARK: - Unified Term Row
struct UnifiedTermRow: View {
    let term: GlossaryTerm

    var body: some View {
        HStack(alignment: .top, spacing: Spacing.sm) {
            // Category color indicator
            RoundedRectangle(cornerRadius: 2)
                .fill(categoryColor)
                .frame(width: 4, height: 40)

            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: Spacing.xs) {
                    Text(term.term)
                        .font(Typography.bodyMedium)
                        .foregroundColor(.textPrimary)
                        .lineLimit(1)

                    Spacer()

                    // Category badge
                    Text(term.category.rawValue)
                        .font(.system(size: 9, weight: .medium))
                        .foregroundColor(categoryColor)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(categoryColor.opacity(0.1))
                        .clipShape(Capsule())
                }

                Text(term.definition)
                    .font(Typography.caption)
                    .foregroundColor(.textSecondary)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, Spacing.xxs)
    }

    private var categoryColor: Color {
        switch term.category {
        case .art: return .orange
        case .behavioral: return .purple
        case .finance: return .blue
        case .investing: return .green
        case .altAssets: return .brown
        case .risk: return .red
        case .gender: return .pink
        case .defi: return .cyan
        case .esg: return .mint
        case .general: return .gray
        }
    }
}

// MARK: - Term Detail Sheet (iPhone-friendly)
struct TermDetailSheet: View {
    let term: GlossaryTerm
    let allTerms: [GlossaryTerm]
    let onSelectRelated: (GlossaryTerm) -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                // Header
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Text(term.term)
                        .font(Typography.displaySmall)
                        .foregroundColor(.textPrimary)

                    Text(term.category.rawValue)
                        .font(Typography.captionMedium)
                        .padding(.horizontal, Spacing.sm)
                        .padding(.vertical, Spacing.xxs)
                        .background(Color.brandPrimary.opacity(0.1))
                        .foregroundColor(.brandPrimary)
                        .clipShape(Capsule())
                }

                Divider()

                // Definition
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Label("Definition", systemImage: "text.book.closed.fill")
                        .font(Typography.bodyMedium)
                        .foregroundColor(.textPrimary)

                    Text(term.definition)
                        .font(Typography.body)
                        .foregroundColor(.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                // Simple explanation
                if let simple = term.simpleExplanation {
                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        Label("In Simple Terms", systemImage: "lightbulb.fill")
                            .font(Typography.bodyMedium)
                            .foregroundColor(.success)

                        Text(simple)
                            .font(Typography.body)
                            .foregroundColor(.textSecondary)
                    }
                    .padding(Spacing.md)
                    .background(Color.success.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
                }

                // Examples
                if !term.examples.isEmpty {
                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        Label("Examples", systemImage: "list.bullet")
                            .font(Typography.bodyMedium)
                            .foregroundColor(.textPrimary)

                        ForEach(Array(term.examples.enumerated()), id: \.offset) { index, example in
                            HStack(alignment: .top, spacing: Spacing.sm) {
                                Text("\(index + 1).")
                                    .font(Typography.caption)
                                    .foregroundColor(.textTertiary)
                                    .frame(width: 20, alignment: .trailing)
                                Text(example)
                                    .font(Typography.body)
                                    .foregroundColor(.textSecondary)
                            }
                        }
                    }
                }

                // Related terms
                if !term.relatedTerms.isEmpty {
                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        Label("Related Concepts", systemImage: "link")
                            .font(Typography.bodyMedium)
                            .foregroundColor(.textPrimary)

                        GlossaryFlowLayout(spacing: Spacing.xs) {
                            ForEach(term.relatedTerms, id: \.self) { relatedId in
                                // Try matching by ID first, then by term name
                                if let relatedTerm = allTerms.first(where: { $0.id == relatedId })
                                    ?? allTerms.first(where: { $0.term.localizedCaseInsensitiveContains(relatedId) }) {
                                    Button {
                                        onSelectRelated(relatedTerm)
                                    } label: {
                                        Text(relatedTerm.term)
                                            .font(Typography.caption)
                                            .foregroundColor(.brandPrimary)
                                            .padding(.horizontal, Spacing.sm)
                                            .padding(.vertical, Spacing.xxs)
                                            .background(Color.brandPrimary.opacity(0.1))
                                            .clipShape(Capsule())
                                    }
                                    .buttonStyle(.plain)
                                } else {
                                    // Show as non-tappable chip if no match found
                                    Text(relatedId)
                                        .font(Typography.caption)
                                        .foregroundColor(.textTertiary)
                                        .padding(.horizontal, Spacing.sm)
                                        .padding(.vertical, Spacing.xxs)
                                        .background(Color.surfaceSecondary)
                                        .clipShape(Capsule())
                                }
                            }
                        }
                    }
                }

                // Module source
                if !term.usedInModules.isEmpty {
                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        Label("Appears In", systemImage: "book.fill")
                            .font(Typography.bodyMedium)
                            .foregroundColor(.textPrimary)

                        ForEach(term.usedInModules, id: \.self) { moduleId in
                            HStack(spacing: Spacing.xs) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.success)
                                    .font(.caption)
                                Text(moduleDisplayName(for: moduleId))
                                    .font(Typography.caption)
                                    .foregroundColor(.textSecondary)
                            }
                        }
                    }
                    .padding(Spacing.md)
                    .background(Color.surfaceSecondary)
                    .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
                }
            }
            .padding(Spacing.lg)
        }
        .background(Color.surfacePrimary)
        .navigationTitle(term.term)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") { dismiss() }
            }
        }
    }

    private func moduleDisplayName(for id: String) -> String {
        switch id {
        case "art": return "Art as Alternative Asset"
        case "defi": return "Decentralized Finance (DeFi)"
        case "behavioral": return "Behavioral Economics"
        case "investing", "primer": return "Investing Primer"
        case "esg_climate": return "Climate / ESG / RWAs"
        case "gender": return "Gender & Behavioral"
        default: return id.replacingOccurrences(of: "_", with: " ").capitalized
        }
    }
}

// MARK: - Flow Layout (for related terms chips)
struct GlossaryFlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = arrangeSubviews(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrangeSubviews(proposal: proposal, subviews: subviews)
        for (index, position) in result.positions.enumerated() {
            subviews[index].place(at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y), proposal: .unspecified)
        }
    }

    private func arrangeSubviews(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, positions: [CGPoint]) {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var lineHeight: CGFloat = 0
        var maxX: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)

            if currentX + size.width > maxWidth && currentX > 0 {
                currentX = 0
                currentY += lineHeight + spacing
                lineHeight = 0
            }

            positions.append(CGPoint(x: currentX, y: currentY))
            lineHeight = max(lineHeight, size.height)
            currentX += size.width + spacing
            maxX = max(maxX, currentX)
        }

        return (CGSize(width: maxX, height: currentY + lineHeight), positions)
    }
}

// MARK: - Category Pill
struct CategoryPill: View {
    let title: String
    let emoji: String?
    let isSelected: Bool
    let count: Int
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                if let emoji = emoji {
                    Text(emoji)
                        .font(.system(size: 11))
                }
                Text(title)
                    .font(.system(size: 11, weight: isSelected ? .semibold : .regular))
                Text("(\(count))")
                    .font(.system(size: 9))
                    .foregroundColor(isSelected ? .white.opacity(0.8) : .textTertiary)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(isSelected ? Color.brandPrimary : Color.surfaceSecondary)
            .foregroundColor(isSelected ? .white : .textPrimary)
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Stat Badge
struct GlossaryStatBadge: View {
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(Typography.title3)
                .foregroundColor(color)
            Text(label)
                .font(Typography.caption2)
                .foregroundColor(.textTertiary)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    NavigationStack {
        GlossaryView()
    }
}
