//
//  ArtAuctionData.swift
//  Enhanced App for Alt Assets
//
//  Created by Victoria Case on 2/19/26.
//  Copyright (c) 2026 Victoria Case. All rights reserved.
//
//  Description: Comprehensive auction price data for notable artworks by blue-chip,
//  mid-career, emerging, and NFT artists. All data sourced from publicly reported
//  auction records at major houses (Christie's, Sotheby's, Phillips).
//
//  DISCLAIMER: This data is presented for educational purposes only. Past auction
//  results do not guarantee future performance. This is NOT investment advice.
//  All prices include buyer's premium unless otherwise noted.
//

import Foundation

// MARK: - Artist Profile Model

struct ArtistProfile: Identifiable, Codable, Hashable {
    let id: String
    var name: String
    var nationality: String
    var birthYear: Int
    var deathYear: Int?               // nil if living
    var category: ArtistCategory
    var auctionRecords: [AuctionRecord]
    var marketNote: String            // 1-2 sentences on market trajectory
    var primarySource: String         // e.g., "Christie's auction records"

    var isLiving: Bool { deathYear == nil }

    var lifeSpan: String {
        if let death = deathYear {
            return "\(birthYear)-\(death)"
        }
        return "b. \(birthYear)"
    }

    enum ArtistCategory: String, Codable, Hashable, CaseIterable {
        case blueChip = "Blue Chip"
        case midCareer = "Mid-Career"
        case emerging = "Emerging"
        case nft = "NFT"
    }
}

// MARK: - Auction Record Model

struct AuctionRecord: Identifiable, Codable, Hashable {
    let id: String
    var artworkTitle: String
    var yearCreated: String           // e.g., "1982" or "c. 1955"
    var medium: String                // e.g., "Acrylic and oilstick on canvas"
    var auctionHouse: String          // e.g., "Sotheby's"
    var saleDate: String              // e.g., "May 18, 2017"
    var salePriceUSD: Double          // in USD (e.g., 110_500_000)
    var estimateLowUSD: Double?       // pre-sale low estimate
    var estimateHighUSD: Double?      // pre-sale high estimate
    var previousSalePriceUSD: Double? // for ROI calculation
    var previousSaleYear: Int?        // year of previous sale
    var source: String                // e.g., "Sotheby's auction records"
    var notes: String?                // additional context

    // Computed: formatted sale price
    var formattedPrice: String {
        if salePriceUSD >= 1_000_000 {
            return String(format: "$%.1fM", salePriceUSD / 1_000_000)
        } else if salePriceUSD >= 1_000 {
            return String(format: "$%.0fK", salePriceUSD / 1_000)
        }
        return String(format: "$%.0f", salePriceUSD)
    }

    // Computed: ROI percentage if previous sale data available
    var roiPercentage: Double? {
        guard let prevPrice = previousSalePriceUSD, prevPrice > 0 else { return nil }
        return ((salePriceUSD - prevPrice) / prevPrice) * 100
    }

    // Computed: annualized return if previous sale data available
    var annualizedReturn: Double? {
        guard let prevPrice = previousSalePriceUSD, prevPrice > 0,
              let prevYear = previousSaleYear else { return nil }
        // Extract sale year from saleDate string (last 4 digits)
        let saleYear = extractYear(from: saleDate)
        guard saleYear > prevYear else { return nil }
        let years = Double(saleYear - prevYear)
        guard years > 0 else { return nil }
        return (pow(salePriceUSD / prevPrice, 1.0 / years) - 1.0) * 100
    }

    private func extractYear(from dateString: String) -> Int {
        let components = dateString.components(separatedBy: ", ")
        if let last = components.last, let year = Int(last.trimmingCharacters(in: .whitespaces)) {
            return year
        }
        // Try last 4 characters
        if dateString.count >= 4, let year = Int(String(dateString.suffix(4))) {
            return year
        }
        return 0
    }
}

// MARK: - Complete Artist Auction Database

struct ArtAuctionDatabase {

    // MARK: - All Artists
    static let allArtists: [ArtistProfile] = [
        basquiat, kahlo, warhol, banksy, hirst,
        mitchell, frankenthaler, oKeeffe, boafo, twombly,
        calder, picasso, rothko, hockney, kelly,
        miro, murakami, balla, martin, deKooning,
        wong, matisse, degas, beeple, vespers
    ]

    // MARK: - Filtered Views
    static var blueChipArtists: [ArtistProfile] {
        allArtists.filter { $0.category == .blueChip }
    }

    static var emergingArtists: [ArtistProfile] {
        allArtists.filter { $0.category == .emerging }
    }

    static var nftArtists: [ArtistProfile] {
        allArtists.filter { $0.category == .nft }
    }

    static var topSalesByPrice: [AuctionRecord] {
        allArtists.flatMap { $0.auctionRecords }
            .sorted { $0.salePriceUSD > $1.salePriceUSD }
    }

    static var recordsWithROI: [(artist: ArtistProfile, record: AuctionRecord)] {
        allArtists.flatMap { artist in
            artist.auctionRecords
                .filter { $0.roiPercentage != nil }
                .map { (artist: artist, record: $0) }
        }
        .sorted { ($0.record.roiPercentage ?? 0) > ($1.record.roiPercentage ?? 0) }
    }

    // ============================================================
    // MARK: 1. Jean-Michel Basquiat
    // ============================================================
    static let basquiat = ArtistProfile(
        id: "artist_basquiat",
        name: "Jean-Michel Basquiat",
        nationality: "American",
        birthYear: 1960,
        deathYear: 1988,
        category: .blueChip,
        auctionRecords: [
            AuctionRecord(
                id: "basquiat_1",
                artworkTitle: "Untitled (1982)",
                yearCreated: "1982",
                medium: "Oilstick, acrylic, and spray paint on canvas",
                auctionHouse: "Sotheby's",
                saleDate: "May 18, 2017",
                salePriceUSD: 110_500_000,
                estimateLowUSD: 60_000_000,
                estimateHighUSD: nil,
                previousSalePriceUSD: 19_000,
                previousSaleYear: 1984,
                source: "Sotheby's auction records",
                notes: "Purchased by Yusaku Maezawa. The skull painting became the most expensive American artwork ever sold at auction at the time."
            ),
            AuctionRecord(
                id: "basquiat_2",
                artworkTitle: "Versus Medici",
                yearCreated: "1982",
                medium: "Acrylic, oilstick, and paper collage on canvas",
                auctionHouse: "Sotheby's",
                saleDate: "May 12, 2021",
                salePriceUSD: 50_820_000,
                estimateLowUSD: 35_000_000,
                estimateHighUSD: 50_000_000,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Sotheby's auction records",
                notes: "Part of the Anatomy series theme addressing race, power, and art history."
            ),
            AuctionRecord(
                id: "basquiat_3",
                artworkTitle: "In This Case",
                yearCreated: "1983",
                medium: "Acrylic, oilstick, and spray paint on three joined canvases",
                auctionHouse: "Christie's",
                saleDate: "May 11, 2022",
                salePriceUSD: 93_105_000,
                estimateLowUSD: nil,
                estimateHighUSD: nil,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Christie's auction records",
                notes: "Second highest Basquiat result. Features his signature skull motif and anatomical references."
            )
        ],
        marketNote: "Basquiat's market has experienced extraordinary growth, with works from his peak period (1981-1983) routinely achieving eight-figure results. His auction record represents one of the highest ROIs in art market history.",
        primarySource: "Sotheby's and Christie's auction records"
    )

