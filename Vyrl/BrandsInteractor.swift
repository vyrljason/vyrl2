//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

fileprivate struct Constants {
    static let baseCellHeight: CGFloat  = 44.0
}

protocol BrandsInteracting: CollectionViewHaving, CollectionViewControlling, CollectionViewUsing {
    weak var dataUpdateListener: DataLoadingEventsListening? { get set }
}

final class BrandsInteractor: BrandsInteracting {

    fileprivate let dataSource: CollectionViewNibRegistering & CollectionViewDataProviding
    weak var collectionView: UICollectionView?
    weak var dataUpdateListener: DataLoadingEventsListening?

    init(dataSource: CollectionViewNibRegistering & CollectionViewDataProviding) {
        self.dataSource = dataSource
        dataSource.delegate = self
    }

    func loadData() {
        dataUpdateListener?.willStartDataLoading()
        dataSource.loadData()
    }

    func reloadData() {
        collectionView?.reloadData()
        dataUpdateListener?.didFinishDataLoading()
    }
}

extension BrandsInteractor: CollectionViewUsing {
    func use(_ collectionView: UICollectionView) {
        self.collectionView = collectionView
        self.collectionView?.dataSource = dataSource
        self.collectionView?.delegate = dataSource

        dataSource.registerNibs()
    }

    func stopUsingCollectionView() {
        collectionView = nil
    }
}

extension BrandsInteractor: CollectionViewRefreshing {
    func refresh() {
        reloadData()
    }
}
