//
//  ROI.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 2/21/21.
//

import Foundation

extension CoinGecko {
    struct ROI: Codable {
        let currency: String
        let times: Double
        let percentage: Double
        
        enum CodingsKeys: String, CodingKey {
            case currency
            case times
            case percentage
        }
    }
}
