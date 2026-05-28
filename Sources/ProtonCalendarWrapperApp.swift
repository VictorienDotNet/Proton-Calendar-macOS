import SwiftUI
import UserNotifications

@main
struct ProtonCalendarWrapperApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        WindowGroup {
            CalendarRootView()
                .frame(minWidth: 1100, minHeight: 720)
        }
        .windowStyle(.automatic)
        //.windowStyle(.hiddenTitleBar) // for hidden title bar
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate, UNUserNotificationCenterDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        AppNotificationBridge.shared.requestAuthorizationIfNeeded()
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound])
    }
}

