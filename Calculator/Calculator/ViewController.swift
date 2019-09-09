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
        // The begining of this application, I want the calculator to display a "0", the best place to get is the numberOnScreen varible
        // the label displays string, the numberOnScreen is a double -- 0.0, so type casting to integer then to string.
        display.text = String(Int(numberOnScreen))
    }
    
    var numberOnScreen:Double = 0 // number displayed on screen will be stored to this golbal varible.
    var previousNumber:Double = 0 // this varible will store whatever the number is before a operation is selected.
    var inputNumber:[String] = [] // a string array for storing the operand, they are all single digit numbers in string form
    var operation = 0 // the varible to store the operation sign value
    
    @IBOutlet weak var display: UILabel!
    
    //Action event for numeral buttons, from 0 to 9, the button tag is given value from 1 to 10, sender tag minus 1 gives the value that user want to input
    @IBAction func numbers(_ sender: UIButton) {
        
        inputNumber.append(String(sender.tag - 1)) //the string array appends the user input
        display.text = inputNumber.joined(separator: "") //assemble the array elements into one long string as an operand.
        numberOnScreen = Double(display.text!)! //cast the operand to double and assign to the numberOnScreen varible
        
        // the app started with "0" displayed, entering new digits will always have the 0 in front, or user can press "0" before other value on purpose
        // therefore this if statement is to check and remove the first element in the string array if there is a "0" presents.
        if inputNumber[0] == "0"
        {
            inputNumber.removeFirst()
        }
        
        
    }
    
    // button of operation + - * / will trigger this event listener, the tags value are 14, 15, 16, 17.
    @IBAction func calculateOperation(_ sender: UIButton) {
        //usually the user use a operation after a operand is decided. before that, if the user just came out from the divide by zero, the app will reset.
        if display.text == "Error!"
        {
         ResetToDefault()
        }
        previousNumber = Double(display.text!)! //so the content of display.text until now is the desired operand, it can be saved to the previous number.
        operation = sender.tag //the value of the button tag stays in operation varible, or perhaps we can use enums to do this project?
        inputNumber.removeAll() //clear the inputNumber string array for new inputs.
    }
    
    // the equal button is connect to this event listener
    @IBAction func equals(_ sender: UIButton) {
        //four cases, so we use switch or enum to deal with user requests.
        switch operation
        {
        
        case 17 :
            display.text = String(previousNumber + numberOnScreen)
        case 16 :
            display.text = String(previousNumber - numberOnScreen)
        case 15 :
            display.text = String(previousNumber * numberOnScreen)
        //incase the user triggers divide by zero error that may cause the app to crash, division will be handled with a function.
        case 14:
            Divide()
        // operation is unlikely to have other value, just in case, the exhaustive will be to reset.
        default:
            ResetToDefault()
        }
        
        inputNumber.removeAll()

    }
    
    // the clear button is tied to this event listener
    @IBAction func reset(_ sender: UIButton) {
        ResetToDefault()
    }
    
    // when user wishs to divide a number, we will check the number doesn't get divided by 0
    func Divide(){
        if numberOnScreen == 0
        {
            display.text = "Error!" //this will cause type cast unwrap to double fail, I have to make a if statement, reset if the operation button repeats
        }
        else
        {
            display.text = String(previousNumber / numberOnScreen)
        }
    }
    
    //master reset, call this to restore display to the intial stage.
    func ResetToDefault(){
        numberOnScreen = 0
        previousNumber = 0
        operation = 0
        display.text = String(Int(numberOnScreen))
        inputNumber.removeAll()
    }
    
   
    



}

