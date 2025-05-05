//
//  AppTabBarController.swift
//  Movies-App
//
//  Created by Le Tien Dat on 4/14/25.
//

import UIKit

class AppTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        tabBar.tintColor = UIColor(hex: 0x0296E5)
        tabBar.unselectedItemTintColor = UIColor(hex: 0x6D676D)

        let view = UIView(frame: CGRect(x: 0, y: -1, width: tabBar.frame.width, height: 1))
        view.backgroundColor = UIColor(hex: 0x0296E5)
        tabBar.addSubview(view)
    }
}
