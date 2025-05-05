//
//  UIImageView+Ext.swift
//  Movies-App
//
//  Created by Le Tien Dat on 20/02/2025.
//

import Foundation
import UIKit
import Kingfisher
import SDWebImage

extension UIImageView {
//    @discardableResult
//    public func setImage(
//        with urlString: String?,
//        placeholder: Placeholder? = nil,
//        options: KingfisherOptionsInfo? = [
//            .processor(DefaultImageProcessor.default),
//            .cacheOriginalImage
//        ],
//        completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil) -> DownloadTask?
//    {
//        guard let urlString = urlString, let url = URL(string: urlString) else { return nil }
//        
//        return kf.setImage(
//            with: url,
//            placeholder: placeholder,
//            options: options,
//            completionHandler: completionHandler
//        )
//    }

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
