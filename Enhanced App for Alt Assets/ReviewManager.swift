//
//  ReviewManager.swift
//  Enhanced App for Alt Assets
//
//  Created by Victoria Case on 2/4/26.
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//
//  Description: Manages spaced repetition review queue and scheduling.
//  Tracks daily goals, streaks, and integrates with quiz completion to
//  automatically add items for review.
//

import Foundation
import Combine
import WidgetKit

class ReviewManager: ObservableObject {
    @Published var state: SpacedRepetitionState
    @Published var currentSession: ReviewSession?
    @Published var stats: RetentionStats
    @Published var pendingMilestone: Int?

    static let masteryThresholds = [10, 25, 50, 100]

    private let storageKey = "spaced_repetition_state"
    private var cancellables = Set<AnyCancellable>()

    init() {
        // Load saved state
        let loadedState: SpacedRepetitionState
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode(SpacedRepetitionState.self, from: data) {
            loadedState = decoded
        } else {
            loadedState = SpacedRepetitionState()
        }

        // Initialize all stored properties first
        self.state = loadedState
        self.stats = SpacedRepetitionEngine.calculateRetentionStats(
            items: loadedState.reviewItems,
            history: loadedState.reviewHistory
        )

        // Check for daily reset after initialization
        checkDailyReset()
    }

    // MARK: - Review Queries

    /// Items due for review today
    var itemsDueToday: [ReviewItem] {
        SpacedRepetitionEngine.getItemsDueForReview(from: state.reviewItems)
    }

    /// Count of items due for review
    var reviewsDueCount: Int {
        itemsDueToday.count
    }

    /// Progress toward daily goal (0.0 to 1.0)
    var todaysProgress: Double {
        state.todaysProgress
    }

    /// Items coming up in the next 7 days
    var upcomingItems: [ReviewItem] {
        SpacedRepetitionEngine.getUpcomingItems(from: state.reviewItems)
    }

    /// Whether the user has any items to review
    var hasItemsToReview: Bool {
        reviewsDueCount > 0
    }

    // MARK: - Review Actions

    /// Add a new item to the review queue
    func addItemForReview(_ item: ReviewItem) {
        // Check for duplicates
        guard !state.reviewItems.contains(where: { $0.sourceId == item.sourceId && $0.itemType == item.itemType }) else {
            return
        }
        state.reviewItems.append(item)
        updateStats()
        save()
    }

    /// Add multiple items from a quiz attempt
    func addQuizQuestionsForReview(
        from quiz: Quiz,
        answers: [(questionIndex: Int, wasCorrect: Bool)],
        moduleId: String
    ) {
        for (index, wasCorrect) in answers {
            let question = quiz.questions[index]

            // Only add if not already in review queue
            if !state.reviewItems.contains(where: { $0.sourceId == question.id }) {
                let item = SpacedRepetitionEngine.createFromQuizQuestion(
                    questionId: question.id,
                    moduleId: moduleId,
                    wasCorrect: wasCorrect
                )
                state.reviewItems.append(item)
            }
        }
        updateStats()
        save()
    }

    /// Record a review response and update the item
    func recordReview(
        itemId: String,
        quality: SpacedRepetitionEngine.Quality,
        responseTime: TimeInterval
    ) {
        guard let index = state.reviewItems.firstIndex(where: { $0.id == itemId }) else {
            return
        }

        // Update item with new review data
        state.reviewItems[index] = SpacedRepetitionEngine.calculateNextReview(
            item: state.reviewItems[index],
            quality: quality
        )

        // Record in history
        let response = ReviewResponse(
            itemId: itemId,
            quality: quality.rawValue,
            responseTime: responseTime
        )
        state.reviewHistory.append(response)
        state.todaysReviewCount += 1

        // Update streak
        updateStreak()
        updateStats()
        save()
    }

    /// Start a new review session
    func startReviewSession(itemCount: Int? = nil) -> ReviewSession {
        let limit = itemCount ?? state.dailyReviewGoal
        let items = Array(itemsDueToday.prefix(limit))
        let session = ReviewSession(items: items)
        currentSession = session
        return session
    }

    /// End the current review session
    func endReviewSession() {
        currentSession = nil
    }

    /// Remove an item from the review queue
    func removeItem(_ itemId: String) {
        state.reviewItems.removeAll { $0.id == itemId }
        updateStats()
        save()
    }

