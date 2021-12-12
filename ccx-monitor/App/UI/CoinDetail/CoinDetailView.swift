//
//  CoinDetailView.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 2/28/21.
//

import SwiftUI
import BetterSafariView

struct CoinDetailView: View {
    @State private var isInWatchlist = false
    
    @State private var selectedNewsArticle: CryptoPanic.NewsArticle?
    
    @State var backgroundColor: Color = .clear
    
    @State var showTopView = true
    
    @StateObject private var viewModel: ViewModel

    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var userState: UserState

    init(coinGeckoId: String, coinSymbol: String) {
        _viewModel = StateObject(wrappedValue: ViewModel(coinGeckoId: coinGeckoId, coinSymbol: coinSymbol))
    }
         
    var body: some View {
//        ZStack(alignment: .topTrailing) {
        NavigationView {

            ScrollView(showsIndicators: false) {
                VStack {
//                    viewModel.coin.map { coin in
//                        CoinDetailHeroView(coin: coin,
//                                           showTopView: $showTopView)
//                    }
                    
                    statistics24h
                    
                    statisticsMarket
                    
                    websites
                    
                    relatedNews
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        icon
                        name
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    trailingBarItems
                }
                
            }
            
//            if showTopView {
//                HStack {
//                    icon
//                    name
//                    Spacer()
//
//                    trailingBarItems
//                }
//                .padding([.bottom, .horizontal])
//                .background(BlurBackground())
//            }
            
//            trailingBarItems
//                .padding(.trailing)
        }
        .edgesIgnoringSafeArea(.top)
        .redacted(reason: viewModel.isLoading ? .placeholder : [])
        .disabled(viewModel.isLoading)
        .onAppear {
            viewModel.getAll()
            isInWatchlist = userState.watchlist.contains(where: { $0.coinGeckoId == viewModel.coinGeckoId })
        }
        .safariView(item: $selectedNewsArticle) { newsArticle in
            SafariView(url: newsArticle.url)
        }
        .interactiveDismissDisabled()
    }
    
    private var icon: some View {
        viewModel.coin.map { coin in
//            AsyncImage(url: URL(string: coin.image!)!,
//                       placeholder: {
//                           Image(systemName: "bitcoinsign.circle.fill").resizable()
//                       },
//                       image: {
//                           Image(uiImage: $0).resizable()
//                       })
            AsyncImage(url: URL(string: coin.image!)!, scale: 2) { image in
                image.resizable()
            } placeholder: {
                Image(systemName: "bitcoinsign.circle.fill")
                 .resizable()
            }
                .frame(width: 32, height: 32)
        }
    }

    private var name: some View {
        viewModel.coin.map { coin in
            Text(coin.name)
                .bold()
                .shadow(color: Color.gray,
                        radius: 1.0)
        }
    }
    
    private var statistics24h: some View {
        viewModel.coin.map { coin in
            StatisticList(title: "Price (24h)",
                          statistics: [
                              (name: "24h Volume", value: coin.marketCapChange24H?.toCurrency()),
                              (name: "High", value: coin.high24H?.toCurrency()),
                              (name: "Low", value: coin.low24H?.toCurrency()),
                              (name: "Change", value: coin.priceChange24H?.toCurrency())
                          ])
                .padding()
        }
    }
    
    private var statisticsMarket: some View {
        viewModel.coin.map { coin in
            StatisticList(title: "Market Stats",
                          statistics: [
                              (name: "Rank", value: "\(coin.marketCapRank.map(String.init) ?? "-")"),
                              (name: "Circulating", value: coin.marketCap?.toCurrency()),
                              (name: "Max Supply", value: coin.maxSupply?.toCurrency()),
                              (name: "Total Supply", value: coin.totalSupply?.toCurrency())
                          ])
                .padding()
        }
    }
    
    private var websites: some View {
        viewModel.coinPlusPlus?.links.map { links in
            VStack(alignment: .leading) {
                Text("Community")
                    .sectionHeadline2Style()

                LazyVStack {
                    WebsiteList(links: links)
                }
            }
            .padding()
        }
    }
    
    private var relatedNews: some View {
        viewModel.topNews.map { news in
            LazyVStack(alignment: .center) {
                HStack {
                    Text("Related News")
                        .sectionHeadline2Style()
                    
                    Spacer()
                }
                  
                ForEach(news) { newsArticle in
                    NewsArticleRow(newsArticle: newsArticle)
                        .onTapGesture {
                            onRowTapped(newsArticle)
                        }
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var addToWatchlistButton: some View {
        viewModel.coin.map { coin in
            LikeButton(isPressed: isInWatchlist, action: { _ in
                if userState.watchlist.contains(coin) {
                    userState.watchlist
                        .removeAll(where: { $0.coinGeckoId == coin.coinGeckoId })
                } else {
                    userState.watchlist.append(coin)
                }
                
                AppUserDefaults.shared.watchlist = userState.watchlist
            })
            .frame(width: 32, height: 32)
                
            
        }
    }
    
    private var dismissButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            Image(systemName: "xmark.circle.fill")
                .resizable()
        })
        .buttonStyle(NavigationButtonStyle())
    }
    
    private var trailingBarItems: some View {
        HStack(alignment: .center, spacing: 20) {
            addToWatchlistButton
            dismissButton
        }
//        .padding(.top, 10)
    }
    
    private func onRowTapped(_ newsArticle: CryptoPanic.NewsArticle) {
        selectedNewsArticle = newsArticle
    }
}

struct CoinDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CoinDetailView(coinGeckoId: CoinGecko.Coin.example.coinGeckoId,
                       coinSymbol: CoinGecko.Coin.example.symbol)
            .environmentObject(UserState())
    }
}
