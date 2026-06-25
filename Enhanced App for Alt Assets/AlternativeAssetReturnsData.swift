//
//  AlternativeAssetReturnsData.swift
//  Enhanced App for Alt Assets
//
//  Created by Victoria Case on 2/10/26.
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//
//  Description: Comprehensive historical returns data catalog for alternative assets.
//  Includes performance metrics, volatility data, and correlation information.
//  All data sourced from industry research and publications.
//

import SwiftUI

// MARK: - Asset Return Data Model
struct AssetReturnData: Identifiable {
    let id = UUID()
    let assetClass: String
    let category: AssetCategory
    let annualizedReturn: Double          // Percentage (e.g., 10.5 for 10.5%)
    let volatility: Double?               // Standard deviation percentage
    let timePeriod: String                // e.g., "10-year", "1991-2022"
    let sharpeRatio: Double?              // Risk-adjusted return
    let correlationToSP500: Double?       // -1 to 1
    let source: String
    let notes: String?
    let icon: String

    enum AssetCategory: String, CaseIterable {
        case traditionalAlts = "Traditional Alternatives"
        case realAssets = "Real Assets"
        case collectibles = "Collectibles"
        case digitalAssets = "Digital Assets"
        case sustainable = "Sustainable/ESG"
        case benchmark = "Benchmarks"
    }
}

// MARK: - Historical Returns Catalog
struct AlternativeAssetReturnsCatalog {

