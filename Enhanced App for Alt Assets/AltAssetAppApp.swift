//
//  AltAssetAppApp.swift
//  Enhanced App for Alt Assets
//
//  Created by Victoria Case on 2/1/26.
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//
//  Description: Main app entry point. Initializes environment objects for progress
//  management, Notion service, and spaced repetition review manager. Shows Terms of
//  Use on first launch, then the main ContentView.
//

import SwiftUI

@main
struct AltAssetAppApp: App {
    @StateObject private var progressManager = ProgressManager()
    @StateObject private var notionService = NotionService()
    @StateObject private var reviewManager = ReviewManager()
    @StateObject private var userSettings = UserSettings.shared
    @StateObject private var subscriptionManager = SubscriptionManager()

    @State private var hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "has_completed_onboarding")

    init() {
        // One-time migration: move sensitive data from UserDefaults to Keychain
        KeychainHelper.migrateFromUserDefaultsIfNeeded()
        // Request notification permission on first launch
        Task { await NotificationManager.shared.requestPermission() }

        // Migrate users who accepted old terms but haven't seen new onboarding
        if UserDefaults.standard.bool(forKey: "has_accepted_terms_of_use") &&
           !UserDefaults.standard.bool(forKey: "has_completed_onboarding") {
            UserDefaults.standard.set(true, forKey: "has_completed_onboarding")
            _hasCompletedOnboarding = State(initialValue: true)
        }
    }

    var body: some Scene {
        WindowGroup {
            Group {
                if hasCompletedOnboarding {
                    ContentView()
                        .environmentObject(progressManager)
                        .environmentObject(notionService)
                        .environmentObject(reviewManager)
                        .environmentObject(userSettings)
                        .environmentObject(subscriptionManager)
                        .showWhatsNewIfNeeded()
                } else {
                    OnboardingFlow(isComplete: $hasCompletedOnboarding)
                        .environmentObject(userSettings)
                }
            }
            #if os(macOS)
            .frame(minWidth: 800, minHeight: 600)
            #endif
            #if os(visionOS)
            .frame(minWidth: 1100, minHeight: 700)
            #endif
        }
        #if os(macOS)
        .windowResizability(.contentSize)
        #endif
        #if os(visionOS)
        .windowResizability(.contentSize)
        .defaultSize(width: 1280, height: 800)
        #endif
    }
}
