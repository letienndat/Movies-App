//
//  UIColor+Ext.swift
//  Movies-App
//
//  Created by Le Tien Dat on 07/02/2025.
//

import Foundation
import UIKit

extension UIColor {
    // Constructor UIColor using params hex and alpha
    convenience init(hex: UInt, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex >> 16) & 0xFF) / 255.0
        let green = CGFloat((hex >> 8) & 0xFF) / 255.0
        let blue = CGFloat(hex & 0xFF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    func isApproximatelyBlack(threshold: CGFloat = 0.01) -> Bool {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        if self.getRed(&r, green: &g, blue: &b, alpha: &a) {
            return abs(r) < threshold && abs(g) < threshold
                && abs(b) < threshold
        }

        return false
    }
}
