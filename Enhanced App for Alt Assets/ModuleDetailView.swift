//
//  ModuleDetailView.swift
//  Enhanced App for Alt Assets
//
//  Created by Victoria Case on 2/1/26.
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//
//  Description: Main learning interface displaying module content with editorial
//  design inspired by NYT and Headspace. Features hero artwork, smooth transitions,
//  emoji section markers, and interactive learning components.
//

import SwiftUI

// MARK: - Tab Scroll Offset Tracking
private struct TabScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct ModuleDetailView: View {
    let initialModule: Module
    @EnvironmentObject var progressManager: ProgressManager
    @EnvironmentObject var reviewManager: ReviewManager
    @EnvironmentObject var userSettings: UserSettings
    @EnvironmentObject var notionService: NotionService
    @EnvironmentObject var subscriptionManager: SubscriptionManager

    /// Always read the latest version from notionService so Notion-fetched content
    /// (including child databases, toggle blocks, etc.) appears once the fetch completes.
    private var module: Module {
        notionService.modules.first(where: { $0.id == initialModule.id }) ?? initialModule
    }
    @State private var expandedSections: Set<String> = []
    @State private var selectedReflectionPrompt: ReflectionPrompt?
    @State private var selectedQuiz: Quiz?
    @State private var scrollOffset: CGFloat = 0
    @State private var selectedModuleTab: ModuleTab = .content
    @State private var showingBibliography = false
    @State private var showingFurtherReading = false
    @State private var showPaywall = false
    @State private var showingCertificate = false
    // Pinch-to-zoom (gentle, capped at 1.3x)
    @State private var contentScale: CGFloat = 1.0
    @State private var containerWidth: CGFloat = 0
    @GestureState private var pinchScale: CGFloat = 1.0
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    enum ModuleTab: String, CaseIterable {
        case content = "Content"
        case quizzes = "Quizzes"
        case reflection = "Reflection"
        case cases = "Use Cases"
        // ESG-specific tabs (only shown for ESG module)
        case esgTips = "Tips & Realities"
        case esgAdvisor = "Advisor Questions"
        case esgAdvanced = "Advanced Portfolio"
        case esgTerms = "ESG Terms"
        // DeFi 101 specific tabs (supplemental to Content)
        case defiLessons = "Lessons"
        case defiGlossary = "DeFi Glossary"
        case defiResearch = "Research Library"
        // DeFi Investing specific tabs
        case defiChecklist = "Checklist"
        case defiAdvisor = "Advisor Q's"
        case defiEvalFramework = "Eval Framework"
        case defiInvestGlossary = "Investor Glossary"
        case defiInvestResearch = "Papers"
        // Art-specific tabs
        case artDeFiBridge = "Art ↔ DeFi"
        case artKahloBasquiat = "Kahlo x Basquiat"
        case artNextSteps = "Next Steps"
        // Investing Primer specific tabs
        case womenLegislation = "Key Laws"

        /// Whether this tab is module-specific (not shown for all modules)
        var isModuleSpecific: Bool {
            switch self {
            case .esgTips, .esgAdvisor, .esgAdvanced, .esgTerms,
                 .defiLessons, .defiGlossary, .defiResearch,
                 .defiChecklist, .defiAdvisor, .defiEvalFramework, .defiInvestGlossary, .defiInvestResearch,
                 .artDeFiBridge, .artKahloBasquiat, .artNextSteps,
                 .womenLegislation:
                return true
            default:
                return false
            }
        }
    }

    /// Returns tabs available for the current module
    private var availableTabs: [ModuleTab] {
        let baseTabs: [ModuleTab] = [.content, .reflection, .quizzes, .cases]

        // Add ESG-specific tabs for the ESG module
        if module.id == "mod_esg_climate" {
            return baseTabs + [.esgTips, .esgAdvisor, .esgAdvanced, .esgTerms]
        }

        // DeFi 101 module: Content (Notion sections) + supplemental Lessons + Glossary + Research
        if module.id == "mod_defi" {
            return [.content, .reflection, .defiLessons, .defiGlossary, .defiResearch] + [.quizzes, .cases]
        }

        // DeFi Investing module: Content + Checklist + Advisor Q's + Eval Framework + Glossary + Research
        if module.id == "mod_defi_investing" {
            return [.content, .reflection, .defiChecklist, .defiAdvisor, .defiEvalFramework, .defiInvestGlossary, .defiInvestResearch] + [.quizzes, .cases]
        }

        // Add Art-specific tabs (Kahlo x Basquiat deep dive + DeFi bridge)
        if module.id == "mod_art" {
            return baseTabs + [.artKahloBasquiat, .artDeFiBridge, .artNextSteps]
        }

        // Investing Primer: add Key Laws tab
        if module.id == "mod_women" {
            return baseTabs + [.womenLegislation]
        }

        return baseTabs
    }

    /// Dampened effective scale for pinch gesture (1.0 to 1.3)
    private var effectiveContentScale: CGFloat {
        // Dampen the gesture: use square root for gentler feel
        let rawScale = contentScale * pinchScale
        let dampened = 1.0 + (rawScale - 1.0) * 0.5
        return min(max(dampened, 1.0), 1.3)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Clean typography header (Art Space style - no hero images)
                artSpaceHeader

                // Tab-based content (zoom applies here only)
                selectedTabContent
                    .scaleEffect(effectiveContentScale, anchor: .topLeading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .onGeometryChange(for: CGFloat.self) { proxy in
                        proxy.size.width
                    } action: { width in
                        containerWidth = width
                    }
                    .frame(
                        width: effectiveContentScale > 1.01 && containerWidth > 0
                            ? containerWidth / effectiveContentScale
                            : nil
                    )
            }
            .frame(maxWidth: horizontalSizeClass == .regular ? 780 : .infinity)
            .frame(maxWidth: .infinity)
        }
        .simultaneousGesture(
            MagnificationGesture()
                .updating($pinchScale) { value, state, _ in
                    state = value
                }
                .onEnded { value in
                    let rawScale = contentScale * value
                    let dampened = 1.0 + (rawScale - 1.0) * 0.5
                    let newScale = min(max(dampened, 1.0), 1.3)
                    withAnimation(.easeOut(duration: 0.2)) {
                        contentScale = newScale
                    }
                }
        )
        .onTapGesture(count: 2) {
            withAnimation(.easeOut(duration: 0.2)) {
                contentScale = 1.0
            }
        }
        .background(Color.surfacePrimary)
        .navigationTitle("")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .toolbar {
            #if os(iOS)
            ToolbarItem(placement: .principal) {
                Text(module.title)
                    .font(Typography.bodyMedium)
                    .foregroundColor(.textPrimary)
                    .lineLimit(1)
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button {
                        cycleTextSize(direction: .up)
                    } label: {
                        Label("Increase Text", systemImage: "textformat.size.larger")
                    }
                    .disabled(userSettings.textSize == .extraLarge)

                    Button {
                        cycleTextSize(direction: .down)
                    } label: {
                        Label("Decrease Text", systemImage: "textformat.size.smaller")
                    }
                    .disabled(userSettings.textSize == .small)

                    Button {
                        userSettings.textSize = .medium
                    } label: {
                        Label("Reset Text Size", systemImage: "arrow.counterclockwise")
                    }
                    .disabled(userSettings.textSize == .medium)

                    Divider()

                    Button {
                        expandAll()
                    } label: {
                        Label("Expand All", systemImage: "arrow.down.right.and.arrow.up.left")
                    }

                    Button {
                        collapseAll()
                    } label: {
                        Label("Collapse All", systemImage: "arrow.up.left.and.arrow.down.right")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(.textSecondary)
                }
            }
            #else
            ToolbarItem(placement: .automatic) {
                Menu {
                    Button {
                        expandAll()
                    } label: {
                        Label("Expand All", systemImage: "arrow.down.right.and.arrow.up.left")
                    }

                    Button {
                        collapseAll()
                    } label: {
                        Label("Collapse All", systemImage: "arrow.up.left.and.arrow.down.right")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(.textSecondary)
                }
            }
            #endif
        }
        .sheet(item: $selectedReflectionPrompt) { prompt in
            ReflectionPromptView(
                prompt: prompt,
                moduleId: module.id
            )
        }
        .sheet(item: $selectedQuiz, onDismiss: {
            // Show certificate if module is complete and at least one quiz was passed
            let passed = module.quizzes.contains { quiz in
                (progressManager.progress.quizScores[quiz.id] ?? 0) >= 0.7
            }
            if progressManager.isModuleComplete(module.id) && passed {
                showingCertificate = true
            }
        }) { quiz in
            QuizView(quiz: quiz, moduleId: module.id)
                .environmentObject(progressManager)
                .environmentObject(reviewManager)
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView()
        }
        .sheet(isPresented: $showingCertificate) {
            ModuleCompletionCertificateSheet(module: module)
                .environmentObject(progressManager)
        }
        .onAppear {
            progressManager.startSession(moduleId: module.id)
            expandedSections = Set(module.sections.map { $0.id })
            ModuleFootnotesManager.shared.loadFromModuleSections(module.sections, moduleId: module.id)
        }
        .onChange(of: notionService.isLoading) { _, isLoading in
            if !isLoading {
                // Re-sync expanded state with the freshly-fetched sections
                expandedSections = Set(module.sections.map { $0.id })
                ModuleFootnotesManager.shared.loadFromModuleSections(module.sections, moduleId: module.id)
            }
        }
        .onDisappear {
            progressManager.endSession()
        }
    }

