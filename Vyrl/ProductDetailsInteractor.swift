//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

fileprivate struct Constants {
    static let estimatedRowHeight: CGFloat = 48.0
}

protocol ProductDetailsInteracting: TableViewUsing, TableViewControlling {
    var galleryDataSource: ProductDetailsGalleryDataProviding { get }
    func viewWillAppear(_ animated: Bool)
    func addToCart()
    func selectFromVariants(_ variants: ProductVariants, on textfield: UITextField)
}

final class ProductDetailsInteractor: ProductDetailsInteracting {
    fileprivate weak var tableView: UITableView?
    let dataSource: ProductDetailsDataProviding
    let galleryDataSource: ProductDetailsGalleryDataProviding
    var variantHandler: VariantHandling
    let product: Product
    let picker: PickerPresenting
    private let cartStorage: CartStoring
    
    init(dataSource: ProductDetailsDataProviding,
         variantHandler: VariantHandling,
         product: Product, cartStorage: CartStoring = ServiceLocator.cartStorage,
         galleryDataSource: ProductDetailsGalleryDataSource
         ) {
        self.product = product
        self.variantHandler = variantHandler
        self.dataSource = dataSource
        self.cartStorage = cartStorage
        self.picker = PickerPresenter()
        self.galleryDataSource = galleryDataSource
        dataSource.tableViewControllingDelegate = self
        dataSource.interactor = self
    }
    
    func viewWillAppear(_ animated: Bool) {
        loadTableData()
    }
    
    func addToCart() {
        let cartItem = CartItem(productId: product.id, addedAt: Date(), productVariants: variantHandler.selectedVariants)
        cartStorage.add(item: cartItem)
    }
    
    func selectFromVariants(_ variants: ProductVariants, on textfield: UITextField) {
        let selectedVariant = self.variantHandler.selectedVariant(for: variants.name)
        picker.showPicker(within: textfield, with: variants.values, defaultValue: selectedVariant) { [weak self] result in
            self?.variantHandler.pickedVariant(variantName: variants.name, variantValue: result)
            textfield.text = result
        }
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
