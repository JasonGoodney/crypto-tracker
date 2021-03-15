//
//  UIState.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 3/8/21.
//

import Foundation
import SwiftUI

class UIState: ObservableObject {
    
    @Published var selectedTab = Tab.home
    
    public static let shared = UIState()
    
    private init() {}
    
    enum Tab: Int {
        case home, market, news, settings
    }

}
