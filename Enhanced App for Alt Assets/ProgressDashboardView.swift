//
//  ProgressDashboardView.swift
//  Enhanced App for Alt Assets
//
//  Created by Victoria Case on 2/1/26.
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//
//  Description: Displays comprehensive user progress analytics including completed
//  modules, quiz performance, learning insights, time spent, and personalized
//  recommendations for continued learning.
//

import SwiftUI
import Charts

struct ProgressDashboardView: View {
    @EnvironmentObject var progressManager: ProgressManager
    @EnvironmentObject var notionService: NotionService
    @EnvironmentObject var reviewManager: ReviewManager
    @EnvironmentObject var userSettings: UserSettings
    @EnvironmentObject var subscriptionManager: SubscriptionManager

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.xxl) {
                // Subscription journey milestone card
                if let milestone = subscriptionManager.currentMilestone {
                    ProgressMilestoneCard(days: milestone) {
                        subscriptionManager.acknowledgeMilestone(milestone)
                    }
                }

                // Overview cards
                overviewSection

                Rectangle()
                    .fill(Color.divider)
                    .frame(height: 1)

                // Learning journey
                learningJourneySection

                Rectangle()
                    .fill(Color.divider)
                    .frame(height: 1)

                // Spaced repetition stats
                spacedRepetitionSection

                // Mastery milestone banner
                if let milestone = reviewManager.pendingMilestone {
                    MilestoneBannerView(count: milestone) {
                        reviewManager.acknowledgeMilestone(milestone)
                    }
                }

                Rectangle()
                    .fill(Color.divider)
                    .frame(height: 1)

                // Quiz performance
                quizPerformanceSection

                Rectangle()
                    .fill(Color.divider)
                    .frame(height: 1)

                // Time spent
                timeSpentSection

                Rectangle()
                    .fill(Color.divider)
                    .frame(height: 1)

                // Insights & recommendations
                insightsSection
            }
            .padding(Spacing.xl)
        }
        .background(Color.surfacePrimary)
        .navigationTitle("Your Learning Progress")
    }

    // MARK: - Overview Section
    private var overviewSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("Learning Overview")
                .font(Typography.title2)
                .foregroundColor(.textPrimary)

            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: Spacing.md) {
                EmojiOverviewCard(
                    emoji: "🎓",
                    color: .brandPrimary,
                    value: "\(progressManager.progress.totalModulesCompleted)",
                    label: "Modules Completed",
                    total: notionService.modules.count
                )

                EmojiOverviewCard(
                    emoji: "✅",
                    color: .success,
                    value: "\(progressManager.progress.totalSectionsExplored)",
                    label: "Sections Explored",
                    total: nil
                )

                EmojiOverviewCard(
                    emoji: "📝",
                    color: .info,
                    value: "\(progressManager.progress.totalReflectionsWritten)",
                    label: "Reflections Written",
                    total: nil
                )

                EmojiOverviewCard(
                    emoji: "☑️",
                    color: .warning,
                    value: "\(progressManager.progress.totalQuizzesPassed)",
                    label: "Quizzes Passed",
                    total: nil
                )

                EmojiOverviewCard(
                    emoji: "⭐",
                    color: .brandHighlight,
                    value: "\(Int(progressManager.progress.averageQuizScore * 100))%",
                    label: "Average Quiz Score",
                    total: nil
                )

                EmojiOverviewCard(
                    emoji: "🕐",
                    color: .brandPrimary,
                    value: formatTime(progressManager.progress.totalTimeSpent),
                    label: "Total Time Spent",
                    total: nil
                )
            }
        }
    }

    // MARK: - Spaced Repetition Section
    private var spacedRepetitionSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("Memory & Retention")
                .font(Typography.title2)
                .foregroundColor(.textPrimary)

            HStack(spacing: Spacing.md) {
                // Retention rate
                VStack(spacing: Spacing.sm) {
                    ZStack {
                        Circle()
                            .stroke(Color.progressTrack, lineWidth: 8)

                        Circle()
                            .trim(from: 0, to: reviewManager.stats.retentionRate)
                            .stroke(Color.success, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                            .rotationEffect(.degrees(-90))

                        VStack(spacing: 2) {
                            Text("\(Int(reviewManager.stats.retentionRate * 100))%")
                                .font(Typography.title2)
                                .foregroundColor(.textPrimary)
                            Text("Retention")
                                .font(Typography.caption)
                                .foregroundColor(.textTertiary)
                        }
                    }
                    .frame(width: 100, height: 100)
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel("Retention rate: \(Int(reviewManager.stats.retentionRate * 100)) percent")
                }
                .frame(maxWidth: .infinity)
                .padding(Spacing.lg)
                .background(Color.surfaceSecondary)
                .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))

                // Stats grid
                VStack(spacing: Spacing.sm) {
                    HStack(spacing: Spacing.md) {
                        MiniStatCard(
                            value: "\(reviewManager.stats.totalItems)",
                            label: "Total Items",
                            color: .info
                        )
                        MiniStatCard(
                            value: "\(reviewManager.stats.matureItems)",
                            label: "Mastered",
                            color: .success
                        )
                    }
                    HStack(spacing: Spacing.md) {
                        MiniStatCard(
                            value: "\(reviewManager.state.streak)",
                            label: "Day Streak",
                            color: .warning
                        )
                        MiniStatCard(
                            value: "\(reviewManager.stats.totalReviews)",
                            label: "Reviews",
                            color: .brandPrimary
                        )
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
    }

    // MARK: - Learning Journey
    private var learningJourneySection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("Learning Journey")
                .font(Typography.title2)
                .foregroundColor(.textPrimary)

            if !notionService.modules.isEmpty {
                ForEach(notionService.modules) { module in
                    ModuleProgressCard(module: module)
                }
            } else {
                Text("No modules loaded yet")
                    .font(Typography.body)
                    .foregroundColor(.textSecondary)
            }
        }
    }

    // MARK: - Quiz Performance
    private var quizPerformanceSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("Quiz Performance")
                .font(Typography.title2)
                .foregroundColor(.textPrimary)

            if !progressManager.progress.quizScores.isEmpty {
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    // Performance summary
                    HStack(spacing: Spacing.xl) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Average Score")
                                .font(Typography.caption)
                                .foregroundColor(.textSecondary)
                            Text("\(Int(progressManager.progress.averageQuizScore * 100))%")
                                .font(Typography.displaySmall)
                                .foregroundColor(.textPrimary)
                        }

                        Rectangle()
                            .fill(Color.divider)
                            .frame(width: 1, height: 40)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Highest Score")
                                .font(Typography.caption)
                                .foregroundColor(.textSecondary)
                            Text("\(Int((progressManager.progress.quizScores.values.max() ?? 0) * 100))%")
                                .font(Typography.displaySmall)
                                .foregroundColor(.success)
                        }
                    }
                    .padding(Spacing.lg)
                    .background(Color.surfaceSecondary)
                    .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))

                    // Individual quiz scores
                    ForEach(Array(progressManager.progress.quizScores.keys.sorted()), id: \.self) { quizId in
                        if let score = progressManager.progress.quizScores[quizId] {
                            QuizScoreRow(quizId: quizId, score: score)
                        }
                    }
                }
            } else {
                ProgressEmptyStateView(
                    icon: "checkmark.circle.fill",
                    message: "Complete quizzes to see your performance"
                )
            }
        }
    }

    // MARK: - Time Spent
    private var timeSpentSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("Time Investment")
                .font(Typography.title2)
                .foregroundColor(.textPrimary)

            if !progressManager.progress.timeSpent.isEmpty {
                ForEach(Array(progressManager.progress.timeSpent.keys.sorted()), id: \.self) { moduleId in
                    if let module = notionService.modules.first(where: { $0.id == moduleId }),
                       let time = progressManager.progress.timeSpent[moduleId] {
                        TimeSpentRow(module: module, timeSpent: time)
                    }
                }
            } else {
                ProgressEmptyStateView(
                    icon: "clock.fill",
                    message: "Start learning to track your time"
                )
            }
        }
    }

    // MARK: - Insights
    private var insightsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("Learning Insights")
                .font(Typography.title2)
                .foregroundColor(.textPrimary)

            VStack(alignment: .leading, spacing: Spacing.md) {
                // Learning style
                InsightCard(
                    icon: "person.fill",
                    color: .info,
                    title: "Your Learning Style",
                    content: progressManager.insights.learningStyle.rawValue.capitalized
                )

                // Strong topics
                if !progressManager.insights.strongTopics.isEmpty {
                    InsightCard(
                        icon: "star.fill",
                        color: .success,
                        title: "Strong Topics",
                        content: "\(progressManager.insights.strongTopics.count) concepts mastered"
                    )
                }

                // Needs review
                if !progressManager.insights.needsReview.isEmpty {
                    InsightCard(
                        icon: "exclamationmark.circle.fill",
                        color: .warning,
                        title: "Concepts to Review",
                        content: "\(progressManager.insights.needsReview.count) topics could use more attention"
                    )
                }

                // Suggestions
                if !progressManager.insights.suggestedNext.isEmpty {
                    InsightCard(
                        icon: "lightbulb.fill",
                        color: .brandHighlight,
                        title: "Suggested Next Steps",
                        content: "We have \(progressManager.insights.suggestedNext.count) recommendations for you"
                    )
                }
            }
        }
    }

    // MARK: - Helpers
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

