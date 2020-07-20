//
//  CardView.swift
//  SetGame
//
//  Created by Valerie 👩🏼‍💻 on 08/07/2020.
//

import SwiftUI

struct CardView: View {
    var card: GeometricCard
    var untidy = false
    var played = true
    
    @State private var standardOffset: CGSize = CGSize(width: 0, height: 0)
    @State private var randomOffset: CGSize = CGSize(width: CGFloat.random(in: 0...5), height: CGFloat.random(in: 0...5))
    
    var body: some View {
        ZStack {
            if card.isFaceUp {
                Rectangle()
                    .fill(card.isFaceUp ? Color.white : Color.pink)
                    .shadow(color: Color.gray.opacity(0.5), radius: 3, x: 1, y: 2)
                    .overlay(
                        Rectangle()
                            .stroke(lineWidth: lineWidth)
                            .foregroundColor(.green)
                            .opacity(card.isSelected ? 0.8 : 0)
                    )
                    .aspectRatio(cardProportion, contentMode: .fill)
                
                FigureBuilderView(card: card)
                    .padding(padding)
                    .opacity(card.isFaceUp ? 1 : 0.1)
            } else {
                BackCardView()
            }
        }
        .padding(padding)
        .offset(untidy ? randomOffset : standardOffset)
    }
    
    private func offsetRandomizer() -> CGFloat {
        return CGFloat.random(in: 0...5)
    }
    
    // MARK: - Drawing Constraints
    private let cardProportion: CGFloat = 4/7
    private let lineWidth: CGFloat = 3
    private let padding: CGFloat = 5
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        let card = GeometricCard(number: .three, color: .yellow, shading: .striped, figure: .star, isFaceUp: true)
        
        VStack {
            CardView(card: card)
                .frame(width: 200, height: 200)
        }
    }
}
