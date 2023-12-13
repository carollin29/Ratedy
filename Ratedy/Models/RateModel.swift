//
//  RateModel.swift
//  Ratedy
//
//  Created by Carol Lin on 2023/10/23.
//

import Foundation

struct RateModel {
    let resultAmount: Double
    
    var resultAmountString: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2 // Adjust the number of decimal places as needed
        
        return numberFormatter.string(from: NSNumber(value: resultAmount)) ?? ""
    }
    
}
