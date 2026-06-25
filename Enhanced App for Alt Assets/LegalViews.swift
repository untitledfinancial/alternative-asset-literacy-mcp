//
//  LegalViews.swift
//  Enhanced App for Alt Assets
//
//  Created by Victoria Case on 2/18/26.
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//
//  Description: Legal views including Terms of Use acceptance screen,
//  module disclaimer banners, and footer disclaimers. Ensures compliance
//  with US and international financial education regulations.
//

import SwiftUI

// MARK: - Terms of Use Acceptance View (First Launch)
/// Shown on first app launch. User must accept before accessing content.
struct TermsOfUseView: View {
    @Binding var hasAcceptedTerms: Bool
    @State private var scrolledToBottom = false

    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: Spacing.sm) {
                Text("Terms of Use")
                    .font(Typography.displayMedium)
                    .foregroundColor(.textPrimary)

                Text("Please review and accept before continuing")
                    .font(Typography.body)
                    .foregroundColor(.textSecondary)
            }
            .padding(.top, Spacing.xl)
            .padding(.bottom, Spacing.lg)

            // Scrollable terms content
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.lg) {
                    termsSection(
                        title: "1. Educational Purpose",
                        content: "This application and all content contained herein are provided exclusively for educational and informational purposes. Nothing in this application constitutes financial advice, investment advice, tax advice, legal advice, or any other form of professional advisory service. The content is designed to support learning about alternative assets, decentralized finance, art markets, behavioral economics, and related topics in an academic and research-oriented context."
                    )

                    termsSection(
                        title: "2. No Financial Advice",
                        content: "The information presented in this application does not constitute a recommendation, solicitation, or offer to buy or sell any securities, financial instruments, or investment products. Any references to specific assets, protocols, markets, or investment strategies are for illustrative and educational purposes only. Past performance is not indicative of future results. All investment involves risk, including the possible loss of principal."
                    )

                    termsSection(
                        title: "3. Consult Your Financial Advisor",
                        content: "Before making any investment decisions, you should consult with a qualified financial advisor, tax professional, or legal counsel who is familiar with your individual financial situation, risk tolerance, and investment objectives. Untitled_ LuxPerpetua Technologies, Inc. does not hold a FINRA license and does not provide personalized investment advisory services."
                    )

                    termsSection(
                        title: "4. Regulatory Disclosure",
                        content: "Untitled_ LuxPerpetua Technologies, Inc. operates under SEC 506(c) and Regulation A Blue Sky Laws. This application is not registered as an investment adviser under the Investment Advisers Act of 1940 (US), the Markets in Financial Instruments Directive II (MiFID II, EU), the Financial Services and Markets Act 2000 (UK), or any equivalent legislation in other jurisdictions. Users outside the United States should be aware that local laws and regulations regarding financial education, securities, and digital assets may differ and should consult local regulatory frameworks."
                    )

                    termsSection(
                        title: "5. No Warranty",
                        content: "Content is provided \"as is\" without warranty of any kind, express or implied. While efforts are made to ensure accuracy, completeness, and currency of information, no guarantee is made regarding the reliability or suitability of any content for any particular purpose. Market conditions, regulations, and factual circumstances may change after content publication."
                    )

                    termsSection(
                        title: "6. Limitation of Liability",
                        content: "To the fullest extent permitted by applicable law, Untitled_ LuxPerpetua Technologies, Inc. and any affiliated parties shall not be liable for any direct, indirect, incidental, consequential, or punitive damages arising from the use of or reliance on any information contained in this application. This limitation applies regardless of the theory of liability, whether in contract, tort, strict liability, or otherwise."
                    )

                    termsSection(
                        title: "7. Intellectual Property",
                        content: "All content, design, and educational materials within this application are the intellectual property of Untitled_ LuxPerpetua Technologies, Inc. IP Patents Pending. Unauthorized reproduction, distribution, or modification of any materials is prohibited without express written consent."
                    )

                    termsSection(
                        title: "8. Affiliate Links & Third-Party Bookstores",
                        content: "This application contains links to books and other media available through Apple Books and other third-party platforms. These links may include affiliate identifiers. When you purchase a book or other content through an affiliate link in this application, Untitled_ LuxPerpetua Technologies, Inc. may receive a commission from the sale at no additional cost to you. These recommendations are made on editorial merit and educational relevance; affiliate relationships do not influence which resources are recommended. You are never required to purchase any book or external content to use this application."
                    )

                    termsSection(
                        title: "9. International Users",
                        content: "This application may be accessed from jurisdictions worldwide. Users are solely responsible for compliance with all local, state, national, and international laws and regulations applicable to their use of this application and any investment decisions they may make. Certain content may reference regulatory frameworks specific to the United States, European Union, or United Kingdom; users in other jurisdictions should consult applicable local regulations."
                    )

                    termsSection(
                        title: "10. Data & Privacy",
                        content: "Your learning progress, reflections, and quiz responses are stored locally on your device. No personal financial data is collected, transmitted, or shared with third parties. Any analytics collected are anonymized and used solely to improve the educational experience."
                    )

                    termsSection(
                        title: "11. Acceptance",
                        content: "By tapping \"I Accept\" below, you acknowledge that you have read, understood, and agree to these Terms of Use. You confirm that you understand this application is for educational and research purposes only and that you will consult with qualified professionals before making any investment decisions."
                    )

                    // Copyright
                    VStack(spacing: Spacing.xs) {
                        Divider()
                        Text("Copyright \u{00A9} 2026 Untitled_ LuxPerpetua Technologies, Inc.")
                            .font(Typography.caption2)
                            .foregroundColor(.textTertiary)
                        Text("All rights reserved. IP Patents Pending.")
                            .font(Typography.caption2)
                            .foregroundColor(.textTertiary)
                    }
                    .padding(.top, Spacing.md)
                }
                .padding(.horizontal, Spacing.lg)
                .padding(.bottom, Spacing.xl)
            }

            // Accept button
            VStack(spacing: Spacing.sm) {
                Divider()

                Button {
                    withAnimation(.smoothSpring) {
                        hasAcceptedTerms = true
                        UserDefaults.standard.set(true, forKey: "has_accepted_terms_of_use")
                    }
                } label: {
                    Text("I Accept — Continue")
                        .font(Typography.bodyMedium)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Spacing.md)
                        .background(Color.brandPrimary)
                        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
                }
                .buttonStyle(.plain)
                .padding(.horizontal, Spacing.lg)

                Text("You must accept to use this application")
                    .font(Typography.caption2)
                    .foregroundColor(.textTertiary)
            }
            .padding(.vertical, Spacing.md)
            .background(Color.surfacePrimary)
        }
        .background(Color.surfacePrimary)
    }

    private func termsSection(title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text(title)
                .font(Typography.bodyMedium)
                .foregroundColor(.textPrimary)

            Text(content)
                .font(Typography.caption)
                .foregroundColor(.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
                .lineSpacing(3)
        }
    }
}

