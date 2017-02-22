//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol BrandStoreInteracting: CollectionViewHaving, CollectionViewUsing {
    
}

final class BrandStoreInteractor: BrandStoreInteracting {
    
    fileprivate let dataSource: CollectionViewNibRegistering // & CollectionViewDataProviding
    weak var collectionView: UICollectionView?
    
    init(dataSource: CollectionViewNibRegistering /* & CollectionViewDataProviding */) {
        self.dataSource = dataSource
    }
}

extension BrandStoreInteractor: CollectionViewUsing {
    func use(_ collectionView: UICollectionView) {
        self.collectionView = collectionView
        self.dataSource.registerNibs()
    }
}
