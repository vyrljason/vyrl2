//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

private enum Constants {
    static let failedToSentMessage = NSLocalizedString("messages.error.failedToSend", comment: "")
}

protocol MessagesInteracting: TableViewUsing {
    weak var dataUpdateListener: DataLoadingEventsListening? { get set }
    weak var presenter: (MessageDisplaying & ErrorAlertPresenting)? { get set }
    func viewWillAppear()
    func didTapMore()
    func didTapSend(message: String)
    func use(_ viewController: MessagesViewController)
}

final class MessagesInteractor: MessagesInteracting {
    fileprivate weak var tableView: UITableView?
    fileprivate weak var viewController: MessagesViewController?
    let dataSource: MessagesDataProviding
    weak var dataUpdateListener: DataLoadingEventsListening?
    weak var presenter: (MessageDisplaying & ErrorAlertPresenting)?

    private let collab: Collab
    private let messageSender: MessageSending
    
    init(dataSource: MessagesDataProviding, collab: Collab,
         messageSender: MessageSending) {
        self.dataSource = dataSource
        self.collab = collab
        self.messageSender = messageSender
        dataSource.interactor = self
        dataSource.tableViewControllingDelegate = self
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
                                }, failure: { error in
                                    self?.presenter?.presentError(title: nil, message: Constants.failedToSentMessage)
                                })
        }
    }
    
    func use(_ viewController: MessagesViewController) {
        self.viewController = viewController
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
