//
//  HeightContentViewDelegate.swift
//  Movies-App
//
//  Created by Le Tien Dat on 28/02/2025.
//

import Foundation

protocol HeightContentViewDelegate: AnyObject {
    func heightContent(index: Int, height: CGFloat)
    func showLoading()
    func hideLoading()
}
