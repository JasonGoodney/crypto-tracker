//
//  PagingState.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 2/27/21.
//

import Foundation

struct PagingState<T> where T: Codable {
    var items: [T] = []
    var page: Int = 1
    var canLoadNextPage = true
    var pageLimit: Int? = nil
    
    var pageLimitReach: Bool {
        page == pageLimit
    }
    
    init(pageLimit: Int? = nil) {
        self.pageLimit = pageLimit
    }
}
