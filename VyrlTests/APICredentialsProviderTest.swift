//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class CredentialStorageMock: CredentialsStoring {
    var accessToken: String?
}

final class APICredentialsProviderTest: XCTestCase {

    private let accessToken = "accessToken"
    private var subject: APICredentialsProvider!
    private var storage: CredentialStorageMock!

    override func setUp() {
        storage = CredentialStorageMock()
        subject = APICredentialsProvider(storage: storage)
    }

    func test_accessToken_whenThereIsToken_returnAccessToken() {
        storage.accessToken = accessToken

        XCTAssertEqual(subject.userAccessToken, accessToken)
    }

    func test_serverAccessToken_whenTokenIsCleared_returnsNil() {
        storage.accessToken = accessToken

        subject.clear()

        XCTAssertNil(subject.userAccessToken)
    }
}
