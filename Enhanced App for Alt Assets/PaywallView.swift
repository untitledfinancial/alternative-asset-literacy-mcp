//
//  PaywallView.swift
//  Enhanced App for Alt Assets
//
//  Created by Victoria Case on 3/12/26.
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//
//  Description: Premium subscription paywall presented as a modal sheet.
//  Matches the editorial/museum aesthetic with brand colors, typography,
//  and Dutch Golden Age palette. Includes Apple-required legal disclosures.
//

import SwiftUI
import StoreKit

// MARK: - Paywall View
struct PaywallView: View {
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    @State private var selectedPlan: String = SubscriptionManager.annualId
    @State private var showOfferCodeRedemption: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.xl) {

                    // MARK: - Header
                    headerSection

                    // MARK: - Feature List
                    featureListSection

                    // MARK: - Plan Cards
                    planCardsSection

                    // MARK: - CTA Button
                    ctaButton

                    // MARK: - Error
                    if let error = subscriptionManager.purchaseError {
                        Text(error)
                            .font(Typography.caption)
                            .foregroundColor(.error)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, Spacing.lg)
                    }

                    // MARK: - Promo Code
                    promoCodeButton

                    // MARK: - Legal Disclosures
                    legalSection

                    // MARK: - Restore Purchases
                    restoreButton
                }
                .padding(.vertical, Spacing.xl)
                .frame(maxWidth: horizontalSizeClass == .regular ? 600 : .infinity)
                .frame(maxWidth: .infinity)
            }
            .background(Color.surfacePrimary)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.body.weight(.medium))
                            .foregroundColor(.textSecondary)
                    }
                }
            }
        }
    }

    // MARK: - Header Section

    private var headerSection: some View {
        VStack(spacing: Spacing.sm) {
            Image(systemName: "book.pages")
                .font(.system(size: 44))
                .foregroundColor(.brandPrimary)
                .padding(.bottom, Spacing.xs)

            Text("Unlock Every Module")
                .font(Typography.displaySmall)
                .foregroundColor(.textPrimary)
                .multilineTextAlignment(.center)

            Text("Full access to expert-curated lessons on alternative assets, behavioral finance, DeFi, and more.")
                .font(Typography.body)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Spacing.lg)
        }
        .padding(.horizontal, Spacing.lg)
    }

    // MARK: - Feature List

    private var featureListSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            featureRow(icon: "text.book.closed", text: "All 9 modules with full content")
            featureRow(icon: "checkmark.circle", text: "Unlimited quizzes and reflections")
            featureRow(icon: "doc.text.magnifyingglass", text: "Case studies and research tools")
            featureRow(icon: "plus.circle", text: "New modules as they launch")
        }
        .padding(.horizontal, Spacing.xl)
    }

    private func featureRow(icon: String, text: String) -> some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: icon)
                .font(.body)
                .foregroundColor(.brandHighlight)
                .frame(width: 24)

            Text(text)
                .font(Typography.body)
                .foregroundColor(.textPrimary)
        }
    }

    // MARK: - Plan Cards

    private var planCardsSection: some View {
        VStack(spacing: Spacing.sm) {
            // Annual plan
            if let annual = subscriptionManager.annualProduct {
                planCard(
                    product: annual,
                    title: "Annual",
                    badge: "Best Value",
                    trialText: "7-day free trial",
                    perMonthText: perMonthPrice(for: annual),
                    isSelected: selectedPlan == SubscriptionManager.annualId
                )
                .onTapGesture {
                    selectedPlan = SubscriptionManager.annualId
                }
            }

            // Monthly plan
            if let monthly = subscriptionManager.monthlyProduct {
                planCard(
                    product: monthly,
                    title: "Monthly",
                    badge: nil,
                    trialText: nil,
                    perMonthText: nil,
                    isSelected: selectedPlan == SubscriptionManager.monthlyId
                )
                .onTapGesture {
                    selectedPlan = SubscriptionManager.monthlyId
                }
            }
        }
        .padding(.horizontal, Spacing.lg)
    }

    private func planCard(
        product: Product,
        title: String,
        badge: String?,
        trialText: String?,
        perMonthText: String?,
        isSelected: Bool
    ) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                HStack(spacing: Spacing.xs) {
                    Text(title)
                        .font(Typography.title3)
                        .foregroundColor(.textPrimary)

                    if let badge = badge {
                        Text(badge)
                            .font(Typography.caption)
                            .foregroundColor(.brandHighlight)
                            .padding(.horizontal, Spacing.xs)
                            .padding(.vertical, 2)
                            .background(
                                Capsule()
                                    .fill(Color.brandHighlight.opacity(0.12))
                            )
                    }
                }

                if let trial = trialText {
                    Text(trial)
                        .font(Typography.caption)
                        .foregroundColor(.success)
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: Spacing.xxs) {
                Text(product.displayPrice)
                    .font(Typography.title3)
                    .foregroundColor(.textPrimary)

                if let perMonth = perMonthText {
                    Text(perMonth)
                        .font(Typography.caption)
                        .foregroundColor(.textTertiary)
                }
            }
        }
        .padding(Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: CornerRadius.md)
                .fill(isSelected ? Color.surfaceSecondary : Color.surfacePrimary)
        )
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.md)
                .stroke(isSelected ? Color.brandPrimary : Color.border, lineWidth: isSelected ? 2 : 1)
        )
    }

    private func perMonthPrice(for annualProduct: Product) -> String {
        let annualPrice = (annualProduct.price as NSDecimalNumber).doubleValue
        let monthly = annualPrice / 12.0
        return String(format: "$%.2f/mo", monthly)
    }

    // MARK: - CTA Button

    private var ctaButton: some View {
        VStack(spacing: Spacing.sm) {
            Button {
                Task {
                    guard let product = selectedProduct else { return }
                    await subscriptionManager.purchase(product)
                    if subscriptionManager.isSubscribed {
                        dismiss()
                    }
                }
            } label: {
                Group {
                    if subscriptionManager.purchaseInProgress {
                        ProgressView()
                            .tint(.white)
                    } else if subscriptionManager.availableProducts.isEmpty {
                        Text("Loading Plans…")
                            .font(Typography.bodyMedium)
                    } else {
                        Text(ctaLabel)
                            .font(Typography.bodyMedium)
                    }
                }
                .foregroundColor(.textOnDark)
                .frame(maxWidth: .infinity)
                .padding(.vertical, Spacing.md)
                .background(
                    RoundedRectangle(cornerRadius: CornerRadius.md)
                        .fill(selectedProduct != nil ? Color.brandHighlight : Color.textTertiary)
                )
            }
            .disabled(subscriptionManager.purchaseInProgress || selectedProduct == nil)
            .padding(.horizontal, Spacing.lg)

            // Show retry if products failed to load
            if subscriptionManager.availableProducts.isEmpty && !subscriptionManager.purchaseInProgress {
                VStack(spacing: Spacing.xs) {
                    Text("Plans could not be loaded.")
                        .font(Typography.caption)
                        .foregroundColor(.textTertiary)
                    Button {
                        Task { await subscriptionManager.loadProducts() }
                    } label: {
                        Text("Retry")
                            .font(Typography.bodyMedium)
                            .foregroundColor(.textOnDark)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, Spacing.sm)
                            .background(
                                RoundedRectangle(cornerRadius: CornerRadius.md)
                                    .fill(Color.brandPrimary)
                            )
                    }
                    .padding(.horizontal, Spacing.lg)
                }
            }
        }
    }

    private var selectedProduct: Product? {
        subscriptionManager.availableProducts.first { $0.id == selectedPlan }
    }

    private var ctaLabel: String {
        if selectedPlan == SubscriptionManager.annualId {
            return "Start Free Trial"
        }
        return "Subscribe"
    }

    // MARK: - Legal Section

    private var legalSection: some View {
        VStack(spacing: Spacing.xs) {
            Text(legalDisclosure)
                .font(Typography.caption)
                .foregroundColor(.textTertiary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Spacing.xl)

            HStack(spacing: Spacing.md) {
                Link("Terms of Use", destination: URL(string: "https://alternativeassetsliteracy.com/terms.html")!)
                    .font(Typography.caption)
                    .foregroundColor(.info)

                Text("|")
                    .font(Typography.caption)
                    .foregroundColor(.textTertiary)

                Link("Privacy Policy", destination: URL(string: "https://alternativeassetsliteracy.com/privacy.html")!)
                    .font(Typography.caption)
                    .foregroundColor(.info)
            }
        }
    }

    private var legalDisclosure: String {
        let suffix = "will be charged to your Apple ID account. Subscription automatically renews unless cancelled at least 24 hours before the end of the current period. Manage subscriptions in your Account Settings."
        if selectedPlan == SubscriptionManager.annualId {
            let price = subscriptionManager.annualProduct?.displayPrice ?? "the annual price"
            return "After your 7-day free trial, payment of \(price)/year \(suffix)"
        }
        let price = subscriptionManager.monthlyProduct?.displayPrice ?? "the monthly price"
        return "Payment of \(price)/month \(suffix)"
    }

    // MARK: - Restore Button

    private var restoreButton: some View {
        Button {
            Task {
                await subscriptionManager.restorePurchases()
                if subscriptionManager.isSubscribed {
                    dismiss()
                }
            }
        } label: {
            Text("Restore Purchases")
                .font(Typography.caption)
                .foregroundColor(.textSecondary)
        }
        .padding(.bottom, Spacing.lg)
    }

    // MARK: - Promo Code Button

    private var promoCodeButton: some View {
        Button {
            showOfferCodeRedemption = true
        } label: {
            Text("Redeem Offer Code")
                .font(Typography.caption)
                .foregroundColor(.brandPrimary)
        }
        .offerCodeRedemption(isPresented: $showOfferCodeRedemption) { result in
            switch result {
            case .success:
                Task {
                    await subscriptionManager.checkSubscriptionStatus()
                    if subscriptionManager.isSubscribed {
                        dismiss()
                    }
                }
            case .failure:
                break
            @unknown default:
                break
            }
        }
    }
}

