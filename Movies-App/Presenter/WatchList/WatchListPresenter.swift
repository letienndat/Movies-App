//
//  WatchListPresenter.swift
//  Movies-App
//
//  Created by Le Tien Dat on 03/03/2025.
//

import Foundation

class WatchListPresenter {
    private weak var watchListViewDelegate: WatchListViewDelegate?
    private let theMovieDBService = TheMovieDBService.shared

    private var page = 1
    private(set) var movies: [Movie]?
    private(set) var totalPages = 0
    private(set) var totalResults = 0
    var isLoading = false
    private(set) var idsMovieWatchList = Set<Int>()

    init(watchListViewDelegate: WatchListViewDelegate) {
        self.watchListViewDelegate = watchListViewDelegate
    }

    func fetchWatchList(stateFetch: StateFetch) {
        if isLoading {
            return
        }

        if (stateFetch == .loadMore && movies == nil) ||
            (stateFetch == .loadMore && movies != nil && movies!.count >= totalResults) ||
            (stateFetch == .loadMore && page >= totalPages) {
            return
        }

        isLoading = true
        page = stateFetch == .loadMore ? page + 1 : 1

        if stateFetch == .loadMore {
            watchListViewDelegate?.showLoadingMore()
        }

        let endpoint = AppConst.endPointWatchlist
        let params: [String: Any] = [
            "language": "en-US",
            "page": page,
            "sort_by": "created_at.desc"
        ]

        theMovieDBService.fetchWatchList(endpoint: endpoint, params: params) { [weak self] res in
            guard let self = self else { return }

            if stateFetch == .loadMore {
                self.watchListViewDelegate?.hideLoadingMore()
            }
            if stateFetch == .reload {
                self.watchListViewDelegate?.hideLoadingReload()
            }

            switch res {
            case .success(let listMovies):
                self.page = self.page > listMovies.totalPages ? listMovies.totalPages : self.page
                if stateFetch == .loadMore {
                    self.movies = (self.movies ?? []) + listMovies.results
                } else {
                    self.movies = listMovies.results
                }
                self.totalPages = listMovies.totalPages
                self.totalResults = listMovies.totalResults

                self.watchListViewDelegate?.fetchWatchListSuccess(stateFetch: stateFetch)
            case .failure(let err):
                self.page -= 1
                self.watchListViewDelegate?.showError(title: "Error", message: err.rawValue)
                self.isLoading = false
            }
        }
    }

    func updateWatchList(state: StateUpdateWatchList, movie: Movie) {
        switch state {
        case .add:
            self.movies?.append(movie)
            if movies!.count == (AppConst.numberItemOfPage * page) + 1 {
                page += 1
            }
        case .remove:
            guard movies != nil else { return }

            if let index = movies!.firstIndex(where: { $0.id == movie.id }) {
                movies!.remove(at: index)
            }
            if movies!.count == AppConst.numberItemOfPage * (page - 1) {
                page -= 1
            }
        }
    }

    func updateIdsMovieWatchList(idMovie: Int) {
        if idsMovieWatchList.contains(idMovie) {
            idsMovieWatchList.remove(idMovie)
        } else {
            idsMovieWatchList.insert(idMovie)
        }
    }

    func clearIdsMovieWatchList() {
        idsMovieWatchList.removeAll()
    }
}
