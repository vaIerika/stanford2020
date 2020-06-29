//
//  CardView.swift
//  Memorize
//
//  Created by Valerie 👩🏼‍💻 on 19/06/2020.
//

import SwiftUI

struct CardView: View {
    var card: MemoryGame<String>.Card
    var themeColor: Color
    
    var body: some View {
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
    }
    
    @State private var animatedBonusRemaining: Double = 0
    
    private func startBonusTimeAnimation() {
        animatedBonusRemaining = card.bonusRemaining
        withAnimation(.linear(duration: card.bonusTimeRemaining)) {
            animatedBonusRemaining = 0
        }
    }
    
    /// ViewBuilder returns EmptyView(), if the condition fails
    @ViewBuilder
    private func body(for size: CGSize) -> some View {  /// Trick to avoid <self> inside GeometryReader or ForEach
        if card.isFaceUp || !card.isMatched {
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle.degrees(0-90),
                            endAngle: Angle.degrees(-animatedBonusRemaining * 360 - 90),
                            clockwise: true)
                            .fill(themeColor)
                            .onAppear {
                                startBonusTimeAnimation()
                            }
                    } else {
                        Pie(startAngle: Angle.degrees(0 - 90),
                            endAngle: Angle.degrees(-card.bonusRemaining * 360 - 90),
                            clockwise: true)
                            .fill(themeColor)
                    }
                }
                .padding(7)
                .opacity(themeOpacityForPie)

                Text(card.content)
                    .font(.system(size: fontSize(for: size)))
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(card.isMatched ?
                                Animation.linear(duration: 1).repeatForever(autoreverses: false)
                                : .default)
            }
            .cardify(isFaceUp: card.isFaceUp, themeColor: themeColor)
            .transition(AnyTransition.scale)
        }
    }
    
    // MARK: - Drawing Contraits    
    private func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.65
    }
    private let themeOpacityForPie = 0.3
}


// TODO: Figure out how to make preview work

/*
struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: MemoryGame<String>.Card(content: "", id: 2), themeColor: Color.red)
    }
}
*/

/*
struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        let cards = game.cards

        return CardView(card: cards[0],
                 themeColor: Color.red)
    }
}
*/


