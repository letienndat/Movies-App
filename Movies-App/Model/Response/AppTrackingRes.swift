//
//  AppTrackingRes.swift
//  Movies-App
//
//  Created by Le Tien Dat on 6/3/25.
//

import Foundation

struct AppTrackingRes<T: Codable>: Codable {
    let status: String
    let message: String
    let data: T?
}

struct RecommendationDTO: Codable {
    let topGenre: Int
    let topGenreName: String
    let genreScores: [GenreScoreDTO]
}

struct GenreScoreDTO: Codable {
    let genreID: Int
    let genre: String
    let score: Int?
}
