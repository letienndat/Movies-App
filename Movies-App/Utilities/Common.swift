//
//  Common.swift
//  Movies-App
//
//  Created by Le Tien Dat on 3/6/25.
//

import Foundation

func printJSON<T: Codable>(_ object: T) {
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
    do {
        let data = try encoder.encode(object)
        if let jsonString = String(data: data, encoding: .utf8) {
            print(jsonString)
        }
    } catch {
        print("Failed to encode object to JSON:", error)
    }
}
