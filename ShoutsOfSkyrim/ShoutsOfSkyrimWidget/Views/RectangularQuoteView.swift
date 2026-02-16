import SwiftUI
import WidgetKit

struct RectangularQuoteView: View {
    var entry: QuoteEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(entry.quote.text)
                .font(.caption)
                .lineLimit(2)
                .widgetAccentable()

            Text("-- \(entry.quote.npcName)")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .containerBackground(.clear, for: .widget)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(entry.quote.text), by \(entry.quote.npcName)")
    }
}
