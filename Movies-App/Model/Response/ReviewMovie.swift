//
//  ReviewMovie.swift
//  Movies-App
//
//  Created by Le Tien Dat on 25/02/2025.
//

import Foundation

struct ReviewMovie: Decodable {
    let author: String
    let authorDetails: AuthorReview
    let content: String
    let createdAt: String
    let id: String
    let updatedAt: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case author, content, id, url
        case authorDetails = "author_details"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct AuthorReview: Decodable {
    let name: String
    let username: String
    let avatarPath: String?
    var avatarUrl: String? {
        guard let avatarPath = avatarPath else { return nil }

        return AppConst.baseURLTMDBImage + avatarPath
    }
    let rating: Int?

    enum CodingKeys: String, CodingKey {
        case name, username, rating
        case avatarPath = "avatar_path"
    }
}
