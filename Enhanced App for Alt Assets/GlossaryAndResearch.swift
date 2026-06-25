//
//  GlossaryAndResearch.swift
//  Enhanced App for Alt Assets
//
//  Created by Victoria Case on 2/1/26.
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//
//  Description: Models for the glossary system (financial/behavioral economics terms)
//  and research database (academic articles). Includes educational calculators for
//  interactive demonstrations.
//

import Foundation

// MARK: - Glossary Term
struct GlossaryTerm: Identifiable, Codable, Hashable {
    let id: String
    var term: String
    var definition: String
    var simpleExplanation: String?
    var examples: [String]
    var relatedTerms: [String] // Other term IDs
    var usedInModules: [String] // Module IDs
    var usedInSections: [String] // Section IDs
    var category: Category
    var userNotes: String?
    
    enum Category: String, Codable, Hashable, CaseIterable {
        case altAssets = "Alternative Assets"
        case art = "Art"
        case behavioral = "Behavioral Economics"
        case defi = "DeFi"
        case esg = "ESG & Climate"
        case finance = "Finance"
        case gender = "Gender & Economics"
        case general = "General"
        case investing = "Investing"
        case risk = "Risk Management"
    }
    
    // Computed properties
    var displayCategory: String { category.rawValue }
}

// MARK: - Research Article
struct ResearchArticle: Identifiable, Codable, Hashable {
    let id: String
    var title: String
    var authors: [String]
    var year: Int
    var publication: String?
    var abstract: String
    var keyFindings: [String]
    var methodology: String?
    var relatedModules: [String] // Module IDs
    var relatedConcepts: [String] // Glossary term IDs
    var url: String?
    var doi: String?
    var tags: [String]
    var researchType: ResearchType
    
    enum ResearchType: String, Codable, Hashable {
        case empirical = "Empirical Study"
        case theoretical = "Theoretical"
        case metaAnalysis = "Meta-Analysis"
        case review = "Literature Review"
        case caseStudy = "Case Study"
    }
    
    // Academic citation format
    var citation: String {
        let authorString = authors.prefix(3).joined(separator: ", ")
        let etAl = authors.count > 3 ? " et al." : ""
        return "\(authorString)\(etAl) (\(year)). \(title)."
    }
}

// MARK: - Visual Calculator (Educational demonstrations)
struct EducationalCalculator: Identifiable, Codable, Hashable {
    let id: String
    var title: String
    var description: String
    var type: CalculatorType
    var disclaimer: String = "Educational demonstration only - not financial advice"
    var relatedConcepts: [String]
    var moduleId: String
    
    enum CalculatorType: String, Codable, Hashable {
        case diversification = "Portfolio Diversification Visualizer"
        case riskTolerance = "Risk Tolerance Explorer"
        case compoundInterest = "Compound Interest Demonstrator"
        case correlation = "Asset Correlation"
        case allocation = "Asset Allocation Simulator"
    }
}
