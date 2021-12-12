//
//  WebsiteList.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 3/6/21.
//

import SwiftUI
import BetterSafariView

struct Website {
    let name: String
    let uri: String
}

private struct WebsiteRow: View {
    let website: Website
    
    @State private var showSafariView = false
    
    @EnvironmentObject var userState: UserState
    
    var body: some View {
        VStack {
            HStack {
                Text(website.name)
                    .font(.footnote)
                    .fontWeight(.medium)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(Font.footnote.weight(.bold))
                    .foregroundColor(Color.black.opacity(0.2))
            }
            
            Divider()
        }
//        .padding(.horizontal)
        .padding(.vertical, 2)
        .contentShape(Rectangle())
        .onTapGesture {
            showSafariView = true
        }
        .safariView(isPresented: $showSafariView) {
            let uri = website.uri.replacingOccurrences(of: "http:", with: "https:")
            return SafariView(url: URL(string: uri)!)
        }
    }
}

struct WebsiteList: View {
    let links: CoinGecko.Links
    
    var body: some View {
        VStack(alignment: .leading) {
            homepages
            
            explorers
            
            forum
            
            community
            
            sourceCode
        }
    }
    
    private var homepages: some View {
        links.home.map {
            WebsiteRow(website: $0)
        }
    }
    
    private var explorers: some View {
        links.blockchainExplorer.map {
            WebsiteRow(website: $0)
        }
    }
    
    private var forum: some View {
        links.forum.map {
            WebsiteRow(website: $0)
        }
    }
    
    private var community: some View {
        Group {
            links.twitter.map {
                WebsiteRow(website: $0)
            }
            
            links.facebook.map {
                WebsiteRow(website: $0)
            }
            
            links.reddit.map {
                WebsiteRow(website: $0)
            }
        }
    }
    
    private var sourceCode: some View {
        Group {
            links.github.map {
                WebsiteRow(website: $0)
            }
     
            links.bitbucket.map {
                WebsiteRow(website: $0)
            }
        }
    }
}

struct WebsiteList_Previews: PreviewProvider {
    static var previews: some View {
        WebsiteList(links: CoinGecko.Links(
            homepage: ["http://www.bitcoin.org", "", ""],
            blockchainSite: ["https://blockchair.com/bitcoin/",
                             "https://btc.com/",
                             "https://btc.tokenview.com/", "", ""],
            officialForumUrl: ["message board"],
            twitterScreenName: "Twitter",
            facebookUsername: "Facebook",
            telegramChannelIdentifier: "Telegram",
            subredditUrl: "Reddit",
            reposUrl: CoinGecko.ReposUrl(
                github: ["https://github.com/bitcoin/bitcoin",
                         "https://github.com/bitcoin/bips"],
                bitbucket: ["bitbucket"])))
    }
}