// MARK: - Module Disclaimer Banner (Top of Content Tab)
/// Compact, collapsible disclaimer shown at the top of every module's content.
struct ModuleDisclaimerBanner: View {
    @State private var isCollapsed = true

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                withAnimation(.smoothSpring) {
                    isCollapsed.toggle()
                }
            } label: {
                HStack(spacing: Spacing.xs) {
                    Image(systemName: "info.circle")
                        .font(.system(size: 12))
                        .foregroundColor(.textTertiary)

                    Text("Educational content only \u{2022} Not financial advice")
                        .font(Typography.caption2)
                        .foregroundColor(.textTertiary)

                    Spacer()

                    Image(systemName: isCollapsed ? "chevron.down" : "chevron.up")
                        .font(.system(size: 9))
                        .foregroundColor(.textTertiary)
                }
            }
            .buttonStyle(.plain)

            if !isCollapsed {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text("This content is for informational and educational purposes only. It does not constitute financial, investment, tax, or legal advice. Please consult a qualified financial advisor before making any investment decisions. Past performance does not indicate future performance.")
                        .font(Typography.caption2)
                        .foregroundColor(.textTertiary)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineSpacing(2)
                }
                .padding(.top, Spacing.xs)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(Spacing.sm)
        .background(Color.surfaceTertiary.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.sm))
    }
}

