//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import XCTest
import Foundation
@testable import Vyrl

final class HTTPHeadersProviderTest: XCTestCase {
    private var subject: HTTPHeadersProvider!
    private var credentialsProvider: APICredentialsProviderMock!

    override func setUp() {
        super.setUp()
        credentialsProvider = APICredentialsProviderMock()
        subject = HTTPHeadersProvider(credentialsProvider: credentialsProvider)
    }

    func test_headersForEndpoint_addsPlatformAndVersionHeader() {
        let endpoint = APIEndpointMock()

        let headers = subject.headersFor(endpoint: endpoint)

        XCTAssertNotNil(headers[HTTPHeaderField.Platform.description])
        XCTAssertNotNil(headers[HTTPHeaderField.Version.description])
    }

    func test_headersForEndpoint_whenEndpointRequiresAuthorizationAndTokenIsAvailable_addsAuthorizationHeader() {
        var endpoint = APIEndpointMock()
        endpoint.authorization = .user
        credentialsProvider.userAccessToken = "token"
        
        let headers = subject.headersFor(endpoint: endpoint)

        XCTAssertNotNil(headers[HTTPHeaderField.Authorization.description])
    }

    func test_headersForEndpoint_whenEndpointRequiresAuthorizationButTokenIsNotAvailable_doesntAddAuthorizationHeader() {
        var endpoint = APIEndpointMock()
        endpoint.authorization = .user
        credentialsProvider.userAccessToken = nil

        let headers = subject.headersFor(endpoint: endpoint)

        XCTAssertNil(headers[HTTPHeaderField.Authorization.description])
    }

    func test_headersForEndpoint_whenEndpointDoesntRequiresAuthorization_doesntAddAuthorizationHeader() {
        let endpoint = APIEndpointMock()
        credentialsProvider.userAccessToken = "token"

        let headers = subject.headersFor(endpoint: endpoint)

        XCTAssertNil(headers[HTTPHeaderField.Authorization.description])
    }
}
