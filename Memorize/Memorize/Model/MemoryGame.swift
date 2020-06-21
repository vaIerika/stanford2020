//
//  MemoryGame.swift
//  Memorize
//
//  Created by Valerie 👩🏼‍💻 on 31/05/2020.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>
    var score = 0
    
    mutating func choose(card: Card) {
        
        let faceupCardIndeces = cards.indices.filter { cards[$0].isFaceUp }
        
        /// 3rd tap; when two cards are opened, update there Seen status and flip them; restart
        if faceupCardIndeces.count > 1 {
            for index in cards.indices {
                if cards[index].isFaceUp {
                    cards[index].alreadyBeenSeen = true
                    cards[index].isFaceUp = false
                }
            }
        }
        
        /// when the 1st and then the 2nd card has chosen which hasn't been matched yet
        if let chosenIndex = cards.firstIndex(matching: card), !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched {
            
            /// 1st tap: choose card - > flip the 1st card;
            /// 2nd tap: choose another card (start over func) -> flip the second card but in faceUpIndeces will be only one index still
            cards[chosenIndex].isFaceUp = true
            if faceupCardIndeces.count == 1 {
                
                if cards[faceupCardIndeces[0]].content == cards[chosenIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[faceupCardIndeces[0]].isMatched = true
                    
                    /// add two points for match even if cards had been seen
                    score += 2
                } else {
                    
                    /// penalizing 1 point for each card that has been seen but hasn't been matched yet
                    if cards[chosenIndex].alreadyBeenSeen {
                        score -= 1
                    }
                    if cards[faceupCardIndeces[0]].alreadyBeenSeen {
                        score -= 1
                    }
                }
            }
        }
    }
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = Array<Card>()
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: pairIndex * 2))
            cards.append(Card(content: content, id: pairIndex * 2 + 1))
        }
        cards.shuffle()
    }
    
    struct Card: Identifiable {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var alreadyBeenSeen: Bool = false
        var content: CardContent
        var id: Int
    }
}