    // MARK: - All Asset Return Data
    static let allAssets: [AssetReturnData] = [

        // MARK: Benchmarks (for comparison)
        AssetReturnData(
            assetClass: "S&P 500",
            category: .benchmark,
            annualizedReturn: 11.0,
            volatility: 15.9,
            timePeriod: "1991-2020",
            sharpeRatio: 0.76,
            correlationToSP500: 1.0,
            source: "NCREIF, Historical Analysis",
            notes: "Traditional equity benchmark",
            icon: "📊"
        ),
        AssetReturnData(
            assetClass: "Nasdaq Composite",
            category: .benchmark,
            annualizedReturn: 15.0,
            volatility: 22.0,
            timePeriod: "10-year (2015-2025)",
            sharpeRatio: nil,
            correlationToSP500: 0.92,
            source: "Tickeron Research",
            notes: "Tech-heavy index benchmark",
            icon: "💻"
        ),
        AssetReturnData(
            assetClass: "US Bonds (Aggregate)",
            category: .benchmark,
            annualizedReturn: 4.5,
            volatility: 5.0,
            timePeriod: "Long-term average",
            sharpeRatio: nil,
            correlationToSP500: 0.1,
            source: "Historical Bond Data",
            notes: "Fixed income benchmark",
            icon: "📜"
        ),

        // MARK: Traditional Alternatives
        AssetReturnData(
            assetClass: "Private Equity",
            category: .traditionalAlts,
            annualizedReturn: 13.0,
            volatility: 21.0,
            timePeriod: "Long-term average",
            sharpeRatio: nil,
            correlationToSP500: 0.7,
            source: "Private Markets Research",
            notes: "Net of fees; ranges 10-13% annualized",
            icon: "🏢"
        ),
        AssetReturnData(
            assetClass: "Venture Capital",
            category: .traditionalAlts,
            annualizedReturn: 15.0,
            volatility: 35.0,
            timePeriod: "Long-term average",
            sharpeRatio: nil,
            correlationToSP500: 0.5,
            source: "Cambridge Associates",
            notes: "High dispersion; top quartile significantly higher",
            icon: "🚀"
        ),
        AssetReturnData(
            assetClass: "Hedge Funds (Multi-Strategy)",
            category: .traditionalAlts,
            annualizedReturn: 12.6,
            volatility: 8.0,
            timePeriod: "2025",
            sharpeRatio: 1.2,
            correlationToSP500: 0.4,
            source: "HFR, CNBC 2026",
            notes: "Best year since 2009; equity and macro strategies led",
            icon: "🎯"
        ),
        AssetReturnData(
            assetClass: "Private Credit",
            category: .traditionalAlts,
            annualizedReturn: 9.5,
            volatility: 6.0,
            timePeriod: "5-year average",
            sharpeRatio: nil,
            correlationToSP500: 0.3,
            source: "iCapital Research",
            notes: "Top performers ~20% (Millstreet); increased dispersion",
            icon: "💳"
        ),

        // MARK: Real Assets
        AssetReturnData(
            assetClass: "Farmland",
            category: .realAssets,
            annualizedReturn: 10.29,
            volatility: 6.74,
            timePeriod: "33-year (NCREIF)",
            sharpeRatio: 1.1,
            correlationToSP500: 0.05,
            source: "Peoples Company, NCREIF",
            notes: "Compared to Dow Jones ~8% with 14% volatility",
            icon: "🌾"
        ),
        AssetReturnData(
            assetClass: "Timberland",
            category: .realAssets,
            annualizedReturn: 10.74,
            volatility: 6.9,
            timePeriod: "1987-2021 (NCREIF)",
            sharpeRatio: 1.03,
            correlationToSP500: 0.05,
            source: "AcreTrader, NCREIF",
            notes: "More recent 10-yr: 5.6%; real returns ~7%",
            icon: "🌲"
        ),
        AssetReturnData(
            assetClass: "Private Real Estate",
            category: .realAssets,
            annualizedReturn: 9.0,
            volatility: 10.0,
            timePeriod: "20-year rolling periods",
            sharpeRatio: nil,
            correlationToSP500: 0.2,
            source: "Invesco, NCREIF",
            notes: "Often highest or second-highest vs stocks/bonds",
            icon: "🏠"
        ),
        AssetReturnData(
            assetClass: "Infrastructure",
            category: .realAssets,
            annualizedReturn: 8.5,
            volatility: 9.0,
            timePeriod: "Long-term average",
            sharpeRatio: nil,
            correlationToSP500: 0.3,
            source: "iCapital Research",
            notes: "Upgraded to Positive outlook in 2024",
            icon: "🌉"
        ),
        AssetReturnData(
            assetClass: "Commodities (GSCI)",
            category: .realAssets,
            annualizedReturn: 15.0,
            volatility: 20.0,
            timePeriod: "5-year (2020-2025)",
            sharpeRatio: nil,
            correlationToSP500: 0.3,
            source: "The Hedge Fund Journal",
            notes: "Recent performance; high volatility",
            icon: "⛽"
        ),
        AssetReturnData(
            assetClass: "Gold",
            category: .realAssets,
            annualizedReturn: 7.5,
            volatility: 15.0,
            timePeriod: "Long-term average",
            sharpeRatio: nil,
            correlationToSP500: 0.0,
            source: "A Wealth of Common Sense",
            notes: "Safe haven; 2026 macro outperformance noted",
            icon: "🥇"
        ),

        // MARK: Collectibles
        AssetReturnData(
            assetClass: "Contemporary Art",
            category: .collectibles,
            annualizedReturn: 11.5,
            volatility: 15.0,
            timePeriod: "1995-2023",
            sharpeRatio: nil,
            correlationToSP500: 0.1,
            source: "Adam Fayed Research",
            notes: "Some studies show real returns ~4% with higher volatility",
            icon: "🎨"
        ),
        AssetReturnData(
            assetClass: "Fine Wine",
            category: .collectibles,
            annualizedReturn: 8.0,
            volatility: 8.0,
            timePeriod: "Long-term estimate",
            sharpeRatio: nil,
            correlationToSP500: 0.1,
            source: "Industry Estimates",
            notes: "Liv-ex indices; storage and insurance costs apply",
            icon: "🍷"
        ),
        AssetReturnData(
            assetClass: "Luxury Watches",
            category: .collectibles,
            annualizedReturn: 6.0,
            volatility: 12.0,
            timePeriod: "Long-term estimate",
            sharpeRatio: nil,
            correlationToSP500: 0.1,
            source: "Benzinga",
            notes: "Rolex, Patek Philippe; condition and rarity critical",
            icon: "⌚"
        ),
        AssetReturnData(
            assetClass: "Sports Cards/Memorabilia",
            category: .collectibles,
            annualizedReturn: 12.0,
            volatility: 30.0,
            timePeriod: "Variable",
            sharpeRatio: nil,
            correlationToSP500: 0.1,
            source: "BlockApps Research",
            notes: "Highly variable; rare items can appreciate significantly",
            icon: "🏈"
        ),
        AssetReturnData(
            assetClass: "Rare Sneakers",
            category: .collectibles,
            annualizedReturn: 10.0,
            volatility: 25.0,
            timePeriod: "Variable",
            sharpeRatio: nil,
            correlationToSP500: 0.1,
            source: "Benzinga",
            notes: "Air Jordans, limited editions; condition critical",
            icon: "👟"
        ),

        // MARK: Digital Assets
        AssetReturnData(
            assetClass: "Bitcoin",
            category: .digitalAssets,
            annualizedReturn: 45.0,
            volatility: 75.0,
            timePeriod: "10-year (2015-2025)",
            sharpeRatio: 0.8,
            correlationToSP500: 0.4,
            source: "Curvo, Fidelity Digital Assets",
            notes: "High volatility declining over time; 54% avg (2014-2024)",
            icon: "₿"
        ),
        AssetReturnData(
            assetClass: "Ethereum",
            category: .digitalAssets,
            annualizedReturn: 85.0,
            volatility: 90.0,
            timePeriod: "10-year (2015-2025)",
            sharpeRatio: nil,
            correlationToSP500: 0.5,
            source: "Curvo, Tickeron",
            notes: "Higher returns and volatility than BTC; 50%+ monthly swings",
            icon: "⟠"
        ),
        AssetReturnData(
            assetClass: "NFTs (Blue Chip)",
            category: .digitalAssets,
            annualizedReturn: -20.0,
            volatility: 100.0,
            timePeriod: "2021-2025",
            sharpeRatio: nil,
            correlationToSP500: 0.6,
            source: "CBS News, Market Data",
            notes: "Peak 2021 ($25B volume); 80%+ decline from highs",
            icon: "🖼️"
        ),

        // MARK: Sustainable/ESG
        AssetReturnData(
            assetClass: "ESG Equity Funds",
            category: .sustainable,
            annualizedReturn: 12.5,
            volatility: 14.0,
            timePeriod: "H1 2025",
            sharpeRatio: nil,
            correlationToSP500: 0.9,
            source: "Morgan Stanley",
            notes: "Outperformed traditional funds (9.2%) in H1 2025",
            icon: "🌱"
        ),
        AssetReturnData(
            assetClass: "Green Bonds",
            category: .sustainable,
            annualizedReturn: 4.5,
            volatility: 5.0,
            timePeriod: "Long-term average",
            sharpeRatio: nil,
            correlationToSP500: 0.2,
            source: "Climate Bonds Initiative",
            notes: "Similar to conventional bonds; 11% of global bond market",
            icon: "🌍"
        ),
        AssetReturnData(
            assetClass: "Tokenized Green RWAs",
            category: .sustainable,
            annualizedReturn: 5.0,
            volatility: 15.0,
            timePeriod: "Projected (2024-2030)",
            sharpeRatio: nil,
            correlationToSP500: 0.3,
            source: "RWA.io",
            notes: "TREE Token example: 3-7% expected; high growth potential",
            icon: "🔗"
        ),
        AssetReturnData(
            assetClass: "Carbon Credits",
            category: .sustainable,
            annualizedReturn: 12.0,
            volatility: 35.0,
            timePeriod: "5-year estimate",
            sharpeRatio: nil,
            correlationToSP500: 0.1,
            source: "Medium/RWA World",
            notes: "High volatility; policy-dependent; upward trend expected",
            icon: "🌫️"
        ),
        AssetReturnData(
            assetClass: "Renewable Energy Infrastructure",
            category: .sustainable,
            annualizedReturn: 8.0,
            volatility: 12.0,
            timePeriod: "Long-term average",
            sharpeRatio: nil,
            correlationToSP500: 0.3,
            source: "RWA.io",
            notes: "Green energy projects: 10-30% projected (higher risk)",
            icon: "⚡"
        )
    ]

