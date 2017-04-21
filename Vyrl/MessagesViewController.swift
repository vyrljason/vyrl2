//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit
import Alamofire

protocol MessageDisplaying: class {
    func clearMessage()
}

protocol MessagesControlling: class {
    func setUpStatusView(withStatus status: CollabStatus)
    func setUpAddMessageView(withStatus status: AddMessageStatus)
    func showKeyboard()
}

@objc protocol PresentingSendStatus: class {
    func showSendingStatus()
    func hideSendingStatus()
}

enum AddMessageStatus {
    case normal
    case instagramLink
    
    var backgroundColor: UIColor {
        switch self {
        case .instagramLink:
            return .rouge
        case .normal:
            return .white
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .instagramLink:
            return .white
        case .normal:
            return .black
        }
    }
    
    var placeholderText: String {
        switch self {
        case .instagramLink:
            return NSLocalizedString("messages.messageTextView.instagramPlaceholder", comment: "")
        default:
            return NSLocalizedString("messages.messageTextView.normalPlaceholder", comment: "")
        }
    }
}

final class MessagesViewController: UIViewController, HavingNib {
    static var nibName: String = "MessagesViewController"

    @IBOutlet fileprivate weak var tableView: UITableView!
    @IBOutlet weak var messageTextView: AutoexpandableTextView!
    @IBOutlet fileprivate weak var addMessageView: UIView!
    @IBOutlet fileprivate weak var statusView: StatusView!
    @IBOutlet fileprivate weak var sendButton: UIButton!
    
    fileprivate let interactor: MessagesInteracting
    fileprivate var activityPresenter: PresentingActivity!
    fileprivate var currentAddMessageStatus: AddMessageStatus = .normal
    
    init(interactor: MessagesInteracting) {
        self.interactor = interactor
        super.init(nibName: MessagesViewController.nibName, bundle: nil)
        interactor.viewController = self
        interactor.errorPresenter = self
        interactor.messageDisplayer = self
        interactor.sendStatusPresenter = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpNavigationBar() {
        renderNoTitleBackButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        setUp(activityPresenter: ServiceLocator.activityPresenter)
        interactor.use(tableView)
        interactor.viewDidLoad()
    }
}

extension MessagesViewController: MessageDisplaying {
    func clearMessage() {
        messageTextView.text = nil
    }
}

extension MessagesViewController {
    @IBAction private func didTapSend() {
        interactor.didTapSend(message: messageTextView.text, addMessageStatus: currentAddMessageStatus)
    }
    
    fileprivate func setUp(activityPresenter: PresentingActivity) {
        self.activityPresenter = activityPresenter
    }
}

extension MessagesViewController: MessagesControlling {
    func setUpStatusView(withStatus status: CollabStatus) {
        let renderable = StatusViewRenderable(status: status)
        statusView.render(renderable: renderable)
    }
    
    func setUpAddMessageView(withStatus status: AddMessageStatus) {
        currentAddMessageStatus = status
        addMessageView.backgroundColor = status.backgroundColor
        messageTextView.placeholderText = status.placeholderText
        messageTextView.textColor = status.textColor
    }
    
    func showKeyboard() {
        messageTextView.becomeFirstResponder()
    }
}

extension MessagesViewController: PresentingSendStatus {
    func showSendingStatus() {
        sendButton.isEnabled = false
        activityPresenter.presentActivity(inView: view)
    }
    
    func hideSendingStatus() {
        sendButton.isEnabled = true
        activityPresenter.dismissActivity(inView: view)
    }
}
