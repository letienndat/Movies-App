//
//  ReviewTabTableViewCell.swift
//  Movies-App
//
//  Created by Le Tien Dat on 25/02/2025.
//

import UIKit

class ReviewTabTableViewCell: UITableViewCell {

    @IBOutlet private weak var avatarAuthor: UIImageView!
    @IBOutlet private weak var labelRating: UILabel!
    @IBOutlet private weak var labelNameAuthor: UILabel!
    @IBOutlet private weak var labelContentCommentByAuthor: UILabel!

    func setupData(review: ReviewMovie?) {
        avatarAuthor.setImage(with: review?.authorDetails.avatarUrl, placeholder: UIImage(named: "image-noface"))
        labelRating.text = String(review?.authorDetails.rating ?? 0)
        labelNameAuthor.text = (review?.author.isEmpty ?? true) ? "Name Author" : review?.author
        labelContentCommentByAuthor.text = review?.content
    }
}