    /// Remove all items for a specific module
    func removeItemsForModule(_ moduleId: String) {
        state.reviewItems.removeAll { $0.moduleId == moduleId }
        updateStats()
        save()
    }

    // MARK: - Settings

    /// Update the daily review goal
    func setDailyGoal(_ goal: Int) {
        state.dailyReviewGoal = max(1, min(100, goal))
        save()
    }

    /// Reset all review data (use with caution!)
    func resetAllData() {
        state = SpacedRepetitionState()
        currentSession = nil
        updateStats()
        save()
    }

    // MARK: - Streak Management

    private func updateStreak() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        if let lastReset = state.lastDailyReset {
            let lastResetDay = calendar.startOfDay(for: lastReset)
            let daysDiff = calendar.dateComponents([.day], from: lastResetDay, to: today).day ?? 0

            if daysDiff == 1 {
                // Consecutive day - increment streak
                state.streak += 1
                state.longestStreak = max(state.streak, state.longestStreak)
            } else if daysDiff > 1 {
                // Missed a day - reset streak
                state.streak = 1
            }
            // Same day - no change to streak
        } else {
            // First ever review
            state.streak = 1
            state.longestStreak = 1
        }

        state.lastDailyReset = today
    }

    private func checkDailyReset() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        if let lastReset = state.lastDailyReset {
            let lastResetDay = calendar.startOfDay(for: lastReset)

            if lastResetDay < today {
                // New day - reset today's count but check streak
                let daysDiff = calendar.dateComponents([.day], from: lastResetDay, to: today).day ?? 0

                if daysDiff > 1 && state.todaysReviewCount == 0 {
                    // Missed yesterday with no reviews - reset streak
                    state.streak = 0
                }

                state.todaysReviewCount = 0
                state.lastDailyReset = today
                save()
            }
        }
    }

    // MARK: - Mastery Milestones

    func acknowledgeMilestone(_ count: Int) {
        state.acknowledgedMilestones.insert(count)
        pendingMilestone = nil
        save()
    }

    private func checkMasteryMilestone() {
        let current = stats.matureItems
        let crossed = Self.masteryThresholds.filter {
            current >= $0 && !state.acknowledgedMilestones.contains($0)
        }
        if let highest = crossed.max(), pendingMilestone == nil {
            pendingMilestone = highest
        }
    }

    // MARK: - Statistics

    private func updateStats() {
        stats = SpacedRepetitionEngine.calculateRetentionStats(
            items: state.reviewItems,
            history: state.reviewHistory
        )
        checkMasteryMilestone()
    }

    /// Get items grouped by module
    func itemsByModule() -> [String: [ReviewItem]] {
        Dictionary(grouping: state.reviewItems) { $0.moduleId }
    }

    /// Get items by difficulty (ease factor)
    func getItemsByDifficulty() -> (hard: [ReviewItem], medium: [ReviewItem], easy: [ReviewItem]) {
        let hard = state.reviewItems.filter { $0.easeFactor < 2.0 }
        let medium = state.reviewItems.filter { $0.easeFactor >= 2.0 && $0.easeFactor < 2.5 }
        let easy = state.reviewItems.filter { $0.easeFactor >= 2.5 }
        return (hard, medium, easy)
    }

    // MARK: - Persistence

    private let appGroupID = "group.com.alternativeassetliteracy.altsapp"
    private let sharedStorageKey = "spaced_repetition_state_shared"

    private func save() {
        if let encoded = try? JSONEncoder().encode(state) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
            // Mirror to shared App Group so the widget can read it
            UserDefaults(suiteName: appGroupID)?.set(encoded, forKey: sharedStorageKey)
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}

// MARK: - Preview Helper
extension ReviewManager {
    /// Create a manager with sample data for previews
    static var preview: ReviewManager {
        let manager = ReviewManager()

        // Add some sample items
        let sampleItems = [
            ReviewItem(itemType: .quizQuestion, sourceId: "q1", moduleId: "m1"),
            ReviewItem(itemType: .quizQuestion, sourceId: "q2", moduleId: "m1", wasCorrectOnFirstAttempt: false),
            ReviewItem(itemType: .glossaryTerm, sourceId: "g1", moduleId: "m1"),
        ]

        for item in sampleItems {
            manager.addItemForReview(item)
        }

        return manager
    }
}
