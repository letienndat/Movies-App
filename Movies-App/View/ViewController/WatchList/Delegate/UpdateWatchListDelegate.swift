//
//  UpdateWatchListDelegate.swift
//  Movies-App
//
//  Created by Le Tien Dat on 03/03/2025.
//

import Foundation

protocol UpdateWatchListDelegate: AnyObject {
    func updateWatchList(state: StateUpdateWatchList, movie: Movie)
}
