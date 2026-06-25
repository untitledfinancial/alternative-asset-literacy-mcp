//
//  ContentView.swift
//  Enhanced App for Alt Assets
//
//  Created by Victoria Case on 2/1/26.
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//
//  Description: Main navigation structure optimized for iPhone with Notion-like
//  visual styling. Features tab-based navigation with settings access, review
//  badges, and learning path integration.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var notionService: NotionService
    @EnvironmentObject var progressManager: ProgressManager
    @EnvironmentObject var reviewManager: ReviewManager
    @EnvironmentObject var userSettings: UserSettings
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var selectedModule: Module?
    @State private var showSettings = false
    @State private var selectedTab = 0
    @State private var showingReviewFromWidget = false

    var body: some View {
        // iPhone-first layout with tabs - iOS 26 Liquid Glass tab bar
        TabView(selection: $selectedTab) {
            // Learn Tab (Home)
            Tab("Learn", systemImage: "book.fill", value: 0) {
                NavigationStack {
                    ModuleListView(selectedModule: $selectedModule, showSettings: $showSettings)
                }
            }

            // Progress Tab (combined with Review + Start Here path)
            Tab("Progress", systemImage: "chart.bar.fill", value: 1) {
                NavigationStack {
                    UnifiedProgressView()
                }
            }
            .badge(reviewManager.reviewsDueCount > 0 ? reviewManager.reviewsDueCount : 0)

            // Glossary Tab (easy-to-find terms)
            Tab("Terms", systemImage: "text.book.closed.fill", value: 2) {
                NavigationStack {
                    GlossaryView()
                }
            }

            // Toolkit Tab (global access)
            Tab("Toolkit", systemImage: "wrench.and.screwdriver.fill", value: 3) {
                NavigationStack {
                    ToolkitView()
                }
            }
        }
        #if os(iOS)
        .tabBarMinimizeBehavior(.onScrollDown)
        #endif
        #if os(iOS) || os(visionOS)
        .tabViewStyle(.sidebarAdaptable)
        #endif
        .tint(.brandPrimary)
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .sheet(isPresented: $showingReviewFromWidget) {
            ReviewSessionView(items: reviewManager.itemsDueToday)
                .environmentObject(reviewManager)
                .environmentObject(progressManager)
        }
        .onOpenURL { url in
            if url.scheme == "altassets" && url.host == "review" {
                selectedTab = 1 // Progress tab
                showingReviewFromWidget = true
            }
        }
        .task {
            // Fetch live Notion data once on launch. Sample data is shown immediately;
            // Notion data replaces it while preserving heroImageName and enriched content.
            if AppConfiguration.preferLiveData && notionService.lastSyncDate == nil {
                await notionService.fetchModules()
            } else if notionService.modules.isEmpty {
                await notionService.fetchModules()
            }

            // Enrich modules with targeted database fetches (runs on both local and Notion data)
            await notionService.enrichModulesWithDatabases()
        }
    }

}

// MARK: - Placeholder alias for compatibility
typealias ReviewDashboardPlaceholderView = ReviewDashboardView
typealias LearningPathsPlaceholderView = LearningPathsListView

// MARK: - Module List View (Art Space Gallery Style)
struct ModuleListView: View {
    @Binding var selectedModule: Module?
    @Binding var showSettings: Bool
    @EnvironmentObject var notionService: NotionService
    @EnvironmentObject var progressManager: ProgressManager
    @EnvironmentObject var reviewManager: ReviewManager
    @EnvironmentObject var userSettings: UserSettings
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @ObservedObject private var networkMonitor = NetworkMonitor.shared
    @State private var showPaywall = false
    @State private var searchText = ""

    private var isWide: Bool { horizontalSizeClass == .regular }