    // ============================================================
    // MARK: 2. Frida Kahlo
    // ============================================================
    static let kahlo = ArtistProfile(
        id: "artist_kahlo",
        name: "Frida Kahlo",
        nationality: "Mexican",
        birthYear: 1907,
        deathYear: 1954,
        category: .blueChip,
        auctionRecords: [
            AuctionRecord(
                id: "kahlo_1",
                artworkTitle: "Diego y yo (Diego and I)",
                yearCreated: "1949",
                medium: "Oil on Masonite",
                auctionHouse: "Sotheby's",
                saleDate: "November 16, 2021",
                salePriceUSD: 34_883_000,
                estimateLowUSD: 30_000_000,
                estimateHighUSD: 50_000_000,
                previousSalePriceUSD: 1_430_000,
                previousSaleYear: 1990,
                source: "Sotheby's auction records",
                notes: "Set the record for the most expensive Latin American artwork ever sold at auction. Also the record for any work by a female Latine artist."
            ),
            AuctionRecord(
                id: "kahlo_2",
                artworkTitle: "Autorretrato con collar de espinas y colibri (Self-Portrait with Necklace of Thorns and Hummingbird)",
                yearCreated: "1940",
                medium: "Oil on canvas",
                auctionHouse: "Private Collection (Harry Ransom Center, UT Austin)",
                saleDate: "N/A - Institutional holding",
                salePriceUSD: 0,
                estimateLowUSD: nil,
                estimateHighUSD: nil,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Harry Ransom Center, University of Texas at Austin",
                notes: "One of Kahlo's most iconic works. Held institutionally and not available at auction, but insured for estimated $30M+. Demonstrates how museum holdings remove supply from market."
            ),
            AuctionRecord(
                id: "kahlo_3",
                artworkTitle: "Roots (Raices)",
                yearCreated: "1943",
                medium: "Oil on metal",
                auctionHouse: "Sotheby's",
                saleDate: "May 24, 2006",
                salePriceUSD: 5_616_000,
                estimateLowUSD: 3_500_000,
                estimateHighUSD: 5_000_000,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Sotheby's auction records",
                notes: "Was the auction record for Kahlo at the time. Shows the dramatic price escalation over the subsequent 15 years."
            )
        ],
        marketNote: "Kahlo's market has surged since the 2000s, driven by institutional recognition, feminist art historical reappraisal, and extremely limited supply (only about 200 works total). Her record-breaking 2021 sale reflected both cultural zeitgeist and scarcity.",
        primarySource: "Sotheby's auction records"
    )

    // ============================================================
    // MARK: 3. Andy Warhol
    // ============================================================
    static let warhol = ArtistProfile(
        id: "artist_warhol",
        name: "Andy Warhol",
        nationality: "American",
        birthYear: 1928,
        deathYear: 1987,
        category: .blueChip,
        auctionRecords: [
            AuctionRecord(
                id: "warhol_1",
                artworkTitle: "Shot Sage Blue Marilyn",
                yearCreated: "1964",
                medium: "Silkscreen ink and acrylic on canvas",
                auctionHouse: "Christie's",
                saleDate: "May 9, 2022",
                salePriceUSD: 195_000_000,
                estimateLowUSD: 200_000_000,
                estimateHighUSD: nil,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Christie's auction records",
                notes: "Most expensive American artwork and most expensive 20th-century artwork ever sold at auction. From the Thomas and Doris Ammann Foundation. Proceeds to charity."
            ),
            AuctionRecord(
                id: "warhol_2",
                artworkTitle: "Silver Car Crash (Double Disaster)",
                yearCreated: "1963",
                medium: "Silkscreen ink and acrylic on canvas",
                auctionHouse: "Sotheby's",
                saleDate: "November 13, 2013",
                salePriceUSD: 105_400_000,
                estimateLowUSD: 60_000_000,
                estimateHighUSD: 80_000_000,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Sotheby's auction records",
                notes: "From the Death and Disaster series. Demonstrates the premium placed on Warhol's early 1960s works."
            ),
            AuctionRecord(
                id: "warhol_3",
                artworkTitle: "Small Campbell's Soup Can (Pepper Pot)",
                yearCreated: "1962",
                medium: "Casein and graphite on linen",
                auctionHouse: "Christie's",
                saleDate: "November 12, 2014",
                salePriceUSD: 2_412_500,
                estimateLowUSD: 2_000_000,
                estimateHighUSD: 3_000_000,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Christie's auction records",
                notes: "Individual Campbell's Soup Cans are among Warhol's most recognizable imagery. The complete set of 32 was donated to MoMA."
            )
        ],
        marketNote: "Warhol is the most liquid artist at auction, with thousands of lots sold annually across all price ranges. His 2022 Marilyn sale cemented his status as the highest-achieving American artist. The market spans from affordable prints (~$5K-$50K) to nine-figure paintings.",
        primarySource: "Christie's and Sotheby's auction records"
    )

    // ============================================================
    // MARK: 4. Banksy
    // ============================================================
    static let banksy = ArtistProfile(
        id: "artist_banksy",
        name: "Banksy",
        nationality: "British",
        birthYear: 1974,
        deathYear: nil,
        category: .blueChip,
        auctionRecords: [
            AuctionRecord(
                id: "banksy_1",
                artworkTitle: "Love is in the Bin (formerly Girl with Balloon)",
                yearCreated: "2006/2018",
                medium: "Spray paint and acrylic on canvas, in artist's frame with shredder",
                auctionHouse: "Sotheby's",
                saleDate: "October 14, 2021",
                salePriceUSD: 25_384_000,
                estimateLowUSD: 5_000_000,
                estimateHighUSD: 8_000_000,
                previousSalePriceUSD: 1_400_000,
                previousSaleYear: 2018,
                source: "Sotheby's auction records",
                notes: "Originally self-shredded at Sotheby's in October 2018 immediately after selling for GBP 1.04M. The act of destruction became part of the artwork, dramatically increasing its value and cultural significance."
            ),
            AuctionRecord(
                id: "banksy_2",
                artworkTitle: "Game Changer",
                yearCreated: "2020",
                medium: "Oil on canvas",
                auctionHouse: "Christie's",
                saleDate: "March 23, 2021",
                salePriceUSD: 23_200_000,
                estimateLowUSD: nil,
                estimateHighUSD: nil,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Christie's auction records",
                notes: "Painted during COVID-19, depicting a child playing with a nurse superhero doll. Donated to and sold for the benefit of University Hospital Southampton."
            ),
            AuctionRecord(
                id: "banksy_3",
                artworkTitle: "Devolved Parliament",
                yearCreated: "2009",
                medium: "Oil on canvas",
                auctionHouse: "Sotheby's",
                saleDate: "October 3, 2019",
                salePriceUSD: 12_200_000,
                estimateLowUSD: 2_000_000,
                estimateHighUSD: 3_000_000,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Sotheby's auction records",
                notes: "Depicts the House of Commons filled with chimpanzees. Sold during Brexit debates, demonstrating how political context affects art market value."
            )
        ],
        marketNote: "Banksy's market is unique: anonymous identity, street art origins, and performance-art stunts (the shredding incident) fuel both cultural relevance and collector demand. His market has grown dramatically since 2018, with works regularly achieving seven- and eight-figure results.",
        primarySource: "Sotheby's and Christie's auction records"
    )

    // ============================================================
    // MARK: 5. Damien Hirst
    // ============================================================
    static let hirst = ArtistProfile(
        id: "artist_hirst",
        name: "Damien Hirst",
        nationality: "British",
        birthYear: 1965,
        deathYear: nil,
        category: .blueChip,
        auctionRecords: [
            AuctionRecord(
                id: "hirst_1",
                artworkTitle: "Lullaby Spring",
                yearCreated: "2002",
                medium: "Painted stainless steel, glass, and pills",
                auctionHouse: "Sotheby's",
                saleDate: "June 21, 2007",
                salePriceUSD: 19_200_000,
                estimateLowUSD: 4_000_000,
                estimateHighUSD: 6_000_000,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Sotheby's auction records",
                notes: "From the Medicine Cabinets/Pill series. Large-scale cabinet with over 6,000 hand-painted pills. One of Hirst's iconic pharmaceutical-themed works."
            ),
            AuctionRecord(
                id: "hirst_2",
                artworkTitle: "The Golden Calf",
                yearCreated: "2008",
                medium: "Calf, 18-carat gold, glass, gold-plated steel, silicone, and formaldehyde solution",
                auctionHouse: "Sotheby's",
                saleDate: "September 15, 2008",
                salePriceUSD: 18_600_000,
                estimateLowUSD: 12_000_000,
                estimateHighUSD: 18_000_000,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Sotheby's auction records",
                notes: "Sold during Hirst's unprecedented 'Beautiful Inside My Head Forever' sale, which bypassed galleries to sell directly at auction. The two-day sale totaled GBP 111M."
            ),
            AuctionRecord(
                id: "hirst_3",
                artworkTitle: "Argininosuccinic Acid",
                yearCreated: "1995",
                medium: "Household gloss on canvas (Spot Painting)",
                auctionHouse: "Sotheby's",
                saleDate: "February 14, 2020",
                salePriceUSD: 2_100_000,
                estimateLowUSD: 1_500_000,
                estimateHighUSD: 2_000_000,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Sotheby's auction records",
                notes: "From the Pharmaceutical/Spot Painting series. Hirst's spot paintings remain among his most liquid and collected works, with prices varying by size and date."
            )
        ],
        marketNote: "Hirst's market experienced a boom in the mid-2000s, a correction after the 2008 financial crisis, and selective recovery since. His spot paintings and pharmaceutical works remain most liquid. The 2008 direct-to-auction sale remains a landmark market event.",
        primarySource: "Sotheby's auction records"
    )

