//
//  String+Ex.swift
//  Movies-App [DEV]
//
//  Created by Le Tien Dat on 10/6/25.
//

import Foundation

extension String {
    var prettyPrintedJSON: String? {
        guard let data = self.data(using: .utf8),
              let object = try? JSONSerialization.jsonObject(with: data, options: []),
              let prettyData = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyString = String(data: prettyData, encoding: .utf8) else {
            return nil
        }
        return prettyString
    }
}
