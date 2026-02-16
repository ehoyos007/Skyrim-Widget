# PLAN.md — Shouts of Skyrim Architecture Blueprint

> Full architecture scaffold for a native iOS widget app built with SwiftUI, WidgetKit, and SwiftData.

---

## 1. Project Structure

### Xcode Targets

| Target | Type | Purpose |
|--------|------|---------|
| `ShoutsOfSkyrim` | SwiftUI App | Main companion app (tab bar, quote browser, themes, settings) |
| `ShoutsOfSkyrimWidget` | Widget Extension | All widget sizes (Home, Lock Screen, StandBy) |

A single Widget Extension handles all widget families via `WidgetBundle`. No need for separate targets per size.

### Folder Layout

```
ShoutsOfSkyrim/
├── ShoutsOfSkyrim.xcodeproj
│
├── Shared/                              # Both targets
│   ├── Models/
│   │   ├── Quote.swift                  # @Model
│   │   ├── UserPrefs.swift              # @Model
│   │   └── QuoteCategory.swift          # AppEnum
│   ├── Intents/
│   │   └── QuoteCategoryIntent.swift    # WidgetConfigurationIntent
│   ├── Services/
│   │   └── ModelContainerConfig.swift   # Shared ModelContainer factory
│   └── Extensions/
│       └── Color+Theme.swift            # Theme color definitions
│
├── ShoutsOfSkyrim/                      # Main app target
│   ├── App/
│   │   ├── ShoutsOfSkyrimApp.swift      # @main, onOpenURL, modelContainer
│   │   └── NotificationDelegate.swift
│   ├── Features/
│   │   ├── Home/
│   │   │   ├── HomeView.swift
│   │   │   └── HomeViewModel.swift
│   │   ├── Quotes/
│   │   │   ├── QuoteBrowserView.swift   # Tab with card stack
│   │   │   ├── CardStackView.swift      # Swipeable cards engine
│   │   │   ├── QuoteCardView.swift      # Individual card UI
│   │   │   ├── QuoteDetailView.swift    # Full quote detail
│   │   │   └── QuotesViewModel.swift
│   │   ├── Themes/
│   │   │   ├── ThemeSelectorView.swift
│   │   │   └── ThemesViewModel.swift
│   │   └── Settings/
│   │       ├── SettingsView.swift
│   │       └── SettingsViewModel.swift
│   ├── Components/
│   │   ├── QuoteTextView.swift          # Styled quote text (New York serif)
│   │   └── NPCBadgeView.swift
│   ├── Theme/
│   │   └── AppTheme.swift               # Theme struct + 4 presets
│   ├── Services/
│   │   ├── NotificationService.swift
│   │   ├── QuoteService.swift           # SwiftData fetch/filter
│   │   └── SeedDataService.swift        # JSON → SwiftData import
│   ├── Navigation/
│   │   ├── TabBarView.swift
│   │   └── DeepLinkHandler.swift
│   └── Resources/
│       ├── Assets.xcassets
│       └── quotes_seed.json             # 300+ quotes
│
├── ShoutsOfSkyrimWidget/                # Widget extension target
│   ├── ShoutsOfSkyrimWidgetBundle.swift
│   ├── ShoutsOfSkyrimWidget.swift
│   ├── Provider/
│   │   └── QuoteTimelineProvider.swift  # AppIntentTimelineProvider
│   └── Views/
│       ├── WidgetEntryView.swift        # Family switch router
│       ├── SmallQuoteView.swift
│       ├── MediumQuoteView.swift
│       ├── LargeQuoteView.swift
│       ├── CircularQuoteView.swift
│       ├── RectangularQuoteView.swift
│       └── InlineQuoteView.swift
│
├── ShoutsOfSkyrimTests/
└── ShoutsOfSkyrimUITests/
```

### App Groups

Both targets share data via App Group: `group.com.arkaidev.shoutsOfSkyrim`
- SwiftData container uses `ModelConfiguration(groupContainer: .identifier("group.com.arkaidev.shoutsOfSkyrim"))`
- Widget reads from the shared container (read-only)
- Main app writes and calls `WidgetCenter.shared.reloadAllTimelines()` on data changes

