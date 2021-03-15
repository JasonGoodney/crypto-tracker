//
//  CoinDetailViewModel.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 3/5/21.
//

import Foundation
import Combine

extension CoinDetailView {
    
    class ViewModel: ObservableObject {
        
        // MARK: - Properties
            
        private var subscriptions = Set<AnyCancellable>()
        
//        var isInWatchlist: Bool {
//            let watchlist = UserDefaults.standard.value(for: .watchlist) as? [String] ?? []
//
//            return watchlist.contains(coin.marketData.coinGeckoId.lowercased())
//        }
        
        @Published private(set) var coin: CoinGecko.Coin
        
        @Published private(set) var topNews: [CryptoPanic.NewsArticle] = []
        
        @Published var isInWatchlist = false
        
        init(coin: CoinGecko.CoinMarketData) {
            self.coin = CoinGecko.Coin(marketData: coin)
        }
        
        // MARK: - Methods
        func loadFromUserDefaults () {
            let watchlist = UserDefaults.standard.value(for: .watchlist) as? [String] ?? []
            let id = coin.marketData.coinGeckoId.lowercased()
            isInWatchlist = watchlist.contains(id)
        }
        
        func getCoin() {
            DataLoader<CoinGeckoAPI>()
                .request(CoinGecko.CoinInfo.self, from: .coin(coin.marketData.coinGeckoId))
                .sink(
                    receiveCompletion: onReceive,
                    receiveValue: onReceive)
                .store(in: &subscriptions)
        }
        
        func getNews() {
            DataLoader<CryptoPanicAPI>()
                .request(CryptoPanic.Root.self,
                         from: .posts(currencies: [coin.marketData.symbol]))
                .sink(receiveCompletion: onReceive,
                      receiveValue: { [weak self] root in
                        if root.results.count > 5 {
                            self?.topNews = Array(root.results[..<5])
                            
                        } else {
                            self?.topNews = root.results
                        }
                        
                      }
                )
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
        
        private func onReceive(_ info: CoinGecko.CoinInfo) {
            coin.info = info
        }
        
    }
    
    
}
