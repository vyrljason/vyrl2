//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import XCTest
import Foundation
import Alamofire
import Decodable
@testable import Vyrl

final class HTTPHeadersProviderMock: HTTPHeadersProviding {
    var headers: [String: String] = [:]

    func headersFor(endpoint: APIEndpoint) -> [String : String] {
        return headers
    }
}

final class APIResponseHandlerMock: APIResponseHandling {
    func handle<Model: Decodable, ResponseType: DataResponseProtocol>(response: ResponseType, completion: @escaping (Vyrl.Result<Model, APIResponseError>) -> Void) { }
}

final class HTTPClientTest: XCTestCase {

    private var subject: HTTPClient!
    private var manager: SessionManager!
    private var apiConfiguration: APIConfigurationMock!
    private var headersProvider: HTTPHeadersProviderMock!
    private var responseHandler: APIResponseHandlerMock!

    override func setUp() {
        super.setUp()
        manager = SessionManager()
        apiConfiguration = APIConfigurationMock()
        headersProvider = HTTPHeadersProviderMock()
        responseHandler = APIResponseHandlerMock()
        subject = HTTPClient(manager: manager, apiConfiguration: apiConfiguration, headersProvider: headersProvider, responseHandler: responseHandler)
    }
}
