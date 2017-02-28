//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol BrandStoreInteracting: CollectionViewHaving, CollectionViewUsing, CollectionViewControlling { }

final class BrandStoreInteractor: BrandStoreInteracting {
    
    fileprivate let dataSource: CollectionViewNibRegistering & CollectionViewDataProviding & CollectionViewUsing
    weak var collectionView: UICollectionView?
    
    init(dataSource: CollectionViewNibRegistering & CollectionViewDataProviding & CollectionViewUsing) {
        self.dataSource = dataSource
        self.dataSource.delegate = self
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