    var filteredModules: [Module] {
        guard !searchText.isEmpty else { return notionService.modules }
        let q = searchText.lowercased()
        return notionService.modules.filter { m in
            m.title.localizedCaseInsensitiveContains(q) ||
            m.description.localizedCaseInsensitiveContains(q) ||
            m.tags.contains(where: { $0.localizedCaseInsensitiveContains(q) })
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            OfflineBanner()
            ScrollView {
                VStack(spacing: 0) {
                    heroBannerSection
                    if searchText.isEmpty {
                        tabContent
                    } else {
                        searchResults
                    }
                }
                .frame(maxWidth: isWide ? 860 : .infinity)
                .frame(maxWidth: .infinity)
            }
            .refreshable {
                await notionService.fetchModules()
                await notionService.enrichModulesWithDatabases()
            }
        }
        .background(Color.surfacePrimary)
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search modules, topics, tags…")
        .navigationTitle("")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .navigationBar)
        #endif
    }

    private var searchResults: some View {
        LazyVStack(spacing: 0) {
            if filteredModules.isEmpty {
                VStack(spacing: Spacing.md) {
                    Text("No results for \"\(searchText)\"")
                        .font(Typography.body)
                        .foregroundColor(.textSecondary)
                    Text("Try a topic, tag, or module name.")
                        .font(Typography.caption)
                        .foregroundColor(.textTertiary)
                }
                .padding(.top, Spacing.xl)
                .frame(maxWidth: .infinity)
            } else {
                ForEach(Array(filteredModules.enumerated()), id: \.element.id) { index, module in
                    Button {
                        selectedModule = module
                    } label: {
                        ArtSpaceModuleRow(module: module, index: index)
                    }
                    .buttonStyle(.plain)
                    Divider().padding(.leading, Spacing.lg)
                }
            }
        }
        .padding(.top, Spacing.md)
    }

    // MARK: - Header Section (Clean, personalized)
    private var heroBannerSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            // Top bar with settings
            HStack {
                Spacer()
                Button {
                    showSettings = true
                } label: {
                    Image(systemName: "gearshape")
                        .font(.body)
                        .foregroundColor(.textSecondary)
                        .frame(width: 36, height: 36)
                        .glassEffect(.regular.interactive(), in: .circle)
                }
                .accessibilityLabel("Settings")
                .accessibilityHint("Opens app settings for typography, personalization, and data management")
            }
            .padding(.horizontal, Spacing.lg)
            .padding(.top, Spacing.md)

            // Personalized greeting with name
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                // Show course name as label
                if !userSettings.courseName.isEmpty && userSettings.courseName != "Alternative Assets" {
                    Text(userSettings.courseName)
                        .font(Typography.caption)
                        .foregroundColor(.textTertiary)
                }

                // Time greeting (italic)
                Text(greetingText)
                    .font(Typography.caption)
                    .italic()
                    .foregroundColor(.textTertiary)

                // User name (dramatic, fills the space)
                if !userSettings.userName.isEmpty {
                    Text(userSettings.userName)
                        .font(.system(size: isWide ? 40 : 52, weight: .light, design: .serif))
                        .foregroundColor(.textPrimary)
                        .minimumScaleFactor(0.6)
                        .lineLimit(1)
                }
            }
            .padding(.horizontal, Spacing.lg)
            .padding(.bottom, Spacing.md)
        }
        .background(Color.surfacePrimary)
    }

    // Personalized greeting with name
    private var personalizedGreeting: String {
        if userSettings.userName.isEmpty {
            return greetingText
        } else {
            return "\(greetingText), \(userSettings.userName)"
        }
    }

    // MARK: - Tab Content (simplified - just modules on home screen)
    @ViewBuilder
    private var tabContent: some View {
        modulesContent
    }

    // MARK: - Modules Content (Art Space List Style)
    private var modulesContent: some View {
        VStack(spacing: 0) {
            // Review banner if items due
            if reviewManager.reviewsDueCount > 0 {
                ReviewBannerView()
                    .padding(.horizontal, Spacing.lg)
                    .padding(.vertical, Spacing.md)
            }

            // Art Space style module list (main modules first, then sub-modules nested)
            let mainModules = notionService.modules.filter { !$0.isSubModule }

            VStack(spacing: 0) {
                ForEach(Array(mainModules.enumerated()), id: \.element.id) { index, module in
                    let isLocked = !subscriptionManager.isModuleAccessible(module.id)
                    NavigationLink {
                        ModuleDetailView(initialModule: module)
                    } label: {
                        ArtSpaceModuleRow(module: module, index: index, isLocked: isLocked)
                    }
                    .buttonStyle(.plain)

                    if index < mainModules.count - 1 {
                        Rectangle()
                            .fill(Color.divider)
                            .frame(height: 1)
                            .padding(.leading, Spacing.lg)
                    }
                }
            }
            .padding(.top, Spacing.md)
        }
        .padding(.bottom, Spacing.xxl)
        .sheet(isPresented: $showPaywall) {
            PaywallView()
        }
    }

    private var greetingText: String {
        let hour = Calendar.current.component(.hour, from: Date())
        let timeGreeting: String
        switch hour {
        case 0..<12: timeGreeting = "Good morning"
        case 12..<17: timeGreeting = "Good afternoon"
        default: timeGreeting = "Good evening"
        }
        return timeGreeting
    }
}

// MARK: - Art Space Module Row (Gallery List Style with Academic Rigor)
struct ArtSpaceModuleRow: View {
    let module: Module
    let index: Int
    var isLocked: Bool = false
    @EnvironmentObject var progressManager: ProgressManager
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    private var isWide: Bool { horizontalSizeClass == .regular }
    private var thumbSize: CGFloat { isWide ? 88 : 72 }

    private var isComplete: Bool {
        progressManager.isModuleComplete(module.id)
    }

    private var progress: Double {
        let completed = module.sections.filter { progressManager.isSectionComplete($0.id) }.count
        guard module.totalSections > 0 else { return 0 }
        return Double(completed) / Double(module.totalSections)
    }

    // Determine research type superscript based on module content
    private var researchSuperscript: String {
        if module.id.contains("behavioral") || module.id.contains("gender") {
            return "E" // Empirical
        } else if module.id.contains("art") || module.id.contains("kahlo") {
            return "C" // Case Studies
        } else if module.id.contains("defi") {
            return "T" // Technical
        } else {
            return "R" // Research-Based
        }
    }

    var body: some View {
        HStack(alignment: .center, spacing: Spacing.md) {
            // Module image (small square) - KEPT per user request
            if let heroImage = module.heroImageName {
                Image(heroImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: thumbSize, height: thumbSize)
                    .clipShape(RoundedRectangle(cornerRadius: CornerRadius.sm))
            } else {
                RoundedRectangle(cornerRadius: CornerRadius.sm)
                    .fill(Color.surfaceSecondary)
                    .frame(width: thumbSize, height: thumbSize)
                    .overlay(
                        Text(module.icon)
                            .font(.system(size: isWide ? 34 : 28))
                    )
            }

            // Content - Art Space typography style
            VStack(alignment: .leading, spacing: 4) {
                // Title with alternating regular/italic + superscript annotation (Art Space style)
                HStack(alignment: .firstTextBaseline, spacing: 0) {
                    Text(module.title)
                        .font(index % 2 == 0 ? Typography.title3 : Typography.title3.italic())
                        .foregroundColor(.textPrimary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)

                    // Research type superscript (like P, D, V in Art Space)
                    Text(" (\(researchSuperscript))")
                        .font(Typography.superscript)
                        .foregroundColor(.textTertiary)
                        .baselineOffset(6)
                }

                // Metadata with minimal styling
                HStack(spacing: Spacing.xs) {
                    Text("\(module.totalSections) sections")
                    Text("·")
                    Text("\(module.estimatedTime) min")
                    if !module.quizzes.isEmpty {
                        Text("·")
                        HStack(spacing: 1) {
                            Text("\(module.quizzes.count)")
                            Text("Q")
                                .font(Typography.superscript)
                                .baselineOffset(3)
                        }
                    }
                }
                .font(Typography.caption)
                .foregroundColor(.textTertiary)

                // Section-level progress bar
                if progress > 0 && !isComplete {
                    HStack(spacing: Spacing.xs) {
                        ProgressView(value: progress)
                            .tint(.brandPrimary)
                            .frame(maxWidth: 120)
                        let completed = module.sections.filter { progressManager.isSectionComplete($0.id) }.count
                        Text("\(completed)/\(module.totalSections) sections")
                            .font(Typography.caption2)
                            .foregroundColor(.textTertiary)
                    }
                }
            }

            Spacer()

            // "New" badge for recent releases
            if module.isNewRelease {
                Text("New")
                    .font(Typography.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color.brandHighlight)
                    .clipShape(Capsule())
            }

            // Status indicator
            if isLocked {
                Image(systemName: "lock.fill")
                    .foregroundColor(.textTertiary)
                    .font(.system(size: 13))
            } else if isComplete {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.success)
                    .font(.system(size: 20))
            } else {
                Image(systemName: "chevron.right")
                    .foregroundColor(.textTertiary)
                    .font(.system(size: 13))
            }
        }
        .padding(.horizontal, Spacing.lg)
        .padding(.vertical, isWide ? Spacing.lg : Spacing.md)
        .dynamicTypeSize(.small ... .accessibility1)
        .contentShape(Rectangle())
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(module.title). \(module.totalSections) sections, \(module.estimatedTime) minutes. \(module.isNewRelease ? "New. " : "")\(isLocked ? "Premium content" : (isComplete ? "Completed" : (progress > 0 ? "\(Int(progress * 100)) percent complete" : "Not started")))")
        .accessibilityHint(isLocked ? "Opens module preview. Subscribe for full access." : "Opens module content")
    }
}

