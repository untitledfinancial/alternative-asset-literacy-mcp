//
//  UserProgress.swift
//  Enhanced App for Alt Assets
//
//  Created by Victoria Case on 2/1/26.
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//
//  Description: Tracks user progress through modules including completed sections,
//  quiz scores, reflection entries, time spent, and learning insights. Manages
//  the user's learning journey and provides analytics.
//

import Foundation

// MARK: - User Progress
struct UserProgress: Codable {
    var completedModules: Set<String> = []
    var completedSections: Set<String> = []
    var completedQuizzes: Set<String> = []
    var quizScores: [String: Double] = [:] // Quiz ID -> Score
    var timeSpent: [String: TimeInterval] = [:] // Module ID -> Seconds
    var unlockedNodes: Set<String> = []
    var reflectionEntries: [ReflectionEntry] = []
    var lastAccessed: [String: Date] = [:] // Module ID -> Last access date
    var learningPath: [String] = [] // Ordered module IDs showing progression
    
    // Computed properties
    var totalModulesCompleted: Int { completedModules.count }
    var totalSectionsExplored: Int { completedSections.count }
    var totalReflectionsWritten: Int { reflectionEntries.count }
    var totalQuizzesPassed: Int { completedQuizzes.count }
    
    var averageQuizScore: Double {
        guard !quizScores.isEmpty else { return 0 }
        return quizScores.values.reduce(0, +) / Double(quizScores.count)
    }
    
    var totalTimeSpent: TimeInterval {
        timeSpent.values.reduce(0, +)
    }
    
    // Progress tracking methods
    mutating func markModuleComplete(_ moduleId: String) {
        completedModules.insert(moduleId)
    }
    
    mutating func markSectionComplete(_ sectionId: String) {
        completedSections.insert(sectionId)
    }
    
    mutating func recordQuizScore(_ quizId: String, score: Double) {
        quizScores[quizId] = score
        if score >= 0.7 { // 70% passing score
            completedQuizzes.insert(quizId)
        }
    }
    
    mutating func addReflection(_ entry: ReflectionEntry) {
        reflectionEntries.append(entry)
    }
    
    mutating func recordTimeSpent(_ moduleId: String, seconds: TimeInterval) {
        timeSpent[moduleId, default: 0] += seconds
    }
    
    mutating func unlockNode(_ nodeId: String) {
        unlockedNodes.insert(nodeId)
    }
    
    mutating func updateLastAccessed(_ moduleId: String) {
        lastAccessed[moduleId] = Date()
    }
}

// MARK: - Reflection Entry
struct ReflectionEntry: Identifiable, Codable, Hashable {
    let id: String
    var promptId: String
    var moduleId: String
    var sectionId: String?
    var content: String
    var createdAt: Date
    var updatedAt: Date
    
    init(promptId: String, moduleId: String, sectionId: String? = nil, content: String) {
        self.id = UUID().uuidString
        self.promptId = promptId
        self.moduleId = moduleId
        self.sectionId = sectionId
        self.content = content
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

// MARK: - Learning Insights
struct LearningInsights: Codable {
    var strongTopics: [String] = [] // Topics with high quiz scores
    var needsReview: [String] = [] // Topics with low quiz scores
    var suggestedNext: [String] = [] // Recommended module IDs
    var learningStyle: LearningStyle = .balanced

    enum LearningStyle: String, Codable {
        case visual // Spends more time on visual content
        case reflective // Writes detailed reflections
        case analytical // High quiz scores, quick progression
        case balanced
    }
}

// MARK: - Session Tracking
struct LearningSession: Identifiable, Codable {
    let id: String
    var moduleId: String
    var startTime: Date
    var endTime: Date?
    var sectionsVisited: [String] = []
    var reflectionsWritten: Int = 0
    var quizzesTaken: Int = 0
    
    var duration: TimeInterval? {
        guard let end = endTime else { return nil }
        return end.timeIntervalSince(startTime)
    }
}
