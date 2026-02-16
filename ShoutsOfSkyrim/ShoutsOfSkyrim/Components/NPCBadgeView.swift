import SwiftUI

struct NPCBadgeView: View {
    let name: String
    let race: String
    let theme: AppTheme

    var body: some View {
        HStack(spacing: 8) {
            Text(name)
                .font(.uiText(.callout, weight: .semibold))
                .foregroundStyle(theme.accent)

            HStack(spacing: 4) {
                Image(systemName: raceIcon)
                    .font(.uiText(.caption2))
                Text(race)
                    .font(.uiText(.caption, weight: .medium))
            }
            .foregroundStyle(theme.subtle)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(
                Capsule()
                    .fill(theme.card)
                    .overlay(
                        Capsule()
                            .strokeBorder(theme.subtle.opacity(0.3), lineWidth: 1)
                    )
            )
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(name), \(race)")
    }

    private var raceIcon: String {
        switch race.lowercased() {
        case "nord": return "snowflake"
        case "imperial": return "building.columns.fill"
        case "breton": return "wand.and.stars"
        case "redguard": return "sun.max.fill"
        case "dunmer", "dark elf": return "moon.fill"
        case "altmer", "high elf": return "star.fill"
        case "bosmer", "wood elf": return "leaf.fill"
        case "khajiit": return "pawprint.fill"
        case "argonian": return "drop.fill"
        case "orc", "orsimer": return "hammer.fill"
        default: return "person.fill"
        }
    }
}
