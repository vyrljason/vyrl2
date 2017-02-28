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
    var headersProvider: HTTPHeadersProvider!
    var responseHandler: APIResponseHandler!
    var controller: HTTPClient!
    var sessionManager: SessionManagerMock!

    override func setUp() {
        super.setUp()
        apiConfiguration = APIConfigurationMock()
        credentialsProvider = APICredentialsProviderMock()
        credentialsProvider.userAccessToken = "token"
        headersProvider = HTTPHeadersProvider(credentialsProvider: credentialsProvider)
        responseHandler = APIResponseHandler(jsonDeserializer: JSONToModelDeserializer())
        sessionManager = SessionManagerMock()
        sessionManager.startRequestsImmediately = false
        controller = HTTPClient(manager: sessionManager, apiConfiguration: apiConfiguration, headersProvider: headersProvider, responseHandler: responseHandler)
    }

    func assertDidCallTo(_ endpoint: APIEndpoint, file: StaticString = #file, line: UInt = #line) {
        var parsedParameters: Data? = nil
        if let parameters = endpoint.parameters {
            parsedParameters = try? JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
            XCTAssertNotNil(parsedParameters)
            XCTAssertEqual(sessionManager.lastRequest?.httpBody, parsedParameters)
        }
        XCTAssertEqual(sessionManager.lastRequest?.url?.host, endpoint.api.baseURL(using: apiConfiguration).host, file: file, line: line)
        XCTAssertEqual(sessionManager.lastRequest?.url?.path, endpoint.path, file: file, line: line)
        XCTAssertEqual(sessionManager.lastRequest?.httpMethod, String(describing: endpoint.method), file: file, line: line)
    }
}
