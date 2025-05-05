//
//  WatchListViewDelegate.swift
//  Movies-App
//
//  Created by Le Tien Dat on 03/03/2025.
//

import Foundation

protocol WatchListViewDelegate: AnyObject {
    func fetchWatchListSuccess(stateFetch: StateFetch)
    func watchListIsEmpty()
    func showLoadingMore()
    func hideLoadingMore()
    func hideLoadingReload()
    func showError(title: String, message: String)
}