// MARK: - Supporting Views

// Notion-style emoji overview card
struct EmojiOverviewCard: View {
    let emoji: String
    let color: Color
    let value: String
    let label: String
    let total: Int?

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack {
                Text(emoji)
                    .font(.system(size: 20))
                Spacer()
                if let total = total {
                    Text("/ \(total)")
                        .font(Typography.caption)
                        .foregroundColor(.textTertiary)
                }
            }

            Text(value)
                .font(Typography.displaySmall)
                .foregroundColor(.textPrimary)

            Text(label)
                .font(Typography.caption)
                .foregroundColor(.textSecondary)
        }
        .padding(Spacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(label): \(value)\(total != nil ? " of \(total!)" : "")")
    }
}

// Legacy SF Symbol card (kept for compatibility)
struct OverviewCard: View {
    let icon: String
    let color: Color
    let value: String
    let label: String
    let total: Int?

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Spacer()
                if let total = total {
                    Text("/ \(total)")
                        .font(Typography.caption)
                        .foregroundColor(.textTertiary)
                }
            }

            Text(value)
                .font(Typography.displaySmall)
                .foregroundColor(.textPrimary)

            Text(label)
                .font(Typography.caption)
                .foregroundColor(.textSecondary)
        }
        .padding(Spacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(label): \(value)\(total != nil ? " of \(total!)" : "")")
    }
}

