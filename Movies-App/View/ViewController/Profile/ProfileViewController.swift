//
//  ProfileViewController.swift
//  Movies-App
//
//  Created by Le Tien Dat on 17/02/2025.
//

import UIKit
import FirebaseAuth
import AcknowList

class ProfileViewController: UIViewController {

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var viewLicenses: UIView!
    @IBOutlet private weak var viewLogout: UIView!
    @IBOutlet private weak var imageAvatar: UIImageView!
    @IBOutlet private weak var labelFullName: UILabel!
    @IBOutlet private weak var viewOverlay: UIView!

    private let refreshControl = UIRefreshControl()

    private lazy var profilePresenter = ProfilePresenter(profileViewDelegate: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadData()
    }

    private func setupView() {
        refreshControl.tintColor = AppConst.colorRefreshControl
        scrollView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handlePullReload), for: .valueChanged)

        let tapLicenses = UITapGestureRecognizer(target: self, action: #selector(handleTappedLicenses))
        viewLicenses.addGestureRecognizer(tapLicenses)

        let tapLogout = UITapGestureRecognizer(target: self, action: #selector(handleTappedLogout))
        viewLogout.addGestureRecognizer(tapLogout)
    }

    private func loadData() {
        profilePresenter.loadProfile()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "goToScreenLicenses" else { return }
        guard let vc = segue.destination as? LicensesViewController else { return }
        vc.hidesBottomBarWhenPushed = true
    }

    @objc
    private func handlePullReload() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.loadData()
        }
    }

    @objc
    private func handleTappedLogout() {
        viewOverlay.isHidden = false
    }

    @objc
    private func handleTappedLicenses() {
        performSegue(withIdentifier: "goToScreenLicenses", sender: self)
    }

    @IBAction private func handleTappedCancelLogout(_ sender: UIButton) {
        viewOverlay.isHidden = true
    }

    @IBAction private func handleTappedAcceptLogout(_ sender: UIButton) {
        profilePresenter.logout()
    }
}

extension ProfileViewController: ProfileViewDelegate {
    func showError(title: String, message: String) {
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
        }
        showAlert(title: title, message: message)
    }

    func loadProfileSuccess(profile: User) {
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
        }
        labelFullName.text = profile.displayName ?? profile.email ?? "Fullname"
        imageAvatar.setImage(with: profile.photoURL?.absoluteString, placeholder: UIImage(named: "avatar-profile"))
    }

    func logoutSuccess() {
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        guard let nav = storyboard.instantiateInitialViewController() else { return }

        self.view.window?.rootViewController = nav
        self.view.window?.makeKeyAndVisible()
    }
}
