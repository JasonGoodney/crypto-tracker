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

extension UserDefaults {

  public struct Key<Value> {
    fileprivate let name: String
    public init(_ name: String) {
      self.name = name
    }
  }

  public func value<Value>(for key: Key<Value>) -> Any? {
    return object(forKey: key.name)
  }

  public func set<Value>(_ value: Any?, for key: Key<Value>) {
    set(value, forKey: key.name)
  }

  public func removeValue<Value>(for key: Key<Value>) {
    removeObject(forKey: key.name)
  }
}

extension UserDefaults.Key where Value == Array<CoinGecko.Coin> {
    static let watchlist = Self(AppStorageKey.watchlist)
}
