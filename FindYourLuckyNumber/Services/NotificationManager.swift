import Foundation
import UserNotifications

final class NotificationManager {
    func requestAuthorization() async -> Bool {
        do {
            return try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
        } catch {
            return false
        }
    }

    func scheduleDailyLuckyNumber(hour: Int = 8, minute: Int = 0) async {
        let content = UNMutableNotificationContent()
        content.title = "Your lucky number is ready"
        content.body = "Open My Lucky Number for today's prediction and guidance."
        content.sound = .default

        var components = DateComponents()
        components.hour = hour
        components.minute = minute
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: "daily-lucky-number", content: content, trigger: trigger)
        try? await UNUserNotificationCenter.current().add(request)
    }

    func scheduleWeeklySummary() async {
        let content = UNMutableNotificationContent()
        content.title = "Weekly lucky number summary"
        content.body = "Review your strongest numbers and unlock new insights."
        content.sound = .default

        var components = DateComponents()
        components.weekday = 2
        components.hour = 9
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: "weekly-summary", content: content, trigger: trigger)
        try? await UNUserNotificationCenter.current().add(request)
    }

    func cancelAll() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