// MARK: - Sub-Module Row (Indented, smaller style)
struct SubModuleRow: View {
    let module: Module
    @EnvironmentObject var progressManager: ProgressManager

    private var isComplete: Bool {
        progressManager.isModuleComplete(module.id)
    }

    var body: some View {
        HStack(alignment: .center, spacing: Spacing.sm) {
            // Indent indicator
            Rectangle()
                .fill(Color.brandPrimary.opacity(0.3))
                .frame(width: 2, height: 40)
                .padding(.leading, Spacing.md)

            // Icon
            Text(module.icon)
                .font(.system(size: 20))
                .frame(width: 36, height: 36)
                .background(Color.surfaceSecondary)
                .clipShape(Circle())

            // Content
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 4) {
                    if module.isBonus {
                        Text("BONUS")
                            .font(Typography.caption2)
                            .foregroundColor(.brandHighlight)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 1)
                            .background(Color.brandHighlight.opacity(0.1))
                            .clipShape(Capsule())
                    }

                    Text(module.title)
                        .font(Typography.bodyMedium.italic())
                        .foregroundColor(.textPrimary)
                        .lineLimit(1)
                }

                Text("\(module.totalSections) sections · \(module.estimatedTime) min")
                    .font(Typography.caption2)
                    .foregroundColor(.textTertiary)
            }

            Spacer()

            // Status
            if isComplete {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.success)
                    .font(.body)
            } else {
                Image(systemName: "chevron.right")
                    .foregroundColor(.textTertiary)
                    .font(.caption2)
            }
        }
        .padding(.horizontal, Spacing.lg)
        .padding(.vertical, Spacing.sm)
        .background(Color.surfaceSecondary.opacity(0.3))
        .contentShape(Rectangle())
    }
}

// MARK: - Tool Card View (App-Native Rounded Style)
struct ToolCardView: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    var isLocked: Bool = false

    var body: some View {
        HStack(spacing: Spacing.md) {
            // Rounded icon container (consistent with Courses view)
            Text(icon)
                .font(.system(size: 28))
                .frame(width: 48, height: 48)
                .background(Color.surfaceTertiary)
                .clipShape(RoundedRectangle(cornerRadius: CornerRadius.sm))

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(Typography.bodyMedium)
                    .foregroundColor(isLocked ? .textTertiary : .textPrimary)

                Text(description)
                    .font(Typography.caption)
                    .foregroundColor(.textSecondary)
            }

            Spacer()

            if isLocked {
                Image(systemName: "lock.fill")
                    .foregroundColor(.textTertiary)
                    .font(.caption)
            } else {
                Image(systemName: "chevron.right")
                    .foregroundColor(.textTertiary)
                    .font(.caption)
            }
        }
        .padding(Spacing.md)
        .background(Color.surfaceSecondary)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.lg))
    }
}

// MARK: - Stat Pill View (Rounded Stats)
struct StatPillView: View {
    let value: String
    let label: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: Spacing.xs) {
            Text(icon)
                .font(.system(size: 20))

            Text(value)
                .font(Typography.title3)
                .foregroundColor(.textPrimary)

            Text(label)
                .font(Typography.caption2)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.md)
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.lg))
    }
}

// MARK: - Mini Stat View
struct MiniStatView: View {
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(Typography.bodyMedium)
                .foregroundColor(color)
            Text(label)
                .font(Typography.caption2)
                .foregroundColor(.textTertiary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Module Progress Row
struct ModuleProgressRow: View {
    let module: Module
    @EnvironmentObject var progressManager: ProgressManager

    private var progress: Double {
        let completed = module.sections.filter { progressManager.isSectionComplete($0.id) }.count
        guard module.totalSections > 0 else { return 0 }
        return Double(completed) / Double(module.totalSections)
    }

    var body: some View {
        HStack(spacing: Spacing.sm) {
            Text(module.icon)
                .font(.system(size: 20))

            VStack(alignment: .leading, spacing: 4) {
                Text(module.title)
                    .font(Typography.caption)
                    .foregroundColor(.textPrimary)
                    .lineLimit(1)

                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.divider)

                        Capsule()
                            .fill(progress >= 1 ? Color.success : Color.brandPrimary)
                            .frame(width: geometry.size.width * progress)
                    }
                }
                .frame(height: 6)
            }

            Text("\(Int(progress * 100))%")
                .font(Typography.caption2)
                .foregroundColor(.textTertiary)
                .frame(width: 36, alignment: .trailing)
        }
        .padding(.vertical, Spacing.xs)
    }
}

// MARK: - Bento Grid Module Card (2025 UI Trend)
struct NotionModuleRow: View {
    let module: Module
    @EnvironmentObject var progressManager: ProgressManager
    @EnvironmentObject var userSettings: UserSettings

    private var completedSections: Int {
        module.sections.filter { progressManager.isSectionComplete($0.id) }.count
    }

