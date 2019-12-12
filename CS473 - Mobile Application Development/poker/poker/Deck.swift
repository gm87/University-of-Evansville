//
//  Deck.swift
//  poker
//
//  Created by Graham Matthews on 11/25/19.
//  Copyright © 2019 Graham Matthews. All rights reserved.
//

import Foundation

class Deck {
    private var deck = [Card]()
    private var deckIndex = -1
    
    init() {
        create()
        shuffle()
    }
    
    func create() {
        deckIndex = -1
        deck.removeAll()
        let suits = ["diamonds", "hearts", "spades", "clubs"]
        for cardSuit in suits {
            for cardValue in 1...13 {
                let tempCard = Card(suit: cardSuit, value: cardValue)
                deck.append(tempCard)
            }
        }
    }
    
    func getTopCard()->Card{
        deckIndex+=1
        return deck[deckIndex]
    }
    
    func shuffle() {
        deck.shuffle()
    }
    
    func new() {
        deckIndex = -1
        shuffle()
    }
}
