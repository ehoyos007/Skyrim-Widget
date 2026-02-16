import SwiftUI
import WidgetKit

struct CircularQuoteView: View {
    var entry: QuoteEntry

    private var categoryEnum: QuoteCategory? {
        QuoteCategory(rawValue: entry.quote.category)
    }

    var body: some View {
        ZStack {
            AccessoryWidgetBackground()

            Image(systemName: categoryEnum?.sfSymbol ?? "scroll.fill")
                .font(.title3)
                .fontWeight(.semibold)
                .widgetAccentable()
        }
        .containerBackground(.clear, for: .widget)
    }
}
