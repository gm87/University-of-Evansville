//
//  ContactInfoViewController.swift
//  outreachTrackingTool
//
//  Created by Graham Matthews on 2/22/20.
//  Copyright © 2020 Graham Matthews. All rights reserved.
//

import UIKit
import OktaOidc

extension UIViewController {
    func hideKeyboardWhenBackgroundTapped() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}

class ContactInfoViewController: UIViewController, UITextFieldDelegate {
    
    var candidateData: CandidateData?
    var states: StatesArray?
    var cities: CitiesArray?
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var address1Field: UITextField!
    @IBOutlet weak var address2Field: UITextField!
    @IBOutlet weak var statePicker: UIPickerView!
    @IBOutlet weak var cityPicker: UIPickerView!
    @IBOutlet weak var websiteField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstNameField.text = candidateData?.getFirstName()
        lastNameField.text = candidateData?.getLastName()
        phoneField.text = candidateData?.getPhone()
        emailField.text = candidateData?.getEmail()
        address1Field.text = candidateData?.getAddress1()
        address2Field.text = candidateData?.getAddress2()
        websiteField.text = candidateData?.website
        configure()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statePicker.dataSource = self
        statePicker.delegate = self
        cityPicker.dataSource = self
        cityPicker.delegate = self
        firstNameField.delegate = self
        lastNameField.delegate = self
        phoneField.delegate = self
        emailField.delegate = self
        address1Field.delegate = self
        address2Field.delegate = self
        
        self.hideKeyboardWhenBackgroundTapped()
        statePicker.selectRow((candidateData?.getStateRowId())! > 0 ? (candidateData?.getStateRowId())! : 0, inComponent: 0, animated: true)
        cityPicker.selectRow((candidateData?.getCityRowId())! > 0 ? (candidateData?.getCityRowId())! : 0, inComponent: 0, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let selectedRowInt = cityPicker.selectedRow(inComponent: 0)
        let cityId = (cities?.filterByStateId(id: (candidateData?.getStateId())!)[selectedRowInt].id)!
        let cityName = (cities?.filterByStateId(id: (candidateData?.getStateId())!)[selectedRowInt].name)!
        candidateData?.updateCityId(id: cityId)
        candidateData?.updateCityRowId(id: selectedRowInt)
        candidateData?.city = cityName
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == firstNameField) {
            firstNameField.resignFirstResponder()
            lastNameField.becomeFirstResponder()
        } else if (textField == lastNameField) {
            lastNameField.resignFirstResponder()
            emailField.becomeFirstResponder()
        } else if (textField == emailField) {
            emailField.resignFirstResponder()
            phoneField.becomeFirstResponder()
        } else if (textField == phoneField) {
            phoneField.resignFirstResponder()
            websiteField.becomeFirstResponder()
        } else if (textField == websiteField) {
            websiteField.resignFirstResponder()
            address1Field.becomeFirstResponder()
        } else if (textField == address1Field) {
            address1Field.resignFirstResponder()
            address2Field.becomeFirstResponder()
        } else if (textField == address2Field) {
            address2Field.resignFirstResponder()
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func doneEditingFirstName(_ sender: Any) {
        candidateData?.updatefName(firstName: firstNameField.text ?? "")
    }
    
    @IBAction func doneEditingLastName(_ sender: Any) {
        candidateData?.updatelName(lastName: lastNameField.text ?? "")
    }
    
    @IBAction func doneEditingPhone(_ sender: Any) {
        candidateData?.updatePhone(phone: phoneField.text ?? "")
    }
    
    @IBAction func doneEditingEmail(_ sender: Any) {
        candidateData?.updateEmail(email: emailField.text ?? "")
    }
    
    @IBAction func doneEditingAddress1(_ sender: Any) {
        candidateData?.updateAddress1(address1: address1Field.text ?? "")
    }
    
    @IBAction func doneEditingAddress2(_ sender: Any) {
        candidateData?.updateAddress2(address2: address2Field.text ?? "")
    }
    
    @IBAction func doneEditingWebsite(_ sender: Any) {
        candidateData?.website = websiteField.text ?? ""
    }
}

extension ContactInfoViewController:UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView == statePicker) {
            return (states?.data.count)!
        } else if (pickerView == cityPicker) {
            let stateId = candidateData?.getStateId()
            return (cities?.filterByStateId(id: stateId!).count ?? 0 )
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView == statePicker) {
            candidateData?.updateStateId(id: (states?.data[row].id)!)
            candidateData?.updateStateRowId(id: statePicker.selectedRow(inComponent: 0))
            candidateData?.updateCityRowId(id: 1)
            candidateData?.state = states?.data[row].abbreviation ?? ""
            cityPicker.reloadAllComponents()
            cityPicker.selectRow(0, inComponent: 0, animated: false)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView == statePicker) {
            return states?.data[row].name
        } else if (pickerView == cityPicker) {
            return cities?.filterByStateId(id: (candidateData?.getStateId())!)[row].name
        }
        return ("NIL")
    }
}

private extension ContactInfoViewController {
    func configure() {
        guard isViewLoaded else { return }
        /*
        let candidateData = self.candidateData
        let states = self.states
        */
    }
}
