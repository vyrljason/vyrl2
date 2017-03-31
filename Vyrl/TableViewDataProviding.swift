//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol TableViewDataProviding: class, UITableViewDataSource, UITableViewDelegate {
    func updateTable(with result: DataFetchResult)
    func loadTableData()
}

protocol NibRegisteringInTableView {
    func registerNibs(in tableView: UITableView)
}
