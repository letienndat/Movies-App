//
//  CommonValidation.swift
//  Movies-App
//
//  Created by Le Tien Dat on 17/02/2025.
//

import Foundation

struct CommonValidation {
    static func isValidEmail(_ email: String?) -> Bool {
        guard let email = email, !email.isEmpty else { return false }
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }

    static func isValidPhoneNumber(_ phone: String?) -> Bool {
       guard let phone = phone, !phone.isEmpty else { return false }
       let regex = "^(0[0-9]{9,10})$"
       return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: phone)
    }

    static func isValidDate(_ dateString: String?, format: String = "dd-MM-yyyy") -> Bool {
        guard let dateString = dateString, !dateString.isEmpty else { return false }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.date(from: dateString) != nil
    }
}
