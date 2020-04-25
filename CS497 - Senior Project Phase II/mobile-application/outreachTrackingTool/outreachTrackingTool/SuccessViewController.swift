//
//  SuccessViewController.swift
//  outreachTrackingTool
//
//  Created by Graham Matthews on 3/16/20.
//  Copyright © 2020 Graham Matthews. All rights reserved.
//

import UIKit
import OktaOidc

class SuccessViewController:UIViewController {
    var stateManager: OktaOidcStateManager?
    var oktaOidc: OktaOidc?
    var states: StatesArray?
    var cities: CitiesArray?
    @IBOutlet weak var returnHomeBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        returnHomeBtn.layer.cornerRadius = 5
        returnHomeBtn.layer.borderWidth = 1
        returnHomeBtn.layer.borderColor = UIColor.black.cgColor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? SignInViewController {
            destinationViewController.oktaOidc = self.oktaOidc
            destinationViewController.stateManager = self.stateManager
            destinationViewController.states = self.states
            destinationViewController.cities = self.cities
        }
    }
    
    @IBAction func pressedReturnHome(_ sender: Any) {
        self.performSegue(withIdentifier: "return-home", sender: self)
    }
    
}
