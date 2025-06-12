//
//  AppManager.swift
//  Movies-App
//
//  Created by Le Tien Dat on 3/6/25.
//

import Foundation

class AppManager {
    static let standard = UserDefaults.standard

    static var hasLaunchedBefore: Bool {
        get {
            if !standard.bool(forKey: StorageKeys.hasLaunchedBefore) {
                standard.set(false, forKey: StorageKeys.hasLaunchedBefore)
            }
            return standard.bool(forKey: StorageKeys.hasLaunchedBefore)
        }
        set {
            standard.set(newValue, forKey: StorageKeys.hasLaunchedBefore)
        }
    }

    static var historySearch: [String]? {
        get {
            standard.array(forKey: StorageKeys.historySearch) as? [String]
        }
        set {
            standard.set(newValue, forKey: StorageKeys.historySearch)
        }
    }

    static var recommendationDTO: RecommendationDTO?
}
