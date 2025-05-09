//
//  HomeViewController.swift
//  Movies-App
//
//  Created by Le Tien Dat on 07/02/2025.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    private lazy var refreshControl = UIRefreshControl()
    private lazy var homePresenter = HomePresenter(homeViewDelegate: self)
    private var cellHomeSelected: TypeCellHome?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
        setupView()
    }

    private func setupView() {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SearchTableViewCell.nib, forCellReuseIdentifier: SearchTableViewCell.reuseIdentifier)
        tableView.register(TopRatedTableViewCell.nib, forCellReuseIdentifier: TopRatedTableViewCell.reuseIdentifier)
        tableView.register(ListMoviesHomeTableViewCell.nib, forCellReuseIdentifier: ListMoviesHomeTableViewCell.reuseIdentifier)

        refreshControl.tintColor = AppConst.colorRefreshControl
        refreshControl.addTarget(self, action: #selector(handlePullReload), for: .valueChanged)
        tableView.refreshControl = refreshControl

        self.fetchData()
    }

    private func setupNav() {
        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToScreenListMovies" {
            guard let cellHomeSelected = cellHomeSelected else { return }
            switch cellHomeSelected {
            case .search:
                break
            case .topRated:
                break
            case .nowPlaying:
                let destinationVC = segue.destination as! ListMoviesViewController
                destinationVC.setupData(title: "Now Playing", listMovies: homePresenter.listMoviesNowPlaying)
            case .trending:
                let destinationVC = segue.destination as! ListMoviesViewController
                destinationVC.setupData(title: "Trending", listMovies: homePresenter.listMoviesTrending)
            case .upcomming:
                let destinationVC = segue.destination as! ListMoviesViewController
                destinationVC.setupData(title: "Upcoming", listMovies: homePresenter.listMoviesUpcoming)
            case .popular:
                let destinationVC = segue.destination as! ListMoviesViewController
                destinationVC.setupData(title: "Popular", listMovies: homePresenter.listMoviesPopular)
            }
        } else if segue.identifier == "goToScreenSearch" {
            let destinationVC = segue.destination as! SearchViewController
            destinationVC.hidesBottomBarWhenPushed = true
        }
    }

    private func fetchData() {
        homePresenter.fetchAll()
    }

    @objc
    private func handlePullReload() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.homePresenter.fetchAll()
        }
    }
}

extension HomeViewController: HomeViewDelegate {
    func displayListMovies(type: TypeCellHome) {
        tableView.reloadRows(at: [IndexPath(item: type.rawValue, section: 0)], with: .automatic)
    }

    func doneFetchAll() {
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
    }

    func fetchProfileError() {
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        guard let nav = storyboard.instantiateInitialViewController() else { return }

        self.view.window?.rootViewController = nav
        self.view.window?.makeKeyAndVisible()
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        6
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = TypeCellHome(rawValue: indexPath.item) else {
            return UITableViewCell()
        }

        switch row {
        case .search:
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.reuseIdentifier, for: indexPath) as! SearchTableViewCell
            cell.closureHandleTappedButtonSearch = { [weak self] in
                guard let self = self else { return }
                self.performSegue(withIdentifier: "goToScreenSearch", sender: self)
            }

            return cell
        case .topRated:
            let cell = tableView.dequeueReusableCell(withIdentifier: TopRatedTableViewCell.reuseIdentifier, for: indexPath) as! TopRatedTableViewCell
            cell.setData(listMovies: homePresenter.listMoviesTopRated)
            cell.tapMovieDelegate = self

            return cell
        case .nowPlaying:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ListMoviesHomeTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! ListMoviesHomeTableViewCell
            cell.closureHandleTappedViewAll = { [weak self] in
                guard let self = self else { return }
                self.cellHomeSelected = .nowPlaying
                self.performSegue(withIdentifier: "goToScreenListMovies", sender: self)
            }
            cell.setData(title: "Now Playing", listMovies: homePresenter.listMoviesNowPlaying)
            cell.tapMovieDelegate = self

            return cell
        case .trending:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ListMoviesHomeTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! ListMoviesHomeTableViewCell
            cell.closureHandleTappedViewAll = { [weak self] in
                guard let self = self else { return }
                self.cellHomeSelected = .trending
                self.performSegue(withIdentifier: "goToScreenListMovies", sender: self)
            }
            cell.setData(title: "Trending", listMovies: homePresenter.listMoviesTrending)
            cell.tapMovieDelegate = self

            return cell
        case .upcomming:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ListMoviesHomeTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! ListMoviesHomeTableViewCell
            cell.closureHandleTappedViewAll = { [weak self] in
                guard let self = self else { return }
                self.cellHomeSelected = .upcomming
                self.performSegue(withIdentifier: "goToScreenListMovies", sender: self)
            }
            cell.setData(title: "Upcoming", listMovies: homePresenter.listMoviesUpcoming)
            cell.tapMovieDelegate = self

            return cell
        case .popular:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ListMoviesHomeTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! ListMoviesHomeTableViewCell
            cell.closureHandleTappedViewAll = { [weak self] in
                guard let self = self else { return }
                self.cellHomeSelected = .popular
                self.performSegue(withIdentifier: "goToScreenListMovies", sender: self)
            }
            cell.setData(title: "Popular", listMovies: homePresenter.listMoviesPopular)
            cell.tapMovieDelegate = self

            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let row = TypeCellHome(rawValue: indexPath.item) else {
            return 300
        }

        return row.height
    }
}

extension HomeViewController: TapMovieDelegate {
    func didTapOnMovie(movie: Movie) {
        let storyboard = UIStoryboard(name: "DetailMovie", bundle: nil)
        guard let vc = storyboard.instantiateInitialViewController() as? DetailMovieViewController else { return }

        vc.setupData(movie: movie)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
