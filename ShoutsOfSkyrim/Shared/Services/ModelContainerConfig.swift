import Foundation
import SwiftData

struct ModelContainerConfig {
    static let appGroupID = "group.com.arkaidev.shoutsOfSkyrim"

    static func makeContainer() throws -> ModelContainer {
        let schema = Schema([Quote.self, UserPrefs.self])
        let config = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false,
            groupContainer: .identifier(appGroupID)
        )
        return try ModelContainer(for: schema, configurations: [config])
    }
}
