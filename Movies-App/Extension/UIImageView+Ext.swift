//
//  UIImageView+Ext.swift
//  Movies-App
//
//  Created by Le Tien Dat on 20/02/2025.
//

import Foundation
import UIKit
import SDWebImage

extension UIImageView {
    public func setImage(
        with urlString: String?,
        placeholder: UIImage? = nil,
        options: SDWebImageOptions = [.refreshCached, .highPriority, .retryFailed],
        completion: ((UIImage?, Error?, SDImageCacheType, URL?) -> Void)? = nil
    ) {
        guard let urlString = urlString, let url = URL(string: urlString) else { return }

        sd_setImage(
            with: url,
            placeholderImage: placeholder,
            options: options,
            completed: completion
        )
    }
}
