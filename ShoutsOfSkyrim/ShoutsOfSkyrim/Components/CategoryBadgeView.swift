import SwiftUI

struct CategoryBadgeView: View {
    let category: String
    let theme: AppTheme

    private var quoteCategory: QuoteCategory? {
        QuoteCategory(rawValue: category)
    }

    var body: some View {
        HStack(spacing: 4) {
            if let cat = quoteCategory {
                Image(systemName: cat.sfSymbol)
                    .font(.uiText(10))
            }
            Text(category)
                .font(.uiText(11, weight: .medium))
        }
        .foregroundStyle(theme.accent)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            Capsule()
                .fill(theme.accent.opacity(0.15))
        )
    }
}
