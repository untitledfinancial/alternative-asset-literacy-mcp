//
//  NotificationManager.swift
//  Enhanced App for Alt Assets
//
//  Copyright © 2026 Untitled_ LuxPerpetua Technologies, Inc. All rights reserved.
//

import UserNotifications
import Foundation

class NotificationManager {
    static let shared = NotificationManager()
    static let reviewReminderID = "spaced_review_reminder"

    private init() {}

    func requestPermission() async {
        let center = UNUserNotificationCenter.current()
        do {
            let granted = try await center.requestAuthorization(options: [.alert, .badge, .sound])
            if granted {
                await scheduleReviewReminder(dueCount: nil)
            }
        } catch {
            // Permission denied — silent fail
        }
    }

    /// Schedule (or replace) a daily 9 AM review reminder.
    func scheduleReviewReminder(dueCount: Int?) async {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [Self.reviewReminderID])

        let settings = await center.notificationSettings()
        guard settings.authorizationStatus == .authorized else { return }

        let content = UNMutableNotificationContent()
        content.sound = .default

        if let count = dueCount, count > 0 {
            content.title = "Review due"
            content.body = count == 1
                ? "1 concept is ready for review."
                : "\(count) concepts are ready for review."
        } else {
            content.title = "Keep the momentum"
            content.body = "Your concepts are ready for review. A few minutes today compounds over time."
        }

        var components = DateComponents()
        components.hour = 9
        components.minute = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)

        let request = UNNotificationRequest(
            identifier: Self.reviewReminderID,
            content: content,
            trigger: trigger
        )
        try? await center.add(request)
    }

    /// Call after a review session to update next-day copy with remaining count.
    func updateAfterReview(remainingDue: Int) async {
        await scheduleReviewReminder(dueCount: remainingDue > 0 ? remainingDue : nil)
    }
}
