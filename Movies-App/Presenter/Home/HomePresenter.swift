//
//  HomePresenter.swift
//  Movies-App
//
//  Created by Le Tien Dat on 10/02/2025.
//

import Foundation
import Alamofire
import FirebaseAuth

struct GroupMovieCellData {
    var title: String
    var movies: ResponseTheMovieDBBase<Movie>?
    var currentOffset: CGPoint

    init(title: String, movies: ResponseTheMovieDBBase<Movie>?, currentOffset: CGPoint) {
        self.title = title
        self.movies = movies
        self.currentOffset = currentOffset
    }

    init(title: String, movies: ResponseTheMovieDBBase<Movie>?) {
        self.init(title: title, movies: movies, currentOffset: .zero)
    }
}

class HomePresenter {
    private weak var homeViewDelegate: HomeViewDelegate?

    private let theMovieDBService = TheMovieDBService.shared
    private let appTrackingService = AppTrackingService.shared

    private(set) var listMoviesTopRated: GroupMovieCellData
    private(set) var listMoviesNowPlaying: GroupMovieCellData
    private(set) var listMoviesTrending: GroupMovieCellData
    private(set) var listMoviesUpcoming: GroupMovieCellData
    private(set) var listMoviesPopular: GroupMovieCellData
    private(set) var recommendations: RecommendationDTO?
    private(set) var listMoviesRecommendForYou: GroupMovieCellData
    private(set) var listMoviesYouMightLike: GroupMovieCellData
    var titleYouMightLike: String {
        var title = TypeCellHome.moviesYouMightLike.title
        let genreName = recommendations?.topGenreName ?? ""
        title = title.replacingOccurrences(of: ":genre_name", with: genreName)
        return title
    }

    init(homeViewDelegate: HomeViewDelegate) {
        self.homeViewDelegate = homeViewDelegate
        self.listMoviesTopRated = GroupMovieCellData(title: TypeCellHome.topRated.title, movies: nil)
        self.listMoviesNowPlaying = GroupMovieCellData(title: TypeCellHome.nowPlaying.title, movies: nil)
        self.listMoviesTrending = GroupMovieCellData(title: TypeCellHome.trending.title, movies: nil)
        self.listMoviesUpcoming = GroupMovieCellData(title: TypeCellHome.upcomming.title, movies: nil)
        self.listMoviesPopular = GroupMovieCellData(title: TypeCellHome.popular.title, movies: nil)
        self.listMoviesRecommendForYou = GroupMovieCellData(title: TypeCellHome.moviesRecommendForYou.title, movies: nil)
        self.listMoviesYouMightLike = GroupMovieCellData(title: TypeCellHome.moviesYouMightLike.title, movies: nil)
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
        case .moviesRecommendForYou:
            return listMoviesRecommendForYou
        case .moviesYouMightLike:
            return listMoviesYouMightLike
        }
    }

    func updateCurrentOffset(_ newOffset: CGPoint, type: TypeCellHome) {
        switch type {
        case .search:
            break
        case .topRated:
            listMoviesTopRated.currentOffset = newOffset
        case .nowPlaying:
            listMoviesNowPlaying.currentOffset = newOffset
        case .trending:
            listMoviesTrending.currentOffset = newOffset
        case .upcomming:
            listMoviesUpcoming.currentOffset = newOffset
        case .popular:
            listMoviesPopular.currentOffset = newOffset
        case .moviesRecommendForYou:
            listMoviesRecommendForYou.currentOffset = newOffset
        case .moviesYouMightLike:
            listMoviesYouMightLike.currentOffset = newOffset
        }
    }

    func resetCurrentOffset() {
        listMoviesTopRated.currentOffset = .zero
        listMoviesNowPlaying.currentOffset = .zero
        listMoviesTrending.currentOffset = .zero
        listMoviesUpcoming.currentOffset = .zero
        listMoviesPopular.currentOffset = .zero
        listMoviesRecommendForYou.currentOffset = .zero
        listMoviesYouMightLike.currentOffset = .zero
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

        dispatchGroup.enter()
        fetchRecommendations { [weak self] in
            guard let self else {
                dispatchGroup.leave()
                return
            }

            dispatchGroup.enter()
            self.fetchMoviesRecommendForYou {
                self.homeViewDelegate?.displayListMovies(type: .moviesRecommendForYou)
                dispatchGroup.leave()
            }

            dispatchGroup.enter()
            self.fetchMoviesYouMightLike {
                self.homeViewDelegate?.displayListMovies(type: .moviesYouMightLike)
                dispatchGroup.leave()
            }

            dispatchGroup.leave()
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
                self.listMoviesTopRated = GroupMovieCellData(title: TypeCellHome.topRated.title, movies: listMovies)
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
                self.listMoviesNowPlaying = GroupMovieCellData(title: TypeCellHome.nowPlaying.title, movies: listMovies)
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
                self.listMoviesTrending = GroupMovieCellData(title: TypeCellHome.trending.title, movies: listMovies)
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
                self.listMoviesUpcoming = GroupMovieCellData(title: TypeCellHome.upcomming.title, movies: listMovies)
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
                self.listMoviesPopular = GroupMovieCellData(title: TypeCellHome.popular.title, movies: listMovies)
            case .failure(let err):
                debugPrint(err)
            }
        }
    }

    func fetchRecommendations(completion: @escaping () -> Void) {
        guard let email = Auth.getCurrentUser()?.email else { return }

        var endpoint = AppConst.AppTrackingEndpoint.recommendations.endpoint
        endpoint = endpoint.replacingOccurrences(of: ":email", with: email)

        appTrackingService.fetchRecommendations(endpoint: endpoint) { [weak self] res in
            guard let self else { return }
            switch res {
            case .success(let data):
                self.recommendations = data
                AppManager.recommendationDTO = data
                completion()
            case .failure:
                break
            }
        }
    }

    private func fetchMoviesRecommendForYou(completion: @escaping () -> Void) {
        guard let recommendations,
              let genres = recommendations.genreScores.map({ String(describing: $0.genreID) }) as? [String]?,
              let genresParam = genres?.joined(separator: "|")
        else {
            return
        }
        let params: [String: Any] = [
            "with_genres": genresParam,
            "page": "1",
            "include_adult": false,
            "language": "en-US"
        ]

        theMovieDBService.fetchListMovies(
            endpoint: AppConst.endPointRecommendations,
            params: params,
            isShuffle: true
        ) { [weak self] res in
            defer {
                completion()
            }
            guard let self = self else { return }

            switch res {
            case .success(let listMovies):
                self.listMoviesRecommendForYou = GroupMovieCellData(title: TypeCellHome.moviesRecommendForYou.title, movies: listMovies)
            case .failure(let err):
                debugPrint(err)
            }
        }
    }

    private func fetchMoviesYouMightLike(completion: @escaping () -> Void) {
        guard let recommendations else { return }

        let genres = String(describing: recommendations.topGenre)
        let params: [String: Any] = [
            "with_genres": genres,
            "page": "1",
            "include_adult": false,
            "language": "en-US"
        ]

        theMovieDBService.fetchListMovies(
            endpoint: AppConst.endPointRecommendations,
            params: params,
            isShuffle: true
        ) { [weak self] res in
            defer {
                completion()
            }
            guard let self = self else { return }

            switch res {
            case .success(let listMovies):
                self.listMoviesYouMightLike = GroupMovieCellData(title: titleYouMightLike, movies: listMovies)
            case .failure(let err):
                debugPrint(err)
            }
        }
    }
}
