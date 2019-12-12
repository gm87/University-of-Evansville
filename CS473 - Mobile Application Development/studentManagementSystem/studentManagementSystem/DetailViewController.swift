//
//  DetailViewController.swift
//  studentManagementSystem
//
//  Created by Graham Matthews on 10/11/19.
//  Copyright © 2019 Graham Matthews. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailTitle: UINavigationItem!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBAction func editButton(_ sender: Any) {
        showInputDialog()
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let label = detailTitle {
                label.title = detail.lName! + ", " + detail.fName!
            }
            if let label = emailLabel {
                label.text = detail.email
            }
            if let label = phoneLabel {
                label.text = detail.phone
            }
            if let label = addressLabel {
                label.text = detail.addr
            }
            if let label = idLabel {
                label.text = detail.id
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
    }

    var detailItem: Student? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    func showInputDialog() {
        //Creating UIAlertController and
        //Setting title and message for the alert dialog
        if let detail = detailItem {
            let alertController = UIAlertController(title: "Enter details", message: "Enter student details", preferredStyle: .alert)
            
            //the confirm action taking the inputs
            let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
                
                //getting the input values from user
                let fname = alertController.textFields?[0].text
                let lname = alertController.textFields?[1].text
                let email = alertController.textFields?[2].text
                let id = alertController.textFields?[3].text
                let phone = alertController.textFields?[4].text
                let addr = alertController.textFields?[5].text
                
                detail.fName = fname
                detail.lName = lname
                detail.email = email
                detail.id = id
                detail.phone = phone
                detail.addr = addr
            }
            
            //the cancel action doing nothing
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
            
            //adding textfields to our dialog box
            alertController.addTextField { (textField) in
                textField.placeholder = "Enter First Name"
            }
            alertController.addTextField { (textField) in
                textField.placeholder = "Enter Last Name"
            }
            alertController.addTextField { (textField) in
                textField.placeholder = "Enter E-Mail"
            }
            alertController.addTextField { (textField) in
                textField.placeholder = "Enter ID"
            }
            alertController.addTextField { (textField) in
                textField.placeholder = "Enter Phone"
            }
            alertController.addTextField { (textField) in
                textField.placeholder = "Enter Address"
            }
            
            //adding the action to dialogbox
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            
            //finally presenting the dialog box
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