    // MARK: - Art Space Typography Header (Clean, no images)
    private var artSpaceHeader: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Large serif title with research badge
            VStack(alignment: .leading, spacing: Spacing.sm) {
                // Research type badge
                HStack(spacing: 4) {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 10))
                    Text(researchTypeBadge)
                        .font(Typography.footnote)
                }
                .foregroundColor(.brandPrimary)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.brandPrimary.opacity(0.1))
                .clipShape(Capsule())

                // Large serif title (Art Space style)
                Text(module.title)
                    .font(Typography.displayMedium)
                    .foregroundColor(.textPrimary)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)

                // Description
                Text(module.description)
                    .font(Typography.body)
                    .foregroundColor(.textSecondary)
                    .lineSpacing(4)

                // Metadata row with superscript annotations
                HStack(spacing: Spacing.sm) {
                    Text("\(module.totalSections) sections")
                    Text("·")
                    Text("\(module.estimatedTime) min")
                    if !module.quizzes.isEmpty {
                        Text("·")
                        HStack(spacing: 2) {
                            Text("\(module.quizzes.count)")
                            Text("Q")
                                .font(Typography.superscript)
                                .baselineOffset(4)
                        }
                    }
                    if !module.reflectionPrompts.isEmpty {
                        HStack(spacing: 2) {
                            Text("\(module.reflectionPrompts.count)")
                            Text("R")
                                .font(Typography.superscript)
                                .baselineOffset(4)
                        }
                    }
                    if !module.caseStudies.isEmpty {
                        HStack(spacing: 2) {
                            Text("\(module.caseStudies.count)")
                            Text("C")
                                .font(Typography.superscript)
                                .baselineOffset(4)
                        }
                    }
                    if progressManager.isModuleComplete(module.id) {
                        Text("·")
                        HStack(spacing: 4) {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Complete")
                        }
                        .foregroundColor(.success)
                    }
                }
                .font(Typography.caption)
                .foregroundColor(.textTertiary)
            }
            .padding(.horizontal, Spacing.lg)
            .padding(.top, Spacing.lg)
            .padding(.bottom, Spacing.md)

            // Functional tab navigation
            moduleTabNavigation
        }
    }

    // Research type badge based on module content
    private var researchTypeBadge: String {
        if module.id.contains("behavioral") || module.id.contains("gender") {
            return "Empirical Research"
        } else if module.id.contains("art") || module.id.contains("kahlo") {
            return "Case Studies"
        } else if module.id.contains("defi") {
            return "Technical Analysis"
        } else {
            return "Research-Based"
        }
    }

    // MARK: - Module Tab Navigation (Functional)
    @State private var tabContentWidth: CGFloat = 0
    @State private var tabViewportWidth: CGFloat = 0
    @State private var tabScrollOffset: CGFloat = 0

    private var tabsOverflow: Bool { tabContentWidth > tabViewportWidth + 1 }
    private var showTrailingFade: Bool { tabsOverflow && tabScrollOffset < (tabContentWidth - tabViewportWidth - 1) }
    private var showLeadingFade: Bool { tabScrollOffset > 1 }

    private var moduleTabNavigation: some View {
        VStack(spacing: 0) {
            ZStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: Spacing.lg) {
                        ForEach(availableTabs, id: \.self) { tab in
                            Button {
                                withAnimation(.smoothSpring) {
                                    selectedModuleTab = tab
                                }
                            } label: {
                                VStack(spacing: 6) {
                                    HStack(spacing: 4) {
                                        Text(tab.rawValue)
                                            .font(selectedModuleTab == tab ? Typography.bodyMedium : Typography.body)
                                            .foregroundColor(selectedModuleTab == tab ? .textPrimary : .textTertiary)

                                        // Badge count
                                        if let count = tabBadgeCount(for: tab), count > 0 {
                                            Text("\(count)")
                                                .font(Typography.caption2)
                                                .foregroundColor(selectedModuleTab == tab ? .white : .textTertiary)
                                                .padding(.horizontal, 6)
                                                .padding(.vertical, 2)
                                                .background(selectedModuleTab == tab ? Color.brandPrimary : Color.surfaceSecondary)
                                                .clipShape(Capsule())
                                        }
                                    }

                                    // Active indicator
                                    Rectangle()
                                        .fill(selectedModuleTab == tab ? Color.textPrimary : Color.clear)
                                        .frame(height: 2)
                                }
                            }
                            .buttonStyle(.plain)
                            .accessibilityLabel("\(tab.rawValue) tab\(selectedModuleTab == tab ? ", selected" : "")")
                            .accessibilityHint("Switch to \(tab.rawValue)")
                            .accessibilityAddTraits(selectedModuleTab == tab ? .isSelected : [])
                        }
                    }
                    .padding(.horizontal, Spacing.lg)
                    .padding(.top, Spacing.md)
                    .background(
                        GeometryReader { contentGeo in
                            Color.clear
                                .preference(key: TabScrollOffsetKey.self, value: -contentGeo.frame(in: .named("tabScroll")).origin.x)
                                .onAppear { tabContentWidth = contentGeo.size.width }
                                .onChange(of: contentGeo.size.width) { _, newWidth in tabContentWidth = newWidth }
                        }
                    )
                }
                .coordinateSpace(name: "tabScroll")
                .onPreferenceChange(TabScrollOffsetKey.self) { tabScrollOffset = $0 }
                .background(
                    GeometryReader { viewportGeo in
                        Color.clear
                            .onAppear { tabViewportWidth = viewportGeo.size.width }
                            .onChange(of: viewportGeo.size.width) { _, newWidth in tabViewportWidth = newWidth }
                    }
                )

                // Trailing fade + chevron — hints at more tabs to the right
                if showTrailingFade {
                    HStack(spacing: 0) {
                        Spacer()
                        ZStack(alignment: .trailing) {
                            LinearGradient(
                                colors: [Color.surfacePrimary.opacity(0), Color.surfacePrimary.opacity(0.9), Color.surfacePrimary],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                            .frame(width: 56)

                            Image(systemName: "chevron.compact.right")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.textTertiary)
                                .padding(.trailing, 4)
                        }
                        .allowsHitTesting(false)
                    }
                }

                // Leading fade + chevron — hints at more tabs to the left
                if showLeadingFade {
                    HStack(spacing: 0) {
                        ZStack(alignment: .leading) {
                            LinearGradient(
                                colors: [Color.surfacePrimary, Color.surfacePrimary.opacity(0.9), Color.surfacePrimary.opacity(0)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                            .frame(width: 56)

                            Image(systemName: "chevron.compact.left")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.textTertiary)
                                .padding(.leading, 4)
                        }
                        .allowsHitTesting(false)
                        Spacer()
                    }
                }
            }

            Rectangle()
                .fill(Color.divider)
                .frame(height: 1)
        }
    }

    // Badge count for each tab
    private func tabBadgeCount(for tab: ModuleTab) -> Int? {
        switch tab {
        case .content: return module.sections.count
        case .quizzes: return module.quizzes.count
        case .reflection: return module.reflectionPrompts.count
        case .cases: return module.caseStudies.count
        // Module-specific tabs don't show badge counts
        case .esgTips, .esgAdvisor, .esgAdvanced, .esgTerms: return nil
        case .defiLessons: return 8  // 8 DeFi lessons
        case .defiGlossary: return nil
        case .defiResearch: return nil
        case .defiChecklist: return 4  // 4 checklist categories
        case .defiAdvisor: return 14  // 14 advisor evaluation questions
        case .defiEvalFramework: return 6  // 6 framework sections
        case .defiInvestGlossary: return nil
        case .defiInvestResearch: return nil
        case .artDeFiBridge: return nil
        case .artKahloBasquiat: return nil
        case .artNextSteps: return nil
        case .womenLegislation: return 7  // 7 key laws
        }
    }

    // MARK: - Tab Content Switcher
    @ViewBuilder
    private var selectedTabContent: some View {
        switch selectedModuleTab {
        case .content:
            contentTabView
        case .quizzes:
            quizzesTabView
        case .reflection:
            reflectionTabView
        case .cases:
            casesTabView
        case .esgTips:
            ESGTipsRealitiesTabView()
        case .esgAdvisor:
            ESGAdvisorQuestionsInteractiveView()
        case .esgAdvanced:
            ESGAdvancedPortfolioTabView()
        case .esgTerms:
            ESGTermsTabView()
        // DeFi 101 tabs
        case .defiLessons:
            DeFiLessonsTabView()
        case .defiGlossary:
            DeFiGlossaryView()
        case .defiResearch:
            PolicyPaperLibraryView()
        // DeFi Investing tabs
        case .defiChecklist:
            DeFiChecklistTabView()
        case .defiAdvisor:
            DeFiAdvisorQuestionsTabView()
        case .defiEvalFramework:
            DeFiEvalFrameworkTabView()
        case .defiInvestGlossary:
            DeFiGlossaryView()
        case .defiInvestResearch:
            DeFiInvestingResearchView()
        // Art-specific tabs
        case .artDeFiBridge:
            ArtNFTDeFiBridgeView()
        case .artKahloBasquiat:
            KahloBasquiatTabView()
        case .artNextSteps:
            ArtNextStepsTabView()
        // Investing Primer tabs
        case .womenLegislation:
            WomenKeyLawsTabView()
        }
    }

    // MARK: - Content Tab
    private var contentTabView: some View {
        VStack(alignment: .leading, spacing: Spacing.lg) {
            // Educational disclaimer
            ModuleDisclaimerBanner()
                .padding(.horizontal, Spacing.md)
                .padding(.top, Spacing.md)

            // Progress indicator (subtle)
            progressIndicator
                .padding(.horizontal, Spacing.md)

            // Content sections (Notion toggle-style)
            sectionsContent
                .padding(.leading, Spacing.md)
                .padding(.trailing, Spacing.md + 2) // Slightly more right padding

            // Further Reading section (from Notion)
            furtherReadingSection
                .padding(.horizontal, Spacing.md)
                .padding(.top, Spacing.lg)

            // Collapsible Sources & Bibliography section
            sourcesAndBibliography
                .padding(.horizontal, Spacing.md)
                .padding(.top, Spacing.md)

            // Bottom copyright & disclaimer
            ModuleFooterDisclaimer()
                .padding(.horizontal, Spacing.md)

            // Bottom spacing
            Spacer()
                .frame(height: Spacing.xxxl)
        }
    }

    // MARK: - Further Reading Section (from Notion)
    private var furtherReadingSection: some View {
        let readings = notionService.readings(for: module.id)

        return Group {
            if !readings.isEmpty || !notionService.furtherReadings.isEmpty {
                VStack(alignment: .leading, spacing: 0) {
                    // Toggle header
                    Button {
                        withAnimation(.smoothSpring) {
                            showingFurtherReading.toggle()
                        }
                    } label: {
                        HStack(spacing: Spacing.sm) {
                            Image(systemName: showingFurtherReading ? "chevron.down" : "chevron.right")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.textTertiary)
                                .frame(width: 16)

                            Text("📖")
                                .font(.system(size: 18))

                            Text("Further Reading")
                                .font(Typography.bodyMedium)
                                .foregroundColor(.textPrimary)

                            if !readings.isEmpty {
                                Text("(\(readings.count))")
                                    .font(Typography.caption)
                                    .foregroundColor(.textTertiary)
                            }

                            Spacer()
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .padding(.vertical, Spacing.sm)

                    // Expanded further reading content
                    if showingFurtherReading {
                        VStack(alignment: .leading, spacing: Spacing.sm) {
                            if readings.isEmpty {
                                // Show general readings if no module-specific ones
                                let generalReadings = notionService.furtherReadings.prefix(5)
                                if generalReadings.isEmpty {
                                    Text("Connect to Notion to load reading recommendations.")
                                        .font(Typography.caption)
                                        .foregroundColor(.textTertiary)
                                        .padding(.leading, Spacing.lg)
                                        .padding(.vertical, Spacing.sm)
                                } else {
                                    ForEach(Array(generalReadings)) { reading in
                                        FurtherReadingRowView(reading: reading)
                                    }
                                }
                            } else {
                                ForEach(readings) { reading in
                                    FurtherReadingRowView(reading: reading)
                                }
                            }
                        }
                        .padding(.leading, Spacing.lg)
                        .padding(.top, Spacing.xs)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                }
                .padding(Spacing.md)
                .background(Color.surfaceSecondary)
                .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
            }
        }
    }

    // MARK: - Sources & Bibliography (Collapsible)
    private var sourcesAndBibliography: some View {
        let footnotes = ModuleFootnotesManager.shared.footnotes(for: module.id)

        return VStack(alignment: .leading, spacing: 0) {
            // Toggle header
            Button {
                withAnimation(.smoothSpring) {
                    showingBibliography.toggle()
                }
            } label: {
                HStack(spacing: Spacing.sm) {
                    Image(systemName: showingBibliography ? "chevron.down" : "chevron.right")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.textTertiary)
                        .frame(width: 16)

                    Text("📚")
                        .font(.system(size: 18))

                    Text("Sources & Bibliography")
                        .font(Typography.bodyMedium)
                        .foregroundColor(.textPrimary)

                    if !footnotes.isEmpty {
                        Text("(\(footnotes.count))")
                            .font(Typography.caption)
                            .foregroundColor(.textTertiary)
                    }

                    Spacer()
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .padding(.vertical, Spacing.sm)

            // Expanded bibliography content
            if showingBibliography {
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    if footnotes.isEmpty {
                        Text("No sources available for this module yet.")
                            .font(Typography.caption)
                            .foregroundColor(.textTertiary)
                            .padding(.leading, Spacing.lg)
                            .padding(.vertical, Spacing.sm)
                    } else {
                        ForEach(footnotes) { footnote in
                            BibliographyRowView(footnote: footnote)
                        }
                    }
                }
                .padding(.leading, Spacing.lg)
                .padding(.top, Spacing.xs)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(Spacing.md)
        .background(Color.surfaceSecondary)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
    }

    // MARK: - Quizzes Tab
    private var quizzesTabView: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            if module.quizzes.isEmpty {
                emptyStateView(
                    icon: "questionmark.circle",
                    title: "No Quizzes Yet",
                    message: "Quizzes for this module are coming soon."
                )
            } else {
                Text("Test Your Knowledge")
                    .font(Typography.title2)
                    .foregroundColor(.textPrimary)
                    .padding(.top, Spacing.lg)

                Text("Complete these quizzes to reinforce your learning and track your progress.")
                    .font(Typography.body)
                    .foregroundColor(.textSecondary)

                ForEach(Array(module.quizzes.enumerated()), id: \.element.id) { index, quiz in
                    let accessible = subscriptionManager.isQuizAccessible(
                        moduleId: module.id,
                        quizIndex: index
                    )

                    if accessible {
                        QuizCard(quiz: quiz, moduleId: module.id) {
                            selectedQuiz = quiz
                        }
                    } else {
                        QuizCard(quiz: quiz, moduleId: module.id) {
                            showPaywall = true
                        }
                        .overlay(LockedOverlay())
                    }
                }
            }

            Spacer()
                .frame(height: Spacing.xxxl)
        }
        .padding(.horizontal, Spacing.lg)
    }

    // MARK: - Reflection Tab
    private var reflectionTabView: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            if !subscriptionManager.areReflectionsAccessible(module.id) {
                // Gated — show teaser + paywall
                VStack(spacing: Spacing.lg) {
                    emptyStateView(
                        icon: "sparkles",
                        title: "Reflection Prompts",
                        message: "Personal reflection questions help you internalize concepts and apply them to your own investing journey."
                    )
                    InlinePaywallCard()
                }
            } else if module.reflectionPrompts.isEmpty {
                emptyStateView(
                    icon: "sparkles",
                    title: "No Reflections Yet",
                    message: "Reflection prompts for this module are coming soon."
                )
            } else {
                Text("Deepen Your Understanding")
                    .font(Typography.title2)
                    .foregroundColor(.textPrimary)
                    .padding(.top, Spacing.lg)

                Text("Take time to reflect on what you've learned and how it applies to your investment journey.")
                    .font(Typography.body)
                    .foregroundColor(.textSecondary)

                ForEach(module.reflectionPrompts) { prompt in
                    ReflectionPromptCard(prompt: prompt) {
                        selectedReflectionPrompt = prompt
                    }
                }

                // Deep self-reflection questions (introspective, categorized)
                let deepQuestions = ReflectionQuestionsManager.shared.questions(for: module.id)
                if !deepQuestions.isEmpty {
                    Divider()
                        .padding(.vertical, Spacing.sm)

                    Text("Personal Reflection")
                        .font(Typography.title3)
                        .foregroundColor(.textPrimary)

                    Text("These questions are designed for sustained reflection — return to them over time as your perspective evolves.")
                        .font(Typography.caption)
                        .foregroundColor(.textSecondary)

                    SelfReflectionSectionView(moduleId: module.id)
                }
            }

            Spacer()
                .frame(height: Spacing.xxxl)
        }
        .padding(.horizontal, Spacing.lg)
    }

    // MARK: - Cases Tab
    private var casesTabView: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            if !subscriptionManager.areCaseStudiesAccessible(module.id) {
                // Gated — show teaser + paywall
                VStack(spacing: Spacing.lg) {
                    emptyStateView(
                        icon: "doc.text.magnifyingglass",
                        title: "Case Studies",
                        message: "Real-world case studies show how these concepts play out in actual investment scenarios."
                    )
                    InlinePaywallCard()
                }
            } else if module.caseStudies.isEmpty {
                emptyStateView(
                    icon: "doc.text.magnifyingglass",
                    title: "No Case Studies Yet",
                    message: "Real-world case studies for this module are coming soon."
                )
            } else {
                Text("Real-World Applications")
                    .font(Typography.title2)
                    .foregroundColor(.textPrimary)
                    .padding(.top, Spacing.lg)

                Text("Explore how these concepts apply in real investment scenarios.")
                    .font(Typography.body)
                    .foregroundColor(.textSecondary)

                ForEach(module.caseStudies) { caseStudy in
                    CaseStudyCard(caseStudy: caseStudy)
                }
            }

            Spacer()
                .frame(height: Spacing.xxxl)
        }
        .padding(.horizontal, Spacing.lg)
    }

    // MARK: - Empty State View
    private func emptyStateView(icon: String, title: String, message: String) -> some View {
        VStack(spacing: Spacing.md) {
            Image(systemName: icon)
                .font(.system(size: 48))
                .foregroundColor(.textTertiary)

            Text(title)
                .font(Typography.title3)
                .foregroundColor(.textPrimary)

            Text(message)
                .font(Typography.body)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.xxxl)
    }

    // MARK: - Progress Indicator (Notion-style)
    private var progressIndicator: some View {
        let completedSections = module.sections.filter {
            progressManager.isSectionComplete($0.id)
        }.count
        let totalSections = module.sections.count
        let progress = totalSections > 0 ? Double(completedSections) / Double(totalSections) : 0

        return HStack(spacing: Spacing.sm) {
            // Progress bar (thin, subtle)
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.divider)

                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.brandPrimary.opacity(0.6))
                        .frame(width: geometry.size.width * progress)
                        .animation(.smoothSpring, value: progress)
                }
            }
            .frame(height: 4)

            // Progress text
            Text("\(completedSections)/\(totalSections)")
                .font(Typography.caption)
                .foregroundColor(.textTertiary)
                .frame(width: 40)
        }
        .padding(.bottom, Spacing.md)
    }

    // MARK: - Sections Content
    private var sectionsContent: some View {
        let filteredSections = module.sections.filter { section in
            let t = section.title.trimmingCharacters(in: .whitespacesAndNewlines)
            let lower = t.lowercased()
            if ["footnote", "reference", "bibliography", "citation", "source", "appendix"]
                .contains(where: { lower.contains($0) }) { return false }
            // DeFi Investing eval framework sections belong in the Eval Framework tab
            if module.id == "mod_defi_investing" {
                let evalKeywords = ["step 1:", "step 2:", "step 3:", "step 4:", "risk framework",
                                    "real-world asset", "protocol fundamental"]
                if evalKeywords.contains(where: { lower.contains($0) }) { return false }
            }
            return true
        }
        let visibleCount = subscriptionManager.visibleSectionCount(
            for: module.id,
            totalSections: filteredSections.count
        )
        let isGated = !subscriptionManager.isModuleAccessible(module.id)

        return LazyVStack(alignment: .leading, spacing: 0) {
            ForEach(Array(filteredSections.prefix(visibleCount).enumerated()), id: \.element.id) { index, section in
                EditorialSectionView(
                    section: section,
                    sectionNumber: index + 1,
                    isExpanded: expandedSections.contains(section.id)
                ) {
                    toggleSection(section.id)
                }
                .onAppear {
                    // Auto-mark section as read when it scrolls into view
                    progressManager.markSectionComplete(section.id)
                }
            }

            // Inline paywall after preview sections
            if isGated && filteredSections.count > visibleCount {
                InlinePaywallCard()
                    .padding(.top, Spacing.lg)
            }
        }
    }

    // MARK: - Section Management
    private func toggleSection(_ sectionId: String) {
        withAnimation(.smoothSpring) {
            if expandedSections.contains(sectionId) {
                expandedSections.remove(sectionId)
            } else {
                expandedSections.insert(sectionId)
                progressManager.markSectionComplete(sectionId)
            }
        }
    }

    private func expandAll() {
        let displaySections = module.sections.filter { section in
            let t = section.title.trimmingCharacters(in: .whitespacesAndNewlines)
            let lower = t.lowercased()
            if ["footnote", "reference", "bibliography", "citation", "source", "appendix"]
                .contains(where: { lower.contains($0) }) { return false }
            if module.id == "mod_defi_investing" {
                let evalKeywords = ["step 1:", "step 2:", "step 3:", "step 4:", "risk framework",
                                    "real-world asset", "protocol fundamental"]
                if evalKeywords.contains(where: { lower.contains($0) }) { return false }
            }
            return true
        }
        withAnimation(.smoothSpring) {
            expandedSections = Set(displaySections.map { $0.id })
            for section in displaySections {
                progressManager.markSectionComplete(section.id)
            }
        }
    }

    private func collapseAll() {
        withAnimation(.smoothSpring) {
            expandedSections.removeAll()
        }
    }

    private enum SizeDirection { case up, down }

    private func cycleTextSize(direction: SizeDirection) {
        let sizes: [TextSize] = [.small, .medium, .large, .extraLarge]
        guard let currentIndex = sizes.firstIndex(of: userSettings.textSize) else { return }
        switch direction {
        case .up:
            if currentIndex < sizes.count - 1 {
                userSettings.textSize = sizes[currentIndex + 1]
            }
        case .down:
            if currentIndex > 0 {
                userSettings.textSize = sizes[currentIndex - 1]
            }
        }
    }

}

