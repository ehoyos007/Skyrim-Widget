import SwiftUI

struct QuoteTextView: View {
    let text: String
    let theme: AppTheme
    var textStyle: Font.TextStyle = .title3

    var body: some View {
        Text("\u{201C}\(text)\u{201D}")
            .font(.quoteSerif(textStyle))
            .italic()
            .foregroundStyle(theme.text)
            .multilineTextAlignment(.leading)
            .lineSpacing(4)
    }
}
