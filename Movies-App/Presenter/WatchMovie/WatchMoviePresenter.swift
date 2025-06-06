//
//  WatchMoviePresenter.swift
//  Movies-App
//
//  Created by Le Tien Dat on 04/03/2025.
//

import Foundation
import FirebaseAuth

class WatchMoviePresenter {
    private let theMovieDBService = TheMovieDBService.shared
    private let appTrackingService = AppTrackingService.shared

    private(set) var movie: Movie?
    private(set) var video: VideoRes?
    private weak var watchMovieViewDelegate: WatchMovieViewDelegate?

    init(watchMovieViewDelegate: WatchMovieViewDelegate) {
        self.watchMovieViewDelegate = watchMovieViewDelegate
    }

    func setupData(movie: Movie) {
        self.movie = movie
    }

    func fetchTrailerMovie() {
        guard let idMovie = movie?.id else { return }

        let endpoint = AppConst.endPointGetListVideos.replacingOccurrences(of: "{movie_id}", with: String(describing: idMovie))

        theMovieDBService.fetchTrailerMovie(endpoint: endpoint, params: nil) { [weak self] res in
            guard let self = self else { return }

            switch res {
            case .success(let video):
                self.video = video
                self.watchMovieViewDelegate?.fetchTrailerMovieSuccess()
            case .failure(let err):
                self.watchMovieViewDelegate?.showError(title: "Error", message: err.rawValue)
            }
        }
    }

    func tracking() {
        guard let movie,
              let genres = movie.genres?.map({ $0.id }) ?? movie.genreIds,
              let email = Auth.getCurrentUser()?.email
        else { return }

        let params: [String: Any] = [
            "email": email,
            "movie_id": movie.id,
            "genres": genres
        ]
        appTrackingService.tracking(type: .watch, params: params)
    }
}
