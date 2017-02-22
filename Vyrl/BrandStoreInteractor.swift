//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol BrandStoreInteracting: CollectionViewHaving, CollectionViewUsing, CollectionViewControlling {
    
}

final class BrandStoreInteractor: BrandStoreInteracting {
    
    fileprivate let dataSource: CollectionViewNibRegistering & CollectionViewDataProviding
    weak var collectionView: UICollectionView?
    
    init(dataSource: CollectionViewNibRegistering & CollectionViewDataProviding) {
        self.dataSource = dataSource
        self.dataSource.delegate = self
    }
    
    func updateCollection(with result: DataFetchResult) {
        reloadData()
    }
    
    func loadData() {
        self.dataSource.loadData()
    }
    
    fileprivate func reloadData() {
        collectionView?.reloadData()
    }
}

extension BrandStoreInteractor: CollectionViewUsing {
    func use(_ collectionView: UICollectionView) {
        self.collectionView = collectionView
        self.collectionView?.dataSource = self.dataSource
        self.collectionView?.delegate = self.dataSource
        self.dataSource.registerNibs()
    }
}
