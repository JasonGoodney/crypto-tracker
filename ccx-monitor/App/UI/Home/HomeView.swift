//
//  HomeView.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 2/28/21.
//

import SwiftUI

struct HomeView: View {
 
    @StateObject private var viewModel = ViewModel()
        
    @State private var isWatchlistCollapsed = true
    
    @State private var selectedCoin: CoinGecko.CoinMarketData? = nil
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    NavigationBarTitleView()
                    MarketCapChangePercentageTitle(percentage: viewModel.percentChange24h.decimals(2))
                        
                }
                .padding(.leading)
                
                ScrollView(showsIndicators: false) {
                    LazyVStack(alignment: .leading, spacing: 32) {
                        
                        HomeWatchlist(viewModel: viewModel,
                                      onCoinTapped: onCoinTapped)
                        
                        HListSection(title: "Top Coins",
                                     items: viewModel.topCoins) { coin in
                            
                            NavigationLink(destination: CoinDetailView(coin: coin)) {
                            TopCoinCard(coin: coin)
                                .padding(.vertical)
                                .padding(.horizontal, 10)
//                                .onTapGesture { onCoinTapped(coin) }
                            }
                        }
            
                        HListSection(title: "Top Gainers",
                                     items: viewModel.topGainers) { coin in
                            
                            TopCoinCard(coin: coin)
                                .padding(.vertical)
                                .padding(.horizontal, 10)
                                .onTapGesture { onCoinTapped(coin) }
                        }
                        
                        HListSection(title: "Top Losers",
                                     items: viewModel.topLosers) { coin in
                            
                            TopCoinCard(coin: coin)
                                .padding(.vertical)
                                .padding(.horizontal, 10)
                                .onTapGesture { onCoinTapped(coin) }
                        }
                        
                        LazyVStack(alignment: .leading) {
                            
                            Text("Top News")
                                .sectionTitleStyle()
                                .padding(.bottom)
                              
                            ForEach(viewModel.topNews) { newsArticle in
                                NewsArticleRow(newsArticle: newsArticle)
                            }
                            
                        }
                        .padding(.horizontal)
                    }
                }
            }
        
            .navigationBarHidden(true)
            .sheet(item: $selectedCoin) { coin in
                CoinDetailView(coin: coin)
            }
            .onAppear(perform: {
                viewModel.getGlobalMarket()
                viewModel.getNews()
                viewModel.getTopCoins()
                viewModel.getWatchlist()
            })
        }
    }
    
    // MARK: - Methods
    
    private func onCoinTapped(_ coin: CoinGecko.CoinMarketData) {
        selectedCoin = coin
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

fileprivate extension HomeView {
    
    struct HomeWatchlist: View {
        @State private var isWatchlistCollapsed = true
                
        @ObservedObject var viewModel: ViewModel
        
        var onCoinTapped: (CoinGecko.CoinMarketData) -> ()
        
        var body: some View {
            VStack(alignment: .leading) {
                Text("Watchlist")
                    .sectionTitleStyle()
                    .padding(.bottom)
                
                if viewModel.watchlist.isEmpty {
                    EmptyWatchlistView()
                } else {
                    ForEach(isWatchlistCollapsed ? viewModel.watchlistCollapsed : viewModel.watchlist) { coin in
                            ListingRow(listing: coin)
                                .onTapGesture { onCoinTapped(coin) }
                    }
                    .padding(.bottom, 10)
        
                    if viewModel.watchlist.count > 5 {
                        HStack {
                            Spacer()
                           
                            Button(action: toggleWatchlist) {
                               Text(isWatchlistCollapsed ? "View More" : "View Less")
                            }
                            .buttonStyle(SecondaryButtonStyle())
                            
                            Spacer()
                       }
                    }
                }
                
            }
            .padding(.horizontal)
        }
        
        // MARK: - Methods
        
        private func toggleWatchlist() {
            withAnimation {
                isWatchlistCollapsed.toggle()
            }
        }
    }
}

