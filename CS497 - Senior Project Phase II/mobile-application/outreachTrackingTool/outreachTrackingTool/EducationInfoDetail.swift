//
//  EducationInfoDetail.swift
//  outreachTrackingTool
//
//  Created by Graham Matthews on 2/22/20.
//  Copyright © 2020 Graham Matthews. All rights reserved.
//

import UIKit
import OktaOidc
import MonthYearPicker

class EducationInfoDetail: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var institutionField: UITextField!
    @IBOutlet weak var beginDatePicker: MonthYearPickerView!
    @IBOutlet weak var endDatePicker: MonthYearPickerView!
    @IBOutlet weak var degreePicker: UIPickerView!
    @IBOutlet weak var summary: UITextView!
    @IBOutlet weak var fieldOfStudy: UITextField!
    
    let degreeTypes:[String] = ["Associate's", "Bachelor's", "Master's", "Doctorate"]
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let beginPicker = beginDatePicker {
                beginPicker.date = detail.getBeginDate()
            }
            if let endPicker = endDatePicker {
                endPicker.date = detail.getEndDate()
            }
            if let degPicker = degreePicker {
                degPicker.selectRow(detail.getDegreeRow(), inComponent: 0, animated: false)
            }
            if let institution = institutionField {
                institution.text = detail.getInstitution()
            }
            if let text = summary {
                text.text = detail.getSummary()
            }
            if let field = fieldOfStudy {
                field.text = detail.getFieldOfStudy()
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == institutionField) {
            institutionField.resignFirstResponder()
        } else if (textField == fieldOfStudy) {
            fieldOfStudy.resignFirstResponder()
            summary.becomeFirstResponder()
        }
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.detailItem?.updateBeginDate(beginDate: beginDatePicker.date)
        self.detailItem?.updateEndDate(endDate: endDatePicker.date)
        self.detailItem?.updateInstitution(institution: institutionField.text ?? "")
        self.detailItem?.updateDegreeRow(row: degreePicker.selectedRow(inComponent: 0))
        self.detailItem?.updateSummary(summary: summary.text)
        self.detailItem?.updateFieldOfStudy(field: fieldOfStudy.text ?? "")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        degreePicker.dataSource = self
        degreePicker.delegate = self
        institutionField.delegate = self
        fieldOfStudy.delegate = self
        summary.delegate = self
        self.hideKeyboardWhenBackgroundTapped()
        configureView()
    }
    
    var detailItem: EducationInfo? {
        didSet {
            // Update the view.
            configureView()
        }
    }
}

extension EducationInfoDetail:UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return degreeTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return degreeTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("Selected row " + degreeTypes[row])
    }
}
