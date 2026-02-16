import SwiftUI
import SwiftData

@Observable
class QuotesViewModel {
    var quotes: [Quote] = []
    var selectedCategory: QuoteCategory?
    var currentIndex: Int = 0

    var visibleQuotes: [Quote] {
        let remaining = Array(quotes.dropFirst(currentIndex))
        return Array(remaining.prefix(3))
    }

    var topQuote: Quote? {
        guard currentIndex < quotes.count else { return nil }
        return quotes[currentIndex]
    }

    var isEmpty: Bool {
        currentIndex >= quotes.count
    }

    @MainActor
    func loadQuotes(modelContext: ModelContext) {
        var descriptor = FetchDescriptor<Quote>(
            sortBy: [SortDescriptor(\.npcName)]
        )

        if let category = selectedCategory {
            let categoryValue = category.rawValue
            descriptor.predicate = #Predicate<Quote> { quote in
                quote.category == categoryValue
            }
        }

        quotes = (try? modelContext.fetch(descriptor)) ?? []
        quotes.shuffle()
        currentIndex = 0
    }

    func advanceCard() {
        guard currentIndex < quotes.count else { return }
        currentIndex += 1
    }

    @MainActor
    func toggleFavorite(_ quote: Quote, modelContext: ModelContext) {
        quote.isFavorite.toggle()
        try? modelContext.save()
    }

    @MainActor
    func favoriteAndAdvance(modelContext: ModelContext) {
        if let quote = topQuote {
            quote.isFavorite = true
            try? modelContext.save()
        }
        advanceCard()
    }

    @MainActor
    func skipAndAdvance() {
        advanceCard()
    }

    @MainActor
    func resetDeck(modelContext: ModelContext) {
        loadQuotes(modelContext: modelContext)
    }
}
