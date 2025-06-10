//
//  APIEventMonitor.swift
//  Movies-App [DEV]
//
//  Created by Le Tien Dat on 10/6/25.
//

import Alamofire
import Foundation

class APIEventMonitor: EventMonitor {
    func requestDidResume(_ request: Request) {
        guard let urlRequest = request.request else {
            print("⚠️ Request is nil")
            return
        }
        APILogger.logRequest(urlRequest)
    }

    func request<Value>(
        _ request: DataRequest,
        didParseResponse response: DataResponse<Value, AFError>
    ) {
        let dataResponse: AFDataResponse<Data>

        switch response.result {
        case .success:
            let data = response.data ?? Data()
            dataResponse = AFDataResponse<Data>(
                request: response.request,
                response: response.response,
                data: data,
                metrics: response.metrics,
                serializationDuration: response.serializationDuration,
                result: .success(data)
            )
        case .failure(let error):
            let data = response.data ?? Data()
            dataResponse = AFDataResponse<Data>(
                request: response.request,
                response: response.response,
                data: data,
                metrics: response.metrics,
                serializationDuration: response.serializationDuration,
                result: .failure(error)
            )
        }

        APILogger.logResponse(dataResponse)
    }
}
