//
//  LoginRes.swift
//  Movies-App
//
//  Created by Le Tien Dat on 14/02/2025.
//

import Foundation

struct LoginRes: Decodable {
    let accessToken: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}
