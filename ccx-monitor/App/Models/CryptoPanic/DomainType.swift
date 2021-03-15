//
//  DomainType.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 3/4/21.
//

import Foundation

extension CryptoPanic.NewsArticle {
    enum DomainType: String {
        case normal
        case twitter = "twitter.com"
        case reddit = "reddit.com"
        case coinTelegraph = "cointelegraph.com"
        
        static func from(_ domainString: String) -> DomainType {
            switch domainString {
            case DomainType.twitter.rawValue:
                return .twitter
            case DomainType.reddit.rawValue:
                return .reddit
            case DomainType.coinTelegraph.rawValue:
                return .coinTelegraph
            default:
                return .normal
            }
        }
    }
}