// MARK: - Module Footer Disclaimer
/// Shown at the bottom of every module's content, before the bottom spacing.
struct ModuleFooterDisclaimer: View {
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Divider()

            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text("Disclaimer")
                    .font(Typography.caption2)
                    .fontWeight(.semibold)
                    .foregroundColor(.textTertiary)

                Text("This is not financial advice or recommendation for any investment. The content is for informational purposes only; you should not construe any such information or other material as legal, tax, investment, or financial advice. Legally we recommend you work with your financial advisor. Untitled_ LuxPerpetua Technologies, Inc. does not offer financial advice or hold a FINRA license. Untitled_ LuxPerpetua Technologies, Inc. operates under SEC 506(c) and Reg A Blue Sky Laws. Please speak with your financial advisor before making investment decisions. Past performance does not indicate future performance.")
                    .font(Typography.caption2)
                    .foregroundColor(.textTertiary)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineSpacing(2)

                Text("Copyright \u{00A9} 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved. IP Patents Pending.")
                    .font(Typography.caption2)
                    .foregroundColor(.textTertiary)
                    .padding(.top, 2)
            }
        }
        .padding(.top, Spacing.lg)
    }
}

// MARK: - Terms of Use Link (for Settings)
struct TermsOfUseLinkView: View {
    @State private var showingTerms = false

    var body: some View {
        Button {
            showingTerms = true
        } label: {
            HStack {
                Text("Terms of Use")
                Spacer()
                Image(systemName: "doc.text")
                    .font(.caption)
                    .foregroundColor(.textTertiary)
            }
        }
        .sheet(isPresented: $showingTerms) {
            NavigationStack {
                TermsOfUseReadOnlyView()
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                showingTerms = false
                            }
                        }
                    }
            }
        }
    }
}

// MARK: - Terms Read-Only View (for viewing after acceptance)
struct TermsOfUseReadOnlyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                Text("Terms of Use")
                    .font(Typography.displayMedium)
                    .foregroundColor(.textPrimary)
                    .padding(.bottom, Spacing.sm)

                readOnlySection("1. Educational Purpose", "This application and all content contained herein are provided exclusively for educational and informational purposes. Nothing in this application constitutes financial advice, investment advice, tax advice, legal advice, or any other form of professional advisory service.")

                readOnlySection("2. No Financial Advice", "The information presented does not constitute a recommendation, solicitation, or offer to buy or sell any securities, financial instruments, or investment products. Past performance is not indicative of future results. All investment involves risk, including the possible loss of principal.")

                readOnlySection("3. Consult Your Financial Advisor", "Before making any investment decisions, consult with a qualified financial advisor, tax professional, or legal counsel. Untitled_ LuxPerpetua Technologies, Inc. does not hold a FINRA license and does not provide personalized investment advisory services.")

                readOnlySection("4. Regulatory Disclosure", "Untitled_ LuxPerpetua Technologies, Inc. operates under SEC 506(c) and Regulation A Blue Sky Laws. This application is not registered as an investment adviser under the Investment Advisers Act of 1940 (US), MiFID II (EU), FSMA 2000 (UK), or equivalent legislation in other jurisdictions.")

                readOnlySection("5. No Warranty", "Content is provided \"as is\" without warranty of any kind. No guarantee is made regarding reliability or suitability for any particular purpose.")

                readOnlySection("6. Limitation of Liability", "To the fullest extent permitted by applicable law, Untitled_ LuxPerpetua Technologies, Inc. and affiliated parties shall not be liable for any damages arising from use of or reliance on information in this application.")

                readOnlySection("7. Intellectual Property", "All content and materials are the intellectual property of Untitled_ LuxPerpetua Technologies, Inc. IP Patents Pending.")

                readOnlySection("8. Affiliate Links & Third-Party Bookstores", "This application contains links to books and other media available through Apple Books and other third-party platforms. These links may include affiliate identifiers. When you purchase content through an affiliate link, Untitled_ LuxPerpetua Technologies, Inc. may receive a commission at no additional cost to you. Recommendations are based on editorial merit and educational relevance; affiliate relationships do not influence which resources are recommended. You are never required to purchase any external content to use this application.")

                readOnlySection("9. International Users", "Users are responsible for compliance with all applicable local, state, national, and international laws and regulations.")

                Text("Copyright \u{00A9} 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.")
                    .font(Typography.caption2)
                    .foregroundColor(.textTertiary)
                    .padding(.top, Spacing.md)
            }
            .padding(Spacing.lg)
        }
        .background(Color.surfacePrimary)
        .navigationTitle("Terms of Use")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    private func readOnlySection(_ title: String, _ content: String) -> some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text(title)
                .font(Typography.bodyMedium)
                .foregroundColor(.textPrimary)
            Text(content)
                .font(Typography.caption)
                .foregroundColor(.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
                .lineSpacing(3)
        }
    }
}

