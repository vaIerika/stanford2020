//
//  ClassicSetGame.swift
//  SetGame
//
//  Created by Valerie 👩🏼‍💻 on 29/06/2020.
//

import Foundation

class ClassicSetGame: ObservableObject {
    @Published private var game: GameSet<GeometricCard>
    
    init(cards: [GeometricCard]) {
        game = GameSet(cards: cards)
        print("Init ViewModel: \(game.deck.count) and \(game.cardsInGame.count)")
    }
    
    // MARK: - Access to the Model
    var deck: [GeometricCard] {
        game.deck
    }
    
    var discardPile: [GeometricCard] {
        game.discardPile
    }
    
    var cardsInGame: [GeometricCard] {
        game.cardsInGame
    }
    
    var score: Int {
        game.score
    }
    
    // MARK: - Intents
    func dealCards() {
        game.dealCards()
    }
    
    func dealInitialCards() {
        game.dealCards(initialNumberOfCards)
    }
    
    func choose(card: GeometricCard) {
        game.choose(card: card)
    }
    
    func restart() {
         let cards = GeometricCard.generateAll()
         game = GameSet(cards: cards)
         dealInitialCards()
    }
    
    // MARK: - Constraints
    private let initialNumberOfCards = 12
}
