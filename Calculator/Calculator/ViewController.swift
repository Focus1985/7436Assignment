//
//  ViewController.swift
//  Calculator
//
//  Created by Focus on 9/09/19.
//  Copyright © 2019 Focus. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        display.text = String(Int(numberOnScreen))
    }
    var numberOnScreen:Double = 0
    var previousNumber:Double = 0
    var calculation:Bool = false
    var inputNumber:[String] = []
    var operation = 0
    
    @IBOutlet weak var display: UILabel!
    @IBAction func numbers(_ sender: UIButton) {
        
  
        if calculation == true
        {
            inputNumber.append(String(sender.tag - 1))
            display.text = inputNumber.joined(separator: "")
            numberOnScreen = Double(display.text!)!
            calculation = false
        }
        
        else
        {
            inputNumber.append(String(sender.tag - 1))
            display.text = inputNumber.joined(separator: "")
            numberOnScreen = Double(display.text!)!
        }
        
        if inputNumber[0] == "0"
        {
            inputNumber.removeFirst()
        }
        
        
    }
    
    
    @IBAction func calculateOperation(_ sender: UIButton) {
        previousNumber = Double(display.text!)!
        operation = sender.tag
        calculation = true
        inputNumber.removeAll()
    }
    
    
    @IBAction func equals(_ sender: UIButton) {
        switch operation
        {
        case 17 :
            display.text = String(previousNumber + numberOnScreen)
        case 16 :
            display.text = String(previousNumber - numberOnScreen)
        case 15 :
            display.text = String(previousNumber * numberOnScreen)
        case 14:
            Divide()
        default:
            ResetToDefault()
        }
        
        inputNumber.removeAll()

    }
    
    @IBAction func reset(_ sender: UIButton) {
        ResetToDefault()
    }
    
    func Divide(){
        if numberOnScreen == 0
        {
            display.text = "Error!"
        }
        else
        {
            display.text = String(previousNumber / numberOnScreen)
        }
    }
    
    func ResetToDefault(){
        numberOnScreen = 0
        previousNumber = 0
        calculation = false
        operation = 0
        display.text = String(Int(numberOnScreen))
        inputNumber.removeAll()
    }
    
   
    



}

