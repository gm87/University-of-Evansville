//
//  CandidateData.swift
//  outreachTrackingTool
//
//  Created by Graham Matthews on 2/22/20.
//  Copyright © 2020 Graham Matthews. All rights reserved.
//

import MapKit

class CandidateData:Codable {
    var fName:String = ""
    var lName:String = ""
    var email:String = ""
    var phone:String = ""
    var website:String = ""
    var address1:String = ""
    var address2:String = ""
    var city:String = ""
    var state:String = ""
    var stateId:Int = 1
    var stateRowId:Int = 0
    var cityId: Int = -1
    var cityRowId:Int = 0
    var educationInfo = [EducationInfo]()
    var workExperience = [WorkExperience]()
    var additionalInfo = [AdditionalInfo]()
    var sourceLocationLat:CLLocationDegrees = CLLocationCoordinate2D(latitude: 0, longitude: 0).latitude
    var sourceLocationLong:CLLocationDegrees = CLLocationCoordinate2D(latitude: 0, longitude: 0).longitude
    var addedByEmail = ""
    
    func updatefName(firstName: String) { self.fName = firstName }
    func updatelName(lastName: String) { self.lName = lastName }
    func updateEmail(email: String) { self.email = email }
    func updatePhone(phone: String) { self.phone = phone }
    func updateAddress1(address1: String) { self.address1 = address1 }
    func updateAddress2(address2: String) { self.address2 = address2 }
    func updateCity(city: String) { self.city = city }
    func updateAdditionalInfo(array: [AdditionalInfo]) { self.additionalInfo = array }
    func updateWorkExperience(array: [WorkExperience]) { self.workExperience = array }
    func updateEducationInfo(array: [EducationInfo]) { self.educationInfo = array }
    func updateStateId(id: Int) { self.stateId = id }
    func updateStateRowId(id: Int) { self.stateRowId = id }
    func updateCityId(id: Int) { self.cityId = id }
    func updateCityRowId(id: Int) { self.cityRowId = id }
    
    func getFirstName() -> String { return self.fName }
    func getLastName() -> String { return self.lName }
    func getEmail() -> String { return self.email }
    func getPhone() -> String { return self.phone }
    func getAddress1() -> String { return self.address1 }
    func getAddress2() -> String { return self.address2 }
    func getAdditionalInfo() -> [AdditionalInfo] { return self.additionalInfo }
    func getEducationInfo() -> [EducationInfo] { return self.educationInfo }
    func getWorkExperience() -> [WorkExperience] { return self.workExperience }
    func getStateId() -> Int { return self.stateId }
    func getCityId() -> Int { return self.cityId }
    func getStateRowId() -> Int { return self.stateRowId }
    func getCityRowId() -> Int { return self.cityRowId }
    
}
