//
//  LoginViewDelegate.swift
//  Movies-App
//
//  Created by Le Tien Dat on 14/02/2025.
//

import Foundation

protocol LoginViewDelegate: AnyObject {
    func showLoading()
    func hideLoading()
    func showError(title: String, message: String)
    func loginSuccess()
    func sendPasswordResetSuccess()
}
