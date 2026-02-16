import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(ThemeManager.self) private var themeManager
    @Query private var allPrefs: [UserPrefs]
    @State private var viewModel = SettingsViewModel()

    private var prefs: UserPrefs? { allPrefs.first }

    var body: some View {
        let theme = themeManager.current

        NavigationStack {
            List {
                notificationsSection(theme: theme)
                aboutSection(theme: theme)
                disclaimerSection(theme: theme)
            }
            .scrollContentBackground(.hidden)
            .background(theme.bg)
            .navigationTitle("Settings")
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
        .onAppear {
            viewModel.loadFromPrefs(prefs)
        }
    }

    @ViewBuilder
    private func notificationsSection(theme: AppTheme) -> some View {
        Section {
            Toggle(isOn: $viewModel.notificationEnabled) {
                Label("Daily Quote", systemImage: "bell.fill")
                    .foregroundStyle(theme.text)
            }
            .tint(theme.accent)
            .onChange(of: viewModel.notificationEnabled) {
                Task {
                    await viewModel.toggleNotifications(
                        prefs: prefs,
                        modelContext: modelContext
                    )
                }
            }

            if viewModel.notificationEnabled {
                DatePicker(
                    "Time",
                    selection: $viewModel.notificationTime,
                    displayedComponents: .hourAndMinute
                )
                .foregroundStyle(theme.text)
                .tint(theme.accent)
                .onChange(of: viewModel.notificationTime) {
                    Task {
                        await viewModel.updateNotificationTime(
                            prefs: prefs,
                            modelContext: modelContext
                        )
                    }
                }
            }
        } header: {
            Text("Notifications")
                .foregroundStyle(theme.subtle)
        }
        .listRowBackground(theme.card)
    }

    @ViewBuilder
    private func aboutSection(theme: AppTheme) -> some View {
        Section {
            HStack {
                Text("Version")
                    .foregroundStyle(theme.text)
                Spacer()
                Text(appVersion)
                    .foregroundStyle(theme.subtle)
            }

            Link(destination: URL(string: "https://en.uesp.net/wiki/Skyrim:Skyrim")!) {
                Label("Quote Sources (UESP Wiki)", systemImage: "link")
                    .foregroundStyle(theme.accent)
            }
        } header: {
            Text("About")
                .foregroundStyle(theme.subtle)
        }
        .listRowBackground(theme.card)
    }

    @ViewBuilder
    private func disclaimerSection(theme: AppTheme) -> some View {
        Section {
            Text("Shouts of Skyrim is a fan-made project and is not affiliated with, endorsed by, or connected to Bethesda Softworks, ZeniMax Media, or Microsoft. The Elder Scrolls, Skyrim, and all related content are trademarks of their respective owners.")
                .font(.uiText(12))
                .foregroundStyle(theme.subtle)
        } header: {
            Text("Legal")
                .foregroundStyle(theme.subtle)
        }
        .listRowBackground(theme.card)
    }

    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }
}
