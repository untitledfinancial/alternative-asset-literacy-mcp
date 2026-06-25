//
//  ReflectionJournalView.swift
//  Enhanced App for Alt Assets
//
//  Created by Victoria Case on 2/1/26.
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//
//  Description: Private reflection journal displaying all user reflections across
//  modules. Supports searching, filtering by module, and reviewing past entries
//  to track learning insights over time.
//

import SwiftUI

struct ReflectionJournalView: View {
    @EnvironmentObject var progressManager: ProgressManager
    @EnvironmentObject var notionService: NotionService
    @State private var searchText = ""
    @State private var selectedModuleFilter: String?
    @State private var sortOrder: SortOrder = .newest
    @State private var showingReflectAgain = false
    @State private var reflectAgainContext: ReflectionEntry?
    @State private var reflectAgainLabel: String = ""

    enum SortOrder {
        case newest, oldest, byModule
    }

    /// Entries grouped by "this time" windows: last week (±2d), last month (±7d), last year (±30d)
    private var lookbackWindows: [(label: String, entries: [ReflectionEntry])] {
        let now = Date()
        let all = progressManager.progress.reflectionEntries

        func entries(center: Int, radius: Int) -> [ReflectionEntry] {
            all.filter { entry in
                let days = Calendar.current.dateComponents([.day], from: entry.createdAt, to: now).day ?? 0
                return days >= (center - radius) && days <= (center + radius)
            }.sorted { $0.createdAt > $1.createdAt }
        }

        var windows: [(label: String, entries: [ReflectionEntry])] = []
        let week = entries(center: 7, radius: 2)
        let month = entries(center: 30, radius: 7)
        let year = entries(center: 365, radius: 30)
        if !week.isEmpty  { windows.append(("This Time Last Week", week)) }
        if !month.isEmpty { windows.append(("This Time Last Month", month)) }
        if !year.isEmpty  { windows.append(("This Time Last Year", year)) }
        return windows
    }
    
