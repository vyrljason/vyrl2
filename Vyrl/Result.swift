//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation

protocol ResultProtocol {
    associatedtype SuccessType
    associatedtype ErrorType: Swift.Error

    @discardableResult func map<Output>(success: (SuccessType) -> Output, failure: (ErrorType) -> Output) -> Output
    @discardableResult func on(success: ((SuccessType) -> Void)?, failure: ((ErrorType) -> Void)?) -> Self
}

extension ResultProtocol {
    @discardableResult func mapSuccess<Output>(_ transform: (SuccessType) -> Output) -> Result<Output, ErrorType> {
        return map(success: { value in
            return Result<Output, ErrorType>(value: transform(value))
        }, failure: { error in
            return Result<Output, ErrorType>(error: error)
        })
    }

    @discardableResult func mapError<OutputError>(_ transform: (ErrorType) -> OutputError) -> Result<SuccessType, OutputError> {
        return map(success: { value in
            return Result<SuccessType, OutputError>(value: value)
        }, failure: { error in
            return Result<SuccessType, OutputError>(error: transform(error))
        })
    }

    @discardableResult func on(success: ((SuccessType) -> Void)? = nil, failure: ((ErrorType) -> Void)? = nil) -> Self {
        return map(success: { value in
            success?(value)
            return self
        }, failure: { error in
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

    func map<Result>(success: (Success) -> Result, failure: (Error) -> Result) -> Result {
        switch self {
        case .success(let value):
            return success(value)
        case .failure(let error):
            return failure(error)
        }
    }
}
