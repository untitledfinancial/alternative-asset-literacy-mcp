//
//  ReadingListView.swift
//  Enhanced App for Alt Assets
//
//  Created by Victoria Case on 4/12/26.
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//
//  Description: Curated reading list spanning behavioral economics, venture capital,
//  economic history, and policy. Each recommendation links to Apple Books.
//

import SwiftUI

// MARK: - Reading List Item
struct ReadingListItem: Identifiable {
    let id = UUID()
    let title: String
    let author: String
    let summary: String
    let category: ReadingCategory
    let appleBooksURL: String
    let yearPublished: String

    enum ReadingCategory: String, CaseIterable {
        case behavioralEconomics = "Behavioral Economics"
        case ventureCapital = "Venture Capital"
        case economicHistory = "Economic History"
        case policy = "Policy"

        var icon: String {
            switch self {
            case .behavioralEconomics: return "brain.head.profile"
            case .ventureCapital: return "chart.line.uptrend.xyaxis"
            case .economicHistory: return "clock.arrow.circlepath"
            case .policy: return "building.columns"
            }
        }

        var color: Color {
            switch self {
            case .behavioralEconomics: return .purple
            case .ventureCapital: return .blue
            case .economicHistory: return .orange
            case .policy: return .teal
            }
        }
    }
}

// MARK: - Reading List Data
struct ReadingListData {
    static let items: [ReadingListItem] = [
        // Behavioral Economics
        ReadingListItem(
            title: "The Psychology of Money",
            author: "Morgan Housel",
            summary: "Nineteen short stories exploring the strange ways people think about money — and how doing well with it is less about what you know and more about how you behave.",
            category: .behavioralEconomics,
            appleBooksURL: "https://books.apple.com/us/book/the-psychology-of-money/id1518559900?at=1000l3by8",
            yearPublished: "2020"
        ),

        // Venture Capital
        ReadingListItem(
            title: "The Power Law",
            author: "Sebastian Mallaby",
            summary: "The definitive history of venture capital — from Sequoia and Kleiner Perkins to Andreessen Horowitz. How a small group of investors fueled the companies that transformed the world.",
            category: .ventureCapital,
            appleBooksURL: "https://books.apple.com/us/book/the-power-law/id1566099489?at=1000l3by8",
            yearPublished: "2022"
        ),
        ReadingListItem(
            title: "The Code",
            author: "Margaret O'Mara",
            summary: "The true, behind-the-scenes history of Silicon Valley — from the Pentagon and Stanford to the mavericks who built an industry. The definitive account of how technology reshaped America.",
            category: .ventureCapital,
            appleBooksURL: "https://books.apple.com/us/audiobook/the-code-silicon-valley-and-the/id1467843262?at=1000l3by8",
            yearPublished: "2019"
        ),

        // Economic History
        ReadingListItem(
            title: "The Great Crash 1929",
            author: "John Kenneth Galbraith",
            summary: "The classic account of the speculative mania and systemic failures that led to the worst financial collapse in American history. As relevant now as when first published in 1955.",
            category: .economicHistory,
            appleBooksURL: "https://books.apple.com/us/book/the-great-crash-1929/id427695965?at=1000l3by8",
            yearPublished: "1955"
        ),

        // Policy
        ReadingListItem(
            title: "Abundance",
            author: "Ezra Klein & Derek Thompson",
            summary: "A paradigm-shifting call to renew a politics of plenty, face up to the failures of governance, and abandon the chosen scarcities that have deformed American life.",
            category: .policy,
            appleBooksURL: "https://books.apple.com/us/book/abundance/id6450192113?at=1000l3by8",
            yearPublished: "2025"
        ),
    ]
}

// MARK: - Reading List View
struct ReadingListView: View {
    @State private var selectedCategory: ReadingListItem.ReadingCategory?

    var filteredItems: [ReadingListItem] {
        if let category = selectedCategory {
            return ReadingListData.items.filter { $0.category == category }
        }
        return ReadingListData.items
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                // Header
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Text("Reading List")
                        .font(Typography.title1)
                        .foregroundColor(.textPrimary)

                    Text("Curated books across economics, policy, and venture capital")
                        .font(Typography.body)
                        .foregroundColor(.textSecondary)
                }
                .padding(.horizontal, Spacing.lg)

                // Category filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: Spacing.xs) {
                        FilterChipButton(
                            title: "All",
                            icon: "books.vertical",
                            isSelected: selectedCategory == nil,
                            color: .brandPrimary
                        ) {
                            selectedCategory = nil
                        }

                        ForEach(ReadingListItem.ReadingCategory.allCases, id: \.self) { category in
                            FilterChipButton(
                                title: category.rawValue,
                                icon: category.icon,
                                isSelected: selectedCategory == category,
                                color: category.color
                            ) {
                                selectedCategory = (selectedCategory == category) ? nil : category
                            }
                        }
                    }
                    .padding(.horizontal, Spacing.lg)
                }

                // Book cards
                LazyVStack(spacing: Spacing.sm) {
                    ForEach(filteredItems) { item in
                        ReadingListCard(item: item)
                    }
                }
                .padding(.horizontal, Spacing.lg)
            }
            .padding(.vertical, Spacing.lg)
        }
        .background(Color.surfacePrimary)
        .navigationTitle("Reading List")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

// MARK: - Filter Chip Button
private struct FilterChipButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 10))
                Text(title)
                    .font(Typography.caption)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isSelected ? color.opacity(0.15) : Color.surfaceSecondary)
            .foregroundColor(isSelected ? color : .textSecondary)
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Reading List Card
struct ReadingListCard: View {
    let item: ReadingListItem

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack(alignment: .top) {
                // Category icon
                Image(systemName: item.category.icon)
                    .font(.system(size: 20))
                    .foregroundColor(item.category.color)
                    .frame(width: 28)

                VStack(alignment: .leading, spacing: 3) {
                    Text(item.title)
                        .font(Typography.bodyMedium)
                        .foregroundColor(.textPrimary)
                        .lineLimit(2)

                    Text(item.author)
                        .font(Typography.caption)
                        .foregroundColor(.textTertiary)
                        .italic()
                }

                Spacer()

                // Year + Category badge
                VStack(alignment: .trailing, spacing: 4) {
                    Text(item.yearPublished)
                        .font(.system(size: 9, weight: .medium, design: .monospaced))
                        .foregroundColor(.textTertiary)

                    Text(item.category.rawValue)
                        .font(.system(size: 8, weight: .medium))
                        .foregroundColor(item.category.color)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(item.category.color.opacity(0.1))
                        .clipShape(Capsule())
                }
            }

            Text(item.summary)
                .font(Typography.caption)
                .foregroundColor(.textSecondary)
                .lineLimit(3)

            // Apple Books link
            if let url = URL(string: item.appleBooksURL) {
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
        ReadingListView()
    }
}
