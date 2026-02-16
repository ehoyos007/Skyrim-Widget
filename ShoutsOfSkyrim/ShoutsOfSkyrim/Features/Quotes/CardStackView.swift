import SwiftUI

struct CardStackView: View {
    let quotes: [Quote]
    let theme: AppTheme
    var onSwipeRight: () -> Void
    var onSwipeLeft: () -> Void
    var onTapCard: (Quote) -> Void

    @State private var dragOffset: CGSize = .zero
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let swipeThreshold: CGFloat = 150

    var body: some View {
        ZStack {
            ForEach(Array(quotes.enumerated().reversed()), id: \.element.id) { index, quote in
                let isTop = index == 0
                let scale = 1.0 - Double(index) * 0.05
                let yOffset = Double(index) * 10

                QuoteCardView(quote: quote, theme: theme) {
                    if isTop {
                        onTapCard(quote)
                    }
                }
                .scaleEffect(isTop ? 1.0 : scale)
                .offset(y: isTop ? 0 : yOffset)
                .offset(x: isTop ? dragOffset.width : 0)
                .rotationEffect(
                    isTop && !reduceMotion ? .degrees(Double(dragOffset.width) / 20) : .zero
                )
                .overlay(
                    Group {
                        if isTop && !reduceMotion {
                            swipeOverlay
                        }
                    }
                )
                .zIndex(Double(quotes.count - index))
                .allowsHitTesting(isTop)
                .gesture(
                    isTop ? dragGesture : nil
                )
                .animation(reduceMotion ? nil : .spring(response: 0.3), value: dragOffset)
                .accessibilityElement(children: .combine)
                .accessibilityHint(isTop ? "Swipe right to favorite, swipe left to skip, or tap to view details" : "")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder
    private var swipeOverlay: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(swipeColor.opacity(swipeOpacity))
            .allowsHitTesting(false)
    }

    private var swipeColor: Color {
        if dragOffset.width > 0 {
            return .green
        } else if dragOffset.width < 0 {
            return .red
        }
        return .clear
    }

    private var swipeOpacity: Double {
        min(abs(dragOffset.width) / swipeThreshold * 0.3, 0.3)
    }

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                dragOffset = value.translation
            }
            .onEnded { value in
                if value.translation.width > swipeThreshold {
                    if reduceMotion {
                        dragOffset = .zero
                        onSwipeRight()
                    } else {
                        withAnimation(.easeOut(duration: 0.3)) {
                            dragOffset = CGSize(width: 500, height: 0)
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            dragOffset = .zero
                            onSwipeRight()
                        }
                    }
                } else if value.translation.width < -swipeThreshold {
                    if reduceMotion {
                        dragOffset = .zero
                        onSwipeLeft()
                    } else {
                        withAnimation(.easeOut(duration: 0.3)) {
                            dragOffset = CGSize(width: -500, height: 0)
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            dragOffset = .zero
                            onSwipeLeft()
                        }
                    }
                } else {
                    if reduceMotion {
                        dragOffset = .zero
                    } else {
                        withAnimation(.spring(response: 0.3)) {
                            dragOffset = .zero
                        }
                    }
                }
            }
    }
}
