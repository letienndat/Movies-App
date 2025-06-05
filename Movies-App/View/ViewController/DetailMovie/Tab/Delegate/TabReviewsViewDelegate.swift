//
//  TabReviewsViewDelegate.swift
//  Movies-App
//
//  Created by Le Tien Dat on 25/02/2025.
//

import Foundation

protocol TabReviewsViewDelegate: AnyObject {
    func showReviews()
    func fetchError(_ msgErr: String)
    func heightContent(height: CGFloat)
}
