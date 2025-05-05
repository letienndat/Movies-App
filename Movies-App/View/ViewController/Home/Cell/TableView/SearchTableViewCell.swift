//
//  SearchTableViewCell.swift
//  Movies-App
//
//  Created by Le Tien Dat on 07/02/2025.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet private weak var viewSearch: UIView!

    public static let nibName = "SearchTableViewCell"
    var closureHandleTappedButtonSearch: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        viewSearch.layer.cornerRadius = 16
        let action = UITapGestureRecognizer(target: self, action: #selector(handleTapButtonSearch))
        viewSearch.addGestureRecognizer(action)
    }

    @objc
    private func handleTapButtonSearch() {
        self.closureHandleTappedButtonSearch?()
    }
}
