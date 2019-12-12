//
//  CommunityCards.swift
//  poker
//
//  Created by Graham Matthews on 11/25/19.
//  Copyright © 2019 Graham Matthews. All rights reserved.
//

import Foundation

class CommunityCards {
    private var hand:Hand = Hand()
    
    func addToCommunityCards (cards:[Card]) {
        hand.addCards(cards: cards)
    }
    
    func resetCommunityCards () {
        hand.resetHand()
    }
    
    func setHand(hand: Hand) {
        self.hand = hand
    }
    
    func getHand() -> Hand {
        return hand
    }
}
