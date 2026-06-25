//
//  QuizView.swift
//  Enhanced App for Alt Assets
//
//  Created by Victoria Case on 2/1/26.
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//
//  Description: Interactive learning quiz that helps users digest information.
//  When a user selects an answer, immediately shows the correct answer with
//  explanation - focusing on learning rather than grading.
//

import SwiftUI
import StoreKit

struct QuizView: View {
    let quiz: Quiz
    let moduleId: String
    @EnvironmentObject var progressManager: ProgressManager
    @EnvironmentObject var reviewManager: ReviewManager
    @Environment(\.dismiss) private var dismiss
    @Environment(\.requestReview) private var requestReview

    @State private var currentQuestionIndex = 0
    @State private var selectedAnswers: [Int?] = []
    @State private var showingExplanation = false
    @State private var quizComplete = false
    @State private var score: Double = 0
    @State private var isInitialized = false

    var body: some View {
        NavigationStack {
            if !isInitialized {
                // Show loading state while initializing
                ProgressView("Loading quiz...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if quizComplete {
                resultsView
            } else {
                questionView
            }
        }
        #if os(macOS)
        .frame(minWidth: 700, minHeight: 600)
        #endif
        .onAppear {
            initializeQuiz()
        }
    }
    
    // MARK: - Question View
    private var questionView: some View {
        VStack(spacing: 0) {
            // Progress bar
            progressBar
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Question
                    questionCard
                    
                    // Options
                    optionsSection
                    
                    // Explanation (after answering)
                    if showingExplanation {
                        explanationCard
                    }
                }
                .padding(.horizontal, Spacing.lg)
                .padding(.vertical, Spacing.lg)
            }
            
            // Navigation buttons
            navigationButtons
        }
        .navigationTitle(quiz.title)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Exit") {
                    dismiss()
                }
            }
        }
    }
    
    private var progressBar: some View {
        VStack(spacing: Spacing.sm) {
            HStack {
                Text("Question \(currentQuestionIndex + 1) of \(quiz.questions.count)")
                    .font(Typography.caption)
                    .foregroundColor(.textSecondary)

                Spacer()

                Text("\(Int(Double(selectedAnswers.filter { $0 != nil }.count) / Double(quiz.questions.count) * 100))% Complete")
                    .font(Typography.caption)
                    .foregroundColor(.textSecondary)
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.progressTrack)

                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.progressFill)
                        .frame(width: geometry.size.width * (Double(currentQuestionIndex + 1) / Double(quiz.questions.count)))
                        .animation(.smoothSpring, value: currentQuestionIndex)
                }
            }
            .frame(height: 6)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Quiz progress")
            .accessibilityValue("Question \(currentQuestionIndex + 1) of \(quiz.questions.count)")
        }
        .padding(.horizontal, Spacing.xl)
        .padding(.vertical, Spacing.md)
        .background(Color.surfaceSecondary)
    }

    private var questionCard: some View {
        let question = quiz.questions[currentQuestionIndex]

        return VStack(alignment: .leading, spacing: Spacing.md) {
            // Difficulty badge
            HStack {
                DifficultyBadge(difficulty: question.difficulty)
                Spacer()
            }

            // Question text
            Text(question.question)
                .font(Typography.title2)
                .foregroundColor(.textPrimary)
                .fixedSize(horizontal: false, vertical: true)

            // Related concepts
            if !question.relatedConcepts.isEmpty {
                HStack {
                    Image(systemName: "tag.fill")
                        .font(Typography.caption)
                        .foregroundColor(.textTertiary)
                        .accessibilityHidden(true)
                    ForEach(question.relatedConcepts.prefix(3), id: \.self) { concept in
                        Text(concept)
                            .font(Typography.caption)
                            .padding(.horizontal, Spacing.sm)
                            .padding(.vertical, 4)
                            .background(Color.brandPrimary.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.sm))
                    }
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Related concepts: \(question.relatedConcepts.prefix(3).joined(separator: ", "))")
            }
        }
        .padding(Spacing.lg)
        .background(Color.brandPrimary.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.lg))
        .accessibilityElement(children: .contain)
        .accessibilityLabel("\(question.difficulty.rawValue.capitalized) difficulty question")
    }
    
    private var optionsSection: some View {
        let question = quiz.questions[currentQuestionIndex]
        let currentAnswer = currentQuestionIndex < selectedAnswers.count ? selectedAnswers[currentQuestionIndex] : nil

        return VStack(spacing: 12) {
            ForEach(Array(question.options.enumerated()), id: \.offset) { index, option in
                OptionButton(
                    text: option,
                    index: index,
                    isSelected: currentAnswer == index,
                    isCorrect: index == question.correctAnswerIndex,
                    showResult: showingExplanation
                ) {
                    selectAnswer(index)
                }
            }
        }
    }
    
    private var explanationCard: some View {
        let question = quiz.questions[currentQuestionIndex]
        let currentAnswer = currentQuestionIndex < selectedAnswers.count ? selectedAnswers[currentQuestionIndex] : nil
        let selectedCorrectly = currentAnswer == question.correctAnswerIndex
        let correctOption = question.options[question.correctAnswerIndex]

        return VStack(alignment: .leading, spacing: Spacing.md) {
            // Always show the correct answer prominently
            HStack(spacing: Spacing.sm) {
                Image(systemName: "lightbulb.fill")
                    .font(.title2)
                    .foregroundColor(.brandHighlight)

                Text("The Answer")
                    .font(Typography.title3)
                    .foregroundColor(.textPrimary)
            }

            // Highlight the correct answer
            HStack(alignment: .top, spacing: Spacing.sm) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.success)
                    .font(.body)

                Text(correctOption)
                    .font(Typography.bodyMedium)
                    .foregroundColor(.textPrimary)
            }
            .padding(Spacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.success.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))

            Rectangle()
                .fill(Color.divider)
                .frame(height: 1)

            // Explanation section
            VStack(alignment: .leading, spacing: Spacing.sm) {
                Text("💡 Why?")
                    .font(Typography.bodyMedium)
                    .foregroundColor(.textPrimary)

                Text(question.explanation)
                    .font(Typography.body)
                    .foregroundColor(.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            // Gentle feedback (not pass/fail)
            if !selectedCorrectly {
                HStack(spacing: Spacing.xs) {
                    Image(systemName: "arrow.right.circle")
                        .foregroundColor(.info)
                    Text("Good effort! Review the explanation above.")
                        .font(Typography.caption)
                        .foregroundColor(.textTertiary)
                }
                .padding(.top, Spacing.xs)
            }
        }
        .padding(Spacing.lg)
        .background(Color.brandPrimary.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.lg))
        .transition(.calmFade)
    }
    
    private var navigationButtons: some View {
        HStack(spacing: Spacing.md) {
            if currentQuestionIndex > 0 {
                Button {
                    previousQuestion()
                } label: {
                    Label("Previous", systemImage: "chevron.left")
                        .font(Typography.bodyMedium)
                        .foregroundColor(.brandPrimary)
                        .padding(.horizontal, Spacing.lg)
                        .padding(.vertical, Spacing.sm)
                        .background(Color.brandPrimary.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
                }
                .buttonStyle(.plain)
            }

            Spacer()

            if showingExplanation {
                if currentQuestionIndex < quiz.questions.count - 1 {
                    Button {
                        nextQuestion()
                    } label: {
                        Label("Next", systemImage: "chevron.right")
                            .font(Typography.bodyMedium)
                            .foregroundColor(.white)
                            .padding(.horizontal, Spacing.lg)
                            .padding(.vertical, Spacing.sm)
                            .background(Color.brandPrimary)
                            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
                    }
                    .buttonStyle(.pressable)
                } else {
                    Button {
                        finishQuiz()
                    } label: {
                        Label("Finish Quiz", systemImage: "checkmark")
                            .font(Typography.bodyMedium)
                            .foregroundColor(.white)
                            .padding(.horizontal, Spacing.lg)
                            .padding(.vertical, Spacing.sm)
                            .background(Color.success)
                            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
                    }
                    .buttonStyle(.pressable)
                }
            } else if currentQuestionIndex < selectedAnswers.count && selectedAnswers[currentQuestionIndex] != nil {
                Button {
                    checkAnswer()
                } label: {
                    Text("Check Answer")
                        .font(Typography.bodyMedium)
                        .foregroundColor(.white)
                        .padding(.horizontal, Spacing.lg)
                        .padding(.vertical, Spacing.sm)
                        .background(Color.brandPrimary)
                        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
                }
                .buttonStyle(.pressable)
            }
        }
        .padding(Spacing.xl)
        .background(Color.surfaceSecondary)
    }
    
    // MARK: - Results View (Learning-Focused, Not Grading)
    private var resultsView: some View {
        ScrollView {
            VStack(spacing: Spacing.xl) {
                // Completion celebration
                VStack(spacing: Spacing.md) {
                    ZStack {
                        Circle()
                            .fill(Color.brandPrimary.opacity(0.1))
                            .frame(width: 120, height: 120)

                        Image(systemName: "sparkles")
                            .font(.system(size: 50))
                            .foregroundColor(.brandHighlight)
                    }

                    Text("Nice Work!")
                        .font(Typography.displaySmall)
                        .foregroundColor(.textPrimary)

                    Text("You've completed this knowledge check")
                        .font(Typography.body)
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .padding(Spacing.xl)
                .frame(maxWidth: .infinity)
                .background(Color.surfaceSecondary)
                .clipShape(RoundedRectangle(cornerRadius: CornerRadius.lg))

                // Learning summary (not scores)
                VStack(alignment: .leading, spacing: Spacing.md) {
                    HStack(spacing: Spacing.sm) {
                        Text("📚")
                            .font(.system(size: 20))
                        Text("What You Explored")
                            .font(Typography.title3)
                            .foregroundColor(.textPrimary)
                    }

                    // Show topics covered
                    let concepts = Set(quiz.questions.flatMap { $0.relatedConcepts })
                    if !concepts.isEmpty {
                        FlowLayout(spacing: Spacing.xs) {
                            ForEach(Array(concepts), id: \.self) { concept in
                                Text(concept)
                                    .font(Typography.caption)
                                    .padding(.horizontal, Spacing.sm)
                                    .padding(.vertical, 4)
                                    .background(Color.brandPrimary.opacity(0.1))
                                    .foregroundColor(.brandPrimary)
                                    .clipShape(Capsule())
                            }
                        }
                    }

                    Text("\(quiz.questions.count) questions reviewed")
                        .font(Typography.caption)
                        .foregroundColor(.textTertiary)
                }
                .padding(Spacing.lg)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.surfaceSecondary)
                .clipShape(RoundedRectangle(cornerRadius: CornerRadius.lg))

                // Review reminder
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    HStack(spacing: Spacing.sm) {
                        Image(systemName: "arrow.clockwise")
                            .foregroundColor(.info)
                        Text("Added to Review")
                            .font(Typography.bodyMedium)
                            .foregroundColor(.textPrimary)
                    }

                    Text("These concepts will appear in your review queue to help reinforce your learning over time.")
                        .font(Typography.caption)
                        .foregroundColor(.textSecondary)
                }
                .padding(Spacing.lg)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.info.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: CornerRadius.lg))

                // Action buttons
                VStack(spacing: Spacing.sm) {
                    Button {
                        retakeQuiz()
                    } label: {
                        Label("Review Again", systemImage: "arrow.clockwise")
                            .font(Typography.bodyMedium)
                            .foregroundColor(.brandPrimary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, Spacing.md)
                            .background(Color.brandPrimary.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
                    }
                    .buttonStyle(.pressable)

                    Button {
                        dismiss()
                    } label: {
                        Text("Continue Learning")
                            .font(Typography.bodyMedium)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, Spacing.md)
                            .background(Color.brandPrimary)
                            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
                    }
                    .buttonStyle(.pressable)
                }
            }
            .padding(Spacing.xl)
        }
        .background(Color.surfacePrimary)
        .navigationTitle("Complete")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
    
    // MARK: - Helper Functions
    private func initializeQuiz() {
        selectedAnswers = Array(repeating: nil, count: quiz.questions.count)
        isInitialized = true
    }
    
    private func selectAnswer(_ index: Int) {
        if !showingExplanation {
            selectedAnswers[currentQuestionIndex] = index
        }
    }
    
    private func checkAnswer() {
        withAnimation {
            showingExplanation = true
        }
    }
    
    private func nextQuestion() {
        withAnimation {
            showingExplanation = false
            currentQuestionIndex += 1
        }
    }
    
    private func previousQuestion() {
        withAnimation {
            showingExplanation = false
            currentQuestionIndex -= 1
        }
    }
    
    private func finishQuiz() {
        calculateScore()
        progressManager.recordQuizAttempt(quizId: quiz.id, score: score)

        // Add questions to spaced repetition review queue
        let answers: [(questionIndex: Int, wasCorrect: Bool)] = selectedAnswers.enumerated().compactMap { index, answer in
            guard let answer = answer else { return nil }
            let wasCorrect = answer == quiz.questions[index].correctAnswerIndex
            return (questionIndex: index, wasCorrect: wasCorrect)
        }
        reviewManager.addQuizQuestionsForReview(from: quiz, answers: answers, moduleId: moduleId)

        withAnimation {
            quizComplete = true
        }

        requestReviewIfAppropriate()
    }

    private func requestReviewIfAppropriate() {
        let quizCount = progressManager.progress.quizScores.count
        let highScore = score >= 0.7
        // Fire after the 3rd, 10th, and 25th completed quiz — only on good scores
        let milestones = [3, 10, 25]
        guard highScore, milestones.contains(quizCount) else { return }
        requestReview()
    }
    
    private func calculateScore() {
        let correct = selectedAnswers.enumerated().filter { index, answer in
            answer == quiz.questions[index].correctAnswerIndex
        }.count
        score = Double(correct) / Double(quiz.questions.count)
    }
    
    private var correctAnswers: Int {
        selectedAnswers.enumerated().filter { index, answer in
            answer == quiz.questions[index].correctAnswerIndex
        }.count
    }
    
    private func retakeQuiz() {
        isInitialized = false
        currentQuestionIndex = 0
        showingExplanation = false
        quizComplete = false
        score = 0
        // Re-initialize after state reset
        DispatchQueue.main.async {
            initializeQuiz()
        }
    }
}

