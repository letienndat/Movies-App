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
            if keyword.isEmpty {
                keywordSuggessions = []
            }
            searchViewDelegate?.changeValueSearch(keyword: keyword)
            debouncedFetchKeywords()
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
        let keywordTrim = keyword.trimmingCharacters(in: .whitespacesAndNewlines)
        if !keywordTrim.isEmpty {
            historySearchFilter = historySearch.filter({ $0.contains(keywordTrim) })
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

    var debounceWorkItem: DispatchWorkItem?

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
            return
        }

        updateHistorySearch(keyword)
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

    func debouncedFetchKeywords() {
        debounceWorkItem?.cancel()

        let workItem = DispatchWorkItem { [weak self] in
            self?.fetchKeywords()
        }

        debounceWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: workItem)
    }

    private func fetchKeywords() {
        let keyword = keyword.trimmingCharacters(in: .whitespaces)
        guard keyword.isNotEmpty else {
            keywordSuggessions = []
            searchViewDelegate?.reloadTableView(type: .keywords, isLoadMore: false)
            return
        }

        theMovieDBService.fetchKeywords(query: keyword) { [weak self] res in
            guard let self = self else { return }

            switch res {
            case .success(let keywords):
                let keywordResult = keywords.results.map(\.name)
                self.pageKeywordSearch = self.pageKeywordSearch > keywords.totalPages ? keywords.totalPages : self.pageKeywordSearch
                self.keywordSuggessions = keywordResult
                self.totalPagesKeywordSearch = keywords.totalPages
                self.totalPagesKeywordSearch = keywords.totalResults
                self.searchViewDelegate?.reloadTableView(type: .keywords, isLoadMore: false)
            case .failure(let err):
                self.searchViewDelegate?.showError(title: "Error", message: err.rawValue)
            }
        }
    }

    func fetchKeywordsLoadMore() {
        if isLoadingKeywordSearch {
            return
        }

        if keywordSuggessions == nil ||
            (keywordSuggessions != nil && keywordSuggessions!.count >= totalPagesKeywordSearch) ||
            pageKeywordSearch >= totalPagesKeywordSearch {
            return
        }

        let keyword = keyword.trimmingCharacters(in: .whitespaces)
        guard keyword.isNotEmpty else { return }

        isLoadingKeywordSearch = true
        pageKeywordSearch += 1

        searchViewDelegate?.showLoading()

        theMovieDBService.fetchKeywords(query: keyword, page: pageKeywordSearch) { [weak self] res in
            guard let self = self else { return }

            searchViewDelegate?.hideLoading()

            switch res {
            case .success(let keywords):
                let keywordResult = keywords.results.map(\.name)
                self.pageKeywordSearch = self.pageKeywordSearch > keywords.totalPages ? keywords.totalPages : self.pageKeywordSearch
                self.keywordSuggessions = (self.keywordSuggessions ?? []) + keywordResult
                self.totalPagesKeywordSearch = keywords.totalPages
                self.totalPagesKeywordSearch = keywords.totalResults
                self.searchViewDelegate?.reloadTableView(type: .keywords, isLoadMore: true)
                self.isLoadingKeywordSearch = false
            case .failure:
                self.pageKeywordSearch -= 1
                self.isLoadingKeywordSearch = false
            }
        }
    }

    func clearKeywordSearch() {
        changeValueSearch(keyword: "")
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
