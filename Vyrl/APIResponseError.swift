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
    case connectionProblem
    case accessDenied(APIError)
    case apiRequestError(APIError)
    case unexpectedFailure(Error)
    case modelDeserializationFailure(Error)
}

extension APIResponseError: Equatable { }

func == (lhs: APIResponseError, rhs: APIResponseError) -> Bool {
    switch(lhs, rhs) {
    case (.connectionProblem, .connectionProblem),
         (.accessDenied, .accessDenied),
         (.apiRequestError, .apiRequestError),
         (.unexpectedFailure, .unexpectedFailure),
         (.modelDeserializationFailure, .modelDeserializationFailure):
        return true
    default:
        return false
    }
}

extension APIResponseError {

    init(statusCode: StatusCode, error: Error, data: Data? = nil) {
        if let data = data, let apiError = try? data.deserialize(model: APIError.self) {
            self.init(statusCode: statusCode, apiError: apiError)
        } else {
            self.init(statusCode: statusCode, error: error)
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

    private init(statusCode: StatusCode, error: Error) {
        switch statusCode {
        case .accessDenied:
            self = .accessDenied(APIError(error: error as NSError))
        default:
            if Constants.connectionProblemURLCodes.contains((error as NSError).code) {
                self = .connectionProblem
            } else {
                self = .unexpectedFailure(error)
            }
        }
    }
}
