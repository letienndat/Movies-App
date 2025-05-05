//
//  Movie.swift
//  Movies-App
//
//  Created by Le Tien Dat on 10/02/2025.
//

import Foundation

struct Movie: Codable {
    let adult: Bool
    let backdropPath: String?
    var backdropUrl: String? {
        guard let backdropPath = backdropPath else { return nil }
        return AppConst.baseURLTMDBImage + backdropPath
    }
    let genreIds: [Int]?
    let genres: [Genre]?
    let id: Int
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    var posterUrl: String? {
        guard let posterPath = posterPath else { return nil }
        return AppConst.baseURLTMDBImage + posterPath
    }
    let releaseDate: String
    let runtime: Int?
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
    var accountStates: AccountStates?

    enum CodingKeys: String, CodingKey {
        case adult, id, overview, popularity, title, video, genres, runtime
        case backdropPath = "backdrop_path"
        case genreIds = "genre_ids"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case accountStates = "account_states"
    }
}

struct Genre: Codable {
    let id: Int
    let name: String
}

struct AccountStates: Codable {
    let favorite: Bool
    let rated: Bool
    var watchlist: Bool
}
