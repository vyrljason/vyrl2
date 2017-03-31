//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit
import Alamofire

protocol MessageDisplaying: class {
    func clearMessage()
}

final class MessagesViewController: UIViewController, HavingNib {
    static var nibName: String = "MessagesViewController"

    @IBOutlet fileprivate weak var tableView: UITableView!
    @IBOutlet weak var messageTextView: AutoexpandableTextView!
    @IBOutlet private weak var addMessageView: UIView!
    @IBOutlet private weak var statusView: StatusView!
    
    fileprivate let interactor: MessagesInteracting & DataRefreshing
    fileprivate let refreshControl = UIRefreshControl()
    
    init(interactor: MessagesInteracting & DataRefreshing) {
        self.interactor = interactor
        super.init(nibName: MessagesViewController.nibName, bundle: nil)
        interactor.use(self)
        interactor.presenter = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupBarButton() {
        let moreButton = ClosureBarButtonItem.barButtonItem(image: #imageLiteral(resourceName: "moreHoriz")) { [weak self] in
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
        super.viewWillAppear(animated)
        interactor.viewWillAppear()

        let resource = ServiceLocator.resourceConfigurator.resourceController
        let imageResource = ImageUploadResource(controller: resource)
        let imageConverter = ImageToDataConverter()
        let postService = ImageUploadService(resource: imageResource, imageConverter: imageConverter)
        let image = #imageLiteral(resourceName: "test")
        postService.upload(image: image) { (result) in
            print(result)
        }
    }

    func setUpStatusView(withStatus status: CollabStatus) {
        let renderable = StatusViewRenderable(status: status)
        statusView.render(renderable: renderable)
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
