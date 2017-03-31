//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

private enum Constants {
    static let failedToSentMessage = NSLocalizedString("messages.error.failedToSend", comment: "")
    static let failedToConfirmDelivery = NSLocalizedString("messages.error.failedToConfirmDelivery", comment: "")
}

protocol MessagesInteracting: TableViewUsing {
    weak var dataUpdateListener: DataLoadingEventsListening? { get set }
    weak var presenter: (MessageDisplaying & ErrorAlertPresenting)? { get set }
    weak var viewController: MessagesControlling? { get set }
    func viewWillAppear()
    func didTapMore()
    func didTapSend(message: String)
}

final class MessagesInteractor: MessagesInteracting {
    fileprivate weak var tableView: UITableView?
    fileprivate let dataSource: MessagesDataProviding
    weak var dataUpdateListener: DataLoadingEventsListening?
    weak var viewController: MessagesControlling?
    weak var presenter: (MessageDisplaying & ErrorAlertPresenting)?

    fileprivate let collab: Collab
    fileprivate let messageSender: MessageSending
    fileprivate let deliveryService: ConfirmingDelivery

    init(dataSource: MessagesDataProviding, collab: Collab,
         messageSender: MessageSending,
         deliveryService: ConfirmingDelivery) {
        self.dataSource = dataSource
        self.collab = collab
        self.messageSender = messageSender
        self.deliveryService = deliveryService
        dataSource.interactor = self
        dataSource.tableViewControllingDelegate = self
        dataSource.actionTarget = self
    }
    
    func viewWillAppear() {
        viewController?.setUpStatusView(withStatus: CollabStatus(orderStatus: collab.chatRoom.status))
        dataSource.loadTableData()
    }
    
    func didTapMore() {
        //TODO: Add reporting functionality. No story on Taiga yet ;-)
    }

    func didTapSend(message: String) {
        let trimmedMessage = message.trimmed
        guard trimmedMessage.characters.count > 0 else { return }
        let message = Message(text: trimmedMessage)
        messageSender.send(message: message,
                            toRoom: collab.chatRoomId) { [weak self] result in
                                result.on(success: { _ in
                                    self?.presenter?.clearMessage()
                                }, failure: { _ in
                                    self?.presenter?.presentError(title: nil, message: Constants.failedToSentMessage)
                                })
        }
    }
}

extension MessagesInteractor: TableViewUsing {
    func use(_ tableView: UITableView) {
        self.tableView = tableView
        dataSource.use(tableView)
    }
}

extension MessagesInteractor: DataRefreshing {
    func refreshData() {
        dataSource.loadTableData()
    }
}

extension MessagesInteractor: TableViewControlling {
    func updateTable(with result: DataFetchResult) {
        tableView?.reloadData()
    }
    
    func loadTableData() {
        dataSource.loadTableData()
    }
}

extension MessagesInteractor: DeliveryConfirming {
    func didTapConfirm() {
        deliveryService.confirmDelivery(forBrand: collab.chatRoom.brandId) { [weak self] result in
            guard let `self` = self else { return }
            result.on(success: { _ in
                self.loadTableData()
            }, failure: { error in
                self.presenter?.presentError(title: nil, message: Constants.failedToConfirmDelivery)
            })
        }
    }
}

extension MessagesInteractor: ContentAdding {
    func didTapAddContent() {
        //FIXME: Waiting for add content view controller
        print("DID TAP ADD CONTENT")
    }
}
