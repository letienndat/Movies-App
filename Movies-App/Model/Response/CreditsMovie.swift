//
//  CreditsMovie.swift
//  Movies-App
//
//  Created by Le Tien Dat on 25/02/2025.
//

import Foundation

struct CreditsMovie: Decodable {
    let id: Int
    let cast: [CastMovie]
}

struct CastMovie: Decodable {
    let name: String
    let profilePath: String?
    var profileUrl: String? {
        guard let profilePath = profilePath else { return nil }
        return AppConst.baseURLTMDBImage + profilePath
    }

    enum CodingKeys: String, CodingKey {
        case name
        case profilePath = "profile_path"
    }
}
