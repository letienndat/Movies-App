//
//  TypeMovie.swift
//  Movies-App
//
//  Created by Le Tien Dat on 24/02/2025.
//

import Foundation

enum TypeMovie {
    case nowPlaying
    case trending
    case upcoming
    case popular
    case recommendForYou
    case youMightLike

    init?(for cell: TypeCellHome) {
        switch cell {
        case .search, .topRated:
            return nil
        case .nowPlaying:
            self = .nowPlaying
        case .trending:
            self = .trending
        case .upcomming:
            self = .upcoming
        case .popular:
            self = .popular
        case .moviesRecommendForYou:
            self = .recommendForYou
        case .moviesYouMightLike:
            self = .youMightLike
        }
    }
}