// MARK: - Content Block Helpers

/// Removes empty text blocks and consecutive duplicate blocks (dividers, callouts, etc.) from a content array.
private func deduplicatedBlocks(_ blocks: [ContentBlock]) -> [ContentBlock] {
    var result: [ContentBlock] = []
    var lastBlock: ContentBlock? = nil
    for block in blocks {
        switch block {
        case .text(let content):
            guard !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { continue }
            result.append(block)
            lastBlock = block
        default:
            guard block != lastBlock else { continue }
            result.append(block)
            lastBlock = block
        }
    }
    return result
}

// MARK: - Editorial Section Header (Notion-style)
struct EditorialSectionHeader: View {
    let emoji: String
    let title: String
    let subtitle: String?
    @EnvironmentObject var userSettings: UserSettings

    init(emoji: String, title: String, subtitle: String? = nil) {
        self.emoji = emoji
        self.title = title
        self.subtitle = subtitle
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            HStack(spacing: Spacing.sm) {
                if userSettings.showEmojis {
                    Text(emoji)
                        .font(.system(size: 20))
                }

                Text(title)
                    .font(Typography.bodyMedium)
                    .foregroundColor(.textPrimary)
            }

            if let subtitle = subtitle {
                Text(subtitle)
                    .font(Typography.caption)
                    .foregroundColor(.textTertiary)
            }
        }
        .padding(.top, Spacing.lg)
        .padding(.bottom, Spacing.sm)
    }
}

// MARK: - Editorial Section View (Notion Toggle-style)
struct EditorialSectionView: View {
    let section: Section
    let sectionNumber: Int
    let isExpanded: Bool
    let onToggle: () -> Void
    @EnvironmentObject var progressManager: ProgressManager
    @EnvironmentObject var userSettings: UserSettings
    @State private var selectedGlossaryTerm: GlossaryTerm?

    private var hasContent: Bool {
        !deduplicatedBlocks(section.content).isEmpty
    }

    /// Extract all plain text from the section's content blocks for glossary scanning.
    private var sectionText: String {
        section.content.compactMap { block -> String? in
            switch block {
            case .text(let s): return s
            case .heading(let s, _): return s
            case .bulletList(let items): return items.joined(separator: " ")
            case .numberedList(let items): return items.joined(separator: " ")
            case .callout(let title, let content, _): return "\(title) \(content)"
            case .quote(let s, let author): return [s, author].compactMap { $0 }.joined(separator: " ")
            case .keyFact(_, let title, let value, _): return "\(title) \(value)"
            case .statistic(let value, let label, let context): return [value, label, context].compactMap { $0 }.joined(separator: " ")
            case .toggleBlock(let title, let content): return "\(title) \(content)"
            default: return nil
            }
        }.joined(separator: " ")
    }

