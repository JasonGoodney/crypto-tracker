//
//  CoinRanking.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 2/27/21.
//

import Foundation

struct CoinRanking {
    struct Root<T: Codable>: Codable {
        let data: T
    }
}
