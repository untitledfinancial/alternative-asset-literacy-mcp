//
//  SettingsView.swift
//  Enhanced App for Alt Assets
//
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var progressManager: ProgressManager
    @EnvironmentObject var userSettings: UserSettings
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @EnvironmentObject var notionService: NotionService
    @Environment(\.dismiss) private var dismiss

    @State private var showingResetConfirmation = false
    @State private var showPaywall = false
    @State private var isSyncing = false
    @State private var syncMessage: String? = nil
    @State private var versionTapCount = 0

    var body: some View {
        NavigationStack {
            Form {
                readingSection
                personalizationSection
                accessSection
                contentSection
                if !subscriptionManager.isSubscribed || versionTapCount >= 5 {
                    developerSection
                }
                aboutSection
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                        .fontWeight(.semibold)
                }
            }
            .sheet(isPresented: $showPaywall) { PaywallView() }
            .alert("Reset All Progress?", isPresented: $showingResetConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Reset", role: .destructive) { resetProgress() }
            } message: {
                Text("This will permanently delete all your learning progress, reflections, and quiz scores.")
            }
        }
    }

    // MARK: - Sections

    private var readingSection: some View {
        Section("Reading") {
            VStack(alignment: .leading, spacing: Spacing.sm) {
                Text("Style")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                HStack(spacing: Spacing.sm) {
                    ForEach(FontStyle.allCases) { style in
                        FontStyleButton(style: style, isSelected: userSettings.fontStyle == style) {
                            withAnimation(.smoothSpring) { userSettings.fontStyle = style }
                        }
                    }
                }
            }

            VStack(alignment: .leading, spacing: Spacing.sm) {
                HStack {
                    Text("Text Size")
                    Spacer()
                    Text(userSettings.textSize.displayName)
                        .foregroundColor(.secondary)
                }
                Picker("Text Size", selection: $userSettings.textSize) {
                    ForEach(TextSize.allCases) { size in
                        Text(size.displayName).tag(size)
                    }
                }
                .pickerStyle(.segmented)
            }

            Toggle(isOn: $userSettings.useSerifForBody) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Serif Body Text")
                    Text("Elegant serif font for reading")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .tint(.brandPrimary)
        }
    }

    private var personalizationSection: some View {
        Section {
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text("Good evening,")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .italic()
                Text(userSettings.userName.isEmpty ? "Your Name" : userSettings.userName)
                    .font(.system(size: 26, weight: .light, design: .serif))
                    .foregroundColor(userSettings.userName.isEmpty ? .secondary : .brandPrimary)
            }
            .padding(.vertical, Spacing.xs)
            TextField("Your Name", text: $userSettings.userName)
            TextField("Course Name", text: $userSettings.courseName)
        } header: {
            Text("Personalization")
        } footer: {
            Text("Your name appears on the Learn screen greeting.")
        }
    }

    private var accessSection: some View {
        Section("Access") {
            if subscriptionManager.isSubscribed {
                Label("Premium Active", systemImage: "checkmark.seal.fill")
                    .foregroundColor(.success)
                if let expiry = subscriptionManager.expirationDate {
                    LabeledContent("Renews", value: expiry.formatted(date: .abbreviated, time: .omitted))
                }
            } else {
                Button { showPaywall = true } label: {
                    Label("Upgrade to Premium", systemImage: "crown")
                }
                Button {
                    Task { await subscriptionManager.restorePurchases() }
                } label: {
                    Label("Restore Purchases", systemImage: "arrow.clockwise")
                        .foregroundColor(.secondary)
                }
            }
        }
    }

    private var contentSection: some View {
        Section {
            Button {
                isSyncing = true
                syncMessage = nil
                Task {
                    await notionService.fetchModules()
                    await notionService.enrichModulesWithDatabases()
                    isSyncing = false
                    if let err = notionService.error {
                        syncMessage = err
                    } else {
                        let total = notionService.modules.map { $0.sections.count }.reduce(0, +)
                        syncMessage = "Refreshed — \(notionService.modules.count) modules, \(total) sections"
                    }
                }
            } label: {
                HStack {
                    Label("Refresh Content", systemImage: "arrow.clockwise")
                        .foregroundColor(isSyncing ? .secondary : .primary)
                    Spacer()
                    if isSyncing {
                        ProgressView().scaleEffect(0.8)
                    } else if let msg = syncMessage {
                        Text(msg)
                            .font(.caption)
                            .foregroundColor(msg.contains("❌") ? .red : .secondary)
                            .multilineTextAlignment(.trailing)
                    } else if let date = notionService.lastSyncDate {
                        Text(date.formatted(.relative(presentation: .named)))
                            .font(.caption)
                            .foregroundColor(.secondary)
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
            Text("Content")
        } footer: {
            Text("Resets all progress, reflections, and quiz scores.")
        }
    }

    private var developerSection: some View {
        Section("Developer") {
            Toggle(isOn: Binding(
                get: { subscriptionManager.screenshotModeEnabled },
                set: { subscriptionManager.screenshotModeEnabled = $0 }
            )) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Full Content Access")
                    Text("Bypass subscription gate for testing")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .tint(.brandPrimary)

            ForEach(notionService.modules, id: \.id) { mod in
                LabeledContent(mod.id, value: "\(mod.sections.count) sections")
            }
        }
    }

    private var aboutSection: some View {
        Section {
            FAQLinkView()
            TermsOfUseLinkView()
            PrivacyPolicyLinkView()
            ImageCreditsLinkView()
            LabeledContent("Version", value: Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0")
                .contentShape(Rectangle())
                .onTapGesture {
                    versionTapCount += 1
                    if versionTapCount == 5 {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    }
                }
            LabeledContent("Build", value: Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "1")
        } header: {
            Text("About")
        } footer: {
            VStack(spacing: 4) {
                Text("Founded & built by Victoria Lee Case")
                Text("© 2026 Untitled_ LuxPerpetua Technologies, Inc.")
                Text("All rights reserved.")
            }
            .frame(maxWidth: .infinity)
            .multilineTextAlignment(.center)
        }
    }

    private func resetProgress() {
        progressManager.resetProgress()
        KeychainHelper.deleteAll()
        dismiss()
    }
}

// MARK: - Font Style Button
struct FontStyleButton: View {
    let style: FontStyle
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: Spacing.xs) {
                Text("Ag")
                    .font(style.headingFont(size: 24, weight: .medium))
                    .foregroundColor(isSelected ? .brandPrimary : .secondary)
                Text(style.displayName)
                    .font(.caption2)
                    .foregroundColor(isSelected ? .brandPrimary : .secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, Spacing.sm)
            .background(
                RoundedRectangle(cornerRadius: CornerRadius.sm)
                    .fill(isSelected ? Color.brandPrimary.opacity(0.1) : Color.clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.sm)
                    .stroke(isSelected ? Color.brandPrimary : Color(.separator), lineWidth: isSelected ? 2 : 1)
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
