//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol ProductDetailsDataProviding: TableViewNibRegistering, TableViewDataProviding {
    
}

final class ProductDetailsDataSource: NSObject, ProductDetailsDataProviding {
    let product: Product
    weak var tableView: UITableView?
    weak var tableViewControllingDelegate: TableViewHaving & TableViewControlling?
    
    init(product: Product) {
        self.product = product
    }
}

extension ProductDetailsDataSource: TableViewNibRegistering {
    func registerNibs(in tableView: UITableView) {
        // something like: BrandStoreHeader.registerHeader(to: collectionView)
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
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
}
