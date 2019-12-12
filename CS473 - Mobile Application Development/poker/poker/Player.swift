//
//  Player.swift
//  poker
//
//  Created by Graham Matthews on 11/25/19.
//  Copyright © 2019 Graham Matthews. All rights reserved.
//

import Foundation

class Player {
    private var hand:Hand = Hand()
    private var bank:Bank = Bank()
    
    init (initValue: Int) {
        self.bank.setValue(value: initValue)
    }
    
    func getHand() -> Hand {
        return hand
    }
    
    func getBank() -> Bank {
        return bank
    }
}
