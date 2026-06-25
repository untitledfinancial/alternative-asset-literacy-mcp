//
//  NetworkMonitor.swift
//  Enhanced App for Alt Assets
//
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//

import Combine
import Network
import SwiftUI

final class NetworkMonitor: ObservableObject {
    static let shared = NetworkMonitor()

    @Published private(set) var isConnected: Bool = true

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor", qos: .utility)

    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
}

struct OfflineBanner: View {
    @ObservedObject private var monitor = NetworkMonitor.shared

    var body: some View {
        if !monitor.isConnected {
            HStack(spacing: Spacing.sm) {
                Image(systemName: "wifi.slash")
                    .font(.caption)
                Text("Using cached content — connect to refresh")
                    .font(Typography.caption)
            }
            .foregroundColor(.white)
            .padding(.horizontal, Spacing.md)
            .padding(.vertical, Spacing.xs)
            .frame(maxWidth: .infinity)
            .background(Color.textSecondary)
            .transition(.move(edge: .top).combined(with: .opacity))
        }
    }
}
