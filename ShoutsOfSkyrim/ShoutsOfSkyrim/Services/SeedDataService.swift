import Foundation
import SwiftData

struct SeedDataService {
    /// Import quotes from the bundled JSON file if the database is empty.
    @MainActor
    static func seedIfNeeded(modelContext: ModelContext) async {
        let descriptor = FetchDescriptor<Quote>()
        let existingCount = (try? modelContext.fetchCount(descriptor)) ?? 0

        guard existingCount == 0 else { return }

        guard let url = Bundle.main.url(forResource: "quotes_seed", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            return
        }

        let decoder = JSONDecoder()
        guard let seeds = try? decoder.decode([SeedQuote].self, from: data) else {
            return
        }

        for seed in seeds {
            let quote = Quote(
                text: seed.text,
                npcName: seed.npcName,
                npcRace: seed.npcRace,
                location: seed.location,
                hold: seed.hold,
                category: seed.category,
                questContext: seed.questContext
            )
            modelContext.insert(quote)
        }

        try? modelContext.save()
    }
}

// MARK: - JSON Decoding Shape

private struct SeedQuote: Decodable {
    let text: String
    let npcName: String
    let npcRace: String
    let location: String
    let hold: String
    let category: String
    let questContext: String?
}
