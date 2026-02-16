import SwiftUI

struct TabBarView: View {
    @Environment(ThemeManager.self) private var themeManager
    @Bindable var deepLinkHandler: DeepLinkHandler

    var body: some View {
        let theme = themeManager.current

        TabView(selection: $deepLinkHandler.selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(AppTab.home)

            QuoteBrowserView(deepLinkHandler: deepLinkHandler)
                .tabItem {
                    Label("Quotes", systemImage: "book.fill")
                }
                .tag(AppTab.quotes)

            ThemeSelectorView()
                .tabItem {
                    Label("Themes", systemImage: "paintbrush.fill")
                }
                .tag(AppTab.themes)

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(AppTab.settings)
        }
        .tint(theme.accent)
    }
}
