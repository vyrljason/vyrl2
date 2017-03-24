//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

final class MessagesViewController: UIViewController, HavingNib {
    static var nibName: String = "MessagesViewController"

    @IBOutlet fileprivate weak var tableView: UITableView!
    @IBOutlet fileprivate weak var messageTextView: AutoexpandableTextView!
    @IBOutlet fileprivate weak var addMessageView: UIView!
    @IBOutlet fileprivate weak var statusView: StatusView!
    
    fileprivate var interactor: MessagesInteracting & DataRefreshing
    fileprivate let refreshControl = UIRefreshControl()
    
    init(interactor: MessagesInteracting & DataRefreshing) {
        self.interactor = interactor
        super.init(nibName: MessagesViewController.nibName, bundle: nil)
        self.interactor.use(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupBarButton() {
        let moreButton = BadgeBarButtonItem(image: #imageLiteral(resourceName: "moreHoriz"), style: .plain) { [weak self] in
            self?.interactor.didTapMore()
        }
        navigationItem.rightBarButtonItem = moreButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpRefresh()
        setupBarButton()
        interactor.use(tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        interactor.viewWillAppear()
    }
    
    func setUpStatusView(withStatus status: CollabStatus) {
        let renderable = StatusViewRenderable(status: status)
        statusView.render(renderable: renderable)
    }
    
}

extension MessagesViewController {
    fileprivate func setUpRefresh() {
        refreshControl.tintColor = UIColor.rouge
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
