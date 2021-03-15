//
//  AppVersion.swift
//  ccx-monitor
//
//  Created by Jason Goodney on 3/8/21.
//

import Foundation

struct AppVersion {
    static func getCurrent() -> String {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"]
        let version = (appVersion as! String)

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
