# App Review Notes — Shouts of Skyrim

## What This App Is
Shouts of Skyrim is a fan-made quote reference and widget app for The Elder Scrolls V: Skyrim. It delivers memorable NPC dialogue through iOS widgets and a companion browsing experience.

## Fan-Project Disclaimer
This app is an independent fan project. It is **not affiliated with, endorsed by, or connected to** Bethesda Softworks, ZeniMax Media, Microsoft, or any of their subsidiaries.

- The Elder Scrolls, Skyrim, and all related names and marks are trademarks of ZeniMax Media Inc.
- No copyrighted assets (images, audio, video, music, textures) from the game are used
- All quotes are text-only dialogue lines sourced from publicly available game transcript documentation (UESP Wiki)
- The app's visual design, themes, icons, and UI are entirely original
- A clear disclaimer is displayed in the app's Settings screen (Legal section)

## Content Details
- 304 NPC quotes with attributed speaker names, races, locations, and quest context
- Quotes are common game dialogue that has been widely documented and discussed publicly since the game's release in 2011
- No story spoilers are presented without context

## Privacy & Data
- Zero data collection — no accounts, no analytics, no network requests
- No third-party SDKs of any kind
- All data (favorites, preferences) stored locally via SwiftData
- Notifications are local only (UNCalendarNotificationTrigger) — no push server

## Widget Functionality
The app provides widgets across all supported families:
- Home Screen: systemSmall, systemMedium, systemLarge
- Lock Screen: accessoryCircular, accessoryRectangular, accessoryInline
- StandBy: reuses systemSmall automatically
- Widgets use AppIntentConfiguration for category filtering
- Quotes rotate every 4 hours (6 timeline entries)

## How to Test
1. Install the app — 304 quotes seed automatically on first launch
2. Add a widget: long-press Home Screen > "+" > search "Shouts of Skyrim"
3. Browse quotes in the Quotes tab (swipe cards left/right)
4. Change themes in the Themes tab
5. Enable daily notifications in Settings

## Technical
- Minimum deployment: iOS 17.0
- Built with: SwiftUI, WidgetKit, SwiftData, AppIntents, UserNotifications
- Zero third-party dependencies
- App Group: group.com.arkaidev.shoutsOfSkyrim
