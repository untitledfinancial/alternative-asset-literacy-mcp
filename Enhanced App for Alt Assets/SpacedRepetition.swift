//
//  SpacedRepetition.swift
//  Enhanced App for Alt Assets
//
//  Created by Victoria Case on 2/4/26.
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//
//  Description: Spaced repetition system using the SM-2 algorithm for optimal
//  learning retention. Manages review scheduling, tracks item difficulty, and
//  provides intelligent review queues based on user performance.
//

import Foundation

// MARK: - Review Item
/// An individual item being tracked for spaced repetition review
struct ReviewItem: Identifiable, Codable, Hashable {
    let id: String
    var itemType: ItemType
    var sourceId: String                // Quiz question ID, glossary term ID, etc.
    var moduleId: String                // Which module this item belongs to
    var createdAt: Date
    var lastReviewedAt: Date?
    var nextReviewDate: Date
    var easeFactor: Double              // SM-2 ease factor (starts at 2.5, min 1.3)
    var interval: Int                   // Days until next review
    var repetitions: Int                // Number of successful consecutive reviews
    var lapses: Int                     // Number of times forgotten (quality < 3)

    enum ItemType: String, Codable, Hashable {
        case quizQuestion
        case glossaryTerm
        case concept
        case caseStudy

        var displayName: String {
            switch self {
            case .quizQuestion: return "Quiz Question"
            case .glossaryTerm: return "Glossary Term"
            case .concept: return "Concept"
            case .caseStudy: return "Case Study"
            }
        }

        var icon: String {
            switch self {
            case .quizQuestion: return "questionmark.circle"
            case .glossaryTerm: return "book"
            case .concept: return "lightbulb"
            case .caseStudy: return "doc.text"
            }
        }
    }

    /// Create a new review item
    init(
        itemType: ItemType,
        sourceId: String,
        moduleId: String,
        wasCorrectOnFirstAttempt: Bool = true
    ) {
        self.id = UUID().uuidString
        self.itemType = itemType
        self.sourceId = sourceId
        self.moduleId = moduleId
        self.createdAt = Date()
        self.lastReviewedAt = nil
        self.easeFactor = 2.5
        self.repetitions = 0
        self.lapses = wasCorrectOnFirstAttempt ? 0 : 1
        self.interval = wasCorrectOnFirstAttempt ? 1 : 0

        // Set initial next review date
        self.nextReviewDate = Calendar.current.date(
            byAdding: .day,
            value: self.interval,
            to: Date()
        ) ?? Date()
    }
}

// MARK: - Review Response
/// Records a single review attempt
struct ReviewResponse: Codable, Hashable {
    let itemId: String
    let quality: Int                    // 0-5 rating (SM-2 standard)
    let responseTime: TimeInterval      // How long user took to respond
    let timestamp: Date
    let wasCorrect: Bool

    init(itemId: String, quality: Int, responseTime: TimeInterval) {
        self.itemId = itemId
        self.quality = quality
        self.responseTime = responseTime
        self.timestamp = Date()
        self.wasCorrect = quality >= 3
    }
}

// MARK: - Spaced Repetition State
/// User's overall spaced repetition state
struct SpacedRepetitionState: Codable {
    var reviewItems: [ReviewItem]
    var reviewHistory: [ReviewResponse]
    var dailyReviewGoal: Int
    var lastDailyReset: Date?
    var todaysReviewCount: Int
    var streak: Int
    var longestStreak: Int
    var acknowledgedMilestones: Set<Int>

    init() {
        self.reviewItems = []
        self.reviewHistory = []
        self.dailyReviewGoal = 10
        self.lastDailyReset = nil
        self.todaysReviewCount = 0
        self.streak = 0
        self.longestStreak = 0
        self.acknowledgedMilestones = []
    }

    // Computed properties
    var totalItemsToReview: Int {
        reviewItems.filter { $0.nextReviewDate <= Date() }.count
    }

    var todaysProgress: Double {
        guard dailyReviewGoal > 0 else { return 0 }
        return min(1.0, Double(todaysReviewCount) / Double(dailyReviewGoal))
    }

