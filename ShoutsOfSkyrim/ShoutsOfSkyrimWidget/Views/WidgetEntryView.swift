import SwiftUI
import WidgetKit

struct WidgetEntryView: View {
    @Environment(\.widgetFamily) var family
    var entry: QuoteEntry

    var body: some View {
        switch family {
        case .systemSmall:
            SmallQuoteView(entry: entry)
        case .systemMedium:
            MediumQuoteView(entry: entry)
        case .systemLarge:
            LargeQuoteView(entry: entry)
        case .accessoryCircular:
            CircularQuoteView(entry: entry)
        case .accessoryRectangular:
            RectangularQuoteView(entry: entry)
        case .accessoryInline:
            InlineQuoteView(entry: entry)
        @unknown default:
            SmallQuoteView(entry: entry)
        }
    }
}