    private var progress: Double {
        guard module.totalSections > 0 else { return 0 }
        return Double(completedSections) / Double(module.totalSections)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Cover image (Notion-style: smaller rectangle)
            if let heroImageName = module.heroImageName {
                Image(heroImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 100)
                    .clipped()
                    .overlay(
                        // Morphism: subtle blur gradient at bottom
                        LinearGradient(
                            colors: [.clear, Color.surfaceSecondary.opacity(0.8)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: 40)
                        .offset(y: 30),
                        alignment: .bottom
                    )
            }

            // Content section
            VStack(alignment: .leading, spacing: Spacing.sm) {
                HStack(alignment: .top, spacing: Spacing.sm) {
                    // Emoji icon
                    if userSettings.showEmojis {
                        Text(module.icon)
                            .font(.system(size: 24))
                    }

                    VStack(alignment: .leading, spacing: Spacing.xxs) {
                        // Big Typography title
                        Text(module.title)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.textPrimary)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)

                        // Metadata
                        HStack(spacing: Spacing.xs) {
                            Text("\(module.totalSections) sections")
                            Text("•")
                            Text("\(module.estimatedTime) min")
                        }
                        .font(Typography.caption2)
                        .foregroundColor(.textTertiary)
                    }

                    Spacer()

                    // Completion badge or arrow
                    if progressManager.isModuleComplete(module.id) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.success)
                            .font(.body)
                    } else {
                        Image(systemName: "arrow.right")
                            .font(.caption)
                            .foregroundColor(.textTertiary)
                    }
                }

                // Progress bar (subtle)
                if progress > 0 {
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.divider)

                            RoundedRectangle(cornerRadius: 2)
                                .fill(progress >= 1 ? Color.success : Color.brandPrimary)
                                .frame(width: geometry.size.width * progress)
                        }
                    }
                    .frame(height: 3)
                }
            }
            .padding(Spacing.md)
        }
        .background(Color.surfaceSecondary)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.lg))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Bento Grid Layout for Modules
struct BentoGridView: View {
    let modules: [Module]

    var body: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: Spacing.sm),
                GridItem(.flexible(), spacing: Spacing.sm)
            ],
            spacing: Spacing.sm
        ) {
            ForEach(Array(modules.enumerated()), id: \.element.id) { index, module in
                NavigationLink {
                    ModuleDetailView(initialModule: module)
                } label: {
                    // First module is featured (full width)
                    if index == 0 {
                        FeaturedModuleCard(module: module)
                    } else {
                        NotionModuleRow(module: module)
                    }
                }
                .buttonStyle(.plain)
                .gridCellColumns(index == 0 ? 2 : 1)
            }
        }
    }
}

// MARK: - Featured Module Card (Large, for first item)
struct FeaturedModuleCard: View {
    let module: Module
    @EnvironmentObject var progressManager: ProgressManager
    @EnvironmentObject var userSettings: UserSettings

    private var progress: Double {
        let completed = module.sections.filter { progressManager.isSectionComplete($0.id) }.count
        guard module.totalSections > 0 else { return 0 }
        return Double(completed) / Double(module.totalSections)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Large cover image
            if let heroImageName = module.heroImageName {
                ZStack(alignment: .bottomLeading) {
                    Image(heroImageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 160)
                        .clipped()

                    // Morphism gradient overlay
                    LinearGradient(
                        colors: [.clear, .clear, Color.black.opacity(0.6)],
                        startPoint: .top,
                        endPoint: .bottom
                    )

                    // Title on image
                    VStack(alignment: .leading, spacing: Spacing.xs) {
                        if userSettings.showEmojis {
                            Text(module.icon)
                                .font(.system(size: 28))
                        }

                        Text(module.title)
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                            .shadow(radius: 2)
                    }
                    .padding(Spacing.md)
                }
            }

            // Content section
            HStack {
                VStack(alignment: .leading, spacing: Spacing.xxs) {
                    Text(module.description)
                        .font(Typography.caption)
                        .foregroundColor(.textSecondary)
                        .lineLimit(2)

                    HStack(spacing: Spacing.xs) {
                        Label("\(module.totalSections) sections", systemImage: "doc.text")
                        Text("•")
                        Label("\(module.estimatedTime) min", systemImage: "clock")
                    }
                    .font(Typography.caption2)
                    .foregroundColor(.textTertiary)
                }

                Spacer()

                // Progress or Start
                if progress > 0 {
                    CircularProgressView(progress: progress)
                        .frame(width: 36, height: 36)
                } else {
                    Text("Start")
                        .font(Typography.captionMedium)
                        .foregroundColor(.white)
                        .padding(.horizontal, Spacing.md)
                        .padding(.vertical, Spacing.xs)
                        .buttonStyle(.glassProminent)
                        .glassEffect(.regular.tint(.brandPrimary), in: .capsule)
                }
            }
            .padding(Spacing.md)
        }
        .background(Color.surfaceSecondary)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.lg))
        .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 4)
    }
}

// MARK: - Circular Progress View
struct CircularProgressView: View {
    let progress: Double

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.divider, lineWidth: 3)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    progress >= 1 ? Color.success : Color.brandPrimary,
                    style: StrokeStyle(lineWidth: 3, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.smoothSpring, value: progress)

            if progress >= 1 {
                Image(systemName: "checkmark")
                    .font(.caption2.bold())
                    .foregroundColor(.success)
            } else {
                Text("\(Int(progress * 100))%")
                    .font(.system(size: 9, weight: .medium))
                    .foregroundColor(.textSecondary)
            }
        }
    }
}

// MARK: - Quick Access Card (Button version)
struct QuickAccessCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(icon)
                    .font(.system(size: 24))

                Text(title)
                    .font(Typography.captionMedium)
                    .foregroundColor(.textPrimary)

                Text(subtitle)
                    .font(Typography.caption2)
                    .foregroundColor(.textTertiary)
            }
            .frame(width: 100, alignment: .leading)
            .padding(Spacing.md)
            .background(Color.surfaceSecondary)
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Quick Access Card View (for NavigationLink)
struct QuickAccessCardView: View {
    let icon: String
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text(icon)
                .font(.system(size: 24))

            Text(title)
                .font(Typography.captionMedium)
                .foregroundColor(.textPrimary)

            Text(subtitle)
                .font(Typography.caption2)
                .foregroundColor(.textTertiary)
        }
        .frame(width: 100, alignment: .leading)
        .padding(Spacing.md)
        .background(Color.surfaceSecondary)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
    }
}

// MARK: - Review Banner View
struct ReviewBannerView: View {
    @EnvironmentObject var reviewManager: ReviewManager
    @State private var showingReviewSession = false

