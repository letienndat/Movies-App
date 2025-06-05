//
//  Array+Ext.swift
//  Movies-App
//
//  Created by Le Tien Dat on 5/6/25.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
