//
//  TabReviewsPresenter.swift
//  Movies-App
//
//  Created by Le Tien Dat on 25/02/2025.
//

import Foundation
import UIKit

class TabReviewsPresenter {
    private let theMovieDBService = TheMovieDBService.shared

    private weak var tabReviewViewDelegate: TabReviewsViewDelegate?
    private(set) var listReviews: [ReviewMovie]?
    var id: Int?

    init(tabReviewViewDelegate: TabReviewsViewDelegate) {
        self.tabReviewViewDelegate = tabReviewViewDelegate
    }

    func fetchReviewsMovie() {
        guard let id = id else { return }

        let endpoint = AppConst.endPointReviewsMovie.replacingOccurrences(of: "{movie_id}", with: "\(id)")
        let params: [String: Any] = [
            "language": "en-US",
            "page": 1
        ]
        theMovieDBService.fetchReviewsMovie(endpoint: endpoint, params: params) { [weak self] res in
            guard let self = self else { return }

            switch res {
            case .success(let listReviews):
                self.listReviews = listReviews.results
                self.tabReviewViewDelegate?.showReviews()
            case .failure:
                self.tabReviewViewDelegate?.fetchError("Can not fetch comments for this movie.")
            }
        }
    }

    func computeHeightContent(tableView: UITableView, label: UILabel, width: CGFloat) {
        guard tableView.isHidden else {
            let height = tableView.contentSize.height
            tabReviewViewDelegate?.heightContent(height: height)
            return
        }
        let height = heightForView(text: label.text ?? "", font: UIFont.systemFont(ofSize: 12, weight: .regular), width: width, lineSpacing: 5)
        tabReviewViewDelegate?.heightContent(height: height)
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
