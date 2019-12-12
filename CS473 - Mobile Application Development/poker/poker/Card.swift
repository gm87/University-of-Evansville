//
//  Card.swift
//  poker
//
//  Created by Graham Matthews on 11/25/19.
//  Copyright © 2019 Graham Matthews. All rights reserved.
//

import Foundation
import SpriteKit

class Card:SKSpriteNode {
    private var suit:String = ""
    private var value:Int = 0
    init (suit: String, value: Int) {
        self.suit = suit
        self.value = value
        let texture = SKTexture(imageNamed: String(value) + "_of_" + suit)
        super.init(texture: texture, color: SKColor.clear, size: texture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func getValue()->Int {
        return value
    }
    
    func getSuit()->String {
        return suit
    }
    
    func printCard() {
        print(String(value) + " of " + suit)
    }
}
