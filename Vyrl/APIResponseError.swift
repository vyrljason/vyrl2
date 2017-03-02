//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation
import Decodable

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
    case modelDeserializationFailure(DecodingError)
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

    init(statusCode: StatusCode?, error: Error, data: Data? = nil) {
        guard let statusCode = statusCode else {
            self.init(error: error)
            return
        }
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
        if case .accessDenied = statusCode {
            self.init(statusCode: statusCode, apiError: APIError(error: error as NSError))
        } else {
            self.init(error: error)
        }
    }

    private init(error: Error) {
        switch error {
        case let decodingError as DecodingError:
            self = .modelDeserializationFailure(decodingError)
        case let connectionError where Constants.connectionProblemURLCodes.contains((connectionError as NSError).code):
            self = .connectionProblem
        default:
            self = .unexpectedFailure(error)
        }
    }
}
