//
//  MarketViewModel.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 2/27/21.
//

import Foundation
import Combine

extension MarketView {
    
    class ViewModel: ObservableObject {
        
        // MARK: - Properties
        
        @Published private(set) var globalMarket: CoinGecko.GlobalMarket?
        
        @Published private(set) var coins: [CoinGecko.CoinMarketData] = []
        
        @Published private(set) var globalStats = CoinRanking.GlobalStats()
        
        @Published private(set) var pagingState = PagingState<CoinGecko.CoinMarketData>()
        
        @Published var isLoading = false {
            didSet {
                if oldValue == false && isLoading == true {
                    self.getAll()
                }
            }
        }
        
        var sort: CoinGeckoAPI.SortBy = .marketCapDescending {
            didSet {
                pagingState.items = []
                pagingState.page = 1
                pagingState.canLoadNextPage = true
                getCoins()
            }
        }

        private let dispatchGroup = DispatchGroup()
    
        private var subscriptions = Set<AnyCancellable>()
        
        // MARK: - Methods
        
        func getAll() {
            
            getCoins()
            getGlobalStats()
            getGlobalMarket()
            
            dispatchGroup.notify(queue: .main) { [weak self] in
                self?.isLoading = false
            }
        }
            
        func getCoins() {
            guard pagingState.canLoadNextPage else { return }
            
            dispatchGroup.enter()
            
            DataLoader<CoinGeckoAPI>()
                .request([CoinGecko.CoinMarketData].self,
                         from: .coins(.markets, sortBy: sort, page: pagingState.page))
                .sink(receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print(error)
                        self?.pagingState.canLoadNextPage = false
                    }
                
                    self?.dispatchGroup.leave()
                    
                }, receiveValue: onReceive)
                .store(in: &subscriptions)
        }
        
        func getGlobalMarket() {
            
            dispatchGroup.enter()
            
            DataLoader<CoinGeckoAPI>()
                .request(CoinGecko.Root.self, from: .global())
                .sink(receiveCompletion: onReceive) { [weak self] root in
                    self?.globalMarket = root.globalMarket
                }
                .store(in: &subscriptions)
        }
        
        func getGlobalStats() {
            
            dispatchGroup.enter()
            
            DataLoader<CoinRankingAPI>()
                .request(CoinRanking.Root<CoinRanking.GlobalStats>.self, from: .stats())
                .sink(receiveCompletion: onReceive) { [weak self] coinRanking in
                    self?.globalStats = coinRanking.data
                }
                .store(in: &subscriptions)
        }
        
        private func onReceive(_ completion: Subscribers.Completion<NetworkError>) {
            switch completion {
            case .finished:
                break
            case .failure(let error):
                print(error)
            }
        
            dispatchGroup.leave()
        }
        
        private func onReceive(_ batch: [CoinGecko.CoinMarketData]) {
            pagingState.items += batch
            pagingState.page += 1
            pagingState.canLoadNextPage = batch.count == CoinGeckoAPI.pageSize
        }
    }
    
}

