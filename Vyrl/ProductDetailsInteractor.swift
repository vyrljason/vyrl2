//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol ProductDetailsInteracting: TableViewHaving, TableViewUsing, TableViewControlling {
    
}

final class ProductDetailsInteractor: ProductDetailsInteracting {
    weak var tableView: UITableView?
    var dataSource: ProductDetailsDataProviding
    
    init(dataSource: ProductDetailsDataProviding) {
        self.dataSource = dataSource
        dataSource.tableViewControllingDelegate = self
    }
}

extension ProductDetailsInteractor: TableViewUsing {
    func use(_ tableView: UITableView) {
        self.tableView = tableView
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
        dataSource.registerNibs(in: tableView)
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
