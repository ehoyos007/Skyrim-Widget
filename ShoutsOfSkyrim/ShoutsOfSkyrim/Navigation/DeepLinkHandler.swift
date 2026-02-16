import SwiftUI

@Observable
class DeepLinkHandler {
    var pendingQuoteID: UUID?
    var selectedTab: AppTab = .home

    func handle(_ url: URL) {
        guard url.scheme == "shoutsOfSkyrim",
              url.host == "quote",
              let idString = url.pathComponents.last,
              let uuid = UUID(uuidString: idString) else {
            return
        }

        selectedTab = .quotes
        pendingQuoteID = uuid
    }

    func consumePendingQuoteID() -> UUID? {
        defer { pendingQuoteID = nil }
        return pendingQuoteID
    }
}

enum AppTab: Hashable {
    case home
    case quotes
    case themes
    case settings
}
