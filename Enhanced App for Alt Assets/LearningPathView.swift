//
//  LearningPathView.swift
//  Enhanced App for Alt Assets
//
//  Created by Victoria Case on 2/4/26.
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//
//  Description: Visual learning path/roadmap showing module connections,
//  prerequisites, and progress. Features a vertical journey map with
//  locked/unlocked/completed states for each node.
//

import SwiftUI

// MARK: - Learning Path View
struct LearningPathView: View {
    let path: LearningPath
    @EnvironmentObject var progressManager: ProgressManager
    @EnvironmentObject var notionService: NotionService
    @State private var selectedNode: LearningPathNode?
    @State private var showingModuleDetail = false

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Path header
                pathHeader

                // Journey map
                LearningJourneyMap(
                    path: path,
                    onSelectNode: { node in
                        if nodeState(for: node) != .locked {
                            selectedNode = node
                            showingModuleDetail = true
                        } else {
                            HapticFeedback.error.trigger()
                        }
                    }
                )
                .padding(.vertical, Spacing.xl)

                // Next step CTA
                if let nextNode = nextUnlockedNode {
                    nextModuleCard(for: nextNode)
                        .padding(.horizontal, Spacing.lg)
                        .padding(.bottom, Spacing.xxl)
                }
            }
        }
        .background(Color.surfacePrimary)
        .navigationTitle(path.title)
        .sheet(isPresented: $showingModuleDetail) {
            if let node = selectedNode, let module = moduleFor(node) {
                NavigationStack {
                    ModuleDetailView(initialModule: module)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Done") {
                                    showingModuleDetail = false
                                }
                            }
                        }
                }
            }
        }
    }

    // MARK: - Path Header (Art Space Typography Style)
    private var pathHeader: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            // Difficulty badge
            HStack(spacing: 4) {
                Image(systemName: difficultyIcon)
                    .font(.system(size: 10))
                Text(path.difficulty.displayName)
                    .font(Typography.footnote)
            }
            .foregroundColor(difficultyColor)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(difficultyColor.opacity(0.1))
            .clipShape(Capsule())

            // Title with icon
            HStack(spacing: Spacing.sm) {
                Text(path.icon)
                    .font(.system(size: 40))

                Text(path.title)
                    .font(Typography.displayMedium)
                    .foregroundColor(.textPrimary)
            }

            // Description
            Text(path.description)
                .font(Typography.body)
                .foregroundColor(.textSecondary)
                .lineSpacing(4)

            // Stats with superscript annotations
            HStack(spacing: Spacing.md) {
                HStack(spacing: 2) {
                    Text("\(path.totalModules)")
                    Text("M")
                        .font(Typography.superscript)
                        .baselineOffset(4)
                }
                Text("·")
                HStack(spacing: 2) {
                    Text("\(path.estimatedDuration)")
                    Text("min")
                }
                Text("·")
                HStack(spacing: 2) {
                    Text("\(completedCount)/\(path.totalModules)")
                    Text("complete")
                }
            }
            .font(Typography.caption)
            .foregroundColor(.textTertiary)

            // Progress bar
            if completedCount > 0 {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.divider)

                        Capsule()
                            .fill(completedCount == path.totalModules ? Color.success : Color.brandPrimary)
                            .frame(width: geometry.size.width * Double(completedCount) / Double(path.totalModules))
                    }
                }
                .frame(height: 6)
                .padding(.top, Spacing.xs)
            }
        }
        .padding(.horizontal, Spacing.lg)
        .padding(.top, Spacing.lg)
        .padding(.bottom, Spacing.md)
    }

    private var difficultyIcon: String {
        switch path.difficulty {
        case .beginner: return "leaf.fill"
        case .intermediate: return "flame.fill"
        case .advanced: return "bolt.fill"
        }
    }

    private var difficultyColor: Color {
        switch path.difficulty {
        case .beginner: return .success
        case .intermediate: return .warning
        case .advanced: return .error
        }
    }

    // MARK: - Next Module Card
    private func nextModuleCard(for node: LearningPathNode) -> some View {
        guard let module = moduleFor(node) else {
            return AnyView(EmptyView())
        }

        return AnyView(
            Button {
                selectedNode = node
                showingModuleDetail = true
            } label: {
                HStack(spacing: Spacing.md) {
                    // Module icon
                    Text(module.icon)
                        .font(.system(size: 40))

                    VStack(alignment: .leading, spacing: Spacing.xxs) {
                        Text("CONTINUE YOUR JOURNEY")
                            .overlineStyle()
                            .foregroundColor(.textTertiary)

                        Text(module.title)
                            .font(Typography.title3)
                            .foregroundColor(.textPrimary)

                        Text("\(module.estimatedTime) min • \(module.totalSections) sections")
                            .font(Typography.caption)
                            .foregroundColor(.textSecondary)
                    }

                    Spacer()

                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.brandHighlight)
                }
                .padding(Spacing.lg)
                .background(Color.surfaceSecondary)
                .clipShape(RoundedRectangle(cornerRadius: CornerRadius.lg))
                .shadow(Theme.Shadow.md)
            }
            .buttonStyle(.pressable)
        )
    }

    // MARK: - Helpers
    private var nextUnlockedNode: LearningPathNode? {
        path.nodes.first { node in
            let state = nodeState(for: node)
            return state == .unlocked || state == .inProgress
        }
    }

    private var completedCount: Int {
        path.nodes.filter { nodeState(for: $0) == .completed }.count
    }

    private func moduleFor(_ node: LearningPathNode) -> Module? {
        notionService.modules.first { $0.id == node.moduleId }
    }

    private func nodeState(for node: LearningPathNode) -> PathNodeState {
        // Check if module is completed
        if progressManager.isModuleComplete(node.moduleId) {
            return .completed
        }

        // Check prerequisites
        let prerequisitesMet = node.prerequisites.allSatisfy { prereqId in
            progressManager.isModuleComplete(prereqId)
        }

        if prerequisitesMet {
            // Check unlock criteria if any
            if let criteria = node.unlockCriteria {
                if let requiredScore = criteria.requiredQuizScore {
                    // Check quiz scores for prerequisite modules
                    let hasRequiredScore = node.prerequisites.allSatisfy { prereqId in
                        if let module = notionService.modules.first(where: { $0.id == prereqId }),
                           let quiz = module.quizzes.first,
                           let score = progressManager.getQuizScore(quiz.id) {
                            return score >= requiredScore
                        }
                        return true
                    }
                    if !hasRequiredScore {
                        return .locked
                    }
                }
            }

            // Check if user has started this module
            let hasProgress = progressManager.progress.completedSections.contains { sectionId in
                if let module = moduleFor(node) {
                    return module.sections.contains { $0.id == sectionId }
                }
                return false
            }

            return hasProgress ? .inProgress : .unlocked
        }

        return .locked
    }
}

