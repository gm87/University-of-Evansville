//
//  AutomaticEntryViewController.swift
//  outreachTrackingTool
//
//  Created by Graham Matthews on 2/4/20.
//  Copyright © 2020 Graham Matthews. All rights reserved.
//

import UIKit
import OktaOidc
import Vision
import VisionKit
import MapKit
import NaturalLanguage

class AutomaticEntryViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var oktaOidc: OktaOidc?
    var stateManager: OktaOidcStateManager?
    var locationManager: CLLocationManager?
    var candidateData: CandidateData?
    var states: StatesArray?
    var cities: CitiesArray?
    var blocks:[TextBlock] = []
    var images: [CGImage] = []
    
    // Vision requests to be performed on each page of the scanned document.
    private var requests = [VNRequest]()
    // Dispatch queue to perform Vision requests.
    private let textRecognitionWorkQueue = DispatchQueue(label: "TextRecognitionQueue",
                                                         qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    private var resultingText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        let documentCameraViewController = VNDocumentCameraViewController()
        documentCameraViewController.delegate = self
        present(documentCameraViewController, animated: true)
        setupVision()
    }
    
    func matches(for regex: String, in text: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [])
            let results = regex.matches(in: text, options: [], range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch {
            print("invalid regex: " + regex)
            return []
        }
    }
    
    // Setup Vision request as the request can be reused
    private func setupVision() {
        let textRecognitionRequest = VNRecognizeTextRequest { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                print("The observations are of an unexpected type.")
                return
            }
            // Concatenate the recognised text from all the observations.
            let maximumCandidates = 1
            for observation in observations {
                guard let candidate = observation.topCandidates(maximumCandidates).first else { continue }
                // First observation always is its own text block
                if (observations.firstIndex(of: observation) == 0) {
                    self.blocks.append(TextBlock(line: TextLine(text: candidate.string, minX: observation.boundingBox.minX, maxX: observation.boundingBox.maxX, minY: observation.boundingBox.minY, maxY: observation.boundingBox.maxY)))
                } else {
                    var addedLine = false
                    for block in self.blocks {
                        for line in block.lines {
                            if (!addedLine &&
                                (abs(observation.boundingBox.minX - line.minX) < 0.08) &&
                                (abs(observation.boundingBox.minY - line.minY) < 0.02)) {
                                block.addLine(line: TextLine(text: candidate.string, minX: observation.boundingBox.minX, maxX: observation.boundingBox.maxX, minY: observation.boundingBox.minY, maxY: observation.boundingBox.maxY))
                                addedLine = true
                            }
                        }
                    }
                    if (!addedLine) {
                        self.blocks.append(TextBlock(line: TextLine(text: candidate.string, minX: observation.boundingBox.minX, maxX: observation.boundingBox.maxX, minY: observation.boundingBox.minY, maxY: observation.boundingBox.maxY)))
                    }
                }
            }
            do {
                self.candidateData = CandidateData()
                let textBlockClassifier = try NLModel(mlModel: TextBlockClassifier().model)
                for block in self.blocks {
                    let classification = textBlockClassifier.predictedLabel(for: block.getLines())
                    print(block.getLines() + " is a " + (classification ?? "Unknown"))
                    block.classification = classification ?? "Unknown"
                }
                for i in 0...self.blocks.count-1 where self.blocks[i].evaluated == false {
                    if (self.blocks[i].classification == "additionalInfo") {
                        let addInfo = AdditionalInfo()
                        addInfo.title=self.blocks[i].lines[0].text
                        if (self.blocks[i].lines.count > 1) {
                            for j in 1...self.blocks[i].lines.count-1 {
                                addInfo.description += self.blocks[i].lines[j].text + "\n"
                            }
                        } else {
                            addInfo.description = self.blocks[i].lines[0].text
                        }
                        self.candidateData?.additionalInfo.append(addInfo)
                    } else if (self.blocks[i].classification == "workExperience") {
                        let textClassifier = try NLModel(mlModel: WorkExpClassifier().model)
                        let workExp = WorkExperience()
                        for line in self.blocks[i].lines {
                            let classification = textClassifier.predictedLabel(for: line.text)
                            if (classification == "workplace" && workExp.name == "") {
                                workExp.name = line.text
                            } else if (classification == "title" && workExp.title == "") {
                                workExp.title = line.text
                            } else {
                                workExp.summary += line.text + "\n"
                            }
                        }
                        self.candidateData?.workExperience.append(workExp)
                    } else if (self.blocks[i].classification == "eduInfo") {
                        let textClassifier = try NLModel(mlModel: EduInfoClassifier().model)
                        let eduInfo = EducationInfo()
                        for line in self.blocks[i].lines {
                            let classification = textClassifier.predictedLabel(for: line.text)
                            if (classification == "field") {
                                eduInfo.fieldOfStudy = line.text
                            } else if (classification == "institution") {
                                eduInfo.institution = line.text
                            } else if (classification == "summary") {
                                eduInfo.summary += line.text + "\n"
                            }
                        }
                        self.candidateData?.educationInfo.append(eduInfo)
                    } else if (self.blocks[i].classification == "contactInfo") {
                        do {
                            let textClassifier = try NLModel(mlModel: ContactInfoClassifier().model)
                            for line in self.blocks[i].lines {
                                let emailRegex = try! NSRegularExpression(pattern: "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,6}")
                                let phoneRegex = try! NSRegularExpression(pattern: "((\\(\\d{3}\\) ?)|(\\d{3}-))?\\d{3}-\\d{4}")
                                let range = NSRange(location: 0, length: line.text.utf16.count)
                                let emailMatched = emailRegex.firstMatch(in: line.text, options: [], range: range) != nil
                                let phoneMatched = phoneRegex.firstMatch(in: line.text, options: [], range: range) != nil
                                if (emailMatched && self.candidateData?.email == "") {
                                    let matched = self.matches(for: "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,6}", in: line.text)
                                    self.candidateData?.email = matched[0]
                                }
                                if (phoneMatched && self.candidateData?.phone == "") {
                                    let matched = self.matches(for: "((\\(\\d{3}\\) ?)|(\\d{3}-))?\\d{3}-\\d{4}", in: line.text)
                                    self.candidateData?.phone = matched[0]
                                }
                                let classification = textClassifier.predictedLabel(for: line.text)
                                line.classification = classification ?? "Unknown"
                                if (line.classification == "name") {
                                    self.candidateData?.fName = String(line.text.split(separator: " ")[0])
                                    let split = line.text.split(separator: " ")
                                    var lName = ""
                                    for i in 1...split.count-1 {
                                        lName += split[i] + " "
                                    }
                                    self.candidateData?.lName = String(lName[..<lName.lastIndex(of: " ")!])
                                } else if (line.classification == "address") {
                                    if (self.candidateData?.address1 == "") {
                                        self.candidateData?.address1 = line.text
                                    } else if (self.candidateData?.address2 == "") {
                                        self.candidateData?.address2 = line.text
                                    }
                                }
                            }
                        } catch {
                            print("Failed to initialize contactInfoClassifier")
                        }
                    } else if (self.blocks[i].classification == "heading") {
                        if (i < self.blocks.count-2 && self.blocks[i+1].classification == "additionalInfo") {
                            let addInfo = AdditionalInfo()
                            addInfo.title = self.blocks[i].lines[0].text
                            addInfo.description = self.blocks[i+1].getAllText()
                            self.candidateData?.additionalInfo.append(addInfo)
                            self.blocks[i+1].evaluated = true
                        }
                    }
                }
            } catch {
                print("Something went wrong")
            }
        }
        // specify the recognition level
        textRecognitionRequest.recognitionLevel = .accurate
        self.requests = [textRecognitionRequest]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? ManualEntryViewController {
            destinationViewController.candidateData = self.candidateData
            destinationViewController.states = self.states
            destinationViewController.cities = self.cities
            destinationViewController.oktaOidc = self.oktaOidc
            destinationViewController.stateManager = self.stateManager
            destinationViewController.images = self.images
            destinationViewController.locationManager = self.locationManager
        }
    }
}

extension AutomaticEntryViewController: VNDocumentCameraViewControllerDelegate {
    
    public func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        // dismiss the document camera
        controller.dismiss(animated: true)
        
        textRecognitionWorkQueue.async {
            self.resultingText = ""
            for pageIndex in 0 ..< scan.pageCount {
                let image = scan.imageOfPage(at: pageIndex)
                if let cgImage = image.cgImage {
                    self.candidateData = CandidateData()
                    self.images.append(cgImage)
                    let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
                    
                    do {
                        try requestHandler.perform(self.requests)
                    } catch {
                        print(error)
                    }
                }
            }
            DispatchQueue.main.async(execute: {
                self.performSegue(withIdentifier: "show-manual-entry", sender: self)
            })
        }
    }
}
