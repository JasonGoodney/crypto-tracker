//
//  AppVersion.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 3/8/21.
//

// swiftlint:disable all

import Foundation

struct AppVersion {
    static func getCurrent() -> String {
        guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] else { return ""}
        
        let version = appVersion as! String

        return version
    }

    static func checkForUpdate(completion: (() -> Void)? = nil) {
        let version = getCurrent()
        let savedVersion = UserDefaults.standard.string(forKey: AppStorageKey.savedVersion)

        if savedVersion == version {
//            print("App is up to date!")
        } else {
            UserDefaults.standard.set(version, forKey: AppStorageKey.savedVersion)
            completion?()
        }
    }
}

// swiftlint:enable all
