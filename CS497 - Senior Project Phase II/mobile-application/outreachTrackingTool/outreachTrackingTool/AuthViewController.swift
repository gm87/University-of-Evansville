//
//  AuthViewControllers.swift
//  outreachTrackingTool
//
//  Created by Graham Matthews on 2/4/20.
//  Copyright © 2020 Graham Matthews. All rights reserved.
//

import OktaOidc
import UIKit

final class AuthViewController: UIViewController {
    
    var oktaOidc: OktaOidc?
    var stateManager: OktaOidcStateManager?
    @IBOutlet weak var signInBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInBtn.layer.cornerRadius = 5
        signInBtn.layer.borderWidth = 1
        signInBtn.layer.borderColor = UIColor.black.cgColor
        navigationItem.hidesBackButton = true
        do {
            oktaOidc = try OktaOidc()
        } catch let error {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            return
        }
        
        if  let oktaOidc = oktaOidc,
            let _ = OktaOidcStateManager.readFromSecureStorage(for: oktaOidc.configuration)?.accessToken {
            self.stateManager = OktaOidcStateManager.readFromSecureStorage(for: oktaOidc.configuration)
            performSegue(withIdentifier: "show-new-entry", sender: self)
        }
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        oktaOidc?.signInWithBrowser(from: self, callback: { [weak self] stateManager, error in
            if let error = error {
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
                return
            }
            self?.stateManager?.clear()
            self?.stateManager = stateManager
            self?.stateManager?.writeToSecureStorage()
            self?.performSegue(withIdentifier: "show-new-entry", sender: self)
        })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? SignInViewController {
            destinationViewController.oktaOidc = self.oktaOidc
            destinationViewController.stateManager = self.stateManager
        }
    }
    
}
