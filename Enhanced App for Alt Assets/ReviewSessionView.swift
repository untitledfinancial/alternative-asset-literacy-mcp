//
//  ReviewSessionView.swift
//  Enhanced App for Alt Assets
//
//  Created by Victoria Case on 2/4/26.
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//
//  Description: Flashcard-style spaced repetition review interface. Presents
//  questions one at a time, allows self-rating of recall quality, and provides
//  session completion statistics.
//

import SwiftUI

// MARK: - Review Session View
struct ReviewSessionView: View {
    @EnvironmentObject var reviewManager: ReviewManager
    @EnvironmentObject var notionService: NotionService
    @Environment(\.dismiss) private var dismiss

    @State private var session: ReviewSession
    @State private var showingAnswer = false
    @State private var questionStartTime = Date()
    @State private var selectedQuality: SpacedRepetitionEngine.Quality?

    init(items: [ReviewItem]) {
        _session = State(initialValue: ReviewSession(items: items))
    }

    var body: some View {
        NavigationStack {
            if session.isComplete {
                sessionCompleteView
            } else {
                reviewContent
            }
        }
        .interactiveDismissDisabled(!session.isComplete)
    }

    // MARK: - Review Content
    private var reviewContent: some View {
        VStack(spacing: 0) {
            // Progress header
            progressHeader

            // Card content
            ScrollView {
                VStack(spacing: Spacing.xl) {
                    if let item = session.currentItem {
                        reviewCard(for: item)
                            .transition(.asymmetric(
                                insertion: .move(edge: .trailing).combined(with: .opacity),
                                removal: .move(edge: .leading).combined(with: .opacity)
                            ))
                            .id(item.id)
                    }
                }
                .padding(Spacing.xl)
            }

            // Rating buttons (shown after reveal)
            if showingAnswer {
                ratingButtons
            }
        }
        .background(Color.surfacePrimary)
        .navigationTitle("Review")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("End Session") {
                    dismiss()
                }
            }
        }
        .onAppear {
            questionStartTime = Date()
        }
    }

    // MARK: - Progress Header
    private var progressHeader: some View {
        VStack(spacing: Spacing.sm) {
            // Progress text
            HStack {
                Text("Question \(session.currentIndex + 1) of \(session.items.count)")
                    .font(Typography.caption)
                    .foregroundColor(.textSecondary)

                Spacer()

                // Streak indicator
                if reviewManager.state.streak > 0 {
                    HStack(spacing: Spacing.xxs) {
                        Image(systemName: "flame.fill")
                            .foregroundColor(.warning)
                        Text("\(reviewManager.state.streak)")
                            .foregroundColor(.warning)
                    }
                    .font(Typography.caption)
                }
            }

            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.progressTrack)

                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.progressFill)
                        .frame(width: geometry.size.width * session.progress)
                        .animation(.smoothSpring, value: session.progress)
                }
            }
            .frame(height: 6)

            // Session stats
            HStack(spacing: Spacing.lg) {
                HStack(spacing: Spacing.xxs) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.success)
                    Text("\(session.correctCount)")
                }
                .font(Typography.caption)

                HStack(spacing: Spacing.xxs) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.error)
                    Text("\(session.incorrectCount)")
                }
                .font(Typography.caption)
            }
        }
        .padding(.horizontal, Spacing.xl)
        .padding(.vertical, Spacing.md)
        .background(Color.surfaceSecondary)
    }

    // MARK: - Review Card
    private func reviewCard(for item: ReviewItem) -> some View {
        VStack(spacing: Spacing.xl) {
            // Item type badge
            HStack {
                Label(item.itemType.displayName, systemImage: item.itemType.icon)
                    .font(Typography.caption)
                    .foregroundColor(.textTertiary)

                Spacer()

                // Difficulty indicator
                if item.easeFactor < 2.0 {
                    Text("Hard")
                        .font(Typography.caption)
                        .foregroundColor(.error)
                        .padding(.horizontal, Spacing.sm)
                        .padding(.vertical, 2)
                        .background(Color.error.opacity(0.1))
                        .clipShape(Capsule())
                }
            }

            Spacer()

            // Question
            VStack(spacing: Spacing.lg) {
                Text(questionText(for: item))
                    .font(Typography.title2)
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Spacing.lg)

                if !showingAnswer {
                    Button {
                        withAnimation(.smoothSpring) {
                            showingAnswer = true
                        }
                        HapticFeedback.light.trigger()
                    } label: {
                        Text("Show Answer")
                            .font(Typography.bodyMedium)
                            .foregroundColor(.white)
                            .padding(.horizontal, Spacing.xl)
                            .padding(.vertical, Spacing.md)
                            .background(Color.brandPrimary)
                            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
                    }
                    .buttonStyle(.pressable)
                }
            }

            Spacer()

            // Answer (revealed)
            if showingAnswer {
                VStack(spacing: Spacing.md) {
                    Rectangle()
                        .fill(Color.divider)
                        .frame(height: 1)

                    Text("Answer")
                        .font(Typography.overline)
                        .foregroundColor(.textTertiary)

                    Text(answerText(for: item))
                        .font(Typography.bodyLarge)
                        .foregroundColor(.textPrimary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, Spacing.lg)

                    // Explanation if available
                    if let explanation = explanationText(for: item) {
                        Text(explanation)
                            .font(Typography.body)
                            .foregroundColor(.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, Spacing.lg)
                            .padding(.top, Spacing.sm)
                    }
                }
                .transition(.calmFade)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Rating Buttons
    private var ratingButtons: some View {
        VStack(spacing: Spacing.md) {
            Text("How well did you remember?")
                .font(Typography.caption)
                .foregroundColor(.textSecondary)

            HStack(spacing: Spacing.sm) {
                RatingButton(
                    quality: .completeBlackout,
                    isSelected: selectedQuality == .completeBlackout,
                    action: { recordAndAdvance(.completeBlackout) }
                )

                RatingButton(
                    quality: .correctDifficult,
                    isSelected: selectedQuality == .correctDifficult,
                    action: { recordAndAdvance(.correctDifficult) }
                )

                RatingButton(
                    quality: .correctHesitation,
                    isSelected: selectedQuality == .correctHesitation,
                    action: { recordAndAdvance(.correctHesitation) }
                )

                RatingButton(
                    quality: .perfectRecall,
                    isSelected: selectedQuality == .perfectRecall,
                    action: { recordAndAdvance(.perfectRecall) }
                )
            }
            .padding(.horizontal, Spacing.md)
        }
        .padding(Spacing.lg)
        .background(Color.surfaceSecondary)
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }

    // MARK: - Session Complete View
    private var sessionCompleteView: some View {
        VStack(spacing: Spacing.xxl) {
            Spacer()

            // Celebration icon
            ZStack {
                Circle()
                    .fill(Color.success.opacity(0.1))
                    .frame(width: 120, height: 120)

                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.success)
            }

            // Stats
            VStack(spacing: Spacing.sm) {
                Text("Session Complete!")
                    .font(Typography.displaySmall)
                    .foregroundColor(.textPrimary)

                Text("Great work on your review session")
                    .font(Typography.body)
                    .foregroundColor(.textSecondary)
            }

            // Results
            HStack(spacing: Spacing.xl) {
                ResultStatView(
                    value: "\(session.items.count)",
                    label: "Reviewed",
                    icon: "square.stack.fill",
                    color: .info
                )

                ResultStatView(
                    value: "\(session.correctCount)",
                    label: "Correct",
                    icon: "checkmark.circle.fill",
                    color: .success
                )

                ResultStatView(
                    value: formatDuration(session.sessionDuration),
                    label: "Time",
                    icon: "clock.fill",
                    color: .brandPrimary
                )
            }
            .padding(.horizontal, Spacing.xl)

            // Streak
            if reviewManager.state.streak > 0 {
                HStack(spacing: Spacing.sm) {
                    Image(systemName: "flame.fill")
                        .font(.title)
                        .foregroundColor(.warning)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(reviewManager.state.streak) Day Streak!")
                            .font(Typography.title3)
                            .foregroundColor(.textPrimary)

                        Text("Keep it going!")
                            .font(Typography.caption)
                            .foregroundColor(.textSecondary)
                    }
                }
                .padding(Spacing.lg)
                .background(Color.warning.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
            }

            Spacer()

            // Done button
            Button {
                Task { await NotificationManager.shared.updateAfterReview(remainingDue: reviewManager.reviewsDueCount) }
                dismiss()
            } label: {
                Text("Done")
                    .font(Typography.bodyMedium)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Spacing.md)
                    .background(Color.brandPrimary)
                    .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
            }
            .buttonStyle(.pressable)
            .padding(.horizontal, Spacing.xl)
            .padding(.bottom, Spacing.xl)
        }
        .background(Color.surfacePrimary)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Done") {
                    dismiss()
                }
            }
        }
    }

    // MARK: - Helpers
    private func questionText(for item: ReviewItem) -> String {
        switch item.itemType {
        case .quizQuestion:
            if let question = findQuizQuestion(sourceId: item.sourceId) {
                return question.question
            }
            return "Review this concept"

        case .glossaryTerm:
            return "Define this term"

        case .concept:
            return "Explain this concept"

        case .caseStudy:
            return "What are the key takeaways?"
        }
    }

    private func answerText(for item: ReviewItem) -> String {
        switch item.itemType {
        case .quizQuestion:
            if let question = findQuizQuestion(sourceId: item.sourceId) {
                return question.options[question.correctAnswerIndex]
            }
            return "Answer not available"

        case .glossaryTerm:
            return "Definition would appear here"

        case .concept:
            return "Concept explanation would appear here"

        case .caseStudy:
            return "Key takeaways would appear here"
        }
    }

    private func explanationText(for item: ReviewItem) -> String? {
        switch item.itemType {
        case .quizQuestion:
            if let question = findQuizQuestion(sourceId: item.sourceId) {
                return question.explanation
            }
            return nil

        default:
            return nil
        }
    }

    private func findQuizQuestion(sourceId: String) -> QuizQuestion? {
        for module in notionService.modules {
            for quiz in module.quizzes {
                if let question = quiz.questions.first(where: { $0.id == sourceId }) {
                    return question
                }
            }
        }
        return nil
    }

    private func recordAndAdvance(_ quality: SpacedRepetitionEngine.Quality) {
        guard let item = session.currentItem else { return }

        let responseTime = Date().timeIntervalSince(questionStartTime)

        // Record in session
        session.recordResponse(quality: quality, responseTime: responseTime)

        // Record in manager
        reviewManager.recordReview(
            itemId: item.id,
            quality: quality,
            responseTime: responseTime
        )

        // Haptic feedback
        if quality.isCorrect {
            HapticFeedback.success.trigger()
        } else {
            HapticFeedback.error.trigger()
        }

        // Reset for next question
        withAnimation(.smoothSpring) {
            showingAnswer = false
            selectedQuality = nil
            questionStartTime = Date()
        }
    }

    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        if minutes > 0 {
            return "\(minutes)m \(seconds)s"
        }
        return "\(seconds)s"
    }
}

