//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

extension Product {
    var cartItemRenderable: CartItemCellRenderable {
        return CartItemCellRenderable(title: name, subTitle: "", price: asDollars(retailPrice))
    }

    private func asDollars(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.currencyCode = "USD"
        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .currencyAccounting
        return formatter.string(from: NSNumber(value: value)) ?? "$\(value)"
    }
}

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

    init(cartStorage: CartStoring, productProvider: ProductProviding) {
        self.cartStorage = cartStorage
        self.productProvider = productProvider
    }

    func loadData() {
        if cartStorage.items.isEmpty {
            delegate?.configure(with: .noData)
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
        productProvider.get(productId: item.id) { result in
            switch result {
            case .success(let product):
                cell.render(product.cartItemRenderable)
            default: ()
            }
        }

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
