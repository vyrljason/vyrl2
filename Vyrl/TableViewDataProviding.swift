//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol TableViewDataProviding: class, UITableViewDataSource, UITableViewDelegate {
    weak var tableViewControllingDelegate: TableViewHaving & TableViewControlling? { get set }
    func loadTableData()
}

protocol TableViewNibRegistering {
    func registerNibs(in tableView: UITableView)
}
