import SwiftUI
import SwiftData

@Observable
class HomeViewModel {
    var totalQuotes: Int = 0
    var favoriteCount: Int = 0

    @MainActor
    func loadStats(modelContext: ModelContext) {
        let allDescriptor = FetchDescriptor<Quote>()
        totalQuotes = (try? modelContext.fetchCount(allDescriptor)) ?? 0

        var favDescriptor = FetchDescriptor<Quote>()
        favDescriptor.predicate = #Predicate<Quote> { $0.isFavorite }
        favoriteCount = (try? modelContext.fetchCount(favDescriptor)) ?? 0
    }
}
