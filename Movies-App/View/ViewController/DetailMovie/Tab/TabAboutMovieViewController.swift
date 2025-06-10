//
//  TabAboutMovieViewController.swift
//  Movies-App
//
//  Created by Lê Tiến Đạt on 24/2/25.
//

import UIKit

class TabAboutMovieViewController: UIViewController {
    @IBOutlet private weak var labelAboutMovie: UILabel!

    private var width: CGFloat = 0

    private lazy var tabAboutMoviePresenter = TabAboutMoviePresenter(tabAboutMovieViewDelegate: self)
    weak var pageTabViewDelegate: PageTabViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let movie = tabAboutMoviePresenter.movie else { return }

        labelAboutMovie.text = movie.overview
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        /// Tracking
        guard let movie = tabAboutMoviePresenter.movie,
              let genres = movie.genres?.map({ $0.id }) ?? movie.genreIds
        else { return }

        let params: [String: Any] = [
            "movie_id": movie.id,
            "genres": genres
        ]
        AppTracking.tracking(.tapTabAboutMovie, params: params)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tabAboutMoviePresenter.computeHeightContent(view: labelAboutMovie, width: width)
    }

    func setupData(movie: Movie?, width: CGFloat) {
        self.tabAboutMoviePresenter.movie = movie
        self.width = width

        guard let movie = tabAboutMoviePresenter.movie,
              !movie.overview.isEmpty
        else {
            labelAboutMovie.text = "There is no description for this movie."
            return
        }
        labelAboutMovie.text = movie.overview
    }
}

extension TabAboutMovieViewController: TabAboutMovieViewDelegate {
    func heightContent(height: CGFloat) {
        pageTabViewDelegate?.heightContent(index: 0, height: height)
    }
}
