//
//  AppManager.swift
//  Movies-App
//
//  Created by Le Tien Dat on 3/6/25.
//

import Foundation

class AppManager {
    private static let standard = UserDefaults.standard

    static var hasLaunchedBefore: Bool {
        get {
            if !standard.bool(forKey: StorageKeys.keyHasLaunchedBefore) {
                standard.set(false, forKey: StorageKeys.keyHasLaunchedBefore)
            }
            return standard.bool(forKey: StorageKeys.keyHasLaunchedBefore)
        }
        set {
            standard.set(newValue, forKey: StorageKeys.keyHasLaunchedBefore)
        }
    }

    static var recommendationDTO: RecommendationDTO?
}
