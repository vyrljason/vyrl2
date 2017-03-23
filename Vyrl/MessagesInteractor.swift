//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol MessagesInteracting: TableViewUsing {
    weak var dataUpdateListener: DataLoadingEventsListening? { get set }
    func viewWillAppear()
    func didTapMore()
}

final class MessagesInteractor: MessagesInteracting {
    fileprivate weak var tableView: UITableView?
    fileprivate let dataSource: MessagesDataProviding
    weak var dataUpdateListener: DataLoadingEventsListening?
    private let collab: Collab
    
    init(dataSource: MessagesDataProviding, collab: Collab) {
        self.dataSource = dataSource
        self.collab = collab
        dataSource.interactor = self
    }
    
    func viewWillAppear() { }
    
    func didTapMore() { }
    
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