    private var detectedGlossaryTerms: [GlossaryTerm] {
        GlossaryManager.shared.terms(in: sectionText)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Section header — toggleable only when there is content
            if hasContent {
                Button(action: onToggle) {
                    HStack(alignment: .center, spacing: Spacing.sm) {
                        Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.textTertiary)
                            .frame(width: 16)

                        Text(section.title)
                            .font(Typography.bodyMedium)
                            .foregroundColor(.textPrimary)
                            .multilineTextAlignment(.leading)

                        Spacer()

                        if progressManager.isSectionComplete(section.id) {
                            Image(systemName: "checkmark")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.success)
                        }
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .padding(.vertical, Spacing.sm)
            } else {
                HStack(alignment: .center, spacing: Spacing.sm) {
                    Text(section.title)
                        .font(Typography.bodyMedium)
                        .foregroundColor(.textPrimary)
                        .multilineTextAlignment(.leading)

                    Spacer()

                    if progressManager.isSectionComplete(section.id) {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.success)
                    }
                }
                .padding(.vertical, Spacing.sm)
            }

            // Section content (indented like Notion)
            if isExpanded {
                VStack(alignment: .leading, spacing: Spacing.lg) {
                    ForEach(Array(deduplicatedBlocks(section.content).enumerated()), id: \.element.id) { index, block in
                        ContentBlockView(block: block, isFirstBlock: index == 0)
                    }

                    // Glossary terms detected in this section
                    let terms = detectedGlossaryTerms
                    if !terms.isEmpty {
                        VStack(alignment: .leading, spacing: Spacing.xs) {
                            Text("Terms in this section")
                                .font(Typography.caption)
                                .foregroundColor(.textTertiary)
                                .padding(.top, Spacing.sm)

                            FlowLayout(spacing: 6) {
                                ForEach(terms) { term in
                                    Button {
                                        selectedGlossaryTerm = term
                                    } label: {
                                        Text(term.term)
                                            .font(Typography.caption)
                                            .foregroundColor(.brandPrimary)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 4)
                                            .background(Color.brandPrimary.opacity(0.08))
                                            .clipShape(Capsule())
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                }
                .padding(.leading, Spacing.lg)
                .padding(.trailing, Spacing.xs)
                .padding(.bottom, Spacing.lg)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .sheet(item: $selectedGlossaryTerm) { term in
            GlossaryTermDetailSheet(term: term)
        }
    }
}

// MARK: - Glossary Term Detail Sheet
struct GlossaryTermDetailSheet: View {
    let term: GlossaryTerm
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.lg) {
                    // Category badge
                    Text(term.category.rawValue)
                        .font(Typography.caption)
                        .foregroundColor(.brandPrimary)
                        .padding(.horizontal, Spacing.sm)
                        .padding(.vertical, Spacing.xs)
                        .background(Color.brandPrimary.opacity(0.1))
                        .clipShape(Capsule())

                    // Definition
                    Text(term.definition)
                        .font(Typography.body)
                        .foregroundColor(.textPrimary)
                        .fixedSize(horizontal: false, vertical: true)

                    // Simple explanation
                    if let simple = term.simpleExplanation {
                        VStack(alignment: .leading, spacing: Spacing.xs) {
                            Text("In plain terms")
                                .font(Typography.captionMedium)
                                .foregroundColor(.textTertiary)
                            Text(simple)
                                .font(Typography.body)
                                .foregroundColor(.textSecondary)
                        }
                        .padding(Spacing.md)
                        .background(Color.surfaceSecondary)
                        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.sm))
                    }

                    // Examples
                    if !term.examples.isEmpty {
                        VStack(alignment: .leading, spacing: Spacing.sm) {
                            Text("Examples")
                                .font(Typography.captionMedium)
                                .foregroundColor(.textTertiary)
                            ForEach(term.examples, id: \.self) { example in
                                HStack(alignment: .top, spacing: Spacing.sm) {
                                    Circle()
                                        .fill(Color.brandPrimary.opacity(0.4))
                                        .frame(width: 5, height: 5)
                                        .padding(.top, 7)
                                    Text(example)
                                        .font(Typography.body)
                                        .foregroundColor(.textSecondary)
                                }
                            }
                        }
                    }
                }
                .padding(Spacing.lg)
            }
            .background(Color.surfacePrimary)
            .navigationTitle(term.term)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}


// MARK: - Content Block View
struct ContentBlockView: View {
    let block: ContentBlock
    var isFirstBlock: Bool = false

    var body: some View {
        switch block {
        case .text(let content):
            ExpandableTextBlock(content: content)

        case .heading(let title, let level):
            Text(title)
                .font(level == 2 ? Typography.title2 : Typography.title3)
                .foregroundColor(.textPrimary)
                .padding(.top, isFirstBlock ? 0 : Spacing.md)
                .padding(.bottom, Spacing.xs)

        case .callout(let title, let content, let type):
            if !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                CalloutView(title: title, content: content, type: type)
                    .padding(.vertical, Spacing.xs)
            }

        case .bulletList(let items):
            VStack(alignment: .leading, spacing: Spacing.sm) {
                ForEach(items, id: \.self) { item in
                    HStack(alignment: .top, spacing: Spacing.sm) {
                        Circle()
                            .fill(Color.textTertiary)
                            .frame(width: 6, height: 6)
                            .padding(.top, 8)
                        DynamicTextView(item, color: .textPrimary)
                            .bodyStyle()
                    }
                }
            }

        case .numberedList(let items):
            VStack(alignment: .leading, spacing: Spacing.sm) {
                ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                    HStack(alignment: .top, spacing: Spacing.sm) {
                        Text("\(index + 1).")
                            .font(Typography.bodyMedium)
                            .foregroundColor(.textSecondary)
                            .frame(width: 24, alignment: .trailing)
                        DynamicTextView(item, color: .textPrimary)
                            .bodyStyle()
                    }
                }
            }

        case .quote(let text, let author):
            QuoteView(text: text, author: author)

        case .image(let url, let caption):
            ImageBlockView(url: url, caption: caption)

        case .localImage(let name, let caption):
            LocalImageBlockView(name: name, caption: caption)

        case .divider:
            Rectangle()
                .fill(Color.divider)
                .frame(height: 1)
                .padding(.vertical, Spacing.md)

        // MARK: - New Enhanced Content Types

        case .keyFact(let emoji, let title, let value, let source):
            KeyFactView(emoji: emoji, title: title, value: value, source: source)

        case .statistic(let value, let label, let context):
            StatisticView(value: value, label: label, context: context)

        case .table(let headers, let rows, let caption):
            TableBlockView(headers: headers, rows: rows, caption: caption)

        case .columnLayout(let columns):
            ColumnLayoutView(columns: columns)

        case .artworkCard(let artist, let title, let year, let salePrice, let auctionHouse, let saleDate):
            ArtworkCardView(artist: artist, title: title, year: year, salePrice: salePrice, auctionHouse: auctionHouse, saleDate: saleDate)

        case .comparisonTable(let title, let items):
            ComparisonTableView(title: title, items: items)

        case .reflection(let prompt, let context):
            ReflectionBlockView(prompt: prompt, context: context)

        case .toggleBlock(let title, let content):
            let tl = title.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            let isFootnoteToggle = ["footnote", "citation", "reference", "bibliography", "source"]
                .contains(where: { tl.contains($0) })
            if !isFootnoteToggle {
                ToggleBlockView(title: title, content: content)
            }

        case .database(let title, let entries, let groupKey):
            DatabaseCardView(title: title, entries: entries, groupKey: groupKey)

        case .spacer(let height):
            Spacer()
                .frame(height: height == .small ? Spacing.sm : height == .medium ? Spacing.md : Spacing.lg)

        case .localWebView(let filename, let title, let caption):
            LocalWebViewBlock(filename: filename, title: title, caption: caption)
        }
    }
}

// MARK: - Expandable Text Block
// Long paragraphs collapse to 5 lines with a "Read more" affordance.
// Short text renders inline with no chrome.
private let expandableTextThreshold = 400 // characters

struct ExpandableTextBlock: View {
    let content: String
    @State private var isExpanded = false

    private var isLong: Bool { content.count > expandableTextThreshold }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            DynamicTextView(content, color: .textPrimary)
                .bodyLargeStyle()
                .lineSpacing(6)
                .lineLimit(isLong && !isExpanded ? 5 : nil)

            if isLong {
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) { isExpanded.toggle() }
                } label: {
                    Text(isExpanded ? "Read less" : "Read more")
                        .font(Typography.caption)
                        .foregroundColor(.brandPrimary)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

// MARK: - Key Fact View
struct KeyFactView: View {
    let emoji: String
    let title: String
    let value: String
    let source: String?

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack(spacing: Spacing.sm) {
                Text(emoji)
                    .font(.system(size: 24))
                Text(title)
                    .font(Typography.bodyMedium)
                    .foregroundColor(.textPrimary)
            }

            Text(value)
                .font(Typography.title3)
                .foregroundColor(.brandPrimary)

            if let source = source {
                Text("Source: \(source)")
                    .font(Typography.caption2)
                    .foregroundColor(.textTertiary)
            }
        }
        .padding(Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.brandPrimary.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
    }
}

// MARK: - Statistic View
struct StatisticView: View {
    let value: String
    let label: String
    let context: String?

    var body: some View {
        VStack(spacing: Spacing.xs) {
            Text(value)
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(.brandPrimary)

            Text(label)
                .font(Typography.captionMedium)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)

            if let context = context {
                Text(context)
                    .font(Typography.caption2)
                    .foregroundColor(.textTertiary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(Spacing.md)
        .frame(maxWidth: .infinity)
        .background(Color.surfaceSecondary)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
    }
}

// MARK: - Table Block View
struct TableBlockView: View {
    let headers: [String]
    let rows: [[String]]
    let caption: String?

    // Minimum column width — wide enough to read, scrollable if needed
    private let minColWidth: CGFloat = 120
    private let firstColWidth: CGFloat = 140

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            // Table with scroll hint overlay
            ZStack(alignment: .trailing) {
                ScrollView(.horizontal, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        // Header row
                        HStack(spacing: 0) {
                            ForEach(Array(headers.enumerated()), id: \.offset) { index, header in
                                Text(header)
                                    .font(Typography.captionMedium)
                                    .foregroundColor(.textSecondary)
                                    .multilineTextAlignment(.leading)
                                    .frame(width: index == 0 ? firstColWidth : minColWidth, alignment: .leading)
                                    .padding(.horizontal, Spacing.sm)
                                    .padding(.vertical, Spacing.sm)
                            }
                        }
                        .background(Color.surfaceTertiary)

                        // Data rows
                        ForEach(Array(rows.enumerated()), id: \.offset) { rowIndex, row in
                            HStack(spacing: 0) {
                                ForEach(Array(row.enumerated()), id: \.offset) { colIndex, cell in
                                    Text(cell)
                                        .font(Typography.caption)
                                        .foregroundColor(colIndex == 0 ? .textPrimary : .textSecondary)
                                        .fontWeight(colIndex == 0 ? .medium : .regular)
                                        .multilineTextAlignment(.leading)
                                        .frame(width: colIndex == 0 ? firstColWidth : minColWidth, alignment: .leading)
                                        .padding(.horizontal, Spacing.sm)
                                        .padding(.vertical, Spacing.sm)
                                }
                            }
                            .background(rowIndex % 2 == 0 ? Color.clear : Color.surfaceTertiary.opacity(0.4))

                            Divider()
                                .padding(.leading, Spacing.sm)
                        }
                    }
                }

                // Scroll hint — only shown when table has more than 2 columns
                if headers.count > 2 {
                    HStack(spacing: 0) {
                        LinearGradient(
                            colors: [Color.clear, Color.surfaceSecondary.opacity(0.9)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .frame(width: 40)
                        Image(systemName: "chevron.right")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.textTertiary)
                            .padding(.trailing, 4)
                    }
                    .allowsHitTesting(false)
                }
            }

            if let caption = caption {
                Text(caption)
                    .font(Typography.caption2)
                    .foregroundColor(.textTertiary)
                    .italic()
                    .padding(.horizontal, Spacing.sm)
            }
        }
        .background(Color.surfaceSecondary)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.sm))
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.sm)
                .stroke(Color.divider, lineWidth: 0.5)
        )
    }
}

