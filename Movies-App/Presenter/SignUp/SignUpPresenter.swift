//
//  SignUpPresenter.swift
//  Movies-App
//
//  Created by Le Tien Dat on 17/02/2025.
//

import Foundation
import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import FacebookLogin

class SignUpPresenter {
    private weak var signUpViewDelegate: SignUpViewDelegate?

    private(set) var fullName: String = ""
    private(set) var password: String = ""
    private(set) var email: String = ""
    private(set) var mobileNumber: String = ""
    private(set) var dateOfBirth: String = ""

    init(signUpViewDelegate: SignUpViewDelegate?) {
        self.signUpViewDelegate = signUpViewDelegate
    }

    func textFieldChanged(tag: Int, text: String) {
        let caseTag = TagTextFieldAuth(rawValue: tag)

        switch caseTag {
        case .fullName:
            fullName = text
        case .password:
            password = text
        case .email:
            email = text
        case .mobileNumber:
            mobileNumber = text
        case .dateOfBirth:
            dateOfBirth = text
        default:
            break
        }
    }

    func signUpWithEmailPassword() {
        guard !fullName.isEmpty,
              !email.isEmpty,
              CommonValidation.isValidEmail(email),
              !password.isEmpty,
              CommonValidation.isValidPhoneNumber(mobileNumber),
              CommonValidation.isValidDate(dateOfBirth)
        else {
            self.signUpViewDelegate?.showError(title: "Error", message: AppError.missingRequiredFields.rawValue)
            return
        }
        self.signUpViewDelegate?.showLoading()

        Auth.auth().createUser(withEmail: email, password: password) { [weak self] _, err in
            self?.signUpViewDelegate?.hideLoading()

            guard let self = self else { return }
            guard err == nil else {
                self.signUpViewDelegate?.showError(title: "Error", message: err!.localizedDescription)
                return
            }
            self.signUpViewDelegate?.signUpSuccess()
        }
    }

    func loginWithGoogle(from viewController: UIViewController) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            signUpViewDelegate?.showError(title: "Error", message: "Count not get ClientID.")
            return
        }
        self.signUpViewDelegate?.showLoading()

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { result, error in
            guard error == nil else {
                self.signUpViewDelegate?.hideLoading()
                self.signUpViewDelegate?.showError(title: "Error", message: error!.localizedDescription)
                return
            }

            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                self.signUpViewDelegate?.hideLoading()
                return
            }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            Auth.auth().signIn(with: credential) { _, error in
                self.signUpViewDelegate?.hideLoading()
                if let error = error {
                    self.signUpViewDelegate?.showError(title: "Error", message: error.localizedDescription)
                    return
                }
                self.signUpViewDelegate?.loginSuccess()
            }
        }
    }

    func loginWithFacebook(from viewController: UIViewController) {
        self.signUpViewDelegate?.showLoading()
        let manager = LoginManager()
        manager.logIn(permissions: ["public_profile", "email"], from: viewController) { _, error in
            if let error = error {
                self.signUpViewDelegate?.hideLoading()
                self.signUpViewDelegate?.showError(title: "Error", message: error.localizedDescription)
                return
            }

            guard let accessToken = AccessToken.current?.tokenString else {
                self.signUpViewDelegate?.hideLoading()
                return
            }

            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken)

            Auth.auth().signIn(with: credential) { _, error in
                self.signUpViewDelegate?.hideLoading()
                if let error = error {
                    self.signUpViewDelegate?.showError(title: "Error", message: error.localizedDescription)
                    return
                }
                self.signUpViewDelegate?.loginSuccess()
            }
        }
    }
}
