//
//  CoinDetailViewModel.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 3/5/21.
//

import Combine
import Foundation

extension CoinDetailView {
    class ViewModel: ObservableObject {
        // MARK: - Properties
            
        let coinGeckoId: String
        private let coinSymbol: String
        
        private var subscriptions = Set<AnyCancellable>()
        
        private let dispatchGroup = DispatchGroup()
                
        @Published private(set) var coin: CoinGecko.Coin?
        
        @Published private(set) var coinPlusPlus: CoinGecko.CoinPlusPlus?
        
        @Published private(set) var topNews: [CryptoPanic.NewsArticle]?
        
        @Published var isInWatchlist = false
        
        @Published private(set) var isLoading = false
        
        init(coinGeckoId: String, coinSymbol: String) {
            self.coinGeckoId = coinGeckoId
            self.coinSymbol = coinSymbol
        }
        
        // MARK: - Methods

        func getAll() {
            isLoading = true
            
            getCoin(for: coinGeckoId)
            getCoinPlusPlus()
            getNews()
            getMarketChart(for: "bitcoin")
         
            dispatchGroup.notify(queue: .main) { [weak self] in
                self?.isLoading = false
            }
        }
        
        func getMarketChart(for id: String) {
            dispatchGroup.enter()
            
            DataLoader<CoinGeckoAPI>()
                .request(CoinGecko.Prices.self, from: .marketChart(for: id, days: 7))
                .sink(receiveCompletion: onReceive) { prices in
                    print(prices)
                }
                .store(in: &subscriptions)
        }
        
        func getCoin(for id: String) {
            dispatchGroup.enter()
            
            DataLoader<CoinGeckoAPI>()
                .request([CoinGecko.Coin].self, from: .coins(.markets, ids: [id]))
                .sink(receiveCompletion: onReceive) { [weak self] coins in
                    self?.coin = coins.first
                }
                .store(in: &subscriptions)
                
        }
        
        func getCoinPlusPlus() {
            dispatchGroup.enter()
            
            DataLoader<CoinGeckoAPI>()
                .request(CoinGecko.CoinPlusPlus.self, from: .coin(coinGeckoId))
                .sink(
                    receiveCompletion: onReceive,
                    receiveValue: onReceive)
                .store(in: &subscriptions)
        }
        
        func getNews() {
            dispatchGroup.enter()
            
            DataLoader<CryptoPanicAPI>()
                .request(CryptoPanic.Root.self,
                         from: .posts(currencies: [coinSymbol]))
                .sink(receiveCompletion: onReceive,
                      receiveValue: { [weak self] root in
                          if root.results.isEmpty {
                              self?.topNews = nil
                          } else if root.results.count > 5 {
                              self?.topNews = Array(root.results[..<5])
                          } else {
                              self?.topNews = root.results
                          }
                      })
                .store(in: &subscriptions)
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
        
        private func onReceive(_ coinPlusPlus: CoinGecko.CoinPlusPlus) {
            self.coinPlusPlus = coinPlusPlus
        }
    }
}