// MARK: - Path Node State
enum PathNodeState {
    case locked
    case unlocked
    case inProgress
    case completed

    var icon: String {
        switch self {
        case .locked: return "lock.fill"
        case .unlocked: return "circle"
        case .inProgress: return "circle.lefthalf.filled"
        case .completed: return "checkmark.circle.fill"
        }
    }

    var color: Color {
        switch self {
        case .locked: return .textTertiary
        case .unlocked: return .brandPrimary
        case .inProgress: return .brandHighlight
        case .completed: return .success
        }
    }
}

// MARK: - Learning Journey Map
struct LearningJourneyMap: View {
    let path: LearningPath
    let onSelectNode: (LearningPathNode) -> Void

    @EnvironmentObject var progressManager: ProgressManager
    @EnvironmentObject var notionService: NotionService
    @EnvironmentObject var reviewManager: ReviewManager

    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(path.nodes.enumerated()), id: \.element.id) { index, node in
                VStack(spacing: 0) {
                    // Connector line from previous
                    if index > 0 {
                        PathConnectorLine(
                            fromState: nodeState(for: path.nodes[index - 1]),
                            toState: nodeState(for: node)
                        )
                    }

                    // Node - now with expandable content
                    PathNodeView(
                        node: node,
                        module: moduleFor(node),
                        state: nodeState(for: node),
                        position: index + 1,
                        isLast: index == path.nodes.count - 1,
                        onTap: { onSelectNode(node) }
                    )
                    .environmentObject(notionService)
                    .environmentObject(progressManager)
                    .environmentObject(reviewManager)
                }
            }
        }
        .padding(.horizontal, Spacing.lg)
    }

    private func moduleFor(_ node: LearningPathNode) -> Module? {
        notionService.modules.first { $0.id == node.moduleId }
    }

    private func nodeState(for node: LearningPathNode) -> PathNodeState {
        if progressManager.isModuleComplete(node.moduleId) {
            return .completed
        }

        let prerequisitesMet = node.prerequisites.allSatisfy { prereqId in
            progressManager.isModuleComplete(prereqId)
        }

        if prerequisitesMet {
            let hasProgress = progressManager.progress.completedSections.contains { sectionId in
                if let module = moduleFor(node) {
                    return module.sections.contains { $0.id == sectionId }
                }
                return false
            }
            return hasProgress ? .inProgress : .unlocked
        }

        return .locked
    }
}

// MARK: - Path Node View (Enhanced with Expandable Content)
struct PathNodeView: View {
    let node: LearningPathNode
    let module: Module?
    let state: PathNodeState
    let position: Int
    let isLast: Bool
    let onTap: () -> Void

    @EnvironmentObject var notionService: NotionService
    @EnvironmentObject var progressManager: ProgressManager
    @EnvironmentObject var reviewManager: ReviewManager
    @State private var isExpanded = false

