//
//  Timer.swift
//  maps
//
//  Created by Graham Matthews on 10/30/19.
//  Copyright © 2019 Graham Matthews. All rights reserved.
//

import Foundation

class MyTimer {
    var timer = Timer()
    var counter = 0.0

    func startTimer() {
        timer = Timer.scheduledTimer(
            timeInterval: 0.1,
            target: self,
            selector: #selector(incCounter),
            userInfo: nil,
            repeats: true
        )
        timer.fire()
    }
    
    func stopTimer() {
        timer.invalidate()
    }

    @objc func incCounter() {
        counter += 0.1
    }
    
    func resetCounter() {
        counter = 0.0
    }
    
    func getCounter() -> Double {
        return counter
    }

}
