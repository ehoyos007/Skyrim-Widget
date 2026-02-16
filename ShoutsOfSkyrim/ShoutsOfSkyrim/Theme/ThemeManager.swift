import SwiftUI
import SwiftData

@Observable
class ThemeManager {
    var current: AppTheme = .whiterun

    /// Load the theme from persisted UserPrefs
    func load(from prefs: UserPrefs?) {
        guard let prefs else { return }
        current = AppTheme.theme(forKey: prefs.selectedTheme)
    }

    /// Apply a new theme and persist the selection
    func apply(_ theme: AppTheme, to prefs: UserPrefs?) {
        current = theme
        prefs?.selectedTheme = theme.id
    }
}