    var body: some View {
        VStack(spacing: 0) {
            // Main node button
            Button {
                withAnimation(.smoothSpring) {
                    if state != .locked {
                        isExpanded.toggle()
                    }
                }
            } label: {
                HStack(spacing: Spacing.lg) {
                    // Position indicator
                    ZStack {
                        Circle()
                            .fill(state == .locked ? Color.surfaceTertiary : state.color)
                            .frame(width: 56, height: 56)

                        if state == .completed {
                            Image(systemName: "checkmark")
                                .font(.title3.bold())
                                .foregroundColor(.white)
                        } else if state == .locked {
                            Image(systemName: "lock.fill")
                                .font(.body)
                                .foregroundColor(.textTertiary)
                        } else {
                            Text("\(position)")
                                .font(Typography.title2)
                                .foregroundColor(.white)
                        }
                    }
                    .overlay(
                        Circle()
                            .stroke(state.color.opacity(0.3), lineWidth: 3)
                    )

                    // Module info
                    VStack(alignment: .leading, spacing: Spacing.xxs) {
                        if node.isOptional {
                            Text("OPTIONAL")
                                .overlineStyle()
                                .foregroundColor(.textTertiary)
                        }

                        HStack(spacing: Spacing.sm) {
                            if let module = module {
                                Text(module.icon)
                                    .font(.title3)
                            }

                            Text(module?.title ?? "Module")
                                .font(Typography.bodyMedium)
                                .foregroundColor(state == .locked ? .textTertiary : .textPrimary)
                                .multilineTextAlignment(.leading)
                        }

                        if let module = module {
                            // Stats row with emoji indicators
                            HStack(spacing: Spacing.sm) {
                                Text("📖 \(module.totalSections)")
                                if !module.quizzes.isEmpty {
                                    Text("📝 \(module.quizzes.count)")
                                }
                                let readings = notionService.readings(for: module.id)
                                if !readings.isEmpty {
                                    Text("📚 \(readings.count)")
                                }
                                Text("⏱ \(module.estimatedTime)m")
                            }
                            .font(Typography.caption)
                            .foregroundColor(.textTertiary)
                        }

                        // State indicator
                        if state == .inProgress {
                            HStack(spacing: Spacing.xxs) {
                                Image(systemName: "circle.lefthalf.filled")
                                Text("In Progress")
                            }
                            .font(Typography.caption)
                            .foregroundColor(.brandHighlight)
                        }
                    }

                    Spacer()

                    // Expand/collapse indicator
                    if state != .locked {
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .foregroundColor(.textTertiary)
                            .font(.caption)
                    }
                }
                .padding(Spacing.md)
                .background(
                    state == .inProgress
                        ? Color.brandHighlight.opacity(0.08)
                        : (state == .locked ? Color.surfaceSecondary.opacity(0.5) : Color.surfaceSecondary)
                )
                .clipShape(RoundedRectangle(cornerRadius: isExpanded ? CornerRadius.md : CornerRadius.md, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadius.md)
                        .stroke(
                            state == .inProgress ? Color.brandHighlight.opacity(0.3) : Color.clear,
                            lineWidth: 2
                        )
                )
            }
            .buttonStyle(.plain)
            .disabled(state == .locked)
            .opacity(state == .locked ? 0.7 : 1.0)

            // Expanded content
            if isExpanded && state != .locked, let module = module {
                PathNodeExpandedContent(
                    module: module,
                    state: state,
                    onStartModule: onTap
                )
                .environmentObject(notionService)
                .environmentObject(progressManager)
                .environmentObject(reviewManager)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
}

// MARK: - Expanded Node Content (Quizzes, Readings, etc.)
struct PathNodeExpandedContent: View {
    let module: Module
    let state: PathNodeState
    let onStartModule: () -> Void

    @EnvironmentObject var notionService: NotionService
    @EnvironmentObject var progressManager: ProgressManager
    @EnvironmentObject var reviewManager: ReviewManager
    @State private var showingQuiz = false
    @State private var selectedQuiz: Quiz?

    private var furtherReadings: [FurtherReading] {
        notionService.readings(for: module.id)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            // Quick description
            if !module.description.isEmpty {
                Text(module.description)
                    .font(Typography.caption)
                    .foregroundColor(.textSecondary)
                    .lineLimit(2)
            }

            // Action buttons row
            HStack(spacing: Spacing.sm) {
                // Start/Continue Module button
                Button(action: onStartModule) {
                    HStack(spacing: Spacing.xs) {
                        Image(systemName: state == .completed ? "arrow.clockwise" : (state == .inProgress ? "play.fill" : "play.fill"))
                        Text(state == .completed ? "Review" : (state == .inProgress ? "Continue" : "Start"))
                    }
                    .font(Typography.captionMedium)
                    .foregroundColor(.white)
                    .padding(.horizontal, Spacing.md)
                    .padding(.vertical, Spacing.sm)
                    .background(Color.brandPrimary)
                    .clipShape(Capsule())
                }
                .buttonStyle(.pressable)

                Spacer()

                // Module completion status
                if state == .completed {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.success)
                        Text("Completed")
                            .foregroundColor(.success)
                    }
                    .font(Typography.caption)
                }
            }

            // Quizzes section
            if !module.quizzes.isEmpty {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    HStack {
                        Text("📝 Quizzes")
                            .font(Typography.captionMedium)
                            .foregroundColor(.textPrimary)
                        Spacer()
                    }

                    ForEach(module.quizzes) { quiz in
                        PathQuizRow(quiz: quiz, moduleId: module.id) {
                            selectedQuiz = quiz
                            showingQuiz = true
                        }
                    }
                }
                .padding(.top, Spacing.xs)
            }

            // Further Reading section
            if !furtherReadings.isEmpty {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    HStack {
                        Text("📚 Further Reading")
                            .font(Typography.captionMedium)
                            .foregroundColor(.textPrimary)
                        Spacer()
                        Text("\(furtherReadings.count) resources")
                            .font(Typography.caption2)
                            .foregroundColor(.textTertiary)
                    }

                    ForEach(furtherReadings.prefix(3)) { reading in
                        PathReadingRow(reading: reading)
                    }

                    if furtherReadings.count > 3 {
                        Text("+ \(furtherReadings.count - 3) more")
                            .font(Typography.caption)
                            .foregroundColor(.brandPrimary)
                    }
                }
                .padding(.top, Spacing.xs)
            }

            // Case Studies
            if !module.caseStudies.isEmpty {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    HStack {
                        Text("🔍 Case Studies")
                            .font(Typography.captionMedium)
                            .foregroundColor(.textPrimary)
                        Spacer()
                    }

                    ForEach(module.caseStudies.prefix(2)) { caseStudy in
                        PathCaseStudyRow(caseStudy: caseStudy)
                    }
                }
                .padding(.top, Spacing.xs)
            }

            // Reflections count
            if !module.reflectionPrompts.isEmpty {
                HStack(spacing: Spacing.xs) {
                    Text("💭")
                    Text("\(module.reflectionPrompts.count) reflection prompts")
                        .font(Typography.caption)
                        .foregroundColor(.textTertiary)
                }
            }
        }
        .padding(Spacing.md)
        .padding(.leading, 72) // Align with node content (56 + 16 spacing)
        .background(Color.surfaceSecondary.opacity(0.5))
        .sheet(isPresented: $showingQuiz) {
            if let quiz = selectedQuiz {
                QuizView(quiz: quiz, moduleId: module.id)
                    .environmentObject(progressManager)
                    .environmentObject(reviewManager)
            }
        }
    }
}

