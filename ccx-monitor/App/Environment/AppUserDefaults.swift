//
//  AppUserDefaults.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 3/11/21.
//

import Foundation
import SwiftUI
import Combine

class AppUserDefaults: ObservableObject {
    public static let shared = AppUserDefaults()
 
    @AppStorage("watchlistData") var watchlistData = Data()
    
    @UserDefaultCodable("watchlist", defaultValue: [])
    var watchlist: [String] {
        willSet {
            objectWillChange.send()
        }
    }
    
}

@propertyWrapper
public struct UserDefaultCodable<T: Codable> {
    let key: String
    let defaultValue: T

    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    public var wrappedValue: T {
        get {
            if let data = UserDefaults.standard.data(forKey: key) {
                if let decoded = try? JSONDecoder().decode(T.self, from: data) {
                    return decoded
                }
            }
            return self.defaultValue
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(encoded, forKey: key)
            }
        }
    }
}
