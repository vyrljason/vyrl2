//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class ChatPresenceServiceTest: XCTestCase {

    private var subject: ChatPresenceService!
    private var chatDatabase: ChatDatabaseMock!
    private var credentialsStorage: ChatCredentialsStorageMock!
    private var chatRoomId: String!

    override func setUp() {
        super.setUp()
        chatRoomId = "room.217"
        chatDatabase = ChatDatabaseMock()
        chatDatabase.child = ChatDatabaseMock()
        credentialsStorage = ChatCredentialsStorageMock()
        subject = ChatPresenceService(chatDatabase: chatDatabase, chatCredentialsStorage: credentialsStorage)
    }

    func test_userDidEnter_withoutUserCredentials_doesntCallDatabase() {
        subject.userDidEnter(chatRoom: chatRoomId)

        XCTAssertNil(chatDatabase.child.lastCalledValue)
    }

    func test_userDidEnter_withUserCredentials_SetsUnreadMessagesToZero() {
        credentialsStorage.internalUserId = "Jack"

        subject.userDidEnter(chatRoom: chatRoomId)

        XCTAssertEqual(chatDatabase.child.lastCalledValue as? Int ?? 1, 0)
    }

    func test_userWillLeave_withoutUserCredentials_doesntCallDatabase() {
        subject.userWillLeave(chatRoom: chatRoomId)

        XCTAssertNil(chatDatabase.child.lastCalledValue)
    }

    func test_userWillLeave_withUserCredentials_SetsUnreadMessagesToZero() {
        credentialsStorage.internalUserId = "Jack"

        subject.userWillLeave(chatRoom: chatRoomId)

        XCTAssertEqual(chatDatabase.child.lastCalledValue as? Int ?? 1, 0)
    }
}
