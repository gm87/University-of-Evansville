//
//  State.swift
//  outreachTrackingTool
//
//  Created by Graham Matthews on 2/29/20.
//  Copyright © 2020 Graham Matthews. All rights reserved.
//

class State:Codable {
    var id:Int
    var name:String
    var abbreviation:String
    
    init(id:Int, name:String, abbreviation:String) {
        self.id = id
        self.name = name
        self.abbreviation = abbreviation
    }
}
