//
//  GlobalMarket.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 2/22/21.
//

import Foundation

extension CoinGecko {
    struct Root: Codable {
        let globalMarket: GlobalMarket

        enum CodingKeys: String, CodingKey {
            case globalMarket = "data"
        }
    }

    struct GlobalMarket: Codable {
        let activeCryptocurrencies: Int
        //        let upcomingIcos: Int
        //        let ongoingIcos: Int
        //        let endedIcos: Int
        let markets: Int
        //        let totalMarketCap: [String: Double]
        //        let totalVolume: [String: Double]
        let marketCapPercentage: [String: Double]
        let marketCapChangePercentage24HUsd: Double
        let updatedAt: Int

        //        var marketCap: Double {
        //            totalMarketCap.values.reduce(0) { $0 + $1 }
        //        }
        //
        var btcDominance: Double {
            marketCapPercentage["btc"]!
        }
    }
}
