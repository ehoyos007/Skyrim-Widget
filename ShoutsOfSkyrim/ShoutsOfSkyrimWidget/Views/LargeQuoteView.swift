import SwiftUI
import WidgetKit

struct LargeQuoteView: View {
    var entry: QuoteEntry

    private let theme = AppTheme.whiterun

    private var categoryEnum: QuoteCategory? {
        QuoteCategory(rawValue: entry.quote.category)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Category icon header
            if let cat = categoryEnum {
                HStack(spacing: 6) {
                    Image(systemName: cat.sfSymbol)
                        .font(.caption)
                        .foregroundStyle(theme.accent)
                    Text(cat.displayName.uppercased())
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundStyle(theme.subtle)
                        .tracking(1.5)
                }
            }

            Spacer(minLength: 0)

            // Quote text -- lore-style layout
            Text(entry.quote.text)
                .font(.quoteSerif(18))
                .foregroundStyle(theme.text)
                .lineLimit(6)
                .minimumScaleFactor(0.75)

            Spacer(minLength: 0)

            // Divider line
            Rectangle()
                .fill(theme.accent.opacity(0.3))
                .frame(height: 1)

            // Attribution
            VStack(alignment: .leading, spacing: 4) {
                Text("-- \(entry.quote.npcName)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(theme.accent)

                HStack(spacing: 12) {
                    Label(entry.quote.location, systemImage: "mappin")
                    Label(entry.quote.hold, systemImage: "map")
                }
                .font(.caption2)
                .foregroundStyle(theme.subtle)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .widgetURL(URL(string: "shoutsOfSkyrim://quote/\(entry.quote.id)"))
        .containerBackground(for: .widget) {
            theme.bg
        }
    }
}
