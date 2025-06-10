//
//  WatchMovieViewController.swift
//  Movies-App
//
//  Created by Le Tien Dat on 04/03/2025.
//

import UIKit
import WebKit
import FirebaseAuth

class WatchMovieViewController: UIViewController {

    @IBOutlet private weak var webView: WKWebView!

    private lazy var watchMoviePresenter = WatchMoviePresenter(watchMovieViewDelegate: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
        fetchData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        /// Tracking
        guard let movie = watchMoviePresenter.movie,
              let genres = movie.genres?.map({ $0.id }) ?? movie.genreIds,
              let email = Auth.getCurrentUser()?.email
        else { return }

        let params: [String: Any] = [
            "email": email,
            "movie_id": movie.id,
            "genres": genres
        ]
        AppTracking.tracking(.watch, params: params)
    }

    func setupNav() {
        title = watchMoviePresenter.movie?.title ?? "Trailer"
        navigationController?.navigationBar.topItem?.title = ""
    }

    func fetchData() {
        watchMoviePresenter.fetchTrailerMovie()
    }

    func setupData(movie: Movie) {
        self.watchMoviePresenter.setupData(movie: movie)
    }
}

extension WatchMovieViewController: WatchMovieViewDelegate {
    func fetchTrailerMovieSuccess() {
        guard let key = watchMoviePresenter.video?.key else { return }

        let urlString = AppConst.urlEmbedVideoYouTube.replacingOccurrences(of: "{video_id}", with: key)
        let videoUrlString = urlString + "?autoplay=1&controls=0&fs=1"
        let url = URL(string: videoUrlString)!
        webView.load(URLRequest(url: url))
    }

    func showError(title: String, message: String) {
        showAlert(title: title, message: message)
    }
}
