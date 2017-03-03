//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

struct CartSummary {
    let productsCount: Int
    let brandsCount: Int
    let value: Double
}

protocol SummaryUpdateHandling: class {
    func didUpdate(summary: CartSummary)
}

protocol CartDataProviding: TableViewUsing, UITableViewDelegate, UITableViewDataSource {
    weak var emptyTableDelegate: EmptyTableViewHandling? { get set }
    weak var reloadingDelegate: ReloadingData? { get set }
    weak var summaryDelegate: SummaryUpdateHandling? { get set }
    weak var guidelinesDelegate: GuidelinesPresenting? { get set }
    func loadData()
}

extension CartSummary {
    init(products: [Product]) {
        value = products.reduce(0.0, { return $0 + $1.retailPrice })
        brandsCount = Set(products.map({ $0.brandId })).count
        productsCount = products.count
    }
}

final class CartDataSource: NSObject, CartDataProviding {

    fileprivate enum Constants {
        static let cellHeight: CGFloat = 120
        static let insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 44, right: 0)
    }

    weak var emptyTableDelegate: EmptyTableViewHandling?
    weak var reloadingDelegate: ReloadingData?
    weak var summaryDelegate: SummaryUpdateHandling?
    weak var guidelinesDelegate: GuidelinesPresenting?

    fileprivate let cartStorage: CartStoring
    fileprivate let productProvider: ProductProviding
    fileprivate var products: [Product] = []

    init(cartStorage: CartStoring, productProvider: ProductProviding) {
        self.cartStorage = cartStorage
        self.productProvider = productProvider
    }

    func loadData() {
        guard !cartStorage.items.isEmpty else {
            emptyTableDelegate?.configure(with: .noData)
            return
        }

        let productsIds: [String] = cartStorage.items.map({ $0.id })

        productProvider.get(productsIds: productsIds) { [weak self] result in
            let products = result.map(success: { return $0 }, failure: { _ in return [] })
            self?.products = products
            self?.reloadingDelegate?.reloadData()
            self?.summaryDelegate?.didUpdate(summary: CartSummary(products: products))
        }
    }

    fileprivate func removeItem(at index: Int) {
        let product = products[index]
        if let itemToRemove = cartStorage.items.filter({ $0.id == product.id }).first {
            cartStorage.remove(item: itemToRemove)
            products.remove(at: index)
            summaryDelegate?.didUpdate(summary: CartSummary(products: products))
            if cartStorage.items.isEmpty {
                emptyTableDelegate?.configure(with: .noData)
            }
        }
    }
}

extension CartDataSource: TableViewUsing {
    func use(_ tableView: UITableView) {
        tableView.dataSource = self
        tableView.delegate = self
        CartItemCell.register(to: tableView)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = Constants.cellHeight
        tableView.tableFooterView = UIView()
        tableView.contentInset = Constants.insets
    }
}

extension CartDataSource: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CartItemCell = tableView.dequeueCell(at: indexPath)
        let product = products[indexPath.row]

        cell.render(product.cartItemRenderable)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = products[indexPath.row]
        guidelinesDelegate?.showGuidelines(for: product)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            removeItem(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
}