    // MARK: - Grouped by Category
    static var groupedByCategory: [AssetReturnData.AssetCategory: [AssetReturnData]] {
        Dictionary(grouping: allAssets, by: { $0.category })
    }

    // MARK: - Top Performers
    static var topPerformers: [AssetReturnData] {
        allAssets
            .filter { $0.category != .benchmark }
            .sorted { $0.annualizedReturn > $1.annualizedReturn }
            .prefix(10)
            .map { $0 }
    }

    // MARK: - Best Risk-Adjusted (by volatility ratio)
    static var bestRiskAdjusted: [AssetReturnData] {
        allAssets
            .compactMap { asset -> (AssetReturnData, Double)? in
                guard let vol = asset.volatility, vol > 0, asset.annualizedReturn > 0 else { return nil }
                return (asset, asset.annualizedReturn / vol)
            }
            .sorted { $0.1 > $1.1 }
            .prefix(10)
            .map { $0.0 }
    }

    // MARK: - Low Correlation Assets
    static var lowCorrelationAssets: [AssetReturnData] {
        allAssets
            .filter { asset in
                guard let corr = asset.correlationToSP500 else { return false }
                return abs(corr) < 0.3
            }
            .sorted { abs($0.correlationToSP500 ?? 1) < abs($1.correlationToSP500 ?? 1) }
    }
}

// MARK: - Visual Data Catalog View
struct AlternativeReturnsDataView: View {
    @State private var selectedCategory: AssetReturnData.AssetCategory?
    @State private var sortOption: SortOption = .returns
    @State private var showLowCorrelationOnly = false

