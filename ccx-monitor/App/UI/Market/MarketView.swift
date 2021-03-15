//
//  MarketView.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 2/22/21.
//

import SwiftUI
import Combine

struct MarketView: View {
    
    @StateObject private var viewModel = ViewModel()
    
    @State private var showActionSheet = false
    
    @State private var selectedCoin: CoinGecko.CoinMarketData? = nil
    
    @Namespace var topID
    
    var body: some View {
        NavigationView {

            Group {
                if viewModel.pagingState.items.isEmpty {
                    EmptyStateView()
                } else {
                    ScrollView {
                        MarketHeaderView(viewModel: viewModel)

                        Divider()
                        
                        MarketListView(viewModel: viewModel)
                    }
                }
            }
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
                            buttons: actionSheetButtons()
                )
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
        }}
        
        buttons.append(contentsOf: defaultButtons)
        
        return buttons
    }
}

struct MarketsView_Previews: PreviewProvider {
    static var previews: some View {
        MarketView()
    }
}


fileprivate extension MarketView {
    
    struct MarketHeaderView: View {
        
        @ObservedObject var viewModel: ViewModel
        
        var body: some View {
            HStack(alignment: .center) {
                StatHeaderView(
                    headline: "Market Cap",
                    value: viewModel.globalStats.totalMarketCap.abbreviated)

                Spacer()
                Divider()
                Spacer()

                StatHeaderView(
                    headline: "24H Volume",
                    value: viewModel.globalStats.total24hVolume.abbreviated,
                    valueChange: viewModel.globalMarket?.marketCapChangePercentage24HUsd)

                Spacer()
                Divider()
                Spacer()
                
                StatHeaderView(
                    headline: "BTC Dominance",
                    value: "\(viewModel.globalMarket?.btcDominance.round(to: 2) ?? 0)%")
            }
            .padding(.vertical, 10)
            .padding(.horizontal)
        }
    }

    struct MarketListView: View {
        
        @ObservedObject var viewModel: ViewModel
        
        var body: some View {
            InfiniteScrollList<CoinGecko.CoinMarketData, ListingRow>(
                items: viewModel.pagingState.items,
                isLoading: viewModel.pagingState.canLoadNextPage,
                onScrolledAtBottom: viewModel.getCoins,
                onRowTapped: { coin in
                    print(coin.name)
                }, content: { coin -> ListingRow in
                    ListingRow(listing: coin, measure: viewModel.sort.measure)
                }
            )
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
