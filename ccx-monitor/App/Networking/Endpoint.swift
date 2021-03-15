//
//  Endpoint.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 2/22/21.
//

import Foundation

class Endpoint: URLRequestable {
    let path: String
    let queryItems: [URLQueryItem]
    
    init(path: String, queryItems: [URLQueryItem] = []) {
        self.path       = path
        self.queryItems = queryItems
    }
    
    func urlRequest() -> URLRequest? {
        return nil
    }
}
