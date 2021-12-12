//
//  HomeViewModel.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 2/28/21.
//

import Combine
import Foundation

extension HomeView {
    class ViewModel: ObservableObject {
        // MARK: - Properties
        
        private var cancellables = Set<AnyCancellable>()
        
        private var dispatchGroup = DispatchGroup()
        
        @Published private(set) var globalMarket: CoinGecko.GlobalMarket?
        
        @Published private(set) var percentChange24h = 0.0
        
        @Published private(set) var topNews: [CryptoPanic.NewsArticle] = []
        
        @Published private(set) var topCoins: [CoinGecko.Coin] = []
        
        @Published private(set) var watchlistCollapsed: [CoinGecko.Coin] = []
        
        @Published private(set) var watchlist: [CoinGecko.Coin] = []

        @Published private(set) var topGainers: [CoinGecko.Coin] = []
        
        @Published private(set) var topLosers: [CoinGecko.Coin] = []
        
        @Published private(set) var isLoading = false
        
        // MARK: - Methods

        func getAll() {
            isLoading = true
            
            getGlobalMarket()
            getWatchlist()
            getTopCoins()
            getNews()
            
            dispatchGroup.notify(queue: .main) { [weak self] in
                self?.isLoading = false
            }
        }
        
        func getGlobalMarket() {
            dispatchGroup.enter()
            
            DataLoader<CoinGeckoAPI>()
                .request(CoinGecko.Root.self, from: .global())
                .sink(receiveCompletion: onReceive) { [weak self] root in
                    self?.globalMarket = root.globalMarket
                    self?.percentChange24h = root.globalMarket.marketCapChangePercentage24HUsd.decimals(2)
                }
                .store(in: &cancellables)
        }
        
        func getNews() {
            dispatchGroup.enter()
            
            DataLoader<CryptoPanicAPI>()
                .request(CryptoPanic.Root.self,
                         from: .posts())
                .sink(receiveCompletion: onReceive,
                      receiveValue: { [weak self] root in

                          self?.topNews = Array(root.results[..<5])
                      })
                .store(in: &cancellables)
        }
        
        func getWatchlist() {
            guard AppUserDefaults.shared.watchlist.isNotEmpty else { return }
            
            dispatchGroup.enter()
            
            DataLoader<CoinGeckoAPI>()
                .request([CoinGecko.Coin].self,
                         from: .coins(.markets, ids: AppUserDefaults.shared.watchlist.map { $0.coinGeckoId }))
                .sink(receiveCompletion: onReceive) { [weak self] value in
                    
                    self?.watchlist = value
                    
                    self?.watchlistCollapsed = []
                    self?.watchlistCollapsed.addElements(upTo: 5, from: self?.watchlist ?? value)
                }
                .store(in: &cancellables)
        }
        
        func getTopCoins() {
            dispatchGroup.enter()
            
            DataLoader<CoinGeckoAPI>()
                .request([CoinGecko.Coin].self, from: .coins(.markets, perPage: 100))
                .sink(receiveCompletion: onReceive) { [weak self] value in
                    
                    self?.topCoins = Array(value[..<10])
                    self?.topGainers = Array(value.filter { $0.priceChangePercentage24H != nil }
                        .sorted(by: { $0.priceChangePercentage24H! > $1.priceChangePercentage24H! })[..<10])
                    self?.topLosers = Array(value.filter { $0.priceChangePercentage24H != nil }
                        .sorted(by: { $0.priceChangePercentage24H! < $1.priceChangePercentage24H! })[..<10])
                }
                .store(in: &cancellables)
        }
        
        private func onReceive(_ completion: Subscribers.Completion<NetworkError>) {
            dispatchGroup.leave()
            
            switch completion {
            case .finished:
                break
            case .failure(let error):
                print(error)
            }
        }
    }
}
