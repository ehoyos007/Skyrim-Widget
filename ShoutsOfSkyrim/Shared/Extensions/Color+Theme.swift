import SwiftUI

extension Color {
    // Convenience accessors when you have a theme reference
    // These are useful in widget views and shared components

    static func themeBg(_ theme: AppTheme) -> Color { theme.bg }
    static func themeCard(_ theme: AppTheme) -> Color { theme.card }
    static func themeAccent(_ theme: AppTheme) -> Color { theme.accent }
    static func themeText(_ theme: AppTheme) -> Color { theme.text }
    static func themeSubtle(_ theme: AppTheme) -> Color { theme.subtle }
    static func themeGlow(_ theme: AppTheme) -> Color { theme.glow }
}

extension Font {
    /// New York serif for quote text display
    static func quoteSerif(_ size: CGFloat) -> Font {
        .system(size: size, design: .serif)
    }

    /// SF Pro for UI chrome / metadata
    static func uiText(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .default)
    }
}
