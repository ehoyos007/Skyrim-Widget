import Foundation
import SwiftData

@Model
class Quote {
    @Attribute(.unique) var id: UUID
    var text: String
    var npcName: String
    var npcRace: String
    var location: String
    var hold: String
    var category: String
    var questContext: String?
    var isFavorite: Bool

    init(
        text: String,
        npcName: String,
        npcRace: String,
        location: String,
        hold: String,
        category: String,
        questContext: String? = nil,
        isFavorite: Bool = false
    ) {
        self.id = UUID()
        self.text = text
        self.npcName = npcName
        self.npcRace = npcRace
        self.location = location
        self.hold = hold
        self.category = category
        self.questContext = questContext
        self.isFavorite = isFavorite
    }

    static let placeholder = Quote(
        text: "I used to be an adventurer like you, then I took an arrow in the knee.",
        npcName: "Guard",
        npcRace: "Nord",
        location: "Whiterun",
        hold: "Whiterun Hold",
        category: "Guard"
    )
}
