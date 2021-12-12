//
//  ccx_monitorApp.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 9/28/20.
//

// swiftlint:disable type_name

import SwiftUI

@main
struct ccx_monitorApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
            
    @StateObject var userState = UserState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userState)
        }
    }
}


//https://icon-icons.com/icon/generic-crypto-cryptocurrency-cryptocurrencies-cash-money-bank-payment/95038
// swiftlint:enable type_name
