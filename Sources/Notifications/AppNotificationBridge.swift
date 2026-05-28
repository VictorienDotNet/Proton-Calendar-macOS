import Foundation
import UserNotifications

final class AppNotificationBridge {
    static let shared = AppNotificationBridge()

    private init() {}

    func requestAuthorizationIfNeeded() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus == .notDetermined else { return }
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in
                // Intentionally ignore result; if denied, notifications just won't show.
            }
        }
    }

    func post(title: String, body: String?) {
        let content = UNMutableNotificationContent()
        content.title = title
        if let body, !body.isEmpty {
            content.body = body
        }

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }
}

