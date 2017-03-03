//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import XCTest
import Alamofire
import Decodable
@testable import Vyrl

class BaseAPIResourceTest: XCTestCase {

    var credentialsProvider: APICredentialsProviderMock!
    var apiConfiguration: APIConfigurationMock!
    var requestDataProvider: RequestDataProvider!
    var responseHandler: APIResponseHandler!
    var controller: HTTPClient!
    var sessionManager: SessionManagerMock!

    override func setUp() {
        super.setUp()
        apiConfiguration = APIConfigurationMock()
        credentialsProvider = APICredentialsProviderMock()
        credentialsProvider.userAccessToken = "token"
        requestDataProvider = RequestDataProvider(credentialsProvider: credentialsProvider)
        responseHandler = APIResponseHandler(jsonDeserializer: JSONToModelDeserializer())
        sessionManager = SessionManagerMock()
        sessionManager.startRequestsImmediately = false
        controller = HTTPClient(manager: sessionManager, apiConfiguration: apiConfiguration, requestDataProvider: requestDataProvider, responseHandler: responseHandler)
    }

    func assertDidCallTo(_ endpoint: APIEndpoint, file: StaticString = #file, line: UInt = #line) {
        var parsedParameters: Data? = nil
        if let parameters = endpoint.parameters, endpoint.authorization == .none {
            parsedParameters = try? JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
            XCTAssertNotNil(parsedParameters)
            XCTAssertEqual(sessionManager.lastRequest?.httpBody, parsedParameters, file: file, line: line)
        }
        XCTAssertEqual(sessionManager.lastRequest?.url?.host, endpoint.api.baseURL(using: apiConfiguration).host, file: file, line: line)
        XCTAssertEqual(sessionManager.lastRequest?.url?.path, endpoint.path, file: file, line: line)
        XCTAssertEqual(sessionManager.lastRequest?.httpMethod, String(describing: endpoint.method), file: file, line: line)
    }
}
