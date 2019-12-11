//
//  Calculator.swift
//  calculator
//
//  Created by Graham Matthews on 8/31/19.
//  Copyright © 2019 Graham Matthews. All rights reserved.
//

import Foundation

class Calculator {

    var num1: Double? = nil
    var num2: Double? = nil
    var lastOp: String? = nil

    func setNum1(x: Double){
        if (num2 == nil) {
            num2 = x
        }
        else {
            num1 = x
        }
    }
    func setNum2(x: Double){ num2 = x }
    func clearNum1() { num1 = nil }
    func clearNum2() { num2 = nil }
    func setLastOp(lastOp: String) { self.lastOp = lastOp }
    func clearLastOp() { lastOp = nil }
    
    func getNum1() -> Double {return num1!}
    func getNum2() -> Double {return num2!}
    
    func calculate() -> Double {
        if (lastOp == "+") {
            num2 = Double(num2!) + Double(num1!)
            return num2!
        }
        else if (lastOp == "-") {
            num2 = Double(num2!) - Double(num1!)
            return num2!
        }
        else if (lastOp == "*") {
            num2 = Double(num2!) * Double(num1!)
            return num2!
        }
        else if (lastOp == "/") {
            num2 = Double(num2!) / Double(num1!)
            return num2!
        }
        else if (lastOp == nil) {
            return num2!
        }
        return 0.0
    }

    func sqrt() -> Double {
        num2 = num2!.squareRoot()
        return num2!
    }

    func sinx() -> Double {
        num2 = sin(num2!)
        return num2!
    }

    func cosx() -> Double {
        num2 = cos(num2!)
        return num2!
    }

    func tanx() -> Double {
        num2 = tan(num2!)
        return num2!
    }

    func inverse() -> Double {
        num2 = 1/num2!
        return num2!
    }

    func opposite() -> Double {
        num2 = num2!*(-1)
        return num2!
    }
}