// MARK: - Inline Paywall CTA (for within module content)
struct InlinePaywallCard: View {
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @State private var showPaywall = false

    var body: some View {
        VStack(spacing: Spacing.md) {
            Image(systemName: "lock.fill")
                .font(.title2)
                .foregroundColor(.brandPrimary)

            Text("Subscribe to Continue")
                .font(Typography.title3)
                .foregroundColor(.textPrimary)

            Text("Unlock all modules, quizzes, reflections, and case studies with a Premium subscription.")
                .font(Typography.body)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)

            Button {
                showPaywall = true
            } label: {
                Text("View Plans")
                    .font(Typography.bodyMedium)
                    .foregroundColor(.textOnDark)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Spacing.sm)
                    .background(
                        RoundedRectangle(cornerRadius: CornerRadius.md)
                            .fill(Color.brandHighlight)
                    )
            }
        }
        .padding(Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: CornerRadius.lg)
                .fill(Color.surfaceSecondary)
        )
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.lg)
                .stroke(Color.border, lineWidth: 1)
        )
        .padding(.horizontal, Spacing.lg)
        .sheet(isPresented: $showPaywall) {
            PaywallView()
        }
    }
}

// MARK: - Locked Overlay (for quiz/section cards)
struct LockedOverlay: View {
    var body: some View {
        ZStack {
            Color.surfacePrimary.opacity(0.6)

            VStack(spacing: Spacing.xxs) {
                Image(systemName: "lock.fill")
                    .font(.caption)
                    .foregroundColor(.textTertiary)
                Text("Premium")
                    .font(Typography.caption)
                    .foregroundColor(.textTertiary)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.sm))
    }
}

// MARK: - Preview
#Preview {
    PaywallView()
        .environmentObject(SubscriptionManager())
}
