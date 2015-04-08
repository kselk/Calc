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
    
}


extension String {
    
    var fromBase10toDouble: Double {
        return NSNumberFormatter().numberFromString(self)!.doubleValue
    }
    var fromBase16toDouble: Double {
        return 1.2
    }
    var fromBase2toDouble: Double {
        return 101
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
        currentBase = sender.currentTitle!
        baseDisplay.text =  currentBase ;
        enter()
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
            
            if (NSNumberFormatter().numberFromString(display.text!) != nil){
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
            else {
                return nil
            }
        }
        set {
            if newValue != nil {
                display.text = "\(newValue!)"
                //            userIsInTheMiddleOfTypingNumber = false
            }
            else {
                clear()
            }
        }
    }






}










































