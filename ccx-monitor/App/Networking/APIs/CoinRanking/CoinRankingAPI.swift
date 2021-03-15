//
//  CoinRankingAPI.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 2/26/21.
//

import Foundation

class CoinRankingAPI: Endpoint {
    
    override func urlRequest() -> URLRequest? {
        var components          = URLComponents()
        components.scheme       = "https"
        components.host         = "api.coinranking.com"
        components.path         = "/v2/\(path)"
        components.queryItems   = queryItems

        guard let url = components.url else {
            print("Bad url")
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("coinrankinga5e8975f3b5de20534adf588bfdee068fcf4e845d02d1f41",
                            forHTTPHeaderField: "x-access-token")
        return urlRequest
    }
}

extension CoinRankingAPI {
    static func stats() -> CoinRankingAPI {
        return CoinRankingAPI(path: Self.Path.stats.rawValue)
    }
    
    static func coins(limit: Int = 10) -> CoinRankingAPI {
        return CoinRankingAPI(path: Self.Path.coins.rawValue,
                              queryItems: [
                                URLQueryItem(name: "limit", value: "\(limit)"),
                              ])
    }
}
