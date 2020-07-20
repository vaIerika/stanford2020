//
//  SetCard+Identifiable.swift
//  SetGame
//
//  Created by Valerie 👩🏼‍💻 on 08/07/2020.
//

import Foundation

protocol SetCard: Equatable, Identifiable where FeatureA: SetCategory, FeatureB: SetCategory, FeatureC: SetCategory, FeatureD: SetCategory {
    
    associatedtype FeatureA
    associatedtype FeatureB
    associatedtype FeatureC
    associatedtype FeatureD
    
    var featureA: FeatureA { get }
    var featureB: FeatureB { get }
    var featureC: FeatureC { get }
    var featureD: FeatureD { get }
    
    var isFaceUp: Bool { get set }
    var isSelected: Bool { get set }
    var isMatched: Bool { get set }
    
    static func generateAll() -> [Self]
}

extension SetCard {
    var facedDown: Self {
        playCard(false)
    }
    
    var facedUp: Self {
        playCard(true)
    }
    
    var unselected: Self {
        var card = self
        card.isSelected = false
        return card
    }
        
    private func playCard(_ facedUp: Bool) -> Self {
        var card = self
        card.isFaceUp = facedUp
        return card
    }
}

extension SetCard {
    static func isSet(card1: Self, card2: Self, card3: Self) -> Bool {
        let setsByFeatures = [
            FeatureA.isCorrectSet(contentA: card1.featureA, contentB: card2.featureA, contentC: card3.featureA),
            FeatureB.isCorrectSet(contentA: card1.featureB, contentB: card2.featureB, contentC: card3.featureB),
            FeatureC.isCorrectSet(contentA: card1.featureC, contentB: card2.featureC, contentC: card3.featureC),
            FeatureD.isCorrectSet(contentA: card1.featureD, contentB: card2.featureD, contentC: card3.featureD)
        ]
        
        // only if all are correct sets
        return setsByFeatures.reduce(true) { $0 && $1 }
    }
}