// MARK: - Privacy Policy Link (for Settings)
struct PrivacyPolicyLinkView: View {
    @State private var showingPolicy = false

    var body: some View {
        Button {
            showingPolicy = true
        } label: {
            HStack {
                Text("Privacy Policy")
                Spacer()
                Image(systemName: "hand.raised")
                    .font(.caption)
                    .foregroundColor(.textTertiary)
            }
        }
        .sheet(isPresented: $showingPolicy) {
            NavigationStack {
                PrivacyPolicyView()
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                showingPolicy = false
                            }
                        }
                    }
            }
        }
    }
}

// MARK: - Privacy Policy View
struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                Text("Privacy Policy")
                    .font(Typography.displayMedium)
                    .foregroundColor(.textPrimary)
                    .padding(.bottom, Spacing.sm)

                Text("Effective Date: March 24, 2026")
                    .font(Typography.caption)
                    .foregroundColor(.textTertiary)

                policySection(
                    "1. Who We Are",
                    "Alternative Asset Literacy is an application operated by Untitled_ LuxPerpetua Technologies, Inc. We are the data controller for information processed through our app."
                )

                policySection(
                    "2. Information We Collect",
                    "This application stores the following data locally on your device using iOS standard storage (UserDefaults). This data is never transmitted to our servers:\n\n• Display name (optional, first name only) — used to personalize greetings\n• Learning progress — completed modules, sections, quiz scores, and time spent\n• Reflection journal entries — free-text entries you write about your learning\n• Display preferences — font style, text size, emoji preferences, course title\n\nAll app data remains on your device. We have no access to it and cannot retrieve it."
                )

                policySection(
                    "3. How We Use Information",
                    "All data stored by this application is used solely to personalize your learning experience, track your progress through educational modules, and maintain your display preferences. This data never leaves your device."
                )

                policySection(
                    "4. Third-Party Services",
                    "This application connects to third-party services solely for content delivery and payment processing. No personal user data is transmitted to these services. No third-party analytics, advertising, or tracking services are integrated into this application."
                )

                policySection(
                    "5. Data Storage & Security",
                    "All user data is stored locally on your device, protected by iOS Data Protection. Sensitive content such as reflection journal entries are encrypted using the iOS Keychain. You may delete all stored data at any time through Settings → \"Reset All Progress.\""
                )

                policySection(
                    "6. We Do Not Sell Your Data",
                    "We do not sell, rent, lease, or trade your personal information to any third party. We do not share your data with data brokers. We do not use your data for targeted advertising. This applies to all users regardless of location."
                )

                policySection(
                    "7. Your Rights Under CCPA (California)",
                    "If you are a California resident, the CCPA provides you with the right to know what personal information we collect, the right to delete it, the right to opt-out of sale (we do not sell data), and the right to non-discrimination. To exercise these rights, visit alternativeassetliteracy.com/contact and select \"Privacy / Data Request.\" We will respond within 45 days."
                )

                policySection(
                    "8. Your Rights Under GDPR (EEA)",
                    "If you are in the European Economic Area, the GDPR provides you with the right of access, rectification, erasure, data portability, the right to object, and the right to withdraw consent. App data is processed based on legitimate interest (providing the service you requested). To exercise these rights, visit alternativeassetliteracy.com/contact and select \"Privacy / Data Request.\" We will respond within 30 days."
                )

                policySection(
                    "9. Children's Privacy",
                    "This application is not directed at children under 13 (or under 16 in the EEA). We do not knowingly collect personal information from children. If we learn that we have collected personal information from a child, we will promptly delete it."
                )

                policySection(
                    "10. Changes to This Policy",
                    "We may update this Privacy Policy from time to time. Material changes will be noted with a revised effective date. Your continued use of the application after changes constitutes acceptance of the revised policy."
                )

                policySection(
                    "11. Contact",
                    "If you have questions about this Privacy Policy, your data, or wish to exercise any of your rights, please visit alternativeassetliteracy.com/contact."
                )

                Text("Copyright \u{00A9} 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.")
                    .font(Typography.caption2)
                    .foregroundColor(.textTertiary)
                    .padding(.top, Spacing.md)
            }
            .padding(Spacing.lg)
        }
        .background(Color.surfacePrimary)
        .navigationTitle("Privacy Policy")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    private func policySection(_ title: String, _ content: String) -> some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text(title)
                .font(Typography.bodyMedium)
                .foregroundColor(.textPrimary)
            Text(content)
                .font(Typography.caption)
                .foregroundColor(.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
                .lineSpacing(3)
        }
    }
}

