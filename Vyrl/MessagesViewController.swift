//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

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
    fileprivate let refreshControl = UIRefreshControl()
    
    init(interactor: MessagesInteracting & DataRefreshing) {
        self.interactor = interactor
        super.init(nibName: MessagesViewController.nibName, bundle: nil)
        interactor.viewController = self
        interactor.presenter = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpNavigationBar() {
        let moreButton = ClosureBarButtonItem.barButtonItem(image: #imageLiteral(resourceName: "moreHoriz")) { [weak self] in
            self?.interactor.didTapMore()
        }
        navigationItem.rightBarButtonItem = nil
        renderNoTitleBackButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpRefresh()
        setUpNavigationBar()
        interactor.use(tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor.viewWillAppear()
    }
}

extension MessagesViewController {
    fileprivate func setUpRefresh() {
        refreshControl.tintColor = .rouge
        refreshControl.addTarget(interactor, action: #selector(DataRefreshing.refreshData), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
}

extension MessagesViewController: DataLoadingEventsListening {
    func willStartDataLoading() {
        refreshControl.beginRefreshing()
    }
    
    func didFinishDataLoading() {
        refreshControl.endRefreshing()
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
