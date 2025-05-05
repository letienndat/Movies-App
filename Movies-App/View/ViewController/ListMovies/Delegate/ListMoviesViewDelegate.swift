//
//  ListMoviesViewDelegate.swift
//  Movies-App
//
//  Created by Le Tien Dat on 24/02/2025.
//

import Foundation

protocol ListMoviesViewDelegate: AnyObject {
    func reloadTableView()
    func showLoadingMore()
    func hideLoadingMore()
    func hideLoadingReload()
    func showError(title: String, message: String)
}