// MARK: - Path Quiz Row (Learning-Focused, Not Grading)
struct PathQuizRow: View {
    let quiz: Quiz
    let moduleId: String
    let onTap: () -> Void

    @EnvironmentObject var progressManager: ProgressManager

    private var hasCompleted: Bool {
        progressManager.getQuizScore(quiz.id) != nil
    }

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: Spacing.sm) {
                // Quiz icon - simple completed/not completed
                ZStack {
                    Circle()
                        .fill(hasCompleted ? Color.brandPrimary.opacity(0.15) : Color.surfaceTertiary)
                        .frame(width: 28, height: 28)

                    if hasCompleted {
                        Image(systemName: "checkmark")
                            .font(.caption2.bold())
                            .foregroundColor(.brandPrimary)
                    } else {
                        Image(systemName: "doc.questionmark")
                            .font(.caption2)
                            .foregroundColor(.textTertiary)
                    }
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(quiz.title)
                        .font(Typography.caption)
                        .foregroundColor(.textPrimary)
                        .lineLimit(1)

                    Text("\(quiz.questions.count) questions")
                        .font(Typography.caption2)
                        .foregroundColor(.textTertiary)
                }

                Spacer()

                // Simple action indicator
                if hasCompleted {
                    Text("Review")
                        .font(Typography.caption2)
                        .foregroundColor(.brandPrimary)
                } else {
                    Text("Start")
                        .font(Typography.caption2)
                        .foregroundColor(.textTertiary)
                }

                Image(systemName: "chevron.right")
                    .font(.caption2)
                    .foregroundColor(.textTertiary)
            }
            .padding(Spacing.sm)
            .background(Color.surfacePrimary)
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.sm))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Path Reading Row
struct PathReadingRow: View {
    let reading: FurtherReading

    var body: some View {
        if let url = URL(string: reading.url) {
            Link(destination: url) {
                pathReadingContent
            }
        } else {
            pathReadingContent
                .opacity(0.5)
        }
    }

    private var pathReadingContent: some View {
        HStack(spacing: Spacing.sm) {
            // Type icon
            Image(systemName: readingIcon)
                .font(.caption)
                .foregroundColor(.brandPrimary)
                .frame(width: 20)

            VStack(alignment: .leading, spacing: 2) {
                Text(reading.title)
                    .font(Typography.caption)
                    .foregroundColor(.textPrimary)
                    .lineLimit(1)

                if let author = reading.author {
                    Text(author)
                        .font(Typography.caption2)
                        .foregroundColor(.textTertiary)
                }
            }

            Spacer()

            Image(systemName: "arrow.up.right")
                .font(.caption2)
                .foregroundColor(.textTertiary)
        }
        .padding(Spacing.sm)
        .background(Color.surfacePrimary)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.sm))
    }

    private var readingIcon: String {
        switch reading.type {
        case .article: return "doc.text"
        case .paper: return "doc.richtext"
        case .video: return "play.rectangle"
        case .book: return "book"
        case .podcast: return "waveform"
        case .tool: return "wrench.and.screwdriver"
        }
    }
}

// MARK: - Path Case Study Row
struct PathCaseStudyRow: View {
    let caseStudy: CaseStudy

    var body: some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: "magnifyingglass")
                .font(.caption)
                .foregroundColor(.brandHighlight)
                .frame(width: 20)

            VStack(alignment: .leading, spacing: 2) {
                Text(caseStudy.title)
                    .font(Typography.caption)
                    .foregroundColor(.textPrimary)
                    .lineLimit(1)

                Text(caseStudy.learningFocus.prefix(2).joined(separator: ", "))
                    .font(Typography.caption2)
                    .foregroundColor(.textTertiary)
            }

            Spacer()
        }
        .padding(Spacing.sm)
        .background(Color.surfacePrimary)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.sm))
    }
}

// MARK: - Path Connector Line
struct PathConnectorLine: View {
    let fromState: PathNodeState
    let toState: PathNodeState

    var body: some View {
        HStack {
            Spacer()
                .frame(width: 28) // Half of node circle width

            Rectangle()
                .fill(lineColor)
                .frame(width: 3, height: 32)

            Spacer()
        }
    }

    private var lineColor: Color {
        if fromState == .completed && toState != .locked {
            return .success
        } else if fromState == .completed || fromState == .inProgress {
            return .success.opacity(0.5)
        }
        return .surfaceTertiary
    }
}

// MARK: - Learning Paths List View (Art Space Style with Courses)
struct LearningPathsListView: View {
    @EnvironmentObject var notionService: NotionService
    @EnvironmentObject var progressManager: ProgressManager
    @State private var learningPaths: [LearningPath] = []
    @State private var selectedSegment: PathSegment = .guide

    enum PathSegment: String, CaseIterable {
        case guide = "Start Here"
        case paths = "Paths"
        case courses = "Courses"
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Art Space header
                pathsHeader

                // Segment selector
                segmentPicker
                    .padding(.horizontal, Spacing.lg)
                    .padding(.bottom, Spacing.md)