---

## 2. Data Layer (SwiftData)

### Quote Model

```swift
@Model
class Quote {
    @Attribute(.unique) var id: UUID
    var text: String
    var npcName: String
    var npcRace: String
    var location: String
    var hold: String
    var category: String
    var questContext: String?
    var isFavorite: Bool

    init(text: String, npcName: String, npcRace: String,
         location: String, hold: String, category: String,
         questContext: String? = nil, isFavorite: Bool = false) {
        self.id = UUID()
        self.text = text
        self.npcName = npcName
        self.npcRace = npcRace
        self.location = location
        self.hold = hold
        self.category = category
        self.questContext = questContext
        self.isFavorite = isFavorite
    }

    static let placeholder = Quote(
        text: "I used to be an adventurer like you...",
        npcName: "Guard", npcRace: "Nord",
        location: "Whiterun", hold: "Whiterun Hold",
        category: "Guard"
    )
}
```

### UserPrefs Model

```swift
@Model
class UserPrefs {
    var selectedTheme: String      // "whiterun", "winterhold", etc.
    var activeCategories: [String] // ["Guard", "Companion", ...]
    var notificationEnabled: Bool
    var notificationHour: Int      // 0-23
    var notificationMinute: Int    // 0-59

    init() {
        self.selectedTheme = "whiterun"
        self.activeCategories = QuoteCategory.allCases.map(\.rawValue)
        self.notificationEnabled = false
        self.notificationHour = 9
        self.notificationMinute = 0
    }
}
```

### Shared Container Factory

```swift
struct ModelContainerConfig {
    static let appGroupID = "group.com.arkaidev.shoutsOfSkyrim"

    static func makeContainer() throws -> ModelContainer {
        let schema = Schema([Quote.self, UserPrefs.self])
        let config = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false,
            groupContainer: .identifier(appGroupID)
        )
        return try ModelContainer(for: schema, configurations: [config])
    }
}
```

### Seed Data Strategy

- 300+ quotes stored in `quotes_seed.json` bundled with the app
- On first launch, `SeedDataService` checks if the database is empty and imports from JSON
- Each quote has: text, npcName, npcRace, location, hold, category, questContext (optional)

---

## 3. Widget Architecture

### Supported Families

| WidgetFamily | Context | Content |
|-------------|---------|---------|
| `.systemSmall` | Home Screen + **StandBy** | Quote text + NPC name |
| `.systemMedium` | Home Screen | Quote + NPC + location + hold |
| `.systemLarge` | Home Screen | Quote + NPC + location + category icon + lore-style layout |
| `.accessoryCircular` | Lock Screen | Category SF Symbol icon |
| `.accessoryRectangular` | Lock Screen | Short quote + NPC name |
| `.accessoryInline` | Lock Screen | Truncated quote text (single line) |

**StandBy** is not a separate family — iOS automatically reuses `.systemSmall` in landscape StandBy mode. Use `@Environment(\.showsWidgetContainerBackground)` to adapt styling when background is stripped.

### Widget Configuration

Using **AppIntentConfiguration** (modern iOS 17+ pattern, not legacy IntentConfiguration):

```swift
// QuoteCategory — AppEnum with all categories
// QuoteCategoryIntent — WidgetConfigurationIntent with a @Parameter for category
```

Users long-press widget → "Edit Widget" → native iOS picker shows category options.

### Timeline Provider

```swift
struct QuoteTimelineProvider: AppIntentTimelineProvider {
    let modelContainer: ModelContainer = try! ModelContainerConfig.makeContainer()

    func timeline(for config: QuoteCategoryIntent, in context: Context) async -> Timeline<QuoteEntry> {
        var entries: [QuoteEntry] = []
        let now = Date()

        // 6 entries × 4 hours = 24-hour coverage
        for hourOffset in stride(from: 0, through: 20, by: 4) {
            let date = Calendar.current.date(byAdding: .hour, value: hourOffset, to: now)!
            let quote = fetchRandomQuote(category: config.category)
            entries.append(QuoteEntry(date: date, quote: quote))
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}
```