// MARK: - Supporting Views
struct DifficultyBadge: View {
    let difficulty: QuizQuestion.Difficulty

    var body: some View {
        Text(difficulty.rawValue.capitalized)
            .font(Typography.captionMedium)
            .padding(.horizontal, Spacing.sm)
            .padding(.vertical, 4)
            .background(color.opacity(0.2))
            .foregroundColor(color)
            .clipShape(Capsule())
            .accessibilityLabel("Difficulty: \(difficulty.rawValue)")
    }

    private var color: Color {
        switch difficulty {
        case .beginner: return .success
        case .intermediate: return .warning
        case .advanced: return .error
        }
    }
}

struct OptionButton: View {
    let text: String
    let index: Int
    let isSelected: Bool
    let isCorrect: Bool
    let showResult: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(optionLabel)
                    .font(Typography.bodyMedium)
                    .foregroundColor(textColor)
                    .frame(width: 30)

                Text(text)
                    .font(Typography.body)
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.leading)

                Spacer()

                // Show checkmark on correct answer when revealing
                if showResult && isCorrect {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.success)
                } else if showResult && isSelected && !isCorrect {
                    // Show user's selection indicator (not an X mark)
                    Image(systemName: "circle.fill")
                        .foregroundColor(.textTertiary)
                        .font(.caption2)
                }
            }
            .padding(Spacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.md)
                    .stroke(borderColor, lineWidth: (isSelected || (showResult && isCorrect)) ? 2 : 1)
            )
        }
        .buttonStyle(.plain)
        .disabled(showResult)
        .accessibilityLabel("Option \(optionLabel): \(text)")
        .accessibilityValue(accessibilityState)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    private var accessibilityState: String {
        if showResult && isCorrect { return "Correct answer" }
        if showResult && isSelected && !isCorrect { return "Your answer, incorrect" }
        if isSelected { return "Selected" }
        return ""
    }

    private var optionLabel: String {
        ["A", "B", "C", "D", "E"][index]
    }

    private var backgroundColor: Color {
        // Always highlight the correct answer in green when showing results
        if showResult && isCorrect {
            return Color.success.opacity(0.1)
        }
        // Show user's selection subtly if it was wrong
        if showResult && isSelected && !isCorrect {
            return Color.surfaceTertiary.opacity(0.5)
        }
        return isSelected ? Color.brandPrimary.opacity(0.1) : Color.clear
    }

    private var borderColor: Color {
        // Always highlight correct answer
        if showResult && isCorrect {
            return .success
        }
        // Subtle indication of user's wrong selection
        if showResult && isSelected && !isCorrect {
            return Color.textTertiary.opacity(0.5)
        }
        return isSelected ? .brandPrimary : Color.divider
    }

    private var textColor: Color {
        if showResult && isCorrect {
            return .success
        }
        return isSelected ? .brandPrimary : .textSecondary
    }
}

struct QuizStatCard: View {
    let icon: String
    let color: Color
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: Spacing.sm) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(color)

            Text(value)
                .font(Typography.displaySmall)
                .foregroundColor(.textPrimary)

            Text(label)
                .font(Typography.caption)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(Spacing.lg)
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(label): \(value)")
    }
}

#Preview {
    let sampleQuiz = Quiz(
        id: "1",
        title: "Behavioral Economics Fundamentals",
        description: "Test your understanding of key concepts",
        questions: [
            QuizQuestion(
                id: "q1",
                question: "Which bias involves over-relying on the first piece of information received?",
                options: ["Anchoring Bias", "Confirmation Bias", "Recency Bias", "Availability Bias"],
                correctAnswerIndex: 0,
                explanation: "Anchoring bias occurs when we rely too heavily on the first piece of information offered when making decisions.",
                difficulty: .beginner,
                relatedConcepts: ["Anchoring", "Cognitive Bias"]
            )
        ],
        passingScore: 0.7
    )
    
    return QuizView(quiz: sampleQuiz, moduleId: "mod1")
        .environmentObject(ProgressManager())
        .environmentObject(ReviewManager())
}
