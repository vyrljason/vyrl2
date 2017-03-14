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

struct CartData {
    let products: [Product]
    let cartItems: [CartItem]
}

protocol CartDataProviding: TableViewUsing, UITableViewDelegate, UITableViewDataSource {
    weak var emptyTableDelegate: EmptyTableViewHandling? { get set }
    weak var reloadingDelegate: ReloadingData? { get set }
    weak var summaryDelegate: SummaryUpdateHandling? { get set }
    weak var guidelinesDelegate: GuidelinesPresenting? { get set }
    var cartData: CartData { get }
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
    fileprivate let service: ProductsWithIdsProviding
    fileprivate var products: [Product] = []
    fileprivate var items: [CartItem] = []

    init(cartStorage: CartStoring, service: ProductsWithIdsProviding) {
        self.cartStorage = cartStorage
        self.service = service
    }

    var cartData: CartData {
        return CartData(products: products, cartItems: cartStorage.items)
    }

    func loadData() {
        items = cartStorage.items
        guard !items.isEmpty else {
            self.update(with: [])
            return
        }

        let productsIds: [String] = items.map({ $0.productId })

        service.getProducts(with: productsIds) { [weak self] result in
            guard let `self` = self else { return }

            let products = result.map(success: { return $0 }, failure: { _ in return [] })
            self.update(with: products)
        }
    }

    fileprivate func update(with products: [Product]) {
        self.products = products
        self.items = self.items.map { (item) in
            var modifiedItem = item
            modifiedItem.product = products.filter({ $0.id == item.productId }).first
            return modifiedItem
        }
        reloadingDelegate?.reloadData()
        summaryDelegate?.didUpdate(summary: CartSummary(products: products))
        if products.isEmpty {
            emptyTableDelegate?.configure(with: .noData)
        }
    }

    fileprivate func removeItem(at index: Int) {
        let item = items[index]
        cartStorage.remove(item: item)
        items.remove(at: index)
        products.remove(at: index)
        summaryDelegate?.didUpdate(summary: CartSummary(products: products))
        if items.isEmpty {
            emptyTableDelegate?.configure(with: .noData)
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
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CartItemCell = tableView.dequeueCell(at: indexPath)
        prepare(cell: cell, cartItem: items[indexPath.row])
        return cell
    }

    fileprivate func prepare(cell: CartItemCell, cartItem: CartItem) {
        guard let renderable = CartItemCellRenderable(cartItem: cartItem) else { return }
        cell.render(renderable)
        guard let imageURL = cartItem.product?.images.first?.url else { return }
        cell.set(imageFetcher: ImageFetcher(url: imageURL))
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let product = items[indexPath.row].product else { return }
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
