//
//  Copyright © 2017 Vyrl. All rights reserved.
//

@testable import Vyrl
import UIKit

final class CollectionInteractorMock: CollectionViewHaving, CollectionViewControlling {
    var collectionView: UICollectionView?
    var updateResult: DataFetchResult?
    var didLoadData = false

    func updateCollection(with result: DataFetchResult) {
        updateResult = result
    }

    func loadData() {
        didLoadData = true
    }
}
