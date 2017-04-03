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
        let cell: UITableViewCell
        switch messageType {
        case .system:
            cell = systemMessageCell(tableView: tableView, indexPath: indexPath)
        case .influencer:
            cell = influencerMessageCell(tableView: tableView, indexPath: indexPath)
        case .brand:
            cell = brandMessageCell(tableView: tableView, indexPath: indexPath)
        }
        if let renderingCapableCell = cell as? MessageCellRendering {
            prepare(cell: renderingCapableCell, messageItem: messageItem)
        }
        if let imageFetchingCapableCell = cell as? ImageFetcherUsing {
            setImageFetchersIn(cell: imageFetchingCapableCell, messageItem: messageItem)
        }
        return cell
    }

    private func prepare(cell: MessageCellRendering, messageItem: MessageContainer) {
        let renderable = MessageCellRenderable(text: messageItem.message.text)
        cell.render(renderable)
    }

    private func setImageFetchersIn(cell: ImageFetcherUsing, messageItem: MessageContainer) {
        guard let avatarUrl = messageItem.sender.avatar else { return }
        cell.set(imageFetcher: ImageFetcher(url: avatarUrl))
    }

    private func brandMessageCell(tableView: UITableView, indexPath: IndexPath) -> BrandMessageCell {
        return tableView.dequeueCell(at: indexPath)
    }

    private func influencerMessageCell(tableView: UITableView, indexPath: IndexPath) -> InfluencerMessageCell {
        return tableView.dequeueCell(at: indexPath)
    }

    private func systemMessageCell(tableView: UITableView, indexPath: IndexPath) -> SystemMessageCell {
        return tableView.dequeueCell(at: indexPath)
    }
}
