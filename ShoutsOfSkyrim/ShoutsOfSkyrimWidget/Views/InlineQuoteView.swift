import SwiftUI
import WidgetKit

struct InlineQuoteView: View {
    var entry: QuoteEntry

    var body: some View {
        Text(entry.quote.text)
            .containerBackground(.clear, for: .widget)
            .accessibilityLabel(entry.quote.text)
    }
}
