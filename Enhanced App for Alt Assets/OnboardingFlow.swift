//
//  OnboardingFlow.swift
//  Enhanced App for Alt Assets
//
//  Created by Victoria Case on 4/14/26.
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//
//  Description: First-launch onboarding flow. Shows the full Terms of Use
//  first, then collects name and optional email before entering the app.
//

import SwiftUI

// MARK: - Onboarding Flow
struct OnboardingFlow: View {
    @Binding var isComplete: Bool
    @EnvironmentObject var userSettings: UserSettings

    @State private var hasAcceptedTerms = false
    @State private var nameInput = ""
    @State private var emailInput = ""

    var body: some View {
        if !hasAcceptedTerms {
            // Step 1: Full Terms of Use (existing legal view)
            TermsOfUseView(hasAcceptedTerms: $hasAcceptedTerms)
        } else {
            // Step 2: Name + email collection
            OnboardingProfileStep(
                nameInput: $nameInput,
                emailInput: $emailInput,
                onContinue: {
                    userSettings.userName = nameInput.trimmingCharacters(in: .whitespaces)
                    if !emailInput.trimmingCharacters(in: .whitespaces).isEmpty {
                        UserDefaults.standard.set(emailInput.trimmingCharacters(in: .whitespaces).lowercased(), forKey: "userEmail")
                    }
                    UserDefaults.standard.set(true, forKey: "has_completed_onboarding")
                    withAnimation(.smoothSpring) {
                        isComplete = true
                    }
                }
            )
        }
    }
}

// MARK: - Profile Step (Name + Email)
private struct OnboardingProfileStep: View {
    @Binding var nameInput: String
    @Binding var emailInput: String
    let onContinue: () -> Void
    @FocusState private var focusedField: Field?
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    enum Field {
        case name, email
    }

    private var canContinue: Bool {
        !nameInput.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(alignment: .leading, spacing: Spacing.lg) {
                Text("What should we\ncall you?")
                    .font(Typography.displayMedium)
                    .foregroundColor(.textPrimary)

                Text("Just your first name or nickname will do the trick")
                    .font(Typography.body)
                    .foregroundColor(.textSecondary)

                VStack(spacing: Spacing.md) {
                    TextField("First name or nickname", text: $nameInput)
                        .font(Typography.bodyLarge)
                        .textFieldStyle(.plain)
                        .padding(Spacing.md)
                        .background(Color.surfaceSecondary)
                        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
                        .overlay(
                            RoundedRectangle(cornerRadius: CornerRadius.md)
                                .stroke(focusedField == .name ? Color.brandPrimary : Color.divider, lineWidth: 1)
                        )
                        .focused($focusedField, equals: .name)
                        .textContentType(.givenName)
                        .submitLabel(.next)
                        .onSubmit { focusedField = .email }

                    TextField("Email (optional)", text: $emailInput)
                        .font(Typography.bodyLarge)
                        .textFieldStyle(.plain)
                        .padding(Spacing.md)
                        .background(Color.surfaceSecondary)
                        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
                        .overlay(
                            RoundedRectangle(cornerRadius: CornerRadius.md)
                                .stroke(focusedField == .email ? Color.brandPrimary : Color.divider, lineWidth: 1)
                        )
                        .focused($focusedField, equals: .email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .submitLabel(.done)
                        .onSubmit {
                            if canContinue {
                                focusedField = nil
                                DispatchQueue.main.async { onContinue() }
                            }
                        }
                }
            }
            .padding(.horizontal, Spacing.xl)
            .frame(maxWidth: horizontalSizeClass == .regular ? 540 : .infinity)
            .frame(maxWidth: .infinity)

            Spacer()
            Spacer()

            // Continue button
            Button(action: {
                focusedField = nil // clear focus before dismissing to avoid iPad focus crash
                DispatchQueue.main.async { onContinue() }
            }) {
                Text("That's me!")
                    .font(Typography.bodyMedium)
                    .foregroundColor(canContinue ? .white : .textTertiary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Spacing.md)
                    .background(canContinue ? Color.brandPrimary : Color.surfaceTertiary)
                    .clipShape(RoundedRectangle(cornerRadius: CornerRadius.lg))
            }
            .buttonStyle(.plain)
            .disabled(!canContinue)
            .padding(.horizontal, Spacing.xl)

            // Skip option
            Button {
                focusedField = nil
                nameInput = ""
                emailInput = ""
                DispatchQueue.main.async { onContinue() }
            } label: {
                Text("Skip for now")
                    .font(Typography.caption)
                    .foregroundColor(.textTertiary)
            }
            .padding(.top, Spacing.sm)
            .padding(.bottom, Spacing.xl)
        }
        .background(Color.surfacePrimary)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                focusedField = .name
            }
        }
    }
}

// MARK: - Preview
#Preview("Onboarding Flow") {
    OnboardingFlow(isComplete: .constant(false))
        .environmentObject(UserSettings.shared)
}
