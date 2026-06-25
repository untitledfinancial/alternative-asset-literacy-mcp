//
//  GlossaryManager.swift
//  Enhanced App for Alt Assets
//
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//

import Foundation

/// Shared access point for the full glossary term list.
/// Loaded once at first access; used by section views for term detection.
final class GlossaryManager {
    static let shared = GlossaryManager()

    let allTerms: [GlossaryTerm]
    /// Lowercased term name → GlossaryTerm, for fast lookup
    private let termIndex: [String: GlossaryTerm]

    private init() {
        let terms = NotionGlossaryData.allTermsUnified()
        self.allTerms = terms
        var index = [String: GlossaryTerm]()
        for t in terms { index[t.term.lowercased()] = t }
        self.termIndex = index
    }

    /// Returns glossary terms whose names appear in the given text, sorted alphabetically.
    func terms(in text: String) -> [GlossaryTerm] {
        let lower = text.lowercased()
        return allTerms.filter { term in
            let name = term.term.lowercased()
            // Require word-boundary match to avoid partial hits (e.g. "art" inside "market")
            guard name.count > 3 else { return false }
            guard lower.contains(name) else { return false }
            // Simple word-boundary check via character context
            if let range = lower.range(of: name) {
                let before = range.lowerBound > lower.startIndex
                    ? lower[lower.index(before: range.lowerBound)...lower.index(before: range.lowerBound)]
                    : ""
                let afterIdx = range.upperBound
                let after = afterIdx < lower.endIndex
                    ? lower[afterIdx...afterIdx]
                    : ""
                let isWordStart = before.isEmpty || !before.first!.isLetter
                let isWordEnd = after.isEmpty || !after.first!.isLetter
                return isWordStart && isWordEnd
            }
            return false
        }.sorted { $0.term < $1.term }
    }
}
