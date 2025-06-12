//
//  SearchViewController.swift
//  Movies-App
//
//  Created by Le Tien Dat on 10/02/2025.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet private weak var constraintBottomContainerView: NSLayoutConstraint!
    @IBOutlet private weak var stackViewContentSearch: UIStackView!
    @IBOutlet private weak var tableViewContent: UITableView!
    @IBOutlet private weak var tableViewItemSearch: UITableView!
    @IBOutlet private weak var viewNotifyEmpty: UIView!
    @IBOutlet private weak var textFieldSearch: PaddingTextField!
    @IBOutlet private weak var buttonHideViewItemSearch: UIButton!

    private let buttonClear = UIButton(type: .system)
    private lazy var searchPresenter = SearchPresenter(searchViewDelegate: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
        setupView()
        setupKeyboardObservers()
    }

    private func setupView() {
        stackViewContentSearch.isHidden = searchPresenter.isShowListKeywordSearch

        tableViewContent.translatesAutoresizingMaskIntoConstraints = false
        tableViewContent.keyboardDismissMode = .interactive
        tableViewContent.register(MovieTableViewCell.nib, forCellReuseIdentifier: MovieTableViewCell.reuseIdentifier)
        tableViewContent.delegate = self
        tableViewContent.dataSource = self
        tableViewContent.contentInset = .init(top: 0, left: 0, bottom: 16, right: 0)

        tableViewItemSearch.register(ItemSearchTableViewCell.nib, forCellReuseIdentifier: ItemSearchTableViewCell.reuseIdentifier)
        tableViewItemSearch.delegate = self
        tableViewItemSearch.dataSource = self
        tableViewItemSearch.isHidden = !searchPresenter.isShowListKeywordSearch
        tableViewItemSearch.contentInset = .init(top: 0, left: 0, bottom: 16, right: 0)

        textFieldSearch.delegate = self
        textFieldSearch.padding = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 0)
        buttonClear.isHidden = true
        buttonClear.setPreferredSymbolConfiguration(
            UIImage.SymbolConfiguration(pointSize: 12, weight: .regular),
            forImageIn: .normal
        )
        buttonClear.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        buttonClear.setImage(UIImage(systemName: "xmark"), for: .normal)
        buttonClear.tintColor = UIColor(hex: 0x67686D)
        if #available(iOS 15.0, *) {
            var configbuttonClear = UIButton.Configuration.plain()
            configbuttonClear.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
            buttonClear.configuration = configbuttonClear
        } else {
            buttonClear.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }
        textFieldSearch.rightView = buttonClear
        textFieldSearch.rightViewMode = .always

        textFieldSearch.attributedPlaceholder = NSAttributedString(
            string: textFieldSearch.placeholder ?? "Search",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor(hex: 0x67686D)
            ]
        )

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)

        buttonClear.addTarget(self, action: #selector(handleClearSearch), for: .touchUpInside)

        let attributedString = NSAttributedString(
            string: "Hide",
            attributes: [
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
        )
        buttonHideViewItemSearch.setAttributedTitle(attributedString, for: .normal)
        buttonHideViewItemSearch.isHidden = !searchPresenter.isShowListKeywordSearch
    }

    private func setupNav() {
        let buttonInfo = UIButton(type: .system)
        buttonInfo.setImage(UIImage(named: "icon-info-navigation"), for: .normal)
        buttonInfo.tintColor = UIColor(hex: 0xFFFFFF)

        let rightBarButton = UIBarButtonItem(customView: buttonInfo)

        navigationItem.rightBarButtonItem = rightBarButton
    }

    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard let selectedIndex = tabBarController?.selectedIndex,
              self.isMovingToParent || selectedIndex == 1 // tab search
        else { return }

        if let coordinator = self.transitionCoordinator {
            coordinator.animate(alongsideTransition: nil) { _ in
                self.textFieldSearch.becomeFirstResponder()
            }
        } else {
            self.textFieldSearch.becomeFirstResponder()
        }
    }

    @objc
    private func handleClearSearch() {
        searchPresenter.clearKeywordSearch()
        textFieldSearch.becomeFirstResponder()
    }

    private func handleSearch() {
        searchPresenter.search()
    }

    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc
    private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }

        let keyboardHeight = keyboardFrame.cgRectValue.height
        if let tabBar = tabBarController?.tabBar, tabBar.isHidden == false {
            let heightTabbar = tabBarController?.tabBar.bounds.height ?? 0
            constraintBottomContainerView.constant = keyboardHeight - heightTabbar

            return
        }
        constraintBottomContainerView.constant = keyboardHeight
    }

    @objc
    private func keyboardWillHide(_ notification: Notification) {
        constraintBottomContainerView.constant = 0
    }

    @IBAction private func handleTapBtnHideViewItemSearch(_ sender: Any) {
        self.searchPresenter.isShowListKeywordSearch = false
        self.dismissKeyboard()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard !searchPresenter.keyword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return true
        }

        searchPresenter.isShowListKeywordSearch = false
        stackViewContentSearch.isHidden = searchPresenter.isShowListKeywordSearch
        tableViewItemSearch.isHidden = !searchPresenter.isShowListKeywordSearch
        textField.resignFirstResponder()
        handleSearch()

        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        DispatchQueue.main.async { [weak self] in
            self?.textFieldSearch.movePointerToEnd()
        }

        if !searchPresenter.isShowListKeywordSearch {
            searchPresenter.debouncedFetchKeywords()
        }
        tableViewItemSearch.reloadData()
        tableViewItemSearch.contentOffset = .zero
        searchPresenter.isShowListKeywordSearch = true
        stackViewContentSearch.isHidden = searchPresenter.isShowListKeywordSearch
        tableViewItemSearch.isHidden = !searchPresenter.isShowListKeywordSearch
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        searchPresenter.changeValueSearch(keyword: newText)

        return false
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableViewContent {
            return searchPresenter.movies?.count ?? 0
        }
        if tableView == tableViewItemSearch {
            return searchPresenter.allKeywordSuggessions.count
        }

        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableViewContent {
            let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.reuseIdentifier, for: indexPath) as! MovieTableViewCell

            let movie = searchPresenter.movies?[safe: indexPath.item]
            cell.setupData(movie: movie)
            cell.tapMovieDelegate = self

            return cell
        }
        if tableView == tableViewItemSearch {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ItemSearchTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! ItemSearchTableViewCell

            guard let keyword = searchPresenter.allKeywordSuggessions[safe: indexPath.item] else {
                return cell
            }
            cell.setupData(type: keyword.type ?? .search, keyword: keyword.name)
            cell.tapItemSearch = { [weak self] in
                guard let self else { return }
                self.searchPresenter.changeValueSearch(keyword: keyword.name)
                self.searchPresenter.isShowListKeywordSearch = false
                self.handleSearch()
                self.dismissKeyboard()
            }
            cell.tapBtnFillSearchInput = { [weak self] in
                guard let self else { return }
                self.searchPresenter.changeValueSearch(keyword: keyword.name)
                self.textFieldSearch.becomeFirstResponder()
            }
            cell.updateTextHighlight(searchPresenter.keyword)

            return cell
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        false
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView == tableViewItemSearch ? 50 : UITableView.automaticDimension
    }
}

