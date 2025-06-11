//
//  SearchViewController.swift
//  Movies-App
//
//  Created by Le Tien Dat on 10/02/2025.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet private weak var tableViewContent: UITableView!
    @IBOutlet private weak var tableViewItemSearch: UITableView!
    @IBOutlet private weak var viewNotifyEmpty: UIView!
    @IBOutlet private weak var textFieldSearch: PaddingTextField!

    private lazy var searchPresenter = SearchPresenter(searchViewDelegate: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
        setupView()
        setupKeyboardObservers()
    }

    private func setupView() {
        tableViewContent.translatesAutoresizingMaskIntoConstraints = false
        tableViewContent.keyboardDismissMode = .interactive
        tableViewContent.register(MovieTableViewCell.nib, forCellReuseIdentifier: MovieTableViewCell.reuseIdentifier)
        tableViewContent.delegate = self
        tableViewContent.dataSource = self

        tableViewItemSearch.register(ItemSearchTableViewCell.nib, forCellReuseIdentifier: ItemSearchTableViewCell.reuseIdentifier)
        tableViewItemSearch.delegate = self
        tableViewItemSearch.dataSource = self

        textFieldSearch.delegate = self
        textFieldSearch.padding = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 10)
        let buttonSearch = UIButton(type: .system)
        buttonSearch.setImage(UIImage(named: "icon-search"), for: .normal)
        buttonSearch.tintColor = UIColor(hex: 0x67686D)
        if #available(iOS 15.0, *) {
            var configButtonSearch = UIButton.Configuration.plain()
            configButtonSearch.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
            buttonSearch.configuration = configButtonSearch
        } else {
            buttonSearch.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }
        textFieldSearch.rightView = buttonSearch
        textFieldSearch.rightViewMode = .always

        textFieldSearch.attributedPlaceholder = NSAttributedString(
            string: textFieldSearch.placeholder ?? "Search",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor(hex: 0x67686D)
            ]
        )

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)

        buttonSearch.addTarget(self, action: #selector(handleSearch), for: .touchUpInside)
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
        guard self.isMovingToParent else { return }
        textFieldSearch.becomeFirstResponder()
    }

    @objc
    private func handleSearch() {
        searchPresenter.changeValueSearch(keywork: textFieldSearch.text ?? "")
        searchPresenter.search()
    }

    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc
    private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = keyboardFrame.cgRectValue.height
        tableViewContent.contentInset.bottom = keyboardHeight
    }

    @objc
    private func keyboardWillHide(_ notification: Notification) {
        tableViewContent.contentInset.bottom = 0
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        handleSearch()

        return true
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableViewContent {
            return searchPresenter.movies?.count ?? 0
        }
        if tableView == tableViewItemSearch {
            return 20
        }

        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableViewContent {
            let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.reuseIdentifier, for: indexPath) as! MovieTableViewCell

            let movie = searchPresenter.movies?[indexPath.item]
            cell.setupData(movie: movie)
            cell.tapMovieDelegate = self

            return cell
        }
        if tableView == tableViewItemSearch {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ItemSearchTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! ItemSearchTableViewCell

            let keyword = UUID().uuidString + UUID().uuidString
            cell.setupData(type: .history, keyword: keyword)
            cell.tapItemSearch = { [weak self] in
                guard let self else { return }
                self.dismissKeyboard()
            }
            cell.tapBtnFillSearchInput = { [weak self] in
                guard let self else { return }
                self.textFieldSearch.text = keyword
            }

            return cell
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        false
    }
}

extension SearchViewController: SearchViewDelegate {
    func reloadTableView(isLoadMore: Bool) {
        tableViewContent.isHidden = false
        viewNotifyEmpty.isHidden = true
        tableViewContent.reloadData()
        searchPresenter.isLoading = false

        if !isLoadMore {
            tableViewContent.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
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
}

extension SearchViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.size.height

        if offsetY > contentHeight - screenHeight {
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
