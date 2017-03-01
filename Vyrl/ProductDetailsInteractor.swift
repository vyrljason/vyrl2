//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol ProductDetailsInteracting: TableViewUsing, TableViewControlling {
    
}

final class ProductDetailsInteractor: ProductDetailsInteracting {
    weak var tableView: UITableView?
}

extension ProductDetailsInteractor: TableViewUsing {
    func use(_ tableView: UITableView) {
        self.tableView = tableView
        // use datasource
    }
}

extension ProductDetailsInteractor: TableViewControlling {
    func updateTable(with result: DataFetchResult) {
        tableView?.reloadData()
        //update table
    }
    
    func loadTableData() {
        // use datasource
    }
}