    var body: some View {
        Button {
            showingReviewSession = true
        } label: {
            HStack(spacing: Spacing.md) {
                // Icon with badge
                ZStack(alignment: .topTrailing) {
                    Image(systemName: "arrow.clockwise.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.brandHighlight)

                    if reviewManager.reviewsDueCount > 0 {
                        Text("\(reviewManager.reviewsDueCount)")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                            .padding(4)
                            .background(Color.error)
                            .clipShape(Circle())
                            .offset(x: 4, y: -4)
                    }
                }

                VStack(alignment: .leading, spacing: Spacing.xxs) {
                    Text("Reviews Due")
                        .font(Typography.bodyMedium)
                        .foregroundColor(.textPrimary)

                    Text("\(reviewManager.reviewsDueCount) items ready for review")
                        .font(Typography.caption)
                        .foregroundColor(.textSecondary)

                    // Streak indicator
                    if reviewManager.state.streak > 0 {
                        HStack(spacing: Spacing.xxs) {
                            Image(systemName: "flame.fill")
                                .foregroundColor(.warning)
                            Text("\(reviewManager.state.streak) day streak")
                                .foregroundColor(.warning)
                        }
                        .font(Typography.caption)
                    }
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.textTertiary)
            }
            .padding(Spacing.md)
            .background(Color.brandHighlight.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showingReviewSession) {
            ReviewSessionView(items: reviewManager.itemsDueToday)
        }
    }
}

// MARK: - Welcome View
struct WelcomeView: View {
    var body: some View {
        VStack(spacing: Spacing.xl) {
            // Hero icon
            Image(systemName: "graduationcap.fill")
                .font(.system(size: 80))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.brandPrimary, .brandPrimary.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            // Welcome text
            VStack(spacing: Spacing.sm) {
                Text("Alternative Asset Education")
                    .displayMediumStyle()
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.center)

                Text("Select a module from the sidebar to begin your learning journey")
                    .font(Typography.body)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
            }

            Rectangle()
                .fill(Color.divider)
                .frame(width: 200, height: 1)

            // Features
            VStack(alignment: .leading, spacing: Spacing.md) {
                FeatureRow(
                    icon: "book.fill",
                    title: "Research-Based Content",
                    description: "Academically vetted educational material"
                )

                FeatureRow(
                    icon: "lightbulb.fill",
                    title: "Reflection Prompts",
                    description: "Deepen your understanding"
                )

                FeatureRow(
                    icon: "checkmark.circle.fill",
                    title: "Knowledge Checks",
                    description: "Test your learning with quizzes"
                )

                FeatureRow(
                    icon: "arrow.clockwise",
                    title: "Spaced Repetition",
                    description: "Retain knowledge long-term"
                )
            }
            .frame(maxWidth: 400)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(Spacing.xxl)
        .background(Color.surfacePrimary)
    }
}

// MARK: - Feature Row
struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(spacing: Spacing.md) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.brandPrimary)
                .frame(width: 30)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(Typography.bodyMedium)
                    .foregroundColor(.textPrimary)

                Text(description)
                    .font(Typography.caption)
                    .foregroundColor(.textSecondary)
            }
        }
    }
}

// MARK: - Review Dashboard View
struct ReviewDashboardView: View {
    @EnvironmentObject var reviewManager: ReviewManager
    @State private var showingReviewSession = false

    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.lg) {
                // Stats cards (Notion-style with emojis)
                HStack(spacing: Spacing.md) {
                    EmojiStatCard(
                        title: "Due Today",
                        value: "\(reviewManager.reviewsDueCount)",
                        emoji: "🕐",
                        color: .brandHighlight
                    )

                    EmojiStatCard(
                        title: "Streak",
                        value: "\(reviewManager.state.streak)",
                        emoji: "🔥",
                        color: .warning
                    )

                    EmojiStatCard(
                        title: "Total Items",
                        value: "\(reviewManager.state.reviewItems.count)",
                        emoji: "📚",
                        color: .info
                    )
                }

                // Progress ring
                if reviewManager.state.dailyReviewGoal > 0 {
                    dailyProgressCard
                }

                Spacer()
                    .frame(height: Spacing.xl)

                // Start review button or all caught up
                if reviewManager.reviewsDueCount > 0 {
                    Button {
                        showingReviewSession = true
                    } label: {
                        HStack(spacing: Spacing.md) {
                            Image(systemName: "play.circle.fill")
                                .font(.title)

                            VStack(alignment: .leading, spacing: 2) {
                                Text("Start Review")
                                    .font(Typography.bodyMedium)

                                Text("\(reviewManager.reviewsDueCount) items ready")
                                    .font(Typography.caption)
                                    .opacity(0.8)
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                        }
                        .foregroundColor(.white)
                        .padding(Spacing.lg)
                        .glassEffect(.regular.tint(.brandHighlight), in: RoundedRectangle(cornerRadius: CornerRadius.md))
                    }
                    .buttonStyle(.pressable)
                } else {
                    VStack(spacing: Spacing.md) {
                        // Emoticon-style celebration message
                        Text("All caught up ✅ Great work!")
                            .font(Typography.emoticonFeature)
                            .foregroundColor(.textPrimary)
                            .multilineTextAlignment(.center)

                        Text("No reviews due right now 😌")
                            .font(Typography.body)
                            .foregroundColor(.textSecondary)

                        if !reviewManager.upcomingItems.isEmpty {
                            Text("\(reviewManager.upcomingItems.count) items coming up this week")
                                .font(Typography.caption)
                                .foregroundColor(.textTertiary)
                        }
                    }
                    .padding(.vertical, Spacing.xxl)
                }

                // Retention stats
                if reviewManager.stats.totalReviews > 0 {
                    retentionStatsCard
                }
            }
            .padding(Spacing.lg)
        }
        .background(Color.surfacePrimary)
        .navigationTitle("Review")
        .sheet(isPresented: $showingReviewSession) {
            ReviewSessionView(items: reviewManager.itemsDueToday)
        }
    }

    private var dailyProgressCard: some View {
        VStack(spacing: Spacing.md) {
            HStack {
                Text("Daily Goal")
                    .font(Typography.bodyMedium)
                    .foregroundColor(.textPrimary)

                Spacer()

                Text("\(reviewManager.state.todaysReviewCount) / \(reviewManager.state.dailyReviewGoal)")
                    .font(Typography.caption)
                    .foregroundColor(.textSecondary)
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.progressTrack)

                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.progressFill)
                        .frame(width: geometry.size.width * reviewManager.todaysProgress)
                }
            }
            .frame(height: 8)

            if reviewManager.todaysProgress >= 1.0 {
                HStack(spacing: Spacing.xs) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.success)
                    Text("Daily goal reached!")
                        .foregroundColor(.success)
                }
                .font(Typography.caption)
            }
        }
        .padding(Spacing.lg)
        .background(Color.surfaceSecondary)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
    }

    private var retentionStatsCard: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("Your Stats")
                .font(Typography.bodyMedium)
                .foregroundColor(.textPrimary)

            HStack(spacing: Spacing.lg) {
                VStack(spacing: Spacing.xxs) {
                    Text("\(Int(reviewManager.stats.retentionRate * 100))%")
                        .font(Typography.title2)
                        .foregroundColor(.success)
                    Text("Retention")
                        .font(Typography.caption)
                        .foregroundColor(.textTertiary)
                }

                Divider()
                    .frame(height: 40)

                VStack(spacing: Spacing.xxs) {
                    Text("\(reviewManager.stats.totalReviews)")
                        .font(Typography.title2)
                        .foregroundColor(.textPrimary)
                    Text("Total Reviews")
                        .font(Typography.caption)
                        .foregroundColor(.textTertiary)
                }

                Divider()
                    .frame(height: 40)

                VStack(spacing: Spacing.xxs) {
                    Text("\(reviewManager.stats.matureItems)")
                        .font(Typography.title2)
                        .foregroundColor(.info)
                    Text("Mastered")
                        .font(Typography.caption)
                        .foregroundColor(.textTertiary)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(Spacing.lg)
        .background(Color.surfaceSecondary)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
    }
}