struct MiniStatCard: View {
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: Spacing.xxs) {
            Text(value)
                .font(Typography.title3)
                .foregroundColor(.textPrimary)
            Text(label)
                .font(Typography.caption)
                .foregroundColor(.textTertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(Spacing.sm)
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.sm))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(label): \(value)")
    }
}

struct ModuleProgressCard: View {
    let module: Module
    @EnvironmentObject var progressManager: ProgressManager

    var body: some View {
        let completedSections = module.sections.filter {
            progressManager.isSectionComplete($0.id)
        }.count
        let progress = Double(completedSections) / Double(module.totalSections)

        return VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack {
                Text(module.icon)
                    .font(.title2)

                VStack(alignment: .leading, spacing: 4) {
                    Text(module.title)
                        .font(Typography.bodyMedium)
                        .foregroundColor(.textPrimary)

                    Text("\(completedSections) / \(module.totalSections) sections")
                        .font(Typography.caption)
                        .foregroundColor(.textSecondary)
                }

                Spacer()

                if progressManager.isModuleComplete(module.id) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.success)
                        .font(.title2)
                }
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.progressTrack)

                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.progressFill)
                        .frame(width: geometry.size.width * progress)
                }
            }
            .frame(height: 6)
            .accessibilityHidden(true)
        }
        .padding(Spacing.md)
        .background(Color.surfaceSecondary)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(module.title): \(completedSections) of \(module.totalSections) sections complete\(progressManager.isModuleComplete(module.id) ? ", completed" : "")")
    }
}

struct QuizScoreRow: View {
    let quizId: String
    let score: Double

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Quiz")
                    .font(Typography.bodyMedium)
                    .foregroundColor(.textPrimary)
                Text(quizId.prefix(20))
                    .font(Typography.caption)
                    .foregroundColor(.textTertiary)
            }

            Spacer()

            HStack(spacing: Spacing.sm) {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color.progressTrack)

                        RoundedRectangle(cornerRadius: 3)
                            .fill(score >= 0.7 ? Color.success : Color.warning)
                            .frame(width: geometry.size.width * score)
                    }
                }
                .frame(width: 100, height: 6)

                Text("\(Int(score * 100))%")
                    .font(Typography.bodyMedium)
                    .foregroundColor(score >= 0.7 ? .success : .warning)
            }
        }
        .padding(Spacing.sm)
        .background(Color.surfaceSecondary)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.sm))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Quiz score: \(Int(score * 100)) percent\(score >= 0.7 ? ", passed" : ", needs review")")
    }
}

struct TimeSpentRow: View {
    let module: Module
    let timeSpent: TimeInterval

    var body: some View {
        HStack {
            Text(module.icon)
                .font(.title3)

            VStack(alignment: .leading, spacing: 4) {
                Text(module.title)
                    .font(Typography.bodyMedium)
                    .foregroundColor(.textPrimary)
                Text("Time invested")
                    .font(Typography.caption)
                    .foregroundColor(.textSecondary)
            }

            Spacer()

            Text(formatTime(timeSpent))
                .font(Typography.title3)
                .foregroundColor(.brandPrimary)
        }
        .padding(Spacing.sm)
        .background(Color.surfaceSecondary)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.sm))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(module.title): \(formatTime(timeSpent)) spent")
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

struct InsightCard: View {
    let icon: String
    let color: Color
    let title: String
    let content: String

    var body: some View {
        HStack(alignment: .top, spacing: Spacing.md) {
            // Rounded icon container (Art Space style)
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 44, height: 44)

                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(color)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(Typography.bodyMedium)
                    .foregroundColor(.textPrimary)

                Text(content)
                    .font(Typography.body)
                    .foregroundColor(.textSecondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.textTertiary)
        }
        .padding(Spacing.md)
        .background(Color.surfaceSecondary)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.lg))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(title): \(content)")
    }
}

struct ProgressEmptyStateView: View {
    let icon: String
    let message: String

    var body: some View {
        VStack(spacing: Spacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 48))
                .foregroundColor(.textTertiary)
            Text(message)
                .font(Typography.body)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(Spacing.xl)
        .background(Color.surfaceSecondary)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
    }
}

#Preview {
    NavigationStack {
        ProgressDashboardView()
            .environmentObject(ProgressManager())
            .environmentObject(NotionService())
            .environmentObject(ReviewManager())
            .environmentObject(UserSettings.shared)
            .environmentObject(SubscriptionManager())
    }
}
