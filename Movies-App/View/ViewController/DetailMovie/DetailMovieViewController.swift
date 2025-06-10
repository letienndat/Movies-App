//
//  DetailMovieViewController.swift
//  Movies-App
//
//  Created by Le Tien Dat on 24/02/2025.
//

import UIKit
import FirebaseAuth

class DetailMovieViewController: UIViewController {

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var imageBackdrop: UIImageView!
    @IBOutlet private weak var imagePoster: UIImageView!
    @IBOutlet private weak var labelTitle: UILabel!
    @IBOutlet private weak var labelRating: UILabel!
    @IBOutlet private weak var labelTimeRelease: UILabel!
    @IBOutlet private weak var labelTimeMovie: UILabel!
    @IBOutlet private weak var labelGerneMovie: UILabel!
    @IBOutlet private weak var containerPage: UIView!
    @IBOutlet private weak var viewTabbar: UIView!
    @IBOutlet private weak var constraintHeightContainerView: NSLayoutConstraint!
    @IBOutlet private var tabbars: [UILabel]!
    @IBOutlet private weak var constraintWidthViewTabSelected: NSLayoutConstraint!
    @IBOutlet private weak var constraintLeadingViewTabSelected: NSLayoutConstraint!

    private let buttonSaveToWatchList = UIButton(type: .system)
    private var indexTabSelected = 0
    private var widthTabs: [CGFloat] = [0, 0, 0]

    private let refreshControl = UIRefreshControl()
    private lazy var pageVC = PageTabViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    private lazy var detailMoviePresenter = DetailMoviePresenter(detailMovieViewDelegate: self)
    weak var updateWatchListDelegate: UpdateWatchListDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
        setupView()
        fetchData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        /// Tracking
        guard let movie = detailMoviePresenter.movie,
              let genres = movie.genres?.map({ $0.id }) ?? movie.genreIds,
              let email = Auth.getCurrentUser()?.email
        else { return }

        let params: [String: Any] = [
            "email": email,
            "movie_id": movie.id,
            "genres": genres
        ]
        AppTracking.tracking(.click, params: params)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        imageBackdrop.roundCorners([.layerMinXMaxYCorner, .layerMaxXMaxYCorner], radius: 16)
    }

    private func setupView() {
        refreshControl.tintColor = AppConst.colorRefreshControl
        scrollView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handlePullReload), for: .valueChanged)

        scrollView.delegate = self
        setupLayout()

        for (index, view) in tabbars.enumerated() {
            view.tag = index
            view.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapTabbar(_:)))
            view.addGestureRecognizer(tap)
        }

        if let labelTitleTabFirst = tabbars[indexTabSelected] as UILabel? {
            labelTitleTabFirst.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        }

        if let tabFirst = tabbars[indexTabSelected] as UIView? {
            constraintWidthViewTabSelected.constant = tabFirst.frame.width
        }
    }

    private func setupLayout() {
        setupShowData()

        pageVC.movie = detailMoviePresenter.movie
        pageVC.heightContentViewDelegate = self
        pageVC.handleSwipePage = { [weak self] indexTab in
            guard let self else { return }
            self.makeTabSelect(indexTab: indexTab)
        }

        containerPage.addSubview(pageVC.view)

        pageVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageVC.view.topAnchor.constraint(equalTo: containerPage.topAnchor),
            pageVC.view.bottomAnchor.constraint(equalTo: containerPage.bottomAnchor),
            pageVC.view.leadingAnchor.constraint(equalTo: containerPage.leadingAnchor),
            pageVC.view.trailingAnchor.constraint(equalTo: containerPage.trailingAnchor)
        ])
    }

    private func setupNav() {
        title = detailMoviePresenter.movie?.title ?? "Detail Movie"

        buttonSaveToWatchList.tintColor = UIColor(hex: 0xFFFFFF)
        buttonSaveToWatchList.setImage(UIImage(systemName: "bookmark"), for: .normal)
        let rightBarButton = UIBarButtonItem(customView: buttonSaveToWatchList)
        navigationItem.rightBarButtonItem = rightBarButton

        buttonSaveToWatchList.addTarget(self, action: #selector(handleAddToWatchList), for: .touchUpInside)
    }

    func setupData(movie: Movie) {
        self.detailMoviePresenter.setMovie(movie: movie)
    }

    func setupShowData() {
        imageBackdrop.setImage(with: detailMoviePresenter.movie?.backdropUrl)
        imagePoster.setImage(with: detailMoviePresenter.movie?.posterUrl)
        labelTitle.text = detailMoviePresenter.movie?.title
        labelRating.text = String(format: "%.1f", detailMoviePresenter.movie?.voteAverage ?? 0)
        labelTimeRelease.text = detailMoviePresenter.movie?.releaseDate.components(separatedBy: "-")[0] ?? ""
        labelTimeMovie.text = "\(detailMoviePresenter.movie?.runtime ?? 0) minutes"

        let gerne = detailMoviePresenter.movie?.genres?.first
        labelGerneMovie.text = "\(gerne?.name ?? "No info")"

        let isMovieInWatchList = detailMoviePresenter.movie?.accountStates?.watchlist ?? false
        buttonSaveToWatchList.setImage(UIImage(systemName: isMovieInWatchList ? "bookmark.fill" : "bookmark"), for: .normal)
    }

    private func fetchData() {
        self.detailMoviePresenter.fetchMovieDetails(isReload: false)
    }

    @objc
    private func handlePullReload() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.detailMoviePresenter.fetchMovieDetails(isReload: true)
        }
    }

    @objc
    private func handleTapTabbar(_ sender: UITapGestureRecognizer) {
        guard let tag = sender.view?.tag, tag != indexTabSelected else { return }
        makeTabSelect(indexTab: tag)
        selectTab(index: tag)
    }

    @objc
    private func handleAddToWatchList() {
        let isMovieInWatchList = detailMoviePresenter.movie?.accountStates?.watchlist ?? false
        buttonSaveToWatchList.setImage(UIImage(systemName: !isMovieInWatchList ? "bookmark.fill" : "bookmark"), for: .normal)

        detailMoviePresenter.updateMovieInWatchList()
    }

    @IBAction private func handleTappedBtnPlay(_ sender: UIButton) {
        guard let movie = detailMoviePresenter.movie else { return }

        let storyboard = UIStoryboard(name: "WatchMovie", bundle: nil)
        guard let vc = storyboard.instantiateInitialViewController() as? WatchMovieViewController else { return }

        vc.setupData(movie: movie)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func selectTab(index: Int) {
        pageVC.selectTab(index: index)
    }

    func makeTabSelect(indexTab: Int) {
        if let labelTitle = tabbars[indexTab] as UILabel? {
            labelTitle.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        }

        if let labelTitleOld = tabbars[indexTabSelected] as UILabel? {
            labelTitleOld.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        }

        indexTabSelected = indexTab

        UIView.animate(withDuration: 0.3) {
            self.constraintLeadingViewTabSelected.constant = self.tabbars[indexTab].frame.minX
            self.constraintWidthViewTabSelected.constant = self.tabbars[indexTab].frame.width
            self.viewTabbar.layoutIfNeeded()
        }
    }
}

