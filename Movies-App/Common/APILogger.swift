//
//  APILogger.swift
//  Movies-App [DEV]
//
//  Created by Le Tien Dat on 10/6/25.
//

import Alamofire

class APILogger {
    static func logRequest(_ request: URLRequest) {
        let method = request.httpMethod ?? "GET"
        let url = request.url?.absoluteString ?? ""
        let headers = request.allHTTPHeaderFields ?? [:]
        let body =
            request.httpBody.flatMap { String(data: $0, encoding: .utf8) } ?? ""

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        let timestamp = dateFormatter.string(from: Date())

        var logOutput = """
            **************** HTTP REQUEST **********************
            \(timestamp)
            **** REQUEST ****
            $ curl -v \\
            \t-X \(method) \\
            """

        headers.forEach { key, value in
            logOutput += "\n\t-H \"\(key): \(value)\" \\"
        }

        if !body.isEmpty {
            logOutput +=
                "\n\t-d \"\(body.replacingOccurrences(of: "\"", with: "\\\""))\" \\"
        }

        logOutput += "\n\t\"\(url)\""
        print(logOutput)
    }

    static func logResponse(_ response: AFDataResponse<Data>) {
        let statusCode = response.response?.statusCode ?? 0
        let method = response.request?.httpMethod ?? "GET"
        let url = response.request?.url?.absoluteString ?? ""
        let headers = response.response?.allHeaderFields ?? [:]
        let data =
            response.data.flatMap { String(data: $0, encoding: .utf8) }
            ?? "None"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        let timestamp = dateFormatter.string(from: Date())

        // Kiểm tra trạng thái result bằng switch thay vì isSuccess
        let status: String
        var logHeader = "RESPONSE "
        switch response.result {
        case .success:
            status = "SUCCESS"
            logHeader +=
                statusCode >= 200 && statusCode < 300
                ? "HTTP \(status) \(statusCode)" : "HTTP ERROR \(statusCode)"
        case .failure:
            logHeader += "HTTP ERROR \(statusCode)"
        }

        var logOutput = """
            **************** \(logHeader) **********************
            \(timestamp)
            **** RESPONSE ****
            \(method) \(url)
            **** HEADERS ****
            \(headers.map { "\($0.key): \($0.value)" }.joined(separator: "\n"))
            **** BODY ****
            \(data.prettyPrintedJSON ?? data)
            """

        if case .failure(let error) = response.result {
            logOutput += """
                **** ERROR ****
                \(error.localizedDescription)
                """
            if let underlyingError = error.underlyingError {
                logOutput += """
                    \nUnderlying Error: \(underlyingError.localizedDescription)
                    """
            }
        }

        logOutput +=
            "\n********************************************************"

        print(logOutput)
    }
}
