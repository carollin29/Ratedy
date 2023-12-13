//
//  RateViewController.swift
//  Ratedy
//
//  Created by Carol Lin on 2023/10/20.
//

import UIKit

class RateViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, RateManagerDelegate {
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var topCurrencyTextField: UITextField!
    @IBOutlet weak var topCurrencyPicker: UIPickerView!
    
    @IBOutlet weak var bottomCurrencyTextField: UITextField!
    @IBOutlet weak var bottomCurrencyPicker: UIPickerView!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    
    
    
    var rateManager = RateManager()
    var baseCurrency: String?
    var targetCurrency: String?
    var enteredAmount: Double?
    
    var debounceTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        amountTextField.delegate = self
        topCurrencyTextField.delegate = self
        bottomCurrencyTextField.delegate = self
        
        topCurrencyPicker.dataSource = self
        bottomCurrencyPicker.dataSource = self
        
        topCurrencyPicker.delegate = self
        bottomCurrencyPicker.delegate = self
        
        rateManager.delegate = self
        
        topCurrencyPicker.isHidden = true
        bottomCurrencyPicker.isHidden = true
        
        // Set the inputView for the picker text fields
        topCurrencyTextField.inputView = topCurrencyPicker
        bottomCurrencyTextField.inputView = bottomCurrencyPicker
        
        // Add a tap gesture recognizer to dismiss the keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func dismissKeyboard() {
            view.endEditing(true)
        }
    
    @IBAction func resetButton(_ sender: UIButton) {
        resetView()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == topCurrencyTextField {
            topCurrencyPicker.isHidden = false
            bottomCurrencyPicker.isHidden = true
            topCurrencyPicker.selectRow(0, inComponent: 0, animated: true)
        } else if textField == bottomCurrencyTextField {
            bottomCurrencyPicker.isHidden = false
            topCurrencyPicker.isHidden = true
            bottomCurrencyPicker.selectRow(0, inComponent: 0, animated: true)
        } else if textField == amountTextField {
            amountTextField.text = ""
            enteredAmount = nil
            resultLabel.text = "0"
        }
        
        return true
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == amountTextField {
            // Handle changes in the amount text field
            if let newAmount = Double((textField.text ?? "") + string) {
                enteredAmount = newAmount
            }
            // Debounce the conversion request
            debounceTimer?.invalidate()
            debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false) { _ in
                self.performConversion()
            }
        }
        
        return true
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == topCurrencyPicker {
            baseCurrency = rateManager.currencyArray[row]
            topCurrencyTextField.text = baseCurrency
            topCurrencyPicker.isHidden = true
        } else if pickerView == bottomCurrencyPicker {
            targetCurrency = rateManager.currencyArray[row]
            bottomCurrencyTextField.text = targetCurrency
            bottomCurrencyPicker.isHidden = true
        }
        if let enteredAmount, let baseCurrency, let targetCurrency {
            rateManager.fetchRate(base: baseCurrency, target: targetCurrency, baseAmount: enteredAmount)
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return rateManager.currencyArray[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return rateManager.currencyArray.count
    }
    
    func didUpdateAmount(_ rateManager: RateManager, resultAmount: RateModel) {
        DispatchQueue.main.async {
                self.resultLabel.text = resultAmount.resultAmountString
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func resetView() {
        // Reset entered values
        enteredAmount = nil
        baseCurrency = nil
        targetCurrency = nil
        
        // Reset text fields
        amountTextField.text = ""
        topCurrencyTextField.text = ""
        bottomCurrencyTextField.text = ""
        resultLabel.text = "0"
        
        // Reload picker views to reset their selection state
        topCurrencyPicker.reloadAllComponents()
        bottomCurrencyPicker.reloadAllComponents()
        
        // Hide pickers
        topCurrencyPicker.isHidden = true
        bottomCurrencyPicker.isHidden = true
    }
    
    func performConversion() {
        // Handle any other logic based on the entered amount
        if let enteredAmount, let baseCurrency, let targetCurrency {
            rateManager.fetchRate(base: baseCurrency, target: targetCurrency, baseAmount: enteredAmount)
        }
    }
        
        
}
