import SwiftUI
import WidgetKit

struct SmallQuoteView: View {
    @Environment(\.showsWidgetContainerBackground) var showsBackground
    var entry: QuoteEntry

    private let theme = AppTheme.whiterun

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Spacer(minLength: 0)

            Text(entry.quote.text)
                .font(.quoteSerif(14))
                .foregroundStyle(theme.text)
                .lineLimit(4)
                .minimumScaleFactor(0.8)

            Spacer(minLength: 0)

            Text("-- \(entry.quote.npcName)")
                .font(.caption2)
                .fontWeight(.medium)
                .foregroundStyle(theme.accent)
        }
        .padding(showsBackground ? 0 : 4)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .widgetURL(URL(string: "shoutsOfSkyrim://quote/\(entry.quote.id)"))
        .containerBackground(for: .widget) {
            theme.bg
        }
    }
}
