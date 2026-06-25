//
//  FootnotesFeature.swift
//  Enhanced App for Alt Assets
//
//  Created by Victoria Case on 2/5/26.
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//
//  Description: Footnotes feature providing multiple ways to use research
//  citations: inline references, bibliography, research deep-dives,
//  and "Did You Know?" facts. Integrates with the Notion Footnotes database.
//

import SwiftUI
import Combine

// MARK: - Footnote Model
struct Footnote: Identifiable, Codable, Hashable {
    let id: String
    let number: Double
    let title: String
    let author: String
    let url: String?
    let modules: [String]
    let datePublished: String?
    let appleBooksURL: String?

    init(id: String, number: Double, title: String, author: String, url: String?, modules: [String], datePublished: String?, appleBooksURL: String? = nil) {
        self.id = id
        self.number = number
        self.title = title
        self.author = author
        self.url = url
        self.modules = modules
        self.datePublished = datePublished
        self.appleBooksURL = appleBooksURL
    }

    var formattedNumber: String {
        if number == floor(number) {
            return String(format: "%.0f", number)
        } else {
            return String(format: "%.1f", number)
        }
    }

    var displayCitation: String {
        var citation = title
        if !author.isEmpty {
            citation += " — \(author)"
        }
        return citation
    }
}

// MARK: - Footnotes Manager
class FootnotesManager: ObservableObject {
    @Published var footnotes: [Footnote] = []
    @Published var isLoading = false

    static let shared = FootnotesManager()

    init() {
        loadSampleFootnotes()
    }

    // Sample footnotes data (would normally load from Notion API)
    func loadSampleFootnotes() {
        footnotes = [
            Footnote(
                id: "fn-1",
                number: 1.1,
                title: "Alternative Investments 2020: The Future of Alternative Investments",
                author: "World Economic Forum",
                url: "https://www3.weforum.org/docs/WEF_Alternative_Investments_2020_Future.pdf",
                modules: ["Alternative Investing"],
                datePublished: "October 2015"
            ),
            Footnote(
                id: "fn-2",
                number: 17,
                title: "Boys Will Be Boys: Gender, Overconfidence, and Common Stock Investment",
                author: "Brad M. Barber and Terrance Odean",
                url: "https://faculty.haas.berkeley.edu/odean/papers/gender/BoysWillBeBoys.pdf",
                modules: ["Behavioral Economics"],
                datePublished: nil
            ),
            Footnote(
                id: "fn-3",
                number: 8,
                title: "The Brain that Changes Itself",
                author: "Norman Doidge, MD",
                url: nil,
                modules: ["Behavioral Economics"],
                datePublished: nil,
                appleBooksURL: "https://books.apple.com/us/book/the-brain-that-changes-itself/id357928935?at=1000l3by8"
            ),
            Footnote(
                id: "fn-4",
                number: 14,
                title: "Half of New US Entrepreneurs are Women, Leading a Creation Boom",
                author: "Alexandre Tanzi",
                url: nil,
                modules: ["Women and Collective Investing"],
                datePublished: nil
            ),
            Footnote(
                id: "fn-5",
                number: 9,
                title: "ESG Investing Through the Gender Lens",
                author: "MSCI",
                url: "https://www.msci.com",
                modules: ["Gender and Behavioral Economics"],
                datePublished: nil
            ),
            Footnote(
                id: "fn-6",
                number: 19.4,
                title: "Lake Wobegon Effect",
                author: "Oxford Reference",
                url: "https://www.oxfordreference.com/display/10.1093/oi/authority",
                modules: ["Behavioral Economics"],
                datePublished: nil
            ),
            Footnote(
                id: "fn-7",
                number: 7,
                title: "JPG File Sells for $69 Million, as 'NFT Mania' Gathers Pace",
                author: "Scott Reyburn",
                url: "https://www.nytimes.com/2021/03/11/arts/design/nft-auction-christies-beeple.html",
                modules: ["Art Investing"],
                datePublished: "March 2021"
            ),
            Footnote(
                id: "fn-8",
                number: 26,
                title: "The Art Collector's Handbook: The Definitive Guide to Acquiring and Owning Art",
                author: "Mary Rozell",
                url: nil,
                modules: ["Art Investing"],
                datePublished: nil,
                appleBooksURL: "https://books.apple.com/us/book/the-art-collectors-handbook/id1529188766?at=1000l3by8"
            ),
            Footnote(
                id: "fn-9",
                number: 14,
                title: "Gender Quotas and the Crisis of the Mediocre Man: Theory and Evidence from Sweden",
                author: "Timothy Besley, Olle Folke, Torsten Persson, Johanna Rickne",
                url: "https://eprints.lse.ac.uk/69193/",
                modules: ["Behavioral Economics"],
                datePublished: nil
            ),
            Footnote(
                id: "fn-10",
                number: 8,
                title: "How to Analyze a Real Estate Investment",
                author: "Catherine Cote",
                url: "https://online.hbs.edu/blog/post/real-estate-investment-analysis",
                modules: ["Alternative Investing"],
                datePublished: nil
            )
        ]
    }

