//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol CartInteracting: class, CollectionViewUsing {
    func viewDidAppear()
}

final class CartInteractor: CartInteracting {

    fileprivate let dataSource: CartDataProviding
    fileprivate let emptyCollectionHandler: EmptyCollectionViewHandling

    init(dataSource: CartDataProviding, emptyCollectionHandler: EmptyCollectionViewHandling) {
        self.dataSource = dataSource
        self.emptyCollectionHandler = emptyCollectionHandler
        dataSource.delegate = emptyCollectionHandler
    }

    func viewDidAppear() {
        dataSource.loadData()
    }
}

extension CartInteractor: CollectionViewUsing {
    func use(_ collectionView: UICollectionView) {
        collectionView.dataSource = dataSource
        collectionView.delegate = dataSource
        emptyCollectionHandler.use(collectionView)
        dataSource.registerNibs(in: collectionView)
    }
}
