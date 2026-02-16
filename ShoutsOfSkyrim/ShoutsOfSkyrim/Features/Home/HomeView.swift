import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(ThemeManager.self) private var themeManager
    @Query private var allQuotes: [Quote]
    @Query(filter: #Predicate<Quote> { $0.isFavorite }) private var favoriteQuotes: [Quote]

    var body: some View {
        let theme = themeManager.current

        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    widgetPreview(theme: theme)
                    statsSection(theme: theme)
                    addWidgetGuide(theme: theme)
                }
                .padding()
            }
            .background(theme.bg)
            .navigationTitle("Shouts of Skyrim")
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }

    @ViewBuilder
    private func widgetPreview(theme: AppTheme) -> some View {
        VStack(spacing: 12) {
            Text("Current Widget")
                .font(.uiText(13, weight: .medium))
                .foregroundStyle(theme.subtle)
                .frame(maxWidth: .infinity, alignment: .leading)

            RoundedRectangle(cornerRadius: 20)
                .fill(theme.card)
                .frame(height: 160)
                .overlay(
                    VStack(spacing: 8) {
                        QuoteTextView(
                            text: "I used to be an adventurer like you...",
                            theme: theme,
                            size: 16
                        )
                        .lineLimit(3)

                        HStack {
                            Text("-- Guard")
                                .font(.uiText(13, weight: .medium))
                                .foregroundStyle(theme.accent)
                            Spacer()
                        }
                    }
                    .padding(16)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(theme.accent.opacity(0.2), lineWidth: 1)
                )
        }
    }

    @ViewBuilder
    private func statsSection(theme: AppTheme) -> some View {
        HStack(spacing: 16) {
            statCard(
                title: "Total Quotes",
                value: "\(allQuotes.count)",
                icon: "book.fill",
                theme: theme
            )
            statCard(
                title: "Favorites",
                value: "\(favoriteQuotes.count)",
                icon: "heart.fill",
                theme: theme
            )
        }
    }

    @ViewBuilder
    private func statCard(title: String, value: String, icon: String, theme: AppTheme) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.uiText(20))
                .foregroundStyle(theme.accent)

            Text(value)
                .font(.uiText(28, weight: .bold))
                .foregroundStyle(theme.text)

            Text(title)
                .font(.uiText(12, weight: .medium))
                .foregroundStyle(theme.subtle)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(theme.card)
        )
    }

    @ViewBuilder
    private func addWidgetGuide(theme: AppTheme) -> some View {
        VStack(spacing: 12) {
            Text("Add a Widget")
                .font(.uiText(16, weight: .semibold))
                .foregroundStyle(theme.text)

            VStack(alignment: .leading, spacing: 8) {
                guideStep("1. Long-press your Home Screen", theme: theme)
                guideStep("2. Tap the + button in the top corner", theme: theme)
                guideStep("3. Search for \"Shouts of Skyrim\"", theme: theme)
                guideStep("4. Choose a widget size and tap Add", theme: theme)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(theme.card)
        )
    }

    @ViewBuilder
    private func guideStep(_ text: String, theme: AppTheme) -> some View {
        Text(text)
            .font(.uiText(14))
            .foregroundStyle(theme.subtle)
    }
}
