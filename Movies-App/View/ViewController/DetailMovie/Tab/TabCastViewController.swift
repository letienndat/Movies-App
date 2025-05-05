//
//  TabCastViewController.swift
//  Movies-App
//
//  Created by Lê Tiến Đạt on 24/2/25.
//

import UIKit

class TabCastViewController: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView!

    private lazy var tabCastPresenter = TabCastPresenter(tabCastViewDelegate: self)
    weak var pageTabViewDelegate: PageTabViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.layoutIfNeeded()
        self.tabCastPresenter.computeHeightContent(view: collectionView)
    }

    func setupView() {
        collectionView.register(CastTabCollectionViewCell.nib, forCellWithReuseIdentifier: CastTabCollectionViewCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    func setupData(id: Int?) {
        tabCastPresenter.id = id
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
}

extension TabCastViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        24
    }
}

extension TabCastViewController: TabCastViewDelegate {
    func heightContent(height: CGFloat) {
        pageTabViewDelegate?.heightContent(index: 2, height: height)
    }

    func showCast() {
        self.collectionView.reloadData()
        self.view.setNeedsLayout()
    }
}
