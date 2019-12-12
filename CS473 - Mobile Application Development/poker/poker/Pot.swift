//
//  Pot.swift
//  poker
//
//  Created by Graham Matthews on 11/25/19.
//  Copyright © 2019 Graham Matthews. All rights reserved.
//

import Foundation

class Pot {
    private var value:Int = 0
    
    init () {
        self.value = 0
    }
    
    func addToPot(value:Int) {
        self.value += value
    }
    
    func getPotValue() -> Int {
        return value
    }
    
    func resetPot() {
        value = 0
    }
}
