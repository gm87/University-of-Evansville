//
//  WorkExperience.swift
//  outreachTrackingTool
//
//  Created by Graham Matthews on 2/22/20.
//  Copyright © 2020 Graham Matthews. All rights reserved.
//

import MonthYearPicker

class WorkExperience:Codable {
    var name:String = ""
    var title:String = ""
    var beginDate:Date = Date()
    var endDate:Date = Date()
    var summary:String = ""
    
    func updateName(name: String) { self.name = name }
    func updateTitle(title: String) { self.title = title }
    func updateBeginDate(beginDate: Date) { self.beginDate = beginDate }
    func updateEndDate(endDate: Date) { self.endDate = endDate }
    func updateSummary(summary: String) { self.summary = summary }
    
    func getName() -> String { return self.name }
    func getTitle() -> String { return self.title }
    func getBeginDate() -> Date { return self.beginDate }
    func getEndDate() -> Date { return self.endDate }
    func getSummary() -> String { return self.summary }
}
