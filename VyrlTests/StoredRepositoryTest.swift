//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

struct StorableObject {
    let value: String
}

extension StorableObject: CustomStringConvertible {
    var description: String { return value }
}

extension StorableObject: Equatable {}
func == (lhs: StorableObject, rhs: StorableObject) -> Bool {
    return lhs.value == rhs.value
}

final class SourceMock: RepositorySource {
    typealias ResponseType = StorableObject

    var storageKey: KeychainKey = .chatToken
    var success = true
    var error: APIResponseError = APIResponseError.connectionProblem
    var object = StorableObject(value: "value")

    var completion: ((Result<ResponseType, APIResponseError>) -> Void)?

    func fetch(completion: @escaping (Result<ResponseType, APIResponseError>) -> Void) {
        self.completion = completion
    }

    func callCompletion() {
        if success {
            completion?(.success(object))
        } else {
            completion?(.failure(error))
        }
    }
}

final class StoredRepositoryTests: XCTestCase {

    private let sourceMock = SourceMock()
    private var repository: StoredRepository<SourceMock>!
    private let firstObject = StorableObject(value: "value1")
    private let secondObject = StorableObject(value: "value2")
    private var keychain: KeychainMock!

    override func setUp() {
        super.setUp()
        keychain = KeychainMock()
        repository = StoredRepository<SourceMock>(source: sourceMock, secureStorage: keychain)
    }

    func test_success_returnedObject() {
        sourceMock.success = true
        sourceMock.object = firstObject

        repository.fetch(refresh: true) { result in
            expect(result, toBeSuccessWith: self.firstObject.description)
        }

        sourceMock.callCompletion()
    }

    func test_fetch_whenSuccess_savesObjectToKeychain() {
        sourceMock.success = true
        sourceMock.object = firstObject
        var didFinish = false
        repository.fetch(refresh: true) { result in
            didFinish = true
            if case .success(let object) = result {
                XCTAssertEqual(self.keychain[self.sourceMock.storageKey], object.description)
            } else {
                XCTFail()
            }
        }

        sourceMock.callCompletion()
        XCTAssertTrue(didFinish)
    }

    func test_fetch_whenFailure_ReturnedErrorMessage() {
        sourceMock.success = false

        repository.fetch(refresh: true) { result in
            expect(result, toBeErrorWith: self.sourceMock.error)
        }

        sourceMock.callCompletion()
    }

    func test_fetch_whenRefreshIsFalse_storedDataIsLoaded() {
        keychain[sourceMock.storageKey] = firstObject.description

        sourceMock.object = secondObject

        repository.fetch(refresh: false) { result in
            expect(result, toBeSuccessWith: self.firstObject.description)
        }

        sourceMock.callCompletion()
    }

    func test_fetch_whenRefreshIsTrue_newDataIsLoaded() {
        self.keychain[sourceMock.storageKey] = firstObject.description

        sourceMock.object = secondObject

        repository.fetch(refresh: true) { resource in
            switch resource {
            case .success(let result):
                XCTAssertNotEqual(result, self.firstObject.description)
            case .failure:
                XCTFail()
            }
        }

        sourceMock.callCompletion()
    }

    func test_fetch_whenResponseIsSuccess_AllClosuresAreCalledOnSuccess() {

        sourceMock.success = true
        sourceMock.object = firstObject

        var count = 0

        repository.fetch(refresh: false) { _ in }

        sourceMock.callCompletion()

        repository.fetch(refresh: false) { _ in count += 1 }
        repository.fetch(refresh: false) { _ in count += 1 }
        repository.fetch(refresh: false) { _ in count += 1 }
        repository.fetch(refresh: false) { _ in count += 1 }

        XCTAssertEqual(count, 4)
    }

    func test_fetch_whenResponseIsFailure_AllClosuresAreCalledOnSuccess() {

        sourceMock.success = false
        sourceMock.error = .connectionProblem

        var count = 0

        repository.fetch(refresh: false) { _ in count += 1 }
        repository.fetch(refresh: false) { _ in count += 1 }
        repository.fetch(refresh: false) { _ in count += 1 }
        repository.fetch(refresh: false) { _ in count += 1 }

        sourceMock.callCompletion()

        XCTAssertEqual(count, 4)
    }

    func test_fetch_whenResponseIsSuccess_whenRefreshIsTrue_AllClosuresAreCalledOnSuccess() {

        sourceMock.success = true
        sourceMock.object = firstObject

        var count = 0

        repository.fetch(refresh: true) { _ in count += 1 }
        repository.fetch(refresh: true) { _ in count += 1 }
        repository.fetch(refresh: true) { _ in count += 1 }
        repository.fetch(refresh: true) { _ in count += 1 }

        sourceMock.callCompletion()

        XCTAssertEqual(count, 4)
    }

    func test_fetch_whenResponseIsFailure_whenRefreshIsTrue_AllClosuresAreCalledOnSuccess() {

        sourceMock.success = false
        sourceMock.error = .connectionProblem

        var count = 0

        repository.fetch(refresh: true) { _ in count += 1 }
        repository.fetch(refresh: true) { _ in count += 1 }
        repository.fetch(refresh: true) { _ in count += 1 }
        repository.fetch(refresh: true) { _ in count += 1 }

        sourceMock.callCompletion()

        XCTAssertEqual(count, 4)
    }

    func test_fetch_whenStorageIsCleared_fetchesNewData() {
        keychain[sourceMock.storageKey] = firstObject.description

        sourceMock.object = secondObject

        keychain[sourceMock.storageKey] = nil

        repository.fetch(refresh: false) { result in
            expect(result, toBeSuccessWith: self.secondObject.description)
        }

        sourceMock.callCompletion()
    }
}
