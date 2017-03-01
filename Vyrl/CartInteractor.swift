//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import UIKit

protocol CartInteracting: class, CollectionViewUsing {
    weak var projector: CartSummaryRendering? { get set }
    func viewDidAppear()
}

final class CartInteractor: CartInteracting {

    fileprivate let dataSource: CartDataProviding
    fileprivate let emptyCollectionHandler: EmptyCollectionViewHandling

    weak var projector: CartSummaryRendering?

    init(dataSource: CartDataProviding, emptyCollectionHandler: EmptyCollectionViewHandling) {
        self.dataSource = dataSource
        self.emptyCollectionHandler = emptyCollectionHandler
        dataSource.emptyCollectionDelegate = emptyCollectionHandler
        dataSource.summaryDelegate = self
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
        dataSource.reloadingDelegate = collectionView
    }
}

extension CartInteractor: SummaryUpdateHandling {
    func didUpdate(summary: CartSummary) {
        let renderable = CartSummaryRenderable(from: summary)
        projector?.render(renderable)
    }
}
