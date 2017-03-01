//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol BrandStoreInteracting: CollectionViewHaving, CollectionViewUsing, CollectionViewControlling, ProductSelecting {
    weak var productDetailsPresenter: ProductDetailsPresenting? { get set }
}

protocol ProductSelecting: class {
    func didSelect(product: Product)
}

final class BrandStoreInteractor: BrandStoreInteracting {
    
    fileprivate let dataSource: BrandStoreDataProviding
    weak var collectionView: UICollectionView?
    weak var productDetailsPresenter: ProductDetailsPresenting?
    
    init(dataSource: BrandStoreDataProviding) {
        self.dataSource = dataSource
        self.dataSource.delegate = self
        self.dataSource.selectionDelegate = self
    }
}

extension BrandStoreInteractor: CollectionViewControlling {
    func updateCollection(with result: DataFetchResult) {
        collectionView?.reloadData()
    }
    
    func loadData() {
        dataSource.loadData()
    }
}

extension BrandStoreInteractor: CollectionViewUsing {
    func use(_ collectionView: UICollectionView) {
        self.collectionView = collectionView
        self.collectionView?.dataSource = dataSource
        self.collectionView?.delegate = dataSource
        dataSource.registerNibs(in: collectionView)
        dataSource.use(collectionView)
    }
}

extension BrandStoreInteractor: ProductSelecting {
    func didSelect(product: Product) {
        productDetailsPresenter?.presentProductDetails(for: product, animated: true)
    }
}
