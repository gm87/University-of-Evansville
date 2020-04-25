//
//  City.swift
//  outreachTrackingTool
//
//  Created by Graham Matthews on 2/29/20.
//  Copyright © 2020 Graham Matthews. All rights reserved.
//

class City:Codable {
    let id:Int
    let name:String
    let state:Int
    
    init(id:Int, name:String, state:Int) {
        self.id = id
        self.name = name
        self.state = state
    }
}
