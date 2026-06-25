//
//  AppConfiguration.swift
//  Enhanced App for Alt Assets
//
//  Created by Victoria Case on 2/5/26.
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//
//  Description: Central configuration for the app. Controls whether the app
//  is in development mode (shows API settings) or production mode (uses
//  embedded credentials and hides developer settings).
//
//  Architecture: Modules are standalone Notion pages (not database rows).
//  Page IDs are mapped in NotionService.modulePages. Only the API key is
//  needed — no database ID required for core module fetching.
//
//  Security: The Notion API key is loaded from Secrets.plist (bundled resource).
//  Secrets.plist is git-ignored and must be created locally from the template.
//

import Foundation

/// App configuration - controls development vs production behavior
struct AppConfiguration {

    // MARK: - Build Mode

    /// Set to `false` for App Store release to hide API settings from users
    /// Set to `true` during development to show API configuration UI
    #if DEBUG
    static let isDevelopmentMode = true
    #else
    static let isDevelopmentMode = false
    #endif

    // MARK: - Credentials (loaded from Secrets.plist)

    /// Reads the Notion API key from the bundled Secrets.plist file.
    /// Secrets.plist is git-ignored and must be created locally from the template.
    /// Falls back to UserDefaults for development override.
    private static var configuredAPIKey: String {
        // 1. Check Secrets.plist (bundled, git-ignored)
        if let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
           let secrets = NSDictionary(contentsOfFile: path),
           let plistKey = secrets["NOTION_API_KEY"] as? String,
           !plistKey.isEmpty,
           !plistKey.contains("your_notion_api_key") {
            return plistKey
        }
        // 2. Check Keychain (development override)
        if let userKey = KeychainHelper.read(key: "notion_api_key"),
           !userKey.isEmpty {
            return userKey
        }
        return ""
    }

    /// Legacy database ID — kept for potential future use with database-based queries.
    /// Not required for core module fetching (modules are standalone pages).
    private static let productionDatabaseID = ""

    // MARK: - Active Credentials

    /// Returns the API key to use
    static var notionAPIKey: String {
        return configuredAPIKey
    }

    /// Returns the database ID to use
    /// Note: Not needed for page-based module fetching
    static var notionDatabaseID: String {
        if isDevelopmentMode {
            return UserDefaults.standard.string(forKey: "notion_database_id") ?? ""
        } else {
            return productionDatabaseID
        }
    }

    /// Whether Notion integration is configured (only API key needed for page-based fetching)
    static var isNotionConfigured: Bool {
        return !notionAPIKey.isEmpty
    }

    // MARK: - Feature Flags

    /// Show developer/API settings in Settings view
    /// Disabled for production deployment — Notion API is internal only
    static var showDeveloperSettings: Bool {
        return isDevelopmentMode
    }

    /// Use sample data when Notion isn't configured or as initial fallback
    static var useSampleDataFallback: Bool {
        return true
    }

    /// Prefer live Notion data over sample data when API is configured
    /// When true, the app will attempt to fetch from Notion on launch
    static var preferLiveData: Bool {
        return isNotionConfigured
    }

    /// Enable debug logging
    static var enableDebugLogging: Bool {
        return isDevelopmentMode
    }
}

// MARK: - Debug Logging
func debugLog(_ message: String, file: String = #file, function: String = #function) {
    if AppConfiguration.enableDebugLogging {
        let filename = (file as NSString).lastPathComponent
        print("[\(filename):\(function)] \(message)")
    }
}
