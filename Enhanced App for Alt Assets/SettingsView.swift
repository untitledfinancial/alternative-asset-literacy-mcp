//
//  SettingsView.swift
//  Enhanced App for Alt Assets
//
//  Created by Victoria Case on 2/1/26.
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//
//  Description: App settings interface for managing user preferences,
//  viewing app information, and resetting progress data.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var progressManager: ProgressManager
    @EnvironmentObject var userSettings: UserSettings
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @Environment(\.dismiss) private var dismiss

    @EnvironmentObject var notionService: NotionService

    @State private var showingResetConfirmation = false
    @State private var showPaywall = false
    @State private var isSyncing = false
    @State private var syncMessage: String? = nil

    var body: some View {
        NavigationStack {
            Form {
                // Typography Section (like Notion)
                SwiftUI.Section {
                    // Font Style Picker
                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        Text("Style")
                            .font(Typography.caption)
                            .foregroundColor(.textSecondary)

                        HStack(spacing: Spacing.sm) {
                            ForEach(FontStyle.allCases) { style in
                                FontStyleButton(
                                    style: style,
                                    isSelected: userSettings.fontStyle == style
                                ) {
                                    withAnimation(.smoothSpring) {
                                        userSettings.fontStyle = style
                                    }
                                }
                            }
                        }
                    }

                    // Text Size
                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        HStack {
                            Text("Text size")
                                .font(Typography.caption)
                                .foregroundColor(.textSecondary)

                            Spacer()

                            Text(userSettings.textSize.displayName)
                                .font(Typography.caption)
                                .foregroundColor(.textTertiary)
                        }

                        Picker("Text Size", selection: $userSettings.textSize) {
                            ForEach(TextSize.allCases) { size in
                                Text(size.displayName).tag(size)
                            }
                        }
                        .pickerStyle(.segmented)
                    }

                    // Additional options
                    Toggle(isOn: $userSettings.useSerifForBody) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Serif body text")
                                .font(Typography.body)
                            Text("Use elegant serif font for reading")
                                .font(Typography.caption)
                                .foregroundColor(.textTertiary)
                        }
                    }
                    .tint(.brandPrimary)

                } header: {
                    Label("Typography", systemImage: "textformat")
                }

                // Personalization Section
                SwiftUI.Section {
                    VStack(alignment: .leading, spacing: Spacing.xs) {
                        Text("Good evening,")
                            .font(Typography.caption)
                            .foregroundColor(.brandPrimary.opacity(0.7))
                            .italic()
                        Text(userSettings.userName.isEmpty ? "Your Name" : userSettings.userName)
                            .font(.system(size: 28, weight: .light, design: .serif))
                            .foregroundColor(userSettings.userName.isEmpty ? .textTertiary : .brandPrimary)
                    }
                    .padding(.vertical, Spacing.sm)
                    .padding(.horizontal, Spacing.sm)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.brandPrimary.opacity(0.07))
                    .clipShape(RoundedRectangle(cornerRadius: CornerRadius.sm))
                    .listRowInsets(EdgeInsets(top: Spacing.sm, leading: Spacing.md, bottom: 0, trailing: Spacing.md))

                    TextField("Your Name", text: $userSettings.userName)
                        .textFieldStyle(.roundedBorder)

                    TextField("Course Name", text: $userSettings.courseName)
                        .textFieldStyle(.roundedBorder)

                    Text("Your name appears on the Learn screen greeting.")
                        .font(Typography.caption)
                        .foregroundColor(.textTertiary)
                } header: {
                    Label("Personalization", systemImage: "person.fill")
                }
                .tint(.brandPrimary)

                // Subscription
                SwiftUI.Section {
                    if subscriptionManager.isSubscribed {
                        HStack {
                            Label("Premium", systemImage: "checkmark.seal.fill")
                                .font(Typography.body)
                                .foregroundColor(.success)
                            Spacer()
                            if let expiry = subscriptionManager.expirationDate {
                                Text("Renews \(expiry, style: .date)")
                                    .font(Typography.caption)
                                    .foregroundColor(.textTertiary)
                            }
                        }
                    } else {
                        Button {
                            showPaywall = true
                        } label: {
                            HStack {
                                Label("Upgrade to Premium", systemImage: "crown")
                                    .font(Typography.body)
                                    .foregroundColor(.brandPrimary)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(.textTertiary)
                            }
                        }
                        .buttonStyle(.plain)

                        Button {
                            Task { await subscriptionManager.restorePurchases() }
                        } label: {
                            Label("Restore Purchases", systemImage: "arrow.clockwise")
                                .font(Typography.body)
                                .foregroundColor(.textSecondary)
                        }
                    }
                } header: {
                    Label("Subscription", systemImage: "crown")
                }

                // Data Management
                SwiftUI.Section {
                    Button {
                        isSyncing = true
                        syncMessage = nil
                        Task {
                            await notionService.fetchModules()
                            await notionService.enrichModulesWithDatabases()
                            isSyncing = false
                            syncMessage = notionService.error == nil ? "Content refreshed" : "Sync failed — using cached data"
                        }
                    } label: {
                        HStack {
                            Label("Refresh Content", systemImage: "arrow.clockwise")
                            Spacer()
                            if isSyncing {
                                ProgressView()
                                    .scaleEffect(0.8)
                            } else if let msg = syncMessage {
                                Text(msg)
                                    .font(Typography.caption)
                                    .foregroundColor(msg.contains("failed") ? .brandHighlight : .textSecondary)
                            } else if let date = notionService.lastSyncDate {
                                Text(date.formatted(.relative(presentation: .named)))
                                    .font(Typography.caption)
                                    .foregroundColor(.textTertiary)
                            }
                        }
                    }
                    .disabled(isSyncing)

                    Button(role: .destructive) {
                        showingResetConfirmation = true
                    } label: {
                        Label("Reset All Progress", systemImage: "trash")
                    }
                } header: {
                    Label("Data", systemImage: "externaldrive")
                } footer: {
                    Text("This will delete all your progress, reflections, and quiz scores.")
                        .font(Typography.caption)
                }

                // Legal & About
                SwiftUI.Section {
                    FAQLinkView()
                    TermsOfUseLinkView()
                    PrivacyPolicyLinkView()
                    ImageCreditsLinkView()

                    LabeledContent("Version", value: Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0")
                    LabeledContent("Build", value: Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "1")

                } header: {
                    Label("About", systemImage: "info.circle")
                } footer: {
                    VStack(spacing: 4) {
                        Text("Founded & built by Victoria Lee Case")
                            .font(Typography.caption2)
                        Text("\u{00A9} 2026 Untitled_ LuxPerpetua Technologies, Inc.")
                            .font(Typography.caption2)
                        Text("All rights reserved.")
                            .font(Typography.caption2)
                    }
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                }
            }
            .formStyle(.grouped)
            .scrollContentBackground(.hidden)
            .background(Color.surfacePrimary)
            .navigationTitle("Settings")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView()
            }
            .alert("Reset All Progress?", isPresented: $showingResetConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Reset", role: .destructive) {
                    resetProgress()
                }
            } message: {
                Text("This will permanently delete all your learning progress, reflections, and quiz scores.")
            }
        }
        #if os(macOS)
        .frame(minWidth: 500, minHeight: 600)
        #endif
    }

    private func resetProgress() {
        progressManager.resetProgress()
        // Also clear sensitive data from Keychain (reflection entries, advisor notes)
        KeychainHelper.deleteAll()
        dismiss()
    }
}

// MARK: - Font Style Button (like Notion)
struct FontStyleButton: View {
    let style: FontStyle
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: Spacing.xs) {
                Text("Ag")
                    .font(style.headingFont(size: 24, weight: .medium))
                    .foregroundColor(isSelected ? .brandPrimary : .textSecondary)

                Text(style.displayName)
                    .font(Typography.caption2)
                    .foregroundColor(isSelected ? .brandPrimary : .textTertiary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, Spacing.sm)
            .background(
                RoundedRectangle(cornerRadius: CornerRadius.sm)
                    .fill(isSelected ? Color.brandPrimary.opacity(0.1) : Color.clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.sm)
                    .stroke(isSelected ? Color.brandPrimary : Color.divider, lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    SettingsView()
        .environmentObject(ProgressManager())
        .environmentObject(UserSettings.shared)
        .environmentObject(SubscriptionManager())
        .environmentObject(NotionService())
}
