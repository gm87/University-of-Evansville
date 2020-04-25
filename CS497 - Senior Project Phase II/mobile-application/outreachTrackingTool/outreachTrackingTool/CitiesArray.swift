//
//  CitiesArray.swift
//  outreachTrackingTool
//
//  Created by Graham Matthews on 2/29/20.
//  Copyright © 2020 Graham Matthews. All rights reserved.
//

class CitiesArray:Codable {
    let data:[City]
    
    func filterByStateId(id: Int) -> [City] {
        let arr = data.filter{$0.state == id}
        return arr
    }
}
