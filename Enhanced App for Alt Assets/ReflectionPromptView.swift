//
//  ReflectionPromptView.swift
//  Enhanced App for Alt Assets
//
//  Created by Victoria Case on 2/1/26.
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//
//  Description: Interface for responding to reflection prompts. Displays the question,
//  context, and provides a text editor for writing reflections. Saves entries to
//  private journal with module and section associations.
//

import SwiftUI

struct ReflectionPromptView: View {
    let prompt: ReflectionPrompt
    let moduleId: String
    @EnvironmentObject var progressManager: ProgressManager
    @Environment(\.dismiss) private var dismiss
    @State private var reflectionText = ""
    @State private var isSaved = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Prompt Question
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Reflection Prompt")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .textCase(.uppercase)
                        
                        Text(prompt.question)
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                    
                    // Context if available
                    if let context = prompt.context {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Context", systemImage: "info.circle")
                                .font(.headline)
                            Text(context)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                        .padding(16)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(12)
                    }
                    
                    Divider()
                    
                    // Writing Area
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Your Thoughts")
                            .font(.headline)
                        
                        Text("Take your time to reflect deeply. There are no right or wrong answers.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        TextEditor(text: $reflectionText)
                            .font(.body)
                            .frame(minHeight: 200)
                            .padding(8)
                            .background(Color.surfaceSecondary)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }
                    
                    // Writing Tips — focused on "Your Why"
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Explore Your Why", systemImage: "lightbulb.fill")
                            .font(.headline)
                            .foregroundColor(.brandPrimary)

                        Text("These reflections are about discovering your personal relationship with investing and money.")
                            .font(.caption)
                            .foregroundColor(.textSecondary)

                        VStack(alignment: .leading, spacing: 8) {
                            TipRow(text: "What motivates you to learn about investing?")
                            TipRow(text: "How does this connect to your personal values and goals?")
                            TipRow(text: "What assumptions about money are you carrying?")
                            TipRow(text: "How might this knowledge change your approach?")
                        }
                    }
                    .padding(Spacing.md)
                    .background(Color.surfaceTertiary.opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
                    
                    // Save Status
                    if isSaved {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("Reflection saved successfully!")
                                .font(.caption)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
                .padding(.horizontal, Spacing.lg)
                .padding(.vertical, Spacing.lg)
            }
            .navigationTitle("Reflection")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveReflection()
                    }
                    .disabled(reflectionText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
        #if os(macOS)
        .frame(minWidth: 600, minHeight: 700)
        #endif
        .onAppear {
            loadExistingReflection()
        }
    }
    
    private func loadExistingReflection() {
        if let existing = progressManager.getReflection(for: prompt.id) {
            reflectionText = existing.content
        }
    }
    
    private func saveReflection() {
        progressManager.saveReflection(
            promptId: prompt.id,
            moduleId: moduleId,
            sectionId: prompt.relatedSections.first,
            content: reflectionText
        )
        
        withAnimation {
            isSaved = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            dismiss()
        }
    }
}

struct TipRow: View {
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "checkmark")
                .font(.caption)
                .foregroundColor(.green)
            Text(text)
                .font(.caption)
        }
    }
}

#Preview {
    let samplePrompt = ReflectionPrompt(
        id: "1",
        question: "Describe a time you noticed anchoring bias in your own decision-making",
        context: "Anchoring bias occurs when we rely too heavily on the first piece of information we receive.",
        relatedSections: ["sec1"]
    )
    
    return ReflectionPromptView(
        prompt: samplePrompt,
        moduleId: "mod1"
    )
    .environmentObject(ProgressManager())
}
