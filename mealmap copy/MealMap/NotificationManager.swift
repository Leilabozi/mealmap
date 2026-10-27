import Foundation
import UserNotifications

/// Manages notification permissions and local notification scheduling.
/// - Note: For App Store release, ensure you:
///   1. Add a user-facing explanation for notifications in your onboarding/UI.
///   2. Include relevant Info.plist keys if you use provisional/critical alerts (not required for standard alerts).
///   3. Enable the Push Notifications capability only if you use remote notifications.
///   4. Test on-device with a Release build.
actor NotificationManager {
    static let shared = NotificationManager()

    private let center = UNUserNotificationCenter.current()

    /// Requests authorization for alert, sound, and badge notifications.
    /// - Returns: The current authorization status after prompting (if needed).
    @discardableResult
    func requestAuthorization() async -> UNAuthorizationStatus {
        do {
            let settings = await center.notificationSettings()
            switch settings.authorizationStatus {
            case .notDetermined:
                let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
                if !granted {
                    return await center.notificationSettings().authorizationStatus
                }
                return await center.notificationSettings().authorizationStatus
            default:
                return settings.authorizationStatus
            }
        } catch {
            return await center.notificationSettings().authorizationStatus
        }
    }

    /// Returns the current notification authorization status without prompting.
    func authorizationStatus() async -> UNAuthorizationStatus {
        let settings = await center.notificationSettings()
        return settings.authorizationStatus
    }

    /// Schedules a one-time local notification at a specific date.
    /// - Parameters:
    ///   - identifier: A unique identifier for the notification request.
    ///   - title: The notification title.
    ///   - body: The notification body.
    ///   - date: The date at which to fire the notification.
    ///   - sound: Optional custom sound. Defaults to `.default`.
    func scheduleNotification(
        identifier: String,
        title: String,
        body: String,
        date: Date,
        sound: UNNotificationSound? = .default
    ) async throws {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = sound

        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        try await center.add(request)
    }

    /// Cancels a scheduled notification with the given identifier.
    func cancelNotification(identifier: String) async {
        await center.removePendingNotificationRequests(withIdentifiers: [identifier])
    }

    /// Cancels all pending notifications scheduled by the app.
    func cancelAll() async {
        await center.removeAllPendingNotificationRequests()
    }
}

// MARK: - Convenience for Meal Reminders

extension NotificationManager {
    /// Schedules a reminder for a meal at a given date.
    /// - Parameters:
    ///   - mealTypeTitle: User-facing meal type title (e.g., "Breakfast").
    ///   - recipeTitle: User-facing recipe title.
    ///   - date: When the reminder should fire.
    /// - Returns: The identifier for the scheduled notification.
    @discardableResult
    func scheduleMealReminder(
        mealTypeTitle: String,
        recipeTitle: String,
        date: Date
    ) async throws -> String {
        let id = "meal-reminder-\(mealTypeTitle)-\(date.timeIntervalSince1970)"
        let title = "\(mealTypeTitle) Reminder"
        let body = "Don't forget: \(recipeTitle)"
        try await scheduleNotification(
            identifier: id,
            title: title,
            body: body,
            date: date,
            sound: .default
        )
        return id
    }
}
