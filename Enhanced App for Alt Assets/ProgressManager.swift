//
//  ProgressManager.swift
//  Enhanced App for Alt Assets
//
//  Created by Victoria Case on 2/1/26.
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//
//  Description: Manages user progress tracking including session management,
//  completion status, quiz scores, reflection entries, time spent, and learning
//  insights. Persists data to UserDefaults.
//

import Foundation
import Combine

class ProgressManager: ObservableObject {
    @Published var progress: UserProgress
    @Published var currentSession: LearningSession?
    @Published var insights: LearningInsights
    
    private let userDefaultsKey = "user_progress"
    private let insightsKey = "learning_insights"
    private var sessionTimer: Timer?
    
    init() {
        // Load saved progress
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decoded = try? JSONDecoder().decode(UserProgress.self, from: data) {
            self.progress = decoded
        } else {
            self.progress = UserProgress()
        }
        
        // Load insights
        if let data = UserDefaults.standard.data(forKey: insightsKey),
           let decoded = try? JSONDecoder().decode(LearningInsights.self, from: data) {
            self.insights = decoded
        } else {
            self.insights = LearningInsights()
        }
    }
    
    // MARK: - Session Management
    func startSession(moduleId: String) {
        currentSession = LearningSession(
            id: UUID().uuidString,
            moduleId: moduleId,
            startTime: Date()
        )
        
        progress.updateLastAccessed(moduleId)
        save()
        
        // Start tracking time
        sessionTimer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { [weak self] _ in
            self?.recordSessionProgress()
        }
    }
    
    func endSession() {
        guard var session = currentSession else { return }
        session.endTime = Date()
        
        if let duration = session.duration {
            progress.recordTimeSpent(session.moduleId, seconds: duration)
        }
        
        currentSession = nil
        sessionTimer?.invalidate()
        sessionTimer = nil
        
        updateInsights()
        save()
    }
    
    private func recordSessionProgress() {
        guard let session = currentSession else { return }
        // Record only 60 seconds (the timer interval), not the full elapsed time
        // This prevents exponential time growth
        progress.recordTimeSpent(session.moduleId, seconds: 60)
        save()
    }
    
    // MARK: - Progress Tracking
    func markSectionComplete(_ sectionId: String) {
        progress.markSectionComplete(sectionId)
        currentSession?.sectionsVisited.append(sectionId)
        save()
    }
    
    func markModuleComplete(_ moduleId: String) {
        progress.markModuleComplete(moduleId)
        save()
    }
    
    func recordQuizAttempt(quizId: String, score: Double) {
        progress.recordQuizScore(quizId, score: score)
        currentSession?.quizzesTaken += 1
        updateInsights()
        save()
    }
    
    func saveReflection(promptId: String, moduleId: String, sectionId: String?, content: String) {
        let entry = ReflectionEntry(
            promptId: promptId,
            moduleId: moduleId,
            sectionId: sectionId,
            content: content
        )
        progress.addReflection(entry)
        currentSession?.reflectionsWritten += 1
        updateInsights()
        save()
    }
    
    func unlockKnowledgeNode(_ nodeId: String) {
        progress.unlockNode(nodeId)
        save()
    }
    
    // MARK: - Insights Generation
    private func updateInsights() {
        // Analyze quiz performance
        analyzeQuizPerformance()
        
        // Determine learning style
        determineLearningStyle()
        
        // Generate recommendations
        generateRecommendations()
        
        saveInsights()
    }
    
    private func analyzeQuizPerformance() {
        var strong: [String] = []
        var needsReview: [String] = []
        
        for (quizId, score) in progress.quizScores {
            if score >= 0.85 {
                strong.append(quizId)
            } else if score < 0.7 {
                needsReview.append(quizId)
            }
        }
        
        insights.strongTopics = strong
        insights.needsReview = needsReview
    }
    
