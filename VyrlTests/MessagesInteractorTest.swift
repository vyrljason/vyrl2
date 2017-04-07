//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import XCTest

final class DeliveryServiceMock: ConfirmingDelivery {
    var success = true
    var result = EmptyResponse()
    var error = ServiceError.unknown
    func confirmDelivery(forBrand brandId: String, completion: @escaping (Result<EmptyResponse, ServiceError>) -> Void) {
        if success {
            completion(.success(result))
        } else {
            completion(.failure(error))
        }
    }
}

final class MessagesPresenterMock: MessageDisplaying, ErrorAlertPresenting {
    var didCallClear = false
    var didCallPresentError = false

    func clearMessage() {
        didCallClear = true
    }

    func presentError(title: String?, message: String?) {
        didCallPresentError = true
    }
}

final class MessageSenderMock: TextMessageSending {
    var success = true
    var error = ServiceError.unknown
    var response = EmptyResponse()

    func send(message: Message, toRoom roomId: String, completion: @escaping (Result<EmptyResponse, ServiceError>) -> Void) {
        if success {
            completion(.success(response))
        } else {
            completion(.failure(error))
        }
    }
}

final class MessagesDataSourceMock: NSObject, MessagesDataProviding {
    var didUseTableView: Bool = false
    var didUseLoadTableData: Bool = false
    var didUseRegisterNibs: Bool = false
    var didCallunsubscribeToChatUpdates: Bool = false
    var didCallsubscribeToChatUpdates: Bool = false
    weak var tableView: UITableView?
    weak var reloadingDelegate: ReloadingData?
    weak var interactor: MessagesInteracting?
    weak var actionTarget: (ContentAdding & DeliveryConfirming & InstagramLinkAdding)?
    weak var statusViewUpdater: MessagesControlling?

    func use(_ tableView: UITableView) {
        didUseTableView = true
        self.tableView = tableView
        reloadingDelegate = tableView
    }

    func registerNibs(in tableView: UITableView) {
        didUseRegisterNibs = true
    }

    func unsubscribeToChatUpdates() {
        didCallunsubscribeToChatUpdates = true
    }

    func subscribeToChatUpdates() {
        didCallsubscribeToChatUpdates = true
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
}

final class MessagesInteractorTest: XCTestCase {
    
    var subject: MessagesInteractor!
    var tableView = TableViewMock()
    var dataSource: MessagesDataSourceMock!
    var messagePresenter: MessagesPresenterMock!
    var messageSender: MessageSenderMock!
    var collab: Collab!
    private var deliveryService: DeliveryServiceMock!
    private var influencerPostUpdater: InfluencerPostUpdaterMock!

    override func setUp() {
        dataSource = MessagesDataSourceMock()
        collab = VyrlFaker.faker.collab()
        messagePresenter = MessagesPresenterMock()
        messageSender = MessageSenderMock()
        deliveryService = DeliveryServiceMock()
        influencerPostUpdater = InfluencerPostUpdaterMock()
        subject = MessagesInteractor(dataSource: dataSource, collab: collab, messageSender: messageSender,
                                     deliveryService: deliveryService, influencerPostUpdater: influencerPostUpdater)
        subject.errorPresenter = messagePresenter
        subject.messageDisplayer = messagePresenter
    }
    
    func test_onViewWillAppear_loadsTableData() {
        subject.viewWillAppear()
        
        XCTAssertTrue(dataSource.didCallsubscribeToChatUpdates)
    }

    func test_viewWillDisappear_unsubscribeToChatUpdates() {
        subject.viewWillDisappear()

        XCTAssertTrue(dataSource.didCallunsubscribeToChatUpdates)
    }
    
    func test_use_forwardsUseToDataSource() {
        subject.use(tableView)
        
        XCTAssertTrue(dataSource.didUseTableView)
        XCTAssertTrue(dataSource.tableView === tableView)
    }

    func test_didTapSend_whenMessageIsEmpty_doesNothing() {
        let message = ""

        subject.didTapSend(message: message, addMessageStatus: .normal)

        XCTAssertFalse(messagePresenter.didCallClear)
        XCTAssertFalse(messagePresenter.didCallPresentError)
    }

    func test_didTapSend_whenServiceReturnsError_presentsError() {
        let message = "message"
        messageSender.success = false

        subject.didTapSend(message: message, addMessageStatus: .normal)

        XCTAssertTrue(messagePresenter.didCallPresentError)
    }

    func test_didTapSend_whenServiceReturnsSuccess_clearsMessage() {
        let message = "message"
        messageSender.success = true

        subject.didTapSend(message: message, addMessageStatus: .normal)

        XCTAssertTrue(messagePresenter.didCallClear)
    }

    func test_didTapSend_whenSendingInstagramLink_whenServiceReturnsSuccess_clearsMessage() {
        let link = "instagramLink"
        influencerPostUpdater.success = true

        subject.didTapSend(message: link, addMessageStatus: .instagramLink)

        XCTAssertTrue(messagePresenter.didCallClear)
    }

    func test_didTapSend_whenSendingInstagramLink_whenServiceReturnsFailure_presentsError() {
        let link = "instagramLink"
        influencerPostUpdater.success = false

        subject.didTapSend(message: link, addMessageStatus: .instagramLink)

        XCTAssertTrue(messagePresenter.didCallPresentError)
    }


    func test_didTapConfirm_whenServiceReturnsFailure_presentsError() {
        deliveryService.success = false

        subject.didTapConfirm()

        XCTAssertTrue(messagePresenter.didCallPresentError)
    }
}
