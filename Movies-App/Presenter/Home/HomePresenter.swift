//
//  HomePresenter.swift
//  Movies-App
//
//  Created by Le Tien Dat on 10/02/2025.
//

import Foundation
import Alamofire

struct GroupMovieCellData {
    var movies: ResponseTheMovieDBBase<Movie>?
    var currentOffset: CGPoint

    init(movies: ResponseTheMovieDBBase<Movie>?, currentOffset: CGPoint) {
        self.movies = movies
        self.currentOffset = currentOffset
    }

    init(movies: ResponseTheMovieDBBase<Movie>?) {
        self.init(movies: movies, currentOffset: .zero)
    }
}

class HomePresenter {
    private weak var homeViewDelegate: HomeViewDelegate?

    private let theMovieDBService = TheMovieDBService.shared

    private(set) var listMoviesTopRated: GroupMovieCellData?
    private(set) var listMoviesNowPlaying: GroupMovieCellData?
    private(set) var listMoviesTrending: GroupMovieCellData?
    private(set) var listMoviesUpcoming: GroupMovieCellData?
    private(set) var listMoviesPopular: GroupMovieCellData?

    init(homeViewDelegate: HomeViewDelegate) {
        self.homeViewDelegate = homeViewDelegate
    }

    func getDataSource(type: TypeCellHome) -> GroupMovieCellData? {
        switch type {
        case .search:
            return nil
        case .topRated:
            return listMoviesTopRated
        case .nowPlaying:
            return listMoviesNowPlaying
        case .trending:
            return listMoviesTrending
        case .upcomming:
            return listMoviesUpcoming
        case .popular:
            return listMoviesPopular
        }
    }

    func updateCurrentOffset(_ newOffset: CGPoint, type: TypeCellHome) {
        switch type {
        case .search:
            break
        case .topRated:
            listMoviesTopRated?.currentOffset = newOffset
        case .nowPlaying:
            listMoviesNowPlaying?.currentOffset = newOffset
        case .trending:
            listMoviesTrending?.currentOffset = newOffset
        case .upcomming:
            listMoviesUpcoming?.currentOffset = newOffset
        case .popular:
            listMoviesPopular?.currentOffset = newOffset
        }
    }

    func resetCurrentOffset() {
        listMoviesTopRated?.currentOffset = .zero
        listMoviesNowPlaying?.currentOffset = .zero
        listMoviesTrending?.currentOffset = .zero
        listMoviesUpcoming?.currentOffset = .zero
        listMoviesPopular?.currentOffset = .zero
    }

    func fetchAll() {
        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        fetchTopRated { [weak self] in
            dispatchGroup.leave()
            self?.homeViewDelegate?.displayListMovies(type: .topRated)
        }

        dispatchGroup.enter()
        fetchNowPlaying { [weak self] in
            dispatchGroup.leave()
            self?.homeViewDelegate?.displayListMovies(type: .nowPlaying)
        }

        dispatchGroup.enter()
        fetchTrending { [weak self] in
            dispatchGroup.leave()
            self?.homeViewDelegate?.displayListMovies(type: .trending)
        }

        dispatchGroup.enter()
        fetchUpcoming { [weak self] in
            dispatchGroup.leave()
            self?.homeViewDelegate?.displayListMovies(type: .upcomming)
        }

        dispatchGroup.enter()
        fetchPopular { [weak self] in
            dispatchGroup.leave()
            self?.homeViewDelegate?.displayListMovies(type: .popular)
        }

        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.homeViewDelegate?.doneFetchAll()
        }
    }

    func fetchTopRated(completion: @escaping () -> Void) {
        let params = [
            "language": "en-US",
            "page": "1"
        ]

        theMovieDBService.fetchListMovies(
            endpoint: AppConst.endPointGetTopRated,
            params: params
        ) { [weak self] res in
            defer {
                completion()
            }
            guard let self = self else { return }

            switch res {
            case .success(let listMovies):
                self.listMoviesTopRated = GroupMovieCellData(movies: listMovies)
            case .failure(let err):
                debugPrint(err)
            }
        }
    }

    func fetchNowPlaying(completion: @escaping () -> Void) {
        let params = [
            "language": "en-US",
            "page": "1"
        ]

        theMovieDBService.fetchListMovies(
            endpoint: AppConst.endPointGetNowPlaying,
            params: params
        ) { [weak self] res in
            defer {
                completion()
            }
            guard let self = self else { return }

            switch res {
            case .success(let listMovies):
                self.listMoviesNowPlaying = GroupMovieCellData(movies: listMovies)
            case .failure(let err):
                debugPrint(err)
            }
        }
    }

    func fetchTrending(completion: @escaping () -> Void) {
        let params = [
            "language": "en-US",
            "page": "1"
        ]

        theMovieDBService.fetchListMovies(
            endpoint: AppConst.endPointGetTrending,
            params: params
        ) { [weak self] res in
            defer {
                completion()
            }
            guard let self = self else { return }

            switch res {
            case .success(let listMovies):
                self.listMoviesTrending = GroupMovieCellData(movies: listMovies)
            case .failure(let err):
                debugPrint(err)
            }
        }
    }

    func fetchUpcoming(completion: @escaping () -> Void) {
        let params = [
            "language": "en-US",
            "page": "1"
        ]

        theMovieDBService.fetchListMovies(
            endpoint: AppConst.endPointGetUpcoming,
            params: params
        ) { [weak self] res in
            defer {
                completion()
            }
            guard let self = self else { return }

            switch res {
            case .success(let listMovies):
                self.listMoviesUpcoming = GroupMovieCellData(movies: listMovies)
            case .failure(let err):
                debugPrint(err)
            }
        }
    }

    func fetchPopular(completion: @escaping () -> Void) {
        let params = [
            "language": "en-US",
            "page": "1"
        ]

        theMovieDBService.fetchListMovies(
            endpoint: AppConst.endPointGetPopular,
            params: params
        ) { [weak self] res in
            defer {
                completion()
            }
            guard let self = self else { return }

            switch res {
            case .success(let listMovies):
                self.listMoviesPopular = GroupMovieCellData(movies: listMovies)
            case .failure(let err):
                debugPrint(err)
            }
        }
    }
}