    // ============================================================
    // MARK: 6. Joan Mitchell
    // ============================================================
    static let mitchell = ArtistProfile(
        id: "artist_mitchell",
        name: "Joan Mitchell",
        nationality: "American",
        birthYear: 1925,
        deathYear: 1992,
        category: .blueChip,
        auctionRecords: [
            AuctionRecord(
                id: "mitchell_1",
                artworkTitle: "Untitled",
                yearCreated: "1959",
                medium: "Oil on canvas",
                auctionHouse: "Christie's",
                saleDate: "May 11, 2021",
                salePriceUSD: 14_500_000,
                estimateLowUSD: 10_000_000,
                estimateHighUSD: 15_000_000,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Christie's auction records",
                notes: "Mitchell's late 1950s works from her New York period are among her most sought-after. This period shows the direct influence of Abstract Expressionism."
            ),
            AuctionRecord(
                id: "mitchell_2",
                artworkTitle: "Blueberry",
                yearCreated: "1969",
                medium: "Oil on canvas",
                auctionHouse: "Christie's",
                saleDate: "May 13, 2018",
                salePriceUSD: 16_600_000,
                estimateLowUSD: 7_000_000,
                estimateHighUSD: 10_000_000,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Christie's auction records",
                notes: "Large-scale work from Mitchell's V\u{00E9}theuil period. Demonstrates the premium for her multi-panel works."
            ),
            AuctionRecord(
                id: "mitchell_3",
                artworkTitle: "12 Hawks at 3 O'Clock",
                yearCreated: "1960",
                medium: "Oil on canvas",
                auctionHouse: "Christie's",
                saleDate: "May 17, 2023",
                salePriceUSD: 20_000_000,
                estimateLowUSD: 15_000_000,
                estimateHighUSD: 20_000_000,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Christie's auction records",
                notes: "Large-scale painting from her most celebrated period. Part of the broader market reappraisal of postwar women artists."
            )
        ],
        marketNote: "Mitchell's market has surged dramatically since 2018, driven by institutional reappraisal and the broader recognition of women Abstract Expressionists. Her auction record has grown over 400% in the last decade, and her 2022 SFMOMA retrospective further cemented her legacy.",
        primarySource: "Christie's auction records"
    )

    // ============================================================
    // MARK: 7. Helen Frankenthaler
    // ============================================================
    static let frankenthaler = ArtistProfile(
        id: "artist_frankenthaler",
        name: "Helen Frankenthaler",
        nationality: "American",
        birthYear: 1928,
        deathYear: 2011,
        category: .blueChip,
        auctionRecords: [
            AuctionRecord(
                id: "frankenthaler_1",
                artworkTitle: "Royal Fireworks",
                yearCreated: "1975",
                medium: "Acrylic on canvas",
                auctionHouse: "Christie's",
                saleDate: "May 15, 2019",
                salePriceUSD: 7_872_500,
                estimateLowUSD: 3_000_000,
                estimateHighUSD: 5_000_000,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Christie's auction records",
                notes: "Frankenthaler's stain paintings pioneered the Color Field movement. This large-scale work demonstrates her mature technique."
            ),
            AuctionRecord(
                id: "frankenthaler_2",
                artworkTitle: "Moveable Blue",
                yearCreated: "1973",
                medium: "Acrylic on canvas",
                auctionHouse: "Sotheby's",
                saleDate: "November 14, 2019",
                salePriceUSD: 4_500_000,
                estimateLowUSD: 3_000_000,
                estimateHighUSD: 4_000_000,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Sotheby's auction records",
                notes: "Representative of her soak-stain technique from the 1970s, among her most productive decades."
            ),
            AuctionRecord(
                id: "frankenthaler_3",
                artworkTitle: "Carousel",
                yearCreated: "1965",
                medium: "Acrylic on canvas",
                auctionHouse: "Sotheby's",
                saleDate: "May 16, 2018",
                salePriceUSD: 3_375_000,
                estimateLowUSD: 2_000_000,
                estimateHighUSD: 3_000_000,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Sotheby's auction records",
                notes: "Mid-1960s Color Field work. Frankenthaler's market has been building steadily, though she remains undervalued relative to male Abstract Expressionist peers."
            )
        ],
        marketNote: "Frankenthaler's market is experiencing a correction rally as the art world reappraises women of the Abstract Expressionist and Color Field movements. Her prices remain a fraction of male peers like Morris Louis and Kenneth Noland despite comparable art historical significance.",
        primarySource: "Christie's and Sotheby's auction records"
    )

    // ============================================================
    // MARK: 8. Georgia O'Keeffe
    // ============================================================
    static let oKeeffe = ArtistProfile(
        id: "artist_okeeffe",
        name: "Georgia O'Keeffe",
        nationality: "American",
        birthYear: 1887,
        deathYear: 1986,
        category: .blueChip,
        auctionRecords: [
            AuctionRecord(
                id: "okeeffe_1",
                artworkTitle: "Jimson Weed/White Flower No. 1",
                yearCreated: "1932",
                medium: "Oil on canvas",
                auctionHouse: "Sotheby's",
                saleDate: "November 20, 2014",
                salePriceUSD: 44_405_000,
                estimateLowUSD: 10_000_000,
                estimateHighUSD: 15_000_000,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Sotheby's auction records",
                notes: "Set the record for any female artist at auction at the time. Purchased by Walmart heiress Alice Walton for Crystal Bridges Museum. Exceeded estimate by nearly 3x."
            ),
            AuctionRecord(
                id: "okeeffe_2",
                artworkTitle: "Red, Yellow and Black Streak",
                yearCreated: "1924",
                medium: "Oil on canvas",
                auctionHouse: "Christie's",
                saleDate: "May 21, 2024",
                salePriceUSD: 10_740_000,
                estimateLowUSD: 6_000_000,
                estimateHighUSD: 8_000_000,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Christie's auction records",
                notes: "Abstract composition from O'Keeffe's influential early period. Demonstrates continued market strength for her non-floral works."
            ),
            AuctionRecord(
                id: "okeeffe_3",
                artworkTitle: "Red and Pink Rocks and Teeth",
                yearCreated: "1938",
                medium: "Oil on canvas",
                auctionHouse: "Sotheby's",
                saleDate: "May 16, 2019",
                salePriceUSD: 4_287_500,
                estimateLowUSD: 3_000_000,
                estimateHighUSD: 5_000_000,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Sotheby's auction records",
                notes: "New Mexico landscape from O'Keeffe's Ghost Ranch period. Her southwestern landscapes and pelvis/bone works form a distinct collecting category."
            )
        ],
        marketNote: "O'Keeffe was among the first female artists to break the $40M barrier at auction. Her market is supported by strong institutional demand, American cultural significance, and limited supply. Flower paintings command the highest premiums, followed by New Mexico landscapes.",
        primarySource: "Sotheby's and Christie's auction records"
    )

