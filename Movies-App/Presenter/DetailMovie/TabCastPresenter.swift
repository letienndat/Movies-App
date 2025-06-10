//
//  TabCastPresenter.swift
//  Movies-App
//
//  Created by Le Tien Dat on 25/02/2025.
//

import Foundation
import UIKit

class TabCastPresenter {
    private let theMovieDBService = TheMovieDBService.shared

    private weak var tabCastViewDelegate: TabCastViewDelegate?
    private(set) var listCasts: [CastMovie]?
    var movie: Movie?

    init(tabCastViewDelegate: TabCastViewDelegate) {
        self.tabCastViewDelegate = tabCastViewDelegate
    }

    func fetchCastMovie() {
        guard let id = movie?.id else { return }

        let endpoint = AppConst.endPointCreditsMovie.replacingOccurrences(of: "{movie_id}", with: "\(id)")
        let params: [String: Any] = [
            "language": "en-US"
        ]
        theMovieDBService.fetchCastMovie(endpoint: endpoint, params: params) { [weak self] res in
            guard let self = self else { return }

            switch res {
            case .success(let credits):
                self.listCasts = credits.cast
                self.tabCastViewDelegate?.showCast()
            case .failure:
                self.tabCastViewDelegate?.fetchError("Can not fetch casts for this movie.")
            }
        }
    }

    func computeHeightContent(collectionView: UICollectionView, label: UILabel, width: CGFloat) {
        guard collectionView.isHidden else {
            let height = collectionView.contentSize.height
            tabCastViewDelegate?.heightContent(height: height)
            return
        }
        let height = label.getHeight(font: UIFont.systemFont(ofSize: 12, weight: .regular), width: width, lineSpacing: 5)
        tabCastViewDelegate?.heightContent(height: height)
    }
}