// MARK: - Column Layout View
struct ColumnLayoutView: View {
    let columns: [ColumnContent]

    var body: some View {
        HStack(alignment: .top, spacing: Spacing.md) {
            ForEach(Array(columns.enumerated()), id: \.offset) { _, column in
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    ForEach(column.blocks) { block in
                        ContentBlockView(block: block)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}

// MARK: - Artwork Card View
struct ArtworkCardView: View {
    let artist: String
    let title: String
    let year: String?
    let salePrice: String?
    let auctionHouse: String?
    let saleDate: String?

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            // Artist name
            Text(artist)
                .font(Typography.captionMedium)
                .foregroundColor(.textSecondary)
                .textCase(.uppercase)
                .tracking(1)

            // Artwork title
            Text("\"\(title)\"")
                .font(Typography.title3)
                .foregroundColor(.textPrimary)
                .italic()

            if let year = year {
                Text(year)
                    .font(Typography.caption)
                    .foregroundColor(.textTertiary)
            }

            if salePrice != nil || auctionHouse != nil {
                Divider()

                HStack {
                    if let price = salePrice {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Sale Price")
                                .font(Typography.caption2)
                                .foregroundColor(.textTertiary)
                            Text(price)
                                .font(Typography.bodyMedium)
                                .foregroundColor(.success)
                        }
                    }

                    Spacer()

                    if let house = auctionHouse {
                        VStack(alignment: .trailing, spacing: 2) {
                            Text(house)
                                .font(Typography.caption)
                                .foregroundColor(.textSecondary)
                            if let date = saleDate {
                                Text(date)
                                    .font(Typography.caption2)
                                    .foregroundColor(.textTertiary)
                            }
                        }
                    }
                }
            }
        }
        .padding(Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.surfaceSecondary)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.md)
                .stroke(Color.divider, lineWidth: 1)
        )
    }
}

// MARK: - Comparison Table View
struct ComparisonTableView: View {
    let title: String
    let items: [ComparisonItem]
    @State private var expandedItem: String?

    /// Detect if values are short enough for a simple horizontal layout
    private var isCompact: Bool {
        items.allSatisfy { item in
            item.values.allSatisfy { $0.count < 40 }
        }
    }

    /// Extract column headers from title (e.g., "DeFi vs. CBDC" → ["DeFi", "CBDC"])
    private var columnHeaders: [String] {
        let separators = [" vs. ", " vs ", " v. ", " v "]
        for sep in separators {
            if title.contains(sep) {
                return title.components(separatedBy: sep).map { $0.trimmingCharacters(in: .whitespaces) }
            }
        }
        return []
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text(title)
                .font(Typography.bodyMedium)
                .foregroundColor(.textPrimary)

            if isCompact {
                compactLayout
            } else {
                expandableLayout
            }
        }
        .padding(Spacing.md)
        .background(Color.surfaceSecondary)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
    }

    // Short values: horizontal row layout
    private var compactLayout: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(items, id: \.label) { item in
                    HStack(alignment: .top, spacing: 0) {
                        Text(item.label)
                            .font(Typography.captionMedium)
                            .foregroundColor(.textSecondary)
                            .frame(width: 140, alignment: .leading)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.trailing, Spacing.sm)

                        ForEach(item.values, id: \.self) { value in
                            Text(value)
                                .font(Typography.caption)
                                .foregroundColor(.textPrimary)
                                .frame(minWidth: 120, maxWidth: 200, alignment: .leading)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.trailing, Spacing.sm)
                        }
                    }
                    .padding(.vertical, Spacing.xs)

                    if item.label != items.last?.label {
                        Divider()
                    }
                }
            }
        }
    }

    // Long values: expandable card layout with column headers
    private var expandableLayout: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            // Column header pills
            if columnHeaders.count == 2 {
                HStack(spacing: Spacing.sm) {
                    Spacer()
                    ForEach(columnHeaders, id: \.self) { header in
                        Text(header)
                            .font(Typography.captionMedium)
                            .foregroundColor(.brandHighlight)
                            .padding(.horizontal, Spacing.sm)
                            .padding(.vertical, Spacing.xxs)
                            .background(
                                Capsule().fill(Color.brandHighlight.opacity(0.1))
                            )
                    }
                }
                .padding(.bottom, Spacing.xxs)
            }

            ForEach(items, id: \.label) { item in
                let isExpanded = expandedItem == item.label
                VStack(alignment: .leading, spacing: 0) {
                    Button {
                        withAnimation(.smoothSpring) {
                            expandedItem = isExpanded ? nil : item.label
                        }
                    } label: {
                        HStack {
                            Text(item.label)
                                .font(Typography.captionMedium)
                                .foregroundColor(.textPrimary)
                            Spacer()
                            Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                                .font(.caption2)
                                .foregroundColor(.textTertiary)
                        }
                        .padding(.vertical, Spacing.sm)
                    }
                    .buttonStyle(.plain)

                    if isExpanded {
                        VStack(alignment: .leading, spacing: Spacing.sm) {
                            ForEach(Array(item.values.enumerated()), id: \.offset) { index, value in
                                VStack(alignment: .leading, spacing: Spacing.xxs) {
                                    if index < columnHeaders.count {
                                        Text(columnHeaders[index])
                                            .font(Typography.captionMedium)
                                            .foregroundColor(.brandHighlight)
                                    }
                                    Text(value)
                                        .font(Typography.caption)
                                        .foregroundColor(.textSecondary)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                .padding(Spacing.sm)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.surfacePrimary)
                                .clipShape(RoundedRectangle(cornerRadius: CornerRadius.sm))
                            }
                        }
                        .padding(.bottom, Spacing.sm)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                }

                if item.label != items.last?.label {
                    Divider()
                }
            }
        }
    }
}

// MARK: - Reflection Block View
struct ReflectionBlockView: View {
    let prompt: String
    let context: String?
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Button {
                withAnimation(.smoothSpring) {
                    isExpanded.toggle()
                }
            } label: {
                HStack(spacing: Spacing.sm) {
                    Text("🌟")
                        .font(.system(size: 20))

                    Text("Reflection")
                        .font(Typography.captionMedium)
                        .foregroundColor(.brandPrimary)

                    Spacer()

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundColor(.textTertiary)
                }
            }
            .buttonStyle(.plain)

            if isExpanded {
                Text(prompt)
                    .font(Typography.body)
                    .foregroundColor(.textPrimary)
                    .italic()

                if let context = context {
                    Text(context)
                        .font(Typography.caption)
                        .foregroundColor(.textSecondary)
                }
            }
        }
        .padding(Spacing.md)
        .background(Color.brandPrimary.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.md)
                .stroke(Color.brandPrimary.opacity(0.2), lineWidth: 1)
        )
    }
}

// MARK: - Toggle Block View
struct ToggleBlockView: View {
    let title: String
    let content: String
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Button {
                withAnimation(.smoothSpring) {
                    isExpanded.toggle()
                }
            } label: {
                HStack(spacing: Spacing.sm) {
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                        .font(.caption)
                        .foregroundColor(.textTertiary)
                        .frame(width: 16)

                    Text(title)
                        .font(Typography.bodyMedium)
                        .foregroundColor(.textPrimary)

                    Spacer()
                }
            }
            .buttonStyle(.plain)

            if isExpanded {
                Text(content)
                    .font(Typography.body)
                    .foregroundColor(.textSecondary)
                    .padding(.leading, Spacing.lg)
            }
        }
    }
}

// MARK: - Database Card View (Notion Inline Database)
/// Renders a Notion inline database as a visually distinct card grid.
/// Renders a Notion inline database as a Kanban-style board.
/// Grouped databases show colored lane headers + cards per column.
/// Comparison databases (two named columns, e.g. DeFi vs Traditional) render
/// as side-by-side comparison rows.
struct DatabaseCardView: View {
    let title: String
    let entries: [DatabaseEntry]
    let groupKey: String?

    // MARK: - Helpers

    private var groupedEntries: [(key: String, entries: [DatabaseEntry])] {
        guard hasGroups else { return [] }
        let dict = Dictionary(grouping: entries, by: { $0.group })
        // Preserve natural insertion order where possible; otherwise alphabetical
        let orderedKeys = entries.compactMap { $0.group.isEmpty ? nil : $0.group }
            .reduce(into: [String]()) { acc, k in if !acc.contains(k) { acc.append(k) } }
        return orderedKeys.map { key in (key: key, entries: dict[key] ?? []) }
    }

    private var hasGroups: Bool {
        entries.contains { !$0.group.isEmpty }
    }

    /// True when entries carry named comparison columns (e.g. "DeFi"/"Traditional" or "DeFi"/"CBDC")
    private var isComparisonTable: Bool {
        guard !hasGroups else { return false }
        guard let first = entries.first else { return false }
        return first.fields.count >= 2
    }

    /// Sorted column names for the comparison table
    private var comparisonColumns: [String] {
        guard let first = entries.first else { return [] }
        return first.fields.keys.sorted()
    }

    // MARK: - Palette (matches Notion group tag colours)
    private static let groupColors: [String: Color] = [
        "dopamine":           Color(red: 0.94, green: 0.36, blue: 0.36),
        "serotonin":          Color(red: 0.98, green: 0.75, blue: 0.20),
        "seratonin":          Color(red: 0.98, green: 0.75, blue: 0.20),
        "brain plasticity":   Color(red: 0.30, green: 0.72, blue: 0.50),
        "real economy":       Color(red: 0.30, green: 0.72, blue: 0.50),
        "capital markets":    Color(red: 0.28, green: 0.56, blue: 0.87),
        "public v. private":  Color(red: 0.58, green: 0.40, blue: 0.87),
        "liquid v. illiquid": Color(red: 0.20, green: 0.65, blue: 0.78),
        "open end v. closed end": Color(red: 0.96, green: 0.52, blue: 0.25),
        "defi":               Color(red: 0.43, green: 0.55, blue: 0.95),
        "cbdc":               Color(red: 0.30, green: 0.72, blue: 0.50),
    ]

    private func groupColor(_ key: String) -> Color {
        Self.groupColors[key.lowercased()] ?? Color.brandPrimary
    }

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            // ── Database title bar ─────────────────────────────────────────
            HStack(spacing: Spacing.sm) {
                Image(systemName: "square.grid.2x2")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.brandHighlight)

                Text(title)
                    .font(Typography.bodyMedium)
                    .foregroundColor(.textPrimary)

                Spacer()

