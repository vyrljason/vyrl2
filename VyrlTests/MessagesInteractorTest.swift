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

final class MessageSenderMock: MessageSending {
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
    var usedTableArgument: UITableView?
    weak var tableViewControllingDelegate: TableViewControlling?
    weak var reloadingDelegate: ReloadingData?
    weak var interactor: MessagesInteracting?
    weak var actionTarget: (ContentAdding & DeliveryConfirming)?
    
    func use(_ tableView: UITableView) {
        didUseTableView = true
        usedTableArgument = tableView
    }
    
    func registerNibs(in tableView: UITableView) {
        didUseRegisterNibs = true
    }
    
    func loadTableData() {
        didUseLoadTableData = true
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
    
    override func setUp() {
        dataSource = MessagesDataSourceMock()
        collab = VyrlFaker.faker.collab()
        messagePresenter = MessagesPresenterMock()
        messageSender = MessageSenderMock()
        deliveryService = DeliveryServiceMock()
        subject = MessagesInteractor(dataSource: dataSource, collab: collab, messageSender: messageSender, deliveryService: deliveryService)
        subject.presenter = messagePresenter
    }
    
    func test_refreshData_reloadsDataSource() {
        subject.refreshData()
        
        XCTAssertTrue(dataSource.didUseLoadTableData)
    }
    
    func test_onViewWillAppear_loadsTableData() {
        subject.viewWillAppear()
        
        XCTAssertTrue(dataSource.didUseLoadTableData)
    }
    
    func test_use_forwardsUseToDataSource() {
        subject.use(tableView)
        
        XCTAssertTrue(dataSource.didUseTableView)
        XCTAssertTrue(dataSource.usedTableArgument === tableView)
    }
    
    func test_updateTable_reloadsTableViewInAllCases() {
        subject.use(tableView)
        let possibleResults = [DataFetchResult.someData, DataFetchResult.empty, DataFetchResult.error]
        
        for result in possibleResults {
            tableView.didCallReload = false
            dataSource.tableViewControllingDelegate?.updateTable(with: result)
            XCTAssertTrue(tableView.didCallReload)
        }
    }

    func test_didTapSend_whenMessageIsEmpty_doesNothing() {
        let message = ""

        subject.didTapSend(message: message)

        XCTAssertFalse(messagePresenter.didCallClear)
        XCTAssertFalse(messagePresenter.didCallPresentError)
    }

    func test_didTapSend_whenServiceReturnsError_presentsError() {
        let message = "message"
        messageSender.success = false

        subject.didTapSend(message: message)

        XCTAssertTrue(messagePresenter.didCallPresentError)
    }

    func test_didTapSend_whenServiceReturnsSuccess_clearsMessage() {
        let message = "message"
        messageSender.success = true

        subject.didTapSend(message: message)

        XCTAssertTrue(messagePresenter.didCallClear)
    }

    func test_didTapConfirm_whenServiceReturnsFailure_presentsError() {
        deliveryService.success = false

        subject.didTapConfirm()

        XCTAssertTrue(messagePresenter.didCallPresentError)
    }
}



