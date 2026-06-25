//
//  AnnualReviewView.swift
//  Enhanced App for Alt Assets
//
//  Created by Victoria Case on 6/24/26.
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//
//  Description: Subscription journey milestone cards surfaced at days 5, 30, 90,
//  180, and 365. Each appears once, dismissed on tap, and grows richer over time.
//  Also provides the mastery milestone banner shown in the Progress tab.
//

import SwiftUI

// MARK: - Progress Milestone Card

struct ProgressMilestoneCard: View {
    let days: Int
    let onDismiss: () -> Void
    @EnvironmentObject var progressManager: ProgressManager
    @EnvironmentObject var reviewManager: ReviewManager
    @State private var showDetail = false

    var body: some View {
        Button { showDetail = true } label: {
            VStack(alignment: .leading, spacing: Spacing.md) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(milestoneLabel)
                            .font(Typography.caption)
                            .foregroundColor(.brandPrimary)
                            .textCase(.uppercase)
                            .tracking(1.2)
                        Text(headlineText)
                            .font(Typography.title3)
                            .foregroundColor(.textPrimary)
                            .multilineTextAlignment(.leading)
                    }
                    Spacer()
                    Button {
                        withAnimation { onDismiss() }
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.textTertiary)
                            .padding(8)
                            .background(Color.surfaceTertiary)
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                }

                Text(bodyText)
                    .font(Typography.body)
                    .foregroundColor(.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)

                // Key stats row
                HStack(spacing: Spacing.lg) {
                    MilestoneStatPill(
                        value: "\(progressManager.progress.totalModulesCompleted)",
                        label: "modules"
                    )
                    MilestoneStatPill(
                        value: "\(progressManager.progress.totalReflectionsWritten)",
                        label: "reflections"
                    )
                    if reviewManager.stats.matureItems > 0 {
                        MilestoneStatPill(
                            value: "\(reviewManager.stats.matureItems)",
                            label: "mastered"
                        )
                    }
                    MilestoneStatPill(
                        value: formatTime(progressManager.progress.totalTimeSpent),
                        label: "invested"
                    )
                }
            }
            .padding(Spacing.xl)
            .background(
                LinearGradient(
                    colors: [Color.brandPrimary.opacity(0.08), Color.brandPrimary.opacity(0.03)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.lg)
                    .stroke(Color.brandPrimary.opacity(0.18), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.lg))
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showDetail) {
            MilestoneDetailSheet(days: days, onDismiss: {
                showDetail = false
                onDismiss()
            })
            .environmentObject(progressManager)
            .environmentObject(reviewManager)
        }
    }

    // MARK: - Copy

    private var milestoneLabel: String {
        switch days {
        case 5:   return "Day Five"
        case 30:  return "One Month"
        case 90:  return "Three Months"
        case 180: return "Six Months"
        default:  return "One Year"
        }
    }

    private var headlineText: String {
        switch days {
        case 5:   return "A strong start."
        case 30:  return "One month of focused learning."
        case 90:  return "The depth is showing."
        case 180: return "Halfway through your year."
        default:  return "Your first year, complete."
        }
    }

    private var bodyText: String {
        let modules = progressManager.progress.totalModulesCompleted
        let reflections = progressManager.progress.totalReflectionsWritten
        let time = formatTime(progressManager.progress.totalTimeSpent)
        let mastered = reviewManager.stats.matureItems

        switch days {
        case 5:
            return "You have explored \(modules == 1 ? "1 module" : "\(modules) modules") and written \(reflections == 1 ? "1 reflection" : "\(reflections) reflections"). Most investors never get this far."
        case 30:
            return "In one month you have invested \(time) and written \(reflections == 1 ? "1 reflection" : "\(reflections) reflections"). The patterns you are building now compound over years."
        case 90:
            return "Three months in. You have mastered \(mastered == 1 ? "1 concept" : "\(mastered) concepts") in spaced repetition. That kind of retention takes sustained attention."
        case 180:
            return "Six months. \(modules == 1 ? "1 module" : "\(modules) modules") explored, \(time) invested. You are building the kind of literacy that changes how decisions get made."
        default:
            return "A full year. \(modules == 1 ? "1 module" : "\(modules) modules") completed, \(mastered == 1 ? "1 concept" : "\(mastered) concepts") mastered, \(reflections == 1 ? "1 reflection" : "\(reflections) reflections") written, \(time) invested. This is what a serious education in alternative assets looks like."
        }
    }

    private func formatTime(_ seconds: TimeInterval) -> String {
        let hours = Int(seconds) / 3600
        let minutes = (Int(seconds) % 3600) / 60
        if hours > 0 { return "\(hours)h \(minutes)m" }
        return "\(minutes)m"
    }
}

// MARK: - Milestone Stat Pill

struct MilestoneStatPill: View {
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(Typography.title3)
                .foregroundColor(.textPrimary)
            Text(label)
                .font(Typography.caption)
                .foregroundColor(.textTertiary)
        }
    }
}

// MARK: - Milestone Detail Sheet

