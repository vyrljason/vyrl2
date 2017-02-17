//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

fileprivate struct Constants {
    static let baseCellHeight: CGFloat  = 44.0
}

protocol BrandsInteracting: CollectionViewHaving, CollectionViewControlling {
    weak var presenter: UIViewController? { get set }
}

final class BrandsInteractor: BrandsInteracting {

    fileprivate let dataSource: LoadingDataForCollectionView
    weak var collectionView: UICollectionView? {
        didSet {
            collectionView?.dataSource = dataSource
            collectionView?.delegate = dataSource
            dataSource.registerNibs()
        }
    }
    weak var presenter: UIViewController?

    init(dataSource: LoadingDataForCollectionView) {
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
