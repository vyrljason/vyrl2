//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol ProductDetailsInteracting: TableViewUsing, TableViewControlling {
    
}

final class ProductDetailsInteractor: ProductDetailsInteracting {
    
}

extension ProductDetailsInteractor: TableViewUsing {
    func use(_ tableView: UITableView) {
        // use datasource
    }
}

extension ProductDetailsInteractor: TableViewControlling {
    func updateTable(with result: DataFetchResult) {
        //update table
    }
    
    func loadTableData() {
        // use datasource
    }
}
