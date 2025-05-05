//
//  TabAboutMoviePresenter.swift
//  Movies-App
//
//  Created by Le Tien Dat on 27/02/2025.
//

import Foundation
import UIKit

class TabAboutMoviePresenter {
    private weak var tabAboutMovieViewDelegate: TabAboutMovieViewDelegate?

    init(tabAboutMovieViewDelegate: TabAboutMovieViewDelegate) {
        self.tabAboutMovieViewDelegate = tabAboutMovieViewDelegate
    }

    func computeHeightContent(view: UILabel, width: CGFloat) {
        let height = heightForView(text: view.text ?? "", font: UIFont.systemFont(ofSize: 12, weight: .regular), width: width, lineSpacing: 5)
        tabAboutMovieViewDelegate?.heightContent(height: height)
    }

    private func heightForView(text: String, font: UIFont, width: CGFloat, lineSpacing: CGFloat) -> CGFloat {
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