// MARK: - Image Credits Link (for Settings)
struct ImageCreditsLinkView: View {
    @State private var showingCredits = false

    var body: some View {
        Button {
            showingCredits = true
        } label: {
            HStack {
                Text("Image Credits")
                Spacer()
                Image(systemName: "photo.on.rectangle")
                    .font(.caption)
                    .foregroundColor(.textTertiary)
            }
        }
        .sheet(isPresented: $showingCredits) {
            NavigationStack {
                ImageCreditsView()
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                showingCredits = false
                            }
                        }
                    }
            }
        }
    }
}

// MARK: - Image Credits View
struct ImageCreditsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                Text("Image Credits")
                    .font(Typography.displayMedium)
                    .foregroundColor(.textPrimary)
                    .padding(.bottom, Spacing.xs)

                Text("All artwork used in this application is in the public domain or used with appropriate licensing. Original works have been cropped and overlaid with typography for educational context.")
                    .font(Typography.caption)
                    .foregroundColor(.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineSpacing(3)
                    .padding(.bottom, Spacing.sm)

                // App Icon
                imageCredit(
                    image: "original_app_icon",
                    title: "Public Secondary Education of Young Women",
                    artist: "Louis-Oscar Roty",
                    date: "1884",
                    medium: "Bronze medal",
                    source: "Public domain",
                    usage: "App icon"
                )

                Divider()

                // Module hero images
                imageCredit(
                    image: "original_women",
                    title: "Portrait of a Young Woman",
                    artist: "Rogier van der Weyden",
                    date: "c. 1460",
                    medium: "Oil on panel",
                    source: "Public domain",
                    usage: "Investing Primer module"
                )

                imageCredit(
                    image: "original_alt_assets",
                    title: "Madonna and Child Enthroned with Saints",
                    artist: "Italian Renaissance, School of Ferrara",
                    date: "c. early 16th century",
                    medium: "Oil on panel",
                    source: "Public domain",
                    usage: "Alternative Asset Classes module"
                )

                imageCredit(
                    image: "original_behavioral",
                    title: "Portrait of a Young Woman in Red",
                    artist: "Unknown artist, Roman Period",
                    date: "A.D. 90–120",
                    medium: "Encaustic on wood",
                    source: "Public domain",
                    usage: "Behavioral Economics module"
                )

                imageCredit(
                    image: "original_art",
                    title: "Portrait d'une femme noire",
                    artist: "Marie-Guillemine Benoist (née Le Roulx de La Ville), French",
                    date: "1800",
                    medium: "Oil on canvas",
                    source: "Public domain. Mus\u{00E9}e du Louvre, Paris. INV 2508",
                    usage: "Art as Investment module"
                )

                imageCredit(
                    image: "original_gender",
                    title: "A Lady Writing",
                    artist: "Johannes Vermeer",
                    date: "c. 1665",
                    medium: "Oil on canvas",
                    source: "Public domain. National Gallery of Art, Washington, D.C.",
                    usage: "Gender and Behavioral Investing module"
                )

                imageCredit(
                    image: "original_defi",
                    title: "Portrait of a Lady",
                    artist: "John Singleton Copley (attributed)",
                    date: "c. 1760s",
                    medium: "Oil on canvas",
                    source: "Public domain",
                    usage: "Decentralized Finance module"
                )

                imageCredit(
                    image: "original_defi_investing",
                    title: "The Siesta",
                    artist: "Paul Gauguin",
                    date: "c. 1892\u{2013}94",
                    medium: "Oil on canvas",
                    source: "Public domain",
                    usage: "DeFi Investing module"
                )

                imageCredit(
                    image: "original_climate",
                    title: "The Trojan Women Setting Fire to Their Fleet",
                    artist: "Claude Lorrain (Claude Gellée), French",
                    date: "ca. 1643",
                    medium: "Oil on canvas",
                    source: "Public domain",
                    usage: "Climate, Energy & RWA module"
                )

                imageCredit(
                    image: "original_kahlo_basquiat",
                    title: "Dos Mujeres (Two Women)",
                    artist: "Frida Kahlo",
                    date: "1929",
                    medium: "Oil on canvas",
                    source: "Used under fair use for educational purposes",
                    usage: "Kahlo x Basquiat module"
                )

                Text("Copyright \u{00A9} 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved. Artwork reproductions are used for non-commercial educational purposes.")
                    .font(Typography.caption2)
                    .foregroundColor(.textTertiary)
                    .padding(.top, Spacing.md)
            }
            .padding(Spacing.lg)
        }
        .background(Color.surfacePrimary)
        .navigationTitle("Image Credits")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    @ViewBuilder
    private func imageCredit(
        image: String?,
        title: String,
        artist: String,
        date: String,
        medium: String,
        source: String,
        usage: String
    ) -> some View {
        HStack(alignment: .top, spacing: Spacing.md) {
            if let imageName = image {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 56, height: 56)
                    .clipShape(RoundedRectangle(cornerRadius: CornerRadius.sm))
            } else {
                #if canImport(UIKit)
                let appIconImage = UIImage(named: "AppIcon") ?? UIImage(named: "app-icon")
                if let appIcon = appIconImage {
                    Image(uiImage: appIcon)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 56, height: 56)
                        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.sm))
                } else {
                    RoundedRectangle(cornerRadius: CornerRadius.sm)
                        .fill(Color.surfaceTertiary)
                        .frame(width: 56, height: 56)
                }
                #else
                RoundedRectangle(cornerRadius: CornerRadius.sm)
                    .fill(Color.surfaceTertiary)
                    .frame(width: 56, height: 56)
                #endif
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(Typography.bodyMedium)
                    .foregroundColor(.textPrimary)
                Text("\(artist), \(date)")
                    .font(Typography.citation)
                    .foregroundColor(.textSecondary)
                Text(medium)
                    .font(Typography.caption)
                    .foregroundColor(.textTertiary)
                Text(source)
                    .font(Typography.caption2)
                    .foregroundColor(.textTertiary)
                Text(usage)
                    .font(Typography.caption2)
                    .foregroundColor(.brandPrimary)
            }
        }
        .padding(.vertical, Spacing.xs)
    }
}

