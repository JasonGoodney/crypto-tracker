//
//  UserState.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 3/16/21.
//

import Foundation

class UserState: ObservableObject {
    @Published var watchlist: [CoinGecko.Coin] = []
    
    init() {
        watchlist = AppUserDefaults.shared.watchlist
    }
}
