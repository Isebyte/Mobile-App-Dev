//
//  ViewController.swift
//  IsabelleXu-Lab1
//
//  Created by Isabelle Xu on 9/6/18.
//  Copyright © 2018 WashU. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var finalPrice: UILabel!
    @IBOutlet weak var discount: UITextField!
    @IBOutlet weak var salesTax: UITextField!
    @IBOutlet weak var originalPrice: UITextField!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var stackView: UIStackView!
    
    struct GlobalVariables {
        static var globalPriceArray = [Float]()
    }
    
    func checkMaxOrig() {
        let floatOriginalPrice :Float? = Float(originalPrice.text!)
        // Set maximums
        if floatOriginalPrice != nil {
            if floatOriginalPrice! >= Float(1000000000) {
                originalPrice.text = "1000000000"
            }
        }
    }
    
    func checkMaxDiscount() {
        let floatDiscount :Float? = Float(discount.text!)
        if floatDiscount != nil {
            if floatDiscount! >= Float(100) {
                discount.text = "100"
            }
        }
    }
    
    func checkMaxSalesTax() {
        let floatSalesTax : Float? = Float(salesTax.text!)
        if floatSalesTax != nil {
            if floatSalesTax! >= Float(100) {
                salesTax.text = "100"
            }
        }
    }
    
    func checkChar() {
        // strips non numerical characters from string
        if  originalPrice.text != nil {
             originalPrice.text = String( originalPrice.text!.filter { "01234567890.".contains($0) })
        }
        if discount.text != nil { // no decimals allowed in discount
            discount.text = String(discount.text!.filter { "01234567890".contains($0) })
        }
        if salesTax.text != nil {
              salesTax.text = String(salesTax.text!.filter { "01234567890.".contains($0) })
        }
    }
    
    @IBAction func updateFinalPrice(_ sender: UITextField) {
        checkChar()
        
        // If change in UITextField, update final Item Price
        let floatOriginalPrice :Float? = Float(originalPrice.text!)
        let floatDiscount :Float? = Float(discount.text!)
        let floatSalesTax : Float? = Float(salesTax.text!)
        var finalPriceNum : Float = 0.0
        var displayText = ""
        
        // check conditions where value box may be nil or <= 0 (although keyboard type shouldn't allow negatives anyways)
        if floatOriginalPrice == nil || floatOriginalPrice! <= Float(0) {
            displayText = "$0.00"
        } else if floatDiscount == nil || floatDiscount! <= Float(0) {
            if floatSalesTax == nil || floatSalesTax! <= Float(0) {
                checkMaxOrig()
                finalPriceNum = floatOriginalPrice!
            } else {
                checkMaxOrig()
                checkMaxSalesTax()
                finalPriceNum = floatOriginalPrice! + (floatOriginalPrice! * (floatSalesTax! * 0.01))
            }
        } else if floatSalesTax == nil || floatSalesTax! <= Float(0) {
            checkMaxOrig()
            checkMaxDiscount()
            finalPriceNum = (floatOriginalPrice! - (floatOriginalPrice! * (floatDiscount! * 0.01)))
        } else {
            checkMaxOrig()
            checkMaxSalesTax()
            checkMaxDiscount()
            let dPrice = (floatOriginalPrice! - (floatOriginalPrice! * (floatDiscount! * 0.01)))
            finalPriceNum = dPrice + (dPrice * (floatSalesTax! * 0.01))
            
        }
        displayText = "$\(String(format: "%.2f", finalPriceNum))"
        finalPrice.text = displayText
        
    }
    
    @IBAction func addPrice(_ sender: UIButton) {
        // Creative Portion: Add label of price to Stack View; max of 10 prices
        // remove dollar sign from number
        if GlobalVariables.globalPriceArray.count == 10 {
            // alert user that max prices hit
            let alert = UIAlertController(title: "Max", message: "Maximum of 10 prices added!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let finalPriceNum = finalPrice.text!.trimmingCharacters(in: CharacterSet(charactersIn: "01234567890.").inverted)
            let floatFinalPrice: Float? = Float(finalPriceNum)
            if floatFinalPrice != 0 && floatFinalPrice != nil {
                // add to global array
                GlobalVariables.globalPriceArray.append(floatFinalPrice!)
                let displayText = "$\(String(format: "%.2f", floatFinalPrice!))"
                
                // create new text label
                let textLabel = UILabel()
                textLabel.backgroundColor = UIColor.white
                if itemName.text != nil {
                    textLabel.text  = itemName.text! + " " + displayText
                } else {
                    textLabel.text  = "Unnamed Item: " + displayText
                }
                
                textLabel.textAlignment = .center
                
                stackView.addArrangedSubview(textLabel)
                
                calculateAndRenderTotal()
            }
        }
        
    }
    
    func calculateAndRenderTotal() {
        // Loops through price array then calculates and updates view
        var total: Float = 0;
        GlobalVariables.globalPriceArray.forEach { item in
            total += item;
        }
        // Round total sum
        let displayText = "$\(String(format: "%.2f", total))"
        totalPrice.text = displayText;
    }

    
    @IBAction func reset(_ sender: Any) {
        // empty global array of prices and stackView
        if GlobalVariables.globalPriceArray.count > 0 { // check to make sure stackView is not empty
            for v in stackView.subviews{
                v.removeFromSuperview()
            }
        }
        GlobalVariables.globalPriceArray.removeAll();
        
        
        totalPrice.text = "$0.00"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
    }
    
    // Closes keyboard when background touched
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

