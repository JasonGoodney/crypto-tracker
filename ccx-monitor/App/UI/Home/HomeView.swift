//
//  HomeView.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 2/28/21.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = ViewModel()
    
    @State private var selectedCoin: CoinGecko.Coin?
    
    @EnvironmentObject var userState: UserState
    
    var body: some View {
        NavigationView {
            ZStack {
                EmptyStateView()
                    .unredacted()
                
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        TodaysDateTitle()
                        
                        MarketCapChangePercentageTitle(
                            percentage: viewModel.percentChange24h.decimals(2))
                    }
                    .padding(.leading)
                    
                    ScrollView(showsIndicators: false) {
                        LazyVStack(alignment: .leading, spacing: 32) {
                            HomeWatchlist(viewModel: viewModel,
                                          onCoinTapped: onCoinTapped)
                            
                            HListSection(title: "Top Coins",
                                         items: viewModel.topCoins) { coin in
                                
                                TopCoinCard(coin: coin)
                                    .padding(.bottom)
                                    .padding(.trailing, 10)
                                    .onTapGesture { onCoinTapped(coin) }
                            }
                            .padding(.horizontal)
                            
                            HListSection(title: "Top Gainers",
                                         items: viewModel.topGainers) { coin in
                                
                                TopCoinCard(coin: coin)
                                    .padding(.bottom)
                                    .padding(.trailing, 10)
                                    .onTapGesture { onCoinTapped(coin) }
                            }
                            .padding(.horizontal)
                            
                            HListSection(title: "Top Losers",
                                         items: viewModel.topLosers) { coin in
                                
                                TopCoinCard(coin: coin)
                                    .padding(.bottom)
                                    .padding(.trailing, 10)
                                    .onTapGesture { onCoinTapped(coin) }
                            }
                            .padding(.horizontal)
                            
                            LazyVStack(alignment: .leading) {
                                Text("Top News")
                                    .sectionTitleStyle()
                                
                                ForEach(viewModel.topNews) { newsArticle in
                                    NewsArticleRow(newsArticle: newsArticle)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .background(Color(UIColor.systemBackground).opacity(0.95))
            }
            .navigationBarHidden(true)
            .redacted(reason: viewModel.isLoading ? .placeholder : [])
            .disabled(viewModel.isLoading)
            .refreshable {
                viewModel.getAll()
            }
            .sheet(item: $selectedCoin) { coin in
                CoinDetailView(coinGeckoId: coin.coinGeckoId, coinSymbol: coin.symbol)
                    .environmentObject(userState)
            }
            .onAppear(perform: viewModel.getAll)
        }
    }
    
    // MARK: - Methods
    private func onCoinTapped(_ coin: CoinGecko.Coin) {
        selectedCoin = coin
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

private extension HomeView {
    struct HomeWatchlist: View {
        @State private var isWatchlistCollapsed = true
                
        @ObservedObject var viewModel: ViewModel
                
        @EnvironmentObject var userState: UserState
        
        var onCoinTapped: (CoinGecko.Coin) -> Void

        var body: some View {
            VStack(alignment: .leading) {
                Text("Watchlist")
                    .sectionTitleStyle()
                
                if userState.watchlist.isEmpty {
                    EmptyWatchlistView()
                } else {
                    ForEach(isWatchlistCollapsed ? Array(userState.watchlist[..<min(userState.watchlist.count, 5)]) : userState.watchlist) { coin in
//                    ForEach(userState.watchlist) { coin in
                        ListingRow(listing: coin)
                            .onTapGesture { onCoinTapped(coin) }
                    }
                    .padding(.bottom, 10)
        
                    if userState.watchlist.count > 5 {
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
