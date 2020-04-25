//
//  ReviewViewController.swift
//  outreachTrackingTool
//
//  Created by Graham Matthews on 2/24/20.
//  Copyright © 2020 Graham Matthews. All rights reserved.
//

import UIKit
import OktaOidc

class ReviewViewController:UIViewController {
    
    var oktaOidc: OktaOidc?
    var stateManager: OktaOidcStateManager?
    var candidateData: CandidateData?
    var states: StatesArray?
    var cities: CitiesArray?
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var textView: UITextView!
    var images: [CGImage]?
    
    @IBOutlet weak var reviewLabel: UILabel!
    override func viewDidLoad() {
        configure()
        submitBtn.layer.cornerRadius = 5
        submitBtn.layer.borderWidth = 1
        submitBtn.layer.borderColor = UIColor.black.cgColor
        reviewLabel.layer.borderWidth = 1
        reviewLabel.layer.borderColor = UIColor.black.cgColor
        textView.attributedText = getReviewText()
    }
    
    func getReviewText() -> NSMutableAttributedString {
        var text:String = "Name\n" + candidateData!.lName + ", " + candidateData!.fName + "\nEmail\n" + candidateData!.email + "\n"
        if ((candidateData?.phone.count)! > 0) { text += "Phone\n" + candidateData!.phone + "\n" }
        if ((candidateData?.address1.count)! > 0) {
            text += "Address\n" + candidateData!.address1 + "\n" + (candidateData!.address2 != "" ? (candidateData!.address2 + "\n") : "") + candidateData!.city + ", " + candidateData!.state + "\n"
        }
        if ((candidateData?.educationInfo.count)! > 0) {
            text += "Education\n"
            let degrees = ["Associate's", "Bachelor's", "Master's", "Doctorate"]
            for info in candidateData!.educationInfo {
                text += info.institution + "\n" + info.fieldOfStudy + " " + degrees[info.degreeId] + "\n"
            }
            text += "\n"
        }
        if ((candidateData?.workExperience.count)! > 0) {
            text += "Work Experience\n"
            for info in candidateData!.workExperience {
                text += info.name + " - " + info.getTitle() + "\n"
            }
            text += "\n"
        }
        if ((candidateData?.additionalInfo.count)! > 0) {
            text += "Additional Information\n"
            for info in candidateData!.additionalInfo {
                text += info.title + "\n"
            }
            text += "\n"
        }
        let string = NSMutableAttributedString(string: text)
        string.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Arial-BoldMT", size: 18.0)!, range: (text as NSString).range(of: "Name"))
        string.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Arial-BoldMT", size: 18.0)!, range: (text as NSString).range(of: "Email"))
        if ((candidateData?.phone.count)! > 0) {
            string.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Arial-BoldMT", size: 18.0)!, range: (text as NSString).range(of: "Phone"))
        }
        if ((candidateData?.address1.count)! > 0) {
            string.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Arial-BoldMT", size: 18.0)!, range: (text as NSString).range(of: "Address"))
        }
        if ((candidateData?.educationInfo.count)! > 0) {
            string.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Arial-BoldMT", size: 18.0)!, range: (text as NSString).range(of: "Education"))
        }
        if ((candidateData?.workExperience.count)! > 0) {
            string.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Arial-BoldMT", size: 18.0)!, range: (text as NSString).range(of: "Work Experience"))
        }
        if ((candidateData?.additionalInfo.count)! > 0) {
            string.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Arial-BoldMT", size: 18.0)!, range: (text as NSString).range(of: "Additional Information"))
        }
        string.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: (text as NSString).range(of: text))
        
        return string
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? SuccessViewController {
            destinationViewController.stateManager = self.stateManager
            destinationViewController.oktaOidc = self.oktaOidc
            destinationViewController.states = self.states
            destinationViewController.cities = self.cities
        }
    }
    
    @IBAction func pressedSubmit(_ sender: Any) {
        let jsonData = try! JSONEncoder().encode(candidateData)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        print(jsonString)
        let sessionConfig = URLSessionConfiguration.default
        let authValue: String = "Bearer \(stateManager?.accessToken ?? "error")"
        sessionConfig.httpAdditionalHeaders = ["authorization": authValue, "accept": "application/json", "content-type": "application/json"]

        let session = URLSession(configuration: sessionConfig,
                                 delegate: self as? URLSessionDelegate,
                                 delegateQueue: nil)
       
        let request = NSMutableURLRequest(url: URL(string: "http://18.219.89.231:4000/candidates/new")!)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        let task = session.dataTask(with: request as URLRequest) {
            (data, response, error) in
            if ((error) != nil) {
                print("Error in http request")
            } else {
                let string = String(data: data!, encoding: .utf8)
                print(string as Any)
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        let request = NSMutableURLRequest(url: URL(string: "http://18.219.89.231:4000/upload")!)
                        request.httpMethod = "POST"
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "show-success-view", sender: self)
                        }
                    }
                }
            }
        }

        task.resume()
    }
    
}

private extension ReviewViewController {
    func configure() {
        guard isViewLoaded else { return }
        /*
        let stateManager = self.stateManager
        let candidateData = self.candidateData
         */
    }
}
