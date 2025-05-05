//
//  TopRatedTableViewCell.swift
//  Movies-App
//
//  Created by Le Tien Dat on 07/02/2025.
//

import UIKit
import Kingfisher

class TopRatedTableViewCell: UITableViewCell {
    @IBOutlet private weak var collectionView: UICollectionView!

    weak var tapMovieDelegate: TapMovieDelegate?
    private var listMovies: ResponseTheMovieDBBase<Movie>?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(MovieTopRatedCollectionViewCell.nib, forCellWithReuseIdentifier: MovieTopRatedCollectionViewCell.reuseIdentifier)
        self.collectionView.showsHorizontalScrollIndicator = false
    }

    func setData(listMovies: ResponseTheMovieDBBase<Movie>?) {
        self.listMovies = listMovies
        collectionView.reloadData()
    }
}

extension TopRatedTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MovieTopRatedCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as! MovieTopRatedCollectionViewCell
        guard let movie = self.listMovies?.results[indexPath.item] else {
            return cell
        }
        cell.setData(number: indexPath.item + 1, movie: movie)
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
        let numberCell: CGFloat = 2

        let widthCell = (widthDevice - (paddingHorizontal * 2) - (spacing * (numberCell - 1))) / numberCell
        let heightCell = widthCell * 1.5

        return CGSize(width: widthCell, height: heightCell)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        20.12
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
    }
}

extension TopRatedTableViewCell: TapMovieDelegate {
    func didTapOnMovie(movie: Movie) {
        tapMovieDelegate?.didTapOnMovie(movie: movie)
    }
}
