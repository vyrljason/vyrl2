//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

fileprivate struct Constants {
    static let baseCellHeight: CGFloat  = 44.0
}

protocol BrandsInteracting: CollectionViewHaving, CollectionViewControlling, CollectionViewUsing {
    weak var presenter: UIViewController? { get set }
}

final class BrandsInteractor: BrandsInteracting {

    fileprivate let dataSource: CollectionViewNibRegistering & CollectionViewDataProviding
    weak var collectionView: UICollectionView?
    weak var presenter: UIViewController?

    init(dataSource: CollectionViewNibRegistering & CollectionViewDataProviding) {
        self.dataSource = dataSource
        dataSource.delegate = self
    }

    func loadData(refresh: Bool = false) {
        dataSource.loadData(refresh: refresh)
    }

    func reloadData() {
        collectionView?.reloadData()
    }
}

extension BrandsInteractor: CollectionViewUsing {
    func use(_ collectionView: UICollectionView) {
        self.collectionView = collectionView
        self.collectionView?.dataSource = dataSource
        self.collectionView?.delegate = dataSource
        dataSource.registerNibs()
    }
}
