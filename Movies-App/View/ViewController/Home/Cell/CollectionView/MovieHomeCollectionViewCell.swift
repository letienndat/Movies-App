//
//  MovieHomeCollectionViewCell.swift
//  Movies-App
//
//  Created by Le Tien Dat on 07/02/2025.
//

import UIKit

class MovieHomeCollectionViewCell: UICollectionViewCell {

    weak var tapMovieDelegate: TapMovieDelegate?

    @IBOutlet private weak var imagePoster: UIImageView!

    private var movie: Movie?
    var closureTapMovie: ((Movie?) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        imagePoster.layer.cornerRadius = 16
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapMovie))
        self.addGestureRecognizer(tap)
    }

    func setData(movie: Movie) {
        self.movie = movie
        imagePoster.setImage(with: movie.posterUrl, placeholder: UIImage(named: "poster-placeholder"))
    }

    @objc
    private func handleTapMovie() {
        guard let movie = movie else { return }
        tapMovieDelegate?.didTapOnMovie(movie: movie)
    }
}
