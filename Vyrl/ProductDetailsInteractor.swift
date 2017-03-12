//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

fileprivate struct Constants {
    static let estimatedRowHeight: CGFloat = 48.0
}

protocol ProductDetailsInteracting: TableViewUsing, TableViewControlling {
    var allVariantsArePicked: Bool { get }
    func viewWillAppear(_ animated: Bool)
    func addToCart()
    func selectFromVariants(_ variants: ProductVariants, on textfield: UITextField)
}

final class ProductDetailsInteractor: ProductDetailsInteracting {
    fileprivate weak var tableView: UITableView?
    private let product: Product
    fileprivate let dataSource: ProductDetailsDataProviding
    private var variantHandler: VariantHandling
    private let picker: PickerPresenting
    private let cartStorage: CartStoring
    
    var allVariantsArePicked: Bool {
        return variantHandler.allVariantsAreSelected
    }
    
    init(dataSource: ProductDetailsDataProviding,
         variantHandler: VariantHandling,
         product: Product, cartStorage: CartStoring = ServiceLocator.cartStorage) {
        self.product = product
        self.variantHandler = variantHandler
        self.dataSource = dataSource
        self.cartStorage = cartStorage
        self.picker = PickerPresenter()
        dataSource.tableViewControllingDelegate = self
        dataSource.interactor = self
    }
    
    func viewWillAppear(_ animated: Bool) {
        loadTableData()
    }
    
    func addToCart() {
        if allVariantsArePicked {
            let cartItem = CartItem(productId: product.id, addedAt: Date(), productVariants: variantHandler.selectedVariants)
            cartStorage.add(item: cartItem)
        } else {
            let firstVariant = IndexPath(row: 0, section: ProductDetailsSections.Variants.integerValue)
            tableView?.scrollToRow(at: firstVariant, at: UITableViewScrollPosition.top, animated: true)
        }
    }
    
    func selectFromVariants(_ variants: ProductVariants, on textfield: UITextField) {
        let selectedVariant: String? = self.variantHandler.selectedVariantValue(for: variants.name)
        picker.showPicker(within: textfield, with: variants.values, defaultValue: selectedVariant) { [weak self] result in
            self?.onVariantPick(variantName: variants.name, variantValue: result, textfield: textfield)
        }
    }
    
    private func onVariantPick(variantName: String, variantValue: String, textfield: UITextField) {
        variantHandler.pickedVariant(variantName: variantName, variantValue: variantValue)
        textfield.text = variantValue
        refreshCartButton()
    }
    
    private func refreshCartButton() {
        let addToCartSection = ProductDetailsSections.Cart.integerValue
        tableView?.reloadSections(IndexSet(integer: addToCartSection), with: UITableViewRowAnimation.none)
    }
}

extension ProductDetailsInteractor: TableViewUsing {
    func use(_ tableView: UITableView) {
        self.tableView = tableView
        setupCellSizing(tableView: tableView)
        dataSource.use(tableView)
    }
    
    private func setupCellSizing(tableView: UITableView) {
        tableView.estimatedRowHeight = Constants.estimatedRowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
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
