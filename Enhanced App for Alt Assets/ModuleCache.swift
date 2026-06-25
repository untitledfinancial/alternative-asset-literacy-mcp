//
//  ModuleCache.swift
//  Enhanced App for Alt Assets
//
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//
//  Persists the last successful Notion module fetch to disk so the app loads
//  rich content instantly on subsequent launches, even when Notion is unreachable.
//

import Foundation

enum ModuleCache {
    private static let filename = "notion_modules_cache.json"
    private static let timestampKey = "notion_modules_cache_timestamp"

    // Notion signed image URLs expire after 1 hour. Use 45 min to stay safely ahead.
    static let imageFreshnessTTL: TimeInterval = 45 * 60

    private static var cacheURL: URL? {
        FileManager.default
            .urls(for: .cachesDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent(filename)
    }

    static func save(_ modules: [Module]) {
        guard let url = cacheURL else { return }
        do {
            let data = try JSONEncoder().encode(modules)
            try data.write(to: url, options: .atomic)
            UserDefaults.standard.set(Date(), forKey: timestampKey)
        } catch {
            // Cache write failure is non-fatal — app still works from live Notion data
        }
    }

    static func load() -> [Module]? {
        guard let url = cacheURL,
              let data = try? Data(contentsOf: url),
              let modules = try? JSONDecoder().decode([Module].self, from: data),
              !modules.isEmpty else { return nil }
        return modules
    }

    /// True when cached image URLs may be expired (older than 45 min).
    static var isImageStale: Bool {
        guard let saved = UserDefaults.standard.object(forKey: timestampKey) as? Date else {
            return true
        }
        return Date().timeIntervalSince(saved) > imageFreshnessTTL
    }

    static func clear() {
        guard let url = cacheURL else { return }
        try? FileManager.default.removeItem(at: url)
        UserDefaults.standard.removeObject(forKey: timestampKey)
    }
}
