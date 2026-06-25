//
//  ModuleCompletionCertificate.swift
//  Enhanced App for Alt Assets
//
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//

import SwiftUI
import Photos

// MARK: - Certificate Canvas (renderable as image)
struct ModuleCompletionCertificateView: View {
    let module: Module
    let completedDate: Date
    let quizScore: Double?

    private var formattedDate: String {
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .none
        return f.string(from: completedDate)
    }

    private var scoreText: String? {
        guard let score = quizScore else { return nil }
        return "\(Int(score * 100))%"
    }

    var body: some View {
        ZStack {
            Color(hex: "#2B3A4D")

            VStack(spacing: 0) {
                Rectangle()
                    .fill(Color(hex: "#C75D5D"))
                    .frame(height: 3)

                Spacer()

                VStack(spacing: 24) {
                    Text("UNTITLED_")
                        .font(.system(size: 11, weight: .medium, design: .monospaced))
                        .kerning(4)
                        .foregroundColor(Color(hex: "#C75D5D"))

                    Text(module.icon)
                        .font(.system(size: 52))

                    Text("Certificate of Completion")
                        .font(.system(size: 13, weight: .light))
                        .kerning(2)
                        .foregroundColor(Color.white.opacity(0.55))
                        .textCase(.uppercase)

                    Text(module.title)
                        .font(.system(size: 26, weight: .semibold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .padding(.horizontal, 32)

                    HStack(spacing: 12) {
                        Rectangle().fill(Color.white.opacity(0.2)).frame(height: 1)
                        Text("✦").font(.system(size: 10)).foregroundColor(Color.white.opacity(0.3))
                        Rectangle().fill(Color.white.opacity(0.2)).frame(height: 1)
                    }
                    .padding(.horizontal, 40)

                    HStack(spacing: 32) {
                        if let score = scoreText {
                            VStack(spacing: 4) {
                                Text(score)
                                    .font(.system(size: 22, weight: .semibold))
                                    .foregroundColor(Color(hex: "#C75D5D"))
                                Text("Quiz Score")
                                    .font(.system(size: 10, weight: .medium))
                                    .kerning(1.5)
                                    .foregroundColor(Color.white.opacity(0.45))
                                    .textCase(.uppercase)
                            }
                        }
                        VStack(spacing: 4) {
                            Text(formattedDate)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.white)
                            Text("Completed")
                                .font(.system(size: 10, weight: .medium))
                                .kerning(1.5)
                                .foregroundColor(Color.white.opacity(0.45))
                                .textCase(.uppercase)
                        }
                    }
                }

                Spacer()

                Rectangle()
                    .fill(Color.white.opacity(0.12))
                    .frame(height: 1)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 24)

                Text("alternativeassetsliteracy.com")
                    .font(.system(size: 10, weight: .light))
                    .kerning(1.5)
                    .foregroundColor(Color.white.opacity(0.3))
                    .padding(.bottom, 32)
            }
        }
        .frame(width: 540, height: 360)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Certificate Sheet
struct ModuleCompletionCertificateSheet: View {
    let module: Module
    @EnvironmentObject var progressManager: ProgressManager
    @Environment(\.dismiss) private var dismiss

    @State private var saveState: SaveState = .idle
    @State private var showingShareSheet = false
    @State private var renderedImage: UIImage?

    enum SaveState { case idle, saved, denied }

    private var quizScore: Double? {
        module.quizzes.compactMap { progressManager.progress.quizScores[$0.id] }.max()
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: Spacing.xl) {
                ModuleCompletionCertificateView(
                    module: module,
                    completedDate: Date(),
                    quizScore: quizScore
                )
                .shadow(color: Color.black.opacity(0.25), radius: 24, x: 0, y: 8)
                .padding(.horizontal, Spacing.lg)
                .padding(.top, Spacing.lg)

                Text("You completed \(module.title).")
                    .font(Typography.bodyMedium)
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.center)

                HStack(spacing: Spacing.md) {
                    Button {
                        saveToPhotos()
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: saveState == .saved ? "checkmark" : "square.and.arrow.down")
                            Text(saveState == .saved ? "Saved" : saveState == .denied ? "Permission denied" : "Save to Photos")
                        }
                        .font(Typography.bodyMedium)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Spacing.md)
                        .background(saveState == .saved ? Color.success : Color.brandPrimary)
                        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
                    }
                    .disabled(saveState == .saved)

                    Button {
                        renderedImage = render()
                        showingShareSheet = true
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                            .font(Typography.bodyMedium)
                            .foregroundColor(.brandPrimary)
                            .frame(width: 50, height: 50)
                            .background(Color.brandPrimary.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
                    }
                }
                .padding(.horizontal, Spacing.xl)

                Spacer()
            }
            .navigationTitle("Certificate")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
            .sheet(isPresented: $showingShareSheet) {
                if let img = renderedImage {
                    ShareSheetView(items: [img])
                }
            }
        }
    }

    private func render() -> UIImage? {
        let renderer = ImageRenderer(
            content: ModuleCompletionCertificateView(
                module: module,
                completedDate: Date(),
                quizScore: quizScore
            )
        )
        renderer.scale = 3
        return renderer.uiImage
    }

    private func saveToPhotos() {
        guard let img = render() else { return }
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
            DispatchQueue.main.async {
                if status == .authorized || status == .limited {
                    UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
                    saveState = .saved
                } else {
                    saveState = .denied
                }
            }
        }
    }
}

// MARK: - UIActivityViewController wrapper
struct ShareSheetView: UIViewControllerRepresentable {
    let items: [Any]
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    func updateUIViewController(_ uvc: UIActivityViewController, context: Context) {}
}