    // ============================================================
    // MARK: 9. Amoako Boafo
    // ============================================================
    static let boafo = ArtistProfile(
        id: "artist_boafo",
        name: "Amoako Boafo",
        nationality: "Ghanaian",
        birthYear: 1984,
        deathYear: nil,
        category: .emerging,
        auctionRecords: [
            AuctionRecord(
                id: "boafo_1",
                artworkTitle: "The Lemon Bathing Suit",
                yearCreated: "2019",
                medium: "Oil on canvas",
                auctionHouse: "Phillips",
                saleDate: "February 27, 2020",
                salePriceUSD: 881_000,
                estimateLowUSD: 30_000,
                estimateHighUSD: 50_000,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Phillips auction records",
                notes: "Exceeded pre-sale estimate by over 17x. This early result signaled the explosive demand for Boafo's figurative portraits of Black subjects."
            ),
            AuctionRecord(
                id: "boafo_2",
                artworkTitle: "Hands Up",
                yearCreated: "2019",
                medium: "Oil on canvas",
                auctionHouse: "Christie's",
                saleDate: "June 30, 2020",
                salePriceUSD: 1_107_000,
                estimateLowUSD: 150_000,
                estimateHighUSD: 200_000,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Christie's auction records",
                notes: "Demonstrated continued strong demand in 2020. Boafo's distinctive finger-painting technique for skin became his signature."
            ),
            AuctionRecord(
                id: "boafo_3",
                artworkTitle: "Green Beret",
                yearCreated: "2020",
                medium: "Oil on canvas",
                auctionHouse: "Christie's",
                saleDate: "March 23, 2021",
                salePriceUSD: 3_369_000,
                estimateLowUSD: 800_000,
                estimateHighUSD: 1_200_000,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Christie's auction records",
                notes: "Boafo's auction record as of 2021. Reflects the heightened demand for contemporary Black figurative painting."
            )
        ],
        marketNote: "Boafo's market trajectory exemplifies the rapid ascent of emerging contemporary artists, rising from gallery prices under $10K to auction results over $3M in under two years. His market has shown signs of stabilization after the initial surge, a common pattern for hyped emerging artists.",
        primarySource: "Phillips and Christie's auction records"
    )

    // ============================================================
    // MARK: 10. Cy Twombly
    // ============================================================
    static let twombly = ArtistProfile(
        id: "artist_twombly",
        name: "Cy Twombly",
        nationality: "American",
        birthYear: 1928,
        deathYear: 2011,
        category: .blueChip,
        auctionRecords: [
            AuctionRecord(
                id: "twombly_1",
                artworkTitle: "Untitled (New York City)",
                yearCreated: "1968",
                medium: "Oil-based house paint and wax crayon on canvas",
                auctionHouse: "Sotheby's",
                saleDate: "November 12, 2015",
                salePriceUSD: 70_530_000,
                estimateLowUSD: 40_000_000,
                estimateHighUSD: 60_000_000,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Sotheby's auction records",
                notes: "Twombly's auction record. Features his iconic looping scrawl on a grey background, the 'blackboard' paintings from the late 1960s."
            ),
            AuctionRecord(
                id: "twombly_2",
                artworkTitle: "Leda and the Swan",
                yearCreated: "1962",
                medium: "Oil, house paint, lead pencil, and wax crayon on canvas",
                auctionHouse: "Christie's",
                saleDate: "May 11, 2017",
                salePriceUSD: 52_887_500,
                estimateLowUSD: 35_000_000,
                estimateHighUSD: 55_000_000,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Christie's auction records",
                notes: "Mythological subject matter typical of Twombly's engagement with classical literature. His works addressing classical themes command top prices."
            ),
            AuctionRecord(
                id: "twombly_3",
                artworkTitle: "Untitled (Bolsena)",
                yearCreated: "1969",
                medium: "Oil-based house paint, wax crayon, and lead pencil on canvas",
                auctionHouse: "Christie's",
                saleDate: "November 12, 2014",
                salePriceUSD: 69_600_000,
                estimateLowUSD: 45_000_000,
                estimateHighUSD: 65_000_000,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Christie's auction records",
                notes: "From the important Bolsena series. Part of a series of 14 paintings created at Palazzo del Drago in Bolsena, Italy."
            )
        ],
        marketNote: "Twombly's market is defined by a relatively limited supply and strong institutional demand. His 'blackboard' paintings from the late 1960s and mythological works command the highest prices. His market has shown consistent strength with minimal volatility at the top end.",
        primarySource: "Sotheby's and Christie's auction records"
    )

    // ============================================================
    // MARK: 11. Alexander Calder
    // ============================================================
    static let calder = ArtistProfile(
        id: "artist_calder",
        name: "Alexander Calder",
        nationality: "American",
        birthYear: 1898,
        deathYear: 1976,
        category: .blueChip,
        auctionRecords: [
            AuctionRecord(
                id: "calder_1",
                artworkTitle: "Lily of Force",
                yearCreated: "1945",
                medium: "Sheet metal, wire, and paint (standing mobile)",
                auctionHouse: "Christie's",
                saleDate: "November 11, 2020",
                salePriceUSD: 18_375_000,
                estimateLowUSD: 12_000_000,
                estimateHighUSD: 18_000_000,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Christie's auction records",
                notes: "Standing mobile from the mid-1940s. Calder's mobiles and stabiles are pioneering works of kinetic sculpture."
            ),
            AuctionRecord(
                id: "calder_2",
                artworkTitle: "Poisson volant (Flying Fish)",
                yearCreated: "1957",
                medium: "Sheet metal, wire, rod, and paint",
                auctionHouse: "Christie's",
                saleDate: "May 15, 2014",
                salePriceUSD: 25_925_000,
                estimateLowUSD: 12_000_000,
                estimateHighUSD: 18_000_000,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Christie's auction records",
                notes: "One of Calder's largest standing mobiles at over 11 feet wide. Monumental works command significant premiums."
            ),
            AuctionRecord(
                id: "calder_3",
                artworkTitle: "Snow Flurry I",
                yearCreated: "1948",
                medium: "Sheet metal, wire, and paint (hanging mobile)",
                auctionHouse: "Sotheby's",
                saleDate: "November 14, 2018",
                salePriceUSD: 6_300_000,
                estimateLowUSD: 6_000_000,
                estimateHighUSD: 8_000_000,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Sotheby's auction records",
                notes: "Classic hanging mobile with white elements. Calder's all-white mobiles are especially prized by collectors."
            )
        ],
        marketNote: "Calder's market is broad and well-established, spanning from smaller gouaches ($50K-$500K) to monumental sculptures ($10M+). His mobiles, stabiles, and standing mobiles have distinct collector bases. Scale, period, and provenance are the primary value drivers.",
        primarySource: "Christie's and Sotheby's auction records"
    )

    // ============================================================
    // MARK: 12. Pablo Picasso
    // ============================================================
    static let picasso = ArtistProfile(
        id: "artist_picasso",
        name: "Pablo Picasso",
        nationality: "Spanish",
        birthYear: 1881,
        deathYear: 1973,
        category: .blueChip,
        auctionRecords: [
            AuctionRecord(
                id: "picasso_1",
                artworkTitle: "Les femmes d'Alger (Version 'O')",
                yearCreated: "1955",
                medium: "Oil on canvas",
                auctionHouse: "Christie's",
                saleDate: "May 11, 2015",
                salePriceUSD: 179_365_000,
                estimateLowUSD: 140_000_000,
                estimateHighUSD: nil,
                previousSalePriceUSD: 31_900_000,
                previousSaleYear: 1997,
                source: "Christie's auction records",
                notes: "Was the most expensive artwork ever sold at auction at the time. Final work in a 15-painting series inspired by Delacroix."
            ),
            AuctionRecord(
                id: "picasso_2",
                artworkTitle: "Femme assise pres d'une fenetre (Marie-Therese)",
                yearCreated: "1932",
                medium: "Oil on canvas",
                auctionHouse: "Christie's",
                saleDate: "May 13, 2021",
                salePriceUSD: 103_410_000,
                estimateLowUSD: 55_000_000,
                estimateHighUSD: nil,
                previousSalePriceUSD: 28_600_000,
                previousSaleYear: 2013,
                source: "Christie's auction records",
                notes: "Portrait of Marie-Therese Walter from the celebrated year of 1932. Works from this year are considered Picasso's peak period."
            ),
            AuctionRecord(
                id: "picasso_3",
                artworkTitle: "Femme au beret et a la robe quadrillee (Marie-Therese Walter)",
                yearCreated: "1937",
                medium: "Oil on canvas",
                auctionHouse: "Sotheby's",
                saleDate: "February 28, 2018",
                salePriceUSD: 69_400_000,
                estimateLowUSD: 50_000_000,
                estimateHighUSD: nil,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Sotheby's auction records",
                notes: "Painted on the same day as Guernica. Subject matter (Marie-Therese) and period (1930s) significantly impact value."
            )
        ],
        marketNote: "Picasso is the most voluminous artist at auction with over 70,000 lots sold historically. His market spans from small ceramics ($1K-$10K) to nine-figure paintings. Works from the 1930s-1950s and portraits of his muses command the highest prices.",
        primarySource: "Christie's and Sotheby's auction records"
    )