    var filteredReflections: [ReflectionEntry] {
        var reflections = progressManager.progress.reflectionEntries
        
        // Filter by search
        if !searchText.isEmpty {
            reflections = reflections.filter {
                $0.content.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Filter by module
        if let moduleId = selectedModuleFilter {
            reflections = reflections.filter { $0.moduleId == moduleId }
        }
        
        // Sort
        switch sortOrder {
        case .newest:
            reflections.sort { $0.createdAt > $1.createdAt }
        case .oldest:
            reflections.sort { $0.createdAt < $1.createdAt }
        case .byModule:
            reflections.sort { $0.moduleId < $1.moduleId }
        }
        
        return reflections
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with filters
            headerSection
            
            Divider()
            
            // Reflections list
            if filteredReflections.isEmpty {
                emptyState
            } else {
                reflectionsList
            }
        }
        .navigationTitle("Reflection Journal")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                ShareLink(item: exportText, preview: SharePreview("Reflection Journal")) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
    }

    private var exportText: String {
        var lines: [String] = []
        lines.append("REFLECTION JOURNAL")
        lines.append(String(repeating: "─", count: 40))
        lines.append("")

        let grouped = Dictionary(grouping: filteredReflections) { entry -> String in
            notionService.modules.first(where: { $0.id == entry.moduleId })?.title ?? entry.moduleId
        }
        let sortedModules = grouped.keys.sorted()

        for moduleName in sortedModules {
            let entries = grouped[moduleName] ?? []
            lines.append(moduleName.uppercased())
            lines.append("")
            for entry in entries.sorted(by: { $0.createdAt > $1.createdAt }) {
                let dateStr = DateFormatter.localizedString(from: entry.createdAt, dateStyle: .medium, timeStyle: .none)
                lines.append("[\(dateStr)]")
                lines.append(entry.content)
                lines.append("")
            }
        }

        let dateStr = DateFormatter.localizedString(from: Date(), dateStyle: .long, timeStyle: .none)
        lines.append(String(repeating: "─", count: 40))
        lines.append("Exported \(dateStr) · alternativeassetsliteracy.com")
        return lines.joined(separator: "\n")
    }
    
    // MARK: - Header
    private var headerSection: some View {
        VStack(spacing: 16) {
            // Stats
            HStack(spacing: 24) {
                StatBadge(
                    value: "\(progressManager.progress.totalReflectionsWritten)",
                    label: "Total Reflections"
                )
                
                StatBadge(
                    value: "\(uniqueModulesCount)",
                    label: "Modules Explored"
                )
                
                StatBadge(
                    value: averageLength,
                    label: "Avg. Length"
                )
            }
            
            // Search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                
                TextField("Search reflections...", text: $searchText)
                    .textFieldStyle(.plain)
                
                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(12)
            .background(Color.surfaceSecondary)
            .cornerRadius(8)

            // Filters
            HStack {
                // Module filter
                Menu {
                    Button("All Modules") {
                        selectedModuleFilter = nil
                    }
                    
                    Divider()
                    
                    ForEach(notionService.modules) { module in
                        Button {
                            selectedModuleFilter = module.id
                        } label: {
                            HStack {
                                Text(module.icon)
                                Text(module.title)
                            }
                        }
                    }
                } label: {
                    HStack {
                        Text(selectedModuleFilter.map { moduleTitle($0) } ?? "All Modules")
                        Image(systemName: "chevron.down")
                    }
                    .font(.caption)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.blue.opacity(0.1))
                    .foregroundColor(.blue)
                    .cornerRadius(8)
                }
                
                // Sort order
                Menu {
                    Button {
                        sortOrder = .newest
                    } label: {
                        Label("Newest First", systemImage: sortOrder == .newest ? "checkmark" : "")
                    }
                    
                    Button {
                        sortOrder = .oldest
                    } label: {
                        Label("Oldest First", systemImage: sortOrder == .oldest ? "checkmark" : "")
                    }
                    
                    Button {
                        sortOrder = .byModule
                    } label: {
                        Label("By Module", systemImage: sortOrder == .byModule ? "checkmark" : "")
                    }
                } label: {
                    HStack {
                        Image(systemName: "arrow.up.arrow.down")
                        Text("Sort")
                    }
                    .font(.caption)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.green.opacity(0.1))
                    .foregroundColor(.green)
                    .cornerRadius(8)
                }
                
                Spacer()
            }
        }
        .padding()
        .background(Color.surfacePrimary)
    }
    
    // MARK: - Reflections List
    private var reflectionsList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                // Lookback thread cards: last week → last month → last year
                if searchText.isEmpty && selectedModuleFilter == nil {
                    ForEach(lookbackWindows, id: \.label) { window in
                        ThisTimeLastYearCard(label: window.label, entries: window.entries) { entry in
                            reflectAgainContext = entry
                            reflectAgainLabel = window.label
                            showingReflectAgain = true
                        }
                    }
                }

                ForEach(filteredReflections) { reflection in
                    ReflectionCard(reflection: reflection)
                }
            }
            .padding()
        }
        .sheet(isPresented: $showingReflectAgain) {
            if let original = reflectAgainContext {
                ReflectAgainView(original: original, windowLabel: reflectAgainLabel)
                    .environmentObject(progressManager)
                    .environmentObject(notionService)
            }
        }
    }
    
    // MARK: - Empty State
    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "pencil.and.list.clipboard")
                .font(.system(size: 64))
                .foregroundStyle(.gray.gradient)
            
            Text("No reflections yet")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Your reflections will appear here as you explore modules")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 400)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Helpers
    private var uniqueModulesCount: Int {
        Set(progressManager.progress.reflectionEntries.map { $0.moduleId }).count
    }
    
    private var averageLength: String {
        let totalWords = progressManager.progress.reflectionEntries.reduce(0) { sum, entry in
            sum + entry.content.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }.count
        }
        let avg = progressManager.progress.reflectionEntries.isEmpty ? 0 : totalWords / progressManager.progress.reflectionEntries.count
        return "\(avg) words"
    }
    
    private func moduleTitle(_ id: String) -> String {
        notionService.modules.first(where: { $0.id == id })?.title ?? "Unknown"
    }
}

// MARK: - Reflection Card
struct ReflectionCard: View {
    let reflection: ReflectionEntry
    @EnvironmentObject var notionService: NotionService
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                if let module = notionService.modules.first(where: { $0.id == reflection.moduleId }) {
                    HStack(spacing: 8) {
                        Text(module.icon)
                        Text(module.title)
                            .font(.headline)
                    }
                }
                
                Spacer()
                
                Text(formatDate(reflection.createdAt))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Divider()
            
            // Content
            Text(reflection.content)
                .font(.body)
                .lineLimit(isExpanded ? nil : 4)
                .fixedSize(horizontal: false, vertical: !isExpanded)
            