// MARK: - Emoji Stat Card (Notion-style)
struct EmojiStatCard: View {
    let title: String
    let value: String
    let emoji: String
    let color: Color

    var body: some View {
        VStack(spacing: Spacing.sm) {
            Text(emoji)
                .font(.system(size: 24))

            Text(value)
                .font(Typography.displaySmall)
                .foregroundColor(.textPrimary)

            Text(title)
                .font(Typography.caption)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(Spacing.md)
        .background(Color.surfaceSecondary)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
    }
}

// MARK: - Stat Card (Legacy SF Symbol version)
struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: Spacing.sm) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)

            Text(value)
                .font(Typography.displaySmall)
                .foregroundColor(.textPrimary)

            Text(title)
                .font(Typography.caption)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(Spacing.md)
        .background(Color.surfaceSecondary)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
    }
}

// MARK: - Unified Progress View (Combined Progress + Review)
struct UnifiedProgressView: View {
    @EnvironmentObject var progressManager: ProgressManager
    @EnvironmentObject var notionService: NotionService
    @EnvironmentObject var reviewManager: ReviewManager
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var showingReviewSession = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                // Subscription journey milestone card
                if let milestone = subscriptionManager.currentMilestone {
                    ProgressMilestoneCard(days: milestone) {
                        subscriptionManager.acknowledgeMilestone(milestone)
                    }
                    .padding(.top, Spacing.md)
                }

                // Overall progress ring (like screenshot)
                overallProgressSection
                    .padding(.top, Spacing.md)

                // Review banner if items due
                if reviewManager.reviewsDueCount > 0 {
                    reviewBannerSection
                }

                // Module progress list (like screenshot)
                moduleProgressSection

                // Time investment section
                timeInvestmentSection

                // Spaced repetition stats
                if reviewManager.state.reviewItems.count > 0 {
                    spacedRepetitionSection
                }

                // Mastery milestone banner
                if let milestone = reviewManager.pendingMilestone {
                    MilestoneBannerView(count: milestone) {
                        reviewManager.acknowledgeMilestone(milestone)
                    }
                }

