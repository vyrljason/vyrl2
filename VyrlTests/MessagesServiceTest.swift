//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class MessagesServiceTest: XCTestCase {
    
    private var subject: MessagesService!
    private var chatDatabase: ChatDatabaseMock!

    override func setUp() {
        super.setUp()
        chatDatabase = ChatDatabaseMock()
        chatDatabase.child = ChatDatabaseMock()
        subject = MessagesService(chatDatabase: chatDatabase)
    }
    
    func test_getMessages_whenSuccess_returnsMessages() {
        let chatRoomId = "id"

        var wasCalled = false
        subject.getMessages(inChatRoom: chatRoomId) { result in
            wasCalled = true
            expectToBeSuccess(result)
        }
        XCTAssertTrue(wasCalled)
    }

    func test_getMessages_whenSuccess_stopsChangesObserving() {
        let chatRoomId = "id"

        var wasCalled = false
        subject.getMessages(inChatRoom: chatRoomId) { result in
            wasCalled = true
            XCTAssertTrue(self.chatDatabase.didCallRemoveObserver)
        }
        XCTAssertTrue(wasCalled)
    }
}