                Text("\(entries.count)")
                    .font(Typography.caption2)
                    .foregroundColor(.brandHighlight)
                    .padding(.horizontal, 7)
                    .padding(.vertical, 3)
                    .background(Color.brandHighlight.opacity(0.10))
                    .clipShape(Capsule())
            }
            .padding(.bottom, 2)

            // ── Layout branch ──────────────────────────────────────────────
            if isComparisonTable {
                comparisonLayout
            } else if hasGroups {
                kanbanLayout
            } else {
                flatLayout
            }
        }
        .padding(Spacing.md)
        .background(Color.surfaceSecondary.opacity(0.4))
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.md)
                .stroke(Color.divider, lineWidth: 1)
        )
    }

    // MARK: - Kanban Layout (grouped)

    @ViewBuilder
    private var kanbanLayout: some View {
        ZStack(alignment: .trailing) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: Spacing.md) {
                    ForEach(groupedEntries, id: \.key) { group in
                        VStack(alignment: .leading, spacing: Spacing.sm) {
                            // Coloured group pill header
                            HStack(spacing: 5) {
                                Circle()
                                    .fill(groupColor(group.key))
                                    .frame(width: 8, height: 8)
                                Text(group.key)
                                    .font(Typography.captionMedium)
                                    .foregroundColor(.textPrimary)
                                Text("\(group.entries.count)")
                                    .font(Typography.caption2)
                                    .foregroundColor(.textTertiary)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(groupColor(group.key).opacity(0.12))
                            .clipShape(Capsule())

                        // Cards
                        ForEach(group.entries) { entry in
                            DatabaseEntryCard(entry: entry)
                                .frame(width: 200)
                        }
                    }
                }
            }
            .padding(.bottom, 4)
        }

        // Scroll hint — fade + chevron on the right edge
        if groupedEntries.count > 1 {
            HStack(spacing: 0) {
                LinearGradient(
                    colors: [Color.clear, Color.surfaceSecondary.opacity(0.85)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(width: 40)
                Image(systemName: "chevron.right")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.textTertiary)
                    .padding(.trailing, 4)
            }
            .allowsHitTesting(false)
        }
        } // ZStack
    }

    // MARK: - Comparison Layout (two named columns)

    private let topicColWidth: CGFloat = 130
    private let dataColWidth: CGFloat = 180

    @ViewBuilder
    private var comparisonLayout: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            VStack(alignment: .leading, spacing: 0) {
                // Column headers
                if !comparisonColumns.isEmpty {
                    HStack(spacing: 0) {
                        Text("Topic")
                            .font(Typography.caption)
                            .foregroundColor(.textTertiary)
                            .frame(width: topicColWidth, alignment: .leading)
                            .padding(.horizontal, Spacing.sm)
                        ForEach(comparisonColumns, id: \.self) { col in
                            Text(col)
                                .font(Typography.captionMedium)
                                .foregroundColor(groupColor(col))
                                .frame(width: dataColWidth, alignment: .leading)
                                .padding(.horizontal, Spacing.sm)
                        }
                    }
                    .padding(.vertical, Spacing.xs)
                    .background(Color.surfacePrimary.opacity(0.6))
                    .clipShape(RoundedRectangle(cornerRadius: CornerRadius.sm))
                    .padding(.bottom, Spacing.sm)
                }

                ForEach(entries) { entry in
                    ComparisonEntryRow(
                        entry: entry,
                        columns: comparisonColumns,
                        topicWidth: topicColWidth,
                        dataWidth: dataColWidth
                    )
                    if entry.id != entries.last?.id {
                        Divider().padding(.vertical, 4)
                    }
                }
            }
        }
    }

    // MARK: - Flat Layout (no groups)

    @ViewBuilder
    private var flatLayout: some View {
        VStack(spacing: Spacing.sm) {
            ForEach(entries) { entry in
                DatabaseEntryCard(entry: entry)
            }
        }
    }
}

// MARK: - Kanban Entry Card

struct DatabaseEntryCard: View {
    let entry: DatabaseEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(entry.name)
                .font(Typography.captionMedium)
                .foregroundColor(.textPrimary)

            if !entry.info.isEmpty {
                Text(entry.info)
                    .font(Typography.caption2)
                    .foregroundColor(.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.surfacePrimary)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.sm))
        .shadow(color: Color.black.opacity(0.04), radius: 2, x: 0, y: 1)
    }
}

// MARK: - Comparison Entry Row

struct ComparisonEntryRow: View {
    let entry: DatabaseEntry
    let columns: [String]
    var topicWidth: CGFloat = 130
    var dataWidth: CGFloat = 180

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            // Topic / title column — fixed width, medium weight
            Text(entry.name)
                .font(Typography.captionMedium)
                .foregroundColor(.textPrimary)
                .frame(width: topicWidth, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, Spacing.sm)

            // Data columns — fixed width, wraps vertically
            ForEach(columns, id: \.self) { col in
                Text(entry.fields[col] ?? "—")
                    .font(Typography.caption2)
                    .foregroundColor(.textSecondary)
                    .frame(width: dataWidth, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, Spacing.sm)
            }
        }
        .padding(.vertical, 6)
    }
}

// MARK: - Callout View (Enhanced with 2025 Design)
struct CalloutView: View {
    let title: String
    let content: String
    let type: CalloutType
    @State private var isExpanded = true
    @State private var isHovered = false

    // Only certain callout types should be collapsible
    private var isCollapsible: Bool {
        switch type {
        case .explore, .reflection, .example:
            return true // These benefit from being collapsible
        default:
            return false // Info, tip, warning, keyPoint, etc. should always show content
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            // Header row - only a button if collapsible or interactive
            if isCollapsible {
                Button {
                    withAnimation(.smoothSpring) {
                        isExpanded.toggle()
                    }
                    HapticFeedback.light.trigger()
                } label: {
                    headerContent
                }
                .buttonStyle(.plain)
            } else {
                headerContent
            }

            // Content - always show for non-collapsible, toggle for collapsible
            if (!isCollapsible || isExpanded) && !content.isEmpty {
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    // Rich text content
                    Text(content)
                        .font(Typography.body)
                        .foregroundColor(.textSecondary)
                        .lineSpacing(4)
                        .fixedSize(horizontal: false, vertical: true)

                    // Action button for interactive types
                    if isInteractiveType {
                        HStack {
                            Spacer()
                            interactiveButton
                        }
                    }
                }
                .padding(.top, Spacing.xs)
                .transition(.asymmetric(
                    insertion: .opacity.combined(with: .move(edge: .top)),
                    removal: .opacity
                ))
            }
        }
        .padding(Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: CornerRadius.lg)
                .fill(Color.surfacePrimary)
        )
        .overlay(
            HStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(accentColor.opacity(0.4))
                    .frame(width: 3)
                Spacer()
            }
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.lg))
        )
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.lg)
                .stroke(Color.divider.opacity(0.3), lineWidth: 0.5)
        )
        .animation(.smoothSpring, value: isExpanded)
        .onHover { hovering in
            isHovered = hovering
        }
    }

    // Extracted header content for reuse
    private var headerContent: some View {
        HStack(spacing: Spacing.sm) {
            // Icon
            Image(systemName: icon)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(accentColor.opacity(0.7))
                .frame(width: 20)

            VStack(alignment: .leading, spacing: 2) {
                Text(title.isEmpty ? typeLabel : title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.textPrimary)

                // Preview text when collapsed
                if isCollapsible && !isExpanded && !content.isEmpty {
                    Text(content.prefix(50) + (content.count > 50 ? "..." : ""))
                        .font(Typography.caption)
                        .foregroundColor(.textTertiary)
                        .lineLimit(1)
                }
            }

            Spacer()

            // Show chevron only for collapsible types
            if isCollapsible {
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .font(.caption.weight(.medium))
                    .foregroundColor(.textTertiary)
            } else if isInteractiveType {
                Image(systemName: "arrow.right.circle.fill")
                    .font(.body)
                    .foregroundColor(accentColor)
            }
        }
    }

    private var isInteractiveType: Bool {
        type == .link || type == .explore
    }

    @ViewBuilder
    private var interactiveButton: some View {
        switch type {
        case .link:
            Button {
                // Handle link action - could navigate or open URL
                HapticFeedback.medium.trigger()
            } label: {
                HStack(spacing: Spacing.xs) {
                    Text("Learn More")
                        .font(Typography.captionMedium)
                    Image(systemName: "arrow.right")
                        .font(.caption)
                }
                .foregroundColor(.white)
                .padding(.horizontal, Spacing.md)
                .padding(.vertical, Spacing.sm)
                .background(accentColor)
                .clipShape(Capsule())
            }
            .buttonStyle(.plain)

        case .explore:
            Button {
                // Handle explore action - could show modal or navigate
                HapticFeedback.medium.trigger()
            } label: {
                HStack(spacing: Spacing.xs) {
                    Text("Dive Deeper")
                        .font(Typography.captionMedium)
                    Image(systemName: "arrow.down.right")
                        .font(.caption)
                }
                .foregroundColor(accentColor)
                .padding(.horizontal, Spacing.md)
                .padding(.vertical, Spacing.sm)
                .background(accentColor.opacity(0.15))
                .clipShape(Capsule())
            }
            .buttonStyle(.plain)

        default:
            EmptyView()
        }
    }

    private var icon: String {
        switch type {
        case .info: return "info.circle.fill"
        case .tip: return "lightbulb.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .example: return "pencil.and.list.clipboard"
        case .research: return "chart.bar.fill"
        case .reflection: return "sparkles"
        case .keyPoint: return "star.fill"
        case .definition: return "book.fill"
        case .link: return "link"
        case .explore: return "safari.fill"
        }
    }

    private var accentColor: Color {
        switch type {
        case .info: return .info
        case .tip: return .success
        case .warning: return .warning
        case .example: return .brandPrimary
        case .research: return .brandPrimary
        case .reflection: return .purple
        case .keyPoint: return .orange
        case .definition: return .blue
        case .link: return .cyan
        case .explore: return .indigo
        }
    }

    private var typeLabel: String {
        switch type {
        case .keyPoint: return "Key Point"
        case .link: return "Related Content"
        case .explore: return "Explore Further"
        default: return type.rawValue.capitalized
        }
    }
}

// MARK: - Quote View
struct QuoteView: View {
    let text: String
    let author: String?

    private var shareText: String {
        var s = "\"\(text)\""
        if let author { s += "\n— \(author)" }
        s += "\n\nalternativeassetsliteracy.com"
        return s
    }

    var body: some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(Color.brandAccent)
                .frame(width: 3)

            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(text)
                    .quoteStyle()
                    .foregroundColor(.textSecondary)

                if let author = author {
                    Text("— \(author)")
                        .font(Typography.caption)
                        .foregroundColor(.textTertiary)
                }

                HStack {
                    Spacer()
                    ShareLink(item: shareText) {
                        Label("Share quote", systemImage: "square.and.arrow.up")
                            .font(Typography.caption2)
                            .foregroundColor(.textTertiary)
                    }
                }
                .padding(.top, 4)
            }
            .padding(.leading, Spacing.md)
        }
        .padding(.vertical, Spacing.sm)
    }
}

// MARK: - Image Block View
struct ImageBlockView: View {
    let url: String
    let caption: String?

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            AsyncImage(url: URL(string: url)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.sm))
                case .failure:
                    EmptyView() // Hide silently — expired Notion URLs shouldn't show a gray box
                case .empty:
                    imagePlaceholder
                        .shimmer()
                @unknown default:
                    EmptyView()
                }
            }
            .frame(maxWidth: .infinity)

            if let caption = caption {
                Text(caption)
                    .font(Typography.caption)
                    .foregroundColor(.textTertiary)
                    .italic()
            }
        }
    }

    private var imagePlaceholder: some View {
        RoundedRectangle(cornerRadius: CornerRadius.sm)
            .fill(Color.surfaceSecondary)
            .frame(height: 200)
    }
}

// MARK: - Local Image Block
struct LocalImageBlockView: View {
    let name: String
    let caption: String?

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            if let uiImage = UIImage(named: name) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: CornerRadius.sm))
                    .frame(maxWidth: .infinity)
            } else {
                RoundedRectangle(cornerRadius: CornerRadius.sm)
                    .fill(Color.surfaceSecondary)
                    .frame(maxWidth: .infinity, minHeight: 200)
                    .overlay(
                        Text(caption ?? name)
                            .font(Typography.caption)
                            .foregroundColor(.textTertiary)
                    )
            }
            if let caption = caption {
                Text(caption)
                    .font(Typography.caption)
                    .foregroundColor(.textTertiary)
                    .italic()
            }
        }
        .padding(.vertical, Spacing.xs)
    }
}

