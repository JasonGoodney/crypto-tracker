//
//  CoinGeckoAPI.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 9/28/20.
//

import Foundation

class CoinGeckoAPI: Endpoint {
    
    static let pageSize = 10
    
    override func urlRequest() -> URLRequest? {
        var components          = URLComponents()
        components.scheme       = "https"
        components.host         = "api.coingecko.com"
        components.path         = "/api/v3/\(path)"
        components.queryItems   = queryItems

        guard let url = components.url else {
            print("Bad url")
            return nil
        }
        
        return URLRequest(url: url)
    }

}

extension CoinGeckoAPI {
    
    static func coin(_ id: String) -> CoinGeckoAPI {
        return CoinGeckoAPI(
            path: "coins/\(id)",
            queryItems: [
                URLQueryItem(name: "tickers", value: "false")
            ])
    }
    
    static func coins(_ path: CoinsPath, vsCurrency: String = "usd",
                      ids: [String] = [], sortBy order: SortBy = .marketCapDescending,
                      perPage: Int = pageSize, page: Int = 1,
                      sparkline: String = "false") -> CoinGeckoAPI {
        
        var queryItems = [
            URLQueryItem(name: "vs_currency", value: vsCurrency),
            URLQueryItem(name: "order", value: order.query),
            URLQueryItem(name: "per_page", value: "\(perPage)"),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "sparkline", value: sparkline)
        ]
        
        if ids.isNotEmpty {
            queryItems.append(URLQueryItem(
                                name: "ids",
                                value: ids.map { $0.lowercased() }
                                    .joined(separator: ",")))
        }
        
        return CoinGeckoAPI(
            path: "coins/\(path)",
            queryItems: queryItems)
    }
    
    static func global() -> CoinGeckoAPI {
        return CoinGeckoAPI(path: "global")
    }
    
    static func allCoins() -> CoinGeckoAPI {
        return CoinGeckoAPI(path: "coins/list")
    }
    
    static func marketChart(for coinId: String, vsCurrency: String = "usd", days: Int) -> CoinGeckoAPI {
        return CoinGeckoAPI(path: "coins/\(coinId)/market_chart",
                            queryItems: [
                                URLQueryItem(name: "id", value: coinId),
                                URLQueryItem(name: "vs_currency", value: vsCurrency),
                                URLQueryItem(name: "days", value: "\(days)"),
                            ])
    }
}

extension CoinGeckoAPI {
    enum SortBy: CaseIterable {
        case marketCapDescending
        case marketCapAscending
        case volumeDescending
        case volumeAscending
        
        var query: String {
            switch self {
            case .marketCapDescending:
                return "market_cap_desc"
            case .marketCapAscending:
                return "market_cap_asc"
            case .volumeDescending:
                return "volume_desc"
            case .volumeAscending:
                return "volume_asc"
            }
        }
        
        var text: String {
            switch self {
            case .marketCapDescending:
                return "Market Cap Descending"
            case .marketCapAscending:
                return "Market Cap Ascending"
            case .volumeDescending:
                return "Volume Descending"
            case .volumeAscending:
                return "Volume Ascending"
            }
        }
        
        var measure: String {
            switch self {
            case .marketCapDescending, .marketCapAscending:
                return "Market Cap"
            case .volumeDescending, .volumeAscending:
                return "Volume"
            }
        }
        
        var measureShort: String {
            switch self {
            case .marketCapDescending, .marketCapAscending:
                return "MCap"
            case .volumeDescending, .volumeAscending:
                return "Vol"
            }
        }
    }
}