    enum SortOption: String, CaseIterable {
        case returns = "Returns"
        case volatility = "Volatility"
        case riskAdjusted = "Risk-Adjusted"
    }

    private var filteredAssets: [AssetReturnData] {
        var assets = selectedCategory == nil
            ? AlternativeAssetReturnsCatalog.allAssets
            : AlternativeAssetReturnsCatalog.allAssets.filter { $0.category == selectedCategory }

        if showLowCorrelationOnly {
            assets = assets.filter { asset in
                guard let corr = asset.correlationToSP500 else { return false }
                return abs(corr) < 0.3
            }
        }

        switch sortOption {
        case .returns:
            return assets.sorted { $0.annualizedReturn > $1.annualizedReturn }
        case .volatility:
            return assets.sorted { ($0.volatility ?? 100) < ($1.volatility ?? 100) }
        case .riskAdjusted:
            return assets.sorted { a, b in
                let ratio1: Double
                if let vol = a.volatility, vol > 0 {
                    ratio1 = a.annualizedReturn / vol
                } else {
                    ratio1 = 0
                }
                let ratio2: Double
                if let vol = b.volatility, vol > 0 {
                    ratio2 = b.annualizedReturn / vol
                } else {
                    ratio2 = 0
                }
                return ratio1 > ratio2
            }
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                // Header
                headerSection

                // Summary stats
                summaryCardsSection

                // Filters
                filtersSection

                // Data table
                dataTableSection
            }
            .padding(Spacing.lg)
        }
        .background(Color.surfacePrimary)
        .navigationTitle("Historical Returns")
    }

    // MARK: - Header Section
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("Alternative Asset Returns")
                .font(Typography.displayMedium)
                .foregroundColor(.textPrimary)

            Text("Historical performance data across asset classes")
                .font(Typography.body)
                .foregroundColor(.textSecondary)

            HStack(spacing: Spacing.xs) {
                Image(systemName: "info.circle")
                    .foregroundColor(.info)
                Text("Past performance does not guarantee future results")
                    .font(Typography.caption)
                    .foregroundColor(.textTertiary)
            }
            .padding(.top, Spacing.xs)
        }
    }

    // MARK: - Summary Cards
    private var summaryCardsSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.md) {
                SummaryStatCard(
                    title: "Highest Return",
                    value: "\(Int(AlternativeAssetReturnsCatalog.topPerformers.first?.annualizedReturn ?? 0))%",
                    subtitle: AlternativeAssetReturnsCatalog.topPerformers.first?.assetClass ?? "",
                    icon: "arrow.up.right",
                    color: .success
                )

                SummaryStatCard(
                    title: "Lowest Volatility",
                    value: "\(Int(filteredAssets.compactMap { $0.volatility }.min() ?? 0))%",
                    subtitle: "Standard Deviation",
                    icon: "chart.line.flattrend.xyaxis",
                    color: .info
                )

                SummaryStatCard(
                    title: "Best Risk-Adjusted",
                    value: AlternativeAssetReturnsCatalog.bestRiskAdjusted.first?.assetClass ?? "",
                    subtitle: "Return/Volatility ratio",
                    icon: "scale.3d",
                    color: .brandPrimary
                )

                SummaryStatCard(
                    title: "Asset Classes",
                    value: "\(AlternativeAssetReturnsCatalog.allAssets.count)",
                    subtitle: "Tracked in catalog",
                    icon: "square.grid.3x3",
                    color: .brandHighlight
                )
            }
            .padding(.vertical, Spacing.sm)
        }
    }

    // MARK: - Filters Section
    private var filtersSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            // Category filter
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.sm) {
                    CategoryFilterButton(
                        title: "All",
                        isSelected: selectedCategory == nil,
                        action: { selectedCategory = nil }
                    )

                    ForEach(AssetReturnData.AssetCategory.allCases, id: \.self) { category in
                        CategoryFilterButton(
                            title: category.rawValue,
                            isSelected: selectedCategory == category,
                            action: { selectedCategory = category }
                        )
                    }
                }
            }

            // Sort and filter options
            HStack(spacing: Spacing.md) {
                // Sort picker
                Picker("Sort by", selection: $sortOption) {
                    ForEach(SortOption.allCases, id: \.self) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                .pickerStyle(.segmented)
                .frame(maxWidth: 300)

                Spacer()

                // Low correlation toggle
                Toggle(isOn: $showLowCorrelationOnly) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.left.arrow.right")
                        Text("Low Correlation Only")
                    }
                    .font(Typography.caption)
                }
                .toggleStyle(.button)
            }
        }
    }

    // MARK: - Data Table
    private var dataTableSection: some View {
        VStack(spacing: 0) {
            // Table header
            HStack(spacing: 0) {
                Text("Asset")
                    .frame(width: 180, alignment: .leading)
                Text("Return")
                    .frame(width: 80, alignment: .trailing)
                Text("Volatility")
                    .frame(width: 80, alignment: .trailing)
                Text("Correlation")
                    .frame(width: 90, alignment: .trailing)
                Text("Period")
                    .frame(width: 120, alignment: .leading)
                Spacer()
            }
            .font(Typography.captionMedium)
            .foregroundColor(.textSecondary)
            .padding(.horizontal, Spacing.md)
            .padding(.vertical, Spacing.sm)
            .background(Color.surfaceSecondary)

            // Table rows
            ForEach(filteredAssets) { asset in
                AssetReturnRow(asset: asset)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.lg)
                .stroke(Color.divider, lineWidth: 1)
        )
    }
}

