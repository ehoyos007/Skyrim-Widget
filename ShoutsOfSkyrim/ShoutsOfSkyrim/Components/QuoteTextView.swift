import SwiftUI

struct QuoteTextView: View {
    let text: String
    let theme: AppTheme
    var size: CGFloat = 20

    var body: some View {
        Text("\u{201C}\(text)\u{201D}")
            .font(.quoteSerif(size))
            .italic()
            .foregroundStyle(theme.text)
            .multilineTextAlignment(.leading)
            .lineSpacing(4)
    }
}
