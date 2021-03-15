//
//  ccx_monitorApp.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 9/28/20.
//

import SwiftUI

@main
struct ccx_monitorApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
        
    @StateObject var appStateContainer = AppStateContainer()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AppUserDefaults.shared)
//                .environmentObject(appStateContainer)
//                .environmentObject(appStateContainer.tabViewState)
        }
    }
}


//https://icon-icons.com/icon/generic-crypto-cryptocurrency-cryptocurrencies-cash-money-bank-payment/95038
