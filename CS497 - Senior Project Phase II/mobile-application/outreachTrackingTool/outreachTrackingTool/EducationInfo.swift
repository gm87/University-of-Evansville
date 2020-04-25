//
//  EducationInfo.swift
//  outreachTrackingTool
//
//  Created by Graham Matthews on 2/22/20.
//  Copyright © 2020 Graham Matthews. All rights reserved.
//

import MonthYearPicker

class EducationInfo:Codable {
    var institution:String = ""
    var beginDate:Date = Date()
    var endDate:Date = Date()
    var summary:String = ""
    var degreeId:Int = 1
    var degreeRow = 1
    var fieldOfStudy = ""
    
    func updateInstitution(institution: String) { self.institution = institution }
    func updateBeginDate(beginDate: Date) { self.beginDate = beginDate }
    func updateEndDate(endDate: Date) { self.endDate = endDate }
    func updateSummary(summary: String) { self.summary = summary }
    func updateDegree(id: Int) { self.degreeId = id }
    func updateDegreeRow(row: Int) { self.degreeRow = row }
    func updateFieldOfStudy(field: String) { self.fieldOfStudy = field }
    
    func getInstitution() -> String { return self.institution }
    func getBeginDate() -> Date { return self.beginDate }
    func getEndDate() -> Date { return self.endDate }
    func getSummary() -> String { return self.summary }
    func getDegreeId() -> Int { return self.degreeId }
    func getDegreeRow() -> Int { return self.degreeRow }
    func getFieldOfStudy() -> String { return self.fieldOfStudy }
}
