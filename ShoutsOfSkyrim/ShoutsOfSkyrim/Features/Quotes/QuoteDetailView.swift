import SwiftUI
import SwiftData

struct QuoteDetailView: View {
    let quote: Quote
    @Environment(\.modelContext) private var modelContext
    @Environment(ThemeManager.self) private var themeManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        let theme = themeManager.current

        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                CategoryBadgeView(category: quote.category, theme: theme)

                QuoteTextView(text: quote.text, theme: theme, textStyle: .title2)

                NPCBadgeView(name: quote.npcName, race: quote.npcRace, theme: theme)

                VStack(alignment: .leading, spacing: 8) {
                    Label(quote.location, systemImage: "mappin")
                    Label(quote.hold, systemImage: "map")
                }
                .font(.uiText(.subheadline))
                .foregroundStyle(theme.subtle)

                if let quest = quote.questContext {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Quest")
                            .font(.uiText(.caption, weight: .medium))
                            .foregroundStyle(theme.subtle)
                        Text(quest)
                            .font(.uiText(.subheadline))
                            .foregroundStyle(theme.text)
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(theme.card)
                    )
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Quest: \(quest)")
                }

                Spacer(minLength: 20)

                HStack(spacing: 16) {
                    Button {
                        quote.isFavorite.toggle()
                        try? modelContext.save()
                    } label: {
                        Label(
                            quote.isFavorite ? "Favorited" : "Favorite",
                            systemImage: quote.isFavorite ? "heart.fill" : "heart"
                        )
                        .font(.uiText(.callout, weight: .semibold))
                        .foregroundStyle(quote.isFavorite ? Color.red : theme.accent)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(theme.card)
                        )
                    }
                    .accessibilityLabel(quote.isFavorite ? "Remove from favorites" : "Add to favorites")
                    .accessibilityAddTraits(.isButton)
                }
            }
            .padding(20)
        }
        .background(theme.bg)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}
