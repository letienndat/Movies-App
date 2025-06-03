//
//  AppTrackingService.swift
//  Movies-App
//
//  Created by Le Tien Dat on 6/3/25.
//

import Foundation
import Alamofire

class AppTrackingService: BaseService {
    static let shared = AppTrackingService()

    private init() {
        let url = AppConst.baseURLServerTracking

        super.init(url: url, method: .get, parameter: nil, headers: nil)
    }

    func tracking(
        type: AppConst.AppTrackingType,
        params: [String: Any]
    ) {
        let endpoint = AppConst.AppTrackingEndpoint.tracking.endpoint
        let headers: HTTPHeaders = [.contentType("application/json")]
        let encoding: ParameterEncoding = JSONEncoding.default
        var params = params
        params["action"] = type.parameter

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

    func fetchRecommendations(
        endpoint: String,
        completion: @escaping ((Result<RecommendationDTO, AppError>) -> Void)
    ) {
        AF.request(
            url + endpoint,
            parameters: parameter,
            headers: headers
        )
        .responseDecodable(of: AppTrackingRes<RecommendationDTO>.self) { res in
            switch res.result {
            case .success(let data):
                printJSON(data)
                guard let data = data.data else { return }
                completion(.success(data))
            case .failure(let err):
                debugPrint(err.localizedDescription)
                let err = AppError(from: err)
                completion(.failure(err))
            }
        }
    }
}
