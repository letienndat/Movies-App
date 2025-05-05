//
//  WatchMovieViewDelegate.swift
//  Movies-App
//
//  Created by Le Tien Dat on 04/03/2025.
//

import Foundation

protocol WatchMovieViewDelegate: AnyObject {
    func fetchTrailerMovieSuccess()
    func showError(title: String, message: String)
}
