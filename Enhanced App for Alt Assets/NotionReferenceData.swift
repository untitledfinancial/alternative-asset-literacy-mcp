//
//  NotionReferenceData.swift
//  Enhanced App for Alt Assets
//
//  Created by Victoria Case on 2/6/26.
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//
//  Description: Reference content imported from Notion including Culture FAQ,
//  NFT information, and Library resources.
//

import Foundation

// MARK: - Culture FAQ Item
struct CultureFAQItem: Identifiable {
    let id: String
    let question: String
    let category: String
}

// MARK: - NFT Reference
struct NFTReference: Identifiable {
    let id: String
    let title: String
    let content: String
    let type: String // "callout", "quote", etc.
}

// MARK: - Library Resource
struct LibraryResource: Identifiable {
    let id: String
    let title: String
    let type: String // "podcast", "book", "digital"
}

/// Reference data loaded from Notion
struct NotionReferenceData {

    // MARK: - Culture & Behavioral FAQ
    static let cultureFAQs: [CultureFAQItem] = [
        CultureFAQItem(id: "faq_2", question: "Somatization_ The Somatic-Marker Hypothesis", category: "Behavioral Economics"),
        CultureFAQItem(id: "faq_3", question: "Mental Models", category: "Behavioral Economics"),
        CultureFAQItem(id: "faq_4", question: "New vs Established Wealth", category: "Behavioral Economics"),
        CultureFAQItem(id: "faq_5", question: "Where do \"meme\" stocks play into behavioral economics?", category: "Behavioral Economics"),
        CultureFAQItem(id: "faq_6", question: "What are key factors in blind spots for based on gender when investing in the markets?", category: "Behavioral Economics"),
        CultureFAQItem(id: "faq_7", question: "How does crypto trading play into behavioral economics?", category: "Behavioral Economics"),
        CultureFAQItem(id: "faq_8", question: "Does gender play a role in behavioral economics?", category: "Behavioral Economics"),
        CultureFAQItem(id: "faq_9", question: "How does Socioeconomic status play a role in Behavioral Economics?", category: "Behavioral Economics")
    ]

    // MARK: - NFT Reference Content
    static let nftContent: [NFTReference] = [
        NFTReference(id: "nft_0", title: "NFT Info", content: "Living Breathing NFT Wiki", type: "callout"),
        NFTReference(id: "nft_1", title: "NFT Info", content: "Tap on the \"toggle\" triangle to see answers! If you're on mobile, tap and hold to open links.", type: "callout"),
        NFTReference(id: "nft_2", title: "NFT Info", content: "\"Technological revolutions change everything, including art. That statement was just as true in the 15th century as it is in the 21st...\" \n_Martin Gayford, A History of Pictures", type: "quote"),
        NFTReference(id: "nft_3", title: "NFT Info", content: "Please remember, NFT and cryptocurrencies are done at your own risk. This is still the Wild West. There are typically few help desks. It is about building and navigating on your own and through different Discord rooms. ", type: "callout"),
        NFTReference(id: "nft_5", title: "NFT Info", content: "Copyright: Currently operated by Victoria Lee Case and Untitled_. ", type: "text")
    ]

    // MARK: - Quick Facts
    
    /// Key behavioral economics questions for reflection
    static var behavioralQuestions: [String] {
        cultureFAQs.map { $0.question }
    }
    
    /// NFT disclaimer and important notes
    static var nftDisclaimer: String {
        nftContent.first(where: { $0.content.contains("risk") })?.content ?? ""
    }
}