// MARK: - Rating Button
struct RatingButton: View {
    let quality: SpacedRepetitionEngine.Quality
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: Spacing.xs) {
                Text(quality.displayName)
                    .font(Typography.captionMedium)
                    .foregroundColor(.white)

                Text(intervalHint)
                    .font(.system(size: 10))
                    .foregroundColor(.white.opacity(0.7))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, Spacing.sm)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.sm))
        }
        .buttonStyle(.pressable)
    }

    private var backgroundColor: Color {
        switch quality {
        case .completeBlackout, .incorrect:
            return .error
        case .incorrectEasyRecall:
            return .warning
        case .correctDifficult:
            return .info
        case .correctHesitation:
            return .success.opacity(0.8)
        case .perfectRecall:
            return .success
        }
    }

    private var intervalHint: String {
        switch quality {
        case .completeBlackout, .incorrect:
            return "< 1 day"
        case .incorrectEasyRecall:
            return "1 day"
        case .correctDifficult:
            return "~3 days"
        case .correctHesitation:
            return "~1 week"
        case .perfectRecall:
            return "~2 weeks"
        }
    }
}

// MARK: - Result Stat View
struct ResultStatView: View {
    let value: String
    let label: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: Spacing.sm) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)

            Text(value)
                .font(Typography.title2)
                .foregroundColor(.textPrimary)

            Text(label)
                .font(Typography.caption)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(Spacing.md)
        .background(Color.surfaceSecondary)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
    }
}

// MARK: - Preview
#Preview {
    let sampleItems = [
        ReviewItem(itemType: .quizQuestion, sourceId: "q1", moduleId: "m1"),
        ReviewItem(itemType: .quizQuestion, sourceId: "q2", moduleId: "m1"),
    ]

    return ReviewSessionView(items: sampleItems)
        .environmentObject(ReviewManager())
        .environmentObject(NotionService())
}