    var averageEaseFactor: Double {
        guard !reviewItems.isEmpty else { return 2.5 }
        return reviewItems.reduce(0) { $0 + $1.easeFactor } / Double(reviewItems.count)
    }
}

// MARK: - SM-2 Algorithm
/// Implementation of the SuperMemo SM-2 spaced repetition algorithm
struct SpacedRepetitionEngine {

    /// Quality ratings for SM-2 algorithm
    enum Quality: Int, CaseIterable {
        case completeBlackout = 0       // Total failure to recall
        case incorrect = 1               // Incorrect, but upon seeing answer, remembered
        case incorrectEasyRecall = 2     // Incorrect, but easy to recall after seeing
        case correctDifficult = 3        // Correct, but with serious difficulty
        case correctHesitation = 4       // Correct, after some hesitation
        case perfectRecall = 5           // Perfect recall

        var displayName: String {
            switch self {
            case .completeBlackout: return "Forgot"
            case .incorrect: return "Wrong"
            case .incorrectEasyRecall: return "Almost"
            case .correctDifficult: return "Hard"
            case .correctHesitation: return "Good"
            case .perfectRecall: return "Easy"
            }
        }

        var color: String {
            switch self {
            case .completeBlackout, .incorrect: return "error"
            case .incorrectEasyRecall: return "warning"
            case .correctDifficult: return "info"
            case .correctHesitation: return "success"
            case .perfectRecall: return "success"
            }
        }

        var isCorrect: Bool {
            self.rawValue >= 3
        }
    }

    /// Calculate next review based on SM-2 algorithm
    /// - Parameters:
    ///   - item: The review item to update
    ///   - quality: User's self-assessed quality of recall (0-5)
    /// - Returns: Updated review item with new scheduling
    static func calculateNextReview(
        item: ReviewItem,
        quality: Quality
    ) -> ReviewItem {
        var updated = item
        let q = Double(quality.rawValue)

        if quality.rawValue >= 3 {
            // Successful recall
            switch updated.repetitions {
            case 0:
                updated.interval = 1
            case 1:
                updated.interval = 6
            default:
                updated.interval = Int(round(Double(updated.interval) * updated.easeFactor))
            }
            updated.repetitions += 1
        } else {
            // Failed recall - reset
            updated.repetitions = 0
            updated.interval = 1
            updated.lapses += 1
        }

        // Update ease factor using SM-2 formula
        // EF' = EF + (0.1 - (5-q) * (0.08 + (5-q) * 0.02))
        let efModifier = 0.1 - (5.0 - q) * (0.08 + (5.0 - q) * 0.02)
        updated.easeFactor = max(1.3, updated.easeFactor + efModifier)

        // Calculate next review date
        updated.lastReviewedAt = Date()
        updated.nextReviewDate = Calendar.current.date(
            byAdding: .day,
            value: updated.interval,
            to: Date()
        ) ?? Date()

        return updated
    }

    /// Get items due for review today, sorted by priority
    /// - Parameters:
    ///   - items: All review items
    ///   - limit: Maximum number of items to return
    /// - Returns: Array of items due for review
    static func getItemsDueForReview(
        from items: [ReviewItem],
        limit: Int = 20
    ) -> [ReviewItem] {
        let now = Date()
        return items
            .filter { $0.nextReviewDate <= now }
            .sorted { item1, item2 in
                // Priority: overdue items first, then by ease factor (harder first)
                if item1.nextReviewDate != item2.nextReviewDate {
                    return item1.nextReviewDate < item2.nextReviewDate
                }
                return item1.easeFactor < item2.easeFactor
            }
            .prefix(limit)
            .map { $0 }
    }

