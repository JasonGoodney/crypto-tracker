//
//  NewsViewModel.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 2/27/21.
//

import Foundation
import Combine

extension NewsView {
    
    class ViewModel: ObservableObject {
        
        // MARK: - Properties
                
        @Published var pagingState = PagingState<CryptoPanic.NewsArticle>(
            pageLimit: CryptoPanicAPI.pageLimit)
        
        @Published var pageLimitReached = false
        
        private var subscriptions = Set<AnyCancellable>()
        
        var filter: CryptoPanicAPI.Filter = .rising {
            didSet {
                pagingState.items = []
                getNews()
            }
        }
        
        // MARK: - Methods
        
        func onAppear() {
            getNews()
        }
        
        func getNews() {
            guard pagingState.canLoadNextPage else { return }
            
            guard !pagingState.pageLimitReach else {
                pagingState.canLoadNextPage = false
                pageLimitReached = true
                return
            }
            
            let currencies: [String] = []
            
            DataLoader<CryptoPanicAPI>()
                .request(CryptoPanic.Root.self,
                         from: .posts(filter: filter,
                                      currencies: currencies,
                                      page: pagingState.page))
                .sink(receiveCompletion: onReceive,
                      receiveValue: { [weak self] root in
                        self?.onReceive(root.results)
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
