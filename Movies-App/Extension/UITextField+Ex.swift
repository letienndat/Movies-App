//
//  UITextField+Ex.swift
//  Movies-App
//
//  Created by Le Tien Dat on 6/12/25.
//

import Foundation
import UIKit

extension UITextField {
    func movePointerToEnd() {
        let position = self.endOfDocument
        self.selectedTextRange = self.textRange(from: position, to: position)
    }
}