    /// Get items that will be due soon (for preview)
    /// - Parameters:
    ///   - items: All review items
    ///   - days: Number of days to look ahead
    /// - Returns: Array of items due within the specified days
    static func getUpcomingItems(
        from items: [ReviewItem],
        days: Int = 7
    ) -> [ReviewItem] {
        let futureDate = Calendar.current.date(byAdding: .day, value: days, to: Date()) ?? Date()
        let now = Date()

        return items
            .filter { $0.nextReviewDate > now && $0.nextReviewDate <= futureDate }
            .sorted { $0.nextReviewDate < $1.nextReviewDate }
    }

    /// Create a review item from a quiz question
    static func createFromQuizQuestion(
        questionId: String,
        moduleId: String,
        wasCorrect: Bool
    ) -> ReviewItem {
        ReviewItem(
            itemType: .quizQuestion,
            sourceId: questionId,
            moduleId: moduleId,
            wasCorrectOnFirstAttempt: wasCorrect
        )
    }

    /// Create a review item from a glossary term
    static func createFromGlossaryTerm(
        termId: String,
        moduleId: String
    ) -> ReviewItem {
        ReviewItem(
            itemType: .glossaryTerm,
            sourceId: termId,
            moduleId: moduleId
        )
    }

    /// Calculate retention statistics
    static func calculateRetentionStats(
        items: [ReviewItem],
        history: [ReviewResponse]
    ) -> RetentionStats {
        let totalReviews = history.count
        let correctReviews = history.filter { $0.wasCorrect }.count
        let retentionRate = totalReviews > 0 ? Double(correctReviews) / Double(totalReviews) : 0

        let matureItems = items.filter { $0.interval >= 21 }.count
        let youngItems = items.filter { $0.interval < 21 && $0.repetitions > 0 }.count
        let newItems = items.filter { $0.repetitions == 0 }.count

        let avgInterval = items.isEmpty ? 0 : items.reduce(0) { $0 + $1.interval } / items.count

        return RetentionStats(
            totalItems: items.count,
            matureItems: matureItems,
            youngItems: youngItems,
            newItems: newItems,
            retentionRate: retentionRate,
            averageInterval: avgInterval,
            totalReviews: totalReviews
        )
    }
}

// MARK: - Retention Statistics
/// Statistics about the user's retention and review performance
struct RetentionStats: Codable {
    let totalItems: Int
    let matureItems: Int                // Items with interval >= 21 days
    let youngItems: Int                 // Items with 0 < interval < 21 days
    let newItems: Int                   // Items never reviewed
    let retentionRate: Double           // Percentage of correct reviews
    let averageInterval: Int            // Average days between reviews
    let totalReviews: Int               // Total number of reviews completed

    var maturityPercentage: Double {
        guard totalItems > 0 else { return 0 }
        return Double(matureItems) / Double(totalItems)
    }
}

// MARK: - Review Session
/// Represents an active review session
struct ReviewSession: Identifiable {
    let id: String
    var items: [ReviewItem]
    var currentIndex: Int
    var responses: [ReviewResponse]
    var startTime: Date
    var endTime: Date?

    init(items: [ReviewItem]) {
        self.id = UUID().uuidString
        self.items = items
        self.currentIndex = 0
        self.responses = []
        self.startTime = Date()
        self.endTime = nil
    }

    var currentItem: ReviewItem? {
        guard currentIndex < items.count else { return nil }
        return items[currentIndex]
    }

    var isComplete: Bool {
        currentIndex >= items.count
    }

    var progress: Double {
        guard !items.isEmpty else { return 0 }
        return Double(currentIndex) / Double(items.count)
    }

    var correctCount: Int {
        responses.filter { $0.wasCorrect }.count
    }

    var incorrectCount: Int {
        responses.filter { !$0.wasCorrect }.count
    }

    var sessionDuration: TimeInterval {
        let end = endTime ?? Date()
        return end.timeIntervalSince(startTime)
    }

    mutating func recordResponse(quality: SpacedRepetitionEngine.Quality, responseTime: TimeInterval) {
        guard let item = currentItem else { return }

        let response = ReviewResponse(
            itemId: item.id,
            quality: quality.rawValue,
            responseTime: responseTime
        )
        responses.append(response)
        currentIndex += 1

        if isComplete {
            endTime = Date()
        }
    }
}
