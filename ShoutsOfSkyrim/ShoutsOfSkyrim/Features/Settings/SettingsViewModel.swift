import SwiftUI
import SwiftData

@Observable
class SettingsViewModel {
    var notificationEnabled: Bool = false
    var notificationHour: Int = 9
    var notificationMinute: Int = 0

    var notificationTime: Date {
        get {
            var components = DateComponents()
            components.hour = notificationHour
            components.minute = notificationMinute
            return Calendar.current.date(from: components) ?? Date()
        }
        set {
            let components = Calendar.current.dateComponents([.hour, .minute], from: newValue)
            notificationHour = components.hour ?? 9
            notificationMinute = components.minute ?? 0
        }
    }

    func loadFromPrefs(_ prefs: UserPrefs?) {
        guard let prefs else { return }
        notificationEnabled = prefs.notificationEnabled
        notificationHour = prefs.notificationHour
        notificationMinute = prefs.notificationMinute
    }

    @MainActor
    func saveToPrefs(_ prefs: UserPrefs?, modelContext: ModelContext) {
        guard let prefs else { return }
        prefs.notificationEnabled = notificationEnabled
        prefs.notificationHour = notificationHour
        prefs.notificationMinute = notificationMinute
        try? modelContext.save()
    }

    @MainActor
    func toggleNotifications(prefs: UserPrefs?, modelContext: ModelContext) async {
        if notificationEnabled {
            let granted = await NotificationService.shared.requestPermission()
            if !granted {
                notificationEnabled = false
                saveToPrefs(prefs, modelContext: modelContext)
                return
            }
            saveToPrefs(prefs, modelContext: modelContext)
            await NotificationService.shared.scheduleDaily(
                quote: nil,
                hour: notificationHour,
                minute: notificationMinute,
                modelContext: modelContext
            )
        } else {
            NotificationService.shared.cancel()
            saveToPrefs(prefs, modelContext: modelContext)
        }
    }

    @MainActor
    func updateNotificationTime(prefs: UserPrefs?, modelContext: ModelContext) async {
        saveToPrefs(prefs, modelContext: modelContext)
        if notificationEnabled {
            await NotificationService.shared.scheduleDaily(
                quote: nil,
                hour: notificationHour,
                minute: notificationMinute,
                modelContext: modelContext
            )
        }
    }
}
