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
}

final class MessagesViewController: UIViewController, HavingNib {
    static var nibName: String = "MessagesViewController"

    @IBOutlet fileprivate weak var tableView: UITableView!
    @IBOutlet weak var messageTextView: AutoexpandableTextView!
    @IBOutlet fileprivate weak var addMessageView: UIView!
    @IBOutlet fileprivate weak var statusView: StatusView!
    
    fileprivate let interactor: MessagesInteracting & DataRefreshing
    
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
        interactor.didTapSend(message: messageTextView.text)
    }
}

extension MessagesViewController: MessagesControlling {
    func setUpStatusView(withStatus status: CollabStatus) {
        let renderable = StatusViewRenderable(status: status)
        statusView.render(renderable: renderable)
    }
}
