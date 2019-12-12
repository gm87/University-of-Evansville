//
//  OpposingPlayer.swift
//  poker
//
//  Created by Graham Matthews on 11/25/19.
//  Copyright © 2019 Graham Matthews. All rights reserved.
//

import Foundation
import SpriteKit

class OpposingPlayer:SKSpriteNode {
    private var hand:Hand = Hand()
    private var bank:Bank = Bank()
    private var playerName:String = ""
    
    init (initValue: Int) {
        bank.setValue(value: initValue)
        let texture = SKTexture(imageNamed: "avatar" + String(Int.random(in: 1...14)))
        super.init(texture: texture, color: SKColor.clear, size: texture.size())
        self.playerName = getRandomName()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func getRandomName() -> String {
        let names = ["Liam", "Noah", "William", "James", "Oliver", "Benjamin", "Elijah", "Lucas",
                    "Mason", "Logan", "Alexander", "Ethan", "Jacob", "Michael", "Daniel", "Emma", "Olivia",
                    "Ava", "Isabella", "Sophia", "Charlotte", "Mia", "Amelia", "Harper", "Evelyn", "Abigail",
                    "Emily", "Elizabeth", "Mila", "Ella", "Avery", "Sofia", "Camila", "Aria", "Scarlett"]
        return names[Int.random(in: 0...names.count-1)]
    }
    
    func getBankValue() -> Int {
        return bank.getBankValue()
    }
    
    func addToBank(value: Int) {
        bank.addToBank(value: value)
    }
    
    func removeFromBank(value: Int) {
        bank.removeFromBank(value: value)
    }
    
    func addToHand(cards: [Card]) {
        hand.addCards(cards: cards)
    }
    
    func resetHand() {
        hand.resetHand()
    }
    
    func getName() -> String {
        return playerName
    }
    
    func getHand() -> Hand {
        return hand
    }
}
