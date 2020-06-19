//
//  CardView.swift
//  Memorize
//
//  Created by Valerie 👩🏼‍💻 on 19/06/2020.
//

import SwiftUI

struct CardView: View {
    var card: MemoryGame<String>.Card
    var themeColor: LinearGradient
    
    var body: some View {
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
    }
    
    func body(for size: CGSize) -> some View {  /// Trick to avoid <self> inside GeometryReader or ForEach
        ZStack {
            if card.isFaceUp {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(lineWidth: edgeLineWidth)
                    .fill(themeColor)
                Text(card.content)
            } else {
                if !card.isMatched {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(themeColor)
                }
            }
        }
        .font(.system(size: fontSize(for: size)))
        // .aspectRatio(2/3, contentMode: .fit)
    }
    
    // MARK: - Drawing Contraits
    let cornerRadius: CGFloat = 10.0
    let edgeLineWidth: CGFloat = 3
    
    func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.75
    }
}

//
//struct CardView_Previews: PreviewProvider {
//    static var example = EmojiMemoryGame().cards[0]
//    static let example1 = MemoryGame<String>.Card.init(content: "🚀", id: 3)
//
//    static var previews: some View {
//        CardView(card: example1, themeColor: LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing))
//    }
//}
