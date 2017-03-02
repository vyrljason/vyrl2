//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol ProductDetailsInteracting: TableViewUsing, TableViewControlling {
    func viewWillAppear(_ animated: Bool)
}

final class ProductDetailsInteractor: ProductDetailsInteracting {
    fileprivate weak var tableView: UITableView?
    var dataSource: ProductDetailsDataProviding
    
    init(dataSource: ProductDetailsDataProviding) {
        self.dataSource = dataSource
        dataSource.tableViewControllingDelegate = self
    }
    
    func viewWillAppear(_ animated: Bool) {
        loadTableData()
    }
}

extension ProductDetailsInteractor: TableViewUsing {
    func use(_ tableView: UITableView) {
        self.tableView = tableView
        dataSource.use(tableView)
    }
}

extension ProductDetailsInteractor: TableViewControlling {
    func updateTable(with result: DataFetchResult) {
        tableView?.reloadData()
    }
    
    func loadTableData() {
        dataSource.loadTableData()
    }
}
