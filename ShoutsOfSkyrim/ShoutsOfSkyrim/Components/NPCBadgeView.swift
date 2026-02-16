import SwiftUI

struct NPCBadgeView: View {
    let name: String
    let race: String
    let theme: AppTheme

    var body: some View {
        HStack(spacing: 8) {
            Text(name)
                .font(.uiText(16, weight: .semibold))
                .foregroundStyle(theme.accent)

            Text(race)
                .font(.uiText(12, weight: .medium))
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
    }
}
