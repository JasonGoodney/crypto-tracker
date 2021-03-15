//
//  CryptoPanicAPI.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 2/27/21.
//

import Foundation

class CryptoPanicAPI: Endpoint {
    
    static let pageSize = 20
    
    static let batchLimit = 200
    
    static let pageLimit = 10
    
    override func urlRequest() -> URLRequest? {
        let apiKeyQueryItem = URLQueryItem(name: "auth_token",
                                           value: "a860ff1b0799e1e8f0d212a7fac7f7151e7b74d2")
        
        var components          = URLComponents()
        components.scheme       = "https"
        components.host         = "cryptopanic.com"
        components.path         = "/api/v1/\(path)"
        components.queryItems   = [apiKeyQueryItem] + queryItems

        guard let url = components.url else {
            print("Bad url")
            return nil
        }
        
        return URLRequest(url: url)
    }
}


extension CryptoPanicAPI {
    static func posts(kind: Kind = .news, filter: Filter = .hot,
                      currencies: [String]? = nil, page: Int = 1) -> CryptoPanicAPI {
        
        var queryItems = [
            URLQueryItem(name: "kind", value: kind.rawValue),
            URLQueryItem(name: "filter", value: filter.rawValue),
            URLQueryItem(name: "page", value: "\(page)")
          ]
        
        if let currencies = currencies, !currencies.isEmpty {
            queryItems.append(
                URLQueryItem(name: "currencies", value:
                                currencies.joined(separator: ",")))
        }
        
        return CryptoPanicAPI(path: "posts/",
                              queryItems: queryItems)
    }
}

extension CryptoPanicAPI {
    enum Kind: String {
        case news
        case media
    }
    
    enum Filter: String, CaseIterable {
        case rising
        case hot
        case bullish
        case bearish
        case important
        case lol
        
        var text: String {
            switch self {
            case .rising:
                return "Rising"
            case .hot:
                return "Hot"
            case .bearish:
                return "Bearish"
            case .bullish:
                return "Bullish"
            case .important:
                return "Important"
            case .lol:
                return "LoL"
                
            }
        }
    }
}
