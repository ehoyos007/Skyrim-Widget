import WidgetKit
import SwiftData
import AppIntents

struct QuoteEntry: TimelineEntry {
    let date: Date
    let quote: Quote
    let categorySymbol: String?
}

struct QuoteTimelineProvider: AppIntentTimelineProvider {

    private func makeContainer() -> ModelContainer? {
        try? ModelContainerConfig.makeContainer()
    }

    // MARK: - Placeholder

    func placeholder(in context: Context) -> QuoteEntry {
        QuoteEntry(
            date: .now,
            quote: .placeholder,
            categorySymbol: nil
        )
    }

    // MARK: - Snapshot

    func snapshot(for configuration: QuoteCategoryIntent, in context: Context) async -> QuoteEntry {
        let quote = await fetchRandomQuote(category: configuration.category) ?? .placeholder
        let symbol = configuration.category.toQuoteCategory?.sfSymbol
        return QuoteEntry(date: .now, quote: quote, categorySymbol: symbol)
    }

    // MARK: - Timeline

    func timeline(for configuration: QuoteCategoryIntent, in context: Context) async -> Timeline<QuoteEntry> {
        var entries: [QuoteEntry] = []
        let now = Date()
        let symbol = configuration.category.toQuoteCategory?.sfSymbol

        // 6 entries x 4 hours = 24-hour coverage
        for hourOffset in stride(from: 0, through: 20, by: 4) {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: now)!
            let quote = await fetchRandomQuote(category: configuration.category) ?? .placeholder
            entries.append(QuoteEntry(date: entryDate, quote: quote, categorySymbol: symbol))
        }

        return Timeline(entries: entries, policy: .atEnd)
    }

    // MARK: - Data Fetching

    @MainActor
    private func fetchRandomQuote(category: QuoteCategoryAppEnum) -> Quote? {
        guard let container = makeContainer() else { return nil }
        let context = container.mainContext

        var descriptor = FetchDescriptor<Quote>()

        if let quoteCategory = category.toQuoteCategory {
            let categoryRaw = quoteCategory.rawValue
            descriptor.predicate = #Predicate<Quote> { quote in
                quote.category == categoryRaw
            }
        }

        guard let allQuotes = try? context.fetch(descriptor), !allQuotes.isEmpty else {
            return nil
        }

        return allQuotes.randomElement()
    }
}
