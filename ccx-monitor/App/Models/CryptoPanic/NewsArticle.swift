//
//  NewsArticle.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 2/27/21.
//

import Foundation

extension CryptoPanic {

    struct NewsArticle: Codable, Identifiable {
        
        let id: Int
        let kind: String
        let domain: String
        let source: Source
        let title: String
        let publishedAt: String
        let slug: String
        let currencies: [Currency]?
    
        var url: URL {
            let domainType = DomainType.from(source.domain)
            
            switch domainType {
            case .normal:
                return URL(string: "https://\(source.domain)/\(slug.lowercased())")!
            case .twitter:
                return URL(string: "https://\(source.domain)/\(domain.replacingOccurrences(of: "@", with: ""))")!
            case .reddit:
                return URL(string: "https://\(source.domain)/\(domain)")!
            case .coinTelegraph:
                return URL(string: "https://\(source.domain)/news/\(slug.lowercased())")!
            case .cryptoGlobe:
                //2021-03-26T00:09:00Z
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
                let date = dateFormatter.date(from: publishedAt)!
                dateFormatter.dateFormat = "yyyy/MM"
                let yearMonth = dateFormatter.string(from: date)
                return URL(string: "https://\(source.domain)/latest/\(yearMonth)/\(slug.lowercased())")!
            }
        }
        
        // MARK: - Currency
        struct Currency: Codable, Hashable {
            let code: String
            let title: String
        }
        
        // MARK: - Source
        struct Source: Codable {
            let title: String
            let region: String
            let domain: String
        }
    }
}

extension CryptoPanic.NewsArticle {
    static let demo = CryptoPanic.NewsArticle(
        id: 234242,
        kind: "news",
        domain: "cryptoglobe.com",
        source: Source(
            title: "CryptoGlobe",
            region: "en",
            domain: "cryptoglobe.com"),
        title: "Billion-Dollar Whale Transfer May Have Triggered Crypto Crash: Report",
        publishedAt: "2021-02-23T03:29:00Z",
        slug: "Billion-Dollar-Whale-Transfer-May-Have-Triggered-Crypto-Crash-Report",
        currencies: [
            Currency(code: "BTC", title: "Bitcoin"),
            Currency(code: "TRX", title: "Tron"),
            Currency(code: "BNB", title: "Binance Coin")
        ])
}

extension CryptoPanic.NewsArticle: Equatable {
    static func == (lhs: CryptoPanic.NewsArticle, rhs: CryptoPanic.NewsArticle) -> Bool {
        lhs.id == rhs.id
    }
}
