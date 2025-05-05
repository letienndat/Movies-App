//
//  SignUpReq.swift
//  Movies-App
//
//  Created by Le Tien Dat on 17/02/2025.
//

import Foundation

struct SignUpReq: Encodable {
    let name: String
    let email: String
    let password: String
    let avatar: String
}
