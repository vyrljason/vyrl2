//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class ChatCredentialsStorageTest: XCTestCase {

    private let chatToken = "chatToken"
    private let internalUserId = "internalUserId"

    private var subject: ChatCredentialsStorage!
    private var keychain: KeychainMock!

    override func setUp() {
        super.setUp()
        keychain = KeychainMock()
        subject = ChatCredentialsStorage(keychain: keychain)
    }

    func test_setSubscriptChatToken_SetsChatToken() {
        subject.chatToken = chatToken

        XCTAssertEqual(chatToken, subject.chatToken)
    }

    func test_setSubscriptInternalUserId_SetsInternalUserId() {
        subject.internalUserId = internalUserId

        XCTAssertEqual(internalUserId, subject.internalUserId)
    }

    func test_clear_deletesChatTokenAndUserId() {
        subject.chatToken = chatToken
        subject.internalUserId = internalUserId

        subject.clear()

        XCTAssertNil(subject.chatToken)
        XCTAssertNil(subject.internalUserId)
    }
}
