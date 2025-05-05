//
//  ConfigNavigationController.swift
//  Movies-App
//
//  Created by Le Tien Dat on 14/02/2025.
//

import UIKit

class ConfigNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
    }

    private func setupNav() {
        let imageBackNav = UIImage(named: "icon-back-nav")
        self.navigationBar.backIndicatorImage = imageBackNav
        self.navigationBar.tintColor = .white
        self.navigationBar.backIndicatorTransitionMaskImage = imageBackNav
    }
}
