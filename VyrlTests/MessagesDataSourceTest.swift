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

final class OrderStatusUpdaterMock: OrderStatusUpdatesInforming {

    var didCallStopListening = false
    var didCallStartListening = false

    func listenToOrderStatusUpdates(inRoom roomId: String, completion: @escaping (OrderStatus) -> Void) {
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

final class MessagesDataSourceTests: XCTestCase {

    var subject: MessagesDataSource!
    var service: MessagesServiceMock!
    var tableView: TableViewMock!
    private var chatRoomUpdater: ChatRoomUpdaterMock!
    private var orderStatusUpdater: OrderStatusUpdaterMock!
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
        orderStatusUpdater = OrderStatusUpdaterMock()
        chatPresenceService = ChatPresenceServiceMock()
        subject = MessagesDataSource(collab: collab, status: status,
                                     chatRoomUpdater: chatRoomUpdater,
                                     orderStatusUpdater: orderStatusUpdater,
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
        XCTAssertTrue(orderStatusUpdater.didCallStartListening)
        XCTAssertEqual(chatPresenceService.enteredRoom, collab.chatRoomId)
    }

    func test_unsubscribeToChatUpdates_asksChatUpdaterToStopUpdates() {

        subject.unsubscribeToChatUpdates()

        XCTAssertTrue(chatRoomUpdater.didCallStopListening)
        XCTAssertTrue(orderStatusUpdater.didCallStopListening)
        XCTAssertEqual(chatPresenceService.leftRoom, collab.chatRoomId)
    }
}
