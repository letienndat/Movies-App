//
//  MovieTableViewCell.swift
//  Movies-App
//
//  Created by Le Tien Dat on 20/02/2025.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    weak var tapMovieDelegate: TapMovieDelegate?

    @IBOutlet private weak var posterMovie: UIImageView!
    @IBOutlet private weak var titleMovie: UILabel!
    @IBOutlet private weak var voteAverageMovie: UILabel!
    @IBOutlet private weak var genreMovie: UILabel!
    @IBOutlet private weak var timeReleaseMovie: UILabel!
    @IBOutlet private weak var timeMovie: UILabel!

    var closureTapMovie: ((Movie?) -> Void)?

    private var movie: Movie?

    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapMovie))
        self.addGestureRecognizer(tap)
    }

    func setupData(movie: Movie?) {
        self.movie = movie
        posterMovie.setImage(with: movie?.posterUrl, placeholder: UIImage(named: "poster-placeholder"))
        titleMovie.text = movie?.title ?? "Title movie"
        voteAverageMovie.text = String(format: "%.1f", movie?.voteAverage ?? 10.0)
        genreMovie.text = "Action"
        timeReleaseMovie.text = movie?.releaseDate.components(separatedBy: "-").first ?? ""
        timeMovie.text = "139 minutes"
    }

    @objc
    private func handleTapMovie() {
        guard let movie = movie else { return }
        tapMovieDelegate?.didTapOnMovie(movie: movie)
    }
}
