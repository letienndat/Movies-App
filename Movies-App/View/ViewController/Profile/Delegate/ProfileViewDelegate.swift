//
//  ProfileViewDelegate.swift
//  Movies-App
//
//  Created by Le Tien Dat on 17/02/2025.
//

import Foundation
import FirebaseAuth

protocol ProfileViewDelegate: AnyObject {
    func loadProfileSuccess(profile: User)
    func showError(title: String, message: String)
    func logoutSuccess()
}
