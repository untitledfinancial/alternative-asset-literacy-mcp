//
//  Module.swift
//  Enhanced App for Alt Assets
//
//  Created by Victoria Case on 2/1/26.
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//
//  Description: Core data models for educational modules, sections, content blocks,
//  reflection prompts, quizzes, case studies, knowledge nodes, and learning paths.
//  Defines the structure of the learning content throughout the app.
//

import Foundation

// MARK: - Module
struct Module: Identifiable, Codable, Hashable {
    let id: String
    var title: String
    var description: String
    var icon: String
    var color: String
    var heroImageName: String?  // Asset catalog image name for module cover
    var sections: [Section]
    var reflectionPrompts: [ReflectionPrompt] = []
    var quizzes: [Quiz] = []
    var caseStudies: [CaseStudy] = []
    var estimatedTime: Int = 30 // minutes
    var tags: [String] = []
    var parentModuleId: String?  // If this is a sub-module, reference parent module
    var isBonus: Bool = false     // Whether this is a bonus/supplemental module
    var releaseDate: Date?        // Set to surface a "New" badge within 30 days of release

    // Computed properties
    var totalSections: Int { sections.count }
    var totalQuizQuestions: Int { quizzes.reduce(0) { $0 + $1.questions.count } }
    var isSubModule: Bool { parentModuleId != nil }
    var isNewRelease: Bool {
        guard let date = releaseDate else { return false }
        let days = Calendar.current.dateComponents([.day], from: date, to: Date()).day ?? 0
        return days >= 0 && days <= 30
    }
}

// MARK: - Section
struct Section: Identifiable, Codable, Hashable {
    let id: String
    var title: String
    var content: [ContentBlock]
    var isCollapsible: Bool = false
    var level: Int = 2 // H2 = 2, H3 = 3, etc.
    var reflectionPrompts: [String] = [] // IDs of reflection prompts
    var glossaryTerms: [String] = [] // Terms referenced in this section
    var relatedResearch: [String] = [] // Research article IDs
}

// MARK: - Content Block
enum ContentBlock: Identifiable, Codable, Hashable {
    case text(String)
    case heading(String, level: Int)
    case callout(title: String, content: String, type: CalloutType)
    case bulletList([String])
    case numberedList([String])
    case quote(String, author: String?)
    case image(url: String, caption: String?)
    case divider

    // New enhanced content types
    case keyFact(emoji: String, title: String, value: String, source: String?)
    case statistic(value: String, label: String, context: String?)
    case table(headers: [String], rows: [[String]], caption: String?)
    case columnLayout(columns: [ColumnContent])
    case artworkCard(artist: String, title: String, year: String?, salePrice: String?, auctionHouse: String?, saleDate: String?)
    case comparisonTable(title: String, items: [ComparisonItem])
    case reflection(prompt: String, context: String?)
    case toggleBlock(title: String, content: String)
    case database(title: String, entries: [DatabaseEntry], groupKey: String?)
    case spacer(height: SpacerHeight)
    case localWebView(filename: String, title: String, caption: String?)
    case localImage(name: String, caption: String?)

    var id: String {
        switch self {
        case .text(let content): return "text_\(content.prefix(20).hashValue)"
        case .heading(let title, _): return "heading_\(title.hashValue)"
        case .callout(let title, _, _): return "callout_\(title.hashValue)"
        case .bulletList(let items): return "bullet_\(items.first?.hashValue ?? 0)"
        case .numberedList(let items): return "numbered_\(items.first?.hashValue ?? 0)"
        case .quote(let text, _): return "quote_\(text.hashValue)"
        case .image(let url, _): return "image_\(url.hashValue)"
        case .divider: return "divider_\(UUID().uuidString)"
        case .keyFact(_, let title, _, _): return "keyfact_\(title.hashValue)"
        case .statistic(let value, let label, _): return "stat_\(value)_\(label)".hashValue.description
        case .table(let headers, _, _): return "table_\(headers.first?.hashValue ?? 0)"
        case .columnLayout(let columns): return "columns_\(columns.count)"
        case .artworkCard(let artist, let title, _, _, _, _): return "artwork_\(artist)_\(title)".hashValue.description
        case .comparisonTable(let title, _): return "comparison_\(title.hashValue)"
        case .reflection(let prompt, _): return "reflection_\(prompt.hashValue)"
        case .toggleBlock(let title, _): return "toggle_\(title.hashValue)"
        case .database(let title, _, _): return "database_\(title.hashValue)"
        case .spacer(let height): return "spacer_\(height.rawValue)_\(UUID().uuidString)"
        case .localWebView(let filename, _, _): return "webview_\(filename.hashValue)"
        case .localImage(let name, _): return "localimage_\(name.hashValue)"
        }
    }
}

// MARK: - Supporting Types for Content Blocks

/// Content for a single column in a column layout
struct ColumnContent: Codable, Hashable {
    var blocks: [ContentBlock]
    var width: ColumnWidth

    enum ColumnWidth: String, Codable, Hashable {
        case equal
        case narrow
        case wide
    }
}

/// Item for comparison tables
struct ComparisonItem: Codable, Hashable {
    var label: String
    var values: [String] // One value per column
}

