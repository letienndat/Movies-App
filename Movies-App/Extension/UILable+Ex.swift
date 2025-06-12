//
//  UILable+Ex.swift
//  Movies-App
//
//  Created by Le Tien Dat on 12/6/25.
//

import Foundation
import UIKit

extension UILabel {
    func setAttributedText(highlight: String, highlightColor: UIColor = .white, highlightFont: UIFont? = nil) {
        guard let fullText = self.text else { return }

        let attributedString = NSMutableAttributedString(string: fullText)
        if let range = fullText.range(of: highlight) {
            let nsRange = NSRange(range, in: fullText)
            attributedString.addAttribute(.foregroundColor, value: highlightColor, range: nsRange)
            if let font = highlightFont {
                attributedString.addAttribute(.font, value: font, range: nsRange)
            }
        }
        self.attributedText = attributedString
    }

    func setAttributedText(highlightColor: UIColor = .white, highlightFont: UIFont? = nil) {
        guard let fullText = self.text else { return }
        setAttributedText(highlight: fullText, highlightColor: highlightColor, highlightFont: highlightFont)
    }
}