    func footnotes(for module: String) -> [Footnote] {
        footnotes.filter { $0.modules.contains(module) }.sorted { $0.number < $1.number }
    }

    func randomFootnote() -> Footnote? {
        footnotes.randomElement()
    }

    func randomFact(for module: String) -> Footnote? {
        footnotes(for: module).randomElement()
    }
}

// MARK: - Feature 1: Inline Footnote Reference
struct InlineFootnoteView: View {
    let footnote: Footnote
    @State private var showingDetail = false

    var body: some View {
        Button {
            showingDetail = true
        } label: {
            Text("[\(footnote.formattedNumber)]")
                .font(.system(size: 8, weight: .bold))
                .foregroundColor(.brandPrimary)
                .baselineOffset(8)
        }
        .sheet(isPresented: $showingDetail) {
            FootnoteDetailSheet(footnote: footnote)
        }
    }
}

// MARK: - Feature 2: Bibliography View
struct BibliographyView: View {
    let footnotes: [Footnote]
    let moduleName: String

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack(spacing: Spacing.sm) {
                Text("📚")
                    .font(.system(size: 20))
                Text("Sources & References")
                    .font(Typography.bodyMedium)
                    .foregroundColor(.textPrimary)
            }

            VStack(alignment: .leading, spacing: Spacing.sm) {
                ForEach(footnotes.sorted { $0.number < $1.number }) { footnote in
                    BibliographyRow(footnote: footnote)
                }
            }
        }
        .padding(Spacing.md)
        .background(Color.surfaceSecondary)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
    }
}

struct BibliographyRow: View {
    let footnote: Footnote
    @State private var showingDetail = false

    var body: some View {
        Button {
            showingDetail = true
        } label: {
            HStack(alignment: .top, spacing: Spacing.sm) {
                Text("[\(footnote.formattedNumber)]")
                    .font(.system(size: 9, weight: .semibold))
                    .foregroundColor(.textTertiary)
                    .frame(width: 24, alignment: .leading)

                VStack(alignment: .leading, spacing: 2) {
                    Text(footnote.title)
                        .font(Typography.caption)
                        .foregroundColor(.textPrimary)
                        .multilineTextAlignment(.leading)

                    if !footnote.author.isEmpty {
                        Text(footnote.author)
                            .font(Typography.caption2)
                            .foregroundColor(.textTertiary)
                            .italic()
                    }
                }

                Spacer()

                if footnote.url != nil {
                    Image(systemName: "link")
                        .font(.caption)
                        .foregroundColor(.brandPrimary)
                } else if footnote.appleBooksURL != nil {
                    Image(systemName: "book.fill")
                        .font(.caption)
                        .foregroundColor(.brandPrimary)
                }
            }
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showingDetail) {
            FootnoteDetailSheet(footnote: footnote)
        }
    }
}

// MARK: - Feature 3: Research Deep Dive Card
struct ResearchDeepDiveCard: View {
    let footnote: Footnote
    @State private var showingDetail = false

