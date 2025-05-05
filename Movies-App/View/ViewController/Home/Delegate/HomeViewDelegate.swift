//
//  HomeViewDelegate.swift
//  Movies-App
//
//  Created by Le Tien Dat on 11/02/2025.
//

import Foundation

protocol HomeViewDelegate: AnyObject {
    func displayListMovies(type: TypeCellHome)
    func doneFetchAll()
    func fetchProfileError()
}
