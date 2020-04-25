//
//  SignInViewController.swift
//  outreachTrackingTool
//
//  Created by Graham Matthews on 2/4/20.
//  Copyright © 2020 Graham Matthews. All rights reserved.
//

import UIKit
import OktaOidc
import OktaJWT
import MapKit

class SignInViewController: UIViewController, CLLocationManagerDelegate {
    
    var oktaOidc: OktaOidc?
    var stateManager: OktaOidcStateManager?
    var states: StatesArray?
    var cities: CitiesArray?
    let locationManager: CLLocationManager = CLLocationManager()
    @IBOutlet weak var manualEntryBtn: UIButton!
    @IBOutlet weak var automaticEntryBtn: UIButton!
    @IBOutlet weak var signOutBtn: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manualEntryBtn.isHidden = true
        automaticEntryBtn.isHidden = true
        manualEntryBtn.layer.cornerRadius = 5
        manualEntryBtn.layer.borderWidth = 1
        manualEntryBtn.layer.borderColor = UIColor.black.cgColor
        automaticEntryBtn.layer.cornerRadius = 5
        automaticEntryBtn.layer.borderWidth = 1
        automaticEntryBtn.layer.borderColor = UIColor.black.cgColor
        signOutBtn.layer.cornerRadius = 5
        signOutBtn.layer.borderWidth = 1
        signOutBtn.layer.borderColor = UIColor.black.cgColor
        loadUserInfo()
        if (self.cities?.data.count ?? 0 > 0 && self.states?.data.count ?? 0 > 0) {
            self.activityIndicator.isHidden = true
            self.manualEntryBtn.isHidden = false
            self.automaticEntryBtn.isHidden = false
        }
        DispatchQueue.global().async {
            let options = ["iss": self.oktaOidc!.configuration.issuer, "exp": "true"]
            let idTokenValidator = OktaJWTValidator(options)
            do {
                _ = try idTokenValidator.isValid(self.stateManager!.idToken!)
            } catch let verificationError {
                var errorDescription = verificationError.localizedDescription
                if let verificationError = verificationError as? OktaJWTVerificationError, let description = verificationError.errorDescription {
                    errorDescription = description
                }
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error", message: errorDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
        let sessionConfig = URLSessionConfiguration.default
        let authValue: String = "Bearer \(stateManager?.accessToken ?? "error")"
        sessionConfig.httpAdditionalHeaders = ["authorization": authValue, "accept": "application/json", "content-type": "application/json"]
        let session = URLSession(configuration: sessionConfig,
                                 delegate: self as? URLSessionDelegate,
                                 delegateQueue: nil)
        
        if (self.states == nil) {
            // load states from database
            let request = NSMutableURLRequest(url: URL(string: "http://18.219.89.231:4000/states")!)
            request.httpMethod = "GET"
            let task = session.dataTask(with: request as URLRequest) {
                (data, response, error) in
                if ((error) != nil) {
                    print("Error in http request")
                } else {
                    let decoder = JSONDecoder()
                    let result = try! decoder.decode(StatesArray.self, from: data!)
                    self.states = result
                    if (self.cities?.data.count ?? 0 > 0 && self.states?.data.count ?? 0 > 0) {
                        DispatchQueue.main.async {
                            self.activityIndicator.isHidden = true
                            self.manualEntryBtn.isHidden = false
                            self.automaticEntryBtn.isHidden = false
                        }
                    }
                }
            }
            task.resume()
        }
        
        if (self.cities == nil) {
            // load cities from database
            let request2 = NSMutableURLRequest(url: URL(string: "http://18.219.89.231:4000/cities")!)
            request2.httpMethod = "GET"
            let task2 = session.dataTask(with: request2 as URLRequest) {
                (data, response, error) in
                if ((error) != nil) {
                    print("Error in http request")
                } else {
                    let decoder = JSONDecoder()
                    let result = try! decoder.decode(CitiesArray.self, from: data!)
                    self.cities = result
                    if (self.cities?.data.count ?? 0 > 0 && self.states?.data.count ?? 0 > 0) {
                        DispatchQueue.main.async {
                            self.activityIndicator.isHidden = true
                            self.manualEntryBtn.isHidden = false
                            self.automaticEntryBtn.isHidden = false
                        }
                    }
                }
            }
            task2.resume()
        }
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? ManualEntryViewController {
            destinationViewController.oktaOidc = self.oktaOidc
            destinationViewController.stateManager = self.stateManager
            destinationViewController.cities = self.cities
            destinationViewController.states = self.states
            destinationViewController.locationManager = self.locationManager
        } else if let destinationViewController = segue.destination as? AutomaticEntryViewController {
            destinationViewController.oktaOidc = self.oktaOidc
            destinationViewController.stateManager = self.stateManager
            destinationViewController.locationManager = self.locationManager
            destinationViewController.cities = self.cities
            destinationViewController.states = self.states
        }
    }
    
    private func loadUserInfo() {
        stateManager?.getUser { [weak self] response, error in
            DispatchQueue.main.async {
                guard let response = response else {
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                    return
                }
                self?.updateUI(info: response)
            }
        }
    }
    
    private func updateUI(info: [String:Any]?) {
        titleLabel.text = "Welcome, \(info?["given_name"] as? String ?? "")"
        subtitleLabel.text = info?["preferred_username"] as? String
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!

    @IBAction func manualEntryTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "show-manual-entry", sender: self)
    }
    
    @IBAction func automaticEntryTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "show-auto-entry", sender: self)
    }
    
    
    @IBAction func signOutTapped(_ sender: Any) {
        guard let oktaOidc = self.oktaOidc,
        let stateManager = self.stateManager else { return }
            
        oktaOidc.signOutOfOkta(stateManager, from: self, callback: { [weak self] error in
            if let error = error {
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
                return
            }
            
            self?.stateManager?.clear()

            self?.navigationController?.popViewController(animated: true)
        })
    }
}
