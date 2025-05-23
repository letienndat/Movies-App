//
//  TypeCellHome.swift
//  Movies-App
//
//  Created by Le Tien Dat on 14/02/2025.
//

import Foundation
import UIKit

enum TypeCellHome: Int {
    case search
    case topRated
    case nowPlaying
    case trending
    case upcomming
    case popular

    var height: CGFloat {
        switch self {
        case .search:
            return UITableView.automaticDimension
        case .topRated:
            return computeHeight(numberCell: 2, padding: 24, spacing: 24) + 40
        case .nowPlaying, .trending, .upcomming, .popular:
            return computeHeight(numberCell: 3, padding: 24, spacing: 24) + 33 + 5 + 10
        }
    }

    private func computeHeight(numberCell: Int, padding: CGFloat, spacing: CGFloat) -> CGFloat {
        let widthDevice = UIScreen.main.bounds.width

        let widthCell = (widthDevice - (padding * 2) - (spacing * (CGFloat(numberCell) - 1))) / CGFloat(numberCell)
        let heightCell = widthCell * 1.5

        return heightCell
    }
}
