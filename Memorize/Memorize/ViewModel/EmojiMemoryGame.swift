//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Valerie 👩🏼‍💻 on 31/05/2020.
//

import Foundation
import SwiftUI

class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
    
    // MARK: - Access to the Model
    @Published private var model: MemoryGame<String>
    
    var theme: Theme

    var cards: [Card] {
        model.cards
    }
    
    var score: Int {
        model.score
    }
    
    init() {
        let theme = Theme.themes.randomElement()!
        self.theme = theme
        model = EmojiMemoryGame.createMemoryGame(with: theme)
    }
    
    private static func createMemoryGame(with theme: Theme) -> MemoryGame<String> {
        let emojis = theme.emojis.shuffled()
        
        // MARK: - Assignment 1 & 2.
        /// Random number of pairs
        // let numberOfPairs = theme.cardsNumber ?? Int.random(in: 2...emojis.count)
        
        // MARK: - Assignment 5.
        /// Each theme has its specific number of cards
        let numberOfPairs = theme.cardsNumber
        
        /// JSON representation of the theme
        print("json = \(theme.json?.utf8 ?? "nil")")
        
        
        return MemoryGame<String>(numberOfPairsOfCards: numberOfPairs) { pairIndex in
            return emojis[pairIndex]
        }
    }
        
    // MARK: - Intent(s)
    func choose(card: Card) {
        model.choose(card: card)
    }
    
    func resetGame() {
        theme = Theme.themes.randomElement()!
        model = EmojiMemoryGame.createMemoryGame(with: theme)
    }
}
