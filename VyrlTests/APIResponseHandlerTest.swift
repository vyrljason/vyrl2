//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import XCTest
import Decodable
@testable import Vyrl

final class JSONToModelDeserializerMock: JSONToModelDeserializing {

    var success = true
    var error = NSError()

    func deserialize<Model: Decodable>(json: Any, model: Model.Type) throws -> Model {
        if success {
            let model = try model.decode(json)
            return model
        } else {
            throw error
        }
    }
}

final class APIResponseHandlerTest: XCTestCase {

    private var subject: APIResponseHandler!
    private var jsonDeserializer: JSONToModelDeserializerMock!

    override func setUp() {
        super.setUp()
        jsonDeserializer = JSONToModelDeserializerMock()
        subject = APIResponseHandler(jsonDeserializer: jsonDeserializer)
    }

    func test_handle_whenResponseIsSuccessAndModelIsValid_callsCompletionWithSuccessAndModel() {
        let validJSON = ["username": "test_user", "email": "email@email.com"]
        let expectedModel = MockUser(username:  validJSON["username"]!, email:  validJSON["email"]!)
        let dataResponse = DataResponseMock.dataWith(json: validJSON)

        let expectation = self.expectation(description: "to eventually be true")

        subject.handle(response: dataResponse) { (result: Result<MockUser, APIResponseError>) in
            expect(result, toBeSuccessWith: expectedModel)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 0.1)
    }

    func test_handle_whenResponseIsSuccessModelDeserializationFails_callsCompletionWithDeserializationError() {
        let validJSON = ["username": "test_user", "email": "email@email.com"]
        let dataResponse = DataResponseMock.dataWith(json: validJSON)
        jsonDeserializer.success = false

        let expectation = self.expectation(description: "to eventually be true")

        subject.handle(response: dataResponse) { (result: Result<MockUser, APIResponseError>) in
            expect(result, toBeErrorWith: APIResponseError.modelDeserializationFailure(self.jsonDeserializer.error))
            expectation.fulfill()
        }

        waitForExpectations(timeout: 0.1)
    }

    func test_handle_whenResponseIsFailureWithValidAPIError_callsCompletionWithAPIError() {
        let error = NSError(domain: "error", code: NSURLErrorUnknown, userInfo: nil)
        let apiError = APIError(statusCode: 333, name: "error", message: "error_message")
        let expectedError = APIResponseError.apiRequestError(apiError)
        let dataResponse = DataResponseMock.dataForValid(apiError: apiError, error: error)

        let expectation = self.expectation(description: "to eventually be true")

        subject.handle(response: dataResponse) { (result: Result<MockUser, APIResponseError>) in
            expect(result, toBeErrorWith: expectedError)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 0.1)
    }

    func test_handle_whenResponseIsFailureWithConnectionError_callsCompletionWithConnectionError() {
        let error = NSError(domain: "error", code: NSURLErrorNetworkConnectionLost, userInfo: nil)
        let expectedError = APIResponseError.connectionProblem
        let dataResponse = DataResponseMock.dataForValid(error: error)

        let expectation = self.expectation(description: "to eventually be true")

        subject.handle(response: dataResponse) { (result: Result<MockUser, APIResponseError>) in
            expect(result, toBeErrorWith: expectedError)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 0.1)
    }

    func test_handle_whenResponseIsFailureWithAccessDeniedError_callsCompletionWithAccessDeniedError() {
        let error = NSError(domain: "error", code: NSURLErrorUnknown, userInfo: nil)
        let expectedError = APIResponseError.accessDenied(APIError(error: error))
        let dataResponse = DataResponseMock.dataForValid(error: error, statusCode: 403)

        let expectation = self.expectation(description: "to eventually be true")

        subject.handle(response: dataResponse) { (result: Result<MockUser, APIResponseError>) in
            expect(result, toBeErrorWith: expectedError)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 0.1)
    }
}
