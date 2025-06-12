//
//  TheMovieDBService.swift
//  Movies-App
//
//  Created by Le Tien Dat on 20/02/2025.
//

import Foundation
import Alamofire

class TheMovieDBService: BaseService {
    static let shared = TheMovieDBService()

    private init() {
        let url = AppConst.baseURLTheMovieDB

        var apiKey = AppConst.apiKeyTheMovieDB
        apiKey = apiKey.replacingOccurrences(of: "\"", with: "")

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(apiKey)",
            "accept": "application/json"
        ]

        super.init(url: url, method: .get, parameter: nil, headers: headers)
    }

    func fetchListMovies(
        endpoint: String,
        params: [String: Any]?,
        isShuffle: Bool = false,
        completion: @escaping ((Result<ResponseTheMovieDBBase<Movie>, AppError>) -> Void)
    ) {
        AF.requestWithoutCache(
            url + endpoint,
            parameters: params,
            encoding: encoding,
            headers: headers
        )
            .responseDecodable(of: ResponseTheMovieDBBase<Movie>.self) { res in
                switch res.result {
                case .success(var movies):
                    if isShuffle {
                        movies.shuffleResults()
                    }
                    completion(.success(movies))
                case .failure(let err):
                    completion(.failure(AppError(from: err)))
                }
            }
    }

    func search(
        query: String,
        page: Int = 1,
        language: String = "en-US",
        completion: @escaping ((Result<ResponseTheMovieDBBase<Movie>, AppError>) -> Void)
    ) {
        let params: [String: Any] = [
            "query": query,
            "page": page,
            "language": language
        ]

        AF.request(
            url + AppConst.endPointSearch,
            method: method,
            parameters: params,
            encoding: encoding,
            headers: headers
        )
        .responseDecodable(of: ResponseTheMovieDBBase<Movie>.self) { res in
            switch res.result {
            case .success(let listMovies):
                completion(.success(listMovies))
            case .failure(let err):
                print(err.localizedDescription)
                completion(.failure(AppError(from: err)))
            }
        }
    }

    func fetchMovieDetail(
        endpoint: String,
        params: [String: Any]?,
        completion: @escaping ((Result<Movie, AppError>) -> Void)
    ) {
        AF.request(
            AppConst.baseURLTheMovieDB + endpoint,
            method: method,
            parameters: params,
            encoding: encoding,
            headers: headers
        )
        .responseDecodable(of: Movie.self) { res in
            switch res.result {
            case .success(let movie):
                completion(.success(movie))
            case .failure(let err):
                print(err.localizedDescription)
                completion(.failure(AppError(from: err)))
            }
        }
    }

    func updateMovieInWatchList(
        endpoint: String,
        params: [String: Any],
        completion: @escaping ((Result<UpdateWatchListRes, AppError>) -> Void)
    ) {
        self.headers?["content-type"] = "application/json"

        AF.request(
            AppConst.baseURLTheMovieDB + endpoint,
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: headers
        )
        .responseDecodable(of: UpdateWatchListRes.self) { res in
            switch res.result {
            case .success(let response):
                completion(.success(response))
            case .failure(let err):
                print(err.localizedDescription)
                completion(.failure(AppError(from: err)))
            }
        }
    }

    func fetchReviewsMovie(
        endpoint: String,
        params: [String: Any]?,
        completion: @escaping ((Result<ResponseTheMovieDBBase<ReviewMovie>, AppError>) -> Void)
    ) {
        AF.requestWithoutCache(
            url + endpoint,
            method: method,
            parameters: params,
            encoding: encoding,
            headers: headers
        )
        .responseDecodable(of: ResponseTheMovieDBBase<ReviewMovie>.self) { res in
            switch res.result {
            case .success(let listReviews):
                completion(.success(listReviews))
            case .failure(let err):
                print(err.localizedDescription)
                completion(.failure(AppError(from: err)))
            }
        }
    }

    func fetchCastMovie(
        endpoint: String,
        params: [String: Any]?,
        completion: @escaping ((Result<CreditsMovie, AppError>) -> Void)
    ) {
        AF.request(
            url + endpoint,
            method: method,
            parameters: params,
            encoding: encoding,
            headers: headers
        )
        .responseDecodable(of: CreditsMovie.self) { res in
            switch res.result {
            case .success(let credits):
                completion(.success(credits))
            case .failure(let err):
                print(err.localizedDescription)
                completion(.failure(AppError(from: err)))
            }
        }
    }

    func fetchWatchList(
        endpoint: String,
        params: [String: Any],
        completion: @escaping ((Result<ResponseTheMovieDBBase<Movie>, AppError>) -> Void)
    ) {
        AF.request(
            url + endpoint,
            method: method,
            parameters: params,
            encoding: encoding,
            headers: headers
        )
        .responseDecodable(of: ResponseTheMovieDBBase<Movie>.self) { res in
            switch res.result {
            case .success(let watchList):
                completion(.success(watchList))
            case .failure(let err):
                print(err.localizedDescription)
                completion(.failure(AppError(from: err)))
            }
        }
    }

    func fetchTrailerMovie(
        endpoint: String,
        params: [String: Any]?,
        completion: @escaping ((Result<VideoRes?, AppError>) -> Void)
    ) {
        AF.request(
            url + endpoint,
            method: method,
            parameters: params,
            encoding: encoding,
            headers: headers
        )
        .responseDecodable(of: ListVideoRes.self) { res in
            switch res.result {
            case .success(let listVideos):
                let trailer = listVideos.results.first { $0.site == "YouTube" && $0.type == "Trailer" }
                completion(.success(trailer))
            case .failure(let err):
                print(err.localizedDescription)
                completion(.failure(AppError(from: err)))
            }
        }
    }
}
