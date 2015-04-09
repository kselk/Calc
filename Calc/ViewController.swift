//
//  ViewController.swift
//  Calc
//
//  Created by eduardo on 3/5/15.
//  Copyright (c) 2015 eduardo. All rights reserved.
//

import UIKit
import Foundation

extension Double {
    
    var toBase10 : String {
        return "\(self)"
    }
    var toBase16 : String {
        return String( Int(self) , radix: 16).uppercaseString
    }
    
    var toBase2 : String {
        return String( Int(self) , radix: 2)
    }

    
}


extension String {
    
    var fromBase10toDouble: Double {
        // return NSNumberFormatter().numberFromString(self)!.doubleValue
        return Double(strtoul(self, nil, 10))
    }
    var fromBase16toDouble: Double {
        return  Double(strtoul(self, nil, 16))
    }
    var fromBase2toDouble: Double {
        return Double(strtoul(self, nil, 2))
    }
    
}


class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
    @IBOutlet weak var history: UILabel!
    
    @IBOutlet weak var baseDisplay: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    
    var brain = CalcBrain()
    
    var currentBase = "(10)"
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func decimal() {
        
        if (userIsInTheMiddleOfTypingANumber) {
            if (display.text!.rangeOfString(".") == nil){
                display.text = display.text! + "."
            }
        } else {
            display.text = "0."
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func base(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        
        currentBase = sender.currentTitle!
        baseDisplay.text =  currentBase
        }
    
    
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation){
                displayValue = result
            } else {
                displayValue = 0
            }
        }
        history.text = "\(brain)"
    }
    
    
    @IBAction func clear() {
        displayValue = 0
        brain.clear()
        history.text = "\(brain)"
        userIsInTheMiddleOfTypingANumber = false
    }
    
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if displayValue != nil{
            if let result = brain.pushOperand(displayValue!) {
                displayValue = result
            } else {
                displayValue = nil // want nil (need dV to be an optional)
            }

        } else {
            displayValue = nil // want nil (need dV to be an optional)
        }
        history.text = "\(brain)"
    }
    var displayValue: Double?{
        get {
            switch currentBase {
                case "(10)":
                    return display.text!.fromBase10toDouble
                case "(16)":
                    return display.text!.fromBase16toDouble
                case "(2)":
                    return display.text!.fromBase2toDouble
                default:
                    return nil
                }
            }
        
        set {
            if newValue != nil {
                
                switch currentBase {
                case "(10)":
                    display.text = newValue!.toBase10
                case "(16)":
                    display.text = newValue!.toBase16
                case "(2)":
                    display.text = newValue!.toBase2
                default:
                    display.text = "\(newValue!)"
                }
                
                //            userIsInTheMiddleOfTypingNumber = false
            }
            else {
                clear()
            }
        }
    }

}





