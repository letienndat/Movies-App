//
//  DetailMovieViewDelegate.swift
//  Movies-App
//
//  Created by Le Tien Dat on 24/02/2025.
//

import Foundation

protocol DetailMovieViewDelegate: AnyObject {
    func fetchMovieDetailSuccess()
    func updateMovieInWatchListSuccess(message: String)
    func reloadMovieDetailSuccess()
    func hideRefresh()
    func showError(title: String, message: String)
}
