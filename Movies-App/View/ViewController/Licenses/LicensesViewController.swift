//
//  LicensesViewController.swift
//  Movies-App
//
//  Created by Le Tien Dat on 4/29/25.
//

import UIKit
import AcknowList

class LicensesViewController: UIViewController {
    @IBOutlet private weak var containerView: UIView!

    private let licensesListVC: AcknowListViewController? = {
        guard let path = Bundle.main.path(forResource: "Pods-Movies-App-acknowledgements", ofType: "plist") else {
            debugPrint("Can't found file Pods-Movies-App-acknowledgements.plist")
            return nil
        }
        let vc = AcknowListViewController(fileNamed: path)
        return vc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = .black
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.tintColor = .white
    }

    private func setupView() {
        navigationItem.backButtonTitle = ""
        guard let licensesListVC = licensesListVC else { return }

        licensesListVC.view.backgroundColor = .clear
        addChild(licensesListVC)
        containerView.addSubview(licensesListVC.view)
        licensesListVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            licensesListVC.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            licensesListVC.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            licensesListVC.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            licensesListVC.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        licensesListVC.didMove(toParent: self)
        licensesListVC.tableView.layoutIfNeeded()
    }
}

extension AcknowViewController {
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = .black
        navigationItem.backButtonTitle = ""
    }

    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.tintColor = .white
    }
}
