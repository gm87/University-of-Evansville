//
//  Bank.swift
//  poker
//
//  Created by Graham Matthews on 11/25/19.
//  Copyright © 2019 Graham Matthews. All rights reserved.
//

import Foundation

class Bank {
    private var value:Int = 0
    
    func addToBank(value:Int) {
        self.value += value
    }
    
    func removeFromBank(value:Int) {
        self.value += (-1 * value)
    }
    
    func getBankValue() -> Int {
        return value
    }
    
    func setValue(value: Int) {
        self.value = value
    }
}
