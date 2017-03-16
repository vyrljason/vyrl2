//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol CollabSelecting: class {
    func didSelect(collab: Collab)
}

protocol CollabsInteracting: CollectionViewHaving, CollectionViewControlling, CollectionViewUsing, CollabSelecting {
    weak var dataUpdateListener: DataLoadingEventsListening? { get set }
    func viewWillAppear()
}

final class CollabsInteractor: CollabsInteracting {

    fileprivate let dataSource: CollabsDataProviding
    fileprivate let emptyCollectionHandler: EmptyCollectionViewHandling
    weak var collectionView: UICollectionView?
    weak var dataUpdateListener: DataLoadingEventsListening?

    init(dataSource: CollabsDataProviding,
         emptyCollectionHandler: EmptyCollectionViewHandling) {
        self.dataSource = dataSource
        self.emptyCollectionHandler = emptyCollectionHandler
    }

    func viewWillAppear() {
        loadData()
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

extension CollabsInteractor: CollabSelecting {
    func didSelect(collab: Collab) {
        //FIXME: As an Influencer I can tap on selected chat to enter it's details 
        //https://taiga.neoteric.eu/project/mpaprocki-vyrl-mobile/us/93
    }
}

extension CollabsInteractor: DataRefreshing {
    func refreshData() {
        loadData()
    }
}

extension CollabsInteractor: CollectionViewUsing {
    func use(_ collectionView: UICollectionView) {
        self.collectionView = collectionView
        self.collectionView?.dataSource = dataSource
        self.collectionView?.delegate = dataSource
        emptyCollectionHandler.use(collectionView)
        dataSource.registerNibs(in: collectionView)
    }
}
