//
//  DetailMoviePresenter.swift
//  Movies-App
//
//  Created by Le Tien Dat on 24/02/2025.
//

import Foundation
import FirebaseAuth

class DetailMoviePresenter {
    private let theMovieDBService = TheMovieDBService.shared
    private weak var detailMovieViewDelegate: DetailMovieViewDelegate?

    private(set) var movie: Movie?
    let tabs = ["About Movie", "Reviews", "Cast"]

    init(detailMovieViewDelegate: DetailMovieViewDelegate) {
        self.detailMovieViewDelegate = detailMovieViewDelegate
    }

    func setMovie(movie: Movie?) {
        self.movie = movie
    }

    func fetchMovieDetails(isReload: Bool) {
        guard let id = movie?.id else {
            if isReload {
                detailMovieViewDelegate?.hideRefresh()
            }
            return
        }

        let endpoint = AppConst.endPointMovieDetails.replacingOccurrences(of: "{movie_id}", with: "\(id)")
        let sessionID = AppConst.sessionID

        let params: [String: Any] = [
            "language": "en-US",
            "append_to_response": "account_states",
            "session_id": sessionID
        ]
        theMovieDBService.fetchMovieDetail(endpoint: endpoint, params: params) { [weak self] res in
            guard let self = self else { return }

            if isReload {
                self.detailMovieViewDelegate?.hideRefresh()
            }

            switch res {
            case .success(let movie):
                self.movie = movie
                if isReload {
                    self.detailMovieViewDelegate?.reloadMovieDetailSuccess()
                } else {
                    self.detailMovieViewDelegate?.fetchMovieDetailSuccess()
                }
            case .failure(let err):
                self.detailMovieViewDelegate?.showError(title: "Error", message: err.rawValue)
            }
        }
    }

    func updateMovieInWatchList() {
        guard let id = movie?.id else { return }

        let endpoint = AppConst.endPointUpdateMovieInWatchlist
        let params: [String: Any] = [
            "media_type": "movie",
            "media_id": id,
            "watchlist": !(movie!.accountStates?.watchlist ?? false)
        ]

        theMovieDBService.updateMovieInWatchList(endpoint: endpoint, params: params) { [weak self] res in
            guard let self = self else { return }

            switch res {
            case .success(let respose):
                var msg = ""
                switch respose.statusCode {
                case 1, 12:
                    self.movie!.accountStates?.watchlist = true
                    msg = "Add movie in watch list success"
                case 13:
                    self.movie!.accountStates?.watchlist = false
                    msg = "Remove movie in watch list success"
                default:
                    break
                }
                self.detailMovieViewDelegate?.updateMovieInWatchListSuccess(message: msg)
            case .failure(let err):
                self.detailMovieViewDelegate?.showError(title: "Error", message: err.rawValue)
            }
        }
    }
}
