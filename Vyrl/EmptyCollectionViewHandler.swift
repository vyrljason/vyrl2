//
//  Copyright © 2017 Vyrl. All rights reserved.
//

import Foundation
import DZNEmptyDataSet

enum EmptyCollectionMode {
    case noData
    case error
}

protocol EmptyCollectionViewHandling: CollectionViewUsing {
    func configure(with mode: EmptyCollectionMode)
}

struct EmptyCollectionRenderable {
    let title: NSAttributedString
    let description: NSAttributedString
}

final class EmptyCollectionViewHandler: NSObject, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, EmptyCollectionViewHandling {
    private weak var collectionView: UICollectionView?
    private var renderable: EmptyCollectionRenderable?
    private let modeToRenderable: [EmptyCollectionMode: EmptyCollectionRenderable]

    init(modeToRenderable: [EmptyCollectionMode: EmptyCollectionRenderable]) {
        self.modeToRenderable = modeToRenderable
    }

    func use(_ collectionView: UICollectionView) {
        self.collectionView = collectionView
        self.collectionView?.emptyDataSetSource = self
        self.collectionView?.emptyDataSetDelegate = self
    }

    func configure(with mode: EmptyCollectionMode) {
        renderable = modeToRenderable[mode]
        collectionView?.reloadEmptyDataSet()
    }

    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return renderable?.title
    }

    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return renderable?.description
    }

    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return renderable != nil
    }

    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}
