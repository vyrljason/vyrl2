//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol CollectionViewManaging: CollectionViewDataProviding, CollectionViewDataLoading, CollectionViewControllerProviding { }

protocol CollectionViewDataProviding: class, UICollectionViewDataSource, UICollectionViewDelegate {}

protocol CollectionViewDataLoading {
    func loadData()
}

protocol CollectionViewControllerProviding {
    weak var collectionViewControllingDelegate: (CollectionViewHaving & CollectionViewControlling)? { get set }
}

protocol CollectionViewNibRegistering {
    func registerNibs(in collectionView: UICollectionView)
}
