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
- [ ] Scaffold Xcode project (main app + widget extension targets)
- [ ] Configure App Groups for widget ↔ app data sharing
- [ ] Set up SwiftData schema (Quote, UserPrefs models)

## Phase 1: Data & Core Infrastructure
- [ ] Build SwiftData models (Quote, UserPrefs)
- [ ] Create quote seed data file (JSON → SwiftData import)
- [ ] Compile 300+ Skyrim NPC quotes with full metadata
- [ ] Build theme system (4 themes: Whiterun, Winterhold, Solstheim, Sovngarde)
- [ ] Implement App Groups shared data layer

## Phase 2: Widget System
- [ ] Small (2x2) Home Screen widget
- [ ] Medium (4x2) Home Screen widget
- [ ] Large (4x4) Home Screen widget with NPC silhouette
- [ ] Lock Screen widgets (circular + rectangular)
- [ ] StandBy mode widget
- [ ] TimelineProvider with random rotation (4-hour refresh)
- [ ] AppIntentConfiguration for category filter
- [ ] Deep link: widget tap → quote detail view

## Phase 3: Companion App
- [ ] Tab bar navigation (Home, Quotes, Themes, Settings)
- [ ] Home tab: widget preview + stats
- [ ] Quotes tab: swipeable card browser (swipe right = favorite, left = skip)
- [ ] Quote detail view (quote + NPC + location + quest)
- [ ] Themes tab: theme selector (4 themes)
- [ ] Settings tab: refresh interval, display mode, notification toggle
- [ ] Favorites system (SwiftData persistence)
- [ ] Search and filter by NPC, hold, category

## Phase 4: Notifications
- [ ] Local notification scheduling (daily featured quote)
- [ ] User-configurable notification time
- [ ] Notification tap → open quote detail

## Phase 5: Polish & Accessibility
- [ ] Custom SF Symbol icons for NPC races/categories
- [ ] Dynamic Type support
- [ ] VoiceOver labels on all elements
- [ ] Minimum 4.5:1 contrast ratio across themes
- [ ] Reduce Motion support
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