/// A single row from a Notion inline database
struct DatabaseEntry: Codable, Hashable, Identifiable {
    var id: String { name.isEmpty ? UUID().uuidString : "\(group)_\(name)".hashValue.description }
    let name: String
    let group: String       // Category/Status grouping value
    let info: String        // Rich-text body content
    let fields: [String: String]  // All other property values
}

/// Spacer heights
enum SpacerHeight: String, Codable, Hashable {
    case small = "sm"
    case medium = "md"
    case large = "lg"
}

enum CalloutType: String, Codable, Hashable {
    case info
    case tip
    case warning
    case example
    case research
    case reflection
    case keyPoint
    case definition
    case link        // Interactive - links to other content
    case explore     // "Dive Further" style expandable with rich content
}

// MARK: - Reflection Prompt
struct ReflectionPrompt: Identifiable, Codable, Hashable {
    let id: String
    var question: String
    var context: String?
    var relatedSections: [String] // Section IDs
}

// MARK: - Quiz
struct Quiz: Identifiable, Codable, Hashable {
    let id: String
    var title: String
    var description: String?
    var questions: [QuizQuestion]
    var passingScore: Double // Percentage (0.0 - 1.0)
}

struct QuizQuestion: Identifiable, Codable, Hashable {
    let id: String
    var question: String
    var options: [String]
    var correctAnswerIndex: Int
    var explanation: String
    var difficulty: Difficulty
    var relatedConcepts: [String] // Glossary term IDs
    
    enum Difficulty: String, Codable, Hashable {
        case beginner
        case intermediate
        case advanced
    }
}

// MARK: - Case Study (extracted from module content)
struct CaseStudy: Identifiable, Codable, Hashable {
    let id: String
    var title: String
    var scenario: String
    var context: String
    var keyQuestions: [String]
    var suggestedAnswers: [String] // Answers/guidance for each key question
    var learningFocus: [String] // e.g., "Pattern Recognition", "Bias Identification"
    var relatedSection: String
    var source: String // e.g., "From: Gender & Behavioral Investing"

    init(id: String, title: String, scenario: String, context: String, keyQuestions: [String], suggestedAnswers: [String] = [], learningFocus: [String], relatedSection: String, source: String) {
        self.id = id
        self.title = title
        self.scenario = scenario
        self.context = context
        self.keyQuestions = keyQuestions
        self.suggestedAnswers = suggestedAnswers
        self.learningFocus = learningFocus
        self.relatedSection = relatedSection
        self.source = source
    }
}

// MARK: - Knowledge Node (for visual map)
struct KnowledgeNode: Identifiable, Codable, Hashable {
    let id: String
    var title: String
    var concept: String
    var connectedNodes: [String] // Other node IDs
    var moduleId: String
    var sectionIds: [String]
    var position: CGPoint? // For visual map layout
    var isUnlocked: Bool

    enum CodingKeys: String, CodingKey {
        case id, title, concept, connectedNodes, moduleId, sectionIds, isUnlocked
    }
}

// MARK: - Learning Path
/// A curated sequence of modules forming a complete learning journey
struct LearningPath: Identifiable, Codable, Hashable {
    let id: String
    var title: String
    var description: String
    var icon: String                    // Emoji icon for the path
    var nodes: [LearningPathNode]       // Ordered sequence of modules
    var estimatedDuration: Int          // Total minutes across all modules
    var difficulty: Difficulty
    var tags: [String]
    var heroImageURL: String?           // Optional hero artwork for path overview

    enum Difficulty: String, Codable, Hashable {
        case beginner
        case intermediate
        case advanced

        var displayName: String {
            rawValue.capitalized
        }
    }

    // Computed properties
    var totalModules: Int { nodes.count }
    var requiredModules: Int { nodes.filter { !$0.isOptional }.count }
}

// MARK: - Learning Path Node
/// A single node in a learning path, representing one module
struct LearningPathNode: Identifiable, Codable, Hashable {
    let id: String
    var moduleId: String                // Reference to the Module
    var position: Int                   // Order in the path (1-indexed)
    var prerequisites: [String]         // Module IDs that must be completed first
    var isOptional: Bool                // Whether this module can be skipped
    var unlockCriteria: UnlockCriteria? // Additional requirements to unlock

    /// Criteria that must be met to unlock this node
    struct UnlockCriteria: Codable, Hashable {
        var requiredQuizScore: Double?      // Minimum score on previous quiz (0.0-1.0)
        var requiredReflections: Int?       // Number of reflections to complete
        var requiredTimeSpent: TimeInterval? // Minimum time spent in previous module
    }
}

// MARK: - Path Progress
/// Tracks user progress through a learning path
struct PathProgress: Codable, Hashable {
    var pathId: String
    var startedAt: Date
    var currentNodeIndex: Int           // Which node the user is currently on
    var unlockedNodes: Set<String>      // Node IDs that are unlocked
    var completedNodes: Set<String>     // Node IDs that are completed
    var lastAccessedAt: Date

    init(pathId: String) {
        self.pathId = pathId
        self.startedAt = Date()
        self.currentNodeIndex = 0
        self.unlockedNodes = []
        self.completedNodes = []
        self.lastAccessedAt = Date()
    }

    // Computed properties
    var completionPercentage: Double {
        guard !unlockedNodes.isEmpty else { return 0 }
        return Double(completedNodes.count) / Double(unlockedNodes.count)
    }
}
