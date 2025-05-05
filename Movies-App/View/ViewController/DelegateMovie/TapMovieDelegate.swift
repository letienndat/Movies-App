//
//  TapMovieDelegate.swift
//  Movies-App
//
//  Created by Le Tien Dat on 24/02/2025.
//

import Foundation

protocol TapMovieDelegate: AnyObject {
    func didTapOnMovie(movie: Movie)
}