    var body: some View {
        Button {
            showingDetail = true
        } label: {
            VStack(alignment: .leading, spacing: Spacing.sm) {
                HStack {
                    Text("🔬")
                        .font(.system(size: 16))
                    Text("Research Spotlight")
                        .font(Typography.captionMedium)
                        .foregroundColor(.textTertiary)
                    Spacer()
                }

                Text(footnote.title)
                    .font(Typography.bodyMedium)
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)

                if !footnote.author.isEmpty {
                    Text("by \(footnote.author)")
                        .font(Typography.caption)
                        .foregroundColor(.textSecondary)
                }

                HStack {
                    ForEach(footnote.modules.prefix(2), id: \.self) { module in
                        Text(module)
                            .font(Typography.caption2)
                            .padding(.horizontal, Spacing.xs)
                            .padding(.vertical, 2)
                            .background(Color.brandPrimary.opacity(0.1))
                            .foregroundColor(.brandPrimary)
                            .clipShape(Capsule())
                    }
                    Spacer()
                    Text("Read more →")
                        .font(Typography.caption)
                        .foregroundColor(.brandPrimary)
                }
            }
            .padding(Spacing.md)
            .background(Color.surfaceSecondary)
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showingDetail) {
            FootnoteDetailSheet(footnote: footnote)
        }
    }
}

// MARK: - Feature 4: "Did You Know?" Fact Card
struct DidYouKnowCard: View {
    let footnote: Footnote
    @State private var showingDetail = false

    var body: some View {
        Button {
            showingDetail = true
        } label: {
            VStack(alignment: .leading, spacing: Spacing.sm) {
                HStack {
                    Text("💡")
                        .font(.system(size: 20))
                    Text("Did You Know?")
                        .font(Typography.captionMedium)
                        .foregroundColor(.warning)
                    Spacer()
                }

                Text(factFromFootnote)
                    .font(Typography.body)
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.leading)

                HStack {
                    Text("Source: \(footnote.author.isEmpty ? "Research" : footnote.author)")
                        .font(Typography.caption2)
                        .foregroundColor(.textTertiary)
                    Spacer()
                    Text("Learn more")
                        .font(Typography.caption)
                        .foregroundColor(.brandPrimary)
                }
            }
            .padding(Spacing.md)
            .background(Color.warning.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.md)
                    .stroke(Color.warning.opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showingDetail) {
            FootnoteDetailSheet(footnote: footnote)
        }
    }

    // Generate engaging fact from footnote title
    private var factFromFootnote: String {
        // Generate contextual facts based on the footnote
        switch footnote.id {
        case "fn-2":
            return "Men trade 45% more frequently than women, often to their detriment due to overconfidence."
        case "fn-4":
            return "Half of all new entrepreneurs in the US are now women, leading a business creation boom."
        case "fn-7":
            return "In 2021, a single JPG file sold for $69 million, marking a watershed moment for NFTs."
        case "fn-9":
            return "Research shows gender quotas can improve organizational performance by reducing 'mediocre' appointments."
        default:
            return "This research from \(footnote.author.isEmpty ? "academic sources" : footnote.author) provides key insights into \(footnote.modules.first ?? "investing")."
        }
    }
}