            // Expand/Collapse button
            if reflection.content.count > 200 {
                Button {
                    withAnimation {
                        isExpanded.toggle()
                    }
                } label: {
                    HStack {
                        Text(isExpanded ? "Show less" : "Show more")
                            .font(.caption)
                            .foregroundColor(.blue)
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
                .buttonStyle(.plain)
            }
            
            // Metadata
            HStack {
                Label("\(wordCount(reflection.content)) words", systemImage: "text.alignleft")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if reflection.updatedAt != reflection.createdAt {
                    Label("Edited", systemImage: "pencil")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(20)
        .background(Color.surfaceSecondary)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
    
    private func wordCount(_ text: String) -> Int {
        text.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }.count
    }
}

// MARK: - This Time Last Year Card
struct ThisTimeLastYearCard: View {
    let label: String
    let entries: [ReflectionEntry]
    let onReflectAgain: (ReflectionEntry) -> Void
    @EnvironmentObject var notionService: NotionService
    @State private var isExpanded = false

    private var primaryEntry: ReflectionEntry { entries[0] }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: "clock.arrow.circlepath")
                    .font(.system(size: 14))
                    .foregroundColor(.brandPrimary)
                Text(label)
                    .font(Typography.captionMedium)
                    .foregroundColor(.brandPrimary)
                Spacer()
                if entries.count > 1 {
                    Text("\(entries.count) entries")
                        .font(Typography.caption)
                        .foregroundColor(.textTertiary)
                }
            }

            if let module = notionService.modules.first(where: { $0.id == primaryEntry.moduleId }) {
                HStack(spacing: 6) {
                    Text(module.icon)
                    Text(module.title)
                        .font(Typography.caption)
                        .foregroundColor(.textSecondary)
                }
            }

            Text(primaryEntry.content)
                .font(Typography.body)
                .foregroundColor(.textPrimary)
                .lineLimit(isExpanded ? nil : 3)
                .fixedSize(horizontal: false, vertical: !isExpanded)

            HStack(spacing: Spacing.sm) {
                Button {
                    withAnimation { isExpanded.toggle() }
                } label: {
                    Text(isExpanded ? "Show less" : "Show more")
                        .font(Typography.caption)
                        .foregroundColor(.textTertiary)
                }
                .buttonStyle(.plain)

                Spacer()

                Button {
                    onReflectAgain(primaryEntry)
                } label: {
                    Text("Reflect Again")
                        .font(Typography.captionMedium)
                        .foregroundColor(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 7)
                        .background(Color.brandPrimary)
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(20)
        .background(Color.brandPrimary.opacity(0.06))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.brandPrimary.opacity(0.2), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Reflect Again View
struct ReflectAgainView: View {
    let original: ReflectionEntry
    let windowLabel: String
    @EnvironmentObject var progressManager: ProgressManager
    @EnvironmentObject var notionService: NotionService
    @Environment(\.dismiss) private var dismiss
    @State private var newContent = ""
    private var module: Module? { notionService.modules.first(where: { $0.id == original.moduleId }) }

    private var contextLabel: String {
        switch windowLabel {
        case "This Time Last Week":  return "Last week you wrote:"
        case "This Time Last Month": return "Last month you wrote:"
        case "This Time Last Year":  return "One year ago you wrote:"
        default:                     return "You wrote:"
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.lg) {
                    // Original entry context
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 6) {
                            Image(systemName: "clock.arrow.circlepath")
                                .font(.caption)
                                .foregroundColor(.textTertiary)
                            Text(contextLabel)
                                .font(Typography.caption)
                                .foregroundColor(.textTertiary)
                        }
                        Text(original.content)
                            .font(Typography.body)
                            .foregroundColor(.textSecondary)
                            .padding(Spacing.md)
                            .background(Color.surfaceSecondary)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }

                    Text("How has your thinking evolved?")
                        .font(Typography.title3)
                        .foregroundColor(.textPrimary)

                    TextEditor(text: $newContent)
                        .font(Typography.body)
                        .frame(minHeight: 160)
                        .padding(Spacing.sm)
                        .background(Color.surfaceSecondary)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .padding(Spacing.xl)
            }
            .navigationTitle(module.map { "\($0.icon) \($0.title)" } ?? "Reflect Again")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        guard !newContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
                        progressManager.saveReflection(
                            promptId: original.promptId,
                            moduleId: original.moduleId,
                            sectionId: original.sectionId,
                            content: newContent
                        )
                        dismiss()
                    }
                    .disabled(newContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

// MARK: - Stat Badge
struct StatBadge: View {
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    NavigationStack {
        ReflectionJournalView()
            .environmentObject(ProgressManager())
            .environmentObject(NotionService())
    }
}
