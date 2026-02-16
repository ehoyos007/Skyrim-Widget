import AppIntents

enum QuoteCategory: String, CaseIterable, Codable {
    case guard_ = "Guard"
    case companion = "Companion"
    case daedric = "Daedric"
    case dragon = "Dragon"
    case citizen = "Citizen"
    case jarl = "Jarl"
    case merchant = "Merchant"
    case mage = "Mage"
    case thief = "Thief"
    case warrior = "Warrior"

    var displayName: String { rawValue }

    var sfSymbol: String {
        switch self {
        case .guard_: return "shield.fill"
        case .companion: return "person.2.fill"
        case .daedric: return "flame.fill"
        case .dragon: return "wind"
        case .citizen: return "house.fill"
        case .jarl: return "crown.fill"
        case .merchant: return "bag.fill"
        case .mage: return "sparkles"
        case .thief: return "eye.slash.fill"
        case .warrior: return "bolt.shield.fill"
        }
    }
}

// MARK: - AppEnum conformance for WidgetKit configuration

enum QuoteCategoryAppEnum: String, AppEnum {
    case all = "All"
    case guard_ = "Guard"
    case companion = "Companion"
    case daedric = "Daedric"
    case dragon = "Dragon"
    case citizen = "Citizen"
    case jarl = "Jarl"
    case merchant = "Merchant"
    case mage = "Mage"
    case thief = "Thief"
    case warrior = "Warrior"

    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        "Quote Category"
    }

    static var caseDisplayRepresentations: [QuoteCategoryAppEnum: DisplayRepresentation] {
        [
            .all: "All Categories",
            .guard_: "Guard",
            .companion: "Companion",
            .daedric: "Daedric",
            .dragon: "Dragon",
            .citizen: "Citizen",
            .jarl: "Jarl",
            .merchant: "Merchant",
            .mage: "Mage",
            .thief: "Thief",
            .warrior: "Warrior",
        ]
    }

    /// Convert to the internal QuoteCategory (returns nil for `.all`)
    var toQuoteCategory: QuoteCategory? {
        switch self {
        case .all: return nil
        case .guard_: return .guard_
        case .companion: return .companion
        case .daedric: return .daedric
        case .dragon: return .dragon
        case .citizen: return .citizen
        case .jarl: return .jarl
        case .merchant: return .merchant
        case .mage: return .mage
        case .thief: return .thief
        case .warrior: return .warrior
        }
    }
}
