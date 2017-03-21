//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol CollabSelecting: class {
    func didSelect(collab: Collab)
}

protocol CollabsInteracting: CollectionViewUsing, CollabSelecting, CollectionUpateListening {
    weak var dataUpdateListener: DataLoadingEventsListening? { get set }
    weak var messagesPresenter: MessagesPresenting? { get set }
    func viewWillAppear()
}

final class CollabsInteractor: CollabsInteracting {

    fileprivate let dataSource: CollabsDataProviding
    fileprivate let emptyCollectionHandler: EmptyCollectionViewHandling
    weak var dataUpdateListener: DataLoadingEventsListening?
    weak var messagesPresenter: MessagesPresenting?

    init(dataSource: CollabsDataProviding,
         emptyCollectionHandler: EmptyCollectionViewHandling) {
        self.dataSource = dataSource
        self.emptyCollectionHandler = emptyCollectionHandler
        dataSource.emptyCollectionHandler = emptyCollectionHandler
    }

    func viewWillAppear() {
        loadData()
    }

    func loadData() {
        dataUpdateListener?.willStartDataLoading()
        dataSource.loadData()
    }
}

extension CollabsInteractor {
    func didUpdateCollection() {
        dataUpdateListener?.didFinishDataLoading()
    }
}

extension CollabsInteractor {
    func didSelect(collab: Collab) {
        messagesPresenter?.presentMessages(for: collab, animated: true)
    }
}

extension CollabsInteractor: DataRefreshing {
    func refreshData() {
        loadData()
    }
}

extension CollabsInteractor: CollectionViewUsing {
    func use(_ collectionView: UICollectionView) {
        emptyCollectionHandler.use(collectionView)
        dataSource.use(collectionView)
        dataSource.reloadingDelegate = collectionView
    }
}