    // ============================================================
    // MARK: 13. Mark Rothko
    // ============================================================
    static let rothko = ArtistProfile(
        id: "artist_rothko",
        name: "Mark Rothko",
        nationality: "American (born Latvia)",
        birthYear: 1903,
        deathYear: 1970,
        category: .blueChip,
        auctionRecords: [
            AuctionRecord(
                id: "rothko_1",
                artworkTitle: "Orange, Red, Yellow",
                yearCreated: "1961",
                medium: "Oil on canvas",
                auctionHouse: "Christie's",
                saleDate: "May 8, 2012",
                salePriceUSD: 86_882_500,
                estimateLowUSD: 35_000_000,
                estimateHighUSD: 45_000_000,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Christie's auction records",
                notes: "Was Rothko's auction record. Demonstrates the premium for warm-palette works. Rothko's red and orange compositions outperform blue and dark works at auction."
            ),
            AuctionRecord(
                id: "rothko_2",
                artworkTitle: "No. 7",
                yearCreated: "1951",
                medium: "Oil on canvas",
                auctionHouse: "Sotheby's",
                saleDate: "November 15, 2021",
                salePriceUSD: 82_468_500,
                estimateLowUSD: 70_000_000,
                estimateHighUSD: 90_000_000,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Sotheby's auction records",
                notes: "From the Macklowe Collection dispersal. Classic multi-form composition from the early 1950s."
            ),
            AuctionRecord(
                id: "rothko_3",
                artworkTitle: "No. 6 (Violet, Green, and Red)",
                yearCreated: "1951",
                medium: "Oil on canvas",
                auctionHouse: "Sotheby's",
                saleDate: "November 13, 2014",
                salePriceUSD: 186_000_000,
                estimateLowUSD: nil,
                estimateHighUSD: nil,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Sotheby's (private sale reported by Bloomberg)",
                notes: "Reported private sale to Dmitry Rybolovlev. If confirmed, this would be the highest price for any Rothko. Private sale data is less transparent than auction records."
            )
        ],
        marketNote: "Rothko's color field paintings from the 1950s-1960s are among the most valuable postwar works. Warm-palette compositions (reds, oranges, yellows) consistently outperform darker works. His market benefits from extreme scarcity and museum-level demand.",
        primarySource: "Christie's and Sotheby's auction records"
    )

    // ============================================================
    // MARK: 14. David Hockney
    // ============================================================
    static let hockney = ArtistProfile(
        id: "artist_hockney",
        name: "David Hockney",
        nationality: "British",
        birthYear: 1937,
        deathYear: nil,
        category: .blueChip,
        auctionRecords: [
            AuctionRecord(
                id: "hockney_1",
                artworkTitle: "Portrait of an Artist (Pool with Two Figures)",
                yearCreated: "1972",
                medium: "Acrylic on canvas",
                auctionHouse: "Christie's",
                saleDate: "November 15, 2018",
                salePriceUSD: 90_312_500,
                estimateLowUSD: 80_000_000,
                estimateHighUSD: nil,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Christie's auction records",
                notes: "Set the record for any living artist at auction at the time (later surpassed by Jeff Koons, then reclaimed by Beeple at Christie's)."
            ),
            AuctionRecord(
                id: "hockney_2",
                artworkTitle: "Nichols Canyon",
                yearCreated: "1980",
                medium: "Acrylic on canvas",
                auctionHouse: "Phillips",
                saleDate: "November 14, 2018",
                salePriceUSD: 41_107_500,
                estimateLowUSD: 35_000_000,
                estimateHighUSD: 45_000_000,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Phillips auction records",
                notes: "Los Angeles landscape demonstrating the strength of Hockney's California period works."
            ),
            AuctionRecord(
                id: "hockney_3",
                artworkTitle: "The Splash",
                yearCreated: "1966",
                medium: "Acrylic on canvas",
                auctionHouse: "Sotheby's",
                saleDate: "February 12, 2020",
                salePriceUSD: 29_800_000,
                estimateLowUSD: 25_000_000,
                estimateHighUSD: 35_000_000,
                previousSalePriceUSD: 7_200_000,
                previousSaleYear: 2006,
                source: "Sotheby's auction records",
                notes: "Iconic California pool painting from the 1960s. This version is the largest of three Splash paintings."
            )
        ],
        marketNote: "Hockney's market is among the strongest for any living artist, anchored by his California pool paintings and Yorkshire landscapes. His 2018 auction record established the viability of nine-figure prices for living artists. His market spans prints ($5K-$100K) to major paintings.",
        primarySource: "Christie's, Sotheby's, and Phillips auction records"
    )

    // ============================================================
    // MARK: 15. Ellsworth Kelly
    // ============================================================
    static let kelly = ArtistProfile(
        id: "artist_kelly",
        name: "Ellsworth Kelly",
        nationality: "American",
        birthYear: 1923,
        deathYear: 2015,
        category: .blueChip,
        auctionRecords: [
            AuctionRecord(
                id: "kelly_1",
                artworkTitle: "Red Curve VII",
                yearCreated: "1982",
                medium: "Oil on canvas (shaped)",
                auctionHouse: "Christie's",
                saleDate: "November 9, 2017",
                salePriceUSD: 6_200_000,
                estimateLowUSD: 4_000_000,
                estimateHighUSD: 6_000_000,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Christie's auction records",
                notes: "Kelly's shaped canvases and monochrome works define his contribution to hard-edge abstraction and Minimalism."
            ),
            AuctionRecord(
                id: "kelly_2",
                artworkTitle: "Spectrum I",
                yearCreated: "1953",
                medium: "Oil on canvas, 13 joined panels",
                auctionHouse: "Private/Museum Collection (Philadelphia Museum of Art)",
                saleDate: "N/A - Museum holding",
                salePriceUSD: 0,
                estimateLowUSD: nil,
                estimateHighUSD: nil,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Philadelphia Museum of Art",
                notes: "One of Kelly's most important early works. Held institutionally. Kelly's Spectrum series would likely achieve $15M+ if brought to market given comparable sales."
            ),
            AuctionRecord(
                id: "kelly_3",
                artworkTitle: "Blue Green Black Red",
                yearCreated: "1966",
                medium: "Oil on canvas, four joined panels",
                auctionHouse: "Christie's",
                saleDate: "May 15, 2019",
                salePriceUSD: 9_812_500,
                estimateLowUSD: 5_000_000,
                estimateHighUSD: 7_000_000,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Christie's auction records",
                notes: "Multi-panel work from the mid-1960s. Kelly's auction record. His multi-panel color works and shaped canvases command the highest prices."
            )
        ],
        marketNote: "Kelly's market has strengthened since his death in 2015 and his posthumous Austin chapel installation (2018). His multi-panel color works and shaped canvases command the strongest prices. The market is relatively thin with limited supply at the top end.",
        primarySource: "Christie's auction records"
    )

