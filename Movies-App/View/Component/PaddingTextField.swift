//
//  PaddingTextField.swift
//  Movies-App
//
//  Created by Le Tien Dat on 17/02/2025.
//

import Foundation
import UIKit

class PaddingTextField: UITextField {
    var padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    private var placeholderColor: UIColor = .lightGray

    override func awakeFromNib() {
        super.awakeFromNib()
        applyPlaceholderColor()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        applyPlaceholderColor()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        applyPlaceholderColor()
    }

    private func applyPlaceholderColor() {
        if let placeholder = placeholder {
            attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [
                    .foregroundColor: placeholderColor
                ]
            )
        }
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rightInset = (rightView?.frame.width ?? 0) + padding.right
        return bounds.inset(by: UIEdgeInsets(top: padding.top, left: padding.left, bottom: padding.bottom, right: rightInset))
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rightInset = (rightView?.frame.width ?? 0) + padding.right
        return bounds.inset(by: UIEdgeInsets(top: padding.top, left: padding.left, bottom: padding.bottom, right: rightInset))
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let rightInset = (rightView?.frame.width ?? 0) + padding.right
        return bounds.inset(by: UIEdgeInsets(top: padding.top, left: padding.left, bottom: padding.bottom, right: rightInset))
    }
}
