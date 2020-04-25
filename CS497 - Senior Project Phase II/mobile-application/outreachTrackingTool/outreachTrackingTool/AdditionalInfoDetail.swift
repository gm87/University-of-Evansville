//
//  AdditionalInfoDetail.swift
//  outreachTrackingTool
//
//  Created by Graham Matthews on 2/22/20.
//  Copyright © 2020 Graham Matthews. All rights reserved.
//

import UIKit
import OktaOidc

class AdditionalInfoDetail:UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let titleField = titleTextField {
                titleField.text = detail.title
            }
            if let descField = descriptionTextField {
                descField.text = detail.description
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        self.hideKeyboardWhenBackgroundTapped()
        titleTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == titleTextField) {
            titleTextField.resignFirstResponder()
            descriptionTextField.becomeFirstResponder()
        }
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        detailItem?.updateTitle(title: titleTextField.text ?? "")
        detailItem?.updateDescription(description: descriptionTextField.text ?? "")
    }
    
    var detailItem: AdditionalInfo? {
        didSet {
            // Update the view.
            configureView()
        }
    }
}
