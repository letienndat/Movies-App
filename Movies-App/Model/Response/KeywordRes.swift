//
//  KeywordRes.swift
//  Movies-App
//
//  Created by Le Tien Dat on 6/12/25.
//

import Foundation

enum KeywordType: Decodable {
    case history
    case search
}

struct KeywordRes: Decodable {
    var type: KeywordType?
    let name: String
}
