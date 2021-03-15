//
//  ContentView.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 9/28/20.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var tabViewState: TabViewState
    
    @State private var showWhatsNew = false
    
    init() {
        UITabBar.appearance().tintColor = UIColor.label
    }
    
    var body: some View {
        tabView
            .accentColor(.primary)
            .environmentObject(AppUserDefaults.shared)
            .sheet(isPresented: $showWhatsNew, content: { WhatsNewView() })
            .onAppear(perform: {
                AppVersion.checkForUpdate {
                    showWhatsNew = true
                }
            })
    }
    
    private var tabView: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(Tab.home)

            MarketView()
                .tabItem {
                    Label("Market", systemImage: "square.stack.3d.up.fill")
                }
                .tag(Tab.markets)

            NewsView()
                .tabItem {
                    Label("News", systemImage: "newspaper.fill")
                }
                .tag(Tab.news)

            SettingsView()
                .tabItem {
                    Label("Settings ", systemImage: "gearshape.fill")
                }
                .tag(Tab.settings)
        }
    }
    
    private var uiKitTabView: some View {
        UIKitTabView {
            HomeView().tab(title: "Home", image: "house.fill")
            
            MarketView().tab(title: "Market", image: "list.bullet.below.rectangle")
            
            NewsView().tab(title: "News", image: "newspaper.fill")
            
            SettingsView().tab(title: "Settings", image: "ellipsis.circle.fill")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
