//
//  ViewBackgroundGradient.swift
//  Movies-App
//
//  Created by Le Tien Dat on 06/02/2025.
//

import Foundation
import UIKit

class ViewBackgroundGradient: UIView {
    let colors = [
        UIColor(red: 18 / 256, green: 20 / 256, blue: 67 / 256, alpha: 1),
        UIColor(red: 49 / 256, green: 20 / 256, blue: 72 / 256, alpha: 1),
        UIColor(red: 45 / 256, green: 3 / 256, blue: 54 / 256, alpha: 1),
        UIColor(red: 40 / 256, green: 0 / 256, blue: 50 / 256, alpha: 1)
    ]
    private var gradientLayer = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    private func configure() {
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.frame = UIScreen.main.bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
