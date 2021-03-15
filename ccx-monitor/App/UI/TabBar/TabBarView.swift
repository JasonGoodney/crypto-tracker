//
//  TabBarView.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 3/8/21.
//

import SwiftUI

struct TabBarView: View {
    
    @EnvironmentObject private var uiState: UIState
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(UIState.Tab.home)
        
            MarketView()
                .tabItem {
                    Label("Market", systemImage: "list.bullet.below.rectangle")
                }
                .tag(UIState.Tab.market)
        
            NewsView()
                .tabItem {
                    Label("News", systemImage: "newspaper.fill")
                }
                .tag(UIState.Tab.news)
        
            SettingsView()
                .tabItem {
                    Label("Settings ", systemImage: "ellipsis.circle.fill")
                }
                .tag(UIState.Tab.settings)
        }
        .accentColor(.primary)
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
