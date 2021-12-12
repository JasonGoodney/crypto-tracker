//
//  CoinSingle.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 3/5/21.
//
import Foundation

extension CoinGecko {
    // MARK: - Coin

    struct CoinPlusPlus: Codable {
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
    }
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
            let officialForumUrl: [String]?
            let twitterScreenName: String?
            let facebookUsername: String?
            let telegramChannelIdentifier: String?
            let subredditUrl: String?
            let reposUrl: ReposUrl?

            var home: Website? {
                guard let uri = homepage?.first else { return nil }
                return Website(name: "Homepage", uri: uri)
            }

            var blockchainExplorer: Website? {
                guard let uri = blockchainSite?.first else { return nil }
                return Website(name: "Blockchain Explorer", uri: uri)
            }

            var forum: Website? {
                guard let uri = officialForumUrl?.first else { return nil }
                return Website(name: "Forum", uri: uri)
            }

            var twitter: Website? {
                guard let username = twitterScreenName else { return nil }
                return Website(name: "Twitter", uri: "https://twitter.com/\(username)")
            }

            var facebook: Website? {
                guard let username = facebookUsername else { return nil }
                return Website(name: "Facebook", uri: "https://facebook.com/\(username)")
            }

            var reddit: Website? {
                guard let uri = subredditUrl else { return nil }
                return Website(name: "Reddit", uri: uri)
            }

            var github: Website? {
                guard let uri = reposUrl?.github?.first else { return nil }
                return Website(name: "GitHub", uri: uri)
            }

            var bitbucket: Website? {
                guard let uri = reposUrl?.bitbucket?.first else { return nil }
                return Website(name: "BitBucket", uri: uri)
            }
        }

        // MARK: - ReposURL

        struct ReposUrl: Codable {
            let github: [String]?
            let bitbucket: [String]?
        }
    
}

extension CoinGecko.CoinPlusPlus {
    static let example = CoinGecko.CoinPlusPlus(blockTimeInMinutes: 10,
                                                hashingAlgorithm: "{Hashing}",
                                                categories: nil,
                                                localization: nil,
                                                description: nil,
                                                links: CoinGecko.Links(
                                                    homepage: ["http://www.bitcoin.org", "", ""],
                                                    blockchainSite: ["https://blockchair.com/bitcoin/",
                                                                     "https://btc.com/",
                                                                     "https://btc.tokenview.com/", "", ""],
                                                    officialForumUrl: ["message board"],
                                                    twitterScreenName: "Twitter",
                                                    facebookUsername: "Facebook",
                                                    telegramChannelIdentifier: "Telegram",
                                                    subredditUrl: "Reddit",
                                                    reposUrl: CoinGecko.ReposUrl(
                                                        github: ["https://github.com/bitcoin/bitcoin",
                                                                 "https://github.com/bitcoin/bips"],
                                                        bitbucket: ["bitbucket"])),
                                                countryOrigin: "US",
                                                genesisDate: nil,
                                                sentimentVotesUpPercentage: nil,
                                                sentimentVotesDownPercentage: nil,
                                                communityData: nil,
                                                developerData: nil)
}
