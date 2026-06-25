// KeychainHelper.swift
// Enhanced App for Alt Assets
//
// Secure storage for sensitive data using iOS Keychain.
// Replaces UserDefaults for API keys and user-generated content
// that could appear in unencrypted device backups.
//
// Created by Victoria Lee Case
// Copyright 2026 Untitled_ LuxPerpetua Technologies, Inc.

import Foundation
import Security

/// Thread-safe Keychain wrapper for storing sensitive strings and Data blobs.
/// All items use kSecAttrAccessibleAfterFirstUnlock so they're available
/// in the background but still encrypted at rest.
enum KeychainHelper {

    private static let service = "com.untitled.alternativeassetliteracy"

    // MARK: - String convenience

    /// Save a string to the Keychain.
    @discardableResult
    static func save(key: String, value: String) -> Bool {
        guard let data = value.data(using: .utf8) else { return false }
        return save(key: key, data: data)
    }

    /// Read a string from the Keychain.
    static func read(key: String) -> String? {
        guard let data = readData(key: key) else { return nil }
        return String(data: data, encoding: .utf8)
    }

    // MARK: - Data (for Codable blobs)

    /// Save raw Data to the Keychain.
    @discardableResult
    static func save(key: String, data: Data) -> Bool {
        // Delete any existing item first
        let deleteQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
        ]
        SecItemDelete(deleteQuery as CFDictionary)

        // Add the new item
        let addQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock,
        ]

        let status = SecItemAdd(addQuery as CFDictionary, nil)
        return status == errSecSuccess
    }

    /// Read raw Data from the Keychain.
    static func readData(key: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne,
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess else { return nil }
        return result as? Data
    }

    /// Delete a single item from the Keychain.
    @discardableResult
    static func delete(key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
        ]
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess || status == errSecItemNotFound
    }

    /// Delete ALL items for this app's service identifier.
    /// Called from "Reset All Progress" in Settings.
    static func deleteAll() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
        ]
        SecItemDelete(query as CFDictionary)
    }

    // MARK: - Migration

    /// One-time migration: moves sensitive data from UserDefaults to Keychain.
    /// Safe to call multiple times (idempotent).
    static func migrateFromUserDefaultsIfNeeded() {
        let migrationKey = "keychain_migration_v1_complete"
        guard !UserDefaults.standard.bool(forKey: migrationKey) else { return }

        // Migrate API key
        if let apiKey = UserDefaults.standard.string(forKey: "notion_api_key"), !apiKey.isEmpty {
            save(key: "notion_api_key", value: apiKey)
            UserDefaults.standard.removeObject(forKey: "notion_api_key")
        }

        // Migrate reflection entries
        if let data = UserDefaults.standard.data(forKey: "selfReflectionEntries") {
            save(key: "selfReflectionEntries", data: data)
            UserDefaults.standard.removeObject(forKey: "selfReflectionEntries")
        }

        // Migrate advisor notes
        if let data = UserDefaults.standard.data(forKey: "advisorNotes") {
            save(key: "advisorNotes", data: data)
            UserDefaults.standard.removeObject(forKey: "advisorNotes")
        }

        UserDefaults.standard.set(true, forKey: migrationKey)
    }
}
