//
//  TrackingService.swift
//  Movies-App [DEV]
//
//  Created by Le Tien Dat on 6/10/25.
//

import Foundation
import Alamofire
import FirebaseAuth

private class TrackingService: BaseService {
    static let shared = TrackingService()

    private init() {
        let url = AppConst.baseURLServerTracking

        super.init(url: url, method: .get, parameter: nil, headers: nil)
    }

    func tracking(
        event: AppConst.TrackingEvent,
        params: [String: Any]
    ) {
        let endpoint = AppConst.TrackingEndpoint.tracking.endpoint
        let headers: HTTPHeaders = [.contentType("application/json")]
        let encoding: ParameterEncoding = JSONEncoding.default
        var params = params
        params["action"] = event.parameter

        AF.request(
            url + endpoint,
            method: .post,
            parameters: params,
            encoding: encoding,
            headers: headers
        )
        .responseDecodable(of: AppTrackingRes<RecommendationDTO>.self) { res in
            switch res.result {
            case .success(let data):
                printJSON(data)
            case .failure(let err):
                debugPrint(err.localizedDescription)
            }
        }
    }
}

class AppTracking {
    private static let trackingService = TrackingService.shared

    static func tracking(_ event: AppConst.TrackingEvent, params: [String: Any]) {
        guard let email = Auth.getCurrentUser()?.email else { return }
        var params = params
        params["email"] = email
        trackingService.tracking(event: event, params: params)
    }
}
