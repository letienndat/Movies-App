//
//  TabCastViewController.swift
//  Movies-App
//
//  Created by Lê Tiến Đạt on 24/2/25.
//

import UIKit

class TabCastViewController: UIViewController {

    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!

    private lazy var tabCastPresenter = TabCastPresenter(tabCastViewDelegate: self)
    weak var pageTabViewDelegate: PageTabViewDelegate?
    private var width: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        /// Tracking
        guard let movie = tabCastPresenter.movie,
              let genres = movie.genres?.map({ $0.id }) ?? movie.genreIds
        else { return }

        let params: [String: Any] = [
            "movie_id": movie.id,
            "genres": genres
        ]
        AppTracking.tracking(.tapTabCastMovie, params: params)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.layoutIfNeeded()
        self.tabCastPresenter.computeHeightContent(
            collectionView: collectionView,
            label: descriptionLabel,
            width: width
        )
    }

    func setupView() {
        collectionView.register(CastTabCollectionViewCell.nib, forCellWithReuseIdentifier: CastTabCollectionViewCell.reuseIdentifier)
        collectionView.isHidden = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = createLayout()
    }

    func setupData(movie: Movie?) {
        tabCastPresenter.movie = movie
    }

    func fetchData() {
        tabCastPresenter.fetchCastMovie()
    }
}

extension TabCastViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tabCastPresenter.listCasts?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CastTabCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as! CastTabCollectionViewCell
        let cast = tabCastPresenter.listCasts?[indexPath.item]
        cell.setupData(cast: cast)

        return cell
    }

    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(128)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(128)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 2 // 2 column
        )
        group.interItemSpacing = .fixed(65) // spacing item in row: 65

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .zero
        section.interGroupSpacing = 24 // spacing item in row: 24

        return UICollectionViewCompositionalLayout(section: section)
    }
}

extension TabCastViewController: TabCastViewDelegate {
    func heightContent(height: CGFloat) {
        pageTabViewDelegate?.heightContent(index: 2, height: height)
    }

    func showCast() {
        guard let listReviews = tabCastPresenter.listCasts,
              !listReviews.isEmpty
        else {
            self.descriptionLabel.text = "There are no casts for this movie."
            self.descriptionLabel.isHidden = false
            self.collectionView.isHidden = true
            return
        }

        self.collectionView.reloadData()
        self.collectionView.isHidden = false
        self.descriptionLabel.isHidden = true
        self.view.setNeedsLayout()
    }

    func fetchError(_ msgErr: String) {
        descriptionLabel.text = msgErr
        collectionView.isHidden = true
        descriptionLabel.isHidden = false
    }
}
