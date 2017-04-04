//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol MessagesCellMaking {
    func makeCell(ofType messageType: MessageType, using messageItem: MessageContainer,
                  in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell
}

final class MessagesCellFactory: MessagesCellMaking {
    func makeCell(ofType messageType: MessageType, using messageItem: MessageContainer,
                  in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        switch messageType {
        case .system:
            return systemMessageCell(tableView: tableView, indexPath: indexPath, messageItem: messageItem)
        case .influencer:
            return influencerMessageCell(tableView: tableView, indexPath: indexPath, messageItem: messageItem)
        case .influencerMedia:
            return influencerMediaMessageCell(tableView: tableView, indexPath: indexPath, messageItem: messageItem)
        case .brand:
            return brandMessageCell(tableView: tableView, indexPath: indexPath, messageItem: messageItem)
        }
    }

    private func brandMessageCell(tableView: UITableView, indexPath: IndexPath, messageItem: MessageContainer) -> BrandMessageCell {
        let cell: BrandMessageCell = tableView.dequeueCell(at: indexPath)
        prepare(cell: cell, messageItem: messageItem)
        guard let imageUrl = messageItem.sender.avatar else { return cell }
        cell.set(imageFetcher: ImageFetcher(url: imageUrl))
        return cell
    }

    private func influencerMessageCell(tableView: UITableView, indexPath: IndexPath, messageItem: MessageContainer) -> InfluencerMessageCell {
        let cell: InfluencerMessageCell = tableView.dequeueCell(at: indexPath)
        prepare(cell: cell, messageItem: messageItem)
        guard let imageUrl = messageItem.sender.avatar else { return cell }
        cell.set(imageFetcher: ImageFetcher(url: imageUrl))
        return cell
    }

    private func influencerMediaMessageCell(tableView: UITableView, indexPath: IndexPath, messageItem: MessageContainer) -> InfluencerMediaMessageCell {
        let cell: InfluencerMediaMessageCell = tableView.dequeueCell(at: indexPath)
        prepare(cell: cell, messageItem: messageItem)
        guard let imageUrl = messageItem.message.mediaURL else { return cell }
        cell.set(imageFetcher: ImageFetcher(url: imageUrl))
        return cell
    }

    private func systemMessageCell(tableView: UITableView, indexPath: IndexPath, messageItem: MessageContainer) -> SystemMessageCell {
        let cell: SystemMessageCell = tableView.dequeueCell(at: indexPath)
        prepare(cell: cell, messageItem: messageItem)
        return cell
    }

    private func prepare(cell: MessageCellRendering, messageItem: MessageContainer) {
        let renderable = MessageCellRenderable(text: messageItem.message.text)
        cell.render(renderable)
    }
}
