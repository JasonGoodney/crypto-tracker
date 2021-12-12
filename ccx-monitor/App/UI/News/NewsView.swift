//
//  NewsView.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 2/27/21.
//

import SwiftUI
import Combine
import BetterSafariView

struct NewsView: View {
    
    @StateObject var viewModel = ViewModel()
        
    @State private var showActionSheet = false
    
    @State private var selectedNewsArticle: CryptoPanic.NewsArticle?
    
    @Environment(\.openURL) var openURL

    var body: some View {
        NavigationView {
            ScrollView {
                InfiniteScrollList<CryptoPanic.NewsArticle, NewsArticleRow>(
                    items: viewModel.pagingState.items,
                    itemLimitReached: viewModel.pageLimitReached,
                    isLoading: viewModel.pagingState.canLoadNextPage,
                    onScrolledAtBottom: viewModel.getNews,
                    onRowTapped: onRowTapped,
                    content: {
                        NewsArticleRow(newsArticle: $0)
                    }
                )
                .padding()
            }
            .redacted(reason: viewModel.isLoading ? .placeholder : [])
            .navigationBarTitle("\(viewModel.filter.text)")
            .navigationBarItems(trailing: trailingBarItem)
            .actionSheet(isPresented: $showActionSheet) {
                ActionSheet(title: Text("Filter By"),
                            buttons: actionSheetButtons()
                )
            }
            .disabled(viewModel.isLoading)
        }
        .onAppear(perform: viewModel.getAll)
        .safariView(item: $selectedNewsArticle) { newsArticle in
            SafariView(url: newsArticle.url)
        }
    }
    
    private var trailingBarItem: some View {
        Button(action: {
            showActionSheet = true
        }, label: {
            Image(systemName: "line.horizontal.3.decrease.circle")
                .resizable()
                .frame(width: 24, height: 24)
        })
    }
    
    private func actionSheetButtons() -> [Alert.Button] {
        var buttons: [Alert.Button] = [.cancel()]
        
        let defaultButtons = CryptoPanicAPI.Filter.allCases.map { filter in Alert.Button.default(Text(filter.text)) {
            viewModel.filter = filter
        }}
        
        buttons.append(contentsOf: defaultButtons)
        
        return buttons
    }
    
    private func onRowTapped(_ newsArticle: CryptoPanic.NewsArticle) {
        selectedNewsArticle = newsArticle
    }
}

struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        NewsView()
    }
}
