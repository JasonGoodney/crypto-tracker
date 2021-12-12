//
//  AppUserDefaults.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 3/11/21.
//

import Combine
import Foundation
import SwiftUI

class AppUserDefaults: ObservableObject {
    public static let shared = AppUserDefaults()

    let objectWillChange = ObservableObjectPublisher()

    @AppStorage("watchlistData") var watchlistData = Data()

    @UserDefaultCodable("watchlist", defaultValue: [])
    var watchlist: [CoinGecko.Coin] {
        willSet {
            objectWillChange.send()
        }
    }

    private var notificationSubscription: AnyCancellable?

    init() {
        notificationSubscription = NotificationCenter.default.publisher(for: UserDefaults.didChangeNotification).sink { _ in
            self.objectWillChange.send()
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
            return defaultValue
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(encoded, forKey: key)
            }
        }
    }
}
