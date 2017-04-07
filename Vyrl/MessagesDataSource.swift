//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol MessagesDataProviding: UITableViewDataSource, UITableViewDelegate, TableViewUsing, TableViewHaving {
    weak var reloadingDelegate: ReloadingData? { get set }
    weak var actionTarget: (ContentAdding & DeliveryConfirming & InstagramLinkAdding)? { get set }
    weak var statusViewUpdater: MessagesControlling? { get set }
    func subscribeToChatUpdates()
    func unsubscribeToChatUpdates()
}

final class MessagesDataSource: NSObject, MessagesDataProviding {

    fileprivate enum Constants {
        static let numberOfSections: Int = 1
        static let messagesSection: Int = 0
        static let cellHeight: CGFloat = 100
        static let footerHeight: CGFloat = 60
        static let successFooterHeight: CGFloat = 176
        static let scrollingUpdateDelay: TimeInterval = 0.4
    }

    fileprivate let messagesCellFactory: MessagesCellMaking
    fileprivate var items = [MessageContainer]()
    fileprivate let collab: Collab

    fileprivate var collaborationStatus: CollabStatus {
        didSet {
            updateView(for: collaborationStatus)
        }
    }

    fileprivate let chatRoomUpdater: ChatRoomUpdatesInforming
    fileprivate let collabStatusUpdater: CollabStatusUpdatesInforming
    fileprivate let chatPresenceService: ChatPresenceInforming

    weak var tableView: UITableView?
    weak var reloadingDelegate: ReloadingData?
    weak var actionTarget: (ContentAdding & DeliveryConfirming & InstagramLinkAdding)?
    weak var statusViewUpdater: MessagesControlling?

    // swiftlint:disable function_parameter_count
    init(collab: Collab,
         chatRoomUpdater: ChatRoomUpdatesInforming,
         collabStatusUpdater: CollabStatusUpdatesInforming,
         chatPresenceService: ChatPresenceInforming,
         messagesCellFactory: MessagesCellMaking = MessagesCellFactory()) {
        self.collab = collab
        self.collaborationStatus = collab.chatRoom.collabStatus
        self.chatRoomUpdater = chatRoomUpdater
        self.collabStatusUpdater = collabStatusUpdater
        self.chatPresenceService = chatPresenceService
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
        InfluencerMediaMessageCell.register(to: tableView)
        BrandMessageCell.register(to: tableView)
        SystemMessageCell.register(to: tableView)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = Constants.cellHeight
        updateFooter()
    }

    fileprivate func properFooterView(for tableView: UITableView) -> UIView {
        switch collaborationStatus {
        case .productDelivery:
            let contentView = createFooterContent(.confirmDelivery)
            return footerView(containing: contentView, tableView: tableView)
        case .contentReview, .contentReviewDeclined:
            let contentView = createFooterContent(.addContent)
            return footerView(containing: contentView, tableView: tableView)
        case .publication:
            let contentView = createFooterContent(.instagramLink)
            return footerView(containing: contentView, tableView: tableView)
        case .done:
            let contentView = createSuccessFooterContent()
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
    
    fileprivate func createSuccessFooterContent() -> SuccessMessagesFooterView {
        let contentView = SuccessMessagesFooterView.fromNib()
        return contentView
    }

    fileprivate func footerView(containing view: UIView, tableView: UITableView) -> UIView {
        let properFooterHeight = collaborationStatus == .done ? Constants.successFooterHeight : Constants.footerHeight
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: properFooterHeight))
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

    func subscribeToChatUpdates() {
        items.removeAll()
        reloadingDelegate?.reloadData()
        startListeningToNewMessages()
        startListeningToStatusUpdates()
        chatPresenceService.userDidEnter(chatRoom: collab.chatRoomId)
    }

    func unsubscribeToChatUpdates() {
        chatRoomUpdater.stopListening(inRoom: collab.chatRoomId)
        collabStatusUpdater.stopListening(inRoom: collab.chatRoomId)
        chatPresenceService.userWillLeave(chatRoom: collab.chatRoomId)
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
        collabStatusUpdater.listenToStatusUpdates(inRoom: collab.chatRoomId) { [weak self] (updatedCollabStatus) in
            guard let `self` = self else { return }
            self.collaborationStatus = updatedCollabStatus
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
