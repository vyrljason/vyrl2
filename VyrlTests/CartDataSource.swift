//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol CartDataProviding: CollectionViewNibRegistering, UICollectionViewDelegate, UICollectionViewDataSource {
    weak var delegate: EmptyCollectionViewHandling? { get set }
    func loadData()
}

final class CartDataSource: NSObject, CartDataProviding {

    fileprivate enum Constants {
        static let cellHeight: CGFloat = 122
    }

    weak var delegate: EmptyCollectionViewHandling?

    fileprivate let cartStorage: CartStoring
    fileprivate let productProvider: ProductProviding
    fileprivate var products: [Product] = []

    init(cartStorage: CartStoring, productProvider: ProductProviding) {
        self.cartStorage = cartStorage
        self.productProvider = productProvider
    }

    func loadData() {
        guard !cartStorage.items.isEmpty else {
            delegate?.configure(with: .noData)
            return
        }

        let productsIds: [String] = cartStorage.items.map({ $0.id })

        productProvider.get(productsIds: productsIds) { [weak self] result in
            self?.products = result.map(success: { return $0 }, failure: { return [] })
        }
    }

    func registerNibs(in collectionView: UICollectionView) {
        CartItemCell.register(to: collectionView)
    }
}

extension CartDataSource: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cartStorage.items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CartItemCell = collectionView.dequeueCell(at: indexPath)
        let item: CartItem = cartStorage.items[indexPath.row]

        // THIS IS TEMPORARY
        // cell.render(product.cartItemRenderable)


        return cell
    }
}

extension CartDataSource: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: Constants.cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
}
