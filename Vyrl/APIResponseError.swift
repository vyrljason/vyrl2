//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

private struct Constants {
    static let connectionProblemURLCodes = [NSURLErrorCancelled, NSURLErrorCannotFindHost,
                                            NSURLErrorCannotConnectToHost, NSURLErrorNetworkConnectionLost,
                                            NSURLErrorNotConnectedToInternet, NSURLErrorDNSLookupFailed]
}

enum APIResponseError: Error {
    case unexpectedFailure
    case connectionProblem
    case accessDenied(APIError?)
    case apiRequestError(APIError)
    case httpResponse(Error)
    case modelDeserializationFailure(Error)
    case jsonDecodingFailure(Error)
}

extension APIResponseError {
    init(statusCode: StatusCode, data: Data? = nil, error: Error? = nil) {
        if let data = data, let apiError = try? data.deserialize(model: APIError.self) {
            switch statusCode {
            case .accessDenied:
                self = .accessDenied(apiError)
            default:
                self = .apiRequestError(apiError)
            }
            return
        }

        if let error = error as? NSError, Constants.connectionProblemURLCodes.contains(error.code) {
            self = .connectionProblem
            return
        }

        if let error = error {
            self = .httpResponse(error)
            return
        }

        switch statusCode {
        case .accessDenied:
            self = .accessDenied(nil)
        case .failure:
            self = .unexpectedFailure
        }
    }
}
