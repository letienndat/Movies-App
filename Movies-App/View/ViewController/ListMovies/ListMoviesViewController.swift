//
//  ListMoviesViewController.swift
//  Movies-App
//
//  Created by Le Tien Dat on 10/02/2025.
//

import UIKit

class ListMoviesViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    private lazy var activityIndicator = UIActivityIndicatorView(style: .large)
    private lazy var refreshControl = UIRefreshControl()
    private lazy var listMoviesPresenter = ListMoviesPresenter(listMoviesViewDelegate: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
        setupView()
    }

    private func setupView() {
        tableView.register(MovieTableViewCell.nib, forCellReuseIdentifier: MovieTableViewCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self

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

    private func setupNav() {
        let buttonInfo = UIButton(type: .system)
        buttonInfo.setImage(UIImage(named: "icon-info-navigation"), for: .normal)
        buttonInfo.tintColor = UIColor(hex: 0xFFFFFF)

        let rightBarButton = UIBarButtonItem(customView: buttonInfo)

        navigationItem.rightBarButtonItem = rightBarButton
    }

    func setupData(title: String, type: TypeCellHome, listMovies: ResponseTheMovieDBBase<Movie>?) {
        self.title = title
        let caseTypeMovie = TypeMovie(for: type)
        listMoviesPresenter.setupData(
            movies: listMovies?.results,
            typeMovies: caseTypeMovie,
            totalPages: listMovies?.totalPages ?? 0,
            totalResults: listMovies?.totalResults ?? 0)
    }

    @objc
    private func handlePullReload() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.listMoviesPresenter.fetchMovies()
        }
    }
}

extension ListMoviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear

        return view
    }
}

extension ListMoviesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listMoviesPresenter.movies?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.reuseIdentifier, for: indexPath) as! MovieTableViewCell

        let movie = listMoviesPresenter.movies?[indexPath.item]
        cell.setupData(movie: movie)
        cell.tapMovieDelegate = self

        return cell
    }
}

extension ListMoviesViewController: ListMoviesViewDelegate {
    func reloadTableView() {
        tableView.reloadData()
        listMoviesPresenter.isLoading = false
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

extension ListMoviesViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.size.height

        // Scroll to end tableView
        if offsetY > contentHeight - screenHeight {
            listMoviesPresenter.fetchMovies(isLoadMore: true)
        }
    }
}

extension ListMoviesViewController: TapMovieDelegate {
    func didTapOnMovie(movie: Movie) {
        let storyboard = UIStoryboard(name: "DetailMovie", bundle: nil)
        guard let vc = storyboard.instantiateInitialViewController() as? DetailMovieViewController else { return }

        vc.setupData(movie: movie)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
