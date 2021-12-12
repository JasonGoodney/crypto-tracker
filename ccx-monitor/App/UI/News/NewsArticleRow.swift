//
//  NewsArticleRow.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 2/28/21.
//

import SwiftUI

struct NewsArticleRow: View {
    
    let newsArticle: CryptoPanic.NewsArticle
        
    @Environment(\.sizeCategory) var sizeCategory
        
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    
                    if let currencies = newsArticle.currencies {
                        ScrollView(.horizontal, showsIndicators: false) {
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
                    }
                    
                    Text(newsArticle.title)
                        .fontWeight(.semibold)
                    
                    Group {
                        switch sizeCategory {
                        case .accessibilityMedium,
                             .accessibilityLarge,
                             .accessibilityExtraLarge,
                             .accessibilityExtraExtraLarge,
                             .accessibilityExtraExtraExtraLarge:
                            
                            VStack(alignment: .leading) {
                                Text(newsArticle.publishedAt.toDate().format(as: "MMMM d"))

                                Text(newsArticle.source.title)
                                    .fontWeight(.semibold)
                            }
                        default:
                            HStack {
                                Text(newsArticle.publishedAt.toDate().format(as: "MMMM d"))
                                Text("•")
                                Text(newsArticle.source.title)
                                    .fontWeight(.semibold)
                            }
                        }
                    }
                    .font(.callout)
                    .foregroundColor(.gray)
                        
                }
                
                Spacer()
            }
            Divider()
        }
    }
}

struct NewsArticleRow_Previews: PreviewProvider {
    static var previews: some View {
        NewsArticleRow(newsArticle: CryptoPanic.NewsArticle.demo)
    }
}
