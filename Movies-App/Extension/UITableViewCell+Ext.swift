//
//  TableViewCell+Ext.swift
//  Movies-App
//
//  Created by Le Tien Dat on 13/02/2025.
//

import Foundation
import UIKit

extension UITableViewCell {
    static var nib: UINib {
        UINib(nibName: String(describing: self), bundle: nil)
    }

    static var reuseIdentifier: String {
        String(describing: self)
    }
}
