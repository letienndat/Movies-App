//
//  HomePresenter.swift
//  Movies-App
//
//  Created by Le Tien Dat on 10/02/2025.
//

import Foundation
import Alamofire

class HomePresenter {
    private weak var homeViewDelegate: HomeViewDelegate?

    private let theMovieDBService = TheMovieDBService.shared

    private(set) var listMoviesTopRated: ResponseTheMovieDBBase<Movie>?
    private(set) var listMoviesNowPlaying: ResponseTheMovieDBBase<Movie>?
    private(set) var listMoviesTrending: ResponseTheMovieDBBase<Movie>?
    private(set) var listMoviesUpcoming: ResponseTheMovieDBBase<Movie>?
    private(set) var listMoviesPopular: ResponseTheMovieDBBase<Movie>?

    init(homeViewDelegate: HomeViewDelegate) {
        self.homeViewDelegate = homeViewDelegate
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
                self.listMoviesTopRated = listMovies
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
                self.listMoviesNowPlaying = listMovies
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
                self.listMoviesTrending = listMovies
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
                self.listMoviesUpcoming = listMovies
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
                self.listMoviesPopular = listMovies
            case .failure(let err):
                debugPrint(err)
            }
        }
    }
}
