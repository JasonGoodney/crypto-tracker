//
//  CoinsPath.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 2/22/21.
//

import Foundation

enum CoinsPath {
    case id(id: String)
    case list
    case markets
    case tickers(id: String)
    case history(id: String)
    case statusUpdates(id: String)
    case marketChart(id: String)
    case range
}

extension CoinsPath {
    var urlPath: String {
        switch self {
        case .id             : return ""
        case .list           : return "list"
        case .markets        : return "markets"
        case .tickers        : return "tickers"
        case .history        : return "history"
        case .statusUpdates  : return "status_updates"
        case .marketChart    : return "market_chart"
        case .range          : return "range"
        }
    }
}
