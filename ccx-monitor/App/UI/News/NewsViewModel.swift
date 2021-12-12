//
//  NewsViewModel.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 2/27/21.
//

import Combine
import Foundation

extension NewsView {
    class ViewModel: ObservableObject {
        // MARK: - Properties
        
        private var cancellables = Set<AnyCancellable>()
        
        private var dispatchGroup = DispatchGroup()
        
        @Published var pagingState = PagingState<CryptoPanic.NewsArticle>(
            pageLimit: CryptoPanicAPI.pageLimit)
        
        @Published var pageLimitReached = false
        
        @Published private(set) var isLoading = false
        
        var filter: CryptoPanicAPI.Filter = .rising {
            didSet {
                pagingState.items = []
                getNews()
            }
        }
        
        // MARK: - Methods
        
        func getAll() {
            isLoading = true
            getNews()
            
            dispatchGroup.notify(queue: .main) { [weak self] in
                self?.isLoading = false
            }
        }
        
        func getNews() {
            guard pagingState.canLoadNextPage else { return }
            
            guard !pagingState.pageLimitReach else {
                pagingState.canLoadNextPage = false
                pageLimitReached = true
                return
            }
            
            dispatchGroup.enter()
            
            let currencies: [String] = []
            
            DataLoader<CryptoPanicAPI>()
                .request(CryptoPanic.Root.self,
                         from: .posts(filter: filter,
                                      currencies: currencies,
                                      page: pagingState.page))
                .sink(receiveCompletion: onReceive,
                      receiveValue: { [weak self] root in
                          self?.onReceive(root.results)
                      })
                .store(in: &cancellables)
        }
        
        private func onReceive(_ completion: Subscribers.Completion<NetworkError>) {
            dispatchGroup.leave()
            
            switch completion {
            case .finished:
                break
            case .failure(let error):
                print(error)
                pagingState.canLoadNextPage = false
            }
        }
        
        private func onReceive(_ batch: [CryptoPanic.NewsArticle]) {
            pagingState.items += batch
            pagingState.page += 1
            pagingState.canLoadNextPage = batch.count == CryptoPanicAPI.pageSize
        }
    }
}
