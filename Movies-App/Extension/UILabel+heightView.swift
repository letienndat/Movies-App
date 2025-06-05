//
//  UILabel+heightView.swift
//  Movies-App
//
//  Created by Le Tien Dat on 5/6/25.
//

import Foundation
import UIKit

extension UILabel {
    func getHeight(font: UIFont, width: CGFloat, lineSpacing: CGFloat) -> CGFloat {
        guard let text else { return 0 }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.lineSpacing = lineSpacing

        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .paragraphStyle: paragraphStyle
        ]

        let constraintSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(
            with: constraintSize,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: attributes,
            context: nil
        )

        return ceil(boundingBox.height)
    }
}
