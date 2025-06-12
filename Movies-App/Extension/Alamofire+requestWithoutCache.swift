//
//  Alamofire+requestWithoutCache.swift
//  Movies-App
//
//  Created by Le Tien Dat on 6/12/25.
//

import Alamofire
import Foundation

extension Alamofire.Session {
    @discardableResult
    func requestWithoutCache(
        _ url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil
    )
        -> DataRequest
    {
        do {
            var urlRequest = try URLRequest(
                url: url, method: method, headers: headers)
            urlRequest.cachePolicy = .reloadIgnoringCacheData
            let encodedURLRequest = try encoding.encode(
                urlRequest, with: parameters)
            return request(encodedURLRequest)
        } catch {
            debugPrint(error)
            return request(
                URLRequest(url: URL(string: "http://example.com/wrong_request")!))
        }
    }
}
