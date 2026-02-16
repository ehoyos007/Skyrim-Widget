# TASKS.md — Shouts of Skyrim

## Status Legend
- [ ] Not started
- [~] In progress
- [x] Complete

---

## Phase 0: Planning & Setup
- [x] Initialize project documentation (CONTEXT, TASKS, TEST_LOG, PROGRESS)
- [x] Conduct detailed interview — finalize all technical decisions
- [x] Initialize git repo with .gitignore
- [x] Create PLAN.md with full architecture blueprint
- [x] Scaffold Xcode project (main app + widget extension targets)
- [x] Configure App Groups for widget ↔ app data sharing
- [x] Set up SwiftData schema (Quote, UserPrefs models)

## Phase 1: Data & Core Infrastructure
- [x] Build SwiftData models (Quote, UserPrefs)
- [x] Create quote seed data file (JSON → SwiftData import)
- [x] Compile 300+ Skyrim NPC quotes with full metadata (304 quotes)
- [x] Build theme system (4 themes: Whiterun, Winterhold, Solstheim, Sovngarde)
- [x] Implement App Groups shared data layer (ModelContainerConfig)

## Phase 2: Widget System
- [x] Small (2x2) Home Screen widget
- [x] Medium (4x2) Home Screen widget
- [x] Large (4x4) Home Screen widget with lore-style layout
- [x] Lock Screen widgets (circular + rectangular + inline)
- [x] StandBy mode widget (containerBackground support)
- [x] TimelineProvider with random rotation (4-hour refresh, 6 entries)
- [x] AppIntentConfiguration for category filter
- [x] Deep link: widget tap → quote detail view

## Phase 3: Companion App
- [x] Tab bar navigation (Home, Quotes, Themes, Settings)
- [x] Home tab: widget preview + stats
- [x] Quotes tab: swipeable card browser (swipe right = favorite, left = skip)
- [x] Quote detail view (quote + NPC + location + quest)
- [x] Themes tab: theme selector (4 themes)
- [x] Settings tab: notification toggle, time picker, about/disclaimer
- [x] Favorites system (SwiftData persistence)
- [x] Category filter chips on quote browser

## Phase 4: Notifications
- [x] Local notification scheduling (daily featured quote)
- [x] User-configurable notification time
- [x] Notification tap → open quote detail (via deep link)

## Phase 4.5: Project Integration
- [x] Rewrite project.pbxproj with all 38 files and correct target membership
- [x] Create Xcode scheme
- [x] Fix iOS 17 compatibility issues (TabBarView)
- [x] Achieve first successful build (both targets)
- [x] Push to GitHub
- [x] Add widget NSExtension Info.plist (fix simulator install)
- [x] Register `shoutsOfSkyrim://` URL scheme (fix deep links)
- [x] Fix Home tab race condition (use @Query instead of manual fetch)
- [x] Full simulator smoke test — all 4 tabs verified

## Phase 5: Polish & Accessibility
- [x] Custom SF Symbol icons for NPC races/categories
- [x] Dynamic Type support
- [x] VoiceOver labels on all elements
- [x] Minimum 4.5:1 contrast ratio across themes
- [x] Reduce Motion support
- [ ] Performance profiling (widget memory, battery)

## Phase 6: App Store Preparation
- [ ] App Store screenshots (all device sizes)
- [ ] App description and keywords (ASO)
- [ ] Privacy policy
- [ ] Fan-project disclaimer
- [ ] TestFlight beta distribution
- [ ] App Store submission

---

## Deferred to v1.1
- [ ] Premium IAP ($2.99 unlock) via StoreKit 2
- [ ] Quote pack expansions ($0.99 each)
- [ ] Tip jar
- [ ] Share quote as styled image card
- [ ] NPC profile cards with lore
- [ ] Gamified unlock system
- [ ] Quote history log

## Parking Lot
- Audio playback of NPC voice lines (significant IP risk)
- Bethesda community program partnership
- iPad / macOS widget support
- User-submitted quote pipeline
