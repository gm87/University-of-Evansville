//
//  AdditionalInfo.swift
//  outreachTrackingTool
//
//  Created by Graham Matthews on 2/22/20.
//  Copyright © 2020 Graham Matthews. All rights reserved.
//

class AdditionalInfo:Codable {
    var title:String = ""
    var description:String = ""
    
    func updateTitle(title: String) { self.title = title }
    func updateDescription(description: String) { self.description = description }
    
    func getTitle() -> String { return self.title }
    func getDescription() -> String { return self.description }
}
