//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import XCTest
import Foundation
import Alamofire
import Decodable
@testable import Vyrl

final class RequestDataProviderMock: RequestDataProviding {
    var headers: [String: String] = [:]
    var parmeters: [String: Any]? = [:]

    func headers(for endpoint: APIEndpoint) -> [String : String] {
        return headers
    }

    func parameters(for endpoint: APIEndpoint) -> [String : Any]? {
        return parmeters
    }
}

final class APIResponseHandlerMock: APIResponseHandling {
    func handle<Model: Decodable, ResponseType: DataResponseProtocol>(response: ResponseType, completion: @escaping (Vyrl.Result<Model, APIResponseError>) -> Void) { }
}

final class HTTPClientTest: XCTestCase {

    private var subject: HTTPClient!
    private var manager: SessionManager!
    private var apiConfiguration: APIConfigurationMock!
    private var requestDataProvider: RequestDataProviderMock!
    private var responseHandler: APIResponseHandlerMock!

    override func setUp() {
        super.setUp()
        manager = SessionManager()
        apiConfiguration = APIConfigurationMock()
        requestDataProvider = RequestDataProviderMock()
        responseHandler = APIResponseHandlerMock()
        subject = HTTPClient(manager: manager, apiConfiguration: apiConfiguration, requestDataProvider: requestDataProvider, responseHandler: responseHandler)
    }
}
