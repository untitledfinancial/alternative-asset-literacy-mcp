//
//  SubscriptionManager.swift
//  Enhanced App for Alt Assets
//
//  Created by Victoria Case on 3/12/26.
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//
//  Description: Manages in-app subscription state using StoreKit2.
//  Handles product loading, purchase flow, entitlement verification,
//  and content access gating for the freemium model.
//

import Foundation
import StoreKit
import Combine

// MARK: - Subscription Manager
@MainActor
class SubscriptionManager: ObservableObject {

    // MARK: - Screenshot / Debug Override
    // When true, all content is unlocked regardless of StoreKit status.
    // Toggle via Settings > Developer > Unlock All Content.
    // Set this to false (and remove the Settings toggle) before App Store submission.
    static let screenshotModeKey = "debug_screenshot_mode"
    @Published var screenshotModeEnabled: Bool {
        didSet { UserDefaults.standard.set(screenshotModeEnabled, forKey: Self.screenshotModeKey) }
    }

    // MARK: - Published State
    @Published private(set) var isSubscribed: Bool = false
    @Published private(set) var availableProducts: [Product] = []
    @Published private(set) var purchaseInProgress: Bool = false
    @Published var purchaseError: String?
    @Published private(set) var expirationDate: Date?

    // Effective subscription state — respects screenshot override
    var hasAccess: Bool { screenshotModeEnabled || isSubscribed }

    // MARK: - Product Identifiers
    static let monthlyId = "altslit_monthly"
    static let annualId = "altslit_annual"
    static let allProductIds: Set<String> = [monthlyId, annualId]

    // MARK: - Free Content Configuration
    /// Module 1 ("Investing Primer") is always accessible
    static let freeModuleId = "mod_women"

    /// Number of quiz previews available per gated module
    static let freeQuizPreviewCount = 1

    /// Number of content sections visible in gated module preview
    static let freeSectionPreviewCount = 2

    // MARK: - Subscription Journey Milestones
    static let subscriptionDateKey = "first_subscription_date"
    static let acknowledgedMilestonesKey = "acknowledged_review_milestones"
    static let milestoneDays = [5, 30, 90, 180, 365]

    var firstSubscriptionDate: Date? {
        UserDefaults.standard.object(forKey: Self.subscriptionDateKey) as? Date
    }

    var currentMilestone: Int? {
        guard let start = firstSubscriptionDate else { return nil }
        let daysSince = Calendar.current.dateComponents([.day], from: start, to: Date()).day ?? 0
        let acknowledged = (UserDefaults.standard.array(forKey: Self.acknowledgedMilestonesKey) as? [Int]) ?? []
        return Self.milestoneDays
            .filter { daysSince >= $0 && !acknowledged.contains($0) }
            .max()
    }

    func acknowledgeMilestone(_ days: Int) {
        var acknowledged = (UserDefaults.standard.array(forKey: Self.acknowledgedMilestonesKey) as? [Int]) ?? []
        if !acknowledged.contains(days) {
            acknowledged.append(days)
            UserDefaults.standard.set(acknowledged, forKey: Self.acknowledgedMilestonesKey)
        }
    }

    private func recordFirstSubscriptionDateIfNeeded() {
        guard UserDefaults.standard.object(forKey: Self.subscriptionDateKey) == nil else { return }
        UserDefaults.standard.set(Date(), forKey: Self.subscriptionDateKey)
    }

    // MARK: - Private
    private var transactionListener: Task<Void, Error>?

    // MARK: - Initialization
    init() {
        self.screenshotModeEnabled = UserDefaults.standard.bool(forKey: Self.screenshotModeKey)

        // Start listening for transaction updates
        transactionListener = listenForTransactions()

        // Load products and check status on launch
        Task {
            await loadProducts()
            await checkSubscriptionStatus()
        }
    }

    deinit {
        transactionListener?.cancel()
    }

    // MARK: - Product Loading

