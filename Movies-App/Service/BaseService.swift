//
//  BaseService.swift
//  Movies-App
//
//  Created by Le Tien Dat on 12/02/2025.
//

import Foundation
import Alamofire

class BaseService {
    var url = ""
    var method = Alamofire.HTTPMethod.get
    var parameter: [String: Any]?
    var headers: HTTPHeaders?

    private var configuration: URLSessionConfiguration = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = AppConst.timeout
        configuration.timeoutIntervalForResource = AppConst.timeout

        return configuration
    }()
    lazy var AF: Session = {
        Session(configuration: configuration, eventMonitors: [APIEventMonitor()])
    }()

    init(url: String) {
        self.url = url
    }

    init(url: String, method: Alamofire.HTTPMethod) {
        self.url = url
        self.method = method
    }

    init(
        url: String,
        method: Alamofire.HTTPMethod,
        parameter: [String: Any]?
    ) {
        self.url = url
        self.method = method
        self.parameter = parameter
    }

    init(
        url: String,
        method: Alamofire.HTTPMethod,
        parameter: [String: Any]?,
        headers: HTTPHeaders?
    ) {
        self.url = url
        self.method = method
        self.parameter = parameter
        self.headers = headers
    }

    var encoding: ParameterEncoding {
        switch method {
        case .get:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }

    var encoder: ParameterEncoder {
        switch method {
        case .get:
            return URLEncodedFormParameterEncoder.default
        default:
            return JSONParameterEncoder.default
        }
    }
}
