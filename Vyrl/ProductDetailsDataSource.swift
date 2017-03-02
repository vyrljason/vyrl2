//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol ProductDetailsDataProviding: TableViewUsing, TableViewDataProviding { }

final class ProductDetailsDataSource: NSObject, ProductDetailsDataProviding {
    fileprivate let product: Product
    weak var tableViewControllingDelegate: TableViewControlling?
    
    init(product: Product) {
        self.product = product
    }
}

extension ProductDetailsDataSource: TableViewUsing {
    func use(_ tableView: UITableView) {
        registerNibs(in: tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension ProductDetailsDataSource: NibRegisteringInTableView {
    func registerNibs(in tableView: UITableView) {
        CenteredWithDetailTableCell.register(to: tableView)
    }
}

extension ProductDetailsDataSource: TableViewDataProviding {
    
    func loadTableData() {
         // Currently fetching is not needed
        DispatchQueue.onMainThread { [weak self] in
            guard let `self` = self else { return }
            self.tableViewControllingDelegate?.updateTable(with: .empty)
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CenteredWithDetailTableCell = tableView.dequeueCell(at: indexPath)
        prepare(cell: cell, for: self.product)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    fileprivate func prepare(cell: CenteredWithDetailTableCell, for product: Product) {
        let renderable = NamePriceTableCellRenderable(product: product)
        cell.render(renderable)
    }
}
