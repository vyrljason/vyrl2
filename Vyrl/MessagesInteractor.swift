//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

private enum Constants {
    static let failedToSentMessage = NSLocalizedString("messages.error.failedToSend", comment: "")
    static let failedToConfirmDelivery = NSLocalizedString("messages.error.failedToConfirmDelivery", comment: "")
    static let failedToSentInstagramLink = NSLocalizedString("messages.error.failedToSendInstagramLink", comment: "")
}

protocol MessagesInteracting: TableViewUsing {
    weak var errorPresenter: ErrorAlertPresenting? { get set }
    weak var messageDisplayer: MessageDisplaying? { get set }
    weak var composePresenter: ComposePresenting? { get set }
    weak var viewController: MessagesControlling? { get set }
    weak var sendStatusPresenter: PresentingSendStatus? { get set }
    func viewWillAppear()
    func viewWillDisappear()
    func didTapMore()
    func didTapSend(message: String, addMessageStatus: AddMessageStatus)
}

final class MessagesInteractor: MessagesInteracting {
    fileprivate let dataSource: MessagesDataProviding
    weak var viewController: MessagesControlling?
    weak var errorPresenter: ErrorAlertPresenting?
    weak var messageDisplayer: MessageDisplaying?
    weak var composePresenter: ComposePresenting?
    weak var sendStatusPresenter: PresentingSendStatus?

    fileprivate let collab: Collab
    fileprivate let messageSender: TextMessageSending
    fileprivate let deliveryService: ConfirmingDelivery
    fileprivate let influencerPostUpdater: UpdatePostWithInstagram
    fileprivate let influencerPostsService: InfluencerPostsProviding

    init(dataSource: MessagesDataProviding,
         collab: Collab,
         messageSender: TextMessageSending,
         deliveryService: ConfirmingDelivery,
         influencerPostUpdater: UpdatePostWithInstagram,
         influencerPostsService: InfluencerPostsProviding) {
        self.dataSource = dataSource
        self.collab = collab
        self.messageSender = messageSender
        self.deliveryService = deliveryService
        self.influencerPostUpdater = influencerPostUpdater
        self.influencerPostsService = influencerPostsService
        dataSource.actionTarget = self
    }

    func viewWillAppear() {
        viewController?.setUpStatusView(withStatus: CollabStatus(orderStatus: collab.chatRoom.orderStatus, contentStatus: collab.chatRoom.contentStatus))
        dataSource.subscribeToChatUpdates()
    }

    func viewWillDisappear() {
        dataSource.unsubscribeToChatUpdates()
    }

    func didTapMore() {
        //TODO: Add reporting functionality. No story on Taiga yet ;-)
    }

    func didTapSend(message: String, addMessageStatus: AddMessageStatus) {
        let trimmedMessage = message.trimmed
        guard trimmedMessage.characters.count > 0 else { return }
        sendStatusPresenter?.showSendingStatus()
        switch addMessageStatus {
        case .normal:
            sendNormalMessage(message: trimmedMessage)
        case .instagramLink:
            sendInstagramLinkMessage(instagramUrl: trimmedMessage)
        }
    }
    
    fileprivate func sendNormalMessage(message: String) {
        let message = Message(text: message)
        messageSender.send(message: message,
                           toRoom: collab.chatRoomId) { [weak self] result in
                            self?.sendStatusPresenter?.hideSendingStatus()
                            result.on(success: { _ in
                                guard let `self` = self else { return }
                                self.messageDisplayer?.clearMessage()
                            }, failure: { _ in
                                guard let `self` = self else { return }
                                self.errorPresenter?.presentError(title: nil, message: Constants.failedToSentMessage)
                            })
        }
    }
    
    fileprivate func sendInstagramLinkMessage(instagramUrl: String) {
        influencerPostsService.influencerPosts(fromBrand: collab.chatRoom.brandId) { result in
            result.on(success: { [weak self] influencerPosts in
                guard let `self` = self else { return }
                guard let currentPost = influencerPosts.posts.first else { return }
                self.influencerPostUpdater.update(postId: currentPost.id, withInstagram: instagramUrl) { [weak self] _ in
                    guard let `self` = self else { return }
                    self.sendStatusPresenter?.hideSendingStatus()
                    self.messageDisplayer?.clearMessage()
                    self.viewController?.setUpAddMessageView(withStatus: .normal)
                }
                }, failure: { _ in
                    self.sendStatusPresenter?.hideSendingStatus()
                    self.errorPresenter?.presentError(title: nil, message: Constants.failedToConfirmDelivery)
            })
        }
    }
}

extension MessagesInteractor: TableViewUsing {
    func use(_ tableView: UITableView) {
        dataSource.use(tableView)
        dataSource.reloadingDelegate = tableView
    }
}

extension MessagesInteractor: DeliveryConfirming {
    func didTapConfirm() {
        deliveryService.confirmDelivery(forBrand: collab.chatRoom.brandId) { [weak self] result in
            guard let `self` = self else { return }
            result.on(success: nil,
                      failure: { _ in
                self.errorPresenter?.presentError(title: nil, message: Constants.failedToConfirmDelivery)
            })
        }
    }
}

extension MessagesInteractor: ContentAdding {
    func didTapAddContent() {
        composePresenter?.presentCompose(for: collab, animated: true)
    }
}

extension MessagesInteractor: InstagramLinkAdding {
    func didTapAddLink() {
        viewController?.setUpAddMessageView(withStatus: .instagramLink)
        viewController?.showKeyboard()
    }
}
