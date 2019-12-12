//
//  Hand.swift
//  poker
//
//  Created by Graham Matthews on 11/25/19.
//  Copyright © 2019 Graham Matthews. All rights reserved.
//

import Foundation

class Hand {
    private var hand = [Card]()
    var highCard = -1
    var pair = -1
    var twoPair = -1
    var threeOfAKind = -1
    var straight = -1
    var flush = -1
    var fullHouse = -1
    var fourOfAKind = -1
    var straightFlush = -1
    
    func printCards() {
        for card in hand {
            card.printCard()
        }
    }
    
    func addCards(cards: [Card]) {
        for card in cards {
            hand.append(card)
        }
    }
    
    func resetHand() {
        hand.removeAll()
        highCard = -1
        pair = -1
        twoPair = -1
        threeOfAKind = -1
        straight = -1
        flush = -1
        fullHouse = -1
        fourOfAKind = -1
        straightFlush = -1
    }
    
    func getCombos(commCardHand: Hand) {
        var cards: [Card] = [hand[0], hand[1]]
        for card in commCardHand.getCardArray() {
            cards.append(card)
        }
        
        var cardVals: [Int] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        for card in cards { cardVals[card.getValue()] += 1 }
        
        for n in 0...cardVals.count-1 {
            if (cardVals[n] != 0) {
                highCard = n
            }
            if (cardVals[n] == 4) {
                fourOfAKind = n
            }
            if (cardVals[n] == 3) {
                threeOfAKind = n
            }
            if (cardVals[n] == 2) {
                pair = n
                for m in n+1...cardVals.count-1 {
                    if (cardVals[m] == 2) {
                        twoPair = m
                    }
                }
            }
        }
        
        if (cards.count > 4) {
            for x in 0...cards.count-5 {
                if (cards[x+1].getSuit() == cards[x].getSuit() &&
                    cards[x+2].getSuit() == cards[x].getSuit() &&
                    cards[x+3].getSuit() == cards[x].getSuit() &&
                    cards[x+4].getSuit() == cards[x].getSuit()) {
                    flush = cards[x+4].getValue()
                }
            }
            
            for x in 0...cards.count-5 {
                if ((cards[x+1].getValue() == cards[x].getValue() + 1) &&
                    (cards[x+2].getValue() == cards[x+1].getValue() + 1) &&
                    (cards[x+3].getValue() == cards[x+2].getValue() + 1) &&
                    (cards[x+4].getValue() == cards[x+3].getValue() + 1)) {
                    straight = cards[x+4].getValue()
                }
            }
        }
        
        if (straight > 0 && flush > 0) {
            straightFlush = straight
        }
        
        if (twoPair > 0 && threeOfAKind > 0) {
            fullHouse = threeOfAKind
        }
    }
    
    func getHighCardStatus() -> Int {
        return highCard
    }
    
    func getPairStatus() -> Int {
        return pair
    }
    
    func getTwoPairStatus() -> Int {
        return twoPair
    }
    
    func getThreeOfAKindStatus() -> Int {
        return threeOfAKind
    }
    
    func getStraightStatus() -> Int {
        return straight
    }
    
    func getFlushStatus() -> Int {
        return flush
    }
    
    func getFullHouseStatus() -> Int {
        return fullHouse
    }
    
    func getFourOfAKindStatus() -> Int {
        return fourOfAKind
    }
    
    func getStraightFlushStatus() -> Int {
        return straightFlush
    }
    
    func getCardArray() -> [Card] {
        return hand
    }
}
