//
//  RateManager.swift
//  Ratedy
//
//  Created by Carol Lin on 2023/10/20.
//

import Foundation

protocol RateManagerDelegate {
    func didUpdateAmount(_ rateManager: RateManager, resultAmount: RateModel)
    func didFailWithError(error: Error)
}

struct RateManager {
    
    let currencyURL = "https://exchange-rates.abstractapi.com/v1/convert/?api_key= Abstract API"
    
    let currencyArray = ["Select","USD","EUR","JPY","BGN","CZK","DKK","GBP","HUF","PLN","RON","SEK","CHF","ISK","NOK","HRK","RUB","TRY","AUD","BRL","CAD","CNY","HKD","IDR","ILS","INR","KRW","MXN","MYR","NZD","PHP","SGD","THB","ZAR","ARS","DZD","MAD","TWD","BTC","ETH","BNB","DOGE","XRP","BCH","LTC"]
    
    var delegate: RateManagerDelegate?
    
    func fetchRate(base: String, target: String, baseAmount: Double) {
        let urlString = "\(currencyURL)&base=\(base)&target=\(target)&base_amount=\(baseAmount)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let dataResult = parseJSON(with: safeData) {
                        self.delegate?.didUpdateAmount(self, resultAmount: dataResult)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON( with rateData: Data) -> RateModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(RateData.self, from: rateData)
            let convertedAmount = decodedData.converted_amount
            let finalAmount = RateModel(resultAmount: convertedAmount)
            
            print(finalAmount)

            return finalAmount
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}

