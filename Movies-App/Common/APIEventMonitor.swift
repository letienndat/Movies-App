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
        APILogger.logRequest(request.request!)
    }

    func request(
        _ request: Request,
        didParseResponse response: DataResponse<Data?, AFError>
    ) {
        guard let data = response.data else { return }

        let dataResponse = AFDataResponse<Data>(
            request: response.request,
            response: response.response,
            data: data,
            metrics: response.metrics,
            serializationDuration: response.serializationDuration,
            result: .success(data)
        )

        APILogger.logResponse(dataResponse)
    }
}