                // Cross-module editorial connections (appear as modules are completed)
                CrossModuleInsightsSection()
                    .environmentObject(progressManager)
            }
            .padding(.horizontal, Spacing.lg)
            .padding(.bottom, Spacing.xxl)
            .frame(maxWidth: horizontalSizeClass == .regular ? 780 : .infinity)
            .frame(maxWidth: .infinity)
        }
        .background(Color.surfacePrimary)
        .navigationTitle("Progress")
        .sheet(isPresented: $showingReviewSession) {
            ReviewSessionView(items: reviewManager.itemsDueToday)
        }
    }

    // MARK: - Overall Progress (Large Ring)
    private var overallProgressSection: some View {
        let allSections = notionService.modules.flatMap { $0.sections }
        let completedSections = allSections.filter { progressManager.isSectionComplete($0.id) }.count
        let totalSections = allSections.count
        let progress = totalSections > 0 ? Double(completedSections) / Double(totalSections) : 0

        return VStack(spacing: Spacing.md) {
            ZStack {
                Circle()
                    .stroke(Color.divider, lineWidth: 16)

                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        Color.brandPrimary,
                        style: StrokeStyle(lineWidth: 16, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.smoothSpring, value: progress)

                VStack(spacing: 2) {
                    Text("\(Int(progress * 100))%")
                        .font(Typography.displayMedium)
                        .foregroundColor(.textPrimary)
                    Text("Complete")
                        .font(Typography.caption)
                        .foregroundColor(.textSecondary)
                }
            }
            .frame(width: 140, height: 140)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.lg)
    }

    // MARK: - Review Banner
    private var reviewBannerSection: some View {
        Button {
            showingReviewSession = true
        } label: {
            HStack(spacing: Spacing.md) {
                ZStack {
                    Circle()
                        .fill(Color.brandHighlight.opacity(0.15))
                        .frame(width: 44, height: 44)

                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.brandHighlight)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text("Review Due")
                        .font(Typography.bodyMedium)
                        .foregroundColor(.textPrimary)

                    Text("\(reviewManager.reviewsDueCount) items ready")
                        .font(Typography.caption)
                        .foregroundColor(.textSecondary)
                }

                Spacer()

                Text("Start")
                    .font(Typography.captionMedium)
                    .foregroundColor(.white)
                    .padding(.horizontal, Spacing.md)
                    .padding(.vertical, Spacing.sm)
                    .background(Color.brandHighlight)
                    .clipShape(Capsule())
            }
            .padding(Spacing.md)
            .background(Color.brandHighlight.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.lg))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Module Progress (Like Screenshot)
    // Ordered modules following Start Here learning sequence
    private var orderedModules: [Module] {
        let sequence = RecommendedLearningSequence.modules
        var ordered: [Module] = []
        // Add modules in the recommended sequence order
        for item in sequence {
            if let module = notionService.modules.first(where: { $0.id == item.moduleId }) {
                ordered.append(module)
            }
        }
        // Append any remaining modules not in the sequence (sub-modules, etc.)
        for module in notionService.modules {
            if !ordered.contains(where: { $0.id == module.id }) && !module.isSubModule {
                ordered.append(module)
            }
        }
        return ordered
    }

    private var moduleProgressSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            // Start Here header
            HStack(spacing: Spacing.sm) {
                Text("🎯")
                    .font(.system(size: 20))
                VStack(alignment: .leading, spacing: 2) {
                    Text("Start Here")
                        .font(Typography.bodyMedium)
                        .foregroundColor(.textPrimary)
                    Text("Recommended learning path")
                        .font(Typography.caption2)
                        .foregroundColor(.textTertiary)
                }
            }

            VStack(spacing: Spacing.xs) {
                ForEach(Array(orderedModules.enumerated()), id: \.element.id) { index, module in
                    let sequenceItem = RecommendedLearningSequence.modules.first(where: { $0.moduleId == module.id })
                    NavigationLink {
                        ModuleDetailView(initialModule: module)
                    } label: {
                        StartHereModuleRow(
                            module: module,
                            stepNumber: index + 1,
                            level: sequenceItem?.level
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(Spacing.md)
        .background(Color.surfaceSecondary)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.lg))
    }

    // MARK: - Time Investment (Fixed)
    private var timeInvestmentSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack {
                Text("⏱️")
                    .font(.system(size: 20))
                Text("Time Investment")
                    .font(Typography.bodyMedium)
                    .foregroundColor(.textPrimary)
            }

            VStack(spacing: Spacing.xs) {
                ForEach(orderedModules) { module in
                    UnifiedTimeRow(module: module, timeSpent: progressManager.progress.timeSpent[module.id] ?? 0)
                }
            }
        }
        .padding(Spacing.md)
        .background(Color.surfaceSecondary)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.lg))
    }

    // MARK: - Spaced Repetition Stats
    private var spacedRepetitionSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack {
                Text("🧠")
                    .font(.system(size: 20))
                Text("Memory & Retention")
                    .font(Typography.bodyMedium)
                    .foregroundColor(.textPrimary)
            }

            HStack(spacing: Spacing.md) {
                MiniStatView(value: "\(Int(reviewManager.stats.retentionRate * 100))%", label: "Retention", color: .success)
                MiniStatView(value: "\(reviewManager.state.streak)", label: "Streak", color: .warning)
                MiniStatView(value: "\(reviewManager.stats.matureItems)", label: "Mastered", color: .info)
            }
        }
        .padding(Spacing.md)
        .background(Color.surfaceSecondary)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.lg))
    }
}

// MARK: - Unified Module Progress Row
struct UnifiedModuleProgressRow: View {
    let module: Module
    @EnvironmentObject var progressManager: ProgressManager

    private var progress: Double {
        let completed = module.sections.filter { progressManager.isSectionComplete($0.id) }.count
        guard module.totalSections > 0 else { return 0 }
        return Double(completed) / Double(module.totalSections)
    }

    var body: some View {
        HStack(spacing: Spacing.sm) {
            Text(module.icon)
                .font(.system(size: 20))

            VStack(alignment: .leading, spacing: 4) {
                Text(module.title)
                    .font(Typography.caption)
                    .foregroundColor(.textPrimary)
                    .lineLimit(1)

                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.divider)

                        Capsule()
                            .fill(progress >= 1 ? Color.success : Color.brandPrimary)
                            .frame(width: geometry.size.width * progress)
                    }
                }
                .frame(height: 6)
            }

            Text("\(Int(progress * 100))%")
                .font(Typography.caption2)
                .foregroundColor(.textTertiary)
                .frame(width: 36, alignment: .trailing)
        }
        .padding(.vertical, Spacing.xs)
    }
}

// MARK: - Start Here Module Row (Learning Path + Progress)
struct StartHereModuleRow: View {
    let module: Module
    let stepNumber: Int
    let level: RecommendedLearningSequence.SequenceItem.Level?
    @EnvironmentObject var progressManager: ProgressManager

    private var progress: Double {
        let completed = module.sections.filter { progressManager.isSectionComplete($0.id) }.count
        guard module.totalSections > 0 else { return 0 }
        return Double(completed) / Double(module.totalSections)
    }

    private var isComplete: Bool { progress >= 1.0 }

    var body: some View {
        HStack(spacing: Spacing.sm) {
            // Step number circle
            ZStack {
                Circle()
                    .fill(isComplete ? Color.success : (level?.color ?? Color.brandPrimary).opacity(0.15))
                    .frame(width: 32, height: 32)

                if isComplete {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                } else {
                    Text("\(stepNumber)")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundColor(level?.color ?? .brandPrimary)
                }
            }

            // Module icon
            Text(module.icon)
                .font(.system(size: 18))

            // Title and progress bar
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: Spacing.xs) {
                    Text(module.title)
                        .font(Typography.caption)
                        .foregroundColor(.textPrimary)
                        .lineLimit(1)

                    if let level = level {
                        Text(level.rawValue)
                            .font(.system(size: 8, weight: .medium))
                            .foregroundColor(level.color)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 1)
                            .background(level.color.opacity(0.12))
                            .clipShape(Capsule())
                    }
                }

                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.divider)

                        Capsule()
                            .fill(isComplete ? Color.success : Color.brandPrimary)
                            .frame(width: geometry.size.width * progress)
                    }
                }
                .frame(height: 5)
            }

            Text("\(Int(progress * 100))%")
                .font(Typography.caption2)
                .foregroundColor(isComplete ? .success : .textTertiary)
                .frame(width: 36, alignment: .trailing)

            Image(systemName: "chevron.right")
                .font(.system(size: 10))
                .foregroundColor(.textTertiary)
        }
        .padding(.vertical, Spacing.xs)
    }
}

