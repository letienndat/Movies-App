//
//  ProfilePresenter.swift
//  Movies-App
//
//  Created by Le Tien Dat on 17/02/2025.
//

import Foundation
import FirebaseAuth
import GoogleSignIn
import FacebookLogin

class ProfilePresenter {
    private weak var profileViewDelegate: ProfileViewDelegate?

    init(profileViewDelegate: ProfileViewDelegate) {
        self.profileViewDelegate = profileViewDelegate
    }

    func loadProfile() {
        guard let user = Auth.auth().currentUser else {
            profileViewDelegate?.showError(title: "Error", message: "Can't load profile!")
            return
        }
        profileViewDelegate?.loadProfileSuccess(profile: user)
    }

    func logout() {
        do {
            switch Auth.getAuthMethod() {
            case .unknown, .withEmailPassword:
                break
            case .withGoogle:
                GIDSignIn.sharedInstance.signOut()
            case .withFacebook:
                LoginManager().logOut()
            }
            try Auth.auth().signOut()
            profileViewDelegate?.logoutSuccess()
        } catch let err {
            profileViewDelegate?.showError(title: "Error", message: err.localizedDescription)
        }
    }
}
