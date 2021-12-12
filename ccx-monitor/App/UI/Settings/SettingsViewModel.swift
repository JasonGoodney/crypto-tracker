//
//  SettingsViewModel.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 3/13/21.
//

import Foundation

extension SettingsView {
    
    class ViewModel: ObservableObject {
        
        // MARK: - Properties
        
        @Published var watchlist: [CoinGecko.Coin] = []
        
        // MARK: Methods
        
        func loadFromUserDefaults() {
            watchlist = AppUserDefaults.shared.watchlist
            watchlist.sort()
        }
        
        func delete(at offsets: IndexSet) {
            watchlist.remove(atOffsets: offsets)
            AppUserDefaults.shared.watchlist = watchlist
        }
    }
}
