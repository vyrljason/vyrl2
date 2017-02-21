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
    fileprivate let emptyCollectionHandler: EmptyCollectionViewHandling
    weak var collectionView: UICollectionView?
    weak var dataUpdateListener: DataLoadingEventsListening?

    init(dataSource: CollectionViewNibRegistering & CollectionViewDataProviding,
         emptyCollectionHandler: EmptyCollectionViewHandling) {
        self.dataSource = dataSource
        self.emptyCollectionHandler = emptyCollectionHandler
        dataSource.delegate = self
    }

    func loadData() {
        dataUpdateListener?.willStartDataLoading()
        dataSource.loadData()
    }

    func updateCollection(with result: DataFetchResult) {
        switch result {
        case .error:
            emptyCollectionHandler.configure(with: .error)
        case .empty:
            emptyCollectionHandler.configure(with: .noData)
        default: ()
        }
        reloadData()
    }

    fileprivate func reloadData() {
        collectionView?.reloadData()
        dataUpdateListener?.didFinishDataLoading()
    }
}

extension BrandsInteractor: CollectionViewUsing {
    func use(_ collectionView: UICollectionView) {
        self.collectionView = collectionView
        self.collectionView?.dataSource = dataSource
        self.collectionView?.delegate = dataSource
        emptyCollectionHandler.use(collectionView)
        dataSource.registerNibs()
    }
}

extension BrandsInteractor: CollectionViewRefreshing {
    func refresh() {
        reloadData()
    }
}
