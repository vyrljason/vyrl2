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
    let image: UIImage?
    
    init(title: NSAttributedString,
         description: NSAttributedString,
         image: UIImage?) {
        self.title = title
        self.description = description
        self.image = image
    }
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

protocol EmptyTableViewHandling: TableViewUsing {
    func configure(with mode: EmptyCollectionMode)
}

final class EmptyTableViewHandler: NSObject, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, EmptyTableViewHandling {
    private weak var tableView: UITableView?
    private var renderable: EmptyCollectionRenderable?
    private let modeToRenderable: [EmptyCollectionMode: EmptyCollectionRenderable]

    init(modeToRenderable: [EmptyCollectionMode: EmptyCollectionRenderable]) {
        self.modeToRenderable = modeToRenderable
    }

    func use(_ tableView: UITableView) {
        self.tableView = tableView
        self.tableView?.emptyDataSetSource = self
        self.tableView?.emptyDataSetDelegate = self
    }

    func configure(with mode: EmptyCollectionMode) {
        renderable = modeToRenderable[mode]
        tableView?.reloadEmptyDataSet()
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage? {
        return renderable?.image
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
