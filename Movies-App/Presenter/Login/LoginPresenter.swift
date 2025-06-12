//
//  LoginPresenter.swift
//  Movies-App
//
//  Created by Le Tien Dat on 14/02/2025.
//

import Foundation
import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import FacebookLogin

class LoginPresenter {
    private weak var loginViewDelegate: LoginViewDelegate?

    private(set) var email: String = ""
    private(set) var password: String = ""

    init(loginViewDelegate: LoginViewDelegate?) {
        self.loginViewDelegate = loginViewDelegate
    }

    func textFieldChanged(tag: Int, text: String) {
        let caseTag = TagTextFieldAuth(rawValue: tag)

        switch caseTag {
        case .email:
            email = text
        case .password:
            password = text
        default:
            break
        }
    }

    func loginWithEmailPassword() {
        guard !email.isEmpty,
              !password.isEmpty else {
            self.loginViewDelegate?.showError(title: "Error", message: AppError.missingRequiredFields.rawValue)
            return
        }
        self.loginViewDelegate?.showLoading()

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] _, err in
            self?.loginViewDelegate?.hideLoading()

            guard let self = self else { return }
            guard err == nil else {
                self.loginViewDelegate?.showError(title: "Error", message: err!.localizedDescription)
                return
            }
            self.loginViewDelegate?.loginSuccess()
        }
    }

    func loginWithGoogle(from viewController: UIViewController) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            loginViewDelegate?.showError(title: "Error", message: "Count not get ClientID.")
            return
        }
        self.loginViewDelegate?.showLoading()

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { result, error in
            guard error == nil else {
                self.loginViewDelegate?.hideLoading()
                self.loginViewDelegate?.showError(title: "Error", message: error!.localizedDescription)
                return
            }

            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                self.loginViewDelegate?.hideLoading()
                return
            }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            Auth.auth().signIn(with: credential) { _, error in
                self.loginViewDelegate?.hideLoading()
                if let error = error {
                    self.loginViewDelegate?.showError(title: "Error", message: error.localizedDescription)
                    return
                }
                self.loginViewDelegate?.loginSuccess()
            }
        }
    }

    func loginWithFacebook(from viewController: UIViewController) {
        self.loginViewDelegate?.showLoading()
        let manager = LoginManager()
        manager.logIn(permissions: ["public_profile", "email"], from: viewController) { _, error in
            if let error = error {
                self.loginViewDelegate?.hideLoading()
                self.loginViewDelegate?.showError(title: "Error", message: error.localizedDescription)
                return
            }

            guard let accessToken = AccessToken.current?.tokenString else {
                self.loginViewDelegate?.hideLoading()
                return
            }

            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken)

            Auth.auth().signIn(with: credential) { _, error in
                self.loginViewDelegate?.hideLoading()
                if let error = error {
                    self.loginViewDelegate?.showError(title: "Error", message: error.localizedDescription)
                    return
                }
                self.loginViewDelegate?.loginSuccess()
            }
        }
    }

    func forgetPassword() {
        guard !email.isEmpty else {
            self.loginViewDelegate?.showError(title: "Error", message: AppError.missingRequiredFieldEmail.rawValue)
            return
        }
        self.loginViewDelegate?.showLoading()

        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] err in
            self?.loginViewDelegate?.hideLoading()

            guard let self = self else { return }
            guard err == nil else {
                self.loginViewDelegate?.showError(title: "Error", message: err!.localizedDescription)
                return
            }
            self.loginViewDelegate?.sendPasswordResetSuccess()
        }
    }
}
