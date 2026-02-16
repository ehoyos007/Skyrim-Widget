import SwiftUI
import WidgetKit

struct ShoutsOfSkyrimWidget: Widget {
    let kind: String = "ShoutsOfSkyrimWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: QuoteCategoryIntent.self,
            provider: QuoteTimelineProvider()
        ) { entry in
            WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Shouts of Skyrim")
        .description("Display memorable quotes from the NPCs of Skyrim.")
        .supportedFamilies([
            .systemSmall,
            .systemMedium,
            .systemLarge,
            .accessoryCircular,
            .accessoryRectangular,
            .accessoryInline,
        ])
    }
}