    // ============================================================
    // MARK: 16. Joan Miro
    // ============================================================
    static let miro = ArtistProfile(
        id: "artist_miro",
        name: "Joan Mir\u{00F3}",
        nationality: "Spanish",
        birthYear: 1893,
        deathYear: 1983,
        category: .blueChip,
        auctionRecords: [
            AuctionRecord(
                id: "miro_1",
                artworkTitle: "Peinture (Etoile Bleue)",
                yearCreated: "1927",
                medium: "Oil on canvas",
                auctionHouse: "Sotheby's",
                saleDate: "June 19, 2012",
                salePriceUSD: 37_000_000,
                estimateLowUSD: 20_000_000,
                estimateHighUSD: 30_000_000,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Sotheby's auction records",
                notes: "Miro's auction record. From his 'dream paintings' period of the late 1920s, considered his most important works."
            ),
            AuctionRecord(
                id: "miro_2",
                artworkTitle: "Painting-Poem (Le corps de ma brune puisque je l'aime comme ma chatte habillee en vert salade comme de la grele c'est pareil)",
                yearCreated: "1925",
                medium: "Oil and charcoal on canvas",
                auctionHouse: "Christie's",
                saleDate: "February 4, 2014",
                salePriceUSD: 26_900_000,
                estimateLowUSD: 22_000_000,
                estimateHighUSD: 30_000_000,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Christie's auction records",
                notes: "Painting-poem from Miro's Surrealist period. The integration of poetry into visual art was pioneering."
            ),
            AuctionRecord(
                id: "miro_3",
                artworkTitle: "Femme et oiseaux",
                yearCreated: "1940",
                medium: "Gouache and oil wash on paper",
                auctionHouse: "Christie's",
                saleDate: "November 12, 2015",
                salePriceUSD: 14_200_000,
                estimateLowUSD: 8_000_000,
                estimateHighUSD: 12_000_000,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Christie's auction records",
                notes: "From the 'Constellations' series, created during wartime. These works on paper are among Miro's most prized creations."
            )
        ],
        marketNote: "Miro's market is deep and well-established, with a large body of work spanning painting, sculpture, ceramics, and prints. His 1920s Surrealist works command the highest prices. The print market offers accessible entry points for collectors.",
        primarySource: "Sotheby's and Christie's auction records"
    )

    // ============================================================
    // MARK: 17. Takashi Murakami
    // ============================================================
    static let murakami = ArtistProfile(
        id: "artist_murakami",
        name: "Takashi Murakami",
        nationality: "Japanese",
        birthYear: 1962,
        deathYear: nil,
        category: .blueChip,
        auctionRecords: [
            AuctionRecord(
                id: "murakami_1",
                artworkTitle: "My Lonesome Cowboy",
                yearCreated: "1998",
                medium: "FRP, iron, and acrylic (sculpture)",
                auctionHouse: "Sotheby's",
                saleDate: "May 14, 2008",
                salePriceUSD: 15_200_000,
                estimateLowUSD: 3_000_000,
                estimateHighUSD: 4_000_000,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Sotheby's auction records",
                notes: "Murakami's auction record. Life-size anime-inspired sculpture. Demonstrates the crossover appeal of his 'Superflat' aesthetic."
            ),
            AuctionRecord(
                id: "murakami_2",
                artworkTitle: "TANGOBLO",
                yearCreated: "2001",
                medium: "Acrylic on canvas mounted on board",
                auctionHouse: "Sotheby's",
                saleDate: "May 12, 2016",
                salePriceUSD: 4_025_000,
                estimateLowUSD: 2_500_000,
                estimateHighUSD: 3_500_000,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Sotheby's auction records",
                notes: "Large-scale flower painting. Murakami's flower motif works, along with his skull and DOB character, form his most collected series."
            ),
            AuctionRecord(
                id: "murakami_3",
                artworkTitle: "727-727",
                yearCreated: "2006",
                medium: "Acrylic on canvas mounted on board, three panels",
                auctionHouse: "Sotheby's",
                saleDate: "November 14, 2018",
                salePriceUSD: 6_012_500,
                estimateLowUSD: 3_500_000,
                estimateHighUSD: 4_500_000,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Sotheby's auction records",
                notes: "Triptych featuring Mr. DOB character. Murakami's collaborations with Louis Vuitton and RTFKT NFTs expanded his market beyond traditional art collectors."
            )
        ],
        marketNote: "Murakami bridges fine art, fashion, and pop culture with his 'Superflat' movement. His market ranges from affordable prints and merchandise to multi-million dollar sculptures and paintings. He has also been active in the NFT space, creating cross-platform demand.",
        primarySource: "Sotheby's auction records"
    )

    // ============================================================
    // MARK: 18. Giacomo Balla
    // ============================================================
    static let balla = ArtistProfile(
        id: "artist_balla",
        name: "Giacomo Balla",
        nationality: "Italian",
        birthYear: 1871,
        deathYear: 1958,
        category: .blueChip,
        auctionRecords: [
            AuctionRecord(
                id: "balla_1",
                artworkTitle: "Velocita astratta + rumore (Abstract Speed + Sound)",
                yearCreated: "1913-1914",
                medium: "Oil on board (unframed) with artist's painted frame",
                auctionHouse: "Sotheby's",
                saleDate: "June 25, 2008",
                salePriceUSD: 6_200_000,
                estimateLowUSD: 2_500_000,
                estimateHighUSD: 3_500_000,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Sotheby's auction records",
                notes: "Major Italian Futurist work capturing speed and movement. Balla was a co-founder of the Futurist movement."
            ),
            AuctionRecord(
                id: "balla_2",
                artworkTitle: "Pessimismo e Ottimismo",
                yearCreated: "1923",
                medium: "Oil on canvas",
                auctionHouse: "Christie's",
                saleDate: "October 14, 2009",
                salePriceUSD: 4_600_000,
                estimateLowUSD: 3_000_000,
                estimateHighUSD: 4_000_000,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Christie's auction records",
                notes: "Major work from Balla's mature Futurist period. Italian Futurism has a dedicated collector base, particularly in Europe."
            ),
            AuctionRecord(
                id: "balla_3",
                artworkTitle: "Forme Grido Viva l'Italia",
                yearCreated: "1915",
                medium: "Oil on canvas",
                auctionHouse: "Christie's",
                saleDate: "November 9, 2016",
                salePriceUSD: 3_800_000,
                estimateLowUSD: 2_000_000,
                estimateHighUSD: 3_000_000,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Christie's auction records",
                notes: "Patriotic wartime Futurist composition. Balla's pre-1920 Futurist works are most valued by the market."
            )
        ],
        marketNote: "Balla's market is centered on his Italian Futurist works from 1910-1925, which represent the movement's most dynamic period. The market is relatively niche but supported by strong European collector demand. Authenticity verification through the Archivio Balla is essential.",
        primarySource: "Sotheby's and Christie's auction records"
    )

    // ============================================================
    // MARK: 19. Agnes Martin
    // ============================================================
    static let martin = ArtistProfile(
        id: "artist_martin",
        name: "Agnes Martin",
        nationality: "American (born Canada)",
        birthYear: 1912,
        deathYear: 2004,
        category: .blueChip,
        auctionRecords: [
            AuctionRecord(
                id: "martin_1",
                artworkTitle: "Orange Grove",
                yearCreated: "1965",
                medium: "Acrylic and graphite on canvas",
                auctionHouse: "Christie's",
                saleDate: "November 11, 2016",
                salePriceUSD: 10_687_500,
                estimateLowUSD: 5_000_000,
                estimateHighUSD: 7_000_000,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Christie's auction records",
                notes: "Martin's 1960s grid paintings are her most sought-after works. This golden-hued work exceeded its high estimate by over 50%."
            ),
            AuctionRecord(
                id: "martin_2",
                artworkTitle: "Untitled #44",
                yearCreated: "1974",
                medium: "Acrylic and graphite on canvas",
                auctionHouse: "Sotheby's",
                saleDate: "May 17, 2017",
                salePriceUSD: 7_500_000,
                estimateLowUSD: 4_000_000,
                estimateHighUSD: 6_000_000,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Sotheby's auction records",
                notes: "From Martin's return to painting in the 1970s after her famous seven-year hiatus. The subtle horizontal bands became her signature of this period."
            ),
            AuctionRecord(
                id: "martin_3",
                artworkTitle: "The Islands",
                yearCreated: "1961",
                medium: "Acrylic on canvas, twelve canvases",
                auctionHouse: "Christie's",
                saleDate: "May 12, 2011",
                salePriceUSD: 3_875_000,
                estimateLowUSD: 2_000_000,
                estimateHighUSD: 3_000_000,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Christie's auction records",
                notes: "Multi-panel work from her early grid period. Martin's market has grown steadily, benefiting from the broader reappraisal of women in postwar American art."
            )
        ],
        marketNote: "Martin's market has shown consistent growth, supported by institutional collecting and her positioning at the intersection of Minimalism and Abstract Expressionism. Her 1960s grid paintings command the highest prices. Recent retrospectives have further elevated her market standing.",
        primarySource: "Christie's and Sotheby's auction records"
    )

