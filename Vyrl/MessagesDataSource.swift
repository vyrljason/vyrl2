//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol MessagesDataAccessing: class {
    weak var interactor: MessagesInteracting? { get set }
}

protocol MessagesDataProviding: TableViewUsing, TableViewDataProviding, MessagesDataAccessing {
    weak var reloadingDelegate: ReloadingData? { get set }
}

final class MessagesDataSource: NSObject, MessagesDataProviding {
    weak var reloadingDelegate: ReloadingData?
    weak var tableViewControllingDelegate: TableViewControlling?
    weak var interactor: MessagesInteracting?
    
}

extension MessagesDataSource: TableViewUsing {
    func use(_ tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension MessagesDataSource: TableViewDataProviding {
    func loadTableData() {
        // Currently fetching is not needed
        DispatchQueue.onMainThread { [weak self] in
            guard let `self` = self else { return }
            self.tableViewControllingDelegate?.updateTable(with: .empty)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
