//
//  NewsView.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 2/27/21.
//

import SwiftUI
import Combine

struct NewsView: View {
    
    @StateObject var viewModel = ViewModel()
        
    @State private var showActionSheet = false
    
    @Environment(\.openURL) var openURL

    var body: some View {
        NavigationView {
            ScrollView {
                InfiniteScrollList<CryptoPanic.NewsArticle, NewsArticleRow>(
                    items: viewModel.pagingState.items,
                    itemLimitReached: viewModel.pageLimitReached,
                    isLoading: viewModel.pagingState.canLoadNextPage,
                    onScrolledAtBottom: viewModel.getNews,
                    content: {
                        NewsArticleRow(newsArticle: $0)
                    }
                )
                .padding()
            }
            .navigationBarTitle("\(viewModel.filter.text)")
            .navigationBarItems(trailing: Button(action: {
                showActionSheet = true
            }, label: {
                Image(systemName: "line.horizontal.3.decrease.circle")
                    .resizable()
                    .frame(width: 24, height: 24)
            }))
            .actionSheet(isPresented: $showActionSheet) {
                ActionSheet(title: Text("Filter By"),
                            buttons: actionSheetButtons()
                )
            }
        }
        .onAppear(perform: viewModel.onAppear)
    }
    
    func actionSheetButtons() -> [Alert.Button] {
        var buttons: [Alert.Button] = [.cancel()]
        
        let defaultButtons = CryptoPanicAPI.Filter.allCases.map { filter in Alert.Button.default(Text(filter.text)) {
            viewModel.filter = filter
        }}
        
        buttons.append(contentsOf: defaultButtons)
        
        return buttons
    }
}

struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        NewsView()
    }
}
