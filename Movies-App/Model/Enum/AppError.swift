//
//  AppError.swift
//  Movies-App
//
//  Created by Le Tien Dat on 17/02/2025.
//

import Foundation
import Alamofire

enum AppError: String, Error {
    case serverError = "Error from server."
    case missingRequiredFields = "Please fill in all information."
    case missingRequiredFieldEmail = "Please enter email."

    init(from afError: AFError) {
        self = .serverError
    }
}
