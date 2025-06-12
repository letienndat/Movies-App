//
//  LoginViewController.swift
//  Movies-App
//
//  Created by Le Tien Dat on 13/02/2025.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var textFieldEmail: PaddingTextField!
    @IBOutlet private weak var textFieldPassword: PaddingTextField!

    private let buttonShowPassword = UIButton(type: .system)

    private lazy var loginPresenter = LoginPresenter(loginViewDelegate: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupKeyboardObservers()
    }

    private func setupView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        textFieldEmail.padding = UIEdgeInsets(top: 0, left: 13.54, bottom: 0, right: 13.54)
        textFieldPassword.padding = UIEdgeInsets(top: 0, left: 13.54, bottom: 0, right: 0)

        buttonShowPassword.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        buttonShowPassword.tintColor = .black
        if #available(iOS 15.0, *) {
            var configButtonShowPassword = UIButton.Configuration.plain()
            configButtonShowPassword.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
            buttonShowPassword.configuration = configButtonShowPassword
        } else {
            buttonShowPassword.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }
        textFieldPassword.rightView = buttonShowPassword
        textFieldPassword.rightViewMode = .always

        buttonShowPassword.addTarget(self, action: #selector(handleTapShowPassword), for: .touchUpInside)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc
    private func handleTapShowPassword(_ sender: UITextField) {
        textFieldPassword.isSecureTextEntry.toggle()
        buttonShowPassword.setImage(UIImage(systemName: textFieldPassword.isSecureTextEntry ? "eye.slash" : "eye"), for: .normal)
    }

    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }

    @IBAction private func onEditingDidEndTextField(_ sender: UITextField) {
        loginPresenter.textFieldChanged(tag: sender.tag, text: sender.text ?? "")
    }

    @IBAction private func handleTappedSignUp(_ sender: UIButton) {
        performSegue(withIdentifier: "goToScreenSignUp", sender: nil)
        if let count = navigationController?.viewControllers.count {
            navigationController?.viewControllers.remove(at: count - 2)
        }
    }

    @IBAction private func handleTappedLoginWithGoogle(_ sender: Any) {
        loginPresenter.loginWithGoogle(from: self)
    }

    @IBAction private func handleTappedLoginWithFacebook(_ sender: Any) {
        loginPresenter.loginWithFacebook(from: self)
    }

    @IBAction private func handleTappedButtonLogin(_ sender: UIButton) {
        loginPresenter.loginWithEmailPassword()
    }

    @IBAction private func handleTappedButtonForgetPassword(_ sender: UIButton) {
        loginPresenter.forgetPassword()
    }

    @objc
    private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = keyboardFrame.cgRectValue.height
        scrollView.contentInset.bottom = keyboardHeight
    }

    @objc
    private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset.bottom = 0
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension LoginViewController: LoginViewDelegate {
    func showLoading() {
        showHUD()
    }

    func hideLoading() {
        DispatchQueue.main.async {
            self.hideHUD()
        }
    }

    func showError(title: String, message: String) {
        self.showAlert(title: title, message: message)
    }

    func loginSuccess() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let tabBar = storyboard.instantiateInitialViewController() else { return }

        view.window?.rootViewController = tabBar
        view.window?.makeKeyAndVisible()
    }

    func sendPasswordResetSuccess() {
        showAlert(
            title: "Success",
            message: "We have sent you a password reset link to your email \(loginPresenter.email). Please check!"
        )
    }
}
