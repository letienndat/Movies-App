//
//  WatchListViewController.swift
//  Movies-App
//
//  Created by Le Tien Dat on 03/03/2025.
//

import UIKit

class WatchListViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var viewNotifyEmptyListMovie: UIView!

    private lazy var activityIndicator = UIActivityIndicatorView(style: .large)
    private lazy var refreshControl = UIRefreshControl()
    lazy var watchListPresenter = WatchListPresenter(watchListViewDelegate: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !watchListPresenter.idsMovieWatchList.isEmpty {
            fetchData()
            watchListPresenter.clearIdsMovieWatchList()
        }
    }

    private func setupView() {
        tableView.register(MovieTableViewCell.nib, forCellReuseIdentifier: MovieTableViewCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self

        refreshControl.tintColor = AppConst.colorRefreshControl
        refreshControl.addTarget(self, action: #selector(handlePullReload), for: .valueChanged)
        tableView.refreshControl = refreshControl

        activityIndicator.color = AppConst.colorRefreshControl
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func fetchData() {
        watchListPresenter.fetchWatchList(stateFetch: .firstFetch)
    }

    @objc
    private func handlePullReload() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.watchListPresenter.fetchWatchList(stateFetch: .reload)
        }
    }
}

extension WatchListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        watchListPresenter.movies?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.reuseIdentifier, for: indexPath) as! MovieTableViewCell

        let movie = watchListPresenter.movies?[indexPath.item]
        cell.setupData(movie: movie)
        cell.tapMovieDelegate = self

        return cell
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear

        return view
    }
}

extension WatchListViewController: WatchListViewDelegate {
    func fetchWatchListSuccess(stateFetch: StateFetch) {
        tableView.isHidden = false
        viewNotifyEmptyListMovie.isHidden = true
        tableView.reloadData()
        watchListPresenter.isLoading = false

        if stateFetch == .firstFetch {
            tableView.selectRow(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .top)
        }
    }

    func watchListIsEmpty() {
        tableView.isHidden = true
        viewNotifyEmptyListMovie.isHidden = false
    }

    func showLoadingMore() {
        activityIndicator.startAnimating()
    }

    func hideLoadingMore() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }

    func hideLoadingReload() {
        self.refreshControl.endRefreshing()
    }

    func showError(title: String, message: String) {
        showAlert(title: title, message: message)
    }
}

extension WatchListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.size.height

        // Scroll to end tableView
        if offsetY > contentHeight - screenHeight {
            watchListPresenter.fetchWatchList(stateFetch: .loadMore)
        }
    }
}

extension WatchListViewController: TapMovieDelegate {
    func didTapOnMovie(movie: Movie) {
        let storyboard = UIStoryboard(name: "DetailMovie", bundle: nil)
        guard let vc = storyboard.instantiateInitialViewController() as? DetailMovieViewController else { return }

        var movie = movie
        movie.accountStates = AccountStates(favorite: false, rated: false, watchlist: true)
        vc.setupData(movie: movie)
        vc.updateWatchListDelegate = self
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension WatchListViewController: UpdateWatchListDelegate {
    func updateWatchList(state: StateUpdateWatchList, movie: Movie) {
        watchListPresenter.updateWatchList(state: state, movie: movie)
        tableView.reloadData()
    }
}