struct MilestoneDetailSheet: View {
    let days: Int
    let onDismiss: () -> Void
    @EnvironmentObject var progressManager: ProgressManager
    @EnvironmentObject var reviewManager: ReviewManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.xxl) {
                    // Hero text
                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        Text(milestoneLabel.uppercased())
                            .font(Typography.caption)
                            .foregroundColor(.brandPrimary)
                            .tracking(1.5)
                        Text(headlineText)
                            .font(Typography.displaySmall)
                            .foregroundColor(.textPrimary)
                        Text(bodyText)
                            .font(Typography.body)
                            .foregroundColor(.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    Rectangle()
                        .fill(Color.divider)
                        .frame(height: 1)

                    // Full stats
                    VStack(alignment: .leading, spacing: Spacing.md) {
                        Text("Your progress")
                            .font(Typography.title3)
                            .foregroundColor(.textPrimary)

                        fullStatRow(label: "Modules completed", value: "\(progressManager.progress.totalModulesCompleted)")
                        fullStatRow(label: "Sections explored", value: "\(progressManager.progress.totalSectionsExplored)")
                        fullStatRow(label: "Reflections written", value: "\(progressManager.progress.totalReflectionsWritten)")
                        fullStatRow(label: "Quizzes passed", value: "\(progressManager.progress.totalQuizzesPassed)")
                        fullStatRow(label: "Concepts mastered", value: "\(reviewManager.stats.matureItems)")
                        fullStatRow(label: "Retention rate", value: "\(Int(reviewManager.stats.retentionRate * 100))%")
                        fullStatRow(label: "Review streak", value: "\(reviewManager.state.streak) days")
                        fullStatRow(label: "Time invested", value: formatTime(progressManager.progress.totalTimeSpent))
                    }

                    Rectangle()
                        .fill(Color.divider)
                        .frame(height: 1)

                    Button {
                        onDismiss()
                        dismiss()
                    } label: {
                        Text("Dismiss")
                            .font(Typography.bodyMedium)
                            .foregroundColor(.textPrimary)
                            .frame(maxWidth: .infinity)
                            .padding(Spacing.md)
                            .background(Color.surfaceSecondary)
                            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
                    }
                    .buttonStyle(.plain)
                }
                .padding(Spacing.xl)
            }
            .background(Color.surfacePrimary)
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        onDismiss()
                        dismiss()
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func fullStatRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(Typography.body)
                .foregroundColor(.textSecondary)
            Spacer()
            Text(value)
                .font(Typography.bodyMedium)
                .foregroundColor(.textPrimary)
        }
        .padding(.vertical, 4)
    }

    private var milestoneLabel: String {
        switch days {
        case 5:   return "Day Five"
        case 30:  return "One Month"
        case 90:  return "Three Months"
        case 180: return "Six Months"
        default:  return "One Year"
        }
    }

    private var headlineText: String {
        switch days {
        case 5:   return "A strong start."
        case 30:  return "One month of focused learning."
        case 90:  return "The depth is showing."
        case 180: return "Halfway through your year."
        default:  return "Your first year, complete."
        }
    }

    private var bodyText: String {
        switch days {
        case 5:   return "The first five days tend to predict the next fifty. You showed up."
        case 30:  return "One month is enough to see a pattern forming. This is how real knowledge is built."
        case 90:  return "Three months of consistent attention to alternative assets is unusual. Most people read a headline and stop there."
        case 180: return "Six months in, the concepts that once required effort are becoming intuitive. That is the whole point."
        default:  return "A full year of study in a field most investors never seriously engage with. This is rare."
        }
    }

    private func formatTime(_ seconds: TimeInterval) -> String {
        let hours = Int(seconds) / 3600
        let minutes = (Int(seconds) % 3600) / 60
        if hours > 0 { return "\(hours)h \(minutes)m" }
        return "\(minutes)m"
    }
}

// MARK: - Mastery Milestone Banner

struct MilestoneBannerView: View {
    let count: Int
    let onAcknowledge: () -> Void

    var body: some View {
        HStack(spacing: Spacing.md) {
            VStack(alignment: .leading, spacing: 4) {
                Text(bannerHeadline)
                    .font(Typography.bodyMedium)
                    .foregroundColor(.textPrimary)
                Text(bannerBody)
                    .font(Typography.caption)
                    .foregroundColor(.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
            Button {
                withAnimation { onAcknowledge() }
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.textTertiary)
                    .padding(7)
                    .background(Color.surfaceTertiary)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
        }
        .padding(Spacing.lg)
        .background(Color.success.opacity(0.07))
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.md)
                .stroke(Color.success.opacity(0.25), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
    }

    private var bannerHeadline: String {
        "You have mastered \(count) concepts."
    }

    private var bannerBody: String {
        switch count {
        case 10:  return "Ten concepts held in long-term memory. That kind of retention is rare."
        case 25:  return "Twenty-five concepts mastered. You are building a vocabulary most investors never acquire."
        case 50:  return "Fifty concepts. This is not passive learning — this is a real education."
        default:  return "One hundred concepts in long-term memory. The field looks different from here."
        }
    }
}
