//
//  NetworkError.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 2/22/21.
//

import Foundation

enum NetworkError: Error {
    case invalidURL(message: String? = nil)
    case requestFailed(message: String? = nil)
    case unknown(message: String? = nil)
    case decoding(message: String? = nil)
}
