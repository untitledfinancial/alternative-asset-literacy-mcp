//
//  UserSettings.swift
//  Enhanced App for Alt Assets
//
//  Created by Victoria Case on 2/4/26.
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//
//  Description: User preferences for app customization including font selection,
//  text size, and display options. Persists settings to UserDefaults.
//

import SwiftUI
import Combine

// MARK: - User Settings Manager
class UserSettings: ObservableObject {
    static let shared = UserSettings()

    // MARK: - Font Settings
    @Published var fontStyle: FontStyle {
        didSet { save() }
    }

    @Published var textSize: TextSize {
        didSet { save() }
    }

    @Published var useSerifForBody: Bool {
        didSet { save() }
    }

    // MARK: - Display Settings
    @Published var showEmojis: Bool {
        didSet { save() }
    }

    // MARK: - Personalization
    @Published var userName: String {
        didSet { save() }
    }

    @Published var courseName: String {
        didSet { save() }
    }

    private let defaults = UserDefaults.standard

    init() {
        // Load saved preferences
        if let fontStyleRaw = defaults.string(forKey: "fontStyle"),
           let style = FontStyle(rawValue: fontStyleRaw) {
            self.fontStyle = style
        } else {
            self.fontStyle = .system
        }

        if let textSizeRaw = defaults.string(forKey: "textSize"),
           let size = TextSize(rawValue: textSizeRaw) {
            self.textSize = size
        } else {
            self.textSize = .medium
        }

        self.useSerifForBody = defaults.bool(forKey: "useSerifForBody")
        self.showEmojis = defaults.object(forKey: "showEmojis") as? Bool ?? true
        self.userName = defaults.string(forKey: "userName") ?? ""
        self.courseName = defaults.string(forKey: "courseName") ?? "Alternative Assets"
    }

    private func save() {
        defaults.set(fontStyle.rawValue, forKey: "fontStyle")
        defaults.set(textSize.rawValue, forKey: "textSize")
        defaults.set(useSerifForBody, forKey: "useSerifForBody")
        defaults.set(showEmojis, forKey: "showEmojis")
        defaults.set(userName, forKey: "userName")
        defaults.set(courseName, forKey: "courseName")
    }

    // Helper for personalized greeting
    var personalizedGreeting: String {
        if userName.isEmpty {
            return ""
        } else {
            return ", \(userName)"
        }
    }
}

// MARK: - Font Style Options (like Notion)
enum FontStyle: String, CaseIterable, Identifiable {
    case system = "Default"
    case serif = "Serif"
    case mono = "Mono"

    var id: String { rawValue }

    var displayName: String { rawValue }

    var description: String {
        switch self {
        case .system: return "Clean and modern"
        case .serif: return "Classic and readable"
        case .mono: return "Technical and precise"
        }
    }

    // Font for headings
    func headingFont(size: CGFloat, weight: Font.Weight = .bold) -> Font {
        switch self {
        case .system:
            return .system(size: size, weight: weight, design: .default)
        case .serif:
            return .system(size: size, weight: weight, design: .serif)
        case .mono:
            return .system(size: size, weight: weight, design: .monospaced)
        }
    }

    // Font for body text
    func bodyFont(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        switch self {
        case .system:
            return .system(size: size, weight: weight, design: .default)
        case .serif:
            return .system(size: size, weight: weight, design: .serif)
        case .mono:
            return .system(size: size, weight: weight, design: .monospaced)
        }
    }
}

// MARK: - Text Size Options
enum TextSize: String, CaseIterable, Identifiable {
    case small = "Small"
    case medium = "Medium"
    case large = "Large"
    case extraLarge = "Extra Large"

    var id: String { rawValue }

    var displayName: String { rawValue }

    var scaleFactor: CGFloat {
        switch self {
        case .small: return 0.85
        case .medium: return 1.0
        case .large: return 1.15
        case .extraLarge: return 1.3
        }
    }
}

// MARK: - Dynamic Typography
struct DynamicTypography {
    let settings: UserSettings

    init(settings: UserSettings = .shared) {
        self.settings = settings
    }

    private var scale: CGFloat { settings.textSize.scaleFactor }
    private var style: FontStyle { settings.fontStyle }

    // Display styles
    var displayLarge: Font {
        style.headingFont(size: 48 * scale, weight: .bold)
    }

    var displayMedium: Font {
        style.headingFont(size: 36 * scale, weight: .bold)
    }

    var displaySmall: Font {
        style.headingFont(size: 28 * scale, weight: .bold)
    }

    // Title styles
    var title1: Font {
        style.headingFont(size: 28 * scale, weight: .bold)
    }

    var title2: Font {
        style.headingFont(size: 22 * scale, weight: .semibold)
    }

    var title3: Font {
        style.headingFont(size: 20 * scale, weight: .semibold)
    }

    // Body styles
    var body: Font {
        if settings.useSerifForBody && style == .system {
            return .system(size: 17 * scale, weight: .regular, design: .serif)
        }
        return style.bodyFont(size: 17 * scale)
    }

    var bodyMedium: Font {
        if settings.useSerifForBody && style == .system {
            return .system(size: 17 * scale, weight: .medium, design: .serif)
        }
        return style.bodyFont(size: 17 * scale, weight: .medium)
    }

    var caption: Font {
        style.bodyFont(size: 13 * scale)
    }

    var caption2: Font {
        style.bodyFont(size: 11 * scale)
    }

    // Quote style (always serif for elegance)
    var quote: Font {
        .system(size: 18 * scale, weight: .regular, design: .serif)
    }
}

// MARK: - Environment Key
struct UserSettingsKey: EnvironmentKey {
    static let defaultValue: UserSettings = .shared
}

extension EnvironmentValues {
    var userSettings: UserSettings {
        get { self[UserSettingsKey.self] }
        set { self[UserSettingsKey.self] = newValue }
    }
}
