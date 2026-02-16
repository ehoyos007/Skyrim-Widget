import SwiftUI
import WidgetKit

struct MediumQuoteView: View {
    var entry: QuoteEntry

    private let theme = AppTheme.whiterun

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Spacer(minLength: 0)

            Text(entry.quote.text)
                .font(.quoteSerif(15))
                .foregroundStyle(theme.text)
                .lineLimit(3)
                .minimumScaleFactor(0.8)

            Spacer(minLength: 0)

            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("-- \(entry.quote.npcName)")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(theme.accent)

                    Text("\(entry.quote.location), \(entry.quote.hold)")
                        .font(.caption2)
                        .foregroundStyle(theme.subtle)
                }

                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .widgetURL(URL(string: "shoutsOfSkyrim://quote/\(entry.quote.id)"))
        .containerBackground(for: .widget) {
            theme.bg
        }
    }
}
