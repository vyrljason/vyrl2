//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol MessagesDataProviding: TableViewUsing, TableViewDataProviding, TableViewHaving {
    weak var reloadingDelegate: ReloadingData? { get set }
    weak var actionTarget: (ContentAdding & DeliveryConfirming)? { get set }
    func stopDataUpdates()
}

final class MessagesDataSource: NSObject, MessagesDataProviding {

    fileprivate enum Constants {
        static let numberOfSections: Int = 1
        static let messagesSection: Int = 0
        static let cellHeight: CGFloat = 100
        static let footerHeight: CGFloat = 60
    }

    fileprivate let collab: Collab
    fileprivate let chatRoomUpdater: ChatRoomUpdatesInforming
    fileprivate var items = [MessageContainer]()
    fileprivate let messagesCellFactory: MessagesCellMaking

    weak var tableView: UITableView?
    weak var reloadingDelegate: ReloadingData?
    weak var actionTarget: (ContentAdding & DeliveryConfirming)?

    init(collab: Collab,
         chatRoomUpdater: ChatRoomUpdatesInforming,
         messagesCellFactory: MessagesCellMaking = MessagesCellFactory()) {
        self.collab = collab
        self.chatRoomUpdater = chatRoomUpdater
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
        switch CollabStatus(orderStatus: collab.chatRoom.status) {
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

extension MessagesDataSource: TableViewDataProviding {
    func loadTableData() {
        self.items.removeAll()
        reloadingDelegate?.reloadData()
        chatRoomUpdater.listenToNewMessages(inRoom: collab.chatRoomId) { [weak self] newMessages in
            guard let `self` = self else { return }
            DispatchQueue.onMainThread { [weak self] in
                guard let `self` = self else { return }
                self.appendNew(messages: newMessages)
                self.updateTable(with: self.items.isEmpty ? .empty : .someData)
            }
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

    func stopDataUpdates() {
        chatRoomUpdater.stopListening(inRoom: collab.chatRoomId)
    }

    func updateTable(with result: DataFetchResult) {
        updateFooter()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
            guard let `self` = self else { return }
            self.tableView?.scrollToRow(at: self.lastElementIndexPath, at: .top, animated: true)
        }
    }

    private var lastElementIndexPath: IndexPath {
        return IndexPath(row: max(0, items.count - 1), section: Constants.messagesSection)
    }

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
