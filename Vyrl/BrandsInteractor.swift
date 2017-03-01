//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

fileprivate struct Constants {
    static let baseCellHeight: CGFloat  = 44.0
}

protocol BrandsInteracting: CollectionViewHaving, CollectionViewControlling, CollectionViewUsing, BrandSelecting {
    weak var dataUpdateListener: DataLoadingEventsListening? { get set }
    weak var brandStorePresenter: BrandStorePresenting? { get set }
}

protocol BrandSelecting: class {
    func didSelect(brand: Brand)
}

protocol BrandsFilteringByCategory: class {
    func filterBrands(by: Category)
}

final class BrandsInteractor: BrandsInteracting {

    fileprivate let dataSource: BrandsDataProviding & BrandsFilteredByCategoryProviding
    fileprivate let emptyCollectionHandler: EmptyCollectionViewHandling
    weak var collectionView: UICollectionView?
    weak var dataUpdateListener: DataLoadingEventsListening?
    weak var brandStorePresenter: BrandStorePresenting?

    init(dataSource: BrandsDataProviding & BrandsFilteredByCategoryProviding,
         emptyCollectionHandler: EmptyCollectionViewHandling) {
        self.dataSource = dataSource
        self.emptyCollectionHandler = emptyCollectionHandler
        dataSource.collectionViewControllingDelegate = self
        dataSource.selectionDelegate = self
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

    func didSelect(brand: Brand) {
        brandStorePresenter?.presentStore(for: brand, animated: true)
    }

    fileprivate func reloadData() {
        collectionView?.reloadData()
        dataUpdateListener?.didFinishDataLoading()
    }
}

extension BrandsInteractor: BrandsFilteringByCategory {
    func filterBrands(by category: Category) {
        dataSource.loadData(filteredBy: category)
    }
}

extension BrandsInteractor: CollectionViewUsing {
    func use(_ collectionView: UICollectionView) {
        self.collectionView = collectionView
        self.collectionView?.dataSource = dataSource
        self.collectionView?.delegate = dataSource
        emptyCollectionHandler.use(collectionView)
        dataSource.registerNibs(in: collectionView)
    }
}

extension BrandsInteractor: CollectionViewRefreshing {
    func refresh() {
        reloadData()
    }
}