// MARK: - Reflection Prompt Card
struct ReflectionPromptCard: View {
    let prompt: ReflectionPrompt
    let onTap: () -> Void
    @EnvironmentObject var progressManager: ProgressManager

    var body: some View {
        Button(action: {
            HapticFeedback.light.trigger()
            onTap()
        }) {
            HStack(spacing: Spacing.md) {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(prompt.question)
                        .font(Typography.bodyMedium)
                        .foregroundColor(.textPrimary)
                        .multilineTextAlignment(.leading)

                    if let context = prompt.context {
                        Text(context)
                            .font(Typography.caption)
                            .foregroundColor(.textTertiary)
                            .lineLimit(2)
                    }

                    if progressManager.getReflection(for: prompt.id) != nil {
                        HStack(spacing: Spacing.xxs) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.success)
                            Text("Reflection saved")
                                .foregroundColor(.success)
                        }
                        .font(Typography.caption)
                    }
                }

                Spacer()

                Image(systemName: "arrow.right.circle.fill")
                    .font(.title2)
                    .foregroundColor(.brandPrimary)
            }
            .padding(Spacing.md)
            .background(Color.surfaceSecondary)
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
        }
        .buttonStyle(.pressable)
    }
}

// MARK: - Quiz Card
struct QuizCard: View {
    let quiz: Quiz
    let moduleId: String
    let onTap: () -> Void
    @EnvironmentObject var progressManager: ProgressManager

    var body: some View {
        Button(action: {
            HapticFeedback.light.trigger()
            onTap()
        }) {
            HStack(spacing: Spacing.md) {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(quiz.title)
                        .font(Typography.bodyMedium)
                        .foregroundColor(.textPrimary)

                    if let description = quiz.description {
                        Text(description)
                            .font(Typography.caption)
                            .foregroundColor(.textTertiary)
                            .lineLimit(2)
                    }

                    HStack(spacing: Spacing.md) {
                        Label("\(quiz.questions.count) questions", systemImage: "questionmark.circle")
                            .font(Typography.caption)
                            .foregroundColor(.textTertiary)

                        // Show completion status (learning-focused, not grading)
                        if progressManager.getQuizScore(quiz.id) != nil {
                            HStack(spacing: Spacing.xxs) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.brandPrimary)
                                Text("Completed")
                            }
                            .font(Typography.caption)
                            .foregroundColor(.brandPrimary)
                        }
                    }
                }

                Spacer()

                Image(systemName: "play.circle.fill")
                    .font(.title)
                    .foregroundColor(.success)
            }
            .padding(Spacing.md)
            .background(Color.success.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.md)
                    .stroke(Color.success.opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(.pressable)
    }
}

// MARK: - Case Study Card
struct CaseStudyCard: View {
    let caseStudy: CaseStudy
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            Button {
                withAnimation(.smoothSpring) {
                    isExpanded.toggle()
                }
                HapticFeedback.selection.trigger()
            } label: {
                HStack(spacing: Spacing.md) {
                    VStack(alignment: .leading, spacing: Spacing.xs) {
                        Text(caseStudy.title)
                            .font(Typography.bodyMedium)
                            .foregroundColor(.textPrimary)
                            .multilineTextAlignment(.leading)

                        HStack(spacing: Spacing.xs) {
                            ForEach(caseStudy.learningFocus.prefix(3), id: \.self) { focus in
                                Text(focus)
                                    .font(Typography.caption2)
                                    .padding(.horizontal, Spacing.xs)
                                    .padding(.vertical, 2)
                                    .background(Color.brandPrimary.opacity(0.1))
                                    .foregroundColor(.brandPrimary)
                                    .clipShape(Capsule())
                            }
                        }
                    }

                    Spacer()

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.textSecondary)
                        .font(.system(size: 16, weight: .medium))
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                }
                .padding(Spacing.md)
            }
            .buttonStyle(.plain)

            // Expanded Content
            if isExpanded {
                VStack(alignment: .leading, spacing: Spacing.md) {
                    Rectangle()
                        .fill(Color.divider)
                        .frame(height: 1)

                    // Context
                    HStack(alignment: .top, spacing: Spacing.sm) {
                        Image(systemName: "info.circle")
                            .font(.caption)
                            .foregroundColor(.textTertiary)
                        Text(caseStudy.context)
                            .font(Typography.caption)
                            .foregroundColor(.textSecondary)
                    }
                    .padding(.horizontal, Spacing.md)

                    // Scenario
                    VStack(alignment: .leading, spacing: Spacing.xs) {
                        Text("Scenario")
                            .font(Typography.captionMedium)
                            .foregroundColor(.textSecondary)

                        Text(caseStudy.scenario)
                            .bodyStyle()
                            .foregroundColor(.textPrimary)
                    }
                    .padding(Spacing.md)
                    .background(Color.surfaceTertiary)
                    .clipShape(RoundedRectangle(cornerRadius: CornerRadius.sm))
                    .padding(.horizontal, Spacing.md)

                    // Key Questions with optional answers
                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        Text("Consider These Questions")
                            .font(Typography.captionMedium)
                            .foregroundColor(.textSecondary)

                        ForEach(Array(caseStudy.keyQuestions.enumerated()), id: \.offset) { index, question in
                            CaseStudyQuestionRow(
                                question: question,
                                answer: index < caseStudy.suggestedAnswers.count ? caseStudy.suggestedAnswers[index] : nil
                            )
                        }
                    }
                    .padding(.horizontal, Spacing.md)

                    // Source
                    Text(caseStudy.source)
                        .font(Typography.caption2)
                        .foregroundColor(.textTertiary)
                        .italic()
                        .padding(.horizontal, Spacing.md)
                        .padding(.bottom, Spacing.md)
                }
                .transition(.calmFade)
            }
        }
        .background(Color.surfaceSecondary)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
    }
}

// MARK: - Case Study Question Row (with reveal answer)
struct CaseStudyQuestionRow: View {
    let question: String
    let answer: String?
    @State private var showAnswer = false

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            HStack(alignment: .top, spacing: Spacing.sm) {
                Text("\u{2022}")
                    .foregroundColor(.brandPrimary)
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(question)
                        .bodyStyle()
                        .foregroundColor(.textPrimary)

                    if let answer = answer {
                        if showAnswer {
                            Text(answer)
                                .font(Typography.caption)
                                .foregroundColor(.textSecondary)
                                .padding(Spacing.sm)
                                .background(Color.brandPrimary.opacity(0.05))
                                .clipShape(RoundedRectangle(cornerRadius: CornerRadius.sm))
                                .transition(.opacity.combined(with: .move(edge: .top)))
                        }

                        Button {
                            withAnimation(.smoothSpring) {
                                showAnswer.toggle()
                            }
                        } label: {
                            Text(showAnswer ? "Hide Answer" : "Reveal Answer")
                                .font(Typography.caption2)
                                .foregroundColor(.brandPrimary)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
}

// MARK: - Module Extension for Hero Image
extension Module {
    /// Optional hero image URL for the module header
    /// This can be set in Notion or configured per module
    var heroImageURL: String? {
        // This would be populated from Notion or a configuration
        // For now, returns nil to use gradient fallback
        return nil
    }
}

// MARK: - Further Reading Row View
struct FurtherReadingRowView: View {
    let reading: FurtherReading

    var body: some View {
        if let url = URL(string: reading.url) {
            Link(destination: url) {
                readingRowContent
            }
            .buttonStyle(.plain)
        } else {
            readingRowContent
                .opacity(0.5)
        }
    }

    private var readingRowContent: some View {
        HStack(alignment: .top, spacing: Spacing.sm) {
            // Type icon
            ZStack {
                Circle()
                    .fill(typeColor.opacity(0.15))
                    .frame(width: 28, height: 28)

                Image(systemName: typeIcon)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(typeColor)
            }

            VStack(alignment: .leading, spacing: 2) {
                // Title
                Text(reading.title)
                    .font(Typography.caption)
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)

                // Author and category
                HStack(spacing: 4) {
                    if let author = reading.author, !author.isEmpty {
                        Text(author)
                            .italic()
                    }
                    Text("·")
                    Text(reading.category)

                    // Type badge
                    Text(reading.type.rawValue)
                        .font(Typography.caption2)
                        .foregroundColor(typeColor)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(typeColor.opacity(0.1))
                        .clipShape(Capsule())
                }
                .font(Typography.caption2)
                .foregroundColor(.textTertiary)

                // Description preview
                if let description = reading.description, !description.isEmpty {
                    Text(description)
                        .font(Typography.caption2)
                        .foregroundColor(.textSecondary)
                        .lineLimit(2)
                }
            }

            Spacer()

            // External link indicator
            Image(systemName: "arrow.up.right")
                .font(.caption2)
                .foregroundColor(.brandPrimary)
        }
        .padding(.vertical, Spacing.xs)
    }

    private var typeIcon: String {
        switch reading.type {
        case .article: return "doc.text"
        case .paper: return "doc.richtext"
        case .video: return "play.circle"
        case .book: return "book"
        case .podcast: return "headphones"
        case .tool: return "wrench.and.screwdriver"
        }
    }

    private var typeColor: Color {
        switch reading.type {
        case .article: return .info
        case .paper: return .brandPrimary
        case .video: return .error
        case .book: return .success
        case .podcast: return .purple
        case .tool: return .orange
        }
    }
}

// MARK: - Bibliography Row View (for collapsible sources)
struct BibliographyRowView: View {
    let footnote: ModuleFootnote
    @State private var showingDetail = false

    var body: some View {
        Button {
            showingDetail = true
        } label: {
            HStack(alignment: .top, spacing: Spacing.sm) {
                // Superscript number (small)
                Text(toSuperscript(footnote.number))
                    .font(.system(size: 9, weight: .medium))
                    .foregroundColor(.brandPrimary)
                    .frame(width: 18, alignment: .leading)
                    .baselineOffset(4)

                VStack(alignment: .leading, spacing: 2) {
                    // Title
                    Text(footnote.title)
                        .font(Typography.caption)
                        .foregroundColor(.textPrimary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)

                    // Author and source
                    HStack(spacing: 4) {
                        if !footnote.author.isEmpty {
                            Text(footnote.author)
                                .italic()
                        }
                        if let source = footnote.source, !source.isEmpty {
                            Text("·")
                            Text(source)
                        }
                        if let year = footnote.year, !year.isEmpty {
                            Text("(\(year))")
                        }
                    }
                    .font(Typography.caption2)
                    .foregroundColor(.textTertiary)
                }

                Spacer()

                // Link indicator
                if footnote.url != nil {
                    Image(systemName: "link")
                        .font(.caption2)
                        .foregroundColor(.brandPrimary)
                }
            }
            .padding(.vertical, Spacing.xs)
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showingDetail) {
            FootnoteDetailView(footnote: footnote)
        }
    }
}

// MARK: - Academic Source Citation View
struct SourceCitationView: View {
    let source: String
    let year: String?
    let publication: String?
    let url: String?

    var body: some View {
        HStack(alignment: .top, spacing: Spacing.sm) {
            // Citation marker
            Text("¹")
                .font(Typography.superscript)
                .foregroundColor(.textTertiary)
                .offset(y: -4)

            VStack(alignment: .leading, spacing: 2) {
                Text(source)
                    .font(Typography.citation)
                    .foregroundColor(.textSecondary)

                if let publication = publication {
                    HStack(spacing: 4) {
                        Text(publication)
                            .font(Typography.publication)
                            .foregroundColor(.textTertiary)

                        if let year = year {
                            Text("(\(year))")
                                .font(Typography.footnote)
                                .foregroundColor(.textTertiary)
                        }
                    }
                }
            }

            Spacer()

            if url != nil {
                Image(systemName: "arrow.up.right.square")
                    .font(.caption2)
                    .foregroundColor(.textTertiary)
            }
        }
        .padding(.vertical, Spacing.xs)
    }
}

// MARK: - Research Badge (Academic Credibility Indicator)
struct ResearchBadgeView: View {
    enum BadgeType {
        case peerReviewed
        case empirical
        case metaAnalysis
        case caseStudy
        case industryReport

        var label: String {
            switch self {
            case .peerReviewed: return "Peer-Reviewed"
            case .empirical: return "Empirical Research"
            case .metaAnalysis: return "Meta-Analysis"
            case .caseStudy: return "Case Study"
            case .industryReport: return "Industry Report"
            }
        }

        var icon: String {
            switch self {
            case .peerReviewed: return "checkmark.seal.fill"
            case .empirical: return "chart.bar.doc.horizontal"
            case .metaAnalysis: return "square.stack.3d.up"
            case .caseStudy: return "doc.text.magnifyingglass"
            case .industryReport: return "building.2"
            }
        }
    }

    let type: BadgeType

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: type.icon)
                .font(.system(size: 10))
            Text(type.label)
                .font(Typography.footnote)
        }
        .foregroundColor(.brandPrimary)
        .padding(.horizontal, Spacing.sm)
        .padding(.vertical, 4)
        .background(Color.brandPrimary.opacity(0.1))
        .clipShape(Capsule())
    }
}

