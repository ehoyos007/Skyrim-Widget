import SwiftUI
import SwiftData

struct QuoteBrowserView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(ThemeManager.self) private var themeManager
    @State private var viewModel = QuotesViewModel()
    @State private var showDetail = false
    @State private var selectedQuote: Quote?
    var deepLinkHandler: DeepLinkHandler

    var body: some View {
        let theme = themeManager.current

        NavigationStack {
            VStack(spacing: 0) {
                categoryFilterBar(theme: theme)
                    .padding(.horizontal)
                    .padding(.top, 8)

                if viewModel.isEmpty {
                    emptyState(theme: theme)
                } else {
                    CardStackView(
                        quotes: viewModel.visibleQuotes,
                        theme: theme,
                        onSwipeRight: {
                            viewModel.favoriteAndAdvance(modelContext: modelContext)
                        },
                        onSwipeLeft: {
                            viewModel.skipAndAdvance()
                        },
                        onTapCard: { quote in
                            selectedQuote = quote
                            showDetail = true
                        }
                    )
                    .padding(20)

                    swipeHints(theme: theme)
                        .padding(.bottom, 8)
                }
            }
            .background(theme.bg)
            .navigationTitle("Quotes")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .navigationDestination(isPresented: $showDetail) {
                if let quote = selectedQuote {
                    QuoteDetailView(quote: quote)
                }
            }
        }
        .onAppear {
            viewModel.loadQuotes(modelContext: modelContext)
            handlePendingDeepLink()
        }
        .onChange(of: deepLinkHandler.pendingQuoteID) {
            handlePendingDeepLink()
        }
    }

    @ViewBuilder
    private func categoryFilterBar(theme: AppTheme) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                filterChip(
                    title: "All",
                    isSelected: viewModel.selectedCategory == nil,
                    theme: theme
                ) {
                    viewModel.selectedCategory = nil
                    viewModel.loadQuotes(modelContext: modelContext)
                }

                ForEach(QuoteCategory.allCases, id: \.rawValue) { category in
                    filterChip(
                        title: category.displayName,
                        icon: category.sfSymbol,
                        isSelected: viewModel.selectedCategory == category,
                        theme: theme
                    ) {
                        viewModel.selectedCategory = category
                        viewModel.loadQuotes(modelContext: modelContext)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func filterChip(
        title: String,
        icon: String? = nil,
        isSelected: Bool,
        theme: AppTheme,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 4) {
                if let icon {
                    Image(systemName: icon)
                        .font(.uiText(10))
                }
                Text(title)
                    .font(.uiText(13, weight: .medium))
            }
            .foregroundStyle(isSelected ? theme.bg : theme.text)
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(
                Capsule()
                    .fill(isSelected ? theme.accent : theme.card)
            )
        }
    }

    @ViewBuilder
    private func swipeHints(theme: AppTheme) -> some View {
        HStack {
            Label("Skip", systemImage: "arrow.left")
                .foregroundStyle(theme.subtle)
            Spacer()
            Label("Favorite", systemImage: "arrow.right")
                .foregroundStyle(theme.subtle)
        }
        .font(.uiText(12))
        .padding(.horizontal, 40)
    }

    @ViewBuilder
    private func emptyState(theme: AppTheme) -> some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "book.closed")
                .font(.system(size: 48))
                .foregroundStyle(theme.subtle)

            Text("No more quotes")
                .font(.uiText(18, weight: .semibold))
                .foregroundStyle(theme.text)

            Text("You've seen all the quotes in this category.")
                .font(.uiText(14))
                .foregroundStyle(theme.subtle)
                .multilineTextAlignment(.center)

            Button {
                viewModel.resetDeck(modelContext: modelContext)
            } label: {
                Text("Reshuffle Deck")
                    .font(.uiText(15, weight: .semibold))
                    .foregroundStyle(theme.bg)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        Capsule().fill(theme.accent)
                    )
            }
            .padding(.top, 8)
            Spacer()
        }
        .padding()
    }

    private func handlePendingDeepLink() {
        guard let quoteID = deepLinkHandler.consumePendingQuoteID() else { return }
        let descriptor = FetchDescriptor<Quote>(
            predicate: #Predicate<Quote> { $0.id == quoteID }
        )
        if let quote = try? modelContext.fetch(descriptor).first {
            selectedQuote = quote
            showDetail = true
        }
    }
}
