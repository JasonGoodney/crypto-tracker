//
//  MarketView.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 2/22/21.
//

import Combine
import SwiftUI

struct MarketView: View {
    @Namespace var topID

    @StateObject private var viewModel = ViewModel()
    
    @State private var showActionSheet = false
    
    @State private var selectedCoin: CoinGecko.Coin?    
    
    var body: some View {
        NavigationView {
            Group {
                ScrollView {
                    MarketHeaderView(viewModel: viewModel)

                    Divider()
                        
                    MarketListView(viewModel: viewModel,
                                   selectedCoin: $selectedCoin)
                }
            }
            .redacted(reason: viewModel.isLoading ? .placeholder : [])
            .disabled(viewModel.isLoading)
            .navigationTitle("Market")
            .navigationBarItems(
                trailing: Button(action: {
                    showActionSheet = true
                }, label: {
                    MarketSortView(sort: viewModel.sort)
                })
            )
            .actionSheet(isPresented: $showActionSheet) {
                ActionSheet(title: Text("Sort By"),
                            buttons: actionSheetButtons())
            }
            .fullScreenCover(item: $selectedCoin) { coin in
                CoinDetailView(coinGeckoId: coin.coinGeckoId, coinSymbol: coin.symbol)
            }
        }
        .onAppear(perform: {
            viewModel.getAll()
        })
    }
    
    private func actionSheetButtons() -> [Alert.Button] {
        var buttons: [Alert.Button] = [.cancel()]
        
        let defaultButtons = CoinGeckoAPI.SortBy.allCases.map { sort in
            Alert.Button.default(Text(sort.text)) {
                withAnimation {
                    viewModel.sort = sort
                }
            }
        }
        
        buttons.append(contentsOf: defaultButtons)
        
        return buttons
    }
}

struct MarketView_Previews: PreviewProvider {
    static var previews: some View {
        MarketView()
    }
}

private extension MarketView {
    struct MarketHeaderView: View {
        @ObservedObject var viewModel: ViewModel
        
        @Environment(\.sizeCategory) var sizeCategory
        
        var body: some View {
            Group {
                switch sizeCategory {
                case .accessibilityMedium,
                     .accessibilityLarge,
                     .accessibilityExtraLarge,
                     .accessibilityExtraExtraLarge,
                     .accessibilityExtraExtraExtraLarge:
                    layoutForAccessibilitySizeCategories
                default:
                    mainLayout
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal)
        }
        
        private var mainLayout: some View {
            HStack(alignment: .center) {
                StatHeaderView(
                    headline: "Market Cap",
                    value: viewModel.globalStats.totalMarketCap.abbreviated)

                Spacer()
                Divider()
                Spacer()

                StatHeaderView(
                    headline: "24H Volume",
                    value: viewModel.globalStats.total24hVolume.abbreviated)

                Spacer()
                Divider()
                Spacer()
                
                StatHeaderView(
                    headline: "BTC Dominance",
                    value: "\(viewModel.globalMarket?.btcDominance.round(to: 2) ?? 0)%")
            }
        }
        
        private var layoutForAccessibilitySizeCategories: some View {
            HStack {
                VStack(alignment: .leading, spacing: 16) {
                    StatHeaderView(
                        headline: "Market Cap",
                        value: viewModel.globalStats.totalMarketCap.abbreviated)

                    StatHeaderView(
                        headline: "24H Volume",
                        value: viewModel.globalStats.total24hVolume.abbreviated)
                    
                    StatHeaderView(
                        headline: "BTC Dominance",
                        value: "\(viewModel.globalMarket?.btcDominance.round(to: 2) ?? 0)%")
                }
                
                Spacer()
            }
        }
    }

    struct MarketListView: View {
        @ObservedObject var viewModel: ViewModel
        
        @Binding var selectedCoin: CoinGecko.Coin?
        
        var body: some View {
            InfiniteScrollList<CoinGecko.Coin, ListingRow>(
                items: viewModel.pagingState.items,
                isLoading: viewModel.pagingState.canLoadNextPage,
                onScrolledAtBottom: viewModel.getCoins,
                onRowTapped: { coin in
                    selectedCoin = coin
                }, content: { coin -> ListingRow in
                    ListingRow(listing: coin, measure: viewModel.sort.measure)
                })
                .padding(.horizontal)
        }
    }
    
    struct MarketSortView: View {
        let sort: CoinGeckoAPI.SortBy
        
        var symbolName: String {
            switch sort {
            case .marketCapDescending, .volumeDescending:
                return "chevron.down"
            case .marketCapAscending, .volumeAscending:
                return "chevron.up"
            }
        }
        
        var body: some View {
            HStack {
                Text(sort.measureShort)
                Image(systemName: symbolName)
            }
        }
    }
}
