//
//  ItemSearchTableViewCell.swift
//  Movies-App
//
//  Created by Le Tien Dat on 11/6/25.
//

import UIKit

class ItemSearchTableViewCell: UITableViewCell {
    enum ItemSearchType {
        case search
        case history
    }

    @IBOutlet private weak var iconLeftImageView: UIImageView!
    @IBOutlet private weak var itemKeywordLabel: UILabel!

    var tapItemSearch: (() -> Void)?
    var tapBtnFillSearchInput: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapCell))
        contentView.addGestureRecognizer(tap)
    }

    func setupData(type: ItemSearchType, keyword: String) {
        if type == .history {
            iconLeftImageView.image = UIImage(systemName: "arrow.counterclockwise")
        } else if type == .search {
            iconLeftImageView.image = UIImage(systemName: "magnifyingglass")
        }

        itemKeywordLabel.text = keyword
    }

    @IBAction private func handleTapBtnFillSearchInput(_ sender: UIButton) {
        tapBtnFillSearchInput?()
    }

    @objc
    private func handleTapCell() {
        tapItemSearch?()
    }
}
