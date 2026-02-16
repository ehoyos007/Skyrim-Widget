import Foundation
import UserNotifications
import SwiftData

class NotificationService {
    static let shared = NotificationService()
    private let center = UNUserNotificationCenter.current()
    private let notificationID = "dailyQuote"

    private init() {}

    func requestPermission() async -> Bool {
        do {
            return try await center.requestAuthorization(options: [.alert, .sound, .badge])
        } catch {
            return false
        }
    }

    @MainActor
    func scheduleDaily(
        quote: Quote?,
        hour: Int,
        minute: Int,
        modelContext: ModelContext
    ) async {
        center.removePendingNotificationRequests(withIdentifiers: [notificationID])

        let selectedQuote = quote ?? fetchRandomQuote(modelContext: modelContext)
        guard let selectedQuote else { return }

        let content = UNMutableNotificationContent()
        content.title = "Shouts of Skyrim"
        content.body = "\u{201C}\(selectedQuote.text)\u{201D} -- \(selectedQuote.npcName)"
        content.sound = .default
        content.userInfo = ["quoteID": selectedQuote.id.uuidString]

        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents,
            repeats: true
        )

        let request = UNNotificationRequest(
            identifier: notificationID,
            content: content,
            trigger: trigger
        )

        try? await center.add(request)
    }

    func cancel() {
        center.removePendingNotificationRequests(withIdentifiers: [notificationID])
    }

    @MainActor
    private func fetchRandomQuote(modelContext: ModelContext) -> Quote? {
        let descriptor = FetchDescriptor<Quote>()
        guard let quotes = try? modelContext.fetch(descriptor), !quotes.isEmpty else {
            return nil
        }
        return quotes.randomElement()
    }
}
