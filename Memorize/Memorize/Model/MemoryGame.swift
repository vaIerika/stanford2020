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
        var isFaceUp: Bool = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        
        var isMatched: Bool = false {
            didSet {
                stopUsingBonusTime()
            }
        }
        
        var alreadyBeenSeen: Bool = false
        var content: CardContent
        var id: Int

    
        
    
        
        // MARK: - Bonus Time
        /// It gives bonus points if user matches the card before a certain amount of time during which the card is face up
        
        // can be zero which means "no bonus available" for this card
        var bonusTimeLimit: TimeInterval = 6
        
        // how long this card has even been face up
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        
        // the last time this card was turned up (and is still face up)
        var lastFaceUpDate: Date?
        
        // the accumulated time this card has been face up in the past
        /// not incuding the current time it's been face up if it is currently so
        var pastFaceUpTime: TimeInterval = 0
        
        // how much time left before the bonus opportunity runs out
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        
        // % of the bonus time remaining
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining / bonusTimeLimit : 0
        }
        
        // whether the card was matched during the bonus time period
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }
        
        // whether we are currently face up, unmatched and have not yet used up the bonus window
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }
        
        // called when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        
        // called when the card goes back face down (or gets matched)
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            lastFaceUpDate = nil
        }
 
    }
}
