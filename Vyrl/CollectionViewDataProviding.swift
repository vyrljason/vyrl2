//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol CollectionViewDataProviding: class, UICollectionViewDataSource, UICollectionViewDelegate {
    weak var collectionViewControllingDelegate: CollectionViewHaving & CollectionViewControlling? { get set }
    func loadData()
}

protocol CollectionViewNibRegistering {
    func registerNibs(in collectionView: UICollectionView)
}