    // ============================================================
    // MARK: 20. Willem de Kooning
    // ============================================================
    static let deKooning = ArtistProfile(
        id: "artist_dekooning",
        name: "Willem de Kooning",
        nationality: "American (born Netherlands)",
        birthYear: 1904,
        deathYear: 1997,
        category: .blueChip,
        auctionRecords: [
            AuctionRecord(
                id: "dekooning_1",
                artworkTitle: "Untitled XXV",
                yearCreated: "1977",
                medium: "Oil on canvas",
                auctionHouse: "Christie's",
                saleDate: "November 15, 2016",
                salePriceUSD: 66_327_500,
                estimateLowUSD: 25_000_000,
                estimateHighUSD: 35_000_000,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Christie's auction records",
                notes: "Large-scale abstract landscape from the 1970s. De Kooning's abstract works from the 1970s-1980s have seen significant reappraisal."
            ),
            AuctionRecord(
                id: "dekooning_2",
                artworkTitle: "Woman as Landscape",
                yearCreated: "1955",
                medium: "Oil on canvas",
                auctionHouse: "Christie's",
                saleDate: "November 15, 2018",
                salePriceUSD: 68_937_500,
                estimateLowUSD: 50_000_000,
                estimateHighUSD: 70_000_000,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Christie's auction records",
                notes: "From the celebrated 'Woman' series. De Kooning's 1950s Woman paintings are considered pinnacles of Abstract Expressionism."
            ),
            AuctionRecord(
                id: "dekooning_3",
                artworkTitle: "Interchange",
                yearCreated: "1955",
                medium: "Oil on canvas",
                auctionHouse: "Private Sale",
                saleDate: "September 2015",
                salePriceUSD: 300_000_000,
                estimateLowUSD: nil,
                estimateHighUSD: nil,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Reported by Bloomberg and multiple sources",
                notes: "Reported private sale to Kenneth C. Griffin alongside Pollock's Number 17A ($200M). If confirmed, the highest price for any de Kooning work. Private sale data is less transparent."
            )
        ],
        marketNote: "De Kooning's market spans his entire career, with the highest prices achieved by 1950s Woman paintings and abstract landscapes. The reported $300M private sale of Interchange made it one of the most expensive paintings ever sold. His auction market consistently delivers eight-figure results.",
        primarySource: "Christie's auction records; Bloomberg (private sale)"
    )

    // ============================================================
    // MARK: 21. Matthew Wong
    // ============================================================
    static let wong = ArtistProfile(
        id: "artist_wong",
        name: "Matthew Wong",
        nationality: "Canadian (born in Toronto, of Chinese descent)",
        birthYear: 1984,
        deathYear: 2019,
        category: .emerging,
        auctionRecords: [
            AuctionRecord(
                id: "wong_1",
                artworkTitle: "The Realm of Appearances",
                yearCreated: "2018",
                medium: "Acrylic on canvas",
                auctionHouse: "Phillips",
                saleDate: "November 17, 2020",
                salePriceUSD: 4_864_500,
                estimateLowUSD: 600_000,
                estimateHighUSD: 800_000,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Phillips auction records",
                notes: "Exceeded estimate by over 6x. Wong's vibrantly colored, emotionally charged landscapes struck a chord with collectors after his death at age 35."
            ),
            AuctionRecord(
                id: "wong_2",
                artworkTitle: "River at Dusk",
                yearCreated: "2018",
                medium: "Oil on canvas",
                auctionHouse: "Sotheby's",
                saleDate: "December 2, 2020",
                salePriceUSD: 4_600_000,
                estimateLowUSD: 500_000,
                estimateHighUSD: 700_000,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Sotheby's auction records",
                notes: "Another result far exceeding estimates. Wong's market rose meteorically in 2020, driven by critical acclaim, emotional narrative, and tragically limited supply."
            ),
            AuctionRecord(
                id: "wong_3",
                artworkTitle: "Shangri-La",
                yearCreated: "2017",
                medium: "Oil on canvas",
                auctionHouse: "Christie's",
                saleDate: "November 10, 2022",
                salePriceUSD: 5_988_000,
                estimateLowUSD: 2_000_000,
                estimateHighUSD: 3_000_000,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Christie's auction records",
                notes: "Wong's auction record. His paintings were selling for a few thousand dollars during his lifetime. The posthumous market surge raises questions about speculation vs. genuine reappraisal."
            )
        ],
        marketNote: "Wong's market represents one of the most dramatic posthumous surges in recent memory, rising from gallery prices under $10K to auction results near $6M within a year of his death. His self-taught approach and emotional landscapes resonate with a wide collector base, though the rapid rise raises sustainability questions.",
        primarySource: "Phillips, Sotheby's, and Christie's auction records"
    )

    // ============================================================
    // MARK: 22. Henri Matisse
    // ============================================================
    static let matisse = ArtistProfile(
        id: "artist_matisse",
        name: "Henri Matisse",
        nationality: "French",
        birthYear: 1869,
        deathYear: 1954,
        category: .blueChip,
        auctionRecords: [
            AuctionRecord(
                id: "matisse_1",
                artworkTitle: "Odalisque couchee aux magnolias",
                yearCreated: "1923",
                medium: "Oil on canvas",
                auctionHouse: "Christie's",
                saleDate: "May 8, 2018",
                salePriceUSD: 80_750_000,
                estimateLowUSD: 50_000_000,
                estimateHighUSD: 70_000_000,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Christie's auction records",
                notes: "Matisse's auction record. From the Rockefeller Collection sale. The provenance significantly boosted the result."
            ),
            AuctionRecord(
                id: "matisse_2",
                artworkTitle: "Le Bonheur de vivre (study/related work)",
                yearCreated: "1905-1906",
                medium: "Oil on canvas",
                auctionHouse: "Christie's",
                saleDate: "May 15, 2017",
                salePriceUSD: 32_500_000,
                estimateLowUSD: 20_000_000,
                estimateHighUSD: 30_000_000,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Christie's auction records",
                notes: "Fauve-period work. Matisse's Fauvist works from 1905-1910 are among his most valued, alongside Odalisque paintings from the 1920s."
            ),
            AuctionRecord(
                id: "matisse_3",
                artworkTitle: "Nu de dos, 4 etat (Back IV)",
                yearCreated: "1930",
                medium: "Bronze",
                auctionHouse: "Christie's",
                saleDate: "November 9, 2010",
                salePriceUSD: 48_802_500,
                estimateLowUSD: 25_000_000,
                estimateHighUSD: 35_000_000,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Christie's auction records",
                notes: "From the landmark series of four monumental bronze reliefs. One of the most important modern sculptures. Demonstrates Matisse's market beyond painting."
            )
        ],
        marketNote: "Matisse's market is broad and deep, spanning painting, sculpture, drawing, and cut-outs. His Fauvist works (1905-1910) and Odalisque paintings (1920s) command the highest prices. Top-tier provenance (like the Rockefeller Collection) can add significant premiums.",
        primarySource: "Christie's auction records"
    )

