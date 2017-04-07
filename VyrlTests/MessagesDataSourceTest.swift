//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import XCTest
@testable import Vyrl

final class MessagesServiceMock: MessagesProviding {
    var mockedMessages: [MessageContainer] = [VyrlFaker.faker.messageContainer()]

    func getMessages(inChatRoom chatRoomId: String, completion: @escaping ([MessageContainer]) -> Void) {
        completion(mockedMessages)
    }
}

final class ChatRoomUpdaterMock: ChatRoomUpdatesInforming {

    var didCallStopListening = false
    var didCallStartListening = false

    func listenToNewMessages(inRoom roomId: String, completion: @escaping ([MessageContainer]) -> Void) {
        didCallStartListening = true
    }

    func stopListening(inRoom roomId: String) {
        didCallStopListening = true
    }
}

final class CollabStatusUpdaterMock: CollabStatusUpdatesInforming {

    var didCallStopListening = false
    var didCallStartListening = false

    func listenToStatusUpdates(inRoom roomId: String, completion: @escaping (CollabStatus) -> Void) {
        didCallStartListening = true
    }

    func stopListening(inRoom roomId: String) {
        didCallStopListening = true
    }
}

final class ChatPresenceServiceMock: ChatPresenceInforming {

    var leftRoom: String?
    var enteredRoom: String?

    func userDidEnter(chatRoom roomId: String) {
        enteredRoom = roomId
    }

    func userWillLeave(chatRoom roomId: String) {
        leftRoom = roomId
    }
}

final class InfluencerPostUpdaterMock: UpdatePostWithInstagram {
    var success: Bool = true
    var error = ServiceError.unknown
    var result = EmptyResponse()

    func update(brandId: String, withInstagram instagramUrl: String, completion: @escaping (Result<EmptyResponse, ServiceError>) -> Void) {
        if success {
            completion(.success(result))
        } else {
            completion(.failure(error))
        }
    }
}

final class MessagesDataSourceTests: XCTestCase {

    var subject: MessagesDataSource!
    var service: MessagesServiceMock!
    var tableView: TableViewMock!
    private var chatRoomUpdater: ChatRoomUpdaterMock!
    private var collabStatusUpdater: CollabStatusUpdaterMock!
    private var chatPresenceService: ChatPresenceServiceMock!
    var collab: Collab!
    var status: CollabStatus!

    override func setUp() {
        super.setUp()
        service = MessagesServiceMock()
        tableView = TableViewMock()
        collab = VyrlFaker.faker.collab()
        status = CollabStatus.brief
        chatRoomUpdater = ChatRoomUpdaterMock()
        collabStatusUpdater = CollabStatusUpdaterMock()
        chatPresenceService = ChatPresenceServiceMock()
        subject = MessagesDataSource(collab: collab,
                                     chatRoomUpdater: chatRoomUpdater,
                                     collabStatusUpdater: collabStatusUpdater,
                                     chatPresenceService: chatPresenceService)
    }

    func test_registerNibs_didRegisterNib() {
        subject.use(tableView)

        XCTAssertTrue(tableView.didRegisterNib)
    }

    func test_use_setsDelegateAndDataSource_onTableView() {
        subject.use(tableView)

        XCTAssertTrue(tableView.didSetDataSource)
        XCTAssertTrue(tableView.dataSource === subject)
        XCTAssertTrue(tableView.didSetDelegation)
        XCTAssertTrue(tableView.delegate === subject)
    }

    func test_subscribeToChatUpdates_asksChatUpdaterAndOrderStatusUpdaterForUpdates() {

        subject.subscribeToChatUpdates()

        XCTAssertTrue(chatRoomUpdater.didCallStartListening)
        XCTAssertTrue(collabStatusUpdater.didCallStartListening)
        XCTAssertEqual(chatPresenceService.enteredRoom, collab.chatRoomId)
    }

    func test_unsubscribeToChatUpdates_asksChatUpdaterToStopUpdates() {

        subject.unsubscribeToChatUpdates()

        XCTAssertTrue(chatRoomUpdater.didCallStopListening)
        XCTAssertTrue(collabStatusUpdater.didCallStopListening)
        XCTAssertEqual(chatPresenceService.leftRoom, collab.chatRoomId)
    }
}