                // Content based on segment
                switch selectedSegment {
                case .guide:
                    recommendedSequenceContent
                case .paths:
                    pathsContent
                case .courses:
                    coursesContent
                }
            }
        }
        .background(Color.surfacePrimary)
        .navigationTitle("")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .onAppear {
            learningPaths = generatePathsFromModules()
        }
    }

    // Generate paths dynamically from actual modules
    private func generatePathsFromModules() -> [LearningPath] {
        var paths: [LearningPath] = []

        // Create paths based on module categories
        let mainModules = notionService.modules.filter { !$0.isSubModule }

        // Alternative Investing Foundations
        let foundationsModules = mainModules.filter {
            $0.id.contains("mod_alt") || $0.title.lowercased().contains("alternative")
        }
        if !foundationsModules.isEmpty {
            paths.append(createPath(
                id: "path-foundations",
                title: "Alternative Investing Foundations",
                description: "Build a solid foundation in alternative assets, from basic concepts to advanced strategies.",
                icon: "🎯",
                modules: foundationsModules,
                difficulty: .beginner
            ))
        }

        // Behavioral & Psychology
        let behavioralModules = mainModules.filter {
            $0.id.contains("behavioral") || $0.id.contains("gender") || $0.title.lowercased().contains("behavioral")
        }
        if !behavioralModules.isEmpty {
            paths.append(createPath(
                id: "path-behavioral",
                title: "Behavioral Investing Psychology",
                description: "Understand the psychological factors that influence investment decisions.",
                icon: "🧠",
                modules: behavioralModules,
                difficulty: .intermediate
            ))
        }

        // Art & Collectibles
        let artModules = notionService.modules.filter {
            $0.id.contains("art") || $0.id.contains("kahlo") || $0.title.lowercased().contains("art")
        }
        if !artModules.isEmpty {
            paths.append(createPath(
                id: "path-art",
                title: "Art as Alternative Asset",
                description: "Explore the world of art investing, from valuation to market dynamics.",
                icon: "🎨",
                modules: artModules,
                difficulty: .intermediate
            ))
        }

        // DeFi & Digital — ensure DeFi 101 comes before DeFi Investing
        let defiModules = mainModules.filter {
            $0.id.contains("defi") || $0.title.lowercased().contains("decentralized")
        }.sorted { a, _ in a.id == "mod_defi" }
        if !defiModules.isEmpty {
            paths.append(createPath(
                id: "path-defi",
                title: "Decentralized Finance",
                description: "From blockchain fundamentals to institutional DeFi investing.",
                icon: "🔗",
                modules: defiModules,
                difficulty: .advanced
            ))
        }

        // Women & Collective
        let womenModules = mainModules.filter {
            $0.id.contains("women") || $0.title.lowercased().contains("women") || $0.title.lowercased().contains("collective")
        }
        if !womenModules.isEmpty {
            paths.append(createPath(
                id: "path-women",
                title: "Women & Collective Investing",
                description: "Explore unique perspectives and collective investment strategies.",
                icon: "💪",
                modules: womenModules,
                difficulty: .beginner
            ))
        }

        // If no specific paths, use sample
        if paths.isEmpty {
            paths = SampleLearningPaths.all
        }

        return paths
    }

    private func createPath(id: String, title: String, description: String, icon: String, modules: [Module], difficulty: LearningPath.Difficulty) -> LearningPath {
        let nodes = modules.enumerated().map { index, module in
            LearningPathNode(
                id: "\(id)-node-\(index)",
                moduleId: module.id,
                position: index + 1,
                prerequisites: index > 0 ? [modules[index - 1].id] : [],
                isOptional: module.isBonus,
                unlockCriteria: nil
            )
        }

        return LearningPath(
            id: id,
            title: title,
            description: description,
            icon: icon,
            nodes: nodes,
            estimatedDuration: modules.reduce(0) { $0 + $1.estimatedTime },
            difficulty: difficulty,
            tags: [],
            heroImageURL: nil
        )
    }

    // MARK: - Art Space Header
    private var pathsHeader: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("Learning Paths")
                .font(Typography.displayMedium)
                .foregroundColor(.textPrimary)

            Text("Curated journeys through alternative asset education")
                .font(Typography.body)
                .foregroundColor(.textSecondary)

            // Quick stats
            HStack(spacing: Spacing.md) {
                HStack(spacing: 4) {
                    Text("\(learningPaths.count)")
                    Text("paths")
                }

                Text("·")

                HStack(spacing: 4) {
                    Text("\(notionService.modules.count)")
                    Text("modules")
                }

                Text("·")

                HStack(spacing: 4) {
                    Text("\(notionService.modules.reduce(0) { $0 + $1.estimatedTime })")
                    Text("min total")
                }
            }
            .font(Typography.caption)
            .foregroundColor(.textTertiary)
        }
        .padding(.horizontal, Spacing.lg)
        .padding(.top, Spacing.lg)
        .padding(.bottom, Spacing.md)
    }

    // MARK: - Segment Picker
    private var segmentPicker: some View {
        HStack(spacing: Spacing.sm) {
            ForEach(PathSegment.allCases, id: \.self) { segment in
                Button {
                    withAnimation(.smoothSpring) {
                        selectedSegment = segment
                    }
                } label: {
                    Text(segment.rawValue)
                        .font(selectedSegment == segment ? Typography.bodyMedium : Typography.body)
                        .foregroundColor(selectedSegment == segment ? .white : .textSecondary)
                        .padding(.horizontal, Spacing.lg)
                        .padding(.vertical, Spacing.sm)
                        .background(selectedSegment == segment ? Color.brandPrimary : Color.surfaceSecondary)
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }

            Spacer()
        }
    }

    // MARK: - Recommended Sequence Content (Beginner to Experienced)
    private var recommendedSequenceContent: some View {
        VStack(alignment: .leading, spacing: Spacing.lg) {
            // Introduction card
            VStack(alignment: .leading, spacing: Spacing.sm) {
                HStack(spacing: Spacing.sm) {
                    Text("🎯")
                        .font(.system(size: 28))
                    Text("Your Learning Journey")
                        .font(Typography.title3)
                        .foregroundColor(.textPrimary)
                }

                Text("Follow this recommended sequence from foundational concepts to advanced topics. Each module builds on the previous one.")
                    .font(Typography.body)
                    .foregroundColor(.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(Spacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.brandPrimary.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
            .padding(.horizontal, Spacing.lg)

            // Learning sequence
            ForEach(Array(RecommendedLearningSequence.modules.enumerated()), id: \.element.id) { index, item in
                let module = notionService.modules.first { $0.id == item.moduleId }

                if let module = module {
                    NavigationLink {
                        ModuleDetailView(initialModule: module)
                    } label: {
                        SequenceModuleCard(
                            item: item,
                            module: module,
                            stepNumber: index + 1,
                            isCompleted: progressManager.isModuleComplete(module.id)
                        )
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, Spacing.lg)

                    // Connector line between modules (except last)
                    if index < RecommendedLearningSequence.modules.count - 1 {
                        HStack {
                            Spacer()
                                .frame(width: 36)

                            VStack(spacing: 0) {
                                Rectangle()
                                    .fill(Color.divider)
                                    .frame(width: 2, height: 24)

                                Image(systemName: "chevron.down")
                                    .font(.system(size: 10, weight: .medium))
                                    .foregroundColor(.textTertiary)
                            }

                            Spacer()
                        }
                        .padding(.leading, Spacing.lg)
                    }
                }
            }

            // Completion message
            VStack(alignment: .center, spacing: Spacing.sm) {
                Text("🎓")
                    .font(.system(size: 40))

                Text("Complete All Modules")
                    .font(Typography.bodyMedium)
                    .foregroundColor(.textPrimary)

                Text("Master alternative investing from fundamentals to institutional DeFi")
                    .font(Typography.caption)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(Spacing.lg)
            .padding(.bottom, Spacing.xxl)
        }
        .padding(.top, Spacing.md)
    }

    // MARK: - Paths Content
    private var pathsContent: some View {
        Group {
            if learningPaths.isEmpty {
                emptyState
                    .padding(.top, Spacing.xxl)
            } else {
                LazyVStack(spacing: 0) {
                    ForEach(Array(learningPaths.enumerated()), id: \.element.id) { index, path in
                        NavigationLink {
                            LearningPathView(path: path)
                        } label: {
                            ArtSpacePathRow(path: path, index: index)
                        }
                        .buttonStyle(.plain)

                        if index < learningPaths.count - 1 {
                            Rectangle()
                                .fill(Color.divider)
                                .frame(height: 1)
                                .padding(.leading, Spacing.lg)
                        }
                    }
                }
                .padding(.top, Spacing.sm)
            }
        }
    }

    // MARK: - Courses Content (All Modules as Cards)
    private var coursesContent: some View {
        LazyVStack(spacing: Spacing.sm) {
            ForEach(notionService.modules.filter { !$0.isSubModule }) { module in
                NavigationLink {
                    ModuleDetailView(initialModule: module)
                } label: {
                    CourseCardView(module: module)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, Spacing.lg)
        .padding(.top, Spacing.sm)
    }

    private var emptyState: some View {
        VStack(spacing: Spacing.md) {
            Image(systemName: "map")
                .font(.system(size: 48))
                .foregroundColor(.textTertiary)

            Text("No Paths Available")
                .font(Typography.title3)
                .foregroundColor(.textPrimary)

            Text("Learning paths will appear here as they become available.")
                .font(Typography.body)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(Spacing.xxl)
    }
}

// MARK: - Course Card View (for Courses tab)
struct CourseCardView: View {
    let module: Module
    @EnvironmentObject var progressManager: ProgressManager

    private var progress: Double {
        let completed = module.sections.filter { progressManager.isSectionComplete($0.id) }.count
        guard module.totalSections > 0 else { return 0 }
        return Double(completed) / Double(module.totalSections)
    }

    private var isComplete: Bool {
        progressManager.isModuleComplete(module.id)
    }

    var body: some View {
        HStack(spacing: Spacing.md) {
            // Module icon
            Text(module.icon)
                .font(.system(size: 32))
                .frame(width: 56, height: 56)
                .background(Color.surfaceTertiary)
                .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))

            VStack(alignment: .leading, spacing: 4) {
                Text(module.title)
                    .font(Typography.bodyMedium)
                    .foregroundColor(.textPrimary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                HStack(spacing: Spacing.xs) {
                    Text("\(module.totalSections) sections")
                    Text("·")
                    Text("\(module.estimatedTime) min")
                    if !module.quizzes.isEmpty {
                        Text("·")
                        Text("\(module.quizzes.count) quizzes")
                    }
                }
                .font(Typography.caption)
                .foregroundColor(.textTertiary)

                // Progress bar
                if progress > 0 {
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(Color.divider)

                            Capsule()
                                .fill(isComplete ? Color.success : Color.brandPrimary)
                                .frame(width: geometry.size.width * progress)
                        }
                    }
                    .frame(height: 4)
                }
            }

            Spacer()

            // Status
            if isComplete {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.success)
                    .font(.title3)
            } else if progress > 0 {
                Text("\(Int(progress * 100))%")
                    .font(Typography.caption)
                    .foregroundColor(.brandPrimary)
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

// MARK: - Art Space Path Row
struct ArtSpacePathRow: View {
    let path: LearningPath
    let index: Int
    @EnvironmentObject var progressManager: ProgressManager

    private var completedModules: Int {
        path.nodes.filter { progressManager.isModuleComplete($0.moduleId) }.count
    }

    private var progress: Double {
        guard path.totalModules > 0 else { return 0 }
        return Double(completedModules) / Double(path.totalModules)
    }

    // Difficulty superscript
    private var difficultySuperscript: String {
        switch path.difficulty {
        case .beginner: return "B"
        case .intermediate: return "I"
        case .advanced: return "A"
        }
    }

    var body: some View {
        HStack(alignment: .center, spacing: Spacing.md) {
            // Path icon
            Text(path.icon)
                .font(.system(size: 32))
                .frame(width: 56, height: 56)
                .background(Color.surfaceSecondary)
                .clipShape(Circle())

            // Content
            VStack(alignment: .leading, spacing: 4) {
                // Title with alternating style + difficulty superscript
                HStack(alignment: .firstTextBaseline, spacing: 0) {
                    Text(path.title)
                        .font(index % 2 == 0 ? Typography.title3 : Typography.title3.italic())
                        .foregroundColor(.textPrimary)
                        .lineLimit(2)

                    Text(" (\(difficultySuperscript))")
                        .font(Typography.superscript)
                        .foregroundColor(difficultyColor)
                        .baselineOffset(6)
                }

                // Metadata
                HStack(spacing: Spacing.xs) {
                    Text("\(path.totalModules) modules")
                    Text("·")
                    Text("\(path.estimatedDuration) min")
                    if progress > 0 {
                        Text("·")
                        Text("\(Int(progress * 100))%")
                            .foregroundColor(.brandPrimary)
                    }
                }
                .font(Typography.caption)
                .foregroundColor(.textTertiary)
            }

            Spacer()

            // Status
            if progress >= 1 {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.success)
                    .font(.title3)
            } else {
                Image(systemName: "chevron.right")
                    .foregroundColor(.textTertiary)
                    .font(.caption)
            }
        }
        .padding(.horizontal, Spacing.lg)
        .padding(.vertical, Spacing.md)
        .contentShape(Rectangle())
    }

    private var difficultyColor: Color {
        switch path.difficulty {
        case .beginner: return .success
        case .intermediate: return .warning
        case .advanced: return .error
        }
    }
}

// MARK: - Learning Path Card (Updated Art Space Style)
struct LearningPathCard: View {
    let path: LearningPath
    @EnvironmentObject var progressManager: ProgressManager

    private var completedModules: Int {
        path.nodes.filter { progressManager.isModuleComplete($0.moduleId) }.count
    }

    private var progress: Double {
        guard path.totalModules > 0 else { return 0 }
        return Double(completedModules) / Double(path.totalModules)
    }

    private var difficultyColor: Color {
        switch path.difficulty {
        case .beginner: return .success
        case .intermediate: return .warning
        case .advanced: return .error
        }
    }

    var body: some View {
        HStack(alignment: .center, spacing: Spacing.md) {
            // Path icon in circle
            Text(path.icon)
                .font(.system(size: 28))
                .frame(width: 56, height: 56)
                .background(difficultyColor.opacity(0.1))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                // Title
                Text(path.title)
                    .font(Typography.bodyMedium)
                    .foregroundColor(.textPrimary)
                    .lineLimit(2)

                // Metadata
                HStack(spacing: Spacing.xs) {
                    Text(path.difficulty.displayName)
                        .foregroundColor(difficultyColor)
                    Text("·")
                    Text("\(path.totalModules) modules")
                    Text("·")
                    Text("\(path.estimatedDuration) min")
                }
                .font(Typography.caption)
                .foregroundColor(.textTertiary)

                // Progress if any
                if progress > 0 {
                    HStack(spacing: Spacing.sm) {
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .fill(Color.divider)

                                Capsule()
                                    .fill(progress >= 1 ? Color.success : Color.brandPrimary)
                                    .frame(width: geometry.size.width * progress)
                            }
                        }
                        .frame(height: 4)

                        Text("\(Int(progress * 100))%")
                            .font(Typography.caption2)
                            .foregroundColor(.textTertiary)
                            .frame(width: 30, alignment: .trailing)
                    }
                }
            }

            Spacer()

            // Status
            if progress >= 1 {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.success)
                    .font(.title3)
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

// MARK: - Path Difficulty Badge
struct PathDifficultyBadge: View {
    let difficulty: LearningPath.Difficulty

    var body: some View {
        Text(difficulty.displayName)
            .font(Typography.caption2)
            .foregroundColor(color)
            .padding(.horizontal, Spacing.xs)
            .padding(.vertical, 2)
            .background(color.opacity(0.15))
            .clipShape(Capsule())
    }

    private var color: Color {
        switch difficulty {
        case .beginner: return .success
        case .intermediate: return .warning
        case .advanced: return .error
        }
    }
}

// MARK: - Sample Learning Paths
struct SampleLearningPaths {
    static let all: [LearningPath] = [
        LearningPath(
            id: "path-1",
            title: "Alternative Investing Foundations",
            description: "Build a solid foundation in alternative assets, from basic concepts to advanced strategies.",
            icon: "🎯",
            nodes: [
                LearningPathNode(
                    id: "node-1",
                    moduleId: "mod-intro",
                    position: 1,
                    prerequisites: [],
                    isOptional: false,
                    unlockCriteria: nil
                ),
                LearningPathNode(
                    id: "node-2",
                    moduleId: "mod-behavioral",
                    position: 2,
                    prerequisites: ["mod-intro"],
                    isOptional: false,
                    unlockCriteria: nil
                )
            ],
            estimatedDuration: 120,
            difficulty: .beginner,
            tags: ["Foundations", "Investing"],
            heroImageURL: nil
        )
    ]
}

// MARK: - Recommended Learning Sequence Data
/// Defines the beginner-to-experienced learning progression
struct RecommendedLearningSequence {

    struct SequenceItem: Identifiable {
        let id = UUID()
        let moduleId: String
        let level: Level
        let whyFirst: String
        let buildsToPrevious: String?

        enum Level: String {
            case beginner = "Beginner"
            case intermediate = "Intermediate"
            case advanced = "Advanced"
            case expert = "Expert"

            var color: Color {
                switch self {
                case .beginner: return .success
                case .intermediate: return .warning
                case .advanced: return .info
                case .expert: return .error
                }
            }

            var icon: String {
                switch self {
                case .beginner: return "1.circle.fill"
                case .intermediate: return "2.circle.fill"
                case .advanced: return "3.circle.fill"
                case .expert: return "4.circle.fill"
                }
            }
        }
    }

    /// Recommended learning sequence from beginner to experienced
    static let modules: [SequenceItem] = [
        // BEGINNER - Start Here
        SequenceItem(
            moduleId: "mod_women",
            level: .beginner,
            whyFirst: "Your investing primer — personal agency and psychology around money",
            buildsToPrevious: nil
        ),
        SequenceItem(
            moduleId: "mod_alt",
            level: .beginner,
            whyFirst: "Foundation for all alternative investing concepts",
            buildsToPrevious: "Builds on your personal investing framework"
        ),

        // INTERMEDIATE - Core Concepts
        SequenceItem(
            moduleId: "mod_behavioral",
            level: .intermediate,
            whyFirst: "Understanding biases that affect investment decisions",
            buildsToPrevious: "Deepens personal finance psychology from previous module"
        ),
        SequenceItem(
            moduleId: "mod_gender",
            level: .intermediate,
            whyFirst: "Research-based insights on decision-making patterns",
            buildsToPrevious: "Applies behavioral concepts to gender-specific research"
        ),
        // DeFi - Blockchain Fundamentals
        SequenceItem(
            moduleId: "mod_defi",
            level: .intermediate,
            whyFirst: "Blockchain fundamentals, crypto, and decentralized finance concepts",
            buildsToPrevious: "Introduces digital asset technology and DeFi mechanics"
        ),
        SequenceItem(
            moduleId: "mod_esg_climate",
            level: .intermediate,
            whyFirst: "Environmental, Social & Governance investing fundamentals",
            buildsToPrevious: "Introduces values-based investing criteria"
        ),

        // ADVANCED - Asset Classes
        SequenceItem(
            moduleId: "mod_art",
            level: .advanced,
            whyFirst: "Art as an alternative asset class (includes Kahlo x Basquiat deep dive)",
            buildsToPrevious: "Applies alternative investing principles to tangible assets"
        ),

        // EXPERT - DeFi Investing
        SequenceItem(
            moduleId: "mod_defi_investing",
            level: .expert,
            whyFirst: "Institutional DeFi investing: frameworks, due diligence, and risk management",
            buildsToPrevious: "Applies DeFi knowledge to practical investment analysis"
        )
    ]
}

// MARK: - Sequence Module Card
struct SequenceModuleCard: View {
    let item: RecommendedLearningSequence.SequenceItem
    let module: Module
    let stepNumber: Int
    let isCompleted: Bool

    var body: some View {
        HStack(alignment: .top, spacing: Spacing.md) {
            // Step number circle
            ZStack {
                Circle()
                    .fill(isCompleted ? Color.success : item.level.color.opacity(0.15))
                    .frame(width: 44, height: 44)

                if isCompleted {
                    Image(systemName: "checkmark")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                } else {
                    Text("\(stepNumber)")
                        .font(Typography.title3)
                        .foregroundColor(item.level.color)
                }
            }

            VStack(alignment: .leading, spacing: Spacing.xs) {
                // Level badge
                HStack(spacing: Spacing.xs) {
                    Text(item.level.rawValue)
                        .font(Typography.caption2)
                        .foregroundColor(item.level.color)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(item.level.color.opacity(0.15))
                        .clipShape(Capsule())

                    if isCompleted {
                        Text("Completed")
                            .font(Typography.caption2)
                            .foregroundColor(.success)
                    }
                }

                // Module title
                HStack(spacing: Spacing.sm) {
                    Text(module.icon)
                        .font(.system(size: 20))

                    Text(module.title)
                        .font(Typography.bodyMedium)
                        .foregroundColor(.textPrimary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }

                // Why this module
                Text(item.whyFirst)
                    .font(Typography.caption)
                    .foregroundColor(.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)

                // Builds on previous
                if let builds = item.buildsToPrevious {
                    HStack(alignment: .top, spacing: Spacing.xs) {
                        Image(systemName: "arrow.turn.down.right")
                            .font(.system(size: 10))
                            .foregroundColor(.textTertiary)
                            .padding(.top, 2)

                        Text(builds)
                            .font(Typography.caption2)
                            .foregroundColor(.textTertiary)
                            .italic()
                    }
                }

                // Module metadata
                HStack(spacing: Spacing.sm) {
                    Label("\(module.totalSections) sections", systemImage: "list.bullet")
                    Label("\(module.estimatedTime) min", systemImage: "clock")
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
        .background(isCompleted ? Color.success.opacity(0.05) : Color.surfaceSecondary)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.md)
                .stroke(isCompleted ? Color.success.opacity(0.3) : Color.clear, lineWidth: 1)
        )
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        LearningPathView(path: SampleLearningPaths.all[0])
            .environmentObject(ProgressManager())
            .environmentObject(NotionService())
            .environmentObject(ReviewManager())
    }
}