    /// Fetches available subscription products from the App Store.
    /// Retries up to 3 times with exponential backoff on failure.
    func loadProducts() async {
        let maxAttempts = 3
        for attempt in 1...maxAttempts {
            do {
                let products = try await Product.products(for: Self.allProductIds)
                // Sort so annual appears first (higher value)
                availableProducts = products.sorted { ($0.price as NSDecimalNumber).doubleValue > ($1.price as NSDecimalNumber).doubleValue }
                purchaseError = nil
                return
            } catch {
                debugLog("Failed to load products (attempt \(attempt)): \(error.localizedDescription)")
                if attempt < maxAttempts {
                    // Exponential backoff: 1s, 2s
                    try? await Task.sleep(nanoseconds: UInt64(attempt) * 1_000_000_000)
                } else {
                    purchaseError = "Unable to load plans. Please check your connection and tap Retry."
                }
            }
        }
    }

    /// Returns the monthly product, if loaded.
    var monthlyProduct: Product? {
        availableProducts.first { $0.id == Self.monthlyId }
    }

    /// Returns the annual product, if loaded.
    var annualProduct: Product? {
        availableProducts.first { $0.id == Self.annualId }
    }

    // MARK: - Purchase

    /// Initiates a purchase for the given product.
    func purchase(_ product: Product) async {
        purchaseInProgress = true
        purchaseError = nil

        do {
            let result = try await product.purchase()

            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                await transaction.finish()
                await checkSubscriptionStatus()

            case .userCancelled:
                break

            case .pending:
                // Transaction requires approval (e.g., Ask to Buy)
                break

            @unknown default:
                break
            }
        } catch {
            purchaseError = error.localizedDescription
        }

        purchaseInProgress = false
    }

    // MARK: - Restore Purchases

    /// Syncs purchase history with the App Store.
    func restorePurchases() async {
        do {
            try await AppStore.sync()
            await checkSubscriptionStatus()
        } catch {
            purchaseError = "Unable to restore purchases. Please try again."
        }
    }

    // MARK: - Subscription Status

    /// Checks current entitlements to determine subscription state.
    func checkSubscriptionStatus() async {
        var hasActiveSubscription = false
        var latestExpiration: Date?

        for await result in Transaction.currentEntitlements {
            guard let transaction = try? checkVerified(result) else { continue }

            if Self.allProductIds.contains(transaction.productID) {
                hasActiveSubscription = true
                if let expiry = transaction.expirationDate {
                    if expiry > (latestExpiration ?? .distantPast) {
                        latestExpiration = expiry
                    }
                }
            }
        }

        isSubscribed = hasActiveSubscription
        expirationDate = latestExpiration
        if hasActiveSubscription {
            recordFirstSubscriptionDateIfNeeded()
        }
    }

    // MARK: - Access Control

    /// Whether the given module is fully accessible.
    func isModuleAccessible(_ moduleId: String) -> Bool {
        if hasAccess { return true }
        return moduleId == Self.freeModuleId
    }

    /// Whether a specific quiz within a module is accessible.
    /// - Parameters:
    ///   - moduleId: The module identifier
    ///   - quizIndex: Zero-based index of the quiz in the module's quiz array
    func isQuizAccessible(moduleId: String, quizIndex: Int) -> Bool {
        if hasAccess { return true }
        if moduleId == Self.freeModuleId { return true }
        return quizIndex < Self.freeQuizPreviewCount
    }

    /// Whether reflections are accessible for a given module.
    func areReflectionsAccessible(_ moduleId: String) -> Bool {
        if hasAccess { return true }
        return moduleId == Self.freeModuleId
    }

    /// Whether case studies are accessible for a given module.
    func areCaseStudiesAccessible(_ moduleId: String) -> Bool {
        if hasAccess { return true }
        return moduleId == Self.freeModuleId
    }

    /// The number of content sections visible for a given module.
    func visibleSectionCount(for moduleId: String, totalSections: Int) -> Int {
        if hasAccess || moduleId == Self.freeModuleId {
            return totalSections
        }
        return min(Self.freeSectionPreviewCount, totalSections)
    }

    // MARK: - Transaction Listener

    /// Listens for real-time transaction updates (renewals, revocations, etc.)
    private func listenForTransactions() -> Task<Void, Error> {
        Task.detached { [weak self] in
            for await result in Transaction.updates {
                guard let self = self else { break }
                if let transaction = try? self.checkVerified(result) {
                    await transaction.finish()
                    await self.checkSubscriptionStatus()
                }
            }
        }
    }

    // MARK: - Verification Helper

    /// Verifies a StoreKit transaction result.
    private nonisolated func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified(_, let error):
            throw error
        case .verified(let safe):
            return safe
        }
    }
}
