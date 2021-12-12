//
//  SearchView.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 3/22/21.
//

import SwiftUI

struct SearchView: View {
    
    @State private var selectedCoin: CoinGecko.CoinSimple?

    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        SearchNavigationView(text: $viewModel.searchText, search: search, cancel: cancel) {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.searchResults) { coin in
                        SearchRow(coin: coin)
                            .onTapGesture { onCoinTapped(coin) }
                    }
                }
                .padding()
            }
            .navigationTitle("Search")
        }
        .fullScreenCover(item: $selectedCoin) { coin in
            CoinDetailView(coinGeckoId: coin.id,
                           coinSymbol: coin.symbol)
        }
    }
    
    func search() {}
    
    func cancel() {}
    
    private func onCoinTapped(_ coin: CoinGecko.CoinSimple) {
        selectedCoin = coin
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

struct SearchRow: View {
    let coin: CoinGecko.CoinSimple
    
    var body: some View {
        VStack {
            HStack {
                Text(coin.name)
                    + Text(" (\(coin.symbol.uppercased()))")
                
                Spacer()
            }
            
            Divider()
        }
    }
}

import Combine

extension SearchView {
    class ViewModel: ObservableObject, PublisherReceiveable {
        
        typealias Value = [CoinGecko.CoinSimple]
        typealias Complete = NetworkError
        
        private var subscriptions: Set<AnyCancellable> = []
        
        private var allCoins: [CoinGecko.CoinSimple] = []
        
        @Published var searchResults: [CoinGecko.CoinSimple] = []
        
        @Published var searchText = String()
        
        init() {
            getAllCoins()
            setupSearchSubscription()
        }
        
        private func getAllCoins() {
            DataLoader<CoinGeckoAPI>()
                .request([CoinGecko.CoinSimple].self, from: .allCoins())
                .sink(receiveCompletion: onReceiveCompletion,
                      receiveValue: onReceiveValue)
                .store(in: &subscriptions)

        }
        
        private func filterAllCoins(using searchText: String) {
            searchResults = allCoins.filter {
                $0.symbol.lowercased().contains(searchText.lowercased())
                    || $0.name.lowercased().contains(searchText.lowercased())
            }
        }
        
        private func setupSearchSubscription() {
            $searchText
                .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
                .removeDuplicates()
                .map { string -> String? in
                    if string.count < 1 {
                        self.searchResults = []
                        return nil
                    }
                    
                    return string
                } // prevents sending numerous requests and sends nil if the count of the characters is less than 1
                .compactMap { $0 } // removes the nil values so the search string does not get passed down to the publisher chain
                .sink(receiveCompletion: { _ in
                    
                }, receiveValue: { [weak self] searchText in
                    self?.filterAllCoins(using: searchText)
                })
                .store(in: &subscriptions)
        }
        
        internal func onReceiveCompletion(_ completion: Subscribers.Completion<NetworkError>) {
            
            switch completion {
            case .finished:
                break
            case .failure(let error):
                print(error)
            }
        }
        
        internal func onReceiveValue(_ value: [CoinGecko.CoinSimple]) {
            allCoins = value
        }
        
    }
}


protocol PublisherReceiveable {
    associatedtype Value
    associatedtype Complete where Complete: Error
    
    func onReceiveValue(_ value: Value)
    
    func onReceiveCompletion(_ completion: Subscribers.Completion<Complete>)
}

extension PublisherReceiveable {
    func onReceiveCompletion(_ completion: Subscribers.Completion<NetworkError>) {

        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(error)
        }
    }
}
