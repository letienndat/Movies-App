//
//  ResponseTheMovieDBBase.swift
//  Movies-App
//
//  Created by Le Tien Dat on 10/02/2025.
//

import Foundation

struct ResponseTheMovieDBBase<T: Decodable>: Decodable {
    let page: Int
    let results: [T]
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
