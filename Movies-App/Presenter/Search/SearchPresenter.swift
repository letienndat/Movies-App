//
//  SearchPresenter.swift
//  Movies-App
//
//  Created by Le Tien Dat on 20/02/2025.
//

import Foundation

final class SearchPresenter {
    private weak var searchViewDelegate: SearchViewDelegate?
    private let theMovieDBService = TheMovieDBService.shared

    private var keyword: String = ""
    private var page = 1
    private var totalPages = 0
    private var totalResults = 0
    private(set) var movies: [Movie]?
    var isLoading = false

    init(searchViewDelegate: SearchViewDelegate) {
        self.searchViewDelegate = searchViewDelegate
    }

    func changeValueSearch(keywork: String) {
        self.keyword = keywork
    }

    func search(isLoadMore: Bool = false) {
        if isLoading {
            return
        }

        if (isLoadMore && movies == nil) ||
            (isLoadMore && movies != nil && movies!.count >= totalResults) ||
            (isLoadMore && page >= totalPages) {
            return
        }

        let keyword = keyword.trimmingCharacters(in: .whitespaces)
        guard !keyword.isEmpty else {
            searchViewDelegate?.showError(title: "Error", message: AppError.missingRequiredFields.rawValue)
            return
        }

        isLoading = true
        page = isLoadMore ? page + 1 : 1

        searchViewDelegate?.showLoading()

        theMovieDBService.search(query: keyword, page: page) { [weak self] res in
                guard let self = self else { return }

                self.searchViewDelegate?.hideLoading()

                switch res {
                case .success(let listMovies):
                    self.page = self.page > listMovies.totalPages ? listMovies.totalPages : self.page
                    if isLoadMore {
                        self.movies = (self.movies ?? []) + listMovies.results
                    } else {
                        self.movies = listMovies.results
                    }
                    self.totalPages = listMovies.totalPages
                    self.totalResults = listMovies.totalResults
                    if self.movies?.count ?? 0 > 0 {
                        self.searchViewDelegate?.reloadTableView(isLoadMore: isLoadMore)
                        return
                    }
                    self.searchViewDelegate?.showNotifyEmpty()
                    self.isLoading = false
                case .failure(let err):
                    self.page -= 1
                    self.searchViewDelegate?.showError(title: "Error", message: err.rawValue)
                    self.isLoading = false
                }
        }
    }
}
