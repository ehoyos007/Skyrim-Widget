import SwiftUI
import SwiftData
import WidgetKit

@Observable
class ThemesViewModel {
    var themes: [AppTheme] = AppTheme.all

    @MainActor
    func selectTheme(_ theme: AppTheme, themeManager: ThemeManager, prefs: UserPrefs?) {
        themeManager.apply(theme, to: prefs)
        WidgetCenter.shared.reloadAllTimelines()
    }
}
