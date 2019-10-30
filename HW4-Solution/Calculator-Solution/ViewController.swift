//
//  ViewController.swift
//  HW3-Solution
//
//  Created by Jonathan Engelsma on 9/7/18.
//  Copyright © 2018 Jonathan Engelsma. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SettingsViewControllerDelegate {

    @IBOutlet weak var fromField: UITextField!
    @IBOutlet weak var toField: UITextField!
    @IBOutlet weak var fromUnits: UILabel!
    @IBOutlet weak var toUnits: UILabel!
    @IBOutlet weak var calculatorHeader: UILabel!
    
    var currentMode : CalculatorMode = .Length
    
    var entries : [Conversion] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toField.delegate = self
        fromField.delegate = self
        self.view.backgroundColor = BACKGROUND_COLOR
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    @IBAction func calculatePressed(_ sender: UIButton) {
        // determine source value of data for conversion and dest value for conversion
        var dest : UITextField?

        var val = ""
        
        if let fromVal = fromField.text {
            if fromVal != "" {
                val = fromVal
                dest = toField
               // conObj.toUnits = fromField.text!
            }
        }
        if let toVal = toField.text {
            if toVal != "" {
                val = toVal
                dest = fromField
            }
        }
        if dest != nil {
            switch(currentMode) {
            case .Length:
                var fUnits, tUnits : LengthUnit
                if dest == toField {
                    fUnits = LengthUnit(rawValue: fromUnits.text!)!
                    tUnits = LengthUnit(rawValue: toUnits.text!)!
                } else {
                    fUnits = LengthUnit(rawValue: toUnits.text!)!
                    tUnits = LengthUnit(rawValue: fromUnits.text!)!
                }
                if let fromVal = Double(val) {
                    let convKey =  LengthConversionKey(toUnits: tUnits, fromUnits: fUnits)
                    let toVal = fromVal * lengthConversionTable[convKey]!;
                    dest?.text = "\(toVal)"
                    
                    entries.append(Conversion(fromVal: fromVal, toVal: toVal, mode: .Length, fromUnits: fUnits.rawValue, toUnits: tUnits.rawValue, timestamp: Date()))
                }
                
            case .Volume:
                var fUnits, tUnits : VolumeUnit
                if dest == toField {
                    fUnits = VolumeUnit(rawValue: fromUnits.text!)!
                    tUnits = VolumeUnit(rawValue: toUnits.text!)!
                } else {
                    fUnits = VolumeUnit(rawValue: toUnits.text!)!
                    tUnits = VolumeUnit(rawValue: fromUnits.text!)!
                }
                if let fromVal = Double(val) {
                    let convKey =  VolumeConversionKey(toUnits: tUnits, fromUnits: fUnits)
                    let toVal = fromVal * volumeConversionTable[convKey]!;
                    dest?.text = "\(toVal)"
                    
                    entries.append(Conversion(fromVal: fromVal, toVal: toVal, mode: .Volume, fromUnits: fUnits.rawValue, toUnits: tUnits.rawValue, timestamp: Date()))
                }

            }
        }
        
        
        
        self.view.endEditing(true)
    }
    
    @IBAction func clearPressed(_ sender: UIButton) {
        self.fromField.text = ""
        self.toField.text = ""
        self.view.endEditing(true)
    }
    
    @IBAction func modePressed(_ sender: UIButton) {
        clearPressed(sender)
        switch (currentMode) {
        case .Length:
            currentMode = .Volume
            fromUnits.text = VolumeUnit.Gallons.rawValue
            toUnits.text = VolumeUnit.Liters.rawValue
            fromField.attributedPlaceholder =
                NSAttributedString(string: "Enter volume in \(fromUnits.text!)", attributes: [NSAttributedString.Key.foregroundColor :
                    FOREGROUND_COLOR])
            fromField.attributedPlaceholder =
                NSAttributedString(string: "Enter volume in \(toUnits.text!)", attributes: [NSAttributedString.Key.foregroundColor :
                    FOREGROUND_COLOR])
        case .Volume:
            currentMode = .Length
            fromUnits.text = LengthUnit.Yards.rawValue
            toUnits.text = LengthUnit.Meters.rawValue
            fromField.attributedPlaceholder =
                NSAttributedString(string: "Enter length in \(fromUnits.text!)", attributes: [NSAttributedString.Key.foregroundColor :
                    FOREGROUND_COLOR])
            fromField.attributedPlaceholder =
                NSAttributedString(string: "Enter length in \(toUnits.text!)", attributes: [NSAttributedString.Key.foregroundColor :
                    FOREGROUND_COLOR])
        }

        calculatorHeader.text = "\(currentMode.rawValue) Conversion Calculator"
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settingsSegue" {
            clearPressed(sender as! UIButton)
            if let target = segue.destination as? SettingsViewController {
                target.mode = currentMode
                target.fUnits = fromUnits.text
                target.tUnits = toUnits.text
                target.delegate = self
            }
        }
        
        if segue.identifier == "historySegue" {
            clearPressed(sender as! UIButton)
            if let target = segue.destination as? HistoryTableViewController {
                target.entries = entries
            }
        }
    }

    func settingsChanged(fromUnits: LengthUnit, toUnits: LengthUnit)
    {
        self.fromUnits.text = fromUnits.rawValue
        self.toUnits.text = toUnits.rawValue
    }
    
    func settingsChanged(fromUnits: VolumeUnit, toUnits: VolumeUnit)
    {
        self.fromUnits.text = fromUnits.rawValue
        self.toUnits.text = toUnits.rawValue
    }
    
    func saveConversion(fromVal: Double, toVal: Double, mode: CalculatorMode, fUnits fromUnits: String, toUnits: String, timestamp: Date)
    {
        entries.append(Conversion.init(fromVal: fromVal, toVal: toVal, mode: mode, fromUnits: fromUnits, toUnits: toUnits, timestamp: timestamp))
    }
}

extension ViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField == toField) {
            fromField.text = ""
        } else {
            toField.text = ""
        }
    }
}

