//
//  WorkInfoDetail.swift
//  outreachTrackingTool
//
//  Created by Graham Matthews on 2/22/20.
//  Copyright © 2020 Graham Matthews. All rights reserved.
//

import UIKit
import OktaOidc
import MonthYearPicker

class WorkInfoDetail:UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var companyField: UITextField!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var beginDatePicker: MonthYearPickerView!
    @IBOutlet weak var endDatePicker: MonthYearPickerView!
    @IBOutlet weak var summary: UITextView!
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let company = companyField {
                company.text = detail.getName()
            }
            if let title = titleField {
                title.text = detail.getTitle()
            }
            if let beginDate = beginDatePicker {
                beginDate.date = detail.getBeginDate()
            }
            if let endDate = endDatePicker {
                endDate.date = detail.getEndDate()
            }
            if let summaryField = summary {
                summaryField.text = detail.getSummary()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        self.hideKeyboardWhenBackgroundTapped()
        companyField.delegate = self
        titleField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == companyField) {
            companyField.resignFirstResponder()
            titleField.becomeFirstResponder()
        } else if (textField == titleField) {
            titleField.resignFirstResponder()
        }
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.detailItem?.updateName(name: companyField.text ?? "")
        self.detailItem?.updateTitle(title: titleField.text ?? "")
        self.detailItem?.updateBeginDate(beginDate: beginDatePicker.date)
        self.detailItem?.updateEndDate(endDate: endDatePicker.date)
        self.detailItem?.updateSummary(summary: summary.text)
    }
    
    var detailItem: WorkExperience? {
        didSet {
            // Update the view.
            configureView()
        }
    }
}
