//
//  ViewController.swift
//  calculator
//
//  Created by Graham Matthews on 8/29/19.
//  Copyright © 2019 Graham Matthews. All rights reserved.
//

import UIKit

var calculator = Calculator()

class ViewController: UIViewController {

    var num = "0"
    var lastOp: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func pressOne(_ sender: UIButton) {
        updateLabel(pressed: "1")
    }
    @IBAction func pressTwo(_ sender: UIButton) {
        updateLabel(pressed: "2")
    }
    @IBAction func pressThree(_ sender: UIButton) {
        updateLabel(pressed: "3")
    }
    @IBAction func pressFour(_ sender: UIButton) {
        updateLabel(pressed: "4")
    }
    @IBAction func pressFive(_ sender: UIButton) {
        updateLabel(pressed: "5")
    }
    @IBAction func pressSix(_ sender: UIButton) {
        updateLabel(pressed: "6")
    }
    @IBAction func pressSeven(_ sender: UIButton) {
        updateLabel(pressed: "7")
    }
    @IBAction func pressEight(_ sender: UIButton) {
        updateLabel(pressed: "8")
    }
    @IBAction func pressNine(_ sender: UIButton) {
        updateLabel(pressed: "9")
    }
    @IBAction func pressZero(_ sender: UIButton) {
        updateLabel(pressed: "0")
    }
    @IBAction func pressClear(_ sender: UIButton) {
        num = "0"
        numLabel.text="0"
        calculator.clearNum1()
        calculator.clearNum2()
        calculator.clearLastOp()
    }
    @IBAction func pressDecimal(_ sender: UIButton) {
        if num.contains(".") {
            numLabel.text = "ERR"
            num = "0"
        }
        else if (num == "CLEARNEXT") {
            num = "0."
            numLabel.text=num
        }
        else {
            num += "."
            numLabel.text=num
        }
    }
    @IBAction func pressPlus(_ sender: UIButton) {
        if (num != "CLEARNEXT"){
            calculator.setNum1(x: Double(Double(num)!))
            displayAnswer(answer: calculator.calculate())
        }
        calculator.setLastOp(lastOp: "+")
        num = "CLEARNEXT"
    }
    @IBAction func pressMinus(_ sender: UIButton) {
        if (num != "CLEARNEXT") {
            calculator.setNum1(x: Double(Double(num)!))
            displayAnswer(answer: calculator.calculate())
        }
        calculator.setLastOp(lastOp: "-")
        num = "CLEARNEXT"
    }
    @IBAction func pressMult(_ sender: UIButton) {
        if (num != "CLEARNEXT") {
            calculator.setNum1(x: Double(Double(num)!))
            displayAnswer(answer: calculator.calculate())
        }
        calculator.setLastOp(lastOp: "*")
        num = "CLEARNEXT"
    }
    @IBAction func pressDiv(_ sender: UIButton) {
        if (num != "CLEARNEXT") {
            calculator.setNum1(x: Double(Double(num)!))
            displayAnswer(answer: calculator.calculate())
        }
        calculator.setLastOp(lastOp: "/")
        num = "CLEARNEXT"
    }
    @IBAction func pressSqrRt(_ sender: UIButton) {
        if (num != "CLEARNEXT") {
            calculator.setNum1(x: Double(Double(num)!))
        }
        displayAnswer(answer: calculator.sqrt())
        num = "CLEARNEXT"
    }
    @IBAction func pressInverse(_ sender: UIButton) {
        if (num != "CLEARNEXT") {
            calculator.setNum1(x: Double(Double(num)!))
        }
        displayAnswer(answer: calculator.inverse())
        num = "CLEARNEXT"
    }
    @IBAction func pressOpposite(_ sender: UIButton) {
        if (num != "CLEARNEXT") {
            if (Double(num)! < 0) { num = String(num.split(separator: "-")[0]) }
            else { num = "-" + num }
            numLabel.text = num
            calculator.setNum1(x: Double(Double(num)!))
        }
        else {
            displayAnswer(answer: calculator.opposite())
            num = "CLEARNEXT"
        }
    }
    @IBAction func pressSin(_ sender: UIButton) {
        if (num != "CLEARNEXT") {
            calculator.setNum1(x: Double(Double(num)!))
        }
        displayAnswer(answer: calculator.sinx())
        num = "CLEARNEXT"
    }
    @IBAction func pressCos(_ sender: UIButton) {
        if (num != "CLEARNEXT") {
            calculator.setNum1(x: Double(Double(num)!))
        }
        displayAnswer(answer: calculator.cosx())
        num = "CLEARNEXT"
    }
    @IBAction func pressTan(_ sender: UIButton) {
        if (num != "CLEARNEXT") {
            calculator.setNum1(x: Double(Double(num)!))
        }
        displayAnswer(answer: calculator.tanx())
        num = "CLEARNEXT"
    }
    @IBAction func pressEquals(_ sender: UIButton) {
        if (num != "CLEARNEXT"){
            calculator.setNum1(x: Double(Double(num)!))
            displayAnswer(answer: calculator.calculate())
        }
        calculator.clearLastOp()
        num = "CLEARNEXT"
    }
    func updateLabel(pressed: String) {
        if (num=="0" || num=="ERR" || num=="CLEARNEXT") {num = pressed}
        else { num += pressed }
        numLabel.text = num
    }
    func displayAnswer(answer: Double) {
        if (answer.truncatingRemainder(dividingBy:  1) == 0.0) {
            numLabel.text = String(Int(answer))
        }
        else {
            numLabel.text = String(answer)
        }
    }
    @IBOutlet weak var numLabel: UILabel!
}

