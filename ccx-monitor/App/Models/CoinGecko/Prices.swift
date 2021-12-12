//
//  Prices.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 3/29/21.
//

import Foundation

extension CoinGecko {
    
    struct Prices: Codable {
        private let pricesData: [[Double]]
        
        var prices: [PriceItem] {
            pricesData.map { PriceItem(timestamp: $0.first!, price: $0.last! )}
        }
        
        enum CodingKeys: String, CodingKey {
            case pricesData = "prices"
        }
    }
    
    struct PriceItem: Codable {
        
        let timestamp: TimeInterval
        let price: Double
    }
}
