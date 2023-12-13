//
//  RateData.swift
//  Ratedy
//
//  Created by Carol Lin on 2023/10/23.
//

import Foundation

struct RateData: Codable {
    let base: String
    let target: String
    let base_amount: Int
    let converted_amount: Double
    let exchange_rate: Double
}







