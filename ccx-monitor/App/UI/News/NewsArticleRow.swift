//
//  NewsArticleRow.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 2/28/21.
//

import SwiftUI
import BetterSafariView

struct NewsArticleRow: View {
    
    let newsArticle: CryptoPanic.NewsArticle
    
    @State private var showSafariView = false
        
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    
                    if let currencies = newsArticle.currencies {
                        HStack(spacing: 4) {
                            ForEach(currencies, id: \.self) { currency in
                                Text(currency.code)
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.vertical, 3)
                                    .padding(.horizontal, 6)
                                    .background(Color.dodgerBlue)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                    
                    Text(newsArticle.title)
                        .fontWeight(.bold)
                        
                    HStack {
                        Text(newsArticle.publishedAt.toDate().format(as: "MMMM d"))
                        Text("•")
                        Text(newsArticle.source.title)
                            .fontWeight(.semibold)
                    }
                    .font(.callout)
                    .foregroundColor(.gray)
                }
                
                Spacer()
            }
            Divider()
        }
        .onTapGesture {
            showSafariView = true
        }
        .safariView(isPresented: $showSafariView) {
            SafariView(url: newsArticle.url)
        }
    }
}

struct NewsArticleRow_Previews: PreviewProvider {
    static var previews: some View {
        NewsArticleRow(newsArticle: CryptoPanic.NewsArticle.demo)
    }
}
