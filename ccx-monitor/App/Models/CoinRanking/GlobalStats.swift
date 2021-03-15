//
//  GlobalStats.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 2/26/21.
//

import Foundation

extension CoinRanking {
    
    struct GlobalStats: Codable {
        let totalCoins: Int
        let totalMarkets: Int
        let totalExchanges: Int
        
        private let totalMarketCapString: String
        private let total24hVolumeString: String
        
        var totalMarketCap: Double {
            Double(totalMarketCapString) ?? 0
        }
        
        var total24hVolume: Double {
            Double(total24hVolumeString) ?? 0
        }
        
        init(totalCoins: Int = 0, totalMarkets: Int = 0, totalExchanges: Int = 0, totalMarketCapString: String = "", total24hVolumeString: String = "") {
            self.totalCoins = totalCoins
            self.totalMarkets = totalMarkets
            self.totalExchanges = totalExchanges
            self.totalMarketCapString = totalMarketCapString
            self.total24hVolumeString = total24hVolumeString
        }
    }

}

private extension CoinRanking.GlobalStats {
    
    enum CodingKeys: String, CodingKey {
        case totalCoins
        case totalMarkets
        case totalExchanges
        case totalMarketCapString = "totalMarketCap"
        case total24hVolumeString = "total24hVolume"
    }
}
