//
//  SignUpViewDelegate.swift
//  Movies-App
//
//  Created by Le Tien Dat on 17/02/2025.
//

import Foundation

protocol SignUpViewDelegate: AnyObject {
    func showLoading()
    func hideLoading()
    func showError(title: String, message: String)
    func signUpSuccess()
    func loginSuccess()
}