// MARK: - Unified Time Row
struct UnifiedTimeRow: View {
    let module: Module
    let timeSpent: TimeInterval

    var body: some View {
        HStack(spacing: Spacing.sm) {
            Text(module.icon)
                .font(.system(size: 20))

            VStack(alignment: .leading, spacing: 2) {
                Text(module.title)
                    .font(Typography.caption)
                    .foregroundColor(.textPrimary)
                    .lineLimit(1)

                Text("Time invested")
                    .font(Typography.caption2)
                    .foregroundColor(.textTertiary)
            }

            Spacer()

            Text(formatTime(timeSpent))
                .font(Typography.bodyMedium)
                .foregroundColor(.brandPrimary)
        }
        .padding(.vertical, Spacing.xs)
    }

    private func formatTime(_ seconds: TimeInterval) -> String {
        let hours = Int(seconds) / 3600
        let minutes = (Int(seconds) % 3600) / 60

        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}

// MARK: - Toolkit View (Global Access)
struct ToolkitView: View {
    @EnvironmentObject var userSettings: UserSettings
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var showPaywall = false

    private var isPremium: Bool { subscriptionManager.hasAccess }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                // Header
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text("Toolkit")
                        .font(Typography.displayMedium)
                        .foregroundColor(.textPrimary)

                    Text("Resources to deepen your learning")
                        .font(Typography.body)
                        .foregroundColor(.textSecondary)
                }
                .padding(.horizontal, Spacing.lg)
                .padding(.top, Spacing.lg)

                // Tool cards — adaptive columns: 2 on iPad, 1 on iPhone
                let columns = horizontalSizeClass == .regular
                    ? [GridItem(.flexible(), spacing: Spacing.sm), GridItem(.flexible(), spacing: Spacing.sm)]
                    : [GridItem(.flexible())]

                LazyVGrid(columns: columns, spacing: Spacing.sm) {

                    // MARK: - Premium Tools
                    if isPremium {
                        NavigationLink(destination: UniversalToolkitView()) {
                            ToolCardView(icon: "🧰", title: "Universal Toolkit", description: "Essential investing tools", color: .indigo)
                        }
                        .buttonStyle(.plain)
                    } else {
                        Button { showPaywall = true } label: {
                            ToolCardView(icon: "🧰", title: "Universal Toolkit", description: "Essential investing tools", color: .indigo, isLocked: true)
                        }
                        .buttonStyle(.plain)
                    }

                    if isPremium {
                        NavigationLink(destination: InteractiveScenariosListView()) {
                            ToolCardView(icon: "🧠", title: "Interactive Scenarios", description: "Practice with real-world situations", color: .purple)
                        }
                        .buttonStyle(.plain)
                    } else {
                        Button { showPaywall = true } label: {
                            ToolCardView(icon: "🧠", title: "Interactive Scenarios", description: "Practice with real-world situations", color: .purple, isLocked: true)
                        }
                        .buttonStyle(.plain)
                    }

                    if isPremium {
                        NavigationLink(destination: BrainMapView()) {
                            ToolCardView(icon: "🔬", title: "Brain Map", description: "Explore neuroscience of investing", color: .blue)
                        }
                        .buttonStyle(.plain)
                    } else {
                        Button { showPaywall = true } label: {
                            ToolCardView(icon: "🔬", title: "Brain Map", description: "Explore neuroscience of investing", color: .blue, isLocked: true)
                        }
                        .buttonStyle(.plain)
                    }

                    if isPremium {
                        NavigationLink(destination: ReflectionJournalView()) {
                            ToolCardView(icon: "✏️", title: "Reflection Journal", description: "Record your insights", color: .pink)
                        }
                        .buttonStyle(.plain)
                    } else {
                        Button { showPaywall = true } label: {
                            ToolCardView(icon: "✏️", title: "Reflection Journal", description: "Record your insights", color: .pink, isLocked: true)
                        }
                        .buttonStyle(.plain)
                    }

                    if isPremium {
                        NavigationLink(destination: ArtTrackOverviewView()) {
                            ToolCardView(icon: "🖼️", title: "Art Track", description: "Deep dive into art investing", color: .orange)
                        }
                        .buttonStyle(.plain)
                    } else {
                        Button { showPaywall = true } label: {
                            ToolCardView(icon: "🖼️", title: "Art Track", description: "Deep dive into art investing", color: .orange, isLocked: true)
                        }
                        .buttonStyle(.plain)
                    }

                    if isPremium {
                        NavigationLink(destination: ArtLibraryView()) {
                            ToolCardView(icon: "📚", title: "Art Library", description: "Books, podcasts & resources", color: .brown)
                        }
                        .buttonStyle(.plain)
                    } else {
                        Button { showPaywall = true } label: {
                            ToolCardView(icon: "📚", title: "Art Library", description: "Books, podcasts & resources", color: .brown, isLocked: true)
                        }
                        .buttonStyle(.plain)
                    }

                    // MARK: - Free Tools
                    NavigationLink(destination: ReadingListView()) {
                        ToolCardView(icon: "📖", title: "Reading List", description: "Curated books across economics & policy", color: .teal)
                    }
                    .buttonStyle(.plain)

                    NavigationLink(destination: GlossaryView()) {
                        ToolCardView(icon: "🔤", title: "Glossary", description: "270+ terms defined", color: .green)
                    }
                    .buttonStyle(.plain)

                    NavigationLink(destination: FootnotesDatabaseView()) {
                        ToolCardView(icon: "📑", title: "Research Footnotes", description: "All sources and citations", color: .gray)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, Spacing.lg)
            }
            .padding(.bottom, Spacing.xxl)
        }
        .background(Color.surfacePrimary)
        .navigationTitle("Toolkit")
        .sheet(isPresented: $showPaywall) {
            PaywallView()
        }
    }
}

// MARK: - Preview
#Preview {
    ContentView()
        .environmentObject(NotionService())
        .environmentObject(ProgressManager())
        .environmentObject(ReviewManager())
        .environmentObject(UserSettings.shared)
}
