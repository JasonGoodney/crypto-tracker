//
//  TabViewState.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 3/13/21.
//

import Foundation

class TabViewState: ObservableObject {
    @Published var selectedTab: Tab = .home
}
