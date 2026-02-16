import Foundation
import UserNotifications

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    let deepLinkHandler: DeepLinkHandler

    init(deepLinkHandler: DeepLinkHandler) {
        self.deepLinkHandler = deepLinkHandler
        super.init()
    }

    // Handle notification tap when app is in foreground
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        [.banner, .sound]
    }

    // Handle notification tap to navigate to quote
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {
        let userInfo = response.notification.request.content.userInfo
        guard let quoteIDString = userInfo["quoteID"] as? String,
              let quoteID = UUID(uuidString: quoteIDString) else {
            return
        }

        await MainActor.run {
            deepLinkHandler.selectedTab = .quotes
            deepLinkHandler.pendingQuoteID = quoteID
        }
    }
}
