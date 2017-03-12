//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import XCTest
import Foundation
@testable import Vyrl

private enum Constants {
    static let accessToken = "access_token"
}

final class RequestDataProviderTest: XCTestCase {
    private var subject: RequestDataProvider!
    private var credentialsProvider: APICredentialsProviderMock!

    override func setUp() {
        super.setUp()
        credentialsProvider = APICredentialsProviderMock()
        subject = RequestDataProvider(credentialsProvider: credentialsProvider)
    }

    func test_headersForEndpoint_addsPlatformAndVersionHeader() {
        let endpoint = APIEndpointMock()

        let headers = subject.headers(for: endpoint)

        XCTAssertNotNil(headers[HTTPHeaderField.platform.description])
        XCTAssertNotNil(headers[HTTPHeaderField.version.description])
    }

    func test_headersForEndpoint_whenInfluencersEndpointRequiresAuthorizationAndTokenIsAvailable_addsAuthorizationHeader() {
        var endpoint = APIEndpointMock()
        endpoint.authorization = .user
        endpoint.api = .influencers

        credentialsProvider.userAccessToken = "token"
        
        let headers = subject.headers(for: endpoint)

        XCTAssertNotNil(headers[HTTPHeaderField.authorization.description])
    }

    func test_headersForEndpoint_whenInfluencersEndpointRequiresAuthorizationButTokenIsNotAvailable_doesntAddAuthorizationHeader() {
        var endpoint = APIEndpointMock()
        endpoint.api = .influencers
        endpoint.authorization = .user
        credentialsProvider.userAccessToken = nil

        let headers = subject.headers(for: endpoint)

        XCTAssertNil(headers[HTTPHeaderField.authorization.description])
    }

    func test_headersForEndpoint_whenInfluencersEndpointDoesntRequireAuthorization_doesntAddAuthorizationHeader() {
        var endpoint = APIEndpointMock()
        endpoint.api = .influencers
        credentialsProvider.userAccessToken = "token"

        let headers = subject.headers(for: endpoint)

        XCTAssertNil(headers[HTTPHeaderField.authorization.description])
    }

    func test_parametersForEndpoint_whenMainAPIEndpointRequiresAuthorizationAndTokenIsAvailable_addsAuthorizationHeader() {
        var endpoint = APIEndpointMock()
        endpoint.authorization = .user
        endpoint.api = .main
        credentialsProvider.userAccessToken = "token"

        let headers = subject.headers(for: endpoint)

        XCTAssertNotNil(headers[HTTPHeaderField.authorization.description])
    }

    func test_parametersForEndpoint_whenInfluencersEndpointRequiresAuthorizationButTokenIsNotAvailable_doesntAddAuthorizationHeader() {
        var endpoint = APIEndpointMock()
        endpoint.authorization = .user
        endpoint.api = .main
        credentialsProvider.userAccessToken = nil

        let headers = subject.headers(for: endpoint)

        XCTAssertNil(headers[HTTPHeaderField.authorization.description])
    }

    func test_parametersForEndpoint_whenInfluencersEndpointDoesntRequireAuthorization_doesntAddAuthorizationHeader() {
        var endpoint = APIEndpointMock()
        endpoint.api = .main
        credentialsProvider.userAccessToken = "token"

        let headers = subject.headers(for: endpoint)

        XCTAssertNil(headers[HTTPHeaderField.authorization.description])
    }
}