extension DetailMovieViewController: DetailMovieViewDelegate {
    func fetchMovieDetailSuccess() {
        setupShowData()
    }

    func reloadMovieDetailSuccess() {
        pageVC.view.removeFromSuperview()
        constraintHeightContainerView.constant = 0
        pageVC = PageTabViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        if indexTabSelected != 0 {
            makeTabSelect(indexTab: 0)
        }
        indexTabSelected = 0
        setupLayout()
    }

    func hideRefresh() {
        refreshControl.endRefreshing()
    }

    func showError(title: String, message: String) {
        showAlert(title: title, message: message)
    }

    func updateMovieInWatchListSuccess(message: String) {
        let isMovieInWatchList = detailMoviePresenter.movie?.accountStates?.watchlist ?? false
        buttonSaveToWatchList.setImage(UIImage(systemName: isMovieInWatchList ? "bookmark.fill" : "bookmark"), for: .normal)

        showAlert(title: "Success", message: message)

        /// Tracking
        guard let movie = detailMoviePresenter.movie,
              let genres = movie.genres?.map({ $0.id }) ?? movie.genreIds,
              let email = Auth.getCurrentUser()?.email
        else { return }

        let event: AppConst.TrackingEvent = isMovieInWatchList ? .addToWatchList : .removeFromWatchList
        let params: [String: Any] = [
            "email": email,
            "movie_id": movie.id,
            "genres": genres
        ]
        AppTracking.tracking(event, params: nil)

        guard let movie = detailMoviePresenter.movie else { return }
        guard updateWatchListDelegate != nil else {
            updateIdsMovieWatchList(idMovie: movie.id)
            return
        }

        updateWatchListDelegate!.updateWatchList(state: isMovieInWatchList ? .add : .remove, movie: movie)
    }

    func updateIdsMovieWatchList(idMovie: Int) {
        guard let nav = tabBarController?.viewControllers?[2] as? UINavigationController,
              let watchListScreen = nav.viewControllers.first as? WatchListViewController
        else { return }
        watchListScreen.watchListPresenter.updateIdsMovieWatchList(idMovie: idMovie)
    }
}

extension DetailMovieViewController: HeightContentViewDelegate {
    func heightContent(index: Int, height: CGFloat) {
        guard indexTabSelected == index else { return }
        constraintHeightContainerView.constant = height
    }

    func showLoading() {
        showHUD()
    }

    func hideLoading() {
        DispatchQueue.main.async {
            self.hideHUD()
        }
    }
}

extension DetailMovieViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let tabReview = pageVC.viewControllers?.first as? TabReviewsViewController else {
            return
        }

        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.size.height

        if offsetY > contentHeight - screenHeight {
            tabReview.fetchData(isLoadMore: true)
        }
    }
}
