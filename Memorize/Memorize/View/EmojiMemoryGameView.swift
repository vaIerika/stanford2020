//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Valerie 👩🏼‍💻 on 30/05/2020.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var themeColor: LinearGradient {
        return LinearGradient(gradient: Gradient(colors: [viewModel.theme.color, viewModel.theme.color.opacity(0.4)]), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(viewModel.theme.name)
                    .font(.largeTitle)
                    .layoutPriority(1)
                Spacer()
                HStack {
                    Spacer()
                    Text("Score")
                    Text("\(viewModel.score)")
                        .foregroundColor(.pink)
                }
            }
            .padding(.horizontal, 5)
            
            Grid(viewModel.cards) { card in
                CardView(card: card, themeColor: self.themeColor)
                    .onTapGesture {
                        self.viewModel.choose(card: card)
                    }
                    .padding(5)
            }
            
            Button(action: {
                self.viewModel.resetGame()
            }) {
                Text("New Game")
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 15)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.pink)
                )
            }
            .padding(.top, 10)
        }
        .padding(.top, 15)
        .padding()
    }
}

struct EmojiMemoryGameView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}
