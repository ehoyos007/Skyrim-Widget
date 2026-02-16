import SwiftUI
import SwiftData
import UserNotifications

@main
struct ShoutsOfSkyrimApp: App {
    @Environment(\.scenePhase) private var scenePhase

    let modelContainer: ModelContainer

    @State private var themeManager = ThemeManager()
    @State private var deepLinkHandler = DeepLinkHandler()
    @State private var notificationDelegate: NotificationDelegate?

    init() {
        do {
            modelContainer = try ModelContainerConfig.makeContainer()
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            TabBarView(deepLinkHandler: deepLinkHandler)
                .environment(themeManager)
                .preferredColorScheme(.dark)
                .onAppear {
                    setupNotificationDelegate()
                }
                .onOpenURL { url in
                    deepLinkHandler.handle(url)
                }
                .task {
                    await seedAndLoadPrefs()
                }
                .onChange(of: scenePhase) { _, newPhase in
                    if newPhase == .active {
                        rescheduleNotificationIfNeeded()
                    }
                }
        }
        .modelContainer(modelContainer)
    }

    @MainActor
    private func seedAndLoadPrefs() async {
        let context = modelContainer.mainContext

        await SeedDataService.seedIfNeeded(modelContext: context)

        let descriptor = FetchDescriptor<UserPrefs>()
        let prefs: UserPrefs
        if let existing = try? context.fetch(descriptor).first {
            prefs = existing
        } else {
            prefs = UserPrefs()
            context.insert(prefs)
            try? context.save()
        }
        themeManager.load(from: prefs)
    }

    private func setupNotificationDelegate() {
        let delegate = NotificationDelegate(deepLinkHandler: deepLinkHandler)
        UNUserNotificationCenter.current().delegate = delegate
        notificationDelegate = delegate
    }

    @MainActor
    private func rescheduleNotificationIfNeeded() {
        let context = modelContainer.mainContext
        let descriptor = FetchDescriptor<UserPrefs>()
        guard let prefs = try? context.fetch(descriptor).first,
              prefs.notificationEnabled else { return }

        Task {
            await NotificationService.shared.scheduleDaily(
                quote: nil,
                hour: prefs.notificationHour,
                minute: prefs.notificationMinute,
                modelContext: context
            )
        }
    }
}