    private func determineLearningStyle() {
        let avgQuizScore = progress.averageQuizScore
        let reflectionCount = progress.totalReflectionsWritten
        let timeSpentTotal = progress.totalTimeSpent
        
        // Simple heuristics for learning style
        if reflectionCount > 10 && timeSpentTotal > 3600 {
            insights.learningStyle = .reflective
        } else if avgQuizScore > 0.85 && progress.totalModulesCompleted > 3 {
            insights.learningStyle = .analytical
        } else {
            insights.learningStyle = .balanced
        }
    }
    
    private func generateRecommendations() {
        // All available module IDs
        let allModules = [
            "mod_women", "mod_alt", "mod_behavioral", "mod_gender",
            "mod_defi", "mod_art", "mod_esg_climate", "mod_defi_investing",
            "mod_kahlo_basquiat"
        ]

        // Module relationships: completing one module suggests related ones
        let relationships: [String: [String]] = [
            "mod_alt": ["mod_defi_investing", "mod_art", "mod_esg_climate"],
            "mod_defi": ["mod_defi_investing", "mod_behavioral"],
            "mod_defi_investing": ["mod_defi", "mod_esg_climate", "mod_alt"],
            "mod_art": ["mod_kahlo_basquiat", "mod_alt", "mod_women"],
            "mod_behavioral": ["mod_defi_investing", "mod_gender"],
            "mod_women": ["mod_gender", "mod_art"],
            "mod_gender": ["mod_women", "mod_behavioral"],
            "mod_esg_climate": ["mod_alt", "mod_defi_investing"],
            "mod_kahlo_basquiat": ["mod_art", "mod_women"]
        ]

        let completedSet = progress.completedModules
        var suggested: [String] = []

        // First: suggest related modules based on what the user has completed
        for completed in completedSet {
            if let related = relationships[completed] {
                for moduleId in related where !completedSet.contains(moduleId) && !suggested.contains(moduleId) {
                    suggested.append(moduleId)
                }
            }
        }

        // Then: fill remaining slots with any uncompleted modules
        if suggested.count < 3 {
            for moduleId in allModules where !completedSet.contains(moduleId) && !suggested.contains(moduleId) {
                suggested.append(moduleId)
                if suggested.count >= 3 { break }
            }
        }

        insights.suggestedNext = Array(suggested.prefix(3))
    }
    
    // MARK: - Queries
    func getReflections(for moduleId: String) -> [ReflectionEntry] {
        progress.reflectionEntries.filter { $0.moduleId == moduleId }
    }
    
    func getReflection(for promptId: String) -> ReflectionEntry? {
        progress.reflectionEntries.first { $0.promptId == promptId }
    }
    
    func isModuleComplete(_ moduleId: String) -> Bool {
        progress.completedModules.contains(moduleId)
    }
    
    func isSectionComplete(_ sectionId: String) -> Bool {
        progress.completedSections.contains(sectionId)
    }
    
    func getQuizScore(_ quizId: String) -> Double? {
        progress.quizScores[quizId]
    }
    
    func getTimeSpent(_ moduleId: String) -> TimeInterval {
        progress.timeSpent[moduleId] ?? 0
    }
    
    // MARK: - Persistence
    private func save() {
        if let encoded = try? JSONEncoder().encode(progress) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    private func saveInsights() {
        if let encoded = try? JSONEncoder().encode(insights) {
            UserDefaults.standard.set(encoded, forKey: insightsKey)
        }
    }
    
    // MARK: - Reset
    func resetProgress() {
        progress = UserProgress()
        insights = LearningInsights()
        save()
        saveInsights()

        // Clear all other app state from UserDefaults
        let keysToRemove = [
            "spaced_repetition_state",
            "userEmail",
            "has_completed_onboarding",
            "has_accepted_terms_of_use"
        ]
        keysToRemove.forEach { UserDefaults.standard.removeObject(forKey: $0) }

        // Clear advisor question asked-state keys (prefixed with "asked_questions_")
        let allKeys = UserDefaults.standard.dictionaryRepresentation().keys
        allKeys.filter { $0.hasPrefix("asked_questions_") }.forEach {
            UserDefaults.standard.removeObject(forKey: $0)
        }
    }

    /// Reset only time tracking data (useful if data became corrupted)
    func resetTimeTracking() {
        progress.timeSpent = [:]
        save()
    }
}
