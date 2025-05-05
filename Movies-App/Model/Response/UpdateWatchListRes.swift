//
//  UpdateWatchListRes.swift
//  Movies-App
//
//  Created by Le Tien Dat on 03/03/2025.
//

import Foundation

struct UpdateWatchListRes: Decodable {
    let success: Bool
    let statusCode: Int
    let statusMessage: String

    enum CodingKeys: String, CodingKey {
        case success
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}