- `.atEnd` policy → WidgetKit requests a new timeline after the last entry
- ~1 timeline reload per day (well within WidgetKit's budget of 40-70/day)

### Deep Linking

- Widget views use `.widgetURL(URL(string: "shoutsOfSkyrim://quote/\(quote.id)")!)`
- App handles via `.onOpenURL { url in handleDeepLink(url) }`
- Parses `shoutsOfSkyrim://quote/<uuid>` and navigates to QuoteDetailView

---

## 4. Theme System

### Theme Struct

```swift
struct AppTheme: Identifiable {
    let id: String          // "whiterun", "winterhold", etc.
    let name: String        // "Whiterun Warm"
    let bg: Color
    let card: Color
    let accent: Color
    let text: Color
    let subtle: Color
    let glow: Color

    static let whiterun = AppTheme(...)
    static let winterhold = AppTheme(...)
    static let solstheim = AppTheme(...)
    static let sovngarde = AppTheme(...)

    static let all: [AppTheme] = [.whiterun, .winterhold, .solstheim, .sovngarde]
}
```

### Theme Propagation

- Store selected theme key in `UserPrefs.selectedTheme` (SwiftData)
- Inject current theme via `@Environment` or `@Observable` ThemeManager
- All views read from the environment — no theme parameters passed manually
- Widget reads theme from shared UserDefaults (via App Group) since the widget reads SwiftData

---

## 5. Companion App Navigation

### Tab Bar Structure

```
TabBarView
├── HomeView          — Widget preview + stats (favorites count, total quotes)
├── QuoteBrowserView  — Swipeable card stack
├── ThemeSelectorView — 4 theme cards with color swatches
└── SettingsView      — Notification toggle, time picker, about/disclaimer
```

### Swipeable Card Stack (Quotes Tab)

**Architecture**: `ZStack` of `QuoteCardView` instances. Only the top card responds to `DragGesture`.

- **Swipe right** → favorite the quote (heart animation)
- **Swipe left** → skip / dismiss
- **Threshold**: 150pt horizontal drag to trigger action
- **Visual feedback**: card rotates (offset.width / 20 degrees) and subtle color overlay (green/red)
- **Performance**: only 3 cards rendered at a time
- **Category filter**: pills/chips at the top to filter the card stack by category

### Quote Detail View

Reached via:
1. Widget tap (deep link)
2. Tapping a card in the browser

Shows: quote text (New York serif, italic), NPC name, race, location, hold, category badge, quest context (if applicable). Favorite toggle button at bottom.

---

## 6. Notifications

### Local Notification Flow

1. **Permission request**: on first toggle of notification setting, call `UNUserNotificationCenter.requestAuthorization()`
2. **Schedule**: `UNCalendarNotificationTrigger` with `repeats: true` at user-chosen hour/minute
3. **Content refresh**: reschedule with a new random quote each time the app becomes active (`scenePhase == .active`)
4. **Tap handling**: `UNUserNotificationCenterDelegate.didReceive` extracts `quoteID` from `userInfo` → navigates to detail
5. **Identifier**: `"dailyQuote"` — single notification, replaced on each reschedule

---

## 7. Implementation Order

Since we're scaffolding the full architecture upfront, here's the build sequence:

### Step 1: Xcode Project Setup
- Create Xcode project with SwiftUI App lifecycle
- Add Widget Extension target
- Configure App Groups on both targets
- Set up folder structure per Section 1

### Step 2: Data Layer
- Define `Quote` and `UserPrefs` SwiftData models
- Create `ModelContainerConfig` shared container
- Build `quotes_seed.json` (start with ~30 quotes for development)
- Implement `SeedDataService` for first-launch import
- Define `QuoteCategory` AppEnum and `QuoteCategoryIntent`

### Step 3: Theme System
- Define `AppTheme` struct with 4 presets
- Create `ThemeManager` (@Observable) for environment injection
- Wire theme to UserPrefs persistence

### Step 4: Widget (All Sizes)
- Implement `QuoteTimelineProvider`
- Build all 6 widget views (small, medium, large, circular, rectangular, inline)
- Add `containerBackground` for StandBy compatibility
- Add `widgetURL` deep linking
- Configure `AppIntentConfiguration` for category filter
- Test on simulator for all sizes

### Step 5: Companion App Shell
- Build `TabBarView` with 4 tabs
- Implement `HomeView` (widget preview + stats)
- Implement `ThemeSelectorView`
- Implement `SettingsView` (placeholder settings)

### Step 6: Quote Browser (Swipeable Cards)
- Build `CardStackView` with DragGesture engine
- Build `QuoteCardView` styled per theme
- Wire swipe-right to favorite, swipe-left to skip
- Add category filter chips
- Build `QuoteDetailView`

### Step 7: Deep Linking
- Register URL scheme `shoutsOfSkyrim://`
- Implement `DeepLinkHandler`
- Handle `onOpenURL` in app entry point
- Test widget tap → quote detail navigation

### Step 8: Notifications
- Implement `NotificationService` (permission, schedule, cancel)
- Wire to Settings toggle + time picker
- Implement notification tap → deep link to quote
- Reschedule on app foreground

### Step 9: Content — Full Quote Database
- Compile 300+ quotes with full metadata
- Validate accuracy against UESP wiki
- Import into `quotes_seed.json`

### Step 10: Polish & Accessibility
- Custom SF Symbol icons for races/categories
- Dynamic Type on all text
- VoiceOver labels
- Contrast audit across all 4 themes
- Reduce Motion support
- Performance profiling

### Step 11: App Store Prep
- Screenshots for all device sizes
- App description, keywords, privacy policy
- Fan-project disclaimer
- TestFlight → App Store submission

---

## 8. Key Technical Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Data persistence | SwiftData | Modern, Swift-native, less boilerplate than Core Data. iOS 17+ target anyway. |
| Widget config API | AppIntentConfiguration | Modern iOS 17+ pattern. Pure Swift, no .intentdefinition files. |
| Theme storage | SwiftData (UserPrefs) | Single source of truth, shared via App Group. |
| Widget ↔ app sync | App Groups + `WidgetCenter.reloadAllTimelines()` | Standard WidgetKit pattern. |
| Notification type | Local (UNCalendarNotificationTrigger) | No server needed. Repeating daily trigger. |
| Quote rotation | Random, 4-hour refresh, 6 entries per timeline | 24-hour coverage, ~1 reload/day. |
| Card swipe | DragGesture + ZStack + offset/rotation | Pure SwiftUI, no external dependencies. |
| Navigation | TabView (bottom tab bar) | Matches demo, standard iOS pattern. |
| Typography | New York (serif) + SF Pro (sans) | System fonts = best Dynamic Type support, zero licensing. |
| Appearance | Always dark | Matches Skyrim aesthetic. All 4 themes are dark variants. |

---

## 9. Dependencies

**None.** The entire app uses first-party Apple frameworks only:

- SwiftUI
- WidgetKit
- SwiftData
- UserNotifications
- AppIntents

No third-party packages. This keeps the project simple, avoids dependency management overhead, and ensures long-term stability.

---

## 10. Risks & Mitigations

| Risk | Mitigation |
|------|-----------|
| SwiftData + App Groups bugs | Test shared container early. Fall back to UserDefaults for widget if needed. |
| WidgetKit timeline not refreshing | Log timeline entries during development. Call `reloadAllTimelines()` on every data change. |
| StandBy rendering issues | Use `showsWidgetContainerBackground` environment value. Test on physical device. |
| Lock Screen widget text truncation | Design for shortest text first. Test with longest quotes. |
| Swipeable cards performance | Only render 3 cards in ZStack. Profile with Instruments. |
| 300+ quote curation | Start with 30 for development. Scale to 300+ in Step 9. |
| IP takedown | Include disclaimer. Have rebrand plan ready. Consult attorney before submission. |
