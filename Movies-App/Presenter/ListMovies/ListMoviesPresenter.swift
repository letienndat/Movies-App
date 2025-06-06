//
//  ListMoviesPresenter.swift
//  Movies-App
//
//  Created by Le Tien Dat on 24/02/2025.
//

import Foundation

class ListMoviesPresenter {
    private weak var listMoviesViewDelegate: ListMoviesViewDelegate?
    private let theMovieDBService = TheMovieDBService.shared

    private var page = 1
    private(set) var movies: [Movie]?
    private var totalPages = 0
    private var totalResults = 0
    private var typeMovies: TypeMovie?
    var isLoading = false
    var recommendation: RecommendationDTO? {
        AppManager.recommendationDTO
    }

    init(listMoviesViewDelegate: ListMoviesViewDelegate) {
        self.listMoviesViewDelegate = listMoviesViewDelegate
    }

    func setupData(movies: [Movie]?, typeMovies: TypeMovie?, totalPages: Int, totalResults: Int) {
        self.movies = movies
        self.typeMovies = typeMovies
        self.totalPages = totalPages
        self.totalResults = totalResults
    }

    func fetchMovies(isLoadMore: Bool = false) {
        if isLoading {
            return
        }

        if (isLoadMore && movies == nil) ||
            (isLoadMore && movies != nil && movies!.count >= totalResults) ||
            (isLoadMore && page >= totalPages) {
            return
        }

        isLoading = true
        page = isLoadMore ? page + 1 : 1

        if isLoadMore {
            listMoviesViewDelegate?.showLoadingMore()
        }

        var endpoint = ""
        switch typeMovies {
        case .none:
            return
        case .nowPlaying:
            endpoint = AppConst.endPointGetNowPlaying
        case .trending:
            endpoint = AppConst.endPointGetTrending
        case .upcoming:
            endpoint = AppConst.endPointGetUpcoming
        case .popular:
            endpoint = AppConst.endPointGetPopular
        case .recommendForYou, .youMightLike:
            endpoint = AppConst.endPointRecommendations
        }

        var params: [String: Any] = [
            "language": "en-US",
            "page": page
        ]

        var isShuffle = false
        if typeMovies == .recommendForYou || typeMovies == .youMightLike {
            guard let recommendation else {
                isLoading = false
                self.listMoviesViewDelegate?.hideLoadingMore()
                return
            }
            isShuffle = true
            params["include_adult"] = false

            if typeMovies == .recommendForYou {
                let genreParam = recommendation.genreScores.map({ String(describing: $0.genreID) }).joined(separator: "|")
                params["with_genres"] = genreParam
            } else if typeMovies == .youMightLike {
                params["with_genres"] = "\(recommendation.topGenre)"
            }
        }
        theMovieDBService.fetchListMovies(
            endpoint: endpoint,
            params: params,
            isShuffle: isShuffle
        ) { [weak self] res in
            guard let self = self else { return }

            if isLoadMore {
                self.listMoviesViewDelegate?.hideLoadingMore()
            } else {
                self.listMoviesViewDelegate?.hideLoadingReload()
            }

            switch res {
            case .success(let listMovies):
                self.page = self.page > listMovies.totalPages ? listMovies.totalPages : self.page
                if isLoadMore {
                    self.movies = (self.movies ?? []) + listMovies.results
                } else {
                    self.movies = listMovies.results
                }
                self.totalPages = listMovies.totalPages
                self.totalResults = listMovies.totalResults
                self.listMoviesViewDelegate?.reloadTableView()
            case .failure(let err):
                self.page -= 1
                self.listMoviesViewDelegate?.showError(title: "Error", message: err.rawValue)
                self.isLoading = false
            }
        }
    }
}
