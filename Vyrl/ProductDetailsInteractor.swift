//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol ProductDetailsInteracting: TableViewUsing, TableViewControlling, VariantHandlerDelegate {
    func viewWillAppear(_ animated: Bool)
    func addToCart()
    func selectFromVariants(_ variants: ProductVariants)
}

final class ProductDetailsInteractor: ProductDetailsInteracting {
    fileprivate weak var tableView: UITableView?
    var dataSource: ProductDetailsDataProviding
    var variantHandler: VariantHandling
    let product: Product
    
    init(dataSource: ProductDetailsDataProviding, variantHandler: VariantHandling, product: Product) {
        self.product = product
        self.variantHandler = variantHandler
        self.dataSource = dataSource
        self.variantHandler.delegate = self
        dataSource.tableViewControllingDelegate = self
        dataSource.interactor = self
    }
    
    func viewWillAppear(_ animated: Bool) {
        loadTableData()
    }
    
    func addToCart() { }
    
    func selectFromVariants(_ variants: ProductVariants) {
        variantHandler.pickFromVariants(variants: variants)
    }
    
    func reloadVariants() {
        let variantsIndex: IndexSet = IndexSet(integer: ProductDetailsSections.Variants.rawValue)
        tableView?.reloadSections(variantsIndex, with: .none)
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
