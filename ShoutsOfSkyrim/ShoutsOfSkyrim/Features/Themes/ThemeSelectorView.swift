import SwiftUI
import SwiftData

struct ThemeSelectorView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(ThemeManager.self) private var themeManager
    @Query private var allPrefs: [UserPrefs]
    @State private var viewModel = ThemesViewModel()

    private var prefs: UserPrefs? { allPrefs.first }

    var body: some View {
        let theme = themeManager.current

        NavigationStack {
            ScrollView {
                LazyVGrid(
                    columns: [GridItem(.flexible()), GridItem(.flexible())],
                    spacing: 16
                ) {
                    ForEach(viewModel.themes) { t in
                        themeCard(t, isSelected: t.id == theme.id, currentTheme: theme)
                    }
                }
                .padding()
            }
            .background(theme.bg)
            .navigationTitle("Themes")
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }

    @ViewBuilder
    private func themeCard(_ t: AppTheme, isSelected: Bool, currentTheme: AppTheme) -> some View {
        Button {
            viewModel.selectTheme(t, themeManager: themeManager, prefs: prefs)
        } label: {
            VStack(spacing: 12) {
                // Color swatches
                HStack(spacing: 4) {
                    Circle().fill(t.bg).frame(width: 20, height: 20)
                    Circle().fill(t.card).frame(width: 20, height: 20)
                    Circle().fill(t.accent).frame(width: 20, height: 20)
                    Circle().fill(t.text).frame(width: 20, height: 20)
                }

                // Mini preview
                RoundedRectangle(cornerRadius: 8)
                    .fill(t.bg)
                    .frame(height: 60)
                    .overlay(
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\u{201C}Sample quote...\u{201D}")
                                .font(.quoteSerif(11))
                                .italic()
                                .foregroundStyle(t.text)
                                .lineLimit(2)
                            Text("-- NPC")
                                .font(.uiText(9, weight: .medium))
                                .foregroundStyle(t.accent)
                        }
                        .padding(8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .strokeBorder(t.accent.opacity(0.3), lineWidth: 1)
                    )

                Text(t.name)
                    .font(.uiText(14, weight: .semibold))
                    .foregroundStyle(currentTheme.text)
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(currentTheme.card)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(
                        isSelected ? currentTheme.accent : Color.clear,
                        lineWidth: 2
                    )
            )
        }
    }
}