extension SearchViewController: SearchViewDelegate {
    func reloadTableView(type: SearchPresenter.TableViewType, isLoadMore: Bool) {
        switch type {
        case .movies:
            tableViewContent.isHidden = false
            viewNotifyEmpty.isHidden = true
            tableViewContent.reloadData()
            searchPresenter.isLoadingMovieSearch = false

            if !isLoadMore && searchPresenter.movies?.count ?? 0 > 0 {
                tableViewContent.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            }
        case .keywords:
            tableViewItemSearch.reloadData()

            if isLoadMore {
                searchPresenter.isLoadingKeywordSearch = false
            } else {
                if (searchPresenter.keywordSuggessions ?? []).isNotEmpty {
                    tableViewItemSearch.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                }
            }
        }
    }

    func showNotifyEmpty() {
        tableViewContent.isHidden = true
        viewNotifyEmpty.isHidden = false
    }

    func showLoading() {
        showHUD()
    }

    func hideLoading() {
        DispatchQueue.main.async {
            self.hideHUD()
        }
    }

    func showError(title: String, message: String) {
        showAlert(title: title, message: message)
    }

    func changeValueSearch(keyword: String) {
        textFieldSearch.text = keyword
        buttonClear.isHidden = keyword.isEmpty
    }

    func updateStateShowItemSearch(isActive: Bool) {
        self.stackViewContentSearch.isHidden = self.searchPresenter.isShowListKeywordSearch
        self.tableViewItemSearch.isHidden = !self.searchPresenter.isShowListKeywordSearch
        self.buttonHideViewItemSearch.isHidden = !self.searchPresenter.isShowListKeywordSearch
    }
}

extension SearchViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.size.height

        guard offsetY > contentHeight - screenHeight else {
            return
        }

        if searchPresenter.isShowListKeywordSearch {
            searchPresenter.fetchKeywordsLoadMore()
        } else {
            searchPresenter.search(isLoadMore: true)
        }
    }
}

extension SearchViewController: TapMovieDelegate {
    func didTapOnMovie(movie: Movie) {
        let storyboard = UIStoryboard(name: "DetailMovie", bundle: nil)
        guard let vc = storyboard.instantiateInitialViewController() as? DetailMovieViewController else { return }

        vc.setupData(movie: movie)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
