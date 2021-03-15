//
//  CoinDetailView.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 2/28/21.
//

import SwiftUI

struct CoinDetailView: View {
    
    @State private var isInWatchlist = false
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var appUserDefaults: AppUserDefaults
    
    @ObservedObject private var viewModel: ViewModel
         
    init(coin: CoinGecko.CoinMarketData) {
        self.viewModel  = ViewModel(coin: coin)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    AsyncImage(url: URL(string: viewModel.coin.marketData.image!)!,
                                placeholder: {
                                        Image(systemName: "bitcoinsign.circle.fill")
                                            .resizable()
                                },
                                image: {
                                        Image(uiImage: $0)
                                            .resizable()
                                })
                        .frame(width: 32, height: 32)
                    Text(viewModel.coin.marketData.name)
                    Text(viewModel.coin.marketData.symbol.uppercased())
                    
                    LazyVStack(alignment: .leading) {
                        
                        Text("Related News")
                            .sectionTitleStyle()
                            .padding(.bottom)
                          
                        ForEach(viewModel.topNews) { newsArticle in
                            NewsArticleRow(newsArticle: newsArticle)
                        }
                        
                    }
                    .padding(.horizontal)
                }
            }
            .navigationBarItems(
                trailing:
                    HStack(alignment: .center, spacing: 20) {
                        addToWatchlistButton
                        dismissButton
                    }
                    .padding(.top, 10)
            )
        }
        .onAppear {
            viewModel.getCoin()
            viewModel.getNews()
            viewModel.loadFromUserDefaults()
        }
    }
    
    private var addToWatchlistButton: some View {
        LikeButton(action: { _ in
//            var watchlist = UserDefaults.standard.value(for: .watchlist) as? [String] ?? []
            var watchlist = AppUserDefaults.shared.watchlist
            let id = viewModel.coin.marketData.coinGeckoId.lowercased()
            if watchlist.contains(id) {
//                deleteFromUserDefaults(viewModel.coin)
                delete(id, from: &watchlist)
//                AppUserDefaults.shared.watchlist = watchlist
//                isInWatchlist = false
                print("removed to watchlist")
            } else {            
//                addToUserDefaults(viewModel.coin)
                add(id, to: &watchlist)
//                AppUserDefaults.shared.watchlist = watchlist
                
//                isInWatchlist = true
                print("added to watchlist")
            }
            
            appUserDefaults.watchlist = watchlist
        })
        
    }
    
    private var dismissButton: some View {
        BarButtonItem(symbolName: "xmark.circle.fill") {
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    
    func deleteFromUserDefaults(_ coin: CoinGecko.Coin) {
        var watchlist = AppUserDefaults.shared.watchlist
        let id = coin.marketData.coinGeckoId.lowercased()
        watchlist.removeAll(where: { $0 == id })
//            UserDefaults.standard.set(watchlist, for: .watchlist)
        isInWatchlist = false
        AppUserDefaults.shared.watchlist = watchlist
    }
    
    func delete(_ id: String, from watchlist: inout [String]) {
        watchlist.removeAll(where: { $0 == id })
    }
    
    func add(_ id: String, to watchList: inout [String]) {
        watchList.append(id)
    }
    
    func addToUserDefaults(_ coin: CoinGecko.Coin) {
        var watchlist = AppUserDefaults.shared.watchlist
        let id = coin.marketData.coinGeckoId.lowercased()
        watchlist.append(id)
//            UserDefaults.standard.set(watchlist, for: .watchlist)
        AppUserDefaults.shared.watchlist = watchlist
        isInWatchlist = true
    }
}

struct BarButtonItem: View {
    
    var text: String? = nil
    
    var symbolName: String? = nil
    
    var handleOnTap: () -> Void
    
    init(text: String,
         handleOnTap: @escaping () -> Void) {
        
        self.text = text
        self.handleOnTap = handleOnTap
    }
    
    init(symbolName: String,
         handleOnTap: @escaping () -> Void) {
        
        self.symbolName = symbolName
        self.handleOnTap = handleOnTap
    }
    
    var body: some View {
        Button(action: handleOnTap) {
            if let text = text {
                Text(text)
            } else if let symbolName = symbolName {
                Image(systemName: symbolName)
                .resizable()
                .frame(width: 32, height: 32)
                .foregroundColor(Color.black.opacity(0.3))
            }
        }
    }
}

struct CoinDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CoinDetailView(coin: CoinGecko.CoinMarketData.default)
    }
}
