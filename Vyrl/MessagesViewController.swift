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
    
    fileprivate let interactor: MessagesInteracting
    fileprivate var currentAddMessageStatus: AddMessageStatus = .normal
    
    init(interactor: MessagesInteracting & DataRefreshing) {
        self.interactor = interactor
        super.init(nibName: MessagesViewController.nibName, bundle: nil)
        interactor.viewController = self
        interactor.errorPresenter = self
        interactor.messageDisplayer = self
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
        interactor.use(tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor.viewWillAppear()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        interactor.viewWillDisappear()
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
