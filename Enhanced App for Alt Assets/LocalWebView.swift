//
//  LocalWebView.swift
//  Enhanced App for Alt Assets
//
//  Created by Victoria Case on 2026-06-03.
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//
//  Description: SwiftUI wrapper for WKWebView used to display self-contained
//  HTML files bundled with the app (e.g. the interactive wine regions map).
//

import SwiftUI
import WebKit

// MARK: - WKWebView SwiftUI Wrapper

struct LocalWebView: UIViewRepresentable {
    let filename: String

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.scrollView.isScrollEnabled = true
        webView.backgroundColor = UIColor(red: 0.05, green: 0.07, blue: 0.09, alpha: 1) // match dark map bg
        webView.isOpaque = false
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "html") else {
            // Fallback: show an error page inline
            let errorHTML = """
            <html><body style='background:#0d1117;color:#c9a84c;font-family:Georgia,serif;padding:2em;text-align:center;'>
            <h2>Map Unavailable</h2>
            <p>The file <code>\(filename).html</code> was not found in the app bundle.</p>
            </body></html>
            """
            webView.loadHTMLString(errorHTML, baseURL: nil)
            return
        }
        webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
    }
}

// MARK: - Module Content Block View

struct LocalWebViewBlock: View {
    let filename: String
    let title: String
    let caption: String?

    @State private var isExpanded: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header tap to expand
            Button {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.82)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack(spacing: Spacing.sm) {
                    Image(systemName: "map.fill")
                        .foregroundStyle(Color.adaptive(light: Color(hex: "#2B3A4D"), dark: Color(hex: "#8BA4C4")))
                        .font(.system(size: 16, weight: .medium))

                    Text(title)
                        .font(Typography.bodyMedium)
                        .foregroundColor(.textPrimary)

                    Spacer()

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.textSecondary)
                        .font(.system(size: 13, weight: .medium))
                }
                .padding(Spacing.md)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.adaptive(
                            light: Color(hex: "#2B3A4D").opacity(0.06),
                            dark: Color(hex: "#8BA4C4").opacity(0.1)
                        ))
                )
            }
            .buttonStyle(.plain)

            // Expandable map
            if isExpanded {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    LocalWebView(filename: filename)
                        .frame(height: 480)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.top, Spacing.xs)

                    if let caption = caption {
                        Text(caption)
                            .font(Typography.caption)
                            .foregroundColor(.textSecondary)
                            .padding(.horizontal, Spacing.xs)
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(.vertical, Spacing.xs)
    }
}
