//
//  Coin.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 2/28/21.
//

import Foundation

extension CoinRanking {
    
    // MARK: - CoinsObject
    struct CoinsObject: Codable {
        let coins: [Coin]
    }

    // MARK: - Coin
    struct Coin: Codable, Hashable {
        static func == (lhs: CoinRanking.Coin, rhs: CoinRanking.Coin) -> Bool {
            return lhs.uuid == rhs.uuid
        }
        
        let uuid: String
        let symbol: String
        let name: String
        let description: String?
        let color: String
        let iconUrl: String
        let websiteUrl: String?
//            let links: [Link]
//            let supply: Supply
        let volume24h: String
        let marketCap: String
        let price: String
        let btcPrice: String
        let listedAt: Int
        let change: String
        let rank: Int
        let numberOfMarkets: Int?
        let numberOfExchanges: Int?
        let sparkline: [String]
//            let allTimeHigh: AllTimeHigh
        let coinrankingUrl: String
    
        // MARK: - AllTimeHigh
        struct AllTimeHigh: Codable {
            let price: String
            let timestamp: Int
        }

        // MARK: - Link
        struct Link: Codable {
            let name: String
            let url: String
            let type: String
        }

        // MARK: - Supply
        struct Supply: Codable {
            let confirmed: Bool
            let circulating: String
            let total: String
        }
    }

    

}

extension CoinRanking.Coin {
    enum CodingKeys: String, CodingKey {

        case uuid
        case symbol
        case name
        case description
        case color
        case iconUrl
        case websiteUrl
//        case links
//        case supply
        case volume24h = "24hVolume"
        case marketCap
        case price
        case btcPrice
        case listedAt
        case change
        case rank
        case numberOfMarkets
        case numberOfExchanges
        case sparkline
//        case allTimeHigh
        case coinrankingUrl




    }
}
