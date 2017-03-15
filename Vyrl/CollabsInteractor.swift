//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol CollabsInteracting: class, TableViewUsing {
    func viewWillAppear()
}

final class CollabsInteractor: CollabsInteracting {
    
    fileprivate let emptyTableHandler: EmptyTableViewHandler
    fileprivate weak var tableView: UITableView?
    
    init(emptyTableHandler: EmptyTableViewHandler) {
        self.emptyTableHandler = emptyTableHandler
    }
    
    func viewWillAppear() {
        emptyTableHandler.configure(with: .noData)
        tableView?.reloadEmptyDataSet()
    }
}

extension CollabsInteractor: TableViewUsing {
    func use(_ tableView: UITableView) {
        self.tableView = tableView
        emptyTableHandler.use(tableView)
    }
}
