//
//  CastTabCollectionViewCell.swift
//  Movies-App
//
//  Created by Le Tien Dat on 25/02/2025.
//

import UIKit

class CastTabCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var avatarCast: UIImageView!
    @IBOutlet private weak var labelNameCast: UILabel!

    func setupData(cast: CastMovie?) {
        avatarCast.setImage(with: cast?.profileUrl, placeholder: UIImage(named: "image-noface-cast"))
        labelNameCast.text = cast?.name
    }
}
