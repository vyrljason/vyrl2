//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol ResultProtocol {
    associatedtype SuccessType
    associatedtype ErrorType: Swift.Error

    @discardableResult func mapResult<Output>(ifSuccess: (SuccessType) -> Output, ifFailure: (ErrorType) -> Output) -> Output
    @discardableResult func when(success: ((SuccessType) -> Void)?, failure: ((ErrorType) -> Void)?) -> Self
}

extension ResultProtocol {
    @discardableResult func map<Output>(_ transform: (SuccessType) -> Output) -> Result<Output, ErrorType> {
        return mapResult(ifSuccess: { value in
            return Result<Output, ErrorType>(value: transform(value))
        }, ifFailure: { error in
            return Result<Output, ErrorType>(error: error)
        })
    }

    @discardableResult func mapError<OutputError>(_ transform: (ErrorType) -> OutputError) -> Result<SuccessType, OutputError> {
        return mapResult(ifSuccess: { value in
            return Result<SuccessType, OutputError>(value: value)
        }, ifFailure: { error in
            return Result<SuccessType, OutputError>(error: transform(error))
        })
    }

    @discardableResult func when(success: ((SuccessType) -> Void)? = nil, failure: ((ErrorType) -> Void)? = nil) -> Self {
        return mapResult(ifSuccess: { value in
            success?(value)
            return self
        }, ifFailure: { error in
            failure?(error)
            return self
        })
    }
}

enum Result<Success, Error:Swift.Error>: ResultProtocol {
    typealias SuccessType = Success
    typealias ErrorType = Error

    case success(Success)
    case failure(Error)

    init(value: Success) {
        self = .success(value)
    }

    init(error: Error) {
        self = .failure(error)
    }

    func mapResult<Result>(ifSuccess: (Success) -> Result, ifFailure: (Error) -> Result) -> Result {
        switch self {
        case .success(let value):
            return ifSuccess(value)
        case .failure(let error):
            return ifFailure(error)
        }
    }
}
