//
//  ContentView.swift
//  Memorize
//
//  Created by Valerie 👩🏼‍💻 on 30/05/2020.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    
    // we can here not a model but viewModel
    var viewModel: EmojiMemoryGame
    
    var body: some View {
        HStack {
            ForEach(viewModel.cards) { card in
                CardView(card: card)
                    .onTapGesture {
                        self.viewModel.choose(card: card)
                }
            }
        }
        .padding()
        .foregroundColor(.yellow)
        .font(viewModel.cards.count / 2 > 4 ? .callout : .largeTitle)
//            .font(EmojiMemoryGame.numberOfPairs > 4 ? .callout : .largeTitle)
    }
}


struct CardView: View {
    var card: MemoryGame<String>.Card
    
    var body: some View {
        ZStack {
            if card.isFaceUp {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 3)
                Text(card.content)
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill()
            }
        }
        .aspectRatio(2/3, contentMode: .fit)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}
