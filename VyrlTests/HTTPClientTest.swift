//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import XCTest
import Foundation
import Alamofire
import Decodable
@testable import Vyrl

final class APIConfigurationMock: APIConfigurationHaving {
    var baseURL = URL(string: "https://www.apple.com")!
    var mode: ConfigurationMode = .staging
}

final class APICredentialsProviderMock: APICredentialsProviding {
    var userAccessToken: String?
}

final class APIResponseHandlerMock: APIResponseHandling {
    func handle<Model: Decodable>(response: DataResponseProtocol, completion: @escaping (Vyrl.Result<Model, APIResponseError>) -> Void) { }
}

private struct APIEndpointMock: APIEndpoint {
    var path: String = "path"
    var authorization: AuthorizationType = .none
    var method: Vyrl.HTTPMethod = .get
    var modelClass: Decodable.Type? = MockUser.self
    var parameters: [String: Any]?
}

final class HTTPClientTest: XCTestCase {

    private var subject: HTTPClient!
    private var manager: SessionManager!
    private var apiConfiguration: APIConfigurationMock!
    private var credentialsProvider: APICredentialsProviderMock!
    private var responseHandler: APIResponseHandlerMock!

    override func setUp() {
        super.setUp()
        manager = SessionManager()
        apiConfiguration = APIConfigurationMock()
        credentialsProvider = APICredentialsProviderMock()
        responseHandler = APIResponseHandlerMock()
        subject = HTTPClient(manager: manager, apiConfiguration: apiConfiguration, credentialsProvider: credentialsProvider, responseHandler: responseHandler)
    }

    func test_call_withAPIEndpoint_callsResponseHandlerWithProperData() {
        let endpoint = APIEndpointMock()

        subject.call(endpoint: endpoint) { (result) in }

        XCTAssertEqual(endpoint.path)
    }
}
