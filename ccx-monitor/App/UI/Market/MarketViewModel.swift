//
//  MarketViewModel.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 2/27/21.
//

import Combine
import Foundation

extension MarketView {
    class ViewModel: ObservableObject {
        // MARK: - Properties
        
        private var cancellables = Set<AnyCancellable>()
        
        private let dispatchGroup = DispatchGroup()
        
        @Published private(set) var globalMarket: CoinGecko.GlobalMarket?
        
        @Published private(set) var coins: [CoinGecko.Coin] = []
        
        @Published private(set) var globalStats = CoinRanking.GlobalStats()
        
        @Published private(set) var pagingState = PagingState<CoinGecko.Coin>()
        
        @Published private(set) var networkError: NetworkError?
        
        @Published var isLoading = false {
            didSet {
                if oldValue == false, isLoading == true {
                    getAll()
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
        
        // MARK: - Methods
        
        func getAll() {
            isLoading = true
            
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
                .request([CoinGecko.Coin].self,
                         from: .coins(.markets, sortBy: sort, page: pagingState.page))
                .sink(receiveCompletion: { [weak self] completion in
                    self?.dispatchGroup.leave()
                    
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print(error)
                        self?.networkError = error
                        self?.pagingState.canLoadNextPage = false
                    }
                
                }, receiveValue: onReceive)
                .store(in: &cancellables)
        }
        
        func getGlobalMarket() {
            dispatchGroup.enter()
            
            DataLoader<CoinGeckoAPI>()
                .request(CoinGecko.Root.self, from: .global())
                .sink(receiveCompletion: onReceive) { [weak self] root in
                    self?.globalMarket = root.globalMarket
                }
                .store(in: &cancellables)
        }
        
        func getGlobalStats() {
            dispatchGroup.enter()
            
            DataLoader<CoinRankingAPI>()
                .request(CoinRanking.Root<CoinRanking.GlobalStats>.self, from: .stats())
                .sink(receiveCompletion: onReceive) { [weak self] coinRanking in
                    self?.globalStats = coinRanking.data
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
        
        private func onReceive(_ batch: [CoinGecko.Coin]) {
            pagingState.items += batch
            pagingState.page += 1
            pagingState.canLoadNextPage = batch.count == CoinGeckoAPI.pageSize
        }
    }
}
