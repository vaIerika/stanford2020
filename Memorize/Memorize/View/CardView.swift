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
    
    /// ViewBuilder returns EmptyView(), if the condition fails
    @ViewBuilder
    private func body(for size: CGSize) -> some View {  /// Trick to avoid <self> inside GeometryReader or ForEach
        if card.isFaceUp || !card.isMatched {
            ZStack {
                Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(110-90))
                    .fill(themeColor).opacity(0.3)
                    .padding(7)
                
                Text(card.content)
                    .font(.system(size: fontSize(for: size)))
            }
            .cardify(isFaceUp: card.isFaceUp, themeColor: themeColor)
        }
    }
    
    // MARK: - Drawing Contraits    
    private func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.65
    }
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


