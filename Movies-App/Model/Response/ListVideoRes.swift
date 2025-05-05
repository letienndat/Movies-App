//
//  ListVideoRes.swift
//  Movies-App
//
//  Created by Le Tien Dat on 04/03/2025.
//

import Foundation

struct ListVideoRes: Decodable {
    let id: Int
    let results: [VideoRes]
}

struct VideoRes: Decodable {
    let id: String
    let type: String
    let site: String
    let key: String
}
