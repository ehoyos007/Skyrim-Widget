# CONTEXT.md — Shouts of Skyrim

## Project Overview
**Shouts of Skyrim** is an iOS widget app that delivers memorable Skyrim NPC quotes to users' Home Screen, Lock Screen, StandBy view, and via daily push notifications. Think "Word of the Day" but for iconic Elder Scrolls lines.

## Developer Profile
- **Developer**: Enzo (ARK AI Consulting)
- **Experience**: First iOS app — beginner in Swift/SwiftUI
- **Dev account**: Apple Developer Program enrolled (Xcode 16+)
- **Priority**: Content depth and quote accuracy above all else

## Domain Knowledge
- **Target market**: Skyrim fanbase (60M+ copies sold), iPhone users on iOS 17+
- **Core concept**: Passive quote delivery via WidgetKit — no active user effort required
- **v1.0 Monetization**: Free (all features). IAP deferred to v1.1

## Technical Stack (Confirmed)
| Component | Technology |
|-----------|-----------|
| Language | Swift 5.9+ |
| UI | SwiftUI + WidgetKit |
| Min Target | iOS 17.0 |
| Data | **SwiftData** + App Groups |
| Architecture | MVVM + async/await |
| Analytics | Apple App Store Connect only (no 3rd party) |
| Notifications | Local notifications (daily featured quote) |
| Xcode | 16+ (latest) |
| Distribution | TestFlight → App Store |

## Key Decisions (from Interview — Feb 15, 2026)

### Scope for v1.0
| Feature | Decision |
|---------|----------|
| Widget sizes | **All**: Small, Medium, Large, Lock Screen, StandBy |
| Themes | All 4 free (Whiterun, Winterhold, Solstheim, Sovngarde) |
| Unlock system | No — all quotes unlocked at launch |
| Share cards | Deferred to v1.1 |
| Push notifications | Yes — daily featured quote (local notifications) |
| IAP / monetization | Deferred to v1.1 |
| Analytics | Apple-only (App Store Connect) |

### UX Decisions
| Area | Decision |
|------|----------|
| Quote browser | **Swipeable cards** (Tinder-style: swipe right to favorite, left to skip) |
| Quote detail view | Quote + NPC + location + quest context (clean, focused) |
| Navigation | Bottom tab bar (Home, Quotes, Themes, Settings) |
| Widget config | Category filter only (via AppIntentConfiguration — modern iOS 17+ API) |
| Widget tap action | Deep link to that specific quote's detail view |
| Quote rotation | Random, refresh every 4 hours |
| Appearance | Always dark — each theme has its own dark palette |

### Design Decisions
| Area | Decision |
|------|----------|
| Icons | Custom SF Symbols / minimalist line icons (Skyrim-inspired) |
| Typography | System fonts: New York (serif) for quotes, SF Pro for UI/metadata |
| Color palette | Muted golds, parchment tones, deep charcoals, icy blues |

### Build Strategy
| Area | Decision |
|------|----------|
| Approach | Full architecture scaffold upfront, then fill in features |
| Quote database | AI-assisted compilation of 300+ verified Skyrim quotes (manual review) |
| Git | Initialize repo from the start |

## IP Strategy
- **Decision**: Use direct Skyrim quotes, accept risk
- Bethesda/ZeniMax/Microsoft trademarks acknowledged
- Include fan-project disclaimer in app
- Have rebrand plan ready if DMCA/takedown occurs
- Consult IP attorney before App Store submission

## Data Model
- **Quote**: id, text, npcName, npcRace, location, hold, category, questContext?, isFavorite
- **UserPrefs**: refreshInterval, selectedTheme, activeCategories, displayMode (random only for v1.0)

## Theme Definitions
| Key | Name | Aesthetic |
|-----|------|-----------|
| whiterun | Whiterun Warm | Muted golds, warm parchment |
| winterhold | Winterhold Frost | Icy blues, cold silver |
| solstheim | Solstheim Dark | Deep reds, volcanic dark |
| sovngarde | Sovngarde Gold | Bright golds, ethereal light |

## Existing Assets
- `Shouts_of_Skyrim_PRD.docx` — Full PRD (v1.0 Draft, Feb 15 2026)
- `shouts_of_skyrim_demo.jsx` — Interactive React prototype (visual reference only)

## Glossary
| Term | Meaning |
|------|---------|
| Hold | A region/province in Skyrim (e.g., Whiterun Hold) |
| NPC | Non-Player Character — game characters who speak quotes |
| Shout | A dragon-language power in Skyrim; used metaphorically for the app name |
| StandBy | iOS 17+ feature showing info when iPhone is charging in landscape |
| WidgetKit | Apple's framework for building Home/Lock Screen widgets |
| Timeline | WidgetKit's system for scheduling widget content updates |
| App Groups | iOS mechanism for sharing data between main app and widget extension |
| SwiftData | Apple's modern persistence framework (replacement for Core Data, iOS 17+) |
| AppIntentConfiguration | Modern WidgetKit API (iOS 17+) for user-configurable widget settings, replaces legacy IntentConfiguration |
