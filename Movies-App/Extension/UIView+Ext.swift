//
//  UIView+Ext.swift
//  Movies-App
//
//  Created by Le Tien Dat on 27/02/2025.
//

import Foundation
import UIKit

extension UIView {
    func roundCorners(_ corners: CACornerMask, radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = corners
    }
}