// MARK: - Academic Section Header (Research-style)
struct AcademicSectionHeader: View {
    let number: String
    let title: String
    let subtitle: String?

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            // Section number (academic style)
            Text("Section \(number)")
                .font(Typography.overline)
                .foregroundColor(.textTertiary)
                .tracking(1.5)
                .textCase(.uppercase)

            // Title with serif font
            Text(title)
                .font(Typography.title1)
                .foregroundColor(.textPrimary)

            if let subtitle = subtitle {
                Text(subtitle)
                    .font(Typography.body)
                    .foregroundColor(.textSecondary)
                    .italic()
            }

            // Decorative rule
            Rectangle()
                .fill(Color.brandAccent)
                .frame(width: 60, height: 2)
                .padding(.top, Spacing.xs)
        }
    }
}

// MARK: - Key Finding Card (Academic Highlight)
struct KeyFindingCard: View {
    let finding: String
    let source: String
    let significance: String?

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            // Finding label
            HStack(spacing: Spacing.xs) {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(.warning)
                Text("KEY FINDING")
                    .font(Typography.overline)
                    .foregroundColor(.textTertiary)
                    .tracking(1.5)
            }

            // The finding
            Text(finding)
                .font(Typography.bodyLarge)
                .foregroundColor(.textPrimary)
                .italic()

            // Source attribution
            HStack {
                Text("—")
                Text(source)
                    .font(Typography.citation)
                    .foregroundColor(.textSecondary)
            }

            if let significance = significance {
                Text(significance)
                    .font(Typography.caption)
                    .foregroundColor(.textTertiary)
                    .padding(.top, Spacing.xs)
            }
        }
        .padding(Spacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.warning.opacity(0.08))
        .overlay(
            Rectangle()
                .fill(Color.warning)
                .frame(width: 4),
            alignment: .leading
        )
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.sm))
    }
}

// MARK: - Research Methodology Badge
struct MethodologyBadge: View {
    let methodology: String

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "flask")
                .font(.caption2)
            Text(methodology)
                .font(Typography.caption2)
        }
        .foregroundColor(.info)
        .padding(.horizontal, Spacing.sm)
        .padding(.vertical, 3)
        .background(Color.info.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}

// MARK: - Preview
#Preview {
    let sampleModule = Module(
        id: "1",
        title: "Introduction to Alternative Investing",
        description: "Learn the fundamentals of alternative assets and how they can diversify your portfolio beyond traditional stocks and bonds.",
        icon: "📊",
        color: "blue",
        sections: [
            Section(
                id: "s1",
                title: "🌍 What Are Alternative Assets?",
                content: [
                    .text("Alternative investments are financial assets that don't fall into conventional categories like stocks, bonds, or cash."),
                    .bulletList(["Private Equity", "Hedge Funds", "Real Estate", "Commodities"]),
                    .callout(title: "Key Insight", content: "Alternatives often have low correlation with traditional markets.", type: .tip)
                ],
                isCollapsible: true,
                level: 2,
                reflectionPrompts: [],
                glossaryTerms: [],
                relatedResearch: []
            )
        ],
        reflectionPrompts: [
            ReflectionPrompt(id: "r1", question: "How might alternative assets fit into your investment strategy?", context: "Consider your risk tolerance and time horizon", relatedSections: [])
        ],
        quizzes: [
            Quiz(id: "q1", title: "Alternative Assets Fundamentals", description: "Test your knowledge", questions: [], passingScore: 0.7)
        ],
        caseStudies: [],
        estimatedTime: 30,
        tags: ["Investing", "Fundamentals", "Portfolio"]
    )

    return NavigationStack {
        ModuleDetailView(initialModule: sampleModule)
            .environmentObject(ProgressManager())
            .environmentObject(ReviewManager())
            .environmentObject(UserSettings.shared)
            .environmentObject(NotionService())
            .environmentObject(SubscriptionManager())
    }
}

// MARK: - Kahlo x Basquiat Tab View (embedded in Art module)
/// Deep dive into Kahlo and Basquiat as a tab within Art as Investment
struct KahloBasquiatTabView: View {
    @EnvironmentObject var notionService: NotionService
    @State private var expandedSections: Set<String> = []

    // Get the Kahlo-Basquiat module content
    private var kahloModule: Module? {
        notionService.modules.first { $0.id == "mod_kahlo_basquiat" }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.lg) {
            // Header
            VStack(alignment: .leading, spacing: Spacing.sm) {
                HStack(spacing: Spacing.sm) {
                    Text("🎭")
                        .font(.system(size: 32))

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Deep Dive")
                            .font(Typography.caption)
                            .foregroundColor(.textTertiary)
                        Text("Kahlo x Basquiat")
                            .font(Typography.title2)
                            .foregroundColor(.textPrimary)
                    }
                }

                Text("Accidental Bedfellows - exploring two of the world's greatest artists through the lens of trauma, healing, and artistic expression.")
                    .font(Typography.body)
                    .foregroundColor(.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.top, Spacing.lg)

            // Content sections
            if let module = kahloModule {
                LazyVStack(spacing: Spacing.sm) {
                    ForEach(module.sections) { section in
                        KahloSectionView(
                            section: section,
                            isExpanded: expandedSections.contains(section.id)
                        ) {
                            withAnimation(.smoothSpring) {
                                if expandedSections.contains(section.id) {
                                    expandedSections.remove(section.id)
                                } else {
                                    expandedSections.insert(section.id)
                                }
                            }
                        }
                    }
                }
            } else {
                // Fallback if module not loaded
                VStack(spacing: Spacing.md) {
                    Image(systemName: "photo.artframe")
                        .font(.system(size: 40))
                        .foregroundColor(.textTertiary)
                    Text("Content loading...")
                        .font(Typography.body)
                        .foregroundColor(.textSecondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, Spacing.xxl)
            }

            Spacer()
                .frame(height: Spacing.xxl)
        }
        .padding(.horizontal, Spacing.lg)
        .onAppear {
            // Auto-expand first section
            if let module = kahloModule, let firstSection = module.sections.first {
                expandedSections.insert(firstSection.id)
            }
        }
    }
}

// MARK: - Kahlo Section View (for Kahlo tab)
struct KahloSectionView: View {
    let section: Section
    let isExpanded: Bool
    let onToggle: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Section header
            Button(action: onToggle) {
                HStack(alignment: .center, spacing: Spacing.sm) {
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.textTertiary)
                        .frame(width: 16)

                    Text(section.title)
                        .font(Typography.bodyMedium)
                        .foregroundColor(.textPrimary)
                        .multilineTextAlignment(.leading)

                    Spacer()
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .padding(.vertical, Spacing.sm)

            // Section content
            if isExpanded {
                VStack(alignment: .leading, spacing: Spacing.md) {
                    ForEach(deduplicatedBlocks(section.content)) { block in
                        ContentBlockView(block: block)
                    }
                }
                .padding(.leading, Spacing.lg)
                .padding(.bottom, Spacing.md)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(.horizontal, Spacing.sm)
        .background(Color.surfaceSecondary.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.sm))
    }
}

// MARK: - Investing Primer: Key Laws Tab
struct WomenKeyLawsTabView: View {

    struct Law: Identifiable {
        let id = UUID()
        let name: String
        let date: String
        let description: String
    }

    private let laws: [Law] = [
        Law(name: "The Fair Labor Standards Act (FLSA)",
            date: "June 25, 1938",
            description: "Establishes minimum wage, overtime pay eligibility, recordkeeping, and child labor standards affecting full-time and part-time workers in the private sector and in local and state governments."),
        Law(name: "19th Amendment",
            date: "August 18, 1920",
            description: "An amendment to the United States Constitution that prohibits the United States and its states from denying the right to vote to citizens on the basis of sex."),
        Law(name: "Equal Pay Act",
            date: "June 10, 1963",
            description: "Amended the Fair Labor Standards Act. Its goal was to eliminate pay disparity based on gender. Women's earnings have increased significantly since this legislation was passed, but a significant wage gap remains."),
        Law(name: "Pregnancy Discrimination Act (PDA)",
            date: "December 31, 1978",
            description: "Covers discrimination \"on the basis of pregnancy, childbirth, or related medical conditions.\" It is an amendment within the Civil Rights Act."),
        Law(name: "Title IX of the Education Amendment Act",
            date: "June 23, 1972",
            description: "Prohibits sex-based discrimination in any school or education program that receives funding from the federal government."),
        Law(name: "The Family and Medical Leave Act (FMLA)",
            date: "February 5, 1993",
            description: "A United States labor law requiring covered employers to provide employees with job-protected, unpaid leave for qualified medical and family reasons."),
        Law(name: "Tampon Tax",
            date: "June 1, 2019",
            description: "A value-added tax (or sales tax) charged on tampons and other feminine hygiene products, while other basic necessities are granted tax exemption status. A popular term used to call attention to the issue — enacted in only 14 states.")
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text("Key Legislative Laws for Women")
                        .font(Typography.title3)
                        .foregroundColor(.textPrimary)
                    Text("A timeline of legislation shaping women's economic and civic rights in the United States.")
                        .font(Typography.caption)
                        .foregroundColor(.textSecondary)
                    Text("Source: Stanford Law Professor Cunnea, A Timeline of Women's Legal History in the United States")
                        .font(Typography.caption)
                        .foregroundColor(.textTertiary)
                        .italic()
                }
                .padding(.horizontal, Spacing.lg)
                .padding(.vertical, Spacing.lg)

                Divider()

                ForEach(laws) { law in
                    LawRowView(law: law)
                    Divider()
                }
            }
        }
    }

    struct LawRowView: View {
        let law: Law

        var body: some View {
            VStack(alignment: .leading, spacing: Spacing.xs) {
                HStack(alignment: .top, spacing: Spacing.sm) {
                    Text(law.date)
                        .font(Typography.caption)
                        .foregroundColor(.textTertiary)
                        .frame(width: 100, alignment: .leading)
                    Text(law.name)
                        .font(Typography.bodyMedium)
                        .foregroundColor(.textPrimary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Text(law.description)
                    .font(Typography.body)
                    .foregroundColor(.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.leading, 108)
            }
            .padding(.horizontal, Spacing.lg)
            .padding(.vertical, Spacing.md)
        }
    }
}
