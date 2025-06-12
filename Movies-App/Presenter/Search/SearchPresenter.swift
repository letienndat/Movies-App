//
//  SearchPresenter.swift
//  Movies-App
//
//  Created by Le Tien Dat on 20/02/2025.
//

import Foundation

final class SearchPresenter {
    enum TableViewType {
        case movies
        case keywords
    }

    private weak var searchViewDelegate: SearchViewDelegate?
    private let theMovieDBService = TheMovieDBService.shared

    private(set) var keyword: String = "" {
        didSet {
            searchViewDelegate?.changeValueSearch(keyword: keyword)
            fetchKeywords()
        }
    }
    private var pageMovieSearch = 1
    private var totalPagesMovieSearch = 0
    private var totalResultsMovieSearch = 0
    private(set) var movies: [Movie]?
    var historySearch: [String] {
        AppManager.historySearch ?? []
    }
    private var pageKeywordSearch = 1
    private var totalPagesKeywordSearch = 0
    private var totalResultsKeywordSearch = 0
    private(set) var keywordSuggessions: [String]?
    var allKeywordSuggessions: [KeywordRes] {
        var historySearchFilter: [KeywordRes] = historySearch.map({ .init(type: .history, name: $0) })
        if !keyword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            historySearchFilter = historySearch.filter({ $0.contains(keyword) })
                .map({ .init(type: .history, name: $0) })
        }

        let keywordSuggessions: [KeywordRes] = (self.keywordSuggessions ?? [])
            .filter({ keywordSearch in
                !historySearchFilter.contains(where: { $0.name == keywordSearch })
            })
            .map({ .init(type: .search, name: $0) })

        return historySearchFilter + keywordSuggessions
    }
    var isShowListKeywordSearch = true {
        didSet {
            searchViewDelegate?.updateStateShowItemSearch(isActive: isShowListKeywordSearch)
        }
    }
    var isLoadingMovieSearch = false
    var isLoadingKeywordSearch = false

    init(searchViewDelegate: SearchViewDelegate) {
        self.searchViewDelegate = searchViewDelegate
    }

    func changeValueSearch(keyword: String) {
        self.keyword = keyword
    }

    func search(isLoadMore: Bool = false) {
        if isLoadingMovieSearch {
            return
        }

        if (isLoadMore && movies == nil) ||
            (isLoadMore && movies != nil && movies!.count >= totalResultsMovieSearch) ||
            (isLoadMore && pageMovieSearch >= totalPagesMovieSearch) {
            return
        }

        let keyword = keyword.trimmingCharacters(in: .whitespaces)
        guard !keyword.isEmpty else {
            searchViewDelegate?.showError(title: "Error", message: AppError.missingRequiredFields.rawValue)
            return
        }

        updateHistorySearch(keyword)
        print("historySearch >>> \(historySearch)")
        isLoadingMovieSearch = true
        pageMovieSearch = isLoadMore ? pageMovieSearch + 1 : 1

        searchViewDelegate?.showLoading()

        theMovieDBService.search(query: keyword, page: pageMovieSearch) { [weak self] res in
            guard let self = self else { return }

            self.searchViewDelegate?.hideLoading()

            switch res {
            case .success(let listMovies):
                self.pageMovieSearch = self.pageMovieSearch > listMovies.totalPages ? listMovies.totalPages : self.pageMovieSearch
                if isLoadMore {
                    self.movies = (self.movies ?? []) + listMovies.results
                } else {
                    self.movies = listMovies.results
                }
                self.totalPagesMovieSearch = listMovies.totalPages
                self.totalResultsMovieSearch = listMovies.totalResults
                if self.movies?.count ?? 0 > 0 {
                    self.searchViewDelegate?.reloadTableView(type: .movies, isLoadMore: isLoadMore)
                    return
                }
                self.searchViewDelegate?.showNotifyEmpty()
                self.isLoadingMovieSearch = false
            case .failure(let err):
                self.pageMovieSearch -= 1
                if !isLoadMore {
                    self.searchViewDelegate?.showError(title: "Error", message: err.rawValue)
                }
                self.isLoadingMovieSearch = false
            }
        }
    }

    func fetchKeywords(isLoadMore: Bool = false) {
        if isLoadingKeywordSearch {
            return
        }

        if (isLoadMore && keywordSuggessions == nil) ||
            (isLoadMore && keywordSuggessions != nil && keywordSuggessions!.count >= totalPagesKeywordSearch) ||
            (isLoadMore && pageKeywordSearch >= totalPagesKeywordSearch) {
            return
        }

        let keyword = keyword.trimmingCharacters(in: .whitespaces)
        guard !keyword.isEmpty else {
            keywordSuggessions = []
            self.searchViewDelegate?.reloadTableView(type: .keywords, isLoadMore: false)
            return
        }

        isLoadingKeywordSearch = true
        pageKeywordSearch = isLoadMore ? pageKeywordSearch + 1 : 1

        if isLoadMore {
            searchViewDelegate?.showLoading()
        }

        theMovieDBService.fetchKeywords(query: keyword, page: pageKeywordSearch) { [weak self] res in
            guard let self = self else { return }

            if isLoadMore {
                searchViewDelegate?.hideLoading()
            }

            switch res {
            case .success(let keywords):
                let keywordResult = keywords.results.map(\.name)
                self.pageKeywordSearch = self.pageKeywordSearch > keywords.totalPages ? keywords.totalPages : self.pageKeywordSearch
                if isLoadMore {
                    self.keywordSuggessions = (self.keywordSuggessions ?? []) + keywordResult
                } else {
                    self.keywordSuggessions = keywordResult
                }
                self.totalPagesKeywordSearch = keywords.totalPages
                self.totalPagesKeywordSearch = keywords.totalResults
                self.searchViewDelegate?.reloadTableView(type: .keywords, isLoadMore: isLoadMore)
                self.isLoadingKeywordSearch = false
            case .failure(let err):
                self.pageKeywordSearch -= 1
                if !isLoadMore {
                    self.searchViewDelegate?.showError(title: "Error", message: err.rawValue)
                }
                self.isLoadingKeywordSearch = false
            }
        }
    }

    func clearKeywordSearch() {
        changeValueSearch(keyword: "")
        keywordSuggessions = []
    }

    func updateHistorySearch(_ keyword: String) {
        let keyword = keyword.trimmingCharacters(in: .whitespacesAndNewlines)
        var cache = historySearch

        if let index = cache.firstIndex(where: { $0 == keyword }) {
            cache.remove(at: index)
        }
        cache.insert(keyword, at: 0)
        AppManager.historySearch = cache
    }

    func removeHistorySearch(_ index: Int) -> String? {
        guard let value = historySearch[safe: index] else {
            return nil
        }

        var cache = historySearch
        cache.remove(at: index)
        AppManager.historySearch = cache
        return value
    }
}
