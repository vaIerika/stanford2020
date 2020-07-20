//
//  GameSet.swift
//  SetGame
//
//  Created by Valerie 👩🏼‍💻 on 29/06/2020.
//

import Foundation

struct GameSet<Card> where Card: SetCard {
    private(set) var deck: [Card]
    private(set) var cardsInGame: [Card]
    private(set) var discardPile: [Card]
    private(set) var score: Int = 0
    private var selectedCards: [Card] {
        cardsInGame.filter { $0.isSelected }
    }
        
    init(cards: [Card]) {
        deck = cards.map(\.facedDown.unselected).shuffled() // comment <.shuffled()> to test 
        cardsInGame = []
        discardPile = []
        print("init() \(deck.count) cards in deck; \(cardsInGame.count) - in game; \(discardPile.count) - discard pile")
    }
    
    mutating func dealCards(_ quantity: Int = 3) {
        let newCards = deck.prefix(quantity).map(\.facedUp)
        cardsInGame.append(contentsOf: newCards)
        deck = Array(deck.dropFirst(quantity))
        print("deal cards \(quantity): \(deck.count) cards in deck; \(cardsInGame.count) - in game; \(discardPile.count) - discard pile")
    }
    
    mutating func choose(card: Card) {
        guard selectedCards.count < setSize else { return }
        
        for index in cardsInGame.indices {
            if cardsInGame[index] == card {
                cardsInGame[index].isSelected.toggle()
            }
        }
        checkForSet()
    }
    
    private mutating func checkForSet() {
        guard selectedCards.count == setSize else { return }
        
        if Card.isSet(card1: selectedCards[0], card2: selectedCards[1], card3: selectedCards[2]) {
            print("Correct set")
            discardSelectedCards()
        } else {
            print("Incorrect set")
            unselectCards()
        }
    }
    
    private mutating func discardSelectedCards() {
        for _ in selectedCards.indices {
            if let index = cardsInGame.firstIndex(of: selectedCards.first!) {
                cardsInGame[index].isMatched = true
                let cardToRemove = cardsInGame.remove(at: index)
                //print("removed \(cardToRemove)")
                discardPile.append(cardToRemove.unselected)
            }
        }
        earnPoints()
        dealCards()
    }
    
    private mutating func unselectCards() {
        for index in cardsInGame.indices {
            if selectedCards.contains(cardsInGame[index]) {
                cardsInGame[index].isSelected = false
            }
        }
        penalizePoints()
    }
    
    private mutating func earnPoints() {
        if cardsInGame.count <= maxCardsForBonus && deck.count > 0 {
            score += maxPoints
        } else {
            score += minPoints
        }
    }
    
    private mutating func penalizePoints() {
        score -= maxPoints
        if score < 0 {
            score = 0
        }
    }
    
    // MARK: - Constraints
    private let setSize = 3
    private let maxCardsForBonus = 18
    private let maxPoints = 5
    private let minPoints = 1
}


