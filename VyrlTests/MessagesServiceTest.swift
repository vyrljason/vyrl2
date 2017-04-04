//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest
import Firebase

final class SnapshotToMessagesConverterMock: SnapshotToMessagesConverting {
    var messages = [MessageContainer]()

    func convert(snapshot: FIRDataSnapshot) -> [MessageContainer] {
        return messages
    }
}

final class MessagesServiceTest: XCTestCase {
    
    private var subject: MessagesService!
    private var chatDatabase: ChatDatabaseMock!
    private var dataConverter: SnapshotToMessagesConverterMock!
    private var chatRoomId: String!

    override func setUp() {
        super.setUp()
        chatRoomId = "room.217"
        chatDatabase = ChatDatabaseMock()
        chatDatabase.child = ChatDatabaseMock()
        dataConverter = SnapshotToMessagesConverterMock()
        subject = MessagesService(chatDatabase: chatDatabase, dataConverter: dataConverter)
    }

    func test_getMessages_triggersSingleObservation() {
        subject.getMessages(inChatRoom: chatRoomId) { _ in }

        XCTAssertTrue(chatDatabase.child.didCallObservedSingleEvent)
    }

    func test_getMessages_returnsDataFromDataConverter() {
        var wasCalled = false

        subject.getMessages(inChatRoom: chatRoomId) { messages in
            wasCalled = true
            XCTAssertEqual(self.dataConverter.messages, messages)
        }

        XCTAssertTrue(wasCalled)
    }
}
