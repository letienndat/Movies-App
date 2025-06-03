//
//  AppManager.swift
//  Movies-App
//
//  Created by Le Tien Dat on 3/6/25.
//

import Foundation

class AppManager {
    static var hasLaunchedBefore: Bool {
        get {
            if !UserDefaults.standard.bool(forKey: "hasLaunchedBefore") {
                UserDefaults.standard.set(false, forKey: "hasLaunchedBefore")
            }
            return UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "hasLaunchedBefore")
        }
    }
    static var recommendationDTO: RecommendationDTO?
}
