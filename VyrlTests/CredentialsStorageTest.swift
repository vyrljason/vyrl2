//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class CredentialsStorageTest: XCTestCase {

    private let accessToken = "accessToken"
    private var subject: CredentialsStorage!
    private var keychain: KeychainMock!

    override func setUp() {
        super.setUp()
        keychain = KeychainMock()
        subject = CredentialsStorage(keychain: keychain)
    }

    func test_setSubscriptAccessToken_SetsAccessToken() {
        subject.accessToken = accessToken

        XCTAssertEqual(accessToken, subject.accessToken)
    }

    func test_save_setsAccessToken() {
        let token = "token"
        let userProfile = VyrlFaker.faker.userProfile(token: token)

        subject.saveToken(using: userProfile)

        XCTAssertEqual(subject.accessToken, token)
    }
}
