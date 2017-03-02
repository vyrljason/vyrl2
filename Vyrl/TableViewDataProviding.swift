//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol TableViewDataProviding: class, UITableViewDataSource, UITableViewDelegate {
    weak var tableViewControllingDelegate: TableViewControlling? { get set }
    func loadTableData()
}

protocol NibRegisteringInTableView {
    func registerNibs(in tableView: UITableView)
}
