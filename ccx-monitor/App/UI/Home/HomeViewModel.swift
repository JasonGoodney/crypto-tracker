//
//  HomeViewModel.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 2/28/21.
//

import Foundation
import Combine

extension HomeView {
    
    class ViewModel: ObservableObject {
        
        // MARK: - Properties
        
        private var subscriptions = Set<AnyCancellable>()
        
        @Published private(set) var globalMarket: CoinGecko.GlobalMarket?
        
        @Published private(set) var percentChange24h = 0.0
        
        @Published private(set) var topNews: [CryptoPanic.NewsArticle] = []
        
        @Published private(set) var topCoins: [CoinGecko.CoinMarketData] = []
        
        @Published private(set) var watchlistCollapsed: [CoinGecko.CoinMarketData] = []
        
        @Published private(set) var watchlist: [CoinGecko.CoinMarketData] = []

        @Published private(set) var topGainers: [CoinGecko.CoinMarketData] = []
        
        @Published private(set) var topLosers: [CoinGecko.CoinMarketData] = []
        
        // MARK: - Methods
        
        func getGlobalMarket() {
            
            DataLoader<CoinGeckoAPI>()
                .request(CoinGecko.Root.self, from: .global())
                .sink(receiveCompletion: onReceive) { [weak self] root in
                    self?.globalMarket = root.globalMarket
                    self?.percentChange24h = root.globalMarket.marketCapChangePercentage24HUsd.decimals(2)
                }
                .store(in: &subscriptions)
        }
        
        func getNews() {
            
            DataLoader<CryptoPanicAPI>()
                .request(CryptoPanic.Root.self,
                         from: .posts())
                .sink(receiveCompletion: onReceive,
                      receiveValue: { [weak self] root in
                        self?.topNews = Array(root.results[..<5])
                      }
                )
                .store(in: &subscriptions)
        }
        
        func getWatchlist() {
            guard AppUserDefaults.shared.watchlist.isNotEmpty else { return }
            
            DataLoader<CoinGeckoAPI>()
                .request([CoinGecko.CoinMarketData].self,
                         from: .coins(.markets, ids: AppUserDefaults.shared.watchlist))
                .sink(receiveCompletion: onReceive) { [weak self] value in
                    self?.watchlist = value
                    
                    self?.watchlistCollapsed = []
                    self?.watchlistCollapsed.addElements(upTo: 5, from: self?.watchlist ?? value)
                }
                .store(in: &subscriptions)
                            
        }
        
        func getTopCoins() {
            
            DataLoader<CoinGeckoAPI>()
                .request([CoinGecko.CoinMarketData].self, from: .coins(.markets, perPage: 100))
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print(error)
                    }
                }, receiveValue: { [weak self] value in
                    self?.topCoins = Array(value[..<10])
                    self?.topGainers = Array(value.filter { $0.priceChangePercentage24H != nil }
                                                .sorted(by: { $0.priceChangePercentage24H! > $1.priceChangePercentage24H! })[..<10])
                    self?.topLosers = Array(value.filter { $0.priceChangePercentage24H != nil }
                                                .sorted(by: { $0.priceChangePercentage24H! < $1.priceChangePercentage24H! })[..<10])
                    
                })
                .store(in: &subscriptions)
        }
        
        private func onReceive(_ completion: Subscribers.Completion<NetworkError>) {
            switch completion {
            case .finished:
                break
            case .failure(let error):
                print(error)
            }
        }
    }
}
