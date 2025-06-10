//
//  AppService.swift
//  Movies-App
//
//  Created by Le Tien Dat on 6/3/25.
//

import Foundation
import Alamofire

class AppService: BaseService {
    static let shared = AppService()

    private init() {
        let url = AppConst.baseURLServerTracking

        super.init(url: url, method: .get, parameter: nil, headers: nil)
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