// MARK: - Feature 5: Footnote Detail Sheet
struct FootnoteDetailSheet: View {
    let footnote: Footnote
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.lg) {
                    // Header
                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        Text("📖")
                            .font(.system(size: 40))

                        Text(footnote.title)
                            .font(Typography.title2)
                            .foregroundColor(.textPrimary)

                        if !footnote.author.isEmpty {
                            Text("by \(footnote.author)")
                                .font(Typography.body)
                                .foregroundColor(.textSecondary)
                        }
                    }

                    Divider()

                    // Details
                    VStack(alignment: .leading, spacing: Spacing.md) {
                        DetailRow(label: "Citation Number", value: footnote.formattedNumber)

                        if let date = footnote.datePublished {
                            DetailRow(label: "Published", value: date)
                        }

                        if !footnote.modules.isEmpty {
                            VStack(alignment: .leading, spacing: Spacing.xs) {
                                Text("Related Modules")
                                    .font(Typography.captionMedium)
                                    .foregroundColor(.textTertiary)

                                FlowLayout(spacing: Spacing.xs) {
                                    ForEach(footnote.modules, id: \.self) { module in
                                        Text(module)
                                            .font(Typography.caption)
                                            .padding(.horizontal, Spacing.sm)
                                            .padding(.vertical, Spacing.xxs)
                                            .background(Color.brandPrimary.opacity(0.1))
                                            .foregroundColor(.brandPrimary)
                                            .clipShape(Capsule())
                                    }
                                }
                            }
                        }
                    }

                    // URL Button
                    if let urlString = footnote.url, let url = URL(string: urlString) {
                        Divider()

                        Link(destination: url) {
                            HStack {
                                Image(systemName: "link")
                                Text("View Original Source")
                                Spacer()
                                Image(systemName: "arrow.up.right")
                            }
                            .font(Typography.bodyMedium)
                            .foregroundColor(.brandPrimary)
                            .padding(Spacing.md)
                            .background(Color.brandPrimary.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
                        }
                    }

                    // Apple Books Button
                    if let urlString = footnote.appleBooksURL, let url = URL(string: urlString) {
                        if footnote.url == nil {
                            Divider()
                        }

                        Link(destination: url) {
                            HStack(spacing: Spacing.xs) {
                                Image(systemName: "book.fill")
                                    .font(.system(size: 13))
                                Text("View on Apple Books")
                                Spacer()
                                Image(systemName: "arrow.up.right")
                            }
                            .font(Typography.bodyMedium)
                            .foregroundColor(.brandPrimary)
                            .padding(Spacing.md)
                            .background(Color.brandPrimary.opacity(0.08))
                            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
                        }
                    }

                    Spacer()
                }
                .padding(Spacing.lg)
            }
            .background(Color.surfacePrimary)
            .navigationTitle("Source Details")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct DetailRow: View {
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xxs) {
            Text(label)
                .font(Typography.captionMedium)
                .foregroundColor(.textTertiary)
            Text(value)
                .font(Typography.body)
                .foregroundColor(.textPrimary)
        }
    }
}

// MARK: - Flow Layout for Tags
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(in: proposal.width ?? 0, subviews: subviews, spacing: spacing)
        return CGSize(width: proposal.width ?? 0, height: result.height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(in: bounds.width, subviews: subviews, spacing: spacing)
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.positions[index].x,
                                       y: bounds.minY + result.positions[index].y),
                          proposal: .unspecified)
        }
    }

    struct FlowResult {
        var positions: [CGPoint] = []
        var height: CGFloat = 0

        init(in width: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var x: CGFloat = 0
            var y: CGFloat = 0
            var rowHeight: CGFloat = 0

            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)

                if x + size.width > width && x > 0 {
                    x = 0
                    y += rowHeight + spacing
                    rowHeight = 0
                }

                positions.append(CGPoint(x: x, y: y))
                rowHeight = max(rowHeight, size.height)
                x += size.width + spacing
            }

            height = y + rowHeight
        }
    }
}

// MARK: - Preview
#Preview("Did You Know") {
    VStack(spacing: 20) {
        DidYouKnowCard(
            footnote: Footnote(
                id: "fn-2",
                number: 17,
                title: "Boys Will Be Boys: Gender, Overconfidence, and Common Stock Investment",
                author: "Brad M. Barber and Terrance Odean",
                url: "https://faculty.haas.berkeley.edu/odean/papers/gender/BoysWillBeBoys.pdf",
                modules: ["Behavioral Economics"],
                datePublished: nil
            )
        )

        ResearchDeepDiveCard(
            footnote: Footnote(
                id: "fn-1",
                number: 1.1,
                title: "Alternative Investments 2020: The Future of Alternative Investments",
                author: "World Economic Forum",
                url: "https://www3.weforum.org/docs/WEF_Alternative_Investments_2020_Future.pdf",
                modules: ["Alternative Investing"],
                datePublished: "October 2015"
            )
        )
    }
    .padding()
    .background(Color.surfacePrimary)
}
