//
//  Coin.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 2/21/21.
//

import UIKit

extension CoinGecko {
    struct CoinSimple: Codable, Identifiable {
        let id: String
        let symbol: String
        let name: String
    }
    
    struct Coin: Codable, Identifiable, Equatable, Hashable, Comparable {
        static func < (lhs: CoinGecko.Coin, rhs: CoinGecko.Coin) -> Bool {
            return lhs.name < rhs.name
        }

        static func == (lhs: CoinGecko.Coin, rhs: CoinGecko.Coin) -> Bool {
            return lhs.coinGeckoId == rhs.coinGeckoId
        }

        let id = UUID()
        var coinGeckoId: String = ""
        var symbol: String = ""
        var name: String = ""
        let image: String?
        var currentPrice: Double = 0
        let marketCap: Double?
        let marketCapRank: Int?
        let fullyDilutedValuation: Double?
        let totalVolume: Double?
        let high24H: Double?
        let low24H: Double?
        let priceChange24H: Double?
        let priceChangePercentage24H: Double?
        let marketCapChange24H: Double?
        let marketCapChangePercentage24H: Double?
        let circulatingSupply: Double?
        let totalSupply: Double?
        let maxSupply: Double?
        let ath: Double?
        let athChangePercentage: Double?
        let athDate: String?
        let atl: Double?
        let atlChangePercentage: Double?
        let atlDate: String?
        let lastUpdated: String?

        enum CodingKeys: String, CodingKey {
            case coinGeckoId = "id"
            case symbol
            case name
            case image
            case currentPrice
            case marketCap
            case marketCapRank
            case fullyDilutedValuation
            case totalVolume
            case high24H
            case low24H
            case priceChange24H
            case priceChangePercentage24H
            case marketCapChange24H
            case marketCapChangePercentage24H
            case circulatingSupply
            case totalSupply
            case maxSupply
            case ath
            case athChangePercentage
            case athDate
            case atl
            case atlChangePercentage
            case atlDate
            case lastUpdated
        }
    }
}

extension CoinGecko.Coin {
    static let example = CoinGecko.Coin(coinGeckoId: "bitcoin",
                                        symbol: "btc",
                                        name: "Bitcoin",
                                        image: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579",
                                        currentPrice: 54054.0,
                                        marketCap: Optional(1007345017072.0),
                                        marketCapRank: 1,
                                        fullyDilutedValuation: Optional(1135129520109.0),
                                        totalVolume: 99974557481.0,
                                        high24H: 57707.0,
                                        low24H: 50868.0,
                                        priceChange24H: -3599.07221998,
                                        priceChangePercentage24H: -6.24266,
                                        marketCapChange24H: -67024252736.06067,
                                        marketCapChangePercentage24H: -6.23847,
                                        circulatingSupply: 18635975.0,
                                        totalSupply: Optional(21000000.0),
                                        maxSupply: Optional(21000000.0),
                                        ath: 58641.0,
                                        athChangePercentage: -7.82217,
                                        athDate: "2021-02-21T19:07:32.042Z",
                                        atl: 67.81,
                                        atlChangePercentage: 79614.76747,
                                        atlDate: "2013-07-06T00:00:00.000Z",
                                        lastUpdated: "2021-02-22T23:18:11.444Z")
}