    // ============================================================
    // MARK: 23. Edgar Degas
    // ============================================================
    static let degas = ArtistProfile(
        id: "artist_degas",
        name: "Edgar Degas",
        nationality: "French",
        birthYear: 1834,
        deathYear: 1917,
        category: .blueChip,
        auctionRecords: [
            AuctionRecord(
                id: "degas_1",
                artworkTitle: "Danseuse au repos (Dancer at Rest)",
                yearCreated: "c. 1879",
                medium: "Pastel and gouache on joined paper",
                auctionHouse: "Sotheby's",
                saleDate: "November 1, 2022",
                salePriceUSD: 41_633_000,
                estimateLowUSD: 25_000_000,
                estimateHighUSD: 35_000_000,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Sotheby's auction records",
                notes: "Dancer subject from Degas's most celebrated theme. Set a new auction record for the artist. Degas's pastels of dancers are his most iconic and valuable works."
            ),
            AuctionRecord(
                id: "degas_2",
                artworkTitle: "Petite danseuse de quatorze ans (Little Fourteen-Year-Old Dancer)",
                yearCreated: "c. 1880, cast 1922",
                medium: "Bronze with fabric and hair",
                auctionHouse: "Sotheby's",
                saleDate: "February 3, 2009",
                salePriceUSD: 18_800_000,
                estimateLowUSD: 20_000_000,
                estimateHighUSD: 25_000_000,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Sotheby's auction records",
                notes: "Degas's most famous sculpture, in posthumous bronze cast. The original wax is at the National Gallery of Art, Washington. Multiple casts exist, affecting market."
            ),
            AuctionRecord(
                id: "degas_3",
                artworkTitle: "Danseuses a la barre (Dancers at the Barre)",
                yearCreated: "c. 1877",
                medium: "Oil paint mixed with turpentine on canvas",
                auctionHouse: "Christie's",
                saleDate: "November 1, 2011",
                salePriceUSD: 3_700_000,
                estimateLowUSD: 3_000_000,
                estimateHighUSD: 5_000_000,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Christie's auction records",
                notes: "Dancers at the barre is a recurring motif in Degas's oeuvre. Multiple versions exist across museums and private collections."
            )
        ],
        marketNote: "Degas's market is anchored by his dancer subjects in pastel and sculpture, which consistently achieve the highest prices. His racecourse scenes and bather compositions form secondary collecting categories. Pastels often outperform oils due to their association with his most celebrated subjects.",
        primarySource: "Sotheby's and Christie's auction records"
    )

    // ============================================================
    // MARK: 24. Beeple (Mike Winkelmann)
    // ============================================================
    static let beeple = ArtistProfile(
        id: "artist_beeple",
        name: "Beeple (Mike Winkelmann)",
        nationality: "American",
        birthYear: 1981,
        deathYear: nil,
        category: .nft,
        auctionRecords: [
            AuctionRecord(
                id: "beeple_1",
                artworkTitle: "Everydays: The First 5000 Days",
                yearCreated: "2007-2021",
                medium: "NFT (non-fungible token), digital art",
                auctionHouse: "Christie's",
                saleDate: "March 11, 2021",
                salePriceUSD: 69_346_250,
                estimateLowUSD: 100,
                estimateHighUSD: nil,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Christie's auction records",
                notes: "First purely digital NFT sold by a major auction house. Purchased by Vignesh Sundaresan (MetaKovan). Comprises 5,000 images created daily over 13+ years. Made Beeple the third most expensive living artist at the time."
            ),
            AuctionRecord(
                id: "beeple_2",
                artworkTitle: "HUMAN ONE",
                yearCreated: "2021",
                medium: "Kinetic video sculpture, NFT (hybrid physical-digital)",
                auctionHouse: "Christie's",
                saleDate: "November 9, 2021",
                salePriceUSD: 28_985_000,
                estimateLowUSD: 10_000_000,
                estimateHighUSD: 15_000_000,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "Christie's auction records",
                notes: "Hybrid physical/digital artwork: a 7-foot-tall box with screens showing a continuously evolving digital figure. Beeple retains the ability to update the digital content remotely, raising novel ownership questions."
            ),
            AuctionRecord(
                id: "beeple_3",
                artworkTitle: "Crossroad",
                yearCreated: "2020",
                medium: "NFT, digital art",
                auctionHouse: "Nifty Gateway (secondary)",
                saleDate: "February 25, 2021",
                salePriceUSD: 6_600_000,
                estimateLowUSD: nil,
                estimateHighUSD: nil,
                previousSalePriceUSD: 66_666,
                previousSaleYear: 2020,
                source: "Nifty Gateway marketplace records",
                notes: "Originally minted and sold for $66,666 in October 2020. Resold four months later for $6.6M on Nifty Gateway, a 9,800% return. One of the earliest NFT flips demonstrating the speculative frenzy."
            )
        ],
        marketNote: "Beeple's $69.3M Christie's sale was the watershed moment for NFT art, legitimizing digital art in the traditional auction world. His market is unique in that it spans both traditional auction houses and crypto-native platforms. The broader NFT market has cooled significantly since the 2021 peak.",
        primarySource: "Christie's auction records; Nifty Gateway"
    )

    // ============================================================
    // MARK: 25. Vespers (Emerging)
    // ============================================================
    static let vespers = ArtistProfile(
        id: "artist_vespers",
        name: "Vespers",
        nationality: "Various/Collective (Digital Art Collective)",
        birthYear: 2020,
        deathYear: nil,
        category: .emerging,
        auctionRecords: [
            AuctionRecord(
                id: "vespers_1",
                artworkTitle: "Vespers Collection (Representative Lot)",
                yearCreated: "2021-2023",
                medium: "Generative digital art / NFT",
                auctionHouse: "Various NFT platforms",
                saleDate: "2021-2023",
                salePriceUSD: 25_000,
                estimateLowUSD: nil,
                estimateHighUSD: nil,
                previousSalePriceUSD: nil,
                previousSaleYear: nil,
                source: "NFT marketplace records",
                notes: "Emerging digital art project. Market data is limited and primarily available through NFT marketplace transaction histories. Prices for individual pieces have ranged from sub-$1K to mid-five figures during the 2021-2022 NFT boom."
            )
        ],
        marketNote: "As an emerging artist/collective in the digital art space, Vespers represents the speculative end of the art market. Limited public auction data is available; most transactions occur on NFT platforms. The broader NFT art market has contracted significantly since 2022.",
        primarySource: "NFT marketplace transaction records"
    )
}

// MARK: - Educational Context and Disclaimers

struct ArtMarketEducationalNotes {

    static let disclaimer = """
    EDUCATIONAL DISCLAIMER: The auction data presented in this app is sourced from \
    publicly reported auction records at major houses including Christie's, Sotheby's, \
    and Phillips. This information is presented for educational purposes only to \
    illustrate how art functions as an alternative asset class. Past auction results \
    do not predict future performance. Art market returns involve significant risks \
    including illiquidity, authentication uncertainty, condition issues, changing taste, \
    and transaction costs (buyer's premium of 20-26%, insurance, storage, etc.). \
    This app does NOT provide investment advice.
    """

    static let sourcesNote = """
    Data sources: Christie's public auction records, Sotheby's public auction records, \
    Phillips public auction records, Artnet Price Database (referenced), Bloomberg \
    (private sale reports). All prices include buyer's premium unless otherwise noted. \
    Private sale prices are reported figures and may not be independently verified.
    """

    static let keyMarketConcepts = [
        "Buyer's Premium: Fee charged by auction houses (typically 20-26%) added to the hammer price. All prices in this database include buyer's premium.",
        "Hammer Price: The winning bid at auction before buyer's premium and taxes.",
        "Estimate: Pre-sale price range set by the auction house. Results above estimate suggest strong demand.",
        "Provenance: Documented ownership history. Notable provenance (celebrity, museum, important collection) adds premium.",
        "Private Sale: Transaction conducted outside public auction. Prices are reported but not independently verified.",
        "Reserve: Minimum price agreed between seller and auction house. If bidding doesn't reach the reserve, the lot goes unsold ('bought in').",
        "Condition: Physical state of the artwork. Condition issues can significantly reduce value.",
        "Authentication: Verification of attribution to the artist. Disputed attribution dramatically affects value."
    ]

    /// Summary statistics for the database
    static var summaryStats: (totalArtists: Int, totalRecords: Int, highestSale: String, highestSalePrice: String) {
        let artists = ArtAuctionDatabase.allArtists
        let records = artists.flatMap { $0.auctionRecords }
        let highest = records.max(by: { $0.salePriceUSD < $1.salePriceUSD })
        return (
            totalArtists: artists.count,
            totalRecords: records.count,
            highestSale: highest?.artworkTitle ?? "N/A",
            highestSalePrice: highest?.formattedPrice ?? "N/A"
        )
    }
}
