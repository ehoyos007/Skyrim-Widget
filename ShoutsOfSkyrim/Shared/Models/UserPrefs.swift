import Foundation
import SwiftData

@Model
class UserPrefs {
    var selectedTheme: String
    var activeCategories: [String]
    var notificationEnabled: Bool
    var notificationHour: Int
    var notificationMinute: Int

    init() {
        self.selectedTheme = "whiterun"
        self.activeCategories = QuoteCategory.allCases.map(\.rawValue)
        self.notificationEnabled = false
        self.notificationHour = 9
        self.notificationMinute = 0
    }
}
