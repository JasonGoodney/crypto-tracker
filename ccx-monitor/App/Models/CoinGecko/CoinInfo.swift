//
//  CoinSingle.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 3/5/21.
//
import Foundation

extension CoinGecko {

    struct Coin: Codable {
        let marketData: CoinMarketData
        var info: CoinInfo? = nil
    }
    
// MARK: - Coin
    struct CoinInfo: Codable {
    let blockTimeInMinutes: Int?
    let hashingAlgorithm: String?
    let categories: [String]?
    let localization: Tion?
    let description: Tion?
    let links: Links?
    let countryOrigin: String?
    let genesisDate: String?
    let sentimentVotesUpPercentage: Double?
    let sentimentVotesDownPercentage: Double?
    let communityData: CommunityData?
    let developerData: DeveloperData?


// MARK: - Tion
struct Tion: Codable {
    let en: String?
    let de: String?
    let es: String?
    let fr: String?
    let it: String?
    let pl: String?
    let ro: String?
    let hu: String?
    let nl: String?
    let pt: String?
    let sv: String?
    let vi: String?
    let tr: String?
    let ru: String?
    let ja: String?
    let zh: String?
    let zhTw: String?
    let ko: String?
    let ar: String?
    let th: String?
    let id: String?
}

// MARK: - CommunityData
struct CommunityData: Codable {
    let facebookLikes: Int?
    let twitterFollowers: Int?
    let redditAveragePosts48H: Double?
    let redditAverageComments48H: Double?
    let redditSubscribers: Int?
    let redditAccountsActive48H: Int?
    let telegramChannelUserCount: Int?
}

// MARK: - DeveloperData
struct DeveloperData: Codable {
    let forks: Int?
    let stars: Int?
    let subscribers: Int?
    let totalIssues: Int?
    let closedIssues: Int?
}

// MARK: - Links
struct Links: Codable {
    let homepage: [String]?
    let blockchainSite: [String]?
    let officialForumURL: [String]?
    let twitterScreenName: String?
    let facebookUsername: String?
    let telegramChannelIdentifier: String?
    let subredditURL: String?
    let reposURL: ReposURL?
}

// MARK: - ReposURL
struct ReposURL: Codable {
    let github: [String]?
    let bitbucket: [String]?
}

}
}
