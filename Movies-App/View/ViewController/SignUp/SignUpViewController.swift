//
//  SignUpViewController.swift
//  Movies-App
//
//  Created by Le Tien Dat on 17/02/2025.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var textFieldFullName: PaddingTextField!
    @IBOutlet private weak var textFieldPassword: PaddingTextField!
    @IBOutlet private weak var textFieldEmail: PaddingTextField!
    @IBOutlet private weak var textFieldMobileNumber: PaddingTextField!
    @IBOutlet private weak var textFieldDateOfBirth: PaddingTextField!

    private let buttonShowPassword = UIButton(type: .system)
    private let datePicker = UIDatePicker()

    private lazy var signUpPresenter = SignUpPresenter(signUpViewDelegate: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupKeyboardObservers()
    }

    private func setupView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        textFieldFullName.padding = UIEdgeInsets(top: 0, left: 13.54, bottom: 0, right: 13.54)
        textFieldPassword.padding = UIEdgeInsets(top: 0, left: 13.54, bottom: 0, right: 0)
        textFieldEmail.padding = UIEdgeInsets(top: 0, left: 13.54, bottom: 0, right: 13.54)
        textFieldMobileNumber.padding = UIEdgeInsets(top: 0, left: 13.54, bottom: 0, right: 13.54)
        textFieldDateOfBirth.padding = UIEdgeInsets(top: 0, left: 13.54, bottom: 0, right: 13.54)

        let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .regular)
        let imageShowPassword = UIImage(systemName: "eye.slash", withConfiguration: config)
        buttonShowPassword.setImage(imageShowPassword, for: .normal)
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

        setupDatePicker()
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

    private func setupDatePicker() {
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            datePicker.datePickerMode = .date
        }
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())

        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.setItems([doneButton], animated: true)

        textFieldDateOfBirth.inputView = datePicker
        textFieldDateOfBirth.inputAccessoryView = toolbar
    }

    @objc
    private func doneButtonTapped() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        textFieldDateOfBirth.text = formatter.string(from: datePicker.date)
        textFieldDateOfBirth.resignFirstResponder()
    }

    @objc
    private func handleTapShowPassword(_ sender: UITextField) {
        textFieldPassword.isSecureTextEntry.toggle()
        let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .regular)
        let imageIcon = UIImage(
            systemName: textFieldPassword.isSecureTextEntry ? "eye.slash" : "eye",
            withConfiguration: config
        )
        buttonShowPassword.setImage(imageIcon, for: .normal)
    }

    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }

    @IBAction private func onEditingDidEndTextField(_ sender: UITextField) {
        signUpPresenter.textFieldChanged(tag: sender.tag, text: sender.text ?? "")
    }

    @IBAction private func handleTappedButtonSignUp(_ sender: UIButton) {
        signUpPresenter.signUpWithEmailPassword()
    }

    @IBAction private func handleTappedLogin(_ sender: UIButton) {
        performSegue(withIdentifier: "goToScreenLogin", sender: nil)
        if let count = navigationController?.viewControllers.count {
            navigationController?.viewControllers.remove(at: count - 2)
        }
    }

    @IBAction private func handleTappedLoginWithGoogle(_ sender: Any) {
        signUpPresenter.loginWithGoogle(from: self)
    }

    @IBAction private func handleTappedLoginWithFacebook(_ sender: Any) {
        signUpPresenter.loginWithFacebook(from: self)
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

extension SignUpViewController: SignUpViewDelegate {
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

    func signUpSuccess() {
        guard let navigationController = navigationController else { return }

        let count = navigationController.viewControllers.count
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "loginViewController")
        navigationController.viewControllers[count - 1] = loginViewController
    }

    func loginSuccess() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let tabBar = storyboard.instantiateInitialViewController() else { return }

        view.window?.rootViewController = tabBar
        view.window?.makeKeyAndVisible()
    }
}
