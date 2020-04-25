//
//  NewEntryViewController.swift
//  outreachTrackingTool
//
//  Created by Graham Matthews on 2/4/20.
//  Copyright © 2020 Graham Matthews. All rights reserved.
//

import UIKit
import OktaOidc
import MapKit

class ManualEntryViewController: UIViewController {
    
    var oktaOidc: OktaOidc?
    var stateManager: OktaOidcStateManager?
    var candidateData: CandidateData?
    var states: StatesArray?
    var cities: CitiesArray?
    var images: [CGImage]?
    var locationManager: CLLocationManager?
    @IBOutlet weak var contactInfoBtn: UIButton!
    @IBOutlet weak var educatoinInfoBtn: UIButton!
    @IBOutlet weak var workExperienceBtn: UIButton!
    @IBOutlet weak var additionalInfoBtn: UIButton!
    @IBOutlet weak var reviewBtn: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configure()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? ContactInfoViewController {
            destinationViewController.candidateData = self.candidateData
            destinationViewController.states = self.states
            destinationViewController.cities = self.cities
        } else if let destinationViewController = segue.destination as? EducationInfoMaster {
            destinationViewController.candidateData = self.candidateData
        } else if let destinationViewController = segue.destination as? WorkInfoMaster {
            destinationViewController.candidateData = self.candidateData
        } else if let destinationViewController = segue.destination as? AdditionalInfoMaster {
            destinationViewController.candidateData = self.candidateData
        } else if let destinationViewController = segue.destination as? ReviewViewController {
            destinationViewController.oktaOidc = self.oktaOidc
            destinationViewController.stateManager = self.stateManager
            destinationViewController.candidateData = self.candidateData
            destinationViewController.states = self.states
            destinationViewController.cities = self.cities
            destinationViewController.images = self.images
        }
    }
    
    @IBAction func pressedContactInfo(_ sender: Any) {
        self.performSegue(withIdentifier: "show-contact-info-entry", sender: self)
    }
    
    @IBAction func pressedEducationInfo(_ sender: Any) {
        self.performSegue(withIdentifier: "show-education-info-master", sender: self)
    }
    
    @IBAction func pressedWorkExperience(_ sender: Any) {
        self.performSegue(withIdentifier: "show-work-info-master", sender: self)
    }
    
    @IBAction func pressedAdditionalInfo(_ sender: Any) {
        self.performSegue(withIdentifier: "show-additional-info-master", sender: self)
    }
    
    func showInvalidDataAlert(message: String) {
        let alert = UIAlertController(title: "Invalid Data", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func checkAddInfoEntries() -> Bool {
        print("Checking add info")
        for entry in candidateData?.additionalInfo ?? [] {
            if (entry.title.count == 0) {
                showInvalidDataAlert(message: "You're missing the title for an additional information entry. Please return to the additional information entry and add it.")
                return false
            }
        }
        print("Done checking add info")
        return true
    }
    
    func checkEduInfoEntries() -> Bool {
        print("Check edu info")
        for eduEntry in candidateData?.educationInfo ?? [] {
            if (eduEntry.institution.count == 0) {
                showInvalidDataAlert(message: "You're missing the institution for an education information entry. Please return to the education information entry and add it.")
                return false
            } else if (eduEntry.fieldOfStudy.count == 0) {
                showInvalidDataAlert(message: "You're missing the field of study for education information entry " + eduEntry.institution + ". Please return to the education information entry and add it.")
                return false
            }
        }
        print("Done checking edu info")
        return true
    }
    
    func checkWorkInfoEntries() -> Bool {
        print("Checking work info")
        for workEntry in candidateData?.workExperience ?? [] {
            if (workEntry.name.count == 0) {
                showInvalidDataAlert(message: "You're missing the workplace name for a work experience entry. Please return to the work experience entry and add it.")
                return false
            } else if (workEntry.title.count == 0) {
                showInvalidDataAlert(message: "You're missing the title for work experience entry " + workEntry.name + ". Please return to the work experience entry and add it.")
                return false
            }
        }
        print("Done checking work info")
        return true
    }
    
    @IBAction func pressedReview(_ sender: Any) {
        if (candidateData?.fName.count == 0) {
            showInvalidDataAlert(message: "You're missing the candidate's first name. Please return to the contact information entry and add it.")
        } else if (candidateData?.lName.count == 0) {
            showInvalidDataAlert(message: "You're missing the candidate's last name. Please return to the contact information entry and add it.")
        } else if (candidateData?.email.count == 0) {
            showInvalidDataAlert(message: "You're missing the candidate's email. Please return to the contact information entry and add it.")
        } else if (checkAddInfoEntries() && checkEduInfoEntries() && checkWorkInfoEntries()) {
            self.performSegue(withIdentifier: "show-review", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactInfoBtn.layer.cornerRadius = 5
        contactInfoBtn.layer.borderWidth = 1
        contactInfoBtn.layer.borderColor = UIColor.black.cgColor
        educatoinInfoBtn.layer.cornerRadius = 5
        educatoinInfoBtn.layer.borderWidth = 1
        educatoinInfoBtn.layer.borderColor = UIColor.black.cgColor
        workExperienceBtn.layer.cornerRadius = 5
        workExperienceBtn.layer.borderWidth = 1
        workExperienceBtn.layer.borderColor = UIColor.black.cgColor
        additionalInfoBtn.layer.cornerRadius = 5
        additionalInfoBtn.layer.borderWidth = 1
        additionalInfoBtn.layer.borderColor = UIColor.black.cgColor
        reviewBtn.layer.cornerRadius = 5
        reviewBtn.layer.borderWidth = 1
        reviewBtn.layer.borderColor = UIColor.black.cgColor
        if (candidateData == nil) {
            candidateData = CandidateData()
            self.stateManager?.getUser { response, error in
                if error != nil {
                    print("Error")
                    return
                }
                
                self.candidateData?.addedByEmail = response?["preferred_username"] as? String ?? "ERR"
                self.candidateData?.sourceLocationLong = self.locationManager?.location?.coordinate.longitude ?? CLLocationCoordinate2D(latitude: 0, longitude: 0).longitude
                self.candidateData?.sourceLocationLat = self.locationManager?.location?.coordinate.latitude ?? CLLocationCoordinate2D(latitude: 0, longitude: 0).latitude
            }
            print("New candidate data")
        } else {
            print("Got candidate data")
            self.stateManager?.getUser { response, error in
                if error != nil {
                    print("Error")
                    return
                }
                
                self.candidateData?.addedByEmail = response?["preferred_username"] as? String ?? "ERR"
            }
            self.candidateData?.sourceLocationLong = self.locationManager?.location?.coordinate.longitude ?? CLLocationCoordinate2D(latitude: 0, longitude: 0).longitude
            self.candidateData?.sourceLocationLat = self.locationManager?.location?.coordinate.latitude ?? CLLocationCoordinate2D(latitude: 0, longitude: 0).latitude
        }
    }
}

private extension ManualEntryViewController {
    func configure() {
        guard isViewLoaded else { return }
        /*
        let stateManager = self.stateManager
        let candidateData = self.candidateData
        let cities = self.cities
        let states = self.states
        let locationManager = self.locationManager
         */
    }
}
