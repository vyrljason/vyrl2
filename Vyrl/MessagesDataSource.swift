//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol MessagesDataProviding: UITableViewDataSource, UITableViewDelegate, TableViewUsing, TableViewHaving {
    weak var reloadingDelegate: ReloadingData? { get set }
    weak var actionTarget: (ContentAdding & DeliveryConfirming)? { get set }
    weak var statusViewUpdater: MessagesControlling? { get set }
    func startListeningToUpdates()
    func stopDataUpdates()
}

final class MessagesDataSource: NSObject, MessagesDataProviding {

    fileprivate enum Constants {
        static let numberOfSections: Int = 1
        static let messagesSection: Int = 0
        static let cellHeight: CGFloat = 100
        static let footerHeight: CGFloat = 60
        static let scrollingUpdateDelay: TimeInterval = 0.4
    }

    fileprivate let collab: Collab
    fileprivate var status: CollabStatus {
        didSet {
            updateView(for: status)
        }
    }
    fileprivate let chatRoomUpdater: ChatRoomUpdatesInforming
    fileprivate let orderStatusUpdater: OrderStatusUpdatesInforming
    fileprivate var items = [MessageContainer]()
    fileprivate let messagesCellFactory: MessagesCellMaking

    weak var tableView: UITableView?
    weak var reloadingDelegate: ReloadingData?
    weak var actionTarget: (ContentAdding & DeliveryConfirming)?
    weak var statusViewUpdater: MessagesControlling?

    init(collab: Collab,
         status: CollabStatus,
         chatRoomUpdater: ChatRoomUpdatesInforming,
         orderStatusUpdater: OrderStatusUpdatesInforming,
         messagesCellFactory: MessagesCellMaking = MessagesCellFactory()) {
        self.collab = collab
        self.status = status
        self.chatRoomUpdater = chatRoomUpdater
        self.orderStatusUpdater = orderStatusUpdater
        self.messagesCellFactory = messagesCellFactory
        super.init()
    }
}

extension MessagesDataSource: TableViewUsing {
    func use(_ tableView: UITableView) {
        self.tableView = tableView
        tableView.delegate = self
        tableView.dataSource = self
        InfluencerMessageCell.register(to: tableView)
        BrandMessageCell.register(to: tableView)
        SystemMessageCell.register(to: tableView)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = Constants.cellHeight
        updateFooter()
    }

    fileprivate func properFooterView(for tableView: UITableView) -> UIView {
        switch status {
        case .productDelivery:
            let contentView = createFooterContent(.confirmDelivery)
            return footerView(containing: contentView, tableView: tableView)
        case .contentReview:
            let contentView = createFooterContent(.addContent)
            return footerView(containing: contentView, tableView: tableView)
        default:
            return UIView()
        }
    }

    fileprivate func createFooterContent(_ type: MessagesFooterType) -> MessagesFooterView {
        let contentView = MessagesFooterView.fromNib()
        let contentViewRenderable = MessagesFooterRenderable(footerType: type)
        contentView.render(renderable: contentViewRenderable)
        contentView.delegate = actionTarget
        return contentView
    }

    fileprivate func footerView(containing view: UIView, tableView: UITableView) -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: Constants.footerHeight))
        footerView.addSubview(view)
        view.pinToEdges(of: footerView)
        return footerView
    }

    fileprivate func updateFooter() {
        guard let tableView = tableView else { return }
        tableView.tableFooterView = properFooterView(for: tableView)
    }
}

extension MessagesDataSource {

    func stopDataUpdates() {
        chatRoomUpdater.stopListening(inRoom: collab.chatRoomId)
        orderStatusUpdater.stopListening(inRoom: collab.chatRoomId)
    }

    func startListeningToUpdates() {
        self.items.removeAll()
        reloadingDelegate?.reloadData()
        startListeningToNewMessages()
        startListeningToStatusUpdates()
    }

    private func startListeningToNewMessages() {
        chatRoomUpdater.listenToNewMessages(inRoom: collab.chatRoomId) { [weak self] newMessages in
            guard let `self` = self else { return }
            DispatchQueue.onMainThread { [weak self] in
                guard let `self` = self else { return }
                self.appendNew(messages: newMessages)
                self.animateToLastMessage()
            }
        }
    }

    private func animateToLastMessage() {
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.scrollingUpdateDelay) { [weak self] in
            guard let `self` = self else { return }
            self.tableView?.scrollToRow(at: self.lastElementIndexPath, at: .top, animated: true)
        }
    }

    private func startListeningToStatusUpdates() {
        orderStatusUpdater.listenToOrderStatusUpdates(inRoom: collab.chatRoomId) { [weak self] chatRoom in
            self?.status = CollabStatus(orderStatus: chatRoom.status)
        }
    }

    private func appendNew(messages: [MessageContainer]) {
        guard messages.count > 0 else { return }
        let sortedMessages = messages.sorted(by: { $0.createdAt < $1.createdAt })
        let newItemsIndexes: [IndexPath] = (0..<sortedMessages.count).map { IndexPath(row: items.count + $0, section: Constants.messagesSection) }
        tableView?.beginUpdates()
        items.append(contentsOf: sortedMessages)
        tableView?.insertRows(at: newItemsIndexes, with: .fade)
        tableView?.endUpdates()
    }

    func updateView(for status: CollabStatus) {
        statusViewUpdater?.setUpStatusView(withStatus: status)
        updateFooter()
    }

    private var lastElementIndexPath: IndexPath {
        return IndexPath(row: max(0, items.count - 1), section: Constants.messagesSection)
    }
}

extension MessagesDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Constants.numberOfSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let relatedMessageItem = items[indexPath.row]
        return messagesCellFactory.makeCell(ofType: relatedMessageItem.messageType(in: collab), using: relatedMessageItem, in: tableView, for: indexPath)
    }
}