// MARK: - FAQ & Troubleshooting Link (for Settings)
struct FAQLinkView: View {
    @State private var showingFAQ = false

    var body: some View {
        Button {
            showingFAQ = true
        } label: {
            HStack {
                Text("FAQ & Troubleshooting")
                Spacer()
                Image(systemName: "questionmark.circle")
                    .font(.caption)
                    .foregroundColor(.textTertiary)
            }
        }
        .sheet(isPresented: $showingFAQ) {
            NavigationStack {
                FAQContentView()
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                showingFAQ = false
                            }
                        }
                    }
            }
        }
    }
}

// MARK: - FAQ Content View
struct FAQContentView: View {
    private let faqSections: [(title: String, items: [(question: String, answer: String)])] = [
        (
            title: "Getting Started",
            items: [
                (
                    question: "What is Alternative Asset Literacy?",
                    answer: "Alternative Asset Literacy is an educational app covering non-traditional investment categories — art, DeFi, ESG/climate investing, behavioral finance, and more. Each module is a self-contained course with readings, citations, and interactive tools."
                ),
                (
                    question: "How do I track my progress?",
                    answer: "Progress is tracked automatically as you read through module sections. The Progress tab shows your completion across all modules. Sections are marked complete once you've scrolled through them."
                ),
                (
                    question: "Do I need an internet connection?",
                    answer: "No. The app works fully offline. All core content is available without a connection. When online, the app fetches the latest version of each module — but if that's unavailable, you'll see the locally cached version instead."
                ),
            ]
        ),
        (
            title: "Content & Modules",
            items: [
                (
                    question: "Why does content sometimes disappear or look incomplete?",
                    answer: "The app pulls live content from our content management system. Occasionally it is briefly unreachable or slow to respond. When this happens, the app falls back to the last cached version. Go to Settings → Data → Refresh Content to pull the latest version."
                ),
                (
                    question: "Content disappeared — what do I do?",
                    answer: "This is normal and easy to fix. Go to Settings → Data → Refresh Content and tap the button. The app will reconnect and restore the full module content. If the issue persists, check your internet connection and try again."
                ),
                (
                    question: "How often is content updated?",
                    answer: "Module content is updated directly in our content system and reflected in the app the next time you refresh. No app update is required — tap Refresh Content in Settings at any time to pull the latest version."
                ),
                (
                    question: "Why do the Sources & Bibliography tabs show fewer citations than the text?",
                    answer: "The bibliography lists every citation referenced in the module body. If citations are missing, try refreshing content from Settings. Modules such as ESG and DeFi Investing have over 100 sources, all of which are included in the offline version."
                ),
            ]
        ),
        (
            title: "Troubleshooting",
            items: [
                (
                    question: "The app is showing an older version of a module.",
                    answer: "Tap Refresh Content in Settings → Data. The app caches content locally so it's always available offline — the Refresh button forces a fresh pull from the server."
                ),
                (
                    question: "My progress disappeared.",
                    answer: "Progress is stored locally on your device. If you deleted and reinstalled the app, progress cannot be recovered. If progress is missing after a normal update, please contact us at case@untitledfinancial.com."
                ),
                (
                    question: "The app is slow or not loading.",
                    answer: "The app loads content in the background. If the server is slow, you'll see the cached version immediately while the refresh runs. You can always use the app fully offline without any delay."
                ),
                (
                    question: "How do I contact support?",
                    answer: "Reach us at case@untitledfinancial.com. We aim to respond within one business day."
                ),
            ]
        ),
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                Text("FAQ & Troubleshooting")
                    .font(Typography.displayMedium)
                    .foregroundColor(.textPrimary)
                    .padding(.bottom, Spacing.sm)

                ForEach(faqSections, id: \.title) { section in
                    VStack(alignment: .leading, spacing: Spacing.md) {
                        Text(section.title)
                            .font(Typography.bodyMedium)
                            .foregroundColor(.textPrimary)

                        ForEach(section.items, id: \.question) { item in
                            faqEntry(question: item.question, answer: item.answer)
                        }
                    }
                }

                Text("Copyright \u{00A9} 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.")
                    .font(Typography.caption2)
                    .foregroundColor(.textTertiary)
                    .padding(.top, Spacing.md)
            }
            .padding(Spacing.lg)
        }
        .background(Color.surfacePrimary)
        .navigationTitle("FAQ & Troubleshooting")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    private func faqEntry(question: String, answer: String) -> some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text(question)
                .font(Typography.bodyMedium)
                .foregroundColor(.textPrimary)
            Text(answer)
                .font(Typography.caption)
                .foregroundColor(.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
                .lineSpacing(3)
        }
    }
}