// MARK: - Supporting Views
struct SummaryStatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(title)
                    .font(Typography.caption)
                    .foregroundColor(.textSecondary)
            }

            Text(value)
                .font(Typography.title2)
                .foregroundColor(.textPrimary)

            Text(subtitle)
                .font(Typography.caption2)
                .foregroundColor(.textTertiary)
        }
        .padding(Spacing.md)
        .frame(width: 160)
        .background(Color.surfaceSecondary)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
    }
}

struct CategoryFilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(isSelected ? Typography.captionMedium : Typography.caption)
                .foregroundColor(isSelected ? .white : .textSecondary)
                .padding(.horizontal, Spacing.md)
                .padding(.vertical, Spacing.sm)
                .background(isSelected ? Color.brandPrimary : Color.surfaceSecondary)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

struct AssetReturnRow: View {
    let asset: AssetReturnData

    var body: some View {
        HStack(spacing: 0) {
            // Asset name with icon
            HStack(spacing: Spacing.sm) {
                Text(asset.icon)
                    .font(.system(size: 20))

                VStack(alignment: .leading, spacing: 2) {
                    Text(asset.assetClass)
                        .font(Typography.bodyMedium)
                        .foregroundColor(.textPrimary)
                        .lineLimit(1)

                    Text(asset.category.rawValue)
                        .font(Typography.caption2)
                        .foregroundColor(.textTertiary)
                }
            }
            .frame(width: 180, alignment: .leading)

            // Return
            Text(returnString)
                .font(Typography.bodyMedium)
                .foregroundColor(asset.annualizedReturn >= 0 ? .success : .error)
                .frame(width: 80, alignment: .trailing)

            // Volatility
            Text(volatilityString)
                .font(Typography.body)
                .foregroundColor(.textSecondary)
                .frame(width: 80, alignment: .trailing)

            // Correlation
            correlationView
                .frame(width: 90, alignment: .trailing)

            // Period
            Text(asset.timePeriod)
                .font(Typography.caption)
                .foregroundColor(.textTertiary)
                .frame(width: 120, alignment: .leading)
                .lineLimit(1)

            Spacer()

            // Source tooltip
            if let notes = asset.notes {
                Image(systemName: "info.circle")
                    .foregroundColor(.textTertiary)
                    .font(.caption)
                    .help(notes)
            }
        }
        .padding(.horizontal, Spacing.md)
        .padding(.vertical, Spacing.sm)
        .background(Color.surfacePrimary)

        Rectangle()
            .fill(Color.divider)
            .frame(height: 1)
    }

    private var returnString: String {
        let sign = asset.annualizedReturn >= 0 ? "+" : ""
        return "\(sign)\(String(format: "%.1f", asset.annualizedReturn))%"
    }

    private var volatilityString: String {
        guard let vol = asset.volatility else { return "—" }
        return "\(String(format: "%.1f", vol))%"
    }

    private var correlationView: some View {
        Group {
            if let corr = asset.correlationToSP500 {
                HStack(spacing: 4) {
                    Circle()
                        .fill(correlationColor(corr))
                        .frame(width: 8, height: 8)
                    Text(String(format: "%.2f", corr))
                        .font(Typography.caption)
                        .foregroundColor(.textSecondary)
                }
            } else {
                Text("—")
                    .font(Typography.caption)
                    .foregroundColor(.textTertiary)
            }
        }
    }

    private func correlationColor(_ corr: Double) -> Color {
        let absCorr = abs(corr)
        if absCorr < 0.3 { return .success }
        if absCorr < 0.6 { return .warning }
        return .error
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        AlternativeReturnsDataView()
    }
}
