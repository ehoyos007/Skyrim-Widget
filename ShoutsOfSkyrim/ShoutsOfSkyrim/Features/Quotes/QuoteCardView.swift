import SwiftUI

struct QuoteCardView: View {
    let quote: Quote
    let theme: AppTheme
    var onTap: (() -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            CategoryBadgeView(category: quote.category, theme: theme)

            QuoteTextView(text: quote.text, theme: theme, textStyle: .body)

            Spacer(minLength: 0)

            VStack(alignment: .leading, spacing: 8) {
                NPCBadgeView(name: quote.npcName, race: quote.npcRace, theme: theme)

                HStack(spacing: 12) {
                    Label(quote.location, systemImage: "mappin")
                    Label(quote.hold, systemImage: "map")
                }
                .font(.uiText(.caption))
                .foregroundStyle(theme.subtle)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(theme.card)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(theme.accent.opacity(0.15), lineWidth: 1)
        )
        .contentShape(Rectangle())
        .onTapGesture {
            onTap?()
        }
    }
}
