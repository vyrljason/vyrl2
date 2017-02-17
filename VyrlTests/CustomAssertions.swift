//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation
import XCTest
@testable import Vyrl

func expect<ResultType: ResultProtocol, SuccessType>(_ result: ResultType, toBeSuccessWith expected: SuccessType, file: StaticString = #file, line: UInt = #line) where ResultType.SuccessType == SuccessType, SuccessType: Equatable {
    result.on(success: { value in
        XCTAssertEqual(value, expected, file: file, line: line)
    }, failure: { _ in
        XCTFail(file: file, line: line)
    })
}

func expect<ResultType: ResultProtocol, SuccessType>(_ result: ResultType, toBeSuccessWith expected: [SuccessType], file: StaticString = #file, line: UInt = #line) where ResultType.SuccessType == [SuccessType], SuccessType: Equatable {
    result.on(success: { value in
        XCTAssertEqual(value, expected, file: file, line: line)
    }, failure: { _ in
        XCTFail(file: file, line: line)
    })
}

func expect<ResultType: ResultProtocol, ErrorType>(_ result: ResultType, toBeErrorWith expectedError: ErrorType, file: StaticString = #file, line: UInt = #line) where ResultType.ErrorType == ErrorType, ErrorType: Swift.Error, ErrorType: Equatable {
    result.on(success: { result in
        XCTFail(file: file, line: line)
    }, failure: { error in
        XCTAssertEqual(error, expectedError)
    })
}

func expectToBeSuccess<ResultType: ResultProtocol>(_ result: ResultType, file: StaticString = #file, line: UInt = #line) {
    result.on(success: { _ in },
                failure: { _ in
                    XCTFail(file: file, line: line)
    })
}

func expectToBeFailure<Result: ResultProtocol>(_ result: Result, file: StaticString = #file, line: UInt = #line) {
    result.on(success: { _ in
        XCTFail(file: file, line: line)
    }, failure: { _ in })
}
