//
//  ListMoviesHomeTableViewCell.swift
//  Movies-App
//
//  Created by Le Tien Dat on 07/02/2025.
//

import UIKit

class ListMoviesHomeTableViewCell: UITableViewCell {

    @IBOutlet private weak var labelTitleCollection: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var buttonViewAll: UIButton!

    private var listMovies: ResponseTheMovieDBBase<Movie>?

    var closureHandleTappedViewAll: (() -> Void)?
    weak var tapMovieDelegate: TapMovieDelegate?
    var scrollViewDidScroll: ((CGPoint) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(MovieHomeCollectionViewCell.nib, forCellWithReuseIdentifier: MovieHomeCollectionViewCell.reuseIdentifier)
        self.collectionView.showsHorizontalScrollIndicator = false
    }

    @IBAction private func handleButtonSeeAll(_ sender: UIButton) {
        self.closureHandleTappedViewAll?()
    }

    func setData(data: GroupMovieCellData?) {
        guard let data else { return }

        labelTitleCollection.text = data.title
        self.listMovies = data.movies
        collectionView.reloadData()
        collectionView.setContentOffset(data.currentOffset, animated: false)
    }
}

extension ListMoviesHomeTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MovieHomeCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as! MovieHomeCollectionViewCell
        guard let movie = listMovies?.results[indexPath.item] else { return cell }
        cell.setData(movie: movie)
        cell.tapMovieDelegate = self

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.listMovies?.results.count ?? 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let widthDevice = UIScreen.main.bounds.width
        let paddingHorizontal: CGFloat = 24
        let spacing: CGFloat = 24
        let numberCell: CGFloat = 3

        let widthCell = (widthDevice - (paddingHorizontal * 2) - (spacing * (numberCell - 1))) / numberCell
        let heightCell = widthCell * 1.5

        return CGSize(width: widthCell, height: heightCell)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        24
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
    }
}

extension ListMoviesHomeTableViewCell: TapMovieDelegate {
    func didTapOnMovie(movie: Movie) {
        tapMovieDelegate?.didTapOnMovie(movie: movie)
    }
}

extension ListMoviesHomeTableViewCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewDidScroll?(scrollView.contentOffset)
    }
}
