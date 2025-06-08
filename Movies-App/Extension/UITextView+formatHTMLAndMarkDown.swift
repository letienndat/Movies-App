//
//  UITextView+formatHTMLAndMarkDown.swift
//  Movies-App
//
//  Created by Le Tien Dat on 7/6/25.
//

import Foundation
import Ink
import UIKit

extension UITextView {
    func formatHTMLAndMarkDown(_ raw: String) {
        self.isEditable = false
        self.isScrollEnabled = false
        self.dataDetectorTypes = [.link]

        let parser = MarkdownParser()
        let html = parser.html(from: raw)

        guard let data = html.data(using: .utf8) else {
            self.text = raw
            return
        }

        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]

        guard
            let attributedString = try? NSMutableAttributedString(
                data: data, options: options, documentAttributes: nil)
        else {
            self.text = raw
            return
        }

        let fallbackFont = self.font ?? UIFont.systemFont(ofSize: 12)
        let fallbackColor = self.textColor ?? UIColor.white

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5

        let fullRange = NSRange(location: 0, length: attributedString.length)

        attributedString.enumerateAttributes(in: fullRange, options: []) { attrs, range, _ in
            var updatedAttrs = attrs
            var shouldUpdate = false

            if let font = attrs[.font] as? UIFont {
                let fontName = font.fontName.lowercased()

                if fontName.contains("times") || font.familyName.lowercased().contains("times") {
                    let traits = font.fontDescriptor.symbolicTraits
                    var descriptor = UIFontDescriptor(fontAttributes: [
                        .family: fallbackFont.familyName
                    ])
                    descriptor =
                        descriptor.withSymbolicTraits(traits) ?? descriptor
                    let newFont = UIFont(
                        descriptor: descriptor, size: font.pointSize)
                    updatedAttrs[.font] = newFont
                    shouldUpdate = true
                }
            } else {
                updatedAttrs[.font] = fallbackFont
                shouldUpdate = true
            }

            if let color = attrs[.foregroundColor] as? UIColor {
                if color.isApproximatelyBlack() {
                    updatedAttrs[.foregroundColor] = fallbackColor
                    shouldUpdate = true
                }
            } else {
                updatedAttrs[.foregroundColor] = fallbackColor
                shouldUpdate = true
            }

            updatedAttrs[.paragraphStyle] = paragraphStyle
            shouldUpdate = true

            if shouldUpdate {
                attributedString.setAttributes(updatedAttrs, range: range)
            }
        }

        self.attributedText = attributedString
    }
}
