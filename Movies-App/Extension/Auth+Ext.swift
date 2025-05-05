//
//  Auth+Ext.swift
//  Movies-App
//
//  Created by Le Tien Dat on 4/5/25.
//

import Foundation
import FirebaseAuth

extension Auth {
    static func isExistCurrentUser() -> Bool {
        auth().currentUser != nil
    }

    static func getCurrentUser() -> User? {
        auth().currentUser
    }

    static func getAuthMethod() -> AuthMethod {
        guard let method = auth().currentUser?.providerData.first else {
            return .unknown
        }
        return AuthMethod(rawValue: method.providerID) ?? .unknown
    }
}
