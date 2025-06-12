//
//  SearchViewDelegate.swift
//  Movies-App
//
//  Created by Le Tien Dat on 20/02/2025.
//

import Foundation

protocol SearchViewDelegate: AnyObject {
    func reloadTableView(type: SearchPresenter.TableViewType, isLoadMore: Bool)
    func showNotifyEmpty()
    func showLoading()
    func hideLoading()
    func showError(title: String, message: String)
    func changeValueSearch(keyword: String)
    func updateStateShowItemSearch(isActive: Bool)
}
