//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol MessagesInteracting: TableViewUsing {
    weak var dataUpdateListener: DataLoadingEventsListening? { get set }
    func viewWillAppear()
    func didTapMore()
    func use(_ viewController: MessagesViewController)
}

final class MessagesInteractor: MessagesInteracting {
    fileprivate weak var tableView: UITableView?
    fileprivate weak var viewController: MessagesViewController?
    let dataSource: MessagesDataProviding
    weak var dataUpdateListener: DataLoadingEventsListening?
    private let collab: Collab
    
    init(dataSource: MessagesDataProviding, collab: Collab) {
        self.dataSource = dataSource
        self.collab = collab
        dataSource.interactor = self
    }
    
    func viewWillAppear() {
        //FIX ME: Waiting for api sync
        viewController?.setUpStatusView(withStatus: CollabStatus.publication)
    }
    
    func didTapMore() {
        //FIX ME: Waiting for api sync
        viewController?.setUpStatusView(withStatus: CollabStatus.waiting)
    }
    
    func use(_ viewController: MessagesViewController) {
        self.viewController = viewController
    }
}

extension MessagesInteractor: TableViewUsing {
    func use(_ tableView: UITableView) {
        self.tableView = tableView
        dataSource.use(tableView)
    }
}

extension MessagesInteractor: DataRefreshing {
    func refreshData() { }
}
