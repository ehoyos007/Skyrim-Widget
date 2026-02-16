import SwiftUI

struct AppTheme: Identifiable, Equatable {
    let id: String
    let name: String
    let bg: Color
    let card: Color
    let accent: Color
    let text: Color
    let subtle: Color
    let glow: Color

    // MARK: - Whiterun Warm
    // Muted golds, warm parchment on dark background
    static let whiterun = AppTheme(
        id: "whiterun",
        name: "Whiterun Warm",
        bg: Color(red: 0.09, green: 0.08, blue: 0.07),
        card: Color(red: 0.15, green: 0.13, blue: 0.10),
        accent: Color(red: 0.80, green: 0.65, blue: 0.30),
        text: Color(red: 0.92, green: 0.87, blue: 0.78),
        subtle: Color(red: 0.58, green: 0.53, blue: 0.45),
        glow: Color(red: 0.80, green: 0.65, blue: 0.30).opacity(0.3)
    )

    // MARK: - Winterhold Frost
    // Icy blues, cold silver on dark
    static let winterhold = AppTheme(
        id: "winterhold",
        name: "Winterhold Frost",
        bg: Color(red: 0.06, green: 0.08, blue: 0.12),
        card: Color(red: 0.10, green: 0.13, blue: 0.18),
        accent: Color(red: 0.45, green: 0.72, blue: 0.90),
        text: Color(red: 0.85, green: 0.90, blue: 0.95),
        subtle: Color(red: 0.50, green: 0.55, blue: 0.62),
        glow: Color(red: 0.45, green: 0.72, blue: 0.90).opacity(0.3)
    )

    // MARK: - Solstheim Dark
    // Deep reds, volcanic on very dark
    static let solstheim = AppTheme(
        id: "solstheim",
        name: "Solstheim Dark",
        bg: Color(red: 0.07, green: 0.05, blue: 0.05),
        card: Color(red: 0.14, green: 0.09, blue: 0.09),
        accent: Color(red: 0.85, green: 0.30, blue: 0.20),
        text: Color(red: 0.90, green: 0.85, blue: 0.82),
        subtle: Color(red: 0.58, green: 0.46, blue: 0.43),
        glow: Color(red: 0.85, green: 0.30, blue: 0.20).opacity(0.3)
    )

    // MARK: - Sovngarde Gold
    // Bright golds, ethereal on dark
    static let sovngarde = AppTheme(
        id: "sovngarde",
        name: "Sovngarde Gold",
        bg: Color(red: 0.08, green: 0.07, blue: 0.10),
        card: Color(red: 0.13, green: 0.11, blue: 0.16),
        accent: Color(red: 0.95, green: 0.80, blue: 0.35),
        text: Color(red: 0.95, green: 0.92, blue: 0.85),
        subtle: Color(red: 0.60, green: 0.55, blue: 0.50),
        glow: Color(red: 0.95, green: 0.80, blue: 0.35).opacity(0.3)
    )

    // MARK: - All Themes

    static let all: [AppTheme] = [.whiterun, .winterhold, .solstheim, .sovngarde]

    static func theme(forKey key: String) -> AppTheme {
        all.first { $0.id == key } ?? .whiterun
    }
}
