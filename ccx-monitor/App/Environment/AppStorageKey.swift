//
//  AppStorageKey.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 3/8/21.
//

import Foundation

enum AppStorageKey {
    static let didLaunchBefore = "didLaunchBefore"

    static let savedVersion = "savedVersion"

    static let watchlist = "watchlist"
}

public extension UserDefaults {
    struct Key<Value> {
        fileprivate let name: String
        public init(_ name: String) {
            self.name = name
        }
    }

    func value<Value>(for key: Key<Value>) -> Any? {
        return object(forKey: key.name)
    }

    func set<Value>(_ value: Any?, for key: Key<Value>) {
        set(value, forKey: key.name)
    }

    func removeValue<Value>(for key: Key<Value>) {
        removeObject(forKey: key.name)
    }
}

extension UserDefaults.Key where Value == [CoinGecko.Coin] {
    static let watchlist = Self(AppStorageKey.watchlist)
}
