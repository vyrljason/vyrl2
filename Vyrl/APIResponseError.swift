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
            self.init(statusCode: statusCode, apiError: apiError)
        } else if let error = error {
            self.init(error: error)
        } else {
            self.init(statusCode: statusCode)
        }
    }

    private init(statusCode: StatusCode, apiError: APIError) {
        switch statusCode {
        case .accessDenied:
            self = .accessDenied(apiError)
        default:
            self = .apiRequestError(apiError)
        }
    }

    private init(error: Error) {
        if Constants.connectionProblemURLCodes.contains((error as NSError).code) {
            self = .connectionProblem
        } else {
            self = .httpResponse(error)
        }
    }

    private init(statusCode: StatusCode) {
        switch statusCode {
        case .accessDenied:
            self = .accessDenied(nil)
        default:
            self = .unexpectedFailure
        }
    }
}
