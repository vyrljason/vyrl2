//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol MessagesDataAccessing: class {
    weak var interactor: MessagesInteracting? { get set }
}

protocol MessagesDataProviding: TableViewUsing, TableViewDataProviding, MessagesDataAccessing {
    weak var reloadingDelegate: ReloadingData? { get set }
}

final class MessagesDataSource: NSObject, MessagesDataProviding {

    fileprivate enum Constants {
        static let numberOfSections: Int = 1
        static let cellHeight: CGFloat = 100
    }

    fileprivate let service: MessagesProviding
    fileprivate let collab: Collab
    fileprivate var items = [MessageContainer]()

    weak var reloadingDelegate: ReloadingData?
    weak var tableViewControllingDelegate: TableViewControlling?
    weak var interactor: MessagesInteracting?

    init(service: MessagesProviding, collab: Collab) {
        self.service = service
        self.collab = collab
        super.init()
    }
}

extension MessagesDataSource: TableViewUsing {
    func use(_ tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
        InfluencerMessageCell.register(to: tableView)
        BrandMessageCell.register(to: tableView)
        SystemMessageCell.register(to: tableView)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = Constants.cellHeight
        tableView.tableFooterView = UIView()
    }
}

extension MessagesDataSource: TableViewDataProviding {
    func loadTableData() {
        service.getMessages(inChatRoom: collab.chatRoomId) { [weak self] result in
            guard let `self` = self else { return }
            self.items = result.map(success: {
                $0.sorted(by: { $0.createdAt < $1.createdAt })},
                                    failure: { _ in return [] })
            DispatchQueue.onMainThread { [weak self] in
                self?.tableViewControllingDelegate?.updateTable(with: result.map(success: { $0 .isEmpty ? .empty : .someData },
                                                                                 failure: { _ in .error }))
            }
        }
    }

    fileprivate func prepare(cell: InfluencerMessageCell, messageItem: MessageContainer) {
        let renderable = MessageCellRenderable(text: messageItem.message.text)
        cell.render(renderable)
        guard let avatarUrl = messageItem.sender.avatar else { return }
        cell.set(imageFetcher: ImageFetcher(url: avatarUrl))
    }

    fileprivate func prepare(cell: BrandMessageCell, messageItem: MessageContainer) {
        let renderable = MessageCellRenderable(text: messageItem.message.text)
        cell.render(renderable)
        guard let avatarUrl = messageItem.sender.avatar else { return }
        cell.set(imageFetcher: ImageFetcher(url: avatarUrl))
    }

    fileprivate func prepare(cell: SystemMessageCell, messageItem: MessageContainer) {
        let renderable = MessageCellRenderable(text: messageItem.message.text)
        cell.render(renderable)
    }

    fileprivate func cellForBrand(messageItem: MessageContainer, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell: BrandMessageCell = tableView.dequeueCell(at: indexPath)
        prepare(cell: cell, messageItem: items[indexPath.row])
        return cell
    }

    fileprivate func cellForInfluencer(messageItem: MessageContainer, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell: InfluencerMessageCell = tableView.dequeueCell(at: indexPath)
        prepare(cell: cell, messageItem: items[indexPath.row])
        return cell
    }

    fileprivate func cellForSystem(messageItem: MessageContainer, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell: SystemMessageCell = tableView.dequeueCell(at: indexPath)
        prepare(cell: cell, messageItem: items[indexPath.row])
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return Constants.numberOfSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch items[indexPath.row].messageType(in: collab) {
        case .system:
            return cellForSystem(messageItem: items[indexPath.row], tableView: tableView, indexPath: indexPath)
        case .influencer:
            return cellForInfluencer(messageItem: items[indexPath.row], tableView: tableView, indexPath: indexPath)
        case .brand:
            return cellForBrand(messageItem: items[indexPath.row], tableView: tableView, indexPath: indexPath)
        }
    }
}
