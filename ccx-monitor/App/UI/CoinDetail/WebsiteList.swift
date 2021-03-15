//
//  WebsiteList.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 3/6/21.
//

import SwiftUI

struct Website {
    let name: String
    let uri: String
}

struct WebsiteList: View {
    
    let links: CoinGecko.CoinInfo.Links
    
    var body: some View {
        List {
            
        }
    }
}

struct WebsiteRow: View {
    let website: Website
    var body: some View {
        HStack {
            Text(website.name)
                .font(.headline)
        }
    }
}

struct WebsiteList_Previews: PreviewProvider {
    static var previews: some View {
        WebsiteList(links: CoinGecko.CoinInfo.Links(homepage: ["homepage"], blockchainSite: ["blockchain"], officialForumURL: ["message board"], twitterScreenName: "Twitter", facebookUsername: "Facebook", telegramChannelIdentifier: "Telegram", subredditURL: "Reddit", reposURL: CoinGecko.CoinInfo.ReposURL(github: ["Github"], bitbucket: ["bitbucket"])))
    }
}
