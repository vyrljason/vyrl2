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

    fileprivate let cartStorage: CartStoraging

    init(cartStorage: CartStoraging) {
        self.cartStorage = cartStorage
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
